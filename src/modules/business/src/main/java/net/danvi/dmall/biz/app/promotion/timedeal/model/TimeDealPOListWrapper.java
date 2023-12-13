package net.danvi.dmall.biz.app.promotion.timedeal.model;

import dmall.framework.common.model.BaseModel;
import lombok.Data;
import lombok.EqualsAndHashCode;
import org.apache.poi.ss.formula.functions.T;

import javax.validation.Valid;
import java.util.ArrayList;
import java.util.List;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 5. 3.
 * 작성자     : 이헌철
 * 설명       :
 * </pre>
 */

@Data
@EqualsAndHashCode
public class TimeDealPOListWrapper extends BaseModel<T> {

    /**
     * 
     */
    private static final long serialVersionUID = -194853115337002666L;
    @Valid
    private int tdNo;

    private List<TimeDealPO> list;

    public TimeDealPOListWrapper() {
        this.list = new ArrayList<>();
    }

}
