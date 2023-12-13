package egovframework.kiosk.monitor.mapper;

import java.util.List;

import egovframework.kiosk.customer.vo.Am700tblVO;
import egovframework.kiosk.customer.vo.CustomerVO;
import egovframework.kiosk.customer.vo.PushVO;
import egovframework.kiosk.customer.vo.SimpleDataOptionVO;
import egovframework.kiosk.customer.vo.SimpleDataVO;
import egovframework.kiosk.customer.vo.StrBookingVO;
import egovframework.kiosk.manager.vo.LoginVO;
import egovframework.kiosk.monitor.vo.SimpleMonitorVO;
import egovframework.kiosk.monitor.vo.TtsOptionVO;
import egovframework.rte.psl.dataaccess.mapper.Mapper;

@DavichMapper("SimpleMonitorMapper")
public interface SimpleMonitorMapper {
	SimpleMonitorVO selectSimpleMonitor(String storeCode) throws Exception;
	int countDavichStrBooking(StrBookingVO strBookingVO) throws Exception;
	List<StrBookingVO> selectStrDavichBookingList(StrBookingVO strBookingVO) throws Exception;
	
	//오늘안경완성자 목록
	List<StrBookingVO> selectDavichStrBookingListComplete(StrBookingVO strBookingVO) throws Exception;
	//TTS 음성 부른사람 있나 확인
	int selectDavichCountStrBookingListTts(StrBookingVO strBookingVO) throws Exception;
		
	//TTS 음성 부른사람 등록
	int insertDavichStrBoonikgTtsList(StrBookingVO strBookingVO) throws Exception;
	
	int insertVisitInfo(StrBookingVO strBookingVO);
	
	String selectDavichCardNo(String mallNoCard) throws Exception;
	
	int selectDavichVisitCount(CustomerVO customerVO) throws Exception;
	
	List<CustomerVO> selectDavichVisitList(CustomerVO customerVO) throws Exception;
	
	int selectDavichCustomerCount(String mobile) throws Exception;
	
	List<CustomerVO> selectDavichCustomerList(String mobile) throws Exception;
	
	int countKvisionStrBooking(StrBookingVO strBookingVO) throws Exception;
	
	List<StrBookingVO> selectKvisionStrBookingListAll(StrBookingVO strBookingVO) throws Exception;
	
	List<StrBookingVO> selectStrDavichBookingMobileList(StrBookingVO strBookingVO) throws Exception;
	
	int updateMallStrBookingFlag(StrBookingVO strBookingVO) throws Exception;
	
	int updateComplete(StrBookingVO strBookingVO) throws Exception;
	
	StrBookingVO selectMallStrBooking(StrBookingVO strBookingVO) throws Exception;
	
	int maxSeqNo(String seq_no) throws Exception;
	
	void insertMallStrBookingList(StrBookingVO strBookingVO) throws Exception;
	
	int updateMallStrBookingTTS_01(StrBookingVO strBookingVO) throws Exception;
	
	int updateMallStrBookingTTS_02(StrBookingVO strBookingVO) throws Exception;
	
	List<StrBookingVO> selectDavichStrBookingListTTS01(StrBookingVO strBookingVO) throws Exception;
	
	List<StrBookingVO> selectDavichStrBookingListTTS02(StrBookingVO strBookingVO) throws Exception;
	
	int selectCountStrBookingListTts01(StrBookingVO strBookingVO) throws Exception;
	
	int selectCountStrBookingListTts02(StrBookingVO strBookingVO) throws Exception;
	
	int selectCountStrBookingListTts02Dates(StrBookingVO strBookingVO) throws Exception;
	
	int deleteStrBookingListTts02(StrBookingVO strBookingVO) throws Exception;
	
	TtsOptionVO selectTtsOption(String str_no) throws Exception;
	
	int selectCountCheck(StrBookingVO strBookingVO) throws Exception;
	
	int countDuplicateChck(StrBookingVO strBookingVO) throws Exception;
	
	String pushInsert(PushVO PushVO) throws Exception;
	
	CustomerVO selectDavichMallNoCard(String cdCust) throws Exception;
	
	Am700tblVO selectAm700tbl(Am700tblVO am700tblVO) throws Exception;
	
	int updateMallStrBookingListStatus(StrBookingVO strBookingVO) throws Exception;
	
	int selectCountStrBookingListTts01Dates(StrBookingVO strBookingVO) throws Exception;
	
	int deleteStrBookingListTts01(StrBookingVO strBookingVO) throws Exception;
	
	List<StrBookingVO> selectDavichStrBookingListTTS04(StrBookingVO strBookingVO) throws Exception;
	
	int selectCountStrBookingListTts04(StrBookingVO strBookingVO) throws Exception;
	
	int selectTestStoreCount(String storeCode) throws Exception;
	
	int deleteStrBookingListTts03(StrBookingVO strBookingVO) throws Exception;
	
	int selectAm030tbl8888 (LoginVO loginVO) throws Exception;
	
	List<SimpleDataVO> selectSimpleData(SimpleDataVO simpleDataVO) throws Exception;
	
	int selectSimpleDataCount(SimpleDataVO simpleDataVO) throws Exception;
	
	int selectAm010tblTestCount(SimpleDataVO simpleDataVO) throws Exception;
	
	SimpleDataOptionVO selectSimpleDataOptionList(SimpleDataOptionVO simpleDataOptionVO) throws Exception;
	
	int selectSimpleDataOptionCount(SimpleDataOptionVO simpleDataOptionVO) throws Exception;
	
	void insertSimpleDataOption(SimpleDataOptionVO simpleDataOptionVO) throws Exception;
	
	int updateSimpleDataOption(SimpleDataOptionVO simpleDataOptionVO) throws Exception;
	
	List<SimpleDataVO> selectSimpleData_test(SimpleDataVO simpleDataVO) throws Exception;
	
	int selectSimpleDataCount_test(SimpleDataVO simpleDataVO) throws Exception;

	//2022 03 08 예약,as,수령 화면 구분자
	List<SimpleDataVO> nullJudg(SimpleDataVO simpleDataVO) throws Exception;
	
}
