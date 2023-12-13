package net.danvi.dmall.biz.app.setup.securitymanage.model;

import java.util.List;

import lombok.Data;
import dmall.framework.common.model.BaseModel;

/**
 * Created by dong on 2016-06-09.
 */
@Data
public class AccessBlockIpConfigPO extends BaseModel<AccessBlockIpConfigPO> {
    // IP 접속 제한 여부
    private String ipConnectLimitUseYn;
    // IP 목록
    private List<AccessBlockIpPO> ipList;
}
