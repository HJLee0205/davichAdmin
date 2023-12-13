package net.danvi.dmall.biz.app.statistics.service;

import net.danvi.dmall.biz.app.statistics.model.VisitPathVO;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import lombok.extern.slf4j.Slf4j;
import net.danvi.dmall.biz.app.statistics.model.VisitPathSO;
import dmall.framework.common.BaseService;
import dmall.framework.common.constants.MapperConstants;
import dmall.framework.common.model.ResultListModel;

import java.util.List;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 8. 24.
 * 작성자     : sin
 * 설명       : 방문 경로 분석 통계 컴포넌트의 구현 클래스
 * </pre>
 */
@Slf4j
@Service("visitPathAnlsService")
@Transactional(rollbackFor = Exception.class)
public class VisitPathAnlsServiceImpl extends BaseService implements VisitPathAnlsService {
    public ResultListModel<VisitPathVO> selectVisitPathList(VisitPathSO visitPathSO) {
//        if (visitPathSO.getSidx().length() == 0) {
//            visitPathSO.setSidx("A.VSTR_CNT");
//            visitPathSO.setSord("DESC");
//        }
//        String listSql = "selectVisitPathList"; // 전체
//
//        if(visitPathSO.getVisitPage()!=null && visitPathSO.getVisitPage().equals("01")){ //방문예약
//            listSql = "selectVisitRsvPathList";
//        }else if(visitPathSO.getVisitPage()!=null && visitPathSO.getVisitPage().equals("02")){ // 방문접수
//            listSql = "selectVisitRsvComPathList";
//        }

        List<VisitPathVO> result = proxyDao.selectList(MapperConstants.VISIT_PATH_ANLS + "selectVisitPathList", visitPathSO);

        ResultListModel<VisitPathVO> resultListModel = new ResultListModel<>();
        resultListModel.setResultList(result);

        return resultListModel;
    }
}
