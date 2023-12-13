package egovframework.kiosk.customer.vo;

public class CustomerVO {
	private String rsv_no = "";
	private int site_no = 0;
	private String store_no = "";
	private int member_no = 0;
	private String member_nm = "";
	private String rsv_time = "";
	private String req_matr = "";
	private String visit_purpose_cd = "";
	private String visit_purpose_nm = "";
	private String rsv_date = "";
	private String cancel_yn = "";
	private String mobile = "";
	private String visit_yn = "";
	
	private String purpose = "";
	private String purpose_etc = "";
	private int purpose_no = 0;
	
	private String integration_member_gb_cd = "";//01:정회원, 02:간편회원, 03:통합회원
	private String recent_str_name = ""; //최근 방문 매점
	private String secret_nm = ""; //고객이름에 **삽입
	
	private int page_index = 1;
	private int n_page_index = 1;
	private int y_page_index = 1;
	private int tot_page_index = 1;
	
	private String cd_cust = "";
	private String mall_no_card = "";
	
	private String customerGubun = "";
	
	private String login_id ="";
	
	public String getRsv_no() {
		return rsv_no;
	}
	public void setRsv_no(String rsv_no) {
		this.rsv_no = rsv_no;
	}
	public int getSite_no() {
		return site_no;
	}
	public void setSite_no(int site_no) {
		this.site_no = site_no;
	}
	public String getStore_no() {
		return store_no;
	}
	public void setStore_no(String store_no) {
		this.store_no = store_no;
	}
	public int getMember_no() {
		return member_no;
	}
	public void setMember_no(int member_no) {
		this.member_no = member_no;
	}
	public String getMember_nm() {
		return member_nm;
	}
	public void setMember_nm(String member_nm) {
		this.member_nm = member_nm;
	}
	public String getRsv_time() {
		return rsv_time;
	}
	public void setRsv_time(String rsv_time) {
		this.rsv_time = rsv_time;
	}
	public String getReq_matr() {
		return req_matr;
	}
	public void setReq_matr(String req_matr) {
		this.req_matr = req_matr;
	}
	
	public String getVisit_purpose_cd() {
		return visit_purpose_cd;
	}
	public void setVisit_purpose_cd(String visit_purpose_cd) {
		this.visit_purpose_cd = visit_purpose_cd;
	}
	public String getVisit_purpose_nm() {
		return visit_purpose_nm;
	}
	public void setVisit_purpose_nm(String visit_purpose_nm) {
		this.visit_purpose_nm = visit_purpose_nm;
	}
	public String getRsv_date() {
		return rsv_date;
	}
	public void setRsv_date(String rsv_date) {
		this.rsv_date = rsv_date;
	}
	public String getCancel_yn() {
		return cancel_yn;
	}
	public void setCancel_yn(String cancel_yn) {
		this.cancel_yn = cancel_yn;
	}
	public String getMobile() {
		return mobile;
	}
	public void setMobile(String mobile) {
		this.mobile = mobile;
	}
	public String getVisit_yn() {
		return visit_yn;
	}
	public void setVisit_yn(String visit_yn) {
		this.visit_yn = visit_yn;
	}
	public String getPurpose() {
		return purpose;
	}
	public void setPurpose(String purpose) {
		this.purpose = purpose;
	}
	public String getPurpose_etc() {
		return purpose_etc;
	}
	public void setPurpose_etc(String purpose_etc) {
		this.purpose_etc = purpose_etc;
	}
	public int getPurpose_no() {
		return purpose_no;
	}
	public void setPurpose_no(int purpose_no) {
		this.purpose_no = purpose_no;
	}
	public String getIntegration_member_gb_cd() {
		return integration_member_gb_cd;
	}
	public void setIntegration_member_gb_cd(String integration_member_gb_cd) {
		this.integration_member_gb_cd = integration_member_gb_cd;
	}
	public String getRecent_str_name() {
		return recent_str_name;
	}
	public void setRecent_str_name(String recent_str_name) {
		this.recent_str_name = recent_str_name;
	}
	public String getSecret_nm() {
		return secret_nm;
	}
	public void setSecret_nm(String secret_nm) {
		this.secret_nm = secret_nm;
	}
	public int getPage_index() {
		return page_index;
	}
	public void setPage_index(int page_index) {
		this.page_index = page_index;
	}
	public int getN_page_index() {
		return n_page_index;
	}
	public void setN_page_index(int n_page_index) {
		this.n_page_index = n_page_index;
	}
	public int getY_page_index() {
		return y_page_index;
	}
	public void setY_page_index(int y_page_index) {
		this.y_page_index = y_page_index;
	}
	public int getTot_page_index() {
		return tot_page_index;
	}
	public void setTot_page_index(int tot_page_index) {
		this.tot_page_index = tot_page_index;
	}
	public String getCd_cust() {
		return cd_cust;
	}
	public void setCd_cust(String cd_cust) {
		this.cd_cust = cd_cust;
	}
	public String getMall_no_card() {
		return mall_no_card;
	}
	public void setMall_no_card(String mall_no_card) {
		this.mall_no_card = mall_no_card;
	}
	public String getCustomerGubun() {
		return customerGubun;
	}
	public void setCustomerGubun(String customerGubun) {
		this.customerGubun = customerGubun;
	}
	public String getLogin_id() {
		return login_id;
	}
	public void setLogin_id(String login_id) {
		this.login_id = login_id;
	}
}
