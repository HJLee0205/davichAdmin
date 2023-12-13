package com.davichmall.ifapi.rsv.controller;


import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.davichmall.ifapi.cmmn.CustomException;
import com.davichmall.ifapi.cmmn.base.BaseController;
import com.davichmall.ifapi.cmmn.constant.Constants;
import com.davichmall.ifapi.cmmn.mapp.dto.OrderMapDTO;
import com.davichmall.ifapi.rsv.dto.PreorderPromotionModReqDTO;
import com.davichmall.ifapi.rsv.dto.PreorderPromotionModResDTO;
import com.davichmall.ifapi.rsv.dto.PreorderPromotionRegReqDTO;
import com.davichmall.ifapi.rsv.dto.PreorderPromotionRegResDTO;
import com.davichmall.ifapi.rsv.dto.PreorderRegReqDTO;
import com.davichmall.ifapi.rsv.dto.PreorderRegReqDTO.PreorderProductDTO;
import com.davichmall.ifapi.rsv.dto.PreorderRegResDTO;
import com.davichmall.ifapi.rsv.dto.ReserveOrderSearchReqDTO;
import com.davichmall.ifapi.rsv.dto.ReserveOrderSearchResDTO;
import com.davichmall.ifapi.rsv.dto.ReserveOrderSearchResDTO.ReserveOrderDTO;
import com.davichmall.ifapi.rsv.dto.ReserveProductSearchReqDTO;
import com.davichmall.ifapi.rsv.dto.ReserveProductSearchResDTO;
import com.davichmall.ifapi.rsv.dto.ReserveProductSearchResDTO.ReserveProductDTO;
import com.davichmall.ifapi.rsv.dto.StoreChaoticReqDTO;
import com.davichmall.ifapi.rsv.dto.StoreChaoticResDTO;
import com.davichmall.ifapi.rsv.dto.StoreDtlInfoReqDTO;
import com.davichmall.ifapi.rsv.dto.StoreDtlInfoResDTO;
import com.davichmall.ifapi.rsv.dto.StoreHolidayReqDTO;
import com.davichmall.ifapi.rsv.dto.StoreHolidayResDTO;
import com.davichmall.ifapi.rsv.dto.StoreSearchReqDTO;
import com.davichmall.ifapi.rsv.dto.StoreSearchResDTO;
import com.davichmall.ifapi.rsv.dto.StoreVisitReserveCancelReqDTO;
import com.davichmall.ifapi.rsv.dto.StoreVisitReserveCancelResDTO;
import com.davichmall.ifapi.rsv.dto.StoreVisitReserveMdfyReqDTO;
import com.davichmall.ifapi.rsv.dto.StoreVisitReserveMdfyResDTO;
import com.davichmall.ifapi.rsv.dto.StoreVisitReserveRegReqDTO;
import com.davichmall.ifapi.rsv.dto.StoreVisitReserveRegReqDTO.ReservePrdDTO;
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
			
			// 쇼핑몰 처리 부분
			// ERP쪽으로 데이터 전송
			String resParam = sendUtil.send(param, ifId);
			
			// 처리 로그 등록
			logService.writeInterfaceLog(ifId, param, resParam, StoreChaoticResDTO.class);
			
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
			// 쇼핑몰 처리 부분
			
			// 회원 번호가 있으면 ERP 회원 번호로 전환
			if(param.getMemNo() != null && !"".equals(param.getMemNo())) {
				String cdCust = mappingService.getErpMemberNo(param.getMemNo());
				param.setCdCust(cdCust);
			}
			
			// 예약 상품이 있으면 다비젼 상품코드로 변환
			if(param.getRsvPrdList() != null) {
				for(ReservePrdDTO dtl : param.getRsvPrdList()) {
					String erpItmCode = mappingService.getErpItemCode(dtl.getItmCode());
					if(erpItmCode == null) {
						// 매핑되지 않은 상품입니다.
						throw new CustomException("ifapi.exception.product.notmapped");
					}
					String [] itmCodes = erpItmCode.split(",");
					if(itmCodes.length>1) {
						dtl.setErpItmCode(itmCodes[0]);
						dtl.setErpItmCodeAdd(itmCodes[1]);
					}else{
						dtl.setErpItmCode(erpItmCode);
					}
				}
			}
			
			// ERP 쪽으로 데이터 전송
			String resParam = sendUtil.send(param, ifId);
			
			// 처리 로그 등록
			logService.writeInterfaceLog(ifId, param, resParam, StoreVisitReserveRegResDTO.class);
			
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
			
			// 쇼핑몰 처리 부분
			// ERP쪽으로 데이터 전송
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
			
			// 쇼핑몰 처리 부분
			// ResponseDTO 생성
			StoreVisitReserveCancelResDTO resDto = new StoreVisitReserveCancelResDTO();
			resDto.setResult(Constants.RESULT.SUCCESS);
			resDto.setMessage("");
			
			// 수정자 ID설정
			param.setUpdrNo(Constants.IF_REGR_NO.toString());
			
			// 데이터 등록
			reserveService.cancelMallStoreVisitReserveInfo(param);
			
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

			// 쇼핑몰 처리 부분
			// ResponseDTO 생성
			StoreVisitReserveMdfyResDTO resDto = new StoreVisitReserveMdfyResDTO();
			resDto.setResult(Constants.RESULT.SUCCESS);
			resDto.setMessage("");
			
			// 등록자 ID설정
			param.setRegrNo(Constants.IF_REGR_NO.toString());
			
			// 데이터 등록
			String rsvNo = reserveService.updateStoreVisitReserveInfo(param);
			
			// 응답 데이터 설정
			resDto.setMallRsvNo(rsvNo);
			
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
			// 쇼핑몰 처리 부분
			// ERP쪽으로 데이터 전송
			String resParam = sendUtil.send(param, ifId);;
			
			// 처리 로그 등록
			logService.writeInterfaceLog(ifId, param, resParam, StoreSearchResDTO.class);
			
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
			// 쇼핑몰 처리 부분
			// ERP쪽으로 데이터 전송
			String resParam = sendUtil.send(param, ifId);;
			
			// 처리 로그 등록
			logService.writeInterfaceLog(ifId, param, resParam, StoreDtlInfoResDTO.class);
			
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
	@RequestMapping(value="/" + Constants.IFID.RESERVE_PRODUCT_SEARCH)
	public @ResponseBody String getReserveProductList(ReserveProductSearchReqDTO param) throws Exception {
		
		String ifId = Constants.IFID.RESERVE_PRODUCT_SEARCH;
		
		try {

			// 쇼핑몰 처리 부분
			// Response DTO 생성
			ReserveProductSearchResDTO resDto = new ReserveProductSearchResDTO();
			resDto.setResult(Constants.RESULT.SUCCESS);
			resDto.setMessage("");
			
			// 데이터 조회
			List<ReserveProductDTO> prdList = reserveService.getReserveProductList(param);
			
			// 쇼핑몰 상품코드를 다비젼 상품 코드로 변환
			if(prdList != null && prdList.size() > 0) {
				for(ReserveProductDTO prd : prdList) {
					// 추가 옵션이 아닌 경우 변환
					if(!"Y".equals(prd.getAddOptYn())) {
						String erpItmCode = mappingService.getErpItemCode(prd.getMallItmCode());
						prd.setItmCode(erpItmCode);
					}
				}
			}
			// Response DTO에 설정
			resDto.setPrdList(prdList);
			
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
	@RequestMapping(value="/" + Constants.IFID.RESERVE_ORDER_SEARCH)
	public @ResponseBody String getReserveOrderList(ReserveOrderSearchReqDTO param) throws Exception {
		String ifId = Constants.IFID.RESERVE_ORDER_SEARCH;
		
		try {
			
			// 쇼핑몰 처리 부분
			// Response DTO 생성
			ReserveOrderSearchResDTO resDto = new ReserveOrderSearchResDTO();
			resDto.setResult(Constants.RESULT.SUCCESS);
			resDto.setMessage("");
			
			// 데이터 조회
			List<ReserveOrderDTO> ordList = reserveService.getReserveOrderList(param);
			
			// 쇼핑몰 주문번호를 다비젼 주문번호로 변환
			if(ordList != null && ordList.size() > 0) {
				for(ReserveOrderDTO ord : ordList) {
					OrderMapDTO mapDto = mappingService.getErpOrderNo(ord.getMallOrdNo());
					if(mapDto != null) {
						ord.setOrdDate(mapDto.getErpOrdDate());
						ord.setStrCode(mapDto.getErpStrCode());
						ord.setOrdSlip(mapDto.getErpOrdSlip());
					}
				}
			}
			// Response DTO에 설정
			resDto.setOrdList(ordList);
			
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
			
			// 쇼핑몰 처리 부분
			// 이미 등록된 기획전인지 확인
			if(mappingService.getErpPrmtNo(param.getPrmtNo()) != null) {
				// 이미 등록된 사전예약 기획전 입니다.
				throw new CustomException("ifapi.exception.reserve.preorder.mapped.already");
			}
			
			// ERP 쪽으로 데이터 전송
			String resParam = sendUtil.send(param, ifId);
			
			// 처리 로그 등록
			logService.writeInterfaceLog(ifId, param, resParam, PreorderPromotionRegResDTO.class);
			
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
			// 쇼핑몰 처리 부분
			// 쇼핑몰 기획전 번호를 ERP 기획전 번호로 변경
			String erpPrmtNo = mappingService.getErpPrmtNo(param.getPrmtNo());
			if(erpPrmtNo == null) {
				// 매핑되지 않은 사전예약 기획전 입니다.
				throw new CustomException("ifapi.exception.reserve.preorder.notmapped");
			}
			param.setErpPrmtNo(erpPrmtNo);
			
			// 쇼핑몰 상품번호를 ERP 상품 번호로 변경
			for(PreorderProductDTO prdDto : param.getPrdList()) {
				String erpItmCode = mappingService.getErpItemCode(prdDto.getItmCode());
				if(erpItmCode == null) {
					// 매핑되지 않은 상품입니다.
					throw new CustomException("ifapi.exception.product.notmapped");
				}
				prdDto.setErpItmCode(erpItmCode);
			}
			
			// ERP쪽으로 데이터 전송
			String resParam = sendUtil.send(param, ifId);
			
			// 처리 로그 등록
			logService.writeInterfaceLog(ifId, param, resParam, PreorderRegResDTO.class);
			
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
			
			// 쇼핑몰 처리 부분
			// 쇼핑몰 기획전 번호를 ERP 기획전 번호로 변경
			String erpPrmtNo = mappingService.getErpPrmtNo(param.getPrmtNo());
			if(erpPrmtNo == null) {
				// 매핑되지 않은 사전예약 기획전 입니다.
				throw new CustomException("ifapi.exception.reserve.preorder.notmapped");
			}
			param.setErpPrmtNo(erpPrmtNo);
			
			// ERP 쪽으로 데이터 전송
			String resParam = sendUtil.send(param, ifId);
			
			// 처리 로그 등록
			logService.writeInterfaceLog(ifId, param, resParam, PreorderPromotionModResDTO.class);
			
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
			// 쇼핑몰 처리 부분
			// ERP 쪽으로 데이터 전송
			String resParam = sendUtil.send(param, ifId);
			
			// 처리 로그 등록
			logService.writeInterfaceLog(ifId, param, resParam, StoreHolidayResDTO.class);
			
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
			
			// 쇼핑몰 처리 부분
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
}
