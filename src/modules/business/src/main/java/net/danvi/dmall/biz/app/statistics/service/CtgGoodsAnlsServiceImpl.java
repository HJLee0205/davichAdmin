package net.danvi.dmall.biz.app.statistics.service;

import net.danvi.dmall.biz.app.statistics.model.CtgGoodsSO;
import net.danvi.dmall.biz.app.statistics.model.CtgGoodsVO;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import lombok.extern.slf4j.Slf4j;
import dmall.framework.common.BaseService;
import dmall.framework.common.constants.MapperConstants;
import dmall.framework.common.model.ResultListModel;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 9. 1.
 * 작성자     : sin
 * 설명       :
 * </pre>
 */
@Slf4j
@Service("ctgGoodsAnlsService")
@Transactional(rollbackFor = Exception.class)
public class CtgGoodsAnlsServiceImpl extends BaseService implements CtgGoodsAnlsService {
    public ResultListModel<CtgGoodsVO> selectCtgGoodsList(CtgGoodsSO ctgGoodsSO) {
        if (ctgGoodsSO.getSidx().length() == 0) {
            ctgGoodsSO.setSidx("ALL_SALE_QTT");
            ctgGoodsSO.setSord("DESC");
        }
        return proxyDao.selectListPage(MapperConstants.CTG_GOODS_ANLS + "selectCtgGoodsList", ctgGoodsSO);
    }
}
