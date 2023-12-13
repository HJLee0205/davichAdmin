package net.danvi.dmall.biz.system.security;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.security.core.AuthenticationException;
import org.springframework.security.web.authentication.AuthenticationFailureHandler;

import com.fasterxml.jackson.databind.ObjectMapper;

import dmall.framework.admin.constants.AdminConstants;
import dmall.framework.common.exception.DormantAccountException;
import dmall.framework.common.exception.LockedAccountException;
import dmall.framework.common.exception.LoginCaptchaException;
import dmall.framework.common.exception.SessionExpiredException;
import dmall.framework.common.exception.WithdrawalAccountException;
import dmall.framework.common.util.HttpUtil;
import dmall.framework.common.util.SiteUtil;

/**
 * Created by dong on 2016-05-27.
 */
public class LoginFailureHandler implements AuthenticationFailureHandler {

    private String failUrl;

    @Override
    public void onAuthenticationFailure(HttpServletRequest httpServletRequest, HttpServletResponse httpServletResponse,
            AuthenticationException e) throws IOException, ServletException {

        if (HttpUtil.isAjax(httpServletRequest)) {
            ObjectMapper om = new ObjectMapper();
            Map<String, String> m = new HashMap<>();
            m.put(AdminConstants.CONTROLLER_RESULT_CODE, AdminConstants.CONTROLLER_RESULT_CODE_FAIL);
            m.put("exCode", AdminConstants.CONTROLLER_RESULT_CODE_FAIL);

            if (e instanceof LockedAccountException) {
                m.put("exCode", "L");
                m.put("exMsg", "비밀번호가 틀렸습니다. ");
            } else if (e instanceof LoginCaptchaException) {
                m.put("exCode", "L");
                m.put("exMsg", "자동 입력 방지를 올바르게 입력하셨는지 확인 바랍니다.");
            } else if (e instanceof DormantAccountException) {
                // 휴면회원
                m.put("exCode", "INACTIVE");
                if(SiteUtil.isMobile()){
                    m.put("redirectUrl", "/m/front/login/inactive-member-view");
                }else{
                    m.put("redirectUrl", "/front/login/inactive-member-view");
                }
                
            } else if (e instanceof WithdrawalAccountException) {
                // 탈퇴회원
            } else if (e instanceof SessionExpiredException) {
            } else {
                m.put("exMsg", e.getMessage());
            }

            httpServletResponse.setCharacterEncoding("UTF-8");
            httpServletResponse.getWriter().write(om.writeValueAsString(m));
            httpServletResponse.getWriter().flush();
        } else {
            throw e;
        }
    }
}
