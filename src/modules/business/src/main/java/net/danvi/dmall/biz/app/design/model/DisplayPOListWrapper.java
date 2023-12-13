package net.danvi.dmall.biz.app.design.model;

import java.util.ArrayList;
import java.util.List;

import javax.validation.Valid;

import dmall.framework.common.model.BaseModel;

/**
 * Created by dong on 2016-05-11.
 */
public class DisplayPOListWrapper extends BaseModel<DisplayPOListWrapper> {
    @Valid
    private List<DisplayPO> list;

    public DisplayPOListWrapper() {
        this.list = new ArrayList<>();
    }

    public List<DisplayPO> getList() {
        return list;
    }

    public void setList(List<DisplayPO> list) {
        this.list = list;
    }
}
