package net.danvi.dmall.biz.app.order.manage.model;

import dmall.framework.common.annotation.Encrypt;
import dmall.framework.common.util.CryptoUtil;
import lombok.Data;
import lombok.EqualsAndHashCode;
import dmall.framework.common.model.BaseSearchVO;

/**
 * Created by dong on 2016-05-02.
 */
@Data
@EqualsAndHashCode
public class ClaimSO extends BaseSearchVO<OrderSO> {
    /** 검색시작일 */
    private String refundDayS;
    /** 검색 종료일 */
    private String refundDayE;
    /** 반품 코드 */
    private String[] returnCd;
    /** 클레임 코드 */
    private String[] claimCd;

    /** 판매자 */
    private String searchSeller;

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
    private String refundNo;
    /** 주문 상세 번호 */
    private String ordDtlSeq;

    /** 주문일/입금일 */
    private String dayTypeCd;

    /** 주문 번호 */
    private String[] ordNoArr;
    /** 주문 상세 순번 */
    private String[] ordDtlSeqArr;
    /** 반품수량  */
    private String[] claimQttArr;

    /** 반품 상품 코드 배열 */
    private String[] claimGoodsNoArr;
    /** 반품 상품 코드  */
    private String claimGoodsNo;
    /** 주문 번호 */
    private String ordNo;

    private long totalDlvrAmt;

    /** 01:환불 02:결제취소 검색 유형 */
    private String cancelSearchType;

    private int claimQtt;
    private String refundType;
    private String exchangeType;

    private long sellerNo;

    private String searchWordEncrypt;
}
