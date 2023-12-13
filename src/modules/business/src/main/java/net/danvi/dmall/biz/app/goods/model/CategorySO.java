package net.danvi.dmall.biz.app.goods.model;

import lombok.Data;
import lombok.EqualsAndHashCode;
import dmall.framework.common.model.BaseSearchVO;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 6. 22.
 * 작성자     : kjw
 * 설명       : 카테고리 정보 관리 검색 조건의 Search Object 클래스
 * </pre>
 */
@Data
@EqualsAndHashCode
public class CategorySO extends BaseSearchVO<CategorySO> {
    // 카테고리 번호
    private String ctgNo;
    // 카테고리 명
    private String ctgNm;
    // 카테고리 타입
    private String ctgType;
    // 카테고리 레벨
    private String ctgLvl;
    // 상위 카테고리 번호
    private String upCtgNo;
    // 카테고리 전시존 번호
    private String ctgDispzoneNo;
    // 전시유형타입
    private String displayTypeCd;
    // 정렬기준
    private String sortType;

    private String searchType;

    private String searchVal;

    //필터유형코드
    private String goodsTypeCd;
    //필터구분코드
    private String[] filterGbCd;

    //브랜드
    private String[] searchBrands;

    private String[] frameColorCd;
    private String[] sunglassColorCd;
    private String[] glassColorCd;
    private String[] contactColorCd;
    private String[] frameShapeCd;
    private String[] sunglassShapeCd;
    private String[] frameMaterialCd;
    private String[] sunglassMaterialCd;
    private String[] frameSizeCd;
    private String[] sunglassSizeCd;

    private String[] sunglassLensColorCd;
    private String[] glassUsageCd;
    private String[] glassFocusCd;
    private String[] glassFunctionCd;
    private String[] glassMmftCd;
    private String[] glassThickCd;
    private String[] glassDesignCd;
    private String[] contactCycleCd;
    private String[] contactSizeCd;
    private String[] contactPriceCd;
    private String[] contactStatusCd;
    private String[] aidShapeCd;
    private String[] aidLosstypeCd;
    private String[] aidLossdegreeCd;

    private String stPrice;
    private String endPrice;

    private String searchAll;
    
    private String udv1;
    
    private String bestCtg;

    private String wearYn;
}
