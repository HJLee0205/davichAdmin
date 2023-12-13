package net.danvi.dmall.biz.app.promotion.freebiecndt.model;

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
 * 작성일     : 2016. 5. 4.
 * 작성자     : 이헌철
 * 설명       : 사은품이벤트 삭제 listWrapper
 * </pre>
 */

@Data
@EqualsAndHashCode
public class FreebieCndtPOListWrapper extends BaseModel<T> {
    /**
     * 
     */
    private static final long serialVersionUID = -7896379544594863041L;
    @Valid
    public int freebieEventNo;

    private List<FreebieCndtPO> list;

    public FreebieCndtPOListWrapper() {
        this.list = new ArrayList<>();
    }

}
