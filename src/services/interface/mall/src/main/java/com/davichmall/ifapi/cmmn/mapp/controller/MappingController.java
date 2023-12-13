package com.davichmall.ifapi.cmmn.mapp.controller;


import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.davichmall.ifapi.cmmn.CustomException;
import com.davichmall.ifapi.cmmn.base.BaseController;
import com.davichmall.ifapi.cmmn.base.BaseResDTO;
import com.davichmall.ifapi.cmmn.constant.Constants;
import com.davichmall.ifapi.cmmn.mapp.dto.OffPointMapRegReqDTO;
import com.davichmall.ifapi.cmmn.mapp.dto.OrderMapRegReqDTO;
import com.davichmall.ifapi.cmmn.mapp.dto.PreorderMapRegReqDTO;
import com.davichmall.ifapi.cmmn.mapp.dto.ReturnMapRegReqDTO;

/**
 * <pre>
 * - 프로젝트명    : davichmall_interface
 * - 패키지명      : com.davichmall.ifapi.cmmn.mapp.controller
 * - 파일명        : MappingController.java
 * - 작성일        : 2018. 7. 17.
 * - 작성자        : CBK
 * - 설명          : 트랜잭션 처리를 위한 매핑 정보 등록 Controller
 * </pre>
 */
@Controller
public class MappingController extends BaseController {
	
	/**
	 * <pre>
	 * 작성일 : 2018. 7. 17.
	 * 작성자 : CBK
	 * 설명   : 주문 및 주문 상세 매핑 정보 등록
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 7. 17. CBK - 최초생성
	 * </pre>
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/insertOrderMap")
	public @ResponseBody String insertOrderAndDtlMap(OrderMapRegReqDTO param) throws Exception {
		try {
			// 매핑 정보 등록
			mappingService.insertOrderAndDtlMap(param);
			
			BaseResDTO resDto = new BaseResDTO();
			resDto.setResult(Constants.RESULT.SUCCESS);
			resDto.setMessage("");
			
			return toJsonRes(resDto, param);

		} catch (CustomException ce) {
			ce.setReqParam(param);
			throw ce;
		} catch (Exception e) {
			e.printStackTrace();
			throw new CustomException(e, param, null);
		}
	}
	
	/**
	 * <pre>
	 * 작성일 : 2018. 9. 17.
	 * 작성자 : CBK
	 * 설명   : 주문 및 주문 상세 매핑 정보 삭제
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 9. 17. CBK - 최초생성
	 * </pre>
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/deleteOrderMap")
	public @ResponseBody String deleteOrderAndDtlMap(OrderMapRegReqDTO param) throws Exception {
		try {
			// 매핑 정보 등록
			mappingService.deleteOrderAndDtlMap(param);
			
			BaseResDTO resDto = new BaseResDTO();
			resDto.setResult(Constants.RESULT.SUCCESS);
			resDto.setMessage("");
			
			return toJsonRes(resDto, param);

		} catch (CustomException ce) {
			ce.setReqParam(param);
			throw ce;
		} catch (Exception e) {
			e.printStackTrace();
			throw new CustomException(e, param, null);
		}
	}
	
	/**
	 * <pre>
	 * 작성일 : 2018. 8. 9.
	 * 작성자 : CBK
	 * 설명   : 반품 매핑 정보 등록
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 8. 9. CBK - 최초생성
	 * </pre>
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/insertReturnMap")
	public @ResponseBody String insertReturnMap(ReturnMapRegReqDTO param) throws Exception {
		try {
			
			// 매핑 정보 등록
			mappingService.insertReturnMap(param);

			BaseResDTO resDto = new BaseResDTO();
			resDto.setResult(Constants.RESULT.SUCCESS);
			resDto.setMessage("");
			
			return toJsonRes(resDto, param);

		} catch (CustomException ce) {
			ce.setReqParam(param);
			throw ce;
		} catch (Exception e) {
			e.printStackTrace();
			throw new CustomException(e, param, null);
		}
	}
	
	/**
	 * <pre>
	 * 작성일 : 2018. 7. 17.
	 * 작성자 : CBK
	 * 설명   : 기획전 매핑 정보 등록
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 7. 17. CBK - 최초생성
	 * </pre>
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/insertPreorderMap")
	public @ResponseBody String insertPreorderMap(PreorderMapRegReqDTO param) throws Exception {
		try {
			// 매핑 정보 등록
			mappingService.insertPOMap(param.getMallPrmtNo(), param.getErpPrmtNo());
			
			BaseResDTO resDto = new BaseResDTO();
			resDto.setResult(Constants.RESULT.SUCCESS);
			resDto.setMessage("");
			
			return toJsonRes(resDto, param);
			
		} catch (CustomException ce) {
			ce.setReqParam(param);
			throw ce;
		} catch (Exception e) {
			e.printStackTrace();
			throw new CustomException(e, param, null);
		}
	}

	/**
	 * <pre>
	 * 작성일 : 2018. 7. 17.
	 * 작성자 : CBK
	 * 설명   : 오프라인 포인트 사용 매핑 정보 등록
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 7. 17. CBK - 최초생성
	 * </pre>
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/insertOffPointMap")
	public @ResponseBody String insertOffPointMap(OffPointMapRegReqDTO param) throws Exception {
		try {
			// 매핑 정보 등록
			mappingService.insertOfflinePointMap(param);

			BaseResDTO resDto = new BaseResDTO();
			resDto.setResult(Constants.RESULT.SUCCESS);
			resDto.setMessage("");
			
			return toJsonRes(resDto, param);
			
		} catch (CustomException ce) {
			ce.setReqParam(param);
			throw ce;
		} catch (Exception e) {
			e.printStackTrace();
			throw new CustomException(e, param, null);
		}
	}
}
