package net.danvi.dmall.biz.app.promotion.event.model;

import java.util.ArrayList;
import java.util.List;

import javax.validation.Valid;

import org.apache.poi.ss.formula.functions.T;

import lombok.Data;
import lombok.EqualsAndHashCode;
import dmall.framework.common.model.BaseModel;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 5. 3.
 * 작성자     : dong
 * 설명       :
 * </pre>
 */
@Data
@EqualsAndHashCode
public class EventPOListWrapper extends BaseModel<T> {

    private static final long serialVersionUID = -455957433477598430L;
    @Valid
    private int eventNo;

    private long lettNo;

    private List<EventPO> list;

    public EventPOListWrapper() {
        this.list = new ArrayList<>();
    }

}
