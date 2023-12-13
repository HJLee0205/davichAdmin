package net.danvi.dmall.biz.app.order.manage.model;

import lombok.Data;
import lombok.EqualsAndHashCode;
import dmall.framework.common.annotation.Encrypt;
import dmall.framework.common.model.BaseSearchVO;
import dmall.framework.common.util.CryptoUtil;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 5. 2.
 * 작성자     : dong
 * 설명       : 주문정보 취합(조회)
 * </pre>
 */
@Data
@EqualsAndHashCode
public class OrderSO extends BaseSearchVO<OrderSO> {
    /** 검색시작일 */
    private String ordDayS;
    /** 검색 종료일 */
    private String ordDayE;
    /** 주문일/입금일 */
    private String dayTypeCd;
    /** 주문 상태 코드 */
    private String[] ordStatusCd;
    /** 주문 상세 상태 코드 */
    private String[] ordDtlStatusCd;
    /** 결제수단 코드 */
    private String[] paymentWayCd;
    /** 판매환경 코드 */
    private String[] ordMediaCd;
    /** 판매채널 코드 */
    private String[] saleChannelCd;
    /** 회원구분 */
    private String memberOrdYn;
    /** 검색어구분 */
    private String searchCd;
    /** 검색어 */
    private String searchWord;
    /** 회원(주문자) 번호 */
    private long memberNo;
    /** 회원(주문자) ID */
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String loginId;
    /** 주문 번호 */
    private String ordNo;
    /** 주문자 모바일 */
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String ordrMobile;
    /** 주문자 모바일(암호화 제거) */
    private String nonOrdrMobile;
    /** 주문 상세 번호 */
    private String ordDtlSeq;
    /** 상품번호 **/
    private String goodsNo;
    /** 주문 상세 순번 */
    private String[] ordDtlSeqArr;
    /** 판매자 **/
    private String searchSeller;
    /** 판매자 로그인**/
    private String searchSellerLogin;

    /** 클레임현황여부**/
    private String claimStatusYn;
    private String searchDlvrcPaymentCd;

    /** 프로모션 **/
    private int prmtNo;
    /** 이벤트 **/
    private int eventNo;
    /** 간편결제 조회 조건 **/
    private String paymentWayForEasy; // and:간편 결제만 조회, or:간편결제 포함 조회, excld:간편결제 재외 조회
}
