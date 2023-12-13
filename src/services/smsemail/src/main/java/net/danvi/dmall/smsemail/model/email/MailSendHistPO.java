package net.danvi.dmall.smsemail.model.email;

import net.danvi.dmall.smsemail.model.request.EmailSendPO;
import dmall.framework.common.annotation.Encrypt;
import dmall.framework.common.util.CryptoUtil;

/**
 * Created by dong on 2016-08-31.
 */
public class MailSendHistPO {
    // 메일 발송 번호
    private Long mailSendNo;
    private String siteNo;
    private String sendTargetCd;
    private String sendEmail;
    private String sendTitle;
    private String sendContent;
    private Long senderNo;
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String senderNm;
    private String sendDttm;
    private String sendStndrd;
    // 삭제 이메일 발송 번호
    private String[] delEmailShotHst;
    private String sendTimeSel;
    private String reservationDttm;
    private String[] mailSendNoArr;

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
     * @return the delEmailShotHst
     */
    public String[] getDelEmailShotHst() {
        return delEmailShotHst;
    }

    /**
     * @param delEmailShotHst
     *            the delEmailShotHst to set
     */
    public void setDelEmailShotHst(String[] delEmailShotHst) {
        this.delEmailShotHst = delEmailShotHst;
    }

    public MailSendHistPO(EmailSendPO po) {
        this.mailSendNo = po.getMailSendNo();
        this.siteNo = po.getSiteNo();
        this.sendTargetCd = po.getSendTargetCd();
        this.sendEmail = po.getSendEmail();
        this.sendTitle = po.getSendTitle();
        this.sendContent = po.getSendContent();
        this.senderNo = po.getSenderNo();
        this.senderNm = po.getSenderNm();
        this.sendDttm = po.getSendDttm();
        this.sendStndrd = po.getSendStndrd();
        this.sendTimeSel = po.getSendTimeSel();
        this.reservationDttm = po.getReservationDttm();
    }

    public Long getMailSendNo() {
        return mailSendNo;
    }

    public void setMailSendNo(Long mailSendNo) {
        this.mailSendNo = mailSendNo;
    }

    public String getSiteNo() {
        return siteNo;
    }

    public void setSiteNo(String siteNo) {
        this.siteNo = siteNo;
    }

    public String getSendTargetCd() {
        return sendTargetCd;
    }

    public void setSendTargetCd(String sendTargetCd) {
        this.sendTargetCd = sendTargetCd;
    }

    public String getSendEmail() {
        return sendEmail;
    }

    public void setSendEmail(String sendEmail) {
        this.sendEmail = sendEmail;
    }

    public String getSendTitle() {
        return sendTitle;
    }

    public void setSendTitle(String sendTitle) {
        this.sendTitle = sendTitle;
    }

    public String getSendContent() {
        return sendContent;
    }

    public void setSendContent(String sendContent) {
        this.sendContent = sendContent;
    }

    public Long getSenderNo() {
        return senderNo;
    }

    public void setSenderNo(Long senderNo) {
        this.senderNo = senderNo;
    }

    public String getSenderNm() {
        return senderNm;
    }

    public void setSenderNm(String senderNm) {
        this.senderNm = senderNm;
    }

    public String getSendDttm() {
        return sendDttm;
    }

    public void setSendDttm(String sendDttm) {
        this.sendDttm = sendDttm;
    }

    public String getSendStndrd() {
        return sendStndrd;
    }

    public void setSendStndrd(String sendStndrd) {
        this.sendStndrd = sendStndrd;
    }
}
