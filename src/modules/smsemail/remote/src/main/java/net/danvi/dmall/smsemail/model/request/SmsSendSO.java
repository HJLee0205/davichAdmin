package net.danvi.dmall.smsemail.model.request;

import java.io.Serializable;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 5. 4.
 * 작성자     : dong
 * 설명       :
 * </pre>
 */
public class SmsSendSO implements Serializable {
    private String fromRegDt;
    private String toRegDt;
    private String fromRecvDttm;
    private String toRecvDttm;
    private String useYn;
    private String searchKind;
    private String searchVal;
    private String pageGb;

    private String smsSendNo;
    private String smsMember;
    private Integer possCnt;
    private String sendWords;
    private String sendTelno;
    private String[] recvTelnoTotal;
    private String[] receiverNoTotal;
    private String[] receiverIdTotal;
    private String[] receiverNmTotal;
    private String[] receiverRecvRjtYnTotal;

    private String[] recvTelnoSearch;
    private String[] receiverNoSearch;
    private String[] receiverIdSearch;
    private String[] receiverNmSearch;
    private String[] receiverRecvRjtYnSearch;

    private String[] recvTelnoSelect;
    private String[] receiverNoSelect;
    private String[] receiverIdSelect;
    private String[] receiverNmSelect;
    private String[] receiverRecvRjtYnSelect;

    private String[] fdestineArr;
    private String fcallback;

    // SMS 발송 내역
    private String receiverId;
    private String receiverNm;
    private String[] resultCd;
    private String recvTelno;

    private String sendFrmCd;
    private String sendTargetCd;
    private String searchType;
    private String searchWords;
    private String searchRecvTelno;

    private String sendTypeCd;
    private String autoSendYn;
    private long memberNo;

    private String templateCode;

    private MemberManageSO memberManageSO;

    public String getFromRegDt() {
        return fromRegDt;
    }

    public void setFromRegDt(String fromRegDt) {
        this.fromRegDt = fromRegDt;
    }

    public String getToRegDt() {
        return toRegDt;
    }

    public void setToRegDt(String toRegDt) {
        this.toRegDt = toRegDt;
    }

    public String getFromRecvDttm() {
        return fromRecvDttm;
    }

    public void setFromRecvDttm(String fromRecvDttm) {
        this.fromRecvDttm = fromRecvDttm;
    }

    public String getToRecvDttm() {
        return toRecvDttm;
    }

    public void setToRecvDttm(String toRecvDttm) {
        this.toRecvDttm = toRecvDttm;
    }

    public String getUseYn() {
        return useYn;
    }

    public void setUseYn(String useYn) {
        this.useYn = useYn;
    }

    public String getSearchKind() {
        return searchKind;
    }

    public void setSearchKind(String searchKind) {
        this.searchKind = searchKind;
    }

    public String getSearchVal() {
        return searchVal;
    }

    public void setSearchVal(String searchVal) {
        this.searchVal = searchVal;
    }

    public String getPageGb() {
        return pageGb;
    }

    public void setPageGb(String pageGb) {
        this.pageGb = pageGb;
    }

    public String getSmsSendNo() {
        return smsSendNo;
    }

    public void setSmsSendNo(String smsSendNo) {
        this.smsSendNo = smsSendNo;
    }

    public String getSmsMember() {
        return smsMember;
    }

    public void setSmsMember(String smsMember) {
        this.smsMember = smsMember;
    }

    public Integer getPossCnt() {
        return possCnt;
    }

    public void setPossCnt(Integer possCnt) {
        this.possCnt = possCnt;
    }

    public String getSendWords() {
        return sendWords;
    }

    public void setSendWords(String sendWords) {
        this.sendWords = sendWords;
    }

    public String getSendTelno() {
        return sendTelno;
    }

    public void setSendTelno(String sendTelno) {
        this.sendTelno = sendTelno;
    }

    public String[] getRecvTelnoTotal() {
        return recvTelnoTotal;
    }

    public void setRecvTelnoTotal(String[] recvTelnoTotal) {
        this.recvTelnoTotal = recvTelnoTotal;
    }

    public String[] getReceiverNoTotal() {
        return receiverNoTotal;
    }

    public void setReceiverNoTotal(String[] receiverNoTotal) {
        this.receiverNoTotal = receiverNoTotal;
    }

    public String[] getReceiverIdTotal() {
        return receiverIdTotal;
    }

    public void setReceiverIdTotal(String[] receiverIdTotal) {
        this.receiverIdTotal = receiverIdTotal;
    }

    public String[] getReceiverNmTotal() {
        return receiverNmTotal;
    }

    public void setReceiverNmTotal(String[] receiverNmTotal) {
        this.receiverNmTotal = receiverNmTotal;
    }

    public String[] getReceiverRecvRjtYnTotal() {
        return receiverRecvRjtYnTotal;
    }

    public void setReceiverRecvRjtYnTotal(String[] receiverRecvRjtYnTotal) {
        this.receiverRecvRjtYnTotal = receiverRecvRjtYnTotal;
    }

    public String[] getRecvTelnoSearch() {
        return recvTelnoSearch;
    }

    public void setRecvTelnoSearch(String[] recvTelnoSearch) {
        this.recvTelnoSearch = recvTelnoSearch;
    }

    public String[] getReceiverNoSearch() {
        return receiverNoSearch;
    }

    public void setReceiverNoSearch(String[] receiverNoSearch) {
        this.receiverNoSearch = receiverNoSearch;
    }

    public String[] getReceiverIdSearch() {
        return receiverIdSearch;
    }

    public void setReceiverIdSearch(String[] receiverIdSearch) {
        this.receiverIdSearch = receiverIdSearch;
    }

    public String[] getReceiverNmSearch() {
        return receiverNmSearch;
    }

    public void setReceiverNmSearch(String[] receiverNmSearch) {
        this.receiverNmSearch = receiverNmSearch;
    }

    public String[] getReceiverRecvRjtYnSearch() {
        return receiverRecvRjtYnSearch;
    }

    public void setReceiverRecvRjtYnSearch(String[] receiverRecvRjtYnSearch) {
        this.receiverRecvRjtYnSearch = receiverRecvRjtYnSearch;
    }

    public String[] getRecvTelnoSelect() {
        return recvTelnoSelect;
    }

    public void setRecvTelnoSelect(String[] recvTelnoSelect) {
        this.recvTelnoSelect = recvTelnoSelect;
    }

    public String[] getReceiverNoSelect() {
        return receiverNoSelect;
    }

    public void setReceiverNoSelect(String[] receiverNoSelect) {
        this.receiverNoSelect = receiverNoSelect;
    }

    public String[] getReceiverIdSelect() {
        return receiverIdSelect;
    }

    public void setReceiverIdSelect(String[] receiverIdSelect) {
        this.receiverIdSelect = receiverIdSelect;
    }

    public String[] getReceiverNmSelect() {
        return receiverNmSelect;
    }

    public void setReceiverNmSelect(String[] receiverNmSelect) {
        this.receiverNmSelect = receiverNmSelect;
    }

    public String[] getReceiverRecvRjtYnSelect() {
        return receiverRecvRjtYnSelect;
    }

    public void setReceiverRecvRjtYnSelect(String[] receiverRecvRjtYnSelect) {
        this.receiverRecvRjtYnSelect = receiverRecvRjtYnSelect;
    }

    public String[] getFdestineArr() {
        return fdestineArr;
    }

    public void setFdestineArr(String[] fdestineArr) {
        this.fdestineArr = fdestineArr;
    }

    public String getFcallback() {
        return fcallback;
    }

    public void setFcallback(String fcallback) {
        this.fcallback = fcallback;
    }

    public String getReceiverId() {
        return receiverId;
    }

    public void setReceiverId(String receiverId) {
        this.receiverId = receiverId;
    }

    public String getReceiverNm() {
        return receiverNm;
    }

    public void setReceiverNm(String receiverNm) {
        this.receiverNm = receiverNm;
    }

    public String[] getResultCd() {
        return resultCd;
    }

    public void setResultCd(String[] resultCd) {
        this.resultCd = resultCd;
    }

    public String getRecvTelno() {
        return recvTelno;
    }

    public void setRecvTelno(String recvTelno) {
        this.recvTelno = recvTelno;
    }

    public String getSendFrmCd() {
        return sendFrmCd;
    }

    public void setSendFrmCd(String sendFrmCd) {
        this.sendFrmCd = sendFrmCd;
    }

    public String getSendTargetCd() {
        return sendTargetCd;
    }

    public void setSendTargetCd(String sendTargetCd) {
        this.sendTargetCd = sendTargetCd;
    }

    public String getSearchType() {
        return searchType;
    }

    public void setSearchType(String searchType) {
        this.searchType = searchType;
    }

    public String getSearchWords() {
        return searchWords;
    }

    public void setSearchWords(String searchWords) {
        this.searchWords = searchWords;
    }

    public String getSearchRecvTelno() {
        return searchRecvTelno;
    }

    public void setSearchRecvTelno(String searchRecvTelno) {
        this.searchRecvTelno = searchRecvTelno;
    }

    public String getSendTypeCd() {
        return sendTypeCd;
    }

    public void setSendTypeCd(String sendTypeCd) {
        this.sendTypeCd = sendTypeCd;
    }

    public String getAutoSendYn() {
        return autoSendYn;
    }

    public void setAutoSendYn(String autoSendYn) {
        this.autoSendYn = autoSendYn;
    }

    public long getMemberNo() {
        return memberNo;
    }

    public void setMemberNo(long memberNo) {
        this.memberNo = memberNo;
    }

    public String getTemplateCode() {
        return templateCode;
    }

    public void setTemplateCode(String templateCode) {
        this.templateCode = templateCode;
    }

    public MemberManageSO getMemberManageSO() {
        return memberManageSO;
    }

    public void setMemberManageSO(MemberManageSO memberManageSO) {
        this.memberManageSO = memberManageSO;
    }
}
