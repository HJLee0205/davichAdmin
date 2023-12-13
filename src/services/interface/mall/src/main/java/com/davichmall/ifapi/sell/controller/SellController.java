package com.davichmall.ifapi.sell.controller;

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
import com.davichmall.ifapi.sell.dto.OfflineBuyInfoReqDTO;
import com.davichmall.ifapi.sell.dto.OfflineBuyInfoResDTO;
import com.davichmall.ifapi.sell.dto.OfflineRecvCompReqDTO;
import com.davichmall.ifapi.sell.dto.OfflineRecvCompResDTO;
import com.davichmall.ifapi.sell.service.SellService;

/**
 * <pre>
 * - 프로젝트명    : davichmall_interface
 * - 패키지명      : com.davichmall.ifapi.sell.controller
 * - 파일명        : SellController.java
 * - 작성일        : 2018. 5. 16.
 * - 작성자        : CBK
 * - 설명          : [판매]분류의 인터페이스 처리를 위한 Controller
 * </pre>
 */
@Controller
public class SellController extends BaseController{
	
	@Resource(name="sellService")
	SellService sellService;

	/**
	 * <pre>
	 * 작성일 : 2018. 5. 16.
	 * 작성자 : CBK
	 * 설명   : 고객판매완료 (매장수령주문상품 수령완료)
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 5. 16. CBK - 최초생성
	 * </pre>
	 *
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/" + Constants.IFID.OFF_RECV_COMPLT)
	public @ResponseBody String completeOfflineRecv(OfflineRecvCompReqDTO param) throws Exception {
		
		String ifId = Constants.IFID.OFF_RECV_COMPLT;
		
		try {
			
			// 쇼핑몰 처리부분 
			
			// ResponseDTO 생성
			OfflineRecvCompResDTO resDto = new OfflineRecvCompResDTO();
			resDto.setResult(Constants.RESULT.SUCCESS);
			resDto.setMessage("");
			
			// 다비젼주문번호를 쇼핑몰 주문번호로 변경
			OrderMapDTO mapDto = mappingService.getMallOrderNo(param.getOrdDate(), param.getStrCode(), param.getOrdSlip());
			if(mapDto == null) {
				// 매핑되지 않은 주문번호입니다.
				throw new CustomException("ifapi.exception.order.orderno.notmapped");
			}
			String mallOrderNo = mapDto.getMallOrderNo().toString();
			param.setMallOrderNo(mallOrderNo);
			
			// 다비젼 주문상세번호를 쇼핑몰 주문상세번호로 변경
			List<String> mallOrdDtlSeqList = new ArrayList<>();
			for(String dtlSeq : param.getOrdSeq()) {
				OrderMapDTO mapDtlDto = mappingService.getMallOrderDtlNo(param.getOrdDate(), param.getStrCode(), param.getOrdSlip(), dtlSeq, "000");
				if(mapDtlDto == null) {
					// 매핑되지 않은 주문상세 번호 입니다.
					throw new CustomException("ifapi.exception.order.orderdtlseq.notmapped");
				}
				mallOrdDtlSeqList.add(mapDtlDto.getMallOrderDtlNo().toString());
			}
			param.setMallOrdDtlSeq(mallOrdDtlSeqList);
			
			sellService.completeOfflineRecv(param);
			
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
	 * 작성일 : 2018. 5. 16.
	 * 작성자 : CBK
	 * 설명   : 오프라인 구매 내역 조회
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 5. 16. CBK - 최초생성
	 * </pre>
	 *
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/" + Constants.IFID.OFF_SAL_SEARCH)
	public @ResponseBody String searchOfflineBuyList(OfflineBuyInfoReqDTO param) throws Exception {
		
		String ifId = Constants.IFID.OFF_SAL_SEARCH;
		
		try {
			// 쇼핑몰처리부분

			// 회원번호가 있으면 쇼핑몰 회원번호를 ERP회원번호로 변경
			if(param.getMemNo() != null && !"".equals(param.getMemNo())) {
				String erpMemNo = mappingService.getErpMemberNo(param.getMemNo());
				if(erpMemNo == null || "".equals(erpMemNo)) {
					// 통합회원이 아닙니다.
					throw new CustomException("ifapi.exception.member.notcombined");
				}
				param.setErpMemNo(erpMemNo);
			}
			
//			// ERP 쪽으로 데이터 전송
			String resParam = sendUtil.send(param, ifId);;
			
			// 처리로그 등록
			logService.writeInterfaceLog(ifId, param, resParam, OfflineBuyInfoResDTO.class);
			
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
