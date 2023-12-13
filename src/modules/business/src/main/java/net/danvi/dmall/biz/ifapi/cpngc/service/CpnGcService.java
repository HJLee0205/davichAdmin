package net.danvi.dmall.biz.ifapi.cpngc.service;

import java.util.List;
import java.util.Map;

import net.danvi.dmall.biz.ifapi.cpngc.dto.GiftCardCheckReqDTO;
import net.danvi.dmall.biz.ifapi.cpngc.dto.GiftCardUseReqDTO;
import net.danvi.dmall.biz.ifapi.cpngc.dto.OffCouponSearchReqDTO;
import net.danvi.dmall.biz.ifapi.cpngc.dto.OffCouponSearchResDTO.OffCouponDTO;
import net.danvi.dmall.biz.ifapi.cpngc.dto.OffCouponUseReqDTO;
import net.danvi.dmall.biz.ifapi.cpngc.dto.OnCouponIssueCancelReqDTO;
import net.danvi.dmall.biz.ifapi.cpngc.dto.OnCouponIssueReqDTO;

/**
 * <pre>
 * - 프로젝트명    : davichmall_interface
 * - 패키지명      : net.danvi.dmall.admin.ifapi.cpngc.service
 * - 파일명        : CpnGcService.java
 * - 작성일        : 2018. 6. 15.
 * - 작성자        : CBK
 * - 설명          : 쿠폰/상품권 인터페이스 처리를 위한 Service
 * </pre>
 */
public interface CpnGcService {
	
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
	List<OffCouponDTO> selectOffCouponList(OffCouponSearchReqDTO param) throws Exception;
	
	/**
	 * <pre>
	 * 작성일 : 2018. 6. 26.
	 * 작성자 : CBK
	 * 설명   : 오프라인 쿠폰 사용 처리
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 6. 26. CBK - 최초생성
	 * </pre>
	 *
	 * @param param
	 * @throws Exception
	 */
	void updateOffCouponUse(OffCouponUseReqDTO param) throws Exception;
	
	/**
	 * <pre>
	 * 작성일 : 2018. 6. 26.
	 * 작성자 : CBK
	 * 설명   : 오프라인 쿠폰 사용 취소 처리
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 6. 26. CBK - 최초생성
	 * </pre>
	 *
	 * @param param
	 * @throws Exception
	 */
	void updateOffCouponUseCancel(OffCouponUseReqDTO param) throws Exception;

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
	Map<String, Object> getGiftCardInfo(GiftCardCheckReqDTO param) throws Exception;
	
	/**
	 * <pre>
	 * 작성일 : 2018. 6. 15.
	 * 작성자 : CBK
	 * 설명   : 상품권 사용/취소 정보 등록
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 6. 15. CBK - 최초생성
	 * </pre>
	 *
	 * @param param
	 * @throws Exception
	 */
	void setGiftCardUseInfo(GiftCardUseReqDTO param) throws Exception;

	/**
	 * <pre>
	 * 작성일 : 2018. 7. 11.
	 * 작성자 : CBK
	 * 설명   : 온라인 쿠폰 발급
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
	String issueOnlineCoupon(OnCouponIssueReqDTO param) throws Exception;

	/**
	 * <pre>
	 * 작성일 : 2018. 7. 11.
	 * 작성자 : CBK
	 * 설명   : 온라인 쿠폰 발급 취소
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 7. 11. CBK - 최초생성
	 * </pre>
	 *
	 * @param param
	 * @throws Exception
	 */
	void cancelOnlineCouponIssue(OnCouponIssueCancelReqDTO param) throws Exception;
}
