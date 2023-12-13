package net.danvi.dmall.front.web.security;

import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.web.access.AccessDeniedHandler;
import org.springframework.security.web.csrf.InvalidCsrfTokenException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * Created by dong on 2016-04-15.
 */
public class CustomAccessDeniedHadnelr implements AccessDeniedHandler {
    private String errorPage;

    public CustomAccessDeniedHadnelr() {
    }

    @Override
    public void handle(HttpServletRequest request, HttpServletResponse response, AccessDeniedException e) throws IOException, ServletException {
        if (e instanceof InvalidCsrfTokenException) {

        } else {
            if (!response.isCommitted()) {
                if (this.errorPage != null) {
                    request.setAttribute("SPRING_SECURITY_403_EXCEPTION", e);
                    response.setStatus(403);
                    RequestDispatcher dispatcher = request.getRequestDispatcher(this.errorPage);
                    dispatcher.forward(request, response);
                } else {
                    response.sendError(403, e.getMessage());
                }
            }
        }
    }

    public void setErrorPage(String errorPage) {
        if(errorPage != null && !errorPage.startsWith("/")) {
            throw new IllegalArgumentException("errorPage must begin with \'/\'");
        } else {
            this.errorPage = errorPage;
        }
    }
}
