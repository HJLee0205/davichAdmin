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
import com.davichmall.ifapi.mem.dto.AppMemberLoginReqDTO;
import com.davichmall.ifapi.mem.dto.AppMemberLoginResDTO;
import com.davichmall.ifapi.mem.dto.BeaconDataReqDTO;
import com.davichmall.ifapi.mem.dto.BeaconDataResDTO;
import com.davichmall.ifapi.mem.dto.MallEyesightInfoReqDTO;
import com.davichmall.ifapi.mem.dto.MallEyesightInfoResDTO;
import com.davichmall.ifapi.mem.dto.MallVCResultReqDTO;
import com.davichmall.ifapi.mem.dto.MallVCResultResDTO;
import com.davichmall.ifapi.mem.dto.MemberCombineReqDTO;
import com.davichmall.ifapi.mem.dto.MemberCombineResDTO;
import com.davichmall.ifapi.mem.dto.MemberOffLevelResDTO;
import com.davichmall.ifapi.mem.dto.MemberOffLevelResDTO.MemberOffLevelDTO;
import com.davichmall.ifapi.mem.dto.MemberYearEndTaxReqDTO;
import com.davichmall.ifapi.mem.dto.MemberYearEndTaxResDTO;
import com.davichmall.ifapi.mem.dto.MemberYearEndTaxResDTO.YearEndTaxInfo;
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
import com.davichmall.ifapi.mem.dto.OfflineMemSearchResDTO.OfflineMemInfo;
import com.davichmall.ifapi.mem.dto.OnPointSearchReqDTO;
import com.davichmall.ifapi.mem.dto.OnPointSearchResDTO;
import com.davichmall.ifapi.mem.dto.OnPointUseCancelReqDTO;
import com.davichmall.ifapi.mem.dto.OnPointUseCancelResDTO;
import com.davichmall.ifapi.mem.dto.OnPointUseReqDTO;
import com.davichmall.ifapi.mem.dto.OnPointUseResDTO;
import com.davichmall.ifapi.mem.dto.OnlineMemSearchReqDTO;
import com.davichmall.ifapi.mem.dto.OnlineMemSearchResDTO;
import com.davichmall.ifapi.mem.dto.PrescriptionUrlReqDTO;
import com.davichmall.ifapi.mem.dto.PrescriptionUrlResDTO;
import com.davichmall.ifapi.mem.dto.StoreEyesightInfoReqDTO;
import com.davichmall.ifapi.mem.dto.StoreEyesightInfoResDTO;
import com.davichmall.ifapi.mem.dto.StoreMemberJoinReqDTO;
import com.davichmall.ifapi.mem.dto.StoreMemberJoinResDTO;
import com.davichmall.ifapi.mem.dto.StoreVCResultReqDTO;
import com.davichmall.ifapi.mem.dto.StoreVCResultResDTO;
import com.davichmall.ifapi.mem.dto.StoreVCResultResDTO.VCRecoGoodsDTO;
import com.davichmall.ifapi.mem.dto.StoreVCResultResDTO.VCResultDTO;
import com.davichmall.ifapi.mem.service.MemberService;

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
			
			// ERP 처리부분 
			
			// ResponseDTO 생성
			OfflineMemSearchResDTO resDto = new OfflineMemSearchResDTO();
			resDto.setResult(Constants.RESULT.SUCCESS);
			resDto.setMessage("");
			boolean paramChk =false;

            //파라미터 정보가 맞지않으면 호출 불가
			if(param.getCustName()!=null && !param.getCustName().equals("") && param.getHp()!=null && !param.getHp().equals("")){
				paramChk = true;
			}

			// 조회
			List<OfflineMemInfo> custList = new ArrayList<>();
			if(paramChk) {
                custList = memberService.getOfflineMemberInfo(param);
            }

			// 정보 세팅
			resDto.setCustList(custList);
			
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

			// ERP 처리부분
			
			// 쇼핑몰 쪽으로 데이터 전송
			String resParam = sendUtil.send(param, ifId);
			
			// 로그 등록
			logService.writeInterfaceLog(ifId, param, resParam, OnlineMemSearchResDTO.class);
			
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

			// ERP 처리부분
			
			// 쇼핑몰 쪽으로 데이터 전송
			String resParam = sendUtil.send(param, ifId);
			
			// 로그 등록
			logService.writeInterfaceLog(ifId, param, resParam, OnlineMemSearchResDTO.class);
			
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

			// ERP처리부분

			// ResponseDTO 생성
			MemberCombineResDTO resDto = new MemberCombineResDTO();
			resDto.setResult(Constants.RESULT.SUCCESS);
			resDto.setMessage("");

			// 회원 테이블에 통합 정보 등록
			int updResult = memberService.insertMemberCombineInfoToErp(param);
			if(updResult < 1) {
				// 회원이 존재하지 않습니다.
				throw new CustomException("ifapi.exception.member.notexist");
			}
			
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
			
			// ERP 처리부분
			
			// 데이터 전송
			String resParam = sendUtil.send(param, ifId);
			
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
			
			
			// ERP 처리부분
			
			// ResponseDTO 생성
			MemberCombineResDTO resDto = new MemberCombineResDTO();
			resDto.setResult(Constants.RESULT.SUCCESS);
			resDto.setMessage("");
			
			int updResult = memberService.deleteMemberCombineInfoFromErp(param);
			if(updResult < 1) {
				// 회원이 존재하지 않습니다.
				throw new CustomException("ifapi.exception.member.notexist");
			}

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
			// ERP 처리부분
			
			// 데이터 전송
			String resParam = sendUtil.send(param, ifId);
			
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
	
	// 회원등급 수정은 추후에...
	// do_later

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
		/*try {
			// ERP 처리 부분
			// ResponseDTO 생성
			MemberOffLevelResDTO resDto = new MemberOffLevelResDTO();
			resDto.setResult(Constants.RESULT.SUCCESS);
			resDto.setMessage("");
			
			// 데이터 조회
			List<MemberOffLevelDTO> offLevelList = memberService.selectErpMemberLvl();
			resDto.setOffLevelList(offLevelList);
			
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
		}*/
		// ERP에서는 이 메소드를 사용하지 않음
		    return "";
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
			
			// ERP처리부분
			
			// ResponseDTO 생성
			OffPointSearchResDTO resDto = new OffPointSearchResDTO();
			resDto.setResult(Constants.RESULT.SUCCESS);
			resDto.setMessage("");
			
			// 보유 포인트 조회
			if(param.getCdCust()!=null && !param.getCdCust().equals("")) {
                int mtPoint = memberService.getOfflineAvailPoint(param);
                resDto.setMtPoint(mtPoint);

            }else{
                resDto.setMtPoint(0);
            }

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
			
			// ERP처리부분
			
			// ResponseDTO 생성
			OffPointHistorySearchResDTO resDto = new OffPointHistorySearchResDTO();
			resDto.setResult(Constants.RESULT.SUCCESS);
			resDto.setMessage("");
			
			// 내역 조회
			resDto.setDealList(memberService.getOfflinePointHistory(param));
			// 총 건수 조회
			resDto.setTotalCnt(memberService.countOfflinePointHistory(param));

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
			
			// ERP 처리 부분			
			// ResponseDTO 생성
			StoreVCResultResDTO resDto = new StoreVCResultResDTO();
			resDto.setResult(Constants.RESULT.SUCCESS);
			resDto.setMessage("");
			
			// 비젼체크 결과 조회
			List<VCResultDTO> resultList = memberService.getLatestStoreVisionCheckResultList(param);
			// 비젼체크 추천 상품 조회
			List<VCRecoGoodsDTO> recoGoodsList = memberService.getLatestStoreVisionCheckRecoPrdList(param);
			
			// 응답 DTO에 조회한 데이터 설정
			resDto.setResultList(resultList);
			resDto.setRecoGoodsList(recoGoodsList);
			
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
			
			// ERP 처리 부분
			// 쇼핑몰 쪽으로 데이터 전송
			String resParam = sendUtil.send(param, ifId);
			
			// 처리 로그 등록
			logService.writeInterfaceLog(ifId, param, resParam, MallVCResultResDTO.class);
			
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
			// ERP 처리 부분
			
			// 시력 데이터 조회
			StoreEyesightInfoResDTO resDto = memberService.getLatestStoreEyesightInfo(param);
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
			// ERP 처리 부분
			// 쇼핑몰로 데이터 전송
			String resParam = sendUtil.send(param, ifId);
			
			// 처리 로그 등록
			logService.writeInterfaceLog(ifId, param, resParam, MallEyesightInfoResDTO.class);
			
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
			
			// ERP 처리 부분
			// 쇼핑몰 쪽으로 데이터 전송
			String resParam = sendUtil.send(param, ifId);
			
			// 처리 로그 등록
			logService.writeInterfaceLog(ifId, param, resParam, PrescriptionUrlResDTO.class);
			
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
			
			// ERP 처리 부분
			// 쇼핑몰 쪽으로 데이터 전송
			String resParam = sendUtil.send(param, ifId);

			// 처리 로그 등록
			logService.writeInterfaceLog(ifId, param, resParam, OnPointSearchResDTO.class);
			
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
			// ERP 처리 부분
			// 쇼핑몰 쪽으로 데이터 전송
			String resParam = sendUtil.send(param, ifId);
			
			// 처리 로그 등록
			logService.writeInterfaceLog(ifId, param, resParam, OnPointUseResDTO.class);
			
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
			// ERP 처리 부분
			// 쇼핑몰 쪽으로 데이터 전송
			String resParam = sendUtil.send(param, ifId);
			
			// 처리 로그 등록
			logService.writeInterfaceLog(ifId, param, resParam, OnPointUseCancelResDTO.class);
			
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
			
			// ERP 처리 부분
			// Response DTO 생성
			OffPointUseResDTO resDto = new OffPointUseResDTO();
			resDto.setResult(Constants.RESULT.SUCCESS);
			resDto.setMessage("");
			
			// 데이터 저장
			List<String> seqNoList = memberService.useOfflinePoint(param);
			// Response에 순번 목록 설정
			resDto.setErpPointSeq(seqNoList);
			
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
			
			// ERP 처리 부분
			// ResponseDTO 생성
			OffPointUseCancelResDTO resDto = new OffPointUseCancelResDTO();
			resDto.setResult(Constants.RESULT.SUCCESS);
			resDto.setMessage("");
			
			// 데이터 저장
			List<String> seqNoList = memberService.cancelOfflinePointUse(param);
			
			resDto.setErpPointSeq(seqNoList);
			
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

			// ERP 처리 부분
			// Response DTO 생성
			OfflineCardNoDupCheckResDTO resDto = new OfflineCardNoDupCheckResDTO();
			resDto.setResult(Constants.RESULT.SUCCESS);
			resDto.setMessage("");
			
			// 중복 여부 확인
			String dupYn = memberService.onlineCardNoDupCheckWithOfflineCardNo(param);

			resDto.setDupYn(dupYn);

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
			
			// ERP 처리 부분
			// 쇼핑몰 쪽으로 데이터 전송
			String resParam = sendUtil.send(param, ifId);
			
			// 처리 로그 등록
			logService.writeInterfaceLog(ifId, param, resParam, StoreMemberJoinResDTO.class);
			
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
			// ERP 처리 부분
			// Response DTO 생성
			AppMemberLoginResDTO resDto = new AppMemberLoginResDTO();
			resDto.setResult(Constants.RESULT.SUCCESS);
			resDto.setMessage("");

			// 앱로그인 기록

			int updResult = memberService.updateMemberLoginDateFromApp(param);
			if(updResult < 1) {
				resDto.setResult(Constants.RESULT.SUCCESS);
				resDto.setMessage("앱로그인 일시 정보가 존재합니다.");
			}

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
	 * 작성일 : 2018. 12. 10.
	 * 작성자 : khy
	 * 설명   : 연말정산 조회
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
			// ERP 처리 부분
			MemberYearEndTaxResDTO resDto = new MemberYearEndTaxResDTO();

			List<YearEndTaxInfo> yearList = memberService.getMemberYearEndTaxList(param);
			
			resDto.setYearEndTaxList(yearList);
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
	 * 작성일 : 2018. 12. 11.
	 * 작성자 : khy
	 * 설명   : 연말정산조회 (PRINT)
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 12. 11. khy - 최초생성
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
			// ERP 처리 부분
			MemberYearEndTaxResDTO resDto = new MemberYearEndTaxResDTO();
			List<YearEndTaxInfo> yearList =  new ArrayList<>();

			String yyyy = param.getYyyy();
			if (!"".equals(yyyy) && yyyy != null) {
				yearList= memberService.getMemberYearEndTaxPrint(param);
			}
			
			resDto.setYearEndTaxList(yearList);
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

			// ERP 처리 부분
			// Response DTO 생성
			AppMemberLoginResDTO resDto = new AppMemberLoginResDTO();
			resDto.setResult(Constants.RESULT.SUCCESS);
			resDto.setMessage("");

			// 자동신고
			int updResult = memberService.updateMemberYearEndTaxAuto(param);
			
			if(updResult < 1) {
				resDto.setResult("");
				resDto.setMessage("내역이 존재하지 않습니다.");
			}			

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
	 * 작성일 : 2018. 12. 10.
	 * 작성자 : khy
	 * 설명   : 연말정산 조회
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
	@RequestMapping(value="/" + Constants.IFID.BEACON_SEARCH)
	public @ResponseBody String searchBeaconData(BeaconDataReqDTO param) throws Exception {
		
		String ifId = Constants.IFID.BEACON_SEARCH;
		
		try {
			// ERP 처리 부분
			BeaconDataResDTO resDto = new BeaconDataResDTO();

			resDto = memberService.searchBeacon(param);
			
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
	

}
