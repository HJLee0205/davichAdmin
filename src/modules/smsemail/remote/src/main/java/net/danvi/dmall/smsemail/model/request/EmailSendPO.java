package net.danvi.dmall.smsemail.model.request;

import java.io.Serializable;
import java.util.List;

public class EmailSendPO implements Serializable, Cloneable {

    private static final long serialVersionUID = -5677181115652162111L;

    // 메일 발송 번호
    private Long mailSendNo;

    private String siteNo;

    private String sendTargetCd;
    private String sendEmail;
    private String sendTitle;
    private String sendContent;
    private Long senderNo;
    private String senderNm;
    private String sendDttm;
    private String sendStndrd;
    private Long regrNo;
    // 발송시간(일반,예약)
    private String sendTimeSel;
    // 예약발송시간
    private String reservationDttm;

    private String[] mailSendNoArr;

    private List<EmailReceiverPO> emailReceiverPOList;

    private String certKey;

    /**
     * @return the mailSendNoArr
     */
    public String[] getMailSendNoArr() {
        return mailSendNoArr;
    }

    /**
     * @param mailSendNoArr
     *            the mailSendNoArr to set
     */
    public void setMailSendNoArr(String[] mailSendNoArr) {
        this.mailSendNoArr = mailSendNoArr;
    }

    /**
     * @return the sendTimeSel
     */
    public String getSendTimeSel() {
        return sendTimeSel;
    }

    /**
     * @param sendTimeSel
     *            the sendTimeSel to set
     */
    public void setSendTimeSel(String sendTimeSel) {
        this.sendTimeSel = sendTimeSel;
    }

    /**
     * @return the reservationDttm
     */
    public String getReservationDttm() {
        return reservationDttm;
    }

    /**
     * @param reservationDttm
     *            the reservationDttm to set
     */
    public void setReservationDttm(String reservationDttm) {
        this.reservationDttm = reservationDttm;
    }

    /**
     * @return the regrNo
     */
    public Long getRegrNo() {
        return regrNo;
    }

    /**
     * @param regrNo
     *            the regrNo to set
     */
    public void setRegrNo(Long regrNo) {
        this.regrNo = regrNo;
    }

    /**
     * @return the mailSendNo
     */
    public Long getMailSendNo() {
        return mailSendNo;
    }

    /**
     * @param mailSendNo
     *            the mailSendNo to set
     */
    public void setMailSendNo(Long mailSendNo) {
        this.mailSendNo = mailSendNo;
    }

    /**
     * @return the siteNo
     */
    public String getSiteNo() {
        return siteNo;
    }

    /**
     * @param siteNo
     *            the siteNo to set
     */
    public void setSiteNo(String siteNo) {
        this.siteNo = siteNo;
    }

    /**
     * @return the sendTargetCd
     */
    public String getSendTargetCd() {
        return sendTargetCd;
    }

    /**
     * @param sendTargetCd
     *            the sendTargetCd to set
     */
    public void setSendTargetCd(String sendTargetCd) {
        this.sendTargetCd = sendTargetCd;
    }

    /**
     * @return the sendEmail
     */
    public String getSendEmail() {
        return sendEmail;
    }

    /**
     * @param sendEmail
     *            the sendEmail to set
     */
    public void setSendEmail(String sendEmail) {
        this.sendEmail = sendEmail;
    }

    /**
     * @return the sendTitle
     */
    public String getSendTitle() {
        return sendTitle;
    }

    /**
     * @param sendTitle
     *            the sendTitle to set
     */
    public void setSendTitle(String sendTitle) {
        this.sendTitle = sendTitle;
    }

    /**
     * @return the sendContent
     */
    public String getSendContent() {
        return sendContent;
    }

    /**
     * @param sendContent
     *            the sendContent to set
     */
    public void setSendContent(String sendContent) {
        this.sendContent = sendContent;
    }

    /**
     * @return the senderNo
     */
    public Long getSenderNo() {
        return senderNo;
    }

    /**
     * @param senderNo
     *            the senderNo to set
     */
    public void setSenderNo(Long senderNo) {
        this.senderNo = senderNo;
    }

    /**
     * @return the senderNm
     */
    public String getSenderNm() {
        return senderNm;
    }

    /**
     * @param senderNm
     *            the senderNm to set
     */
    public void setSenderNm(String senderNm) {
        this.senderNm = senderNm;
    }

    /**
     * @return the sendDttm
     */
    public String getSendDttm() {
        return sendDttm;
    }

    /**
     * @param sendDttm
     *            the sendDttm to set
     */
    public void setSendDttm(String sendDttm) {
        this.sendDttm = sendDttm;
    }

    /**
     * @return the sendStndrd
     */
    public String getSendStndrd() {
        return sendStndrd;
    }

    /**
     * @param sendStndrd
     *            the sendStndrd to set
     */
    public void setSendStndrd(String sendStndrd) {
        this.sendStndrd = sendStndrd;
    }

    public List<EmailReceiverPO> getEmailReceiverPOList() {
        return emailReceiverPOList;
    }

    public String getCertKey() {
        return certKey;
    }

    public void setCertKey(String certKey) {
        this.certKey = certKey;
    }

    public void setEmailReceiverPOList(List<EmailReceiverPO> emailReceiverPOList) {
        this.emailReceiverPOList = emailReceiverPOList;
    }

    @Override
    public EmailSendPO clone() throws CloneNotSupportedException {
        return (EmailSendPO) super.clone();
    }
}
