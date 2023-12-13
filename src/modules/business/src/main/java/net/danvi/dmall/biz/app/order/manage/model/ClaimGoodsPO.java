package net.danvi.dmall.biz.app.order.manage.model;

import com.fasterxml.jackson.annotation.JsonFormat;

import dmall.framework.common.model.EditorBasePO;
import lombok.Data;
import lombok.EqualsAndHashCode;
import dmall.framework.common.constants.CommonConstants;
import dmall.framework.common.model.BaseModel;
import net.danvi.dmall.biz.app.setup.siteinfo.model.SitePO;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 5. 12.
 * 작성자     : dong
 * 설명       : 클레임상품정보(조회결과)
 * </pre>
 */
@Data
@EqualsAndHashCode
public class ClaimGoodsPO extends EditorBasePO<ClaimGoodsPO>  {
    // 클레임 사유 코드
    private String claimReasonCd;
    // 반품코드(01, 02)
    private String returnCd;
    // 클레임 코드(11, 12, 21, 22)
    private String claimCd;
    // 클레임 수량
    private int claimQtt;
    // 클레임 접수 일시
    private String claimAcceptDttm;
    // 클레임 완료 일시
    private String claimCmpltDttm;
    // 클레임 취소 일시
    private String claimCancelDttm;
    // 클레임 메모
    private String claimMemo;
    // 클레임 상세 이유
    private String claimDtlReason;
    /** 이력 시작 일시 */
    @JsonFormat(pattern = CommonConstants.DATE_YYYYMMDD, timezone = CommonConstants.DATE_TIMEZONE, locale = CommonConstants.DATE_LOCALE)
    private String histStartDttm;

    private String ordNo;
    private String ordDtlSeq;
    private String ordDtlStatusCd;
    private String curOrdStatusCd;

    /** 클레임 상태 명 */
    private String claimStatusNm;
    /** 클레임 유형 명 */
    private String claimTypeNm;
    /** 판매 금액 */
    private String saleAmt;
    /** 회원 번호 */
    private long memberNo;
    /** 판매 채널 코드 */
    private String saleChannelCd;
    /** 상품 번호 */
    private String goodsNo;
    /** 사은품 번호 */
    private String freebieNo;
    /** 상품 명 */
    private String goodsNm;
    /** 단품 명 */
    private String itemNm;
    /** 단품 번호 */
    private String itemNo;
    /** 옵션 명 */
    private String optNm;
    /** 주문 수량 */
    private String ordQtt;
    /** 쿠폰 할인 금액 */
    private int cpDcAmt;
    /** 포인트 할인 금액 */
    private String pointDcAmt;
    /** 배송 완료 일시 */
    private String dvlrCmpltDttm;

    /** 클레임 번호 */
    private String claimNo;
    private String[] claimNoArr;
    private String[] ordNoArr;
    private String[] ordQttArr;
    private String[] ordDtlSeqArr;
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

    private String cancelStatusCd; // 주문취소, 결제취소, 환불완료 상태값 확인
    
    private String sellerNo;

    private String paymentWayCd;
    private long payReserveAmt; // 부분취소시 취소상품에 분배된 디포인트
}
