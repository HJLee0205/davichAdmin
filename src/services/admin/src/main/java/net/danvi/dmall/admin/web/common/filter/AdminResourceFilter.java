package net.danvi.dmall.admin.web.common.filter;

import java.io.File;
import java.io.IOException;

import javax.annotation.Resource;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Component;

import lombok.extern.slf4j.Slf4j;
import net.danvi.dmall.biz.system.model.SiteCacheVO;
import net.danvi.dmall.biz.system.service.SiteService;
import dmall.framework.common.filter.ResourceFilter;
import dmall.framework.common.util.FileUtil;
import dmall.framework.common.util.SiteUtil;
import dmall.framework.common.util.StringUtil;

/**
 * <pre>
 * 프로젝트명 : 41.admin
 * 작성일     : 2016. 6. 16.
 * 작성자     : dong
 * 설명       : 리소스 처리 필터
 * </pre>
 */
@Slf4j
@Component("resourceFilter")
public class AdminResourceFilter extends ResourceFilter {

    private final String RESOURCE_PATH = "/resource";

    @Resource(name = "siteService")
    private SiteService siteService;

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {

    }

    @Override
    public void destroy() {

    }

    @Override
    protected void writeResource(ServletRequest servletRequest, ServletResponse servletResponse) throws IOException {
        HttpServletRequest req = (HttpServletRequest)servletRequest;
        String uri = req.getRequestURI();
        log.debug("URI:{}", uri);
        Long siteNo = siteService.getSiteNo(req);
        SiteCacheVO vo = siteService.getSiteInfo(siteNo);
        String filePath;

        if(uri.startsWith(RESOURCE_PATH)) {
            // 리소스인 경우
            uri = StringUtil.replace(uri, RESOURCE_PATH, "", false, true);
            filePath = SiteUtil.getSiteUplaodRootPath(vo.getSiteId()) + File.separator + uri;
        } else {
            return;
        }

        filePath = filePath.replaceAll("[/]{2,}", "/");
        log.debug("filePath:{}", filePath);
        File file = new File(filePath);
        FileUtil.writeFileToResponse((HttpServletResponse) servletResponse, file);
        servletResponse.flushBuffer();
    }
}
