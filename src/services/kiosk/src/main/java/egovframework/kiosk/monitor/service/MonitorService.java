package egovframework.kiosk.monitor.service;

import egovframework.kiosk.customer.vo.StrBookingVO;
import egovframework.kiosk.monitor.vo.MessageVO;
import egovframework.kiosk.monitor.vo.MonitorVO;
import egovframework.kiosk.monitor.vo.SimpleMonitorVO;
import egovframework.kiosk.monitor.vo.TtsOptionVO;

public interface MonitorService {
	int storeCallCheckCnt(MonitorVO monitorVO) throws Exception;
	MonitorVO storeCallCheck(String str_code) throws Exception;
	int insertBookingCall(MonitorVO monitorVO) throws Exception;
	void updateCallYn(MonitorVO monitorVO) throws Exception;
	void updateCallTime(MonitorVO monitorVO) throws Exception;
	
	int selectStrCount(String str_code) throws Exception;
	MessageVO selectBookingMsg(String str_code) throws Exception;
	int insertBookingMsg(MessageVO messageVO) throws Exception;
	void updateBookingMsg(MessageVO messageVO) throws Exception;
	SimpleMonitorVO selectSimpleMonitor(String str_code) throws Exception;
	
	int insertVisitInfo(StrBookingVO strBookingVO) throws Exception;
	
	void updateMallStrBookingFlag(StrBookingVO strBookingVO) throws Exception;
	
	String updateComplete(StrBookingVO strBookingVO) throws Exception;
	
	String insertMallStrBookingList(StrBookingVO strBookingVO) throws Exception;
	
	TtsOptionVO selectTtsOption(String str_no) throws Exception;
	
	String pushInsert(String cdCust,String content,String strCode) throws Exception;
}
