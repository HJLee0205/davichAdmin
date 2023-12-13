package net.danvi.dmall.biz.app.order.manage.service;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import net.danvi.dmall.biz.app.goods.model.GoodsAddOptionDtlVO;
import net.danvi.dmall.biz.app.goods.model.GoodsDetailSO;
import net.danvi.dmall.biz.app.member.manage.model.MemberManageVO;
import net.danvi.dmall.biz.app.promotion.coupon.model.CouponPO;
import net.danvi.dmall.biz.app.promotion.coupon.model.CouponVO;
import net.danvi.dmall.biz.app.visit.model.VisitVO;
import net.danvi.dmall.core.model.payment.AlipayPO;
import net.danvi.dmall.core.model.payment.TenpayPO;
import org.springframework.web.servlet.ModelAndView;

import net.danvi.dmall.biz.app.order.manage.model.ClaimGoodsPO;
import net.danvi.dmall.biz.app.order.manage.model.ClaimGoodsVO;
import net.danvi.dmall.biz.app.order.manage.model.OrderExcelVO;
// import ClaimVO;
import net.danvi.dmall.biz.app.order.manage.model.OrderGoodsPO;
import net.danvi.dmall.biz.app.order.manage.model.OrderGoodsVO;
import net.danvi.dmall.biz.app.order.manage.model.OrderInfoPO;
import net.danvi.dmall.biz.app.order.manage.model.OrderInfoVO;
import net.danvi.dmall.biz.app.order.manage.model.OrderPO;
import net.danvi.dmall.biz.app.order.manage.model.OrderSO;
import net.danvi.dmall.biz.app.order.manage.model.OrderVO;
import net.danvi.dmall.biz.app.order.payment.model.OrderPayPO;
import net.danvi.dmall.biz.app.order.payment.model.OrderPayVO;
import net.danvi.dmall.core.model.payment.PaymentModel;
import net.danvi.dmall.core.model.payment.PaypalPO;
import dmall.framework.common.exception.CustomException;
import dmall.framework.common.model.ResultListModel;
import dmall.framework.common.model.ResultModel;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 5. 3.
 * 작성자     : dong
 * 설명       : 주문목록, 주문상세, 취소등을 관리
 * </pre>
 */
public interface OrderService {

    /** 회원번호 또는 아이디로 주문횟수 및 결제금액 합계 조회 */
    public MemberManageVO selectOrdHistbyMember(OrderSO so) throws CustomException;

    /** 주문 목록 페이징 조회 */
    public ResultListModel<OrderInfoVO> selectOrdListPaging(OrderSO so) throws CustomException;

    /** 엑셀 다운로드 목록 */
    public List<OrderInfoVO> selectOrdSrchListExcel(OrderSO so) throws CustomException;

    /** 순방향으로 선택가능한 주문 상태코드를 조회 */
    public OrderInfoVO selectOrdStatusForward(OrderInfoVO vo) throws CustomException;

    /** 역방향으로 선택가능한 주문 상태코드를 조회 */
    public OrderInfoVO selectOrdStatusBackward(OrderInfoVO vo, String dtlYn) throws CustomException;

    /** 주문 내역 리스트 엑셀 목록 */
    public List<OrderExcelVO> selectOrdList(String[] ordNoList) throws CustomException;

    public ResultModel<OrderInfoVO> updateOrdListStatus(List<OrderGoodsVO> listvo, String curOrdStatusCd)
            throws CustomException;

    /** 주문 내역서 프린트 **/
    public OrderVO selectOrdDtlPrint(OrderInfoVO vo) throws CustomException;

    /** 주문 상세 페이지 **/
    public OrderVO selectOrdDtl(OrderInfoVO vo) throws CustomException;

    /** 주문 메모 등록 **/
    public boolean insertOrdMemo(OrderInfoPO po) throws CustomException;

    /** 주문한 상품 목록 정보를 조회 */
    public List<OrderGoodsVO> selectOrdDtlList(OrderInfoVO vo) throws CustomException;

    public boolean updateOrdDtlOption(OrderGoodsVO vo) throws CustomException;

    /**
     * 주문 상태 변경
     *
     * @param 주문번호
     * @param 주문상세번호(선택)
     * @param 현재주문상태
     */
    public ResultModel<OrderInfoVO> updateOrdStatus(OrderGoodsVO vo, String curOrdStatusCd) throws CustomException;

    /** 주문 상세 상태 변경. 상태 코드 부분배송[준비]중을 전체완료로 변경 */
    public ResultModel<OrderInfoVO> updateOrdStatusDone(OrderGoodsVO po) throws CustomException;

    /** 결제취소시 PG 결제였다면 TO_PAYMENT 테이블의 상태를 취소로 변경 */
    public ResultModel<OrderPayVO> updatePaymentStatus(PaymentModel model) throws CustomException;

    /**
     * <pre>
     * 작성일 : 2016. 9. 28.
     * 작성자 : KNG
     * 설명   : PG 입금통보 입금정보 수신시 주문, 주문상세, 결제, 현금영수증 테이블 정보를 변경 및 추가하는 작업
     *
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 9. 28. KNG - 최초생성
     * </pre>
     *
     * @param vo
     * @param model
     * @return
     * @throws CustomException
     * @throws Exception
     */
    public ResultModel<OrderPayVO> updatePaymentStatusByDepositNotice(OrderGoodsVO vo, PaymentModel model)
            throws CustomException, Exception;

    /** 클레임 이력 */
    public List<ClaimGoodsVO> selectClaimList(OrderInfoVO vo) throws CustomException;

    /** 처리 로그 이력 조회 */
    public List<OrderGoodsVO> selectOrdDtlHistList(OrderInfoVO vo) throws CustomException;

    /** 현재 주문의 상태 조회 */
    public OrderGoodsVO selectCurOrdStatus(OrderGoodsVO vo) throws CustomException;

    /** 주문 프로세스 실행 **/
    public ResultModel<OrderPO> insertOrder(OrderPO po, HttpServletRequest request) throws Exception;

    /** 주문 결제 프로세스 실행 **/
    public ResultModel<OrderPO> orderPayment(OrderPO po, HttpServletRequest request, Map<String, Object> reqMap,
            ModelAndView mav) throws Exception;

    /** 주문정보 등록 **/
    public ResultModel<OrderInfoPO> insertOrderInfo(OrderInfoPO po) throws Exception;

    /** 주문 배송지 정보 등록 **/
    public ResultModel<OrderInfoPO> insertOrderDelivery(OrderInfoPO po) throws Exception;

    /** 주문상품정보 등록 **/
    public ResultModel<OrderGoodsPO> insertOrderGoods(List<OrderGoodsPO> po) throws Exception;

    /** 배송비 정보 등록 **/
    public ResultModel<OrderGoodsPO> insertDlvrc(List<OrderGoodsPO> po) throws Exception;

    /** 결제 정보 등록 **/
    public ResultModel<PaymentModel<?>> insertOrderPay(PaymentModel po) throws Exception;

    /** 부가비용 정보 등록 **/
    public ResultModel<OrderGoodsPO> insertAddedAmount(List<OrderGoodsPO> po) throws Exception;

    /** 주문 사은품 정보 등록 **/
    public ResultModel<OrderGoodsPO> insertFreebie(List<OrderGoodsPO> po) throws Exception;

    /** 쿠폰 사용 정보 등록 **/
    public ResultModel<CouponPO> insertCouponUse(List<CouponPO> po) throws Exception;

    /** 상품 구매 재고 수정 **/
    public void updateGoodsStock(List<OrderGoodsPO> po) throws Exception;

    /**
     * 주문 취소 프로세스 실행
     *
     * @param cpo
     **/
    public ResultModel<OrderPayPO> cancelOrder(OrderPO po) throws CustomException;

    /** 주문번호 생성 **/
    public long createOrdNo(long siteNo) throws Exception;

    /** 페이팔 hash 데이터 생성 **/
    public ResultModel<PaypalPO> getPaypalHashData(PaypalPO po);

    /** 알리페이 hash 데이터 생성 **/
    public ResultModel<AlipayPO> getAlipayHashData(AlipayPO po);

    /** 텐페이 hash 데이터 생성 **/
    public ResultModel<TenpayPO> getTenpayHashData(TenpayPO po);

    /** 부분취소 적립예정금액 재계산 **/
    public Long calcSvmnAmt(List<OrderGoodsPO> orderGoodsList) throws Exception;

    /** 상품평 작성을 위한 상품 구매 여부 확인 **/
    public OrderGoodsVO selectOrdGoodsReview(OrderSO so) throws Exception;

    /** 주문확인용 상품 정보 조회 **/
    public OrderGoodsVO selectOrderGoodsInfo(GoodsDetailSO so) throws Exception;

    /** 배송비 계산용 주문 정보 조회 **/
    public List<OrderGoodsVO> selectOrderGoodsInfoList(GoodsDetailSO so) throws Exception;

    /** 배송비 계산 **/
    public Map calcDlvrAmt(List list, String type) throws Exception;

    /** 주문확인용 상품 추가 옵션 정보 조회 **/
    public GoodsAddOptionDtlVO selectOrderAddOptionInfo(GoodsDetailSO so) throws Exception;

    /** 주문확인용 상품 정보 조회 **/
    public ResultModel<OrderVO> selectOrderCountInfo(OrderSO so);

    /** 선택한 주문상태의 주문건수 조회 **/
    public ResultModel<OrderVO> selectStatusOrderCount(OrderSO so);

    /** 비회원 주문 존재여부 조회 **/
    public boolean selectNonMemberOrder(OrderSO so);

    /** 검색조건에 맞는 주문 상세 목록을 조회하여 리턴 **/
    public ResultListModel<OrderGoodsVO> selectOrdDtlAllListPaging(OrderSO so) throws CustomException;

    /** 프론트 주문 상세 목록을 조회하여 리턴 **/
    public ResultListModel<OrderVO> selectOrdListFrontPaging(OrderSO so) throws CustomException;

    /** 부가 비용 사용 목록 조회 **/
    public List<OrderGoodsVO> selectAddedAmountList(OrderInfoVO vo) throws CustomException;

    /** 주문 상태 변경시 자동 SMS 보내기 **/
    public boolean sendOrdAutoSms(String templateCode,String sendTypeCd, OrderGoodsVO vo, Map<String, String> templateCodeMap) throws Exception;

    /** 주문 상태 변경시 자동 이메일 보내기 **/
    public boolean sendOrdAutoEmail(String sendTypeCd, OrderGoodsVO vo) throws Exception;

    /** 취소시 배송비 재 계산용 주문 정보 조회 **/
    public List<ClaimGoodsVO> selectDlvrCalOrdGoodsList(GoodsDetailSO so) throws Exception;

    /** 결제 정보 목록 조회 **/
    public List<OrderPayVO> selectOrderPayInfoList(OrderInfoVO vo);

    /** 주문 기본 정보 조회 **/
    public OrderInfoVO selectOrdDtlInfo(OrderInfoVO vo);

    /** 주문 상품 취소 정보 조회 **/
    public List<OrderGoodsVO> selectOrdCancelDtlList(OrderInfoVO vo) throws CustomException;

    /** 주문 상품 취소 정보 조회 **/
    public OrderGoodsVO selectOrdCancelDtlInfo(OrderGoodsVO vo) throws CustomException;

    /** 묶음배송 해제여부 조회 **/
    public boolean changeDlvrPriceYn(OrderPO po) throws CustomException;

    /** 주문정보 수정 **/
    public ResultModel<OrderInfoPO> updateOrderInfo(OrderInfoPO po) throws Exception;

    /** 주문테이블의 전체 구매 확정 처리 */
    public ResultModel<OrderInfoVO> updateOrdStatusCdConfirm(OrderGoodsVO vo) throws Exception;

    /** 현재 결제 완료 주문상태 확인 **/
    public ResultModel<OrderVO> partCancelStatusOrderCount(OrderSO so);

    /** 결제 정보 등록 **/
    public ResultModel<PaymentModel<?>> insertPartCancelOrderPay(PaymentModel po) throws Exception;

    /** 주문 취소/교환/환불 상세 정보 **/
    public ResultListModel<OrderVO> orderCancelDtlInfo(OrderSO vo);

    /** 모바일 주문 결제 프로세스 실행 **/
    public ResultModel<OrderPO> orderPaymentMobile(OrderPO po, HttpServletRequest request, Map<String, Object> reqMap,
            ModelAndView mav) throws Exception;

    /** 주문취소 인터페이스에서 처리 **/
    public ResultModel<OrderPayPO> orderCancelAllIf(OrderPO po) throws Exception;

    /** 주문 상세 seq 확인 **/
    public Integer selectOrderDtlSeqCancelCount(OrderPO po);
    
    /** 주문 상세 구매 확정 **/
    public ResultModel<OrderInfoVO> updateOrderDtl(OrderGoodsVO vo) throws Exception;
    /** 주문시 사용한 쿠폰 리스트 **/
    public List<CouponVO> selectCouponList(OrderInfoVO orderInfoVo) throws Exception;
    /** 방문예약시 등록한 매장번호 조회 **/
    public  VisitVO selectStrCode(OrderInfoVO orderInfoVo) throws Exception;

    public List<OrderGoodsVO> selectReturnRegistList(ClaimGoodsPO claimGoodsPo) throws Exception;

    public List<OrderGoodsVO> selectReturnConfirmList(OrderInfoVO orderInfoVo) throws Exception;

    public List<OrderGoodsVO> selectRefundConfirmList(OrderInfoVO orderInfoVo) throws Exception;


    /** 이니시스 실시간 계좌이체 NOTI 정보 저장 (모바일) **/
    public int insertIniCisNotiInfo(Map<String, String> paramMap)throws Exception;

    /** 이니시스 실시간 계좌이체 NOTI 정보 조회 (모바일) **/
    public Map<String, Object>  selectIniCisNotiInfo(Map<String, String> paramMap)throws Exception;
    
    /** 다비전코드 조회 **/
    public String selectErpItmCode(String mallItmCode) throws Exception;
}
