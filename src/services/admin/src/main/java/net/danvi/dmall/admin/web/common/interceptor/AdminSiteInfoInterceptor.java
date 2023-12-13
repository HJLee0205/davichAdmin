package net.danvi.dmall.admin.web.common.interceptor;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import lombok.extern.slf4j.Slf4j;
import net.danvi.dmall.biz.system.model.SiteCacheVO;
import net.danvi.dmall.biz.system.service.SiteService;
import dmall.framework.common.constants.RequestAttributeConstants;
import dmall.framework.common.util.HttpUtil;

/**
 * Created by dong on 2016-05-17.
 */
@Slf4j
public class AdminSiteInfoInterceptor extends HandlerInterceptorAdapter {

    @Resource(name = "siteService")
    private SiteService siteService;

    @Override
    public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler, ModelAndView modelAndView) throws Exception {
        // ajax 요청이 아니면
        if(!HttpUtil.isAjax(request) && modelAndView != null) {
            Long siteNo = siteService.getSiteNo(request.getServerName());
            SiteCacheVO siteCacheVO = siteService.getSiteInfo(siteNo);
            modelAndView.addObject(RequestAttributeConstants.SITE_INFO, siteCacheVO);

        }

        super.postHandle(request, response, handler, modelAndView);
    }
}
