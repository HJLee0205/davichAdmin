package net.danvi.dmall.biz.app.statistics.service;

import net.danvi.dmall.biz.app.statistics.model.OrdSttcsSO;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import lombok.extern.slf4j.Slf4j;
import net.danvi.dmall.biz.app.statistics.model.OrdSttcsVO;
import dmall.framework.common.BaseService;
import dmall.framework.common.constants.MapperConstants;
import dmall.framework.common.model.ResultListModel;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 9. 7.
 * 작성자     : sin
 * 설명       :
 * </pre>
 */
@Slf4j
@Service("ordSttcsAnlsService")
@Transactional(rollbackFor = Exception.class)
public class OrdSttcsAnlsServiceImpl extends BaseService implements OrdSttcsAnlsService {

    @Override
    @Transactional(readOnly = true)
    public ResultListModel<OrdSttcsVO> selectOrdSttcsList(OrdSttcsSO ordSttcsSO) {
        if (ordSttcsSO.getSidx().length() == 0) {
            if ("T".equals(ordSttcsSO.getPeriodGb())) {
                ordSttcsSO.setSidx("A.DT");
                ordSttcsSO.setSord("ASC");
            } else if ("M".equals(ordSttcsSO.getPeriodGb())) {
                ordSttcsSO.setSidx("A.DT");
                ordSttcsSO.setSord("ASC");
            } else if ("D".equals(ordSttcsSO.getPeriodGb())) {
                ordSttcsSO.setSidx("SUBSTR(A.DT,1,6)");
                ordSttcsSO.setSord("ASC");
            }
        }

        // 주문통계 리스트
        ResultListModel<OrdSttcsVO> resultListModel = proxyDao.selectListPage(MapperConstants.ORD_STTCS_ANLS + "selectOrdSttcsList", ordSttcsSO);

        // 주문통계 총 합
        resultListModel.put("resultListTotalSum",proxyDao.selectList(MapperConstants.ORD_STTCS_ANLS + "selectTotOrdSttcsList", ordSttcsSO));

        return resultListModel;
    }
}
