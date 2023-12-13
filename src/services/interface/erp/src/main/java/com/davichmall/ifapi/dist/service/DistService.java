package com.davichmall.ifapi.dist.service;

import java.util.List;

import com.davichmall.ifapi.dist.dto.ErpReturnConfirmReqDTO;
import com.davichmall.ifapi.dist.dto.OrderCancelReqDTO;
import com.davichmall.ifapi.dist.dto.OrderRegReqDTO;
import com.davichmall.ifapi.dist.dto.OrderReleaseReqDTO;
import com.davichmall.ifapi.dist.dto.PurchaseConfirmReqDTO;
import com.davichmall.ifapi.dist.dto.RefundCmpltReqDTO;
import com.davichmall.ifapi.dist.dto.ReturnPopUrlReqDTO;
import com.davichmall.ifapi.dist.dto.MallReturnConfirmReqDTO;
import com.davichmall.ifapi.dist.dto.StoreDlvrCmpltReqDTO;
import com.davichmall.ifapi.dist.dto.OrderReleaseResDTO.ReleaseFailDTO;

/**
 * <pre>
 * - 프로젝트명    : davichmall_interface
 * - 패키지명      : com.davichmall.ifapi.dist.service
 * - 파일명        : DistService.java
 * - 작성일        : 2018. 5. 30.
 * - 작성자        : CBK
 * - 설명          : [발주] 분류의 인터페이스 처리를 위한 Service
 * </pre>
 */
public interface DistService {

	/**
	 * <pre>
	 * 작성일 : 2018. 5. 30.
	 * 작성자 : CBK
	 * 설명   : 발주 및 발주 상세 데이터 저장
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 5. 30. CBK - 최초생성
	 * </pre>
	 *
	 * @param param
	 * @throws Exception
	 */
	void insertOrderInfo(OrderRegReqDTO param) throws Exception;
	
	/**
	 * <pre>
	 * 작성일 : 2018. 6. 4.
	 * 작성자 : CBK
	 * 설명   : 발주 취소
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 6. 4. CBK - 최초생성
	 * </pre>
	 *
	 * @param param
	 * @throws Exception
	 */
	void cancelOrder(OrderCancelReqDTO param) throws Exception;
	
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
	List<ReleaseFailDTO> insertReleaseInfo(OrderReleaseReqDTO param) throws Exception;
	
	/**
	 * <pre>
	 * 작성일 : 2018. 6. 5.
	 * 작성자 : CBK
	 * 설명   : 매장 배송완료 처리
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 6. 5. CBK - 최초생성
	 * </pre>
	 *
	 * @param param
	 * @throws Exception
	 */
	void completeStoreDelivery(StoreDlvrCmpltReqDTO param) throws Exception;
	

	/**
	 * <pre>
	 * 작성일 : 2018. 6. 8.
	 * 작성자 : CBK
	 * 설명   : 반품신청등록(쇼핑몰)
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 6. 8. CBK - 최초생성
	 * </pre>
	 *
	 * @param param
	 * @param resDto
	 * @throws Exception
	 */
	void insertMallReturnReq(OrderRegReqDTO param) throws Exception;
	
	/**
	 * <pre>
	 * 작성일 : 2018. 6. 11.
	 * 작성자 : CBK
	 * 설명   : 반품확정(반품완료) 정보를 다비젼에 등록
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 6. 11. CBK - 최초생성
	 * </pre>
	 *
	 * @param param
	 * @throws Exception
	 */
	void updateErpReturnComfirm(MallReturnConfirmReqDTO param) throws Exception;
	
	/**
	 * <pre>
	 * 작성일 : 2018. 7. 13.
	 * 작성자 : CBK
	 * 설명   : 쇼핑몰 반품 확정 처리
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 7. 13. CBK - 최초생성
	 * </pre>
	 *
	 * @param param
	 * @throws Exception
	 */
	void updateMallReturnConfirm(ErpReturnConfirmReqDTO param) throws Exception;
	
	/**
	 * <pre>
	 * 작성일 : 2018. 7. 13.
	 * 작성자 : CBK
	 * 설명   : ERP 주문 상세에 구매확정 정보 갱신
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 7. 13. CBK - 최초생성
	 * </pre>
	 *
	 * @param param
	 * @throws Exception
	 */
	void updateErpPurchaseConfirm(PurchaseConfirmReqDTO param) throws Exception;
	
	/**
	 * <pre>
	 * 작성일 : 2018. 8. 13.
	 * 작성자 : CBK
	 * 설명   : 쇼핑몰 반품 추가 정보 팝업 URL
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
	String getMallReturnAddInfoPopUrl(ReturnPopUrlReqDTO param) throws Exception;
	
	/**
	 * <pre>
	 * 작성일 : 2018. 8. 13.
	 * 작성자 : CBK
	 * 설명   : 환불 완료 데이터 저장
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 8. 13. CBK - 최초생성
	 * </pre>
	 *
	 * @param param
	 * @throws Exception
	 */
	void completeRefund(RefundCmpltReqDTO param) throws Exception;
	
	/**
	 * <pre>
	 * 작성일 : 2018. 8. 20.
	 * 작성자 : CBK
	 * 설명   : 교환완료 - 재주문
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 8. 20. CBK - 최초생성
	 * </pre>
	 *
	 * @param param
	 * @throws Exception
	 */
	void completeChange(OrderRegReqDTO param) throws Exception;

	/**
	 * <pre>
	 * 작성일 : 2018. 9. 6.
	 * 작성자 : CBK
	 * 설명   : 반품신청 사유 팝업 URL 조회
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 9. 6. CBK - 최초생성
	 * </pre>
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */
	String getMallReturnReasonPopUrl(ReturnPopUrlReqDTO param) throws Exception;
}
