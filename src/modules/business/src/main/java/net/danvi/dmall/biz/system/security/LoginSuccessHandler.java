package net.danvi.dmall.biz.system.security;

import java.io.IOException;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import dmall.framework.common.util.*;
import net.danvi.dmall.biz.system.util.InterfaceUtil;
import org.springframework.security.core.Authentication;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;

import dmall.framework.admin.constants.AdminConstants;
import dmall.framework.common.constants.CommonConstants;
import lombok.extern.slf4j.Slf4j;
import net.danvi.dmall.biz.app.member.manage.model.MemberManagePO;
import net.danvi.dmall.biz.app.member.manage.service.FrontMemberService;
import net.danvi.dmall.biz.system.login.model.MemberLoginHistPO;
import net.danvi.dmall.biz.system.login.service.LoginService;
import net.danvi.dmall.biz.system.model.AppLogPO;
import net.danvi.dmall.biz.system.util.JsonMapperUtil;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 6. 2.
 * 작성자     : dong
 * 설명       : 로그인 성공 핸들러
 * </pre>
 */
@Slf4j
public abstract class LoginSuccessHandler implements AuthenticationSuccessHandler {

    protected final String DMALL_LOGIN_MSG = "_DMALL_LOGIN_MSG";
    protected final String DMALL_LOGIN_RETURN_URL = "_DMALL_LOGIN_RETURN_URL";

    @Resource(name = "loginService")
    private LoginService loginService;
    
    @Resource(name = "frontMemberService")
    private FrontMemberService frontMemberService;

    private String returnUrl;

    public void setReturnUrl(String returnUrl) {
        this.returnUrl = returnUrl;
    }

    /**
     * 로그인 성공시 처리
     * 
     * @param request
     * @param response
     * @param authentication
     * @throws IOException
     * @throws ServletException
     */
    public void onAuthenticationSuccess(HttpServletRequest request, HttpServletResponse response,
            Authentication authentication) throws IOException, ServletException {

        log.debug("request : {}", request);
        log.debug("response : {}", response);
        log.debug("authentication : {}", authentication);
        
        String resultMsg = null;
        String childReturnUrl = null;
        String returnUrl = request.getParameter("returnUrl");
        if (request.getAttribute(DMALL_LOGIN_MSG) != null) {
            resultMsg = request.getAttribute(DMALL_LOGIN_MSG).toString();
            request.removeAttribute(DMALL_LOGIN_MSG);
        }

        if (request.getAttribute(DMALL_LOGIN_RETURN_URL) != null) {
            childReturnUrl = request.getAttribute(DMALL_LOGIN_RETURN_URL).toString();
            request.removeAttribute(DMALL_LOGIN_RETURN_URL);
        }

        if (returnUrl == null || returnUrl.trim().equals("")) {
            returnUrl = this.returnUrl;
        } else {
            try {
                returnUrl = UrlUtil.decoder(returnUrl, "UTF-8");
            } catch (Exception e) {
                log.error("returnUrl 디코드 오류", e);
            }
        }
        
        ObjectMapper mapper = new ObjectMapper();
        Map<String, Object> m = new HashMap<>();
        m.put(AdminConstants.CONTROLLER_RESULT_CODE, AdminConstants.CONTROLLER_RESULT_CODE_SUCCESS);
        m.put("returnUrl", childReturnUrl != null ? childReturnUrl : returnUrl);
        String refererType = request.getParameter("refererType");
        m.put("refererType", refererType);
        if (resultMsg != null) m.put("resultMsg", resultMsg);

        DmallSessionDetails details = (DmallSessionDetails) authentication.getDetails();
        Session session = details.getSession();
        MemberLoginHistPO memberLoginHistPO = new MemberLoginHistPO();
        memberLoginHistPO.setSiteNo(details.getSiteNo());
        memberLoginHistPO.setMemberNo(session.getMemberNo());
        memberLoginHistPO.setRegrNo(session.getMemberNo());
        memberLoginHistPO.setLoginIp(HttpUtil.getClientIp(request));

        if ("Y".equals(session.getSellerLoginYn())) {
            m.put("returnUrl", "/admin/seller/main/main-view");
        } else {
            loginService.insertLoginHistory(memberLoginHistPO);
        }
        
        // 로그인된 경우 로그인 쿠키 추가
        if (details.isLogin()) {
        	
            log.debug("로그인 쿠키 추가");
            String cookieValue = null;

            try {
                session.setServerName(request.getServerName());
                details.setSession(session);
                cookieValue = JsonMapperUtil.getMapper().writeValueAsString(details);
            } catch (JsonProcessingException e) {
                log.error("로그인 쿠키 생성 오류", e);
            }

            try {
                AppLogPO app = new AppLogPO();
                String jsessionid = request.getSession().getId();
                app.setMemberNo(details.getSession().getMemberNo());
                app.setJsessionid(jsessionid);
                app.setLoginId(details.getSession().getLoginId());
                app.setCookieVal(CryptoUtil.encryptAES(cookieValue));
            	
            	// 자동로그인이 체크가 되었을경우
            	if (request.getParameter("auto_login") != null && "Y".equals(request.getParameter("auto_login"))) {
                    response.addCookie(CookieUtil.createEncodedCookie(CommonConstants.LOGIN_COOKIE_NAME, cookieValue, 365 * 24 * 60 * 60));
                    
                    MemberManagePO po = new MemberManagePO(); 
                    po.setAutoLoginGb("1");
                    po.setMemberNo(session.getMemberNo());
                    po.setSiteNo(details.getSiteNo());
                    frontMemberService.updateAppInfoCollect(po);
                	// 로그인 - 세션정보 DB저장
                    app.setExpireTime( new Date( System.currentTimeMillis() + ( 1000L * 60L * 60L * 365 * 24)));
            	} else {
                    MemberManagePO po = new MemberManagePO(); 
                    po.setAutoLoginGb("0");
                    po.setMemberNo(session.getMemberNo());
                    po.setSiteNo(details.getSiteNo());
                    frontMemberService.updateAppInfoCollect(po);
            		
                    if (getCookieExpireTime(details.getSiteNo()) == -1) {
                        app.setExpireTime( new Date( System.currentTimeMillis() + ( 1000L * 60L * 60L * 365 * 24)));
                    } else {
                        app.setExpireTime( new Date( System.currentTimeMillis() + ( 1000L * getCookieExpireTime(details.getSiteNo()))));
                    }
                    response.addCookie(CookieUtil.createEncodedCookie(CommonConstants.LOGIN_COOKIE_NAME, cookieValue,getCookieExpireTime(details.getSiteNo())));
            	}

                if (SiteUtil.isMobile(request)) {
                	// 자동로그인이 체크가 되었을경우
                	/*if (request.getParameter("auto_login") != null && "Y".equals(request.getParameter("auto_login"))) {
                    	CookieUtil.addCookie(response,CommonConstants.JDSESSION_ID_COOKIE_NAME, jsessionid,365 * 24 * 60 * 60);                	
                	} else {
                    	CookieUtil.addCookie(response,CommonConstants.JDSESSION_ID_COOKIE_NAME, jsessionid,getCookieExpireTime(details.getSiteNo()));                	
                	}*/
                	frontMemberService.insertAppLoginInfo(app);
                }

               /* Map<String, Object> param = new HashMap<>();
                param.put("memNo", session.getMemberNo());

                Map<String, Object> result = InterfaceUtil.send("IF_MEM_022", param);
                if ("1".equals(result.get("result"))) {
                }else{
                    //처리결과가 어떻든 진행하도록...
                    //throw new Exception(String.valueOf(result.get("message")));
                }*/
            	
            } catch (Exception e) {
                log.error("로그인 쿠키 추가 오류", e);
            }
        }

        response.setCharacterEncoding("UTF-8");
        response.getWriter().write(mapper.writeValueAsString(m));
        response.getWriter().flush();
    }

    /**
     * <pre>
     * 작성일 : 2016. 6. 2.
     * 작성자 : dong
     * 설명   : 쿠키 만료시간 설정
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 2. dong - 최초생성
     * </pre>
     *
     * @param siteNo
     * @return
     * @throws Exception
     */
    protected abstract int getCookieExpireTime(Long siteNo) throws Exception;

}
