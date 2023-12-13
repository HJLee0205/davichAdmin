package com.davichmall.ifapi.mem.controller;

import java.util.ArrayList;
import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.davichmall.ifapi.cmmn.CustomException;
import com.davichmall.ifapi.cmmn.base.BaseController;
import com.davichmall.ifapi.cmmn.base.BaseReqDTO;
import com.davichmall.ifapi.cmmn.constant.Constants;
import com.davichmall.ifapi.cmmn.mapp.dto.OffPointMapDTO;
import com.davichmall.ifapi.mem.dto.AppMemberLoginReqDTO;
import com.davichmall.ifapi.mem.dto.AppMemberLoginResDTO;
import com.davichmall.ifapi.mem.dto.BeaconDataReqDTO;
import com.davichmall.ifapi.mem.dto.BeaconDataResDTO;
import com.davichmall.ifapi.mem.dto.MallEyesightInfoReqDTO;
import com.davichmall.ifapi.mem.dto.MallEyesightInfoResDTO;
import com.davichmall.ifapi.mem.dto.MallVCResultReqDTO;
import com.davichmall.ifapi.mem.dto.MallVCResultResDTO;
import com.davichmall.ifapi.mem.dto.MallVCResultResDTO.MallVCResultDTO;
import com.davichmall.ifapi.mem.dto.MemberCombineReqDTO;
import com.davichmall.ifapi.mem.dto.MemberCombineResDTO;
import com.davichmall.ifapi.mem.dto.MemberOffLevelResDTO;
import com.davichmall.ifapi.mem.dto.MemberYearEndTaxReqDTO;
import com.davichmall.ifapi.mem.dto.MemberYearEndTaxResDTO;
import com.davichmall.ifapi.mem.dto.OffPointHistorySearchReqDTO;
import com.davichmall.ifapi.mem.dto.OffPointHistorySearchResDTO;
import com.davichmall.ifapi.mem.dto.OffPointSearchReqDTO;
import com.davichmall.ifapi.mem.dto.OffPointSearchResDTO;
import com.davichmall.ifapi.mem.dto.OffPointUseCancelReqDTO;
import com.davichmall.ifapi.mem.dto.OffPointUseCancelResDTO;
import com.davichmall.ifapi.mem.dto.OffPointUseReqDTO;
import com.davichmall.ifapi.mem.dto.OffPointUseResDTO;
import com.davichmall.ifapi.mem.dto.OfflineCardNoDupCheckReqDTO;
import com.davichmall.ifapi.mem.dto.OfflineCardNoDupCheckResDTO;
import com.davichmall.ifapi.mem.dto.OfflineMemSearchReqDTO;
import com.davichmall.ifapi.mem.dto.OfflineMemSearchResDTO;
import com.davichmall.ifapi.mem.dto.OnPointSearchReqDTO;
import com.davichmall.ifapi.mem.dto.OnPointSearchResDTO;
import com.davichmall.ifapi.mem.dto.OnPointUseCancelReqDTO;
import com.davichmall.ifapi.mem.dto.OnPointUseCancelResDTO;
import com.davichmall.ifapi.mem.dto.OnPointUseReqDTO;
import com.davichmall.ifapi.mem.dto.OnPointUseResDTO;
import com.davichmall.ifapi.mem.dto.OnlineMemSearchReqDTO;
import com.davichmall.ifapi.mem.dto.OnlineMemSearchResDTO;
import com.davichmall.ifapi.mem.dto.OnlineMemSearchResDTO.OnlineMemInfo;
import com.davichmall.ifapi.mem.dto.PrescriptionUrlReqDTO;
import com.davichmall.ifapi.mem.dto.PrescriptionUrlResDTO;
import com.davichmall.ifapi.mem.dto.StoreEyesightInfoReqDTO;
import com.davichmall.ifapi.mem.dto.StoreEyesightInfoResDTO;
import com.davichmall.ifapi.mem.dto.StoreMemberJoinReqDTO;
import com.davichmall.ifapi.mem.dto.StoreMemberJoinResDTO;
import com.davichmall.ifapi.mem.dto.StoreVCResultReqDTO;
import com.davichmall.ifapi.mem.dto.StoreVCResultResDTO;
import com.davichmall.ifapi.mem.service.MemberService;

import net.sf.json.JSONObject;

/**
 * <pre>
 * - 프로젝트명    : davichmall_interface
 * - 패키지명      : com.davichmall.ifapi.mem.dto
 * - 파일명        : MemberController.java
 * - 작성일        : 2018. 5. 24.
 * - 작성자        : CBK
 * - 설명          : 회원 관련 인터페이스 처리를 위한 Controller
 * </pre>
 */
@Controller
public class MemberController extends BaseController {

	@Resource(name="memberService")
	MemberService memberService;

	/**
	 * <pre>
	 * 작성일 : 2018. 5. 24.
	 * 작성자 : CBK
	 * 설명   : 오프라인 회원 조회
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 5. 24. CBK - 최초생성
	 * </pre>
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/" + Constants.IFID.OFF_MEM_SEARCH)
	public @ResponseBody String searchOfflineMemInfo(OfflineMemSearchReqDTO param) throws Exception {

		String ifId = Constants.IFID.OFF_MEM_SEARCH;

		try {

			// 쇼핑몰 처리부분

			// ERP 쪽으로 데이터 전송
			String resParam = sendUtil.send(param, ifId);;

			// 로그 등록
			logService.writeInterfaceLog(ifId, param, resParam, OfflineMemSearchResDTO.class);

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
	 * 작성일 : 2018. 5. 25.
	 * 작성자 : CBK
	 * 설명   : 온라인 회원조회
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 5. 25. CBK - 최초생성
	 * </pre>
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/" + Constants.IFID.ON_MEM_SEARCH)
	public @ResponseBody String searchOnlineMemList(OnlineMemSearchReqDTO param) throws Exception {

		String ifId = Constants.IFID.ON_MEM_SEARCH;

		try {

			// 쇼핑몰 처리부분
			boolean paramChk =false;
			// ResponseDTO 생성
			OnlineMemSearchResDTO resDto = new OnlineMemSearchResDTO();
			resDto.setResult(Constants.RESULT.SUCCESS);
			resDto.setMessage("");

			// 조회
			//파라미터 정보가 맞지않으면 호출 불가
			if(param.getCustName()!=null && !param.getCustName().equals("")){
				paramChk = true;
			}
			if(param.getHp()!=null && !param.getHp().equals("")){
				paramChk = true;
			}
			if(param.getOnlineCardNo()!=null && !param.getOnlineCardNo().equals("")){
				paramChk = true;
			}
			if(param.getCombineYn()!=null && !param.getCombineYn().equals("")){
				paramChk = true;
			}

			if(param.getFullHp()!=null && !param.getFullHp().equals("")){
				paramChk = true;
			}

			List<OnlineMemInfo> memList = new ArrayList<>();
			if(paramChk) {
				memList = memberService.getOnlineMemberInfo(param);
			}
			resDto.setMemList(memList);

			// 처리 로그 등록
			logService.writeInterfaceLog(ifId, param, resDto);

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
	 * 작성일 : 2019. 2. 14.
	 * 작성자 : hskim
	 * 설명   : 온라인 회원조회
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 2. 14. hskim - 최초생성
	 * </pre>
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/" + Constants.IFID.ON_MEM_CARD_SEARCH)
	public @ResponseBody String searchOnlineMemCardList(OnlineMemSearchReqDTO param) throws Exception {

		String ifId = Constants.IFID.ON_MEM_CARD_SEARCH;

		try {

			// 쇼핑몰 처리부분
			boolean paramChk =false;
			// ResponseDTO 생성
			OnlineMemSearchResDTO resDto = new OnlineMemSearchResDTO();
			resDto.setResult(Constants.RESULT.SUCCESS);
			resDto.setMessage("");

			// 조회
			//파라미터 정보가 맞지않으면 호출 불가
			if(param.getOnlineCardNo()!=null && !param.getOnlineCardNo().equals("")){
				paramChk = true;
			}

			List<OnlineMemInfo> memList = new ArrayList<>();
			if(paramChk) {
				memList = memberService.getOnlineMemberCardInfo(param);
			}
			resDto.setMemList(memList);

			// 처리 로그 등록
			logService.writeInterfaceLog(ifId, param, resDto);

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
	 * 작성일 : 2018. 5. 25.
	 * 작성자 : CBK
	 * 설명   : 쇼핑몰에서 회원통합
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 5. 25. CBK - 최초생성
	 * </pre>
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/" + Constants.IFID.MEM_COMBINE_FROM_MALL)
	public @ResponseBody String combineMemberFromMall(MemberCombineReqDTO param) throws Exception {

		String ifId = Constants.IFID.MEM_COMBINE_FROM_MALL;

		try {
			// 쇼핑몰 처리부분

			// ERP 쪽으로 데이터 전송 및 매핑 테이블에 등록
			String resParam = memberService.insertMemberMapAndSend(param, ifId);;

			// 처리 로그 등록
			logService.writeInterfaceLog(ifId, param, resParam, MemberCombineResDTO.class);

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
	 * 작성일 : 2018. 5. 28.
	 * 작성자 : CBK
	 * 설명   : 다비젼에서 회원통합
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 5. 28. CBK - 최초생성
	 * </pre>
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/" + Constants.IFID.MEM_COMBINE_FROM_ERP)
	public @ResponseBody String combineMemberFromErp(MemberCombineReqDTO param) throws Exception {

		String ifId = Constants.IFID.MEM_COMBINE_FROM_ERP;

		try {

			// 쇼핑몰 처리부분

			// ResponseDTO 생성
			MemberCombineResDTO resDto = new MemberCombineResDTO();
			resDto.setResult(Constants.RESULT.SUCCESS);
			resDto.setMessage("");

			// 매핑 테이블에 저장 및 회원 통합 코드 변경
			memberService.combineMemberFromErp(param);

			// 처리 로그 등록
			logService.writeInterfaceLog(ifId, param, resDto);

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
	 * 작성일 : 2018. 5. 28.
	 * 작성자 : CBK
	 * 설명   : 쇼핑몰에서 회원 탈퇴
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 5. 28. CBK - 최초생성
	 * </pre>
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/" + Constants.IFID.MEM_SEPARATE_FROM_MALL)
	public @ResponseBody String exitMemberFromMall(MemberCombineReqDTO param) throws Exception {

		String ifId = Constants.IFID.MEM_SEPARATE_FROM_MALL;

		try {

			// 쇼핑몰 처리부분

			// 매핑 정보 제거 및 ERP테이블에서 통합 정보 제거(플래그변경)
			String resParam = memberService.deleteMemberMapAndSend(param, ifId);;

			// 처리 로그 등록
			logService.writeInterfaceLog(ifId, param, resParam, MemberCombineResDTO.class);

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
	 * 작성일 : 2018. 5. 28.
	 * 작성자 : CBK
	 * 설명   : ERP에서 회원탈퇴
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 5. 28. CBK - 최초생성
	 * </pre>
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/" + Constants.IFID.MEM_SEPARATE_FROM_ERP)
	public @ResponseBody String exitMemberFromErp(MemberCombineReqDTO param) throws Exception {

		String ifId = Constants.IFID.MEM_SEPARATE_FROM_ERP;

		try {

			// 쇼핑몰 처리부분

			// ResponseDTO 생성
			MemberCombineResDTO resDto = new MemberCombineResDTO();
			resDto.setResult(Constants.RESULT.SUCCESS);
			resDto.setMessage("");

			// 다비젼 회원코드를 쇼핑몰 회원코드로 변경
			String memNo = mappingService.getMallMemberNo(param.getCdCust());
			if(memNo == null) {
				// 통합회원이 아닙니다.
				throw new CustomException("ifapi.exception.member.notcombined");
			}
			param.setMemNo(memNo);

			// 회원 매핑 삭제 및 회원 통합정보 삭제
			memberService.deleteMemberCombineInfoFromMall(param);

			// 처리 로그 등록
			logService.writeInterfaceLog(ifId, param, resDto);

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
	 * 작성일 : 2018. 6. 21.
	 * 작성자 : CBK
	 * 설명   : 통합회원의 다비젼 등급을 조회 해서 쇼핑몰쪽(매핑테이블)에 갱신
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 6. 21. CBK - 최초생성
	 * 2019. 3. 14. KDY - 배치성능 저하이슈로인한 dblink 방식으로 변경
	 * </pre>
	 *
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/" + Constants.IFID.MEM_OFF_LVL)
	public @ResponseBody String updateErpMemLvlOnMall(BaseReqDTO param) throws Exception {

		String ifId = Constants.IFID.MEM_OFF_LVL;
		try {
			// 쇼핑몰 처리 부분
			/* 배치성능 저하이슈로인한 dblink 방식으로 변경*/
			//String resParam = sendUtil.send(null, ifId);
			// 응답 Json을 DTO형태로 변환
			//MemberOffLevelResDTO resDto = (MemberOffLevelResDTO) JSONObject.toBean(JSONObject.fromObject(resParam), MemberOffLevelResDTO.class);
			//if(Constants.RESULT.SUCCESS.equals(resDto.getResult())) {
				// 조회 결과가 성공이면 테이블에 갱신
			//	memberService.updateErpMemberLvl(resDto.getOffLevelList());
			//}

			MemberOffLevelResDTO resDto = new MemberOffLevelResDTO();
			resDto.setResult(Constants.RESULT.SUCCESS);
			resDto.setMessage("");

			memberService.updateErpMemberLvl();

			// 처리 로그 등록
			logService.writeInterfaceLog(ifId, param, resDto);

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
	 * 작성일 : 2018. 5. 29.
	 * 작성자 : CBK
	 * 설명   : 보유 포인트 조회
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 5. 29. CBK - 최초생성
	 * </pre>
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/" + Constants.IFID.MEM_OFF_POINT_SEARCH)
	public @ResponseBody String searchMemberOffPoint(OffPointSearchReqDTO param) throws Exception {

		String ifId = Constants.IFID.MEM_OFF_POINT_SEARCH;

		try {

			// 쇼핑몰 처리 부분
            if(param.getMemNo()!=null && !param.getMemNo().equals("")) {
                // ERP용 회원번호로 변경
                String cdCust = mappingService.getErpMemberNo(param.getMemNo());
                if (cdCust == null) {
                    // 통합회원이 아닙니다.
                    throw new CustomException("ifapi.exception.member.notcombined");
                }
                param.setCdCust(cdCust);

                // ERP로 전송
                String resParam = sendUtil.send(param, ifId);


                // 처리 로그 등록
                logService.writeInterfaceLog(ifId, param, resParam, OffPointSearchResDTO.class);
                return resParam;
            }else{
                    // 통합회원이 아닙니다.
                    throw new CustomException("ifapi.exception.member.notcombined");
            }

		} catch (CustomException ce) {
			ce.setReqParam(param);
			ce.setIfId(ifId);
			throw ce;
		} catch (Exception e) {
			throw new CustomException(e, param, ifId);
		}
	}

	/**
	 * <pre>
	 * 작성일 : 2018. 5. 29.
	 * 작성자 : CBK
	 * 설명   : 오프라인 포인트 증감내역 조회
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 5. 29. CBK - 최초생성
	 * </pre>
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/" + Constants.IFID.MEM_OFF_POINT_HISTORY_SEARCH)
	public @ResponseBody String searchMemberPointHistory(OffPointHistorySearchReqDTO param) throws Exception {

		String ifId = Constants.IFID.MEM_OFF_POINT_HISTORY_SEARCH;

		try {

			// 쇼핑몰 처리 부분

			// ERP용 회원번호로 변경
			String cdCust = mappingService.getErpMemberNo(param.getMemNo());
			if(cdCust == null) {
				// 통합회원이 아닙니다.
				throw new CustomException("ifapi.exception.member.notcombined");
			}
			param.setCdCust(cdCust);

			// ERP로 전송
			String resParam = sendUtil.send(param, ifId);;

			// 처리 로그 등록
			logService.writeInterfaceLog(ifId, param, resParam, OffPointHistorySearchResDTO.class);

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
	 * 작성일 : 2018. 6. 19.
	 * 작성자 : CBK
	 * 설명   : 매장 비젼체크 결과 조회
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 6. 19. CBK - 최초생성
	 * </pre>
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/" + Constants.IFID.STORE_VC_RESULT)
	public @ResponseBody String getStoreVisionCheck(StoreVCResultReqDTO param) throws Exception {

		String ifId = Constants.IFID.STORE_VC_RESULT;
		try {

			// 쇼핑몰 처리 부분

			// 쇼핑몰 회원번호를 다비젼 회원 번호로 변경
			String cdCust = mappingService.getErpMemberNo(param.getMemNo());
			if(cdCust == null) {
				// 통합회원이 아닙니다.
				throw new CustomException("ifapi.exception.member.notcombined");
			}
			param.setCdCust(cdCust);

			// ERP 쪽으로 데이터 전송
			String resParam = sendUtil.send(param, ifId);;

			// 처리 로그 등록
			logService.writeInterfaceLog(ifId, param, resParam, StoreVCResultResDTO.class);

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
	 * 작성일 : 2018. 7. 27.
	 * 작성자 : CBK
	 * 설명   : 쇼핑몰 비젼체크 결과 조회
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
	@RequestMapping(value="/" + Constants.IFID.MALL_VC_RESULT)
	public @ResponseBody String getMallVisionCheck(MallVCResultReqDTO param) throws Exception {
		String ifId = Constants.IFID.MALL_VC_RESULT;

		try {

			// 쇼핑몰 처리 부분
			// Response DTO 생성
			MallVCResultResDTO resDto = new MallVCResultResDTO();
			resDto.setResult(Constants.RESULT.SUCCESS);
			resDto.setMessage("");

			// ERP 회원코드를 쇼핑몰 회원번호로 변환
			String memNo = mappingService.getMallMemberNo(param.getCdCust());
			if(memNo == null) {
				// 통합회원이 아닙니다.
				throw new CustomException("ifapi.exception.member.notcombined");
			}
			param.setMemNo(memNo);

			// 비젼 체크 결과 및 추천 상품 조회
			List<MallVCResultDTO> resultList = memberService.getLatestMallVisionCheckList(param);

			resDto.setResultList(resultList);

			// 처리 로그 등록
			logService.writeInterfaceLog(ifId, param, resDto);

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
	 * 작성일 : 2018. 6. 20.
	 * 작성자 : CBK
	 * 설명   : 매장 시력 정보 조회
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 6. 20. CBK - 최초생성
	 * </pre>
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/" + Constants.IFID.STORE_EYESIGHT_INFO)
	public @ResponseBody String getStoreEyesightInfo(StoreEyesightInfoReqDTO param) throws Exception {

		String ifId = Constants.IFID.STORE_EYESIGHT_INFO;

		try {
			// 쇼핑몰 처리 부분

			// 쇼핑몰 회원번호를 다비젼 회원 번호로 변경
			String cdCust = mappingService.getErpMemberNo(param.getMemNo());
			if(cdCust == null) {
				// 통합회원이 아닙니다.
				throw new CustomException("ifapi.exception.member.notcombined");
			}
			param.setCdCust(cdCust);

			// ERP 쪽으로 데이터 전송
			String resParam = sendUtil.send(param, ifId);;

			// 처리 로그 등록
			logService.writeInterfaceLog(ifId, param, resParam, StoreEyesightInfoResDTO.class);

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
	 * 작성일 : 2018. 7. 3.
	 * 작성자 : CBK
	 * 설명   : 쇼핑몰 시력 정보 조회
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 7. 3. CBK - 최초생성
	 * </pre>
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/" + Constants.IFID.MALL_EYESIGHT_INFO)
	public @ResponseBody String getMallEyesightInfo(MallEyesightInfoReqDTO param) throws Exception {

		String ifId = Constants.IFID.MALL_EYESIGHT_INFO;

		try {

			// 쇼핑몰 처리 부분
			// ERP 회원번호를 쇼핑몰 회원 번호로 변경
			String memNo = mappingService.getMallMemberNo(param.getCdCust());
			if(memNo == null) {
				// 통합회원이 아닙니다.
				throw new CustomException("ifapi.exception.member.notcombined");
			}
			param.setMemNo(memNo);

			// 시력 데이터 조회
			MallEyesightInfoResDTO resDto = memberService.getLatestMallEyesightInfo(param);
			if(resDto == null) {
				// 데이터가 존재하지 않습니다.
				throw new CustomException("ifapi.exception.data.not.exist");
			}
			// 기본값 설정
			resDto.setResult(Constants.RESULT.SUCCESS);
			resDto.setMessage("");

			// 처리 로그 등록
			logService.writeInterfaceLog(ifId, param, resDto);

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
	 * 작성일 : 2018. 7. 10.
	 * 작성자 : CBK
	 * 설명   : 처방전 최근 1건의 이미지 URL 조회
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 7. 10. CBK - 최초생성
	 * </pre>
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/" + Constants.IFID.PRESCRIPTION_URL)
	public @ResponseBody String getLatestPrescriptionImageURL(PrescriptionUrlReqDTO param) throws Exception {

		String ifId = Constants.IFID.PRESCRIPTION_URL;

		try {

			// 쇼핑몰 처리 부분
			// Response DTO 생성
			PrescriptionUrlResDTO resDto = new PrescriptionUrlResDTO();
			resDto.setResult(Constants.RESULT.SUCCESS);
			resDto.setMessage("");

			// 다비젼 회원 번호를 쇼핑몰 회원 번호로 변환
			String memNo = mappingService.getMallMemberNo(param.getCdCust());
			if(memNo == null) {
				// 통합회원이 아닙니다.
				throw new CustomException("ifapi.exception.member.notcombined");
			}
			param.setMemNo(memNo);

			String prescriptionImgUrl = memberService.getLatestPrescriptionImageURL(param);
			// 데이터가 없으면 오류
			if(prescriptionImgUrl == null) {
				throw new CustomException("ifapi.exception.data.not.exist");
			}
			resDto.setImageUrl(prescriptionImgUrl);

			// 처리 로그 등록
			logService.writeInterfaceLog(ifId, param, resDto);

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
	 * 작성일 : 2018. 7. 16.
	 * 작성자 : CBK
	 * 설명   : 온라인 보유 포인트 조회
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 7. 16. CBK - 최초생성
	 * </pre>
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/" + Constants.IFID.MEM_ON_POINT_SEARCH)
	public @ResponseBody String searchMemberOnPoint(OnPointSearchReqDTO param) throws Exception {
		String ifId = Constants.IFID.MEM_ON_POINT_SEARCH;

		try {

			// 쇼핑몰 처리 부분
			// Response DTO 생성
			OnPointSearchResDTO resDto = new OnPointSearchResDTO();
			resDto.setResult(Constants.RESULT.SUCCESS);
			resDto.setMessage("");

			// ERP 회원 코드를 쇼핑몰 회원번호로 변환
			String memNo = mappingService.getMallMemberNo(param.getCdCust());
			if(memNo == null) {
				// 통합회원이 아닙니다.
				throw new CustomException("ifapi.exception.member.notcombined");
			}
			param.setMemNo(memNo);

			// 보유 포인트 조회
			int onPoint = memberService.getOnlinePoint(param);
			resDto.setMallPointAmt(onPoint);

			// 처리 로그 등록
			logService.writeInterfaceLog(ifId, param, resDto);

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
	 * 작성일 : 2018. 7. 16.
	 * 작성자 : CBK
	 * 설명   : 온라인 포인트 사용
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 7. 16. CBK - 최초생성
	 * </pre>
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/" + Constants.IFID.MEM_ON_POINT_USE)
	public @ResponseBody String useMemberOnlinePoint(OnPointUseReqDTO param) throws Exception {
		String ifId = Constants.IFID.MEM_ON_POINT_USE;
		try {

			// 쇼핑몰 처리 부분
			// Response DTO 생성
			OnPointUseResDTO resDto = new OnPointUseResDTO();
			resDto.setResult(Constants.RESULT.SUCCESS);
			resDto.setMessage("");

			// ERP 회원 코드를 쇼핑몰 회원번호로 변환
			String memNo = mappingService.getMallMemberNo(param.getCdCust());
			if(memNo == null) {
				// 통합회원이 아닙니다.
				throw new CustomException("ifapi.exception.member.notcombined");
			}
			param.setMemNo(memNo);

			// 보유 포인트 조회
			OnPointSearchReqDTO onPointSearchReqDTO = new OnPointSearchReqDTO();
			onPointSearchReqDTO.setMemNo(memNo);
			int onPoint = memberService.getOnlinePoint(onPointSearchReqDTO);
			if(onPoint < param.getUseMallPointAmt().intValue()) {
				// 보유 포인트가 부족합니다.
				throw new CustomException("ifapi.exception.onpoint.overuse");
			}

			// 포인트 사용 정보 등록
			memberService.useOnlinePoint(param);

			// 처리 로그 등록
			logService.writeInterfaceLog(ifId, param, resDto);

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
	 * 작성일 : 2018. 7. 16.
	 * 작성자 : CBK
	 * 설명   : 온라인 포인트 사용 취소
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 7. 16. CBK - 최초생성
	 * </pre>
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/" + Constants.IFID.MEM_ON_POINT_USE_CANCEL)
	public @ResponseBody String cancelMemberOnlinePointUse(OnPointUseCancelReqDTO param) throws Exception {
		String ifId = Constants.IFID.MEM_ON_POINT_USE_CANCEL;

		try {

			// 쇼핑몰 처리 부분
			// Response DTO 생성
			OnPointUseCancelResDTO resDto = new OnPointUseCancelResDTO();
			resDto.setResult(Constants.RESULT.SUCCESS);
			resDto.setMessage("");

			// ERP 회원 코드를 쇼핑몰 회원번호로 변환
			String memNo = mappingService.getMallMemberNo(param.getCdCust());
			if(memNo == null) {
				// 통합회원이 아닙니다.
				throw new CustomException("ifapi.exception.member.notcombined");
			}
			param.setMemNo(memNo);

			// 포인트 사용 취소 정보 등록
			memberService.cancelOnlinePointUse(param);

			// 처리 로그 등록
			logService.writeInterfaceLog(ifId, param, resDto);

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
	 * 작성일 : 2018. 7. 18.
	 * 작성자 : CBK
	 * 설명   : 오프라인 포인트 사용
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 7. 18. CBK - 최초생성
	 * </pre>
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/" + Constants.IFID.MEM_OFF_POINT_USE)
	public @ResponseBody String useMemberOfflinePoint(OffPointUseReqDTO param) throws Exception {
		String ifId = Constants.IFID.MEM_OFF_POINT_USE;

		try {
			// 쇼핑몰 처리 부분
			// 쇼핑몰 회원번호를 다비젼 회원 번호로 변환
			String cdCust = mappingService.getErpMemberNo(param.getMemNo());
			if(cdCust == null) {
				// 통합회원이 아닙니다.
				throw new CustomException("ifapi.exception.member.notcombined");
			}
			param.setCdCust(cdCust);

			// ERP 쪽으로 전송
			String resParam = sendUtil.send(param, ifId);

			// 처리 로그 등록
			logService.writeInterfaceLog(ifId, param, resParam, OffPointUseResDTO.class);

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
	 * 작성일 : 2018. 7. 18.
	 * 작성자 : CBK
	 * 설명   : 오프라인 포인트 사용 취소
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 7. 18. CBK - 최초생성
	 * </pre>
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/" + Constants.IFID.MEM_OFF_POINT_USE_CANCEL)
	public @ResponseBody String cancelMemberOfflinePointUse(OffPointUseCancelReqDTO param) throws Exception {
		String ifId = Constants.IFID.MEM_OFF_POINT_USE_CANCEL;

		try {

			// 쇼핑몰 처리 부분
			// 쇼핑몰 주문번호로 ERP 포인트 사용 번호 조회
			OffPointMapDTO mapSearchDto = new OffPointMapDTO();
			mapSearchDto.setMallOrderNo(param.getOrderNo());
			mapSearchDto.setMallOrderType(Constants.ORDER_MAP_ORDER_TYPE.ORDER);
			OffPointMapDTO pointMap = mappingService.getOfflinePointMapByMall(mapSearchDto);

			param.setOrgDates(pointMap.getErpDates());
			param.setOrgCdCust(pointMap.getErpMemberNo());
			param.setOrgSeqNo(pointMap.getErpSeqNoList());

			// ERP 쪽으로 전송
			String resParam = sendUtil.send(param, ifId);

			// 처리 로그 등록
			logService.writeInterfaceLog(ifId, param, resParam, OffPointUseCancelResDTO.class);

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
	 * 작성일 : 2018. 7. 24.
	 * 작성자 : CBK
	 * 설명   : 온라인 카드 발급시 오프라인 카드번호중에 중복되는 카드번호가 존재 하는지 여부 확인
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 7. 24. CBK - 최초생성
	 * </pre>
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/" + Constants.IFID.ON_CARD_NO_DUP_CHECK)
	public @ResponseBody String onlineCardNoDupCheckWithOfflineCardNo(OfflineCardNoDupCheckReqDTO param) throws Exception {
		String ifId = Constants.IFID.ON_CARD_NO_DUP_CHECK;

		try {

			// 쇼핑몰 처리 부분
			// ERP쪽으로 데이터 전송
			String resParam = sendUtil.send(param, ifId);

			// 처리 로그 등록
			logService.writeInterfaceLog(ifId, param, resParam, OfflineCardNoDupCheckResDTO.class);

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
	 * 작성일 : 2018. 9. 11.
	 * 작성자 : CBK
	 * 설명   : 매장에서 쇼핑몰 회원 가입
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 9. 11. CBK - 최초생성
	 * </pre>
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/" + Constants.IFID.MEMBER_JOIN_FROM_STORE)
	public @ResponseBody String memberJoinFromStore(StoreMemberJoinReqDTO param) throws Exception {
		String ifId = Constants.IFID.MEMBER_JOIN_FROM_STORE;

		try {
			// 쇼핑몰 처리 부분
			// Response DTO 생성
			StoreMemberJoinResDTO resDto = new StoreMemberJoinResDTO();
			resDto.setResult(Constants.RESULT.SUCCESS);
			resDto.setMessage("");

			// 회원 가입 처리
			String onlineCardNo = memberService.memberJoinFromStore(param);

			resDto.setOnlineCardNo(onlineCardNo);

			// 처리 로그 등록
			logService.writeInterfaceLog(ifId, param, resDto);

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
	 * 작성일 : 2018. 11. 28.
	 * 작성자 : dong
	 * 설명   : 앱로그인 일시 다비전 기록
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 11. 28. dong - 최초생성
	 * </pre>
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/" + Constants.IFID.MEMBER_LOGIN_DATE_FROM_APP)
	public @ResponseBody String memberLoginDateFromApp(AppMemberLoginReqDTO param) throws Exception {
		String ifId = Constants.IFID.MEMBER_LOGIN_DATE_FROM_APP;

		try {
			// 쇼핑몰 처리 부분.
			String resParam = "{message:'앱로그인 일시 업데이트 회원정보 없음',result:1}";
			// ERP회원번호 조회
			String cdCust = mappingService.getErpMemberNo(param.getMemNo());

			if(cdCust!=null && !cdCust.equals("")) {
				param.setCdCust(cdCust);
				// ERP쪽으로 데이터 전송
				resParam = sendUtil.send(param, ifId);
				// 처리 로그 등록
				logService.writeInterfaceLog(ifId, param, resParam, AppMemberLoginResDTO.class);
			}
			return resParam;

		} catch (CustomException ce) {
			ce.setReqParam(param);
			ce.setIfId(ifId);
			throw ce;
		} catch (Exception e) {
			throw new CustomException(e, param, ifId);
		}
	}
	
	

	/**
	 * <pre>
	 * 작성일 : 2018. 12. 10.
	 * 작성자 : khy
	 * 설명   : 연말정산내역조회
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 12. 10. khy - 최초생성
	 * </pre>
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/" + Constants.IFID.MEMBER_YEAR_END_TAX_LIST)
	public @ResponseBody String searchMemberYearEndTaxList(MemberYearEndTaxReqDTO param) throws Exception {

		String ifId = Constants.IFID.MEMBER_YEAR_END_TAX_LIST;

		try {

			// 쇼핑몰 처리 부분
			// ERP용 회원번호로 변경
			String cdCust = mappingService.getErpMemberNo(param.getMemNo());
			if(cdCust == null) {
				// 통합회원이 아닙니다.
				throw new CustomException("ifapi.exception.member.notcombined");
			}
			param.setCdCust(cdCust);

			// ERP로 전송
			String resParam = sendUtil.send(param, ifId);;

			// 처리 로그 등록
			logService.writeInterfaceLog(ifId, param, resParam, MemberYearEndTaxResDTO.class);

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
	 * 작성일 : 2018. 12. 10.
	 * 작성자 : khy
	 * 설명   : 연말정산내역조회 (PRINT)
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 12. 10. khy - 최초생성
	 * </pre>
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/" + Constants.IFID.MEMBER_YEAR_END_TAX_PRINT)
	public @ResponseBody String searchMemberYearEndTaxPrint(MemberYearEndTaxReqDTO param) throws Exception {

		String ifId = Constants.IFID.MEMBER_YEAR_END_TAX_PRINT;

		try {

			// 쇼핑몰 처리 부분
			// ERP용 회원번호로 변경
//			String cdCust = mappingService.getErpMemberNo(param.getMemNo());
//			if(cdCust == null) {
//				// 통합회원이 아닙니다.
//				throw new CustomException("ifapi.exception.member.notcombined");
//			}
//			param.setCdCust(cdCust);

			// ERP로 전송
			String resParam = sendUtil.send(param, ifId);;

			// 처리 로그 등록
			logService.writeInterfaceLog(ifId, param, resParam, MemberYearEndTaxResDTO.class);

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
	 * 작성일 : 2018. 12. 10.
	 * 작성자 : khy
	 * 설명   : 연말정산내역 자동신고
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 12. 10. khy - 최초생성
	 * </pre>
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/" + Constants.IFID.MEMBER_YEAR_END_TAX_AUTO)
	public @ResponseBody String updateMemberYearEndTaxAuto(MemberYearEndTaxReqDTO param) throws Exception {

		String ifId = Constants.IFID.MEMBER_YEAR_END_TAX_AUTO;

		try {

			// 쇼핑몰 처리 부분
			// ERP용 회원번호로 변경
			String cdCust = mappingService.getErpMemberNo(param.getMemNo());
			if(cdCust == null) {
				// 통합회원이 아닙니다.
				throw new CustomException("ifapi.exception.member.notcombined");
			}
			param.setCdCust(cdCust);

			// ERP로 전송
			String resParam = sendUtil.send(param, ifId);

			// 처리 로그 등록
			logService.writeInterfaceLog(ifId, param, resParam, MemberYearEndTaxResDTO.class);

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
	 * 작성일 : 2019. 1. 22.
	 * 작성자 : khy
	 * 설명   : 비콘내역조회
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2019. 1. 22. khy - 최초생성
	 * </pre>
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/" + Constants.IFID.BEACON_SEARCH)
	public @ResponseBody String searchBeaconData(BeaconDataReqDTO param) throws Exception {

		String ifId = Constants.IFID.BEACON_SEARCH;

		try {
			// ERP로 전송
			String resParam = sendUtil.send(param, ifId);;

			// 처리 로그 등록
			logService.writeInterfaceLog(ifId, param, resParam, BeaconDataResDTO.class);

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
