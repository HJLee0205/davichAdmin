package net.danvi.dmall.biz.app.order.delivery.model;

import java.util.Date;

import org.hibernate.validator.constraints.NotEmpty;

import com.fasterxml.jackson.annotation.JsonFormat;

import lombok.Data;
import lombok.EqualsAndHashCode;
import dmall.framework.common.annotation.Encrypt;
import dmall.framework.common.constants.CommonConstants;
import dmall.framework.common.model.BaseModel;
import dmall.framework.common.util.CryptoUtil;

/**
 * Created by dong on 2016-05-02.
 */
@Data
@EqualsAndHashCode
public class DeliveryVO extends BaseModel<DeliveryVO> {
    private String rownum;
    @NotEmpty
    private String ordNo;
    /** 주문 상세 번호 */
    private String ordDtlSeq;
    /** 배송 번호 */
    private String dlvrNo;
    /** 상품 코드 */
    private String goodsNo;
    /** 상품 명 */
    private String goodsNm;
    /** 상품 이미지 */
    private String imgPath;
    /** 아이템 명 */
    private String itemNm;
    /** 추가 옵션 명 */
    private String addOptNm;
    /** 아이템 재고 수량 */
    private String stockQtt;
    /** 아이템 재고 가용 수량 */
    private String availStockQtt;
    /** 주문 수량 */
    private String ordQtt;
    /** 취소 수량 */
    private String canQtt;
    /** 배송 수량 */
    private String dlvrQtt;
    /** 배송비 결제 방법 */
    private String dlvrcPaymentNm;
    /** 배송비 결제 방법 코드 */
    private String dlvrcPaymentCd;
    /** 택배사 코드 */
    private String rlsCourierCd;
    /** 택배사 명 */
    private String rlsCourierNm;
    /** 송장 번호 */
    private String rlsInvoiceNo;
    /** 송장 번호 등록일시 */
    @JsonFormat(pattern = CommonConstants.DATE_YYYYMMDDHHMMSS, timezone = CommonConstants.DATE_TIMEZONE, locale = CommonConstants.DATE_LOCALE)
    private Date rlsInvoiceRegDttm;
    /** 배송 시작일시 : 출고 완료일시 */
    @JsonFormat(pattern = CommonConstants.DATE_YYYYMMDDHHMMSS, timezone = CommonConstants.DATE_TIMEZONE, locale = CommonConstants.DATE_LOCALE)
    private Date rlsCmpltDttm;
    /** 주문일시 */
    @JsonFormat(pattern = CommonConstants.DATE_YYYYMMDDHHMMSS, timezone = CommonConstants.DATE_TIMEZONE, locale = CommonConstants.DATE_LOCALE)
    private Date ordAcceptDttm;
    /** 주문자 ID */
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String loginId;
    /** 주문자 명 */
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String ordrNm;
    /** 수취인 명 */
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String adrsNm;
    /** 주문자 등급명 */
    private String memberGradeNm;
    /** 상세주문 상태 코드 */
    private String ordDtlStatusCd;
    /** 상세주문 상태 명 */
    private String ordDtlStatusNm;
    /** 수신자 우편번호 */
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String postNo;
    /** 수신자 도로명 주소 */
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String roadnmAddr;
    /** 수신자 지번 주소 */
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String numAddr;
    /** 수신자 상세주소 */
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String dtlAddr;
    /** 판매자 번호 */
    private String sellerNo;
    /** 판매자 명 */
    private String sellerNm;
    /** 판매채널 */
    private String saleChannelNm;
    /** 판매가 */
    private String saleAmt;
    /** 공급가 */
    private String supplyAmt;
    /** 결재금액 */
    private String paymentAmt;
    /** 할인금액 */
    private String dcAmt;
}
