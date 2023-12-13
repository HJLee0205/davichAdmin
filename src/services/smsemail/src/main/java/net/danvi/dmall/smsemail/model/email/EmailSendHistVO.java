package net.danvi.dmall.smsemail.model.email;

import dmall.framework.common.annotation.Encrypt;

/**
 * Created by dong on 2016-08-31.
 */
public class EmailSendHistVO {
    // 메일 발송 번호
    private String mailSendNo;

    private String siteNo;

    private Long ordNo;
    private String mailTypeCd;
    private String sendTargetCd;
    private String mailTypeNm;
    // 보내는 사람 주소
    private String sendEmail;
    // 메일 제목
    private String sendTitle;
    // 메일 내용
    private String sendContent;
    // 보내는 사람 회원 번호
    private Long senderNo;
    // 보내는 사람 이름
    @Encrypt
    private String senderNm;
    // 발송일자
    private String sendDttm;
    private String sendStndrd;
    private String receiverEmail;
    private Long receiverNo;
    private String receiverNm;
    private String autoSendYn;
    private String rowNum;
    // 발송 결과
    private String resultCd;

    private String delYn;
    private String groupCnt;

    // 메일 솔루션 캠페인 아이디
    private String campaignNo;

    // 메일 솔루션 발송 결과 테이블 명
    private String campaignTbNm;

    // 메일 솔루션 발송 성공 건수
    private String sucsCnt;

    /**
     * @return the sucsCnt
     */
    public String getSucsCnt() {
        return sucsCnt;
    }

    /**
     * @param sucsCnt
     *            the sucsCnt to set
     */
    public void setSucsCnt(String sucsCnt) {
        this.sucsCnt = sucsCnt;
    }

    /**
     * @return the campaignTbNm
     */
    public String getCampaignTbNm() {
        return campaignTbNm;
    }

    /**
     * @param campaignTbNm
     *            the campaignTbNm to set
     */
    public void setCampaignTbNm(String campaignTbNm) {
        this.campaignTbNm = campaignTbNm;
    }

    /**
     * @return the campaignNo
     */
    public String getCampaignNo() {
        return campaignNo;
    }

    /**
     * @param campaignNo
     *            the campaignNo to set
     */
    public void setCampaignNo(String campaignNo) {
        this.campaignNo = campaignNo;
    }

    /**
     * @return the groupCnt
     */
    public String getGroupCnt() {
        return groupCnt;
    }

    /**
     * @param groupCnt
     *            the groupCnt to set
     */
    public void setGroupCnt(String groupCnt) {
        this.groupCnt = groupCnt;
    }

    /**
     * @return the rowNum
     */
    public String getRowNum() {
        return rowNum;
    }

    /**
     * @param rowNum
     *            the rowNum to set
     */
    public void setRowNum(String rowNum) {
        this.rowNum = rowNum;
    }

    /**
     * @return the resultCd
     */
    public String getResultCd() {
        return resultCd;
    }

    /**
     * @param resultCd
     *            the resultCd to set
     */
    public void setResultCd(String resultCd) {
        this.resultCd = resultCd;
    }

    public String getMailSendNo() {
        return mailSendNo;
    }

    public void setMailSendNo(String mailSendNo) {
        this.mailSendNo = mailSendNo;
    }

    public String getSiteNo() {
        return siteNo;
    }

    public void setSiteNo(String siteNo) {
        this.siteNo = siteNo;
    }

    public Long getOrdNo() {
        return ordNo;
    }

    public void setOrdNo(Long ordNo) {
        this.ordNo = ordNo;
    }

    public String getMailTypeCd() {
        return mailTypeCd;
    }

    public void setMailTypeCd(String mailTypeCd) {
        this.mailTypeCd = mailTypeCd;
    }

    public String getSendTargetCd() {
        return sendTargetCd;
    }

    public void setSendTargetCd(String sendTargetCd) {
        this.sendTargetCd = sendTargetCd;
    }

    public String getMailTypeNm() {
        return mailTypeNm;
    }

    public void setMailTypeNm(String mailTypeNm) {
        this.mailTypeNm = mailTypeNm;
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

    public String getAutoSendYn() {
        return autoSendYn;
    }

    public void setAutoSendYn(String autoSendYn) {
        this.autoSendYn = autoSendYn;
    }

    public String getDelYn() {
        return delYn;
    }

    public void setDelYn(String delYn) {
        this.delYn = delYn;
    }
}
