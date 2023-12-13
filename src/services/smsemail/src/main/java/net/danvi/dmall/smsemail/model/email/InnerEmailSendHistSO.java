package net.danvi.dmall.smsemail.model.email;

import java.io.Serializable;

import net.danvi.dmall.smsemail.model.EmailSendHistSO;
import net.danvi.dmall.smsemail.model.RemoteSearchBaseVO;

/**
 * Created by dong on 2016-08-29.
 */
public class InnerEmailSendHistSO extends RemoteSearchBaseVO<InnerEmailSendHistSO> implements Serializable {

    private static final long serialVersionUID = 3132306259638627724L;

    /** 조회기간 시작일 */
    private String startDt;
    /** 메일발송번호 */
    private String mailSendNo;
    /** 조회기간 종료일 */
    private String endDt;

    /** 검색어 구분 */
    private String searchType;
    /** 검색어 */
    private String searchWords;
    /** 발송 상태 */
    private String resultCd;

    public InnerEmailSendHistSO() {
    }

    public InnerEmailSendHistSO(EmailSendHistSO so) {
        this.setSiteNo(so.getSiteNo());
        this.setPage(so.getPage());
        this.setRows(so.getRows());
        this.setSidx(so.getSidx());
        this.setSord(so.getSord());

        this.startDt = so.getStartDt();
        this.endDt = so.getEndDt();
        this.searchType = so.getSearchType();
        this.searchWords = so.getSearchWords();
        this.mailSendNo = so.getMailSendNo();
        this.resultCd = so.getResultCd();
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
}
