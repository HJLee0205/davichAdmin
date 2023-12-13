package net.danvi.dmall.biz.app.promotion.freebiecndt.model;

import lombok.Data;
import lombok.EqualsAndHashCode;
import dmall.framework.common.model.BaseModel;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 5. 4.
 * 작성자     : 이헌철
 * 설명       : 사은품이벤트 사은품상품 vo
 * </pre>
 */
@Data
@EqualsAndHashCode
public class FreebieGoodsVO extends BaseModel<FreebieGoodsVO> {
    private int freebieEventNo;
    private String freebieNo;
    private String freebieNm;
    private String imgPath;
    private String imgNm;
    private int freebieEventAmt; // 사은품지급 충족금액
    private String freebiePresentCndtCd; // 사은품 증정조건 : 01 일정금액 이상 구매 시, 02 개별상품 구매 시
    private String freebieEventDscrt;
    private String simpleDscrt;
}
