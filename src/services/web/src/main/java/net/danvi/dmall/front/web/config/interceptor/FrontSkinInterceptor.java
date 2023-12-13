package net.danvi.dmall.front.web.config.interceptor;

import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.danvi.dmall.biz.system.service.SiteService;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import eu.bitwalker.useragentutils.DeviceType;
import eu.bitwalker.useragentutils.UserAgent;
import lombok.extern.slf4j.Slf4j;
import net.danvi.dmall.biz.app.design.model.SkinVO;
import net.danvi.dmall.biz.app.design.service.SkinConfigService;
import net.danvi.dmall.biz.system.model.SiteCacheVO;
import dmall.framework.common.constants.RequestAttributeConstants;
import dmall.framework.common.util.CookieUtil;
import dmall.framework.common.util.SiteUtil;

/**
 * 상점벌 화면으로 이동
 * Created by dong on 2016-03-14.
 */
@Slf4j
public class FrontSkinInterceptor extends HandlerInterceptorAdapter {

    @Resource(name = "siteService")
    private SiteService siteService;

    @Resource(name = "skinConfigService")
    private SkinConfigService skinConfigService;

    @Override
    public boolean preHandle(HttpServletRequest httpServletRequest, HttpServletResponse httpServletResponse, Object o)
            throws Exception {
        log.debug("URL : {}", httpServletRequest.getRequestURL());
        if(SiteUtil.isMobile()){
            httpServletRequest.setAttribute("_MOBILE_PATH", "/m");
        }
        String skinId = getSkinId(httpServletRequest);

        // 2. 쿠키 사용 방법 - 세션이 안되어서 쿠키로 변경
        if (skinId != null && (httpServletRequest.getRequestURL().indexOf("main-view") > 0 || httpServletRequest.getRequestURL().indexOf("main-intro") > 0 )) {
            if(SiteUtil.isMobile()){
                CookieUtil.addCookie(httpServletResponse, "SS_MSKIN_ID", skinId);
            }else {
                CookieUtil.addCookie(httpServletResponse, "SS_SKIN_ID", skinId);
            }
        }

        // 스킨 아이디가 없더라도 쿠키정보에 데이터 체크해서 다시 확인하는 처리
        String ss_skinId =CookieUtil.getCookie(httpServletRequest, "SS_SKIN_ID");

        if(SiteUtil.isMobile()){
            ss_skinId = CookieUtil.getCookie(httpServletRequest, "SS_MSKIN_ID");
        }

        if (skinId == null && ss_skinId != null && !ss_skinId.equals("")) {
            skinId = ss_skinId;
        }

        // 3. 스킨아이디값을 빈값으로 넘길때 기본화면으로 나오게 처리하는 방식 추가 쿠키값도 삭제함
        if (skinId != null && skinId.equals("") && (httpServletRequest.getRequestURL().indexOf("main-view") > 0 || httpServletRequest.getRequestURL().indexOf("main-intro") > 0 )) {
            // 스킨아이디 값을 넘기는데 아무조건도 없이 넘길때 화면 처리방식
            if(SiteUtil.isMobile()){
                CookieUtil.removeCookie(httpServletRequest, httpServletResponse, "SS_MSKIN_ID");
            }else{
                CookieUtil.removeCookie(httpServletRequest, httpServletResponse, "SS_SKIN_ID");
            }


            skinId = null;
        }

        log.debug("스킨 ID  : {}", skinId);

        String skinPath = SiteUtil.getSkinViewPathWithSiteId(skinId);

        if (skinId != null) {
            httpServletRequest.setAttribute(RequestAttributeConstants.SKIN_ID, skinId);
            skinPath = SiteUtil.getSkinPath(skinId);
            setSkinNoToRequest(httpServletRequest, skinId);
        } else {
            setSkinNoToRequest(httpServletRequest);
        }

        log.debug("skinPath : {}", skinPath);
        // 상점과 스킨명으로 뷰네임 설정, 오류시에는 이 데이터를 통해 스킨 화면이 출력됨
        setSkinInfo(httpServletRequest, skinPath, skinId);

        httpServletRequest.setAttribute(RequestAttributeConstants.SITE_ID, SiteUtil.getSiteId());

        return super.preHandle(httpServletRequest, httpServletResponse, o);
    }

    /**
     * <pre>
     * 작성일 : 2016. 7. 18.
     * 작성자 : dong
     * 설명   : 
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 7. 18. dong - 최초생성
     * </pre>
     *
     * @param httpServletRequest
     * @param skinId
     */
    private void setSkinNoToRequest(HttpServletRequest httpServletRequest, String skinId) {
        SkinVO vo = new SkinVO();
        vo.setSiteNo(siteService.getSiteNo(httpServletRequest));
        vo.setSkinId(skinId);
        Integer skinNo = skinConfigService.getSkinNoBySkinId(vo);
        httpServletRequest.setAttribute(RequestAttributeConstants.SKIN_NO, skinNo);
    }

    /**
     * <pre>
     * 작성일 : 2016. 7. 18.
     * 작성자 : dong
     * 설명   : HttpServletRequest 에 접속 기기별로 (적용)스킨 번호를 세팅한다.
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 7. 18. dong - 최초생성
     * </pre>
     *
     * @param httpServletRequest
     */
    private void setSkinNoToRequest(HttpServletRequest httpServletRequest) {
        Long siteNo = siteService.getSiteNo(httpServletRequest);
        SiteCacheVO siteCacheVO = siteService.getSiteInfo(siteNo);

        UserAgent ua = UserAgent.parseUserAgentString(httpServletRequest.getHeader("User-Agent"));

        if (ua.getOperatingSystem().getDeviceType() == DeviceType.COMPUTER) {
            httpServletRequest.setAttribute(RequestAttributeConstants.SKIN_NO, siteCacheVO.getPcSkinNo());
        }else if (ua.getOperatingSystem().getDeviceType() == DeviceType.UNKNOWN) {
            httpServletRequest.setAttribute(RequestAttributeConstants.SKIN_NO, siteCacheVO.getPcSkinNo());
        } else {
            httpServletRequest.setAttribute(RequestAttributeConstants.SKIN_NO, siteCacheVO.getMobileSkinNo());
        }
    }

    @Override
    public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler,
            ModelAndView modelAndView) throws Exception {

        String skinId;
        String skinPath;

        // 스킨 아이디 값을 받았을 경우 처리되는 로직
        // 스킨 아이디가 잇을시 처리
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
            String ss_skinId = CookieUtil.getCookie(request, "SS_SKIN_ID");
            if(SiteUtil.isMobile()) {
             ss_skinId = CookieUtil.getCookie(request, "SS_MSKIN_ID");
            }

            if (ss_skinId != null && !ss_skinId.equals("")) {
                skinId = ss_skinId;
            }
        }

        if (modelAndView != null) {
            Map<String, Object> model = modelAndView.getModel();

            // 모델에 스킨뷰라고 설정되어 있고
            if (model.containsKey(RequestAttributeConstants.SKIN_VIEW)) {

                // 기본 스킨ID(default)가 아니면 모델의 스킨ID로
                if (SiteUtil.getDefaultSkinId().equals(skinId)) {
                    skinId = (String) model.get(RequestAttributeConstants.SKIN_ID);
                }

                // 상점과 스킨명으로 뷰네임 설정
                modelAndView.setViewName(SiteUtil.getViewNameByStoreId(skinId, modelAndView));
            }

            log.debug("viewName : {}", modelAndView.getViewName());
        }

        skinPath = SiteUtil.getSkinViewPathWithSiteId(skinId);

        log.debug("skinPath : {}", skinPath);
        // 스킨 정보 설정
        setSkinInfo(request, skinPath, skinId);

        super.postHandle(request, response, handler, modelAndView);
    }

    private String getSkinId(HttpServletRequest request) {
        // 파라미터에 스킨ID가 설정되어 있으면 모델의 스킨ID로
        String skinId = request.getParameter(RequestAttributeConstants.SKIN_ID);

        return skinId;
    }

    /**
     * 스킨 정보 설정
     * 
     * @param request
     * @param skinPath
     * @param skinId
     */
    private void setSkinInfo(HttpServletRequest request, String skinPath, String skinId) {
        request.setAttribute(RequestAttributeConstants.SKIN_PATH, skinPath);
        request.setAttribute(RequestAttributeConstants.SKIN_IMG_PATH, SiteUtil.getSkinImagePath(skinId));
        request.setAttribute(RequestAttributeConstants.SKIN_CSS_PATH, SiteUtil.getSkinCssPath(skinId));
        request.setAttribute(RequestAttributeConstants.SKIN_JS_PATH, SiteUtil.getSkinScriptPath(skinId));
        request.setAttribute(RequestAttributeConstants.SKIN_VIEW_PATH, SiteUtil.getSkinViewPath(skinId));
        log.debug("SKIN INFO : {} - {}, {}, {}, {}", skinPath, SiteUtil.getSkinViewPath(skinId),
                SiteUtil.getSkinImagePath(skinId), SiteUtil.getSkinCssPath(skinId), SiteUtil.getSkinScriptPath(skinId));
    }
}