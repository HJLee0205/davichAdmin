package net.danvi.dmall.smsemail.service;

import net.danvi.dmall.smsemail.model.MemberManageSO;
import net.danvi.dmall.smsemail.model.MemberManageVO;
import net.danvi.dmall.smsemail.model.PushSendVO;
import net.danvi.dmall.smsemail.model.request.PushSendPO;
import net.danvi.dmall.smsemail.model.request.SmsSendPO;
import net.danvi.dmall.smsemail.model.request.SmsSendSO;
import org.springframework.scheduling.annotation.Async;

import java.util.List;
import java.util.Map;

/**
 * <pre>
 * 프로젝트명 : push service
 * 작성일     : 2018. 8. 31.
 * 작성자     : khy
 * 설명       :
 * </pre>
 */
public interface MemberService {

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
     * 설명   : 회원 리스트 조회 페이징 (앱 푸시 대상조회)
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2018. 8. 9. khy - 최초생성
     * </pre>
     *
     * @param memberManageSO
     * @return MemberManageVO
     */
     @Async
    public List<MemberManageVO> viewTotalPushListPaging(MemberManageSO memberManageSO,PushSendVO rstVO) throws Exception;

     @Async
    public List<MemberManageVO> viewTotalSmsListPaging(SmsSendSO smsSendSO, SmsSendPO po) throws Exception;

    /**
     * <pre>
     * 작성일 : 2018. 8. 9.
     * 작성자 : khy
     * 설명   : 회원 리스트 조회 페이징 (앱 푸시 대상조회)
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2018. 8. 9. khy - 최초생성
     * </pre>
     *
     * @param memberManageSO
     * @return MemberManageVO
     */
    public int selectTotalPushListPagingCount(MemberManageSO memberManageSO);

    public int selectTotalSmsListPagingCount(MemberManageSO memberManageSO);



	
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
     @Async
    public List<MemberManageVO> viewPushListCommonByMap(PushSendVO rstVO,PushSendVO rsltVO) throws Exception;

    /**
     * <pre>
     * 작성일 : 2018. 8. 9.
     * 작성자 : khy
     * 설명   : 회원 리스트 조회 페이징 (앱 푸시 대상조회)
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2018. 8. 9. khy - 최초생성
     * </pre>
     *
     * @param memberManageSO
     * @return MemberManageVO
     */
    public int selectMemListByPushCount(Map<String, Object> map);
    
    
    /**
     * <pre>
     * 작성일 : 2018. 8. 9.
     * 작성자 : khy
     * 설명   : 토큰정보조회
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2018. 8. 9. khy - 최초생성
     * </pre>
     *
     * @param memberManageSO
     * @return MemberManageVO
     */
    public MemberManageVO selectMemberToken(PushSendPO po);

    
    
    
}
