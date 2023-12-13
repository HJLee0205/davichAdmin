package net.danvi.dmall.biz.app.goods.model;

import java.util.ArrayList;
import java.util.List;

import javax.validation.Valid;

import dmall.framework.common.model.BaseModel;

/**
 * Created by dong on 2016-06-01.
 */
public class DisplayGoodsListWrapper extends BaseModel<DisplayGoodsListWrapper> {
    @Valid
    private List<DisplayGoodsPO> list;

    public DisplayGoodsListWrapper() {
        this.list = new ArrayList<>();
    }

    public List<DisplayGoodsPO> getList() {
        return list;
    }

    public void setList(List<DisplayGoodsPO> list) {
        this.list = list;
    }
}
