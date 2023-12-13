package net.danvi.dmall.biz.app.setup.securitymanage.model;

import lombok.Data;
import dmall.framework.common.model.BaseModel;

/**
 * Created by dong on 2016-06-15.
 */
@Data
public class ContentsProtectionPO extends BaseModel<ContentsProtectionPO> {
    /** 마우스 우클릭 사용 여부 */
    private String mouseRclickUseYn;
    /** 드래그&복사 사용 여부 */
    private String dragCopyUseYn;
}
