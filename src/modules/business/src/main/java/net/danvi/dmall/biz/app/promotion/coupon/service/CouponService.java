package net.danvi.dmall.biz.app.promotion.coupon.service;

import java.util.List;
import java.util.Map;

import net.danvi.dmall.biz.app.member.manage.model.MemberManagePO;
import net.danvi.dmall.biz.app.operation.model.SavedmnPointPO;
import net.danvi.dmall.biz.app.promotion.coupon.model.CouponPO;
import net.danvi.dmall.biz.app.promotion.coupon.model.CouponPOListWrapper;
import net.danvi.dmall.biz.app.promotion.coupon.model.CouponSO;
import net.danvi.dmall.biz.app.promotion.coupon.model.CouponVO;
import net.danvi.dmall.biz.app.promotion.coupon.model.CpTargetVO;
import dmall.framework.common.model.ResultListModel;
import dmall.framework.common.model.ResultModel;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 5. 3.
 * 작성자     : dong
 * 설명       : 쿠폰 서비스
 * </pre>
 */
public interface CouponService {

    List<CouponVO> selectCouponList(CouponSO so);

    /**
     * <pre>
     * 작성일 : 2016. 9. 8.
     * 작성자 : dong
     * 설명   : 쿠폰목록조회(페이징)
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 9. 8. dong - 최초생성
     * </pre>
     *
     * @param so
     * @return
     */
    ResultListModel<CouponVO> selectCouponListPaging(CouponSO so);

    /**
     * <pre>
     * 작성일 : 2016. 5. 3.
     * 작성자 : dong
     * 설명   : 쿠폰기본정보 등록
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 3. dong - 최초생성
     * </pre>
     *
     * @param po
     * @return
     */
    ResultModel<CouponPO> insertCouponInfo(CouponPO po) throws Exception;

    /**
     * <pre>
     * 작성일 : 2016. 5. 3.
     * 작성자 : dong
     * 설명   : 쿠폰기본정보 수정
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 3. dong - 최초생성
     * </pre>
     *
     * @param po
     * @return
     */
    ResultModel<CouponPO> updateCouponInfo(CouponPO po) throws Exception;

    /**
     * <pre>
     * 작성일 : 2016. 5. 3.
     * 작성자 : dong
     * 설명   : 쿠폰기본정보 삭제
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 3. dong - 최초생성
     * </pre>
     *
     * @param wrapper
     * @return
     */
    ResultModel<CouponPO> deleteCouponInfo(CouponPOListWrapper wrapper) throws Exception;

    /**
     * <pre>
     * 작성일 : 2016. 5. 3.
     * 작성자 : dong
     * 설명   : 쿠폰기본정보 조회 ( 단건 )
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 3. dong - 최초생성
     * </pre>
     *
     * @param so
     * @return
     */
    ResultModel<CouponVO> selectCouponDtl(CouponSO so) throws Exception;

    /**
     * <pre>
     * 작성일 : 2016. 9. 8.
     * 작성자 : dong
     * 설명   : 쿠폰발급
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 9. 8. dong - 최초생성
     * </pre>
     *
     * @param po
     * @return
     * @throws Exception
     */
    ResultModel<CouponPO> insertCouponIssue(CouponPO po) throws Exception;

    /**
     * <pre>
     * 작성일 : 2016. 5. 3.
     * 작성자 : 
     * 설명   : 상품상세 사용가능 쿠폰 리스트
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 3. - 최초생성
     * </pre>
     *
     * @param CouponSO
     * @return
     */
    List<CouponVO> selectAvailableGoodsCouponList(CouponSO couponSO);

    /**
     * <pre>
     * 작성일 : 2016. 5. 3.
     * 작성자 : 
     * 설명   : 주문적용시 사용가능 쿠폰 리스트
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 3. - 최초생성
     * </pre>
     *
     * @param couponSO
     * @return
     */
    List<CouponVO> selectAvailableOrderCouponList(CouponSO couponSO);

    /**
     * <pre>
     * 작성일 : 2016. 6. 20.
     * 작성자 : KMS
     * 설명   : 쿠폰 적용 대상 조회
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 20. KMS - 최초생성
     * </pre>
     *
     * @param couponSO
     * @return
     */
    ResultModel<CouponVO> selectCouponApplyTargetList(CouponSO couponSO);

    /**
     * <pre>
     * 작성일 : 2016. 6. 23.
     * 작성자 : dong
     * 설명   : 회원쿠폰발급팝업 화면_ 발급대상목록 조회
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 23. dong - 최초생성
     * </pre>
     *
     * @param so
     * @return
     */
    List<CpTargetVO> selectIssueTargetListPop(CouponSO so);

    /**
     * <pre>
     * 작성일 : 2016. 8. 29.
     * 작성자 : dong
     * 설명   : 회원쿠폰발급팝업 화면_ 발급 받은 회원목록 조회(중복방지)
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 8. 29. dong - 최초생성
     * </pre>
     *
     * @param so
     * @return
     */
    List<CpTargetVO> selectIssuedTargetListPop(CouponSO so);

    /**
     * <pre>
     * 작성일 : 2016. 6. 23.
     * 작성자 : dong
     * 설명   : 쿠폰발급/사용내역 조회
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 23. dong - 최초생성
     * </pre>
     *
     * @param so
     * @return
     */
    ResultListModel<CpTargetVO> selectCouponIssueUseHist(CouponSO so);

    /**
     * <pre>
     * 작성일 : 2016. 7. 20.
     * 작성자 : KMS
     * 설명   : 사용하지 않은 회원 보유 쿠폰 조회
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 7. 20. KMS - 최초생성
     * </pre>
     *
     * @param so
     * @return
     */
    int selectMemberCoupon(CouponSO so);

    /**
     * <pre>
     * 작성일 : 2016. 8. 10.
     * 작성자 : KMS
     * 설명   : 회원쿠폰 사용정보 수정
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 8. 10. KMS - 최초생성
     * </pre>
     *
     * @param poList
     * @return
     * @throws Exception
     */
    ResultModel<CouponPO> updateMemberUseCoupon(List<CouponPO> poList) throws Exception;

    /**
     * <pre>
     * 작성일 : 2016. 8. 22.
     * 작성자 : dong
     * 설명   :회원탈퇴시 발급한 쿠폰 모두 삭제처리하는 메서드
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 8. 22. choiyousung - 최초생성
     * </pre>
     *
     * @param po
     * @return
     * @throws Exception
     */
    ResultModel<MemberManagePO> deleteMemberCoupon(MemberManagePO po) throws Exception;
    
    /**
     * <pre>
     * 작성일 : 2018. 8. 7.
     * 작성자 : CBK
     * 설명   : 오프라인 쿠폰 발급
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2018. 8. 7. CBK - 최초생성
     * </pre>
     *
     * @param po
     * @return
     * @throws Exception
     */
    ResultModel<SavedmnPointPO> issueOfflineCoupon(SavedmnPointPO po) throws Exception;
    
    /**
     * <pre>
     * 작성일 : 2018. 9. 12.
     * 작성자 : hskim
     * 설명   : 예약전용 쿠폰 발급
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2018. 9. 12. hskim - 최초생성
     * </pre>
     *
     * @param po
     * @return
     * @throws Exception
     */
    ResultModel<CouponPO> rsvOnlyCoupon(CouponPO po) throws Exception;

    /**
     * <pre>
     * 작성일 : 2018. 9. 12.
     * 작성자 : hskim
     * 설명   : 첫구매 쿠폰 발급
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2018. 9. 12. hskim - 최초생성
     * </pre>
     *
     * @param po
     * @return
     * @throws Exception
     */
    ResultModel<CouponPO> firstOrdCoupon(CouponPO po) throws Exception;

    /**
     * <pre>
     * 작성일 : 2018. 9. 12.
     * 작성자 : dong
     * 설명   : 예약시 발급받은 쿠폰 조회
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2018. 9. 12. dong - 최초생성
     * </pre>
     *
     * @param po
     * @return
     * @throws Exception
     */
    List<CouponVO> selectRsvCouponIssue(String[] cpIssueNo) throws Exception;
    
    /**
     * <pre>
     * 작성일 : 2019. 4. 3.
     * 작성자 : hskim
     * 설명   : 쿠폰존 사용가능 쿠폰 리스트
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2019. 4. 3. - 최초생성
     * </pre>
     *
     * @param CouponSO
     * @return
     */
    List<CouponVO> selectAvailableGoodsCouponZoneList(CouponSO couponSO);

    Map<String, Object> selectAvailableGoodsCouponZoneNewList(CouponSO couponSO);
    
    /**
     * <pre>
     * 작성일 : 2019. 4. 3.
     * 작성자 : hskim
     * 설명   : 다운로드 가능 쿠폰 갯수
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2019. 4. 3. - 최초생성
     * </pre>
     *
     * @param CouponSO
     * @return
     */
    int selectAvailableDownloadCouponCnt(CouponSO couponSO);
    
    /**
     * <pre>
     * 작성일 : 2019. 6. 4.
     * 작성자 : hskim
     * 설명   : 증정 쿠폰 갯수
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2019. 6. 4. - 최초생성
     * </pre>
     *
     * @param CouponSO
     * @return
     */
    int selectGoodsPreGoodsCnt(CouponSO couponSO);

    /**
     * <pre>
     * 작성일 : 2019. 6. 4.
     * 작성자 : hskim
     * 설명   : 증정 쿠폰 발급 수량 체크
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2019. 6. 4. - 최초생성
     * </pre>
     *
     * @param CouponSO
     * @return
     */
    String selectCouponLimitQttYn(CouponSO cpSO);


    /**
     * <pre>
     * 작성일 : 2016. 5. 3.
     * 작성자 : dong
     * 설명   : 쿠폰기본정보 복사
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 3. dong - 최초생성
     * </pre>
     *
     * @param po
     * @return
     */
    ResultModel<CouponPO> copyCouponInfo(CouponPO po) throws Exception;
}
