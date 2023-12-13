package net.danvi.dmall.smsemail.model;

import java.io.Serializable;

/**
 * Created by dong on 2016-08-29.
 */
public class SmsSendHistSO extends RemoteSearchBaseVO<SmsSendHistSO> implements Serializable {

    private static final long serialVersionUID = -8876648800935963144L;

    /** 조회기간 시작일 */
    private String startDt;
    /** 조회기간 종료일 */
    private String endDt;

    /** 발송상태 */
    private String status;

    /** 수신자 ID */
    private String receiverId;
    /** 수신자 전화번호 */
    private String recvTelno;
    /** 자동발송 여부 */
    private String autoSendYn;
    /** 결과코드 검색 */
    private String searchResult;

    private String searchRecvTelno;
    /** 발송유형 */
    private String sendFrmCd;
    /** 검색어 */
    private String searchWords;
    /** 검색유형 */
    private String searchType;
    /** 발신자 전화번호 */
    private String sendTelno;

    /**
     * @return the searchType
     */
    public String getSearchType() {
        return searchType;
    }

    /**
     * @param searchType
     *            the searchType to set
     */
    public void setSearchType(String searchType) {
        this.searchType = searchType;
    }

    /**
     * @return the searchRecvTelno
     */
    public String getSearchRecvTelno() {
        return searchRecvTelno;
    }

    /**
     * @param searchRecvTelno
     *            the searchRecvTelno to set
     */
    public void setSearchRecvTelno(String searchRecvTelno) {
        this.searchRecvTelno = searchRecvTelno;
    }

    /**
     * @return the sendFrmCd
     */
    public String getSendFrmCd() {
        return sendFrmCd;
    }

    /**
     * @param sendFrmCd
     *            the sendFrmCd to set
     */
    public void setSendFrmCd(String sendFrmCd) {
        this.sendFrmCd = sendFrmCd;
    }

    /**
     * @return the searchWords
     */
    public String getSearchWords() {
        return searchWords;
    }

    /**
     * @param searchWords
     *            the searchWords to set
     */
    public void setSearchWords(String searchWords) {
        this.searchWords = searchWords;
    }

    public String getAutoSendYn() {
        return autoSendYn;
    }

    public void setAutoSendYn(String autoSendYn) {
        this.autoSendYn = autoSendYn;
    }

    public String getSearchResult() {
        return searchResult;
    }

    public void setSearchResult(String searchResult) {
        this.searchResult = searchResult;
    }

    public String getStartDt() {
        return startDt;
    }

    public void setStartDt(String startDt) {
        this.startDt = startDt;
    }

    public String getEndDt() {
        return endDt;
    }

    public void setEndDt(String endDt) {
        this.endDt = endDt;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getReceiverId() {
        return receiverId;
    }

    public void setReceiverId(String receiverId) {
        this.receiverId = receiverId;
    }

    public String getRecvTelno() {
        return recvTelno;
    }

    public void setRecvTelno(String recvTelno) {
        this.recvTelno = recvTelno;
    }

    public String getSendTelno() {
        return sendTelno;
    }

    public void setSendTelno(String sendTelno) {
        this.sendTelno = sendTelno;
    }
}
