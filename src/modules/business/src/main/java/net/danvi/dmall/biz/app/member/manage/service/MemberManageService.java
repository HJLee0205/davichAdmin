package net.danvi.dmall.biz.app.member.manage.service;

import java.util.List;
import java.util.Map;

import dmall.framework.common.model.FileVO;
import dmall.framework.common.model.ResultListModel;
import dmall.framework.common.model.ResultModel;
import net.danvi.dmall.biz.app.member.manage.model.*;
import net.danvi.dmall.biz.app.operation.model.AtchFilePO;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 5. 3.
 * 작성자     : dong
 * 설명       : 회원 정보 관리 컴포넌트의 서비스 인터페이스
 * </pre>
 */
public interface MemberManageService {

    /**
     * <pre>
     * 작성일 : 2016. 5. 3.
     * 작성자 : dong
     * 설명   : 회원 리스트 조회
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 3. dong - 최초생성
     * </pre>
     *
     * @param memberManageSO
     * @return MemberManageVO
     */
    public ResultListModel<MemberManageVO> viewMemListPaging(MemberManageSO memberManageSO);

    /**
     * <pre>
     * 작성일 : 2016. 5. 3.
     * 작성자 : dong
     * 설명   : 회원 리스트 조회(엑셀 다운로드)
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 3. dong - 최초생성
     * </pre>
     *
     * @param memberManageSO
     * @return MemberManageVO
     */
    public List<MemberManageVO> viewMemListCommon(MemberManageSO memberManageSO);

    /**
     * <pre>
     * 작성일 : 2016. 5. 9.
     * 작성자 : dong
     * 설명   : 회원 탈퇴
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 9. dong - 최초생성
     * </pre>
     *
     * @param po
     * @return
     * @throws Exception
     */
    public ResultModel<MemberManagePO> deleteMem(MemberManagePO po) throws Exception;

    /**
     * <pre>
     * 작성일 : 2018. 8. 23.
     * 작성자 : hskim
     * 설명   : 사업자 회원 승인 처리
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2018. 8. 23. hskim - 최초생성
     * </pre>
     *
     * @param po
     * @return
     * @throws Exception
     */
    public ResultModel<MemberManagePO> confirmMemInfo(MemberManagePO po) throws Exception;
    
    /**
     * <pre>
     * 작성일 : 2016. 5. 9.
     * 작성자 : dong
     * 설명   : 회원 정보 수정
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 9. dong - 최초생성
     * </pre>
     *
     * @param po
     * @return
     * @throws Exception
     */
    public ResultModel<MemberManagePO> updateMemInfo(MemberManagePO po) throws Exception;

    /**
     * <pre>
     * 작성일 : 2016. 5. 9.
     * 작성자 : dong
     * 설명   : 회원정보 상세 조회(로그인정보, 활동정보 포함)
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 9. dong - 최초생성
     * </pre>
     *
     * @param memberManageSO
     * @return
     */
    public ResultModel<MemberManageVO> viewMemInfoDtl(MemberManageSO memberManageSO);

    /**
     * <pre>
     * 작성일 : 2016. 6. 1.
     * 작성자 : dong
     * 설명   : 회원정보 상세 조회
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 1. dong - 최초생성
     * </pre>
     *
     * @param memberManageSO
     * @return
     */
    public ResultModel<MemberManageVO> viewMemInfo(MemberManageSO memberManageSO);

    /**
     * <pre>
     * 작성일 : 2016. 5. 9.
     * 작성자 : dong
     * 설명   : 회원 최종 로그인 정보 조회
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 9. dong - 최초생성
     * </pre>
     *
     * @param memberManageSO
     * @return
     */
    public ResultModel<MemberManageVO> selectLastLoinInfo(MemberManageSO memberManageSO);

    /**
     * <pre>
     * 작성일 : 2016. 5. 9.
     * 작성자 : dong
     * 설명   : 최근 회원정보 수정일자 조회
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 9. dong - 최초생성
     * </pre>
     *
     * @param memberManageSO
     * @return
     */
    public ResultModel<MemberManageVO> selectLastUpdate(MemberManageSO memberManageSO);

    /**
     * <pre>
     * 작성일 : 2016. 5. 9.
     * 작성자 : dong
     * 설명   : 회원 포인트 조회
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 9. dong - 최초생성
     * </pre>
     *
     * @param memberManageSO
     * @return
     */
    public ResultModel<MemberManageVO> selectMemPoint(MemberManageSO memberManageSO);

    /**
     * <pre>
     * 작성일 : 2016. 5. 9.
     * 작성자 : dong
     * 설명   : 회원 마켓포인트 조회
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 9. dong - 최초생성
     * </pre>
     *
     * @param memberManageSO
     * @return
     */
    public ResultModel<MemberManageVO> selectMemSaveMn(MemberManageSO memberManageSO);

    /**
     * <pre>
     * 작성일 : 2016. 5. 9.
     * 작성자 : dong
     * 설명   : 회원이 보유한 쿠폰 갯수 조회
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 9. dong - 최초생성
     * </pre>
     *
     * @param memberManageSO
     * @return
     */
    public ResultModel<MemberManageVO> selectMemCpCnt(MemberManageSO memberManageSO);

    /**
     * <pre>
     * 작성일 : 2016. 5. 9.
     * 작성자 : dong
     * 설명   : 방문횟수 조회
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 9. dong - 최초생성
     * </pre>
     *
     * @param memberManageSO
     * @return
     */
    public ResultModel<MemberManageVO> selectVisitCnt(MemberManageSO memberManageSO);

    /**
     * <pre>
     * 작성일 : 2016. 5. 9.
     * 작성자 : dong
     * 설명   : 1:1 문의 등록 글 갯수 조회
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 9. dong - 최초생성
     * </pre>
     *
     * @param memberManageSO
     * @return
     */
    public ResultModel<MemberManageVO> selectInquirytCnt(MemberManageSO memberManageSO);

    /**
     * <pre>
     * 작성일 : 2016. 5. 9.
     * 작성자 : dong
     * 설명   : 상품문의 등록 글 갯수 조회
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 9. dong - 최초생성
     * </pre>
     *
     * @param memberManageSO
     * @return
     */
    public ResultModel<MemberManageVO> selectQuestionCnt(MemberManageSO memberManageSO);

    /**
     * <pre>
     * 작성일 : 2016. 5. 9.
     * 작성자 : dong
     * 설명   : 상품후기 등록 글 갯수 조회
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 9. dong - 최초생성
     * </pre>
     *
     * @param memberManageSO
     * @return
     */
    public ResultModel<MemberManageVO> selectReviewCnt(MemberManageSO memberManageSO);

    /**
     * <pre>
     * 작성일 : 2023. 5. 3.
     * 작성자 : truesol
     * 설명   : 회원 스탬프 조회
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2023. 5. 3. truesol - 최초생성
     * </pre>
     *
     * @param memberManageSO
     * @return
     */
    public ResultModel<MemberManageVO> selectMemStamp(MemberManageSO memberManageSO);

    /**
     * <pre>
     * 작성일 : 2016. 5. 9.
     * 작성자 : dong
     * 설명   : 자주쓰는 배송지 목록 조회
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 9. dong - 최초생성
     * </pre>
     *
     * @param memberManageSO
     * @return
     */
    public ResultListModel<MemberManageVO> selectDeliveryList(MemberManageSO memberManageSO);

    /**
     * <pre>
     * 작성일 : 2016. 5. 9.
     * 작성자 : dong
     * 설명   : 탈퇴회원 리스트 조회
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 9. dong - 최초생성
     * </pre>
     *
     * @param memberManageSO
     * @return
     */
    public ResultListModel<MemberManageVO> viewWithdrwMemPaging(MemberManageSO memberManageSO);

    /**
     * <pre>
     * 작성일 : 2016. 5. 9.
     * 작성자 : dong
     * 설명   : 탈퇴회원 상세 정보 조회
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 9. dong - 최초생성
     * </pre>
     *
     * @param memberManageSO
     * @return
     */
    public ResultModel<MemberManageVO> viewWithdrwMemDtl(MemberManageSO memberManageSO);

    /**
     * <pre>
     * 작성일 : 2016. 5. 9.
     * 작성자 : dong
     * 설명   : 휴면회원 리스트 조회
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 9. dong - 최초생성
     * </pre>
     *
     * @param memberManageSO
     * @return
     */
    public ResultListModel<MemberManageVO> viewDormantMemGetPaging(MemberManageSO memberManageSO);

    /**
     * <pre>
     * 작성일 : 2016. 5. 9.
     * 작성자 : dong
     * 설명   : 휴면회원 상세 정보 조회
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 9. dong - 최초생성
     * </pre>
     *
     * @param memberManageSO
     * @return
     */
    public ResultModel<MemberManageVO> viewDormantMemDtl(MemberManageSO memberManageSO);

    /**
     * <pre>
     * 작성일 : 2016. 5. 9.
     * 작성자 : dong
     * 설명   : 휴면회원 휴면 해제
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 9. dong - 최초생성
     * </pre>
     *
     * @param po
     * @return
     * @throws Exception
     */
    public ResultModel<MemberManagePO> updateDormantMem(MemberManagePO po) throws Exception;
    
    /**
     * <pre>
     * 작성일 : 2019. 08. 06.
     * 작성자 : hskim
     * 설명   : 휴면회원 휴면 해제
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2019. 08. 06. hskim - 최초생성
     * </pre>
     *
     * @param po
     * @return
     * @throws Exception
     */
    public ResultModel<MemberManagePO> updateWithdrawalMem(MemberManagePO po) throws Exception;

    /**
     * <pre>
     * 작성일 : 2016. 6. 2.
     * 작성자 : dong
     * 설명   : 쿠폰 목록 조회
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 2. dong - 최초생성
     * </pre>
     *
     * @param memberManageSO
     * @return
     */
    public ResultListModel<MemberManageVO> selectCouponGetPaging(MemberManageSO memberManageSO);

    /**
     * <pre>
     * 작성일 : 2016. 6. 2.
     * 작성자 : dong
     * 설명   : 쿠폰 갯수 조회
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 2. dong - 최초생성
     * </pre>
     *
     * @param memberManageSO
     * @return
     */
    public Integer selectCouponGetPagingCount(MemberManageSO memberManageSO);

    /**
     * <pre>
     * 작성일 : 2016. 7. 5.
     * 작성자 : dong
     * 설명   : 회원 리스트 조회
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 7. 5. dong - 최초생성
     * </pre>
     *
     * @param memberManageSO
     * @return MemberManageVO
     */
    public List<MemberManageVO> viewMemList(MemberManageSO memberManageSO);

    /**
     * <pre>
     * 작성일 : 2016. 8.11.
     * 작성자 : dong
     * 설명   : 슈퍼관리자 조회 
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 8. 11. dong - 최초생성
     * </pre>
     *
     * @return
     */
    public String selectAdmin(MemberManageSO memberManageSO);

    /**
     * <pre>
     * 작성일 : 2016. 8.22.
     * 작성자 : dong
     * 설명   : 처리 로그 조회
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 8. 22. dong - 최초생성
     * </pre>
     *
     * @return
     */
    public List<MemberManageVO> selectLog(MemberManageSO memberManageSO);

    /**
     * <pre>
     * 작성일 : 2016. 9. 29.
     * 작성자 : dong
     * 설명   : 비밀번호 다음에 변경하기 정보 업데이트
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 9. 29. dong - 최초생성
     * </pre>
     *
     * @param po
     * @return
     */
    public void updateChangePwNext(MemberManagePO po);

    /**
     * <pre>
     * 작성일 : 2016. 9. 29.
     * 작성자 : dong
     * 설명   : 080 수신거부 여부 업데이트 
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 9. 29. dong - 최초생성
     * </pre>
     *
     * @param po
     * @return
     */
    public void updateRecvRjtYnMemInfo(String[] memberTelnoTarget);

    /**
     * <pre>
     * 작성일 : 2016. 5. 31.
     * 작성자 : dong
     * 설명   : 파일 삭제를 하는 함수
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 31. dong - 최초생성
     * </pre>
     *
     * @param request
     * @param po
     * @return
     */
    ResultModel<AtchFilePO> deleteAtchFile(MemberManagePO po) throws Exception;

    /**
     * <pre>
     * 작성일 : 2016. 5. 31.
     * 작성자 : dong
     * 설명   : 파일 다운로드
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 31. dong - 최초생성
     * </pre>
     *
     * @param request
     * @param po
     * @return
     */
    public FileVO selectAtchFileDtl(MemberManagePO po) throws Exception;

    /**
     * <pre>
     * 작성일 : 2018. 7. 28.
     * 작성자 : hskim
     * 설명   : 회원 쿠폰 상세보기
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2018. 7. 28. hskim - 최초생성
     * </pre>
     *
     * @param po
     * @return
     * @throws Exception
     */
	ResultModel<MemberManageVO> selectMemCouponInfo(MemberManageSO so) throws Exception;
	
	
    /**
     * <pre>
     * 작성일 : 2018. 8. 9.
     * 작성자 : khy
     * 설명   : 회원 리스트 조회 (앱 푸시 대상조회)
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2018. 8. 9. khy - 최초생성
     * </pre>
     *
     * @param memberManageSO
     * @return MemberManageVO
     */
    public List<MemberManageVO> viewTotalPushList(MemberManageSO memberManageSO);
	
    /**
     * <pre>
     * 작성일 : 2018. 8. 9.
     * 작성자 : khy
     * 설명   : 검색 회원 리스트 조회 (앱 푸시 대상조회)
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2018. 8. 9. khy - 최초생성
     * </pre>
     *
     * @param memberManageSO
     * @return MemberManageVO
     */
    public ResultListModel<MemberManageVO> viewSearchPushListPaging(MemberManageSO memberManageSO);
    
    
    /**
     * <pre>
     * 작성일 : 2018. 8. 9.
     * 작성자 : khy
     * 설명   : 검색 회원 리스트 조회 (앱 푸시 대상조회)
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2018. 8. 9. khy - 최초생성
     * </pre>
     *
     * @param memberManageSO
     * @return MemberManageVO
     */
    public List<MemberManageVO> viewPushListCommon(MemberManageSO memberManageSO);

    
    
    /**
     * <pre>
     * 작성일 : 2018. 8. 9.
     * 작성자 : khy
     * 설명   : 검색 회원 리스트 조회 (앱 푸시 대상조회)
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2018. 8. 9. khy - 최초생성
     * </pre>
     *
     * @param memberManageSO
     * @return MemberManageVO
     */
    public List<MemberManageVO> viewPushListCommonByMap(Map<String,Object> map);

    /**
     * <pre>
     * 작성일 : 2018. 8. 31.
     * 작성자 : hskim
     * 설명   : 회원통합일시 조회
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2018. 8. 31. hskim - 최초생성
     * </pre>
     *
     * @param memberManageSO
     * @return string
     */
	public MemberManageVO selectIntegrationDttm(MemberManageSO so);

    /**
     * <pre>
     * 작성일 : 2022. 10. 24.
     * 작성자 : slims
     * 설명   : 얼굴정보 리스트 조회
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2022. 10. 24. slims - 최초생성
     * </pre>
     *
     * @param MemberFaceSO
     * @return MemberFaceVO
     */
    public List<MemberFaceVO> selectFaceList(MemberFaceSO so) throws Exception;

    /**
     * <pre>
     * 작성일 : 2022. 10. 28.
     * 작성자 : slims
     * 설명   : 얼굴정보 리스트 조회
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2022. 10. 28. slims - 최초생성
     * </pre>
     *
     * @param MemberFaceSO
     * @return MemberFaceVO
     */
    public List<MemberFaceVO> selectFaceInfoList(MemberFaceSO so) throws Exception;

    /**
     * <pre>
     * 작성일 : 2023. 2. 2.
     * 작성자 : truesol
     * 설명   : 닉네임 중복확인
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2023. 2. 2. truesol - 최초생성
     * </pre>
     *
     * @return
     * @throws Exception
     */
    public int checkDuplicationNickname(MemberManageVO so) throws Exception;

    public ResultListModel<MemberManageVO> selectStampList(MemberManageSO memberManageSO);

    public List<MemberManageVO> selectMemListBySend(MemberManageSO memberManageSO);
}
