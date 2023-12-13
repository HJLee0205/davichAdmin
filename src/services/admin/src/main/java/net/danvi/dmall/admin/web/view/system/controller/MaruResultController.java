package net.danvi.dmall.admin.web.view.system.controller;

import javax.annotation.Resource;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.ckd.common.reqInterface.ChangeStatusResult;
import com.ckd.common.reqInterface.CreateMallResult;
import com.ckd.common.reqInterface.DiskTrafficResult;
import com.ckd.common.reqInterface.DomainLinkResult;
import com.ckd.common.reqInterface.ImageHostingResult;
import com.ckd.common.reqInterface.ShoppingMallAdminResult;

import lombok.extern.slf4j.Slf4j;
import net.danvi.dmall.biz.common.service.CacheService;
import net.danvi.dmall.biz.system.model.SiteCacheVO;
import net.danvi.dmall.biz.system.remote.homepage.service.HomepageRemoteDelegateService;
import net.danvi.dmall.biz.system.remote.homepage.service.SiteCreateService;
import net.danvi.dmall.biz.system.remote.maru.model.MaruResult;
import net.danvi.dmall.biz.system.service.SiteService;
import net.danvi.dmall.core.remote.homepage.model.request.DomainPO;
import net.danvi.dmall.core.remote.homepage.model.request.SitePO;
import net.danvi.dmall.core.remote.homepage.model.result.SiteResult;
import dmall.framework.common.constants.CommonConstants;
import dmall.framework.common.util.DateUtil;

/**
 * <pre>
 * 프로젝트명 : 41.admin.web
 * 작성일     : 2016. 10. 5.
 * 작성자     : dong
 * 설명       : 마루 솔루션 결과 처리 컨트롤러
 * </pre>
 */
@Slf4j
@Controller
@RequestMapping("/admin/remote")
public class MaruResultController {

    @Resource(name = "homepageRemoteDelegateService")
    private HomepageRemoteDelegateService homepageRemoteDelegateService;

    @Resource(name = "siteCreateService")
    private SiteCreateService siteCreateService;

    @Resource(name = "siteService")
    private SiteService siteService;

    @Resource(name = "cacheService")
    private CacheService cacheService;

    private static final String NEW_MALL = "New_Mall"; // 쇼핑몰 생성
    private static final String NEW_IMAGE = "New_Imghost"; // 이미지 호스팅 계정 생송
    private static final String CHANGE_TRAFFIC = "Change_Traffic"; // 트래픽 용량 변경
    private static final String CHANGE_HARD = "Change_Hard"; // 디스크 용량 변경
    private static final String CHANGE_FTP_PASSWORD = "Change_Ftp_Password"; // FTP(관리자) 패스워드 변경
    private static final String DELETE_MALL = "Delete_Mall"; // 쇼핑몰 삭제
    private static final String ADD_DOMAIN = "Add_Domain"; // 도메인 추가
    private static final String CHANGE_DOMAIN = "Change_Domain"; // 도메인 변경
    // private static final String CHANGE_MALL = "Change_Mall"; // 쇼핑몰 상품 변경(디스크/트래픽) - 미사용

    /**
     * <pre>
     * 작성일 : 2016. 9. 28.
     * 작성자 : dong
     * 설명   : 마루 솔루션의 결과값 처리
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 9. 28. dong - 최초생성
     * </pre>
     *
     * @param maruResult
     */
    @RequestMapping("/maru")
    public void maru(MaruResult maruResult) {

        log.debug("PARAMS : {}", maruResult);

        switch (maruResult.getType()) {
        case NEW_MALL: // 쇼핑몰 생성
            setCreateMallResult(maruResult);
            break;
        case CHANGE_TRAFFIC: // 트래픽 변경
            setDiskTrafficResult(maruResult, "2");
            break;
        case CHANGE_HARD: // 하드디스크 변경
            setDiskTrafficResult(maruResult, "1");
            break;
        case CHANGE_FTP_PASSWORD: // FTP 패스워드 변경
            setPasswordResult(maruResult);
            break;
        case DELETE_MALL: // 쇼핑몰 삭제
            setChangeMallStatusResult(maruResult);
            break;
        case ADD_DOMAIN: // 도메인 추가
            //break;
        case CHANGE_DOMAIN: // 도메인 변경
            setDomainResult(maruResult);
            break;
        // case CHANGE_MALL: // 쇼핑몰 상품 변경
        // break;
        case NEW_IMAGE: // 이미지 호스팅 서버 계정 생성
            setCreateImageResult(maruResult);
            break;
        default:

        }
    }

    /**
     * <pre>
     * 작성일 : 2016. 9. 26.
     * 작성자 : dong
     * 설명   : 쇼핑몰 생성 결과
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 9. 26. dong - 최초생성
     * </pre>
     *
     * @param maruResult
     */
    private void setCreateMallResult(MaruResult maruResult) {
        CreateMallResult createMallResult = new CreateMallResult();
        createMallResult.setSuccess(false);

        SitePO sitePO = new SitePO();
        sitePO.setSiteId(maruResult.getSiteId());
        sitePO.setIdx(maruResult.getIdx());

        sitePO = siteCreateService.getSiteSystemWork(sitePO);

        if(sitePO == null) {
            log.error("작업 결과 데이터와 일치하는 작업 요청 데이터가 존재하지 않음 {}", maruResult);
            createMallResult.setSiteStatusCd("99"); // 사이트 상태 코드, 99:실패
            createMallResult.setFailMessage("작업 결과 데이터와 일치하는 작업 요청 데이터가 존재하지 않음 : " + maruResult.getIdx());

            homepageRemoteDelegateService.setCreateMallResult(createMallResult);
            return;
        }

        sitePO.setRegrNo(CommonConstants.MEMBER_INTERFACE_SYSTEM);

        createMallResult.setSiteId(maruResult.getSiteId());
        createMallResult.setRequestCd(maruResult.getRequestCd());

        if (maruResult.getError()) {
            // 마루 몰생성 생성 결과 실패 처리
            createMallResult.setSiteStatusCd("99"); // 사이트 상태 코드, 99:실패
            createMallResult.setFailMessage(maruResult.getErrorText());
        } else {
            createMallResult.setCrtDate(DateUtil.getNowDate()); // 생성일자

            try {
                SiteResult result = siteCreateService.createSite(sitePO);
                createMallResult.setSuccess(true);
                createMallResult.setSiteNo(result.getSiteNo());
                createMallResult.setSiteStatusCd("2"); // 사이트 상태 코드, 2:정상

            } catch (Exception e) {
                log.error("쇼핑몰 정보 생성시 오류가 발생", e);
                createMallResult.setSiteStatusCd("99"); // 사이트 상태 코드, 99:실패
                createMallResult.setFailMessage(e.getMessage());
            }
        }
        log.debug("createMallResult : {}", createMallResult);
        homepageRemoteDelegateService.setCreateMallResult(createMallResult);
    }

    /**
     * <pre>
     * 작성일 : 2016. 9. 28.
     * 작성자 : dong
     * 설명   : 디스크/트래픽 변경 결과 반환
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 9. 28. dong - 최초생성
     * </pre>
     *
     * @param maruResult
     * @param gbCd
     *            1 : 디스크, 2 : 트래픽
     */
    private void setDiskTrafficResult(MaruResult maruResult, String gbCd) {
        DiskTrafficResult diskTrafficResult = new DiskTrafficResult();
        diskTrafficResult.setSiteId(maruResult.getSiteId());
        diskTrafficResult.setSiteNo(maruResult.getSiteNo());
        diskTrafficResult.setGbCd(gbCd);
        diskTrafficResult.setRequestCd(maruResult.getRequestCd());

        if (maruResult.getError()) {
            diskTrafficResult.setResultCd("99"); // 처리 결과 코드, 99:실패
            diskTrafficResult.setResultMassage(maruResult.getErrorText());
        } else {
            diskTrafficResult.setResultCd("00"); // 처리 결과 코드, 00:성공
        }

        homepageRemoteDelegateService.reqDiskTrafficResult(diskTrafficResult);
    }

    /**
     * <pre>
     * 작성일 : 2016. 9. 28.
     * 작성자 : dong
     * 설명   : 패스워드 변경 결과 반환
     *          솔루션의 패스워드는 홈페이지에서 요청 받았을때 먼저 처리함
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 9. 28. dong - 최초생성
     * </pre>
     *
     * @param maruResult
     */
    private void setPasswordResult(MaruResult maruResult) {
        ShoppingMallAdminResult shoppingMallAdminResult = new ShoppingMallAdminResult();
        shoppingMallAdminResult.setSiteNo(maruResult.getSiteNo());
        shoppingMallAdminResult.setSiteId(maruResult.getSiteId());
        shoppingMallAdminResult.setRequestCd(maruResult.getRequestCd());

        if (maruResult.getError()) {
            shoppingMallAdminResult.setResultCd("99"); // 처리 결과 코드, 99:실패
            shoppingMallAdminResult.setResultMassage(maruResult.getErrorText());
        } else {
            shoppingMallAdminResult.setResultCd("00"); // 처리 결과 코드, 00:성공
        }

        homepageRemoteDelegateService.reqShoppingMallAdminPasswordChangeResult(shoppingMallAdminResult);
    }

    /**
     * <pre>
     * 작성일 : 2016. 9. 28.
     * 작성자 : dong
     * 설명   : 쇼핑몰 상태 변경 결과 반환
     *          솔루션의 쇼핑몰 상태는 홈페이지에서 요청 받았을때 먼저 처리함
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 9. 28. dong - 최초생성
     * </pre>
     *
     * @param maruResult
     */
    private void setChangeMallStatusResult(MaruResult maruResult) {

        ChangeStatusResult result = new ChangeStatusResult();
        result.setSiteNo(maruResult.getSiteNo());
        result.setSiteId(maruResult.getSiteId());
        result.setRequestCd(maruResult.getRequestCd());

        if (maruResult.getError()) {
            result.setResultCd("99"); // 처리 결과 코드, 99:실패
            result.setResultMessage(maruResult.getErrorText());
            SiteCacheVO siteCacheVO = siteService.getSiteInfo(maruResult.getSiteNo());
            result.setSiteStatusCd(siteCacheVO.getSiteStatusCd()); // 사이트 상태코드
        } else {
            result.setResultCd("00"); // 처리 결과 코드, 00:성공
            result.setSiteStatusCd("5"); // 사이트 상태코드, 5:중지
            result.setClsDate(DateUtil.getNowDate()); // 몰 폐쇄일자
        }

        // 사이트 정보 갱신
        cacheService.refreshSiteInfoCache(maruResult.getSiteNo());

        homepageRemoteDelegateService.setChangeStatusResult(result);
    }

    /**
     * <pre>
     * 작성일 : 2016. 9. 28.
     * 작성자 : dong
     * 설명   : 도메인 변경 결과 처리
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 9. 28. dong - 최초생성
     * </pre>
     *
     * @param maruResult
     */
    private void setDomainResult(MaruResult maruResult) {

        DomainPO po = new DomainPO();
        po.setSiteNo(maruResult.getSiteNo());
        po.setSiteId(maruResult.getSiteId());
        po.setDomain(maruResult.getDomain());

        // TODO: 홈페이지로 결과 반환
        DomainLinkResult domainLinkResult = new DomainLinkResult();
        domainLinkResult.setSiteNo(maruResult.getSiteNo());
        domainLinkResult.setSiteId(maruResult.getSiteId());
        domainLinkResult.setRequestCd(maruResult.getRequestCd());

        try {
            // 도메인 세팅
            siteCreateService.setDomain(po);

            if (maruResult.getError()) {
                domainLinkResult.setResultCd("99"); // 처리 결과 코드, 99:실패
                domainLinkResult.setResultMassage(maruResult.getErrorText());
            } else {
                domainLinkResult.setResultCd("00"); // 처리 결과 코드, 00:성공
            }

        } catch (Exception e) {
            log.error("도메인 세팅정보 저장중 오류", e);
            domainLinkResult.setResultCd("99"); // 처리 결과 코드, 99:실패
            domainLinkResult.setResultMassage(maruResult.getErrorText());
        }

        // 사이트 정보 갱신
        cacheService.refreshSiteInfoCache(maruResult.getSiteNo());

        homepageRemoteDelegateService.reqDomainLinkInfoResult(domainLinkResult);
    }

    /**
     * <pre>
     * 작성일 : 2016. 9. 28.
     * 작성자 : dong
     * 설명   : 
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 9. 28. dong - 최초생성
     * </pre>
     *
     * @param maruResult
     */
    private void setCreateImageResult(MaruResult maruResult) {
        SitePO sitePO = new SitePO();
        sitePO.setSiteNo(maruResult.getSiteNo());
        sitePO.setSiteId(maruResult.getSiteId());

        // TODO: 이미지 호스팅 정보 세팅 저장
        ImageHostingResult imageHostingResult = new ImageHostingResult();
        imageHostingResult.setSiteNo(maruResult.getSiteNo());
        imageHostingResult.setSiteId(maruResult.getSiteId());
        imageHostingResult.setRequestCd(maruResult.getRequestCd());

        if (maruResult.getError()) {
            imageHostingResult.setResultCd("99"); // 처리 결과 코드, 99:실패
            imageHostingResult.setResultMassage(maruResult.getErrorText());
        } else {
            imageHostingResult.setResultCd("00"); // 처리 결과 코드, 00:성공
        }

        // 사이트 정보 갱신
        cacheService.refreshSiteInfoCache(maruResult.getSiteNo());

        homepageRemoteDelegateService.reqImageHostingResult(imageHostingResult);
    }
}
