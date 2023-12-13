package net.danvi.dmall.smsemail.model.sms;

import java.io.Serializable;

import net.danvi.dmall.smsemail.model.SmsAutoSendHistSO;
import net.danvi.dmall.smsemail.model.SmsSendHistSO;

/**
 * Created by dong on 2016-08-29.
 */
public class InnerSmsAutoSendHistSO extends SmsSendHistSO implements Serializable {

    private static final long serialVersionUID = -7621427637239219859L;

    /** 발송유형 */
    private String sendFrmCd;
    /** 검색어 구분 */
    private String searchType;
    /** 검색어 */
    private String searchWords;

    /** 자동발송 여부 */
    private String autoSendYn;

    public String getAutoSendYn() {
        return autoSendYn;
    }

    public void setAutoSendYn(String autoSendYn) {
        this.autoSendYn = autoSendYn;
    }

    public InnerSmsAutoSendHistSO() {
    }

    public InnerSmsAutoSendHistSO(SmsAutoSendHistSO so) {
        this.setSiteNo(so.getSiteNo());
        this.setPage(so.getPage());
        this.setRows(so.getRows());
        this.setSidx(so.getSidx());
        this.setSord(so.getSord());
        this.setAutoSendYn(so.getAutoSendYn());
        this.setSearchResult(so.getSearchResult());

        this.sendFrmCd = so.getSendFrmCd();
        this.searchType = so.getSearchType();
        this.searchWords = so.getSearchWords();
    }

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
