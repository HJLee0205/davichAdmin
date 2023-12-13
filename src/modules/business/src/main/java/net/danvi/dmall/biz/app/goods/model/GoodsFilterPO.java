package net.danvi.dmall.biz.app.goods.model;

import dmall.framework.common.model.BaseModel;
import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 5. 2.
 * 작성자     : kwt
 * 설명       : 상품 필터 선택 정보 Parameter Object
 * </pre>
 */
@Data
@EqualsAndHashCode
public class GoodsFilterPO extends BaseModel<GoodsFilterPO> {
    // 상품 번호
    private String goodsNo;
    // 필터 번호
    private String filterNo;
    // 삭제 여부
    private String delYn;
    // 등록 FLAG
    private String registFlag;
    // 상품 복사시 복사원본 상품번호
    private String targetGoodsNo;
    // 상품 복사시 복사생성 상품번호
    private String newGoodsNo;
}
