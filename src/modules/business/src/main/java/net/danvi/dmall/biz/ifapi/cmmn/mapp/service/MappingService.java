package net.danvi.dmall.biz.ifapi.cmmn.mapp.service;

import net.danvi.dmall.biz.ifapi.cmmn.mapp.dto.*;
import net.danvi.dmall.biz.ifapi.dist.dto.OrderRegReqDTO;

/**
 * <pre>
 * - 프로젝트명    : davichmall_interface
 * - 패키지명      : net.danvi.dmall.admin.ifapi.cmmn.mapp.service
 * - 파일명        : MappingService.java
 * - 작성일        : 2018. 5. 18.
 * - 작성자        : CBK
 * - 설명          : 쇼핑몰 - ERP 데이터 매핑 정보 처리 Service
 * </pre>
 */
public interface MappingService {

	/**
	 * <pre>
	 * 작성일 : 2018. 5. 18.
	 * 작성자 : CBK
	 * 설명   : ERP 상품코드로 쇼핑몰 상품 코드(옵션코드) 조회
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 5. 18. CBK - 최초생성
	 * </pre>
	 *
	 * @return
	 * @throws Exception
	 */
	String getMallItemCode(String erpItmCode) throws Exception;
	
	/**
	 * <pre>
	 * 작성일 : 2018. 5. 18.
	 * 작성자 : CBK
	 * 설명   : 쇼핑몰 상품코드(옵션코드)로 ERP상품코드 조회
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 5. 18. CBK - 최초생성
	 * </pre>
	 *
	 * @return
	 * @throws Exception
	 */
	String getErpItemCode(String mallItmCode) throws Exception;
	
	/**
	 * <pre>
	 * 작성일 : 2018. 5. 18.
	 * 작성자 : CBK
	 * 설명   : 쇼핑몰-ERP 상품코드 매핑 정보 등록
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 5. 18. CBK - 최초생성
	 * </pre>
	 *
	 * @return
	 * @throws Exception
	 */
	void insertItemCodeMap(String mallGoodsNo, String mallItmCode, String erpItmCode) throws Exception;

	/**
	 * <pre>
	 * 작성일 : 2018. 5. 18.
	 * 작성자 : CBK
	 * 설명   : 쇼핑몰-ERP 상품코드 매핑 정보 삭제
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 5. 18. CBK - 최초생성
	 * </pre>
	 *
	 * @return
	 * @throws Exception
	 */
	void deleteItemCodeMap(String mallGoodsNo, String mallItmCode) throws Exception;
	
	/**
	 * <pre>
	 * 작성일 : 2018. 5. 18.
	 * 작성자 : CBK
	 * 설명   : ERP 주문번호로 쇼핑몰 주문번호 조회
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 5. 18. CBK - 최초생성
	 * </pre>
	 *
	 * @return
	 * @throws Exception
	 */
	OrderMapDTO getMallOrderNo(String erpOrdDate, String erpStrCode, String erpOrdSlip) throws Exception;

	/**
	 * <pre>
	 * 작성일 : 2018. 5. 18.
	 * 작성자 : CBK
	 * 설명   : ERP 주문번호 조회
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 5. 18. CBK - 최초생성
	 * </pre>
	 *
	 * @return
	 * @throws Exception
	 */
	OrderMapDTO getErpOrderNo(OrderRegReqDTO param) throws Exception;

	/**
	 * <pre>
	 * 작성일 : 2018. 5. 18.
	 * 작성자 : CBK
	 * 설명   : 쇼핑몰 주문번호로 ERP 주문번호 조회
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 5. 18. CBK - 최초생성
	 * </pre>
	 *
	 * @return
	 * @throws Exception
	 */
	OrderMapDTO getErpOrderNo(String mallOrderNo) throws Exception;
	
	/**
	 * <pre>
	 * 작성일 : 2018. 8. 17.
	 * 작성자 : CBK
	 * 설명   : 쇼핑몰 주문번호로 ERP주문번호 조회
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 8. 17. CBK - 최초생성
	 * </pre>
	 *
	 * @param mallOrderNo
	 * @param mallClaimNo
	 * @return
	 * @throws Exception
	 */
	OrderMapDTO getErpOrderNo(String mallOrderNo, String mallClaimNo) throws Exception;

	
	/**
	 * <pre>
	 * 작성일 : 2018. 8. 17.
	 * 작성자 : CBK
	 * 설명   : 쇼핑몰 주문번호로 반품재발주 포함 마지막 주문번호 매핑 조회(교환 재발주는 제회)
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 8. 17. CBK - 최초생성
	 * </pre>
	 *
	 * @param mallOrderNo
	 * @return
	 * @throws Exception
	 */
	OrderMapDTO getLatestOrderMapWithoutChangeReorder(String mallOrderNo) throws Exception;
	
	/**
	 * <pre>
	 * 작성일 : 2018. 5. 18.
	 * 작성자 : CBK
	 * 설명   : 쇼핑몰-ERP 주문번호 매핑 정보 등록
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 5. 18. CBK - 최초생성
	 * </pre>
	 *
	 * @return
	 * @throws Exception
	 */
	void insertOrderNoMap(String mallOrderNo, String erpOrdDate, String erpStrCode, String erpOrdSlip, String ordRute) throws Exception;
	
	/**
	 * <pre>
	 * 작성일 : 2018. 5. 18.
	 * 작성자 : CBK
	 * 설명   : ERP 주문상세번호로 쇼핑몰 주문상세번호 조회
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 5. 18. CBK - 최초생성
	 * </pre>
	 *
	 * @return
	 * @throws Exception
	 */
	OrderMapDTO getMallOrderDtlNo(String erpOrdDate, String erpStrCode, String erpOrdSlip, String erpOrderDtlNo, String erpOrderAddNo) throws Exception;

	/**
	 * <pre>
	 * 작성일 : 2018. 5. 18.
	 * 작성자 : CBK
	 * 설명   : 쇼핑몰 주문상세번호로 ERP 주문상세번호 조회
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 5. 18. CBK - 최초생성
	 * </pre>
	 *
	 * @return
	 * @throws Exception
	 */
	OrderMapDTO getErpOrderDtlNo(String mallOrderNo, String mallOrderDtlNo) throws Exception;
	
	/**
	 * <pre>
	 * 작성일 : 2018. 8. 17.
	 * 작성자 : CBK
	 * 설명   : 쇼핑몰 주문상세번호로 ERP 주문상세번호 조회
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 8. 17. CBK - 최초생성
	 * </pre>
	 *
	 * @param mallOrderNo
	 * @param mallClaimNo
	 * @param mallOrderDtlNo
	 * @return
	 * @throws Exception
	 */
	OrderMapDTO getErpOrderDtlNo(String mallOrderNo, String mallClaimNo, String mallOrderDtlNo) throws Exception;
	
	/**
	 * <pre>
	 * 작성일 : 2018. 5. 18.
	 * 작성자 : CBK
	 * 설명   : 쇼핑몰-ERP 주문상세번호 매핑 정보 등록
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 5. 18. CBK - 최초생성
	 * </pre>
	 *
	 * @return
	 * @throws Exception
	 */
	void insertOrderDtlNoMap(String mallOrderNo, String mallOrderDtlNo, String erpOrdDate, String erpStrCode, String erpOrdSlip, String erpOrderDtlNo, String erpOrderAddNo) throws Exception;
	
	/**
	 * <pre>
	 * 작성일 : 2018. 8. 9.
	 * 작성자 : CBK
	 * 설명   : 쇼핑몰 - ERP 반품 번호 매핑 정보 등록
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 8. 9. CBK - 최초생성
	 * </pre>
	 *
	 * @param mallClaimNo
	 * @param mallOrderNo
	 * @param mallOrderDtlNo
	 * @param erpOrdDate
	 * @param erpStrCode
	 * @param erpOrdSlip
	 * @param erpOrderDtlNo
	 * @param erpOrderAddNo
	 * @throws Exception
	 */
	void insertClaimNoMap(String mallClaimNo, String mallOrderNo, String mallOrderDtlNo, String erpOrdDate, String erpStrCode, String erpOrdSlip, String erpOrderDtlNo, String erpOrderAddNo) throws Exception;
	
	/**
	 * <pre>
	 * 작성일 : 2018. 8. 9.
	 * 작성자 : CBK
	 * 설명   : 쇼핑몰 반품 번호로 ERP 반품주문 번호 조회
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 8. 9. CBK - 최초생성
	 * </pre>
	 *
	 * @param mallClaimNo
	 * @param mallOrderNo
	 * @param mallOrderDtlNo
	 * @return
	 * @throws Exception
	 */
	OrderMapDTO getErpClaimNo(String mallClaimNo, String mallOrderNo, String mallOrderDtlNo) throws Exception;
	
	/**
	 * <pre>
	 * 작성일 : 2018. 8. 9.
	 * 작성자 : CBK
	 * 설명   : ERP 반품주문 번호로 쇼핑몰 반품번호 조회
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 8. 9. CBK - 최초생성
	 * </pre>
	 *
	 * @param erpOrdDate
	 * @param erpStrCode
	 * @param erpOrdSlip
	 * @param erpOrderDtlNo
	 * @param erpOrderAddNo
	 * @return
	 * @throws Exception
	 */
	OrderMapDTO getMallClaimNo(String erpOrdDate, String erpStrCode, String erpOrdSlip, String erpOrderDtlNo, String erpOrderAddNo) throws Exception;
	
	/**
	 * <pre>
	 * 작성일 : 2018. 5. 18.
	 * 작성자 : CBK
	 * 설명   : 쇼핑몰 회원번호로 ERP 회원번호 조회
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 5. 18. CBK - 최초생성
	 * </pre>
	 *
	 * @return
	 * @throws Exception
	 */
	String getErpMemberNo(String mallMemberNo) throws Exception;
	
	/**
	 * <pre>
	 * 작성일 : 2018. 5. 18.
	 * 작성자 : CBK
	 * 설명   : ERP 회원번호로 쇼핑몰 회원번호 조회
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 5. 18. CBK - 최초생성
	 * </pre>
	 *
	 * @return
	 * @throws Exception
	 */
	String getMallMemberNo(String erpMemberNo) throws Exception;

	/**
	 * <pre>
	 * 작성일 : 2018. 5. 18.
	 * 작성자 : CBK
	 * 설명   : ERP 회원번호로 쇼핑몰 회원ID 조회
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 5. 18. CBK - 최초생성
	 * </pre>
	 *
	 * @return
	 * @throws Exception
	 */
	String getMallMemberLoginId(String erpMemberNo) throws Exception;
	
	/**
	 * <pre>
	 * 작성일 : 2018. 5. 18.
	 * 작성자 : CBK
	 * 설명   : 쇼핑몰-ERP 회원번호 매핑 정보 등록
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 5. 18. CBK - 최초생성
	 * </pre>
	 *
	 * @return
	 * @throws Exception
	 */
	void insertMemberMap(String mallMemberNo, String erpMemberNo, String erpMemberLvl) throws Exception;
	
	/**
	 * <pre>
	 * 작성일 : 2018. 5. 28.
	 * 작성자 : CBK
	 * 설명   : 쇼핑몰 -ERP 회원번호 매핑 정보 삭제
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 5. 28. CBK - 최초생성
	 * </pre>
	 *
	 * @param mallMemberNo
	 * @param erpMemberNo
	 * @throws Exception
	 */
	void deleteMemberMap(String mallMemberNo, String erpMemberNo) throws Exception;
	
	/**
	 * <pre>
	 * 작성일 : 2018. 5. 18.
	 * 작성자 : CBK
	 * 설명   : 쇼핑몰-ERP 회원번호 매핑 정보 삭제 (쇼핑몰 회원번호 기준)
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 5. 18. CBK - 최초생성
	 * </pre>
	 *
	 * @return
	 * @throws Exception
	 */
	void deleteMemberMapByMall(String mallMemberNo) throws Exception;
	
	/**
	 * <pre>
	 * 작성일 : 2018. 5. 18.
	 * 작성자 : CBK
	 * 설명   : 쇼핑몰-ERP 회원번호 매핑 정보 삭제 (ERP 회원번호 기준)
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 5. 18. CBK - 최초생성
	 * </pre>
	 *
	 * @return
	 * @throws Exception
	 */
	void deleteMemberMapByErp(String erpMemberNo) throws Exception;
	
	/**
	 * <pre>
	 * 작성일 : 2018. 6. 29.
	 * 작성자 : CBK
	 * 설명   : 쇼핑몰-ERP 사전예약 기획전 매핑 정보 등록
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 6. 29. CBK - 최초생성
	 * </pre>
	 *
	 * @param mallPrmtNo
	 * @param erpPrmtNo
	 * @throws Exception
	 */
	void insertPOMap(String mallPrmtNo, String erpPrmtNo) throws Exception;
	
	/**
	 * <pre>
	 * 작성일 : 2018. 6. 29.
	 * 작성자 : CBK
	 * 설명   : 쇼핑몰 기획전 번호로 ERP 사전예약 번호 조회
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 6. 29. CBK - 최초생성
	 * </pre>
	 *
	 * @param mallPrmtNo
	 * @return
	 * @throws Exception
	 */
	String getErpPrmtNo(String mallPrmtNo) throws Exception;
	
	/**
	 * <pre>
	 * 작성일 : 2018. 6. 29.
	 * 작성자 : CBK
	 * 설명   : ERP 사전예약 번호로 쇼핑몰 기획전 번호 조회
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 6. 29. CBK - 최초생성
	 * </pre>
	 *
	 * @param erpPrmtNO
	 * @return
	 * @throws Exception
	 */
	String getMallPrmtNo(String erpPrmtNO) throws Exception;

	/**
	 * <pre>
	 * 작성일 : 2018. 7. 17.
	 * 작성자 : CBK
	 * 설명   : 쇼핑몰-ERP 오프라인포인트 매핑 정보 등록
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 7. 17. CBK - 최초생성
	 * </pre>
	 *
	 * @param param
	 * @throws Exception
	 */
	void insertOfflinePointMap(OffPointMapDTO param) throws Exception;
	
	/**
	 * <pre>
	 * 작성일 : 2018. 7. 17.
	 * 작성자 : CBK
	 * 설명   : 쇼핑몰 주문번호로 ERP 포인트 로그번호 조회
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
	OffPointMapDTO getOfflinePointMapByMall(OffPointMapDTO param) throws Exception;

	
	/**
	 * <pre>
	 * 작성일 : 2018. 7. 17.
	 * 작성자 : CBK
	 * 설명   : 쇼핑몰 주문번호로 ERP 포인트 로그 매핑 삭제
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 7. 17. CBK - 최초생성
	 * </pre>
	 *
	 * @param param
	 * @throws Exception
	 */
	void deleteOfflinePointMapByMall(OffPointMapDTO param) throws Exception;
	
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
	 * @throws Exception
	 */
	void insertOrderAndDtlMap(OrderMapRegReqDTO param) throws Exception;
	
	/**
	 * <pre>
	 * 작성일 : 2018. 9. 17.
	 * 작성자 : CBK
	 * 설명   : 주문 및 주문상세 매핑 제거
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 9. 17. CBK - 최초생성
	 * </pre>
	 *
	 * @param mallOrderNo
	 * @throws Exception
	 */
	void deleteOrderAndDtlMap(OrderMapRegReqDTO param) throws Exception;
	
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
	 * @throws Exception
	 */
	void insertReturnMap(ReturnMapRegReqDTO param) throws Exception;
	
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
	 * @throws Exception
	 */
	void insertOfflinePointMap(OffPointMapRegReqDTO param) throws Exception;
}
