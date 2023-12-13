package net.danvi.dmall.biz.system.remote.homepage.service;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import net.danvi.dmall.biz.app.design.model.SkinPO;
import net.danvi.dmall.biz.app.member.manage.model.MemberManagePO;
import net.danvi.dmall.biz.app.setup.operationsupport.model.OperSupportConfigPO;
import net.danvi.dmall.biz.app.setup.securitymanage.model.SecurityManagePO;
import net.danvi.dmall.biz.system.service.SiteService;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.transaction.interceptor.TransactionAspectSupport;

import lombok.extern.slf4j.Slf4j;
import net.danvi.dmall.biz.app.design.service.SkinConfigService;
import net.danvi.dmall.biz.app.setup.operationsupport.service.OperationSupportConfigService;
import net.danvi.dmall.biz.common.service.CacheService;
import net.danvi.dmall.biz.system.model.SiteCacheVO;
import net.danvi.dmall.biz.system.service.SiteQuotaService;
import net.danvi.dmall.core.link.maru.model.MaruPO;
import net.danvi.dmall.core.link.maru.service.MaruService;
import net.danvi.dmall.core.remote.homepage.model.request.DomainPO;
import net.danvi.dmall.core.remote.homepage.model.request.HostingInfoPO;
import net.danvi.dmall.core.remote.homepage.model.request.ImageHostingPO;
import net.danvi.dmall.core.remote.homepage.model.request.PaymentInfoPO;
import net.danvi.dmall.core.remote.homepage.model.request.RemoteBaseModel;
import net.danvi.dmall.core.remote.homepage.model.request.SitePO;
import net.danvi.dmall.core.remote.homepage.model.request.SiteSO;
import net.danvi.dmall.core.remote.homepage.model.request.SiteServiceTermPO;
import net.danvi.dmall.core.remote.homepage.model.request.SiteStatusPO;
import net.danvi.dmall.core.remote.homepage.model.request.SkinPayInfoPO;
import net.danvi.dmall.core.remote.homepage.model.request.SmsSenderPO;
import net.danvi.dmall.core.remote.homepage.model.request.SslPO;
import net.danvi.dmall.core.remote.homepage.model.request.SuperAdminPO;
import net.danvi.dmall.core.remote.homepage.model.result.RemoteBaseResult;
import net.danvi.dmall.core.remote.homepage.model.result.SiteResult;
import net.danvi.dmall.core.remote.homepage.model.result.SiteStatusResult;
import net.danvi.dmall.core.remote.homepage.service.SiteRemoteService;
import dmall.framework.common.BaseService;
import dmall.framework.common.constants.CommonConstants;
import dmall.framework.common.constants.MapperConstants;

@Slf4j
@Service("siteRemoteService")
public class SiteRemoteServiceImpl extends BaseService implements SiteRemoteService {

    @Resource(name = "siteService")
    private SiteService siteService;

    @Resource(name = "skinConfigService")
    private SkinConfigService skinConfigService;

    @Resource(name = "maruService")
    private MaruService maruService;

    @Resource(name = "siteCreateService")
    private SiteCreateService siteCreateService;

    @Resource(name = "siteQuotaService")
    private SiteQuotaService siteQuotaService;

    @Resource(name = "operationSupportConfigService")
    OperationSupportConfigService operationSupportConfigService;

    @Resource(name = "cacheService")
    private CacheService cacheService;

    @Value("#{system['system.domain']}")
    private String domain;

    @Value("#{system['system.image.domain']}")
    private String imageDomain;

    @Value("#{system['system.id.not.allowed.prefix']}")
    private List<String> notAllowedPrefix;

    @Value("#{system['system.id.not.allowed.word']}")
    private List<String> notAllowedWord;



    @Override
    public SiteResult createSite(SitePO po) {
        log.debug("쇼핑몰 정보 생성");
        SiteResult result = new SiteResult();
        result.setSuccess(true);

        if(siteCreateService.isExistSiteId(po.getSiteId())) {
            result.setSuccess(false);
            result.setMessage("이미 존재하는 사이트 아이디입니다.");
            return result;
        }

        //TODO: 사이트 아이디 체크
        if(notAllowedWord.contains(po.getSiteId())) {
            result.setSuccess(false);
            result.setMessage(po.getSiteId() + "는 사용할수 없는 사이트 아이디입니다.");
            return result;
        }
        for(String prefix : notAllowedPrefix) {
            if(po.getSiteId().startsWith(prefix)) {
                result.setSuccess(false);
                result.setMessage(po.getSiteId() + "는 사용할수 없는 사이트 아이디입니다.");
                return result;
            }
        }

        // 마루 서비스 호출
        try {
            // 마루 작업 정보 등록
            log.debug("마루 작업 정보 등록 : {}", po);
            MaruPO maruPO = newMallByMaru(po);
            po.setIdx(maruPO.getIdx());
        } catch (Exception e) {
            result = new SiteResult();
            result.setSuccess(false);
            result.setMessage("쇼핑몰 서버 계정 생성시 오류가 발생했습니다.");

            log.debug("몰생성 요청 실패 : {}", po, e);
            return result;
        }

        try {
            log.debug("작업 테이블 등록 : {}", po);
            siteCreateService.createSiteSystemWork(po);
        } catch (Exception e) {
            log.debug("작업 정보 테이블 저장 실패 : {}", po, e);
        }

        // 몰생성 요청 결과 반환
        log.debug("몰생성 요청 결과 반환 : {}", result);
        return result;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public RemoteBaseResult setSiteStatus(SiteStatusPO po) {
        SiteResult result = new SiteResult();
        result.setSuccess(true);

        if ("03".equals(po.getSiteStatusCd())) {
            // TODO: 쇼핑몰 폐쇄시 진행중인 주문 상태 체크
        }

        try {
            int updateCnt = proxyDao.update(MapperConstants.SYSTEM_SITE + "updateSiteStatus", po);
            checkUpdateCount(po, result, updateCnt);

            if(!result.getSuccess()) {
                TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
                return result;
            }

        } catch (Exception e) {
            TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
            result.setSuccess(false);
            result.setMessage("쇼핑몰 상태 변경중 오류가 발생했습니다.");
            log.error("쇼핑몰 상태 변경중 오류 발생, {}, {}", po.getSiteNo(), po.getSiteStatusCd(), e);
            return result;
        }

        if ("03".equals(po.getSiteStatusCd())) {
            try {
                // 마루 작업 정보 등록
                deleteMallByMaru(po);
            } catch (Exception e) {
                TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
                result.setSuccess(false);
                result.setMessage("쇼핑몰 서버 상태 변경중 오류가 발생했습니다.");
                log.error("쇼핑몰 서버 상태 변경중 오류 발생, {}, {}", po.getSiteNo(), po.getSiteStatusCd(), e);
            }
        }

        // 사이트 정보 갱신
        cacheService.refreshSiteInfoCache(po.getSiteNo());

        return result;
    }

    @Override
    @Transactional(readOnly = true)
    public SiteStatusResult getSiteStatus(SiteSO so) {
        SiteStatusResult result = new SiteStatusResult();
        try {
            result = proxyDao.selectOne(MapperConstants.SYSTEM_SITE + "selectSiteStatus", so);
            result.setSuccess(true);
        } catch (Exception e) {
            result.setSuccess(false);
            result.setMessage("쇼핑몰 상태 조회중 오류가 발생했습니다.");
            log.error("쇼핑몰 상태 조회중 오류 발생, {}", so.getSiteNo(), e);
        }

        return result;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public RemoteBaseResult setSslInfo(SslPO po) {
        RemoteBaseResult result = new RemoteBaseResult();
        result.setSuccess(true);

        SecurityManagePO securityManagePO = new SecurityManagePO();
        securityManagePO.setSiteNo(po.getSiteNo());

        if ("1".equals(po.getSslStatusCd())) {
            securityManagePO.setApplyStartDt(po.getSslStartDt());
            securityManagePO.setApplyEndDt(po.getSslEndDt());
            securityManagePO.setDomain(po.getDomain());
            securityManagePO.setPort(po.getPort());
            securityManagePO.setSecurityServStatusCd("2");
        } else {
            securityManagePO.setSecurityServStatusCd("1");
        }
        securityManagePO.setUpdrNo(CommonConstants.MEMBER_INTERFACE_SYSTEM);

        try {
            int updateCnt = proxyDao.update(MapperConstants.SETUP_SECURITY_MANAGE + "updateSecurityConfigStatus",
                    securityManagePO);
            checkUpdateCount(po, result, updateCnt);
        } catch (Exception e) {
            TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
            result.setSuccess(false);
            result.setMessage("보안서버 신청정보 변경중 오류가 발생했습니다.");
            log.error("보안서버 신청정보 변경중 오류 발생, {}", po.getSiteNo(), e);
        }

        // 사이트 정보 갱신
        cacheService.refreshSiteInfoCache(po.getSiteNo());

        return result;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public RemoteBaseResult setSmsSenderCertInfo(SmsSenderPO po) {
        RemoteBaseResult result = new RemoteBaseResult();
        result.setSuccess(true);

        try {
            // 발신번호 인증정보 저장
            int updateCnt = proxyDao.update(MapperConstants.SYSTEM_SITE + "updateCertifySendNo", po);
            checkUpdateCount(po, result, updateCnt);
        } catch (Exception e) {
            TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
            result.setSuccess(false);
            result.setMessage("SMS 발신번호 인증 정보 설정중 오류가 발생했습니다.");
            log.error("SMS 발신번호 인증 정보 설정중 오류 발생, {}", po.getSiteNo(), e);
        }

        // 사이트 정보 갱신
        cacheService.refreshSiteInfoCache(po.getSiteNo());

        return result;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public RemoteBaseResult setPaymentInfo(PaymentInfoPO po) {
        RemoteBaseResult result = new RemoteBaseResult();
        result.setSuccess(true);
        if (po.getAmt() != null && po.getAmt().trim().length() > 0) {
            // TODO: 복호화
            // po.setAmt(CryptoUtil.decryptAES(po.getAmt()));
        }

        switch (po.getPayGbCd()) {
        case "1":
            // SMS
            break;
        case "2":
            // EMAIL
            break;
        case "3":
            // 관리자 계정
            result = addSiteQuotaAdmin(po, result);
            break;
        case "4":
            // 무통장계좌
            result = addSiteQuotaNopbAct(po, result);
            break;
        case "5":
            // 아이콘
            result = addSiteQuotaIcon(po, result);
            break;
        case "6":
            // 080 수신거부
            result = add080Reject(po, result);
            break;
        case "7":
            // 게시판
            result = addSiteQuotaBbs(po, result);
            break;
        case "8":
            // 소셜로그인 추가정보
            result = addSiteQuotaSocialLogin(po, result);
            break;
        default:
            result.setSuccess(false);
            result.setMessage("정의된 결제 구분 코드가 아닙니다.");
            log.error("정의된 결제 구분 코드 아님 [{}, {}]", po.getSiteNo(), po.getPayGbCd());
            break;
        }

        // 사이트 정보 갱신
        cacheService.refreshSiteInfoCache(po.getSiteNo());

        return result;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public RemoteBaseResult setSiteServiceTerm(SiteServiceTermPO po) {
        RemoteBaseResult result = new RemoteBaseResult();
        result.setSuccess(true);

        try {
            int updateCnt = proxyDao.update(MapperConstants.SYSTEM_SITE + "updateSiteServiceTerm", po);
            checkUpdateCount(po, result, updateCnt);
        } catch (Exception e) {
            TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
            result.setSuccess(false);
            result.setMessage("쇼핑몰 서비스 기간 변경중 오류가 발생했습니다.");
            log.error("쇼핑몰 서비스 기간 변경중 오류 발생, {}", po.getSiteNo(), e);
        }

        // 사이트 정보 갱신
        cacheService.refreshSiteInfoCache(po.getSiteNo());

        return result;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public RemoteBaseResult setSkinPayInfo(SkinPayInfoPO po) {
        RemoteBaseResult result = new RemoteBaseResult();
        result.setSuccess(true);

        SkinPO skinPo = new SkinPO();
        skinPo.setSiteNo(po.getSiteNo());
        skinPo.setSkinId(po.getSkinId()); // 기본스킨 ID
        skinPo.setSiteId(po.getSiteId());
        skinPo.setPcGbCd(po.getSkinGb());
        skinPo.setRegrNo(CommonConstants.MEMBER_INTERFACE_SYSTEM);
        skinPo.setUpdrNo(CommonConstants.MEMBER_INTERFACE_SYSTEM);
        try {
            skinConfigService.insertBuySkin(skinPo);
        } catch (Exception e) {
            TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
            log.error("구매스킨 등록중 오류 발생 [{}, {}]", po.getSiteNo(), po.getSkinId(), e);
            result.setSuccess(false);
            throw new RuntimeException("구매 스킨 등록중 오류가 발생했습니다.");
        }

        return result;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public RemoteBaseResult setAdminPassword(SuperAdminPO po) {
        RemoteBaseResult result = new RemoteBaseResult();
        result.setSuccess(true);

        try {
            MemberManagePO memberManagePO = new MemberManagePO();
            memberManagePO.setSiteNo(po.getSiteNo());
            memberManagePO.setLoginId(po.getAdminId());
            memberManagePO.setPw(po.getAdminPw());
            memberManagePO.setUpdrNo(CommonConstants.MEMBER_INTERFACE_SYSTEM);
            int updateCnt = proxyDao.update(MapperConstants.MEMBER_INFO + "updatePwd", memberManagePO);

            if (updateCnt == 0) {
                TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
                result.setSuccess(false);
                result.setMessage("비밀번호를 변경할 최고 관리자 정보가 존재하지 않습니다. ");
                log.warn("비밀번호를 변경할 최고 관리자 정보가 존재하지 않음. [{}, {}]", po.getSiteNo(), po.getAdminId());
                return result;
            }
        } catch (Exception e) {
            TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
            result.setSuccess(false);
            result.setMessage("최고 관리자 비밀번호 변경중 오류가 발생했습니다.");
            log.error("최고 관리자 비밀번호 변경중 오류 발생, {}", po.getSiteNo(), e);
            return result;
        }

        SiteCacheVO vo = siteService.getSiteInfo(po.getSiteNo());

        if("2".equals(vo.getSiteTypeCd()) || "3".equals(vo.getSiteTypeCd())) {

            // 임대형 유료인 경우 FTP 비밀번호 변경
            try {
                // 마루 작업 정보 등록
                changeFtpPasswordByMaru(po);
            } catch (Exception e) {
                TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
                result.setSuccess(false);
                result.setMessage("서버 FTP 비밀번호 변경중 오류가 발생했습니다.");
                log.error("서버 FTP 비밀번호 변경중 오류 발생, {}", po.getSiteNo(), e);
            }
        }

        return result;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public RemoteBaseResult setDomain(DomainPO po) {
        RemoteBaseResult result = new RemoteBaseResult();
        result.setSuccess(true);

        SiteSO so = new SiteSO();
        so.setSiteNo(po.getSiteNo());
        Map<String, Object> m = proxyDao.selectOne(MapperConstants.SYSTEM_SITE + "selectSiteDomain", so);

        if (m == null || m.isEmpty()) {
            TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
            result.setSuccess(false);
            result.setMessage("도메인 연결 정보를 변경할 쇼핑몰 정보가 존재하지 않습니다. ");
            log.warn("도메인 연결 정보를 변경할 쇼핑몰 정보가 존재하지 않음. [{}]", po.getSiteNo());
            return result;
        }

        try {
            // 마루 작업 정보 등록
            changeDomainByMaru(po);
        } catch (Exception e) {
            TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
            log.error("서버 도메인 변경 요청중 오류 발생[{}, {}]", po.getSiteNo(), po.getDomain(), e);
            result.setSuccess(false);
            result.setMessage("서버 도메인 변경 요청중 오류가 발생했습니다. ");
        }

        return result;
    }

    @Override
    public RemoteBaseResult setImageHosting(ImageHostingPO po) {
        RemoteBaseResult result = new RemoteBaseResult();
        result.setSuccess(true);

        //Long companyNo = siteCreateService.getCompanyNo(po.getHomepageId());
        //po.setCompanyNo(companyNo);
        po.setImgHostingServer(po.getId() + "." + imageDomain);
        po.setRegrNo(CommonConstants.MEMBER_INTERFACE_SYSTEM);
        po.setUpdrNo(CommonConstants.MEMBER_INTERFACE_SYSTEM);

        try {
            int updateCnt = operationSupportConfigService.updateImgServConfig(po);
            if (updateCnt == 0) {
                result.setSuccess(false);
                result.setMessage("이미지 호스팅 정보를 변경할 쇼핑몰이 존재하지 않습니다. ");
                log.warn("이미지 호스팅 정보를 변경할 쇼핑몰이 존재하지 않음. [{}]", po.getSiteNo());
                return result;
            }
        } catch(Exception e) {
            log.error("이미지 호스팅 정보 등록중 오류 발생[{}, {}]", po.getSiteNo(), po.getId(), e);
            result.setSuccess(false);
            result.setMessage("이미지 호스팅 정보 등록중 오류가 발생했습니다.");
        }

        try {
            // 마루 작업 정보 등록
            newImageByMaru(po);
        } catch (Exception e) {
            TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
            log.error("이미지 호스팅 정보 등록 요청중 오류 발생 [{}, {}]", po.getSiteNo(), po.getId(), e);
            result.setSuccess(false);
            result.setMessage("이미지 호스팅 정보 등록 요청중 오류가 발생했습니다.");
        }

        return result;
    }

    @Override
    public RemoteBaseResult setHostingInfo(HostingInfoPO po) {
        RemoteBaseResult result = new RemoteBaseResult();
        result.setSuccess(true);

        SiteCacheVO vo = siteService.getSiteInfo(po.getSiteNo());
        // TODO: 마루 서비스 호출
        MaruPO maruPO = new MaruPO();
        maruPO.setSiteNo(po.getSiteNo());
        maruPO.setSiteId(po.getSiteId());
        maruPO.setSellerDomain(domain);
        maruPO.setRequestCd(po.getRequestCd());
        maruPO.setFtpId(po.getSiteId());
        maruPO.setPublicIp(po.getIp());
        maruPO.setHostingIp(po.getVip());
        //TODO: (임대형)독립몰을 위한 리턴URL 정의 재고
        maruPO.setReturnUrl(po.getRtnDomain() + "/admin/remote/maru");

        if(po.getAmt() == null || po.getAmt() < 0) {
            result.setSuccess(false);
            result.setMessage("잘못된 세팅값입니다.");
            return result;
        }

        switch (po.getTypeGbCd()) {
        case "1": // 디스크
            maruPO.setSettingType("Change_Hard");
            maruPO.setHardLimit(po.getAmt());
            break;
        case "2": // 트래픽
            maruPO.setSettingType("Change_Traffic");
            maruPO.setTrafficLimit(po.getAmt());
            break;
        default:
            result.setSuccess(false);
            result.setMessage("미정의된 구분코드입니다.");
            return result;
        }

        maruService.insertRequest(maruPO);

        return result;
    }

    /**
     * <pre>
     * 작성일 : 2016. 9. 22.
     * 작성자 : dong
     * 설명   : 업데이트 카운트 체크
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 9. 22. dong - 최초생성
     * </pre>
     *
     * @param po
     * @param result
     * @param updateCnt
     */
    private void checkUpdateCount(RemoteBaseModel po, RemoteBaseResult result, int updateCnt) {
        if (updateCnt == 0) {
            TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
            result.setSuccess(false);
            result.setMessage("변경할 쇼핑몰 정보가 존재하지 않습니다. ");
            log.warn("변경할 쇼핑몰 정보 존재하지 않음. {}", po.getSiteNo());
        }
    }

    /**
     * <pre>
     * 작성일 : 2016. 9. 22.
     * 작성자 : dong
     * 설명   : 관리자 제한 수량 추가
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 9. 22. dong - 최초생성
     * </pre>
     *
     * @param po
     * @param result
     * @return
     */
    private RemoteBaseResult addSiteQuotaAdmin(PaymentInfoPO po, RemoteBaseResult result) {
        int updateCnt = siteQuotaService.updateManagerCount(po);
        checkUpdateCount(po, result, updateCnt);

        return result;
    }

    /**
     * <pre>
     * 작성일 : 2016. 9. 22.
     * 작성자 : dong
     * 설명   : 무통장 계좌 제한수량 추가
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 9. 22. dong - 최초생성
     * </pre>
     *
     * @param po
     * @param result
     * @return
     */
    private RemoteBaseResult addSiteQuotaNopbAct(PaymentInfoPO po, RemoteBaseResult result) {
        int updateCnt = siteQuotaService.updateAccountCount(po);
        checkUpdateCount(po, result, updateCnt);

        return result;
    }

    /**
     * <pre>
     * 작성일 : 2016. 9. 22.
     * 작성자 : dong
     * 설명   : 상품 아이콘 제한수량 추가
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 9. 22. dong - 최초생성
     * </pre>
     *
     * @param po
     * @param result
     * @return
     */
    private RemoteBaseResult addSiteQuotaIcon(PaymentInfoPO po, RemoteBaseResult result) {
        int updateCnt = siteQuotaService.updateIconCount(po);
        checkUpdateCount(po, result, updateCnt);

        return result;
    }

    /**
     * <pre>
     * 작성일 : 2016. 9. 22.
     * 작성자 : dong
     * 설명   : 080 수신거부 서비스 정보 등록
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 9. 22. dong - 최초생성
     * </pre>
     *
     * @param po
     * @param result
     * @return
     */
    private RemoteBaseResult add080Reject(PaymentInfoPO po, RemoteBaseResult result) {
        OperSupportConfigPO operSupportConfigPO = new OperSupportConfigPO();
        operSupportConfigPO.setSiteNo(po.getSiteNo());
        operSupportConfigPO.setRecvRjtNo(po.getAmt());
        operSupportConfigPO.setSvcUseStartPeriod(po.getServiceStartDt());
        operSupportConfigPO.setSvcUseEndPeriod(po.getServiceEndDt());

        int updateCnt = operationSupportConfigService.update080Config(operSupportConfigPO);
        checkUpdateCount(po, result, updateCnt);

        return result;
    }

    /**
     * <pre>
     * 작성일 : 2016. 9. 22.
     * 작성자 : dong
     * 설명   : BBS 제한수량 추가
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 9. 22. dong - 최초생성
     * </pre>
     *
     * @param po
     * @param result
     * @return
     */
    private RemoteBaseResult addSiteQuotaBbs(PaymentInfoPO po, RemoteBaseResult result) {
        int updateCnt = siteQuotaService.updateBbsCount(po);
        checkUpdateCount(po, result, updateCnt);

        return result;
    }

    /**
     * <pre>
     * 작성일 : 2016. 9. 22.
     * 작성자 : dong
     * 설명   : 소셜로그인 정보 등록
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 9. 22. dong - 최초생성
     * </pre>
     *
     * @param po
     * @param result
     * @return
     */
    private RemoteBaseResult addSiteQuotaSocialLogin(PaymentInfoPO po, RemoteBaseResult result) {
        po.setRegrNo(CommonConstants.MEMBER_INTERFACE_SYSTEM);
        int updateCnt = siteQuotaService.insertSnsLoginInfo(po);
        checkUpdateCount(po, result, updateCnt);

        return result;
    }

    /**
     * <pre>
     * 작성일 : 2016. 9. 22.
     * 작성자 : dong
     * 설명   : 마루 작업 테이블에 쇼핑몰 신규 등록 요청 등록
     *          결과 URL은 사이트ID와 도메인으로 조합한다.
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 9. 22. dong - 최초생성
     * </pre>
     *
     * @param po
     */
    private MaruPO newMallByMaru(SitePO po) {
        MaruPO maruPO = new MaruPO();
        maruPO.setSettingType("New_Mall");  // 세팅타입
        maruPO.setSellerDomain(domain);  //  도메인
        maruPO.setFtpId(po.getSiteId());  // FTP ID
        String pw;

        if("1".equals(po.getSitetypeCd())) {
            // 임대형 무료인 경우, FTP를 제공하지 않기 위해서 사이트ID에 '@davichmarket.com'을 붙여서 암호를 만듬
            pw = po.getSiteId() + "@davichmarket.com";
//            pw = cryptoUtil.encryptSHA512(pw); // FTP PW
        } else {
            pw = po.getAdminPw();
        }
        maruPO.setFtpPasswd(pw); // FTP PW, TODO: 암호화 체크

        maruPO.setHardLimit(po.getDisk());  // 하드용량
        maruPO.setTrafficLimit(po.getTraffic());  // 트래픽 용량
        maruPO.setPublicIp(po.getIp());  // 공인IP
        maruPO.setHostingIp(po.getVip());  // VIP

        maruPO.setSiteNo(po.getSiteNo());
        maruPO.setSiteId(po.getSiteId());
        maruPO.setRequestCd(po.getRequestCd());
        maruPO.setReturnUrl(po.getRtnDomain() + "/admin/remote/maru");

        maruService.insertRequest(maruPO);

        return maruPO;
    }

    /**
     * <pre>
     * 작성일 : 2016. 9. 22.
     * 작성자 : dong
     * 설명   : 마루 작업 테이블에 쇼핑몰 정보 삭제 요청 등록
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 9. 22. dong - 최초생성
     * </pre>
     *
     * @param po
     */
    private void deleteMallByMaru(SiteStatusPO po) {
        SiteCacheVO vo = siteService.getSiteInfo(po.getSiteNo());

        // 쇼핑몰 폐쇄시 마루 서비스 호출
        MaruPO maruPO = new MaruPO();
        maruPO.setSettingType("Delete_Mall");  // 세팅타입
        maruPO.setSellerDomain(domain); // 2차도메인
        maruPO.setFtpId(po.getSiteId());  // FTP ID
        maruPO.setDomain(vo.getDlgtDomain());  // 독립도메인
        maruPO.setHostingIp(po.getVip());  // VIP

        maruPO.setSiteNo(po.getSiteNo());
        maruPO.setSiteId(po.getSiteId());
        maruPO.setRequestCd(po.getRequestCd());
        //TODO: (임대형)독립몰을 위한 리턴URL 정의 재고
        maruPO.setReturnUrl(po.getRtnDomain() + "/admin/remote/maru");

        maruService.insertRequest(maruPO);
    }

    /**
     * <pre>
     * 작성일 : 2016. 9. 22.
     * 작성자 : dong
     * 설명   : 마루 작업 테이블에 FTP 비밀번호 변경 요청 등록
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 9. 22. dong - 최초생성
     * </pre>
     *
     * @param po
     */
    private void changeFtpPasswordByMaru(SuperAdminPO po) {
        SiteCacheVO vo = siteService.getSiteInfo(po.getSiteNo());
        MaruPO maruPO = new MaruPO();
        maruPO.setSettingType("Change_Ftp_Password");  // 세팅타입
        maruPO.setSellerDomain(domain);
        maruPO.setFtpId(po.getSiteId());  // FTP ID
        maruPO.setFtpPasswd(po.getAdminPw()); // TODO: SHA512 해시코드이니 판단할것
        maruPO.setHostingIp(po.getVip());  // VIP

        maruPO.setSiteNo(po.getSiteNo());
        maruPO.setSiteId(po.getSiteId());
        maruPO.setRequestCd(po.getRequestCd());
        //TODO: (임대형)독립몰을 위한 리턴URL 정의 재고
        maruPO.setReturnUrl(po.getRtnDomain() + "/admin/remote/maru");

        maruService.insertRequest(maruPO);
    }

    /**
     * <pre>
     * 작성일 : 2016. 9. 22.
     * 작성자 : dong
     * 설명   : 마루 작업 테이블에 도메인 변경 요청 등록
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 9. 22. dong - 최초생성
     * </pre>
     *
     * @param po
     */
    private void changeDomainByMaru(DomainPO po) throws Exception {
        SiteCacheVO vo = siteService.getSiteInfo(po.getSiteNo());
        MaruPO maruPO = new MaruPO();
        maruPO.setSettingType("Add_Domain");  // 세팅타입
        maruPO.setSellerDomain(domain); // 2차도메인
        maruPO.setFtpId(po.getSiteId());  // FTP ID
        maruPO.setDomain(po.getDomain());  // 신규 도메인

        if(vo.getTempDomain().trim().equals(vo.getDlgtDomain().trim())) {
            log.debug("임시도메인({})과 대표도메인({})이 같음", vo.getTempDomain(), vo.getDlgtDomain());
            log.debug("도메인 추가 : {}", po.getDomain());
            // 임시도메인과 대표도메인이 같으면 도메인 추가
            maruPO.setOlddomain(vo.getTempDomain());  // 이전 도메인

            // 임시도메인과 변경할 도메인이 같으면 도메인 변경
            if(po.getDomain().equals(vo.getTempDomain())) {
                log.debug("도메인 변경 : {}", po.getDomain());
                maruPO.setSettingType("Change_Domain");  // 세팅타입
            }
        } else {
            log.debug("임시도메인({})과 대표도메인({})이 다름", vo.getTempDomain(), vo.getDlgtDomain());
            log.debug("도메인 변경 : {}", po.getDomain());
            // 다르면 도메인 변경
            maruPO.setOlddomain(vo.getDlgtDomain());  // 이전 도메인
            maruPO.setSettingType("Change_Domain");  // 세팅타입

            if(po.getDomain().contains(domain)) {
                throw new Exception("변경할 수 없는 도메인입니다.");
            }
        }
        maruPO.setPublicIp(po.getIp());  // 공인 IP
        maruPO.setHostingIp(po.getVip());  // VIP

        maruPO.setSiteNo(po.getSiteNo());
        maruPO.setSiteId(po.getSiteId());
        maruPO.setRequestCd(po.getRequestCd());
        // TODO: 도메인이 즉시 반영이 되면 po.domain()
//        maruPO.setReturnUrl(po.getRtnDomain() + "/admin/remote/maru");
        maruPO.setReturnUrl(po.getRtnDomain() + "/admin/remote/maru");

        maruService.insertRequest(maruPO);
    }
    /**
     * <pre>
     * 작성일 : 2016. 9. 22.
     * 작성자 : dong
     * 설명   : 마루 작업 테이블에 이미지 호스팅 등록 요청 등록
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 9. 22. dong - 최초생성
     * </pre>
     *
     * @param po
     */
    private MaruPO newImageByMaru(ImageHostingPO po) {
        MaruPO maruPO = new MaruPO();
        maruPO.setSettingType("New_Imghost");  // 세팅타입
        maruPO.setSellerDomain(imageDomain);  // eyaap.com 도메인
        maruPO.setFtpId(po.getSiteId());  // FTP ID
        maruPO.setFtpPasswd(po.getPw()); // FTP PW, TODO: 암호화 체크

        maruPO.setHardLimit(po.getDisk());  // 하드용량
        maruPO.setTrafficLimit(po.getTraffic());  // 트래픽 용량
        maruPO.setPublicIp(po.getIp());  // 공인IP
        maruPO.setHostingIp(po.getVip());  // VIP

        maruPO.setSiteNo(po.getSiteNo());
        maruPO.setSiteId(po.getSiteId());
        maruPO.setRequestCd(po.getRequestCd());

        //TODO: (임대형)독립몰을 위한 리턴URL 정의 재고
        maruPO.setReturnUrl(po.getRtnDomain() + "/admin/remote/maru");

        maruService.insertRequest(maruPO);

        return maruPO;
    }
}
