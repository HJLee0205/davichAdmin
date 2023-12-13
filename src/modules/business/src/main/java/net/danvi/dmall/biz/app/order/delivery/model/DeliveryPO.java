package net.danvi.dmall.biz.app.order.delivery.model;

import org.hibernate.validator.constraints.NotEmpty;

import lombok.Data;
import lombok.EqualsAndHashCode;
import dmall.framework.common.annotation.Encrypt;
import dmall.framework.common.model.BaseModel;
import dmall.framework.common.util.CryptoUtil;

/**
 * Created by dong on 2016-05-02.
 */
@Data
@EqualsAndHashCode(callSuper = false)
public class DeliveryPO extends BaseModel<DeliveryPO> {
    /** 배송지 번호 */
    @NotEmpty
    private String deliveryNo;
    /** 우편번호 */
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String postNo;
    /** 도로명 주소 */
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String roadnmAddr;
    /** 지번 주소 */
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String numAddr;
    /** 상세 주소 */
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String dtlAddr;
    /** 배송 메세지 */
    private String dlvrMsg;
    /** 주문 번호 */
    private String ordNo;
    /** 주문 상세 번호 */
    private String ordDtlSeq;
    /** 주문 상품 번호 */
    private String goodsNo;
    /** 현재 주문 상태 코드 */
    private String ordStatusCd;
    /** 배송비 결제 코드 */
    private String dlvrcPaymentCd;
    /** 택배사 코드 */
    private String rlsCourierCd;
    /** 송장 번호 **/
    private String rlsInvoiceNo;
    /** 배송 수량 */
    private String dlvrQtt;
    /** 배송 번호 */
    private String dlvrNo;

    /** 해외 주소 관련 */
    private String memberGbCd;
    private String frgAddrCountry;
    private String frgAddrCity;
    private String frgAddrState;
    private String frgAddrZipCode;
    private String frgAddrDtl1;
    private String frgAddrDtl2;

    private String dlvrApi;

    private String smsSendYn;
}
