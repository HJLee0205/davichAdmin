package com.davichmall.ifapi.cmmn.mapp.dao;

import java.util.HashMap;
import java.util.Map;

import org.springframework.stereotype.Repository;

import com.davichmall.ifapi.cmmn.base.BaseDAO;
import com.davichmall.ifapi.cmmn.mapp.dto.OffPointMapDTO;
import com.davichmall.ifapi.cmmn.mapp.dto.OrderMapDTO;

/**
 * <pre>
 * - 프로젝트명    : davichmall_interface
 * - 패키지명      : com.davichmall.ifapi.cmmn.mapp.dao
 * - 파일명        : MappingDAO.java
 * - 작성일        : 2018. 5. 18.
 * - 작성자        : CBK
 * - 설명          : 쇼핑몰 - ERP 데이터 매핑 정보 처리 DAO
 * </pre>
 */
@Repository("mappingDao")
public class MappingDAO extends BaseDAO {
	
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
	public String getMallItemCode(String erpItmCode) throws Exception {
		return sqlSession1.selectOne("mapping.selectMallItemCode", erpItmCode);
	}
	
	/**
	 * <pre>
	 * 작성일 : 2018. 6. 7.
	 * 작성자 : CBK
	 * 설명   : 쇼핑몰 단품코드/추가옵션코드로 ERP상품코드 조회
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 6. 7. CBK - 최초생성
	 * </pre>
	 *
	 * @param mallItmCode
	 * @return
	 * @throws Exception
	 */
	public String getErpItemCode(String mallItmCode) throws Exception {
		return sqlSession1.selectOne("mapping.selectErpItemCode", mallItmCode);
	}
	
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
	public void insertItemCodeMap(String mallGoodsNo, String mallItmCode, String erpItmCode) throws Exception {
		Map<String, String> param = new HashMap<>();
		param.put("mallGoodsNo", mallGoodsNo);
		param.put("mallItmCode", mallItmCode);
		param.put("erpItmCode", erpItmCode);
		sqlSession1.insert("mapping.insertItemCodeMap", param);
	}

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
	public void deleteItemCodeMap(String mallGoodsNo, String mallItmCode) throws Exception {
		Map<String, String> param = new HashMap<>();
		param.put("mallGoodsNo", mallGoodsNo);
		param.put("mallItmCode", mallItmCode);
		sqlSession1.delete("mapping.deleteItemCodeMap", param);
	}

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
	public OrderMapDTO getMallOrderNo(OrderMapDTO param) throws Exception {
		return sqlSession1.selectOne("mapping.selectMallOrderNo", param);
	}

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
	public OrderMapDTO getErpOrderNo(OrderMapDTO param) throws Exception {
		return sqlSession1.selectOne("mapping.selectErpOrderNo", param);
	}
	
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
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public OrderMapDTO getLatestOrderMapWithoutChangeReorder(OrderMapDTO param) throws Exception {
		return sqlSession1.selectOne("mapping.selectLatestOrderMapWithoutChangeReorder", param);
	}
	

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
	public void insertOrderNoMap(OrderMapDTO param) throws Exception {
		sqlSession1.insert("mapping.insertOrderNoMap", param);
	}
	
	/**
	 * <pre>
	 * 작성일 : 2018. 5. 21.
	 * 작성자 : CBK
	 * 설명   : ERP 주문상세번호로 쇼핑몰 주문상세번호 조회
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 5. 21. CBK - 최초생성
	 * </pre>
	 *
	 * @return
	 * @throws Exception
	 */
	public OrderMapDTO getMallOrderDtlNo(OrderMapDTO param) throws Exception {
		return sqlSession1.selectOne("mapping.selectMallOrderDtlNo", param);
	}
	
	/**
	 * <pre>
	 * 작성일 : 2018. 5. 21.
	 * 작성자 : CBK
	 * 설명   : 쇼핑몰 주문상세번호로 ERP주문상세번호 조회
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 5. 21. CBK - 최초생성
	 * </pre>
	 *
	 * @return
	 * @throws Exception
	 */
	public OrderMapDTO getErpOrderDtlNo(OrderMapDTO param) throws Exception {
		return sqlSession1.selectOne("mapping.selectErpOrderDtlNo", param);
	}
	
	/**
	 * <pre>
	 * 작성일 : 2018. 5. 21.
	 * 작성자 : CBK
	 * 설명   : 쇼핑몰-ERP 주문상세 번호 매핑 정보 등록
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 5. 21. CBK - 최초생성
	 * </pre>
	 *
	 * @return
	 * @throws Exception
	 */
	public void insertOrderDtlNoMap(OrderMapDTO param) throws Exception {
		sqlSession1.insert("mapping.insertOrderDtlNoMap", param);
	}
	
	/**
	 * <pre>
	 * 작성일 : 2018. 8. 22.
	 * 작성자 : CBK
	 * 설명   : 쇼핑몰 주문 번호로 주문번호 매핑 지우기
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 8. 22. CBK - 최초생성
	 * </pre>
	 *
	 * @param param
	 * @throws Exception
	 */
	public void deleteOrderMap(OrderMapDTO param) throws Exception {
		sqlSession1.update("mapping.deleteOrderMap", param);
	}
	
	/**
	 * <pre>
	 * 작성일 : 2018. 8. 22.
	 * 작성자 : CBK
	 * 설명   : ERP 주문번호 기준으로 주문 상세 번호 매핑 지우기
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 8. 22. CBK - 최초생성
	 * </pre>
	 *
	 * @param param
	 * @throws Exception
	 */
	public void deleteOrderDtlMap(OrderMapDTO param) throws Exception {
		sqlSession1.update("mapping.deleteOrderDtlMap", param);
	}
	
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
	 * @param param
	 * @throws Exception
	 */
	public void insertClaimNoMap(OrderMapDTO param) throws Exception {
		sqlSession1.insert("mapping.insertClaimNoMap", param);
	}
	
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
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public OrderMapDTO getErpClaimNo(OrderMapDTO param) throws Exception {
		return sqlSession1.selectOne("mapping.selectErpClaimNo", param);
	}
	
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
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public OrderMapDTO getMallClaimNo(OrderMapDTO param) throws Exception {
		return sqlSession1.selectOne("mapping.selectMallClaimNo", param);
	}
	
	/**
	 * <pre>
	 * 작성일 : 2018. 5. 21.
	 * 작성자 : CBK
	 * 설명   : 쇼핑몰 회원번호로 ERP 회원번호 조회
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 5. 21. CBK - 최초생성
	 * </pre>
	 *
	 * @return
	 * @throws Exception
	 */
	public String getErpMemberNo(String mallMemberNo) throws Exception {
		return sqlSession1.selectOne("mapping.selectErpMemberNo", mallMemberNo);
	}

	/**
	 * <pre>
	 * 작성일 : 2018. 5. 21.
	 * 작성자 : CBK
	 * 설명   : ERP 회원번호로 쇼핑몰 회원번호 조회
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 5. 21. CBK - 최초생성
	 * </pre>
	 *
	 * @return
	 * @throws Exception
	 */
	public String getMallMemberNo(String erpMemberNo) throws Exception {
		return sqlSession1.selectOne("mapping.selectMallMemberNo", erpMemberNo);
	}
	
	/**
	 * <pre>
	 * 작성일 : 2018. 5. 21.
	 * 작성자 : CBK
	 * 설명   : 쇼핑몰-ERP 회원번호 매핑 정보 등록
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 5. 21. CBK - 최초생성
	 * </pre>
	 *
	 * @return
	 * @throws Exception
	 */
	public void insertMemberMap(String mallMemberNo, String erpMemberNo, String erpMemberLvl) throws Exception {
		Map<String, String> param = new HashMap<>();
		param.put("mallMemberNo", mallMemberNo);
		param.put("erpMemberNo", erpMemberNo);
		param.put("erpMemberLvl", erpMemberLvl);
		sqlSession1.insert("mapping.insertMemberMap", param);
	}
	
	/**
	 * <pre>
	 * 작성일 : 2018. 5. 28.
	 * 작성자 : CBK
	 * 설명   : 쇼핑몰-ERP 회원번호 매핑 정보 삭제(완전삭제)
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
	public void deleteMemberMap(String mallMemberNo, String erpMemberNo) throws Exception {
		Map<String, String> param = new HashMap<>();
		param.put("mallMemberNo", mallMemberNo);
		param.put("erpMemberNo", erpMemberNo);
		sqlSession1.insert("mapping.deleteMemberMap", param);
	}

	/**
	 * <pre>
	 * 작성일 : 2018. 5. 21.
	 * 작성자 : CBK
	 * 설명   : 쇼핑몰-ERP 회원번호 매핑 정보 삭제 (쇼핑몰 회원번호 기준)
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 5. 21. CBK - 최초생성
	 * </pre>
	 *
	 * @return
	 * @throws Exception
	 */
	public void deleteMemberMapByMall(String mallMemberNo) throws Exception {
		sqlSession1.update("mapping.deleteMemberMapByMall", mallMemberNo);
	}

	/**
	 * <pre>
	 * 작성일 : 2018. 5. 21.
	 * 작성자 : CBK
	 * 설명   : 쇼핑몰-ERP 회원번호 매핑 정보 삭제 (ERP 회원번호 기준)
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 5. 21. CBK - 최초생성
	 * </pre>
	 *
	 * @return
	 * @throws Exception
	 */
	public void deleteMemberMapByErp(String erpMemberNo) throws Exception {
		sqlSession1.update("mapping.deleteMemberMapByErp", erpMemberNo);
	}
	
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
	public void insertPOMap(String mallPrmtNo, String erpPrmtNo) throws Exception {
		Map<String, String> param = new HashMap<>();
		param.put("mallPrmtNo", mallPrmtNo);
		param.put("erpPrmtNo", erpPrmtNo);
		sqlSession1.insert("mapping.insertPOMap", param);
	}
	
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
	public String getErpPrmtNo(String mallPrmtNo) throws Exception {
		return sqlSession1.selectOne("mapping.selectErpPrmtNo", mallPrmtNo);
	}
	
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
	public String getMallPrmtNo(String erpPrmtNO) throws Exception {
		return sqlSession1.selectOne("mapping.selectMallPrmtNo", erpPrmtNO);
	}
	
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
	public void insertOfflinePointMap(OffPointMapDTO param) throws Exception {
		sqlSession1.insert("mapping.insertOfflinePointMap", param);
	}
	
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
	public OffPointMapDTO getOfflinePointMapByMall(OffPointMapDTO param) throws Exception {
		return sqlSession1.selectOne("mapping.selectOfflinePointMapByMall", param);
	}
	
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
	public void deleteOfflinePointMapByMall(OffPointMapDTO param) throws Exception {
		sqlSession1.update("mapping.deleteOfflinePointMapByMall", param);
	}

}
