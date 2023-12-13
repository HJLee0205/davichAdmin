package net.danvi.dmall.biz.app.statistics.service;

import net.danvi.dmall.biz.app.statistics.model.SalesSttcsSO;
import net.danvi.dmall.biz.app.statistics.model.SalesSttcsVO;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import lombok.extern.slf4j.Slf4j;
import dmall.framework.common.BaseService;
import dmall.framework.common.constants.MapperConstants;
import dmall.framework.common.model.ResultListModel;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 9. 9.
 * 작성자     : sin
 * 설명       :
 * </pre>
 */
@Slf4j
@Service("salesSttcsAnlsService")
@Transactional(rollbackFor = Exception.class)
public class SalesSttcsAnlsServiceImpl extends BaseService implements SalesSttcsAnlsService {

    @Override
    @Transactional(readOnly = true)
    public ResultListModel<SalesSttcsVO> selectSalesSttcsList(SalesSttcsSO salesSttcsSO) {
        if (salesSttcsSO.getSidx().length() == 0) {
            if ("T".equals(salesSttcsSO.getPeriodGb())) {
                salesSttcsSO.setSidx("A.DT");
                salesSttcsSO.setSord("ASC");
            } else if ("M".equals(salesSttcsSO.getPeriodGb())) {
                salesSttcsSO.setSidx("A.DT");
                salesSttcsSO.setSord("ASC");
            } else if ("D".equals(salesSttcsSO.getPeriodGb())) {
                salesSttcsSO.setSidx("A.DT");
                salesSttcsSO.setSord("ASC");
            }
        }

        // 매출통계 리스트
        ResultListModel<SalesSttcsVO> resultListModel = proxyDao
                .selectListPage(MapperConstants.SALES_STTCS_ANLS + "selectSalesSttcsList", salesSttcsSO);

        // 매출통계 총 합
        salesSttcsSO.setTotalSum("1");
        resultListModel.put("resultListTotalSum",
                proxyDao.selectList(MapperConstants.SALES_STTCS_ANLS + "selectTotSalesSttcsList", salesSttcsSO));

        return resultListModel;
    }
}
