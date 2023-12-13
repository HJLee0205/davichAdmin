package net.danvi.dmall.biz.system.remote.homepage.service;

import lombok.extern.slf4j.Slf4j;
import net.danvi.dmall.biz.app.design.model.SkinPO;
import net.danvi.dmall.biz.app.design.service.SkinConfigService;
import net.danvi.dmall.biz.app.member.level.model.MemberLevelPO;
import net.danvi.dmall.biz.app.operation.model.EmailSendPO;
import net.danvi.dmall.biz.app.setup.base.model.ManagerGroupPO;
import net.danvi.dmall.biz.app.setup.base.model.ManagerPO;
import net.danvi.dmall.biz.app.setup.payment.model.NopbPaymentConfigPO;
import net.danvi.dmall.biz.app.setup.securitymanage.model.SecurityManagePO;
import net.danvi.dmall.biz.app.setup.siteinfo.model.CompanyPO;
import net.danvi.dmall.biz.common.service.BizService;
import net.danvi.dmall.biz.system.model.SiteQuotaPO;
import net.danvi.dmall.biz.system.remote.homepage.model.AdminMemberPO;
import net.danvi.dmall.biz.system.remote.homepage.model.SiteCreatePO;
import net.danvi.dmall.biz.system.remote.homepage.model.SiteTermPO;
import net.danvi.dmall.core.remote.homepage.model.request.DomainPO;
import net.danvi.dmall.core.remote.homepage.model.request.SitePO;
import net.danvi.dmall.core.remote.homepage.model.result.RemoteBaseResult;
import net.danvi.dmall.core.remote.homepage.model.result.SiteResult;
import net.danvi.dmall.smsemail.service.PointRemoteService;
import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.ClassPathResource;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.transaction.interceptor.TransactionAspectSupport;
import dmall.framework.common.BaseService;
import dmall.framework.common.constants.CommonConstants;
import dmall.framework.common.constants.MapperConstants;
import dmall.framework.common.exception.CustomException;
import dmall.framework.common.util.CryptoUtil;
import dmall.framework.common.util.StringUtil;

import javax.annotation.Resource;
import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by dong on 2016-08-17.
 */
@Slf4j
@Service("siteCreateService")
public class SiteCreateServiceImpl extends BaseService implements SiteCreateService {

    @Resource(name = "bizService")
    private BizService bizService;

    @Resource(name = "skinConfigService")
    private SkinConfigService skinConfigService;

    @Resource(name = "pointRemoteService")
    private PointRemoteService pointRemoteService;

    @Value("#{system['site.init.script.path']}")
    private String scriptPath;

    @Value("#{system['site.init.script.copy.skin']}")
    private String scriptName;

    @Value("#{system['site.init.default.skin.path']}")
    private String defaultSkinPath;

    @Value("#{system['system.site.root.path']}")
    private String siteRootPath;

    @Value("#{system['system.domain']}")
    private String domain;

    @Value("#{core['system.site.init.admin.act.cnt']}")
    private Integer adminActCnt;
    @Value("#{core['system.site.init.nopb.act.cnt']}")
    private Integer nopbActCnt;
    @Value("#{core['system.site.init.bbs.cnt']}")
    private Integer bbsCnt;
    @Value("#{core['system.site.init.icon.cnt']}")
    private Integer iconCnt;

    @Value("#{core['system.site.init.default.skin.id']}")
    private String defaultSkinId;
    @Value("#{core['system.site.init.additional.skins']}")
    private List<String> additionalSkinList;

    @Value("#{core['system.site.init.list.image.size']}")
    private String goodsListImageSize;
    @Value("#{core['system.site.init.default.image.size']}")
    private String goodsDefaultImageSize;
    @Value("#{core['system.site.init.display.image.size.type.a']}")
    private String displayImageSizeTypeA;
    @Value("#{core['system.site.init.display.image.size.type.b']}")
    private String displayImageSizeTypeB;
    @Value("#{core['system.site.init.display.image.size.type.c']}")
    private String displayImageSizeTypeC;
    @Value("#{core['system.site.init.display.image.size.type.d']}")
    private String displayImageSizeTypeD;
    @Value("#{core['system.site.init.display.image.size.type.e']}")
    private String displayImageSizeTypeE;

    @Value("#{core['system.site.init.banned.word']}")
    private String bannedWord;

    @Value("#{core['system.site.init.terms.files']}")
    private String terms;

    @Value("#{core['system.site.init.email.template.files']}")
    private String emailTemplates;

    @Value("#{datasource['main.database.type']}")
    private String dbType;

    @Override
    @Transactional(rollbackFor = Exception.class)
    public SiteResult createSite(SitePO po) {
        SiteResult result = new SiteResult();
        result.setSuccess(true);

        po.setSiteId(po.getSiteId().toLowerCase());

        // 업체 및 사이트 생성
        SiteCreatePO siteCreatePO = insertSite(po);
        Long siteNo = siteCreatePO.getSiteNo();
        po.setSiteNo(siteNo);
        result.setSiteNo(siteNo);
        result.setSiteId(po.getSiteId());

        // 게시판 생성
        try {
            log.debug("쇼핑몰 게시판 정보 등록");
            siteCreatePO.setSiteNo(siteCreatePO.getSiteNo());
            insertDefaultBbs(po);
        } catch (Exception e) {
            log.error("쇼핑몰 게시판 정보 등록중 오류 발생 : {}", po.getSiteId(), e);
            TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
            throw new RuntimeException("쇼핑몰 게시판 정보 등록중 오류가 발생했습니다.");
        }

        // 소셜로그인 연동 정보 등록
        try {
            log.debug("쇼핑몰 소셜로그인 연동 정보 등록");
            insertInitSnsConfig(po);
        } catch (Exception e) {
            log.error("쇼핑몰 소셜로그인 연동 정보 등록중 오류 발생 : {}", po.getSiteId(), e);
            TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
            throw new RuntimeException("쇼핑몰 소셜로그인 연동 정보 등록중 오류가 발생했습니다.");
        }

        // 약관
        try {
            log.debug("약관 정보 등록");
            insertSiteInfo(siteCreatePO);
        } catch (Exception e) {
            log.error("약관 정보 등록중 오류 발생 : {}", po.getSiteId(), e);
            TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
            throw new RuntimeException("약관 정보 등록중 오류가 발생했습니다.");
        }

        // 금칙어
        try {
            log.debug("금칙어 정보 등록");
            insertBannedWords(siteCreatePO);
        } catch (Exception e) {
            log.error("금칙어 정보 등록중 오류 발생 : {}", po.getSiteId(), e);
            TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
            throw new RuntimeException("금칙어 정보 등록중 오류가 발생했습니다.");
        }

        // 기본 상품 아이콘
        try {
            log.debug("기본 상품 아이콘 정보 등록");
            insertGoodsIcon(siteCreatePO);
        } catch (Exception e) {
            log.error("기본 상품 아이콘 정보 등록중 오류 발생 : {}", po.getSiteId(), e);
            TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
            throw new RuntimeException("기본 상품 아이콘 정보 등록중 오류가 발생했습니다.");
        }

        // 회원등급 및 혜택
        try {
            log.debug("회원등급 및 혜택 정보 등록");
            insertMemberGradeBnf(siteCreatePO);
        } catch (Exception e) {
            log.error("회원등급 및 혜택 정보 등록중 오류 발생 : {}", po.getSiteId(), e);
            TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
            throw new RuntimeException("회원등급 및 혜택 정보 등록중 오류가 발생했습니다.");
        }

        // 사이트의 관리자 계정 생성
        AdminMemberPO adminMemberPO;
        adminMemberPO = insertMember(po);

        // 관리자 그룹 생성
        ManagerGroupPO managerGroupPO = insertManagerGroup(siteNo);
        Long authGrpNo = managerGroupPO.getAuthGrpNo();

        // 관리자 등록
        insertAdmin(siteNo, adminMemberPO, authGrpNo);

        // SMS 자동발송 템플릿
        try {
            insertSmsTemplate(po);
        } catch(Exception e) {
            log.error("SMS 자동발송 템플릿 세팅 중 오류", e);
            TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
            throw new RuntimeException("SMS 자동발송 템플릿 세팅 중 오류가 발생했습니다.");
        }

        // 이메일 자동발송 템플릿
        try {
            insertEmailTemplate(po);
        } catch (Exception e) {
            log.error("이메일 자동발송 템플릿 세팅 중 오류", e);
            TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
            throw new RuntimeException("이메일 자동발송 템플릿 세팅 중 오류가 발생했습니다.");
        }

        try {
            // 초기 카테고리 추가
            proxyDao.insert(MapperConstants.SYSTEM_SITE + "insertCategory", siteCreatePO);
        } catch (Exception e) {
            log.error("이메일 자동발송 템플릿 세팅 중 오류", e);
            TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
            throw new RuntimeException("이메일 자동발송 템플릿 세팅 중 오류가 발생했습니다.");
        }

        try {
            // 초기 전시영역 추가
            proxyDao.insert(MapperConstants.SYSTEM_SITE + "insertMainDisplay", siteCreatePO);
        } catch (Exception e) {
            log.error("이메일 자동발송 템플릿 세팅 중 오류", e);
            TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
            throw new RuntimeException("이메일 자동발송 템플릿 세팅 중 오류가 발생했습니다.");
        }

        // 무통장 정보 추가
        try {
            log.debug("무통장 정보 등록");
            NopbPaymentConfigPO nopbPaymentConfigPO = new NopbPaymentConfigPO();
            nopbPaymentConfigPO.setSiteNo(siteCreatePO.getSiteNo());
            nopbPaymentConfigPO.setBankCd("04"); // 국민은행
            nopbPaymentConfigPO.setBankNm("국민은행"); // 국민은행
            nopbPaymentConfigPO.setDlgtActYn("Y"); // 대표 계좌 여부
            nopbPaymentConfigPO.setHolder("이스밥"); // 예금주
            nopbPaymentConfigPO.setActno("123-123-12345"); // 계좌번호
            proxyDao.insert(MapperConstants.SYSTEM_SITE + "insertAccount", nopbPaymentConfigPO);
        } catch (Exception e) {
            log.error("무통장 정보 등록중 오류 발생 : {}", siteCreatePO.getSiteId(), e);
            TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
            throw new RuntimeException("무통장 정보 등록중 오류가 발생했습니다.");
        }

        // 스킨정보 세팅
        try {
            createDefaultSkin(po);
        } catch (Exception e) {
            log.error("스킨 정보 세팅 중 오류", e);
            TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
            throw new RuntimeException("스킨 정보 세팅 중 오류가 발생했습니다.");
        }

        return result;
    }

    /**
     * <pre>
     * 작성일 : 2016. 8. 16.
     * 작성자 : dong
     * 설명   : 업체 및 사이트(쇼핑몰) 등록
     *          홈페이지ID에 해당하는 업체가 없으면 신규 생성하고
     *          있으면 그 정보로 사이트(쇼핑몰)를 생성한다.
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 8. 16. dong - 최초생성
     * </pre>
     *
     * @param sitePO
     * @return
     */
    private SiteCreatePO insertSite(SitePO sitePO) {
        SiteCreatePO siteCreatePO = new SiteCreatePO();
        siteCreatePO.setSiteId(sitePO.getSiteId());
        siteCreatePO.setSiteTypeCd(sitePO.getSitetypeCd());
        siteCreatePO.setSvcStartDt(sitePO.getServiceStartDt());
        siteCreatePO.setSvcEndDt(sitePO.getServiceEndDt());
        siteCreatePO.setPwChgGuideYn("Y");
        siteCreatePO.setPwChgGuideCycle("6");
        siteCreatePO.setPwChgNextChgDcnt("15");
        siteCreatePO.setDormantMemberCancelMethod("1");

        try {
            // 업체 번호 유무 확인
            log.debug("기존 업체 확인 : {}", sitePO);
            Long companyNo = getCompanyNo(sitePO.getHomepageId());
            if (companyNo == null) {
                log.debug("신규 업체 생성 : {}", sitePO);
                // 없으면 업체 생성
                CompanyPO companyPO = new CompanyPO();
                companyPO.setHomepageId(sitePO.getHomepageId());
                companyPO.setCeoNm("홍길동");
                companyPO.setCompanyNm("㈜다비치");
                companyPO.setAddrRoadnm("서울특별시 서대문구 충정로");
                companyPO.setAddrCmnDtl("8");
                companyPO.setTelNo("070-1234-1234");
                companyPO.setFaxNo("070-1234-1234");
                companyPO.setBizNo("123-12-12345");
                companyPO.setCommSaleRegistNo("000-000-0000");
                companyPO.setPrivacymanager("홍길동");
                companyPO.setRegrNo(CommonConstants.MEMBER_INTERFACE_SYSTEM); // 인터페이스 - 시스템
                createCompany(companyPO);
                siteCreatePO.setCompanyNo(companyPO.getCompanyNo());
            } else {
                log.debug("기존 업체 사용 : {}", companyNo);
                siteCreatePO.setCompanyNo(companyNo);
            }
        } catch (Exception e) {
            log.error("업체 정보 등록중 오류가 발생", e);
            TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
            throw new RuntimeException("업체 정보 등록중 오류가 발생했습니다.");
        }

        // 중복 사이트 아이디 유무 판단, 있으면 생성 불가
        if (isExistSiteId(sitePO.getSiteId())) {
            log.error("이미 등록된 사이트 아이디 : {}", sitePO.getSiteId());
            TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
            throw new RuntimeException("이미 등록된 사이트 아이디입니다.");
        }

        // TODO: 등록불가 사이트 아이디 처리
        // EX) admin01~ admin99 등

        // 업체에 속한 사이트 정보 생성
        siteCreatePO.setDlgtDomain(sitePO.getSiteId() + "." + domain);
        siteCreatePO.setTempDomain(sitePO.getSiteId() + "." + domain);
        siteCreatePO.setSiteStatusCd("2");
        siteCreatePO.setRegrNo(CommonConstants.MEMBER_INTERFACE_SYSTEM); // 인터페이스 - 시스템
        // 기본상품이미지사이즈
        try {
            String[] size = StringUtil.split(goodsListImageSize, "*");
            siteCreatePO.setGoodsListImgWidth(Integer.valueOf(size[0]));
            siteCreatePO.setGoodsListImgHeight(Integer.valueOf(size[1]));
            size = StringUtils.split(goodsDefaultImageSize, "*");
            siteCreatePO.setGoodsDefaultImgWidth(Integer.valueOf(size[0]));
            siteCreatePO.setGoodsDefaultImgHeight(Integer.valueOf(size[1]));
            size = StringUtils.split(displayImageSizeTypeA, "*");
            siteCreatePO.setGoodsDispImgTypeAWidth(Integer.valueOf(size[0]));
            siteCreatePO.setGoodsDispImgTypeAHeight(Integer.valueOf(size[1]));
            size = StringUtils.split(displayImageSizeTypeB, "*");
            siteCreatePO.setGoodsDispImgTypeBWidth(Integer.valueOf(size[0]));
            siteCreatePO.setGoodsDispImgTypeBHeight(Integer.valueOf(size[1]));
            size = StringUtils.split(displayImageSizeTypeC, "*");
            siteCreatePO.setGoodsDispImgTypeCWidth(Integer.valueOf(size[0]));
            siteCreatePO.setGoodsDispImgTypeCHeight(Integer.valueOf(size[1]));
            size = StringUtils.split(displayImageSizeTypeD, "*");
            siteCreatePO.setGoodsDispImgTypeDWidth(Integer.valueOf(size[0]));
            siteCreatePO.setGoodsDispImgTypeDHeight(Integer.valueOf(size[1]));
            size = StringUtils.split(displayImageSizeTypeE, "*");
            siteCreatePO.setGoodsDispImgTypeEWidth(Integer.valueOf(size[0]));
            siteCreatePO.setGoodsDispImgTypeEHeight(Integer.valueOf(size[1]));
        } catch (Exception e) {
            log.error("사이트 기본 이미지 사이즈 설정중 오류 : {}", sitePO.getSiteId(), e);
            TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
            throw new RuntimeException("사이트 기본 이미지 사이즈 설정중 오류가 발생했습니다.");
        }

        siteCreatePO.setEmail("info@danvistory.com");
        siteCreatePO.setCustCtTelNo("070.4365.879");
        siteCreatePO.setCustCtOperTime("평일 AM 09:00 ~ PM 06:00");
        siteCreatePO.setCustCtLunchTime("PM 12:30 ~ PM 1:30");
        siteCreatePO.setCustCtClosedInfo("* 토, 일요일 및 공휴일 휴무");
        siteCreatePO.setLogoPath("/front/img/common/logo/logo.png");
        siteCreatePO.setBottomLogoPath("/front/img/common/logo/f_logo.png");

        try {
            log.debug("쇼핑몰 정보 등록");
            initSite(siteCreatePO);

        } catch (Exception e) {
            log.error("쇼핑몰 정보 등록중 오류 발생 : {}", sitePO.getSiteId(), e);
            TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
            throw new RuntimeException("쇼핑몰 정보 등록중 오류가 발생했습니다.");
        }

        try {
            // SMS/email 인증키 등록
            log.debug("SMS/email 인증키 등록");
            String certKey = pointRemoteService.getCertKey(siteCreatePO.getSiteNo());
            siteCreatePO.setCertKey(certKey);
            proxyDao.update(MapperConstants.SYSTEM_SITE + "updateCertKey", siteCreatePO);
        } catch (Exception e) {
            log.error("SMS/email 인증키 등록중 오류 발생 : {}", sitePO.getSiteId(), e);
            TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
            throw new RuntimeException("SMS/email 인증키 등록중 오류가 발생했습니다.");
        }

        return siteCreatePO;
    }

    /**
     * <pre>
     * 작성일 : 2016. 8. 16.
     * 작성자 : dong
     * 설명   : 관리자 로그인 계정 등록
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 8. 16. dong - 최초생성
     * </pre>
     *
     * @param po
     * @return
     * @throws Exception
     */
    private AdminMemberPO insertMember(SitePO po) throws RuntimeException {
        log.debug("관리자 계정 생성 : {}, {}", po.getSiteNo(), po.getAdminId());
        AdminMemberPO adminMemberPO = new AdminMemberPO();
        adminMemberPO.setSiteNo(po.getSiteNo());
        adminMemberPO.setMemberNm("관리자");
        adminMemberPO.setLoginId(po.getAdminId());
        adminMemberPO.setPw(CryptoUtil.encryptSHA512(po.getAdminPw()));
        adminMemberPO.setMemberStatusCd("01");
        adminMemberPO.setRegrNo(CommonConstants.MEMBER_INTERFACE_SYSTEM); // 인터페이스 - 시스템
        try {
            proxyDao.insert(MapperConstants.SYSTEM_SITE + "insertMember", adminMemberPO);
        } catch (Exception e) {
            log.error("관리자 로그인 계정 정보 등록중 오류 발생", e);
            TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
            throw new RuntimeException("관리자 계정 정보 등록중 오류가 발생했습니다.");
        }
        return adminMemberPO;
    }

    /**
     * <pre>
     * 작성일 : 2016. 8. 16.
     * 작성자 : dong
     * 설명   : 쇼핑몰 관리자 권한 등록
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 8. 16. dong - 최초생성
     * </pre>
     *
     * @param siteNo
     * @return
     */
    private ManagerGroupPO insertManagerGroup(Long siteNo) throws RuntimeException {
        log.debug("관리자 관리자 권한 등록 : {}", siteNo);
        ManagerGroupPO managerGroupPO = new ManagerGroupPO();
        managerGroupPO.setSiteNo(siteNo);
        managerGroupPO.setAuthGbCd(CommonConstants.AUTH_GB_CD_ADMIN);
        managerGroupPO.setAuthNm("쇼핑몰 관리자");
        managerGroupPO.setRegrNo(CommonConstants.MEMBER_INTERFACE_SYSTEM); // 인터페이스 - 시스템
        try {
            proxyDao.insert(MapperConstants.SETUP_BASE_ADMINAUTHCONFIG + "insertManagerGroup", managerGroupPO);
        } catch (Exception e) {
            log.error("관리자 그룹 등록중 오류 발생", e);
            TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
            throw new RuntimeException("관리자 그룹 등록중 오류가 발생했습니다.");
        }
        return managerGroupPO;
    }

    /**
     * <pre>
     * 작성일 : 2016. 8. 16.
     * 작성자 : dong
     * 설명   : 관리자 계정에 관리자 권한 추가
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 8. 16. dong - 최초생성
     * </pre>
     *
     * @param siteNo
     * @param adminMemberPO
     * @param authGrpNo
     */
    private void insertAdmin(Long siteNo, AdminMemberPO adminMemberPO, Long authGrpNo) {
        log.debug("관리자 회원 등록 {}, {}", siteNo, adminMemberPO.getLoginId());
        ManagerPO managerPO = new ManagerPO();
        managerPO.setSiteNo(siteNo);
        managerPO.setAuthGrpNo(authGrpNo);
        managerPO.setMemberNo(adminMemberPO.getMemberNo());
        managerPO.setRegrNo(CommonConstants.MEMBER_INTERFACE_SYSTEM); // 인터페이스 - 시스템
        try {
            proxyDao.insert(MapperConstants.SETUP_BASE_ADMINAUTHCONFIG + "insertManager", managerPO);
        } catch (Exception e) {
            log.error("관리자 권한 등록중 오류 발생", e);
            TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
            throw new RuntimeException("관리자 권한 등록중 오류가 발생했습니다.");
        }
    }

    /**
     * <pre>
     * 작성일 : 2016. 9. 5.
     * 작성자 : dong
     * 설명   : 기본 게시판 정보 등록
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 9. 5. dong - 최초생성
     * </pre>
     *
     * @param po
     */
    private void insertDefaultBbs(SitePO po) {
        log.debug("sitetypeCd:{}", po.getSitetypeCd());
        po.setRegrNo(CommonConstants.MEMBER_INTERFACE_SYSTEM);
        proxyDao.insert(MapperConstants.SYSTEM_SITE + "insertInitBbs", po);
    }

    /**
     * <pre>
     * 작성일 : 2016. 9. 5.
     * 작성자 : dong
     * 설명   : 소셜로그인 설정 정보 등록
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 9. 5. dong - 최초생성
     * </pre>
     *
     * @param po
     */
    private void insertInitSnsConfig(SitePO po) {
        proxyDao.insert(MapperConstants.SYSTEM_SITE + "insertInitSnsConfig", po);
    }

    /**
     * <pre>
     * 작성일 : 2016. 9. 5.
     * 작성자 : dong
     * 설명   : 기본 약관 정보 등록
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 9. 5. dong - 최초생성
     * </pre>
     *
     * @param po
     * @throws IOException
     */
    private void insertSiteInfo(SiteCreatePO po) throws Exception {
        String[] termsArray = null;
        if (terms != null) {
            termsArray = terms.split(",");
        }
        ClassPathResource resource;
        FileReader fr = null;
        BufferedReader br = null;
        String line;
        StringBuilder sb;
        SiteTermPO siteTermPO;
        List<SiteTermPO> siteTermPOList = new ArrayList<>();

        try {
            if(termsArray == null) {
                throw new RuntimeException("기본 약관 정보 설정이 없거나 잘못되었습니다.");
            }
            for (String termFileName : termsArray) {
                if (termFileName == null || termFileName.trim().length() == 0) continue;

                resource = new ClassPathResource("terms/" + termFileName.trim() + ".txt");
                fr = new FileReader(resource.getFile());
                br = new BufferedReader(fr);
                sb = new StringBuilder();

                while ((line = br.readLine()) != null) {
                    sb.append(line).append(System.lineSeparator());
                }
                siteTermPO = new SiteTermPO();
                siteTermPO.setSiteNo(po.getSiteNo());
                siteTermPO.setSiteInfoCd(termFileName);
                siteTermPO.setRegrNo(po.getRegrNo());
                siteTermPO.setContent(sb.toString());
                siteTermPOList.add(siteTermPO);
            }

            proxyDao.insert(MapperConstants.SYSTEM_SITE + "insertBaseSiteInfo", siteTermPOList);
        } catch(Exception e) {
            log.error("약관 정보 등록 오류", e);
            throw e;
        } finally {
            if (br != null) {
                try {
                    br.close();
                } catch (Exception e) {
                    log.warn("BufferedReader 오류", e);
                }
            }
            if (fr != null) {
                try {
                    fr.close();
                } catch (Exception e) {
                    log.warn("FileReader 오류", e);
                }
            }
        }
    }

    /**
     * <pre>
     * 작성일 : 2016. 9. 5.
     * 작성자 : dong
     * 설명   : 기본 금칙어 등록
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 9. 5. dong - 최초생성
     * </pre>
     *
     * @param po
     */
    private void insertBannedWords(SiteCreatePO po) {
        String[] bannedWordArray = null;
        if (bannedWord != null) {
            bannedWordArray = bannedWord.split(",");
        }
        po.setBannedWordArray(bannedWordArray);
        proxyDao.insert(MapperConstants.SYSTEM_SITE + "insertBannedWords", po);
    }

    /**
     * <pre>
     * 작성일 : 2016. 9. 19.
     * 작성자 : dong
     * 설명   : 기본 상품 아이콘 정보 등록
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 9. 19. dong - 최초생성
     * </pre>
     *
     * @param po
     */
    private void insertGoodsIcon(SiteCreatePO po) {
        proxyDao.insert(MapperConstants.SYSTEM_SITE + "insertGoodsIcon", po);
    }

    /**
     * <pre>
     * 작성일 : 2016. 9. 19.
     * 작성자 : dong
     * 설명   : 기본 회원 등급 및 혜택 등록
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 9. 19. dong - 최초생성
     * </pre>
     *
     * @param po
     * @throws Exception
     */
    private void insertMemberGradeBnf(SiteCreatePO po) throws Exception {
        MemberLevelPO memberLevelPO = new MemberLevelPO();
        memberLevelPO.setSiteNo(po.getSiteNo());
        memberLevelPO.setMemberGradeNo("" + bizService.getSequence("MEMBER_GRADE_NO", po.getSiteNo()));
        memberLevelPO.setMemberGradeNm("브론즈");
        memberLevelPO.setTotBuyAmt("0");
        memberLevelPO.setTotBuyCnt("0");
        memberLevelPO.setMemberGradeLvl("1");
        memberLevelPO.setMemberGradeManageCd("10");
        memberLevelPO.setDelYn("N");
        memberLevelPO.setAutoYn("Y");
        memberLevelPO.setRegrNo(CommonConstants.MEMBER_INTERFACE_SYSTEM);
        proxyDao.insert(MapperConstants.SYSTEM_SITE + "insertMemberGrade", memberLevelPO);
        memberLevelPO.setDcUnitCd("1");
        memberLevelPO.setSvmnUnitCd("11");
        memberLevelPO.setUseYn("N");
        memberLevelPO.setDcValue("4");
        memberLevelPO.setSvmnValue("4");
        memberLevelPO.setMemberGradeBnfNo(bizService.getSequence("MEMBER_GRADE_BNF_NO"));
        proxyDao.insert(MapperConstants.SYSTEM_SITE + "insertMemberGradeBnf", memberLevelPO);

        memberLevelPO.setMemberGradeNo("" + bizService.getSequence("MEMBER_GRADE_NO", po.getSiteNo()));
        memberLevelPO.setMemberGradeNm("실버");
        memberLevelPO.setTotBuyAmt("100000");
        memberLevelPO.setTotPoint("2000");
        memberLevelPO.setTotBuyCnt("3");
        memberLevelPO.setMemberGradeLvl("2");
        proxyDao.insert(MapperConstants.SYSTEM_SITE + "insertMemberGrade", memberLevelPO);
        memberLevelPO.setDcValue("6");
        memberLevelPO.setSvmnValue("6");
        memberLevelPO.setMemberGradeBnfNo(bizService.getSequence("MEMBER_GRADE_BNF_NO"));
        proxyDao.insert(MapperConstants.SYSTEM_SITE + "insertMemberGradeBnf", memberLevelPO);

        memberLevelPO.setMemberGradeNo("" + bizService.getSequence("MEMBER_GRADE_NO", po.getSiteNo()));
        memberLevelPO.setMemberGradeNm("골드");
        memberLevelPO.setTotBuyAmt("300000");
        memberLevelPO.setTotPoint("5000");
        memberLevelPO.setTotBuyCnt("6");
        memberLevelPO.setMemberGradeLvl("3");
        proxyDao.insert(MapperConstants.SYSTEM_SITE + "insertMemberGrade", memberLevelPO);
        memberLevelPO.setDcValue("8");
        memberLevelPO.setSvmnValue("8");
        memberLevelPO.setMemberGradeBnfNo(bizService.getSequence("MEMBER_GRADE_BNF_NO"));
        proxyDao.insert(MapperConstants.SYSTEM_SITE + "insertMemberGradeBnf", memberLevelPO);

        memberLevelPO.setMemberGradeNo("" + bizService.getSequence("MEMBER_GRADE_NO", po.getSiteNo()));
        memberLevelPO.setMemberGradeNm("플래티늄");
        memberLevelPO.setTotBuyAmt("600000");
        memberLevelPO.setTotPoint("10000");
        memberLevelPO.setTotBuyCnt("9");
        memberLevelPO.setMemberGradeLvl("4");
        proxyDao.insert(MapperConstants.SYSTEM_SITE + "insertMemberGrade", memberLevelPO);
        memberLevelPO.setDcValue("10");
        memberLevelPO.setSvmnValue("10");
        memberLevelPO.setMemberGradeBnfNo(bizService.getSequence("MEMBER_GRADE_BNF_NO"));
        proxyDao.insert(MapperConstants.SYSTEM_SITE + "insertMemberGradeBnf", memberLevelPO);

        proxyDao.insert(MapperConstants.SYSTEM_SITE + "insertMemberGradeAutoRearrange", po);
    }

    /**
     * <pre>
     * 작성일 : 2016. 9. 19.
     * 작성자 : dong
     * 설명   : 홈페이지 아이디로 업체 번호 조회
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 9. 19. dong - 최초생성
     * </pre>
     *
     * @param homepageId
     * @return
     */
    public Long getCompanyNo(String homepageId) {
        return proxyDao.selectOne(MapperConstants.SYSTEM_SITE + "selectCompanyNo", homepageId);
    }

    @Override
    public RemoteBaseResult setDomain(DomainPO po) {
        RemoteBaseResult result = new RemoteBaseResult();
        result.setSuccess(true);

        Map<String, Object> siteDomainMap = new HashMap<>();
        siteDomainMap.put("siteNo", po.getSiteNo());
        siteDomainMap.put("dlgtDomain", po.getDomain());

        // TODO : 맵에서 POJO 모델로 변경
        siteDomainMap.put("updrNo", CommonConstants.MEMBER_INTERFACE_SYSTEM);

        try {
            int updateCnt = proxyDao.update(MapperConstants.SYSTEM_SITE + "updateDomainInfo", siteDomainMap);
            if (updateCnt == 0) {
                TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
                result.setSuccess(false);
                result.setMessage("도메인 연결 정보를 변경할 쇼핑몰 정보가 존재하지 않습니다. ");
                log.warn("도메인 연결 정보를 변경할 쇼핑몰 정보가 존재하지 않음. [{}]", siteDomainMap.get("siteNo"));
                return result;
            }
        } catch (Exception e) {
            TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
            log.error("도메인 연결 정보 변경중 [{}, {}]", po.getSiteNo(), po.getDomain(), e);
            result.setSuccess(false);
            result.setMessage("도메인 연결 정보 변경중 오류가 발생했습니다.");
        }

        return result;
    }

    @Override
    @Transactional(rollbackFor = Exception.class, propagation = Propagation.REQUIRES_NEW)
    public void createSiteSystemWork(SitePO po) {
        proxyDao.insert(MapperConstants.SYSTEM_SITE + "insertSiteSystemWork", po);
    }

    @Override
    public SitePO getSiteSystemWork(SitePO po) {
        return proxyDao.selectOne(MapperConstants.SYSTEM_SITE + "selectSiteSystemWork", po);
    }

    /**
     * <pre>
     * 작성일 : 2016. 9. 19.
     * 작성자 : dong
     * 설명   : 업체 정보 등록
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 9. 19. dong - 최초생성
     * </pre>
     *
     * @param po
     */
    private void createCompany(CompanyPO po) {
        proxyDao.insert(MapperConstants.SYSTEM_SITE + "insertCompany", po);
    }

    /**
     * <pre>
     * 작성일 : 2016. 9. 19.
     * 작성자 : dong
     * 설명   : 사이트(쇼핑몰) 정보 등록
     *          무료 임대몰일 경우 기본 사용 쿼터 정보 등록
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 9. 19. dong - 최초생성
     * </pre>
     *
     * @param po
     */
    private void initSite(SiteCreatePO po) {
        proxyDao.insert(MapperConstants.SYSTEM_SITE + "insertSite", po);
        proxyDao.insert(MapperConstants.SYSTEM_SITE + "insertSiteDtl", po);
        SecurityManagePO securityManagePO = new SecurityManagePO();
        securityManagePO.setSiteNo(po.getSiteNo());
        securityManagePO.setSecurityServUseTypeCd("1"); // 무료 보안 서버
        securityManagePO.setSecurityServStatusCd("1"); // 정상
        securityManagePO.setRegrNo(CommonConstants.MEMBER_INTERFACE_SYSTEM);
        proxyDao.insert(MapperConstants.SETUP_SECURITY_MANAGE + "insertSecurityConfig", securityManagePO);

        // 무료 임대몰인 경우 쿼터 정보 추가
        if ("1".equals(po.getSiteTypeCd())) {
            SiteQuotaPO siteQuotaPO = new SiteQuotaPO();
            siteQuotaPO.setSiteNo(po.getSiteNo());
            siteQuotaPO.setManagerActCnt(adminActCnt);
            siteQuotaPO.setNopbActCnt(nopbActCnt);
            siteQuotaPO.setBbsCnt(bbsCnt);
            siteQuotaPO.setIconCnt(iconCnt);
            siteQuotaPO.setRegrNo(CommonConstants.MEMBER_INTERFACE_SYSTEM);
            proxyDao.insert(MapperConstants.SYSTEM_SITE + "insertSiteQuota", siteQuotaPO);
        }
    }

    public boolean isExistSiteId(String siteId) {
        return (Integer) proxyDao.selectOne(MapperConstants.SYSTEM_SITE + "selectCountSiteBySiteId", siteId) > 0 ? true
                : false;
    }

    private void insertSmsTemplate(SitePO po) {
        proxyDao.insert(MapperConstants.SYSTEM_SITE + "insertSmsInfoManage", po);
        proxyDao.insert(MapperConstants.SYSTEM_SITE + "insertSmsTemplate", po);
    }

    private void insertEmailTemplate(SitePO po) throws Exception {
        String[] emailArray = null;
        String[] emailConfigArray = null;
        if (emailTemplates != null) {
            emailArray = StringUtil.split(StringUtil.trim(emailTemplates), "/////");
        }
        ClassPathResource resource;
        FileReader fr = null;
        BufferedReader br = null;
        String line;
        StringBuilder sb;
        EmailSendPO emailSendPO;
        List<EmailSendPO> emailSendPOList = new ArrayList<>();
        String code;

        if(emailArray == null) {
            throw new RuntimeException("이메일 템플릿 파일이 없거나 잘못되었습니다.");
        }

        try {
            for (String email : emailArray) {
                if (email == null || email.trim().length() == 0) continue;
                emailConfigArray = StringUtil.split(email, "|||||");

                if (emailConfigArray == null || emailConfigArray.length != 5) continue;

                code = StringUtil.trim(emailConfigArray[0]);
                resource = new ClassPathResource("email/" + code + ".txt");
                fr = new FileReader(resource.getFile());
                br = new BufferedReader(fr);
                sb = new StringBuilder();

                while ((line = br.readLine()) != null) {
                    sb.append(line);
                }
                emailSendPO = new EmailSendPO();
                emailSendPO.setSiteNo(po.getSiteNo());
                emailSendPO.setMailTypeCd(code);
                emailSendPO.setRegrNo(po.getRegrNo());
                emailSendPO.setMailTitle(StringUtil.trim(emailConfigArray[1]));
                emailSendPO.setMailContent(sb.toString());
                emailSendPO.setMemberSendYn(StringUtil.nvl(StringUtil.trim(emailConfigArray[2]), null));
                emailSendPO.setManagerSendYn(StringUtil.nvl(StringUtil.trim(emailConfigArray[3]), null));
                emailSendPO.setOperatorSendYn(StringUtil.nvl(StringUtil.trim(emailConfigArray[4]), null));
                emailSendPOList.add(emailSendPO);
            }

            proxyDao.insert(MapperConstants.SYSTEM_SITE + "insertMailInfoManage", po);
            proxyDao.insert(MapperConstants.SYSTEM_SITE + "insertEmailTemplate", emailSendPOList);
        } catch (Exception e) {
            log.error("이메일 템플릿 등록 오류", e);
            throw e;
        } finally {
            if (br != null) {
                try {
                    br.close();
                } catch (Exception e) {
                    log.warn("BufferedReader 오류", e);
                }
            }
            if (fr != null) {
                try {
                    fr.close();
                } catch (Exception e) {
                    log.warn("FileReader 오류", e);
                }
            }
        }
    }

    /**
     * <pre>
     * 작성일 : 2016. 8. 16.
     * 작성자 : dong
     * 설명   : 기본 스킨 정보 생성
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 8. 16. dong - 최초생성
     * </pre>
     *
     * @param po
     * @throws IOException
     */
    private void createDefaultSkin(SitePO po) throws Exception {
        log.debug("스킨 정보 생성");
        SkinPO skinPo = new SkinPO();
        skinPo.setSiteNo(po.getSiteNo());
        skinPo.setSkinId(defaultSkinId); // 기본스킨 ID
        skinPo.setSiteId(po.getSiteId());
        skinPo.setPcGbCd("S"); // 세트 스킨
        skinPo.setRegrNo(CommonConstants.MEMBER_INTERFACE_SYSTEM);
        skinPo.setUpdrNo(CommonConstants.MEMBER_INTERFACE_SYSTEM);
        try {
            skinConfigService.insertDefaultSkin(skinPo);
        } catch (Exception e) {
            log.error("기본스킨 등록중 오류 발생", e);
            throw new RuntimeException("기본스킨 등록중 오류가 발생했습니다.");
        }


        if("2".equals(po.getSitetypeCd())) {
            // 임대형 유료인 경우 추가 제공 스킨 처리
            for (String skinId : additionalSkinList) {
                skinPo = new SkinPO();
                skinPo.setSiteNo(po.getSiteNo());
                skinPo.setSkinId(skinId); // 기본스킨 ID
                skinPo.setSiteId(po.getSiteId());
                skinPo.setPcGbCd("S");
                skinPo.setSkinNm(skinId);
                skinPo.setRegrNo(CommonConstants.MEMBER_INTERFACE_SYSTEM);
                skinPo.setUpdrNo(CommonConstants.MEMBER_INTERFACE_SYSTEM);
                skinConfigService.insertBuySkin(skinPo);
            }
        }

        // PC 적용 스킨 번호 조회
        Long skinNo = proxyDao.selectOne("selectPcSkinNo", skinPo);
        skinPo.setSkinNo(skinNo);

        // PC 기본 배너 등록
        proxyDao.insert(MapperConstants.SYSTEM_SITE + "insertBanner", skinPo);

        //TODO: 모바일 배너 등록
    }
}
