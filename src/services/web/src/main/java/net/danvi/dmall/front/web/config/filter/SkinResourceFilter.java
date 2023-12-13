package net.danvi.dmall.front.web.config.filter;

import lombok.extern.slf4j.Slf4j;
import net.danvi.dmall.biz.system.model.SiteCacheVO;
import net.danvi.dmall.biz.system.service.SiteService;
import org.springframework.stereotype.Component;
import dmall.framework.common.constants.RequestAttributeConstants;
import dmall.framework.common.filter.ResourceFilter;
import dmall.framework.common.util.FileUtil;
import dmall.framework.common.util.SiteUtil;
import dmall.framework.common.util.StringUtil;

import javax.annotation.Resource;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.*;
import java.nio.ByteBuffer;
import java.nio.channels.Channels;
import java.nio.channels.ReadableByteChannel;
import java.nio.channels.WritableByteChannel;

/**
 * <pre>
 * 프로젝트명 : 31.front.web
 * 작성일     : 2016. 6. 16.
 * 작성자     : dong
 * 설명       : 스킨 리소스 처리 필터
 * </pre>
 */
@Slf4j
@Component("skinResourceFilter")
public class SkinResourceFilter extends ResourceFilter {

    private final String SKIN_PATH = "/skin";
    private final String SKINS_PATH = "/skins";
    private final String RESOURCE_PATH = "/resource";

    @Resource(name = "siteService")
    private SiteService siteService;

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {

    }

    @Override
    public void destroy() {

    }

    protected void writeResource(ServletRequest servletRequest, ServletResponse servletResponse) throws IOException {
        HttpServletRequest req = (HttpServletRequest)servletRequest;
        String uri = req.getRequestURI();
        if(SiteUtil.isMobile()){
            uri = uri.replace("/m/", "/");
        }
        log.debug("URI:{}", uri);
        Long siteNo = siteService.getSiteNo(req);
        SiteCacheVO vo = siteService.getSiteInfo(siteNo);
        String filePath;

        if(uri.startsWith(SKINS_PATH)) {
            // 스킨 미리보기 리소스인 경우
            filePath = SiteUtil.getSiteRootPath(vo.getSiteId()) + File.separator + uri;
        } else if(uri.startsWith(SKIN_PATH)) {
            // 적용스킨 리소스인 경우
            uri = StringUtil.replace(uri, SKIN_PATH, "", false, true);
            log.debug("URI:{}", uri);
            filePath = SiteUtil.getSiteRootPath(vo.getSiteId()) + File.separator + SiteUtil.getDefaultSkinId() + uri;
        } else if(uri.startsWith(RESOURCE_PATH)) {
            // 리소스인 경우
            uri = StringUtil.replace(uri, RESOURCE_PATH, "", false, true);
            filePath = SiteUtil.getSiteUplaodRootPath(vo.getSiteId()) + File.separator + uri;
        } else {
            return;
        }

         filePath = filePath.replaceAll("[/]{2,}", "/");
        log.debug("filePath:{}", filePath);
//        org.springframework.core.io.Resource resource = new FileSystemResource(filePath);
//        if((new ServletWebRequest((HttpServletRequest) servletRequest, (HttpServletResponse) servletResponse)).checkNotModified(resource.lastModified())) {
//            ((HttpServletResponse) servletResponse).setStatus(HttpServletResponse.SC_NOT_MODIFIED);
//        } else {
            //copyByNio2(servletResponse, filePath);
            copyChannel(servletResponse, filePath);
//        }
        servletResponse.flushBuffer();
    }

    private void copyByNio2(ServletResponse servletResponse, String filePath) throws IOException {
        File file = new File(filePath);
        FileUtil.writeFileToResponse((HttpServletResponse) servletResponse, file);
        servletResponse.flushBuffer();
    }

    private Long copyChannel(ServletResponse servletResponse, String filePath) throws IOException {
        try (
                InputStream input = new FileInputStream(filePath);
                OutputStream output = servletResponse.getOutputStream();
                ReadableByteChannel inputChannel = Channels.newChannel(input);
                WritableByteChannel outputChannel = Channels.newChannel(output);
        ) {
            ByteBuffer buffer = ByteBuffer.allocateDirect(10240);
            long size = 0;

            while (inputChannel.read(buffer) != -1) {
                buffer.flip();
                size += outputChannel.write(buffer);
                buffer.clear();
            }

            return size;
        }
    }
}
