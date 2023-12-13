package net.danvi.dmall.biz.app.setup.base.model;

import lombok.Data;
import dmall.framework.common.model.BaseModel;

/**
 * Created by dong on 2016-05-03.
 */
@Data
public class ManagerPO extends BaseModel<ManagerPO> {
    private Long memberNo;
    private Long authGrpNo;
    private Long orgAuthGrpNo;
}
