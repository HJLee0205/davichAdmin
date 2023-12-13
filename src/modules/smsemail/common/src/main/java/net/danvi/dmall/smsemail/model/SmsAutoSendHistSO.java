package net.danvi.dmall.smsemail.model;

import java.io.Serializable;

/**
 * Created by dong on 2016-08-29.
 */
public class SmsAutoSendHistSO extends SmsSendHistSO implements Serializable {

    private static final long serialVersionUID = -7621427637239219859L;

    /** 발송유형 */
    private String sendFrmCd;
    /** 검색어 구분 */
    private String searchType;
    /** 검색어 */
    private String searchWords;
    /** 자동발송 여부 */
    private String autoSendYn;

    public String getSendFrmCd() {
        return sendFrmCd;
    }

    public void setSendFrmCd(String sendFrmCd) {
        this.sendFrmCd = sendFrmCd;
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
}
