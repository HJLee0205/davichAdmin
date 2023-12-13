package net.danvi.dmall.smsemail.model;

import java.io.Serializable;

/**
 * Created by dong on 2016-08-29.
 */
public class EmailSendHistSO extends RemoteSearchBaseVO<EmailSendHistSO> implements Serializable {

    private static final long serialVersionUID = -8942579935798111572L;

    /** 메일발송번호 */
    private String mailSendNo;

    /** 조회기간 시작일 */
    private String startDt;
    /** 조회기간 종료일 */
    private String endDt;

    /** 검색어 구분 */
    private String searchType;
    /** 검색어 */
    private String searchWords;

    /** 자동 전송 여부 */
    private String autoSendYn;

    /** 발송 상태 */
    private String resultCd;

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

    /**
     * @return the mailSendNo
     */
    public String getMailSendNo() {
        return mailSendNo;
    }

    /**
     * @param mailSendNo
     *            the mailSendNo to set
     */
    public void setMailSendNo(String mailSendNo) {
        this.mailSendNo = mailSendNo;
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

    public String getAutoSendYn() {
        return autoSendYn;
    }

    public void setAutoSendYn(String autoSendYn) {
        this.autoSendYn = autoSendYn;
    }
}
