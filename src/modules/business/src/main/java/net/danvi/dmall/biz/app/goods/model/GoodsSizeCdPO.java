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
public class GoodsSizeCdPO extends BaseModel<GoodsSizeCdPO> {

    private String goodsNo;
    // 얼굴 PD
    private String fullSize;
    // 브릿지 길이
    private String bridgeSize;
    // 가로 길이
    private String horizontalLensSize;
    // 세로 길이
    private String verticalLensSize;
    // 다리 길이
    private String templeSize;

}
