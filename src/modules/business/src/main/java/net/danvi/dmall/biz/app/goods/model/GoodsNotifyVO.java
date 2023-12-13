package net.danvi.dmall.biz.app.goods.model;

import lombok.Data;
import lombok.EqualsAndHashCode;
import dmall.framework.common.model.BaseSearchVO;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 5. 2.
 * 작성자     : dong
 * 설명       : 상품 고시 정보 Value Object
 * </pre>
 */
@Data
@EqualsAndHashCode
public class GoodsNotifyVO extends BaseSearchVO<GoodsNotifyVO> {
    // 상품 번호
    private String goodsNo;
    // 고시 번호
    private String notifyNo;
    // 고시 명
    private String notifyNm;
    // 상세 항목
    private String dtlItem;
    // 항목 번호
    private String itemNo;
    // 항목 명
    private String itemNm;
    // 상세
    private String dscrt;
    // 항목 값
    private String itemValue;
    // 사용 여부
    private String useYn;
    // 삭제 여부
    private String delYn;
    // 등록 정보
    private String registFlag;
}
