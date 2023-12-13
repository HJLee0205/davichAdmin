package net.danvi.dmall.smsemail.model.request;

import java.io.Serializable;

public class PushSendPO implements Serializable, Cloneable {

    private static final long serialVersionUID = -5677181115652162111L;

    // 푸시 발송 번호
    private String pushNo;
    private String siteNo;
    private String recvCndtGb;
    
    private String searchDateFrom;
    private String searchDateTo;
    private String pushStatus;
    private String alarmGb;
    private String sendMsg;
    private String pageGb;
    private String updrNo;
    private String memberNo;
    private String beaconId;
    
    private String receiverNo;
    private String receiverId;
    private String link;
    private String imgUrl;
    private String token;
    private String osType;
    
	public String getSiteNo() {
		return siteNo;
	}
	public void setSiteNo(String siteNo) {
		this.siteNo = siteNo;
	}
	public String getRecvCndtGb() {
		return recvCndtGb;
	}
	public void setRecvCndtGb(String recvCndtGb) {
		this.recvCndtGb = recvCndtGb;
	}
	
	public String getSearchDateFrom() {
		return searchDateFrom;
	}
	public void setSearchDateFrom(String searchDateFrom) {
		this.searchDateFrom = searchDateFrom;
	}
	public String getSearchDateTo() {
		return searchDateTo;
	}
	public void setSearchDateTo(String searchDateTo) {
		this.searchDateTo = searchDateTo;
	}
	public String getPushStatus() {
		return pushStatus;
	}
	public void setPushStatus(String pushStatus) {
		this.pushStatus = pushStatus;
	}
	public String getAlarmGb() {
		return alarmGb;
	}
	public void setAlarmGb(String alarmGb) {
		this.alarmGb = alarmGb;
	}
	public String getSendMsg() {
		return sendMsg;
	}
	public void setSendMsg(String sendMsg) {
		this.sendMsg = sendMsg;
	}
	public String getPageGb() {
		return pageGb;
	}
	public void setPageGb(String pageGb) {
		this.pageGb = pageGb;
	}
	public String getUpdrNo() {
		return updrNo;
	}
	public void setUpdrNo(String updrNo) {
		this.updrNo = updrNo;
	}
	
	public String getMemberNo() {
		return memberNo;
	}
	public void setMemberNo(String memberNo) {
		this.memberNo = memberNo;
	}
	public String getBeaconId() {
		return beaconId;
	}
	public void setBeaconId(String beaconId) {
		this.beaconId = beaconId;
	}
	
	public String getReceiverNo() {
		return receiverNo;
	}
	public void setReceiverNo(String receiverNo) {
		this.receiverNo = receiverNo;
	}
	public String getReceiverId() {
		return receiverId;
	}
	public void setReceiverId(String receiverId) {
		this.receiverId = receiverId;
	}
	public String getLink() {
		return link;
	}
	public void setLink(String link) {
		this.link = link;
	}
	
	public String getPushNo() {
		return pushNo;
	}
	public void setPushNo(String pushNo) {
		this.pushNo = pushNo;
	}
	
	public String getImgUrl() {
		return imgUrl;
	}
	public void setImgUrl(String imgUrl) {
		this.imgUrl = imgUrl;
	}
	public String getToken() {
		return token;
	}
	public void setToken(String token) {
		this.token = token;
	}
	
	
	public String getOsType() {
		return osType;
	}
	public void setOsType(String osType) {
		this.osType = osType;
	}
	@Override
	public String toString() {
		return "PushSendPO [pushNo=" + pushNo + ", siteNo=" + siteNo + ", recvCndtGb=" + recvCndtGb
				+ ", searchDateFrom=" + searchDateFrom + ", searchDateTo=" + searchDateTo + ", pushStatus=" + pushStatus
				+ ", alarmGb=" + alarmGb + ", sendMsg=" + sendMsg + ", pageGb=" + pageGb + ", updrNo=" + updrNo
				+ ", memberNo=" + memberNo + ", beaconId=" + beaconId + ", receiverNo=" + receiverNo + ", receiverId="
				+ receiverId + ", link=" + link + "]";
	}
	
	
	
}
