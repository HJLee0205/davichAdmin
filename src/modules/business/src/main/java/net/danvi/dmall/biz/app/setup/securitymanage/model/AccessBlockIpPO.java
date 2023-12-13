package net.danvi.dmall.biz.app.setup.securitymanage.model;

import lombok.Data;
import dmall.framework.common.model.BaseModel;

/**
 * Created by dong on 2016-06-09.
 */
@Data
public class AccessBlockIpPO extends BaseModel<AccessBlockIpPO> {
    // 사이트 번호
    private Long setNo;
    // IP 주소 1
    private String ipAddr1;
    // IP 주소 2
    private String ipAddr2;
    // IP 주소 3
    private String ipAddr3;
    // IP 주소 4
    private String ipAddr4;
}
