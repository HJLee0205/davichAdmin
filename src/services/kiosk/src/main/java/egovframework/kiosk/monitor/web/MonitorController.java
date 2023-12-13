package egovframework.kiosk.monitor.web;

import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import egovframework.kiosk.customer.service.CustomerService;
import egovframework.kiosk.customer.vo.CustomerVO;
import egovframework.kiosk.customer.vo.SimpleDataOptionVO;
import egovframework.kiosk.customer.vo.SimpleDataVO;
import egovframework.kiosk.customer.vo.StrBookingVO;
import egovframework.kiosk.manager.vo.LoginVO;
import egovframework.kiosk.monitor.service.MonitorService;
import egovframework.kiosk.monitor.vo.MessageVO;
import egovframework.kiosk.monitor.vo.MonitorVO;
import egovframework.kiosk.monitor.vo.SimpleMonitorVO;
import egovframework.kiosk.monitor.vo.TtsOptionVO;
import net.sf.json.JSONObject;

@Controller
public class MonitorController {
	
	@Resource(name = "MonitorService")
	private MonitorService monitorService;
	
	@Resource(name = "CustomerService")
	private CustomerService customerService;
	
	/**
	 * 대기 모니터  페이지
	 * @param CustomerVO
	 * @param request
	 * @param response
	 * @return ModelAndView
	 * @throws Exception
	 */	
	@RequestMapping(value = "/kiosk/monitor.do")
	public ModelAndView monitor(@ModelAttribute("customerVO") CustomerVO customerVO, HttpServletRequest request, HttpServletResponse response) throws Exception{
		ModelAndView mv = new ModelAndView("/kiosk/monitor");	
		
		MonitorVO monitorVO = new MonitorVO();
		monitorVO.setStr_code(customerVO.getStore_no());
		int cnt = monitorService.storeCallCheckCnt(monitorVO);	
		
		if(cnt == 0){
			monitorVO.setCall_yn("N");
			monitorVO.setCall_time(10);
			monitorVO.setAuto_clear("N");
			monitorService.insertBookingCall(monitorVO);
		}else{
			monitorVO = monitorService.storeCallCheck(customerVO.getStore_no());
		}
		
		int cnt1 = monitorService.selectStrCount(customerVO.getStore_no());
		
		MessageVO messageVO = new MessageVO();
		if(cnt1 == 0){
			messageVO.setStr_code(customerVO.getStore_no());
			messageVO.setMsg1("잠시만 기다려주시면 순번대로 빠르게 안내해 드리겠습니다.");
			messageVO.setMsg2("");
			messageVO.setMsg3("");
			messageVO.setMsg4("");
			messageVO.setMsg5("");
			monitorService.insertBookingMsg(messageVO);
		}else{
			messageVO = monitorService.selectBookingMsg(customerVO.getStore_no());
		}
		
		mv.addObject("tot_cnt", "0");
		mv.addObject("n_cnt", "0");
		mv.addObject("y_cnt", "0");
		mv.addObject("monitorVO", monitorVO);
		mv.addObject("messageVO", messageVO);
		mv.addObject("customerVO", customerVO);
		return mv;
	}
	
	/**
	 * 예약자 포함 대기 모니터  페이지
	 * @param CustomerVO
	 * @param request
	 * @param response
	 * @return ModelAndView
	 * @throws Exception
	 */	
	@RequestMapping(value = "/kiosk/booking_monitor.do")
	public ModelAndView booking_monitor(@ModelAttribute("customerVO") CustomerVO customerVO, HttpServletRequest request, HttpServletResponse response) throws Exception{
		ModelAndView mv = new ModelAndView("/kiosk/monitor_booking");	
		
		MonitorVO monitorVO = new MonitorVO();
		monitorVO.setStr_code(customerVO.getStore_no());
		int cnt = monitorService.storeCallCheckCnt(monitorVO);	
		
		if(cnt == 0){
			monitorVO.setCall_yn("N");
			monitorVO.setCall_time(10);
			monitorVO.setAuto_clear("N");
			monitorService.insertBookingCall(monitorVO);
		}else{
			monitorVO = monitorService.storeCallCheck(customerVO.getStore_no());
		}
		
		int cnt1 = monitorService.selectStrCount(customerVO.getStore_no());
		
		MessageVO messageVO = new MessageVO();
		if(cnt1 == 0){
			messageVO.setStr_code(customerVO.getStore_no());
			messageVO.setMsg1("잠시만 기다려주시면 순번대로 빠르게 안내해 드리겠습니다.");
			messageVO.setMsg2("");
			messageVO.setMsg3("");
			messageVO.setMsg4("");
			messageVO.setMsg5("");
			monitorService.insertBookingMsg(messageVO);
		}else{
			messageVO = monitorService.selectBookingMsg(customerVO.getStore_no());
		}
		
		mv.addObject("tot_cnt", "0");
		mv.addObject("n_cnt", "0");
		mv.addObject("y_cnt", "0");
		mv.addObject("monitorVO", monitorVO);
		mv.addObject("messageVO", messageVO);
		mv.addObject("customerVO", customerVO);
		return mv;
	}
	
	/**
	 * 대기 모니터  페이지
	 * @param CustomerVO
	 * @param request
	 * @param response
	 * @return ModelAndView
	 * @throws Exception
	 */	
	@RequestMapping(value = "/kiosk/tts_monitor.do")
	public ModelAndView tts_monitor(@ModelAttribute("customerVO") CustomerVO customerVO, HttpServletRequest request, HttpServletResponse response) throws Exception{
		ModelAndView mv = new ModelAndView("/kiosk/monitor_tts");	
		
		MonitorVO monitorVO = new MonitorVO();
		monitorVO.setStr_code(customerVO.getStore_no());
		int cnt = monitorService.storeCallCheckCnt(monitorVO);	
		MessageVO messageVO = new MessageVO();
		/*if(cnt == 0){
			monitorVO.setCall_yn("N");
			monitorVO.setCall_time(10);
			monitorVO.setAuto_clear("N");
			monitorService.insertBookingCall(monitorVO);
		}else{
			monitorVO = monitorService.storeCallCheck(customerVO.getStore_no());
		}
		
		int cnt1 = monitorService.selectStrCount(customerVO.getStore_no());
		
		MessageVO messageVO = new MessageVO();
		if(cnt1 == 0){
			messageVO.setStr_code(customerVO.getStore_no());
			messageVO.setMsg1("잠시만 기다려주시면 순번대로 빠르게 안내해 드리겠습니다.");
			messageVO.setMsg2("");
			messageVO.setMsg3("");
			messageVO.setMsg4("");
			messageVO.setMsg5("");
			monitorService.insertBookingMsg(messageVO);
		}else{
			messageVO = monitorService.selectBookingMsg(customerVO.getStore_no());
		}*/
		
		mv.addObject("tot_cnt", "0");
		mv.addObject("n_cnt", "0");
		mv.addObject("y_cnt", "0");
		mv.addObject("monitorVO", monitorVO);
		mv.addObject("messageVO", messageVO);
		mv.addObject("customerVO", customerVO);
		return mv;
	}
	
	
	/**
	 * 대기 모니터  페이지 tts 고도화 테스트 작업
	 * @param CustomerVO
	 * @param request
	 * @param response
	 * @return ModelAndView
	 * @throws Exception
	 */	
	@RequestMapping(value = "/kiosk/tts_monitor_test.do")
	public ModelAndView tts_monitor_test(@ModelAttribute("customerVO") CustomerVO customerVO, HttpServletRequest request, HttpServletResponse response) throws Exception{
		ModelAndView mv = new ModelAndView("/kiosk/monitor_tts_test");	
		
		MonitorVO monitorVO = new MonitorVO();
		monitorVO.setStr_code(customerVO.getStore_no());
		int cnt = monitorService.storeCallCheckCnt(monitorVO);	
		MessageVO messageVO = new MessageVO();
		/*if(cnt == 0){
			monitorVO.setCall_yn("N");
			monitorVO.setCall_time(10);
			monitorVO.setAuto_clear("N");
			monitorService.insertBookingCall(monitorVO);
		}else{
			monitorVO = monitorService.storeCallCheck(customerVO.getStore_no());
		}
		
		int cnt1 = monitorService.selectStrCount(customerVO.getStore_no());
		
		MessageVO messageVO = new MessageVO();
		if(cnt1 == 0){
			messageVO.setStr_code(customerVO.getStore_no());
			messageVO.setMsg1("잠시만 기다려주시면 순번대로 빠르게 안내해 드리겠습니다.");
			messageVO.setMsg2("");
			messageVO.setMsg3("");
			messageVO.setMsg4("");
			messageVO.setMsg5("");
			monitorService.insertBookingMsg(messageVO);
		}else{
			messageVO = monitorService.selectBookingMsg(customerVO.getStore_no());
		}*/
		
		mv.addObject("tot_cnt", "0");
		mv.addObject("n_cnt", "0");
		mv.addObject("y_cnt", "0");
		mv.addObject("monitorVO", monitorVO);
		mv.addObject("messageVO", messageVO);
		mv.addObject("customerVO", customerVO);
		return mv;
	}
	
	/**
	 * 호출 업데이트
	 * @param MonitorVO
	 * @param request
	 * @param response
	 * @return void
	 * @throws Exception
	 */	
	@RequestMapping(value = "/kiosk/bookingCall.do")
	public void bookingCall(@ModelAttribute("monitorVO") MonitorVO monitorVO, HttpServletRequest request, HttpServletResponse response) throws Exception{
		response.setContentType("text/xml");
		response.setCharacterEncoding("UTF-8");
		StringBuffer retXML = new StringBuffer(1024);
		retXML.append("<?xml version='1.0' encoding='UTF-8'?>");				
		retXML.append("<items>");
		
		try{
			monitorService.updateCallYn(monitorVO);
			retXML.append("<row>");
			retXML.append("		<rtn>1</rtn>");
			retXML.append("</row>");
		}catch(Exception e){
			e.printStackTrace();
		}
		
		retXML.append("</items>");
		response.getWriter().println(retXML.toString());
	}
	
	/**
	 * 호출 업데이트
	 * @param MonitorVO
	 * @param request
	 * @param response
	 * @return void
	 * @throws Exception
	 */	
	@RequestMapping(value = "/kiosk/bookingCallCheck.do")
	public void bookingCallCheck(@ModelAttribute("monitorVO") MonitorVO monitorVO, HttpServletRequest request, HttpServletResponse response) throws Exception{
		response.setContentType("text/xml");
		response.setCharacterEncoding("UTF-8");
		StringBuffer retXML = new StringBuffer(1024);
		retXML.append("<?xml version='1.0' encoding='UTF-8'?>");				
		retXML.append("<items>");
		
		try{			
			int cnt = monitorService.storeCallCheckCnt(monitorVO);	
			retXML.append("<row>");
			retXML.append("		<cnt>"+cnt+"</cnt>");
			retXML.append("</row>");
			
		}catch(Exception e){
			e.printStackTrace();
		}
		
		retXML.append("</items>");
		response.getWriter().println(retXML.toString());
	}
	
	/**
	 * 호출 업데이트
	 * @param MonitorVO
	 * @param request
	 * @param response
	 * @return void
	 * @throws Exception
	 */	
	@RequestMapping(value = "/kiosk/bookingCallYn.do")
	public void bookingCallYn(@ModelAttribute("monitorVO") MonitorVO monitorVO, HttpServletRequest request, HttpServletResponse response) throws Exception{
		response.setContentType("text/xml");
		response.setCharacterEncoding("UTF-8");
		StringBuffer retXML = new StringBuffer(1024);
		retXML.append("<?xml version='1.0' encoding='UTF-8'?>");				
		retXML.append("<items>");
		
		try{
			monitorService.updateCallYn(monitorVO);
			
		}catch(Exception e){
			e.printStackTrace();
		}
		
		retXML.append("</items>");
		response.getWriter().println(retXML.toString());
	}
	
	/**
	 * 호출 업데이트
	 * @param MonitorVO
	 * @param request
	 * @param response
	 * @return void
	 * @throws Exception
	 */	
	@RequestMapping(value = "/kiosk/bookingCallTimeUpdate.do")
	public void bookingCallTimeUpdate(@ModelAttribute("monitorVO") MonitorVO monitorVO, HttpServletRequest request, HttpServletResponse response) throws Exception{
		response.setContentType("text/xml");
		response.setCharacterEncoding("UTF-8");
		StringBuffer retXML = new StringBuffer(1024);
		retXML.append("<?xml version='1.0' encoding='UTF-8'?>");				
		retXML.append("<items>");
		
		try{
			monitorService.updateCallTime(monitorVO);
			
		}catch(Exception e){
			e.printStackTrace();
		}
		
		retXML.append("</items>");
		response.getWriter().println(retXML.toString());
	}
	
	/**
	 * 안내문구 업데이트
	 * @param MessageVO
	 * @param request
	 * @param response
	 * @return void
	 * @throws Exception
	 */	
	@RequestMapping(value = "/kiosk/bookingMsgUpdate.do")
	public void bookingMsgUpdate(@ModelAttribute("messageVO") MessageVO messageVO, HttpServletRequest request, HttpServletResponse response) throws Exception{
		response.setContentType("text/xml");
		response.setCharacterEncoding("UTF-8");
		StringBuffer retXML = new StringBuffer(1024);
		retXML.append("<?xml version='1.0' encoding='UTF-8'?>");				
		retXML.append("<items>");
		
		try{
			monitorService.updateBookingMsg(messageVO);
			
		}catch(Exception e){
			e.printStackTrace();
		}
		
		retXML.append("</items>");
		response.getWriter().println(retXML.toString());
	}
	
	/**
	 * 대기 모니터  페이지
	 * @param CustomerVO
	 * @param request
	 * @param response
	 * @return ModelAndView
	 * @throws Exception
	 */	
	@RequestMapping(value = "/kiosk/simpleMonitor.do")
	public ModelAndView simpleMonitor(@ModelAttribute("customerVO") CustomerVO customerVO, HttpServletRequest request, HttpServletResponse response) throws Exception{
		ModelAndView mv = new ModelAndView("/kiosk/simpleMonitor");	
		mv.addObject("customerVO", customerVO);
		return mv;
	}
	
	
	@RequestMapping(value = "/kiosk/simpleMonitorData.do")
	@ResponseBody
	public void simpleMonitorData(@ModelAttribute("customerVO") CustomerVO customerVO, HttpServletRequest request, HttpServletResponse response) throws Exception{
		SimpleMonitorVO simpleMonitorVO = new SimpleMonitorVO();
		simpleMonitorVO = monitorService.selectSimpleMonitor(customerVO.getStore_no());
		JSONObject json = new JSONObject();
        json.put("data", simpleMonitorVO);
        PrintWriter out = response.getWriter();
        out.print(json);
	}
	
	@RequestMapping(value = "/kiosk/mobileMonitor.do")
	public ModelAndView mobileMonitor(@ModelAttribute("customerVO") CustomerVO customerVO, HttpServletRequest request, HttpServletResponse response) throws Exception{
		ModelAndView mv = new ModelAndView("/kiosk/mobileMonitor");	
		mv.addObject("customerVO", customerVO);
		HttpSession session = request.getSession();
		LoginVO loginVo = (LoginVO)session.getAttribute("loginVo");
		mv.addObject("loginVo", loginVo);
		TtsOptionVO ttsOptionVO = new TtsOptionVO();
		if(loginVo != null){
			ttsOptionVO = monitorService.selectTtsOption(loginVo.getStrCode());
		}
		
		mv.addObject("ttsOptionVO", ttsOptionVO);
		return mv;
	}
	
	@RequestMapping(value = "/kiosk/updateMallStrBookingFlag.do")
	@ResponseBody
	public void updateMallStrBookingFlag(@ModelAttribute("strBookingVO") StrBookingVO strBookingVO, HttpServletRequest request, HttpServletResponse response) throws Exception{
		response.setContentType("text/xml");
		response.setCharacterEncoding("UTF-8");
		StringBuffer retXML = new StringBuffer(1024);
		retXML.append("<?xml version='1.0' encoding='UTF-8'?>");				
		retXML.append("<items>");
		strBookingVO.setFlag("2");
		monitorService.updateMallStrBookingFlag(strBookingVO);
		retXML.append("</items>");
		response.getWriter().println(retXML.toString());
	}
	
	@RequestMapping(value = "/kiosk/complete.do")
	@ResponseBody
	public void complete(@ModelAttribute("strBookingVO") StrBookingVO strBookingVO, HttpServletRequest request, HttpServletResponse response) throws Exception{
		response.setContentType("text/xml");
		response.setCharacterEncoding("UTF-8");
		StringBuffer retXML = new StringBuffer(1024);
		retXML.append("<?xml version='1.0' encoding='UTF-8'?>");				
		retXML.append("<items>");
		retXML.append("<result>");
		strBookingVO.setStatus("7");
		String result = monitorService.updateComplete(strBookingVO);
		System.out.println("result");
		System.out.println(result);
		retXML.append(result);
		retXML.append("</result>");
		retXML.append("</items>");
		response.getWriter().println(retXML.toString());
	}
	//백업
	/*@RequestMapping(value = "/kiosk/resCall.do")
	@ResponseBody
	public void resCall(@ModelAttribute("strBookingVO") StrBookingVO strBookingVO, HttpServletRequest request, HttpServletResponse response) throws Exception{
		response.setContentType("text/xml");
		response.setCharacterEncoding("UTF-8");
		StringBuffer retXML = new StringBuffer(1024);
		retXML.append("<?xml version='1.0' encoding='UTF-8'?>");				
		retXML.append("<items>");
		retXML.append("<result>");
		//String result = monitorService.insertMallStrBookingList(strBookingVO);
		String result = "";
		//해당 tts가 있는지 확인 작업
			if(customerService.selectCountStrBookingListTts01Dates(strBookingVO) > 0){
				//있으면 tts delete
				result = customerService.deleteStrBookingListTts01(strBookingVO);
			}else{
				//없으면 list 에서 update
				strBookingVO.setTts_01("1");
				result = monitorService.insertMallStrBookingList(strBookingVO);
				//result = customerService.updateMallStrBookingTTS_01(strBookingVO);
			}
		System.out.println("result");
		System.out.println(result);
		retXML.append(result);
		retXML.append("</result>");
		retXML.append("</items>");
		response.getWriter().println(retXML.toString());
	}*/
	
	@RequestMapping(value = "/kiosk/resCall.do")
	@ResponseBody
	public void resCall(@ModelAttribute("strBookingVO") StrBookingVO strBookingVO, HttpServletRequest request, HttpServletResponse response) throws Exception{
		response.setContentType("text/xml");
		response.setCharacterEncoding("UTF-8");
		StringBuffer retXML = new StringBuffer(1024);
		retXML.append("<?xml version='1.0' encoding='UTF-8'?>");				
		retXML.append("<items>");
		retXML.append("<result>");
		//String result = monitorService.insertMallStrBookingList(strBookingVO);
		String result = "";
		//해당 tts가 있는지 확인 작업 (에약호출도 그냥 호출이랑 통합 로직은 조금 변경함)
			if(customerService.selectCountStrBookingListTts02Dates(strBookingVO) > 0){
				//있으면 tts delete
				result = customerService.deleteStrBookingListTts01(strBookingVO);
			}else{
				//없으면 list 에서 update
				strBookingVO.setTts_01("1");
				result = monitorService.insertMallStrBookingList(strBookingVO);
				//result = customerService.updateMallStrBookingTTS_01(strBookingVO);
			}
		System.out.println("result");
		System.out.println(result);
		retXML.append(result);
		retXML.append("</result>");
		retXML.append("</items>");
		response.getWriter().println(retXML.toString());
	}
	
	@RequestMapping(value = "/kiosk/simpleCall.do")
	@ResponseBody
	public void simpleCall(@ModelAttribute("strBookingVO") StrBookingVO strBookingVO, HttpServletRequest request, HttpServletResponse response) throws Exception{
		response.setContentType("text/xml");
		response.setCharacterEncoding("UTF-8");
		StringBuffer retXML = new StringBuffer(1024);
		retXML.append("<?xml version='1.0' encoding='UTF-8'?>");				
		retXML.append("<items>");
		String result = "";
		//해당 tts가 있는지 확인 작업
		if(customerService.selectCountStrBookingListTts02Dates(strBookingVO) > 0){
			//있으면 tts delete
			result = customerService.deleteStrBookingListTts02(strBookingVO);
		}else{
			//없으면 list 에서 update
			strBookingVO.setTts_02("1");
			result = customerService.updateMallStrBookingTTS_02(strBookingVO);
		}
		System.out.println("result");
		System.out.println(result);
		retXML.append(result);
		retXML.append("</result>");
		retXML.append("</items>");
		response.getWriter().println(retXML.toString());
	}
	
	
	@RequestMapping(value = "/kiosk/simpleDataMonitor.do")
	public ModelAndView simpleDataMonitor(@ModelAttribute("customerVO") CustomerVO customerVO, HttpServletRequest request, HttpServletResponse response) throws Exception{
		ModelAndView mv = new ModelAndView("/kiosk/simpleDataMonitor");	
		mv.addObject("customerVO", customerVO);
		SimpleDataVO simpleDataVO = new SimpleDataVO();
		SimpleDataOptionVO simpleDataOptionVO = new SimpleDataOptionVO();
		simpleDataOptionVO.setLogin_id(customerVO.getLogin_id());
		simpleDataOptionVO.setStr_code(customerVO.getStore_no());
		int page_unit = 0;
		//데이터 저장하기
		int count = customerService.selectSimpleDataOptionCount(simpleDataOptionVO);
		if(count > 0){
			simpleDataOptionVO = customerService.selectSimpleDataOptionList(simpleDataOptionVO);
			page_unit = simpleDataOptionVO.getUnit_size(); 
		}else{
			page_unit = 5;
		}
		simpleDataVO.setPage_unit(page_unit);
		mv.addObject("simpleDataVO", simpleDataVO);
		return mv;
	}
	
	@RequestMapping(value = "/kiosk/simpleDataOption.do")
	public ModelAndView simpleDataOption(@ModelAttribute("customerVO") CustomerVO customerVO, HttpServletRequest request, HttpServletResponse response) throws Exception{
		ModelAndView mv = new ModelAndView("/kiosk/simpleDataOption");	
		mv.addObject("customerVO", customerVO);
		SimpleDataVO simpleDataVO = new SimpleDataVO();
		SimpleDataOptionVO simpleDataOptionVO = new SimpleDataOptionVO();
		simpleDataOptionVO.setLogin_id(customerVO.getLogin_id());
		simpleDataOptionVO.setStr_code(customerVO.getStore_no());
		int page_unit = 0;
		//데이터 저장하기
		int count = customerService.selectSimpleDataOptionCount(simpleDataOptionVO);
		if(count > 0){
			simpleDataOptionVO = customerService.selectSimpleDataOptionList(simpleDataOptionVO);
			page_unit = simpleDataOptionVO.getUnit_size(); 
		}else{
			page_unit = 5;
		}
		simpleDataVO.setPage_unit(page_unit);
		mv.addObject("simpleDataVO", simpleDataVO);
		return mv;
	}
	
	@RequestMapping(value = "/kiosk/simpleDataMonitor_test.do")
	public ModelAndView simpleDataMonitor_test(@ModelAttribute("customerVO") CustomerVO customerVO, HttpServletRequest request, HttpServletResponse response) throws Exception{
		ModelAndView mv = new ModelAndView("/kiosk/simpleDataMonitor_test");	
		mv.addObject("customerVO", customerVO);
		SimpleDataVO simpleDataVO = new SimpleDataVO();
		SimpleDataOptionVO simpleDataOptionVO = new SimpleDataOptionVO();
		simpleDataOptionVO.setLogin_id(customerVO.getLogin_id());
		simpleDataOptionVO.setStr_code(customerVO.getStore_no());
		int page_unit = 0;
		//데이터 저장하기
		int count = customerService.selectSimpleDataOptionCount(simpleDataOptionVO);
		if(count > 0){
			simpleDataOptionVO = customerService.selectSimpleDataOptionList(simpleDataOptionVO);
			page_unit = simpleDataOptionVO.getUnit_size(); 
		}else{
			page_unit = 5;
		}
		simpleDataVO.setPage_unit(page_unit);
		mv.addObject("simpleDataVO", simpleDataVO);
		return mv;
	}
	
	@RequestMapping(value = "/kiosk/insertSimpleDataOption.do")
	@ResponseBody
	public void insertSimpleDataOption(@ModelAttribute("simpleDataOptionVO") SimpleDataOptionVO simpleDataOptionVO, HttpServletRequest request, HttpServletResponse response) throws Exception{
		response.setContentType("text/xml");
		response.setCharacterEncoding("UTF-8");
		StringBuffer retXML = new StringBuffer(1024);
		retXML.append("<?xml version='1.0' encoding='UTF-8'?>");				
		retXML.append("<items>");
		String result = "";
		
		try {
			customerService.insertSimpleDataOption(simpleDataOptionVO);
			result = "true";
		} catch (Exception e) {
			result = "false";
		}
		
		retXML.append(result);
		retXML.append("</result>");
		retXML.append("</items>");
		response.getWriter().println(retXML.toString());
	}
	
	@RequestMapping(value = "/kiosk/simpleDataListMonitor.do")
	public void simpleDataListMonitor(@ModelAttribute("simpleDataVO") SimpleDataVO simpleDataVO, HttpServletRequest request, HttpServletResponse response) throws Exception{
		response.setContentType("text/xml");
		response.setCharacterEncoding("UTF-8");
		StringBuffer retXML = new StringBuffer(1024);
		retXML.append("<?xml version='1.0' encoding='UTF-8'?>");				
		retXML.append("<items>");
		
		try{
			retXML.append("<tot_rows>");
			
			SimpleDataVO param = new SimpleDataVO();
			List<SimpleDataVO> result = new ArrayList<SimpleDataVO>();
			SimpleDateFormat sDate = new SimpleDateFormat("yyyyMMdd");
			
			param.setDates(sDate.format(new Date()));
			param.setPurpose(simpleDataVO.getPurpose());
			param.setStr_code(simpleDataVO.getStr_code());;
			
			//
			param.setPage_index(simpleDataVO.getPage_index());
			param.setPage_unit(simpleDataVO.getPage_unit());
			result = customerService.selectSimpleData(param);
			if(result.isEmpty()){
				param.setPage_index(1);
				result = customerService.selectSimpleData(param);
			}
			
			retXML.append("	<page_index>"+ param.getPage_index() +"</page_index>");
			
			int totalCount = customerService.selectSimpleDataCount(param);
			retXML.append("	<total_count>"+ totalCount +"</total_count>");
			
			for(int i=0; i<result.size(); i++){
				SimpleDataVO sbVO = result.get(i);
				retXML.append("<tot_row>");
				retXML.append("	<nm_cust>"+sbVO.getNm_cust()+"</nm_cust>");
				retXML.append("	<book_time>"+sbVO.getBook_time()+"</book_time>");
				retXML.append("	<input_time>"+sbVO.getInput_time()+"</input_time>");
				retXML.append("	<seq_no>"+sbVO.getSeq_no()+"</seq_no>");
				retXML.append("	<status>"+sbVO.getStatus()+"</status>");
				retXML.append("</tot_row>");
			}
			retXML.append("</tot_rows>");
		}catch(Exception e){
			e.printStackTrace();
		}
		retXML.append("</items>");

		//System.out.println(retXML.toString());
		
		response.getWriter().println(retXML.toString());
	}
	
	@RequestMapping(value = "/kiosk/simpleDataListMonitor_test.do")
	public void simpleDataListMonitor_test(@ModelAttribute("simpleDataVO") SimpleDataVO simpleDataVO, HttpServletRequest request, HttpServletResponse response) throws Exception{
		response.setContentType("text/xml");
		response.setCharacterEncoding("UTF-8");
		StringBuffer retXML = new StringBuffer(1024);
		retXML.append("<?xml version='1.0' encoding='UTF-8'?>");				
		retXML.append("<items>");
		
		try{
			retXML.append("<tot_rows>");
			
			SimpleDataVO param = new SimpleDataVO();
			List<SimpleDataVO> result = new ArrayList<SimpleDataVO>();
			SimpleDateFormat sDate = new SimpleDateFormat("yyyyMMdd");
			
			param.setDates(sDate.format(new Date()));
			param.setPurpose(simpleDataVO.getPurpose());
			param.setStr_code(simpleDataVO.getStr_code());;
			
			//
			param.setPage_index(simpleDataVO.getPage_index());
			param.setPage_unit(simpleDataVO.getPage_unit());
			result = customerService.selectSimpleData_test(param);
			
			if(result.isEmpty()){
				param.setPage_index(1);
				result = customerService.selectSimpleData_test(param);
			}
			
			retXML.append("	<page_index>"+ param.getPage_index() +"</page_index>");
			
			int totalCount = customerService.selectSimpleDataCount_test(param);
			retXML.append("	<total_count>"+ totalCount +"</total_count>");
			
			for(int i=0; i<result.size(); i++){
				SimpleDataVO sbVO = result.get(i);
				retXML.append("<tot_row>");
				retXML.append("	<nm_cust>"+sbVO.getNm_cust()+"</nm_cust>");
				retXML.append("	<book_time>"+sbVO.getBook_time()+"</book_time>");
				retXML.append("	<input_time>"+sbVO.getInput_time()+"</input_time>");
				retXML.append("	<seq_no>"+sbVO.getSeq_no()+"</seq_no>");
				retXML.append("	<status>"+sbVO.getStatus()+"</status>");
				retXML.append("</tot_row>");
			}
			retXML.append("</tot_rows>");
		}catch(Exception e){
			e.printStackTrace();
		}
		retXML.append("</items>");

		//System.out.println(retXML.toString());
		
		response.getWriter().println(retXML.toString());
	}
	
	
	@RequestMapping(value = "/kiosk/selectAm010tblTestCount.do")
	@ResponseBody
	public void selectAm010tblTestCount(@ModelAttribute("simpleDataVO") SimpleDataVO simpleDataVO, HttpServletRequest request, HttpServletResponse response) throws Exception{
		int count = customerService.selectAm010tblTestCount(simpleDataVO);
		JSONObject json = new JSONObject();
        json.put("count", count);
        PrintWriter out = response.getWriter();
        out.print(json);
	}
	
	@RequestMapping(value = "/kiosk/nullJudg.do", method=RequestMethod.POST)
	@ResponseBody
	public void nullJudg(@ModelAttribute("simpleDataVO") SimpleDataVO simpleDataVO,HttpServletRequest request, HttpServletResponse response , Model model) throws Exception{

		response.setContentType("text/xml");
		response.setCharacterEncoding("UTF-8");
		StringBuffer retXML = new StringBuffer(1024);
		retXML.append("<?xml version='1.0' encoding='UTF-8'?>");				
		retXML.append("<items>");
		
		try{
			retXML.append("<tot_rows>");
			
			SimpleDataVO param = new SimpleDataVO();
			List<SimpleDataVO> result = new ArrayList<SimpleDataVO>();
			SimpleDateFormat sDate = new SimpleDateFormat("yyyyMMdd");
			
			param.setDates(sDate.format(new Date()));
			param.setStr_code(simpleDataVO.getStr_code());;
			
			//
			
			result = customerService.nullJudg(param);

			if(result.isEmpty()){
				param.setPage_index(1);
				result = customerService.nullJudg(param);
			}
			
			retXML.append("	<page_index>"+ param.getPage_index() +"</page_index>");
			
			
			for(int i=0; i<result.size(); i++){
				SimpleDataVO sbVO = result.get(i);
				retXML.append("<tot_row>");
				retXML.append("	<seq_no>"+sbVO.getSeq_no()+"</seq_no>");
				retXML.append("</tot_row>");
			}
			retXML.append("</tot_rows>");
		}catch(Exception e){
			e.printStackTrace();
		}
		retXML.append("</items>");

		//System.out.println(retXML.toString());
		
		response.getWriter().println(retXML.toString());
        
	}

	
}

