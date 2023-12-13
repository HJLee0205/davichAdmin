package com.davichmall.ifapi.mem.dao;

import java.util.List;
import java.util.Map;

import com.davichmall.ifapi.mem.dto.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.davichmall.ifapi.cmmn.base.BaseDAO;
import com.davichmall.ifapi.mem.dto.MallVCResultResDTO.MallVCResultDTO;
import com.davichmall.ifapi.mem.dto.MemberOffLevelResDTO.MemberOffLevelDTO;
import com.davichmall.ifapi.mem.dto.MemberYearEndTaxResDTO.YearEndTaxInfo;
import com.davichmall.ifapi.mem.dto.OffPointHistorySearchResDTO.PointHistoryDTO;
import com.davichmall.ifapi.mem.dto.OfflineMemSearchResDTO.OfflineMemInfo;
import com.davichmall.ifapi.mem.dto.OnlineMemSearchResDTO.OnlineMemInfo;
import com.davichmall.ifapi.mem.dto.StoreVCResultResDTO.VCRecoGoodsDTO;
import com.davichmall.ifapi.mem.dto.StoreVCResultResDTO.VCResultDTO;

import dmall.framework.common.dao.ProxyDao;

/**
 * <pre>
 * - 프로젝트명    : davichmall_interface
 * - 패키지명      : com.davichmall.ifapi.mem.dao
 * - 파일명        : MemberDAO.java
 * - 작성일        : 2018. 5. 24.
 * - 작성자        : CBK
 * - 설명          : 회원 관련 인터페이스 처리를 위한 DAO
 * </pre>
 */
@Repository("memberDao")
public class MemberDAO extends BaseDAO {

	// 쇼핑몰 암호화 데이터 조회시에 사용
	@Autowired
	ProxyDao proxyDao;
	
	/**
	 * <pre>
	 * 작성일 : 2018. 5. 24.
	 * 작성자 : CBK
	 * 설명   : 오프라인 회원 목록 조회
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
	public List<OfflineMemInfo> getOfflineMemberInfo(OfflineMemSearchReqDTO param) throws Exception {
		return sqlSession2.selectList("member.selectOfflineMemberList", param);
	}
	
	/**
	 * <pre>
	 * 작성일 : 2018. 5. 24.
	 * 작성자 : CBK
	 * 설명   : 온라인 회원 목록 조회
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
	public List<OnlineMemInfo> getOnlineMemberInfo(OnlineMemSearchReqDTO param) throws Exception {
		return proxyDao.selectList("member.selectOnlineMemberList", param);
	}
	
	/**
	 * <pre>
	 * 작성일 : 2019. 2.14.
	 * 작성자 : hskim
	 * 설명   : 온라인 회원 목록 카드번호로 조회
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2019. 2. 14. CBK - 최초생성
	 * </pre>
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public List<OnlineMemInfo> getOnlineMemberCardInfo(OnlineMemSearchReqDTO param) throws Exception {
		return proxyDao.selectList("member.selectOnlineMemberCardList", param);
	}
	
	/**
	 * <pre>
	 * 작성일 : 2018. 5. 25.
	 * 작성자 : CBK
	 * 설명   : 회원통합 정보 등록(ERP)
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 5. 25. CBK - 최초생성
	 * </pre>
	 *
	 * @param param
	 * @throws Exception
	 */
	public int insertMemberCombineInfoToErp(MemberCombineReqDTO param) throws Exception {
		return sqlSession2.update("member.insertMemberCombineInfo", param);
	}
	
	/**
	 * <pre>
	 * 작성일 : 2018. 9. 20.
	 * 작성자 : CBK
	 * 설명   : 쇼핑몰 회원의 회원통합구분코드 조회
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 9. 20. CBK - 최초생성
	 * </pre>
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public String selectCombineGbCd(MemberCombineReqDTO param) throws Exception {
		return sqlSession1.selectOne("member.selectCombineGbCd", param);
	}
	
	/**
	 * <pre>
	 * 작성일 : 2018. 9. 20.
	 * 작성자 : CBK
	 * 설명   : 쇼핑몰 회원 통합구분 코드 변경
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 9. 20. CBK - 최초생성
	 * </pre>
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public int updateMallMemberInfoCombine(MemberCombineReqDTO param) throws Exception {
		return sqlSession1.update("member.updateMallMemberInfoCombine", param);
	}
	
	/**
	 * <pre>
	 * 작성일 : 2018. 5. 28.
	 * 작성자 : CBK
	 * 설명   : 회원통합 정보 삭제(ERP)
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
	public int deleteMemberCombineInfoFromErp(MemberCombineReqDTO param) throws Exception {
		return sqlSession2.update("member.deleteMemberCombineInfo", param);
	}
	
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
	public List<MemberOffLevelDTO> selectErpMemberLvl() throws Exception {
		/*return sqlSession2.selectList("member.selectMemberLvlInfo");*/
		return null;
	}
	
	/**
	 * <pre>
	 * 작성일 : 2018. 6. 21.
	 * 작성자 : CBK
	 * 설명   : 쇼핑몰(매핑테이블)에 다비젼 회원등급을 갱신
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 6. 21. CBK - 최초생성
	 * 2019. 3. 14. KDY - 배치성능 저하이슈로인한 dblink 방식으로 변경
	 * </pre>
	 * @throws Exception
	 */
	public void updateMemberLvl() throws Exception {
		sqlSession1.update("member.updateMemberLvl");
	}
	
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
	public int getOfflineAvailPoint(OffPointSearchReqDTO param) throws Exception {
		return sqlSession2.selectOne("member.selectOfflineAvailPoint", param);
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
	public List<PointHistoryDTO> getOfflinePointHistory(OffPointHistorySearchReqDTO param) throws Exception {
		return sqlSession2.selectList("member.selectOfflinePointHistory", param);
	}
	
	/**
	 * <pre>
	 * 작성일 : 2018. 5. 29.
	 * 작성자 : CBK
	 * 설명   : 오프라인 포인트 증간내역 건수 조회
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
	public int countOfflinePointHistory(OffPointHistorySearchReqDTO param) throws Exception {
		return sqlSession2.selectOne("member.countOfflinePointHistory", param);
	}
	
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
	public List<VCResultDTO> getLatestStoreVisionCheckResultList(StoreVCResultReqDTO param) throws Exception {
		return sqlSession2.selectList("member.selectLatestStoreVisionCheck", param);
	}
	
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
	public List<VCRecoGoodsDTO> getLatestStoreVisionCheckRecoPrdList(StoreVCResultReqDTO param) throws Exception {
		return sqlSession2.selectList("member.selectLatestStoreVisionCheckRecoPrdList", param);
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
	public List<MallVCResultDTO> getLatestMallVisionCheckList(MallVCResultReqDTO param) throws Exception {
		return sqlSession1.selectList("member.selectLastestMallVisionCheck", param);
	}
	
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
	public StoreEyesightInfoResDTO getLatestStoreEyesightInfo(StoreEyesightInfoReqDTO param) throws Exception {
		return sqlSession2.selectOne("member.selectLatestStoreEyesightInfo", param);
	}
	
	/**
	 * <pre>
	 * 작성일 : 2018. 7. 3.
	 * 작성자 : CBK
	 * 설명   : 쇼핑몰(최근 1건의) 시력정보 조회
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
	public MallEyesightInfoResDTO getLatestMallEyesightInfo(MallEyesightInfoReqDTO param) throws Exception {
		return sqlSession1.selectOne("member.selectLatestMallEyesightInfo", param);
	}
	
	/**
	 * <pre>
	 * 작성일 : 2018. 7. 10.
	 * 작성자 : CBK
	 * 설명   : 처방전 최근 1건의 이미지 File ID 조회
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
	public String getLatestPrescriptionFileId(PrescriptionUrlReqDTO param) throws Exception {
		return sqlSession1.selectOne("member.selectPrescriptionFileId", param);
	}

	/**
	 * <pre>
	 * 작성일 : 2018. 7. 18.
	 * 작성자 : CBK
	 * 설명   : 오프라인 포인트 사용정보 등록을 위한 가맹점별 보유 포인트 조회
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 7. 18. CBK - 최초생성
	 * </pre>
	 *
	 * @param cdCust
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, Object>> getStorePointList(String cdCust) throws Exception {
		return sqlSession2.selectList("member.selectStorePointList", cdCust);
	}

	/**
	 * <pre>
	 * 작성일 : 2018. 7. 18.
	 * 작성자 : CBK
	 * 설명   : 포인트 로그 등록을 위한 trxn_no 조회
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
	public String getTrxnNo(OffPointUseDTO param) throws Exception {
		return sqlSession2.selectOne("member.getTrxnNo", param);
	}

	/**
	 * <pre>
	 * 작성일 : 2018. 7. 18.
	 * 작성자 : CBK
	 * 설명   : 오프라인 포인트 사용정보 등록
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 7. 18. CBK - 최초생성
	 * </pre>
	 *
	 * @param param
	 * @throws Exception
	 */
	public void insertOfflinePointUse(OffPointUseDTO param) throws Exception {
		sqlSession2.insert("member.insertOfflinePointUse", param);
	}

	/**
	 * <pre>
	 * 작성일 : 2018. 7. 18.
	 * 작성자 : CBK
	 * 설명   : 오프라인 포인트 사용 취소 등록을 위한 사용정보 목록 조회
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
	public List<OffPointUseDTO> getOfflinPointUseList(OffPointUseCancelReqDTO param) throws Exception {
		return sqlSession2.selectList("member.selectOfflinPointUseList", param);
	}
	
	/**
	 * <pre>
	 * 작성일 : 2018. 7. 24.
	 * 작성자 : CBK
	 * 설명   : 오프라인 카드 번호 중에 온라인 카드번호와 중복된 데이터 개수
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
	public int countDupOfflineCardNo(OfflineCardNoDupCheckReqDTO param) throws Exception {
		return sqlSession2.selectOne("member.countDupOfflineCardNo", param);
	}
	
	/**
	 * <pre>
	 * 작성일 : 2018. 9. 7.
	 * 작성자 : CBK
	 * 설명   : 쇼핑몰 회원 테이블에 매장에서 가입 여부를 Y로 설정
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 9. 7. CBK - 최초생성
	 * </pre>
	 *
	 * @param memberNo
	 * @throws Exception
	 */
	public void setStoreJoinYnToY(String memberNo) throws Exception {
		proxyDao.update("member.updateStoreJoinYnToY", memberNo);
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
	 * @throws Exception
	 */
	public int updateMemberLoginDateFromApp(AppMemberLoginReqDTO param) throws Exception {
		return sqlSession2.update("member.updateMemberLoginDateFromApp", param);
	}
	
	
	
	/**
	 * <pre>
	 * 작성일 : 2018. 12. 10.
	 * 작성자 : khy
	 * 설명   : 연말정산 조회 LIST
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
	public List<YearEndTaxInfo> getYearEndTaxList(MemberYearEndTaxReqDTO param) throws Exception {
		return sqlSession2.selectList("member.selectYearEndTaxList", param);
	}
	
	
	/**
	 * <pre>
	 * 작성일 : 2018. 12. 10.
	 * 작성자 : khy
	 * 설명   : 연말정산 출력 조회
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
	public List<YearEndTaxInfo> getYearEndTaxPrint(MemberYearEndTaxReqDTO param) throws Exception {
		return sqlSession2.selectList("member.selectYearEndTaxPrint", param);
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
	 * @throws Exception
	 */
//	public int updateMemberYearEndTaxAuto(MemberYearEndTaxReqDTO param) throws Exception {
//		return sqlSession2.update("member.updateMemberYearEndTaxAuto", param);
//	}
	
}
