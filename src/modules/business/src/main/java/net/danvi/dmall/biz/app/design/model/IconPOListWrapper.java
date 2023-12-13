package net.danvi.dmall.biz.app.design.model;

import dmall.framework.common.model.BaseModel;

import javax.validation.Valid;
import java.util.ArrayList;
import java.util.List;

/**
 * Created by dong on 2023-01-17.
 */
public class IconPOListWrapper extends BaseModel<IconPOListWrapper> {
    @Valid
    private List<IconPO> list;

    public IconPOListWrapper() {
        this.list = new ArrayList<>();
    }

    public List<IconPO> getList() {
        return list;
    }

    public void setList(List<IconPO> list) {
        this.list = list;
    }
}
