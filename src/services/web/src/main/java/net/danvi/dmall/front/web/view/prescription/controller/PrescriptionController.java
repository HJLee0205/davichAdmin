package net.danvi.dmall.front.web.view.prescription.controller;

import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import dmall.framework.common.constants.UploadConstants;
import dmall.framework.common.model.FileVO;
import dmall.framework.common.model.ResultModel;
import dmall.framework.common.util.FileUtil;
import dmall.framework.common.util.MessageUtil;
import dmall.framework.common.util.SiteUtil;
import net.danvi.dmall.biz.app.prescription.model.PrescriptionPO;
import net.danvi.dmall.biz.app.prescription.model.PrescriptionVO;
import net.danvi.dmall.biz.app.prescription.service.PrescriptionService;
import net.danvi.dmall.biz.system.security.SessionDetailHelper;

/**
 * <pre>
 * - 프로젝트명    : 04.front.web
 * - 패키지명      : net.danvi.dmall.front.web.view.prescription.controller
 * - 파일명        : PrescriptionController.java
 * - 작성일        : 2018. 7. 9.
 * - 작성자        : CBK
 * - 설명          : 처방전 Controller
 * </pre>
 */
@Controller
@RequestMapping(value = "/front/mypage")
public class PrescriptionController {

	@Resource(name="prescriptionService")
	PrescriptionService prescriptionService;
	
	/**
	 * <pre>
	 * 작성일 : 2018. 7. 9.
	 * 작성자 : CBK
	 * 설명   : 처방전 목록
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 7. 9. CBK - 최초생성
	 * </pre>
	 *
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/prescription")
	public ModelAndView prescriptionList(HttpServletRequest request) throws Exception {
		ModelAndView mv = SiteUtil.getSkinView("/mypage/prescription_list");

        // 로그인여부 체크
        if (!SessionDetailHelper.getDetails().isLogin()) {
            mv.addObject("exMsg", MessageUtil.getMessage("biz.exception.lng.loginRequired"));
            mv.setViewName("/error/notice");
            return mv;
        }
        
        long memberNo = SessionDetailHelper.getDetails().getSession().getMemberNo();

        // 처방전 목록 조회
        List<PrescriptionVO> prescriptionList = prescriptionService.selectPrescriptionList(memberNo);
        mv.addObject("prescriptionList", prescriptionList);
        
        // left menu
        mv.addObject("leftMenu", "prescription");

        return mv;
	}
	
	/**
	 * <pre>
	 * 작성일 : 2018. 7. 10.
	 * 작성자 : CBK
	 * 설명   : 처방전 등록 화면
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 7. 10. CBK - 최초생성
	 * </pre>
	 *
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/prescription_reg_form")
	public ModelAndView prescriptionRegForm(HttpServletRequest request) throws Exception {
		ModelAndView mv = SiteUtil.getSkinView("/mypage/prescription_reg");	// 성공시
		
        // 로그인여부 체크
        if (!SessionDetailHelper.getDetails().isLogin()) {
            mv.addObject("exMsg", MessageUtil.getMessage("biz.exception.lng.loginRequired"));
        }
        long memberNo = SessionDetailHelper.getDetails().getSession().getMemberNo();
        
        // 최대 10개까지만 등록 가능
        if(prescriptionService.countPrescriptionList(memberNo) >= 10) {
        	mv.addObject("exMsg", MessageUtil.getMessage("front.exception.prescription.overmax"));
        }
        
        return mv;
	}
	
	/**
	 * <pre>
	 * 작성일 : 2018. 7. 10.
	 * 작성자 : CBK
	 * 설명   : 처방전 등록
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 7. 10. CBK - 최초생성
	 * </pre>
	 *
	 * @param po
	 * @param mRequest
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/prescription_reg")
	public @ResponseBody ResultModel<Object> regPrescription(PrescriptionPO po, HttpServletRequest mRequest) throws Exception {
		
		ResultModel<Object> result = new ResultModel<>();

        // 로그인여부 체크
        if (!SessionDetailHelper.getDetails().isLogin()) {
        	result.setSuccess(false);
            result.setMessage(MessageUtil.getMessage("biz.exception.lng.loginRequired"));
        	return result;
        }
        
        long memberNo = SessionDetailHelper.getDetails().getSession().getMemberNo();
        po.setMemberNo(memberNo);
        po.setRegrNo(memberNo);

        // 최대 10개까지만 등록 가능
        if(prescriptionService.countPrescriptionList(memberNo) >= 10) {
        	result.setSuccess(false);
        	result.setMessage(MessageUtil.getMessage("front.exception.prescription.overmax"));
        	return result;
        }
        
        // 파일 정보 등록
        List<FileVO> list = FileUtil.getFileListFromRequest(mRequest,FileUtil.getPath(UploadConstants.PATH_ATTACH, UploadConstants.PATH_PRESCRIPTION));

        if (list != null && list.size() == 1) {
            po.setPrescriptionFilePath(list.get(0).getFilePath());
            po.setPrescriptionFileNm(list.get(0).getFileName());
            po.setPrescriptionOrgFileNm(list.get(0).getFileOrgName());
            po.setPrescriptionFileSize(list.get(0).getFileSize());
        }
        
        // 처방전 정보 등록
        prescriptionService.insertPrescription(po);
        
		result.setSuccess(true);
		result.setMessage(MessageUtil.getMessage("front.web.common.insert"));
		
		return result;
	}
	
	/**
	 * <pre>
	 * 작성일 : 2018. 7. 10.
	 * 작성자 : CBK
	 * 설명   : 처방전 삭제
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 7. 10. CBK - 최초생성
	 * </pre>
	 *
	 * @param po
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/prescription_del")
	public @ResponseBody ResultModel<Object> delPrescription(PrescriptionPO po) throws Exception {

		ResultModel<Object> result = new ResultModel<>();

        // 로그인여부 체크
        if (!SessionDetailHelper.getDetails().isLogin()) {
        	result.setSuccess(false);
            result.setMessage(MessageUtil.getMessage("biz.exception.lng.loginRequired"));
        	return result;
        }
        
        long memberNo = SessionDetailHelper.getDetails().getSession().getMemberNo();
        po.setMemberNo(memberNo);
        po.setUpdrNo(memberNo);
        
        // 처방전 정보 삭제
        prescriptionService.deletePrescription(po);

		result.setSuccess(true);
		result.setMessage(MessageUtil.getMessage("front.web.common.delete"));
		
		return result;
	}
}
