package net.danvi.dmall.front.web.config.interceptor;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import lombok.extern.slf4j.Slf4j;
import net.danvi.dmall.biz.system.interceptor.SiteCookieInterceptor;
import net.danvi.dmall.biz.system.model.SiteCacheVO;
import net.danvi.dmall.biz.system.security.Session;
import net.danvi.dmall.biz.system.security.SessionDetailHelper;
import net.danvi.dmall.biz.system.security.DmallSessionDetails;
import net.danvi.dmall.biz.system.service.SiteService;

@Slf4j
public class FrontSiteCookieInterceptor extends SiteCookieInterceptor {

    @Resource(name = "siteService")
    private SiteService siteService;

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
    @Override
    protected void setGeustCookie(HttpServletRequest httpServletRequest) throws Exception {
        Session s = new Session();
        s.setServerName(httpServletRequest.getServerName());

        Long siteNo = siteService.getSiteNo(httpServletRequest.getServerName());
        s.setSiteNo(siteNo);
        DmallSessionDetails details = new DmallSessionDetails("", "", s, null);
        details.setSiteNo(siteNo);
        SiteCacheVO siteCacheVO = siteService.getSiteInfo(siteNo);

        if(siteCacheVO.getAutoLogoutTime() == 0) {
            // 자동로그아웃 미설정 시는 세션 쿠키
            SessionDetailHelper.setDetailsToCookie(details, -1);
        } else {
            SessionDetailHelper.setDetailsToCookie(details, siteCacheVO.getAutoLogoutTime() * 60);
        }
    }
}