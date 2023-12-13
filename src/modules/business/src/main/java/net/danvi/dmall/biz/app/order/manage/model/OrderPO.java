package net.danvi.dmall.biz.app.order.manage.model;

import java.util.List;

import dmall.framework.common.model.EditorBasePO;
import lombok.Data;
import lombok.EqualsAndHashCode;
import net.danvi.dmall.biz.app.order.payment.model.OrderPayPO;
import net.danvi.dmall.biz.app.promotion.coupon.model.CouponPO;
import dmall.framework.common.model.BaseModel;
import net.danvi.dmall.core.model.payment.PaymentModel;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 5. 2.
 * 작성자     : dong
 * 설명       : 주문정보 취합(등록)
 * </pre>
 */
@Data
@EqualsAndHashCode
public class OrderPO extends EditorBasePO<OrderPO> {
    /*
     * BaseModel 생성
     * private Long companyNo;
     * private Long siteNo;
     * private Long regrNo;
     * private String regrNm;
     */
    private OrderInfoPO orderInfoPO;// 주문정보&배송지정보
    private List<OrderGoodsPO> orderGoodsPO;// 상품정보
    private OrderPayPO orderPayPO;// 결제정보
    private List<CouponPO> couponPO; // 쿠폰정보
    private PaymentModel paymentModel;//외부결제 리턴값

    private long ordNo;// 주문번호
    private long paymentAmt; // 결제금액
    private long saleAmt; // 판매금액
    private long dcAmt; // 할인금액
    private long mileageTotalAmt; // 마켓포인트 사용금액
    private long pointTotalAmt; // 가맹점 포인트 사용금액
    private String PartCancelYn; // 부분취소여부
    /* front 배열 처리 파라메터 */
    private String[] itemArr; // 아이템 배열(상품번호+아이템정보+추가옵션정보)
    //지역추가배송비
    private long addDlvrAmt;
    // 추천인 회원번호
    private String recomMemberNo;

    /** 주문 번호 */
    private String[] ordNoArr;
    /** 주문 상세 순번 */
    private String[] ordDtlSeqArr;
    /** 주문 상세 상태 코드 */
    private String[] ordDtlStatusCdArr;
    private long ordDtlSeq;

    /** 클레임 번호 상세정보 */
    private String claimNo;
    private String[] claimNoArr;
    private String[] ordDtlGoodsNoArr;
    private String[] ordDtlItemNoArr;
    private String[] claimReasonCdArr;
    private String[] claimQttArr;
    private String[] claimReturnCdArr;
    private String[] claimExchangeCdArr;

    /** 환불결제정보테이블용 계좌정보 **/
    private String bankCd;
    private String holderNm;
    private String actNo;
    private long totalDlvrPrice;

    private String paymentNo;
    private String refundTypeCd;
    private String refundMemo;
    private String refundStatusCd;
    private String pgType;
    private long pgAmt; // 환불 결제금액 ( pg/ 무통장 ), 210-해당 상품(취소할 상품결제했을때 금액)을 결제할때 결제한금액(포인트를 해용햇다면 그것도 차감 쿠폰도 배송비도 같이 포함된급액이다)
    private long orgPgAmt; // 원 결제금액, 210-상품 결제시 전체 금액, 상품을두개 결제 했으면 전체의 금액
    private long payReserveAmt; // 부분취소시 취소상품에 분배된 디포인트
    private long orgReserveAmt; // 결제시 총 사용한 디 포인트
    private long refundAmt; // 취소 후 남은 금액
    private long restAmt; // 환불 금액
    private long pvdSvmn;// 상품에 분배된 적립금
    private String cancelType; // 프론트, 관리자 분기 처리 구분 ( 01 : 프론트, 02 : 관리자 )
    private String claimDtlReason;
    private String claimReasonCd;
    private String claimMemo;
    private String claimCd;
    private String returnCd;
    private String cancelStatusCd; // 주문취소, 결제취소, 환불완료 상태값 확인

    private String defaultYn; //기본배송지 여부
    private String addDeliveryYn; // 배송지 추가여부

    private String orderFormType; // 일반주문서(01) , 매장픽업주문서(02)
    
    
    /*방문예약*/
    private String rsvNo;
    private String storeNo;
    private String storeNm;
    private Long memberNo;
    private String rsvDate;
    private String rsvTime;
    private String reqMatr;
    private String visitPurposeCd;
    private String visitPurposeNm;
    private String exhibitionYn;
    private String rsvOnlyYn;
    private String refererType;
    private CouponPO cpIssueResult;
    private String checkupYn;
    private String preGoodsYn;
    private String stampYn;

    private String memberYn;
    private String nomobile;
    private String nomemberNm;
    private String eventGubun;
}