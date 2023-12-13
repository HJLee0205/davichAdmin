package net.danvi.dmall.biz.batch.banner.service;

import dmall.framework.common.BaseService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.io.IOException;
import java.lang.reflect.InvocationTargetException;

@Service("bannerBatchService")
@Slf4j
public class BannerBatchServiceImpl extends BaseService implements BannerBatchService {

    // 배너 자동 미전시처리
    /*
     * (non-Javadoc)
     *
     * @see GoodsBatchService#
     * createEpGoodsInfo(net.danvi.dmall.biz.batch.goods.salestatus.model.GoodsBatchVO)
     */
    @Override
    public void bannerAutoDispNone()
            throws InvocationTargetException, NoSuchMethodException, IllegalAccessException, IOException {
        log.debug("배너 자동 미전시처리 시작");
        proxyDao.update("batch.banner." + "updateBannerDispNone");
        log.debug("배너 자동 미전시처리 완료");

    }


}
