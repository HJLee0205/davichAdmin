package net.danvi.dmall.biz.app.goods.model;

import dmall.framework.common.model.BaseModel;
import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2019. 6. 17.
 * 작성자     : kwt
 * 설명       : 렌즈 착용샷 상세 정보 Value Object
 * </pre>
 */
@Data
@EqualsAndHashCode
public class ContactWearVO extends BaseModel<ContactWearVO> {
    // 상품 번호
    private String goodsNo;
    // 착용샷 이미지 세트 번호
    private long wearImgsetNo;
    // 착용샷 이미지 유형
    private String wearImgType;
    // 착용샷 이미지 경로
    private String imgPath;
    // 착용샷 이미지 명
    private String imgNm;
    // 렌즈 이미지 경로
    private String lensImgPath;
    // 렌즈 이미지 명
    private String lensImgNm;
    // 렌즈 이미지 세트 번호 배열
    private String arrWearImgsetNo;

    private String wearGoodsNm;
    private String colorValue;
    private String wearCycle;
    private String grpDmtr;
    private String materialValue;
    private String uvInterceptionValue;
    private String qttValue;
    private String salePriceValue;
    private String mktBnfValue;
}
