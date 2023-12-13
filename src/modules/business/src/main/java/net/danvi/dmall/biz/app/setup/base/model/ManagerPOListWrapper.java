package net.danvi.dmall.biz.app.setup.base.model;

import dmall.framework.common.model.BaseModel;

import javax.validation.Valid;
import java.util.ArrayList;
import java.util.List;

/**
 * Created by dong on 2016-05-11.
 */
public class ManagerPOListWrapper extends BaseModel<ManagerPOListWrapper> {
    @Valid
    private List<ManagerPO> list;

    public ManagerPOListWrapper() {
        this.list = new ArrayList<>();
    }

    public List<ManagerPO> getList() {
        return list;
    }

    public void setList(List<ManagerPO> list) {
        this.list = list;
    }
}
