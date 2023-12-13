package com.davichmall.ifapi.rsv.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import com.davichmall.ifapi.cmmn.base.BaseDAO;
import com.davichmall.ifapi.rsv.dto.PreorderPromotionModReqDTO;
import com.davichmall.ifapi.rsv.dto.PreorderPromotionRegReqDTO;
import com.davichmall.ifapi.rsv.dto.PreorderRegDTO;
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
import com.davichmall.ifapi.rsv.dto.StoreVisitReserveRegReqDTO.ReservePrdDTO;

@Repository("reserveDao")
public class ReserveDAO extends BaseDAO {

	
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
	public List<StoreChaoticDTO> getStoreChaoticList(StoreChaoticReqDTO param) throws Exception {
		return sqlSession2.selectList("rsv.selectChaoticList", param);
	}
	
	/**
	 * <pre>
	 * 작성일 : 2018. 6. 22.
	 * 작성자 : CBK
	 * 설명   : 다비젼 방문예약 데이터 등록시 이미 등록된 데이터 인지 확인
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
	public int countStoreVisitReserveInfo(StoreVisitReserveRegReqDTO param) throws Exception {
		return sqlSession2.selectOne("rsv.countStoreVisitReserveInfo", param);
	}
	
	/**
	 * <pre>
	 * 작성일 : 2018. 6. 22.
	 * 작성자 : CBK
	 * 설명   : 매장 방문 예약 테이블 등록을 위한 seq_no 조회
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
	public int getStoreVisitReserveMaxSeq(StoreVisitReserveRegReqDTO param) throws Exception {
		return sqlSession2.selectOne("rsv.getStoreVisitReserveMaxSeq", param);
	}
	
	/**
	 * <pre>
	 * 작성일 : 2018. 6. 22.
	 * 작성자 : CBK
	 * 설명   : 다비젼 매장 방문 예약 정보 등록
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 6. 22. CBK - 최초생성
	 * </pre>
	 *
	 * @param param
	 * @throws Exception
	 */
	public void insertStoreVisitReserveInfo(StoreVisitReserveRegReqDTO param) throws Exception {
		sqlSession2.insert("rsv.insertStoreVisitReserveInfo", param);
	}
	
	/**
	 * <pre>
	 * 작성일 : 2018. 8. 3.
	 * 작성자 : CBK
	 * 설명   : 다비젼 방문 예약 상세 정보(예약상품) 등록
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 8. 3. CBK - 최초생성
	 * </pre>
	 *
	 * @param param
	 * @throws Exception
	 */
	public void insertStoreVisitReserveDtlInfo(ReservePrdDTO param) throws Exception {
		sqlSession2.insert("rsv.insertStoreVisitReserveDtlInfo", param);
	}
	
	/**
	 * <pre>
	 * 작성일 : 2018. 6. 25.
	 * 작성자 : CBK
	 * 설명   : 다비젼 매장 방문 예약 취소
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 6. 25. CBK - 최초생성
	 * </pre>
	 *
	 * @param param
	 * @throws Exception
	 */
	public void cancelErpStoreVisitReserveInfo(StoreVisitReserveCancelReqDTO param) throws Exception {
		sqlSession2.update("rsv.cancelErpStoreVisitReserveInfo", param);
	}
	
	/**
	 * <pre>
	 * 작성일 : 2018. 6. 25.
	 * 작성자 : CBK
	 * 설명   : 쇼핑몰 매장 방문 예약 취소
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 6. 25. CBK - 최초생성
	 * </pre>
	 *
	 * @param param
	 * @throws Exception
	 */
	public void cancelMallStoreVisitReserveInfo(StoreVisitReserveCancelReqDTO param) throws Exception {
		sqlSession1.update("rsv.cancelMallStoreVisitReserveInfo", param);
	}
	
	/**
	 * <pre>
	 * 작성일 : 2018. 6. 26.
	 * 작성자 : CBK
	 * 설명   : 쇼핑몰 방문예약 테이블에서 예약번호의 max+1을 조회
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 6. 26. CBK - 최초생성
	 * </pre>
	 *
	 * @return
	 * @throws Exception
	 */
	public String getMaxRsvNo() throws Exception {
		return sqlSession1.selectOne("rsv.getMaxRsvNo");
	}
	
	/**
	 * <pre>
	 * 작성일 : 2018. 6. 26.
	 * 작성자 : CBK
	 * 설명   : 쇼핑몰 방문예약 데이터 변경 등록(기존 데이터에서 날짜/시간 변경해서 insert)
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 6. 26. CBK - 최초생성
	 * </pre>
	 *
	 * @param param
	 * @throws Exception
	 */
	public void insertModifiedStoreVisitReserveInfo(StoreVisitReserveMdfyReqDTO param) throws Exception {
		sqlSession1.insert("rsv.insertModifiedStoreVisitReserveInfo", param);
	}
	
	/**
	 * <pre>
	 * 작성일 : 2018. 6. 26.
	 * 작성자 : CBK
	 * 설명   : 쇼핑몰 방문예약 상세 데이터 변경 등록(기존 데이터에서 날짜/시간 변경해서 insert)
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 6. 26. CBK - 최초생성
	 * </pre>
	 *
	 * @param param
	 * @throws Exception
	 */
	public void insertModifiedStoreVisitReserveDtl(StoreVisitReserveMdfyReqDTO param) throws Exception {
		sqlSession1.insert("rsv.insertModifiedStoreVisitReserveDtl", param);
	}
	
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
	public List<StoreInfoDTO> getStoreList(StoreSearchReqDTO param) throws Exception {
		return sqlSession2.selectList("rsv.selectStoreList", param);
	}
	
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
	public int countStoreList(StoreSearchReqDTO param) throws Exception {
		return sqlSession2.selectOne("rsv.countStoreList", param);
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
	public StoreDtlInfoResDTO getStoreDtlInfo(StoreDtlInfoReqDTO param) throws Exception {
		return sqlSession2.selectOne("rsv.selectStoreDtlInfo", param);
	}
	
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
	public List<ReserveProductDTO> selectReserveProductList(ReserveProductSearchReqDTO param) throws Exception {
		return sqlSession1.selectList("rsv.selectReserveProductList", param);
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
	public List<ReserveOrderDTO> selectReserveOrderList(ReserveOrderSearchReqDTO param) throws Exception {
		return sqlSession1.selectList("rsv.selectOrderList", param);
	}
	
	/**
	 * <pre>
	 * 작성일 : 2018. 7. 2.
	 * 작성자 : CBK
	 * 설명   : 사전 예약 기획전 등록을 위한 max ctr_code 조회
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 7. 2. CBK - 최초생성
	 * </pre>
	 *
	 * @return
	 * @throws Exception
	 */
	public String getMaxPreorderCtrCode() throws Exception {
		return sqlSession2.selectOne("rsv.getMaxPreorderCtrCode");
	}

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
	 * @throws Exception
	 */
	public void insertPreorderCtrCode(PreorderPromotionRegReqDTO param) throws Exception {
		sqlSession2.insert("rsv.insertPreorderCtrCode", param);
	}

	/**
	 * <pre>
	 * 작성일 : 2018. 7. 2.
	 * 작성자 : CBK
	 * 설명   : 사전 예약 주문 등록을 위한 max receipt_seq 조회
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 7. 2. CBK - 최초생성
	 * </pre>
	 *
	 * @param erpPrmtNo
	 * @return
	 * @throws Exception
	 */
	public int getMaxReceiptSeqForPreorder(String erpPrmtNo) throws Exception {
		return sqlSession2.selectOne("rsv.getMaxReceiptSeqForPreorder", erpPrmtNo);
	}

	/**
	 * <pre>
	 * 작성일 : 2018. 7. 2.
	 * 작성자 : CBK
	 * 설명   : 사전예약 주문 등록을 위한 상품 정보 조회
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 7. 2. CBK - 최초생성
	 * </pre>
	 *
	 * @param erpItmCode
	 * @return
	 * @throws Exception
	 */
	public Map<String, String> selectProductInfoForPreorder(String erpItmCode) throws Exception {
		return sqlSession2.selectOne("rsv.selectProductInfoForPreorder", erpItmCode);
		
	}

	/**
	 * <pre>
	 * 작성일 : 2018. 7. 2.
	 * 작성자 : CBK
	 * 설명   : 사전 예약 주문 등록
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 7. 2. CBK - 최초생성
	 * </pre>
	 *
	 * @param param
	 * @throws Exception
	 */
	public void insertPreorderInfo(PreorderRegDTO param) throws Exception {
		sqlSession2.insert("rsv.insertPreorderInfo", param);
	}
	
	/**
	 * <pre>
	 * 작성일 : 2018. 7. 4.
	 * 작성자 : CBK
	 * 설명   : 사전예약 기획전 이름 수정
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 7. 4. CBK - 최초생성
	 * </pre>
	 *
	 * @param param
	 * @throws Exception
	 */
	public void updatePreorderCtrCode(PreorderPromotionModReqDTO param) throws Exception {
		sqlSession2.update("rsv.updatePreorderCtrCode", param);
	}
	
	/**
	 * <pre>
	 * 작성일 : 2018. 7. 4.
	 * 작성자 : CBK
	 * 설명   : 사전예약기획전 정보 변경에 따른 사전예약 주문 정보 수정(기획전명, 기간)
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 7. 4. CBK - 최초생성
	 * </pre>
	 *
	 * @param param
	 * @throws Exception
	 */
	public void updatePreorderInfo(PreorderPromotionModReqDTO param) throws Exception {
		sqlSession2.update("rsv.updatePreorderInfo", param);
	}
	
	/**
	 * <pre>
	 * 작성일 : 2018. 7. 27.
	 * 작성자 : CBK
	 * 설명   : 가맹점 휴일 정보 조회
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
	public Map<String, String> getStoreHolidayList(StoreHolidayReqDTO param) throws Exception {
		return sqlSession2.selectOne("rsv.selectStoreHoliday", param);
	}
	
	/**
	 * <pre>
	 * 작성일 : 2018. 9. 20.
	 * 작성자 : CBK
	 * 설명   : ERP 방문예약 정보 수정
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
	public int updateErpStoreVisitReserveInfo(StoreVisitReserveMdfyReqDTO param) throws Exception {
		return sqlSession2.update("rsv.updateErpStoreVisitReserveInfo", param);
	}
}
