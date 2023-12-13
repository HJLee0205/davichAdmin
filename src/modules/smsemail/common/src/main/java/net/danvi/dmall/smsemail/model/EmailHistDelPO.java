package net.danvi.dmall.smsemail.model;

import java.io.Serializable;
import java.util.List;

public class EmailHistDelPO implements Serializable {

    private static final long serialVersionUID = -4149294812196078534L;

    private String siteNo;
    private Long mailSendNo;
    private String receiverEmail; // 수신자 이메일
    private List<Long> receiverNoList;
    // 삭제 이메일 발송 번호
    private String[] delEmailShotHst;

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

    public String getSiteNo() {
        return siteNo;
    }

    public void setSiteNo(String siteNo) {
        this.siteNo = siteNo;
    }

    public Long getMailSendNo() {
        return mailSendNo;
    }

    public void setMailSendNo(Long mailSendNo) {
        this.mailSendNo = mailSendNo;
    }

    public String getReceiverEmail() {
        return receiverEmail;
    }

    public void setReceiverEmail(String receiverEmail) {
        this.receiverEmail = receiverEmail;
    }

    public List<Long> getReceiverNoList() {
        return receiverNoList;
    }

    public void setReceiverNoList(List<Long> receiverNoList) {
        this.receiverNoList = receiverNoList;
    }

    @Override
    public String toString() {
        return "EmailHistDelPO{" + "siteNo=" + siteNo + ", mailSendNo=" + mailSendNo + ", receiverEmail='"
                + receiverEmail + '\'' + ", receiverNoList=" + receiverNoList + '}';
    }
}
