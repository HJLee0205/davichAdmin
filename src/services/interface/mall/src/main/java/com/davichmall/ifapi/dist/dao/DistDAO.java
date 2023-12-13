package com.davichmall.ifapi.dist.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import com.davichmall.ifapi.cmmn.base.BaseDAO;
import com.davichmall.ifapi.dist.dto.ErpReturnConfirmReqDTO;
import com.davichmall.ifapi.dist.dto.OrderCancelReqDTO;
import com.davichmall.ifapi.dist.dto.OrderPayInfoDTO;
import com.davichmall.ifapi.dist.dto.OrderRegReqDTO;
import com.davichmall.ifapi.dist.dto.PurchaseConfirmReqDTO;
import com.davichmall.ifapi.dist.dto.ReturnInfoDTO;
import com.davichmall.ifapi.dist.dto.MallReturnConfirmReqDTO.ClaimInfoDTO;
import com.davichmall.ifapi.dist.dto.OrderRegReqDTO.OrderDetailDTO;

/**
 * <pre>
 * - 프로젝트명    : davichmall_interface
 * - 패키지명      : com.davichmall.ifapi.dist.dao
 * - 파일명        : DistDAO.java
 * - 작성일        : 2018. 5. 30.
 * - 작성자        : CBK
 * - 설명          : [발주] 분류의 인터페이스 처리를 위한 DAO
 * </pre>
 */
@Repository("distDao")
public class DistDAO extends BaseDAO {

	/**
	 * <pre>
	 * 작성일 : 2018. 7. 5.
	 * 작성자 : CBK
	 * 설명   : 매장 배송 주문 출고 마감 시간 조회
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 7. 5. CBK - 최초생성
	 * </pre>
	 *
	 * @return
	 * @throws Exception
	 */
	public String getClosingTimeForStoreDlvr() throws Exception {
		return sqlSession2.selectOne("dist.selectClosingTimeForStoreDlvr");
	}
	
	/**
	 * <pre>
	 * 작성일 : 2018. 7. 5.
	 * 작성자 : CBK
	 * 설명   : 자택 배송 주문 출고 마감 시간 조회
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 7. 5. CBK - 최초생성
	 * </pre>
	 *
	 * @return
	 * @throws Exception
	 */
	public String getClosingTimeForHomeDlvr() throws Exception {
		return sqlSession2.selectOne("dist.selectClosingTimeForHomeDlvr");
	}
	
	/**
	 * <pre>
	 * 작성일 : 2018. 5. 30.
	 * 작성자 : CBK
	 * 설명   : 다음 전표번호 조회(신규 데이터 저장시)
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 5. 30. CBK - 최초생성
	 * </pre>
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public String getNextOrdSlip(OrderRegReqDTO param) throws Exception {
		return sqlSession2.selectOne("dist.getNextOrdSlip", param);
	}
	
	/**
	 * <pre>
	 * 작성일 : 2018. 5. 30.
	 * 작성자 : CBK
	 * 설명   : 발주(주문)데이터 저장
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 5. 30. CBK - 최초생성
	 * </pre>
	 *
	 * @param param
	 * @throws Exception
	 */
	public void insertOrderInfo(OrderRegReqDTO param) throws Exception {
		sqlSession2.insert("dist.insertOrderInfo", param);
	}
	
	/**
	 * <pre>
	 * 작성일 : 2018. 5. 30.
	 * 작성자 : CBK
	 * 설명   : 발주(주문)상세 데이터 저장
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 5. 30. CBK - 최초생성
	 * </pre>
	 *
	 * @param param
	 * @throws Exception
	 */
	public void insertOrderDetailInfo(OrderDetailDTO param) throws Exception {
		sqlSession2.insert("dist.insertOrderDetailInfo", param);
	}

	/**
	 * <pre>
	 * 작성일 : 2018. 6. 5.
	 * 작성자 : CBK
	 * 설명   : 결제 정보 등록
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 6. 5. CBK - 최초생성
	 * </pre>
	 *
	 * @param param
	 * @throws Exception
	 */
	public void insertOrderPaymentInfo(OrderPayInfoDTO param) throws Exception {
		sqlSession2.insert("dist.insertOrderPaymentInfo", param);
	}
	
	/**
	 * <pre>
	 * 작성일 : 2018. 6. 5.
	 * 작성자 : CBK
	 * 설명   : 발주(주문) 취소
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 6. 5. CBK - 최초생성
	 * </pre>
	 *
	 * @param param
	 * @throws Exception
	 */
	public void cancelOrder(OrderCancelReqDTO param) throws Exception {
		sqlSession2.update("dist.cancelOrder", param);
	}
	
	/**
	 * <pre>
	 * 작성일 : 2018. 6. 8.
	 * 작성자 : CBK
	 * 설명   : 매장 배송완료 처리
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 6. 8. CBK - 최초생성
	 * </pre>
	 *
	 * @param mallOrderNo
	 * @param mallOrderDtlSeq
	 * @return
	 * @throws Exception
	 */
	public Map<String, Object> getMallDlvrInfo(String mallOrderNo, String mallOrderDtlSeq) throws Exception {
		Map<String, Object> param = new HashMap<>();
		param.put("mallOrderNo", mallOrderNo);
		param.put("mallOrderDtlSeq", mallOrderDtlSeq);
		
		return sqlSession1.selectOne("dist.selectMallOrderDlvrInfo", param);
	}
	
	/**
	 * <pre>
	 * 작성일 : 2018. 6. 8.
	 * 작성자 : CBK
	 * 설명   : 주문상세에 따른 결제 내역 목록 조회
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 6. 8. CBK - 최초생성
	 * </pre>
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public List<OrderPayInfoDTO> getOrderDtlPaymentInfoList(OrderPayInfoDTO param) throws Exception {
		return sqlSession2.selectList("dist.selectOrderDtlPaymentInfoList", param);
	}
	
	/**
	 * <pre>
	 * 작성일 : 2018. 6. 8.
	 * 작성자 : CBK
	 * 설명   : 원주문상세 주문수량 조회
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 6. 8. CBK - 최초생성
	 * </pre>
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public int getOrgOrderDtlQty(OrderDetailDTO param) throws Exception {
		return sqlSession2.selectOne("dist.selectOrgOrderDtlQty", param);
	}
	
	/**
	 * <pre>
	 * 작성일 : 2018. 8. 10.
	 * 작성자 : CBK
	 * 설명   : 쇼핑몰 주문 상세 상태 갱신
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 8. 10. CBK - 최초생성
	 * </pre>
	 *
	 * @param param
	 * @throws Exception
	 */
	public void updateErpOrderDtlStatus(ClaimInfoDTO param) throws Exception {
		sqlSession2.update("dist.updateErpOrderDtlStatus", param);
	}
	
	/**
	 * <pre>
	 * 작성일 : 2018. 8. 10.
	 * 작성자 : CBK
	 * 설명   : 상태가 다른 주문상세 데이터 개수 조회
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 8. 10. CBK - 최초생성
	 * </pre>
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public int countErpOrderDtlOtherStatus(ClaimInfoDTO param) throws Exception {
		return sqlSession2.selectOne("dist.countErpOrderDtlOtherStatus", param);
	}
	
	/**
	 * <pre>
	 * 작성일 : 2018. 6. 11.
	 * 작성자 : CBK
	 * 설명   : ERP 반품주문상태 수정
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 6. 11. CBK - 최초생성
	 * </pre>
	 *
	 * @param param
	 * @throws Exception
	 */
	public void updateErpOrderStatus(ClaimInfoDTO param) throws Exception {
		sqlSession2.update("dist.updateErpOrderStatus", param);
	}
	
	/**
	 * <pre>
	 * 작성일 : 2018. 7. 13.
	 * 작성자 : CBK
	 * 설명   : 쇼핑몰 주문 상세 반품상태 코드 변경
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
	public int updateMallReturnStatus(ErpReturnConfirmReqDTO param) throws Exception {
		return sqlSession1.update("dist.updateMallReturnStatus", param);
	}
	
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
	 * @return
	 * @throws Exception
	 */
	public int updateErpPurchaseConfirm(PurchaseConfirmReqDTO param) throws Exception {
		return sqlSession2.update("dist.updateErpPurchaseConfirm", param);
	}
	
	/**
	 * <pre>
	 * 작성일 : 2018. 8. 17.
	 * 작성자 : CBK
	 * 설명   : 원 발주에서 교환반품/교환재발주를 적용한 결제정보
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 8. 17. CBK - 최초생성
	 * </pre>
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, String>> getOrgPaymentInfoList(Map<String, String> param) throws Exception {
		return sqlSession2.selectList("dist.selectOrgPaymentInfoList", param);
	}
	
	/**
	 * <pre>
	 * 작성일 : 2018. 8. 17.
	 * 작성자 : CBK
	 * 설명   : 주문 정보의 정산포함 여부 플래그를 Y로 변경
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 8. 17. CBK - 최초생성
	 * </pre>
	 *
	 * @param param
	 * @throws Exception
	 */
	public void setOrderChargeYnToY(String ordDate, String strCode, String ordSlip) throws Exception {
		Map<String, String> param = new HashMap<>();
		param.put("ordDate", ordDate);
		param.put("strCode", strCode);
		param.put("ordSlip", ordSlip);
		sqlSession2.update("dist.updateOrderChargeYnToY", param);
	}

	/**
	 * <pre>
	 * 작성일 : 2018. 9. 11.
	 * 작성자 : CBK
	 * 설명   : 반품 상세 정보 조회
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
	public ReturnInfoDTO getReturnOrderDtlInfo(Map<String, String> param) throws Exception {
		return sqlSession2.selectOne("dist.selectReturnOrderDtlInfo", param);
	}

	/**
	 * <pre>
	 * 작성일 : 2018. 9. 11.
	 * 작성자 : CBK
	 * 설명   : 반품 상세 원발주 수량 조회 (원발주수량 - 환불완료 수량)
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
	public int getOrgOrderQtyExceptRefund(ReturnInfoDTO param) throws Exception {
		return sqlSession2.selectOne("dist.selectOrgOrderQtyExceptRefund", param);
	}

	/**
	 * <pre>
	 * 작성일 : 2018. 9. 11.
	 * 작성자 : CBK
	 * 설명   : 반품상세 원발주 결제내역 조회(원발주결제 - 환불완료결제)
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
	public List<OrderPayInfoDTO> getOrgPaymentInfoListExceptRefund(ReturnInfoDTO param) throws Exception {
		return sqlSession2.selectList("dist.selectOrgPaymentInfoListExceptRefund", param);
	}
	
	/**
	 * <pre>
	 * 작성일 : 2018. 9. 12.
	 * 작성자 : CBK
	 * 설명   : 주문 상세의 현재 상태 값 조회
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 9. 12. CBK - 최초생성
	 * </pre>
	 *
	 * @param ordNo
	 * @param ordDtlSeq
	 * @return
	 * @throws Exception
	 */
	public String getOrderDtlCurrentStatus(String ordNo, String ordDtlSeq) throws Exception {
		Map<String, String> param = new HashMap<>();
		param.put("ordNo", ordNo);
		param.put("ordDtlSeq", ordDtlSeq);
		
		return sqlSession1.selectOne("dist.selectOrderDtlCurrentStatus", param);
	}
}
