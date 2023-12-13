package net.danvi.dmall.smsemail.model;

/**
 * Created by dong on 2016-08-31.
 */
public class SmsEmailPointPO {
    private String siteNo;
    private Integer point;

    // 실패 포인트 관련 변수
    private Integer fsequence;
    private Integer msgkey;
    private Integer smsFailPoint;

    public String getSiteNo() {
        return siteNo;
    }

    public void setSiteNo(String siteNo) {
        this.siteNo = siteNo;
    }

    public Integer getPoint() {
        return point;
    }

    public void setPoint(Integer point) {
        this.point = point;
    }

    public Integer getFsequence() {
        return fsequence;
    }

    public void setFsequence(Integer fsequence) {
        this.fsequence = fsequence;
    }

    public Integer getMsgkey() {
        return msgkey;
    }

    public void setMsgkey(Integer msgkey) {
        this.msgkey = msgkey;
    }

    public Integer getSmsFailPoint() {
        return smsFailPoint;
    }

    public void setSmsFailPoint(Integer smsFailPoint) {
        this.smsFailPoint = smsFailPoint;
    }
}
