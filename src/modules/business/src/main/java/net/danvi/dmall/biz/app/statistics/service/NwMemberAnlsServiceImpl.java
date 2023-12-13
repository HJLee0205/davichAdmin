package net.danvi.dmall.biz.app.statistics.service;

import net.danvi.dmall.biz.app.statistics.model.NwMemberSO;
import net.danvi.dmall.biz.app.statistics.model.NwMemberVO;
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
 * 작성일     : 2016. 8. 29.
 * 작성자     : sin
 * 설명       :
 * </pre>
 */
@Slf4j
@Service("nwMemberAnlsService")
@Transactional(rollbackFor = Exception.class)
public class NwMemberAnlsServiceImpl extends BaseService implements NwMemberAnlsService {

    @Override
    @Transactional(readOnly = true)
    public ResultListModel<NwMemberVO> selectNwMemberList(NwMemberSO nwMemberSO) {
        List<NwMemberVO> list = proxyDao.selectList(MapperConstants.NW_MEMBER_ANLS + "selectNwMemberList", nwMemberSO);

        ResultListModel<NwMemberVO> result = new ResultListModel<>();
        result.setResultList(list);

        return result;
    }
}
