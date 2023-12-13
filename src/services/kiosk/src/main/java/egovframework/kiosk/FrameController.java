package egovframework.kiosk;

import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import egovframework.kiosk.customer.service.CustomerService;
import egovframework.kiosk.manager.service.ManagerService;
import egovframework.kiosk.manager.vo.BannerVO;
import egovframework.kiosk.manager.vo.LoginVO;

@Controller
public class FrameController {
	
	@Resource(name = "ManagerService")
	private ManagerService managerService;
	
	@Resource(name = "CustomerService")
	private CustomerService customerService;
	
	/**
	 * forward 페이지
	 * @param request
	 * @return String
	 * @throws Exception
	 */	
	@RequestMapping(value = "/kiosk/index.do")
	public String indexFeame(HttpServletRequest request) throws Exception{
		HttpSession session = request.getSession();

		if(session.getAttribute("loginVo") == null){
	    	return "redirect:/kiosk/login.do";
		}else{
			return "redirect:/kiosk/start.do";
		}
	}
	
	/**
	 * 실행화면을 선택  페이지
	 * @param request
	 * @return ModelAndView
	 * @throws Exception
	 */	
	@RequestMapping(value = "/kiosk/start.do")
	public ModelAndView startFeame(HttpServletRequest request) throws Exception{
		ModelAndView mv = new ModelAndView("/kiosk/start");
		HttpSession session = request.getSession();
		LoginVO loginVo = (LoginVO)session.getAttribute("loginVo");
		
		mv.addObject("loginVo", loginVo);
		//테스트 서버 설정 작업
		/*int info = customerService.selectTestStoreCount(loginVo.getStrCode());
		mv.addObject("info", info);*/
		return mv;
	}
	
	/**
	 * 메인  페이지
	 * @param request
	 * @return ModelAndView
	 * @throws Exception
	 */	
	@RequestMapping(value = "/kiosk/main.do")
	public ModelAndView mainFeame(HttpServletRequest request) throws Exception{
		ModelAndView mv = new ModelAndView("/kiosk/main");
		HttpSession session = request.getSession();
		LoginVO loginVo = (LoginVO)session.getAttribute("loginVo");
		
		BannerVO bannerVO = new BannerVO();
		bannerVO.setStr_code(loginVo.getStrCode());
		bannerVO.setIs_view("Y");
		List<BannerVO> bannerList = managerService.selectBookingMainBannerList(bannerVO);//본사 + 각 매장에서 올린 배너
		mv.addObject("bannerList", bannerList);
		mv.addObject("loginVo", loginVo);
		return mv;
	}
}
