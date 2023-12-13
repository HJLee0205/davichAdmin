package com.davichmall.ifapi.visit.controller;

import javax.annotation.Resource;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.davichmall.ifapi.cmmn.CustomException;
import com.davichmall.ifapi.cmmn.base.BaseController;
import com.davichmall.ifapi.cmmn.constant.Constants;
import com.davichmall.ifapi.visit.dto.KioskLoginCheckReqDTO;
import com.davichmall.ifapi.visit.dto.KioskLoginCheckResDTO;
import com.davichmall.ifapi.visit.dto.VisitInfoRegReqDTO;
import com.davichmall.ifapi.visit.dto.VisitInfoRegResDTO;
import com.davichmall.ifapi.visit.dto.VisitStatusMdfyReqDTO;
import com.davichmall.ifapi.visit.dto.VisitStatusMdfyResDTO;
import com.davichmall.ifapi.visit.service.VisitService;

/**
 * <pre>
 * - 프로젝트명    : davichmall_interface
 * - 패키지명      : com.davichmall.ifapi.visit
 * - 파일명        : VisitController.java
 * - 작성일        : 2018. 8. 6.
 * - 작성자        : CBK
 * - 설명          : 고객방문 정보 처리 Controller(키오스크/전광판)
 * </pre>
 */
@Controller
public class VisitController extends BaseController {
	
	@Resource(name="visitService")
	VisitService visitService;

	
	/**
	 * <pre>
	 * 작성일 : 2018. 8. 6.
	 * 작성자 : CBK
	 * 설명   : 키오스크 로그인 정보 확인
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 8. 6. CBK - 최초생성
	 * </pre>
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/" + Constants.IFID.CHECK_KIOSK_LOGIN)
	public @ResponseBody String checkKioskLoginInfo(KioskLoginCheckReqDTO param) throws Exception {
		String ifId = Constants.IFID.CHECK_KIOSK_LOGIN;
		
		try {
			
			// ERP 처리 부분
			// Response DTO 생성
			KioskLoginCheckResDTO resDto = new KioskLoginCheckResDTO();
			resDto.setResult(Constants.RESULT.SUCCESS);
			resDto.setMessage("");
			
			// 데이터 확인
			String checkResult = visitService.checkKioskLoginInfo(param);
			
			resDto.setCheckResult(checkResult);
			
			// 처리 로그 등록
			logService.writeInterfaceLog(ifId, param, resDto);
			
			return toJsonRes(resDto, param);
		} catch (CustomException ce) {
			ce.setReqParam(param);
			ce.setIfId(ifId);
			throw ce;
		} catch (Exception e) {
			e.printStackTrace();
			throw new CustomException(e, param, ifId);
		}
	}
	
	/**
	 * <pre>
	 * 작성일 : 2018. 8. 6.
	 * 작성자 : CBK
	 * 설명   : 키오스크에 등록된 방문 고객 정보를 다비젼에 전달
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 8. 6. CBK - 최초생성
	 * </pre>
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/" + Constants.IFID.VISIT_INFO_REG)
	public @ResponseBody String insertCustVisitInfo(VisitInfoRegReqDTO param) throws Exception {
		String ifId = Constants.IFID.VISIT_INFO_REG;
		
		try {
			
			// ERP 처리 부분
			// Response DTO 생성
			VisitInfoRegResDTO resDto = new VisitInfoRegResDTO();
			resDto.setResult(Constants.RESULT.SUCCESS);
			resDto.setMessage("");
			
			// 데이터 등록
			visitService.insertVisitInfo(param);
			
			// 처리 로그 등록
			logService.writeInterfaceLog(ifId, param, resDto);
			
			return toJsonRes(resDto, param);
		} catch (CustomException ce) {
			ce.setReqParam(param);
			ce.setIfId(ifId);
			throw ce;
		} catch (Exception e) {
			e.printStackTrace();
			throw new CustomException(e, param, ifId);
		}
	}
	
	/**
	 * <pre>
	 * 작성일 : 2018. 8. 6.
	 * 작성자 : CBK
	 * 설명   : 키오스크에서 방문 고객 상태를 수정
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 8. 6. CBK - 최초생성
	 * </pre>
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/" + Constants.IFID.VISIT_STATUS_MOD_FROM_KIOSK)
	public @ResponseBody String updateVisitStatusFromKiosk(VisitStatusMdfyReqDTO param) throws Exception {
		String ifId = Constants.IFID.VISIT_STATUS_MOD_FROM_KIOSK;
		
		try {
			
			// ERP 처리 부분
			// Response DTO 생성
			VisitStatusMdfyResDTO resDto = new VisitStatusMdfyResDTO();
			resDto.setResult(Constants.RESULT.SUCCESS);
			resDto.setMessage("");
			
			// 데이터 수정
			visitService.updateErpVisitStatus(param);
			
			// 처리 로그 등록
			logService.writeInterfaceLog(ifId, param, resDto);

			return toJsonRes(resDto, param);
			
		} catch (CustomException ce) {
			ce.setReqParam(param);
			ce.setIfId(ifId);
			throw ce;
		} catch (Exception e) {
			e.printStackTrace();
			throw new CustomException(e, param, ifId);
		}
	}
	
	
	
	/**
	 * <pre>
	 * 작성일 : 2018. 8. 6.
	 * 작성자 : CBK
	 * 설명   : 다비젼에서 방문 고객 상태를 수정
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 8. 6. CBK - 최초생성
	 * </pre>
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/" + Constants.IFID.VISIT_STATUS_MOD_FROM_ERP)
	public @ResponseBody String updateVisitStatusFromErp(VisitStatusMdfyReqDTO param) throws Exception {
		String ifId = Constants.IFID.VISIT_STATUS_MOD_FROM_ERP;
		
		try {
			
			// ERP 처리 부분
			// 쇼핑몰(키오스크) 쪽으로 데이터 전송
			String resParam = sendUtil.send(param, ifId);
			
			// 처리 로그 등록
			logService.writeInterfaceLog(ifId, param, resParam, VisitStatusMdfyResDTO.class);
			
			return resParam;
		} catch (CustomException ce) {
			ce.setReqParam(param);
			ce.setIfId(ifId);
			throw ce;
		} catch (Exception e) {
			e.printStackTrace();
			throw new CustomException(e, param, ifId);
		}
	}
	
}
