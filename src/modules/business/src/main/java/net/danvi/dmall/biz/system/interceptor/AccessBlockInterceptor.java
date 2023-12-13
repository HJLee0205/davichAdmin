package net.danvi.dmall.biz.system.interceptor;

import lombok.extern.slf4j.Slf4j;
import net.danvi.dmall.biz.app.setup.securitymanage.model.AccessBlockIpPO;
import net.danvi.dmall.biz.system.model.SiteCacheVO;
import net.danvi.dmall.biz.system.service.SiteService;
import org.chimi.ipfilter.Config;
import org.chimi.ipfilter.IpFilter;
import org.chimi.ipfilter.IpFilters;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;
import dmall.framework.common.util.HttpUtil;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.List;

@Slf4j
public class AccessBlockInterceptor extends HandlerInterceptorAdapter {

    @Resource(name = "siteService")
    private SiteService siteService;

    @Override
    public boolean preHandle(HttpServletRequest httpServletRequest, HttpServletResponse httpServletResponse, Object o)
            throws Exception {
        String ip = HttpUtil.getClientIp(httpServletRequest);
        log.debug("IP : {}", ip);
        Long siteNo = siteService.getSiteNo(httpServletRequest);
        SiteCacheVO site = siteService.getSiteInfo(siteNo);

        List<AccessBlockIpPO> list = site.getBlockIpList();

        Config conf = new Config();
        conf.setAllowFirst(true);
        conf.setDefaultAllow(true);
        String filter;

        for(AccessBlockIpPO po : list){
            filter = po.getIpAddr1();
            if(po.getIpAddr2().trim().length() > 0) {
                filter += "." + po.getIpAddr2();
            } else {
                filter += ".*";
            }
            if(po.getIpAddr3().trim().length() > 0) {
                filter += "." + po.getIpAddr3();
            } else {
                filter += ".*";
            }
            if(po.getIpAddr4().trim().length() > 0) {
                filter += "." + po.getIpAddr4();
            } else {
                filter += ".*";
            }
            conf.deny(filter);
        }
        log.debug("IP 필터 생성 : 필터링 IP {}개", list.size());
        IpFilter ipFilter = IpFilters.create(conf);

        log.debug("IP 필터 처리 : {}", ip);
        if(!ipFilter.accept(ip)) {
            log.debug("제한 IP 또는 제한 IP 대역 : {}", ip);
            throw new AccessDeniedException("");
        }

        return super.preHandle(httpServletRequest, httpServletResponse, o);
    }


}