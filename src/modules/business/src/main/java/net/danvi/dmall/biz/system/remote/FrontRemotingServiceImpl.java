package net.danvi.dmall.biz.system.remote;

import javax.annotation.Resource;

import net.danvi.dmall.biz.app.setup.siteinfo.model.SiteSO;
import net.danvi.dmall.biz.common.service.CacheService;
import org.springframework.stereotype.Service;

import lombok.extern.slf4j.Slf4j;

/**
 * Created by dong on 2016-06-21.
 */
@Service("frontRemotingService")
@Slf4j
public class FrontRemotingServiceImpl implements FrontRemotingService {

    @Resource(name = "cacheService")
    private CacheService cacheService;

    @Override
    public void refreshBasicInfoCache(Long siteNo) {
        log.debug("사이트 정보 캐시 갱신 : {}", siteNo);
        SiteSO so = new SiteSO();
        so.setSiteNo(siteNo);
        cacheService.refreshBasicInfoCache(so);
    }

    @Override
    public void refreshGnbInfo(Long siteNo) {
        log.debug("카테고리 정보 캐시 갱신 : {}", siteNo);
        cacheService.refreshGnbInfo(siteNo);
    }
    
    @Override
    public void refreshLnbInfo(Long siteNo) {
        log.debug("카테고리 정보 캐시 갱신 : {}", siteNo);
        cacheService.refreshLnbInfo(siteNo);
    }

    @Override
    public void refreshNopbInfo(Long siteNo) {
        log.debug("무통장 정보 캐시 갱신 : {}", siteNo);
        cacheService.refreshNopbInfo(siteNo);
    }

    @Override
    public void refreshSiteInfoCache(Long siteNo) {
        log.debug("사이트 정보(금칙어, 접속차단IP) 캐시 갱신 : {}", siteNo);
        cacheService.refreshSiteInfoCache(siteNo);
    }
}
