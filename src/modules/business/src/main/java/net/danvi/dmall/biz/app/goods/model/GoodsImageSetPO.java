package net.danvi.dmall.biz.app.goods.model;

import java.util.List;

import lombok.Data;
import lombok.EqualsAndHashCode;
import dmall.framework.common.model.BaseModel;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 5. 2.
 * 작성자     : kwt
 * 설명       : 상품 이미지세트 정보 등록 Parameter Object
 * </pre>
 */
@Data
@EqualsAndHashCode
public class GoodsImageSetPO extends BaseModel<GoodsImageSetPO> {
    // 이미지 세트 번호
    private long goodsImgsetNo;
    // 상품 번호
    private String goodsNo;
    // 대표이미지 세트 여부
    private String dlgtImgYn;
    // 이미지 상세 리스트
    private List<GoodsImageDtlPO> goodsImageDtlList;
    // 저장 대상인지 여부 (화면에 변화가 있었을 경우 'I'값을 설정)
    private String registFlag;
    // 순번
    private String idx;
    // 이미지 구분
    private String imgGb;
}
