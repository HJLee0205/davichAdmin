package net.danvi.dmall.biz.app.promotion.timedeal.model;

import dmall.framework.common.model.BaseModel;
import lombok.Data;
import lombok.EqualsAndHashCode;

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
public class TimeDealTargetVO extends BaseModel<TimeDealTargetVO> {
    // 타임딜 대상 상품
    private String prmtNo;
    private String prmtNm;
    private String goodsNo;
    private String goodsNm;
    private String goodsTypeCd;
    private String ctgName;
    private String applySeq;
}
