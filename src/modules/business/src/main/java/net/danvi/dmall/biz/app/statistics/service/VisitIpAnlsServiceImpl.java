package net.danvi.dmall.biz.app.statistics.service;

import net.danvi.dmall.biz.app.statistics.model.VisitIpSO;
import net.danvi.dmall.biz.app.statistics.model.VisitIpVO;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import lombok.extern.slf4j.Slf4j;
import dmall.framework.common.BaseService;
import dmall.framework.common.constants.MapperConstants;
import dmall.framework.common.model.ResultListModel;

import java.util.List;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 8. 25.
 * 작성자     : sin
 * 설명       : 방문자 IP 분석 통계 컴포넌트의 구현 클래스
 * </pre>
 */
@Slf4j
@Service("visitIpAnlsService")
@Transactional(rollbackFor = Exception.class)
public class VisitIpAnlsServiceImpl extends BaseService implements VisitIpAnlsService {
    public ResultListModel<VisitIpVO> selectVisitIpList(VisitIpSO visitIpSO) {
        return proxyDao.selectListPage(MapperConstants.VISIT_IP_ANLS + "selectVisitIpList", visitIpSO);
    }
}
