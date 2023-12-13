package net.danvi.dmall.biz.app.promotion.coupon.model;

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
 * 작성자     : 이헌철
 * 설명       :
 * </pre>
 */

@Data
@EqualsAndHashCode
public class CouponPOListWrapper extends BaseModel<T> {

    /**
     * 
     */
    private static final long serialVersionUID = -1849236772258145345L;

    @Valid
    private int couponNo;
    private List<CouponPO> list;

    public CouponPOListWrapper() {
        this.list = new ArrayList<>();
    }

}
