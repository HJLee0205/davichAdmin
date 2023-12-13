package net.danvi.dmall.smsemail.model;

/**
 * Created by dong on 2016-08-31.
 */
public class SmsEmailPointHistPO {

    private String siteNo;
    private Integer point;
    private String gbCd; // 01:충전, 02:전송차감, 03:실패복구

    public SmsEmailPointHistPO() {}

    public SmsEmailPointHistPO(SmsEmailPointPO po) {
        this.siteNo = po.getSiteNo();
        this.point = Math.abs(po.getPoint());
    }

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

    public String getGbCd() {
        return gbCd;
    }

    public void setGbCd(String gbCd) {
        this.gbCd = gbCd;
    }
}
