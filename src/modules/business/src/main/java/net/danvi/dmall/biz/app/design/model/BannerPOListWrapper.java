package net.danvi.dmall.biz.app.design.model;

import java.util.ArrayList;
import java.util.List;

import javax.validation.Valid;

import dmall.framework.common.model.BaseModel;

/**
 * Created by dong on 2016-07-04.
 */
public class BannerPOListWrapper extends BaseModel<BannerPOListWrapper> {
    @Valid
    private List<BannerPO> list;

    public BannerPOListWrapper() {
        this.list = new ArrayList<>();
    }

    public List<BannerPO> getList() {
        return list;
    }

    public void setList(List<BannerPO> list) {
        this.list = list;
    }
}
