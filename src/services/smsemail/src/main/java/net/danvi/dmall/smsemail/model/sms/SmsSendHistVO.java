package net.danvi.dmall.smsemail.model.sms;

import dmall.framework.common.annotation.Encrypt;

/**
 * Created by dong on 2016-08-29.
 */
public class SmsSendHistVO {
    private String senderId;
    @Encrypt
    private String senderNm;
    private String senderNo;
    private String sendWords;
    private String receiverId;
    @Encrypt
    private String receiverNm;
    private String receiverNo;
    @Encrypt
    private String recvTelno;
    private String recvDttm;
    private String sendDttm;
    private String status;
    private String msg;
    private String frsltdate;
    private String fsendstat;
    private String frsltstat;
    private String frsltstatnm;
    private String rownum;
    private String sendFrmNm;
    @Encrypt
    private String sendTelno;

    // SMS 실패 관련 변수
    private Integer fsequence;
    private Integer msgkey;
    private String siteNo;
    private Integer smsFailPoint;

    private String sortNum;
    private String rslt;
    /**
     * @return the sendTelno
     */
    public String getSendTelno() {
        return sendTelno;
    }

    /**
     * @param sendTelno
     *            the sendTelno to set
     */
    public void setSendTelno(String sendTelno) {
        this.sendTelno = sendTelno;
    }

    public String getSendFrmNm() {
        return sendFrmNm;
    }

    public void setSendFrmNm(String sendFrmNm) {
        this.sendFrmNm = sendFrmNm;
    }

    /**
     * @return the rownum
     */
    public String getRownum() {
        return rownum;
    }

    /**
     * @param rownum
     *            the rownum to set
     */
    public void setRownum(String rownum) {
        this.rownum = rownum;
    }

    /**
     * @return the senderId
     */
    public String getSenderId() {
        return senderId;
    }

    /**
     * @param senderId
     *            the senderId to set
     */
    public void setSenderId(String senderId) {
        this.senderId = senderId;
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
     * @return the senderNo
     */
    public String getSenderNo() {
        return senderNo;
    }

    /**
     * @param senderNo
     *            the senderNo to set
     */
    public void setSenderNo(String senderNo) {
        this.senderNo = senderNo;
    }

    /**
     * @return the sendWords
     */
    public String getSendWords() {
        return sendWords;
    }

    /**
     * @param sendWords
     *            the sendWords to set
     */
    public void setSendWords(String sendWords) {
        this.sendWords = sendWords;
    }

    /**
     * @return the receiverId
     */
    public String getReceiverId() {
        return receiverId;
    }

    /**
     * @param receiverId
     *            the receiverId to set
     */
    public void setReceiverId(String receiverId) {
        this.receiverId = receiverId;
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

    /**
     * @return the receiverNo
     */
    public String getReceiverNo() {
        return receiverNo;
    }

    /**
     * @param receiverNo
     *            the receiverNo to set
     */
    public void setReceiverNo(String receiverNo) {
        this.receiverNo = receiverNo;
    }

    /**
     * @return the recvTelno
     */
    public String getRecvTelno() {
        return recvTelno;
    }

    /**
     * @param recvTelno
     *            the recvTelno to set
     */
    public void setRecvTelno(String recvTelno) {
        this.recvTelno = recvTelno;
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
     * @return the status
     */
    public String getStatus() {
        return status;
    }

    /**
     * @param status
     *            the status to set
     */
    public void setStatus(String status) {
        this.status = status;
    }

    /**
     * @return the msg
     */
    public String getMsg() {
        return msg;
    }

    /**
     * @param msg
     *            the msg to set
     */
    public void setMsg(String msg) {
        this.msg = msg;
    }

    /**
     * @return the frsltdate
     */
    public String getFrsltdate() {
        return frsltdate;
    }

    /**
     * @param frsltdate
     *            the frsltdate to set
     */
    public void setFrsltdate(String frsltdate) {
        this.frsltdate = frsltdate;
    }

    /**
     * @return the fsendstat
     */
    public String getFsendstat() {
        return fsendstat;
    }

    /**
     * @param fsendstat
     *            the fsendstat to set
     */
    public void setFsendstat(String fsendstat) {
        this.fsendstat = fsendstat;
    }

    /**
     * @return the frsltstat
     */
    public String getFrsltstat() {
        return frsltstat;
    }

    /**
     * @param frsltstat
     *            the frsltstat to set
     */
    public void setFrsltstat(String frsltstat) {
        this.frsltstat = frsltstat;
    }

    /**
     * @return the frsltstatnm
     */
    public String getFrsltstatnm() {
        return frsltstatnm;
    }

    /**
     * @param frsltstatnm
     *            the frsltstatnm to set
     */
    public void setFrsltstatnm(String frsltstatnm) {
        this.frsltstatnm = frsltstatnm;
    }

    /**
     * @return the fsequence
     */
    public Integer getFsequence() {
        return fsequence;
    }

    /**
     * @param fsequence
     *            the fsequence to set
     */
    public void setFsequence(Integer fsequence) {
        this.fsequence = fsequence;
    }

    /**
     * @return the msgkey
     */
    public Integer getMsgkey() {
        return msgkey;
    }

    /**
     * @param msgkey
     *            the msgkey to set
     */
    public void setMsgkey(Integer msgkey) {
        this.msgkey = msgkey;
    }

    /**
     * @return the smsFailPoint
     */
    public Integer getSmsFailPoint() {
        return smsFailPoint;
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
     * @param smsFailPoint
     *            the smsFailPoint to set
     */
    public void setSmsFailPoint(Integer smsFailPoint) {
        this.smsFailPoint = smsFailPoint;
    }

    public String getSortNum() {
        return sortNum;
    }

    public void setSortNum(String sortNum) {
        this.sortNum = sortNum;
    }

    public String getRslt() {
        return rslt;
    }

    public void setRslt(String rslt) {
        this.rslt = rslt;
    }

    @Override
    public String toString() {
        return "SmsSendHistVO{" + "senderId='" + senderId + '\'' + ", receiverId='" + receiverId + '\''
                + ", receiverNm='" + receiverNm + '\'' + ", receiverNo='" + receiverNo + '\'' + ", sendDttm=" + sendDttm
                + ", status='" + status + '\'' + ", msg='" + msg + '\'' + '}';
    }
}
