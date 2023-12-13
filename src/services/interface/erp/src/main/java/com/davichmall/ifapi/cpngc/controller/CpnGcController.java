package com.davichmall.ifapi.cpngc.controller;

import java.util.Map;

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

			// ERP 처리 부분
			
			// 쇼핑몰 쪽으로 데이터 전송
			String resParam = sendUtil.send(param, ifId);
			
			// 처리 로그 등록
			logService.writeInterfaceLog(ifId, param, resParam, OffCouponSearchResDTO.class);
			
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
			
			// ERP 처리 부분
			// 쇼핑몰 쪽으로 데이터 전송
			String resParam = sendUtil.send(param, ifId);
			
			// 처리 로그 등록
			logService.writeInterfaceLog(ifId, param, resParam, OffCouponUseResDTO.class);
			
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
			
			// ERP 처리 부분
			// 쇼핑몰 쪽으로 데이터 전송
			String resParam = sendUtil.send(param, ifId);
			
			// 처리 로그 등록
			logService.writeInterfaceLog(ifId, param, resParam, OffCouponUseResDTO.class);
			
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
			
			// ERP 처리 부분
			GiftCardCheckResDTO resDto = new GiftCardCheckResDTO();
			resDto.setResult(Constants.RESULT.SUCCESS);
			resDto.setMessage("");
			
			// 상품권 정보 조회
			Map<String, Object> giftCardInfo = cpnGcService.getGiftCardInfo(param);
			
			if(giftCardInfo != null) {
				// response dto에 데이터 옮겨 담기
				resDto.setGiftCardNo(giftCardInfo.get("giftCardNo").toString());
				resDto.setGiftCardAmt(new Integer(giftCardInfo.get("giftCardAmt").toString()));
				resDto.setUseYn(giftCardInfo.get("useYn").toString());
			}
			
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
			
			// ERP 처리 부분
			GiftCardUseResDTO resDto = new GiftCardUseResDTO();
			resDto.setResult(Constants.RESULT.SUCCESS);
			resDto.setMessage("");
			
			// 사용처리를 위한 데이터 설정
			param.setStrCode(strCode);
			param.setUseFlg(Constants.GIFT_CARD_USE_FLG.USE);
			param.setUseYn("Y");
			
			// 상품권 사용 처리
			cpnGcService.setGiftCardUseInfo(param);

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
			
			// ERP 처리 부분
			GiftCardUseResDTO resDto = new GiftCardUseResDTO();
			resDto.setResult(Constants.RESULT.SUCCESS);
			resDto.setMessage("");
			
			// 사용처리를 위한 데이터 설정
			param.setStrCode(strCode);
			param.setUseFlg(Constants.GIFT_CARD_USE_FLG.CANCEL);
			param.setUseYn("N");
			
			// 상품권 사용 처리
			cpnGcService.setGiftCardUseInfo(param);

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
			// ERP 처리 부분
			// 쇼핑몰 쪽으로 데이터 전송
			String resParam = sendUtil.send(param, ifId);
			
			// 처리 로그 등록
			logService.writeInterfaceLog(ifId, param, resParam, OnCouponIssueResDTO.class);
			
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
			// ERP 처리 부분
			// 쇼핑몰 쪽으로 데이터 전송
			String resParam = sendUtil.send(param, ifId);
			
			// 처리 로그 등록
			logService.writeInterfaceLog(ifId, param, resParam, OnCouponIssueCancelResDTO.class);
			
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
	
}
