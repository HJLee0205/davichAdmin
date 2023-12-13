package net.danvi.dmall.biz.app.design.model;

import java.util.ArrayList;
import java.util.List;

import javax.validation.Valid;

import dmall.framework.common.model.BaseModel;

/**
 * Created by dong on 2016-05-11.
 */
public class ImageManagePOListWrapper extends BaseModel<ImageManagePOListWrapper> {
    @Valid
    private List<ImageManagePO> list;

    public ImageManagePOListWrapper() {
        this.list = new ArrayList<>();
    }

    public List<ImageManagePO> getList() {
        return list;
    }

    public void setList(List<ImageManagePO> list) {
        this.list = list;
    }
}
