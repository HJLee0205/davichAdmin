package net.danvi.dmall.smsemail.interceptor;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;
import dmall.framework.common.util.HttpUtil;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Enumeration;

public class AccessInterceptor extends HandlerInterceptorAdapter {

    private static final Logger log = LoggerFactory.getLogger(AccessInterceptor.class);

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse httpServletResponse, Object o)
            throws Exception {
        // ajax 가 아닐 경우만 처리
        String referer = getReferer(request.getHeader("referer"));
        log.debug("referer : {}", referer);
        log.debug("ip : {}", HttpUtil.getClientIp(request));

        Enumeration<String> headerNames = request.getHeaderNames();
        String headerName;

        log.debug("Header");
        while(headerNames.hasMoreElements()) {
            headerName = headerNames.nextElement();
            log.debug("{} = {}", headerName, request.getHeader(headerName));
        }

        log.debug("paramMap : {}", request.getParameterMap());

        log.debug("Attribute");

        Enumeration<String> attributeNames = request.getAttributeNames();
        String attributeName;
        while(attributeNames.hasMoreElements()) {
            attributeName = attributeNames.nextElement();
            log.debug("{} = {}", attributeName, request.getHeader(attributeName));
        }

        return super.preHandle(request, httpServletResponse, o);
    }

    private String getReferer(String referer) {
        if(referer == null) return null;

        if (referer.contains("?")) {
            referer = referer.substring(0, referer.indexOf("?"));
        }

        return referer;
    }
}