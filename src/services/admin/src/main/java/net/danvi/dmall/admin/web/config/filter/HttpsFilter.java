package net.danvi.dmall.admin.web.config.filter;

import dmall.framework.common.constants.RequestAttributeConstants;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.springframework.web.servlet.mvc.support.RedirectAttributesModelMap;

import javax.annotation.PostConstruct;
import javax.servlet.*;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Enumeration;

@Slf4j
@Component("httpsFilter")
public class HttpsFilter implements Filter {

    @Value("#{back['system.https.url.list']}")
    private String httpsUrlString;
    @Value("#{back['system.switch.url.list']}")
    private String switchUrlString;

    private String[] httpsUrls = new String[] {};

    private String[] switchUrls = new String[] {};

    @Value("#{system['system.image.domain']}")
    private String imageDomain;

    @PostConstruct
    public void init() {
        if (httpsUrlString != null) {
            httpsUrls = httpsUrlString.split(",");
        }
        if (switchUrlString != null) {
            switchUrls = switchUrlString.split(",");
        }
    }

    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws java.io.IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;

        String uri = req.getRequestURI();
        String protocol = req.getScheme();
        String domain = req.getServerName();
        String params = "";
        String redirectUrl = "";
        String site;
        String method = req.getMethod();
        boolean isSecurityUrl = false;
        boolean isSwitchUrl = false;
        boolean isRedirect = false;
        /*log.debug("httpsUrlString :::::::::::::::::::::::::::::::::: "+httpsUrlString);
        log.debug("switchUrlString :::::::::::::::::::::::::::::::::: "+switchUrlString);
        log.debug("req getRequestURL :::::::::::::::::::::::::::::::::: "+req.getRequestURL());
        log.debug("req getContextPath :::::::::::::::::::::::::::::::::: "+req.getContextPath());
        log.debug("res getContentType :::::::::::::::::::::::::::::::::: "+res.getContentType());

        log.debug("protocol :::::::::::::::::::::::::::::::::: "+protocol);
        log.debug("uri :::::::::::::::::::::::::::::::::: "+uri);
        log.debug("domain :::::::::::::::::::::::::::::::::: "+domain);
        log.debug("method :::::::::::::::::::::::::::::::::: "+method);
        log.debug("switchUrls :::::::::::::::::::::::::::::::::: "+switchUrlString);*/
        // http, https 양쪽에서 사용할수 있는 URL인지 판단
        for (String url : switchUrls) {
            if (uri.contains(url.trim())) {
                isSwitchUrl = true;
                break;
            }
        }
//        log.debug("isSwitchUrl :::::::::::::::::::::::::::::::::: "+isSwitchUrl);
        request.setAttribute(RequestAttributeConstants.IMAGE_DOMAIN, protocol+"://"+imageDomain);
        if (isSwitchUrl) {
            if(domain.equals("davichmarket.com")){
                if ("post".equalsIgnoreCase(method)) {
                    // post인 경우
                    RedirectAttributes ra = new RedirectAttributesModelMap();
                    ra.addAllAttributes(req.getParameterMap());

                    //파라미터가 있는경우 파라미터 세팅...
                    Enumeration<String> enumeration = req.getParameterNames();
                    String paramName;
                    String[] paramValues;

                    while (enumeration.hasMoreElements()) {
                        paramName = enumeration.nextElement();
                        paramValues = req.getParameterValues(paramName);
                        log.debug("{}:{}", paramName, paramValues);
                        for (String value : paramValues) {
                            if(!paramName.equals("_csrf")) {
                                params += "&" + paramName + "=" + value;
                            }
                        }
                    }

                    if (params.length() > 0) {
                        params = "?" + params.substring(1);
                    }
                } else {
                    // post가 아닌 경우, get.. 등등
                    Enumeration<String> enumeration = req.getParameterNames();
                    String paramName;
                    String[] paramValues;

                    while (enumeration.hasMoreElements()) {
                        paramName = enumeration.nextElement();
                        paramValues = req.getParameterValues(paramName);
                        log.debug("{}:{}", paramName, paramValues);
                        for (String value : paramValues) {
                            params += "&" + paramName + "=" + value;
                        }
                    }

                    if (params.length() > 0) {
                        params = "?" + params.substring(1);
                    }
                }

                 domain = "www."+domain;
                 if ("http".equals(protocol)){
                    redirectUrl ="http://";
                 } else if ("https".equals(protocol)){
                    redirectUrl ="https://";
                 }

                redirectUrl += domain + uri + params;
                log.debug("redirectUrl:{}", redirectUrl);
                site = new String(redirectUrl);
                res.setStatus(HttpServletResponse.SC_TEMPORARY_REDIRECT);
                res.setHeader("Location", site.replaceAll("\r", "").replaceAll("\n", ""));
            }
        }

        // http / https 한쪽만 사용해야 하는 URL이면
        if (!isSwitchUrl) {
            // https URL 판단
            for (String url : httpsUrls) {
                if (uri.contains(url.trim())) {
                    isSecurityUrl = true;
                    break;
                }
            }

            if ("http".equals(protocol) && isSecurityUrl) {
                // http로 접근했으나 https로 접근해야 하는 URL인 경우
                redirectUrl = "https://";
                isRedirect = true;

            } else if ("https".equals(protocol) && !isSecurityUrl) {
                // https로 접근했으나 http로 접근해야 하는 URL인 경우
                redirectUrl = "http://";
                isRedirect = true;
            }

            if (isRedirect) {
                // 리다이렉트 해야할 경우
                if ("post".equalsIgnoreCase(method)) {
                    // post인 경우
                    RedirectAttributes ra = new RedirectAttributesModelMap();
                    ra.addAllAttributes(req.getParameterMap());
                } else {
                    // post가 아닌 경우, get.. 등등
                    Enumeration<String> enumeration = req.getParameterNames();
                    String paramName;
                    String[] paramValues;

                    while (enumeration.hasMoreElements()) {
                        paramName = enumeration.nextElement();
                        paramValues = req.getParameterValues(paramName);
                        log.debug("{}:{}", paramName, paramValues);
                        for (String value : paramValues) {
                            params += "&" + paramName + "=" + value;
                        }
                    }

                    if (params.length() > 0) {
                        params = "?" + params.substring(1);
                    }
                }

                if(domain.equals("davichmarket.com")){
                    domain = "www."+domain;
                }
                redirectUrl += domain + uri + params;
                log.debug("redirectUrl:{}", redirectUrl);
                site = new String(redirectUrl);
                res.setStatus(HttpServletResponse.SC_TEMPORARY_REDIRECT);
                res.setHeader("Location", site.replaceAll("\r", "").replaceAll("\n", ""));
            }
        }
        // Pass request back down the filter chain
        chain.doFilter(req, res);
    }

    @Override
    public void init(FilterConfig arg0) throws ServletException {
        // TODO Auto-generated method stub
    }

    @Override
    public void destroy() {
        // TODO Auto-generated method stub
    }
}