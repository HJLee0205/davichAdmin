package net.danvi.dmall.biz.app.promotion.freebiecndt.model;

import lombok.Data;
import lombok.EqualsAndHashCode;
import dmall.framework.common.model.BaseModel;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 5. 4.
 * 작성자     : 이헌철
 * 설명       : 사은품이벤트 사은품대상 vo
 * </pre>
 */
@Data
@EqualsAndHashCode
public class FreebieTargetVO extends BaseModel<FreebieTargetVO> {
    private int freebieEventNo;
    private String freebieEventNm;
    private String goodsNo;
    private String goodsNm;
    private String imgPath;
}
