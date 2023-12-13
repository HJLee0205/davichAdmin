package com.davichmall.ifapi.rsv.controller;


import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.davichmall.ifapi.cmmn.CustomException;
import com.davichmall.ifapi.cmmn.base.BaseController;
import com.davichmall.ifapi.cmmn.constant.Constants;
import com.davichmall.ifapi.rsv.dto.PreorderPromotionModReqDTO;
import com.davichmall.ifapi.rsv.dto.PreorderPromotionModResDTO;
import com.davichmall.ifapi.rsv.dto.PreorderPromotionRegReqDTO;
import com.davichmall.ifapi.rsv.dto.PreorderPromotionRegResDTO;
import com.davichmall.ifapi.rsv.dto.PreorderRegReqDTO;
import com.davichmall.ifapi.rsv.dto.PreorderRegResDTO;
import com.davichmall.ifapi.rsv.dto.ReserveOrderSearchReqDTO;
import com.davichmall.ifapi.rsv.dto.ReserveOrderSearchResDTO;
import com.davichmall.ifapi.rsv.dto.ReserveProductSearchReqDTO;
import com.davichmall.ifapi.rsv.dto.ReserveProductSearchResDTO;
import com.davichmall.ifapi.rsv.dto.StoreChaoticReqDTO;
import com.davichmall.ifapi.rsv.dto.StoreChaoticResDTO;
import com.davichmall.ifapi.rsv.dto.StoreChaoticResDTO.StoreChaoticDTO;
import com.davichmall.ifapi.rsv.dto.StoreDtlInfoReqDTO;
import com.davichmall.ifapi.rsv.dto.StoreDtlInfoResDTO;
import com.davichmall.ifapi.rsv.dto.StoreHolidayReqDTO;
import com.davichmall.ifapi.rsv.dto.StoreHolidayResDTO;
import com.davichmall.ifapi.rsv.dto.StoreSearchReqDTO;
import com.davichmall.ifapi.rsv.dto.StoreSearchResDTO;
import com.davichmall.ifapi.rsv.dto.StoreSearchResDTO.StoreInfoDTO;
import com.davichmall.ifapi.rsv.dto.StoreVisitReserveCancelReqDTO;
import com.davichmall.ifapi.rsv.dto.StoreVisitReserveCancelResDTO;
import com.davichmall.ifapi.rsv.dto.StoreVisitReserveMdfyReqDTO;
import com.davichmall.ifapi.rsv.dto.StoreVisitReserveMdfyResDTO;
import com.davichmall.ifapi.rsv.dto.StoreVisitReserveRegReqDTO;
import com.davichmall.ifapi.rsv.dto.StoreVisitReserveRegResDTO;
import com.davichmall.ifapi.rsv.service.ReserveService;

/**
 * <pre>
 * - 프로젝트명    : davichmall_interface
 * - 패키지명      : com.davichmall.ifapi.rsv.controller
 * - 파일명        : ReserveController.java
 * - 작성일        : 2018. 6. 18.
 * - 작성자        : CBK
 * - 설명          : 예약 관련 인터페이스 처리를 위한 Controller
 * </pre>
 */
@Controller
public class ReserveController extends BaseController {
	
	@Resource(name="reserveService")
	ReserveService reserveService;
	
	/**
	 * <pre>
	 * 작성일 : 2018. 6. 22.
	 * 작성자 : CBK
	 * 설명   : 가맹점의 혼잡도 조회(특정요일)
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 6. 22. CBK - 최초생성
	 * </pre>
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/" + Constants.IFID.STORE_CHAOTIC_SEARCH)
	public @ResponseBody String searchStoreChaotic(StoreChaoticReqDTO param) throws Exception {
		
		String ifId = Constants.IFID.STORE_CHAOTIC_SEARCH;
		try {

			// ERP 처리 부분
			StoreChaoticResDTO resDto = new StoreChaoticResDTO();
			resDto.setResult(Constants.RESULT.SUCCESS);
			resDto.setMessage("");
			
			// 데이터 조회
			List<StoreChaoticDTO> storeChaoticList = reserveService.getStoreChaoticList(param);
			resDto.setStoreChaoticList(storeChaoticList);
			
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
	 * 작성일 : 2018. 6. 22.
	 * 작성자 : CBK
	 * 설명   : 매장 방문 예약 등록
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 6. 22. CBK - 최초생성
	 * </pre>
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/" + Constants.IFID.STORE_VISIT_RESERVE_REG)
	public @ResponseBody String regStoreVisitReservation(StoreVisitReserveRegReqDTO param) throws Exception {
		
		String ifId = Constants.IFID.STORE_VISIT_RESERVE_REG;
		
		try {
			// ERP 처리 부분
			
			// ResponseDTO 생성
			StoreVisitReserveRegResDTO resDto = new StoreVisitReserveRegResDTO();
			resDto.setResult(Constants.RESULT.SUCCESS);
			resDto.setMessage("");
			
			// 데이터 등록
			reserveService.insertStoreVisitReserveInfo(param);
			
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
	 * 작성일 : 2018. 6. 25.
	 * 작성자 : CBK
	 * 설명   : 다비젼 매장 방문 예약 취소(from Mall)
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 6. 25. CBK - 최초생성
	 * </pre>
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/" + Constants.IFID.STORE_VISIT_RESERVE_CANCEL_FROM_MALL)
	public @ResponseBody String cancelErpStoreVisitReservation(StoreVisitReserveCancelReqDTO param) throws Exception {
		
		String ifId = Constants.IFID.STORE_VISIT_RESERVE_CANCEL_FROM_MALL;
		
		try {

			// ERP 처리 부분
			// ResponseDTO 생성
			StoreVisitReserveCancelResDTO resDto = new StoreVisitReserveCancelResDTO();
			resDto.setResult(Constants.RESULT.SUCCESS);
			resDto.setMessage("");
			
			// 데이터 등록
			reserveService.cancelErpStoreVisitReserveInfo(param);
			
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
	 * 작성일 : 2018. 6. 25.
	 * 작성자 : CBK
	 * 설명   : 쇼핑몰 매장 방문 예약 취소(from ERP)
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 6. 25. CBK - 최초생성
	 * </pre>
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/" + Constants.IFID.STORE_VISIT_RESERVE_CANCEL_FROM_ERP)
	public @ResponseBody String cancelMallStoreVisitReservation(StoreVisitReserveCancelReqDTO param) throws Exception {

		String ifId = Constants.IFID.STORE_VISIT_RESERVE_CANCEL_FROM_ERP;
		
		try {
			
			// ERP 처리 부분
			// 쇼핑몰 쪽으로 데이터 전송
			String resParam = sendUtil.send(param, ifId);
			
			// 처리 로그 등록
			logService.writeInterfaceLog(ifId, param, resParam, StoreVisitReserveCancelResDTO.class);
			
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
	 * 작성일 : 2018. 6. 25.
	 * 작성자 : CBK
	 * 설명   : 방문 예약 수정(From ERP)
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 6. 25. CBK - 최초생성
	 * </pre>
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/" + Constants.IFID.STORE_VISIT_RESERVE_MDFY_FROM_ERP)
	public @ResponseBody String modifyMallStoreVisitReservation(StoreVisitReserveMdfyReqDTO param) throws Exception {
		String ifId = Constants.IFID.STORE_VISIT_RESERVE_MDFY_FROM_ERP;
		
		try {
			// ERP 처리 부분
			
			// 쇼핑몰 쪽으로 데이터 전송
			String resParam = sendUtil.send(param, ifId);
			
			// 처리 로그 등록
			logService.writeInterfaceLog(ifId, param, resParam, StoreVisitReserveMdfyResDTO.class);
			
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
	 * 작성일 : 2018. 6. 18.
	 * 작성자 : CBK
	 * 설명   : 가맹점 목록 조회
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 6. 18. CBK - 최초생성
	 * </pre>
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/" + Constants.IFID.STORE_LIST_SEARCH)
	public @ResponseBody String searchStoreList(StoreSearchReqDTO param) throws Exception {

		String ifId = Constants.IFID.STORE_LIST_SEARCH;
		try {
			
			// ERP 처리 부분
			// ResponseDTO 생성
			StoreSearchResDTO resDto = new StoreSearchResDTO();
			resDto.setResult(Constants.RESULT.SUCCESS);
			resDto.setMessage("");
			
			// 데이터 조회
			if(param.getErpItmCode() != null && !"".equals(param.getErpItmCode())) {
				
	    		String [] arrErpItmCode = param.getErpItmCode().split(",");
	    		param.setArrErpItmCode(arrErpItmCode);
		    	
				// 다비전코드로 가맹점 코드 조회
				List<StoreInfoDTO> strCodeList = reserveService.getStrCodeList(param);
				if(strCodeList != null && strCodeList.size() > 0) {
					String strCode = "";
					for(int i=0; i<strCodeList.size(); i++) {
						if(!"".equals(strCode)) {
							strCode += ",";
						}
						strCode += "'" + strCodeList.get(i).getStrCode() + "'";
					}
					param.setStrCodeList(strCode);
				}
			}
			List<StoreInfoDTO> storeList = reserveService.getStoreList(param);
			// 데이터 건수 조회
			int totalCnt = reserveService.countStoreList(param);
			
			// 조회한 데이터 설정
			resDto.setStrList(storeList);
			resDto.setTotalCnt(totalCnt);
			
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
	 * 작성일 : 2018. 6. 18.
	 * 작성자 : CBK
	 * 설명   : 가맹점 상세 정보 조회
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 6. 18. CBK - 최초생성
	 * </pre>
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/" + Constants.IFID.STORE_DEATIL_INFO)
	public @ResponseBody String getStoreDetailInfo(StoreDtlInfoReqDTO param) throws Exception {

		String ifId = Constants.IFID.STORE_DEATIL_INFO;
		try {
			// ERP 처리 부분
			// 데이터 조회
			int strExist = 1;
			if(param.getErpItmCode() != null && !"".equals(param.getErpItmCode())) {
				// 다비전코드로 가맹점 코드 조회
				StoreSearchReqDTO dto = new StoreSearchReqDTO();
				/*dto.setErpItmCode(param.getErpItmCode());*/
				String [] arrErpItmCode = param.getErpItmCode().split(",");
	    		dto.setArrErpItmCode(arrErpItmCode);

				List<StoreInfoDTO> strCodeList = reserveService.getStrCodeList(dto);
				if(strCodeList != null && strCodeList.size() > 0) {
					strExist = 0;
					for(int i=0; i<strCodeList.size(); i++) {
						if(param.getStrCode().equals(strCodeList.get(i).getStrCode())) {
							strExist = 1;
							break;
						}
					}
				}
			}
			// 기본값 설정
			StoreDtlInfoResDTO resDto = new StoreDtlInfoResDTO();
			if(strExist > 0) {
				resDto = reserveService.getStoreDtlInfo(param);
				resDto.setMessage("");
				resDto.setResult(Constants.RESULT.SUCCESS);
			}else {
				resDto.setMessage("해당 상품은 단골매장에서 구매하실 수 없습니다.");
				resDto.setResult(Constants.RESULT.SUCCESS);
			}
			
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
	 * 작성일 : 2018. 6. 29.
	 * 작성자 : CBK
	 * 설명   : 방문 예약 주문 목록 조회
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 6. 29. CBK - 최초생성
	 * </pre>
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/" + Constants.IFID.RESERVE_PRODUCT_SEARCH)
	public @ResponseBody String getReserveProductList(ReserveProductSearchReqDTO param) throws Exception {
		
		String ifId = Constants.IFID.RESERVE_PRODUCT_SEARCH;
		
		try {
			// ERP 처리 부분
			
			// 쇼핑몰 쪽으로 데이터 전송
			String resParam = sendUtil.send(param, ifId);
			
			// 처리 로그 등록
			logService.writeInterfaceLog(ifId, param, resParam, ReserveProductSearchResDTO.class);
			
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
	 * 작성일 : 2018. 6. 29.
	 * 작성자 : CBK
	 * 설명   : 방문 예약 주문 목록 조회
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 6. 29. CBK - 최초생성
	 * </pre>
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/" + Constants.IFID.RESERVE_ORDER_SEARCH)
	public @ResponseBody String getReserveOrderList(ReserveOrderSearchReqDTO param) throws Exception {
		String ifId = Constants.IFID.RESERVE_ORDER_SEARCH;
		
		try {
			
			// ERP 처리 부분
			
			// 쇼핑몰 쪽으로 데이터 전송
			String resParam = sendUtil.send(param, ifId);
			
			//  처리 로그 등록
			logService.writeInterfaceLog(ifId, param, resParam, ReserveOrderSearchResDTO.class);
			
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
	 * 작성일 : 2018. 7. 2.
	 * 작성자 : CBK
	 * 설명   : 사전예약 기획전 등록
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 7. 2. CBK - 최초생성
	 * </pre>
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/" + Constants.IFID.PREORDER_PROMOTION_REG)
	public @ResponseBody String insertPreorderPromotion(PreorderPromotionRegReqDTO param) throws Exception {
		String ifId = Constants.IFID.PREORDER_PROMOTION_REG;
		try {
			
			// ERP 처리 부분
			// Response DTO 생성
			PreorderPromotionRegResDTO resDto = new PreorderPromotionRegResDTO();
			resDto.setResult(Constants.RESULT.SUCCESS);
			resDto.setMessage("");
			
			// 데이터 등록
			String erpPrmtNo = reserveService.insertPreorderCtrCode(param);
			
			// Response DTO에 필요 정보 세팅
			resDto.setMallPrmtNo(param.getPrmtNo());
			resDto.setErpPrmtNo(erpPrmtNo);

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
	 * 작성일 : 2018. 7. 2.
	 * 작성자 : CBK
	 * 설명   : 사전예약 주문 등록
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 7. 2. CBK - 최초생성
	 * </pre>
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/" + Constants.IFID.PREORDER_REG)
	public @ResponseBody String insertPreorder(PreorderRegReqDTO param) throws Exception {
		String ifId = Constants.IFID.PREORDER_REG;
		
		try {
			
			// ERP 처리 부분
			// Response DTO 생성
			PreorderRegResDTO resDto = new PreorderRegResDTO();
			resDto.setResult(Constants.RESULT.SUCCESS);
			resDto.setMessage("");
			
			// 데이터 저장
			reserveService.insertPreorderInfo(param);
			
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
	 * 작성일 : 2018. 7. 4.
	 * 작성자 : CBK
	 * 설명   : 사전 예약 기획전 정보 수정
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 7. 4. CBK - 최초생성
	 * </pre>
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/" + Constants.IFID.PREORDER_PROMOTION_MOD)
	public @ResponseBody String updatePreorderPromotion(PreorderPromotionModReqDTO param) throws Exception {
		
		String ifId = Constants.IFID.PREORDER_PROMOTION_MOD;
		
		try {
			
			// ERP 처리 부분
			// Response DTO 생성
			PreorderPromotionModResDTO resDto = new PreorderPromotionModResDTO();
			resDto.setResult(Constants.RESULT.SUCCESS);
			resDto.setMessage("");
			
			// 데이터 수정
			reserveService.updatePreorderPromotion(param);
			
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
	 * 작성일 : 2018. 7. 27.
	 * 작성자 : CBK
	 * 설명   : 가맹점의 특정월 휴일 목록 조회
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 7. 27. CBK - 최초생성
	 * </pre>
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/" + Constants.IFID.STORE_HOLIDAY_SEARCH)
	public @ResponseBody String searchStoreHoliday(StoreHolidayReqDTO param) throws Exception {
		String ifId = Constants.IFID.STORE_HOLIDAY_SEARCH;
		
		try {
			
			// ERP 처리 부분
			// Response DTO 생성
			StoreHolidayResDTO resDto = new StoreHolidayResDTO();
			resDto.setResult(Constants.RESULT.SUCCESS);
			resDto.setMessage("");
			
			// 휴일 목록 조회
			List<String> holidayList = reserveService.getStoreHolidayList(param);
			resDto.setHolidayList(holidayList);
			
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
	 * 작성일 : 2018. 9. 20.
	 * 작성자 : CBK
	 * 설명   : 매장방문 예약 수정(쇼핑몰에서) - 방문 목적만 수정가능
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 9. 20. CBK - 최초생성
	 * </pre>
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/" + Constants.IFID.STORE_VISIT_RESERVE_MDFY_FROM_MALL)
	public @ResponseBody String mdfyStoreVisitReservation(StoreVisitReserveMdfyReqDTO param) throws Exception {
		String ifId = Constants.IFID.STORE_VISIT_RESERVE_MDFY_FROM_MALL;
		
		try {
			// ERP 처리 부분
			// Response DTO 생성
			StoreVisitReserveMdfyResDTO resDto = new StoreVisitReserveMdfyResDTO();
			resDto.setResult(Constants.RESULT.SUCCESS);
			resDto.setMessage("");
			
			// 데이터 수정
			reserveService.updateErpStoreVisitReserveInfo(param);
			
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
}
