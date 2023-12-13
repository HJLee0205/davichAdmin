package net.danvi.dmall.smsemail.model.email;

import net.danvi.dmall.smsemail.model.request.EmailReceiverPO;
import dmall.framework.common.annotation.Encrypt;
import dmall.framework.common.util.CryptoUtil;

/**
 * Created by dong on 2016-08-31.
 */
public class MailSendHistDtlPO {
    // 메일 발송 번호
    private Long mailSendNo;
    // 메일 발송 상세 번호
    private Integer mailSendDtlNo;
    private String siteNo;
    private String receiverEmail; // 수신자 이메일
    private Long receiverNo;
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String receiverNm;
    private String resultCd;

    public MailSendHistDtlPO(EmailReceiverPO po) {
        this.mailSendNo = po.getMailSendNo();
        this.receiverEmail = po.getReceiverEmail();
        this.siteNo = po.getSiteNo();
        this.receiverNm = po.getReceiverNm();
        this.receiverNo = po.getReceiverNo();
    }

    public Long getMailSendNo() {
        return mailSendNo;
    }

    public void setMailSendNo(Long mailSendNo) {
        this.mailSendNo = mailSendNo;
    }

    public Integer getMailSendDtlNo() {
        return mailSendDtlNo;
    }

    public void setMailSendDtlNo(Integer mailSendDtlNo) {
        this.mailSendDtlNo = mailSendDtlNo;
    }

    public String getSiteNo() {
        return siteNo;
    }

    public void setSiteNo(String siteNo) {
        this.siteNo = siteNo;
    }

    public String getReceiverEmail() {
        return receiverEmail;
    }

    public void setReceiverEmail(String receiverEmail) {
        this.receiverEmail = receiverEmail;
    }

    public Long getReceiverNo() {
        return receiverNo;
    }

    public void setReceiverNo(Long receiverNo) {
        this.receiverNo = receiverNo;
    }

    public String getReceiverNm() {
        return receiverNm;
    }

    public void setReceiverNm(String receiverNm) {
        this.receiverNm = receiverNm;
    }

    public String getResultCd() {
        return resultCd;
    }

    public void setResultCd(String resultCd) {
        this.resultCd = resultCd;
    }

    @Override
    public String toString() {
        return "MailSendHistDtlPO{" +
                "mailSendNo=" + mailSendNo +
                ", mailSendDtlNo=" + mailSendDtlNo +
                ", siteNo=" + siteNo +
                ", receiverEmail='" + receiverEmail + '\'' +
                ", receiverNo=" + receiverNo +
                ", receiverNm='" + receiverNm + '\'' +
                ", resultCd='" + resultCd + '\'' +
                '}';
    }
}
