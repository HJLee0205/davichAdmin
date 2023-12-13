package egovframework.kiosk.monitor.mapper;

import egovframework.kiosk.monitor.vo.MessageVO;
import egovframework.kiosk.monitor.vo.MonitorVO;
import egovframework.kiosk.monitor.vo.SimpleMonitorVO;
import egovframework.rte.psl.dataaccess.mapper.Mapper;

@Mapper("MonitorMapper")
public interface MonitorMapper {
	//모니터(현황판) 직원호출 카운트
	int storeCallCheckCnt(MonitorVO monitorVO) throws Exception;
	//모니터(현황판) 직원호출 정보
	MonitorVO storeCallCheck(String str_code) throws Exception;
	//직원호출 등록
	int insertBookingCall(MonitorVO monitorVO) throws Exception;
	//직원호출 유무수정
	void updateCallYn(MonitorVO monitorVO) throws Exception;
	//모니터(현황판)직원호출 깜박이 시간
	void updateCallTime(MonitorVO monitorVO) throws Exception;
	
	//안내 문구 카운터
	int selectStrCount(String str_code) throws Exception;
	//안내문구 정보
	MessageVO selectBookingMsg(String str_code) throws Exception;
	//안내문구 등록
	int insertBookingMsg(MessageVO messageVO) throws Exception;
	//안내문구 수정
	void updateBookingMsg(MessageVO messageVO) throws Exception;
	
	SimpleMonitorVO selectSimpleMonitor() throws Exception;
}
