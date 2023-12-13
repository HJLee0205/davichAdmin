package net.danvi.dmall.admin;

import dmall.framework.common.BaseService;
import dmall.framework.common.constants.MapperConstants;
import dmall.framework.common.util.HttpUtil;
import lombok.extern.slf4j.Slf4j;
import net.danvi.dmall.biz.app.order.manage.model.OrderGoodsVO;
import net.danvi.dmall.biz.app.order.manage.model.OrderInfoVO;
import net.danvi.dmall.biz.app.order.manage.model.OrderVO;
import net.danvi.dmall.biz.app.order.manage.service.OrderService;
import net.danvi.dmall.biz.app.order.payment.model.OrderPayVO;
import net.danvi.dmall.biz.app.promotion.coupon.model.CouponVO;
import net.danvi.dmall.biz.app.visit.model.VisitVO;
import net.danvi.dmall.biz.system.util.InterfaceUtil;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Slf4j
@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = {"classpath:spring/context/context-datasource.xml"
    ,"classpath:spring/context/context-application.xml"
    ,"classpath:spring/context/context-security.xml"
        ,"classpath:spring/context/context-ehcache.xml"
     })

public class OrdRegTest extends BaseService {

    @Resource(name = "orderService")
    private OrderService orderService;


    @Test
    public void test() throws Exception {
        // MD확정일 경우 인터페이스 호출 (IF_ORD_001 : 발주등록)
        String[] ordNo = {
 "1905141308266759"
,"1905141413096761"
,"1905141534336762"
        };
        for (int i = 0; i < ordNo.length; i++) {
            OrderInfoVO orderInfoVo = new OrderInfoVO();
            orderInfoVo.setOrdNo(ordNo[i]);
            orderInfoVo.setSiteNo((long) 1);
            Long sellerNo = (long) 1;
            if (sellerNo != null && sellerNo > 0) {
                orderInfoVo.setSellerNo(String.valueOf(sellerNo));
            }

       /* if (CommonConstants.AUTH_GB_CD_ADMIN.equals(SessionDetailHelper.getSession().getAuthGbCd())) {
            sellerNo = null;
            orderInfoVo.setSellerNo(null);
        }*/
            /*HttpServletRequest request = HttpUtil.getHttpServletRequest();
            String referer = request.getHeader("referer");
            if (referer.indexOf("seller") > -1) {

            } else {
                sellerNo = null;
                orderInfoVo.setSellerNo(null);
            }*/

            OrderVO orderVo = orderService.selectOrdDtl(orderInfoVo);

            List<Map<String, Object>> ordDtlList = new ArrayList<>();
            List<Map<String, Object>> ordSellerDtlList = new ArrayList<>();

            if (sellerNo != null && sellerNo > 0) {
                // 실제 넘길 주문 상세 목록 조회(예약 전용이 아닌 셀러상품중 매장픽업 상품 목록 조회)
                ordDtlList = proxyDao.selectList(MapperConstants.ORDER_MANAGE + "selectOrdDtlListForInterface", orderInfoVo);
            } else {// seller 정보가 없을때
                // 실제 넘길 주문 상세 목록 조회(예약 전용이 아닌 다비치 상품 목록 조회)
                ordDtlList = proxyDao.selectList(MapperConstants.ORDER_MANAGE + "selectOrdDtlListForInterface", orderInfoVo);
                // 실제 넘길 주문 상세 목록 조회(예약 전용이 아닌 셀러상품중 매장픽업 상품 목록 조회)
                ordSellerDtlList = proxyDao.selectList(MapperConstants.ORDER_MANAGE + "selectSellerOrdDtlListForInterface", orderInfoVo);

            }

            Map<String, Object> param = new HashMap<>();
            //예약전용이 아닌 다비치 상품 & 셀러상품중 매장픽업 상품이 있을때만 인터페이스로 발주 정보 등록
            if (ordDtlList != null && ordDtlList.size() > 0) {

                param.put("orderNo", ordNo[i]);
                SimpleDateFormat transFormat = new SimpleDateFormat("yyyyMMdd");
                String orderDate = transFormat.format(orderVo.getOrderInfoVO().getOrdAcceptDttm());
                param.put("orderDate", orderDate);
                String payDate = transFormat.format(orderVo.getOrderInfoVO().getPaymentCmpltDttm());
                param.put("payDate", payDate);

                //주문번호에 해당하는 방문예약정보조회(매장코드)
                VisitVO visitVO = orderService.selectStrCode(orderInfoVo);
                String delivStrCode = "";
                String destType = "";
                if (visitVO != null && visitVO.getStoreNo() != null) {
                    delivStrCode = visitVO.getStoreNo();
                }

                if (sellerNo != null && !"".equals(sellerNo) && sellerNo > 1) {
                    destType = "3";    //셀러상품 매장픽업
                    param.put("venCode", "100000");
                } else {
                    if (!delivStrCode.equals("")) {
                        destType = "2";    //다비치상품 매장픽업
                    } else {
                        destType = "1";    //다비치상품 택배
                    }
                    param.put("venCode", "000000");
                }

                param.put("destType", destType);
                param.put("ordRute", destType);
                param.put("delivStrCode", delivStrCode);
                param.put("address1", orderVo.getOrderInfoVO().getRoadnmAddr());
                param.put("address2", orderVo.getOrderInfoVO().getDtlAddr());
                param.put("zipcode", orderVo.getOrderInfoVO().getPostNo());
                param.put("receiverName", orderVo.getOrderInfoVO().getAdrsNm());
                param.put("receiverHp", orderVo.getOrderInfoVO().getAdrsMobile());
                param.put("memNo", orderVo.getOrderInfoVO().getMemberNo());
                param.put("bigo", orderVo.getOrderInfoVO().getMemoContent());


                param.put("orderName", orderVo.getOrderInfoVO().getOrdrNm());
                param.put("orderHp", orderVo.getOrderInfoVO().getOrdrMobile());

                int dlvrAmt = 0;
                for (OrderGoodsVO orderGoodsVo : orderVo.getOrderGoodsVO()) {
                    dlvrAmt += Integer.parseInt(orderGoodsVo.getRealDlvrAmt());
                }
                param.put("dlvrAmt", dlvrAmt);
                param.put("ordDtlList", ordDtlList);

                List<Map<String, Object>> payList = new ArrayList<>();
                for (OrderPayVO payVo : orderVo.getOrderPayVO()) {
                    Map<String, Object> listParam = new HashMap<>();
                    listParam.put("payWayCd", payVo.getPaymentWayCd());
                    listParam.put("payWayNm", payVo.getPaymentWayNm());
                    listParam.put("payAmt", payVo.getPaymentAmt());
                    payList.add(listParam);
                }
                param.put("payList", payList);


                //쿠폰사용 주문내역 조회
                List<CouponVO> cpList = orderService.selectCouponList(orderInfoVo);

                List<Map<String, Object>> couponList = new ArrayList<>();
                for (CouponVO cpVo : cpList) {
                    Map<String, Object> listParam = new HashMap<>();
                    listParam.put("ordDtlSeq", cpVo.getOrdDtlSeq());
                    listParam.put("dcAmt", cpVo.getCpUseAmt());
                    listParam.put("dcCode", cpVo.getCouponKindCd());
                    listParam.put("dcName", cpVo.getCouponKindCdNm());
                    couponList.add(listParam);
                }
                param.put("couponList", couponList);

                Map<String, Object> ifresult = InterfaceUtil.send("IF_ORD_001", param);
                if ("1".equals(ifresult.get("result"))) {
                    System.out.println("성공!!!"+i+" 번째");
                } else {
                    throw new Exception(String.valueOf(ifresult.get("message")));
                }
            }
            //예약전용이 아닌 셀러상품중 매장픽업 이 있을때만 인터페이스로 발주 정보 등록
            if (ordSellerDtlList != null && ordSellerDtlList.size() > 0) {

                param.put("orderNo", ordNo[i]);
                SimpleDateFormat transFormat = new SimpleDateFormat("yyyyMMdd");
                String orderDate = transFormat.format(orderVo.getOrderInfoVO().getOrdAcceptDttm());
                param.put("orderDate", orderDate);
                String payDate = transFormat.format(orderVo.getOrderInfoVO().getPaymentCmpltDttm());
                param.put("payDate", payDate);

                //주문번호에 해당하는 방문예약정보조회(매장코드)
                VisitVO visitVO = orderService.selectStrCode(orderInfoVo);
                String delivStrCode = "";
                String destType = "3";
                if (visitVO != null && visitVO.getStoreNo() != null) {
                    delivStrCode = visitVO.getStoreNo();
                }

                param.put("venCode", "100000");
                param.put("destType", destType);
                param.put("ordRute", destType);
                param.put("delivStrCode", delivStrCode);
                param.put("address1", orderVo.getOrderInfoVO().getRoadnmAddr());
                param.put("address2", orderVo.getOrderInfoVO().getDtlAddr());
                param.put("zipcode", orderVo.getOrderInfoVO().getPostNo());
                param.put("receiverName", orderVo.getOrderInfoVO().getAdrsNm());
                param.put("receiverHp", orderVo.getOrderInfoVO().getAdrsMobile());
                param.put("memNo", orderVo.getOrderInfoVO().getMemberNo());
                param.put("bigo", orderVo.getOrderInfoVO().getMemoContent());


                param.put("orderName", orderVo.getOrderInfoVO().getOrdrNm());
                param.put("orderHp", orderVo.getOrderInfoVO().getOrdrMobile());

                int dlvrAmt = 0;
                for (OrderGoodsVO orderGoodsVo : orderVo.getOrderGoodsVO()) {
                    dlvrAmt += Integer.parseInt(orderGoodsVo.getRealDlvrAmt());
                }
                param.put("dlvrAmt", dlvrAmt);
                param.put("ordDtlList", ordSellerDtlList);

                List<Map<String, Object>> payList = new ArrayList<>();
                for (OrderPayVO payVo : orderVo.getOrderPayVO()) {
                    Map<String, Object> listParam = new HashMap<>();
                    listParam.put("payWayCd", payVo.getPaymentWayCd());
                    listParam.put("payWayNm", payVo.getPaymentWayNm());
                    listParam.put("payAmt", payVo.getPaymentAmt());
                    payList.add(listParam);
                }
                param.put("payList", payList);


                //쿠폰사용 주문내역 조회
                List<CouponVO> cpList = orderService.selectCouponList(orderInfoVo);

                List<Map<String, Object>> couponList = new ArrayList<>();
                for (CouponVO cpVo : cpList) {
                    Map<String, Object> listParam = new HashMap<>();
                    listParam.put("ordDtlSeq", cpVo.getOrdDtlSeq());
                    listParam.put("dcAmt", cpVo.getCpUseAmt());
                    listParam.put("dcCode", cpVo.getCouponKindCd());
                    listParam.put("dcName", cpVo.getCouponKindCdNm());
                    couponList.add(listParam);
                }
                param.put("couponList", couponList);

                Map<String, Object> ifresult = InterfaceUtil.send("IF_ORD_001", param);
                if ("1".equals(ifresult.get("result"))) {
                    System.out.println("성공!!!"+i+" 번째");
                } else {
                    throw new Exception(String.valueOf(ifresult.get("message")));
                }
            }

        }
    }
}