package net.danvi.dmall.biz.app.seller.model;

import java.util.ArrayList;
import java.util.List;

import javax.validation.Valid;

import dmall.framework.common.model.BaseModel;

/**
 * Created by khy on 2017-12-18.
 */
public class CalcVOListWrapper {
    @Valid
    private List<CalcVO> list;

    public CalcVOListWrapper() {
        this.list = new ArrayList<>();
    }

    public List<CalcVO> getList() {
        return list;
    }

    public void setList(List<CalcVO> list) {
        this.list = list;
    }
}
