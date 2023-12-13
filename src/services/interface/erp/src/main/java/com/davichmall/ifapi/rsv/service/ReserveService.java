package com.davichmall.ifapi.rsv.service;

import java.util.List;

import com.davichmall.ifapi.rsv.dto.PreorderPromotionModReqDTO;
import com.davichmall.ifapi.rsv.dto.PreorderPromotionRegReqDTO;
import com.davichmall.ifapi.rsv.dto.PreorderRegReqDTO;
import com.davichmall.ifapi.rsv.dto.ReserveOrderSearchReqDTO;
import com.davichmall.ifapi.rsv.dto.ReserveOrderSearchResDTO.ReserveOrderDTO;
import com.davichmall.ifapi.rsv.dto.ReserveProductSearchReqDTO;
import com.davichmall.ifapi.rsv.dto.ReserveProductSearchResDTO.ReserveProductDTO;
import com.davichmall.ifapi.rsv.dto.StoreChaoticReqDTO;
import com.davichmall.ifapi.rsv.dto.StoreChaoticResDTO.StoreChaoticDTO;
import com.davichmall.ifapi.rsv.dto.StoreDtlInfoReqDTO;
import com.davichmall.ifapi.rsv.dto.StoreDtlInfoResDTO;
import com.davichmall.ifapi.rsv.dto.StoreHolidayReqDTO;
import com.davichmall.ifapi.rsv.dto.StoreSearchReqDTO;
import com.davichmall.ifapi.rsv.dto.StoreSearchResDTO.StoreInfoDTO;
import com.davichmall.ifapi.rsv.dto.StoreVisitReserveCancelReqDTO;
import com.davichmall.ifapi.rsv.dto.StoreVisitReserveMdfyReqDTO;
import com.davichmall.ifapi.rsv.dto.StoreVisitReserveRegReqDTO;

/**
 * <pre>
 * - 프로젝트명    : davichmall_interface
 * - 패키지명      : com.davichmall.ifapi.rsv.service
 * - 파일명        : ReserveService.java
 * - 작성일        : 2018. 6. 18.
 * - 작성자        : CBK
 * - 설명          : 예약 관련 인터페이스 처리를 위한 Controller
 * </pre>
 */
public interface ReserveService {

	/**
	 * <pre>
	 * 작성일 : 2018. 6. 22.
	 * 작성자 : CBK
	 * 설명   : 가맹점의 특정 요일 혼잡도 목록 조회
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
	List<StoreChaoticDTO> getStoreChaoticList(StoreChaoticReqDTO param) throws Exception;
	
	/**
	 * <pre>
	 * 작성일 : 2018. 6. 22.
	 * 작성자 : CBK
	 * 설명   : 다비젼에 매장 방문 예약 정보 등록
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 6. 22. CBK - 최초생성
	 * </pre>
	 *
	 * @param param
	 * @throws Exception
	 */
	void insertStoreVisitReserveInfo(StoreVisitReserveRegReqDTO param) throws Exception;
	
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
	 * @throws Exception
	 */
	void cancelErpStoreVisitReserveInfo(StoreVisitReserveCancelReqDTO param) throws Exception;
	
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
	 * @throws Exception
	 */
	void cancelMallStoreVisitReserveInfo(StoreVisitReserveCancelReqDTO param) throws Exception;
	
	/**
	 * <pre>
	 * 작성일 : 2018. 6. 26.
	 * 작성자 : CBK
	 * 설명   : 매장 방문 예약 정보 수정
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 6. 26. CBK - 최초생성
	 * </pre>
	 *
	 * @param param
	 * @return 변경된 방문예약번호
	 * @throws Exception
	 */
	String updateStoreVisitReserveInfo(StoreVisitReserveMdfyReqDTO param) throws Exception;
	
	/**
	 * <pre>
	 * 작성일 : 2018. 6. 18.
	 * 작성자 : CBK
	 * 설명   : 가맹점 목록 검색
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
	List<StoreInfoDTO> getStoreList(StoreSearchReqDTO param) throws Exception;
	
	/**
	 * <pre>
	 * 작성일 : 2019. 2. 19.
	 * 작성자 : hskim
	 * 설명   : 가맹점 코드 목록 검색
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2019. 2. 19. hskim - 최초생성
	 * </pre>
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */
	List<StoreInfoDTO> getStrCodeList(StoreSearchReqDTO param) throws Exception;
	
	/**
	 * <pre>
	 * 작성일 : 2018. 6. 18.
	 * 작성자 : CBK
	 * 설명   : 가맹점 목록 건수 조회
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
	int countStoreList(StoreSearchReqDTO param) throws Exception;
	
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
	StoreDtlInfoResDTO getStoreDtlInfo(StoreDtlInfoReqDTO param) throws Exception;
	
	/**
	 * <pre>
	 * 작성일 : 2018. 6. 29.
	 * 작성자 : CBK
	 * 설명   : 방문 예약 상품 목록 조회
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
	List<ReserveProductDTO> getReserveProductList(ReserveProductSearchReqDTO param) throws Exception;
	
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
	List<ReserveOrderDTO> getReserveOrderList(ReserveOrderSearchReqDTO param) throws Exception;

	/**
	 * <pre>
	 * 작성일 : 2018. 7. 2.
	 * 작성자 : CBK
	 * 설명   : 사전 예약 기획전 정보 등록 (공통코드 테이블에 등록)
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
	String insertPreorderCtrCode(PreorderPromotionRegReqDTO param) throws Exception;

	/**
	 * <pre>
	 * 작성일 : 2018. 7. 2.
	 * 작성자 : CBK
	 * 설명   : 사전 예약 주문 정보 등록
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 7. 2. CBK - 최초생성
	 * </pre>
	 *
	 * @param param
	 * @throws Exception
	 */
	void insertPreorderInfo(PreorderRegReqDTO param) throws Exception;
	
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
	 * @throws Exception
	 */
	void updatePreorderPromotion(PreorderPromotionModReqDTO param) throws Exception;
	
	/**
	 * <pre>
	 * 작성일 : 2018. 7. 27.
	 * 작성자 : CBK
	 * 설명   : 가맹점 휴일 목록 조회
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
	List<String> getStoreHolidayList(StoreHolidayReqDTO param) throws Exception;
	
	/**
	 * <pre>
	 * 작성일 : 2018. 9. 20.
	 * 작성자 : CBK
	 * 설명   : 쇼핑몰에서 방문예약 정보 수정 (ERP쪽 데이터 변경)
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 9. 20. CBK - 최초생성
	 * </pre>
	 *
	 * @param param
	 * @throws Exception
	 */
	void updateErpStoreVisitReserveInfo(StoreVisitReserveMdfyReqDTO param) throws Exception;
}
