package com.davichmall.ifapi.cpngc.controller;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.davichmall.ifapi.cmmn.CustomException;
import com.davichmall.ifapi.cmmn.base.BaseController;
import com.davichmall.ifapi.cmmn.constant.Constants;
import com.davichmall.ifapi.cpngc.dto.GiftCardCheckReqDTO;
import com.davichmall.ifapi.cpngc.dto.GiftCardCheckResDTO;
import com.davichmall.ifapi.cpngc.dto.GiftCardUseReqDTO;
import com.davichmall.ifapi.cpngc.dto.GiftCardUseResDTO;
import com.davichmall.ifapi.cpngc.dto.OffCouponSearchReqDTO;
import com.davichmall.ifapi.cpngc.dto.OffCouponSearchResDTO;
import com.davichmall.ifapi.cpngc.dto.OffCouponSearchResDTO.OffCouponDTO;
import com.davichmall.ifapi.cpngc.dto.OffCouponUseReqDTO;
import com.davichmall.ifapi.cpngc.dto.OffCouponUseResDTO;
import com.davichmall.ifapi.cpngc.dto.OnCouponIssueCancelReqDTO;
import com.davichmall.ifapi.cpngc.dto.OnCouponIssueCancelResDTO;
import com.davichmall.ifapi.cpngc.dto.OnCouponIssueReqDTO;
import com.davichmall.ifapi.cpngc.dto.OnCouponIssueResDTO;
import com.davichmall.ifapi.cpngc.service.CpnGcService;

/**
 * <pre>
 * - 프로젝트명    : davichmall_interface
 * - 패키지명      : com.davichmall.ifapi.cpngc.controller
 * - 파일명        : CpnGcController.java
 * - 작성일        : 2018. 6. 15.
 * - 작성자        : CBK
 * - 설명          : 쿠폰/상품권 인터페이스 처리를 위한 Controller
 * </pre>
 */
@Controller
public class CpnGcController extends BaseController {
	
	@Resource(name="cpnGcService")
	CpnGcService cpnGcService;

	/**
	 * 쇼핑몰 가맹점 코드
	 */
	@Value("${mall.strcode}")
	String strCode;
	
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
	@RequestMapping(value="/" + Constants.IFID.OFF_COUPON_LIST_SEARCH)
	public @ResponseBody String searchOffCouponList(OffCouponSearchReqDTO param) throws Exception {
		
		String ifId = Constants.IFID.OFF_COUPON_LIST_SEARCH;
		
		try {

			// 쇼핑몰 처리 부분
			// Response DTO 생성
			OffCouponSearchResDTO resDto = new OffCouponSearchResDTO();
			resDto.setResult(Constants.RESULT.SUCCESS);
			resDto.setMessage("");
			
			// 쿠폰 목록 조회
			List<OffCouponDTO> cpnList = cpnGcService.selectOffCouponList(param);
			
			// 응답 DTO에 데이터 담기
			resDto.setCpnList(cpnList);
			
			// 처리 로그 등록
			logService.writeInterfaceLog(ifId, param, resDto);
			
			// 결과 반환
			return toJsonRes(resDto, param);
			
		} catch (CustomException ce) {
			ce.setReqParam(param);
			ce.setIfId(ifId);
			throw ce;
		} catch (Exception e) {
			e.printStackTrace();
			throw new CustomException(e, param, ifId);
		}
	}
	
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
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/" + Constants.IFID.OFF_COUPON_USE)
	public @ResponseBody String useOfflineCoupon(OffCouponUseReqDTO param) throws Exception {
		String ifId = Constants.IFID.OFF_COUPON_USE;
		
		try {

			// 쇼핑몰 처리 부분
			// Response DTO 생성
			OffCouponUseResDTO resDto = new OffCouponUseResDTO();
			resDto.setResult(Constants.RESULT.SUCCESS);
			resDto.setMessage("");
			
			param.setUpdrNo(Constants.IF_REGR_NO.toString());
			
			// 데이터 처리
			cpnGcService.updateOffCouponUse(param);
			
			// 처리 로그 등록
			logService.writeInterfaceLog(ifId, param, resDto);
			
			// 결과 반환
			return toJsonRes(resDto, param);
			
		} catch (CustomException ce) {
			ce.setReqParam(param);
			ce.setIfId(ifId);
			throw ce;
		} catch (Exception e) {
			e.printStackTrace();
			throw new CustomException(e, param, ifId);
		}
	}
	
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
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/" + Constants.IFID.OFF_COUPON_USE_CANCEL)
	public @ResponseBody String cancelUseOfflineCoupon(OffCouponUseReqDTO param) throws Exception {
		String ifId = Constants.IFID.OFF_COUPON_USE_CANCEL;

		try {
			
			// 쇼핑몰 처리 부분
			// Response DTO 생성
			OffCouponUseResDTO resDto = new OffCouponUseResDTO();
			resDto.setResult(Constants.RESULT.SUCCESS);
			resDto.setMessage("");
			
			param.setUpdrNo(Constants.IF_REGR_NO.toString());
			
			// 데이터 처리
			cpnGcService.updateOffCouponUseCancel(param);
			
			// 처리 로그 등록
			logService.writeInterfaceLog(ifId, param, resDto);
			
			// 결과 반환
			return toJsonRes(resDto, param);
			
		} catch (CustomException ce) {
			ce.setReqParam(param);
			ce.setIfId(ifId);
			throw ce;
		} catch (Exception e) {
			e.printStackTrace();
			throw new CustomException(e, param, ifId);
		}
	}
	
	/**
	 * <pre>
	 * 작성일 : 2018. 6. 15.
	 * 작성자 : CBK
	 * 설명   : 상품권 사용 가능 여부 체크
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
	@RequestMapping(value="/" + Constants.IFID.GIFT_CARD_CHECK)
	public @ResponseBody String checkGiftCardUsable(GiftCardCheckReqDTO param) throws Exception {
		String ifId = Constants.IFID.GIFT_CARD_CHECK;
		
		try {
			
			// 쇼핑몰 처리 부분
			
			// ERP 쪽으로 데이터 전송
			String resParam = sendUtil.send(param, ifId);;
			
			// 처리 로그 등록
			logService.writeInterfaceLog(ifId, param, resParam, GiftCardCheckResDTO.class);
			
			// 결과 반환
			return resParam;
			
		} catch (CustomException ce) {
			ce.setReqParam(param);
			ce.setIfId(ifId);
			throw ce;
		} catch (Exception e) {
			e.printStackTrace();
			throw new CustomException(e, param, ifId);
		}
	}
	
	/**
	 * <pre>
	 * 작성일 : 2018. 6. 15.
	 * 작성자 : CBK
	 * 설명   : 상품권 사용 정보 등록
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
	@RequestMapping(value="/" + Constants.IFID.GIFT_CARD_USE)
	public @ResponseBody String useGiftCard(GiftCardUseReqDTO param) throws Exception {
		String ifId = Constants.IFID.GIFT_CARD_USE;
		
		try {
			// 쇼핑몰 처리 부분
			
			// ERP 쪽으로 데이터 전송
			String resParam = sendUtil.send(param, ifId);;
			
			// 처리 로그 등록
			logService.writeInterfaceLog(ifId, param, resParam, GiftCardUseResDTO.class);
			
			// 결과 반환
			return resParam;
			
		} catch (CustomException ce) {
			ce.setReqParam(param);
			ce.setIfId(ifId);
			throw ce;
		} catch (Exception e) {
			e.printStackTrace();
			throw new CustomException(e, param, ifId);
		}
	}
	
	/**
	 * <pre>
	 * 작성일 : 2018. 6. 15.
	 * 작성자 : CBK
	 * 설명   : 상품권 사용 취소 정보 등록
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
	@RequestMapping(value="/" + Constants.IFID.GIFT_CARD_CANCEL)
	public @ResponseBody String cancelGiftCardUse(GiftCardUseReqDTO param) throws Exception {
		String ifId = Constants.IFID.GIFT_CARD_CANCEL;
		
		try {
			// 쇼핑몰 처리 부분
			
			// ERP 쪽으로 데이터 전송
			String resParam = sendUtil.send(param, ifId);;
			
			// 처리 로그 등록
			logService.writeInterfaceLog(ifId, param, resParam, GiftCardUseResDTO.class);
			
			// 결과 반환
			return resParam;

		} catch (CustomException ce) {
			ce.setReqParam(param);
			ce.setIfId(ifId);
			throw ce;
		} catch (Exception e) {
			e.printStackTrace();
			throw new CustomException(e, param, ifId);
		}
	}
	
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
	@RequestMapping(value="/" + Constants.IFID.ISSUE_ON_COUPON)
	public @ResponseBody String issueOnlineCoupon(OnCouponIssueReqDTO param) throws Exception {
		String ifId = Constants.IFID.ISSUE_ON_COUPON;
		
		try {
			
			// 쇼핑몰 처리 부분
			// Response DTO 생성
			OnCouponIssueResDTO resDto = new OnCouponIssueResDTO();
			resDto.setResult(Constants.RESULT.SUCCESS);
			resDto.setMessage("");

			// ERP 회원번호를 쇼핑몰 회원 번호로 변경
			String memNo = mappingService.getMallMemberNo(param.getCdCust());
			if(memNo == null) {
				// 통합회원이 아닙니다.
				throw new CustomException("ifapi.exception.member.notcombined");
			}
			param.setMemNo(memNo);
			
			// 등록자/사이트번호 세팅
			param.setRegrNo(Constants.IF_REGR_NO);
			param.setSiteNo(Constants.SITE_NO);
			
			// 쿠폰 발급
			String cpnNo = cpnGcService.issueOnlineCoupon(param);
			
			// 응답 DTO에 쿠폰 번호(고유번호) 설정
			resDto.setCpnNo(cpnNo);
			
			// 처리 로그 등록
			logService.writeInterfaceLog(ifId, param, resDto);
			
			// 결과 반환
			return toJsonRes(resDto, param);

		} catch (CustomException ce) {
			ce.setReqParam(param);
			ce.setIfId(ifId);
			throw ce;
		} catch (Exception e) {
			e.printStackTrace();
			throw new CustomException(e, param, ifId);
		}
	}
	
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
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/" + Constants.IFID.CANCEL_ON_COUPON_ISSUE)
	public @ResponseBody String cancelOnCouponIssue(OnCouponIssueCancelReqDTO param) throws Exception {
		String ifId = Constants.IFID.CANCEL_ON_COUPON_ISSUE;
		
		try {
			
			// 쇼핑몰 처리 부분
			// Response DTO 생성
			OnCouponIssueCancelResDTO resDto = new OnCouponIssueCancelResDTO();
			resDto.setResult(Constants.RESULT.SUCCESS);
			resDto.setMessage("");

			// ERP 회원번호를 쇼핑몰 회원 번호로 변경
			String memNo = mappingService.getMallMemberNo(param.getCdCust());
			if(memNo == null) {
				// 통합회원이 아닙니다.
				throw new CustomException("ifapi.exception.member.notcombined");
			}
			param.setMemNo(memNo);
			
			// 쿠폰 삭제
			cpnGcService.cancelOnlineCouponIssue(param);
			
			// 처리 로그 등록
			logService.writeInterfaceLog(ifId, param, resDto);
			
			// 결과 반환
			return toJsonRes(resDto, param);

		} catch (CustomException ce) {
			ce.setReqParam(param);
			ce.setIfId(ifId);
			throw ce;
		} catch (Exception e) {
			e.printStackTrace();
			throw new CustomException(e, param, ifId);
		}
	}
	
}
