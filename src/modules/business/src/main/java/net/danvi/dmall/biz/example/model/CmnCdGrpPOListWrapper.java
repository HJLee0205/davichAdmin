package net.danvi.dmall.biz.example.model;

import java.util.ArrayList;
import java.util.List;

import javax.validation.Valid;

import org.apache.poi.ss.formula.functions.T;

import dmall.framework.common.model.BaseModel;

/**
 * Created by dong on 2016-04-20.
 */
public class CmnCdGrpPOListWrapper extends BaseModel<T> {

    private static final long serialVersionUID = -6356882663672372386L;

    @Valid
    private List<CmnCdGrpPO> list;

    public CmnCdGrpPOListWrapper() {
        this.list = new ArrayList<>();
    }

    /**
     * @return the list
     */
    public List<CmnCdGrpPO> getList() {
        return list;
    }

    /**
     * @param list
     *            the list to set
     */
    public void setList(List<CmnCdGrpPO> list) {
        this.list = list;
    }

}
