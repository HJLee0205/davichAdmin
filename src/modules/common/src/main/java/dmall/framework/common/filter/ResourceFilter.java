package dmall.framework.common.filter;

import java.io.IOException;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;

/**
 * <pre>
 * 프로젝트명 : 01.common
 * 작성일     : 2016. 6. 16.
 * 작성자     : dong
 * 설명       : 리소스 처리 필터
 * </pre>
 */
public abstract class ResourceFilter implements Filter {
    protected abstract void writeResource(ServletRequest servletRequest, ServletResponse servletResponse) throws IOException;

    @Override
    public void doFilter(ServletRequest servletRequest, ServletResponse servletResponse, FilterChain filterChain) throws IOException, ServletException {
        if (servletRequest instanceof HttpServletRequest) {
            writeResource(servletRequest, servletResponse);
        }
    }
}
