package com.davichmall.ifapi.sell.controller;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.davichmall.ifapi.cmmn.CustomException;
import com.davichmall.ifapi.cmmn.base.BaseController;
import com.davichmall.ifapi.cmmn.constant.Constants;
import com.davichmall.ifapi.sell.dto.OfflineBuyInfoReqDTO;
import com.davichmall.ifapi.sell.dto.OfflineBuyInfoResDTO;
import com.davichmall.ifapi.sell.dto.OfflineBuyInfoResDTO.OfflineBuyInfoDTO;
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
			
			// ERP 처리부분
			
			String resParam = sendUtil.send(param, ifId);

			// 처리로그 등록
			logService.writeInterfaceLog(ifId, param, resParam, OfflineRecvCompResDTO.class);
			
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
			// ERP처리부분
			
			// ResponseDTO 생성
			OfflineBuyInfoResDTO resDto = new OfflineBuyInfoResDTO();
			resDto.setResult(Constants.RESULT.SUCCESS);
			resDto.setMessage("");
			
			// 오프라인 구매내역 조회
			List<OfflineBuyInfoDTO> salList = sellService.selectOfflineBuyInfoList(param);
			resDto.setSalList(salList);
			
			// 오프라인 구매내역 개수 조회
			int totalCnt = sellService.countOfflineBuyInfoList(param);
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
}
