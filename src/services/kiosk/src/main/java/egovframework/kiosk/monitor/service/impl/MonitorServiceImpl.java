package egovframework.kiosk.monitor.service.impl;

import java.text.SimpleDateFormat;
import java.util.Date;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import egovframework.kiosk.customer.vo.Am700tblVO;
import egovframework.kiosk.customer.vo.CustomerVO;
import egovframework.kiosk.customer.vo.PushVO;
import egovframework.kiosk.customer.vo.StrBookingVO;
import egovframework.kiosk.monitor.mapper.MonitorMapper;
import egovframework.kiosk.monitor.mapper.SimpleMonitorMapper;
import egovframework.kiosk.monitor.service.MonitorService;
import egovframework.kiosk.monitor.vo.MessageVO;
import egovframework.kiosk.monitor.vo.MonitorVO;
import egovframework.kiosk.monitor.vo.SimpleMonitorVO;
import egovframework.kiosk.monitor.vo.TtsOptionVO;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

@Service("MonitorService")
public class MonitorServiceImpl extends EgovAbstractServiceImpl implements MonitorService{
	private static final Logger LOGGER = LoggerFactory.getLogger(MonitorServiceImpl.class);
	
	@Resource(name="MonitorMapper")
	private MonitorMapper monitorMapper;
	
	@Resource(name="SimpleMonitorMapper")
	private SimpleMonitorMapper simpleMonitorMapper;
	

	@Override
	public int storeCallCheckCnt(MonitorVO monitorVO) throws Exception{
		return monitorMapper.storeCallCheckCnt(monitorVO);
	}
	
	@Override
	public MonitorVO storeCallCheck(String str_code) throws Exception{
		return monitorMapper.storeCallCheck(str_code);
	}
		
	@Override
	public int insertBookingCall(MonitorVO monitorVO) throws Exception{
		return monitorMapper.insertBookingCall(monitorVO);
	}
		
	@Override
	public void updateCallYn(MonitorVO monitorVO) throws Exception{
		monitorMapper.updateCallYn(monitorVO);
	}	
	
	@Override
	public void updateCallTime(MonitorVO monitorVO) throws Exception{
		monitorMapper.updateCallTime(monitorVO);
	}
	

	@Override
	public int selectStrCount(String str_code) throws Exception{
		return monitorMapper.selectStrCount(str_code);
	}

	@Override
	public MessageVO selectBookingMsg(String str_code) throws Exception{
		return monitorMapper.selectBookingMsg(str_code);
	}

	@Override
	public int insertBookingMsg(MessageVO messageVO) throws Exception{
		return monitorMapper.insertBookingMsg(messageVO);
	}

	@Override
	public void updateBookingMsg(MessageVO messageVO) throws Exception{
		monitorMapper.updateBookingMsg(messageVO);
	}
	
	
	@Override
	public SimpleMonitorVO selectSimpleMonitor(String str_code) throws Exception{
		return simpleMonitorMapper.selectSimpleMonitor(str_code);
	}
	
	@Override
	public int insertVisitInfo(StrBookingVO strBookingVO) throws Exception{
		return simpleMonitorMapper.insertVisitInfo(strBookingVO);
	}
	
	@Override
	public void updateMallStrBookingFlag(StrBookingVO strBookingVO) throws Exception{
		SimpleDateFormat transFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		Date to = transFormat.parse(strBookingVO.getDates());
		strBookingVO.setInput_date2(to);
		simpleMonitorMapper.updateMallStrBookingFlag(strBookingVO);
	}
	
	@Override
	public String updateComplete(StrBookingVO strBookingVO) throws Exception{
		SimpleDateFormat transFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		Date to = transFormat.parse(strBookingVO.getDates());
		strBookingVO.setInput_date2(to);
		simpleMonitorMapper.updateComplete(strBookingVO);
		
		simpleMonitorMapper.deleteStrBookingListTts03(strBookingVO);
		
		Am700tblVO am700tblVO = new Am700tblVO();
		am700tblVO.setCtr_code("003");
		am700tblVO.setCtr_id("341");
		Am700tblVO ment = simpleMonitorMapper.selectAm700tbl(am700tblVO);
		return pushInsert(strBookingVO.getCd_cust(),ment.getCtr_desc(),strBookingVO.getStr_code());
	}
	
	/*@Override
	public String insertMallStrBookingList(StrBookingVO strBookingVO) throws Exception{
		String result = "";
		SimpleDateFormat transFormat = new SimpleDateFormat("yyyy-MM-dd");
		//Date to = transFormat.parse(strBookingVO.getDates());
		//strBookingVO.setInput_date2(to);
		
		//StrBookingVO data = simpleMonitorMapper.selectMallStrBooking(strBookingVO);
		//int seq_no = simpleMonitorMapper.maxSeqNo(data.getStr_code());
		//data.setSeq_no2(seq_no);
		//data.setReturnTime("1234");
		//int checkData = 0;
		//checkData = simpleMonitorMapper.selectCountCheck(data);
		//이미 데이터가 있으면 예약호출시 입력되지 않게 변경
		//if(checkData == 0){
		//	simpleMonitorMapper.insertMallStrBookingList(data);
		//	if(!"1234".equals(data.getReturnTime())){
		//		StrBookingVO param = new StrBookingVO();
		//		param.setTimes(data.getReturnTime());
		//		param.setInput_date2(data.getInput_date2());
		//		param.setStr_code(data.getStr_code());
		//		param.setStr_code(data.getStr_code());
		//		param.setTts_01("1");
		//		simpleMonitorMapper.updateMallStrBookingTTS_01(param);
		//	}
		//}
		// 상담시작으로 상태값 바꾸고
		//버튼 여러번 누르게 해야함.
		//StrBookingVO data = simpleMonitorMapper.selectMallStrBooking(strBookingVO);
		StrBookingVO data = strBookingVO;
		StrBookingVO param = new StrBookingVO();
		param.setTimes(data.getTimes());
		param.setInput_date2(data.getInput_date2());
		param.setStr_code(data.getStr_code());
		param.setTts_01("1");
		simpleMonitorMapper.updateMallStrBookingTTS_01(param);
		//strBookingVO.setStatus("2");
		//simpleMonitorMapper.updateMallStrBookingListStatus(strBookingVO);
		Am700tblVO am700tblVO = new Am700tblVO();
		am700tblVO.setCtr_code("001");
		am700tblVO.setCtr_id("341");
		Am700tblVO ment = simpleMonitorMapper.selectAm700tbl(am700tblVO);
		result = pushInsert(strBookingVO.getCd_cust(),ment.getCtr_desc(),strBookingVO.getStr_code());
		return result;
	}*/
	
	@Override
	public String insertMallStrBookingList(StrBookingVO strBookingVO) throws Exception{
		String result = "";
		SimpleDateFormat transFormat = new SimpleDateFormat("yyyy-MM-dd");
		// 상담시작으로 상태값 바꾸고
		//버튼 여러번 누르게 해야함.
		StrBookingVO data = strBookingVO;
		StrBookingVO param = new StrBookingVO();
		param.setTimes(data.getTimes());
		param.setInput_date2(data.getInput_date2());
		param.setStr_code(data.getStr_code());
		param.setTts_02("1");
		simpleMonitorMapper.updateMallStrBookingTTS_02(param);
		Am700tblVO am700tblVO = new Am700tblVO();
		am700tblVO.setCtr_code("001");
		am700tblVO.setCtr_id("341");
		Am700tblVO ment = simpleMonitorMapper.selectAm700tbl(am700tblVO);
		result = pushInsert(strBookingVO.getCd_cust(),ment.getCtr_desc(),strBookingVO.getStr_code());
		return result;
	}
	
	@Override
	public TtsOptionVO selectTtsOption(String str_no) throws Exception{
		TtsOptionVO ttsOptionVO = new TtsOptionVO();
		ttsOptionVO = simpleMonitorMapper.selectTtsOption(str_no);
		return ttsOptionVO;
	}
	
	@Override
	public String pushInsert(String cdCust,String content,String strCode) throws Exception{
		System.out.println("@@@@@@@@@@@");
		System.out.println(cdCust);
		System.out.println(content);
		System.out.println(strCode);
		String result = "";
		PushVO pushVO =  new PushVO();
		CustomerVO customerVO = new CustomerVO();
		System.out.println("!!!!!!!!");
		System.out.println(cdCust != "" );
		System.out.println(cdCust != null);
		System.out.println("".equals(cdCust));
		System.out.println(cdCust);
		if(!"".equals(cdCust)){
			customerVO = simpleMonitorMapper.selectDavichMallNoCard(cdCust);
		}
		
		if(!customerVO.getMall_no_card().equals(null)){
			pushVO.setMallCardNo(customerVO.getMall_no_card());
			pushVO.setContent(customerVO.getMember_nm()+" "+content);
			pushVO.setStrCode(strCode);
			result = simpleMonitorMapper.pushInsert(pushVO);
			System.out.println("result");
			System.out.println(result);
		}
		return result;
	}
}
