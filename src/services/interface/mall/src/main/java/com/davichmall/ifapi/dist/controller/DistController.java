package com.davichmall.ifapi.dist.controller;

import java.util.ArrayList;
import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.davichmall.ifapi.cmmn.CustomException;
import com.davichmall.ifapi.cmmn.base.BaseController;
import com.davichmall.ifapi.cmmn.constant.Constants;
import com.davichmall.ifapi.cmmn.mapp.dto.OrderMapDTO;
import com.davichmall.ifapi.dist.dto.ErpReturnConfirmReqDTO;
import com.davichmall.ifapi.dist.dto.ErpReturnConfirmReqDTO.ErpReturnOrdDtlDto;
import com.davichmall.ifapi.dist.dto.ErpReturnConfirmResDTO;
import com.davichmall.ifapi.dist.dto.MallReturnConfirmReqDTO;
import com.davichmall.ifapi.dist.dto.MallReturnConfirmReqDTO.ClaimInfoDTO;
import com.davichmall.ifapi.dist.dto.MallReturnConfirmResDTO;
import com.davichmall.ifapi.dist.dto.OrderCancelReqDTO;
import com.davichmall.ifapi.dist.dto.OrderCancelResDTO;
import com.davichmall.ifapi.dist.dto.OrderRegReqDTO;
import com.davichmall.ifapi.dist.dto.OrderRegReqDTO.OrderDetailDTO;
import com.davichmall.ifapi.dist.dto.OrderRegResDTO;
import com.davichmall.ifapi.dist.dto.OrderReleaseReqDTO;
import com.davichmall.ifapi.dist.dto.OrderReleaseResDTO;
import com.davichmall.ifapi.dist.dto.OrderReleaseResDTO.ReleaseFailDTO;
import com.davichmall.ifapi.dist.dto.PurchaseConfirmReqDTO;
import com.davichmall.ifapi.dist.dto.PurchaseConfirmReqDTO.PurchaseConfirmOrdDtlDTO;
import com.davichmall.ifapi.dist.dto.RefundCmpltReqDTO.RefundItemDTO;
import com.davichmall.ifapi.dist.dto.RefundCmpltResDTO;
import com.davichmall.ifapi.dist.dto.PurchaseConfirmResDTO;
import com.davichmall.ifapi.dist.dto.RefundCmpltReqDTO;
import com.davichmall.ifapi.dist.dto.ReturnPopUrlReqDTO;
import com.davichmall.ifapi.dist.dto.ReturnPopUrlResDTO;
import com.davichmall.ifapi.dist.dto.StoreDlvrCmpltReqDTO;
import com.davichmall.ifapi.dist.dto.StoreDlvrCmpltResDTO;
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
			
			// 쇼핑몰 처리부분
			
			/*OrderMapDTO ordMapDto = mappingService.getErpOrderNo(param.getOrderNo());*/
			OrderMapDTO ordMapDto = mappingService.getErpOrderNo(param);
			if(ordMapDto != null) {
				// 이미 등록된 주문번호 입니다.
				throw new CustomException("ifapi.exception.order.orderno.exist");
			}
			
			// ERP 상품코드로 변경
			for(OrderDetailDTO dtlDto : param.getOrdDtlList()) {
				if("Y".equals(dtlDto.getAddOptYn())) {
					// 추가 옵션 상품인 경우 상품코드 설정 안함.
					continue;
				}
				
				String erpItmCode = "";
				if(param.getOrdRute() != null && !"".equals(param.getOrdRute()) && !"3".equals(param.getOrdRute())) {
					if(dtlDto.getOrdRute()!=null && !dtlDto.getOrdRute().equals("3")) {
						erpItmCode = mappingService.getErpItemCode(dtlDto.getItmCode());
						if (erpItmCode == null) {
							// 매핑되지 않은 상품입니다.
							throw new CustomException("ifapi.exception.product.notmapped");
						}
					}
				}
				/*String erpItmCode = mappingService.getErpItemCode(dtlDto.getItmCode());
				if(erpItmCode == null) {
					// 매핑되지 않은 상품입니다.
					throw new CustomException("ifapi.exception.product.notmapped");
				}*/
				dtlDto.setErpItmCode(erpItmCode);
				
			}
			
			// 회원번호를 ERP회원코드로 변경 (없으면 없는대로 설정)
			if(param.getMemNo() != null) {
				param.setCdCust(mappingService.getErpMemberNo(param.getMemNo()));
			}
			
			// ERP쪽으로 데이터 전송
			String resParam = sendUtil.send(param, ifId);

			// 처리 로그 등록
			logService.writeInterfaceLog(ifId, param, resParam, OrderRegResDTO.class);
			
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
			
			// 쇼핑몰 처리부분
			
			// 주문번호를 ERP주문번호로 변경
			OrderMapDTO mapDto = mappingService.getErpOrderNo(param.getOrderNo());
			
			if(mapDto == null) {
				// 매핑되지 않은 주문번호입니다.
				throw new CustomException("ifapi.exception.order.orderno.notmapped");
			}
			
			// ERP주문 Key를 파라미터에 담기
			param.setOrdDate(mapDto.getErpOrdDate());
			param.setStrCode(mapDto.getErpStrCode());
			param.setOrdSlip(mapDto.getErpOrdSlip());
			
			// ERP쪽으로 데이터 전송
			String resParam = sendUtil.send(param, ifId);

			// 처리 로그 등록
			logService.writeInterfaceLog(ifId, param, resParam, OrderCancelResDTO.class);
			
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

			// 쇼핑몰 처리부분
			
			// ResponseDTO 생성
			OrderReleaseResDTO resDto = new OrderReleaseResDTO();
			resDto.setResult(Constants.RESULT.SUCCESS);
			resDto.setMessage("");
			
			// 처리 서비스 호출
			List<ReleaseFailDTO> failList = distService.insertReleaseInfo(param);
			resDto.setFailList(failList);
			
			// 처리로그 등록
			logService.writeInterfaceLog(ifId, param, resDto);
			
			// 결과 반환
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
			
			// 쇼핑몰 처리 부분

			// ResponseDTO 생성
			StoreDlvrCmpltResDTO resDto = new StoreDlvrCmpltResDTO();
			resDto.setResult(Constants.RESULT.SUCCESS);
			resDto.setMessage("");
			
			// ERP 주문번호를 쇼핑몰 주문번호로 바꾸기
			OrderMapDTO mapDto = mappingService.getMallOrderNo(param.getOrdDate(), param.getStrCode(), param.getOrdSlip());
			if(mapDto == null) {
				// 매핑되지 않은 주문번호입니다.
				throw new CustomException("ifapi.exception.order.orderno.notmapped");
			}
			String mallOrderNo = mapDto.getMallOrderNo().toString();
			param.setMallOrderNo(mallOrderNo);

			// ERP주문 상세 번호를 쇼핑몰 주문상세 번호로 바꾸기
			List<String> mallOrdDtlSeqList = new ArrayList<>();
			for(String ordSeq : param.getOrdSeq()) {
				OrderMapDTO mapDtlDto = mappingService.getMallOrderDtlNo(param.getOrdDate(), param.getStrCode(), param.getOrdSlip(), ordSeq, "000");
				if(mapDtlDto == null) {
					// 매핑되지 않은 주문상세번호입니다.
					throw new CustomException("ifapi.exception.order.orderdtlseq.notmapped");	
				}
				String mallOrdDtlSeq = mapDtlDto.getMallOrderDtlNo().toString();
				mallOrdDtlSeqList.add(mallOrdDtlSeq);
			}
			param.setMallOrdDtlSeq(mallOrdDtlSeqList);
			
			
			// 배송완료 처리
			distService.completeStoreDelivery(param);
			
			// 처리로그 등록
			logService.writeInterfaceLog(ifId, param, resDto);

			// 결과 반환
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
			// 쇼핑몰 처리 부분
			String claimNo="";
			if(param.getClaimNo()!=null && !param.getClaimNo().equals("")){
			    claimNo = param.getClaimNo();
			}

			// ERP 상품코드로 변경
			for(OrderDetailDTO dtlDto : param.getOrdDtlList()) {
				if("Y".equals(dtlDto.getAddOptYn())) {
					// 추가 옵션 상품인 경우 상품코드 설정 안함.
					continue;
				}
				String erpItmCode = mappingService.getErpItemCode(dtlDto.getItmCode());
				if(erpItmCode == null) {
					// 매핑되지 않은 상품입니다.
					throw new CustomException("ifapi.exception.product.notmapped");
				}
				dtlDto.setErpItmCode(erpItmCode);

			}
			
			// 회원번호를 ERP회원코드로 변경 (없으면 없는대로 설정)
			if(param.getMemNo() != null) {
				param.setCdCust(mappingService.getErpMemberNo(param.getMemNo()));
			}

			// 쇼핑몰 원발주 번호를 ERP 발주 번호로 변경
			/*OrderMapDTO orgMapDto = mappingService.getErpOrderNo(param.getOrderNo());*/
			//반품등록시에는 claim no 강제 세팅...
			param.setClaimNo(null);
			OrderMapDTO orgMapDto = mappingService.getErpOrderNo(param);
			if(orgMapDto == null) {
				// 매핑되지 않은 주문번호입니다.
				throw new CustomException("ifapi.exception.order.orderno.notmapped");
			}
			//클레임 번호 다시 세팅...
			param.setClaimNo(claimNo);
			param.setOrgOrdDate(orgMapDto.getErpOrdDate());
			param.setOrgStrCode(orgMapDto.getErpStrCode());
			param.setOrgOrdSlip(orgMapDto.getErpOrdSlip());
			
			// 주문 상세 데이터에 ERP 원 주문 번호 설정(결제 정보 등록시 원본 데이터를 참조하기 위해)
			for(OrderDetailDTO dtlDto : param.getOrdDtlList()) {
				OrderMapDTO mapDto = mappingService.getErpOrderDtlNo(param.getOrderNo(), dtlDto.getOrdDtlSeq());
				if(mapDto == null) {
					// 매핑되지 않은 주문상세번호입니다.
					throw new CustomException("ifapi.exception.order.orderdtlseq.notmapped");
				}
				dtlDto.setOrgOrdDate(mapDto.getErpOrdDate());
				dtlDto.setOrgStrCode(mapDto.getErpStrCode());
				dtlDto.setOrgOrdSlip(mapDto.getErpOrdSlip());
				dtlDto.setOrgOrdSeq(mapDto.getErpOrderDtlNo().toString());
				dtlDto.setOrgOrdAddNo(mapDto.getErpOrderAddNo().toString());
			}
			
			// ERP쪽으로 데이터 전송
			String resParam = sendUtil.send(param, ifId);
			
			// 처리 로그 등록
			logService.writeInterfaceLog(ifId, param, resParam, OrderRegResDTO.class);
			
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
			// 쇼핑몰 처리 부분
			// 쇼핑몰 반품번호로  ERP주문번호 조회
			for(ClaimInfoDTO dto : param.getClaimList()) {
				OrderMapDTO mapDto = mappingService.getErpClaimNo(dto.getClaimNo(), dto.getOrderNo(), dto.getOrdDtlSeq());
				
				if(mapDto == null) {
					// 매핑되지 않은 주문번호입니다.
					throw new CustomException("ifapi.exception.order.orderno.notmapped");
				}
				
				// ERP주문 Key를 파라미터에 담기
				dto.setOrdDate(mapDto.getErpOrdDate());
				dto.setStrCode(mapDto.getErpStrCode());
				dto.setOrdSlip(mapDto.getErpOrdSlip());
				dto.setOrdSeq(mapDto.getErpOrderDtlNo());
				dto.setOrdAddNo(mapDto.getErpOrderAddNo());
			}
			
			
			// ERP쪽으로 데이터 전송
			String resParam = sendUtil.send(param, ifId);
			
			// 처리 로그 등록
			logService.writeInterfaceLog(ifId, param, resParam, MallReturnConfirmResDTO.class);
			
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
			
			// 쇼핑몰 처리 부분
			// Response DTO 생성
			ErpReturnConfirmResDTO resDto = new ErpReturnConfirmResDTO();
			resDto.setResult(Constants.RESULT.SUCCESS);
			resDto.setMessage("");
			
			// ERP 반품주문 번호를 쇼핑몰 반품 번호로 변경
			for(ErpReturnOrdDtlDto dtlDto : param.getOrdDtlList()) {
				OrderMapDTO dtlMap = mappingService.getMallClaimNo(param.getOrdDate(), param.getStrCode(), param.getOrdSlip(), dtlDto.getOrdSeq(), dtlDto.getOrdAddNo());
				if(dtlMap == null) {
					// 매핑되지 않은 주문상세번호입니다.
					throw new CustomException("ifapi.exception.order.orderdtlseq.notmapped");	
				}
				dtlDto.setClaimNo(dtlMap.getMallClaimNo());
				dtlDto.setOrdNo(dtlMap.getMallOrderNo());
				dtlDto.setOrdDtlSeq(dtlMap.getMallOrderDtlNo());
			}
			
			// 수정자 설정
			param.setUpdrNo(Constants.IF_REGR_NO);
			
			// 반품처리
			distService.updateMallReturnConfirm(param);
			
			
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
			// 쇼핑몰 처리 부분
			// 쇼핑몰 주문 번호를 ERP 주문번호로 변경
			OrderMapDTO ordMap = mappingService.getErpOrderNo(param.getOrderNo());
			if(ordMap == null) {
				// 매핑되지 않은 주문번호입니다.
				throw new CustomException("ifapi.exception.order.orderno.notmapped");
			}
			// ERP주문 Key를 파라미터에 담기
			param.setOrdDate(ordMap.getErpOrdDate());
			param.setStrCode(ordMap.getErpStrCode());
			param.setOrdSlip(ordMap.getErpOrdSlip());
			
			// 쇼핑몰 주문상세번호를 ERP 주문상세 번호로 변경
			for(PurchaseConfirmOrdDtlDTO dtlDto : param.getOrdDtlList()) {
				OrderMapDTO ordDtlMap = mappingService.getErpOrderDtlNo(param.getOrderNo(), dtlDto.getOrdDtlSeq());
				if(ordDtlMap == null) {
					// 매핑되지 않은 주문상세번호입니다.
					throw new CustomException("ifapi.exception.order.orderdtlseq.notmapped");
				}
				dtlDto.setOrdSeq(ordDtlMap.getErpOrderDtlNo());
				dtlDto.setOrdAddNo(ordDtlMap.getErpOrderAddNo());
			}
			
			// ERP 쪽으로 데이터 전송
			String resParam = sendUtil.send(param, ifId);
			
			// 처리 로그 등록
			logService.writeInterfaceLog(ifId, param, resParam, PurchaseConfirmResDTO.class);
			
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
			
			// 쇼칭몰 처리 부분
			// Response DTO 생성
			ReturnPopUrlResDTO resDto = new ReturnPopUrlResDTO();
			resDto.setResult(Constants.RESULT.SUCCESS);
			resDto.setMessage("");
			
			// ERP 반품 번호를 쇼핑몰 반품 번호로 변경
			OrderMapDTO mapDto = mappingService.getMallClaimNo(param.getOrdDate(), param.getStrCode(), param.getOrdSlip(), param.getOrdSeq(), param.getOrdAddNo());
			if(mapDto == null) {
				// 매핑되지 않은 주문번호입니다.
				throw new CustomException("ifapi.exception.order.orderno.notmapped");
			}
			param.setMallClaimNo(mapDto.getMallClaimNo());
			param.setMallOrderNo(mapDto.getMallOrderNo());
			param.setMallOrderDtlNo(mapDto.getMallOrderDtlNo());

			// 팝업  URL 조회
			String popUrl = distService.getMallReturnAddInfoPopUrl(param);
			resDto.setPopUrl(popUrl);

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
			// 쇼핑몰 처리 부분
			// 쇼핑몰 반품 번호를 다비젼 반품 번호로 변경
			OrderMapDTO mapDto = mappingService.getErpClaimNo(param.getClaimNo(), null, null);
			if(mapDto == null) {
				// 매핑되지 않은 주문번호입니다.
				throw new CustomException("ifapi.exception.order.orderno.notmapped");
			}
			param.setOrdDate(mapDto.getErpOrdDate());
			param.setStrCode(mapDto.getErpStrCode());
			param.setOrdSlip(mapDto.getErpOrdSlip());
			
			// ERP 쪽으로 데이터 전송
			String resParam = sendUtil.send(param, ifId);
			
			// 처리 로그 등록
			logService.writeInterfaceLog(ifId, param, resParam, OrderCancelResDTO.class);
			
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
			// 쇼핑몰 처리 부분
			// 쇼핑몰 반품 번호를 ERP반품 번호로 변경
			OrderMapDTO mapDto = mappingService.getErpClaimNo(param.getClaimNo(), param.getOrderNo(), null);
			param.setOrdDate(mapDto.getErpOrdDate());
			param.setStrCode(mapDto.getErpStrCode());
			param.setOrdSlip(mapDto.getErpOrdSlip());
			
			// 쇼핑몰 반품 상세 번호를 ERP반품 상세 번호로 변경 
			for(RefundItemDTO dtl : param.getOrdDtlList()) {
				OrderMapDTO dtlMapDto = mappingService.getErpClaimNo(param.getClaimNo(), param.getOrderNo(), dtl.getOrderDtlSeq());
				dtl.setOrdSeq(dtlMapDto.getErpOrderDtlNo());
				dtl.setOrdAddNo(dtlMapDto.getErpOrderAddNo());
			}
			
			// ERP 쪽으로 데이터 전송
			String resParam = sendUtil.send(param, ifId);
			
			// 처리 로그 등록
			logService.writeInterfaceLog(ifId, param, resParam, RefundCmpltResDTO.class);
			
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
			// 쇼핑몰 처리 부분
			// 쇼핑몰 반품 번호를 ERP반품 번호로 변경
			OrderMapDTO mapDto = mappingService.getErpClaimNo(param.getClaimNo(), param.getOrgOrderNo(), null);
			if(mapDto == null) {
				// 매핑되지 않은 주문번호입니다.
				throw new CustomException("ifapi.exception.order.orderno.notmapped");
			}
			param.setOrderDate(mapDto.getErpOrdDate());
			param.setStrCode(mapDto.getErpStrCode());
			param.setOrdSlip(mapDto.getErpOrdSlip());

			// 쇼핑몰 반품상세번호로  ERP주문상세번호 조회
			for(OrderDetailDTO dto : param.getOrdDtlList()) {
				OrderMapDTO dtlMapDto = mappingService.getErpClaimNo(param.getClaimNo(), param.getOrderNo(), dto.getOrgOrdDtlSeq());
				
				if(dtlMapDto == null) {
					// 매핑되지 않은 주문번호입니다.
					throw new CustomException("ifapi.exception.order.orderno.notmapped");
				}
				
				// ERP주문 Key를 파라미터에 담기
				dto.setOrdDate(dtlMapDto.getErpOrdDate());
				dto.setStrCode(dtlMapDto.getErpStrCode());
				dto.setOrdSlip(dtlMapDto.getErpOrdSlip());
				dto.setErpOrdDtlSeq(dtlMapDto.getErpOrderDtlNo());
				dto.setErpOrdAddNo(dtlMapDto.getErpOrderAddNo());
			}

			// ERP 상품코드로 변경
			for(OrderDetailDTO dtlDto : param.getOrdDtlList()) {
				if("Y".equals(dtlDto.getAddOptYn())) {
					// 추가 옵션 상품인 경우 상품코드 설정 안함.
					continue;
				}
				String erpItmCode = mappingService.getErpItemCode(dtlDto.getItmCode());
				if(erpItmCode == null) {
					// 매핑되지 않은 상품입니다.
					throw new CustomException("ifapi.exception.product.notmapped");
				}
				dtlDto.setErpItmCode(erpItmCode);
			}
			
			// 회원번호를 ERP회원코드로 변경 (없으면 없는대로 설정)
			if(param.getMemNo() != null) {
				param.setCdCust(mappingService.getErpMemberNo(param.getMemNo()));
			}
			
			// ERP쪽으로 데이터 전송
			String resParam = sendUtil.send(param, ifId);

			// 처리 로그 등록
			logService.writeInterfaceLog(ifId, param, resParam, OrderRegResDTO.class);
			
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
			
			// 쇼칭몰 처리 부분
			// Response DTO 생성
			ReturnPopUrlResDTO resDto = new ReturnPopUrlResDTO();
			resDto.setResult(Constants.RESULT.SUCCESS);
			resDto.setMessage("");
			
			// ERP 반품 번호를 쇼핑몰 반품 번호로 변경
			OrderMapDTO mapDto = mappingService.getMallClaimNo(param.getOrdDate(), param.getStrCode(), param.getOrdSlip(), param.getOrdSeq(), param.getOrdAddNo());
			if(mapDto == null) {
				// 매핑되지 않은 주문번호입니다.
				throw new CustomException("ifapi.exception.order.orderno.notmapped");
			}
			param.setMallClaimNo(mapDto.getMallClaimNo());
			param.setMallOrderNo(mapDto.getMallOrderNo());
			param.setMallOrderDtlNo(mapDto.getMallOrderDtlNo());

			// 팝업  URL 조회
			String popUrl = distService.getMallReturnReasonPopUrl(param);
			resDto.setPopUrl(popUrl);

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
