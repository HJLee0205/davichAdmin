package net.danvi.dmall.biz.system.security;

import java.io.IOException;
import java.net.URLDecoder;

import javax.annotation.Resource;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import dmall.framework.common.util.SiteUtil;
import org.springframework.beans.factory.InitializingBean;
import org.springframework.security.authentication.AnonymousAuthenticationToken;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContext;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.web.context.HttpRequestResponseHolder;
import org.springframework.security.web.context.SaveContextOnUpdateOrErrorResponseWrapper;
import org.springframework.security.web.context.SecurityContextRepository;

import dmall.framework.common.constants.CommonConstants;
import dmall.framework.common.util.CookieUtil;
import dmall.framework.common.util.CryptoUtil;
import lombok.extern.slf4j.Slf4j;
import net.danvi.dmall.biz.app.member.manage.service.FrontMemberService;
import net.danvi.dmall.biz.system.model.AppLogPO;
import net.danvi.dmall.biz.system.service.SiteService;
import net.danvi.dmall.biz.system.util.JsonMapperUtil;

/**
 * Created by dong on 2016-04-04.
 */
@Slf4j
public class CookieSecurityContextRepository implements SecurityContextRepository, InitializingBean {

    private boolean disableUrlRewriting = false;
    private String cookieKey;
    
    @Resource(name = "frontMemberService")
    private FrontMemberService frontMemberService;
    
    @Resource(name = "siteService")
    private SiteService siteService;

    public SecurityContext loadContext(HttpRequestResponseHolder requestResponseHolder) {
        HttpServletRequest request = requestResponseHolder.getRequest();
        HttpServletResponse response = requestResponseHolder.getResponse();
        SecurityContext context = null;
        
        log.debug("로그인 세션 정보 조회");
        /*if (SiteUtil.isMobile(request)) {
            context = resolveContextFromRequestDB(request);
        } else {
            context = resolveContextFromRequest(request);
        }*/
        context = resolveContextFromRequest(request);

        if (context == null) {
            context = generateNewContext();
            // requestResponseHolder.setResponse(new SaveToCookieResponseWrapper(response, false));
        }

        return context;
    }

    public void saveContext(SecurityContext context, HttpServletRequest request, HttpServletResponse response) {
        // log.debug("saveContext : {}", context);
    }

    public boolean containsContext(HttpServletRequest request) {
        return resolveContextFromRequest(request) != null;
    }

    protected SecurityContext resolveContextFromRequest(HttpServletRequest request) {

        SecurityContext context = null;

        Cookie cookie = null;

        try {
            cookie = CookieUtil.getDecodedCookieByName(request, CommonConstants.LOGIN_COOKIE_NAME);
        } catch (Exception e) {
            log.error("로그인 쿠키 정보를 얻지 못함.", e);
        }

        if (cookie != null) {
            DmallSessionDetails details = null;

            try {
                details = JsonMapperUtil.getMapper().readValue(cookie.getValue(), DmallSessionDetails.class);
                log.debug("detils:{}", details);

                UsernamePasswordAuthenticationToken auth = new UsernamePasswordAuthenticationToken(details.getUsername(), details.getPassword(), details.getAuthorities());
                auth.setDetails(details);
                // TODO validate token

                context = SecurityContextHolder.getContext();
                if (context == null) {
                    context = generateNewContext();
                }

//                log.debug("시큐리티 컨텍스트에 로그인 세션 정보 세팅");
                context.setAuthentication(auth);
                SecurityContextHolder.setContext(context);
            } catch (IOException e) {
                log.debug("로그인 세션 정보 획득 오류", e);
                return null;
            }
        }

//        log.debug("context:{}", context);

         return context;
    }
    

    protected SecurityContext resolveContextFromRequestDB(HttpServletRequest request) {

        SecurityContext context = null;
    	String loginId =  "";
    	String jds = "";
    	try {
    		//loginId = CookieUtil.getCookie(request, "dmld");
    		jds = CookieUtil.getCookie(request, "jdsc");
    	} catch (Exception e) {
    	}
    			
    	AppLogPO po = new AppLogPO(); 
    	po.setLoginId(loginId);
    	po.setJsessionid(jds);
    	AppLogPO rst = frontMemberService.selectAppLoginInfo(po);
    	
    	String cookieValue = "";

        if (rst != null ) {
        	try {
        		cookieValue = CryptoUtil.decryptAES(rst.getCookieVal());
        	} catch (Exception e) {

        	}
        }

        try {
        	
        	if (!"".equals(cookieValue)) {
        		
                DmallSessionDetails details = null;
        		details = JsonMapperUtil.getMapper().readValue(cookieValue, DmallSessionDetails.class);

	            UsernamePasswordAuthenticationToken auth = new UsernamePasswordAuthenticationToken(details.getUsername(), details.getPassword(), details.getAuthorities());
	            auth.setDetails(details);
	            
                context = SecurityContextHolder.getContext();
                if (context == null) {
                    context = generateNewContext();
                }
                
	            context.setAuthentication(auth);
	            SecurityContextHolder.setContext(context);
        	} else {
                Session s = new Session();
                s.setServerName(request.getServerName());
                Long siteNo = 1L;
                try {
                  siteNo = siteService.getSiteNo(request.getServerName());
                } catch (Exception e) {
                }
                s.setSiteNo(siteNo);
                DmallSessionDetails details = new DmallSessionDetails(loginId, "", s, null);
                details.setSiteNo(siteNo);
	            UsernamePasswordAuthenticationToken auth = new UsernamePasswordAuthenticationToken(null, null, null);
	            auth.setDetails(details);
	            
                context = SecurityContextHolder.getContext();
                if (context == null) {
                    context = generateNewContext();
                }	            
	            context.setAuthentication(auth);
	            SecurityContextHolder.setContext(context);
        	}

            log.debug("시큐리티 컨텍스트에 로그인 세션 정보 세팅");
        } catch (IOException e) {
            log.debug("로그인 세션 정보 획득 오류", e);
            return null;
        }

        log.debug("context:{}", context);

         return context;
    }    
    

    SecurityContext generateNewContext() {
        log.debug("신규 Context 생성");
        return SecurityContextHolder.createEmptyContext();
    }

    /**
     * Allows the use of session identifiers in URLs to be disabled. Off by
     * default.
     *
     * @param disableUrlRewriting
     *            set to <tt>true</tt> to disable URL encoding methods in the
     *            response wrapper and prevent the use of <tt>jsessionid</tt>
     *            parameters.
     */
    public void setDisableUrlRewriting(boolean disableUrlRewriting) {
        this.disableUrlRewriting = disableUrlRewriting;
    }

    public String getCookieKey() {
        return cookieKey;
    }

    public void setCookieKey(String cookieKey) {
        this.cookieKey = cookieKey;
    }

    @Override
    public void afterPropertiesSet() throws Exception {

    }

    // ~ Inner Classes
    // ==================================================================================================

    final class SaveToCookieResponseWrapper extends SaveContextOnUpdateOrErrorResponseWrapper {

        public SaveToCookieResponseWrapper(HttpServletResponse response, boolean disableUrlRewriting) {
            super(response, disableUrlRewriting);
        }

        @Override
        protected void saveContext(SecurityContext context) {
            final Authentication authentication = context.getAuthentication();

            if (authentication == null || !authentication.isAuthenticated()) {
                log.debug("+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++");
                log.debug("SecurityContext is empty or anonymous - context will not be stored.");
                log.debug("+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++");
                return;
            }

            if (authentication instanceof AnonymousAuthenticationToken) {
                log.debug("+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++");
                log.debug("SecurityContext is empty or anonymous");
                log.debug("+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++");
                return;
            }
            if (!(authentication.getDetails() instanceof DmallSessionDetails)) {
                return;
            }

            log.debug("+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++");
            log.debug("authentication2 : {}", authentication);
            log.debug("+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++");

            // DmallSessionDetails ud = (DmallSessionDetails) authentication.getDetails();
            //
            // String cookieValue = null;
            // try {
            // cookieValue = JsonMapperUtil.getMapper().writeValueAsString(ud);
            // } catch (JsonProcessingException e) {
            // e.printStackTrace();
            // }
            //
            // addCookie(CookieUtil.createEncodedCookie(CommonConstants.LOGIN_COOKIE_NAME, cookieValue));
        }
    }
}
