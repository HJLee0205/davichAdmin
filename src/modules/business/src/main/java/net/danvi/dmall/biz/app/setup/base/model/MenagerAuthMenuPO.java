package net.danvi.dmall.biz.app.setup.base.model;

import lombok.Data;
import dmall.framework.common.model.BaseModel;

/**
 * Created by dong on 2016-05-11.
 */
@Data
public class MenagerAuthMenuPO extends BaseModel<MenagerAuthMenuPO> {
    private Long authGrpNo;
    private String menuId;

    public MenagerAuthMenuPO() {}
    public MenagerAuthMenuPO(ManagerGroupPO po) {
        this.authGrpNo = po.getAuthGrpNo();
        this.setSiteNo(po.getSiteNo());
        this.setRegrNo(po.getRegrNo());
        this.setUpdrNo(po.getUpdrNo());
        this.setDelrNo(po.getDelrNo());
    }
}
