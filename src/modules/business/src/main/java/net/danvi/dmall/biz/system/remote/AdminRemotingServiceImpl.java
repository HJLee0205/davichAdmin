package net.danvi.dmall.biz.system.remote;

import lombok.extern.slf4j.Slf4j;
import net.danvi.dmall.biz.app.setup.siteinfo.model.SiteSO;
import net.danvi.dmall.biz.common.service.CacheService;
import org.springframework.remoting.httpinvoker.HttpInvokerProxyFactoryBean;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;

/**
 * Created by dong on 2016-06-21.
 */
@Service("adminRemotingService")
@Slf4j
public class AdminRemotingServiceImpl implements AdminRemotingService {

    private final String REMOTE_PATH = "/front/remote/front-remote-service";
    private final String M_REMOTE_PATH = "/m/front/remote/front-remote-service";

    @Resource(name = "cacheService")
    private CacheService cacheService;

    @Override
    @Async
    public void refreshSiteInfoCache(Long siteNo, String serverName) {
        if(false) {// 프론트케시 리프레시 block
            SiteSO so = new SiteSO();
            so.setSiteNo(siteNo);
            cacheService.refreshBasicInfoCache(so);
            cacheService.refreshSiteInfoCache(siteNo);

            log.debug("프론트 사이트 정보 갱신 요청");
            FrontRemotingService result = getFrontService(serverName);
            result.refreshBasicInfoCache(siteNo);
            result.refreshSiteInfoCache(siteNo);

            log.debug("모바일 사이트 정보 갱신 요청");
            FrontRemotingService m_result = getMobileFrontService(serverName);
            m_result.refreshBasicInfoCache(siteNo);
            m_result.refreshSiteInfoCache(siteNo);
        }
    }

    @Override
    @Async
    public void refreshGnbInfo(Long siteNo, String serverName) {
        if(false) {// 프론트케시 리프레시 block
            cacheService.refreshGnbInfo(siteNo);
            log.debug("프론트 카테고리 정보 갱신 요청");
            FrontRemotingService result = getFrontService(serverName);
            result.refreshGnbInfo(siteNo);
            log.debug("모바일 카테고리 정보 갱신 요청");
            FrontRemotingService m_result = getMobileFrontService(serverName);
            m_result.refreshGnbInfo(siteNo);
        }
    }
    
    @Override
    @Async
    public void refreshLnbInfo(Long siteNo, String serverName) {
        if(false) {// 프론트케시 리프레시 block
            cacheService.refreshLnbInfo(siteNo);
            log.debug("프론트 lnb 카테고리 정보 갱신 요청");
            FrontRemotingService result = getFrontService(serverName);
            result.refreshLnbInfo(siteNo);
            log.debug("모바일 lnb 카테고리 정보 갱신 요청");
            FrontRemotingService m_result = getMobileFrontService(serverName);
            m_result.refreshLnbInfo(siteNo);
        }
    }

    @Override
    @Async
    public void refreshNopbInfo(Long siteNo, String serverName) {
        if(false) {// 프론트케시 리프레시 block
            // 사이트 정보 캐시 갱신
            cacheService.refreshNopbInfo(siteNo);

            log.debug("프론트 무통장 정보 갱신 요청");
            FrontRemotingService result = getFrontService(serverName);
            result.refreshNopbInfo(siteNo);
            log.debug("모바일 무통장 정보 갱신 요청");
            FrontRemotingService m_result = getMobileFrontService(serverName);
            m_result.refreshNopbInfo(siteNo);
        }
    }

    private FrontRemotingService getFrontService(String serverName) {
        HttpInvokerProxyFactoryBean fb = new HttpInvokerProxyFactoryBean();
        fb.setServiceInterface(FrontRemotingService.class);
        log.debug("serverName ::" + serverName);
        fb.setServiceUrl("http://" + serverName + REMOTE_PATH);
        fb.afterPropertiesSet();
        return (FrontRemotingService) fb.getObject();
    }

    private FrontRemotingService getMobileFrontService(String serverName) {
        HttpInvokerProxyFactoryBean fb = new HttpInvokerProxyFactoryBean();
        fb.setServiceInterface(FrontRemotingService.class);
        log.debug("Mobile serverName ::" + serverName);
        fb.setServiceUrl("http://" + serverName + M_REMOTE_PATH);
        fb.afterPropertiesSet();
        return (FrontRemotingService) fb.getObject();
    }
}
