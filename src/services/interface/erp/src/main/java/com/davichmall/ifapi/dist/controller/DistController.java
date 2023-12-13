package com.davichmall.ifapi.dist.controller;

import javax.annotation.Resource;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.davichmall.ifapi.cmmn.CustomException;
import com.davichmall.ifapi.cmmn.base.BaseController;
import com.davichmall.ifapi.cmmn.constant.Constants;
import com.davichmall.ifapi.cmmn.mapp.dto.OrderMapDTO;
import com.davichmall.ifapi.dist.dto.ErpReturnConfirmReqDTO;
import com.davichmall.ifapi.dist.dto.ErpReturnConfirmResDTO;
import com.davichmall.ifapi.dist.dto.MallReturnConfirmReqDTO;
import com.davichmall.ifapi.dist.dto.MallReturnConfirmResDTO;
import com.davichmall.ifapi.dist.dto.OrderCancelReqDTO;
import com.davichmall.ifapi.dist.dto.OrderCancelResDTO;
import com.davichmall.ifapi.dist.dto.OrderRegReqDTO;
import com.davichmall.ifapi.dist.dto.OrderRegResDTO;
import com.davichmall.ifapi.dist.dto.OrderReleaseReqDTO;
import com.davichmall.ifapi.dist.dto.OrderReleaseResDTO;
import com.davichmall.ifapi.dist.dto.PurchaseConfirmReqDTO;
import com.davichmall.ifapi.dist.dto.PurchaseConfirmResDTO;
import com.davichmall.ifapi.dist.dto.RefundCmpltReqDTO;
import com.davichmall.ifapi.dist.dto.RefundCmpltResDTO;
import com.davichmall.ifapi.dist.dto.ReturnPopUrlReqDTO;
import com.davichmall.ifapi.dist.dto.ReturnPopUrlResDTO;
import com.davichmall.ifapi.dist.dto.StoreDlvrCmpltReqDTO;
import com.davichmall.ifapi.dist.dto.StoreDlvrCmpltResDTO;
import com.davichmall.ifapi.dist.dto.OrderRegReqDTO.OrderDetailDTO;
import com.davichmall.ifapi.dist.dto.RefundCmpltReqDTO.RefundItemDTO;
import com.davichmall.ifapi.dist.service.DistService;

/**
 * <pre>
 * - 프로젝트명    : davichmall_interface
 * - 패키지명      : com.davichmall.ifapi.dist.controller
 * - 파일명        : DistController.java
 * - 작성일        : 2018. 5. 30.
 * - 작성자        : CBK
 * - 설명          : [발주] 분류의 인터페이스 처리를 위한 Controller
 * </pre>
 */
@Controller
public class DistController extends BaseController {

	@Resource(name="distService")
	DistService distService;
	
	/**
	 * <pre>
	 * 작성일 : 2018. 6. 1.
	 * 작성자 : CBK
	 * 설명   : 발주등록
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 6. 1. CBK - 최초생성
	 * </pre>
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/" + Constants.IFID.ORDER_REG)
	public @ResponseBody String regOrderInfo(OrderRegReqDTO param) throws Exception {
		
		String ifId = Constants.IFID.ORDER_REG;

		try {
			
			// ERP 처리부분
			
			// ResponseDTO 생성
			OrderRegResDTO resDto = new OrderRegResDTO();
			resDto.setResult(Constants.RESULT.SUCCESS);
			resDto.setMessage("");
			
			// 데이터 저장
			distService.insertOrderInfo(param);

			// 처리로그 등록
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
	 * 작성일 : 2018. 6. 5.
	 * 작성자 : CBK
	 * 설명   : 발주 취소
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 6. 5. CBK - 최초생성
	 * </pre>
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/" + Constants.IFID.ORDER_CANCEL)
	public @ResponseBody String cancelOrder(OrderCancelReqDTO param) throws Exception {
		
		String ifId = Constants.IFID.ORDER_CANCEL;

		try {
			// ERP 처리부분
			
			// ResponseDTO 생성
			OrderCancelResDTO resDto = new OrderCancelResDTO();
			resDto.setResult(Constants.RESULT.SUCCESS);
			resDto.setMessage("");
			
			
			// 데이터 처리
			distService.cancelOrder(param);

			// 처리로그 등록
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
	 * 작성일 : 2018. 6. 5.
	 * 작성자 : CBK
	 * 설명   : 출고 정보 등록
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 6. 5. CBK - 최초생성
	 * </pre>
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/" + Constants.IFID.ORDER_RELEASE)
	public @ResponseBody String release(OrderReleaseReqDTO param) throws Exception {
		
		String ifId = Constants.IFID.ORDER_RELEASE;

		try {
			
			// ERP 처리부분
			
			// 쇼핌몰로 데이터 넘기기
			String resParam = sendUtil.send(param, ifId);
			
			// 처리로그 등록
			logService.writeInterfaceLog(ifId, param, resParam, OrderReleaseResDTO.class);
			
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
	
	/**
	 * <pre>
	 * 작성일 : 2018. 6. 7.
	 * 작성자 : CBK
	 * 설명   : 매장배송완료
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 6. 7. CBK - 최초생성
	 * </pre>
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/" + Constants.IFID.STORE_DLVR_CMPLT)
	public @ResponseBody String completeStoreDelivery(StoreDlvrCmpltReqDTO param) throws Exception {

		String ifId = Constants.IFID.STORE_DLVR_CMPLT;
		try {
			
			// ERP 처리 부분
			
			// 쇼핑몰쪽으로 데이터 전송
			String resParam = sendUtil.send(param, ifId);
			
			// 처리로그 등록
			logService.writeInterfaceLog(ifId, param, resParam, StoreDlvrCmpltResDTO.class);
			
			// 결과 반환
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

	/**
	 * <pre>
	 * 작성일 : 2018. 6. 11.
	 * 작성자 : CBK
	 * 설명   : 반품등록
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 6. 11. CBK - 최초생성
	 * </pre>
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/" + Constants.IFID.MALL_RETURN_REG)
	public @ResponseBody String returnReg(OrderRegReqDTO param) throws Exception {

		String ifId = Constants.IFID.MALL_RETURN_REG;
		try {
			
			// ERP 처리부분
			
			// ResponseDTO 생성
			OrderRegResDTO resDto = new OrderRegResDTO();
			resDto.setResult(Constants.RESULT.SUCCESS);
			resDto.setMessage("");
			
			// 기본 값 설정
			//  발주구분 : 반품발주
			param.setGubun(Constants.ORDER_GUBUN.RETURN);
			// 배송루트 (빤품은 그냥 고정)
			String ordRute = Constants.ORD_RUTE.DIRECT_RECV;
			param.setOrdRute(ordRute);
			
			// 데이터 저장
			distService.insertMallReturnReq(param);

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
	 * 작성일 : 2018. 6. 14.
	 * 작성자 : CBK
	 * 설명   : 쇼핑몰 반품확정 (반품정보 ERP에 등록)
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 6. 14. CBK - 최초생성
	 * </pre>
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */	
	@RequestMapping(value="/" + Constants.IFID.MALL_RETURN_CONFIRM)
	public @ResponseBody String mallReturnConfirm(MallReturnConfirmReqDTO param) throws Exception {
		
		String ifId = Constants.IFID.MALL_RETURN_CONFIRM;
		try {
			
			// ERP 처리부분
			
			// ResponseDTO 생성
			MallReturnConfirmResDTO resDto = new MallReturnConfirmResDTO();
			resDto.setResult(Constants.RESULT.SUCCESS);
			resDto.setMessage("");
			
			// 반품완료 상태로 수정
			distService.updateErpReturnComfirm(param);
			
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
	 * 작성일 : 2018. 7. 13.
	 * 작성자 : CBK
	 * 설명   : 물류센터 반품 확정
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 7. 13. CBK - 최초생성
	 * </pre>
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/" + Constants.IFID.DIST_CENTER_RETURN_CONFIRM)
	public @ResponseBody String erpReturnConfirm(ErpReturnConfirmReqDTO param) throws Exception {
		String ifId = Constants.IFID.DIST_CENTER_RETURN_CONFIRM;
		
		try {
			
			// ERP 처리 부분
			// 쇼핑몰 쪽으로 데이터 전송
			String resParam = sendUtil.send(param, ifId);
			
			// 처리 로그 등록
			logService.writeInterfaceLog(ifId, param, resParam, ErpReturnConfirmResDTO.class);
			
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

	/**
	 * <pre>
	 * 작성일 : 2018. 7. 13.
	 * 작성자 : CBK
	 * 설명   : 쇼핑몰 구매확정 정보를 ERP에 등록
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 7. 13. CBK - 최초생성
	 * </pre>
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/" + Constants.IFID.PURCHASE_CONFIRM)
	public @ResponseBody String purchaseConfirm(PurchaseConfirmReqDTO param) throws Exception {
		String ifId = Constants.IFID.PURCHASE_CONFIRM;
		
		try {
			
			// ERP 처리 부분
			// Response DTO 생성
			PurchaseConfirmResDTO resDto = new PurchaseConfirmResDTO();
			resDto.setResult(Constants.RESULT.SUCCESS);
			resDto.setMessage("");
			
			// 데이터 등록
			distService.updateErpPurchaseConfirm(param);
			
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
	 * 작성일 : 2018. 8. 13.
	 * 작성자 : CBK
	 * 설명   : 반품 상품 추가 정보 입력 팝업 URL 조회
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 8. 13. CBK - 최초생성
	 * </pre>
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/" + Constants.IFID.RETURN_POP_URL)
	public @ResponseBody String returnPopUrl(ReturnPopUrlReqDTO param) throws Exception {
		String ifId = Constants.IFID.RETURN_POP_URL;
		
		try {
			
			// ERP 처리 부분
			// 쇼핑몰 쪽으로 데이터 전송
			String resParam = sendUtil.send(param, ifId);
			
			// 처리 로그 등록
			logService.writeInterfaceLog(ifId, param, resParam, ReturnPopUrlResDTO.class);
			
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
	
	/**
	 * <pre>
	 * 작성일 : 2018. 8. 13.
	 * 작성자 : CBK
	 * 설명   : 반품 취소
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 8. 13. CBK - 최초생성
	 * </pre>
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/" + Constants.IFID.RETURN_CANCEL)
	public @ResponseBody String cancelReturn(OrderCancelReqDTO param) throws Exception {
		String ifId = Constants.IFID.RETURN_CANCEL;
		
		try {
			
			// ERP 처리 부분
			// Response DTO 생성
			OrderCancelResDTO resDto = new OrderCancelResDTO();
			resDto.setResult(Constants.RESULT.SUCCESS);
			resDto.setMessage("");
			
			// 반품 취소 처리
			distService.cancelOrder(param);

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
	 * 작성일 : 2018. 8. 13.
	 * 작성자 : CBK
	 * 설명   : 환불 완료
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 8. 13. CBK - 최초생성
	 * </pre>
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/" + Constants.IFID.REFUND_CMPLT)
	public @ResponseBody String completeRefund(RefundCmpltReqDTO param) throws Exception {
		String ifId = Constants.IFID.REFUND_CMPLT;
		
		try {

			// ERP 처리 부분
			// Response DTO 생성
			RefundCmpltResDTO resDto = new RefundCmpltResDTO();
			resDto.setResult(Constants.RESULT.SUCCESS);
			resDto.setMessage("");
			
			// 데이터 저장
			distService.completeRefund(param);
			
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
	 * 작성일 : 2018. 8. 20.
	 * 작성자 : CBK
	 * 설명   : 교환 완료 (반품 결제 정보 등록 및 재 발주 등록)
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 8. 20. CBK - 최초생성
	 * </pre>
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/" + Constants.IFID.EXCHANGE_CMPLT)
	public @ResponseBody String completeExchange(OrderRegReqDTO param) throws Exception {
		String ifId = Constants.IFID.EXCHANGE_CMPLT;
		
		try {
			// ERP 처리 부분
			// Response DTO 생성
			OrderRegResDTO resDto = new OrderRegResDTO();
			resDto.setResult(Constants.RESULT.SUCCESS);
			resDto.setMessage("");
			
			// 데이터 처리
			distService.completeChange(param);
			
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
	 * 작성일 : 2018. 9. 11.
	 * 작성자 : CBK
	 * 설명   : 반품신청 사유 확인 팝업
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 9. 11. CBK - 최초생성
	 * </pre>
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/" + Constants.IFID.RETURN_REASON_POP_URL)
	public @ResponseBody String returnReasonPopUrl(ReturnPopUrlReqDTO param) throws Exception {
		String ifId = Constants.IFID.RETURN_REASON_POP_URL;
		
		try {
			
			// ERP 처리 부분
			// 쇼핑몰 쪽으로 데이터 전송
			String resParam = sendUtil.send(param, ifId);
			
			// 처리 로그 등록
			logService.writeInterfaceLog(ifId, param, resParam, ReturnPopUrlResDTO.class);
			
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
