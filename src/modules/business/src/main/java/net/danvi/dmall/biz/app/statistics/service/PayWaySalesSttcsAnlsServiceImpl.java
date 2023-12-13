package net.danvi.dmall.biz.app.statistics.service;

import net.danvi.dmall.biz.app.statistics.model.PayWaySalesSttcsVO;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import lombok.extern.slf4j.Slf4j;
import net.danvi.dmall.biz.app.statistics.model.PayWaySalesSttcsSO;
import dmall.framework.common.BaseService;
import dmall.framework.common.constants.MapperConstants;
import dmall.framework.common.model.ResultListModel;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 9. 13.
 * 작성자     : sin
 * 설명       :
 * </pre>
 */
@Slf4j
@Service("payWaySalesSttcsAnlsService")
@Transactional(rollbackFor = Exception.class)
public class PayWaySalesSttcsAnlsServiceImpl extends BaseService implements PayWaySalesSttcsAnlsService {

    @Override
    @Transactional(readOnly = true)
    public ResultListModel<PayWaySalesSttcsVO> selectPayWaySalesSttcsList(PayWaySalesSttcsSO payWaySalesSttcsSO) {
        if (payWaySalesSttcsSO.getSidx().length() == 0) {
            if ("T".equals(payWaySalesSttcsSO.getPeriodGb())) {
                payWaySalesSttcsSO.setSidx("A.DT");
                payWaySalesSttcsSO.setSord("ASC");
            } else if ("M".equals(payWaySalesSttcsSO.getPeriodGb())) {
                payWaySalesSttcsSO.setSidx("A.DT");
                payWaySalesSttcsSO.setSord("ASC");
            } else if ("D".equals(payWaySalesSttcsSO.getPeriodGb())) {
                payWaySalesSttcsSO.setSidx("A.DT");
                payWaySalesSttcsSO.setSord("ASC");
            }
        }

        return proxyDao.selectListPage(MapperConstants.PAY_WAY_SALES_STTCS + "selectPayWaySalesSttcsList",
                payWaySalesSttcsSO);
    }
}
