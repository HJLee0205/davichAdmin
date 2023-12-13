package net.danvi.dmall.biz.app.setup.delivery.model;

import java.util.ArrayList;
import java.util.List;

import javax.validation.Valid;

import dmall.framework.common.model.BaseModel;

/**
 * Created by dong on 2016-05-11.
 */
public class DeliveryAreaPOListWrapper extends BaseModel<DeliveryAreaPOListWrapper> {
    @Valid
    private List<DeliveryAreaPO> list;

    public DeliveryAreaPOListWrapper() {
        this.list = new ArrayList<>();
    }

    public List<DeliveryAreaPO> getList() {
        return list;
    }

    public void setList(List<DeliveryAreaPO> list) {
        this.list = list;
    }
}
