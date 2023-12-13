package net.danvi.dmall.biz.app.interest.model;

import lombok.Data;
import lombok.EqualsAndHashCode;
import dmall.framework.common.model.BaseModel;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 5. 2.
 * 작성자     : dong
 * 설명       :
 * </pre>
 */
@Data
@EqualsAndHashCode
public class InterestPO extends BaseModel<InterestPO> {

    private Long memberNo;
    // private String itemNo;
    private String goodsNo; // 상품번호
    private String[] goodsNoArr; // 상품번호 배열
    private String itemNo; // 단품번호
    private String[] itemNoArr; // 단품번호 배열
    private String ctgNo; // 대표 카테고리 여부
}
