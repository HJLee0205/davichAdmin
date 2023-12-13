package net.danvi.dmall.biz.app.order.constants;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 6. 8.
 * 작성자     : kdy
 * 설명       :
 * </pre>
 */
public class OrdStatusConstants {
    // 00 주문무효
    public static final String ORD_NOVALID = "00";
    // 01 주문접수
    public static final String ORD_ACCEPT = "01";
    // 10 주문완료(상태코드:입금확인중)
    public static final String ORD_DONE = "10";
    // 11 주문취소
    public static final String ORD_CANCEL = "11";
    // 20 결제완료
    public static final String PAY_DONE = "20";
    // 21 결제취소
    public static final String PAY_CANCEL = "21";
    // 22 결제실패
    public static final String PAY_FAIL = "22";
    // 23 결제취소신청
    public static final String PAY_CANEL_REQUEST = "23";
    // 30 배송준비중
    public static final String DELIV_BEFORE = "30";
    // 39 부분배송중
    public static final String DELIV_DOING_PARTLY = "39";
    // 40 배송중
    public static final String DELIV_DOING = "40";

    // 49 부분배송완료
    public static final String DELIV_DONE_PARTLY = "49";
    // 50 배송완료
    public static final String DELIV_DONE = "50";
    // 90 구매확정
    public static final String BUY_CONFIRM = "90";

    // 60 교환신청
    public static final String EXCG_APPLY = "60";
    // 61 교환취소
    public static final String EXCG_CANCEL = "61";
    // 62 부분교환신청
    public static final String EXCG_PART_APPLY = "62";
    // 63 부분교환취소
    public static final String EXCG_PART_CANCEL = "63";
    // 66 교환완료
    public static final String EXCG_DONE = "66";
    // 67 부분교환완료
    public static final String EXCG_PART_DONE = "67";
    // 70 환불신청
    public static final String RETURN_APPLY = "70";
    // 71 환불취소
    public static final String RETURN_CANCEL = "71";
    // 72 부분 환불신청
    public static final String RETURN_PART_APPLY = "72";
    // 73 부분 환불취소
    public static final String RETURN_PART_CANCEL = "73";
    // 74 환불완료
    public static final String RETURN_DONE = "74";
    // 75 부분환불완료
    public static final String RETURN_PART_DONE = "75";

}
