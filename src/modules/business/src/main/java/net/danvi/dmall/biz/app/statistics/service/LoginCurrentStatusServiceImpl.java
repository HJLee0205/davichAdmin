package net.danvi.dmall.biz.app.statistics.service;

import dmall.framework.common.BaseService;
import dmall.framework.common.constants.MapperConstants;
import dmall.framework.common.model.ResultListModel;
import lombok.extern.slf4j.Slf4j;
import net.danvi.dmall.biz.app.statistics.model.LoginCurrentStatusSO;
import net.danvi.dmall.biz.app.statistics.model.LoginCurrentStatusVO;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Slf4j
@Service("loginCurrentStatusService")
@Transactional(rollbackFor = Exception.class)
public class LoginCurrentStatusServiceImpl extends BaseService implements LoginCurrentStatusService {

    @Override
    @Transactional(readOnly = true)
    public ResultListModel<LoginCurrentStatusVO> selectLoginCurrentStatusList(LoginCurrentStatusSO so) {
        return proxyDao.selectListPage(MapperConstants.LOGIN_CURRENTSTATUS_ANLS + "selectLoginCurrentStatusList", so);
    }
}
