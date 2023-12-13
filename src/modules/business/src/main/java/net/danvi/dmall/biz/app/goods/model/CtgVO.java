package net.danvi.dmall.biz.app.goods.model;

import lombok.Data;
import lombok.EqualsAndHashCode;
import dmall.framework.common.model.BaseModel;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 5. 2.
 * 작성자     : dong
 * 설명       : 카테고리 정보 Value Object
 * </pre>
 */
@Data
@EqualsAndHashCode
public class CtgVO extends BaseModel<CtgVO> {
    // 카테고리 번호
    private String ctgNo;
    // 카테고리 레벨
    private String ctgLvl;
    // 카테고리 명
    private String ctgNm;
    // 상위 카테고리 번호
    private String upCtgNo;
    // 전시 여부
    private String dispYn;
    // 카테고리 수수료율
    private String ctgCmsRate;
    // 카테고리 타입
    private String ctgType;
    // 카테고리 M: Mandatory, O: Optional
    private String ctgRequire;

    // 상품 컨텐츠 구분 코드
    private String goodsContsGbCd;
    // 상품 유형 구분 코드
    private String goodsTypeCd;

}
