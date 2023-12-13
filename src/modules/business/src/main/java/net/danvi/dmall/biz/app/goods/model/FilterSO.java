package net.danvi.dmall.biz.app.goods.model;

import dmall.framework.common.model.BaseSearchVO;
import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2022. 9. 28.
 * 작성자     : slims
 * 설명       : filter 정보 관리 검색 조건의 Search Object 클래스
 * </pre>
 */
@Data
@EqualsAndHashCode
public class FilterSO extends BaseSearchVO<FilterSO> {
    // filter 번호
    private String filterNo;
    // filter 명
    private String filterNm;
    // filter 레벨
    private String filterLvl;
    // 상위 filter 번호
    private String upFilterNo;
    // filter menu type
    private String filterMenuType;
    // 전시유형타입
    private String displayTypeCd;
    // 정렬기준
    private String sortType;

    private String searchType;

    private String searchVal;

    //필터유형코드
    private String filterTypeCd;
    //필터구분코드
    private String[] filterGbCd;

    //브랜드
    private String[] searchBrands;

    private String stPrice;
    private String endPrice;

    private String searchAll;
    
    private String udv1;
    
    private String bestFilter;

    private String wearYn;

    // filter type
    private String filterType;
    // filter slide typ min value
    private String filterSlideMin;
    // filter slide typ max value
    private String filterSlideMax;
    // filter child code
    private String filterChildCd;
    // filter 상품 유형 code
    private String goodsTypeCd;

    // filter 메뉴 레벨
    private String filterMenuLvl;
    // filter 메뉴 아이템 레벨
    private String filterItemLvl;

    // filter 선택된 필터 번호
    private String selectedFilterNo;

    // 상품 번호
    private String goodsNo;
}
