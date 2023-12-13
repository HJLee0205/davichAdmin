package egovframework.kiosk.customer.web;

import java.net.InetAddress;
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

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import egovframework.kiosk.customer.service.CustomerDavichService;
import egovframework.kiosk.customer.service.CustomerService;
import egovframework.kiosk.customer.vo.CustomerVO;
import egovframework.kiosk.customer.vo.MemberVO;
import egovframework.kiosk.customer.vo.StrBookingVO;
import egovframework.kiosk.manager.vo.LoginVO;
import egovframework.kiosk.monitor.service.MonitorService;
import egovframework.kiosk.util.ClientUtils;
import egovframework.kiosk.util.CryptoUtil;
import egovframework.kiosk.util.InterfaceUtil;
import egovframework.rte.fdl.property.EgovPropertyService;

@Controller
public class CustomerController {
	@Resource(name = "propertiesService")
	private EgovPropertyService propertiesService;
	
	@Resource(name = "CustomerService")
	private CustomerService customerService;
	
	@Resource(name = "CustomerDavichService")
	private CustomerDavichService customerDavichService;
	
	@Resource(name = "MonitorService")
	private MonitorService monitorService;
	
	
	/**
	 * 고객 조회
	 * @param request
	 * @return ModelAndView
	 * @throws Exception
	 */	
	@RequestMapping(value = "/kiosk/customerSearch.do")
	public ModelAndView customerSearch(HttpServletRequest request) throws Exception{
		ModelAndView mv = new ModelAndView("/kiosk/customer/customer_search");
		
		return mv;
	}
	
	/**
	 * 고객 검색 Count
	 * @param CustomerVO
	 * @param request
	 * @param response
	 * @return void
	 * @throws Exception
	 */	
	@RequestMapping(value = "/kiosk/customerCheckCount.do")
	public void customerCheckCount(@ModelAttribute("customerVO") CustomerVO customerVO, HttpServletRequest request, HttpServletResponse response) throws Exception{
		
		response.setContentType("text/xml");
		response.setCharacterEncoding("UTF-8");
		StringBuffer retXML = new StringBuffer(1024);
		retXML.append("<?xml version='1.0' encoding='UTF-8'?>");				
		retXML.append("<items>");
		
		
		GregorianCalendar cal = new GregorianCalendar();		
		String today = Integer.toString(cal.get(Calendar.YEAR)) + "-" + 
				   (Integer.toString(cal.get(Calendar.MONTH)+1).length() == 1 ? "0" + Integer.toString(cal.get(Calendar.MONTH)+1) : Integer.toString(cal.get(Calendar.MONTH)+1) )+ "-" + 
				   (Integer.toString(cal.get(Calendar.DATE)).length() == 1 ? "0" + Integer.toString(cal.get(Calendar.DATE)) : Integer.toString(cal.get(Calendar.DATE)));
		
		try{
		
			CustomerVO cVO = new CustomerVO();
			cVO.setStore_no(customerVO.getStore_no());
			cVO.setRsv_date(today);
			cVO.setCancel_yn("N");
			cVO.setMobile(customerVO.getMobile());		
			//케이비젼과 다비젼 디비 테이블로 변경함
			int visitCnt = customerService.selectDavichVisitCount(cVO);
					
			//방문예약이 있는경우
			if(visitCnt > 0){
				retXML.append("<row>");
				retXML.append("		<count>"+visitCnt+"</count>");
				retXML.append("		<msg>visit</msg>");
				retXML.append("</row>");
			}else{
				int memberCnt = 0;
				
				//다비젼 회원(다비젼만 고객 또는 통합 고객)
				//기존소스(작동안함)
				/*Map<String, Object> param = new HashMap<>();
				param.put("hp", customerVO.getMobile().replaceAll("-", ""));	    	
				Map<String, Object> result = InterfaceUtil.send("IF_MEM_001", param);
				
				if(result.get("result").equals("1")){
					List<?> custList = (List<?>)result.get("custList");
					if(custList.size() > 0){
						memberCnt = custList.size();
					}
				}*/
				String mobile = customerVO.getMobile().replaceAll("-", "");
				memberCnt = customerService.selectDavichCustomerCount(mobile);
				
				//마켓 고객(통합회원 제외)
				//memberCnt = memberCnt + customerService.selectMemberCount(cVO);
				memberCnt = memberCnt + customerService.selectNoMemberCount(cVO);
				if(memberCnt > 0){
					retXML.append("<row>");
					retXML.append("		<count>"+memberCnt+"</count>");
					retXML.append("		<msg>member</msg>");
					retXML.append("</row>");
				}else{
					retXML.append("<row>");
					retXML.append("		<count>"+memberCnt+"</count>");
					retXML.append("		<msg>first</msg>");
					retXML.append("</row>");
				}
			}
		}catch(Exception e){
			retXML.append("<row>");
			retXML.append("		<count>0</count>");
			retXML.append("		<msg>first</msg>");
			retXML.append("</row>");
		}
		
		retXML.append("</items>");
		System.out.println(retXML.toString());
		response.getWriter().println(retXML.toString());
	}
	
	/**
	 * 고객 확인
	 * @param CustomerVO
	 * @param request
	 * @param response
	 * @return ModelAndView
	 * @throws Exception
	 */	
	@RequestMapping(value = "/kiosk/customerReservation.do")
	public ModelAndView customerVisit(@ModelAttribute("customerVO") CustomerVO customerVO, HttpServletRequest request, HttpServletResponse response) throws Exception{
		ModelAndView mv = new ModelAndView("/kiosk/customer/customer_reservation");
		
		//System.out.println(customerVO.getMobile());
		//System.out.println(CryptoUtil.encryptAES(customerVO.getMobile()));
		//System.out.println(CryptoUtil.decryptAES(CryptoUtil.encryptAES(customerVO.getMobile())));
		
		GregorianCalendar cal = new GregorianCalendar();
		String today = Integer.toString(cal.get(Calendar.YEAR)) + "-" + 
				   (Integer.toString(cal.get(Calendar.MONTH)+1).length() == 1 ? "0" + Integer.toString(cal.get(Calendar.MONTH)+1) : Integer.toString(cal.get(Calendar.MONTH)+1) )+ "-" + 
				   (Integer.toString(cal.get(Calendar.DATE)).length() == 1 ? "0" + Integer.toString(cal.get(Calendar.DATE)) : Integer.toString(cal.get(Calendar.DATE)));
		
		CustomerVO cVO = new CustomerVO();
		cVO.setStore_no(customerVO.getStore_no());
		cVO.setSite_no(Integer.parseInt(propertiesService.getString("siteNo")));
		cVO.setRsv_date(today);
		cVO.setCancel_yn("N");
		cVO.setVisit_yn("N");
		cVO.setMobile(customerVO.getMobile());		
		
		//List<CustomerVO> visitList = customerService.selectVisitList(cVO);
		List<CustomerVO> visitList = customerService.selectDavichVisitList(cVO);
		
		if(visitList.size() > 0){
			CustomerVO tmpVO = visitList.get(0);
			customerVO.setMember_nm(egovframework.kiosk.util.StringUtil.stringInstar(tmpVO.getMember_nm()));
		}			
		
		int visitCnt = visitList.size();
		
		mv.addObject("visitCnt", visitCnt);
		mv.addObject("customerVO", customerVO);
		return mv;
	}
	
	/**
	 * 고객 확인
	 * @param CustomerVO
	 * @param request
	 * @param response
	 * @return ModelAndView
	 * @throws Exception
	 */	
	@RequestMapping(value = "/kiosk/customerRsvList.do")
	public ModelAndView customerRsvList(@ModelAttribute("customerVO") CustomerVO customerVO, HttpServletRequest request, HttpServletResponse response) throws Exception{
		ModelAndView mv = new ModelAndView("/kiosk/customer/customer_rsv_list");
		
		//System.out.println(customerVO.getMobile());
		//System.out.println(CryptoUtil.encryptAES(customerVO.getMobile()));
		//System.out.println(CryptoUtil.decryptAES(CryptoUtil.encryptAES(customerVO.getMobile())));
		
		GregorianCalendar cal = new GregorianCalendar();
		String today = Integer.toString(cal.get(Calendar.YEAR)) + "-" + 
				   (Integer.toString(cal.get(Calendar.MONTH)+1).length() == 1 ? "0" + Integer.toString(cal.get(Calendar.MONTH)+1) : Integer.toString(cal.get(Calendar.MONTH)+1) )+ "-" + 
				   (Integer.toString(cal.get(Calendar.DATE)).length() == 1 ? "0" + Integer.toString(cal.get(Calendar.DATE)) : Integer.toString(cal.get(Calendar.DATE)));
		try{
			CustomerVO cVO = new CustomerVO();
			cVO.setStore_no(customerVO.getStore_no());
			cVO.setSite_no(Integer.parseInt(propertiesService.getString("siteNo")));
			cVO.setRsv_date(today);
			cVO.setCancel_yn("N");
			cVO.setVisit_yn("N");
			cVO.setMobile(customerVO.getMobile());		
			
			List<CustomerVO> visitList = new ArrayList<CustomerVO>();
			//List<CustomerVO> vList = customerService.selectNoVisitList(cVO);
			List<CustomerVO> vList = customerService.selectDavichVisitList(cVO);
			if(vList.size() > 0){
				CustomerVO tmpVO = vList.get(0);
				customerVO.setMember_nm(tmpVO.getMember_nm());
				customerVO.setCd_cust(tmpVO.getCd_cust());
				for(int i=0; i<vList.size(); i++ ){
					tmpVO = vList.get(i);
					/*if(tmpVO.getVisit_purpose_cd() != null && tmpVO.getVisit_purpose_cd().equals("G")){
						tmpVO.setVisit_purpose_nm("추천 안경렌즈");
					}else if(tmpVO.getVisit_purpose_cd() != null && tmpVO.getVisit_purpose_cd().equals("C")){
						tmpVO.setVisit_purpose_nm("추천 컨택트렌즈");
					}*/
					
					visitList.add(tmpVO);
				}
			}
			mv.addObject("visitList", visitList);
		}catch(Exception e){
			e.printStackTrace();
		}
		mv.addObject("customerVO", customerVO);
		return mv;
	}
	
	/**
	 * 고객 확인
	 * @param CustomerVO
	 * @param request
	 * @param response
	 * @return ModelAndView
	 * @throws Exception
	 */	
	@RequestMapping(value = "/kiosk/customerRsvConfirm.do")
	public ModelAndView customerRsvConfirm(@ModelAttribute("customerVO") CustomerVO customerVO, HttpServletRequest request, HttpServletResponse response) throws Exception{
		ModelAndView mv = new ModelAndView("/kiosk/customer/customer_rsv_confirm");
		
		//System.out.println(customerVO.getMobile());
		//System.out.println(CryptoUtil.encryptAES(customerVO.getMobile()));
		//System.out.println(CryptoUtil.decryptAES(CryptoUtil.encryptAES(customerVO.getMobile())));
		
		GregorianCalendar cal = new GregorianCalendar();
		String today = Integer.toString(cal.get(Calendar.YEAR)) + "-" + 
				   (Integer.toString(cal.get(Calendar.MONTH)+1).length() == 1 ? "0" + Integer.toString(cal.get(Calendar.MONTH)+1) : Integer.toString(cal.get(Calendar.MONTH)+1) )+ "-" + 
				   (Integer.toString(cal.get(Calendar.DATE)).length() == 1 ? "0" + Integer.toString(cal.get(Calendar.DATE)) : Integer.toString(cal.get(Calendar.DATE)));
		
		CustomerVO cVO = new CustomerVO();
		cVO.setStore_no(customerVO.getStore_no());
		cVO.setSite_no(Integer.parseInt(propertiesService.getString("siteNo")));
		cVO.setRsv_date(today);
		cVO.setCancel_yn("N");
		cVO.setVisit_yn("N");
		cVO.setMobile(CryptoUtil.encryptAES(customerVO.getMobile()));		
		
		//List<CustomerVO> visitList = customerService.selectNoVisitList(cVO);
		List<CustomerVO> visitList = customerService.selectDavichVisitList(cVO);
		if(visitList.size() > 0){
			CustomerVO tmpVO = visitList.get(0);
			customerVO.setRsv_no(tmpVO.getRsv_no());
			
			customerVO.setMember_nm(tmpVO.getMember_nm());
			customerVO.setSecret_nm(egovframework.kiosk.util.StringUtil.stringInstar(customerVO.getMember_nm()));			
			customerVO.setRsv_time(tmpVO.getRsv_time());
			customerVO.setReq_matr(tmpVO.getReq_matr());
			customerVO.setVisit_purpose_nm(tmpVO.getVisit_purpose_nm());
			List<CustomerVO> shopData = customerService.selectNoVisitList(cVO);
			if(shopData.size() > 0){
				customerVO.setMember_no(customerService.selectNoVisitList(cVO).get(0).getMember_no());
			}else{
				//우선 없으면 쇼핑몰 기본 등록 정보인 9999로 등록한다.
				customerVO.setMember_no(9999);
			}
			
		}
		//mv.addObject("visitList", visitList);		
		mv.addObject("customerVO", customerVO);
		return mv;
	}
	
	
	/**
	 * 고객 확인
	 * @param CustomerVO
	 * @param request
	 * @param response
	 * @return ModelAndView
	 * @throws Exception
	 */	
	@RequestMapping(value = "/kiosk/customerCheck.do")
	public ModelAndView customerMember(@ModelAttribute("customerVO") CustomerVO customerVO, HttpServletRequest request, HttpServletResponse response) throws Exception{
		ModelAndView mv = new ModelAndView("/kiosk/customer/customer_check");
		
		
		try{
			List<CustomerVO> searchList = new ArrayList<CustomerVO>();
			
			//오프라인회원
			//다비젼 회원(다비젼만 고객 또는 통합 고객)
			searchList = customerService.selectDavichCustomerList(customerVO.getMobile().replaceAll("-", ""));
			
			
			//온라인회원
			CustomerVO cVO = new CustomerVO();
			cVO.setSite_no(Integer.parseInt(propertiesService.getString("siteNo")));
			cVO.setMobile(CryptoUtil.encryptAES(customerVO.getMobile()));					
			List<MemberVO> memberList = new ArrayList<MemberVO>();
			
			memberList = customerService.selectNoMemberList(cVO); 
			
			if(!memberList.isEmpty()){
				for(int i=0; i<memberList.size(); i++){
					MemberVO mVO = memberList.get(i);
					
					CustomerVO ccVO = new CustomerVO();
					ccVO.setMember_no(mVO.getMember_no());
					ccVO.setMember_nm(CryptoUtil.decryptAES(mVO.getMember_nm()));
					ccVO.setSecret_nm(egovframework.kiosk.util.StringUtil.stringInstar(ccVO.getMember_nm()));
					ccVO.setRecent_str_name("다비치마켓");
					ccVO.setCd_cust(null);
					ccVO.setMall_no_card(null);
					ccVO.setCustomerGubun("마켓회원");
					searchList.add(ccVO);					
				}
			}

			mv.addObject("tot_cnt", searchList.size());
			mv.addObject("searchList", searchList);
		}catch(Exception e){
			e.printStackTrace();
		}		
		
		mv.addObject("customerVO", customerVO);
		return mv;
	}
	
	/**
	 * 고객 확인
	 * @param CustomerVO
	 * @param request
	 * @param response
	 * @return ModelAndView
	 * @throws Exception
	 */	
	@RequestMapping(value = "/kiosk/customerFirst.do")
	public ModelAndView customerFirst(@ModelAttribute("customerVO") CustomerVO customerVO, HttpServletRequest request, HttpServletResponse response) throws Exception{
		ModelAndView mv = new ModelAndView("/kiosk/customer/customer_first");
				
		mv.addObject("customerVO", customerVO);
		return mv;
	}
	
	/**
	 * 고객 검색 Count
	 * @param StrBookingVO
	 * @param request
	 * @param response
	 * @return void
	 * @throws Exception
	 */	
	@RequestMapping(value = "/kiosk/customerStrBooking.do")
	public void customerStrBooking(@ModelAttribute("strBookingVO") StrBookingVO strBookingVO, HttpServletRequest request, HttpServletResponse response) throws Exception{
		
		response.setContentType("text/xml");
		response.setCharacterEncoding("UTF-8");
		StringBuffer retXML = new StringBuffer(1024);
		retXML.append("<?xml version='1.0' encoding='UTF-8'?>");				
		retXML.append("<items>");
		
		
		GregorianCalendar cal = new GregorianCalendar();		
		String today = Integer.toString(cal.get(Calendar.YEAR)) +  
				   (Integer.toString(cal.get(Calendar.MONTH)+1).length() == 1 ? "0" + Integer.toString(cal.get(Calendar.MONTH)+1) : Integer.toString(cal.get(Calendar.MONTH)+1) )+  
				   (Integer.toString(cal.get(Calendar.DATE)).length() == 1 ? "0" + Integer.toString(cal.get(Calendar.DATE)) : Integer.toString(cal.get(Calendar.DATE)));
		
		String nowTime = Integer.toString(cal.get(Calendar.HOUR_OF_DAY)) + 
				   (Integer.toString(cal.get(Calendar.MINUTE)).length() == 1 ? "0" + Integer.toString(cal.get(Calendar.MINUTE)) : Integer.toString(cal.get(Calendar.MINUTE))) +
				   (Integer.toString(cal.get(Calendar.SECOND)).length() == 1 ? "0" + Integer.toString(cal.get(Calendar.SECOND)) : Integer.toString(cal.get(Calendar.SECOND)));
		
		//System.out.println("=======================");
		//System.out.println(nowTime);
		//System.out.println("=======================");
		
		try{		
			strBookingVO.setTimes(nowTime);
			int rtn = customerService.insertStrBoonikg(strBookingVO);
						
			if(rtn > 0){
				//방문예약이 있는경우
				if(strBookingVO.getBook_yn().equals("Y")){
					strBookingVO.setVisit_yn("Y");
					customerService.updateVisitRsvYN(strBookingVO);
				}
				retXML.append("<row>");
				retXML.append("		<rtn>"+rtn+"</rtn>");
				retXML.append("</row>");
			}else{
				retXML.append("<row>");
				retXML.append("		<rtn>"+rtn+"</rtn>");
				retXML.append("</row>");
			}
			
			//다비전에 예약정보 전달(IF_VST_002)
			/*Map<String, Object> param = new HashMap<>();
			param.put("dates", today);	    	
			param.put("strCode", strBookingVO.getStr_code());
			param.put("visitTime", nowTime);
			param.put("custName", strBookingVO.getNm_cust());
			param.put("hp", strBookingVO.getHandphone().replaceAll("-", ""));
			param.put("age", 0);
			param.put("purpose", strBookingVO.getPurpose());
			param.put("bookYn", strBookingVO.getBook_yn());
			param.put("bookTime", strBookingVO.getBook_time());
			
			Map<String, Object> result = InterfaceUtil.send("IF_VST_002", param);*/
			strBookingVO.setDates(today);
			strBookingVO.setTimes(nowTime);
			strBookingVO.setTimes(nowTime);			
			strBookingVO.setNm_cust(strBookingVO.getNm_cust());
			strBookingVO.setFlag("1");
			strBookingVO.setPurpose(strBookingVO.getPurpose());
			strBookingVO.setBook_yn("Y");	
			strBookingVO.setHandphone(strBookingVO.getHandphone().replaceAll("-", ""));
			//인터페이스 안쓰고 insert 처리
			strBookingVO.setSeq_no2(customerService.countStrBooking(strBookingVO)+1);
			monitorService.insertVisitInfo(strBookingVO);
			//System.out.println("==IF_VST_002========================");
			//System.out.println("result : " + result.get("result"));
			//System.out.println("message : " + result.get("message"));
			//System.out.println("==IF_VST_002========================");
			
		}catch(Exception e){
			retXML.append("<row>");
			retXML.append("		<count>0</count>");
			retXML.append("</row>");
		}
		
		retXML.append("</items>");
		response.getWriter().println(retXML.toString());
	}
	
	/**
	 * 제품,서비스선택
	 * @param CustomerVO
	 * @param request
	 * @param response
	 * @return ModelAndView
	 * @throws Exception
	 */	
	@RequestMapping(value = "/kiosk/customerPurpose.do")
	public ModelAndView customerPurpose(@ModelAttribute("customerVO") CustomerVO customerVO, HttpServletRequest request, HttpServletResponse response) throws Exception{
		ModelAndView mv = new ModelAndView("/kiosk/customer/customer_purpose");
				
		mv.addObject("customerVO", customerVO);
		return mv;
	}
	
	/**
	 * 제품,서비스 해당 선택
	 * @param CustomerVO
	 * @param request
	 * @param response
	 * @return ModelAndView
	 * @throws Exception
	 */	
	@RequestMapping(value = "/kiosk/customerPurposeEtc.do")
	public ModelAndView customerPurposeEtc(@ModelAttribute("customerVO") CustomerVO customerVO, HttpServletRequest request, HttpServletResponse response) throws Exception{
		ModelAndView mv = new ModelAndView("/kiosk/customer/customer_purpose_etc");
				
		mv.addObject("customerVO", customerVO);
		return mv;
	}
	
	/**
	 * 처음 고객정보 입력
	 * @param CustomerVO
	 * @param request
	 * @param response
	 * @return ModelAndView
	 * @throws Exception
	 */	
	@RequestMapping(value = "/kiosk/customerFirstInfo.do")
	public ModelAndView customerFirstInfo(@ModelAttribute("customerVO") CustomerVO customerVO, HttpServletRequest request, HttpServletResponse response) throws Exception{
		ModelAndView mv = new ModelAndView("/kiosk/customer/customer_first_info");
				
		mv.addObject("customerVO", customerVO);
		return mv;
	}
	
	/**
	 * 고객정보  접수 완료
	 * @param CustomerVO
	 * @param request
	 * @param response
	 * @return ModelAndView
	 * @throws Exception
	 */	
	@RequestMapping(value = "/kiosk/customerFirstConform.do")
	public ModelAndView customerFirstConform(@ModelAttribute("customerVO") CustomerVO customerVO, HttpServletRequest request, HttpServletResponse response) throws Exception{
		ModelAndView mv = new ModelAndView("/kiosk/customer/customer_first_conform");
		
		
		GregorianCalendar cal = new GregorianCalendar();				
		String today = Integer.toString(cal.get(Calendar.YEAR)) +  
				   (Integer.toString(cal.get(Calendar.MONTH)+1).length() == 1 ? "0" + Integer.toString(cal.get(Calendar.MONTH)+1) : Integer.toString(cal.get(Calendar.MONTH)+1) )+  
				   (Integer.toString(cal.get(Calendar.DATE)).length() == 1 ? "0" + Integer.toString(cal.get(Calendar.DATE)) : Integer.toString(cal.get(Calendar.DATE)));
		
		String nowTime = Integer.toString(cal.get(Calendar.HOUR_OF_DAY)) + 
				   (Integer.toString(cal.get(Calendar.MINUTE)).length() == 1 ? "0" + Integer.toString(cal.get(Calendar.MINUTE)) : Integer.toString(cal.get(Calendar.MINUTE))) +
				   (Integer.toString(cal.get(Calendar.SECOND)).length() == 1 ? "0" + Integer.toString(cal.get(Calendar.SECOND)) : Integer.toString(cal.get(Calendar.SECOND)));
		
		//System.out.println("=======================");
		//System.out.println(nowTime);
		//System.out.println("=======================");
		
		try{
			StrBookingVO strBookingVO = new StrBookingVO();
			strBookingVO.setStr_code(customerVO.getStore_no());
			strBookingVO.setTimes(nowTime);			
			strBookingVO.setNm_cust(customerVO.getMember_nm());
			strBookingVO.setHandphone(customerVO.getMobile());
			strBookingVO.setFlag("1");
			strBookingVO.setPurpose(customerVO.getPurpose());
			strBookingVO.setPurpose_etc(customerVO.getPurpose_etc());
			strBookingVO.setBook_yn("N");	
			//마켓 디비 insert
			int rtn = customerService.insertStrBoonikg(strBookingVO);
			System.out.println("customerVO.getCd_cust()");
			System.out.println(customerVO.getCd_cust());
			strBookingVO.setDates(today);
			strBookingVO.setTimes(nowTime);
			strBookingVO.setCd_cust(customerVO.getCd_cust());
			strBookingVO.setHandphone(strBookingVO.getHandphone().replaceAll("-", ""));
			//인터페이스 안쓰고 insert 처리
			monitorService.insertVisitInfo(strBookingVO);
		}catch(Exception e){
			e.printStackTrace();
		}		
		
		customerVO.setMember_nm(egovframework.kiosk.util.StringUtil.stringInstar(customerVO.getMember_nm()));
		
		mv.addObject("customerVO", customerVO);
		return mv;
	}
	
	/**
	 * 고객대기 목록
	 * @param CustomerVO
	 * @param request
	 * @param response
	 * @return ModelAndView
	 * @throws Exception
	 */	
	@RequestMapping(value = "/kiosk/standBy.do")
	public ModelAndView standBy(@ModelAttribute("customerVO") CustomerVO customerVO, HttpServletRequest request, HttpServletResponse response) throws Exception{
		ModelAndView mv = new ModelAndView("/kiosk/customer/stand_by");
		
		GregorianCalendar cal = new GregorianCalendar();		
		String today = Integer.toString(cal.get(Calendar.YEAR)) + "-" + 
				   (Integer.toString(cal.get(Calendar.MONTH)+1).length() == 1 ? "0" + Integer.toString(cal.get(Calendar.MONTH)+1) : Integer.toString(cal.get(Calendar.MONTH)+1) )+ "-" + 
				   (Integer.toString(cal.get(Calendar.DATE)).length() == 1 ? "0" + Integer.toString(cal.get(Calendar.DATE)) : Integer.toString(cal.get(Calendar.DATE)));
		
		try{
			StrBookingVO strBookingVO = new StrBookingVO();
			strBookingVO.setStr_code(customerVO.getStore_no());
			strBookingVO.setDates(today);
			int tot_cnt = customerService.countStrBooking(strBookingVO);
			
			/*strBookingVO.setBook_yn("N");
			int n_cnt = customerService.countStrBooking(strBookingVO);
			List<StrBookingVO> listN = new ArrayList<StrBookingVO>(); 					
			List<StrBookingVO> nTmp = customerService.selectStrBookingListAll(strBookingVO);
			for(int i=0; i<nTmp.size(); i++){
				StrBookingVO sbVO = nTmp.get(i);
				sbVO.setNm_cust(egovframework.kiosk.util.StringUtil.stringInstar(sbVO.getNm_cust()));				
				listN.add(sbVO);
			}			
			
			strBookingVO.setBook_yn("Y");
			int y_cnt = customerService.countStrBooking(strBookingVO);
			List<StrBookingVO> listY = new ArrayList<StrBookingVO>(); 					
			List<StrBookingVO> yTmp = customerService.selectStrBookingListAll(strBookingVO);
			for(int i=0; i<yTmp.size(); i++){
				StrBookingVO sbVO = yTmp.get(i);
				sbVO.setNm_cust(egovframework.kiosk.util.StringUtil.stringInstar(sbVO.getNm_cust()));				
				listY.add(sbVO);
			}*/
			
			int n_cnt = customerService.countStrBooking(strBookingVO);
			List<StrBookingVO> list = new ArrayList<StrBookingVO>(); 					
			List<StrBookingVO> nTmp = customerService.selectStrBookingListAll(strBookingVO);
			for(int i=0; i<nTmp.size(); i++){
				StrBookingVO sbVO = nTmp.get(i);
				sbVO.setNm_cust(egovframework.kiosk.util.StringUtil.stringInstar(sbVO.getNm_cust()));				
				list.add(sbVO);
			}
			
			mv.addObject("tot_cnt", tot_cnt);
			mv.addObject("n_cnt", n_cnt);
			/*mv.addObject("y_cnt", y_cnt);*/
			/*mv.addObject("listN", listN);
			mv.addObject("listY", listY);*/
			mv.addObject("list", list);
		}catch(Exception e){
			e.printStackTrace();
		}
		mv.addObject("customerVO", customerVO);
		return mv;
	}
	
	/**
	 * 고객대기 목록 XML
	 * @param CustomerVO
	 * @param request
	 * @param response
	 * @return void
	 * @throws Exception
	 */	
	@RequestMapping(value = "/kiosk/standByXml.do")
	public void standByXml(@ModelAttribute("customerVO") CustomerVO customerVO, HttpServletRequest request, HttpServletResponse response) throws Exception{
		response.setContentType("text/xml");
		response.setCharacterEncoding("UTF-8");
		StringBuffer retXML = new StringBuffer(1024);
		retXML.append("<?xml version='1.0' encoding='UTF-8'?>");				
		retXML.append("<items>");
		
		GregorianCalendar cal = new GregorianCalendar();		
		String today = Integer.toString(cal.get(Calendar.YEAR)) + "-" + 
				   (Integer.toString(cal.get(Calendar.MONTH)+1).length() == 1 ? "0" + Integer.toString(cal.get(Calendar.MONTH)+1) : Integer.toString(cal.get(Calendar.MONTH)+1) )+ "-" + 
				   (Integer.toString(cal.get(Calendar.DATE)).length() == 1 ? "0" + Integer.toString(cal.get(Calendar.DATE)) : Integer.toString(cal.get(Calendar.DATE)));
		try{
			StrBookingVO strBookingVO = new StrBookingVO();			
			strBookingVO.setStr_code(customerVO.getStore_no());
			strBookingVO.setDates(today);			
			strBookingVO.setPage_unit(5);

			retXML.append("<tot_rows>");
			int tot_cnt = customerService.countStrBooking(strBookingVO);
			retXML.append("<tot_cnt>"+tot_cnt+"</tot_cnt>");
			
			strBookingVO.setPage_index(customerVO.getTot_page_index());			
			List<StrBookingVO> listTot = customerService.selectStrBookingList(strBookingVO);
			if(listTot.isEmpty()){
				strBookingVO.setPage_index(1);	
				strBookingVO.setTot_page_index(1);
				customerVO.setTot_page_index(1);
				listTot = customerService.selectStrBookingList(strBookingVO);
			}
			retXML.append("<tot_page_index>"+customerVO.getTot_page_index()+"</tot_page_index>");
			for(int i=0; i<listTot.size(); i++){
				StrBookingVO sbVO = listTot.get(i);
				retXML.append("<tot_row>");
				retXML.append("	<tot_num>"+ ((strBookingVO.getPage_unit()*(strBookingVO.getPage_index()-1)) + (i+1)) +"</tot_num>");
				retXML.append("	<nm_cust>"+sbVO.getNm_cust()+"</nm_cust>");
				retXML.append("	<dates>"+sbVO.getDates()+"</dates>");
				retXML.append("	<str_code>"+sbVO.getStr_code()+"</str_code>");
				retXML.append("	<times>"+sbVO.getTimes()+"</times>");
				retXML.append("	<purpose>"+sbVO.getPurpose()+"</purpose>");
				retXML.append("	<book_yn>"+sbVO.getBook_yn()+"</book_yn>");
				retXML.append("	<book_time>"+sbVO.getBook_time()+"</book_time>");
				retXML.append("	<seq_no>"+sbVO.getSeq_no()+"</seq_no>");
				retXML.append("	<status>"+sbVO.getStatus()+"</status>");
				retXML.append("</tot_row>");
			}
			int waiting_cnt;
			if(listTot.size() == 0){
				waiting_cnt = 0;
			}else{
				waiting_cnt = listTot.get(0).getWaiting_cnt();
			}
			retXML.append("	<waiting_cnt>"+waiting_cnt+"</waiting_cnt>");
			retXML.append("</tot_rows>");
		}catch(Exception e){
			e.printStackTrace();
		}
		retXML.append("</items>");
		
		//System.out.println(retXML.toString());
		
		response.getWriter().println(retXML.toString());
	}
	
	/**
	 * 고객대기 목록 XML
	 * @param CustomerVO
	 * @param request
	 * @param response
	 * @return void
	 * @throws Exception
	 */	
	@RequestMapping(value = "/kiosk/standByXml_booking.do")
	public void standByXml_test(@ModelAttribute("customerVO") CustomerVO customerVO, HttpServletRequest request, HttpServletResponse response) throws Exception{
		response.setContentType("text/xml");
		response.setCharacterEncoding("UTF-8");
		StringBuffer retXML = new StringBuffer(1024);
		retXML.append("<?xml version='1.0' encoding='UTF-8'?>");				
		retXML.append("<items>");
		
		GregorianCalendar cal = new GregorianCalendar();		
		String today = Integer.toString(cal.get(Calendar.YEAR)) + "-" + 
				   (Integer.toString(cal.get(Calendar.MONTH)+1).length() == 1 ? "0" + Integer.toString(cal.get(Calendar.MONTH)+1) : Integer.toString(cal.get(Calendar.MONTH)+1) )+ "-" + 
				   (Integer.toString(cal.get(Calendar.DATE)).length() == 1 ? "0" + Integer.toString(cal.get(Calendar.DATE)) : Integer.toString(cal.get(Calendar.DATE)));
		try{
			StrBookingVO strBookingVO = new StrBookingVO();			
			strBookingVO.setStr_code(customerVO.getStore_no());
			strBookingVO.setDates(today);			
			strBookingVO.setPage_unit(5);

			retXML.append("<tot_rows>");
			//int tot_cnt = customerService.countStrBooking(strBookingVO);
			int tot_cnt = customerDavichService.countDavichStrBooking(strBookingVO);
			retXML.append("<tot_cnt>"+tot_cnt+"</tot_cnt>");
			
			strBookingVO.setPage_index(customerVO.getTot_page_index());			
			List<StrBookingVO> listTot = customerDavichService.selectStrDavichBookingList(strBookingVO);
			if(listTot.isEmpty()){
				strBookingVO.setPage_index(1);	
				strBookingVO.setTot_page_index(1);
				customerVO.setTot_page_index(1);
				listTot = customerDavichService.selectStrDavichBookingList(strBookingVO);
			}
			retXML.append("<tot_page_index>"+customerVO.getTot_page_index()+"</tot_page_index>");
			for(int i=0; i<listTot.size(); i++){
				StrBookingVO sbVO = listTot.get(i);
				retXML.append("<tot_row>");
				retXML.append("	<tot_num>"+ ((strBookingVO.getPage_unit()*(strBookingVO.getPage_index()-1)) + (i+1)) +"</tot_num>");
				retXML.append("	<nm_cust>"+sbVO.getNm_cust()+"</nm_cust>");
				retXML.append("	<dates>"+sbVO.getDates()+"</dates>");
				retXML.append("	<str_code>"+sbVO.getStr_code()+"</str_code>");
				retXML.append("	<times>"+sbVO.getTimes()+"</times>");
				retXML.append("	<purpose>"+sbVO.getPurpose()+"</purpose>");
				retXML.append("	<book_yn>"+sbVO.getBook_yn()+"</book_yn>");
				retXML.append("	<book_time>"+sbVO.getBook_time()+"</book_time>");
				retXML.append("	<seq_no>"+sbVO.getSeq_no()+"</seq_no>");
				retXML.append("	<status>"+sbVO.getStatus()+"</status>");
				retXML.append("</tot_row>");
			}
			int waiting_cnt;
			if(listTot.size() == 0){
				waiting_cnt = 0;
			}else{
				waiting_cnt = listTot.get(0).getWaiting_cnt();
			}
			retXML.append("	<waiting_cnt>"+waiting_cnt+"</waiting_cnt>");
			retXML.append("</tot_rows>");
		}catch(Exception e){
			e.printStackTrace();
		}
		retXML.append("</items>");
		
		//System.out.println(retXML.toString());
		
		response.getWriter().println(retXML.toString());
	}
	
	/*@RequestMapping(value = "/kiosk/standByXml.do")
	public void standByXml(@ModelAttribute("customerVO") CustomerVO customerVO, HttpServletRequest request, HttpServletResponse response) throws Exception{
		response.setContentType("text/xml");
		response.setCharacterEncoding("UTF-8");
		StringBuffer retXML = new StringBuffer(1024);
		retXML.append("<?xml version='1.0' encoding='UTF-8'?>");				
		retXML.append("<items>");
		
		GregorianCalendar cal = new GregorianCalendar();		
		String today = Integer.toString(cal.get(Calendar.YEAR)) + "-" + 
				   (Integer.toString(cal.get(Calendar.MONTH)+1).length() == 1 ? "0" + Integer.toString(cal.get(Calendar.MONTH)+1) : Integer.toString(cal.get(Calendar.MONTH)+1) )+ "-" + 
				   (Integer.toString(cal.get(Calendar.DATE)).length() == 1 ? "0" + Integer.toString(cal.get(Calendar.DATE)) : Integer.toString(cal.get(Calendar.DATE)));
		try{
			StrBookingVO strBookingVO = new StrBookingVO();			
			strBookingVO.setStr_code(customerVO.getStore_no());
			strBookingVO.setDates(today);
			int tot_cnt = customerService.countStrBooking(strBookingVO);
			
			retXML.append("<tot_cnt>"+tot_cnt+"</tot_cnt>");
			
			strBookingVO.setPage_unit(5);
			
			retXML.append("<n_rows>");
			strBookingVO.setBook_yn("N");
			int n_cnt = customerService.countStrBooking(strBookingVO);
			retXML.append("<n_cnt>"+n_cnt+"</n_cnt>");
			
			strBookingVO.setPage_index(customerVO.getN_page_index());			
			List<StrBookingVO> listN = customerService.selectStrBookingList(strBookingVO);
			if(listN.isEmpty()){
				strBookingVO.setPage_index(1);	
				strBookingVO.setN_page_index(1);
				customerVO.setN_page_index(1);
				listN = customerService.selectStrBookingList(strBookingVO);
			}
			retXML.append("<n_page_index>"+customerVO.getN_page_index()+"</n_page_index>");
			for(int i=0; i<listN.size(); i++){
				StrBookingVO sbVO = listN.get(i);
				retXML.append("<n_row>");
				retXML.append("	<n_num>"+ ((strBookingVO.getPage_unit()*(strBookingVO.getPage_index()-1)) + (i+1)) +"</n_num>");
				retXML.append("	<nm_cust>"+egovframework.kiosk.util.StringUtil.stringInstar(sbVO.getNm_cust())+"</nm_cust>");
				retXML.append("	<dates>"+sbVO.getDates()+"</dates>");
				retXML.append("	<str_code>"+sbVO.getStr_code()+"</str_code>");
				retXML.append("	<times>"+sbVO.getTimes()+"</times>");
				retXML.append("	<purpose>"+sbVO.getPurpose()+"</purpose>");
				retXML.append("	<book_yn>"+sbVO.getBook_yn()+"</book_yn>");
				retXML.append("	<book_time>"+sbVO.getBook_time()+"</book_time>");
				retXML.append("</n_row>");
			}
			retXML.append("</n_rows>");
			
			retXML.append("<y_rows>");
			strBookingVO.setBook_yn("Y");
			int y_cnt = customerService.countStrBooking(strBookingVO);
			retXML.append("<y_cnt>"+y_cnt+"</y_cnt>");
			
			strBookingVO.setPage_index(customerVO.getY_page_index());			
			List<StrBookingVO> listY = customerService.selectStrBookingList(strBookingVO);
			if(listY.isEmpty()){
				strBookingVO.setPage_index(1);	
				strBookingVO.setY_page_index(1);
				customerVO.setY_page_index(1);
				listY = customerService.selectStrBookingList(strBookingVO);
			}
			retXML.append("<y_page_index>"+customerVO.getY_page_index()+"</y_page_index>");
			for(int i=0; i<listY.size(); i++){
				StrBookingVO sbVO = listY.get(i);
				retXML.append("<y_row>");
				retXML.append("	<y_num>"+ ((strBookingVO.getPage_unit()*(strBookingVO.getPage_index()-1)) + (i+1)) +"</y_num>");
				retXML.append("	<nm_cust>"+egovframework.kiosk.util.StringUtil.stringInstar(sbVO.getNm_cust())+"</nm_cust>");
				retXML.append("	<dates>"+sbVO.getDates()+"</dates>");
				retXML.append("	<str_code>"+sbVO.getStr_code()+"</str_code>");
				retXML.append("	<times>"+sbVO.getTimes()+"</times>");
				retXML.append("	<purpose>"+sbVO.getPurpose()+"</purpose>");
				retXML.append("	<book_yn>"+sbVO.getBook_yn()+"</book_yn>");
				retXML.append("	<book_time>"+sbVO.getBook_time()+"</book_time>");
				retXML.append("</y_row>");
			}
			retXML.append("</y_rows>");
		}catch(Exception e){
			e.printStackTrace();
		}
		retXML.append("</items>");
		
		//System.out.println(retXML.toString());
		
		response.getWriter().println(retXML.toString());
	}*/
	
	/**
	 * 고객대기 목록 XML
	 * @param CustomerVO
	 * @param request
	 * @param response
	 * @return void
	 * @throws Exception
	 */	
	@RequestMapping(value = "/kiosk/standByXmlAll.do")
	public void standByXmlAll(@ModelAttribute("customerVO") CustomerVO customerVO, HttpServletRequest request, HttpServletResponse response) throws Exception{
		response.setContentType("text/xml");
		response.setCharacterEncoding("UTF-8");
		StringBuffer retXML = new StringBuffer(1024);
		retXML.append("<?xml version='1.0' encoding='UTF-8'?>");				
		retXML.append("<items>");
		
		GregorianCalendar cal = new GregorianCalendar();		
		String today = Integer.toString(cal.get(Calendar.YEAR)) + "-" + 
				   (Integer.toString(cal.get(Calendar.MONTH)+1).length() == 1 ? "0" + Integer.toString(cal.get(Calendar.MONTH)+1) : Integer.toString(cal.get(Calendar.MONTH)+1) )+ "-" + 
				   (Integer.toString(cal.get(Calendar.DATE)).length() == 1 ? "0" + Integer.toString(cal.get(Calendar.DATE)) : Integer.toString(cal.get(Calendar.DATE)));
		try{
			StrBookingVO strBookingVO = new StrBookingVO();			
			strBookingVO.setStr_code(customerVO.getStore_no());
			strBookingVO.setDates(today);
			int tot_cnt = customerService.countStrBooking(strBookingVO);
			
			retXML.append("<tot_cnt>"+tot_cnt+"</tot_cnt>");
			
			strBookingVO.setPage_unit(5);
			
			retXML.append("<n_rows>");
			/*strBookingVO.setBook_yn("N");*/
			int n_cnt = customerService.countStrBooking(strBookingVO);
			retXML.append("<n_cnt>"+n_cnt+"</n_cnt>");		
			List<StrBookingVO> listN = customerService.selectStrBookingListAll(strBookingVO);
			for(int i=0; i<listN.size(); i++){
				StrBookingVO sbVO = listN.get(i);
				retXML.append("<n_row>");
				retXML.append("	<n_num>"+ ((strBookingVO.getPage_unit()*(strBookingVO.getPage_index()-1)) + (i+1)) +"</n_num>");
				retXML.append("	<nm_cust>"+egovframework.kiosk.util.StringUtil.stringInstar(sbVO.getNm_cust())+"</nm_cust>");
				retXML.append("	<dates>"+sbVO.getDates()+"</dates>");
				retXML.append("	<str_code>"+sbVO.getStr_code()+"</str_code>");
				retXML.append("	<times>"+sbVO.getTimes()+"</times>");
				retXML.append("	<purpose>"+sbVO.getPurpose()+"</purpose>");
				retXML.append("	<book_yn>"+sbVO.getBook_yn()+"</book_yn>");
				retXML.append("	<book_time>"+sbVO.getBook_time()+"</book_time>");
				retXML.append("</n_row>");
			}
			retXML.append("</n_rows>");
			
			retXML.append("<y_rows>");
			strBookingVO.setBook_yn("Y");
			int y_cnt = customerService.countStrBooking(strBookingVO);
			retXML.append("<y_cnt>"+y_cnt+"</y_cnt>");
			
			strBookingVO.setPage_index(customerVO.getY_page_index());			
			List<StrBookingVO> listY = customerService.selectStrBookingListAll(strBookingVO);
			for(int i=0; i<listY.size(); i++){
				StrBookingVO sbVO = listY.get(i);
				retXML.append("<y_row>");
				retXML.append("	<y_num>"+ ((strBookingVO.getPage_unit()*(strBookingVO.getPage_index()-1)) + (i+1)) +"</y_num>");
				retXML.append("	<nm_cust>"+egovframework.kiosk.util.StringUtil.stringInstar(sbVO.getNm_cust())+"</nm_cust>");
				retXML.append("	<dates>"+sbVO.getDates()+"</dates>");
				retXML.append("	<str_code>"+sbVO.getStr_code()+"</str_code>");
				retXML.append("	<times>"+sbVO.getTimes()+"</times>");
				retXML.append("	<purpose>"+sbVO.getPurpose()+"</purpose>");
				retXML.append("	<book_yn>"+sbVO.getBook_yn()+"</book_yn>");
				retXML.append("	<book_time>"+sbVO.getBook_time()+"</book_time>");
				retXML.append("</y_row>");
			}
			retXML.append("</y_rows>");
		}catch(Exception e){
			e.printStackTrace();
		}
		retXML.append("</items>");
		
		//System.out.println(retXML.toString());
		
		response.getWriter().println(retXML.toString());
	}
	
	/**
	 * 고객대기 목록 XML
	 * @param StrBookingVO
	 * @param request
	 * @param response
	 * @return void
	 * @throws Exception
	 */	
	@RequestMapping(value = "/kiosk/standByFlagUpdate.do")
	public void standByFlagUpdate(@ModelAttribute("strBookingVO") StrBookingVO strBookingVO, HttpServletRequest request, HttpServletResponse response) throws Exception{
		response.setContentType("text/xml");
		response.setCharacterEncoding("UTF-8");
		StringBuffer retXML = new StringBuffer(1024);
		retXML.append("<?xml version='1.0' encoding='UTF-8'?>");				
		retXML.append("<items>");
				
		try{
			customerService.updateStrBookingFlag(strBookingVO);
			retXML.append("<rtn>1</rtn>");
			
			//다비전에 예약정보 전달(IF_VST_003)
			Map<String, Object> param = new HashMap<>();
			param.put("dates", strBookingVO.getDates().substring(0, 10).replace("-", ""));	    	
			param.put("strCode", strBookingVO.getStr_code());
			param.put("visitTime", strBookingVO.getTimes());
			param.put("flag", strBookingVO.getFlag());
			
			Map<String, Object> result = InterfaceUtil.send("IF_VST_003", param);
			
			//System.out.println("==IF_VST_003========================");
			//System.out.println("result : " + result.get("result"));
			//System.out.println("message : " + result.get("message"));
			//System.out.println("==IF_VST_003========================");			
			
		}catch(Exception e){
			retXML.append("<rtn>0</rtn>");
		}
		retXML.append("</items>");
		response.getWriter().println(retXML.toString());
	}
	
	/**
	 * 고객대기 목록 XML
	 * @param CustomerVO
	 * @param request
	 * @param response
	 * @return void
	 * @throws Exception
	 */	
	@RequestMapping(value = "/kiosk/selectStrBookingListComplete.do")
	public void selectStrBookingListComplete(@ModelAttribute("customerVO") CustomerVO customerVO, HttpServletRequest request, HttpServletResponse response) throws Exception{
		response.setContentType("text/xml");
		response.setCharacterEncoding("UTF-8");
		StringBuffer retXML = new StringBuffer(1024);
		retXML.append("<?xml version='1.0' encoding='UTF-8'?>");				
		retXML.append("<items>");
		
		GregorianCalendar cal = new GregorianCalendar();		
		String today = Integer.toString(cal.get(Calendar.YEAR)) + "-" + 
				   (Integer.toString(cal.get(Calendar.MONTH)+1).length() == 1 ? "0" + Integer.toString(cal.get(Calendar.MONTH)+1) : Integer.toString(cal.get(Calendar.MONTH)+1) )+ "-" + 
				   (Integer.toString(cal.get(Calendar.DATE)).length() == 1 ? "0" + Integer.toString(cal.get(Calendar.DATE)) : Integer.toString(cal.get(Calendar.DATE)));
		try{
			StrBookingVO strBookingVO = new StrBookingVO();			
			strBookingVO.setStr_code(customerVO.getStore_no());
			strBookingVO.setDates(today);			
			strBookingVO.setPage_index(customerVO.getTot_page_index());			
			
			
			
			List<StrBookingVO> listTot = customerService.selectStrBookingListComplete(strBookingVO);
			
			for (int i = 0; i < listTot.size(); i++) {
				StrBookingVO sbVO = listTot.get(i);
				ClientUtils client = new ClientUtils();
				String ip = client.getRemoteIP(request);
				
		        sbVO.setIp(ip);
		        
		        SimpleDateFormat dt = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss"); 
				Date input_date2 = dt.parse(sbVO.getInput_date()); 
				Date cng_date2 = dt.parse(sbVO.getCng_date()); 
				sbVO.setInput_date2(input_date2);
				sbVO.setCng_date2(cng_date2);
				if(customerService.selectCountStrBookingListTts(sbVO) == 0 ){
					retXML.append("<tot_row>");
					retXML.append("	<tot_num>"+ ((strBookingVO.getPage_unit()*(strBookingVO.getPage_index()-1)) + (i+1)) +"</tot_num>");
					retXML.append("	<nm_cust>"+sbVO.getNm_cust()+"</nm_cust>");
					retXML.append("	<dates>"+sbVO.getDates()+"</dates>");
					retXML.append("	<str_code>"+sbVO.getStr_code()+"</str_code>");
					retXML.append("	<times>"+sbVO.getTimes()+"</times>");
					retXML.append("	<purpose>"+sbVO.getPurpose()+"</purpose>");
					retXML.append("	<book_yn>"+sbVO.getBook_yn()+"</book_yn>");
					retXML.append("	<book_time>"+sbVO.getBook_time()+"</book_time>");
					retXML.append("	<seq_no>"+sbVO.getSeq_no()+"</seq_no>");
					retXML.append("	<status>"+sbVO.getStatus()+"</status>");
					retXML.append("</tot_row>");
					sbVO.setTts_gubun("3");
					customerService.insertStrBoonikgTtsList(sbVO);
				} ;
			}
			
		}catch(Exception e){
			e.printStackTrace();
		}
		retXML.append("</items>");
		
		//System.out.println(retXML.toString());
		
		response.getWriter().println(retXML.toString());
	}
	
	/**
	 * 고객대기 목록 XML test
	 * @param CustomerVO
	 * @param request
	 * @param response
	 * @return void
	 * @throws Exception
	 */	
	@RequestMapping(value = "/kiosk/selectStrBookingListTestComplete.do")
	public void selectStrBookingListTestComplete(@ModelAttribute("customerVO") CustomerVO customerVO, HttpServletRequest request, HttpServletResponse response) throws Exception{
		response.setContentType("text/xml");
		response.setCharacterEncoding("UTF-8");
		StringBuffer retXML = new StringBuffer(1024);
		retXML.append("<?xml version='1.0' encoding='UTF-8'?>");				
		retXML.append("<items>");
		//로그인 세션체크 작업
		/*LoginVO loginVo= (LoginVO)request.getSession().getAttribute("loginVo");*/
		GregorianCalendar cal = new GregorianCalendar();		
		String today = Integer.toString(cal.get(Calendar.YEAR)) + "-" + 
				   (Integer.toString(cal.get(Calendar.MONTH)+1).length() == 1 ? "0" + Integer.toString(cal.get(Calendar.MONTH)+1) : Integer.toString(cal.get(Calendar.MONTH)+1) )+ "-" + 
				   (Integer.toString(cal.get(Calendar.DATE)).length() == 1 ? "0" + Integer.toString(cal.get(Calendar.DATE)) : Integer.toString(cal.get(Calendar.DATE)));
		try{
			StrBookingVO strBookingVO = new StrBookingVO();			
			strBookingVO.setStr_code(customerVO.getStore_no());
			strBookingVO.setDates(today);			
			strBookingVO.setPage_index(customerVO.getTot_page_index());			
			
			
			
			List<StrBookingVO> listTot = customerService.selectStrBookingListComplete(strBookingVO);
			
			for (int i = 0; i < listTot.size(); i++) {
				StrBookingVO sbVO = listTot.get(i);
				ClientUtils client = new ClientUtils();
				String ip = client.getRemoteIP(request);
				/*String loginId = loginVo.getLoginId();*/
				String loginId = customerVO.getLogin_id();
		        sbVO.setIp(ip);
		        sbVO.setLogin_id(loginId);
		        
		        SimpleDateFormat dt = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss"); 
				Date input_date2 = dt.parse(sbVO.getInput_date()); 
				Date cng_date2 = dt.parse(sbVO.getCng_date()); 
				sbVO.setInput_date2(input_date2);
				sbVO.setCng_date2(cng_date2);
				if(customerService.selectCountStrBookingListTts(sbVO) == 0 ){
					sbVO.setTts_gubun("3");
					retXML.append("<tot_row>");
					retXML.append("	<tts>3</tts>");
					retXML.append("	<tot_num>"+ ((strBookingVO.getPage_unit()*(strBookingVO.getPage_index()-1)) + (i+1)) +"</tot_num>");
					retXML.append("	<nm_cust>"+sbVO.getNm_cust()+"</nm_cust>");
					retXML.append("	<dates>"+sbVO.getDates()+"</dates>");
					retXML.append("	<str_code>"+sbVO.getStr_code()+"</str_code>");
					retXML.append("	<times>"+sbVO.getTimes()+"</times>");
					retXML.append("	<purpose>"+sbVO.getPurpose()+"</purpose>");
					retXML.append("	<book_yn>"+sbVO.getBook_yn()+"</book_yn>");
					retXML.append("	<book_time>"+sbVO.getBook_time()+"</book_time>");
					retXML.append("	<seq_no>"+sbVO.getSeq_no()+"</seq_no>");
					retXML.append("	<status>"+sbVO.getStatus()+"</status>");
					retXML.append("	<phoneNum>"+sbVO.getHandphone()+"</phoneNum>");
					retXML.append("</tot_row>");
					if(customerService.selectCountStrBookingListTts(sbVO) == 0 ){
						customerService.insertStrBoonikgTtsList(sbVO);
					}
					
				} ;
			}
			
			List<StrBookingVO> listTot2 = customerService.selectDavichStrBookingListTTS01(strBookingVO);
			for (int i = 0; i < listTot2.size(); i++) {
				StrBookingVO sbVO = listTot2.get(i);
				ClientUtils client = new ClientUtils();
				String ip = client.getRemoteIP(request);
				String loginId = customerVO.getLogin_id();
		        sbVO.setIp(ip);
		        sbVO.setLogin_id(loginId);
		        
		        SimpleDateFormat dt = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss"); 
				Date input_date2 = dt.parse(sbVO.getInput_date()); 
				Date cng_date2 = dt.parse(sbVO.getCng_date()); 
				sbVO.setInput_date2(input_date2);
				sbVO.setCng_date2(cng_date2);
				if(customerService.selectCountStrBookingListTts01(sbVO) == 0 ){
					sbVO.setTts_gubun("1");
					retXML.append("<tot_row>");
					retXML.append("	<tts>1</tts>");
					retXML.append("	<tot_num>"+ ((strBookingVO.getPage_unit()*(strBookingVO.getPage_index()-1)) + (i+1)) +"</tot_num>");
					retXML.append("	<nm_cust>"+sbVO.getNm_cust()+"</nm_cust>");
					retXML.append("	<dates>"+sbVO.getDates()+"</dates>");
					retXML.append("	<str_code>"+sbVO.getStr_code()+"</str_code>");
					retXML.append("	<times>"+sbVO.getTimes()+"</times>");
					retXML.append("	<purpose>"+sbVO.getPurpose()+"</purpose>");
					retXML.append("	<book_yn>"+sbVO.getBook_yn()+"</book_yn>");
					retXML.append("	<book_time>"+sbVO.getBook_time()+"</book_time>");
					retXML.append("	<seq_no>"+sbVO.getSeq_no()+"</seq_no>");
					retXML.append("	<status>"+sbVO.getStatus()+"</status>");
					retXML.append("	<phoneNum>"+sbVO.getHandphone()+"</phoneNum>");
					retXML.append("</tot_row>");
					if(customerService.selectCountStrBookingListTts01(sbVO) == 0 ){
						customerService.insertStrBoonikgTtsList(sbVO);
					}
				} ;
			}
			
			List<StrBookingVO> listTot3 = customerService.selectDavichStrBookingListTTS02(strBookingVO);
			for (int i = 0; i < listTot3.size(); i++) {
				StrBookingVO sbVO = listTot3.get(i);
				ClientUtils client = new ClientUtils();
				String ip = client.getRemoteIP(request);
				String loginId = customerVO.getLogin_id();
		        sbVO.setIp(ip);
		        sbVO.setLogin_id(loginId);
		        
		        SimpleDateFormat dt = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss"); 
				Date input_date2 = dt.parse(sbVO.getInput_date()); 
				Date cng_date2 = dt.parse(sbVO.getCng_date()); 
				sbVO.setInput_date2(input_date2);
				sbVO.setCng_date2(cng_date2);
				if(customerService.selectCountStrBookingListTts02(sbVO) == 0 ){
					sbVO.setTts_gubun("2");
					retXML.append("<tot_row>");
					retXML.append("	<tts>2</tts>");
					retXML.append("	<tot_num>"+ ((strBookingVO.getPage_unit()*(strBookingVO.getPage_index()-1)) + (i+1)) +"</tot_num>");
					retXML.append("	<nm_cust>"+sbVO.getNm_cust()+"</nm_cust>");
					retXML.append("	<dates>"+sbVO.getDates()+"</dates>");
					retXML.append("	<str_code>"+sbVO.getStr_code()+"</str_code>");
					retXML.append("	<times>"+sbVO.getTimes()+"</times>");
					retXML.append("	<purpose>"+sbVO.getPurpose()+"</purpose>");
					retXML.append("	<book_yn>"+sbVO.getBook_yn()+"</book_yn>");
					retXML.append("	<book_time>"+sbVO.getBook_time()+"</book_time>");
					retXML.append("	<seq_no>"+sbVO.getSeq_no()+"</seq_no>");
					retXML.append("	<status>"+sbVO.getStatus()+"</status>");
					retXML.append("	<phoneNum>"+sbVO.getHandphone()+"</phoneNum>");
					retXML.append("</tot_row>");
					if(customerService.selectCountStrBookingListTts02(sbVO) == 0 ){
						customerService.insertStrBoonikgTtsList(sbVO);
					}
				} ;
			}
			
		}catch(Exception e){
			e.printStackTrace();
		}
		retXML.append("</items>");
		
		//System.out.println(retXML.toString());
		
		response.getWriter().println(retXML.toString());
	}
	
	/**
	 * 모바일용 고객대기 목록 XML
	 * @param CustomerVO
	 * @param request
	 * @param response
	 * @return void
	 * @throws Exception
	 */	
	@RequestMapping(value = "/kiosk/standByMobileXml.do")
	public void standByMobileXml(@ModelAttribute("customerVO") CustomerVO customerVO, HttpServletRequest request, HttpServletResponse response) throws Exception{
		response.setContentType("text/xml");
		response.setCharacterEncoding("UTF-8");
		StringBuffer retXML = new StringBuffer(1024);
		retXML.append("<?xml version='1.0' encoding='UTF-8'?>");				
		retXML.append("<items>");
		
		GregorianCalendar cal = new GregorianCalendar();		
		String today = Integer.toString(cal.get(Calendar.YEAR)) + "-" + 
				   (Integer.toString(cal.get(Calendar.MONTH)+1).length() == 1 ? "0" + Integer.toString(cal.get(Calendar.MONTH)+1) : Integer.toString(cal.get(Calendar.MONTH)+1) )+ "-" + 
				   (Integer.toString(cal.get(Calendar.DATE)).length() == 1 ? "0" + Integer.toString(cal.get(Calendar.DATE)) : Integer.toString(cal.get(Calendar.DATE)));
		try{
			StrBookingVO strBookingVO = new StrBookingVO();			
			strBookingVO.setStr_code(customerVO.getStore_no());
			strBookingVO.setDates(today);			

			retXML.append("<tot_rows>");
			int tot_cnt = customerDavichService.countDavichStrBooking(strBookingVO);
			retXML.append("<tot_cnt>"+tot_cnt+"</tot_cnt>");
			
			strBookingVO.setPage_index(customerVO.getTot_page_index());			
			List<StrBookingVO> listTot = customerDavichService.selectStrDavichBookingMobileList(strBookingVO);
			
			retXML.append("<tot_page_index>"+customerVO.getTot_page_index()+"</tot_page_index>");
			for(int i=0; i<listTot.size(); i++){
				StrBookingVO sbVO = listTot.get(i);
				retXML.append("<tot_row>");
				retXML.append("	<tot_num>"+ ((strBookingVO.getPage_unit()*(strBookingVO.getPage_index()-1)) + (i+1)) +"</tot_num>");
				retXML.append("	<nm_cust>"+sbVO.getNm_cust()+"</nm_cust>");
				retXML.append("	<dates>"+sbVO.getDates()+"</dates>");
				retXML.append("	<str_code>"+sbVO.getStr_code()+"</str_code>");
				retXML.append("	<times>"+sbVO.getTimes()+"</times>");
				retXML.append("	<purpose>"+sbVO.getPurpose()+"</purpose>");
				retXML.append("	<book_yn>"+sbVO.getBook_yn()+"</book_yn>");
				retXML.append("	<book_time>"+sbVO.getBook_time()+"</book_time>");
				retXML.append("	<seq_no>"+sbVO.getSeq_no()+"</seq_no>");
				retXML.append("	<seq_no3>"+sbVO.getSeq_no3()+"</seq_no3>");
				retXML.append("	<status>"+sbVO.getStatus()+"</status>");
				retXML.append("	<rsv_seq>"+sbVO.getRsv_seq()+"</rsv_seq>");
				retXML.append("	<cd_cust>"+sbVO.getCd_cust()+"</cd_cust>");
				retXML.append("</tot_row>");
			}
			int waiting_cnt;
			if(listTot.size() == 0){
				waiting_cnt = 0;
			}else{
				waiting_cnt = listTot.get(0).getWaiting_cnt();
			}
			retXML.append("	<waiting_cnt>"+waiting_cnt+"</waiting_cnt>");
			retXML.append("</tot_rows>");
		}catch(Exception e){
			e.printStackTrace();
		}
		retXML.append("</items>");
		response.getWriter().println(retXML.toString());
	}
}
