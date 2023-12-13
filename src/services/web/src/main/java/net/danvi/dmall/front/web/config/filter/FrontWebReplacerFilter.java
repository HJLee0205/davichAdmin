package net.danvi.dmall.front.web.config.filter;

import net.danvi.dmall.biz.common.service.CacheService;
import org.springframework.stereotype.Component;
import dmall.framework.common.filter.ReplacerFilter;

import javax.annotation.PostConstruct;
import javax.annotation.Resource;
import javax.servlet.ServletRequest;
import javax.servlet.http.HttpServletRequest;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

/**
 * Created by dong on 2016-06-27.
 */
@Component("replacerFilter")
public class FrontWebReplacerFilter extends ReplacerFilter {

    @Resource(name = "cacheService")
    private CacheService cacheService;

    private List<String> excludeUrl = new ArrayList<>();

    @PostConstruct
    public void init() {
        excludeUrl.add("/image/image-view");
        excludeUrl.add("/image/editor-image-view");
        excludeUrl.add("/image/preview");
        excludeUrl.add("/image/preview-goods-image");
        excludeUrl.add("/image/preview-freebie-image");
        excludeUrl.add("/front/remote/");
        excludeUrl.add("/front/common/capcha");
        excludeUrl.add("/front/community/capchacode-create");
        excludeUrl.add("/front/common/common-download");
        excludeUrl.add("/front/review/review-insert"); // IE8 상품평등록
        excludeUrl.add("/front/review/review-update"); // IE8 상품평수정
        excludeUrl.add("/front/community/letter-insert"); // IE8 게시판등록
        excludeUrl.add("/front/community/letter-update"); // IE8 게시판수정
    }

    @Override
    protected boolean isExcludedUrlPattern(ServletRequest servletRequest) {
        HttpServletRequest request = (HttpServletRequest) servletRequest;
        String url = request.getRequestURL().toString();

        for (String urlPattern : excludeUrl) {
            if (url.indexOf(urlPattern) > -1) {
                return true;
            }
        }
        return false;
    }

    @Override
    protected Map<String, String> getReplacerMap() throws Exception {
        // return cacheService.getReplaceCd();
        return null;
    }
}
