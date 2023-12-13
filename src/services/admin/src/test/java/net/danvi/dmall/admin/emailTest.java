package net.danvi.dmall.admin;

import dmall.framework.common.BaseService;
import dmall.framework.common.constants.MapperConstants;
import dmall.framework.common.exception.CustomException;
import dmall.framework.common.util.DateUtil;
import dmall.framework.common.util.StringUtil;
import lombok.extern.slf4j.Slf4j;
import net.danvi.dmall.biz.app.operation.model.EmailSendSO;
import net.danvi.dmall.biz.app.operation.model.ReplaceCdVO;
import net.danvi.dmall.biz.app.operation.service.EmailSendService;
import net.danvi.dmall.biz.app.operation.service.SmsSendService;
import net.danvi.dmall.biz.app.order.exchange.service.ExchangeService;
import net.danvi.dmall.biz.app.order.manage.model.ClaimGoodsVO;
import net.danvi.dmall.biz.app.order.manage.model.ClaimSO;
import net.danvi.dmall.biz.app.order.manage.model.OrderGoodsVO;
import net.danvi.dmall.biz.app.order.manage.model.OrderInfoVO;
import net.danvi.dmall.biz.app.order.payment.model.OrderPayVO;
import net.danvi.dmall.biz.app.setup.siteinfo.model.SiteVO;
import net.danvi.dmall.biz.system.security.SessionDetailHelper;
import net.danvi.dmall.biz.system.service.SiteService;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import javax.annotation.Resource;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.List;

@Slf4j
@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = {"classpath:spring/context/context-datasource.xml"
    ,"classpath:spring/context/context-application.xml"
    ,"classpath:spring/context/context-security.xml"
        ,"classpath:spring/context/context-ehcache.xml"
     })

public class emailTest extends BaseService {

    @Resource(name = "siteService")
    private SiteService siteService;

    @Resource(name = "exchangeService")
    private ExchangeService exchangeService;

    @Resource(name = "emailSendService")
    private EmailSendService emailSendService;

    @Resource(name = "smsSendService")
    private SmsSendService smsSendService;


    @Test
    public void test() throws Exception {
        /**
         * EMAIL (sendTypeCdEmail)
         * 회원가입 : 01
         * 회원탈퇴 : 02
         * 주문완료(상태코드:입금확인중) :05
         * 결제완료 : 06
         * 배송준비중 : 07
         * 배송중 : 08
         * 부분배송중 : 09
         * 부분배송완료 : 10
         * 배송완료 : 11
         * 교환신청 & 반품신청: 12
         * 주문무효 : 13
         * 반품완료 : 15
         * 결제취소 : 16
         * 결제실패 : 17
         */

        boolean result = false;
        OrderGoodsVO vo = new OrderGoodsVO();

        String sendTypeCd = "08";
        vo.setSiteNo((long) 1);
        vo.setOrdNo("1810221905113606");

        // 기본 정보
        OrderInfoVO tVO = new OrderInfoVO();
        tVO.setSiteNo((!StringUtil.isEmpty(vo.getSiteNo())) ? vo.getSiteNo() : SessionDetailHelper.getDetails().getSiteNo());
        tVO.setOrdNo(vo.getOrdNo());
        OrderInfoVO orderDtl = selectOrdDtlInfo(tVO);

        List<OrderGoodsVO> goodsList = selectOrdDtlList(tVO);
        // 결제 정보
        List<OrderPayVO> payVo = selectOrderPayInfoList(tVO);
        EmailSendSO sendSo = new EmailSendSO();
        /* 변경할 치환 코드 설정 */
        ReplaceCdVO replaceVO = new ReplaceCdVO();

            /* 이메일 자동 발송 기본 설정 */
            sendSo.setMailTypeCd(sendTypeCd); // ERD 메일 유형 코드 참조 ex)1:1문의 답변 코드 : 23
            sendSo.setSiteNo((!StringUtil.isEmpty(vo.getSiteNo())) ? vo.getSiteNo() : SessionDetailHelper.getDetails().getSiteNo());
            sendSo.setOrdNo(new Long(tVO.getOrdNo()));
            if (orderDtl.getMemberNo() != null) sendSo.setReceiverNo(new Long(orderDtl.getMemberNo()));
            sendSo.setReceiverId(orderDtl.getLoginId());
            sendSo.setReceiverNm(orderDtl.getOrdrNm());
            sendSo.setReceiverEmail("ksdch8@naver.com");
            // Set 해줘야 할 컬럼 : emailSendSo- receiverId, receiverNm, receiverEmail,
            // siteNo
            double dlvrAmt = 0;

            SiteVO siteVO = proxyDao.selectOne(MapperConstants.SETUP_SITE_INFO + "selectSiteInfo", tVO);
            siteVO.setDlgtDomain(siteVO.getDlgtDomain());

            replaceVO.setOrderNm(orderDtl.getOrdrNm());
            SimpleDateFormat transFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
            String orderDate = transFormat.format(orderDtl.getOrdAcceptDttm());
            replaceVO.setReqDate(orderDate);
            replaceVO.setOrderNo(orderDtl.getOrdNo());

            if (orderDtl.getOrdGoodsCnt() > 1) {
                orderDtl.setGoodsNm(orderDtl.getGoodsNm() + " 외 " + (orderDtl.getOrdGoodsCnt() - 1) + "건");
            }
            replaceVO.setOrderItem(orderDtl.getGoodsNm());

            String rlsCourierNm = "";
            String rlsInvoiceNo = "";
            int idx = 1;
            String comma = ",";
            for (OrderGoodsVO ordGoodsVo : goodsList) {
                rlsCourierNm += ordGoodsVo.getRlsCourierNm();
                rlsInvoiceNo += ordGoodsVo.getRlsInvoiceNo();
                if (idx < goodsList.size()) {
                    rlsCourierNm += comma;
                    rlsInvoiceNo += comma;
                }
                idx++;
            }
            replaceVO.setDeliveryCompany(rlsCourierNm);
            replaceVO.setDeliveryNumber(rlsInvoiceNo);

            replaceVO.setShopName(siteVO.getSiteNm());
            replaceVO.setCustCtEmail(siteVO.getCustCtEmail());
            replaceVO.setCustCtTelNo(siteVO.getCustCtTelNo());
            replaceVO.setDlgtDomain(siteVO.getDlgtDomain());
            replaceVO.setLogoPath(siteVO.getLogoPath());

            replaceVO.setMemberNm(orderDtl.getOrdrNm());
            replaceVO.setOrdEmail(orderDtl.getOrdrEmail()); // 이메일
            replaceVO.setOrdTel(orderDtl.getOrdrTel());
            replaceVO.setOrdMobile(orderDtl.getOrdrMobile());
            replaceVO.setOrdAdrsNm(orderDtl.getAdrsNm());
            replaceVO.setOrdAdrsTel(orderDtl.getAdrsTel());
            replaceVO.setOrdAdrsMobile(orderDtl.getAdrsMobile());
            replaceVO.setOrdRoadAddr(orderDtl.getRoadnmAddr());
            replaceVO.setOrdNumAddr(orderDtl.getNumAddr());
            replaceVO.setOrdDtlAddr(orderDtl.getDtlAddr());
            replaceVO.setOrdDlvrMsg(orderDtl.getDlvrMsg());
            replaceVO.setOrdSaleAmt(StringUtil.formatMoney(orderDtl.getSaleAmt() + ""));
            replaceVO.setOrdDcAmt(StringUtil.formatMoney(orderDtl.getDcAmt() + ""));
            replaceVO.setOrdSvmnAmt("0");
            for (OrderPayVO pvo : payVo) {
                if (pvo.getPaymentWayCd().equals("01")) // 마켓포인트
                    replaceVO.setOrdSvmnAmt(StringUtil.formatMoney(pvo.getPaymentAmt()));
                else
                    replaceVO.setOrdPaymentWayNm(pvo.getPaymentWayNm());
                if (pvo.getPaymentWayCd().equals("11") || pvo.getPaymentWayCd().equals("22")) {// 가상계좌,  무통장
                    replaceVO.setOrdBankNm(pvo.getBankNm()); // 입금은행명
                    replaceVO.setOrdBankAccntNm(pvo.getDpsterNm()); // 입금자명
                    replaceVO.setOrdBankAccntNo(pvo.getActNo()); // 입금은행 계좌

                    replaceVO.setSettleprice(StringUtil.formatMoney((long) (new Double(pvo.getPaymentAmt())).doubleValue() + ""));
                    String today = DateUtil.getNowDate();
                    replaceVO.setDormancyDuDate(StringUtil.formatDate(DateUtil.addDays(today, 5)));
                    replaceVO.setOrdClaimBankNm(pvo.getBankNm());
                    replaceVO.setOrdClaimAccntNo(pvo.getActNo());
                    replaceVO.setOrdClaimAccntNm(pvo.getDpsterNm());

                }
            }
            replaceVO.setOrdPayAmt(StringUtil.formatMoney((long) (new Double(orderDtl.getPaymentAmt())).doubleValue() + ""));

            // replaceVO.setOrdClaimReason();
            // replaceVO.setOrdClaimDtlReason();
            // replaceVO.setOrdClaimAmt();
            // replaceVO.setOrdClaimCmpltDttm();
            // replaceVO.setOrdClaimSvmnAmt();
            // replaceVO.setOrdClaimRefundWay();
            StringBuffer itemBuf = new StringBuffer();
            int rownum = 1;
            itemBuf.append("<table class=\"basic3\" style=\"width:100%;border-collapse:collapse;margin-bottom:30px;font-size:12px;border-top:1px solid #dddddd;\">");
            itemBuf.append("<tr>");
            itemBuf.append("    <th colspan=\"3\" style=\"padding:15px 0;text-align:center;border-bottom:1px solid #dddddd;background-color:#f9f9f9;\">");
            itemBuf.append("        상품명");
            itemBuf.append("    </th>");
            if (!"12".equals(sendTypeCd) && !"14".equals(sendTypeCd) && !"15".equals(sendTypeCd)) {
                itemBuf.append("    <th style=\"padding:15px 0;text-align:center;border-bottom:1px solid #dddddd;background-color:#f9f9f9;\">");
                itemBuf.append("        수량");
                itemBuf.append("    </th>");
            } else {
                itemBuf.append("    <th style=\"padding:15px 0;text-align:center;border-bottom:1px solid #dddddd;background-color:#f9f9f9;\">");
                itemBuf.append("    주문수량/<br>");
                itemBuf.append("    요청수량");
                itemBuf.append("    </th>");
            }
            itemBuf.append("    <th style=\"padding:15px 0;text-align:center;border-bottom:1px solid #dddddd;background-color:#f9f9f9;\">");
            itemBuf.append("        상품금액");
            itemBuf.append("    </th>");
            /*
             * 교환/환불 신청 : 12
             * 결제취소환불완료 : 14
             * 반품환불완료 : 15
             */
            if (!"12".equals(sendTypeCd) && !"14".equals(sendTypeCd) && !"15".equals(sendTypeCd)) {
                itemBuf.append("    <th style=\"padding:15px 0;text-align:center;border-bottom:1px solid #dddddd;background-color:#f9f9f9;\">");
                itemBuf.append("        배송비");
                itemBuf.append("    </th>");
            }
            // 주문 상태
            if ("08".equals(sendTypeCd) || "09".equals(sendTypeCd) || "10".equals(sendTypeCd) || "11".equals(sendTypeCd)
                    || "12".equals(sendTypeCd) || "14".equals(sendTypeCd) || "15".equals(sendTypeCd)
                    || "16".equals(sendTypeCd)) {
                itemBuf.append("    <th style=\"padding:15px 0;text-align:center;border-bottom:1px solid #dddddd;background-color:#f9f9f9;\">");
                itemBuf.append("        주문/배송상태");
            }
            itemBuf.append("</tr>");
            if ("12".equals(sendTypeCd) || "14".equals(sendTypeCd) || "15".equals(sendTypeCd)) {
                itemBuf.append("    <tr>");
                itemBuf.append("        <td colspan=\"6\" style=\"width:100%;text-align:left;padding:15px 10px;border-bottom:1px solid #dddddd;\">");
                itemBuf.append("            <strong>배송지</strong><br>");
                itemBuf.append("             (" + orderDtl.getPostNo() + ")" + orderDtl.getRoadnmAddr() == "" ? orderDtl.getNumAddr() : orderDtl.getRoadnmAddr() + " " + orderDtl.getDtlAddr() + "<br>");
                itemBuf.append("             " + orderDtl.getAdrsNm() + " / " + orderDtl.getAdrsMobile() + " / " + orderDtl.getAdrsTel());
                itemBuf.append("        </td>");
                itemBuf.append("    </tr>");
            }
            for (OrderGoodsVO goodVo : goodsList) {
                itemBuf.append("<tr>");
                itemBuf.append("   <td style=\"width:50px;pappending:15px 10px;text-align:center;border-bottom:1px solid #dddddd;\">");
                if ("N".equals(goodVo.getAddOptYn())) { // 추가옵션 아닐때
                    itemBuf.append("    " + rownum);
                    rownum++;
                } else {
                    itemBuf.append("    <img src=\"http://" + siteVO.getDlgtDomain() + "/admin/img/email/icon_addition.png\" alt=\"추가상품\" style=\"border:0;\">");
                }

                itemBuf.append("    </td>");
                itemBuf.append("    <td style=\"padding:15px 10px;text-align:center;border-bottom:1px solid #dddddd;\">");
                itemBuf.append("    <img src=\"http://" + siteVO.getDlgtDomain() + goodVo.getImgPath() + "\" alt=\"\" style=\"border:0;\">");
                itemBuf.append("    </td>");
                itemBuf.append("    <td class=\"tal\" style=\"width:150px;padding:15px 10px;text-align:left;border-bottom:1px solid #dddddd;\">");
                itemBuf.append("    <a href=\"http://" + siteVO.getDlgtDomain() + "/front/goods/goods-detail?goodsNo=" + goodVo.getGoodsNo() + "\" class=\"goods_txt\">");
                itemBuf.append(goodVo.getGoodsNm() + "<br>");
                if ("Y".equals(goodVo.getAddOptYn())) { // 추가옵션
                    itemBuf.append("</a>");
                } else {
                    if (goodVo.getItemNm() != null && !"".equals(goodVo.getItemNm())) {
                        itemBuf.append("    [기본옵션:");
                        itemBuf.append("    " + goodVo.getItemNm() == null ? "" : goodVo.getItemNm());
                        itemBuf.append("    ]><br>");
                        // itemBuf.append(" <span class=\"code\">[상품코드 : " +
                        // goodVo.getGoodsNo() + "]</span>");
                    }
                    if (goodVo.getFreebieNm() != null && !"".equals(goodVo.getFreebieNm())) {
                        itemBuf.append("    [사은품:");
                        itemBuf.append(goodVo.getFreebieNm() == null ? "" : goodVo.getFreebieNm());
                        itemBuf.append("    ]");
                    }
                    itemBuf.append("</a>");
                }
                itemBuf.append("    </td>");
                itemBuf.append("   <td style=\"padding:15px 10px;text-align:center;border-bottom:1px solid #dddddd;\">");
                if (!"12".equals(sendTypeCd) && !"14".equals(sendTypeCd) && !"15".equals(sendTypeCd)) {
                    itemBuf.append("     " + goodVo.getOrdQtt());
                } else {
                    itemBuf.append("     " + goodVo.getOrdQtt() + "<br>");
                    itemBuf.append("    <span class=\"point1\" style=\"color:red;\">(-" + goodVo.getOrdQtt() + ")</span>");
                }
                itemBuf.append("   </td>");
                itemBuf.append("   <td style=\"padding:15px 10px;text-align:center;border-bottom:1px solid #dddddd;\">");
                itemBuf.append("     " + StringUtil.formatMoney((long) (new Double(goodVo.getPaymentAmt()).doubleValue()) + "") + "원");
                itemBuf.append("   </td>");
                try {
                    if (!"12".equals(sendTypeCd) && !"14".equals(sendTypeCd) && !"15".equals(sendTypeCd)) {
                        if ("N".equals(goodVo.getAddOptYn()) && !"0".equals(goodVo.getDlvrcCnt())) {
                            itemBuf.append("   <td rowspan=\"" + goodVo.getDlvrcCnt() + "\" style=\"padding:15px 10px;text-align:center;border-bottom:1px solid #dddddd;\">");
                            if (!"0".equals(goodVo.getAreaAddDlvrc())) {
                                itemBuf.append("   선불<br>");
                            } else {
                                itemBuf.append(goodVo.getDlvrcPaymentNm() + "<br>");
                            }
                            double amt1 = new Double(goodVo.getRealDlvrAmt());
                            double amt2 = new Double(goodVo.getAreaAddDlvrc());

                            if ((amt1 + amt2) > 0) {
                                itemBuf.append(StringUtil.formatMoney((long) (amt1 + amt2) + ""));
                            }
                            itemBuf.append("   </td>");
                        }
                    }
                    // 배송비 계산
                    if ("N".equals(goodVo.getAddOptYn()) && !"0".equals(goodVo.getDlvrcCnt())) {
                        double amt1 = new Double(goodVo.getRealDlvrAmt());
                        double amt2 = new Double(goodVo.getAreaAddDlvrc());
                        dlvrAmt = dlvrAmt + amt1 + amt2;
                    }
                } catch (Exception e) {
                    log.debug("{}", e.getMessage());
                }

                /*
                 * 교환/환불 신청 : 12
                 * 결제취소환불완료 : 14
                 * 반품환불완료 : 15
                 */
                if ("12".equals(sendTypeCd) || "14".equals(sendTypeCd) || "15".equals(sendTypeCd)) {
                    // 클레임 정보 조회
                    ClaimSO so = new ClaimSO();
                    so.setOrdNo(goodVo.getOrdNo());
                    so.setOrdDtlSeq(goodVo.getOrdDtlSeq());
                    ClaimGoodsVO claimVo = proxyDao.selectOne(MapperConstants.ORDER_EXCHANGE + "selectOrdDtlExchange", so);
                    if (claimVo != null) {
                        replaceVO.setOrdClaimReason(claimVo.getClaimReasonNm());
                        replaceVO.setOrdClaimDtlReason(claimVo.getClaimDtlReason());
                        Calendar caldate = Calendar.getInstance();
                        caldate.setTime(claimVo.getClaimAcceptDttm());
                        replaceVO.setReqDate(DateUtil.getFormatDate(caldate, "yyyy-MM-dd HH:mm:ss"));
                    }

                }
                // 주문 상태
                if ("08".equals(sendTypeCd) || "09".equals(sendTypeCd) || "10".equals(sendTypeCd)
                        || "11".equals(sendTypeCd) || "12".equals(sendTypeCd) || "14".equals(sendTypeCd)
                        || "15".equals(sendTypeCd) || "16".equals(sendTypeCd)) {
                    itemBuf.append("   <td style=\"padding:15px 10px;text-align:center;border-bottom:1px solid #dddddd;\">");
                    itemBuf.append("     " + goodVo.getOrdDtlStatusNm());
                    itemBuf.append("   </td>");
                }
                itemBuf.append("   </tr>");
            }
            replaceVO.setOrdDlvrAmt(StringUtil.formatMoney((long) dlvrAmt + "")); // 배송비
            itemBuf.append("</table>");
            replaceVO.setOrderItemList(itemBuf.toString());
            // return "true";
            result = emailSendService.emailAutoSend(sendSo, replaceVO);

    }

    public OrderInfoVO selectOrdDtlInfo (OrderInfoVO vo){
        return proxyDao.selectOne(MapperConstants.ORDER_MANAGE + "selectOrdDtlInfo", vo);
    }

    public List<OrderPayVO> selectOrderPayInfoList(OrderInfoVO vo) {
        return proxyDao.selectList(MapperConstants.ORDER_MANAGE + "selectOrdDtlPayInfo", vo);
    }

    public List<OrderGoodsVO> selectOrdDtlList(OrderInfoVO vo) throws CustomException {
        return proxyDao.selectList(MapperConstants.ORDER_MANAGE + "selectOrdDtlList", vo);
    }
}