package net.danvi.dmall.biz.system.login.service;

import net.danvi.dmall.biz.app.member.manage.model.MemberManagePO;
import net.danvi.dmall.biz.app.member.manage.model.MemberManageVO;
import net.danvi.dmall.biz.system.login.model.MemberLoginHistPO;
import net.danvi.dmall.biz.system.model.LoginVO;
import dmall.framework.common.model.ResultModel;

public interface LoginService {

    /**
     * <pre>
     * 작성일 : 2016. 5. 27.
     * 작성자 : dong
     * 설명   : 로그인 에러 카운트 수정
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 27. dong - 최초생성
     * </pre>
     *
     * @param vo
     */
    public void updateLoginErrorCount(LoginVO vo);

    /**
     * <pre>
     * 작성일 : 2016. 5. 27.
     * 작성자 : dong
     * 설명   : 로그인 이력 등록
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 27. dong - 최초생성
     * </pre>
     *
     * @param vo
     */
    public void insertLoginHistory(MemberLoginHistPO vo);

    /**
     * <pre>
     * 작성일 : 2016. 5. 27.
     * 작성자 : dong
     * 설명   : 유저 정보 반환
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 27. dong - 최초생성
     * </pre>
     *
     * @param user
     * @return
     */
    LoginVO getUser(LoginVO user);

    /**
     * <pre>
     * 작성일 : 2016. 6. 8.
     * 작성자 : dong
     * 설명   : 로그인 에러 카운트 초기화
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 8. dong - 최초생성
     * </pre>
     *
     * @param user
     * @return
     */
    void resetUserFailCnt(LoginVO user) throws CloneNotSupportedException;

    ResultModel checkEmailCertify(MemberManagePO po);

    ResultModel updateMemberActivate(MemberManagePO po) throws Exception;

    /**
     * <pre>
     * 작성일 : 2016. 6. 20.
     * 작성자 : dong
     * 설명   : 비밀번호 다음에 변경하기 정보 업데이트
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 20. dong - 최초생성
     * </pre>
     *
     * @param po
     * @return
     */
    ResultModel<MemberManageVO> updateChangePwNext(MemberManagePO po);

    /**
     * <pre>
     * 작성일 : 2016. 6. 20.
     * 작성자 : dong
     * 설명   : 이메일 인증 키 생성후 DB 저장
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 20. dong - 최초생성
     * </pre>
     *
     * @param po
     * @return
     */
    ResultModel createAuthKey(MemberManagePO po);

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
     * @param po
     * @return
     */
    MemberManageVO selectEmailAuthKey(MemberManagePO po);
}