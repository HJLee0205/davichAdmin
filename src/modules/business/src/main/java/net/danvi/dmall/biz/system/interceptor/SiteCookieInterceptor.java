package net.danvi.dmall.biz.system.interceptor;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.danvi.dmall.biz.system.security.Session;
import net.danvi.dmall.biz.system.security.SessionDetailHelper;
import net.danvi.dmall.biz.system.security.DmallSessionDetails;
import net.danvi.dmall.biz.system.service.SiteService;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import lombok.extern.slf4j.Slf4j;
import net.danvi.dmall.biz.system.model.SiteCacheVO;
import dmall.framework.common.constants.CommonConstants;
import dmall.framework.common.util.CookieUtil;

@Slf4j
public class SiteCookieInterceptor extends HandlerInterceptorAdapter {

    @Resource(name = "siteService")
    private SiteService siteService;

    @Override
    public boolean preHandle(HttpServletRequest httpServletRequest, HttpServletResponse httpServletResponse, Object o)
            throws Exception {

        if (!CookieUtil.existCookie(httpServletRequest, CommonConstants.LOGIN_COOKIE_NAME)) {
            log.debug("로그인 쿠키 없음");
            // 로그인 쿠키가 없으면 게스트 쿠키 생성
            setGeustCookie(httpServletRequest);
        } else {
            // 쿠키는 있지만 게스트 쿠키면 재생성
            DmallSessionDetails detail = SessionDetailHelper.getDetails();

            if (detail == null || !detail.isLogin()) {
                log.debug("게스트 쿠키 재생성");
                setGeustCookie(httpServletRequest);
            }
        }

        return super.preHandle(httpServletRequest, httpServletResponse, o);
    }

    /**
     * <pre>
     * 작성일 : 2016. 6. 3.
     * 작성자 : dong
     * 설명   : 게스트(비회원 또는 비로그인) 쿠키 생성
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 3. dong - 최초생성
     * </pre>
     *
     * @param httpServletRequest
     * @throws Exception
     */
    protected void setGeustCookie(HttpServletRequest httpServletRequest) throws Exception {
        Session s = new Session();
        s.setServerName(httpServletRequest.getServerName());

        Long siteNo = siteService.getSiteNo(httpServletRequest.getServerName());
        s.setSiteNo(siteNo);
        DmallSessionDetails details = new DmallSessionDetails("", "", s, null);
        details.setSiteNo(siteNo);
        SiteCacheVO siteCacheVO = siteService.getSiteInfo(siteNo);

        if(siteCacheVO.getAutoLogoutTime() == 0) {
            // 자동로그아웃 미설정 시는 1년
            SessionDetailHelper.setDetailsToCookie(details, 365 * 24 * 60 * 60);
        } else {
            SessionDetailHelper.setDetailsToCookie(details, siteCacheVO.getAutoLogoutTime() * 60);
        }
    }

    /**
     * <pre>
     * 작성일 : 2016. 6. 3.
     * 작성자 : dong
     * 설명   :
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 3. dong - 최초생성
     * </pre>
     *
     * @param details
     * @throws Exception
     */
//    protected void setDetailsToCookie(DmallSessionDetails details, int maxAge) throws Exception {
//        String cookieValue = JsonMapperUtil.getMapper().writeValueAsString(details);
//        CookieUtil.addEncodedCookie(CommonConstants.LOGIN_COOKIE_NAME, cookieValue, maxAge);
//        // 스프링 시큐리티에 인증정보 추가
//        UsernamePasswordAuthenticationToken auth = new UsernamePasswordAuthenticationToken(details.getUsername(),
//                details.getPassword(), details.getAuthorities());
//        auth.setDetails(details);
//        SecurityContextHolder.getContext().setAuthentication(auth);
//    }
}