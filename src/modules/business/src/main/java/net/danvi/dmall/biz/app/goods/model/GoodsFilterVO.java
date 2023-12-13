package net.danvi.dmall.biz.app.goods.model;

import lombok.Data;
import lombok.EqualsAndHashCode;

import java.io.Serializable;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 5. 2.
 * 작성자     : kwt
 * 설명       : 상품 필터 정보 Value Object
 * </pre>
 */
@Data
@EqualsAndHashCode
public class GoodsFilterVO implements Serializable {

    private static final long serialVersionUID = -5209866107423256041L;

    // 상품 번호
    private String goodsNo;
    // 필터 번호
    private String filterNo;
    // 삭제 여부
    private String delYn;
    // 등록 FLAG
    private String registFlag;
    // 필터 경로 (화면표시용)

}
