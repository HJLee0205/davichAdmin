package net.danvi.dmall.biz.app.statistics.service;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import lombok.extern.slf4j.Slf4j;
import net.danvi.dmall.biz.app.statistics.model.BasketGoodsSO;
import net.danvi.dmall.biz.app.statistics.model.BasketGoodsVO;
import dmall.framework.common.BaseService;
import dmall.framework.common.constants.MapperConstants;
import dmall.framework.common.model.ResultListModel;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 9. 6.
 * 작성자     : sin
 * 설명       :
 * </pre>
 */
@Slf4j
@Service("basketGoodsAnlsService")
@Transactional(rollbackFor = Exception.class)
public class BasketGoodsAnlsServiceImpl extends BaseService implements BasketGoodsAnlsService {
    @Override
    @Transactional(readOnly = true)
    public ResultListModel<BasketGoodsVO> selectBasketGoodsList(BasketGoodsSO basketGoodsSO) {
        if (basketGoodsSO.getSidx().length() == 0) {
            basketGoodsSO.setSidx("A.BASKET_CNT");
            basketGoodsSO.setSord("DESC");
        }
        return proxyDao.selectListPage(MapperConstants.BASKET_GOODS_ANLS + "selectBasketGoodsList", basketGoodsSO);
    }
}
