package net.danvi.dmall.front.web.view.hearingaid.controller;

import java.util.ArrayList;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.StringUtils;
import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import dmall.framework.common.util.SiteUtil;
import lombok.extern.slf4j.Slf4j;
import net.danvi.dmall.biz.app.hearingaid.model.HearingaidCheckVO;
import net.danvi.dmall.biz.app.hearingaid.model.HearingaidStep1VO;
import net.danvi.dmall.biz.app.hearingaid.model.HearingaidVO;
import net.danvi.dmall.biz.app.hearingaid.service.HearingaidService;
import net.danvi.dmall.biz.system.security.DmallSessionDetails;
import net.danvi.dmall.biz.system.security.SessionDetailHelper;

/**
 * <pre>
 * - 프로젝트명    : 31.front.web
 * - 패키지명      : front.web.view.hearingaid.controller
 * - 파일명        : HearingaidController.java
 * - 작성일        : 2019. 1. 8.
 * - 작성자        : yji
 * - 설명          : hearing aid Controller
 * </pre>
 */
@Slf4j
@Controller
@RequestMapping("/front/hearingaid")
public class HearingaidController {
	@Resource(name = "hearingaidService")
    private HearingaidService hearingaidService;
	
	@RequestMapping(value = "/hearingaid-check")
	public ModelAndView hearingaidCheck(@Validated HearingaidVO vo, BindingResult bindingResult) throws Exception {
		ModelAndView mav = SiteUtil.getSkinView("/hearingaid/hearingaid_check");
		
		String haUse = vo.getHaUse();
		
		if(StringUtils.isEmpty(haUse) || "".equals(haUse)){
			haUse = "N";
        }
		
		mav.addObject("haUse", haUse);
		return mav;
	}
	
	@RequestMapping(value = "/hearingaid-check-s1")
	public ModelAndView hearingaidCheckS1(@Validated HearingaidVO vo, BindingResult bindingResult) throws Exception {
		ModelAndView mav = SiteUtil.getSkinView("/hearingaid/hearingaid_check_s1");
		
		String haUse = vo.getHaUse();
		
		if(StringUtils.isEmpty(haUse) || "".equals(haUse)){
			vo.setHaUse("N");
        }
		
		HearingaidStep1VO hearingaidStep1VO = new HearingaidStep1VO();
		hearingaidStep1VO.setGrpCd("HEARINGAID_STEP1_CD");
		hearingaidStep1VO.setUserDefine1(vo.getHaUse());
		List<HearingaidStep1VO> hearingaidStep1 = hearingaidService.selectHearingaidStep1(hearingaidStep1VO);
		mav.addObject("hearingaidStep1", hearingaidStep1);
		mav.addObject("hearingaidVO", vo);
		return mav;
	}
	
	@RequestMapping(value = "/hearingaid-check-s2")
	public ModelAndView hearingaidCheckS2(@Validated HearingaidVO vo, BindingResult bindingResult) throws Exception {
		ModelAndView mav = SiteUtil.getSkinView("/hearingaid/hearingaid_check_s2");
		
		String haUse = vo.getHaUse();
		
		if(StringUtils.isEmpty(haUse) || "".equals(haUse)){
			vo.setHaUse("N");
        }
		
		HearingaidStep1VO hearingaidStep1VO = new HearingaidStep1VO();
		hearingaidStep1VO.setGrpCd("HEARINGAID_STEP2_CD");
		List<HearingaidStep1VO> hearingaidStep2 = hearingaidService.selectHearingaidStep1(hearingaidStep1VO);
		mav.addObject("hearingaidStep2", hearingaidStep2);
		
		mav.addObject("hearingaidVO", vo);
		return mav;
	}
	
	@RequestMapping(value = "/hearingaid-check-s3")
	public ModelAndView hearingaidCheckS3(@Validated HearingaidVO vo, BindingResult bindingResult) throws Exception {
		ModelAndView mav = SiteUtil.getSkinView("/hearingaid/hearingaid_check_s3");
		
		String haUse = vo.getHaUse();
		
		if(StringUtils.isEmpty(haUse) || "".equals(haUse)){
			vo.setHaUse("N");
        }
		
		HearingaidStep1VO hearingaidStep1VO = new HearingaidStep1VO();
		hearingaidStep1VO.setGrpCd("HEARINGAID_STEP3_CD");
		List<HearingaidStep1VO> hearingaidStep3 = hearingaidService.selectHearingaidStep1(hearingaidStep1VO);
		mav.addObject("hearingaidStep3", hearingaidStep3);
		
		mav.addObject("hearingaidVO", vo);
		return mav;
	}
	
	@RequestMapping(value = "/hearingaid-recommend")
	public ModelAndView hearingaidRecommend(@Validated HearingaidVO vo, BindingResult bindingResult) throws Exception {
		ModelAndView mav = SiteUtil.getSkinView("/hearingaid/hearingaid_recommend");
		
		// 조회할 회원정보 set
        DmallSessionDetails sessionInfo = SessionDetailHelper.getDetails();       
        mav.addObject("userNo", sessionInfo.getSession().getMemberNo());    
        mav.addObject("userName", sessionInfo.getSession().getMemberNm());
		
		String haUse = vo.getHaUse();
		
		if(StringUtils.isEmpty(haUse) || "".equals(haUse)){
			vo.setHaUse("N");
        }
		
		HearingaidStep1VO hearingaidStep1VO = new HearingaidStep1VO();
		hearingaidStep1VO.setGrpCd("HEARINGAID_STEP1_CD");	
		
		if(vo.getStep1Cd().length() > 0) {
			hearingaidStep1VO.setStepCd("'" + vo.getStep1Cd().replaceAll(",", "','") + "'");
			List<HearingaidStep1VO> hearingaidStep1 = hearingaidService.selectHearingaidStep1(hearingaidStep1VO);
			mav.addObject("hearingaidStep1", hearingaidStep1);
		}
		
		String strStepCds = "";
		
		if(vo.getStep1CdFlg().length() > 0) strStepCds += vo.getStep1CdFlg();
		if(strStepCds.length() > 0) {
			if(vo.getStep1CdFlg().length() > 0)	strStepCds +=  "," + vo.getStep2CdFlg();
		}		
		
		if(vo.getStep3CdFlg() !=  null) {
			if(!vo.getStep3CdFlg().trim().equals("")) {
				if(strStepCds.length() > 0) {
					strStepCds += "," + vo.getStep3CdFlg();
				}else {
					strStepCds += vo.getStep3CdFlg();
				}
			}
		}		
		
		List<Integer> hearingaidCdMap = new ArrayList<>();
		String[] strTmp = strStepCds.split(",");
		for(int i=0; i<strTmp.length; i++){
			hearingaidCdMap.add(Integer.parseInt(strTmp[i]));
		}
		
		vo.setHearingaidCdMap(hearingaidCdMap);
		List<HearingaidVO> hearingaidRecommend = hearingaidService.selectHearingaidRecommend(vo);
		mav.addObject("hearingaidRecommend", hearingaidRecommend);
		mav.addObject("hearingaidVO", vo);
		return mav;
	}
	
	@RequestMapping(value = "/hearingaid-check-insert")
	public void hearingaidCheckInsert(@Validated HearingaidCheckVO vo, BindingResult bindingResult, HttpServletResponse response) throws Exception {
		// 조회할 회원정보 set
		DmallSessionDetails sessionInfo = SessionDetailHelper.getDetails();        
        vo.setMemberNo(sessionInfo.getSession().getMemberNo());
        
        //기존 정보 삭제
        hearingaidService.deleteHearingaidCheck(vo);
        
        if(vo.getGoodsNos().indexOf(",") > 0) {
        	String[] goodsNos = vo.getGoodsNos().split(",");
        	String[] goodsNms = vo.getGoodsNms().split(",");
        	for(int i=0; i<goodsNos.length; i++) {
        		vo.setGoodsNo(goodsNos[i]);
        		vo.setGoodsNm(goodsNms[i]);
        		hearingaidService.insertHearingaidCheck(vo);
        	}
        }else {
        	vo.setGoodsNo(vo.getGoodsNos());
    		vo.setGoodsNm(vo.getGoodsNms());
        	hearingaidService.insertHearingaidCheck(vo);
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
	
	@RequestMapping(value = "/my-hearingaid-check")
	public ModelAndView myHearingaidCheck(@Validated HearingaidCheckVO vo, BindingResult bindingResult) throws Exception {
		ModelAndView mav = SiteUtil.getSkinView("/mypage/hearingaid_check_list");
		// 조회할 회원정보 set
        DmallSessionDetails sessionInfo = SessionDetailHelper.getDetails();
        mav.addObject("userName", sessionInfo.getSession().getMemberNm());
        
        HearingaidCheckVO hearingaidCheckVO = new HearingaidCheckVO();
        hearingaidCheckVO.setMemberNo(sessionInfo.getSession().getMemberNo());
        
        List<HearingaidCheckVO> hearingaidCheckList  = hearingaidService.selectHearingaidCheckList(hearingaidCheckVO);
        
        if(hearingaidCheckList != null && hearingaidCheckList.size() > 0) {
	        HearingaidCheckVO topHearingaidCheckVO = hearingaidCheckList.get(0);
	        mav.addObject("topHearingaidCheckVO", topHearingaidCheckVO);
	        mav.addObject("hearingaidCheckList", hearingaidCheckList);
	        mav.addObject("leftMenu", "my-hearingaid-check");
        }else {
        	mav = SiteUtil.getSkinView("/hearingaid/hearingaid_check");
        	mav.addObject("haUse", "N");
        }
        
        return mav;
	}
}
