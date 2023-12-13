package net.danvi.dmall.biz.app.order.deposit.model;

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
@EqualsAndHashCode
public class DepositVO extends BaseModel<DepositVO> {
    @NotEmpty
    private String ordNo;
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String ordrNm;
    private String bankCd;
    private String bankNm;
    /* 계좌 번호 */
    private String actNo;
    /* 입금자 명 */
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String dpsterNm;
    /* 결제액 */
    private String paymentAmt;
    private String ordStatusNm;
    /* 입금완료일 */
    private String paymentCmpltDttm;
    private String ordStatusCd;

}
