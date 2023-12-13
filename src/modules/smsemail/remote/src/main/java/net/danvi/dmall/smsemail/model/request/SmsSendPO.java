package net.danvi.dmall.smsemail.model.request;

import java.io.Serializable;

public class SmsSendPO implements Serializable {

    private static final long serialVersionUID = -1733992784886537772L;

    private Long smsSendNo;
    private String siteNo;
    private String sendTypeCd;
    private String sendTargetCd;
    private String sendFrmCd;
    // private String resultCd;
    private String sendTelno;
    private String sendWords;
    private Long senderNo;
    private String senderId;
    private String senderNm;
    private String sendDttm;
    private String realSendDttm;
    private String recvTelno;
    private Long receiverNo;
    private String receiverId;
    private String receiverNm;
    private String recvDttm;
    private String autoSendYn;
    private String ordNo;
    private String fcallback;
    private String fdestine;
    private String subject;
    private String failedType;
    private String failedSubject;
    private String failedMsg;
    private String templateCode;

    public String getSubject() {
        return subject;
    }

    public void setSubject(String subject) {
        this.subject = subject;
    }

    public String getReceiverId() {
        return receiverId;
    }

    public void setReceiverId(String receiverId) {
        this.receiverId = receiverId;
    }

    public String getSenderId() {
        return senderId;
    }

    public void setSenderId(String senderId) {
        this.senderId = senderId;
    }

    public String getFcallback() {
        return fcallback;
    }

    public void setFcallback(String fcallback) {
        this.fcallback = fcallback;
    }

    public String getFdestine() {
        return fdestine;
    }

    public void setFdestine(String fdestine) {
        this.fdestine = fdestine;
    }

    public Long getSmsSendNo() {
        return smsSendNo;
    }

    public void setSmsSendNo(Long smsSendNo) {
        this.smsSendNo = smsSendNo;
    }

    public String getSiteNo() {
        return siteNo;
    }

    public void setSiteNo(String siteNo) {
        this.siteNo = siteNo;
    }

    public String getSendTypeCd() {
        return sendTypeCd;
    }

    public void setSendTypeCd(String sendTypeCd) {
        this.sendTypeCd = sendTypeCd;
    }

    public String getSendTargetCd() {
        return sendTargetCd;
    }

    public void setSendTargetCd(String sendTargetCd) {
        this.sendTargetCd = sendTargetCd;
    }

    public String getSendFrmCd() {
        return sendFrmCd;
    }

    public void setSendFrmCd(String sendFrmCd) {
        this.sendFrmCd = sendFrmCd;
    }

    public String getSendTelno() {
        return sendTelno;
    }

    public void setSendTelno(String sendTelno) {
        this.sendTelno = sendTelno;
    }

    public String getSendWords() {
        return sendWords;
    }

    public void setSendWords(String sendWords) {
        this.sendWords = sendWords;
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

    public String getRealSendDttm() {
        return realSendDttm;
    }

    public void setRealSendDttm(String realSendDttm) {
        this.realSendDttm = realSendDttm;
    }

    public String getRecvTelno() {
        return recvTelno;
    }

    public void setRecvTelno(String recvTelno) {
        this.recvTelno = recvTelno;
    }

    public Long getReceiverNo() {
        return receiverNo;
    }

    public void setReceiverNo(Long receiverNo) {
        this.receiverNo = receiverNo;
    }

    /**
     * @return the receiverId
     */
    // public String getReceiverId() {
    // return receiverId;
    // }

    /**
     * @param receiverId
     *            the receiverId to set
     */
    // public void setReceiverId(String receiverId) {
    // this.receiverId = receiverId;
    // }

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

    /**
     * @return the recvDttm
     */
    public String getRecvDttm() {
        return recvDttm;
    }

    /**
     * @param recvDttm
     *            the recvDttm to set
     */
    public void setRecvDttm(String recvDttm) {
        this.recvDttm = recvDttm;
    }

    /**
     * @return the autoSendYn
     */
    public String getAutoSendYn() {
        return autoSendYn;
    }

    /**
     * @param autoSendYn
     *            the autoSendYn to set
     */
    public void setAutoSendYn(String autoSendYn) {
        this.autoSendYn = autoSendYn;
    }

    /**
     * @return the ordNo
     */
    public String getOrdNo() {
        return ordNo;
    }

    /**
     * @param ordNo
     *            the ordNo to set
     */
    public void setOrdNo(String ordNo) {
        this.ordNo = ordNo;
    }
    public String getFailedType() {
        return failedType;
    }

    public void setFailedType(String failedType) {
        this.failedType = failedType;
    }

    public String getFailedSubject() {
        return failedSubject;
    }

    public void setFailedSubject(String failedSubject) {
        this.failedSubject = failedSubject;
    }

    public String getFailedMsg() {
        return failedMsg;
    }

    public void setFailedMsg(String failedMsg) {
        this.failedMsg = failedMsg;
    }


    public String getTemplateCode() {
        return templateCode;
    }

    public void setTemplateCode(String templateCode) {
        this.templateCode = templateCode;
    }
}
