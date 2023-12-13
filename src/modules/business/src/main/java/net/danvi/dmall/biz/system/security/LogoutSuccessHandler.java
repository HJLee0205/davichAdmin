package net.danvi.dmall.biz.system.security;

import java.io.IOException;
import java.net.URLDecoder;

import javax.annotation.Resource;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import dmall.framework.common.util.SiteUtil;
import org.springframework.security.core.Authentication;
import org.springframework.security.web.authentication.logout.SimpleUrlLogoutSuccessHandler;

import dmall.framework.common.constants.CommonConstants;
import dmall.framework.common.util.CookieUtil;
import dmall.framework.common.util.CryptoUtil;
import lombok.extern.slf4j.Slf4j;
import net.danvi.dmall.biz.app.member.manage.service.FrontMemberService;
import net.danvi.dmall.biz.system.model.AppLogPO;
import net.danvi.dmall.biz.system.model.SiteCacheVO;
import net.danvi.dmall.biz.system.service.SiteService;
import net.danvi.dmall.biz.system.util.JsonMapperUtil;

/**
 * Created by dong on 2016-04-04.
 */
@Slf4j
public class LogoutSuccessHandler extends SimpleUrlLogoutSuccessHandler {

    @Resource(name = "siteService")
    private SiteService siteService;
    
    @Resource(name = "frontMemberService")
    private FrontMemberService frontMemberService;

    @Override
    public void onLogoutSuccess(HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws IOException, ServletException {

        // 게스트 쿠키 세팅
        Session s = new Session();
        s.setServerName(request.getServerName());

        Long siteNo = siteService.getSiteNo(request);
        s.setSiteNo(siteNo);
        DmallSessionDetails details = new DmallSessionDetails("", "", s, null);
        details.setSiteNo(siteNo);
        SiteCacheVO siteCacheVO = siteService.getSiteInfo(siteNo);
        String cookieValue = JsonMapperUtil.getMapper().writeValueAsString(details);

        try {
            if(siteCacheVO.getAutoLogoutTime() == 0) {
                response.addCookie(CookieUtil.createEncodedCookie(CommonConstants.LOGIN_COOKIE_NAME, cookieValue, 365 * 24 * 60 * 60));
            } else {
                response.addCookie(CookieUtil.createEncodedCookie(CommonConstants.LOGIN_COOKIE_NAME, cookieValue, siteCacheVO.getAutoLogoutTime() * 60));
            }
            
        } catch (Exception e) {
            log.error("사용자 정보 쿠키 생성 오류", e);
        }
        
       /* if (SiteUtil.isMobile(request)) {
	    	// 로그아웃시 DB 세션삭제
	    	String loginId =  "";
	    	String jds = "";
	    	try {
	    		loginId = CookieUtil.getCookie(request, "dmld");
	    		jds = CookieUtil.getCookie(request, CommonConstants.JDSESSION_ID_COOKIE_NAME);
	    	} catch (Exception e) {
	    	}
	    	
	    	AppLogPO app = new AppLogPO();
	        app.setLoginId(loginId);
	        app.setJsessionid(jds);
	        
	        try {
                String jsessionid = request.getSession().getId();
            	CookieUtil.addCookie(response,CommonConstants.JDSESSION_ID_COOKIE_NAME, jsessionid,getCookieExpireTime(details.getSiteNo()));                	
	        	frontMemberService.deleteAppLoginInfo(app);
	        } catch(Exception e) {
	        }
        }*/

        super.onLogoutSuccess(request, response, authentication);
    }
    
    protected int getCookieExpireTime(Long siteNo) throws Exception {
        SiteCacheVO vo = siteService.getSiteInfo(siteNo);

        if (vo.getAutoLogoutTime() == 0) {
            return -1;
        } else {
            return vo.getAutoLogoutTime() * 60;
        }
    }
    
    
    
}
