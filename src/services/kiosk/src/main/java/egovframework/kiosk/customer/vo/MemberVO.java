package egovframework.kiosk.customer.vo;

public class MemberVO {
	private int member_no = 0;
	private int site_no = 0;
	private String member_nm = "";
	private String mobile = "";
	private String integration_member_gb_cd = "";
	public int getMember_no() {
		return member_no;
	}
	public void setMember_no(int member_no) {
		this.member_no = member_no;
	}
	public int getSite_no() {
		return site_no;
	}
	public void setSite_no(int site_no) {
		this.site_no = site_no;
	}
	public String getMember_nm() {
		return member_nm;
	}
	public void setMember_nm(String member_nm) {
		this.member_nm = member_nm;
	}
	public String getMobile() {
		return mobile;
	}
	public void setMobile(String mobile) {
		this.mobile = mobile;
	}
	public String getIntegration_member_gb_cd() {
		return integration_member_gb_cd;
	}
	public void setIntegration_member_gb_cd(String integration_member_gb_cd) {
		this.integration_member_gb_cd = integration_member_gb_cd;
	}
	
	
}
