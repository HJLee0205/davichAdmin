package net.danvi.dmall.biz.app.seller.model;

import java.util.ArrayList;
import java.util.List;

import javax.validation.Valid;

import dmall.framework.common.model.BaseModel;

/**
 * Created by khy on 2017-12-18.
 */
public class SellerVOListWrapper extends BaseModel<SellerVOListWrapper> {
    @Valid
    private List<SellerVO> list;

    public SellerVOListWrapper() {
        this.list = new ArrayList<>();
    }

    public List<SellerVO> getList() {
        return list;
    }

    public void setList(List<SellerVO> list) {
        this.list = list;
    }
}
