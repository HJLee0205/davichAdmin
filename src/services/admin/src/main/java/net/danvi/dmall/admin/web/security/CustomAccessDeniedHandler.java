package net.danvi.dmall.admin.web.security;

import java.io.IOException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.web.access.AccessDeniedHandler;
import org.springframework.security.web.csrf.InvalidCsrfTokenException;

import dmall.framework.common.util.HttpUtil;

/**
 * <pre>
 * 프로젝트명 : 41.admin.web
 * 작성일     : 2016. 4. 15.
 * 작성자     : dong
 * 설명       : 사용자 정의 접근 거절 핸들러
 * </pre>
 */
public class CustomAccessDeniedHandler implements AccessDeniedHandler {
    private String errorPage;

    public CustomAccessDeniedHandler() {
    }

    @Override
    public void handle(HttpServletRequest request, HttpServletResponse response, AccessDeniedException e)
            throws IOException, ServletException {
        if (e instanceof InvalidCsrfTokenException) {

        } else {
            // 상황에 따라 접근 거절 페이지 정의
            if (!response.isCommitted()) {
                if (this.errorPage != null) {
                    request.setAttribute("SPRING_SECURITY_403_EXCEPTION", e);
                    response.setStatus(403);
                    if (HttpUtil.isAjax(request)) {
                        response.sendError(403, e.getMessage());
                    } else {
                        RequestDispatcher dispatcher = request.getRequestDispatcher(this.errorPage);
                        dispatcher.forward(request, response);
                    }
                } else {
                    response.sendError(403, e.getMessage());
                }
            }
        }
    }

    public void setErrorPage(String errorPage) {
        if (errorPage != null && !errorPage.startsWith("/")) {
            throw new IllegalArgumentException("errorPage must begin with \'/\'");
        } else {
            this.errorPage = errorPage;
        }
    }
}
