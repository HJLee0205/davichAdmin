package net.danvi.dmall.biz.system.service;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import lombok.extern.slf4j.Slf4j;
import net.danvi.dmall.biz.common.service.CacheService;
import net.danvi.dmall.biz.system.model.SiteCacheVO;
import dmall.framework.common.BaseService;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 5. 3.
 * 작성자     : dong
 * 설명       :
 * 
 * </pre>
 */
@Service("siteService")
@Slf4j
public class SiteServiceImpl extends BaseService implements SiteService {

    @Resource(name = "cacheService")
    private CacheService cacheService;

    @Value(value = "#{system['system.server']}")
    private String server;

    @Override
    @Transactional(readOnly = true)
    public Long getSiteNo(String domain) {
        // 서버가 개발이면...
        if ("dev".equals(server)) {
            domain = "www.davichmarket.com";
        }else if ("local".equals(server)) {
            domain="id1.test.com";
        }else{
            domain = "www.davichmarket.com";
        }
        return cacheService.getSiteNo(domain);
    }

    @Override
    @Transactional(readOnly = true)
    public Long getSiteNo(HttpServletRequest request) {
        String serverName = request.getServerName();
        return getSiteNo(serverName);
    }

    @Override
    @Transactional(readOnly = true)
    public SiteCacheVO getSiteInfo(Long siteNo) {
        return cacheService.getSiteInfo(siteNo);
    }

    @Override
    @Transactional(readOnly = true)
    public void refreshSiteInfo(Long siteNo) {
        cacheService.refreshSiteInfoCache(siteNo);
    }
}
