package egovframework.kiosk.manager.web;

import java.util.ArrayList;
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
import org.springframework.web.util.WebUtils;

import egovframework.kiosk.manager.service.ManagerService;
import egovframework.kiosk.manager.vo.LoginVO;
import egovframework.kiosk.util.InterfaceUtil;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

@Controller
public class LoginController {

	@Resource(name = "ManagerService")
	private ManagerService managerService;

	/**
	 * 로그인 페이지
	 * @param request
	 * @return ModelAndView
	 * @throws Exception
	 */
	@RequestMapping(value = "/kiosk/login.do")
	public ModelAndView login(HttpServletRequest request) throws Exception{
		ModelAndView mv = new ModelAndView("/kiosk/manager/login");

		// 세션 전체
    	request.getSession().invalidate();
    	
    	//매장정보
    	Map<String, Object> param = new HashMap<>();
    	param.put("cntPerPage", 1000);
    	Map<String, Object> result = InterfaceUtil.send("IF_RSV_006", param);
    	if ("1".equals(result.get("result"))) {
    		
    		//System.out.println(result.get("strList").toString());
    		//System.out.println("=====================================");
    		     
    		JSONObject jsonObj =  JSONObject.fromObject(result);    		
    		JSONArray jsonArray = jsonObj.getJSONArray("strList"); 
    		if (jsonArray != null) { 
    		   List<Object> strList = new ArrayList<>();
    		   for (int i=0;i<jsonArray.size();i++){ 
    			   JSONObject tmpObj = (JSONObject)jsonArray.get(i);    		    
    			   
    			   Map<String, String> tmpMap = new HashMap<String, String>();
    			   tmpMap.put("strCode", tmpObj.get("strCode").toString());
    			   tmpMap.put("strName", tmpObj.get("strName").toString());
    			   
    			   strList.add(tmpMap);
    			   //System.out.println(tmpObj.get("strCode") + ":" + tmpObj.get("strName"));
    		   }
    		   
    		   mv.addObject("strList", strList);
    		} 
    		
    	}else{
    		System.out.println(result.get("message"));
        } 	
    	
    	
		return mv;
	}

	/**
	 * 로그인 Proc 페이지
	 * @param LoginVO
	 * @param request
	 * @param response
	 * @return void
	 * @throws Exception
	 */
	@RequestMapping(value = "/kiosk/loginProc.do")
	public void loginProc(@ModelAttribute("loginVO") LoginVO loginVO, HttpServletRequest request, HttpServletResponse response) throws Exception{
		response.setContentType("text/xml");
		response.setCharacterEncoding("UTF-8");
		StringBuffer retXML = new StringBuffer(1024);
		retXML.append("<?xml version='1.0' encoding='UTF-8'?>");
		retXML.append("<items>");

		//System.out.println("======================================");
		//System.out.println("StrCode : " + loginVO.getStrCode());
		//System.out.println("LoginId : " + loginVO.getLoginId());
		//System.out.println("LoginPw : " + loginVO.getLoginPw());
		//System.out.println("======================================");

		try{
			Map<String, Object> param = new HashMap<>();
			param.put("strCode", loginVO.getStrCode());
			param.put("loginId", loginVO.getLoginId());
			param.put("loginPw", loginVO.getLoginPw());
			Map<String, Object> result =  new HashMap<>();
			if("dg".equals(param.get("loginId"))){
				if(managerService.selectAm030tbl8888(loginVO)>0){
					result.put("result", "1");
					result.put("checkResult", "Y");
				}else{
					result.put("result", "2");
				}
			}else{
				result = InterfaceUtil.send("IF_VST_001", param);
			}
			//System.out.println("======================================");
			//System.out.println("결과코드 : " + result.get("result"));
			//System.out.println("메시지 : " + result.get("message"));
			//System.out.println("체크결과 : " + result.get("checkResult"));
			//System.out.println("======================================");
			if(result.get("result").toString().equals("1")){
				if(result.get("checkResult").toString().equals("Y")){
					Map<String, Object> shop = InterfaceUtil.send("IF_RSV_007", param);
					//System.out.println("======================================");
					//System.out.println("결과코드 : " + shop.get("result"));
					//System.out.println("메시지 : " + shop.get("message"));
					//System.out.println("매장코드 : " + shop.get("strCode"));
					//System.out.println("매장명 : " + shop.get("strName"));
					//System.out.println("======================================");

					loginVO.setStrName(shop.get("strName").toString());

					WebUtils.setSessionAttribute(request, "loginVo", loginVO);
					
					retXML.append("<row>");
					retXML.append("		<rtn>true</rtn>");
					retXML.append("		<msg></msg>");
					retXML.append("</row>");
				}else{
					retXML.append("<row>");
					retXML.append("		<rtn>false</rtn>");
					retXML.append("		<msg>매장의 정보가 없습니다.\n매장코드,아이디,비밀번호를 확인하세요.</msg>");
					retXML.append("</row>");
				}
			}else{

				retXML.append("<row>");
				retXML.append("		<rtn>false</rtn>");
				retXML.append("		<msg>접속오류입니다.\n관리자에게 문의하세요.</msg>");
				retXML.append("</row>");
			}			
		}catch(Exception e){
			e.printStackTrace();
		}	
		
		retXML.append("</items>");
		response.getWriter().println(retXML.toString());
	}
	
	/**
	 * 로그아웃 페이지
	 * @param request
	 * @return String
	 * @throws Exception
	 */	
	@RequestMapping(value="/kiosk/logout.do")
    public String logoutView(HttpServletRequest request) throws Exception{		
    	// 세션 전체
    	request.getSession().invalidate();

    	return "redirect:/kiosk/login.do";
    }
}
