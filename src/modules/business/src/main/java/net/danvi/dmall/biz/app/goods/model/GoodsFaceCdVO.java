package net.danvi.dmall.biz.app.goods.model;

import lombok.Data;
import lombok.EqualsAndHashCode;

import java.io.Serializable;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 5. 2.
 * 작성자     : kwt
 * 설명       : 상품 카테고리 정보 Value Object
 * </pre>
 */
@Data
@EqualsAndHashCode
public class GoodsFaceCdVO implements Serializable {

    private static final long serialVersionUID = 7870255258301607073L;

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
