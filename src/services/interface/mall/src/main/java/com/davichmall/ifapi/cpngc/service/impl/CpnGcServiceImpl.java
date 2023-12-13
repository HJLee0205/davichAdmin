package com.davichmall.ifapi.cpngc.service.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.davichmall.ifapi.cmmn.CustomException;
import com.davichmall.ifapi.cpngc.dao.CpnGcDAO;
import com.davichmall.ifapi.cpngc.dto.GiftCardCheckReqDTO;
import com.davichmall.ifapi.cpngc.dto.GiftCardUseReqDTO;
import com.davichmall.ifapi.cpngc.dto.OffCouponSearchReqDTO;
import com.davichmall.ifapi.cpngc.dto.OffCouponSearchResDTO.OffCouponDTO;
import com.davichmall.ifapi.cpngc.dto.OffCouponUseReqDTO;
import com.davichmall.ifapi.cpngc.dto.OnCouponIssueCancelReqDTO;
import com.davichmall.ifapi.cpngc.dto.OnCouponIssueReqDTO;
import com.davichmall.ifapi.cpngc.service.CpnGcService;

/**
 * <pre>
 * - 프로젝트명    : davichmall_interface
 * - 패키지명      : com.davichmall.ifapi.cpngc.service.impl
 * - 파일명        : CpnGcServiceImpl.java
 * - 작성일        : 2018. 6. 15.
 * - 작성자        : CBK
 * - 설명          : 쿠폰/상품권 인터페이스 처리를 위한 Service
 * </pre>
 */
@Service("cpnGcService")
public class CpnGcServiceImpl implements CpnGcService {
	
	@Resource(name="cpnGcDao")
	CpnGcDAO cpnGcDao;

	/**
	 * (온라인에서 발급한) 오프라인 쿠폰 목록 조회
	 */
	@Override
	public List<OffCouponDTO> selectOffCouponList(OffCouponSearchReqDTO param) throws Exception {
		return cpnGcDao.selectOffCouponList(param);
	}
	
	/**
	 * 오프라인 쿠폰 사용 처리
	 */
	@Override
	public void updateOffCouponUse(OffCouponUseReqDTO param) throws Exception {
		// 쿠폰 사용여부 확인
		String cpnUseYn = cpnGcDao.selectOffCouponUseYn(param);
		if(cpnUseYn == null) {
			// 쿠폰 정보가 없을때
			// 존재하지 않는 쿠폰입니다.
			throw new CustomException("ifapi.exception.cpngc.notexist");
		} else if(!"N".equals(cpnUseYn)) {
			// 사용된 쿠폰일때
			// 이미 사용된 쿠폰입니다.
			throw new CustomException("ifapi.exception.cpngc.alreadyused");
		}
		param.setUseFlg("Y");
		cpnGcDao.updateOffCouponUse(param);
	}
	
	/**
	 * 오프라인 쿠폰 사용 취소 처리
	 */
	@Override
	public void updateOffCouponUseCancel(OffCouponUseReqDTO param) throws Exception {// 쿠폰 사용여부 확인
		String cpnUseYn = cpnGcDao.selectOffCouponUseYn(param);
		if(cpnUseYn == null) {
			// 쿠폰 정보가 없을때
			// 존재하지 않는 쿠폰입니다.
			throw new CustomException("ifapi.exception.cpngc.notexist");
		} else if(!"Y".equals(cpnUseYn)) {
			// 사용되지 않은 쿠폰일때
			// 사용되지 않은 쿠폰입니다.
			throw new CustomException("ifapi.exception.cpngc.notused");
		}
		param.setUseFlg("N");
		cpnGcDao.updateOffCouponUse(param);
	}

	/**
	 * 상품권 정보 조회
	 */
	@Override
	public Map<String, Object> getGiftCardInfo(GiftCardCheckReqDTO param) throws Exception {
		return cpnGcDao.getGiftCardInfo(param);
	}

	/**
	 * 상품권 사용/취소 정보 등록
	 */
	@Transactional(transactionManager="transactionManager2")
	@Override
	public void setGiftCardUseInfo(GiftCardUseReqDTO param) throws Exception {
		// 상품권 사용/취소 처리
		cpnGcDao.updateGiftCardUseInfo(param);
		
		// 상품권 사용/취소 이력 등록
		int maxSeq = cpnGcDao.getGiftCardHistoryMaxSeq(param);
		param.setSeq(maxSeq);
		cpnGcDao.insertGiftCardUseHistory(param);
	}

	/**
	 * 온라인 쿠폰 발급
	 */
	@Override
	public String issueOnlineCoupon(OnCouponIssueReqDTO param) throws Exception {
		// 쿠폰 번호(종류번호) 조회
		if(param.getCouponNo() == null || "".equals(param.getCouponNo())) {
			Integer couponNo = cpnGcDao.getMallCouponNoByBnfAmt(param);
			if(couponNo == null) {
				throw new CustomException("ifapi.exception.cpngc.notexist");
			}
			param.setCouponNo(new Integer(couponNo).toString());
		}
		
		// 쿠폰 발급
		cpnGcDao.insertMallCoupon(param);
		
		// 쿠폰 고유키 반환
		return param.getMemberCpNo();
	}

	/**
	 * 온라인 쿠폰 발급 취소
	 */
	@Override
	public void cancelOnlineCouponIssue(OnCouponIssueCancelReqDTO param) throws Exception {
		// 쿠폰 사용 여부 확인
		String useYn = cpnGcDao.selectMallCouponUseYn(param);
		if(useYn == null) {
			// 데이터가 존재하지 않습니다.
			throw new CustomException("ifapi.exception.data.not.exist");
		}
		if("Y".equals(useYn)) {
			// 이미 사용된 쿠폰입니다.
			throw new CustomException("ifapi.exception.cpngc.alreadyused");
		}
		
		// 쿠폰 삭제
		cpnGcDao.deleteMallCoupon(param);
	}

}
