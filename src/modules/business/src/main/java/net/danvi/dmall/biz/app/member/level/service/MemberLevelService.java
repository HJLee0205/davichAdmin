package net.danvi.dmall.biz.app.member.level.service;

import java.util.List;

import net.danvi.dmall.biz.app.member.level.model.MemberLevelPO;
import net.danvi.dmall.biz.app.member.level.model.MemberLevelSO;
import net.danvi.dmall.biz.app.member.level.model.MemberLevelVO;
import dmall.framework.common.model.ResultListModel;
import dmall.framework.common.model.ResultModel;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 5. 3.
 * 작성자     : kjw
 * 설명       : 회원 등급 관리 컴포넌트의 서비스 인터페이스
 * </pre>
 */
public interface MemberLevelService {
    /**
     * <pre>
     * 작성일 : 2016. 5. 3.
     * 작성자 : kjw
     * 설명   : 회원 등급 조회(회원 등급 메뉴)
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 3. kjw - 최초생성
     * </pre>
     *
     * @return
     */
    public ResultListModel<MemberLevelVO> viewMemGradeList(MemberLevelSO so);

    /**
     * <pre>
     * 작성일 : 2016. 5. 3.
     * 작성자 : kjw
     * 설명   : 회원 등급 조회(회원 등급 메뉴 외)
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 3. kjW - 최초생성
     * </pre>
     *
     * @return
     */
    public ResultListModel<MemberLevelVO> selectGradeGetList();

    /**
     * <pre>
     * 작성일 : 2016. 5. 3.
     * 작성자 : kjw
     * 설명   : 회원 등급 삭제
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 3. kjW - 최초생성
     * </pre>
     *
     * @param po
     * @return
     * @throws Exception
     */
    public ResultModel<MemberLevelPO> deleteMemGrade(MemberLevelPO po) throws Exception;

    /**
     * <pre>
     * 작성일 : 2016. 5. 3.
     * 작성자 : kjw
     * 설명   : 회원 등급 산정 기준 설정
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 3. kjw - 최초생성
     * </pre>
     *
     * @param po
     * @return
     * @throws Exception
     */
    public ResultModel<MemberLevelPO> updateMemGradeManageCfg(MemberLevelPO po) throws Exception;

    /**
     * <pre>
     * 작성일 : 2016. 5. 3.
     * 작성자 : kjw
     * 설명   : 자동 등급조정(갱신) 설정
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 3. kjw - 최초생성
     * </pre>
     *
     * @param po
     * @return
     * @throws Exception
     */
    public ResultModel<MemberLevelPO> updateMemGradeAsbConfig(MemberLevelPO po) throws Exception;

    /**
     * <pre>
     * 작성일 : 2016. 5. 3.
     * 작성자 : kjw
     * 설명   : 회원 등급 수정
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 3. kjw - 최초생성
     * </pre>
     *
     * @param po
     * @return
     * @throws Exception
     */
    public ResultModel<MemberLevelPO> updateMemGradeConfig(MemberLevelPO po) throws Exception;

    /**
     * <pre>
     * 작성일 : 2016. 5. 3.
     * 작성자 : kjw
     * 설명   : 회원 등급 등록
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 3. kjw - 최초생성
     * </pre>
     *
     * @param po
     * @return
     * @throws Exception
     */
    public ResultModel<MemberLevelPO> insertMemGrade(MemberLevelPO po) throws Exception;

    /**
     * <pre>
     * 작성일 : 2016. 6. 29.
     * 작성자 : dong
     * 설명   : 회원 등급별 구매혜택 그룹건수 조회
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 29. dong - 최초생성
     * </pre>
     *
     * @return
     */
    public List<MemberLevelVO> getMemGradeBenefitGrpList(MemberLevelSO so);

    /**
     * <pre>
     * 작성일 : 2016. 6. 29.
     * 작성자 : dong
     * 설명   : 회원 등급별 구매혜택 리스트 조회
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 29. dong - 최초생성
     * </pre>
     *
     * @return
     */
    public List<MemberLevelVO> viewMemGradeBenefitList(MemberLevelSO so);

    /**
     * <pre>
     * 작성일 : 2016. 5. 3.
     * 작성자 : dong
     * 설명   : 회원 등급별 구매혜택 등록
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 29. dong - 최초생성
     * </pre>
     *
     * @param po
     * @return
     * @throws Exception
     */
    public ResultModel<MemberLevelPO> insertMemGradeBenefit(MemberLevelPO po) throws Exception;

    /**
     * <pre>
     * 작성일 : 2016. 5. 3.
     * 작성자 : dong
     * 설명   : 회원 등급별 구매혜택 수정
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 3. dong - 최초생성
     * </pre>
     *
     * @param po
     * @return
     * @throws Exception
     */
    public ResultModel<MemberLevelPO> updateMemGradeBenefit(MemberLevelPO po) throws Exception;

    /**
     * <pre>
     * 작성일 : 2016. 5. 3.
     * 작성자 : dong
     * 설명   : 회원 등급별 구매혜택 사용여부 수정
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 3. dong - 최초생성
     * </pre>
     *
     * @param po
     * @return
     * @throws Exception
     */
    public ResultModel<MemberLevelPO> updateUseYn(MemberLevelPO po) throws Exception;

    /**
     * <pre>
     * 작성일 : 2016. 7. 1.
     * 작성자 : dong
     * 설명   : 회원 등급별 구매혜택 삭제
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 7. 1. dong - 최초생성
     * </pre>
     *
     * @param po
     * @return
     * @throws Exception
     */
    public ResultModel<MemberLevelPO> deleteMemGradeBenefit(MemberLevelPO po) throws Exception;

    /**
     * <pre>
     * 작성일 : 2016. 5. 3.
     * 작성자 : kjw
     * 설명   : 자동 등급조정(갱신) 조회
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 3. kjw - 최초생성
     * </pre>
     *
     * @param po
     * @return
     * @throws Exception
     */
    public ResultModel<MemberLevelVO> selectMemGradeAsbConfig(MemberLevelSO memberLevelSO);

    /**
     * <pre>
     * 작성일 : 2016. 5. 3.
     * 작성자 : kjw
     * 설명   : 회원 등급 수정 화면(회원 등급 상세 정보 조회)
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 3. kjw - 최초생성
     * </pre>
     *
     * @return
     */
    public ResultModel<MemberLevelVO> viewMemGradeUpdate(MemberLevelSO so);

    /**
     * <pre>
     * 작성일 : 2016. 5. 3.
     * 작성자 : kjw
     * 설명   : 회원 등급 레벨 발리데이션 
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 3. kjw - 최초생성
     * </pre>
     *
     * @return
     */
    public Integer selectMemGradeLevelCnt(MemberLevelSO so);

    public ResultModel<MemberLevelVO> viewSignupBnf(MemberLevelSO so);
}
