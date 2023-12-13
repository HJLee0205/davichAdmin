package net.danvi.dmall.front.web.view.vision.controller;

import java.net.URLDecoder;
import java.util.Calendar;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.StringUtils;
import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import dmall.framework.common.exception.JsonValidationException;
import dmall.framework.common.util.SiteUtil;
import lombok.extern.slf4j.Slf4j;
import net.danvi.dmall.biz.app.vision.model.VisionCheckDscrtVO;
import net.danvi.dmall.biz.app.vision.model.VisionCheckSO;
import net.danvi.dmall.biz.app.vision.model.VisionCheckVO;
import net.danvi.dmall.biz.app.vision.model.VisionStepVO;
import net.danvi.dmall.biz.app.vision.model.VisionVO;
import net.danvi.dmall.biz.app.vision.service.VisionCheckService;
import net.danvi.dmall.biz.system.security.DmallSessionDetails;
import net.danvi.dmall.biz.system.security.SessionDetailHelper;

/**
 * <pre>
 * - 프로젝트명    : 31.front.web
 * - 패키지명      : front.web.view.vision.controller
 * - 파일명        : VisionController.java
 * - 작성일        : 2018. 7. 19.
 * - 작성자        : yji
 * - 설명          : vision check Controller
 * </pre>
 */
@Slf4j
@Controller
@RequestMapping("/front/vision")
public class VisionController {	
	@Resource(name = "visionCheckService")
    private VisionCheckService visionCheckService;
    
	@RequestMapping(value = "/vision-check")
	public ModelAndView visionCheck(@Validated VisionVO vo, BindingResult bindingResult) throws Exception {
        ModelAndView mav = SiteUtil.getSkinView("/vision/vision_check");
        
        DmallSessionDetails sessionInfo = SessionDetailHelper.getDetails();
        String birth = sessionInfo.getSession().getBirth();
        
        // 회원의 생일로 현재 나이(만 나이) 계산
        if(!StringUtils.isEmpty(birth) && !"".equals(birth)){
	        int birthYear = Integer.parseInt(birth.substring(0, 4));
	        int birthMonth = Integer.parseInt(birth.substring(4, 6));
	        int birthDay = Integer.parseInt(birth.substring(6, 8));
	        
	        Calendar current = Calendar.getInstance();
	        int currentYear  = current.get(Calendar.YEAR);
	        int currentMonth = current.get(Calendar.MONTH) + 1;
	        int currentDay   = current.get(Calendar.DAY_OF_MONTH);
	
	        int age = currentYear - birthYear;
	        //생일 안 지난 경우 -1
	        if (birthMonth * 100 + birthDay > currentMonth * 100 + currentDay) age--;

	        mav.addObject("memberAge", age);
        }
        else{
        	mav.addObject("memberAge", 0);
        }
        
        //렌즈타입
        String lensType = vo.getLensType();
        if(StringUtils.isEmpty(lensType) || "".equals(lensType)){
        	lensType = "G";
        }
        mav.addObject("lensType", lensType);
        
        return mav;
	}
	
	@RequestMapping(value = "/vision-check2")
	public ModelAndView visionCheck2(@Validated VisionStepVO vo, BindingResult bindingResult) throws Exception {
        ModelAndView mav = SiteUtil.getSkinView("/vision/vision_check2");
        
        DmallSessionDetails sessionInfo = SessionDetailHelper.getDetails();
        String birth = sessionInfo.getSession().getBirth();
        
        // 회원의 생일로 현재 나이(만 나이) 계산
        if(!StringUtils.isEmpty(birth) && !"".equals(birth)){
	        int birthYear = Integer.parseInt(birth.substring(0, 4));
	        int birthMonth = Integer.parseInt(birth.substring(4, 6));
	        int birthDay = Integer.parseInt(birth.substring(6, 8));
	        
	        Calendar current = Calendar.getInstance();
	        int currentYear  = current.get(Calendar.YEAR);
	        int currentMonth = current.get(Calendar.MONTH) + 1;
	        int currentDay   = current.get(Calendar.DAY_OF_MONTH);
	
	        int age = currentYear - birthYear;
	        //생일 안 지난 경우 -1
	        if (birthMonth * 100 + birthDay > currentMonth * 100 + currentDay) age--;

	        mav.addObject("memberAge", age);
        }
        else{
        	mav.addObject("memberAge", 0);
        }
        
        //렌즈타입
        String visionGb = vo.getVisionGb();
        if(StringUtils.isEmpty(visionGb) || "".equals(visionGb)){
        	visionGb = "G";
        }
        mav.addObject("visionGb", visionGb);
        
        VisionStepVO ageVO = new VisionStepVO();
        ageVO.setVisionGb(visionGb);
        List<VisionStepVO> ageList = visionCheckService.selectVisionAge(ageVO);
        
        mav.addObject("ageList", ageList);
        
        return mav;
	}
	
	@RequestMapping(value = "/vision-check2-s1")
	public ModelAndView visionCheck2S1(@Validated VisionStepVO vo, BindingResult bindingResult) throws Exception {
        ModelAndView mav = SiteUtil.getSkinView("/vision/vision_check2_s1");                 
        
        List<VisionStepVO> step1List = visionCheckService.selectVisionStep1(vo);
        mav.addObject("step1List", step1List);
        mav.addObject("visionStepVO", vo);
        return mav;
	}
	
	@RequestMapping(value = "/vision-check2-s2")
	public ModelAndView visionCheck2S2(@Validated VisionStepVO vo, BindingResult bindingResult) throws Exception {
        ModelAndView mav = SiteUtil.getSkinView("/vision/vision_check2_s2");                 
        
        List<VisionStepVO> step2List = visionCheckService.selectVisionStep2(vo);
        mav.addObject("step2List", step2List);
        mav.addObject("visionStepVO", vo);
        return mav;
	}
	
	@RequestMapping(value = "/vision-check2-s3")
	public ModelAndView visionCheck2S3(@Validated VisionStepVO vo, BindingResult bindingResult) throws Exception {
        ModelAndView mav = SiteUtil.getSkinView("/vision/vision_check2_s3");                 
        
       
    	 if(vo.getStep2Cd().indexOf(",") > 0) {
    		 String[] step2Cd = vo.getStep2Cd().split(",");
    		 String step2Cds = "";
    		 for(int i=0; i<step2Cd.length; i++) {
    			 step2Cds = step2Cds + "'" + step2Cd[i] + "'";
    			 if(i<step2Cd.length-1) step2Cds = step2Cds + ",";
    		 }
    		 
    		 vo.setStep2Cd(step2Cds);
    	 }else {
    		 vo.setStep2Cd("'" + vo.getStep2Cd() + "'");
    	 }
       
        
        List<VisionStepVO> step3List = visionCheckService.selectVisionStep3(vo);
        mav.addObject("step3List", step3List);
        
        if(vo.getVisionGb().equals("C")) {
        	 List<VisionStepVO> step10List = visionCheckService.selectVisionStep10(vo);
        	 mav.addObject("step10List", step10List);
        }
        
        mav.addObject("visionStepVO", vo);
        return mav;
	}
	
	@RequestMapping(value = "/vision-check2-s4")
	public ModelAndView visionCheck2S4(@Validated VisionStepVO vo, BindingResult bindingResult) throws Exception {
        ModelAndView mav = SiteUtil.getSkinView("/vision/vision_check2_s4");                 
        
       
    	 if(vo.getStep3Cd().indexOf(",") > 0) {
    		 String[] step3Cd = vo.getStep3Cd().split(",");
    		 String step3Cds = "";
    		 for(int i=0; i<step3Cd.length; i++) {
    			 step3Cds = step3Cds + "'" + step3Cd[i] + "'";
    			 if(i<step3Cd.length-1) step3Cds = step3Cds + ",";
    		 }
    		 
    		 vo.setStep3Cd(step3Cds);
    	 }else {
    		 vo.setStep3Cd("'" + vo.getStep3Cd() + "'");
    	 }
       
        if(vo.getVisionGb().equals("G")) {
        	List<VisionStepVO> step4List = visionCheckService.selectVisionStep4g(vo);
            mav.addObject("step4List", step4List);
        }else if(vo.getVisionGb().equals("C")){
        	List<VisionStepVO> step4List = visionCheckService.selectVisionStep4(vo);
            mav.addObject("step4List", step4List);
        }
        
        mav.addObject("visionStepVO", vo);
        return mav;
	}
	
	@RequestMapping(value = "/vision-check2-s5")
	public ModelAndView visionCheck2S5(@Validated VisionStepVO vo, BindingResult bindingResult) throws Exception {
        ModelAndView mav = SiteUtil.getSkinView("/vision/vision_check2_s5");                 
               
		if(vo.getStep4Cd().indexOf(",") > 0) {
			String[] step4Cd = vo.getStep4Cd().split(",");
			String step4Cds = "";
			for(int i=0; i<step4Cd.length; i++) {
				step4Cds = step4Cds + "'" + step4Cd[i] + "'";
				if(i<step4Cd.length-1) step4Cds = step4Cds + ",";
			}
			 
			vo.setStep4Cd(step4Cds);
		}else {
			vo.setStep4Cd("'" + vo.getStep4Cd() + "'");
		}      
		
		if(vo.getStep10Cd().indexOf(",") > 0) {
			String[] step10Cd = vo.getStep10Cd().split(",");
			String step10Cds = "";
			for(int i=0; i<step10Cd.length; i++) {
				step10Cds = step10Cds + "'" + step10Cd[i] + "'";
				if(i<step10Cd.length-1) step10Cds = step10Cds + ",";
			}
			 
			vo.setStep10Cd(step10Cds);
		}else {
			vo.setStep10Cd("'" + vo.getStep10Cd() + "'");
		}
		 
        
        List<VisionStepVO> step5List = visionCheckService.selectVisionStep5c(vo);
        mav.addObject("step5List", step5List);
                
        mav.addObject("visionStepVO", vo);
        return mav;
	}
	
	@RequestMapping(value = "/recommend-lens")
	public ModelAndView recommendLens(@Validated VisionVO vo, BindingResult bindingResult) throws Exception {
        ModelAndView mav = SiteUtil.getSkinView("/vision/recommend_lens");
        
        // 조회할 회원정보 set
        DmallSessionDetails sessionInfo = SessionDetailHelper.getDetails();       
        mav.addObject("userNo", sessionInfo.getSession().getMemberNo());    
        mav.addObject("userName", sessionInfo.getSession().getMemberNm());

        List<VisionCheckDscrtVO> visionDscrt = visionCheckService.selectVisonCheckDscrtList(vo);
        mav.addObject("visionDscrt", visionDscrt);
        
        mav.addObject("VisionVO", vo);   
        
        return mav;
	}
	
	@RequestMapping(value = "/recommend-lens2")
	public ModelAndView recommendLens2(@Validated VisionStepVO vo, BindingResult bindingResult) throws Exception {
        ModelAndView mav = SiteUtil.getSkinView("/vision/recommend_lens2");
        
        // 조회할 회원정보 set
        DmallSessionDetails sessionInfo = SessionDetailHelper.getDetails();       
        mav.addObject("userNo", sessionInfo.getSession().getMemberNo());    
        mav.addObject("userName", sessionInfo.getSession().getMemberNm());
        
        String checkNo[] = ((String)vo.getCheckNos()).split(",");
        String checkNos = "";
        if(checkNo.length > 0) {
        	for(int i=0; i<checkNo.length; i++) {
        		if(!checkNo[i].equals("")) {
        			checkNos += checkNo[i];        			
        			if(i<checkNo.length-1) checkNos += ",";        			
        		}
        	}
        }
        
        vo.setCheckNos(checkNos);
        
        List<VisionCheckDscrtVO> visionDscrt = visionCheckService.selectVisonCheckDscrtList2(vo);
        mav.addObject("visionDscrt", visionDscrt);
        
         
        /*
        System.out.println("========================================");
        System.out.println("AgeNm : " + vo.getAgeNm());
        System.out.println("RelateActivity : " + vo.getRelateActivity());
        System.out.println("Step1Cd : " + vo.getStep1Cd());
        System.out.println("Step2Cd : " + vo.getStep2Cd());
        System.out.println("Step3Cd : " + vo.getStep3Cd());
        System.out.println("Step4Cd : " + vo.getStep4Cd());
        System.out.println("Step5Cd : " + vo.getStep5Cd());        
        System.out.println("========================================");
        */
        
        String step2Nm = "";
        String step3Nm = "";
        String step4Nm = "";
        String step10Nm = "";
        
        vo.setGrpCd("VISION_STEP2_CD");
        vo.setStepCds(vo.getStep2Cd());        
        List<VisionStepVO> step2NmList = visionCheckService.selectStepNm(vo);
        for(int i=0; i<step2NmList.size(); i++) {
        	VisionStepVO tmpVO = step2NmList.get(i);
        	step2Nm += (String)tmpVO.getCdNm();
        	if(i<step2NmList.size()-1) step2Nm += ",";
        }
        mav.addObject("step2Nm", step2Nm);  
        mav.addObject("step2NmList", step2NmList);
        
        vo.setGrpCd("VISION_STEP3_CD");
        vo.setStepCds(vo.getStep3Cd());        
        List<VisionStepVO> step3NmList = visionCheckService.selectStepNm(vo);
        for(int i=0; i<step3NmList.size(); i++) {
        	VisionStepVO tmpVO = step3NmList.get(i);
        	step3Nm += (String)tmpVO.getCdNm();
        	if(i<step3NmList.size()-1) step3Nm += ",";
        }
        mav.addObject("step3Nm", step3Nm); 
        
        if(vo.getStep4Cd().indexOf("'") < 0) {
        	vo.setStep4Cd("'" + vo.getStep4Cd().replaceAll(",", "','") + "'");
        }        
        vo.setGrpCd("VISION_STEP4_CD");
        vo.setStepCds(vo.getStep4Cd());        
        List<VisionStepVO> step4NmList = visionCheckService.selectStepNm(vo);
        for(int i=0; i<step4NmList.size(); i++) {
        	VisionStepVO tmpVO = step4NmList.get(i);
        	step4Nm += (String)tmpVO.getCdNm();
        	if(i<step4NmList.size()-1) step4Nm += ",";
        }
        mav.addObject("step4Nm", step4Nm);
        
        if(vo.getVisionGb().equals("C")) {
	        vo.setGrpCd("VISION_STEP10_CD");
	        vo.setStepCds(vo.getStep10Cd());        
	        List<VisionStepVO> step10NmList = visionCheckService.selectStepNm(vo);
	        for(int i=0; i<step10NmList.size(); i++) {
	        	VisionStepVO tmpVO = step10NmList.get(i);
	        	step10Nm += (String)tmpVO.getCdNm();
	        	if(i<step10NmList.size()-1) step10Nm += ",";
	        }
	        mav.addObject("step10Nm", step10Nm);
        }
        
        //vo.setStep2Cd(vo.getStep2Cd().replaceAll("'", ""));
        mav.addObject("visionStepVO", vo);  
        
        return mav;
	}
	
	@RequestMapping(value = "/vision-check-insert")
	public void visionCheckInsert(@Validated VisionCheckVO vo, BindingResult bindingResult, HttpServletResponse response) throws Exception {
		
		// 조회할 회원정보 set
        DmallSessionDetails sessionInfo = SessionDetailHelper.getDetails();        
        vo.setMemberNo(sessionInfo.getSession().getMemberNo());
        vo.setRegrNo(sessionInfo.getSession().getMemberNo());
        
        //기존 정보 삭제
        visionCheckService.deleteVisionCheck(vo);
        
        if(vo.getCheckNos().indexOf(",") > 0) {
        	String[] checkNo = vo.getCheckNos().split(",");
        	for(int i=0; i<checkNo.length; i++) {
        		vo.setCheckNo(Integer.parseInt(checkNo[i]));
        		visionCheckService.insertVisionCheck(vo);
        	}
        }else{
        	vo.setCheckNo(Integer.parseInt(vo.getCheckNos()));
    		visionCheckService.insertVisionCheck(vo);
        }
                
        response.setContentType("text/xml");
		response.setCharacterEncoding("UTF-8");
		StringBuffer retXML = new StringBuffer(1024);
		retXML.append("<?xml version='1.0' encoding='UTF-8'?>");				
		retXML.append("<items>");
         
		retXML.append("<row>");
		retXML.append("		<rtn>1</rtn>");
		retXML.append("</row>");
		
		retXML.append("</items>");
		response.getWriter().println(retXML.toString());
	}
	
	
	
	
	@RequestMapping(value = "/my-vision-check")
	public ModelAndView myVisionCheck(@Validated VisionVO vo, BindingResult bindingResult) throws Exception {
        ModelAndView mav = SiteUtil.getSkinView("/mypage/vision_check_list");
        
     // 조회할 회원정보 set
        DmallSessionDetails sessionInfo = SessionDetailHelper.getDetails();
        mav.addObject("userName", sessionInfo.getSession().getMemberNm());
        
        VisionCheckVO visionCheckVO = new VisionCheckVO();        
        visionCheckVO.setMemberNo(sessionInfo.getSession().getMemberNo());
        
        visionCheckVO.setLensGbCd("G");
        List<VisionCheckVO> glassVision = visionCheckService.selectVisionCheckList(visionCheckVO);   
        if(glassVision.size() > 0) {
        	mav.addObject("glassVision", glassVision);        
        	VisionCheckVO topGlassVO = glassVision.get(0);      
        	mav.addObject("topGlassVO", topGlassVO);
        }
        
        visionCheckVO.setLensGbCd("C");
        List<VisionCheckVO> contactVision = visionCheckService.selectVisionCheckList(visionCheckVO);
        if(contactVision.size() > 0) {
        	mav.addObject("contactVision", contactVision);        
	        VisionCheckVO topContactVO = contactVision.get(0);      
	        mav.addObject("topContactVO", topContactVO);
        }
        
        String lensType = "G";
        if("C".equals(vo.getLensType())){
        	lensType = "C";
        }
        mav.addObject("lensType", lensType);  
        mav.addObject("leftMenu", "my-vision-check");
        
        return mav;
	}
	
	/**
     * <pre>
     * 작성일 : 2018. 8. 29.
     * 작성자 : hskim
     * 설명   : 안경렌즈 추천 불편사항 데이터 조회
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2018. 8. 29. hskim - 최초생성
     * </pre>
     *
     * @param so
     * @param bindingResult
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/select-poMatr-ajax")
    public @ResponseBody List<VisionCheckVO> selectPoMatrAjax(@Validated VisionCheckSO so,
            BindingResult bindingResult) throws Exception {
    	
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }

        List<VisionCheckVO> result = visionCheckService.selectPoMatrAjax(so);

        return result;
    }
    
    /**
     * <pre>
     * 작성일 : 2018. 8. 29.
     * 작성자 : hskim
     * 설명   : 안경렌즈 추천 라이프스타일 데이터 조회
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2018. 8. 29. hskim - 최초생성
     * </pre>
     *
     * @param so
     * @param bindingResult
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/select-lifeStyle-ajax")
    public @ResponseBody List<VisionCheckVO> selectLifeStyleAjax(@Validated VisionCheckSO so,
            BindingResult bindingResult) throws Exception {
    	
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }

        List<VisionCheckVO> result = visionCheckService.selectLifeStyleAjax(so);

        return result;
    }
    
    /**
     * <pre>
     * 작성일 : 2018. 8. 29.
     * 작성자 : hskim
     * 설명   : 콘텍트렌즈 추천 라이프스타일 데이터 조회
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2018. 8. 29. hskim - 최초생성
     * </pre>
     *
     * @param so
     * @param bindingResult
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/select-contact-ajax")
    public @ResponseBody List<VisionCheckVO> selectContactAjax(@Validated VisionCheckSO so,
            BindingResult bindingResult) throws Exception {
    	
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }

        List<VisionCheckVO> result = visionCheckService.selectContactAjax(so);

        return result;
    }
    
    /**
     * <pre>
     * 작성일 : 2018. 8. 29.
     * 작성자 : hskim
     * 설명   : 콘텍트렌즈 추천 라이프스타일 데이터 조회
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2018. 8. 29. hskim - 최초생성
     * </pre>
     *
     * @param so
     * @param bindingResult
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/select-age-ajax")
    public @ResponseBody List<VisionStepVO> selectAgeAjax(@Validated VisionStepVO vo, BindingResult bindingResult) throws Exception {
    	
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }

      //렌즈타입
        String visionGb = vo.getVisionGb();
        if(StringUtils.isEmpty(visionGb) || "".equals(visionGb)){
        	visionGb = "G";
        }
        
        VisionStepVO ageVO = new VisionStepVO();
        ageVO.setVisionGb(visionGb);
        List<VisionStepVO> result = visionCheckService.selectVisionAge(ageVO);

        return result;
    }
}
