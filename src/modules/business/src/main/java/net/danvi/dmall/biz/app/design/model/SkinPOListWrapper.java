package net.danvi.dmall.biz.app.design.model;

import java.util.ArrayList;
import java.util.List;

import javax.validation.Valid;

import dmall.framework.common.model.BaseModel;

/**
 * Created by dong on 2016-05-11.
 */
public class SkinPOListWrapper extends BaseModel<SkinPOListWrapper> {
    @Valid
    private List<SkinPO> list;

    public SkinPOListWrapper() {
        this.list = new ArrayList<>();
    }

    public List<SkinPO> getList() {
        return list;
    }

    public void setList(List<SkinPO> list) {
        this.list = list;
    }
}
