package egovframework.kiosk.customer.vo;

import java.util.Date;


public class StrBookingVO {
	private String seq_no = "";
	private String seq_no3 = "";
	private String dates = "";
	private String str_code = "";
	private String times = "";
	private String nm_cust = "";
	private String handphone = "";
	private String flag = "";
	private String purpose = "";
	private String purpose_etc = "";
	private String book_yn = "";
	private String book_time = "";
	private String input_date = "";
	private String cng_date = "";
	private String status = "";
	private String ip = "";
	
	private String rsv_no = "";
	private String visit_yn = "";
	private String ttsYn = "";
	private int member_no = 0; 

	private int page_index = 1;
	private int n_page_index = 1;
	private int y_page_index = 1;
	private int tot_page_index = 1;
	private int page_unit = 5;
	private int page_size = 10;	
	private int waiting_cnt = 0;
	private int seq_no2 = 0;
	
	private Date input_date2;
	private Date cng_date2;
	private String cd_cust = "";
	
	private int age = 0;
	private int rsv_seq = 0;
	private String ct_telno = "";
	private String times_fr = "";
	private String returnTime = "";
	
	private String tts_01 = "";
	private String tts_02 = "";
	private String tts_03 = "";
	private String tts_gubun = "";
	private String login_id = "";
	
	public String getSeq_no() {
		return seq_no;
	}

	public void setSeq_no(String seq_no) {
		this.seq_no = seq_no;
	}
	
	public String getDates() {
		return dates;
	}

	public void setDates(String dates) {
		this.dates = dates;
	}

	public String getStr_code() {
		return str_code;
	}

	public void setStr_code(String str_code) {
		this.str_code = str_code;
	}

	public String getTimes() {
		return times;
	}

	public void setTimes(String times) {
		this.times = times;
	}

	public String getNm_cust() {
		return nm_cust;
	}

	public void setNm_cust(String nm_cust) {
		this.nm_cust = nm_cust;
	}

	public String getHandphone() {
		return handphone;
	}

	public void setHandphone(String handphone) {
		this.handphone = handphone;
	}

	public String getFlag() {
		return flag;
	}

	public void setFlag(String flag) {
		this.flag = flag;
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

	public String getBook_yn() {
		return book_yn;
	}

	public void setBook_yn(String book_yn) {
		this.book_yn = book_yn;
	}

	public String getBook_time() {
		return book_time;
	}

	public void setBook_time(String book_time) {
		this.book_time = book_time;
	}

	public String getInput_date() {
		return input_date;
	}

	public void setInput_date(String input_date) {
		this.input_date = input_date;
	}

	public String getCng_date() {
		return cng_date;
	}

	public void setCng_date(String cng_date) {
		this.cng_date = cng_date;
	}
	
	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public String getRsv_no() {
		return rsv_no;
	}

	public void setRsv_no(String rsv_no) {
		this.rsv_no = rsv_no;
	}

	public String getVisit_yn() {
		return visit_yn;
	}

	public void setVisit_yn(String visit_yn) {
		this.visit_yn = visit_yn;
	}

	public int getMember_no() {
		return member_no;
	}

	public void setMember_no(int member_no) {
		this.member_no = member_no;
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

	public int getPage_unit() {
		return page_unit;
	}

	public void setPage_unit(int page_unit) {
		this.page_unit = page_unit;
	}

	public int getPage_size() {
		return page_size;
	}

	public void setPage_size(int page_size) {
		this.page_size = page_size;
	}

	public int getWaiting_cnt() {
		return waiting_cnt;
	}

	public void setWaiting_cnt(int waiting_cnt) {
		this.waiting_cnt = waiting_cnt;
	}

	public String getTtsYn() {
		return ttsYn;
	}

	public void setTtsYn(String ttsYn) {
		this.ttsYn = ttsYn;
	}

	public String getIp() {
		return ip;
	}

	public void setIp(String ip) {
		this.ip = ip;
	}

	public int getSeq_no2() {
		return seq_no2;
	}

	public void setSeq_no2(int seq_no2) {
		this.seq_no2 = seq_no2;
	}
	public Date getInput_date2() {
		return input_date2;
	}
	public void setInput_date2(Date input_date2) {
		this.input_date2 = input_date2;
	}
	public Date getCng_date2() {
		return cng_date2;
	}
	public void setCng_date2(Date cng_date2) {
		this.cng_date2 = cng_date2;
	}

	public String getCd_cust() {
		return cd_cust;
	}

	public void setCd_cust(String cd_cust) {
		this.cd_cust = cd_cust;
	}

	public int getAge() {
		return age;
	}

	public void setAge(int age) {
		this.age = age;
	}

	public int getRsv_seq() {
		return rsv_seq;
	}

	public void setRsv_seq(int rsv_seq) {
		this.rsv_seq = rsv_seq;
	}

	public String getCt_telno() {
		return ct_telno;
	}

	public void setCt_telno(String ct_telno) {
		this.ct_telno = ct_telno;
	}

	public String getTimes_fr() {
		return times_fr;
	}

	public void setTimes_fr(String times_fr) {
		this.times_fr = times_fr;
	}

	public String getReturnTime() {
		return returnTime;
	}

	public void setReturnTime(String returnTime) {
		this.returnTime = returnTime;
	}

	public String getTts_01() {
		return tts_01;
	}

	public void setTts_01(String tts_01) {
		this.tts_01 = tts_01;
	}

	public String getTts_02() {
		return tts_02;
	}

	public void setTts_02(String tts_02) {
		this.tts_02 = tts_02;
	}

	public String getTts_03() {
		return tts_03;
	}

	public void setTts_03(String tts_03) {
		this.tts_03 = tts_03;
	}

	public String getTts_gubun() {
		return tts_gubun;
	}

	public void setTts_gubun(String tts_gubun) {
		this.tts_gubun = tts_gubun;
	}

	public String getSeq_no3() {
		return seq_no3;
	}

	public void setSeq_no3(String seq_no3) {
		this.seq_no3 = seq_no3;
	}

	public String getLogin_id() {
		return login_id;
	}

	public void setLogin_id(String login_id) {
		this.login_id = login_id;
	}
	
	
}
