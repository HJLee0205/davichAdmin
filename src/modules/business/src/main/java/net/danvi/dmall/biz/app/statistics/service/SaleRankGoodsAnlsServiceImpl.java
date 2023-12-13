package net.danvi.dmall.biz.app.statistics.service;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import lombok.extern.slf4j.Slf4j;
import net.danvi.dmall.biz.app.statistics.model.SaleRankGoodsSO;
import net.danvi.dmall.biz.app.statistics.model.SaleRankGoodsVO;
import dmall.framework.common.BaseService;
import dmall.framework.common.constants.MapperConstants;
import dmall.framework.common.model.ResultListModel;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 9. 5.
 * 작성자     : sin
 * 설명       :
 * </pre>
 */
@Slf4j
@Service("saleRankGoodsAnlsService")
@Transactional(rollbackFor = Exception.class)
public class SaleRankGoodsAnlsServiceImpl extends BaseService implements SaleRankGoodsAnlsService {
    @Override
    @Transactional(readOnly = true)
    public ResultListModel<SaleRankGoodsVO> selectSaleRankGoodsList(SaleRankGoodsSO saleRankGoodsSO) {
        if (saleRankGoodsSO.getSidx().length() == 0) {
            saleRankGoodsSO.setSidx("A.SALE_QTT");
            saleRankGoodsSO.setSord("DESC");
        }
        return proxyDao.selectListPage(MapperConstants.SALE_RANK_GOODS_ANLS + "selectSaleRankGoodsList",
                saleRankGoodsSO);
    }
}
