package net.danvi.dmall.biz.app.statistics.service;

import net.danvi.dmall.biz.app.statistics.model.VstrSO;
import net.danvi.dmall.biz.app.statistics.model.VstrVO;
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
 * 작성일     : 2016. 8. 22.
 * 작성자     : sin
 * 설명       : 방문자분석 통계 컴포넌트의 구현 클래스
 * </pre>
 */
@Slf4j
@Service("vstrAnlsService")
@Transactional(rollbackFor = Exception.class)
public class VstrAnlsServiceImpl extends BaseService implements VstrAnlsService {

    @Override
    @Transactional(readOnly = true)
    public ResultListModel<VstrVO> selectVstrList(VstrSO vstrSO) {
        List<VstrVO> result = proxyDao.selectList(MapperConstants.VSTR_ANLS + "selectVstrAnlsList", vstrSO);

        ResultListModel<VstrVO> resultModel = new ResultListModel<>();
        resultModel.setResultList(result);

        return resultModel;
    }
}
