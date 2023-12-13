package net.danvi.dmall.biz.app.operation.service;

import net.danvi.dmall.smsemail.model.request.PushSendPO;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import dmall.framework.common.BaseService;
import dmall.framework.common.constants.MapperConstants;
import lombok.extern.slf4j.Slf4j;
import net.danvi.dmall.biz.app.operation.model.PushSendSO;
import net.danvi.dmall.biz.app.operation.model.PushSendVO;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2018. 12. 21.
 * 작성자     : khy
 * 설명       :
 * </pre>
 */
@Slf4j
@Service("appStorePushService")
@Transactional(rollbackFor = Exception.class)
public class AppStorePushServiceImpl extends BaseService implements AppStorePushService {
    @Autowired(required=false)
    @Qualifier("sqlSessionTemplatePushSt")
    private SqlSessionTemplate sqlSessionTemplatePushSt;
    
    @Override
    public PushSendVO selectPushCheck(PushSendPO po) {
        PushSendVO vo = sqlSessionTemplatePushSt.selectOne(MapperConstants.PUSH + "selectPushCheck", po);
        //푸시확인 이력
        sqlSessionTemplatePushSt.insert(MapperConstants.PUSH + "insertPushConfirm", po);
        return vo;
    }
    
    
    
}
