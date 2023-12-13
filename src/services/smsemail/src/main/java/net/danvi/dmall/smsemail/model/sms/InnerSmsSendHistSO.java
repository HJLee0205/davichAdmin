package net.danvi.dmall.smsemail.model.sms;

import java.io.Serializable;

import net.danvi.dmall.smsemail.model.RemoteSearchBaseVO;
import net.danvi.dmall.smsemail.model.SmsSendHistSO;
import dmall.framework.common.annotation.Encrypt;

/**
 * Created by dong on 2016-08-29.
 */
public class InnerSmsSendHistSO extends RemoteSearchBaseVO<InnerSmsSendHistSO> implements Serializable {

    /** 조회기간 시작일 */
    private String startDt;
    /** 조회기간 종료일 */
    private String endDt;

    /** 발송상태 */
    private String status;

    /** 수신자 ID */
    private String receiverId;
    /** 수신자 전화번호 */
    @Encrypt
    private String recvTelno;
    /** 발신자 전화번호 */
    @Encrypt
    private String sendTelno;

    /** 자동발송 여부 */
    private String autoSendYn;
    /** 결과코드 검색 */
    private String searchResult;

    @Encrypt
    private String searchRecvTelno;
    /** 발송유형 */
    private String sendFrmCd;
    /** 검색 유형 */
    private String searchType;
    /** 검색어 */
    @Encrypt
    private String searchWords;

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

    public String getSendTelno() {
        return sendTelno;
    }

    public void setSendTelno(String sendTelno) {
        this.sendTelno = sendTelno;
    }

    public InnerSmsSendHistSO() {
    }

    public InnerSmsSendHistSO(SmsSendHistSO so) {
        this.setSiteNo(so.getSiteNo());
        this.setPage(so.getPage());
        this.setRows(so.getRows());
        this.setSidx(so.getSidx());
        this.setSord(so.getSord());
        this.setAutoSendYn(so.getAutoSendYn());
        this.setSearchResult(so.getSearchResult());
        this.setSendFrmCd(so.getSendFrmCd());
        this.setSearchWords(so.getSearchWords());
        this.setSearchRecvTelno(so.getSearchRecvTelno());
        this.setSearchType(so.getSearchType());

        this.startDt = so.getStartDt();
        this.endDt = so.getEndDt();
        this.status = so.getStatus();
        this.receiverId = so.getReceiverId();
        this.recvTelno = so.getRecvTelno();
        this.sendTelno = so.getSendTelno();
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
}
