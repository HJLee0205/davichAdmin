package net.danvi.dmall.biz.ifapi.cpngc.service.impl;

import java.util.List;
import java.util.Map;

import dmall.framework.common.BaseService;
import net.danvi.dmall.biz.ifapi.cpngc.dto.OffCouponSearchReqDTO;
import net.danvi.dmall.biz.ifapi.cpngc.dto.OffCouponSearchResDTO;
import net.danvi.dmall.biz.ifapi.cpngc.dto.OnCouponIssueCancelReqDTO;
import net.danvi.dmall.biz.ifapi.cpngc.service.CpnGcService;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import net.danvi.dmall.biz.ifapi.cmmn.CustomIfException;
import net.danvi.dmall.biz.ifapi.cpngc.dto.GiftCardCheckReqDTO;
import net.danvi.dmall.biz.ifapi.cpngc.dto.GiftCardUseReqDTO;
import net.danvi.dmall.biz.ifapi.cpngc.dto.OffCouponUseReqDTO;
import net.danvi.dmall.biz.ifapi.cpngc.dto.OnCouponIssueReqDTO;

/**
 * <pre>
 * - 프로젝트명    : davichmall_interface
 * - 패키지명      : net.danvi.dmall.admin.ifapi.cpngc.service.impl
 * - 파일명        : CpnGcServiceImpl.java
 * - 작성일        : 2018. 6. 15.
 * - 작성자        : CBK
 * - 설명          : 쿠폰/상품권 인터페이스 처리를 위한 Service
 * </pre>
 */
@Service("cpnGcService")
public class CpnGcServiceImpl extends BaseService implements CpnGcService {

	/**
	 * (온라인에서 발급한) 오프라인 쿠폰 목록 조회
	 */
	@Override
	public List<OffCouponSearchResDTO.OffCouponDTO> selectOffCouponList(OffCouponSearchReqDTO param) throws Exception {
		return proxyDao.selectList("cpngc.selectOffCouponList", param);
	}
	
	/**
	 * 오프라인 쿠폰 사용 처리
	 */
	@Override
	public void updateOffCouponUse(OffCouponUseReqDTO param) throws Exception {
		// 쿠폰 사용여부 확인
		String cpnUseYn = proxyDao.selectOne("cpngc.selectOffCouponUseYn", param);
		if(cpnUseYn == null) {
			// 쿠폰 정보가 없을때
			// 존재하지 않는 쿠폰입니다.
			throw new CustomIfException("ifapi.exception.cpngc.notexist");
		} else if(!"N".equals(cpnUseYn)) {
			// 사용된 쿠폰일때
			// 이미 사용된 쿠폰입니다.
			throw new CustomIfException("ifapi.exception.cpngc.alreadyused");
		}
		param.setUseFlg("Y");
		proxyDao.update("cpngc.updateOffCouponUse", param);
	}
	
	/**
	 * 오프라인 쿠폰 사용 취소 처리
	 */
	@Override
	public void updateOffCouponUseCancel(OffCouponUseReqDTO param) throws Exception {// 쿠폰 사용여부 확인
		String cpnUseYn = proxyDao.selectOne("cpngc.selectOffCouponUseYn", param);
		if(cpnUseYn == null) {
			// 쿠폰 정보가 없을때
			// 존재하지 않는 쿠폰입니다.
			throw new CustomIfException("ifapi.exception.cpngc.notexist");
		} else if(!"Y".equals(cpnUseYn)) {
			// 사용되지 않은 쿠폰일때
			// 사용되지 않은 쿠폰입니다.
			throw new CustomIfException("ifapi.exception.cpngc.notused");
		}
		param.setUseFlg("N");
		proxyDao.update("cpngc.updateOffCouponUse", param);
	}

	/**
	 * 상품권 정보 조회
	 */
	@Override
	public Map<String, Object> getGiftCardInfo(GiftCardCheckReqDTO param) throws Exception {
		return proxyDao.selectOne("cpngc.selectGiftCardInfo", param);
	}

	/**
	 * 상품권 사용/취소 정보 등록
	 */
//	@Transactional(transactionManager="transactionManager2")
	@Override
	public void setGiftCardUseInfo(GiftCardUseReqDTO param) throws Exception {
		// 상품권 사용/취소 처리
		proxyDao.update("cpngc.updateGiftCardUse", param);
		
		// 상품권 사용/취소 이력 등록
		int maxSeq = proxyDao.selectOne("cpngc.getGiftCardHistoryMaxSeq", param);
		param.setSeq(maxSeq);
		proxyDao.insert("cpngc.insertGiftCardUseHistory", param);
	}

	/**
	 * 온라인 쿠폰 발급
	 */
	@Override
	public String issueOnlineCoupon(OnCouponIssueReqDTO param) throws Exception {
		// 쿠폰 번호(종류번호) 조회
		if(param.getCouponNo() == null || "".equals(param.getCouponNo())) {
			Integer couponNo = proxyDao.selectOne("cpngc.getMallCouponNoByBnfAmt", param);
			if(couponNo == null) {
				throw new CustomIfException("ifapi.exception.cpngc.notexist");
			}
			param.setCouponNo(new Integer(couponNo).toString());
		}
		
		// 쿠폰 발급
		proxyDao.insert("cpngc.insertMallCoupon", param);
		
		// 쿠폰 고유키 반환
		return param.getMemberCpNo();
	}

	/**
	 * 온라인 쿠폰 발급 취소
	 */
	@Override
	public void cancelOnlineCouponIssue(OnCouponIssueCancelReqDTO param) throws Exception {
		// 쿠폰 사용 여부 확인
		String useYn = proxyDao.selectOne("cpngc.selectMallCouponUseYn", param);
		if(useYn == null) {
			// 데이터가 존재하지 않습니다.
			throw new CustomIfException("ifapi.exception.data.not.exist");
		}
		if("Y".equals(useYn)) {
			// 이미 사용된 쿠폰입니다.
			throw new CustomIfException("ifapi.exception.cpngc.alreadyused");
		}
		
		// 쿠폰 삭제
		proxyDao.delete("cpngc.deleteMallCoupon", param);
	}

}
