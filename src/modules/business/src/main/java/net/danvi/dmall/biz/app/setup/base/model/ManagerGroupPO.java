package net.danvi.dmall.biz.app.setup.base.model;

import lombok.Data;
import net.danvi.dmall.biz.system.validation.DeleteGroup;
import net.danvi.dmall.biz.system.validation.UpdateGroup;
import org.hibernate.validator.constraints.NotEmpty;
import dmall.framework.common.model.BaseModel;

import java.util.List;

/**
 * Created by dong on 2016-05-03.
 */
@Data
public class ManagerGroupPO extends BaseModel<ManagerGroupPO> {
    @NotEmpty(groups = {UpdateGroup.class, DeleteGroup.class})
    private Long authGrpNo;
    private String authGbCd;
    @NotEmpty
    private String authNm;
    @NotEmpty
    private List<String> menuId;
}
