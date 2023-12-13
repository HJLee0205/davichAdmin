package egovframework.kiosk.manager.web;

import java.io.File;
import java.util.Enumeration;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.io.FilenameUtils;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import egovframework.kiosk.customer.vo.CustomerVO;
import egovframework.kiosk.manager.service.ManagerService;
import egovframework.kiosk.manager.vo.BannerVO;
import egovframework.kiosk.manager.vo.LoginVO;
import egovframework.kiosk.monitor.service.MonitorService;
import egovframework.kiosk.monitor.vo.MessageVO;
import egovframework.kiosk.monitor.vo.MonitorVO;
import egovframework.rte.fdl.property.EgovPropertyService;

@Controller
public class ManagerController {
	
	@Resource(name = "propertiesService")
	private EgovPropertyService propertiesService;
	
	@Resource(name = "MonitorService")
	private MonitorService monitorService;
	
	@Resource(name = "ManagerService")
	private ManagerService managerService;
	
	/**
	 * 대기화면(배너)
	 * @param CustomerVO
	 * @param request
	 * @param response
	 * @return ModelAndView
	 * @throws Exception
	 */	
	@RequestMapping(value = "/kiosk/bannerList.do")
	public ModelAndView bannerList(@ModelAttribute("customerVO") CustomerVO customerVO, HttpServletRequest request, HttpServletResponse response) throws Exception{
		ModelAndView mv = new ModelAndView("/kiosk/manager/banner_list");
		
		BannerVO bannerVO = new BannerVO();
		bannerVO.setStr_code(customerVO.getStore_no());
		
		List<BannerVO> bannerList = managerService.selectBookingBannerList(bannerVO);
		
		mv.addObject("bannerList", bannerList);
		mv.addObject("customerVO", customerVO);
		
		return mv;
	}
	
	
	/**
	 * 배너 등록
	 * @param request
	 * @param response
	 * @return void
	 * @throws Exception
	 */	
	@RequestMapping(value = "/kiosk/managerBanner.do", method = RequestMethod.POST)
	public void practiceInsert(HttpServletRequest request, HttpServletResponse response) throws Exception{
		HttpSession session = request.getSession();		
		if(session.getAttribute("loginVo")==null){
			//String msg = "잘못된 접근경로입니다.";			
		}else{			
			LoginVO mlVO = (LoginVO)session.getAttribute("loginVo");
	
			String realPath =  propertiesService.getString("attach_dir");	
			
			int sizeLimit = 100 * 1024 * 1024;
			
			com.oreilly.servlet.MultipartRequest multi = egovframework.kiosk.util.StringUtil.uploadFile(request, realPath, sizeLimit);
			int rtn = 0;
			try{
				if(multi!=null){		
					Enumeration<?> files = multi.getFileNames();
					//실습일지 등록
					BannerVO bannerVO = new BannerVO();
					bannerVO.setStr_code(multi.getParameter("str_code"));
					bannerVO.setBanner_no(Integer.parseInt(multi.getParameter("banner_no")));
					bannerVO.setReg_id(mlVO.getLoginId());
					
					//첨부파일 등록
					if(files.hasMoreElements()){
						String strFile = (String)files.nextElement();						
						File file = multi.getFile(strFile);
						bannerVO.setOrg_file_nm(multi.getOriginalFileName(strFile));
						bannerVO.setFile_path(realPath);
						bannerVO.setFile_nm(multi.getFilesystemName(strFile));
						bannerVO.setFile_type(FilenameUtils.getExtension(multi.getFilesystemName(strFile)).toLowerCase());
						bannerVO.setFile_size(file.length());	
					}					
					
					if(bannerVO.getBanner_no() > 0){
						rtn = managerService.updateBookingBanner(bannerVO);
					}else{
						bannerVO.setIs_view("N");
						rtn = managerService.insertBookingBanner(bannerVO);
					}
					
				}
			}catch(Exception e){
				e.printStackTrace();
			}
			
			response.setContentType("text/xml");
			response.setCharacterEncoding("UTF-8");
			StringBuffer retXML = new StringBuffer(1024);
			retXML.append("<?xml version='1.0' encoding='UTF-8'?>");				
			retXML.append("<items>");
			retXML.append("		<rtn>"+rtn+"</rtn>");
			retXML.append("</items>");
			response.getWriter().println(retXML.toString());
		}
		
	}
	
	/**
	 * IS_VIEW 업데이트
	 * @param BannerVO
	 * @param request
	 * @param response
	 * @return void
	 * @throws Exception
	 * */
	@RequestMapping(value = "/kiosk/managerBannerIsView.do")
	public void managerBannerIsView(@ModelAttribute("bannerVO") BannerVO bannerVO, HttpServletRequest request, HttpServletResponse response) throws Exception {		
		HttpSession session = request.getSession();		
		if(session.getAttribute("loginVo")==null){
			//String msg = "잘못된 접근경로입니다.";
		}else{
			LoginVO mlVO = (LoginVO)session.getAttribute("loginVo");
			
			try{
				bannerVO.setReg_id(mlVO.getLoginId());
				managerService.updateBookingBannerIsView(bannerVO);
			}catch(Exception e){
				e.printStackTrace();
			}				
			
			response.setContentType("text/xml");
			response.setCharacterEncoding("UTF-8");
			StringBuffer retXML = new StringBuffer(1024);
			retXML.append("<?xml version='1.0' encoding='UTF-8'?>");				
			retXML.append("<items>");
			retXML.append("		<rtn>"+bannerVO.getBanner_no()+"</rtn>");
			retXML.append("</items>");
			response.getWriter().println(retXML.toString());
		}
	}
	
	/**
	 * 배너 삭제
	 * @param BannerVO
	 * @param request
	 * @param response
	 * @return void
	 * @throws Exception
	 * */
	@RequestMapping(value = "/kiosk/managerBannerDel.do")
	public void managerBannerDel(@ModelAttribute("bannerVO") BannerVO bannerVO, HttpServletRequest request, HttpServletResponse response) throws Exception {		
		HttpSession session = request.getSession();		
		if(session.getAttribute("loginVo")==null){
			//String msg = "잘못된 접근경로입니다.";
		}else{			
			try{
				BannerVO bVO = managerService.selectBookingBanner(bannerVO);
				
				File delFile = new File(bVO.getFile_path()+ File.separator +bVO.getFile_nm());//기존 파일을 지운다.
			    delFile.delete();//파일삭제
				
				managerService.deleteBookingBanner(bannerVO);
			}catch(Exception e){
				e.printStackTrace();
			}				
			
			response.setContentType("text/xml");
			response.setCharacterEncoding("UTF-8");
			StringBuffer retXML = new StringBuffer(1024);
			retXML.append("<?xml version='1.0' encoding='UTF-8'?>");				
			retXML.append("<items>");
			retXML.append("		<rtn>"+bannerVO.getBanner_no()+"</rtn>");
			retXML.append("</items>");
			response.getWriter().println(retXML.toString());
		}
	}
	
	/**
	 * 안내문구
	 * @param CustomerVO
	 * @param request
	 * @param response
	 * @return ModelAndView
	 * @throws Exception
	 */	
	@RequestMapping(value = "/kiosk/messageList.do")
	public ModelAndView messageList(@ModelAttribute("customerVO") CustomerVO customerVO, HttpServletRequest request, HttpServletResponse response) throws Exception{
		ModelAndView mv = new ModelAndView("/kiosk/manager/message_list");
		
		int cnt = monitorService.selectStrCount(customerVO.getStore_no());
		
		MessageVO messageVO = new MessageVO();
		if(cnt == 0){
			messageVO.setStr_code(customerVO.getStore_no());
			messageVO.setMsg1("잠시만 기다려주시면 순번대로 빠르게 안내해 드리겠습니다.");
			messageVO.setMsg2("");
			messageVO.setMsg3("");
			messageVO.setMsg4("");
			messageVO.setMsg5("");
			int rtn = monitorService.insertBookingMsg(messageVO);
		}else{
			messageVO = monitorService.selectBookingMsg(customerVO.getStore_no());
		}
		mv.addObject("messageVO", messageVO);
		mv.addObject("customerVO", customerVO);
		return mv;
	}
	
	/**
	 * 호출타임
	 * @param CustomerVO
	 * @param request
	 * @param response
	 * @return ModelAndView
	 * @throws Exception
	 */	
	@RequestMapping(value = "/kiosk/callTime.do")
	public ModelAndView callTime(@ModelAttribute("customerVO") CustomerVO customerVO, HttpServletRequest request, HttpServletResponse response) throws Exception{
		ModelAndView mv = new ModelAndView("/kiosk/manager/call_time");
		
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
		
		mv.addObject("monitorVO", monitorVO);
		mv.addObject("customerVO", customerVO);
		return mv;
	}
}
