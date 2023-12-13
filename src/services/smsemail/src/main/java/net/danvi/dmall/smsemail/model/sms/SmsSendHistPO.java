package net.danvi.dmall.smsemail.model.sms;

import net.danvi.dmall.smsemail.model.request.SmsSendPO;
import dmall.framework.common.annotation.Encrypt;

import java.util.Date;

/**
 * Created by dong on 2016-09-05.
 */
public class SmsSendHistPO {
    private Long smsSendNo;
    private String siteNo;
    private String sendTypeCd;
    private String sendTargetCd;
    private String sendFrmCd;
    private String resultCd;
    @Encrypt
    private String sendTelno;
    private String sendWords;
    private Long senderNo;
    private String senderId;
    @Encrypt
    private String senderNm;
    private Date sendDttm;
    private String realSendDttm;
    @Encrypt
    private String recvTelno;
    private String receiverId;
    private Long receiverNo;
    @Encrypt
    private String receiverNm;
    private Date recvDttm;
    private String autoSendYn;
    private String ordNo;
    private Date regDttm;
    private Date updDttm;

    public SmsSendHistPO(SmsSendPO po) {
        this.smsSendNo = po.getSmsSendNo();
        this.siteNo = po.getSiteNo();
        this.ordNo = po.getOrdNo();
        this.sendTypeCd = po.getSendTypeCd();
        this.sendTargetCd = po.getSendTargetCd();
        this.sendFrmCd = po.getSendFrmCd();
        this.sendTelno = po.getSendTelno();
        this.sendWords = po.getSendWords();
        this.senderNo = po.getSenderNo();
        this.senderId = po.getSenderId();
        this.senderNm = po.getSenderNm();
        this.recvTelno = po.getRecvTelno();
        this.receiverNo = po.getReceiverNo();
        this.receiverId = po.getReceiverId();
        this.receiverNm = po.getReceiverNm();
        this.autoSendYn = po.getAutoSendYn();

    }

    public String getReceiverId() {
        return receiverId;
    }

    public void setReceiverId(String receiverId) {
        this.receiverId = receiverId;
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

    public String getResultCd() {
        return resultCd;
    }

    public void setResultCd(String resultCd) {
        this.resultCd = resultCd;
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

    public String getSenderId() {
        return senderId;
    }

    public void setSenderId(String senderId) {
        this.senderId = senderId;
    }

    public String getSenderNm() {
        return senderNm;
    }

    public void setSenderNm(String senderNm) {
        this.senderNm = senderNm;
    }

    public Date getSendDttm() {
        return sendDttm;
    }

    public void setSendDttm(Date sendDttm) {
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

    public String getReceiverNm() {
        return receiverNm;
    }

    public void setReceiverNm(String receiverNm) {
        this.receiverNm = receiverNm;
    }

    public Date getRecvDttm() {
        return recvDttm;
    }

    public void setRecvDttm(Date recvDttm) {
        this.recvDttm = recvDttm;
    }

    public String getAutoSendYn() {
        return autoSendYn;
    }

    public void setAutoSendYn(String autoSendYn) {
        this.autoSendYn = autoSendYn;
    }

    public String getOrdNo() {
        return ordNo;
    }

    public void setOrdNo(String ordNo) {
        this.ordNo = ordNo;
    }

    public Date getRegDttm() {
        return regDttm;
    }

    public void setRegDttm(Date regDttm) {
        this.regDttm = regDttm;
    }

    public Date getUpdDttm() {
        return updDttm;
    }

    public void setUpdDttm(Date updDttm) {
        this.updDttm = updDttm;
    }

    @Override
    public String toString() {
        return "SmsSendHistPO{" + "smsSendNo=" + smsSendNo + ", siteNo=" + siteNo + ", sendTypeCd='" + sendTypeCd + '\''
                + ", sendTargetCd='" + sendTargetCd + '\'' + ", sendFrmCd='" + sendFrmCd + '\'' + ", resultCd='"
                + resultCd + '\'' + ", sendTelno='" + sendTelno + '\'' + ", sendWords='" + sendWords + '\''
                + ", senderNo=" + senderNo + ", senderId='" + senderId + '\'' + ", senderNm='" + senderNm + '\''
                + ", sendDttm=" + sendDttm + ", realSendDttm='" + realSendDttm + '\'' + ", recvTelno='" + recvTelno
                + '\'' + ", receiverNo=" + receiverNo + ", receiverNm='" + receiverNm + '\'' + ", recvDttm=" + recvDttm
                + ", autoSendYn='" + autoSendYn + '\'' + ", ordNo='" + ordNo + '\'' + ", regDttm=" + regDttm
                + ", updDttm=" + updDttm + '}';
    }
}
