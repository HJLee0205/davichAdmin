package net.danvi.dmall.biz.app.design.model;

import java.util.ArrayList;
import java.util.List;

import javax.validation.Valid;

import dmall.framework.common.model.BaseModel;

/**
 * Created by dong on 2016-05-11.
 */
public class PopManagePOListWrapper extends BaseModel<PopManagePOListWrapper> {
    @Valid
    private List<PopManagePO> list;

    public PopManagePOListWrapper() {
        this.list = new ArrayList<>();
    }

    public List<PopManagePO> getList() {
        return list;
    }

    public void setList(List<PopManagePO> list) {
        this.list = list;
    }
}
