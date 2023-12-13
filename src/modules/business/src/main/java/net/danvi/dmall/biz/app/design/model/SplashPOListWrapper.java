package net.danvi.dmall.biz.app.design.model;

import dmall.framework.common.model.BaseModel;

import javax.validation.Valid;
import java.util.ArrayList;
import java.util.List;

/**
 * Created by dong on 2016-05-11.
 */
public class SplashPOListWrapper extends BaseModel<SplashPOListWrapper> {
    @Valid
    private List<SplashPO> list;

    public SplashPOListWrapper() {
        this.list = new ArrayList<>();
    }

    public List<SplashPO> getList() {
        return list;
    }

    public void setList(List<SplashPO> list) {
        this.list = list;
    }
}
