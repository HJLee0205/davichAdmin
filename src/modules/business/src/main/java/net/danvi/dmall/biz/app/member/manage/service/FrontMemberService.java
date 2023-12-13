package net.danvi.dmall.biz.app.member.manage.service;

import java.util.List;

import dmall.framework.common.exception.CustomException;
import dmall.framework.common.model.ResultListModel;
import dmall.framework.common.model.ResultModel;
import net.danvi.dmall.biz.app.member.manage.model.MemberDeliveryPO;
import net.danvi.dmall.biz.app.member.manage.model.MemberDeliverySO;
import net.danvi.dmall.biz.app.member.manage.model.MemberDeliveryVO;
import net.danvi.dmall.biz.app.member.manage.model.MemberManagePO;
import net.danvi.dmall.biz.app.member.manage.model.MemberManageSO;
import net.danvi.dmall.biz.app.member.manage.model.MemberManageVO;
import net.danvi.dmall.biz.app.member.manage.model.RefundAccountPO;
import net.danvi.dmall.biz.app.member.manage.model.RefundAccountSO;
import net.danvi.dmall.biz.app.member.manage.model.RefundAccountVO;
import net.danvi.dmall.biz.app.operation.model.SavedmnPointSO;
import net.danvi.dmall.biz.app.operation.model.SavedmnPointVO;
import net.danvi.dmall.biz.app.setup.personcertify.model.PersonCertifyConfigVO;
import net.danvi.dmall.biz.system.model.AppLogPO;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 5. 9.
 * 작성자     : dong
 * 설명       :
 * </pre>
 */
public interface FrontMemberService {

    /**
     * <pre>
     * 작성일 : 2016. 6. 20.
     * 작성자 : dong
     * 설명   : 회원정보 조회서비스
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 20. dong - 최초생성
     * </pre>
     *
     * @param so
     * @return
     */
    public ResultModel<MemberManageVO> selectMember(MemberManageSO so);

    /**
     * <pre>
     * 작성일 : 2016. 6. 20.
     * 작성자 : dong
     * 설명   : 회원등록 서비스
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 20. dong - 최초생성
     * </pre>
     *
     * @param MemberManagePO po
     * @return
     */
    public ResultModel<MemberManagePO> insertMember(MemberManagePO po) throws Exception;

    /**
     * <pre>
     * 작성일 : 2016. 6. 20.
     * 작성자 : dong
     * 설명   : 회원정보 변경서비스
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 20. dong - 최초생성
     * </pre>
     *
     * @param MemberManagePO po
     * @return
     */
    public ResultModel<MemberManagePO> updateMember(MemberManagePO po) throws Exception;

    /**
     * <pre>
     * 작성일 : 2016. 6. 20.
     * 작성자 : dong
     * 설명   : 본인인증서비스
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 20. dong - 최초생성
     * </pre>
     *
     * @param MemberManagePO po
     * @return
     */
    public ResultModel<MemberManagePO> successIdentity(MemberManagePO po) throws Exception;

    /**
     * <pre>
     * 작성일 : 2016. 6. 20.
     * 작성자 : dong
     * 설명   : 회원탈퇴 서비스
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 20. dong - 최초생성
     * </pre>
     *
     * @param MemberManagePO po
     * @return
     */
    public ResultModel<MemberManagePO> deleteMember(MemberManagePO po) throws Exception;

    /**
     * <pre>
     * 작성일 : 2016. 6. 20.
     * 작성자 : dong
     * 설명   : 휴면회원해제 서비스
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 20. dong - 최초생성
     * </pre>
     *
     * @param MemberManagePO po
     * @return
     */
    public ResultModel<MemberManagePO> updateDormantMem(MemberManagePO po) throws Exception;
    
    /**
     * <pre>
     * 작성일 : 2019. 08. 06.
     * 작성자 : hskim
     * 설명   : 탈퇴회원해제 서비스
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2019. 08. 06. hskim - 최초생성
     * </pre>
     *
     * @param MemberManagePO po
     * @return
     */
    public ResultModel<MemberManagePO> updateWithdrawalMem(MemberManagePO po) throws Exception;

    /**
     * <pre>
     * 작성일 : 2016. 6. 20.
     * 작성자 : dong
     * 설명   : 회원배송지 조회서비스
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 20. dong - 최초생성
     * </pre>
     *
     * @param MemberDeliverySO so
     * @return
     */
    public ResultListModel<MemberDeliveryVO> selectDeliveryListPaging(MemberDeliverySO so);

    /**
     * <pre>
     * 작성일 : 2016. 6. 20.
     * 작성자 : dong
     * 설명   : 최근 배송지 조회
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 20. dong - 최초생성
     * </pre>
     *
     * @param MemberDeliverySO so
     * @return
     */
    public ResultModel<MemberDeliveryVO> selectRecentlyDeliveryInfo(MemberDeliverySO so) throws Exception;

    /**
     * <pre>
     * 작성일 : 2016. 6. 20.
     * 작성자 : dong
     * 설명   : 회원배송지 상세조회 조회서비스
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 20. dong - 최초생성
     * </pre>
     *
     * @param MemberDeliverySO so
     * @return
     */
    public ResultModel<MemberDeliveryVO> selectDeliveryDtl(MemberDeliverySO so);

    /**
     * <pre>
     * 작성일 : 2016. 6. 20.
     * 작성자 : dong
     * 설명   : 회원배송지 등록서비스
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 20. dong - 최초생성
     * </pre>
     *
     * @param MemberDeliveryPO po
     * @return
     */
    public ResultModel<MemberDeliveryPO> insertDelivery(MemberDeliveryPO po) throws Exception;

    /**
     * <pre>
     * 작성일 : 2016. 6. 20.
     * 작성자 : dong
     * 설명   : 회원배송지 변경서비스
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 20. dong - 최초생성
     * </pre>
     *
     * @param MemberDeliveryPO po
     * @return
     */
    public ResultModel<MemberDeliveryPO> updateDelivery(MemberDeliveryPO po) throws Exception;

    /**
     * <pre>
     * 작성일 : 2016. 6. 20.
     * 작성자 : dong
     * 설명   : 회원배송지 삭제서비스
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 20. dong - 최초생성
     * </pre>
     *
     * @param MemberDeliveryPO po
     * @return
     */
    public ResultModel<MemberDeliveryPO> deleteDelivery(MemberDeliveryPO po) throws Exception;

    /**
     * <pre>
     * 작성일 : 2016. 6. 20.
     * 작성자 : dong
     * 설명   : 환불계좌 조회서비스
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 20. dong - 최초생성
     * </pre>
     *
     * @param RefundAccountSO so
     * @return
     */
    public ResultModel<RefundAccountVO> selectRefundAccount(RefundAccountSO so) throws Exception;

    /**
     * <pre>
     * 작성일 : 2016. 6. 20.
     * 작성자 : dong
     * 설명   : 환불계좌 등록서비스
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 20. dong - 최초생성
     * </pre>
     *
     * @param RefundAccountPO po
     * @return
     */
    public ResultModel<RefundAccountPO> insertRefundAccount(RefundAccountPO po) throws Exception;

    /**
     * <pre>
     * 작성일 : 2016. 6. 20.
     * 작성자 : dong
     * 설명   : 환불계좌 변경서비스
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 20. dong - 최초생성
     * </pre>
     *
     * @param RefundAccountPO po
     * @return
     */
    public ResultModel<RefundAccountPO> updateRefundAccount(RefundAccountPO po) throws Exception;

    /**
     * <pre>
     * 작성일 : 2016. 6. 20.
     * 작성자 : dong
     * 설명   : 환불계좌 삭제서비스
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 20. dong - 최초생성
     * </pre>
     *
     * @param RefundAccountPO po
     * @return
     */
    public ResultModel<RefundAccountPO> deleteRefundAccount(RefundAccountPO po) throws Exception;

    /**
     * <pre>
     * 작성일 : 2016. 6. 20.
     * 작성자 : dong
     * 설명   : 아이디 찾기 서비스
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 20. dong - 최초생성
     * </pre>
     *
     * @param MemberManageSO so
     * @return
     */
    public List<MemberManageVO> selectMemeberId(MemberManageSO so) throws Exception;

    /**
     * <pre>
     * 작성일 : 2016. 6. 20.
     * 작성자 : dong
     * 설명   : 휴면회원 계정 정보 조회
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 20. dong - 최초생성
     * </pre>
     *
     * @param MemberManageSO so
     * @return
     */
    public List<MemberManageVO> selectInactiveMember(MemberManageSO so) throws Exception;

    public List<MemberManageVO> selectInactiveMemberById(MemberManageSO so) throws Exception;

    /**
     * <pre>
     * 작성일 : 2016. 6. 20.
     * 작성자 : dong
     * 설명   : 인증수단목록조회
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 20. dong - 최초생성
     * </pre>
     *
     * @param MemberManageSO so
     * @return
     */
    public List<PersonCertifyConfigVO> selectCertifyList(MemberManageSO so) throws Exception;

    /**
     * <pre>
     * 작성일 : 2016. 6. 20.
     * 작성자 : dong
     * 설명   : 비밀번호 변경 서비스
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 20. dong - 최초생성
     * </pre>
     *
     * @param MemberManagePO po
     * @return
     */
    public ResultModel<MemberManagePO> updatePwd(MemberManagePO po) throws Exception;

    /**  **/
    /**
     * <pre>
     * 작성일 : 2016. 6. 20.
     * 작성자 : dong
     * 설명   : 이메일 인증 서비스
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 20. dong - 최초생성
     * </pre>
     *
     * @param MemberManageSO so
     * @return
     */
    public ResultModel<MemberManageVO> checkEmailCertify(MemberManageSO so) throws Exception;

    /**
     * <pre>
     * 작성일 : 2016. 6. 20.
     * 작성자 : dong
     * 설명   : 15일이내 소멸 마켓포인트 조회 서비스
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 20. dong - 최초생성
     * </pre>
     *
     * @param SavedmnPointSO so
     * @return
     */
    public ResultModel<SavedmnPointVO> selectExtinctionSavedMn(SavedmnPointSO so) throws Exception;

    /**
     * <pre>
     * 작성일 : 2016. 6. 20.
     * 작성자 : dong
     * 설명   : 15일이내 소멸 포인트 조회 서비스
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 20. dong - 최초생성
     * </pre>
     *
     * @param SavedmnPointSO so
     * @return
     */
    public ResultModel<SavedmnPointVO> selectExtinctionPoint(SavedmnPointSO so) throws Exception;
    
    /**
     * <pre>
     * 작성일 : 2016. 6. 20.
     * 작성자 : dong
     * 설명   : 아이디 중복 확인 서비스
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 20. dong - 최초생성
     * </pre>
     *
     * @param MemberManageSO so
     * @return
     */
    public int checkDuplicationId(MemberManageSO so) throws Exception;
    
    /**
     * <pre>
     * 작성일 : 2019. 4. 26.
     * 작성자 : hskim
     * 설명   : 휴대전화 중복 확인 서비스
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2019. 4. 26. hskim - 최초생성
     * </pre>
     *
     * @param MemberManagePO po
     * @return
     */
    public int checkDuplicationMobile(MemberManagePO po) throws Exception;
    
    /**
     * <pre>
     * 작성일 : 2018. 11. 02.
     * 작성자 : hskim
     * 설명   : 아이디 중복 확인 서비스
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2018. 11. 02. hskim - 최초생성
     * </pre>
     *
     * @param MemberManageSO so
     * @return
     */
    public List<MemberManageVO> checkDuplicationMem(MemberManageSO so) throws Exception;

    /**
     * <pre>
     * 작성일 : 2016. 6. 20.
     * 작성자 : dong
     * 설명   : 사업자번호 중복 확인 서비스
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 20. dong - 최초생성
     * </pre>
     *
     * @param MemberManageSO so
     * @return
     */
    public int checkDuplicationBizNo(MemberManageSO so) throws Exception;

    /**
     * <pre>
     * 작성일 : 2016. 6. 20.
     * 작성자 : dong
     * 설명   : 휴면회원 복구시 DI 값으로 회원정보 조회
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 20. dong - 최초생성
     * </pre>
     *
     * @param MemberManageSO so
     * @return
     */
    public MemberManageVO selectDormantMemberNo(MemberManageSO so);
    
    /**
     * <pre>
     * 작성일 : 2019. 08. 06.
     * 작성자 : hskim
     * 설명   : 탈퇴회원 복구시 DI 값으로 회원정보 조회
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2019. 08. 06. hskim - 최초생성
     * </pre>
     *
     * @param MemberManageSO so
     * @return
     */
    public MemberManageVO selectWithdrawalMemberNo(MemberManageSO so);

    /**
     * <pre>
     * 작성일 : 2016. 6. 20.
     * 작성자 : dong
     * 설명   : 회원가입 이메일인증 키 저장
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 20. dong - 최초생성
     * </pre>
     *
     * @param MemberManagePO po
     * @return
     */
    public ResultModel<MemberManagePO> createAuthKey(MemberManagePO po) throws Exception;

    /**
     * <pre>
     * 작성일 : 2016. 6. 20.
     * 작성자 : dong
     * 설명   : 이메일 인증 키 가져오기
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 20. dong - 최초생성
     * </pre>
     *
     * @param MemberManageSO so
     * @return
     */
    ResultModel<MemberManageVO> selectEmailAuthKey(MemberManageSO so) throws Exception;

    /**
     * <pre>
     * 작성일 : 2016. 6. 20.
     * 작성자 : dong
     * 설명   : 이메일 인증 키 삭제
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 20. dong - 최초생성
     * </pre>
     *
     * @param MemberManageSO so
     * @return
     */
    int deleteEmailAuthKey(MemberManageSO so) throws Exception;

    
    /**
     * <pre>
     * 작성일 : 2017. 7. 24.
     * 작성자 : khy
     * 설명   : 단골매장 저장
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 20. dong - 최초생성
     * </pre>
     *
     * @param MemberManagePO po
     * @return
     */
    public int updateCustomStore(MemberManagePO po) throws Exception; 
    
    
    /**
     * <pre>
     * 작성일 : 2018. 7. 24.
     * 작성자 : dong
     * 설명   : 회원 통합회원구분코드 변경
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2018. 7. 24. hskim - 최초생성
     * </pre>
     *
     * @param MemberManagePO po
     * @return
     */
	public ResultModel<MemberManagePO> updateMemberIntegration(MemberManagePO po) throws Exception;

	/**
     * <pre>
     * 작성일 : 2018. 8. 17.
     * 작성자 : hskim
     * 설명   : 추천인 아이디 체크
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2018. 8. 17. hskim - 최초생성
     * </pre>
     *
     * @param MemberManageSO so
     * @return
     */
	public String checkRecomMemberId(MemberManageSO so) throws Exception;
	
	
	
    /**
     * <pre>
     * 작성일 : 2018. 8. 24.
     * 작성자 : khy
     * 설명   : 회원정보 수정 (토큰,자동로그인,위치정보동의,알림구분)
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2018. 7. 24. khy - 최초생성
     * </pre>
     *
     * @param MemberManagePO po
     * @return
     */
	public ResultModel<MemberManagePO> updateAppInfoCollect(MemberManagePO po) throws Exception;
	
    public AppLogPO selectAppLoginInfo(AppLogPO po) throws CustomException;

	public int insertAppLoginInfo(AppLogPO po) throws Exception;
	
	public int updateAppLoginInfo(AppLogPO po) throws Exception;
	
	public int deleteAppLoginInfo(AppLogPO po) throws Exception;
	
	MemberManagePO selectAppInfo(MemberManageSO so) throws Exception;

	public void updateAppFirstLogin(MemberManagePO po) throws Exception;
	
	public void updateAppPushAgree(MemberManagePO po) throws Exception;

	public void updateTermsApply(MemberManagePO po) throws Exception;
	
	/**
     * <pre>
     * 작성일 : 2019. 4. 24.
     * 작성자 : hskim
     * 설명   : 휴대폰인증 완료처리 
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2019. 4. 24. dong - 최초생성
     * </pre>
     *
     * @param MemberManagePO po
     * @return
     */
    public ResultModel<MemberManagePO> updateCertify(MemberManagePO po) throws Exception;

    /**
     * <pre>
     * 작성일 : 2018. 8. 13.
     * 작성자 : khy
     * 설명   : push 발송내역을 조회한다. (가맹점)
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2018. 8. 13. khy - 최초생성
     * </pre>
     *
     * @param so
     * @return
     */
    public ResultListModel<MemberManageVO> selectPushListPaging(MemberManageSO so);

      /**
     * <pre>
     * 작성일 : 2018. 8. 13.
     * 작성자 : khy
     * 설명   : push 발송내역을 조회한다.
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2018. 8. 13. khy - 최초생성
     * </pre>
     *
     * @param so
     * @return
     */
    public ResultListModel<MemberManageVO> selectMarketPushListPaging(MemberManageSO so);
    
    /**
     * <pre>
     * 작성일 : 2018. 8. 13.
     * 작성자 : khy
     * 설명   : push 발송내역을 조회한다. (가맹점)
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2018. 8. 13. khy - 최초생성
     * </pre>
     *
     * @param so
     * @return
     */
    public ResultListModel<MemberManageVO> selectStorePushListPaging(MemberManageSO so);
    
    /**
     * <pre>
     * 작성일 : 2019. 6. 24.
     * 작성자 : hskim
     * 설명   : 안읽은 메세지수 조회 - 마켓용
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2019. 6. 24. hskim - 최초생성
     * </pre>
     *
     * @param so
     * @return
     */
    int selectNewMarketPushCnt(MemberManageSO so);
    
    /**
     * <pre>
     * 작성일 : 2019. 6. 24.
     * 작성자 : hskim
     * 설명   : 안읽은 메세지수 조회 - 가맹점용
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2019. 6. 24. hskim - 최초생성
     * </pre>
     *
     * @param so
     * @return
     */
    int selectNewStorePushCnt(MemberManageSO so);
    
    /**
     * <pre>
     * 작성일 : 2019. 6. 24.
     * 작성자 : hskim
     * 설명   : 매장코드로 매장명 조회
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2019. 6. 24. hskim - 최초생성
     * </pre>
     *
     * @param String strCode
     * @return
     */
	public String selectStrName(String strCode);
	
	/**
     * <pre>
     * 작성일 : 2019. 6. 25.
     * 작성자 : hskim
     * 설명   : 푸쉬메세지 읽음처리
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2019. 6. 25. hskim - 최초생성
     * </pre>
     *
     * @param MemberDeliveryPO po
     * @return
     */
    public ResultModel<MemberManageVO> insertPushMessageConfirm(MemberManagePO po) throws Exception;


    /**
     * <pre>
     * 작성일 : 2016. 5. 9.
     * 작성자 : dong
     * 설명   : 비비엠 워런티 조회
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 9. dong - 최초생성
     * </pre>
     *
     * @param memberManageSO
     * @return
     */
    public ResultListModel<MemberManageVO> selectBibiemWarrantyList(MemberManageSO memberManageSO);
}
