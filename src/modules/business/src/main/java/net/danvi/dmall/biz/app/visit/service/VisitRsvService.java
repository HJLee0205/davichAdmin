package net.danvi.dmall.biz.app.visit.service;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import dmall.framework.common.model.ResultListModel;
import dmall.framework.common.model.ResultModel;
import net.danvi.dmall.biz.app.order.manage.model.OrderGoodsPO;
import net.danvi.dmall.biz.app.order.manage.model.OrderPO;
import net.danvi.dmall.biz.app.order.manage.model.OrderVO;
import net.danvi.dmall.biz.app.visit.model.VisitSO;
import net.danvi.dmall.biz.app.visit.model.VisitVO;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2018. 7. 11.
 * 작성자     : khy
 * 설명       : 방문예약내역
 * </pre>
 */

public interface VisitRsvService {
	
    /** 방문 예약 목록 조회 **/
    public ResultListModel<VisitVO> selectVisitList(VisitSO visitSO);
    /** 방문 예약 정보 **/
    public VisitVO selectVisitDtl(VisitSO visitSO);
    /** 방문 예약 상세 목록 (상품 목록) **/
    public List<VisitVO> selectVisitDtlList(VisitSO visitSO);
    /** 방문 예약 상세 옵션 목록 (상품 옵션 목록) **/
    public List<VisitVO> selectVisitAddOptionList(VisitSO visitSO);
    /** 주문에서 방문예약 여부 조회  **/
    public Integer selectExistOrd(VisitSO visitSO);
    /** 방문 예약 취소 **/
    public int updateRsvCancel(VisitSO visitSO) throws Exception;
    /** 방문예약등록 **/
    public ResultModel<OrderPO> insertVisit(OrderPO po)  throws Exception;
    /** 방문예약등록 (방문 - 인터페이스 포함) **/
    public ResultModel<OrderPO> insertVisitInfo(OrderPO po, List<OrderGoodsPO> orderGoodsList) throws Exception;
    /** 주문 방문예약 상품목록 **/
    public ResultModel<OrderVO> selectVisitGoods(OrderVO vo, HttpServletRequest request) throws Exception;
    /** 시/도 코드 가져오기**/
    public String selectSidoCode(VisitSO so);
    /** 동일시간 예약체크 **/
    public int existsRsvTime(VisitVO vo);
    /** 현재 방문예약 리스트 조회 **/
    public List<VisitVO> selectExistVisitList(VisitSO visitSO);
    /** 기존방문예약에 예약추가 **/
    public int addVisitBook(VisitSO visitSO) throws Exception;
    
    /** 가맹점 제휴업체 조회 **/
    public List<VisitVO> selectAffiliateList(VisitSO so);

    /** 비회원 방문예약 존재여부 조회 **/
    public boolean selectNonMemberRsv(VisitSO so);

    /** 당첨자 체크 **/
    public int winnerChk(Map<String, String> param);

    /** 방문예약 취소 */
    public int removeVisit(VisitSO visitSO) throws Exception;
}
