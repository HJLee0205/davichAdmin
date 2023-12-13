package net.danvi.dmall.biz.app.goods.model;

import dmall.framework.common.model.BaseSearchVO;
import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2022. 9. 28.
 * 작성자     : slims
 * 설명       : keyword 정보 관리 검색 조건의 Search Object 클래스
 * </pre>
 */
@Data
@EqualsAndHashCode
public class KeywordSO extends BaseSearchVO<KeywordSO> {
    // keyword 번호
    private String keywordNo;
    // keyword 명
    private String keywordNm;
    // keyword 레벨
    private String keywordLvl;
    // 상위 keyword 번호
    private String upKeywordNo;
    // keyword menu type
    private String keywordMenuType;
    // 전시유형타입
    private String displayTypeCd;
    // 정렬기준
    private String sortType;

    private String searchType;

    private String searchVal;

    //필터유형코드
    private String keywordTypeCd;
    //필터구분코드
    private String[] keywordGbCd;

    //브랜드
    private String[] searchBrands;

    private String stPrice;
    private String endPrice;

    private String searchAll;
    
    private String udv1;
    
    private String bestKeyword;

    private String wearYn;

    // keyword type
    private String keywordType;
    // keyword slide typ min value
    private String keywordSlideMin;
    // keyword slide typ max value
    private String keywordSlideMax;
    // keyword child code
    private String keywordChildCd;
}
