package net.danvi.dmall.admin;

import dmall.framework.common.BaseService;
import dmall.framework.common.constants.MapperConstants;
import dmall.framework.common.exception.CustomException;
import dmall.framework.common.model.ResultListModel;
import dmall.framework.common.util.DateUtil;
import dmall.framework.common.util.StringUtil;
import lombok.extern.slf4j.Slf4j;
import net.danvi.dmall.biz.app.operation.model.ReplaceCdVO;
import net.danvi.dmall.biz.app.operation.model.SmsSendSO;
import net.danvi.dmall.biz.app.operation.service.EmailSendService;
import net.danvi.dmall.biz.app.operation.service.SmsSendService;
import net.danvi.dmall.biz.app.order.exchange.service.ExchangeService;
import net.danvi.dmall.biz.app.order.manage.model.ClaimGoodsVO;
import net.danvi.dmall.biz.app.order.manage.model.ClaimSO;
import net.danvi.dmall.biz.app.order.manage.model.OrderGoodsVO;
import net.danvi.dmall.biz.app.order.manage.model.OrderInfoVO;
import net.danvi.dmall.biz.app.order.payment.model.OrderPayVO;
import net.danvi.dmall.biz.system.model.SiteCacheVO;
import net.danvi.dmall.biz.system.security.SessionDetailHelper;
import net.danvi.dmall.biz.system.service.SiteService;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import javax.annotation.Resource;
import java.util.Calendar;
import java.util.List;

import static org.junit.Assert.*;

@Slf4j
@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = {"classpath:spring/context/context-datasource.xml"
    ,"classpath:spring/context/context-application.xml"
    ,"classpath:spring/context/context-security.xml"
        ,"classpath:spring/context/context-ehcache.xml"
     })

public class smsTestTest extends BaseService {

    @Resource(name = "siteService")
    private SiteService siteService;

    @Resource(name = "exchangeService")
    private ExchangeService exchangeService;

    @Resource(name = "emailSendService")
    private EmailSendService emailSendService;

    @Resource(name = "smsSendService")
    private SmsSendService smsSendService;



    @Test
    public void test() throws Exception{
        /**
         * SMS (sendTypeCdSms)
         * 회원가입 : 01
         * 회원탈퇴 : 02
         * 주문완료(상태코드:입금확인중) :03
         * 결제완료 : 04 mk001
         * 배송준비중 : 05
         * 배송중 : 06
         * 부분배송중 : 07
         * 부분배송완료 : 08
         * 배송완료 : 09 mk002
         * 결제취소 : 10 mk003
         * 주문취소 : 11
         * 교환신청 & 반품신청: 12
         * 주문무효 : 13
         * 결제실패 : 14
         * 반품완료 :    mk004
         * 상품문의 등록: 15
         * 상품문의 답변 등록: 16
         * 1:1문의 등록 : 19
         * 1:1문의 답변등록 : 20
         * 방문예약 접수시 : 21
         * 방문예약일 사전안내 : 22
         * 멤버쉽통합완료시 : 23
         * 오프라인쿠폰발행시 : 24
         * *********************************
         * kakao templete code (templateCode)
         * 오프라인쿠폰발행시    mk008
         * 멤버쉽통합완료시      mk007
         * 방문예약일 사전안내   mk006
         * 방문예약 접수시       mk005
         * 반품상품환불완료시    mk004
         * 결제취소환불완료시    mk003
         * 배송완료시(발송처리)  mk002
         * 결제완료시            mk001
         * *********************************
         */

        OrderGoodsVO vo = new OrderGoodsVO();
        SmsSendSO sendSo = new SmsSendSO();
        ReplaceCdVO replaceVO = new ReplaceCdVO();

        String sendTypeCd="04";
        String templateCode ="mk001";
        vo.setSiteNo((long) 1);
        vo.setOrdNo("1810221905113606");

        try {
            // 기본 정보
            OrderInfoVO orderInfoVo = new OrderInfoVO();
            orderInfoVo.setSiteNo(vo.getSiteNo());
            orderInfoVo.setOrdNo(vo.getOrdNo());
            OrderInfoVO orderDtl = selectOrdDtlInfo(orderInfoVo);
            List<OrderGoodsVO> goodsList = selectOrdDtlList(orderInfoVo);
            // 결제 정보
            List<OrderPayVO> payVo = selectOrderPayInfoList(orderInfoVo);

            sendSo.setTemplateCode(templateCode);
            sendSo.setSendTypeCd(sendTypeCd); //
            sendSo.setMemberNo(1000);
            sendSo.setSiteNo((long) 1);
            sendSo.setRecvTelno(orderDtl.getOrdrMobile());
            sendSo.setReceiverNm(orderDtl.getOrdrNm());
            sendSo.setReceiverId(orderDtl.getLoginId());
            // Set 해줘야 할 컬럼 : smsSendSo - receiverId, receiverNm, recvTelno,
            // siteNo.
            SiteCacheVO siteVO = siteService.getSiteInfo((!StringUtil.isEmpty(vo.getSiteNo())) ? vo.getSiteNo(): SessionDetailHelper.getDetails().getSiteNo());

            replaceVO.setSiteNo(vo.getSiteNo());
            replaceVO.setSiteNm(siteVO.getSiteNm());
            replaceVO.setSiteDomain(siteVO.getDlgtDomain());

            replaceVO.setOrderNm(orderDtl.getOrdrNm());
            replaceVO.setOrderNo(orderDtl.getOrdNo());

            String rlsCourierNm = "";
            String rlsInvoiceNo = "";
            int idx = 1;
            String comma=",";
            for(OrderGoodsVO ordGoodsVo : goodsList){
                if((ordGoodsVo.getRlsCourierNm()!=null && !ordGoodsVo.getRlsCourierNm().equals("")) &&
                        (ordGoodsVo.getRlsInvoiceNo()!=null && !ordGoodsVo.getRlsInvoiceNo().equals(""))) {
                    rlsCourierNm += ordGoodsVo.getRlsCourierNm();
                    rlsInvoiceNo += ordGoodsVo.getRlsCourierNm()+":"+ordGoodsVo.getRlsInvoiceNo();
                    if (idx < goodsList.size()) {
                        rlsCourierNm += comma;
                        rlsInvoiceNo += "\\\n  ";
                    }
                }
                idx++;
            }
            replaceVO.setDeliveryCompany(rlsCourierNm);
            replaceVO.setDeliveryNumber(rlsInvoiceNo);

            if(orderDtl.getOrdGoodsCnt()>1){
                orderDtl.setGoodsNm(orderDtl.getGoodsNm()+" 외 "+(orderDtl.getOrdGoodsCnt()-1)+"건");
            }

            replaceVO.setOrderItem(orderDtl.getGoodsNm());

            for (OrderPayVO pvo : payVo) {
                if (pvo.getPaymentWayCd().equals("01")) // 마켓포인트
                    replaceVO.setOrdSvmnAmt(pvo.getPaymentAmt());
                if (pvo.getPaymentWayCd().equals("11") || pvo.getPaymentWayCd().equals("22")) {// 가상계좌,무통장
                    replaceVO.setOrdBankNm(pvo.getBankNm()); // 입금은행명
                    replaceVO.setOrdBankAccntNm(pvo.getDpsterNm()); // 입금자명
                    replaceVO.setOrdBankAccntNo(pvo.getActNo()); // 입금은행 계좌
                    replaceVO.setOrdPayAmt(pvo.getPaymentAmt());
                    replaceVO.setSettleprice(StringUtil.formatMoney((long) (new Double(pvo.getPaymentAmt())).doubleValue() + ""));
                }
            }
            replaceVO.setOrdPayAmt(StringUtil.formatMoney((long) (new Double(orderDtl.getPaymentAmt())).doubleValue() + ""));

            if ("11".equals(sendTypeCd) || "12".equals(sendTypeCd)) {
                ClaimSO so = new ClaimSO();
                so.setOrdNo(vo.getOrdNo());
                ResultListModel<ClaimGoodsVO> cvoList = exchangeService.selectOrdDtlExchange(so);
                List<ClaimGoodsVO> list = cvoList.getResultList();
                for (ClaimGoodsVO cvo : list) {
                    if (cvo.getClaimAcceptDttm() != null && !"".equals(cvo.getClaimAcceptDttm())) {
                        Calendar caldate = Calendar.getInstance();
                        caldate.setTime(cvo.getClaimAcceptDttm());
                        replaceVO.setReqDate(DateUtil.getFormatDate(caldate, "yyyy-MM-dd"));
                    }
                }
            }
        } catch (Exception e) {
            log.debug("{}", e.getMessage());
        }

         smsSendService.sendAutoSms(sendSo, replaceVO);

    }

    public OrderInfoVO selectOrdDtlInfo(OrderInfoVO vo) {
        return proxyDao.selectOne(MapperConstants.ORDER_MANAGE + "selectOrdDtlInfo", vo);
    }

    public List<OrderPayVO> selectOrderPayInfoList(OrderInfoVO vo) {
        return proxyDao.selectList(MapperConstants.ORDER_MANAGE + "selectOrdDtlPayInfo", vo);
    }
    public List<OrderGoodsVO> selectOrdDtlList(OrderInfoVO vo) throws CustomException {
        return proxyDao.selectList(MapperConstants.ORDER_MANAGE + "selectOrdDtlList", vo);
    }


     @Test
    public void memberIntegration() throws Exception{

        // 멤버쉽 통합 SMS 발송
        SmsSendSO smsSendSo = new SmsSendSO();
        smsSendSo.setTemplateCode("mk007");
        smsSendSo.setSendTypeCd("23");

    //z4vOgjgP7SsU8LO13at6jw==
        smsSendSo.setReceiverId("kt_814071341");
        smsSendSo.setReceiverNm("김동엽");
        smsSendSo.setRecvTelno("01033278598");
        smsSendSo.setSiteNo(Long.valueOf(1));
        smsSendSo.setMemberNo(1419);

        ReplaceCdVO smsReplaceVO = new ReplaceCdVO();

        smsReplaceVO.setMemberNm("김동엽");

        smsSendService.sendAutoSms(smsSendSo, smsReplaceVO);

     }

    @Test
    public void visitRsv() throws Exception{

        // 멤버쉽 통합 SMS 발송
        SmsSendSO smsSendSo = new SmsSendSO();
        smsSendSo.setTemplateCode("mk005");
        smsSendSo.setSendTypeCd("21");

    //z4vOgjgP7SsU8LO13at6jw==
        smsSendSo.setReceiverId("kt_814071341");
        smsSendSo.setReceiverNm("김동엽");
        smsSendSo.setRecvTelno("01033278598");
        smsSendSo.setSiteNo(Long.valueOf(1));
        smsSendSo.setMemberNo(1419);

        ReplaceCdVO smsReplaceVO = new ReplaceCdVO();

        //방문매장
        smsReplaceVO.setStoreNm("명동점");
        //방문일시
        String rsvtime = StringUtil.nvl("1500");
        if(!rsvtime.equals("") && rsvtime.length()==4) {
            rsvtime = rsvtime.substring(0, 2) + ":" + rsvtime.substring(2, 4);
        }else{
            rsvtime ="";
        }
        smsReplaceVO.setRsvTime(rsvtime);
        smsReplaceVO.setRsvDate("2018-12-25" + " " + rsvtime);
        //문의
        smsReplaceVO.setReqMatr("요청사항입니다.");
        smsReplaceVO.setMemberNm("김동엽");

        smsSendService.sendAutoSms(smsSendSo, smsReplaceVO);

     }

      @Test
    public void visitRsvInfo() throws Exception{

        // 멤버쉽 통합 SMS 발송
        SmsSendSO smsSendSo = new SmsSendSO();
        smsSendSo.setTemplateCode("mk006");
        smsSendSo.setSendTypeCd("22");

    //z4vOgjgP7SsU8LO13at6jw==
        smsSendSo.setReceiverId("kt_814071341");
        smsSendSo.setReceiverNm("김동엽");
        smsSendSo.setRecvTelno("01033278598");
        smsSendSo.setSiteNo(Long.valueOf(1));
        smsSendSo.setMemberNo(1419);

        ReplaceCdVO smsReplaceVO = new ReplaceCdVO();

        //방문매장
        smsReplaceVO.setStoreNm("명동점");
        //방문일시
        String rsvtime = StringUtil.nvl("1500");
        if(!rsvtime.equals("") && rsvtime.length()==4) {
            rsvtime = rsvtime.substring(0, 2) + ":" + rsvtime.substring(2, 4);
        }else{
            rsvtime ="";
        }
        smsReplaceVO.setRsvTime(rsvtime);
        smsReplaceVO.setRsvDate("2018-12-25" + " " + rsvtime);
        //문의
        smsReplaceVO.setReqMatr("요청사항입니다.");
        smsReplaceVO.setMemberNm("김동엽");

        smsSendService.sendAutoSms(smsSendSo, smsReplaceVO);

     }

        @Test
    public void offlineCouponIssue() throws Exception{

        // 오프라인 쿠폰발행
        SmsSendSO smsSendSo = new SmsSendSO();
        smsSendSo.setTemplateCode("mk008");
        smsSendSo.setSendTypeCd("24");

        //z4vOgjgP7SsU8LO13at6jw==
        smsSendSo.setReceiverId("kt_814071341");
        smsSendSo.setReceiverNm("김동엽");
        smsSendSo.setRecvTelno("01033278598");
        smsSendSo.setSiteNo(Long.valueOf(1));
        smsSendSo.setMemberNo(1419);

        ReplaceCdVO smsReplaceVO = new ReplaceCdVO();
        //쿠폰번호
        smsReplaceVO.setCouponNo(222);

        //쿠폰명
        smsReplaceVO.setCouponNm("오프라인쿠폰");
        //사용기한
        smsReplaceVO.setApplyEndDttm("2018-12-25");


        smsSendService.sendAutoSms(smsSendSo, smsReplaceVO);

     }




}