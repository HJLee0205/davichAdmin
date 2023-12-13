package net.danvi.dmall.biz.app.goods.model;

import java.util.ArrayList;
import java.util.List;

import javax.validation.Valid;

import dmall.framework.common.model.BaseModel;

/**
 * Created by dong on 2016-05-11.
 */
/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 9. 27.
 * 작성자     : dong
 * 설명       : 재입고 알립 목록 Parameter Object Wrapper 클래스
 * </pre>
 */
public class RestockNotifyPOListWrapper extends BaseModel<RestockNotifyPOListWrapper> {

    @Valid
    private List<RestockNotifyPO> list;

    public RestockNotifyPOListWrapper() {
        this.list = new ArrayList<>();
    }

    public List<RestockNotifyPO> getList() {
        return list;
    }

    public void setList(List<RestockNotifyPO> list) {
        this.list = list;
    }
}
