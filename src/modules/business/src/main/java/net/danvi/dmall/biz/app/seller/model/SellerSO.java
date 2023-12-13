package net.danvi.dmall.biz.app.seller.model;

import dmall.framework.common.annotation.Encrypt;
import dmall.framework.common.util.CryptoUtil;
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
public class SellerSO extends BaseSearchVO<SellerSO> {
    private Long siteNo; // 사이트 번호
    private String sellerNo; // 판매자 번호
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String sellerId; // 판매자ID
    private String sellerNm; // 판매자명
    private String managerTelno; // 담당자 전화번호
    private String managerEmail; // 담당자 이메일
    private String searchType;     // 검색타입
    private String searchWords;     // 검색어
    private String inputGbn;     // 입력구분
    private String statusCd;     // 상태
    private String fromApvDt;    //승인 시작일자
    private String toApvDt;      //승인 종료일자
    private String calcStart;    //정산 종료일자
    private String calcEnd;      //정산 종료일자
    private Long regrNo;       
    private String calculateNo;   //정산번호
    private String yr;   //조회년도
    private String mm;   //조회월
    private String call;
    
    private String calculateStartdt;  //정산기준일 시작일
    private String calculateEnddt;   //정산기준일 종료일
    private String calculateDttm;    //정산일자
    
    private String searchDate;    //정산일자,정산기준일자
    private String searchOrdNo;    //주문번호
    private String searchGoodsNm;    //주문번호
    private String searchGb;
    private String calculateGb;
    
    //검색어
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String searchSellerId;
    private String searchSellerNm;
    private String searchManagerTelNo;
    private String searchManagerEmail;

    private String[] storeInquiryGbCds;    // 입점 문의 구분 코드
    private String storeInquiryGbCd;
    private String fromRegDt;
    private String toRegDt;
    private String[] statusCds;
}
