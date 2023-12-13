package net.danvi.dmall.front.web.view.vision.controller;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.StringUtils;
import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import dmall.framework.common.model.ResultListModel;
import dmall.framework.common.util.SiteUtil;
import lombok.extern.slf4j.Slf4j;
import net.danvi.dmall.biz.app.goods.model.GoodsSO;
import net.danvi.dmall.biz.app.goods.model.GoodsVO;
import net.danvi.dmall.biz.app.goods.service.GoodsManageService;
import net.danvi.dmall.biz.app.operation.model.AtchFileVO;
import net.danvi.dmall.biz.app.vision.model.VisionCheckCdPO;
import net.danvi.dmall.biz.app.vision.model.VisionCheckContactPO;
import net.danvi.dmall.biz.app.vision.model.VisionCheckGlassesPO;
import net.danvi.dmall.biz.app.vision.model.VisionCheckResultVO;
import net.danvi.dmall.biz.app.vision.model.VisionGunVO;
import net.danvi.dmall.biz.app.vision.service.VisionCheckService;
import net.danvi.dmall.biz.system.security.DmallSessionDetails;
import net.danvi.dmall.biz.system.security.SessionDetailHelper;

/**
 * <pre>
 * - 프로젝트명    : 31.front.web
 * - 패키지명      : front.web.view.vision.controller
 * - 파일명        : VisionController.java
 * - 작성일        : 2019. 2. 18.
 * - 작성자        : yji
 * - 설명          : vision check 2 Controller
 * </pre>
 */
@Slf4j
@Controller
@RequestMapping("/front/vision2")
public class Vision2Controller {
	@Resource(name = "visionCheckService")
    private VisionCheckService visionCheckService;
	
	@Resource(name = "goodsManageService")
    private GoodsManageService goodsManageService;
    
	@RequestMapping(value = "/vision-check")
	public ModelAndView visionCheck(@Validated VisionCheckCdPO po, BindingResult bindingResult) throws Exception {
        ModelAndView mav = SiteUtil.getSkinView("/vision2/vision_check");
        
        DmallSessionDetails sessionInfo = SessionDetailHelper.getDetails();
        String birth = sessionInfo.getSession().getBirth();
        
        //나이 
        po.setGrpCd("VISION2_AGE_CD");
        po.setUserDefine1("G"); //안경렌즈
        List<VisionCheckCdPO> ageListG = visionCheckService.selectVisionCheckCD(po);
        mav.addObject("ageListG", ageListG);
        po.setUserDefine1("C"); //콘택트렌즈
        List<VisionCheckCdPO> ageListC = visionCheckService.selectVisionCheckCD(po);
        mav.addObject("ageListC", ageListC);
        
        String ageCdG = "";
        String ageCdC = "";
        
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
	        
	        
	        //안경렌즈
	        if(age <= 13){
	        	ageCdG = "01";
	        }else if(age >= 14 && age <= 42) {
	        	ageCdG = "02";
	        }else {
	        	ageCdG = "03";
	        }
	        
	        //콘택트 렌즈
	        if(age <= 19){
	        	ageCdC = "10";
	        }else if(age >= 20 && age <= 39) {
	        	ageCdC = "11";
	        }else {
	        	ageCdC = "12";
	        }
        }else{
        	ageCdG = "0" ;
        	ageCdC = "0" ;
        }
        
        mav.addObject("ageCdG", ageCdG);
    	mav.addObject("ageCdC", ageCdC);
        
        //렌즈타입
        String lensType = po.getLensType();
        if(StringUtils.isEmpty(lensType) || "".equals(lensType)){
        	lensType = "G";
        }
        
        
    	for(int i=0; i<ageListG.size(); i++) {
    		VisionCheckCdPO vPO = ageListG.get(i);
    		if(vPO.getCd().equals(ageCdG)) {
    			 mav.addObject("ageCdGNm", vPO.getCdNm());
    		}
    	}
    
    	for(int i=0; i<ageListC.size(); i++) {
    		VisionCheckCdPO vPO = ageListC.get(i);
    		if(vPO.getCd().equals(ageCdC)) {
    			 mav.addObject("ageCdCNm", vPO.getCdNm());
    		}
    	}
        
        mav.addObject("lensType", lensType);
        
        return mav;
	}
	
	/*안경렌즈*/	
	@RequestMapping(value = "/vision-check-g1")
	public ModelAndView visionCheckG1(@Validated VisionCheckGlassesPO po, BindingResult bindingResult) throws Exception {
        ModelAndView mav = SiteUtil.getSkinView("/vision2/vision_check_g1");
        
        VisionCheckCdPO cdPO = new VisionCheckCdPO();
        
        //착용여부
        cdPO.setGrpCd("VISION2_WEAR_CD");
        List<VisionCheckCdPO> wearList = visionCheckService.selectVisionCheckCD(cdPO);
        mav.addObject("wearList", wearList);
        
        if(wearList.size() > 0) {
        	cdPO = wearList.get(0);
        	po.setWearCd(cdPO.getCd());
        	po.setWearCdNm(cdPO.getCdNm());
        }
        
        mav.addObject("classesPO", po);
        return mav;        
	}
	
	@RequestMapping(value = "/vision-check-g2")
	public ModelAndView visionCheckG2(@Validated VisionCheckGlassesPO po, BindingResult bindingResult) throws Exception {
        ModelAndView mav = SiteUtil.getSkinView("/vision2/vision_check_g2");
        
        VisionCheckCdPO cdPO = new VisionCheckCdPO();
        
        //불편사항1
        cdPO.setGrpCd("VISION2_INCON1_G_CD");
        
        List<VisionCheckCdPO> incon1List = visionCheckService.selectVisionCheckCD(cdPO);
        mav.addObject("incon1List", incon1List);
        
        if(incon1List.size() > 0) {
        	if(po.getAgeCdG().equals("03")) {//43세 이상
	        	cdPO = incon1List.get(0);
	        	po.setIncon1Cd(cdPO.getCd());
	        	po.setIncon1CdNm(cdPO.getCdNm());
        	}else {//~13세, 14세~42세
        		cdPO = incon1List.get(1);
	        	po.setIncon1Cd(cdPO.getCd());
	        	po.setIncon1CdNm(cdPO.getCdNm());
        	}
        }
        
        mav.addObject("classesPO", po);
        return mav;        
	}
	
	@RequestMapping(value = "/vision-check-g3")
	public ModelAndView visionCheckG3(@Validated VisionCheckGlassesPO po, BindingResult bindingResult) throws Exception {
        ModelAndView mav = SiteUtil.getSkinView("/vision2/vision_check_g3");
        
        VisionCheckCdPO cdPO = new VisionCheckCdPO();
        
        //불편사항2
        cdPO.setGrpCd("VISION2_INCON2_G_CD");
        cdPO.setUserDefine1(po.getAgeCdG());
        
        List<VisionCheckCdPO> incon2List = visionCheckService.selectVisionCheckCD(cdPO);
        mav.addObject("incon2List", incon2List);
        
        if(incon2List.size() > 0) {
        	cdPO = incon2List.get(0);
        	po.setIncon2Cd(cdPO.getCd());
        	po.setIncon2CdNm(cdPO.getCdNm());
        }
        
        mav.addObject("classesPO", po);
        return mav;        
	}
	
	@RequestMapping(value = "/vision-check-g4")
	public ModelAndView visionCheckG4(@Validated VisionCheckGlassesPO po, BindingResult bindingResult) throws Exception {
        ModelAndView mav = SiteUtil.getSkinView("/vision2/vision_check_g4");
        
        VisionCheckCdPO cdPO = new VisionCheckCdPO();
        
        //라이프 스타일
        cdPO.setGrpCd("VISION2_LIFESTYLE_CD");
        cdPO.setUserDefine1(po.getAgeCdG());
        
        List<VisionCheckCdPO> lifestyleList = visionCheckService.selectVisionCheckCD(cdPO);
        mav.addObject("lifestyleList", lifestyleList);
        
        if(lifestyleList.size() > 0) {
        	cdPO = lifestyleList.get(0);
        	po.setLifestyleCd(cdPO.getCd());
        	po.setLifestyleCdNm(cdPO.getCdNm());
        }
        
        mav.addObject("classesPO", po);
        return mav;        
	}
	
	@RequestMapping(value = "/vision-check-gr")
	public ModelAndView visionCheckGr(@Validated VisionCheckGlassesPO po, BindingResult bindingResult) throws Exception {
        ModelAndView mav = SiteUtil.getSkinView("/vision2/vision_check_gr");
        
        VisionCheckCdPO cdPO = new VisionCheckCdPO();
        VisionCheckGlassesPO gPO = new VisionCheckGlassesPO();
        
        //라이프 스타일
        cdPO.setGrpCd("VISION2_LIFESTYLE_CD");        
        List<String> cdLifestyleArr = new ArrayList<>();
		String[] strTmp1 = po.getLifestyleCd().split(",");
		for(int i=0; i<strTmp1.length; i++){
			cdLifestyleArr.add(strTmp1[i]);
		}		
		cdPO.setCdArr(cdLifestyleArr);
		gPO.setLifestyleCdCdArr(cdLifestyleArr);
        
        List<VisionCheckCdPO> lifestyleList = visionCheckService.selectVisionCheckResult(cdPO);
        mav.addObject("lifestyleList", lifestyleList);
        
        //불편사항2
        cdPO.setGrpCd("VISION2_INCON2_G_CD");        
        List<String> cdIncon2Arr = new ArrayList<>();
		String[] strTmp2 = po.getIncon2Cd().split(",");
		for(int i=0; i<strTmp2.length; i++){
			cdIncon2Arr.add(strTmp2[i]);
		}		
		cdPO.setCdArr(cdIncon2Arr);
		gPO.setIncon2CdArr(cdIncon2Arr);
		
        List<VisionCheckCdPO> incon2List = visionCheckService.selectVisionCheckResult(cdPO);
        mav.addObject("incon2List", incon2List);
                
        //불편사항1(현재 착용중)
        if(po.getWearCd().equals("02")) {
	        cdPO.setGrpCd("VISION2_INCON1_G_CD");        
	        List<String> cdIncon1Arr = new ArrayList<>();
			String[] strTmp5 = po.getIncon1Cd().split(",");
			for(int i=0; i<strTmp5.length; i++){
				cdIncon1Arr.add(strTmp5[i]);
			}		
			cdPO.setCdArr(cdIncon1Arr);
	        
	        List<VisionCheckCdPO> incon1List = visionCheckService.selectVisionCheckResult(cdPO);
	        mav.addObject("incon1List", incon1List);
        }
        
        //권장검사
        VisionCheckCdPO rtPO = new VisionCheckCdPO();
        rtPO.setGrpCd("VISION2_RECOMM_TEST_GR_CD");
        
    	if("03".equals(po.getAgeCdG())) { //43세
    		rtPO.setUserDefine1("02"); 
    	}else {
    		rtPO.setUserDefine1("01"); //0~42세 or default
    	}
        
        List<String> cdArr = new ArrayList<>();
        for(int i=0;i<incon2List.size();i++) {
        	cdArr.add(incon2List.get(i).getUserDefine3());
        }
        rtPO.setUserDefine2Arr(cdArr);
		
        List<VisionCheckCdPO> recommTestList = visionCheckService.selectVisionCheckRecommTestGr(rtPO);
        mav.addObject("recommTestList", recommTestList);
        
        //눈운동
        VisionCheckCdPO emPO = new VisionCheckCdPO();
        emPO.setGrpCd("VISION2_EYE_MVMT_GR_CD");
        emPO.setUserDefine1(po.getAgeCdG());	//연령대
        emPO.setUserDefine2Arr(cdArr);	//불편사항
		
        List<VisionCheckCdPO> eyeMovementList = visionCheckService.selectVisionCheckRecommTestGr(emPO);
        mav.addObject("eyeMovementList", eyeMovementList);
        
        //눈운동 멘트
        List<VisionCheckCdPO> recommCmntList = visionCheckService.selectVisionCheckRecommCmntGr(emPO);
        mav.addObject("recommCmntList", recommCmntList);
        
        
        // 조회할 회원정보 set
        DmallSessionDetails sessionInfo = SessionDetailHelper.getDetails();       
        mav.addObject("userNo", sessionInfo.getSession().getMemberNo());    
        mav.addObject("userName", sessionInfo.getSession().getMemberNm());
                
        gPO.setAgeCdG(po.getAgeCdG());
        List<VisionGunVO> visionGunList =  visionCheckService.selectVisionCheckGunInGlasses(gPO);
        mav.addObject("visionGunList", visionGunList);
        
        // 군에 속한 상품목록 가져오기
        ResultListModel<GoodsVO> gunGoodsList = new ResultListModel<GoodsVO>();
        GoodsSO gso = new GoodsSO();
        gso.setSiteNo(sessionInfo.getSiteNo());// 사이트번호셋팅
        String goodsDisplay[] = { "Y" }; // 전시여부
        gso.setGoodsDisplay(goodsDisplay);
        gso.setSaleYn("Y");
        String gunNo = "";
        
        for (int j=0;j<visionGunList.size();j++) {
        	gunNo = String.valueOf(visionGunList.get(j).getGunNo());
        	gso.setGunNo(gunNo);
        	gunGoodsList = goodsManageService.selectGoodsList(gso);
        	mav.addObject("gunGoodsList_"+gunNo, gunGoodsList.getResultList());
		}
        
        mav.addObject("classesPO", po);
        
        return mav;        
	}
	
	
    
    /*컨택트렌즈*/
    @RequestMapping(value = "/vision-check-c1")
	public ModelAndView visionCheckC1(@Validated VisionCheckContactPO po, BindingResult bindingResult) throws Exception {
        ModelAndView mav = SiteUtil.getSkinView("/vision2/vision_check_c1");
        
        VisionCheckCdPO cdPO = new VisionCheckCdPO();
        
        //착용여부
        cdPO.setGrpCd("VISION2_WEAR_CD");
        List<VisionCheckCdPO> wearList = visionCheckService.selectVisionCheckCD(cdPO);
        mav.addObject("wearList", wearList);
        
        if(wearList.size() > 0) {
        	cdPO = wearList.get(0);
        	po.setWearCd(cdPO.getCd());
        	po.setWearCdNm(cdPO.getCdNm());
        }
        
        mav.addObject("classesPO", po);
        return mav;        
	}
    
    @RequestMapping(value = "/vision-check-c2")
	public ModelAndView visionCheckC2(@Validated VisionCheckContactPO po, BindingResult bindingResult) throws Exception {
        ModelAndView mav = SiteUtil.getSkinView("/vision2/vision_check_c2");
        
        VisionCheckCdPO cdPO = new VisionCheckCdPO();
        
        //투명/컬러
        cdPO.setGrpCd("VISION2_CONTACT_TYPE_CD");
        List<VisionCheckCdPO> typeList = visionCheckService.selectVisionCheckCD(cdPO);
        mav.addObject("typeList", typeList);
        
        if(typeList.size() > 0) {
        	cdPO = typeList.get(0);
        	po.setContactTypeCd(cdPO.getCd());
        	po.setContactTypeCdNm(cdPO.getCdNm());
        }
        
        mav.addObject("classesPO", po);
        return mav;        
	}
    
    @RequestMapping(value = "/vision-check-c3")
	public ModelAndView visionCheckC3(@Validated VisionCheckContactPO po, BindingResult bindingResult) throws Exception {
        ModelAndView mav = SiteUtil.getSkinView("/vision2/vision_check_c3");
        
        VisionCheckCdPO cdPO = new VisionCheckCdPO();
        
        //렌즈착용 시간
        cdPO.setGrpCd("VISION2_WEAR_TIME_CD");
        List<VisionCheckCdPO> timeList = visionCheckService.selectVisionCheckCD(cdPO);
        mav.addObject("timeList", timeList);
        
        if(timeList.size() > 0) {
        	cdPO = timeList.get(0);
        	po.setWearTimeCd(cdPO.getCd());
        	po.setWearTimeCdNm(cdPO.getCdNm());
        }
        
        //렌즈착용 일수
        cdPO.setGrpCd("VISION2_WEAR_DAY_CD");
        List<VisionCheckCdPO> dayList = visionCheckService.selectVisionCheckCD(cdPO);
        mav.addObject("dayList", dayList);
        
        if(dayList.size() > 0) {
        	cdPO = dayList.get(0);
        	po.setWearDayCd(cdPO.getCd());
        	po.setWearDayCdNm(cdPO.getCdNm());
        }        
        
        mav.addObject("classesPO", po);
        return mav;        
	}
    
    @RequestMapping(value = "/vision-check-c4")
	public ModelAndView visionCheckC4(@Validated VisionCheckContactPO po, BindingResult bindingResult) throws Exception {
        ModelAndView mav = SiteUtil.getSkinView("/vision2/vision_check_c4");
        
        VisionCheckCdPO cdPO = new VisionCheckCdPO();
        
        //불편사항1(처음착용/착용중)
        cdPO.setGrpCd("VISION2_INCON1_C_CD");
        cdPO.setUserDefine1(po.getWearCd());
        List<VisionCheckCdPO> incon1List = visionCheckService.selectVisionCheckCD(cdPO);
        mav.addObject("incon1List", incon1List);
        
        if(incon1List.size() > 0) {
        	cdPO = incon1List.get(0);
        	po.setIncon1Cd(cdPO.getCd());
        	po.setIncon1CdNm(cdPO.getCdNm());
        }
        
        mav.addObject("classesPO", po);
        return mav;        
	}
    
    @RequestMapping(value = "/vision-check-c5")
	public ModelAndView visionCheckC5(@Validated VisionCheckContactPO po, BindingResult bindingResult) throws Exception {
        ModelAndView mav = SiteUtil.getSkinView("/vision2/vision_check_c5");
        
        VisionCheckCdPO cdPO = new VisionCheckCdPO();
        
        //착용 목적
        cdPO.setGrpCd("VISION2_CONTACT_PURP_CD");
        List<VisionCheckCdPO> purpList = visionCheckService.selectVisionCheckCD(cdPO);
        mav.addObject("purpList", purpList);
        
        if(purpList.size() > 0) {
        	cdPO = purpList.get(0);
        	po.setContactPurpCd(cdPO.getCd());
        	po.setContactPurpCdNm(cdPO.getCdNm());
        }
        
        mav.addObject("classesPO", po);
        return mav;        
	}
    
    @RequestMapping(value = "/vision-check-c6")
	public ModelAndView visionCheckC6(@Validated VisionCheckContactPO po, BindingResult bindingResult) throws Exception {
        ModelAndView mav = SiteUtil.getSkinView("/vision2/vision_check_c6");
        
        VisionCheckCdPO cdPO = new VisionCheckCdPO();
        
        //눈 불편 사항 2(현재 작용중 => 투명/컬러)
        cdPO.setGrpCd("VISION2_INCON2_C_CD");
        cdPO.setUserDefine1(po.getContactTypeCd());
        List<VisionCheckCdPO> incon2List = visionCheckService.selectVisionCheckCD(cdPO);
        mav.addObject("incon2List", incon2List);
        
        if(incon2List.size() > 0) {
        	cdPO = incon2List.get(0);
        	po.setIncon2Cd(cdPO.getCd());
        	po.setIncon2CdNm(cdPO.getCdNm());
        }
        
        mav.addObject("classesPO", po);
        return mav;        
	}
    
    @RequestMapping(value = "/vision-check-cr")
	public ModelAndView visionCheckCr(@Validated VisionCheckContactPO po, BindingResult bindingResult) throws Exception {
        ModelAndView mav = SiteUtil.getSkinView("/vision2/vision_check_cr");
        
        VisionCheckCdPO cdPO = new VisionCheckCdPO();
        VisionCheckContactPO cPO = new VisionCheckContactPO();
        
        //착용 목적
        cdPO.setGrpCd("VISION2_CONTACT_PURP_CD");        
        List<String> cdPurpArr = new ArrayList<>();
		String[] strTmp1 = po.getContactPurpCd().split(",");
		for(int i=0; i<strTmp1.length; i++){
			cdPurpArr.add(strTmp1[i]);
		}		
		cdPO.setCdArr(cdPurpArr);        
        List<VisionCheckCdPO> purpList = visionCheckService.selectVisionCheckResult(cdPO);
        mav.addObject("purpList", purpList);
        
        //붚련사항1
        cdPO.setGrpCd("VISION2_INCON1_C_CD");      
        cdPO.setUserDefine1(po.getWearCd());
        List<String> cdIncon1Arr = new ArrayList<>();
		String[] strTmp5 = po.getIncon1Cd().split(",");
		for(int i=0; i<strTmp5.length; i++){
			cdIncon1Arr.add(strTmp5[i]);
		}		
		cdPO.setCdArr(cdIncon1Arr);
		cPO.setIncon1CdArr(cdIncon1Arr);
        
        List<VisionCheckCdPO> incon1List = visionCheckService.selectVisionCheckResult(cdPO);
        mav.addObject("incon1List", incon1List);
        
        //붚련사항2(현재 착용중)
        if(po.getWearCd().equals("02")) {
        	cdPO.setGrpCd("VISION2_INCON2_C_CD");        
        	List<String> cdIncon2Arr = new ArrayList<>();        
			String[] strTmp2 = po.getIncon2Cd().split(",");
			for(int i=0; i<strTmp2.length; i++){
				cdIncon2Arr.add(strTmp2[i]);
			}		
			cdPO.setCdArr(cdIncon2Arr);
			
	        List<VisionCheckCdPO> incon2List = visionCheckService.selectVisionCheckResult(cdPO);
	        mav.addObject("incon2List", incon2List);        
        }
        
        //권장검사
        VisionCheckCdPO rtPO = new VisionCheckCdPO();
        rtPO.setGrpCd("VISION2_RECOMM_TEST_CR_CD");
        
        List<String> cdArr = new ArrayList<>();
        for(int i=0;i<incon1List.size();i++) {
        	cdArr.add(incon1List.get(i).getUserDefine3());
        }
        rtPO.setUserDefine1Arr(cdArr);
		
        List<VisionCheckCdPO> recommTestList = visionCheckService.selectVisionCheckRecommTestCr(rtPO);
        mav.addObject("recommTestList", recommTestList);
        
        // 조회할 회원정보 set
        DmallSessionDetails sessionInfo = SessionDetailHelper.getDetails();       
        mav.addObject("userNo", sessionInfo.getSession().getMemberNo());    
        mav.addObject("userName", sessionInfo.getSession().getMemberNm());
        
        cPO.setAgeCdC(po.getAgeCdC());
        cPO.setWearCd(po.getWearCd());
        cPO.setWearTimeCd(po.getWearTimeCd());
        cPO.setWearDayCd(po.getWearDayCd());
        List<VisionGunVO> visionGunList =  visionCheckService.selectVisionCheckGunInContact(cPO);
        mav.addObject("visionGunList", visionGunList);

        // 군에 속한 상품목록 가져오기
        ResultListModel<GoodsVO> gunGoodsList = new ResultListModel<GoodsVO>();
        GoodsSO gso = new GoodsSO();
        gso.setSiteNo(sessionInfo.getSiteNo());// 사이트번호셋팅
        String goodsDisplay[] = { "Y" }; // 전시여부
        gso.setGoodsDisplay(goodsDisplay);
        gso.setSaleYn("Y");
        String gunNo = "";

        for (int j=0;j<visionGunList.size();j++) {
        	gunNo = String.valueOf(visionGunList.get(j).getGunNo());
        	gso.setGunNo(gunNo);
        	gunGoodsList = goodsManageService.selectGoodsList(gso);
        	mav.addObject("gunGoodsList_"+gunNo, gunGoodsList.getResultList());
		}
        
        mav.addObject("classesPO", po);
        
        return mav;        
	}
    
    /**
     * <pre>
     * 작성일 : 2019.02.07
     * 작성자 : yang ji
     * 설명   : 비전체크 군 정보 이미지
     * </pre>
     *
     * @return
     */
    @RequestMapping("/vision-check-gun-img")
    public void visionCheckGunInfo(@Validated VisionGunVO vo, BindingResult bindingResult, HttpServletResponse response) throws Exception {
    	response.setContentType("text/xml");
		response.setCharacterEncoding("UTF-8");
		StringBuffer retXML = new StringBuffer(1024);
		retXML.append("<?xml version='1.0' encoding='UTF-8'?>");				
		retXML.append("<items>");
		
		try {
			List<AtchFileVO> imgArr = visionCheckService.selectVisionCheckGunImage(Integer.parseInt(vo.getLettNo()));
			for(int i=0; i<imgArr.size(); i++) {
				AtchFileVO afVO = imgArr.get(i);
				retXML.append("		<att_img>");
				retXML.append("			<file_no>"+afVO.getFileNo()+"</file_no>");
				retXML.append("			<org_file_nm>"+afVO.getOrgFileNm()+"</org_file_nm>");	
				retXML.append("			<img_yn>"+afVO.getImgYn()+"</img_yn>");	
				retXML.append("			<file_path>"+afVO.getFilePath()+"</file_path>");
				retXML.append("			<file_name>"+afVO.getFileNm()+"</file_name>");		
				retXML.append("		</att_img>");					
			}
		}catch(Exception e) {
			e.printStackTrace();
		}
		
		retXML.append("</items>");
		response.getWriter().println(retXML.toString());
    }

    /*비전체크 결과 저장*/
    @RequestMapping(value = "/vision-check-insert")
	public void visionCheckInsert(@Validated VisionCheckResultVO vo, BindingResult bindingResult, HttpServletResponse response) throws Exception {
		// 조회할 회원정보 set
        DmallSessionDetails sessionInfo = SessionDetailHelper.getDetails();        
        vo.setMemberNo(sessionInfo.getSession().getMemberNo());
        vo.setRegrNo(sessionInfo.getSession().getMemberNo());
        
        //기존 정보 삭제
        visionCheckService.deleteVisionCheckResult(vo);
        visionCheckService.insertVisionCheckResult(vo);
        
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
    
    @RequestMapping(value = "/my-vision-check-g")
	public ModelAndView myVisionCheckG(@Validated VisionCheckGlassesPO po, BindingResult bindingResult) throws Exception {
        ModelAndView mav = SiteUtil.getSkinView("/mypage/vision_check_g_list");
        
        po.setLensType("G");
        
        // 조회할 회원정보 set
        DmallSessionDetails sessionInfo = SessionDetailHelper.getDetails();        
        mav.addObject("userName", sessionInfo.getSession().getMemberNm());
        
        VisionCheckResultVO vo = new VisionCheckResultVO();
        vo.setLensType("G");
        vo.setMemberNo(sessionInfo.getSession().getMemberNo());
        vo = visionCheckService.selectVisionCheck2Result(vo);       
        
        mav.addObject("resultVO", vo);
        
        if(vo != null) {        
	        VisionCheckCdPO cdPO = new VisionCheckCdPO();
	        VisionCheckGlassesPO gPO = new VisionCheckGlassesPO();
	        
	        //라이프 스타일
	        cdPO.setGrpCd("VISION2_LIFESTYLE_CD");        
	        List<String> cdLifestyleArr = new ArrayList<>();
			String[] strTmp1 = vo.getLifestyleCd().split(",");
			for(int i=0; i<strTmp1.length; i++){
				cdLifestyleArr.add(strTmp1[i]);
			}		
			cdPO.setCdArr(cdLifestyleArr);
			gPO.setLifestyleCdCdArr(cdLifestyleArr);
	        
	        List<VisionCheckCdPO> lifestyleList = visionCheckService.selectVisionCheckResult(cdPO);
	        mav.addObject("lifestyleList", lifestyleList);
	
	        String strLifestyleCdNm = "";
	        for(int i=0; i<lifestyleList.size(); i++) {
	        	VisionCheckCdPO tmpVO = lifestyleList.get(i);
	        	strLifestyleCdNm += tmpVO.getCdNm();
	        	if(i<lifestyleList.size()-1) strLifestyleCdNm += ", ";
	        }
	        
	        po.setLifestyleCdNm(strLifestyleCdNm);
	        
	        //붚련사항2
	        cdPO.setGrpCd("VISION2_INCON2_G_CD");        
	        List<String> cdIncon2Arr = new ArrayList<>();
			String[] strTmp2 = vo.getIncon2Cd().split(",");
			for(int i=0; i<strTmp2.length; i++){
				cdIncon2Arr.add(strTmp2[i]);
			}		
			cdPO.setCdArr(cdIncon2Arr);
			gPO.setIncon2CdArr(cdIncon2Arr);
			
	        List<VisionCheckCdPO> incon2List = visionCheckService.selectVisionCheckResult(cdPO);
	        mav.addObject("incon2List", incon2List);
	                
	        //붚련사항1(현재 착용중)
	        if(vo.getWearCd().equals("02")) {
		        cdPO.setGrpCd("VISION2_INCON1_G_CD");        
		        List<String> cdIncon1Arr = new ArrayList<>();
				String[] strTmp5 = vo.getIncon1Cd().split(",");
				for(int i=0; i<strTmp5.length; i++){
					cdIncon1Arr.add(strTmp5[i]);
				}		
				cdPO.setCdArr(cdIncon1Arr);
		        
		        List<VisionCheckCdPO> incon1List = visionCheckService.selectVisionCheckResult(cdPO);
		        mav.addObject("incon1List", incon1List);
	        }
	        
	        //나이
	        cdPO.setGrpCd("VISION2_AGE_CD");      
	        List<String> ageCdGArr = new ArrayList<>();
	        ageCdGArr.add(vo.getAgeCd());
	        cdPO.setCdArr(ageCdGArr);
	        List<VisionCheckCdPO> ageCdGList = visionCheckService.selectVisionCheckResult(cdPO);
	        VisionCheckCdPO agpo = ageCdGList.get(0);
	        po.setAgeCdG(agpo.getCd());
	        po.setAgeCdGNm(agpo.getCdNm());
	        
	        //처음착용/착용중
	        cdPO.setGrpCd("VISION2_WEAR_CD");      
	        List<String> wearCdGArr = new ArrayList<>();
	        wearCdGArr.add(vo.getWearCd());
	        cdPO.setCdArr(wearCdGArr);
	        List<VisionCheckCdPO> wearCdGList = visionCheckService.selectVisionCheckResult(cdPO);
	        VisionCheckCdPO wearpo = wearCdGList.get(0);        
	        po.setWearCd(wearpo.getCd());
	        po.setWearCdNm(wearpo.getCdNm());
	        
	        //군 목록
	        gPO.setAgeCdG(vo.getAgeCd());
	        List<VisionGunVO> visionGunList =  visionCheckService.selectVisionCheckGunInGlasses(gPO);
	        mav.addObject("visionGunList", visionGunList);
	        
	        // 군에 속한 상품목록 가져오기
	        ResultListModel<GoodsVO> gunGoodsList = new ResultListModel<GoodsVO>();
	        GoodsSO gso = new GoodsSO();
	        gso.setSiteNo(sessionInfo.getSiteNo());// 사이트번호셋팅
	        String gunNo = "";

	        for (int j=0;j<visionGunList.size();j++) {
	        	gunNo = String.valueOf(visionGunList.get(j).getGunNo());
	        	gso.setGunNo(gunNo);
	        	gunGoodsList = goodsManageService.selectGoodsList(gso);
	        	mav.addObject("gunGoodsList_"+gunNo, gunGoodsList.getResultList());
			}
        }
        
        mav.addObject("classesPO", po);
        mav.addObject("leftMenu", "my-vision-check-g");
        
        return mav;
    }
    
    @RequestMapping(value = "/my-vision-check-c")
	public ModelAndView myVisionCheckC(@Validated VisionCheckContactPO po, BindingResult bindingResult) throws Exception {
        ModelAndView mav = SiteUtil.getSkinView("/mypage/vision_check_c_list");
        
        po.setLensType("C");
        
        // 조회할 회원정보 set
        DmallSessionDetails sessionInfo = SessionDetailHelper.getDetails();        
        mav.addObject("userName", sessionInfo.getSession().getMemberNm());
        
        VisionCheckResultVO vo = new VisionCheckResultVO();
        vo.setLensType("C");
        vo.setMemberNo(sessionInfo.getSession().getMemberNo());
        vo = visionCheckService.selectVisionCheck2Result(vo);       
        
        mav.addObject("resultVO", vo);
        
        if(vo != null) { 
	        VisionCheckCdPO cdPO = new VisionCheckCdPO();
	        VisionCheckContactPO cPO = new VisionCheckContactPO();
	        
	        //착용 목적
	        cdPO.setGrpCd("VISION2_CONTACT_PURP_CD");        
	        List<String> cdPurpArr = new ArrayList<>();
			String[] strTmp1 = vo.getContactPurpCd().split(",");
			for(int i=0; i<strTmp1.length; i++){
				cdPurpArr.add(strTmp1[i]);
			}		
			cdPO.setCdArr(cdPurpArr);        
	        List<VisionCheckCdPO> purpList = visionCheckService.selectVisionCheckResult(cdPO);
	        mav.addObject("purpList", purpList);
	        
	        //붚련사항1
	        cdPO.setGrpCd("VISION2_INCON1_C_CD");      
	        cdPO.setUserDefine1(po.getWearCd());
	        List<String> cdIncon1Arr = new ArrayList<>();
			String[] strTmp5 = vo.getIncon1Cd().split(",");
			for(int i=0; i<strTmp5.length; i++){
				cdIncon1Arr.add(strTmp5[i]);
			}		
			cdPO.setCdArr(cdIncon1Arr);
			cPO.setIncon1CdArr(cdIncon1Arr);
	        
	        List<VisionCheckCdPO> incon1List = visionCheckService.selectVisionCheckResult(cdPO);
	        mav.addObject("incon1List", incon1List);
	        
	        String strincon1Nm = "";
	        for(int i=0; i<incon1List.size(); i++) {
	        	VisionCheckCdPO tmpVO = incon1List.get(i);
	        	strincon1Nm += tmpVO.getCdNm();
	        	if(i<incon1List.size()-1) strincon1Nm += ", ";
	        }        
	        po.setIncon1CdNm(strincon1Nm);
	        
	        //붚련사항2(현재 착용중)
	        if(vo.getWearCd().equals("02")) {
	        	cdPO.setGrpCd("VISION2_INCON2_C_CD");        
	        	List<String> cdIncon2Arr = new ArrayList<>();        
				String[] strTmp2 = vo.getIncon2Cd().split(",");
				for(int i=0; i<strTmp2.length; i++){
					cdIncon2Arr.add(strTmp2[i]);
				}		
				cdPO.setCdArr(cdIncon2Arr);
				
		        List<VisionCheckCdPO> incon2List = visionCheckService.selectVisionCheckResult(cdPO);
		        mav.addObject("incon2List", incon2List);       
		        
		        String strincon2Nm = "";
		        for(int i=0; i<incon2List.size(); i++) {
		        	VisionCheckCdPO tmpVO = incon2List.get(i);
		        	strincon2Nm += tmpVO.getCdNm();
		        	if(i<incon2List.size()-1) strincon2Nm += ", ";
		        }        
		        po.setIncon2CdNm(strincon2Nm);
	        }
	        
	        //나이
	        cdPO.setGrpCd("VISION2_AGE_CD");      
	        List<String> ageCdGArr = new ArrayList<>();
	        ageCdGArr.add(vo.getAgeCd());
	        cdPO.setCdArr(ageCdGArr);
	        List<VisionCheckCdPO> ageCdGList = visionCheckService.selectVisionCheckResult(cdPO);
	        VisionCheckCdPO agpo = ageCdGList.get(0);
	        po.setAgeCdC(agpo.getCd());
	        po.setAgeCdCNm(agpo.getCdNm());
	        
	        //처음착용/착용중
	        cdPO.setGrpCd("VISION2_WEAR_CD");      
	        List<String> wearCdGArr = new ArrayList<>();
	        wearCdGArr.add(vo.getWearCd());
	        cdPO.setCdArr(wearCdGArr);
	        List<VisionCheckCdPO> wearCdGList = visionCheckService.selectVisionCheckResult(cdPO);
	        VisionCheckCdPO wearpo = wearCdGList.get(0);
	        po.setWearCd(wearpo.getCd());
	        po.setWearCdNm(wearpo.getCdNm());
	        
	        //투명/컬러
	        cdPO.setGrpCd("VISION2_CONTACT_TYPE_CD");      
	        List<String> typeCdGArr = new ArrayList<>();
	        typeCdGArr.add(vo.getContactTypeCd());
	        cdPO.setCdArr(typeCdGArr);
	        List<VisionCheckCdPO> typeCdGList = visionCheckService.selectVisionCheckResult(cdPO);
	        VisionCheckCdPO typepo = typeCdGList.get(0);
	        po.setContactTypeCd(typepo.getCd());
	        po.setContactTypeCdNm(typepo.getCdNm());
	        
	        //착용시간
	        cdPO.setGrpCd("VISION2_WEAR_TIME_CD");      
	        List<String> timeCdGArr = new ArrayList<>();
	        timeCdGArr.add(vo.getWearTimeCd());
	        cdPO.setCdArr(timeCdGArr);
	        List<VisionCheckCdPO> wearTimeList = visionCheckService.selectVisionCheckResult(cdPO);
	        VisionCheckCdPO timepo = wearTimeList.get(0);
	        po.setWearTimeCd(timepo.getCd());
	        po.setWearTimeCdNm(timepo.getCdNm());
	        
	        //착용일
	        cdPO.setGrpCd("VISION2_WEAR_DAY_CD");      
	        List<String> dayCdGArr = new ArrayList<>();
	        dayCdGArr.add(vo.getWearDayCd());
	        cdPO.setCdArr(dayCdGArr);
	        List<VisionCheckCdPO> wearDayList = visionCheckService.selectVisionCheckResult(cdPO);
	        VisionCheckCdPO daypo = wearDayList.get(0);
	        po.setWearDayCd(daypo.getCd());
	        po.setWearDayCdNm(daypo.getCdNm());
	        
	        //군 목록
	        cPO.setAgeCdC(vo.getAgeCd());
	        cPO.setWearCd(vo.getWearCd());
	        cPO.setWearTimeCd(vo.getWearTimeCd());
	        cPO.setWearDayCd(vo.getWearDayCd());
	        List<VisionGunVO> visionGunList =  visionCheckService.selectVisionCheckGunInContact(cPO);
	        mav.addObject("visionGunList", visionGunList);
	     
	        // 군에 속한 상품목록 가져오기
	        ResultListModel<GoodsVO> gunGoodsList = new ResultListModel<GoodsVO>();
	        GoodsSO gso = new GoodsSO();
	        gso.setSiteNo(sessionInfo.getSiteNo());// 사이트번호셋팅
	        String gunNo = "";

	        for (int j=0;j<visionGunList.size();j++) {
	        	gunNo = String.valueOf(visionGunList.get(j).getGunNo());
	        	gso.setGunNo(gunNo);
	        	gunGoodsList = goodsManageService.selectGoodsList(gso);
	        	mav.addObject("gunGoodsList_"+gunNo, gunGoodsList.getResultList());
			}
        }
        
        mav.addObject("classesPO", po);
        mav.addObject("leftMenu", "my-vision-check-c");
        
        return mav;
    }

}
