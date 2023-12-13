package net.danvi.dmall.biz.system.remote.maru.model;

/**
 * Created by dong on 2016-09-13.
 */
public class MaruResult {

    /** 에러여부 */
    private Boolean error;
    /** 작업 인덱스 */
    private Long idx;
    /** FTP 아이디 */
    private String ftp_id;
    /** FTP PW */
    private String ftp_passwd;
    /** 세팅 완료 타입 */
    private String type;
    /** 에러코드 */
    private String errorCode;
    /** 에러 내용 */
    private String errorText;

    /** 사이트 번호 */
    private Long siteNo;
    /** 사이트 아이디 */
    private String siteId;
    /** 요청 코드 */
    private Integer requestCd;

    /** 디스크 용량 */
    private Integer disk;
    /** 트래픽 용량 */
    private Integer traffic;
    /** 도메인 */
    private String domain;

    /** 사이트 타입 코드 */
    private String siteTypeCd;
    /** 비밀번호 */
    private String pw;

    public Boolean getError() {
        return error;
    }

    public void setError(Boolean error) {
        this.error = error;
    }

    public Long getIdx() {
        return idx;
    }

    public void setIdx(Long idx) {
        this.idx = idx;
    }

    public String getFtp_id() {
        return ftp_id;
    }

    public void setFtp_id(String ftp_id) {
        this.ftp_id = ftp_id;
    }

    public String getFtp_passwd() {
        return ftp_passwd;
    }

    public void setFtp_passwd(String ftp_passwd) {
        this.ftp_passwd = ftp_passwd;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public String getErrorCode() {
        return errorCode;
    }

    public void setErrorCode(String errorCode) {
        this.errorCode = errorCode;
    }

    public String getErrorText() {
        return errorText;
    }

    public void setErrorText(String errorText) {
        this.errorText = errorText;
    }

    public Long getSiteNo() {
        return siteNo;
    }

    public void setSiteNo(Long siteNo) {
        this.siteNo = siteNo;
    }

    public String getSiteId() {
        return siteId;
    }

    public void setSiteId(String siteId) {
        this.siteId = siteId;
    }

    public Integer getRequestCd() {
        return requestCd;
    }

    public void setRequestCd(Integer requestCd) {
        this.requestCd = requestCd;
    }

    public Integer getDisk() {
        return disk;
    }

    public void setDisk(Integer disk) {
        this.disk = disk;
    }

    public Integer getTraffic() {
        return traffic;
    }

    public void setTraffic(Integer traffic) {
        this.traffic = traffic;
    }

    public String getDomain() {
        return domain;
    }

    public void setDomain(String domain) {
        this.domain = domain;
    }

    public String getSiteTypeCd() {
        return siteTypeCd;
    }

    public void setSiteTypeCd(String siteTypeCd) {
        this.siteTypeCd = siteTypeCd;
    }

    public String getPw() {
        return pw;
    }

    public void setPw(String pw) {
        this.pw = pw;
    }

    @Override
    public String toString() {
        return "MaruResult{" +
                "error=" + error +
                ", idx=" + idx +
                ", ftp_id='" + ftp_id + '\'' +
                ", ftp_passwd='" + ftp_passwd + '\'' +
                ", type='" + type + '\'' +
                ", errorCode='" + errorCode + '\'' +
                ", errorText='" + errorText + '\'' +
                ", siteNo=" + siteNo +
                ", siteId='" + siteId + '\'' +
                ", requestCd=" + requestCd +
                ", disk=" + disk +
                ", traffic=" + traffic +
                ", domain='" + domain + '\'' +
                ", siteTypeCd='" + siteTypeCd + '\'' +
                ", pw='" + pw + '\'' +
                '}';
    }
}
