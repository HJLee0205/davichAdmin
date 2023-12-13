package net.danvi.dmall.biz.app.goods.model;

import dmall.framework.common.model.BaseModel;
import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 5. 2.
 * 작성자     : kwt
 * 설명       : 상품 카테고리 선택 정보 Parameter Object
 * </pre>
 */
@Data
@EqualsAndHashCode
public class GoodsFaceCdPO extends BaseModel<GoodsFaceCdPO> {
    // 상품 번호
    private String goodsNo;
    // 얼굴 PD
    private String facePd;
    // 얼굴 너비
    private String faceWidth;
    // 얼굴형
    private String faceShape;
    // 안경테 사이즈
    private String glassesSize;
    // FACE CODE SIZE
    private String fdSize;
    // FACE CODE SHAPE
    private String fdShape;
    // FACE CODE TONE
    private String fdTone;
    // FACE CODE STYLE
    private String fdStyle;
    // EYE CODE SHAPE
    private String edShape;
    // EYE CODE SIZE
    private String edSize;
    // EYE CODE STYLE
    private String edStyle;
    // EYE CODE COLOR
    private String edColor;

}
