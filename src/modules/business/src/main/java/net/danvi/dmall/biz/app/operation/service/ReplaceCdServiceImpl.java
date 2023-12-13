package net.danvi.dmall.biz.app.operation.service;

import java.util.List;

import net.danvi.dmall.biz.app.operation.model.ReplaceCdSO;
import org.springframework.stereotype.Service;

import lombok.extern.slf4j.Slf4j;
import net.danvi.dmall.biz.app.operation.model.ReplaceCdVO;
import dmall.framework.common.BaseService;
import dmall.framework.common.constants.MapperConstants;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 6. 24.
 * 작성자     : kjw
 * 설명       :
 * </pre>
 */
@Slf4j
@Service("replaceCdService")
public class ReplaceCdServiceImpl extends BaseService implements ReplaceCdService {

    @Override
    public List<ReplaceCdVO> selectReplaceCdList(ReplaceCdSO so) {
        // 치환 코드 리스트 조회
        return proxyDao.selectList(MapperConstants.REPLACE_CD + "selectReplaceCdList", so);
    }

}
