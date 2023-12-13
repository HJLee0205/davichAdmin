package net.danvi.dmall.front.web.config.exception;

import lombok.extern.slf4j.Slf4j;
import net.danvi.dmall.biz.app.basicinfo.model.BasicInfoVO;
import net.danvi.dmall.biz.app.basicinfo.service.BasicInfoService;
import net.danvi.dmall.biz.system.service.SiteService;
import net.danvi.dmall.front.web.config.view.View;
import org.apache.commons.fileupload.FileUploadBase;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.web.multipart.MaxUploadSizeExceededException;
import org.springframework.web.servlet.HandlerExceptionResolver;
import org.springframework.web.servlet.ModelAndView;
import dmall.framework.common.constants.CommonConstants;
import dmall.framework.common.constants.ExceptionConstants;
import dmall.framework.common.constants.RequestAttributeConstants;
import dmall.framework.common.exception.*;
import dmall.framework.common.model.ResultListModel;
import dmall.framework.common.util.*;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * <pre>
* - 프로젝트명	: 31.front.web
* - 패키지명		: front.web.config.exception
* - 파일명		: FrontWebExceptionResolver.java
* - 작성일		: 2016. 3. 2.
* - 작성자		: snw
* - 설명			:
 * </pre>
 */
@Slf4j
public class FrontWebExceptionResolver implements HandlerExceptionResolver {

    @Autowired
    private MessageSourceAccessor message;

    @Resource(name = "siteService")
    private SiteService siteService;
    @Resource(name = "basicInfoService")
    private BasicInfoService basicInfoService;

    @Override
    public ModelAndView resolveException(HttpServletRequest request, HttpServletResponse response, Object paramObject,
            Exception ex) {

        ModelAndView mav = SiteUtil.getSkinView();

        String exCode = null;
        String msgKey = "exMsg";

        log.error("resolvException : {}", ex);

        if (ex instanceof CustomException) {
            log.debug(">>>>>>>>>>>>> Custom Exception");

            CustomException customEx = (CustomException) ex;
            exCode = customEx.getExCode();
            if (customEx.getArgs() != null) {
                mav.addObject(msgKey, MessageUtil.getMessage(exCode, customEx.getArgs()));
            } else {
                mav.addObject(msgKey, MessageUtil.getMessage(exCode));
            }
        } else if (ex instanceof MaxUploadSizeExceededException
                || ex.getCause() instanceof FileUploadBase.FileSizeLimitExceededException) {
            // 업로드 파일 사이즈 예외
            if (request.getHeader("user-agent").contains("MSIE 8.0")) {
                // IE8 에선 jQuery.form 의 ajaxSubmit() 으로 파일업로드시에 x-requested-with 값이 안 넘어와서 ajax 요청인지 체크할 수 없음
                // 폼서브밋 업로드가 없으니 업로드 파일사이즈 오류 발생시 강제로 jsonview로 만듬
                msgKey = "message";
                mav.addObject(msgKey, "업로드할 수 있는 파일 크기보다 업로드한 파일의 크기가 큽니다.");
                mav.setViewName(View.jsonView());
                mav.addObject("success", false);
                return mav;
            }
            mav.addObject(msgKey, "업로드할 수 있는 파일 크기보다 업로드한 파일의 크기가 큽니다.");
        } else if (ex instanceof AccessDeniedException) {
            mav.setViewName("error/blockedIp");
            return mav;
        } else if (ex instanceof AdultOnlyException) {
            String returnUrl = ((AdultOnlyException) ex).getReturnUrl();
            try {
                returnUrl = UrlUtil.encoder(returnUrl, "UTF-8");
            } catch (Exception e) {
                log.error("리턴 URL 에러 : {}", e.getMessage());
            }
            mav.setViewName("redirect:/front/login/member-login?type=adult&returnUrl=" + returnUrl);
            return mav;
        } else if (ex instanceof SitePrepareException) {
            // 쇼핑몰 생성 중
            log.warn("쇼핑몰 생성중", ex);
            mav.setViewName("error/prepare");
            mav.addObject("msg", ex.getMessage());

            return mav;
        } else if (ex instanceof SiteClosedException) {
            // 정상적인 상태의 쇼핑몰 아님
            log.warn("정상적인 상태의 쇼핑몰 아님", ex);
            mav.setViewName("error/closed");
            mav.addObject("msg", ex.getMessage());

            return mav;
        } else if(ex instanceof SiteNotExistException) {
            // 쇼핑몰 미존재
            log.warn("쇼핑몰 미존재", ex);
            mav.setViewName("error/404p");
            mav.addObject("msg", ex.getMessage());

            return mav;
        } else {
            log.debug(">>>>>>>>>>>>> None Custom Exception");
            exCode = ExceptionConstants.ERROR_CODE_DEFAULT;

        }

        if (HttpUtil.isAjax(request)) {
            log.debug(">>>>>>>>>>>>> Ajax");
            mav.setViewName(CommonConstants.JSON_VIEW_NAME);
        } else {
            log.debug(">>>>>>>>>>>>> None Ajax");
            if (ExceptionConstants.ERROR_CODE_LOGIN_REQUIRED.equals(exCode)) {
                mav.setViewName("redirect:/front/login/member-login");
            } else {
                try {
                    Long siteNo = siteService.getSiteNo(request.getServerName());
                    ResultListModel<BasicInfoVO> result = basicInfoService.selectBasicInfo(siteNo);
                    // 사이트 공통정보
                    request.setAttribute(RequestAttributeConstants.FRONT_SITE_INFO, result.get("site_info"));
                    // 사이트 메뉴정보
                    request.setAttribute(RequestAttributeConstants.FRONT_GNB_INFO, result.get("gnb_info"));
                    request.setAttribute(RequestAttributeConstants.FRONT_LNB_INFO, result.get("lnb_info"));
                    // 무통장 계좌정보
                    request.setAttribute(RequestAttributeConstants.FRONT_NOPB_INFO, result.get("nopb_info"));

                    //구글애널리틱스 ID
                    request.setAttribute("anlsId", result.get("anlsId"));

                } catch (Exception e) {
                    log.error("사이트 정보 조회 에러 : {}", e.getMessage());
                }

                setSkinInfo(request);

                mav.setViewName("error/error");
            }
        }

        mav.addObject("exCode", exCode);
        /*mav.addObject("exMsg", message.getMessage(exCode));*/
        return mav;
    }

    private void setSkinInfo(HttpServletRequest request) {
        String skinId;

        // 스킨 아이디 값을 받았을 경우 처리되는 로직
        // 스킨 아이디가 있을시 처리
        if (request.getParameter(RequestAttributeConstants.SKIN_ID) != null) {
            if ("".equals(request.getParameter(RequestAttributeConstants.SKIN_ID))) {
                // 스킨아이디값을 빈값으로 넘길때 기본화면으로 나오게 처리하는 방식 추가 쿠키값도 삭제함
                skinId = SiteUtil.getDefaultSkinId();
            } else {
                skinId = request.getParameter(RequestAttributeConstants.SKIN_ID);
            }
            // 스킨 아이디가 없을시 기본처리
        } else {
            skinId = SiteUtil.getDefaultSkinId();
            // 스킨 아이디가 없더라도 쿠키정보에 데이터 체크해서 다시 확인하는 처리
            String ss_skinId = "";
            if(SiteUtil.isMobile()){
                ss_skinId=CookieUtil.getCookie(request, "SS_MSKIN_ID");
            }else{
                ss_skinId=CookieUtil.getCookie(request, "SS_SKIN_ID");
            }

            if (ss_skinId != null && !ss_skinId.equals("")) {
                skinId = ss_skinId;
            }
        }


        String skinPath = SiteUtil.getSkinViewPathWithSiteId(skinId);
        request.setAttribute(RequestAttributeConstants.SKIN_PATH, skinPath);
        request.setAttribute(RequestAttributeConstants.SKIN_IMG_PATH, SiteUtil.getSkinImagePath(skinId));
        request.setAttribute(RequestAttributeConstants.SKIN_CSS_PATH, SiteUtil.getSkinCssPath(skinId));
        request.setAttribute(RequestAttributeConstants.SKIN_JS_PATH, SiteUtil.getSkinScriptPath(skinId));
        request.setAttribute(RequestAttributeConstants.SKIN_VIEW_PATH, SiteUtil.getSkinViewPath(skinId));
    }


}
