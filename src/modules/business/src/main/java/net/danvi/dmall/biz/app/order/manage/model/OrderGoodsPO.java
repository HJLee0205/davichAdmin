package net.danvi.dmall.biz.app.order.manage.model;

import java.util.Date;
import java.util.List;

import lombok.Data;
import lombok.EqualsAndHashCode;
import dmall.framework.common.model.BaseModel;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 5. 2.
 * 작성자     : dong
 * 설명       : 주문상품정보(등록,수정)
 * </pre>
 */
@Data
@EqualsAndHashCode
public class OrderGoodsPO extends BaseModel<OrderGoodsPO> {

    /** 주문상품 정보 **/
    // 주문 번호
    private long ordNo;
    // 주문 상세 순번
    private long ordDtlSeq;
    // 주문 상세 상태 코드
    private String ordDtlStatusCd;
    // 상품 번호
    private String goodsNo;
    // 단품 번호
    private String itemNo;
    // 브랜드 번호
    private String brandNo;
    // 사은품 번호
    private long freebieNo;
    // 상품 명
    private String goodsNm;
    // 단품 명
    private String itemNm;
    // 주문 수량
    private long ordQtt;

    // 소비자 금액
    private long customerAmt;
    // 공급 금액
    private long supplyAmt;
    // 판매 금액
    private long saleAmt;
    // 할인 금액
    private long dcAmt;
    // 상품 준비 일시
    private Date goodsReadyDttm;
    // 출고 지시 일시
    private Date rlsCmdDttm;
    // 출고 완료 일시
    private Date rlsCmpltDttm;
    // 배송 완료 일시
    private Date dlvrCmpltDttm;
    // 상품 평가 등록 여부
    private String goodsEstmRegYn;
    // 배송비 번호
    private long dlvrcNo;
    // 배송 희망 일자
    private String dlvrWishDt;
    // 추가 옵션 여부
    private String addOptYn;
    // 옵션 번호
    private long optNo;
    // 옵션 명
    private String optNm;
    // 옵션 상세 순번
    private long optDtlSeq;
    // 카테고리 번호
    private long ctgNo;
    // 결제 당시 원본 배송비
    private long dlvrOrgAmt;
    // 결제 당시 배송비
    private long dlvrAmt;

    // 판매자번호
    private String sellerNo;

    /** 상품 배송비 **/
    // 배송 번호
    private long dlvrNo;
    // 배송 처리 유형 코드
    private String dlvrPrcTypeCd;
    // 출고 택배사 코드
    private String rlsCourierCd;
    // 출고 송장 번호
    private String rlsInvoiceNo;
    // 출고 송장 등록일시
    private String rlsInvoiceRegDttm;
    // 출고 완료 등록일시
    private String rlsCmpltRegDttm;
    // 반품 택배사 코드
    private String returnCourierCd;
    // 반품 송장 번호
    private String returnInvoiceNo;
    // 출고 송장 등록일시
    private String returnInvoiceRegDttm;
    // 출고 완료 등록일시
    private String returnCmpltRegDttm;
    // 배송 수량
    private int dlvrQtt;
    // 배송 메세지
    private String dlvrMsg;
    // 지역 배송 설정 번호
    private long areaDlvrSetNo;
    // 주문 클레임 구분 코드
    private String ordClaimGbCd;
    // 클레임 번호
    private long claimNo;
    // 클레임 상세 순번
    private long claimDtlSeq;
    // 원본 배송 금액
    private long orgDlvrAmt;
    // 실 배송 금액
    private long realDlvrAmt;
    // 배송비 결제 코드
    private String dlvrcPaymentCd;
    // 배송비 결제 방법
    private String dlvrcPaymentNm;
    private long   dlvrAddAmt;       //추가 배송비 실주문상품테이블에 들어갈거
    // 지역 추가 배송비
    private long areaAddDlvrc;
    // 배송 설정 코드(상품테이블의 배송설정 코드와 동일)
    private String dlvrSetCd;
    // 배송 순번(묶음배송 관련)
    private int dlvrSeq;

    /** 부가비용 정보 **/
    // 부가 비용 번호
    private long addedAmountNo;
    // 원본 부가 비용 번호
    private long orgAddedAmountNo;
    // 부가 비용 구분 코드
    private String addedAmountGbCd;
    // 부가 비용 금액
    private long addedAmountAmt;
    // 회원 번호
    private long memberNo;
    // 프로모션 번호
    private long prmtNo;
    // 부가 비용 혜택 코드
    private String addedAmountBnfCd;
    // 부가 비용 헤택 값
    private long addedAmountBnfValue;

    /** 사은품정보 **/
    // 주문 사은품 순번
    private long ordFreebieSeq;
    // 사은품 리스트
    private List<OrderGoodsPO> freebieList;
    // 부가비용 리스트
    private List<OrderGoodsPO> addedAmountList;

    private String[] ordDtlSeqArr;// 선택한 상품상세순번

    /** 상품 마켓포인트 정책 사용 여부(Y:사이트설정,N:상품설정) */
    private String goodsSvmnPolicyUseYn;
    /** 상품 마켓포인트 금액 */
    private long goodsSvmnAmt;
    /** 상품 마켓포인트 추천인 적립금액 */
    private long recomSvmnAmt;

    private String bankCd;// 은행코드
    private String actNo;// 계좌번호
    private String holderNm;// 예금주
    
    //예약전용상품
    private String rsvOnlyYn;
    // 클레임 수량
    private long claimQtt;
    
    /** 상품 마켓포인트 적립금액 */
    private long pvdSvmn;
    
    /** 상품 마켓포인트 사용금액 */
    private long goodsDmoneyUseAmt;

    /** 스템프 **/
    private String stampYn;

}
