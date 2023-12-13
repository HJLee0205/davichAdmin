package net.danvi.dmall.biz.app.goods.model;

import lombok.Data;
import lombok.EqualsAndHashCode;
import dmall.framework.common.model.BaseSearchVO;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2019. 6. 17.
 * 작성자     : hskim
 * 설명       : 렌즈 착용샷 상세 정보 등록 Parameter Object
 * </pre>
 */
@Data
@EqualsAndHashCode
public class ContactWearSO extends BaseSearchVO<ContactWearSO> {
    // 상품 번호
    private String goodsNo;
    // 착용샷 이미지 유형
    private String wearImgType;
    // 렌즈 이미지 유형
    private String lensImgType;
    // 브랜드번호
    private String brandNo;
    // 렌즈 이미지 세트 번호 배열
    private String arrWearImgsetNo;

}
