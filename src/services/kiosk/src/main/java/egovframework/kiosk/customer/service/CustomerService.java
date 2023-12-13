package egovframework.kiosk.customer.service;

import java.util.List;

import egovframework.kiosk.customer.vo.CustomerVO;
import egovframework.kiosk.customer.vo.MemberVO;
import egovframework.kiosk.customer.vo.SimpleDataOptionVO;
import egovframework.kiosk.customer.vo.SimpleDataVO;
import egovframework.kiosk.customer.vo.StrBookingVO;

public interface CustomerService {
	int selectVisitCount(CustomerVO customerVO) throws Exception;
	List<CustomerVO> selectVisitList(CustomerVO customerVO) throws Exception;
	List<CustomerVO> selectNoVisitList(CustomerVO customerVO) throws Exception;
	
	int selectMemberCount(CustomerVO customerVO) throws Exception;
	List<MemberVO> selectMemberList(CustomerVO customerVO) throws Exception;
	int insertStrBoonikg(StrBookingVO strBookingVO) throws Exception;
	void updateVisitRsvYN(StrBookingVO strBookingVO) throws Exception;
	int countStrBooking(StrBookingVO strBookingVO) throws Exception;
	List<StrBookingVO> selectStrBookingList(StrBookingVO strBookingVO) throws Exception;
	List<StrBookingVO> selectStrBookingListAll(StrBookingVO strBookingVO) throws Exception;
	void updateStrBookingFlag(StrBookingVO strBookingVO) throws Exception; 
	List<StrBookingVO> selectStrBookingListComplete(StrBookingVO strBookingVO) throws Exception;
	int selectCountStrBookingListTts(StrBookingVO strBookingVO) throws Exception;
	int insertStrBoonikgTtsList(StrBookingVO strBookingVO) throws Exception;
	String selectTcMemberCardNo(int member_no) throws Exception;
	String selectDavichCardNo(String member_no) throws Exception;
	
	int selectDavichVisitCount(CustomerVO customerVO) throws Exception;
	List<CustomerVO> selectDavichVisitList(CustomerVO customerVO) throws Exception;
	int selectDavichCustomerCount(String mobile) throws Exception;
	int selectNoMemberCount(CustomerVO customerVO) throws Exception;
	List<CustomerVO> selectDavichCustomerList(String mobile) throws Exception;
	List<MemberVO> selectNoMemberList(CustomerVO customerVO) throws Exception;
	List<StrBookingVO> selectDavichStrBookingListTTS01(StrBookingVO strBookingVO) throws Exception;
	List<StrBookingVO> selectDavichStrBookingListTTS02(StrBookingVO strBookingVO) throws Exception;
	int selectCountStrBookingListTts01(StrBookingVO strBookingVO) throws Exception;
	int selectCountStrBookingListTts02(StrBookingVO strBookingVO) throws Exception;
	int selectCountStrBookingListTts02Dates(StrBookingVO strBookingVO) throws Exception;
	String deleteStrBookingListTts02(StrBookingVO strBookingVO) throws Exception;
	String updateMallStrBookingTTS_02(StrBookingVO strBookingVO) throws Exception;
	int countDuplicateChck(StrBookingVO strBookingVO) throws Exception;
	int selectCountStrBookingListTts01Dates(StrBookingVO strBookingVO) throws Exception;
	String deleteStrBookingListTts01(StrBookingVO strBookingVO) throws Exception;
	
	List<StrBookingVO> selectDavichStrBookingListTTS04(StrBookingVO strBookingVO) throws Exception;
	int selectCountStrBookingListTts04(StrBookingVO strBookingVO) throws Exception;
	
	int selectTestStoreCount(String storeCode) throws Exception;
	
	List<SimpleDataVO> selectSimpleData(SimpleDataVO simpleDataVO) throws Exception;
	
	int selectSimpleDataCount(SimpleDataVO simpleDataVO) throws Exception;
	
	int selectAm010tblTestCount(SimpleDataVO simpleDataVO) throws Exception;
	
	SimpleDataOptionVO selectSimpleDataOptionList(SimpleDataOptionVO simpleDataOptionVO) throws Exception;
	
	int selectSimpleDataOptionCount(SimpleDataOptionVO simpleDataOptionVO) throws Exception;
	
	void insertSimpleDataOption(SimpleDataOptionVO simpleDataOptionVO) throws Exception;
	
	List<SimpleDataVO> selectSimpleData_test(SimpleDataVO simpleDataVO) throws Exception;
	
	int selectSimpleDataCount_test(SimpleDataVO simpleDataVO) throws Exception;
	
	//2022 03 08 예약,as,수령 화면 구분자
	List<SimpleDataVO> nullJudg(SimpleDataVO simpleDataVO) throws Exception;
}
