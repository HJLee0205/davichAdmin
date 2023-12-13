package net.danvi.dmall.biz.app.seller.model;

import java.util.ArrayList;
import java.util.List;

import javax.validation.Valid;

import dmall.framework.common.model.BaseModel;

/**
 * Created by khy on 2017-12-18.
 */
public class CalcDeductVOListWrapper {
    @Valid
    private List<CalcDeductVO> list;

    public CalcDeductVOListWrapper() {
        this.list = new ArrayList<>();
    }

    public List<CalcDeductVO> getList() {
        return list;
    }

    public void setList(List<CalcDeductVO> list) {
        this.list = list;
    }
}
