package net.danvi.dmall.admin.web.view.vision.controller;

import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import dmall.framework.common.exception.JsonValidationException;
import dmall.framework.common.model.ResultListModel;
import dmall.framework.common.model.ResultModel;
import lombok.extern.slf4j.Slf4j;
import net.danvi.dmall.admin.web.view.goods.controller.GoodsManageController;
import net.danvi.dmall.biz.app.operation.model.AtchFilePO;
import net.danvi.dmall.biz.app.operation.model.AtchFileVO;
import net.danvi.dmall.biz.app.vision.model.VisionGunVO;
import net.danvi.dmall.biz.app.vision.service.VisionCheckService;
import net.danvi.dmall.biz.system.security.DmallSessionDetails;
import net.danvi.dmall.biz.system.security.SessionDetailHelper;
import net.danvi.dmall.biz.system.validation.DeleteGroup;

/**
 * 비전체크 군 관리 Controller
 *
 * @author yang ji
 * @since 2019.01.31
 * 
 * CTG_NO	3 : 안경렌즈
 * 			4 : 콘택트렌즈
 *			5 : 다비치보청기
 * 
 * 
 */

@Slf4j
@Controller
@RequestMapping("/admin/vision")
public class VisionManageController {
	
	@Resource(name = "visionCheckService")
	private VisionCheckService visionCheckService;

	/**
     * <pre>
     * 작성일 : 2019.01.31
     * 작성자 : yang ji
     * 설명   : 비전체크 군 관리 : 3 : 안경렌즈
     * </pre>
     *
     * @return
     */
    @RequestMapping("/vision-glasses-lengs")
    public ModelAndView visionGlassesLengs() {
        ModelAndView mav = new ModelAndView("/admin/vision/visionGunManager");
        mav.addObject("siteNo", SessionDetailHelper.getDetails().getSiteNo());
        
        VisionGunVO ctgVO = new VisionGunVO();
        ctgVO.setGoodsTypeCd("03");
        ctgVO.setGoodsTypeCdNm("안경렌즈");
        
        mav.addObject("ctgVO", ctgVO);
        
        return mav;
    }
    


	/**
     * <pre>
     * 작성일 : 2019.01.31
     * 작성자 : yang ji
     * 설명   : 비전체크 군 관리 : 4 : 콘택트렌즈
     * </pre>
     *
     * @return
     */
    @RequestMapping("/vision-contact-lengs")
    public ModelAndView visionContactLengs() {
    	ModelAndView mav = new ModelAndView("/admin/vision/visionGunManager");
        mav.addObject("siteNo", SessionDetailHelper.getDetails().getSiteNo());
        
        VisionGunVO ctgVO = new VisionGunVO();
        ctgVO.setGoodsTypeCd("04");
        ctgVO.setGoodsTypeCdNm("콘택트렌즈");
        
        mav.addObject("ctgVO", ctgVO);
        
        return mav;
    }
    
    /**
     * <pre>
     * 작성일 : 2019.02.07
     * 작성자 : yang ji
     * 설명   : 비전체크 군 등록
     * </pre>
     *
     * @return
     */
    @RequestMapping("/vision-check-gun-insert")
    public void visionCheckGunInsert(@Validated VisionGunVO vo, BindingResult bindingResult, HttpServletResponse response) throws Exception {
    	
    	// 조회할 회원정보 set
        DmallSessionDetails sessionInfo = SessionDetailHelper.getDetails();    
        vo.setRegrNo(sessionInfo.getSession().getMemberNo());
        
    	int rtn = visionCheckService.insertVisionCheckGun(vo);
    	
    	response.setContentType("text/xml");
		response.setCharacterEncoding("UTF-8");
		StringBuffer retXML = new StringBuffer(1024);
		retXML.append("<?xml version='1.0' encoding='UTF-8'?>");				
		retXML.append("<items>");         
		retXML.append("<row>");
		retXML.append("		<rtn>"+rtn+"</rtn>");
		retXML.append("</row>");		
		retXML.append("</items>");
		response.getWriter().println(retXML.toString());    	
    }
    
    /**
     * <pre>
     * 작성일 : 2019.02.07
     * 작성자 : yang ji
     * 설명   : 비전체크 군 목록
     * </pre>
     *
     * @return
     */
    @RequestMapping("/vision-check-gun-list")
    public void visionCheckGunList(@Validated VisionGunVO vo, BindingResult bindingResult, HttpServletResponse response) throws Exception {
    	
    	// 조회할 회원정보 set
        DmallSessionDetails sessionInfo = SessionDetailHelper.getDetails();    
        vo.setRegrNo(sessionInfo.getSession().getMemberNo());   	
    	
    	response.setContentType("text/xml");
		response.setCharacterEncoding("UTF-8");
		StringBuffer retXML = new StringBuffer(1024);
		retXML.append("<?xml version='1.0' encoding='UTF-8'?>");				
		retXML.append("<items>");         
		
		try {
			List<VisionGunVO> gunList = visionCheckService.selectVisionCheckGunList(vo);
			for(int i=0; i<gunList.size(); i++){
				VisionGunVO gunVO = gunList.get(i);
				retXML.append("<row>");
				retXML.append("		<gun_no>"+gunVO.getGunNo()+"</gun_no>");
				retXML.append("		<ctg_no>"+gunVO.getGoodsTypeCd()+"</ctg_no>");
				retXML.append("		<gun_nm>"+gunVO.getGunNm()+"</gun_nm>");
				retXML.append("		<is_use>"+gunVO.getIsUse()+"</is_use>");
				retXML.append("</row>");	
			}
		}catch(Exception e) {
			e.printStackTrace();
		}
		retXML.append("</items>");
		response.getWriter().println(retXML.toString());    	
    }   
    
    /**
     * <pre>
     * 작성일 : 2019.02.07
     * 작성자 : yang ji
     * 설명   : 비전체크 군 정보
     * </pre>
     *
     * @return
     */
    @RequestMapping("/vision-check-gun-info")
    public @ResponseBody ResultModel<VisionGunVO> visionCheckGunInfo(@Validated VisionGunVO vo
    		, BindingResult bindingResult, HttpServletRequest request) throws Exception {
    	if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }
    	
    	ResultModel<VisionGunVO> result = visionCheckService.selectVisionCheckGun(vo);
		
    	return result;
    }   
    
    /**
     * <pre>
     * 작성일 : 2019.02.07
     * 작성자 : yang ji
     * 설명   : 비전체크 군 정보
     * </pre>
     *
     * @return
     */
    @RequestMapping("/vision-check-gun-update")
    public @ResponseBody ResultModel<VisionGunVO> visionCheckGunUpdate(@Validated VisionGunVO vo, 
    		BindingResult bindingResult, HttpServletRequest request) throws Exception {
    	if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }
        if (SessionDetailHelper.getDetails().getSession().getMemberNo() != null) {
        	vo.setRegrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
        } else {

        }
        
        ResultModel<VisionGunVO> result= visionCheckService.updateVisionCheckGun(vo, request);
        
        return result;
    }
    
    @RequestMapping("/attach-file-delete")
    public @ResponseBody ResultModel<AtchFilePO> deleteAtchFile(@Validated(DeleteGroup.class) AtchFilePO po,
            BindingResult bindingResult) throws Exception {
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }
        if (SessionDetailHelper.getDetails().getSession().getMemberNo() != null) {
            po.setDelrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
        }

        ResultModel<AtchFilePO> result = visionCheckService.deleteAtchFile(po);

        return result;
    }
}
