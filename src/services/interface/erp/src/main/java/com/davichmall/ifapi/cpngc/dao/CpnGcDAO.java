package com.davichmall.ifapi.cpngc.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import com.davichmall.ifapi.cmmn.base.BaseDAO;
import com.davichmall.ifapi.cpngc.dto.GiftCardCheckReqDTO;
import com.davichmall.ifapi.cpngc.dto.GiftCardUseReqDTO;
import com.davichmall.ifapi.cpngc.dto.OffCouponSearchReqDTO;
import com.davichmall.ifapi.cpngc.dto.OffCouponSearchResDTO.OffCouponDTO;
import com.davichmall.ifapi.cpngc.dto.OffCouponUseReqDTO;
import com.davichmall.ifapi.cpngc.dto.OnCouponIssueCancelReqDTO;
import com.davichmall.ifapi.cpngc.dto.OnCouponIssueReqDTO;

@Repository("cpnGcDao")
public class CpnGcDAO extends BaseDAO {

	/**
	 * <pre>
	 * 작성일 : 2018. 6. 26.
	 * 작성자 : CBK
	 * 설명   : (온라인에서 발급한) 오프라인 쿠폰 목록 조회
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 6. 26. CBK - 최초생성
	 * </pre>
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public List<OffCouponDTO> selectOffCouponList(OffCouponSearchReqDTO param) throws Exception {
		return sqlSession1.selectList("cpngc.selectOffCouponList", param);
	}
	
	/**
	 * <pre>
	 * 작성일 : 2018. 8. 8.
	 * 작성자 : CBK
	 * 설명   : 쿠폰 사용여부 확인
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 8. 8. CBK - 최초생성
	 * </pre>
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public String selectOffCouponUseYn(OffCouponUseReqDTO param) throws Exception {
		return sqlSession1.selectOne("cpngc.selectOffCouponUseYn", param);
	}
	
	/**
	 * <pre>
	 * 작성일 : 2018. 6. 26.
	 * 작성자 : CBK
	 * 설명   : 쿠폰 사용/취소 처리
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 6. 26. CBK - 최초생성
	 * </pre>
	 *
	 * @param param
	 * @throws Exception
	 */
	public void updateOffCouponUse(OffCouponUseReqDTO param) throws Exception {
		sqlSession1.update("cpngc.updateOffCouponUse", param);
	}
	
	/**
	 * <pre>
	 * 작성일 : 2018. 6. 15.
	 * 작성자 : CBK
	 * 설명   : 상품권 정보 조회
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 6. 15. CBK - 최초생성
	 * </pre>
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public Map<String, Object> getGiftCardInfo(GiftCardCheckReqDTO param) throws Exception {
		return sqlSession2.selectOne("cpngc.selectGiftCardInfo", param);
	}
	
	/**
	 * <pre>
	 * 작성일 : 2018. 6. 15.
	 * 작성자 : CBK
	 * 설명   : 상품권 사용상태 변경
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 6. 15. CBK - 최초생성
	 * </pre>
	 *
	 * @param param
	 * @throws Exception
	 */
	public void updateGiftCardUseInfo(GiftCardUseReqDTO param) throws Exception {
		sqlSession2.update("cpngc.updateGiftCardUse", param);
	}
	
	/**
	 * <pre>
	 * 작성일 : 2018. 6. 15.
	 * 작성자 : CBK
	 * 설명   : 상품권 사용/취소 이력 테이블에서 상품권의 최대 순번 +1 을 조회
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 6. 15. CBK - 최초생성
	 * </pre>
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public int getGiftCardHistoryMaxSeq(GiftCardUseReqDTO param) throws Exception {
		return sqlSession2.selectOne("cpngc.getGiftCardHistoryMaxSeq", param);
	}
	
	/**
	 * <pre>
	 * 작성일 : 2018. 6. 15.
	 * 작성자 : CBK
	 * 설명   : 상품권 사용/취소 이력 등록
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 6. 15. CBK - 최초생성
	 * </pre>
	 *
	 * @param param
	 * @throws Exception
	 */
	public void insertGiftCardUseHistory(GiftCardUseReqDTO param) throws Exception {
		sqlSession2.insert("cpngc.insertGiftCardUseHistory", param);
	}

	/**
	 * <pre>
	 * 작성일 : 2018. 7. 11.
	 * 작성자 : CBK
	 * 설명   : 온라인 쿠폰 발급을 위한 쿠폰 번호(쿠폰 종류 번호) 조회
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 7. 11. CBK - 최초생성
	 * </pre>
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public Integer getMallCouponNoByBnfAmt(OnCouponIssueReqDTO param) throws Exception {
		return sqlSession1.selectOne("cpngc.getMallCouponNoByBnfAmt", param);
	}

	/**
	 * <pre>
	 * 작성일 : 2018. 7. 11.
	 * 작성자 : CBK
	 * 설명   : 오프라인에서 온라인 쿠폰 발급
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 7. 11. CBK - 최초생성
	 * </pre>
	 *
	 * @param param
	 * @throws Exception
	 */
	public void insertMallCoupon(OnCouponIssueReqDTO param) throws Exception {
		sqlSession1.insert("cpngc.insertMallCoupon", param);
	}

	/**
	 * <pre>
	 * 작성일 : 2018. 7. 11.
	 * 작성자 : CBK
	 * 설명   : 오프라인에서 발급한 온라인 쿠폰 사용 여부 확인
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 7. 11. CBK - 최초생성
	 * </pre>
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public String selectMallCouponUseYn(OnCouponIssueCancelReqDTO param) throws Exception {
		return sqlSession1.selectOne("cpngc.selectMallCouponUseYn", param);
	}

	/**
	 * <pre>
	 * 작성일 : 2018. 7. 11.
	 * 작성자 : CBK
	 * 설명   : 오프라인에서 온라인 쿠폰 발급 취소 (삭제)
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 7. 11. CBK - 최초생성
	 * </pre>
	 *
	 * @param param
	 * @throws Exception
	 */
	public void deleteMallCoupon(OnCouponIssueCancelReqDTO param) throws Exception {
		sqlSession1.delete("cpngc.deleteMallCoupon", param);
	}
}
