package net.danvi.dmall.biz.app.order.manage.model;

import java.util.Date;
import java.util.List;

import com.fasterxml.jackson.annotation.JsonFormat;

import lombok.Data;
import lombok.EqualsAndHashCode;
import dmall.framework.common.annotation.Encrypt;
import dmall.framework.common.constants.CommonConstants;
import dmall.framework.common.model.BaseModel;
import dmall.framework.common.util.CryptoUtil;
import net.danvi.dmall.biz.app.goods.model.GoodsItemVO;

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
public class ClaimGoodsVO extends BaseModel<ClaimGoodsVO> {

    /** 클레임상품 정보 **/

    // 클레임 상세 번호
    private String claimDtlSeq;
    // 클레임 유형 코드
    private String claimTypeCd;
    /** 클레임 유형 명 */
    private String claimTypeNm;
    // 클레임 사유 코드
    private String claimReasonCd;
    // 클레임 사유 명
    private String claimReasonNm;
    // 클레임 반품 코드
    private String returnCd;
    // 클레임 반품 명
    private String returnNm;
    // 클레임 코드
    private String claimCd;
    // 클레임 명
    private String claimNm;
    // 클레임 수량
    private int claimQtt;
    // 주문 결제 방법
    private String paymentWayNm;
    // 클레임 접수 일시
    @JsonFormat(pattern = CommonConstants.DATE_YYYYMMDDHHMMSS, timezone = CommonConstants.DATE_TIMEZONE, locale = CommonConstants.DATE_LOCALE)
    private Date claimAcceptDttm;
    // 클레임 완료 일시
    @JsonFormat(pattern = CommonConstants.DATE_YYYYMMDDHHMMSS, timezone = CommonConstants.DATE_TIMEZONE, locale = CommonConstants.DATE_LOCALE)
    private Date claimCmpltDttm;
    // 클레임 취소 일시
    @JsonFormat(pattern = CommonConstants.DATE_YYYYMMDDHHMMSS, timezone = CommonConstants.DATE_TIMEZONE, locale = CommonConstants.DATE_LOCALE)
    private Date claimCancelDttm;
    // 클레임 메모
    private String claimMemo;
    // 클레임 상세 이유
    private String claimDtlReason;
    /** 이력 시작 일시 */
    @JsonFormat(pattern = CommonConstants.DATE_YYYYMMDDHHMMSS, timezone = CommonConstants.DATE_TIMEZONE, locale = CommonConstants.DATE_LOCALE)
    private Date histStartDttm;

    /** 클레임 번호 */
    private String claimNo;
    // 재주문 번호
    private String newOrdNo;
    private String ordNo;
    private String ordDtlSeq;
    private String ordDtlStatusCd;
    private String ordDtlStatusNm;

    /** 판매 금액 */
    private String saleAmt;
    /** 회원 번호 */
    private long memberNo;
    private String rownum;
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String ordrNm;

    /** 판매자 번호*/
    private String sellerNo;
    /** 판매자 */
    private String sellerNm;

    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String loginId;
    private String memberGradeNm;
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
    /** 단품 명 */
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
    @JsonFormat(pattern = CommonConstants.DATE_YYYYMMDD, timezone = CommonConstants.DATE_TIMEZONE, locale = CommonConstants.DATE_LOCALE)
    private Date dvlrCmpltDttm;
    /** 등록자 명 */
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String regrNm;
    private String imgPath;
    private String escrowYn;

    private int partCnt;
    
    /** 물류센터에서 입력한 반품 확인 정보 */
    private String claimContentChk;

    private List<GoodsItemVO> goodsItemList;
    /** 공급 금액 */
    private String supplyAmt;

    // 추가배송비
    private long dlvrAddAmt;
    // 배송비
    private long dlvrAmt;
    // 사용 포인트
    private long goodsDmoneyUseAmt;

    private long dcAmt;

    // 배송비
    private String realDlvrAmt;
}
