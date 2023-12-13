package net.danvi.dmall.biz.ifapi.mem.service;

import dmall.framework.common.model.ResultListModel;
import net.danvi.dmall.biz.app.order.manage.model.OrderGoodsPO;
import net.danvi.dmall.biz.ifapi.mem.dto.*;


/**
 * 2023-05-28 210
 * erp 와 포인트 통합 관련 따로 빼서 관리
 * **/
public interface ErpPointService {

    /**
     * 2023-05-29 210
     * 어드민에서 설정된 포인트값 가져오기
     * **/
    public AdminPointConfigVO selectPointConfig();

    /**
     * 2023-05-28 210
     * 가맹점 포인트 조회
     */
    public int getfranchiseePoint(String f_sCdCust) throws Exception;

    /**
     * 2023-05-28 210
     * 회원 통합 DPoint 컨트롤
     * **/
    public void ErpMemberDPoint(MemberDPointErpVO param) throws Exception;

    /**
     * 2023-05-28 210
     * 회원가입 포인트 제공
     */
    public void RegisterMemberPoint(MemberDPointCtVO user) throws Exception;

    /**
     * 2023-05-28 210
     * 상품 후기작성
     */
    public void GoodsWritePoint(MemberDPointCtVO memberDPointCtVO) throws Exception;

    /**
     * 2023-05-28 210
     * 회원탈퇴시 포인트 소멸
     **/
    public void MemberLeaveDeletePoint(MemberDPointCtVO memberDPointCtVO) throws Exception;

    /**
     * 2023-05-31 210
     * 이알피에서 회원의 디포인트 하나 조회
     **/
    public MemberDPointErpDTO getErpMemberDPointOne(String f_sCdCust) throws Exception;

    /**
     * 2023-06-01 210
     * 우리쪽에 쌓은 디포인트 로그 회원의 디포인트 페이징 조회
     **/
    public ResultListModel<MemberDPointErpVO> getErpMemberDPointPaging(MemberDPointErpSO so) throws Exception;

    /**
     * 2023-06-02 210
     * 결제의 모든것 포인트 적립, 사용등
     * **/
    public void PaymentDPoint(MemberDPointCtVO memberDPointCtVO) throws Exception;

    /**
     * 2023-06-02 210
     * 상품 적립, 회수
     * **/
    public void PaymentDPointPvdSvMn(MemberDPointCtVO memberDPointCtVO) throws Exception;

    /**
     * 2023-06-24
     * 구매확정 포인트 적립
     * **/
    public void ordConfirmDPointPvdSvMn(MemberDPointCtVO memberDPointCtVO) throws Exception;

    /**
     * <pre>
     * 작성일 : 2018. 5. 18.
     * 작성자 : CBK
     * 설명   : 쇼핑몰-ERP 회원번호 매핑 정보 삭제 (쇼핑몰 회원번호 기준)
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2018. 5. 18. CBK - 최초생성
     * </pre>
     *
     * @return
     * @throws Exception
     */
    void deleteMemberMapByMall(String mallMemberNo) throws Exception;
}
