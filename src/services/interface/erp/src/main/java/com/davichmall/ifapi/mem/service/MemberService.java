package com.davichmall.ifapi.mem.service;

import java.util.List;

import com.davichmall.ifapi.mem.dto.AppMemberLoginReqDTO;
import com.davichmall.ifapi.mem.dto.BeaconDataReqDTO;
import com.davichmall.ifapi.mem.dto.BeaconDataResDTO;
import com.davichmall.ifapi.mem.dto.MallEyesightInfoReqDTO;
import com.davichmall.ifapi.mem.dto.MallEyesightInfoResDTO;
import com.davichmall.ifapi.mem.dto.MallVCResultReqDTO;
import com.davichmall.ifapi.mem.dto.MallVCResultResDTO.MallVCResultDTO;
import com.davichmall.ifapi.mem.dto.MemberCombineReqDTO;
import com.davichmall.ifapi.mem.dto.MemberOffLevelResDTO.MemberOffLevelDTO;
import com.davichmall.ifapi.mem.dto.MemberYearEndTaxReqDTO;
import com.davichmall.ifapi.mem.dto.MemberYearEndTaxResDTO.YearEndTaxInfo;
import com.davichmall.ifapi.mem.dto.OffPointHistorySearchReqDTO;
import com.davichmall.ifapi.mem.dto.OffPointHistorySearchResDTO.PointHistoryDTO;
import com.davichmall.ifapi.mem.dto.OffPointSearchReqDTO;
import com.davichmall.ifapi.mem.dto.OffPointUseCancelReqDTO;
import com.davichmall.ifapi.mem.dto.OffPointUseReqDTO;
import com.davichmall.ifapi.mem.dto.OfflineCardNoDupCheckReqDTO;
import com.davichmall.ifapi.mem.dto.OfflineMemSearchReqDTO;
import com.davichmall.ifapi.mem.dto.OfflineMemSearchResDTO.OfflineMemInfo;
import com.davichmall.ifapi.mem.dto.OnPointSearchReqDTO;
import com.davichmall.ifapi.mem.dto.OnPointUseCancelReqDTO;
import com.davichmall.ifapi.mem.dto.OnPointUseReqDTO;
import com.davichmall.ifapi.mem.dto.OnlineMemSearchReqDTO;
import com.davichmall.ifapi.mem.dto.OnlineMemSearchResDTO.OnlineMemInfo;
import com.davichmall.ifapi.mem.dto.PrescriptionUrlReqDTO;
import com.davichmall.ifapi.mem.dto.StoreEyesightInfoReqDTO;
import com.davichmall.ifapi.mem.dto.StoreEyesightInfoResDTO;
import com.davichmall.ifapi.mem.dto.StoreMemberJoinReqDTO;
import com.davichmall.ifapi.mem.dto.StoreVCResultReqDTO;
import com.davichmall.ifapi.mem.dto.StoreVCResultResDTO.VCRecoGoodsDTO;
import com.davichmall.ifapi.mem.dto.StoreVCResultResDTO.VCResultDTO;

/**
 * <pre>
 * - 프로젝트명    : davichmall_interface
 * - 패키지명      : com.davichmall.ifapi.mem.service
 * - 파일명        : MemberService.java
 * - 작성일        : 2018. 5. 24.
 * - 작성자        : CBK
 * - 설명          : 회원 관련 인터페이스 처리를 위한 Service
 * </pre>
 */
public interface MemberService {

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
	List<OfflineMemInfo> getOfflineMemberInfo(OfflineMemSearchReqDTO param) throws Exception;
	
	/**
	 * <pre>
	 * 작성일 : 2018. 5. 24.
	 * 작성자 : CBK
	 * 설명   : 온라인 회원 조회
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
	List<OnlineMemInfo> getOnlineMemberInfo(OnlineMemSearchReqDTO param) throws Exception;
	
	/**
	 * <pre>
	 * 작성일 : 2019. 2. 14.
	 * 작성자 : CBK
	 * 설명   : 온라인 회원 카드번호로 조회
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2019. 2. 14. hskim - 최초생성
	 * </pre>
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */
	List<OnlineMemInfo> getOnlineMemberCardInfo(OnlineMemSearchReqDTO param) throws Exception;
	
	/**
	 * <pre>
	 * 작성일 : 2018. 6. 15.
	 * 작성자 : CBK
	 * 설명   : 회원통합 매핑 정보 등록 및 ERP쪽으로 전송
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 6. 15. CBK - 최초생성
	 * </pre>
	 *
	 * @param param
	 * @param ifId
	 * @return
	 * @throws Exception
	 */
	String insertMemberMapAndSend(MemberCombineReqDTO param, String ifId) throws Exception;
	
	/**
	 * <pre>
	 * 작성일 : 2018. 5. 25.
	 * 작성자 : CBK
	 * 설명   : 회원 통합 정보 저장(ERP)
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 5. 25. CBK - 최초생성
	 * </pre>
	 *
	 * @param param
	 * @throws Exception
	 */
	int insertMemberCombineInfoToErp(MemberCombineReqDTO param) throws Exception;
	
	/**
	 * <pre>
	 * 작성일 : 2018. 9. 20.
	 * 작성자 : CBK
	 * 설명   : 다비젼에서 회원 통합
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 9. 20. CBK - 최초생성
	 * </pre>
	 *
	 * @param param
	 * @throws Exception
	 */
	void combineMemberFromErp(MemberCombineReqDTO param) throws Exception;
	
	/**
	 * <pre>
	 * 작성일 : 2018. 5. 28.
	 * 작성자 : CBK
	 * 설명   : 쇼핑몰-ERP 회원통합 매핑정보 삭제(플래그변경) 및 ERP쪽으로 데이터 전송(Transaction처리를 위해 Service에 Method로 구성)
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 5. 28. CBK - 최초생성
	 * </pre>
	 *
	 * @param param
	 * @param ifId
	 * @return
	 * @throws Exception
	 */
	String deleteMemberMapAndSend(MemberCombineReqDTO param, String ifId) throws Exception;
	
	/**
	 * <pre>
	 * 작성일 : 2018. 5. 28.
	 * 작성자 : CBK
	 * 설명   : 회원 통합 정보 삭제(ERP)
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
	int deleteMemberCombineInfoFromErp(MemberCombineReqDTO param) throws Exception;
	
	/**
	 * <pre>
	 * 작성일 : 2018. 9. 20.
	 * 작성자 : CBK
	 * 설명   : 회원통합 정보 삭제(쇼핑몰)
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 9. 20. CBK - 최초생성
	 * </pre>
	 *
	 * @param param
	 * @throws Exception
	 */
	void deleteMemberCombineInfoFromMall(MemberCombineReqDTO param) throws Exception;
	
	/**
	 * <pre>
	 * 작성일 : 2018. 6. 15.
	 * 작성자 : CBK
	 * 설명   : ERP 회원 등급 조회
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 6. 15. CBK - 최초생성
	 * 2019. 3. 14. KDY - 배치성능 저하이슈로인한 dblink 방식으로 변경
	 * </pre>
	 *
	 * @return
	 * @throws Exception
	 */
	List<MemberOffLevelDTO> selectErpMemberLvl() throws Exception;
	
	/**
	 * <pre>
	 * 작성일 : 2018. 6. 21.
	 * 작성자 : CBK
	 * 설명   : 쇼핑몰에 ERP회원 등급 갱신
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 6. 21. CBK - 최초생성
	 * </pre>
	 *
	 * @param param
	 * @throws Exception
	 */
	void updateErpMemberLvl(List<MemberOffLevelDTO> param) throws Exception;

	/**
	 * <pre>
	 * 작성일 : 2018. 5. 29.
	 * 작성자 : CBK
	 * 설명   : 오프라인 포인트 조회
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
	int getOfflineAvailPoint(OffPointSearchReqDTO param) throws Exception;
	
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
	List<PointHistoryDTO> getOfflinePointHistory(OffPointHistorySearchReqDTO param) throws Exception;
	
	/**
	 * <pre>
	 * 작성일 : 2018. 5. 29.
	 * 작성자 : CBK
	 * 설명   : 오프라인 포인트 증감내역 건수 조회
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
	int countOfflinePointHistory(OffPointHistorySearchReqDTO param) throws Exception;

	/**
	 * <pre>
	 * 작성일 : 2018. 6. 19.
	 * 작성자 : CBK
	 * 설명   : 매장 (최근 1건의)비젼체크 결과 조회
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
	List<VCResultDTO> getLatestStoreVisionCheckResultList(StoreVCResultReqDTO param) throws Exception;
	
	/**
	 * <pre>
	 * 작성일 : 2018. 6. 19.
	 * 작성자 : CBK
	 * 설명   : 매장 (최근 1건의)비젼체크 결과에 따른 추천상품 목록 조회
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
	List<VCRecoGoodsDTO> getLatestStoreVisionCheckRecoPrdList(StoreVCResultReqDTO param) throws Exception;
	
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
	List<MallVCResultDTO> getLatestMallVisionCheckList(MallVCResultReqDTO param) throws Exception;

	/**
	 * <pre>
	 * 작성일 : 2018. 6. 20.
	 * 작성자 : CBK
	 * 설명   : 매장 (최근 1건의)시력검사 결과 조회
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
	StoreEyesightInfoResDTO getLatestStoreEyesightInfo(StoreEyesightInfoReqDTO param) throws Exception;
	
	/**
	 * <pre>
	 * 작성일 : 2018. 7. 3.
	 * 작성자 : CBK
	 * 설명   : 쇼핑몰 (최근 1건의) 시력 정보 조회
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
	MallEyesightInfoResDTO getLatestMallEyesightInfo(MallEyesightInfoReqDTO param) throws Exception;
	
	/**
	 * <pre>
	 * 작성일 : 2018. 7. 10.
	 * 작성자 : CBK
	 * 설명   : 최근 1건의 처방전 이미지 URL 조회
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
	String getLatestPrescriptionImageURL(PrescriptionUrlReqDTO param) throws Exception;
	
	/**
	 * <pre>
	 * 작성일 : 2018. 7. 16.
	 * 작성자 : CBK
	 * 설명   : 온라인 포인트 조회
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
	Integer getOnlinePoint(OnPointSearchReqDTO param) throws Exception;
	
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
	 * @throws Exception
	 */
	void useOnlinePoint(OnPointUseReqDTO param) throws Exception;
	
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
	 * @throws Exception
	 */
	void cancelOnlinePointUse(OnPointUseCancelReqDTO param) throws Exception;

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
	List<String> useOfflinePoint(OffPointUseReqDTO param) throws Exception;

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
	List<String> cancelOfflinePointUse(OffPointUseCancelReqDTO param) throws Exception;
	
	/**
	 * <pre>
	 * 작성일 : 2018. 7. 24.
	 * 작성자 : CBK
	 * 설명   : 온라인 카드번호와 중복되는 오프라인 카드번호가 존재 하는지 확인
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 7. 24. CBK - 최초생성
	 * </pre>
	 *
	 * @param param
	 * @return Y:중복데이터 존재, N:중복데이터 미존재
	 * @throws Exception
	 */
	String onlineCardNoDupCheckWithOfflineCardNo(OfflineCardNoDupCheckReqDTO param) throws Exception;
	
	/**
	 * <pre>
	 * 작성일 : 2018. 9. 7.
	 * 작성자 : CBK
	 * 설명   : 매장에서 쇼핑몰 회원가입
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 9. 7. CBK - 최초생성
	 * </pre>
	 *
	 * @param param
	 * @return 온라인 회원카드 번호
	 * @throws Exception
	 */
	String memberJoinFromStore(StoreMemberJoinReqDTO param) throws Exception;

	/**
	 * <pre>
	 * 작성일 : 2018. 11. 28.
	 * 작성자 : dong
	 * 설명   : 앱로그인 일시 다비전 기록(ERP)
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 11. 28. dong - 최초생성
	 * </pre>
	 *
	 * @param param
	 * @throws Exception
	 */
	int updateMemberLoginDateFromApp(AppMemberLoginReqDTO param) throws Exception;
	
	
	/**
	 * <pre>
	 * 작성일 : 2018. 12. 10.
	 * 작성자 : khy
	 * 설명   : 쇼핑몰 연말정산 조회
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
	List<YearEndTaxInfo> getMemberYearEndTaxList(MemberYearEndTaxReqDTO param) throws Exception;
	
	
	/**
	 * <pre>
	 * 작성일 : 2018. 12. 10.
	 * 작성자 : khy
	 * 설명   : 쇼핑몰 연말정산 조회 (print)
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
	List<YearEndTaxInfo> getMemberYearEndTaxPrint(MemberYearEndTaxReqDTO param) throws Exception;
	
	

	/**
	 * <pre>
	 * 작성일 : 2018. 12. 10.
	 * 작성자 : khy
	 * 설명   : 쇼핑몰 연말정산 자동신고
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 12. 10. khy - 최초생성
	 * </pre>
	 *
	 * @param param
	 * @throws Exception
	 */
	int updateMemberYearEndTaxAuto(MemberYearEndTaxReqDTO param) throws Exception;
	
	
	
	/**
	 * <pre>
	 * 작성일 : 2019. 1. 22.
	 * 작성자 : khy
	 * 설명   : 매장 비콘 내역 조회
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
	BeaconDataResDTO searchBeacon(BeaconDataReqDTO param) throws Exception;	
	
	
}
