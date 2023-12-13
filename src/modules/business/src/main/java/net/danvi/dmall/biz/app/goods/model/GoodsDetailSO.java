package net.danvi.dmall.biz.app.goods.model;

import lombok.Data;
import lombok.EqualsAndHashCode;
import dmall.framework.common.model.BaseSearchVO;

import java.util.List;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 5. 2.
 * 작성자     : dong
 * 설명       : 상품 상세 정보 Search Object
 * </pre>
 */
@Data
@EqualsAndHashCode
public class GoodsDetailSO extends BaseSearchVO<GoodsDetailSO> {
    // 상품 번호
    private String goodsNo;
    // 단품 번호
    private String itemNo;
    // 고시 번호
    private String notifyNo;
    // 카테고리 번호
    private String ctgNo;
    // 삭제 여부
    private String delYn;
    // 장바구니 세션 No
    private int sessionIndex;
    // 추가 옵션 번호
    private long addOptNo;
    // 추가 옵션 상세 번호
    private long addOptDtlSeq;
    // 판매 여부
    private String saleYn;
    // 단품 정보
    private List<String> itemNoArr;
    // 판매상태여부(1:판매중,2:품절,3:판매대기,4:판매중지)
    private String[] goodsStatus;

    // 전시여부?
    private String dispYn;
    private String brandNo;

    private String wordFrom; //브랜드관 초성검색
    private String wordTo;	//브랜드관 초성검색

    private String goodsTypeCd;
    
    // 상품상세 문의탭을 바로 띄우기위한 처리
    private String opt;
    //필터유형코드
    private String filterTypeCd;
    private long freebieEventAmt; // 사은품지급 충족금액

    private String ordNo;
    private List<String> ordDtlSeqArr;

    private String goodsStampTypeCd;
    private long memberNo;

    private String typeCd;
}
