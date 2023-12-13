package net.danvi.dmall.biz.app.statistics.service;

import dmall.framework.common.model.ResultListModel;
import net.danvi.dmall.biz.app.statistics.model.LoginCurrentStatusSO;
import net.danvi.dmall.biz.app.statistics.model.LoginCurrentStatusVO;

public interface LoginCurrentStatusService {

    public ResultListModel<LoginCurrentStatusVO> selectLoginCurrentStatusList(LoginCurrentStatusSO so);
}
