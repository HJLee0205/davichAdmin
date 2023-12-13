package net.danvi.dmall.smsemail.model.request;

import java.io.Serializable;

public class EmailReceiverPO implements Serializable {

    private static final long serialVersionUID = -5677181115652162111L;

    private Long mailSendNo;
    private String receiverEmail; // 수신자 이메일
    private String siteNo;
    private String receiverNm; // 수신자명
    private Long receiverNo;


    public Long getMailSendNo() {
        return mailSendNo;
    }

    public void setMailSendNo(Long mailSendNo) {
        this.mailSendNo = mailSendNo;
    }

    /**
     * @return the receiverEmail
     */
    public String getReceiverEmail() {
        return receiverEmail;
    }

    /**
     * @param receiverEmail
     *            the receiverEmail to set
     */
    public void setReceiverEmail(String receiverEmail) {
        this.receiverEmail = receiverEmail;
    }

    /**
     * @return the receiverNo
     */
    public Long getReceiverNo() {
        return receiverNo;
    }

    /**
     * @param receiverNo
     *            the receiverNo to set
     */
    public void setReceiverNo(Long receiverNo) {
        this.receiverNo = receiverNo;
    }

    public String getSiteNo() {
        return siteNo;
    }

    public void setSiteNo(String siteNo) {
        this.siteNo = siteNo;
    }

    /**
     * @return the receiverNm
     */
    public String getReceiverNm() {
        return receiverNm;
    }

    /**
     * @param receiverNm
     *            the receiverNm to set
     */
    public void setReceiverNm(String receiverNm) {
        this.receiverNm = receiverNm;
    }
}
