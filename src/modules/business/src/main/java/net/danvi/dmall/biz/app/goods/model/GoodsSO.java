package net.danvi.dmall.biz.app.goods.model;

import lombok.Data;
import lombok.EqualsAndHashCode;

import java.util.ArrayList;
import java.util.List;

import dmall.framework.common.constraint.NullOrLength;
import dmall.framework.common.model.BaseSearchVO;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 5. 2.
 * 작성자     : dong
 * 설명       : 상품 정보 Search Object
 * </pre>
 */
@Data
@EqualsAndHashCode
public class GoodsSO extends BaseSearchVO<GoodsSO> {
    // 검색 카테고리 1
    @NullOrLength(min = 1, max = 3)
    private String searchCtg1;
    // 검색 카테고리 2
    private String searchCtg2;
    // 검색 카테고리 3
    private String searchCtg3;
    // 검색 카테고리 4
    private String searchCtg4;
    // 검색 카테고리
    private String searchCtg;
    // 검색 브랜드
    private String searchBrand;
    // 브랜드 정보
    private String[] searchBrands;
    // 필터 정보
    private String filters;
    private String[] searchFilters;
    // 상품 번호
    private String goodsNo;
    // 단품 번호
    private String itemNo;
    // 검색 일자 유형
    private String searchDateType;
    // 검색 일자 시작일
    private String searchDateFrom;
    // 검색 일자 종료일
    private String searchDateTo;
    // 검색 가격 시작
    private String searchPriceFrom;
    // 검색 가격 종료
    private String searchPriceTo;
    // 상품 번호 정보
    private String[] goodsNos;
    // 상품 상태 정보
    private String[] goodsStatus;
    // 상품 전시 정보
    private String[] goodsDisplay;
    // 판매자
    private String searchSeller;
    // 판매자 로그인
    private String searchSellerLogin;
    // 검색 유형
    private String searchType;
    // 검색 어
    private String searchWord;
    // 정렬 기준
    private String sortType;
    // 전시 타입
    private String displayTypeCd;
    // 판매여부 (프론트에서 설정)
    private String saleYn;

    //필터유형코드
    private String filterTypeCd;
    //필터구분코드
    private String[] filterGbCd;

    private String[] frameColorCd;
    private String[] sunglassColorCd;
    private String[] glassColorCd;
    private String[] contactColorCd;
    private String[] frameShapeCd;
    private String[] sunglassShapeCd;
    private String[] frameMaterialCd;
    private String[] sunglassMaterialCd;
    private String[] contactMaterialCd;
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
    private String[] contactFocusCd;
    private String[] contactSizeCd;
    private String[] contactPriceCd;
    private String[] contactStatusCd;
    private String[] aidShapeCd;
    private String[] aidLosstypeCd;
    private String[] aidLossdegreeCd;

    private String stPrice;
    private String endPrice;
    
    // 비전체크 후 검색
    private String searchVisionCtg;
    private String searchVisionCtgNm;
    private List<String> ctgMap = new ArrayList<>();
    
    private String searchVisionCtgAll;
    private String searchVisionCtgNmAll;

    private String searchErpItmCd;
    private String[] erpMapYn;
    
    //보청기 추천 후 검색
    private String searchGoodsNos;
    private List<String> goodsNoMap = new ArrayList<>();
    
    //상품조회시 사전예약상품 제외 여부를 판별하기 위해 추가
    private String adminYn;
    
    //비전체크 상품군 번호
    private String gunNo;

    // 상품 컨텐츠 구분 코드
    private String goodsContsGbCd;

    // 상품 컨텐츠 구분 코드(팝업검색조건)
    private String srchGoodsContsGbCd;

    // 상품 구분 코드
    private String goodsTypeCd;

    // 페이지 구분 코드
    private String typeCd;

    // 내 코드 정보 - 안경추천사이즈
    private String faceSizeCd;
    // 내 코드 정보 - 얼굴형
    private String faceShapeCd;
    // 내 코드 정보 - 피부톤
    private String faceSkinToneCd;
    // 내 코드 정보 - 스타일
    private String faceStyleCd;
    // 내 코드 정보 - 눈 모양
    private String eyeShapeCd;
    // 내 코드 정보 - 눈 사이즈
    private String eyeSizeCd;
    // 내 코드 정보 - 눈 스타일
    private String eyeStyleCd;
    // 내 코드 정보 - 동공색
    private String eyeColorCd;

    // 일반
    private String normalYn;
    // 신상품
    private String newGoodsYn;
    // 스탬프 적립 상품
    private String stampYn;
    // 웹발주용
    private String mallOrderYn;

    private String sellerYn;
}
