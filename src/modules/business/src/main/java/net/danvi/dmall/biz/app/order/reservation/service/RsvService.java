package net.danvi.dmall.biz.app.order.reservation.service;

import dmall.framework.common.exception.CustomException;
import dmall.framework.common.model.ResultListModel;
import dmall.framework.common.model.ResultModel;
import net.danvi.dmall.biz.app.order.manage.model.OrderVO;
import net.danvi.dmall.biz.app.order.reservation.model.ReservationExcelVO;
import net.danvi.dmall.biz.app.order.reservation.model.ReservationSO;
import net.danvi.dmall.biz.app.order.reservation.model.ReservationVO;

import javax.servlet.http.HttpServletRequest;
import java.util.List;
import java.util.Map;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2018. 7. 11.
 * 작성자     : khy
 * 설명       : 방문예약내역
 * </pre>
 */

public interface RsvService {
	
    /** 방문 예약 목록 조회 **/
    public ResultListModel<ReservationVO> selectReservationList(ReservationSO reservationSO);
    /** 방문 예약 목록 조회 엑셀 다운 로드 용 **/
    public List<ReservationExcelVO> selectReservationExcelList(ReservationSO reservationSO) throws CustomException;
    /** 방문 예약 정보 **/
    public ReservationVO selectReservationDtl(ReservationSO reservationSO);
    /** 방문 예약 상세 목록 (상품 목록) **/
    public List<ReservationVO> selectReservationDtlList(ReservationSO reservationSO);
    /** 방문 예약 상세 옵션 목록 (상품 옵션 목록) **/
    public List<ReservationVO> selectReservationAddOptionList(ReservationSO reservationSO);
    /** 주문에서 방문예약 여부 조회  **/
    public Integer selectExistOrd(ReservationSO reservationSO);
    /** 방문 예약 취소 **/
    public int updateRsvInfo(ReservationVO vo) throws Exception;
    /** 방문예약등록 **/
    //public ResultModel<OrderPO> insertReservation(OrderPO po)  throws Exception;
    /** 방문예약등록 (방문 - 인터페이스 포함) **/
    //public ResultModel<OrderPO> insertReservationInfo(OrderPO po, List<OrderGoodsPO> orderGoodsList) throws Exception;
    /** 주문 방문예약 상품목록 **/
    public ResultModel<OrderVO> selectReservationGoods(OrderVO vo, HttpServletRequest request) throws Exception;
    /** 시/도 코드 가져오기**/
    public String selectSidoCode(ReservationSO so);
    /** 동일시간 예약체크 **/
    public int existsRsvTime(ReservationVO vo);
    /** 현재 방문예약 리스트 조회 **/
    public List<ReservationVO> selectExistReservationList(ReservationSO reservationSO);
    /** 기존방문예약에 예약추가 **/
    public int addReservationBook(ReservationSO reservationSO) throws Exception;
    
    /** 가맹점 제휴업체 조회 **/
    public List<ReservationVO> selectAffiliateList(ReservationSO so);

    /** 비회원 방문예약 존재여부 조회 **/
    public boolean selectNonMemberRsv(ReservationSO so);

    /** 당첨자 체크 **/
    public int winnerChk(Map<String, String> param);

    /** 예약 변경 히스토리 **/
    public List<ReservationVO> selectRsvHistList(ReservationSO so) throws CustomException;
}
