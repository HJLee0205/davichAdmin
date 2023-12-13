package net.danvi.dmall.front.web.view.eyesight.controller;

import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import dmall.framework.common.model.ResultModel;
import dmall.framework.common.util.MessageUtil;
import dmall.framework.common.util.SiteUtil;
import net.danvi.dmall.biz.app.eyesight.model.EyesightPO;
import net.danvi.dmall.biz.app.eyesight.model.EyesightVO;
import net.danvi.dmall.biz.app.eyesight.service.EyesightService;
import net.danvi.dmall.biz.system.security.SessionDetailHelper;

/**
 * <pre>
 * - 프로젝트명    : 04.front.web
 * - 패키지명      : net.danvi.dmall.front.web.view.sight.controller
 * - 파일명        : SightController.java
 * - 작성일        : 2018. 7. 6.
 * - 작성자        : CBK
 * - 설명          : 시력 Controller
 * </pre>
 */
@Controller
@RequestMapping(value = "/front/mypage")
public class EyesightController {
	
	@Resource(name="eyesightService")
	EyesightService eyesightService;

	/**
	 * <pre>
	 * 작성일 : 2018. 7. 6.
	 * 작성자 : CBK
	 * 설명   : 시력 정보 조회
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 7. 6. CBK - 최초생성
	 * </pre>
	 *
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/eyesight")
	public ModelAndView viewMyEyesightInfo(HttpServletRequest request) throws Exception {
		ModelAndView mv = SiteUtil.getSkinView("/mypage/eyesight_view");

        // 로그인여부 체크
        if (!SessionDetailHelper.getDetails().isLogin()) {
            mv.addObject("exMsg", MessageUtil.getMessage("biz.exception.lng.loginRequired"));
            mv.setViewName("/error/notice");
            return mv;
        }
        
        // 시력 정보 조회
        Long memberNo = SessionDetailHelper.getDetails().getSession().getMemberNo();
        EyesightVO eyesightVo = eyesightService.selectEyesightInfo(memberNo);
        mv.addObject("eyesightInfo", eyesightVo);

        // left menu
        mv.addObject("leftMenu", "eyesight");
        
        return mv;
	}
	
	/**
	 * <pre>
	 * 작성일 : 2018. 7. 6.
	 * 작성자 : CBK
	 * 설명   : 시력 정보 등록/수정 화면으로 이동
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 7. 6. CBK - 최초생성
	 * </pre>
	 *
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/eyesight_reg_form")
	public ModelAndView myEysightInfoRegForm(HttpServletRequest request) throws Exception {
		ModelAndView mv = SiteUtil.getSkinView("/mypage/eyesight_reg");

        // 로그인여부 체크
        if (!SessionDetailHelper.getDetails().isLogin()) {
            mv.addObject("exMsg", MessageUtil.getMessage("biz.exception.lng.loginRequired"));
            mv.setViewName("/error/notice");
            return mv;
        }
        
        // 시력 정보 조회
        Long memberNo = SessionDetailHelper.getDetails().getSession().getMemberNo();
        EyesightVO eyesightVo = eyesightService.selectEyesightInfo(memberNo);
        mv.addObject("eyesightInfo", eyesightVo);

        // left menu
        mv.addObject("leftMenu", "eyesight");
        
        return mv;
	}
	
	/**
	 * <pre>
	 * 작성일 : 2018. 7. 6.
	 * 작성자 : CBK
	 * 설명   : 시력 정보 등록/수정
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 7. 6. CBK - 최초생성
	 * </pre>
	 *
	 * @param po
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/eyesight_reg")
	public @ResponseBody ResultModel<Object> regMyEyssightInfo(EyesightPO po, HttpServletRequest request) throws Exception {
		ResultModel<Object> result = new ResultModel<>();

        // 로그인 확인
        if (!SessionDetailHelper.getDetails().isLogin()) {
            result.setSuccess(false);
            result.setMessage(MessageUtil.getMessage("biz.exception.lng.loginRequired"));
            return result;
        }
        long memberNo = SessionDetailHelper.getDetails().getSession().getMemberNo();
        po.setMemberNo(memberNo);
        po.setRegrNo(memberNo);
        po.setUpdrNo(memberNo);
		
		eyesightService.insertOrUpdateEyesightInfo(po);
		
		result.setSuccess(true);
		result.setMessage(MessageUtil.getMessage("front.web.common.insert"));
		
		
		return result;
	}
	
	/**
	 * <pre>
	 * 작성일 : 2018. 7. 6.
	 * 작성자 : CBK
	 * 설명   : 다비치 안경점(ERP)에서 실시한 시력검사 정보를 조회한다.
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 7. 6. CBK - 최초생성
	 * </pre>
	 *
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/store_eyesight")
	public @ResponseBody ResultModel<Object> getStoreEyesightInfo(HttpServletRequest request) throws Exception {
		ResultModel<Object> result = new ResultModel<>();

        // 로그인 확인
		if (!SessionDetailHelper.getDetails().isLogin()) {
            result.setSuccess(false);
            result.setMessage(MessageUtil.getMessage("biz.exception.lng.loginRequired"));
            return result;
        }
        
        long memberNo = SessionDetailHelper.getDetails().getSession().getMemberNo();
        
        // 통합 회원인지 확인
        if(!eyesightService.checkCombinedMember(memberNo)) {
        	result.setSuccess(false);
        	result.setMessage(MessageUtil.getMessage("front.exception.eyesight.onlyCombinedMember"));
        	return result;
        }
        
        // 다비젼 시력 정보 조회
        Map<String, Object> eyesightInfo = eyesightService.getStoreEyesightInfo(memberNo);
        result.setData(eyesightInfo);
        

		return result;
	}
}
