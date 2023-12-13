package net.danvi.dmall.biz.app.goods.model;

import dmall.framework.common.model.BaseModel;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.util.List;

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
public class WearImageSetPO extends BaseModel<WearImageSetPO>{

    // 착용샷 이미지 세트 번호
    private long wearImgsetNo;
    // 상품 번호
    private String goodsNo;

    // 브랜드 번호
    private String brandNo;

    // 대표이미지 세트 여부
    private String dlgtImgYn;
    // 저장 대상인지 여부 (화면에 변화가 있었을 경우 'I'값을 설정)
    private String registFlag;
    // 순번
    private String idx;
    // 이미지 구분
    private String imgGb;

    // 착용샷 이미지 상세 리스트
    private List<WearImageDtlPO> goodsWearImageList;

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
