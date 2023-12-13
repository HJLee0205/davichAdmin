package net.danvi.dmall.biz.app.visit.service;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import com.fasterxml.jackson.databind.ObjectMapper;
import net.danvi.dmall.biz.ifapi.cmmn.CustomIfException;
import net.danvi.dmall.biz.ifapi.cmmn.constant.Constants;
import net.danvi.dmall.biz.ifapi.cmmn.service.LogService;
import net.danvi.dmall.biz.ifapi.rsv.dto.StoreVisitReserveCancelReqDTO;
import net.danvi.dmall.biz.ifapi.rsv.dto.StoreVisitReserveCancelResDTO;
import net.danvi.dmall.biz.ifapi.rsv.service.ReserveService;
import net.sf.json.JSONObject;
import org.apache.commons.lang.StringUtils;
import org.springframework.beans.BeanUtils;
import org.springframework.dao.DuplicateKeyException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import dmall.framework.common.BaseService;
import dmall.framework.common.constants.MapperConstants;
import dmall.framework.common.dao.ProxyErpDao;
import dmall.framework.common.exception.CustomException;
import dmall.framework.common.model.ResultListModel;
import dmall.framework.common.model.ResultModel;
import dmall.framework.common.util.MessageUtil;
import dmall.framework.common.util.StringUtil;
import lombok.extern.slf4j.Slf4j;
import net.danvi.dmall.biz.app.basket.model.BasketPO;
import net.danvi.dmall.biz.app.basket.model.BasketSO;
import net.danvi.dmall.biz.app.basket.model.BasketVO;
import net.danvi.dmall.biz.app.basket.service.FrontBasketService;
import net.danvi.dmall.biz.app.goods.model.GoodsAddOptionDtlVO;
import net.danvi.dmall.biz.app.goods.model.GoodsDetailSO;
import net.danvi.dmall.biz.app.member.manage.model.MemberManageSO;
import net.danvi.dmall.biz.app.member.manage.model.MemberManageVO;
import net.danvi.dmall.biz.app.member.manage.service.MemberManageService;
import net.danvi.dmall.biz.app.operation.model.ReplaceCdVO;
import net.danvi.dmall.biz.app.operation.model.SmsSendSO;
import net.danvi.dmall.biz.app.operation.service.SmsSendService;
import net.danvi.dmall.biz.app.order.manage.model.OrderGoodsPO;
import net.danvi.dmall.biz.app.order.manage.model.OrderGoodsVO;
import net.danvi.dmall.biz.app.order.manage.model.OrderPO;
import net.danvi.dmall.biz.app.order.manage.model.OrderVO;
import net.danvi.dmall.biz.app.order.manage.service.OrderService;
import net.danvi.dmall.biz.app.promotion.coupon.model.CouponPO;
import net.danvi.dmall.biz.app.promotion.coupon.model.CouponSO;
import net.danvi.dmall.biz.app.promotion.coupon.service.CouponService;
import net.danvi.dmall.biz.app.promotion.exhibition.model.ExhibitionSO;
import net.danvi.dmall.biz.app.promotion.exhibition.model.ExhibitionVO;
import net.danvi.dmall.biz.app.promotion.exhibition.service.ExhibitionService;
import net.danvi.dmall.biz.app.setup.siteinfo.service.SiteInfoService;
import net.danvi.dmall.biz.app.visit.model.VisitSO;
import net.danvi.dmall.biz.app.visit.model.VisitVO;
import net.danvi.dmall.biz.system.security.SessionDetailHelper;
import net.danvi.dmall.biz.system.util.InterfaceUtil;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2018. 7. 11.
 * 작성자     : khy
 * 설명       : 방문예약내역
 * </pre>
 */
@Slf4j
@Service("visitRsvService")
@Transactional(rollbackFor = Exception.class)
public class VisitRsvServiceImpl extends BaseService implements VisitRsvService {

    @Resource(name = "siteInfoService")
    private SiteInfoService siteInfoService;

    @Resource(name = "orderService")
    private OrderService orderService;

    @Resource(name = "memberManageService")
    private MemberManageService memberManageService;

    @Resource(name = "exhibitionService")
    private ExhibitionService exhibitionService;

    @Resource(name = "frontBasketService")
    private FrontBasketService frontBasketService;

    @Resource(name = "couponService")
    private CouponService couponService;

    @Resource(name = "smsSendService")
    private SmsSendService smsSendService;

    @Resource(name = "proxyErpDao")
    private ProxyErpDao proxyErpDao;

    @Resource(name = "logService")
    private LogService logService;

    @Resource(name = "reserveService")
    private ReserveService reserveService;
    /**
     * <pre>
     * 작성일 : 2018. 7. .
     * 작성자 : khy
     * 설명   : 방문예약 목록
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2018. 7. . khy - 최초생성
     * </pre>
     *
     * @return
     */
    public ResultListModel<VisitVO> selectVisitList(VisitSO visitSO) {

//        if (visitSO.getSidx().length() == 0) {
//        	visitSO.setSidx("RSV_DATE, RSV_TIME");
//        	visitSO.setSord("ASC, ASC");
//        }        

        return proxyDao.selectListPage(MapperConstants.VISIT_RSV + "selectVisitPaging", visitSO);
    }


    /**
     * <pre>
     * 작성일 : 2018. 7. .
     * 작성자 : khy
     * 설명   : 방문예약 정보
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2018. 7. . khy - 최초생성
     * </pre>
     *
     * @return
     */
    public VisitVO selectVisitDtl(VisitSO visitSO) {
        return proxyDao.selectOne(MapperConstants.VISIT_RSV + "selectVisitDtl", visitSO);
    }

    /**
     * <pre>
     * 작성일 : 2018. 7. .
     * 작성자 : khy
     * 설명   : 방문예약 상세 목록 (방문예약 상품목록)
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2018. 7. . khy - 최초생성
     * </pre>
     *
     * @return
     */
    public List<VisitVO> selectVisitDtlList(VisitSO visitSO) {
        return proxyDao.selectList(MapperConstants.VISIT_RSV + "selectVisitDtlList", visitSO);
    }

    /**
     * <pre>
     * 작성일 : 2018. 7. .
     * 작성자 : khy
     * 설명   : 방문예약 상세 옵션 목록 (방문예약 상품 옵션 목록)
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2018. 7. . khy - 최초생성
     * </pre>
     *
     * @return
     */
    public List<VisitVO> selectVisitAddOptionList(VisitSO visitSO) {
        return proxyDao.selectList(MapperConstants.VISIT_RSV + "selectVisitAddOptionList", visitSO);
    }

    /**
     * <pre>
     * 작성일 : 2018. 7. .
     * 작성자 : khy
     * 설명   : 주문에서 방문예약 했는지 여부 조회
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2018. 7. . khy - 최초생성
     * </pre>
     *
     * @return
     */
    public Integer selectExistOrd(VisitSO visitSO) {
        return proxyDao.selectOne(MapperConstants.VISIT_RSV + "selectExistOrd", visitSO);
    }

    /**
     * <pre>
     * 작성일 : 2018. 7. .
     * 작성자 : khy
     * 설명   : 방문예약 취소
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2018. 7. . khy - 최초생성
     * </pre>
     *
     * @return
     */
    public int updateRsvCancel(VisitSO visitSO) throws Exception  {

        Map<String, Object> param = new HashMap<>();
        param.put("mallRsvNo", visitSO.getRsvNo());

        ifCancelErpStoreVisitReservation(param); // interface_block_temp
        /*Map<String, Object> res = InterfaceUtil.send("IF_RSV_003", param);

        if ("1".equals(res.get("result"))) {
        }else{
            throw new Exception(String.valueOf(res.get("message")));
        }*/

        //방문예약취소 SMS /알림톡 발송
        try {
            VisitVO visitVo = this.selectVisitDtl(visitSO);
            SmsSendSO smsSendSo = new SmsSendSO();
            smsSendSo.setTemplateCode("mk012");
            smsSendSo.setSendTypeCd("25");

            smsSendSo.setReceiverId(SessionDetailHelper.getDetails().getSession().getLoginId());
            smsSendSo.setReceiverNm(SessionDetailHelper.getDetails().getSession().getMemberNm());
            smsSendSo.setRecvTelno(SessionDetailHelper.getDetails().getSession().getMobile());
            smsSendSo.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
            smsSendSo.setMemberNo(SessionDetailHelper.getDetails().getSession().getMemberNo());

            smsSendSo.setStoreNo(visitVo.getStoreNo());

            ReplaceCdVO smsReplaceVO = new ReplaceCdVO();
            //방문매장
            smsReplaceVO.setStoreNm(visitVo.getStoreNm());
            //방문일시
            String rsvtime = StringUtil.nvl(visitVo.getRsvTime());
            if(!rsvtime.equals("") && rsvtime.length()==4) {
                rsvtime = rsvtime.substring(0,2) + ":" + rsvtime.substring(2,4);
            }else{
                rsvtime ="";
            }
            smsReplaceVO.setRsvTime(rsvtime);
//        smsReplaceVO.setRsvDate(visitVo.getRsvDate() + " " + rsvtime);
            smsReplaceVO.setRsvDate(visitVo.getStrVisitDate());
            //문의
            smsReplaceVO.setReqMatr(visitVo.getReqMatr());
            smsReplaceVO.setMemberNm(SessionDetailHelper.getDetails().getSession().getMemberNm());
            smsReplaceVO.setRsvName(SessionDetailHelper.getDetails().getSession().getMemberNm());
            smsReplaceVO.setRsvGubun(visitVo.getVisitPurposeNm());

            smsSendService.sendAutoSms(smsSendSo, smsReplaceVO);

        }catch (Exception e){

            log.debug("방문예약접수 SMS 전송 실패 {}" +  e.getMessage());
        }

        return proxyDao.update(MapperConstants.VISIT_RSV + "updateRsvCancel", visitSO);
    }

    /**
     * <pre>
     * 작성일 : 2018. 7. .
     * 작성자 : khy
     * 설명   : 방문예약 등록
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2018. 7. . khy - 최초생성
     * </pre>
     *
     * @return
     */
    public ResultModel<OrderPO> insertVisit(OrderPO po) throws Exception  {
        ResultModel<OrderPO> result = new ResultModel<>();

        GoodsDetailSO goodsDetailSO = new GoodsDetailSO();
        String[] itemArr = po.getItemArr();

        List<OrderGoodsPO> orderGoodsList = new ArrayList<>();
        int ordDtlSeq = 1; // 상세 순번

        if (itemArr != null && itemArr.length > 0) {
            for (int i = 0; i < itemArr.length; i++) {
                /*
                 * 전송 데이터 예제
                 * itemArr[0] : G1607121100_0815▦I1607121106_0960^1^01▦
                 * itemArr[1] : G1607121100_0815▦I1607121106_0961^1^02▦
                 * itemArr[2] : G1607121100_0815▦I1607121106_0962^1^03▦
                 * itemArr[3] : G1607121100_0815▦I1607121106_0963^1^04▦69^118^1*70^120^1*69^119^1
                 */
                // 상품번호
                String goodsNo = itemArr[i].split("\\▦")[0];

                // 단품정보(단품번호:수량)
                String item = itemArr[i].split("\\▦")[1];
                String itemNo = item.split("\\^")[0]; // 단품번호
                int buyQtt = Integer.parseInt(item.split("\\^")[1]); // 단품 구매수량
                // 추가옵션정보(옵션번호:상세번호:수량)
                String addOpt = "";
                if (itemArr[i].split("\\▦").length == 4) {
                    addOpt = itemArr[i].split("\\▦")[2];
                }
                long ctgNo = Long.parseLong(itemArr[i].split("\\▦")[3]);

                goodsDetailSO.setGoodsNo(goodsNo);
                goodsDetailSO.setItemNo(itemNo);
                goodsDetailSO.setSiteNo(po.getSiteNo());

                OrderGoodsPO orderGoodsPO = new OrderGoodsPO();
                OrderGoodsVO orderGoodsVO = orderService.selectOrderGoodsInfo(goodsDetailSO); // 주문상품정보 조회
                BeanUtils.copyProperties(orderGoodsVO, orderGoodsPO);
                orderGoodsPO.setOrdDtlSeq(ordDtlSeq); // 주문상세순번
                orderGoodsPO.setOrdQtt(buyQtt);// 구매수량
                orderGoodsPO.setOrdDtlStatusCd("01"); // 주문상태(주문접수)
                orderGoodsPO.setAddOptYn("N"); // 추가옵션여부
                orderGoodsPO.setCtgNo(ctgNo); // 카테고리 번호
                orderGoodsPO.setStampYn(orderGoodsVO.getStampYn());

                orderGoodsList.add(orderGoodsPO);
                // 추가옵션
                if (!"".equals(addOpt)) {
                    String[] addOptArr = addOpt.split("\\*");
                    for (int k = 0; k < addOptArr.length; k++) {
                        OrderGoodsPO addOptPO = new OrderGoodsPO();
                        ordDtlSeq++;
                        long addOptNo = Long.parseLong(addOptArr[k].split("\\^")[0]);
                        long addOptDtlSeq = Long.parseLong(addOptArr[k].split("\\^")[1]);
                        int optBuyQtt = Integer.parseInt(addOptArr[k].split("\\^")[2]);
                        goodsDetailSO.setAddOptNo(addOptNo);
                        goodsDetailSO.setAddOptDtlSeq(addOptDtlSeq);
                        // 추가옵션 정보 조회
                        GoodsAddOptionDtlVO goodsAddOptionDtlVO = orderService.selectOrderAddOptionInfo(goodsDetailSO);
                        addOptPO.setOrdDtlSeq(ordDtlSeq); // 주문상세순번
                        addOptPO.setOrdDtlStatusCd("01"); // 주문상태(주문접수)
                        addOptPO.setGoodsNo(orderGoodsPO.getGoodsNo()); // 상품번호
                        addOptPO.setItemNo(orderGoodsPO.getItemNo()); // 아이템번호
                        addOptPO.setGoodsNm(orderGoodsPO.getGoodsNm()); // 상품명
                        addOptPO.setOrdQtt(optBuyQtt); // 구매수량
                        long addOptAmt = (long) Double.parseDouble(goodsAddOptionDtlVO.getAddOptAmt());
                        addOptPO.setSaleAmt(addOptAmt);
                        addOptPO.setAddOptYn("Y"); // 추가옵션 여부
                        addOptPO.setOptNo(goodsAddOptionDtlVO.getAddOptNo()); // 추가옵션  번호
                        String optNm = goodsAddOptionDtlVO.getAddOptNm() + ":"+ goodsAddOptionDtlVO.getAddOptValue();
                        addOptPO.setOptNm(optNm); // 추가옵션 명
                        addOptPO.setOptDtlSeq(goodsAddOptionDtlVO.getAddOptDtlSeq()); // 추가옵션 상세순번
                        addOptPO.setRsvOnlyYn(orderGoodsPO.getRsvOnlyYn()); //예약전용여부

                        orderGoodsList.add(addOptPO);
                    }
                }
                ordDtlSeq++;
            }
        }

        //증정상품일 경우 쿠폰 발행 개수로 가능여부를 판단한다.
        //증정쿠폰 유무 체크
        if(po.getPreGoodsYn()!=null && po.getPreGoodsYn().equals("Y")) {
            String preAvailableYn  ="Y";
            CouponSO cpSO = new CouponSO();
            for (OrderGoodsPO orderGoodsPO : orderGoodsList) {
                cpSO.setSiteNo(SessionDetailHelper.getDetails().getSession().getSiteNo());
                cpSO.setGoodsNo(orderGoodsPO.getGoodsNo());
                //증정쿠폰 제한수량과 현재 발행 수량을 체크하여 예약불가능 하도록 처리..
                preAvailableYn = couponService.selectCouponLimitQttYn(cpSO);
            }
            if(preAvailableYn.equals("N")){
                throw new CustomException("biz.exception.visit.noGoods");
            }
        }
        if(po.getMemberYn()!=null && po.getMemberYn().equals("Y") || SessionDetailHelper.getDetails().isLogin()) {
            // 장바구니 삭제
            List<String> itemNoList = new ArrayList<>();

            long memberNo = SessionDetailHelper.getDetails().getSession().getMemberNo();

            for (OrderGoodsPO orderGoodsPO : orderGoodsList) {
                if ("N".equals(orderGoodsPO.getAddOptYn())) {
                    itemNoList.add(orderGoodsPO.getItemNo());
                }
            }

            String[] itemNoArr = itemNoList.toArray(new String[itemNoList.size()]);
            BasketSO basketSO = new BasketSO();
            basketSO.setSiteNo(po.getSiteNo());
            basketSO.setItemNoArr(itemNoArr);
            basketSO.setMemberNo(memberNo);

            if (itemNoArr.length > 0) {
                List<BasketVO> basketList = frontBasketService.selectBasketByItemNo(basketSO);
                if (basketList != null && basketList.size() > 0) {
                    for (BasketVO basketVO : basketList) {
                        BasketPO deletePO = new BasketPO();
                        deletePO.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
                        deletePO.setMemberNo(memberNo);
                        deletePO.setBasketNo(basketVO.getBasketNo());
                        frontBasketService.deleteBasket(deletePO);
                    }
                }
            }
        }
        // 방문예약등록        
        result = insertVisitInfo(po, orderGoodsList);

        if(po.getMemberYn()!=null && po.getMemberYn().equals("Y") || SessionDetailHelper.getDetails().isLogin()) {
            long memberNo = SessionDetailHelper.getDetails().getSession().getMemberNo();
            // 예약전용쿠폰 발급
            CouponPO cpIssueResult = new CouponPO();
            if (result.isSuccess()) {
                try {
                    if (orderGoodsList.size() > 0) {
                        for (OrderGoodsPO orderGoodsPO : orderGoodsList) {
                            CouponPO cpo = new CouponPO();
                            cpo.setMemberNo(memberNo);
                            cpo.setGoodsNo(orderGoodsPO.getGoodsNo());
                            cpIssueResult = couponService.rsvOnlyCoupon(cpo).getData();
                        }
                    } else {
                        CouponPO cpo = new CouponPO();
                        cpo.setMemberNo(memberNo);
                        cpIssueResult = couponService.rsvOnlyCoupon(cpo).getData();
                    }
                    result.getData().setCpIssueResult(cpIssueResult);
                } catch (Exception e) {
                    // TODO Auto-generated catch block

                }
            }
        }
        return result;
    };

    /** 방문예약 취소 */
    public int removeVisit(VisitSO visitSO) throws Exception  {

        // 다비젼 매장 방문 예약 취소
        StoreVisitReserveCancelReqDTO param = new StoreVisitReserveCancelReqDTO();
        param.setMallRsvNo(visitSO.getRsvNo());
        /*if(m_isDibug210) {

        }*/
        reserveService.cancelErpStoreVisitReserveInfo(param);

        //Map<String, Object> param = new HashMap<>();
        //param.put("mallRsvNo", visitSO.getRsvNo());
        //Map<String, Object> res = InterfaceUtil.send("IF_RSV_003", param);
        //if ("1".equals(res.get("result"))) {
        //}else{
        //    throw new Exception(String.valueOf(res.get("message")));
        //}

        //방문예약취소 SMS /알림톡 발송
        try {
            VisitVO visitVo = this.selectVisitDtl(visitSO);

            SmsSendSO smsSendSo = new SmsSendSO();
            smsSendSo.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
            smsSendSo.setSendTypeCd("34");
            if(StringUtils.isEmpty(visitVo.getNoMemberNm())) {
                smsSendSo.setMemberNo(visitVo.getMemberNo());
            } else {
                smsSendSo.setMemberNo(9999);
                smsSendSo.setRecvTelno(visitVo.getNoMemberMobile());
            }
            smsSendSo.setMemberTemplateCode("mk046");
            smsSendSo.setStoreNo(visitVo.getStoreNo());
            smsSendSo.setStoreTemplateCode("mk047");

            ReplaceCdVO smsReplaceVO = new ReplaceCdVO();
            smsReplaceVO.setRsvNo(visitVo.getRsvNo());
            smsReplaceVO.setStoreNm(visitVo.getStoreNm());
            smsReplaceVO.setRsvDate(visitVo.getStrVisitDate());
            if (StringUtils.isEmpty(visitVo.getNoMemberNm())) {
                smsReplaceVO.setRsvName(visitVo.getMemberNm());
            } else {
                smsReplaceVO.setRsvName(visitVo.getNoMemberNm());
            }
            smsReplaceVO.setRsvGubun(visitVo.getVisitPurposeNm());

            smsSendService.sendAutoSms(smsSendSo, smsReplaceVO);

        }catch (Exception e){
            log.debug("방문예약접수 SMS 전송 실패 {}" +  e.getMessage());
        }

        return proxyDao.update(MapperConstants.VISIT_RSV + "updateRsvCancel", visitSO);
    }

    /**
     * <pre>
     * 작성일 : 2018. 7. .
     * 작성자 : khy
     * 설명   : 방문예약번호 채번
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2018. 7. . khy - 최초생성
     * </pre>
     *
     * @return
     */
    private Integer selectRsvNo() {
        return proxyDao.selectOne(MapperConstants.VISIT_RSV + "selectRsvNo");
    }


    /**
     * <pre>
     * 작성일 : 2018. 7. .
     * 작성자 : khy
     * 설명   : 방문예약등록
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2018. 7. . khy - 최초생성
     * </pre>
     *
     * @return
     */
    public ResultModel<OrderPO> insertVisitInfo(OrderPO po, List<OrderGoodsPO> orderGoodsList) throws Exception  {

        ResultModel<OrderPO> result = new ResultModel<OrderPO>();


        //예약정보
        if(po.getMemberYn()!=null && po.getMemberYn().equals("Y") || SessionDetailHelper.getDetails().isLogin()) {
            po.setMemberNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
        }else{
            po.setMemberNo(999L);

        }

        if (po.getVisitPurposeNm() == null || "".equals(po.getVisitPurposeNm())) {
            po.setVisitPurposeNm("▶주문상품픽업");
        }

        String getRsvNo;
        while (true){
            try {
                // 예약번호 채번
                getRsvNo = this.selectRsvNo().toString();
                po.setRsvNo(getRsvNo);
                proxyDao.insert(MapperConstants.VISIT_RSV + "insertVisitRsvMst", po);
                break;
            } catch (DuplicateKeyException e) {
                // 예약 번호가 중복되는 경우 예약번호를 재 설정한다.
                proxyDao.update(MapperConstants.VISIT_RSV + "resetRsvNo");
            }
        }

        String rsvOnlyYn = po.getRsvOnlyYn();
        String stampYn = "N";

        //예약상세
        VisitVO vDtl = new VisitVO();
        for (OrderGoodsPO goodspo : orderGoodsList ) {
            vDtl.setRsvNo(getRsvNo);
            vDtl.setRsvDtlSeq((int)goodspo.getOrdDtlSeq());

            if (goodspo.getOrdNo() > 0) {
                vDtl.setOrdNo(String.valueOf(goodspo.getOrdNo()));
                vDtl.setOrdDtlSeq((int)goodspo.getOrdDtlSeq());
                vDtl.setRsvGb("01");  // 매장수령
            } else {
                vDtl.setOrdNo(null);
                vDtl.setOrdDtlSeq(null);

                if ("Y".equals(rsvOnlyYn)) {
                    vDtl.setRsvGb("02");  // 예약전용
                } else {
                    vDtl.setRsvGb("03");  // 사전예약
                }
            }
            vDtl.setGoodsNo(goodspo.getGoodsNo());
            vDtl.setGoodsNm(goodspo.getGoodsNm());
            vDtl.setItemNo(goodspo.getItemNo());
            vDtl.setItemNm(goodspo.getItemNm());
            vDtl.setOrdQtt((int)goodspo.getOrdQtt());
            vDtl.setSaleAmt(goodspo.getSaleAmt());
            vDtl.setDcAmt(goodspo.getDcAmt());
            vDtl.setAddOptYn(goodspo.getAddOptYn());
            vDtl.setAddOptNo((int)goodspo.getOptNo());
            vDtl.setAddOptNm(goodspo.getOptNm());
            vDtl.setAddOptDtlSeq((int)goodspo.getOptDtlSeq());

            if ("N".equals(stampYn)) stampYn = goodspo.getStampYn();

            proxyDao.insert(MapperConstants.VISIT_RSV + "insertVisitRsvDtl", vDtl);

        }

        // 예약 interface 호출 
        interfaceVisitBook(po, orderGoodsList);


        //방문예약접수 SMS /알림톡 발송
        try {

            SmsSendSO smsSendSo = new SmsSendSO();
            smsSendSo.setTemplateCode("mk005");
            smsSendSo.setSendTypeCd("21");

            smsSendSo.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
            if(po.getMemberYn()!=null && po.getMemberYn().equals("Y") || SessionDetailHelper.getDetails().isLogin()) {
                smsSendSo.setReceiverId(SessionDetailHelper.getDetails().getSession().getLoginId());
                smsSendSo.setReceiverNm(SessionDetailHelper.getDetails().getSession().getMemberNm());
                smsSendSo.setRecvTelno(SessionDetailHelper.getDetails().getSession().getMobile());
                smsSendSo.setMemberNo(po.getMemberNo());
            }else{
                smsSendSo.setReceiverId("nomember");
                smsSendSo.setReceiverNm(po.getNomemberNm());
                smsSendSo.setMemberNo(999L);
            }
            smsSendSo.setRecvTelno(po.getNomobile());

            smsSendSo.setStoreNo(po.getStoreNo());

            ReplaceCdVO smsReplaceVO = new ReplaceCdVO();
            //방문매장
            smsReplaceVO.setStoreNm(po.getStoreNm()+"\r\n- 예약번호 : "+getRsvNo);
            //방문일시
            String rsvtime = StringUtil.nvl(po.getRsvTime());
            if(!rsvtime.equals("") && rsvtime.length()==4) {
                rsvtime = rsvtime.substring(0,2) + ":" + rsvtime.substring(2,4);
            }else{
                rsvtime ="";
            }
            smsReplaceVO.setRsvTime(rsvtime);
            smsReplaceVO.setRsvDate(po.getRsvDate() + " " + rsvtime);
            //문의
            smsReplaceVO.setReqMatr(po.getReqMatr());
            if(po.getMemberYn()!=null && po.getMemberYn().equals("Y") || SessionDetailHelper.getDetails().isLogin()) {
                smsReplaceVO.setMemberNm(SessionDetailHelper.getDetails().getSession().getMemberNm());
                smsReplaceVO.setRsvName(SessionDetailHelper.getDetails().getSession().getMemberNm());
            }else{
                smsReplaceVO.setMemberNm(po.getNomemberNm());
                smsReplaceVO.setRsvName(po.getNomemberNm());
            }
            smsReplaceVO.setRsvGubun(po.getVisitPurposeNm());

            if ("Y".equals(stampYn)){
                String stampNo = proxyDao.selectOne(MapperConstants.VISIT_RSV + "selectStampNo", po);
                smsReplaceVO.setEtc("- 스탬프적립 예약번호 : ".concat(stampNo));
            }

            smsSendService.sendAutoSms(smsSendSo, smsReplaceVO);

        }catch (Exception e){
            log.debug("방문예약접수 SMS 전송 실패 {}" +  e.getMessage());
        }


        result.setSuccess(true);
        result.setData(po);
        return result;
    }


    /**
     * <pre>
     * 작성일 : 2018. 7. .
     * 작성자 : khy
     * 설명   : 방문예약등록 - 인터페이스
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2018. 7. . khy - 최초생성
     * </pre>
     *
     * @return
     */
    private void interfaceVisitBook(OrderPO po, List<OrderGoodsPO> list) throws Exception  {

        MemberManageSO so = new MemberManageSO();
        so.setSiteNo(po.getSiteNo());
        so.setMemberNo(po.getMemberNo());
        ResultModel<MemberManageVO> memberInfo = new ResultModel<>();
        //회원상세정보 호출
        if(po.getMemberYn()!=null && po.getMemberYn().equals("Y") || SessionDetailHelper.getDetails().isLogin()) {
            memberInfo = memberManageService.viewMemInfo(so);
        }else{
            MemberManageVO vo = new MemberManageVO();
            if(po.getNomemberNm()!=null && !po.getNomemberNm().equals("")){
                vo.setMemberNm(po.getNomemberNm());
            }

            if(po.getNomobile()!=null && !po.getNomobile().equals("")){
                vo.setMobile(po.getNomobile());
            }

            if(po.getOrderInfoPO()!=null && po.getOrderInfoPO().getOrdrNm()!=null && !po.getOrderInfoPO().getOrdrNm().equals("")){
                vo.setMemberNm(po.getOrderInfoPO().getOrdrNm());
            }

            if(po.getOrderInfoPO()!=null && po.getOrderInfoPO().getOrdrMobile()!=null && !po.getOrderInfoPO().getOrdrMobile().equals("")){
                vo.setMobile(po.getOrderInfoPO().getOrdrMobile());
            }

            memberInfo.setData(vo);

        }

        // 사전예약일경우
        // todo : 2022.05.02 사전예약 사용하지 않음, 방문예약 정상작동시 삭제
        // if ("Y".equals(po.getExhibitionYn()) && list != null) {
        if ("NONE".equals(po.getExhibitionYn()) && list != null) {

            ExhibitionSO pso = new ExhibitionSO();
            pso.setSiteNo(po.getSiteNo());
            pso.setGoodsNo(list.get(0).getGoodsNo());
            String prmtBrandNo ="";
            if(list.get(0).getBrandNo()!=null && !list.get(0).getBrandNo().equals("")) {
                prmtBrandNo = list.get(0).getBrandNo();
                pso.setPrmtBrandNo(prmtBrandNo);
            }
            ResultModel<ExhibitionVO> exhibitionVO = exhibitionService.selectExhibitionByGoods(pso);

            String prmtNo = "";
            String prmtName = "";
            String prmtSDate = "";
            String prmtEDate = "";

            if (exhibitionVO.getData() != null) {
                prmtNo = String.valueOf(exhibitionVO.getData().getPrmtNo()); // 기획전 번호
                prmtName = exhibitionVO.getData().getPrmtNm(); // 기획전 번호
                prmtSDate = exhibitionVO.getData().getApplyStartDttm().replaceAll("-", "").substring(0, 8);
                prmtEDate = exhibitionVO.getData().getApplyEndDttm().replaceAll("-", "").substring(0, 8);
            }

            //사전예약주문
            Map<String, Object> param = new HashMap<>();
            param.put("prmtNo", prmtNo);
            param.put("prmtName", prmtName);
            param.put("prmtSDate", prmtSDate);
            param.put("prmtEDate", prmtEDate);
            param.put("custName", memberInfo.getData().getMemberNm());
            param.put("custHp", memberInfo.getData().getMobile());
            if(memberInfo.getData().getBirth()!=null && !memberInfo.getData().getBirth().equals("")) {
                param.put("custBirthday", memberInfo.getData().getBirth().replaceAll("-", ""));
            }else{
                param.put("custBirthday", "");
            }
            param.put("custAgreeYn", "Y");
            param.put("strCode", po.getStoreNo());
            param.put("reqDate", po.getRsvDate().replaceAll("-", ""));

            List<Map<String,Object>> gList = new ArrayList<>();
            for (OrderGoodsPO goodsPO : list) {
                Map<String,Object> map = new HashMap<>();
                map.put("itmCode", goodsPO.getItemNo());
                map.put("qty", goodsPO.getOrdQtt());
                gList.add(map);
            }

            param.put("prdList", gList);
            Map<String, Object> res = InterfaceUtil.send("IF_RSV_011", param);

            if ("1".equals(res.get("result"))) {
            }else{
                throw new Exception(String.valueOf(res.get("message")));
            }

        } else {

            String telNo = po.getNomobile();
            String rsvDate = po.getRsvDate();
            if (rsvDate.length() > 4) rsvDate = rsvDate.replaceAll("-", "");

            // 방문예약정보
            Map<String, Object> param = new HashMap<>();
            param.put("memNo", po.getMemberNo());
            param.put("rsvDate", rsvDate);
            param.put("rsvTime", po.getRsvTime());
            param.put("strCode", po.getStoreNo());
            param.put("memName", memberInfo.getData().getMemberNm());
            param.put("telNo",  telNo);
            param.put("memo", po.getReqMatr());
            param.put("purpose", po.getVisitPurposeNm());
            param.put("mallRsvNo", po.getRsvNo());
            param.put("checkupYn", po.getCheckupYn());
            param.put("eventGubun", po.getEventGubun());

            //예약전용 상품일경우만 add
            List<Map<String,Object>> gList = new ArrayList<>();
            for (OrderGoodsPO goodsPO : list) {
                if ("Y".equals(goodsPO.getRsvOnlyYn())) {
                    Map<String,Object> map = new HashMap<>();
                    map.put("itmCode", goodsPO.getItemNo());
                    map.put("qty", goodsPO.getOrdQtt());

                    // 샘플증정인 경우
                    if(po.getPreGoodsYn() != null && "Y".equals(po.getPreGoodsYn())) {
                        map.put("memo", goodsPO.getOptNm());
                    }

                    gList.add(map);
                }
            }

            param.put("rsvPrdList", gList);

            Map<String, Object> res = InterfaceUtil.send("IF_RSV_002", param);

            if(!"1".equals(res.get("result"))) {
                throw new CustomException(String.valueOf(res.get("message")));
            }
        }
    }


    /**
     * <pre>
     * 작성일 : 2018. 7. .
     * 작성자 : khy
     * 설명   : 주문 - 방문예약상품 목록
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2018. 7. . khy - 최초생성
     * </pre>
     *
     * @return
     */
    public ResultModel<OrderVO> selectVisitGoods(OrderVO vo, HttpServletRequest request) throws Exception   {

        String[] itemArr = vo.getItemArr();

        if(request.getParameter("param_opt_1")!=null){
            JSONObject json = new JSONObject(request.getParameter("param_opt_1").isEmpty());
            log.debug(" === json : {}", json.toString());
            itemArr = json.getString("itemArr").split(",");
        }

        OrderVO orderVO = new OrderVO();
        GoodsDetailSO goodsDetailSO = new GoodsDetailSO();

        // 주문 상품 정보
        log.debug(" ==== itemArr : {}", String.valueOf(itemArr));
        List<OrderGoodsVO> orderGoodsList = new ArrayList<>();
        if (itemArr != null && itemArr.length > 0) {
            for (int i = 0; i < itemArr.length; i++) {
                /*
                 * 전송 데이터 예제 (상품번호▦단품번호▦단품구매수량^배송비결제코드▦▦카테고리번호
                 *  ** 추가옵션이 있을경우 ▦추가옵션번호^추가옵션상세번호^추가옵션구매수량
                 * itemArr[0] : G1607121100_0815▦I1607121106_0960^1^01▦▦82
                 * itemArr[1] : G1607121100_0815▦I1607121106_0961^1^02▦▦82
                 * itemArr[2] : G1607121100_0815▦I1607121106_0962^1^03▦▦82
                 * itemArr[3] : G1607121100_0815▦I1607121106_0963^1^04▦69^118^1*70^120^1*69^119^1▦82
                 */

                String itemArrSplit = itemArr[i].replace("&acirc;&brvbar;", "▦");
                // 상품번호
                String goodsNo = itemArrSplit.split("\\▦")[0];
                // 단품정보(단품번호:수량:배송비결제코드)
                String item = itemArrSplit.split("\\▦")[1];
                String itemNo = item.split("\\^")[0]; // 단품번호
                int buyQtt = Integer.parseInt(item.split("\\^")[1]); // 단품 구매수량
                String dlvrcPaymentCd = item.split("\\^")[2]; // 배송비 결제 코드
                // 추가옵션정보(옵션번호:상세번호:수량)
                String addOpt = "";
                if (itemArrSplit.split("\\▦").length == 4) {
                    addOpt = itemArrSplit.split("\\▦")[2];
                }

                goodsDetailSO.setGoodsNo(goodsNo);
                goodsDetailSO.setItemNo(itemNo);
                goodsDetailSO.setSiteNo(vo.getSiteNo());
                goodsDetailSO.setSaleYn("Y");

                // 상품정보조회
                OrderGoodsVO orderGoodsVO = orderService.selectOrderGoodsInfo(goodsDetailSO);

                if (orderGoodsVO == null) {
                    ResultModel<OrderVO> rs = new ResultModel<>();
                    rs.setSuccess(false);
                    rs.setMessage(MessageUtil.getMessage("front.web.goods.noSale"));
                    return rs;
                } else {
                    if ("Y".equals(orderGoodsVO.getAdultCertifyYn())) {
                        if (!SessionDetailHelper.getDetails().isLogin()) {
                            ResultModel<OrderVO> rs = new ResultModel<>();
                            rs.setSuccess(false);
                            rs.setMessage("성인용품은 성인인증을 하셔야만 구매가 가능합니다.");
                            return rs;
                        } else {
                            if (SessionDetailHelper.getSession().getAdult() == null || !SessionDetailHelper.getSession().getAdult()) {
                                ResultModel<OrderVO> rs = new ResultModel<>();
                                rs.setSuccess(false);
                                rs.setMessage("성인용품은 성인인증을 하셔야만 구매가 가능합니다.");
                                return rs;
                            }
                        }
                    }
                }

                // 기획전 할인정보 조회
                ExhibitionSO pso = new ExhibitionSO();
                pso.setSiteNo(vo.getSiteNo());
                pso.setGoodsNo(goodsNo);

                String prmtBrandNo ="";
                if(orderGoodsVO.getBrandNo()!=null && !orderGoodsVO.getBrandNo().equals("")) {
                    prmtBrandNo = orderGoodsVO.getBrandNo();
                    pso.setPrmtBrandNo(prmtBrandNo);
                }
                ResultModel<ExhibitionVO> exhibitionVO = exhibitionService.selectExhibitionByGoods(pso);

                if (exhibitionVO.getData() != null) {
                    orderGoodsVO.setPrmtNo(exhibitionVO.getData().getPrmtNo()); //기획전 번호
                    orderGoodsVO.setDcRate(exhibitionVO.getData().getPrmtDcValue()); //기획전 할인율
                    orderGoodsVO.setPrmtSDate(exhibitionVO.getData().getApplyStartDttm().substring(0, 10));
                    orderGoodsVO.setPrmtEDate(exhibitionVO.getData().getApplyEndDttm().substring(0, 10));
                    orderGoodsVO.setPrmtDcGbCd(exhibitionVO.getData().getPrmtDcGbCd());//기획전 할인구분코드
                    orderGoodsVO.setPrmtNm(exhibitionVO.getData().getPrmtNm()); //기획전 이름
                    vo.setExhibitionYn("Y");
                }

                // 상품에 매핑된 다비전코드 조회
                String erpItmCode = orderService.selectErpItmCode(goodsDetailSO.getItemNo());
                if(erpItmCode != null && !"".equals(erpItmCode)) {
                    orderGoodsVO.setErpItmCode(erpItmCode);
                }

                orderGoodsVO.setOrdQtt(buyQtt); // 구매수량
                orderGoodsVO.setDlvrcPaymentCd(dlvrcPaymentCd); // 배송비 결제 코드
                List<GoodsAddOptionDtlVO> goodsAddOptList = new ArrayList<>();

                //추가옵션이 있을경우
                if (!"".equals(addOpt)) {

                    String[] addOptArr = addOpt.split("\\*");
                    for (int k = 0; k < addOptArr.length; k++) {
                        long addOptNo = Long.parseLong(addOptArr[k].split("\\^")[0]);      // 추가옵션번호
                        long addOptDtlSeq = Long.parseLong(addOptArr[k].split("\\^")[1]);  // 추가옵셔상세번호
                        int optBuyQtt = Integer.parseInt(addOptArr[k].split("\\^")[2]);    // 추가옵션구매수량 
                        goodsDetailSO.setAddOptNo(addOptNo);
                        goodsDetailSO.setAddOptDtlSeq(addOptDtlSeq);
                        // 추가옵션 정보 조회
                        GoodsAddOptionDtlVO goodsAddOptionDtlVO = orderService.selectOrderAddOptionInfo(goodsDetailSO);
                        goodsAddOptionDtlVO.setAddOptBuyQtt(optBuyQtt);
                        goodsAddOptList.add(goodsAddOptionDtlVO);
                    }
                    orderGoodsVO.setGoodsAddOptList(goodsAddOptList);
                }

                //증정쿠폰 유무 체크
                CouponSO cpSO = new CouponSO();
                cpSO.setSiteNo(SessionDetailHelper.getDetails().getSession().getSiteNo());
                cpSO.setGoodsNo(goodsNo);
                int preGoodsCnt = couponService.selectGoodsPreGoodsCnt(cpSO);
                if(preGoodsCnt > 0) {
                    orderVO.setPreGoodsYn("Y");

                    //증정쿠폰 제한수량과 현재 발행 수량을 체크하여 예약불가능 하도록 처리..
                    String preAvailableYn =  couponService.selectCouponLimitQttYn(cpSO);
                    orderVO.setPreAvailableYn(preAvailableYn);
                }

                orderGoodsList.add(orderGoodsVO);
            }
        } else {
            throw new Exception(MessageUtil.getMessage("front.web.common.wrongapproach"));
        }

        // 배송비 계산(묶음 관련)
        String type = "order";
        @SuppressWarnings("rawtypes")
        Map map = orderService.calcDlvrAmt(orderGoodsList, type);
        @SuppressWarnings("unchecked")
        List<OrderGoodsVO> list = (List<OrderGoodsVO>) map.get("list");

        orderVO.setOrderGoodsVO(list);

        // 기획전여부 (사전예약여부)
        if (vo.getExhibitionYn() != null) {
            orderVO.setExhibitionYn(vo.getExhibitionYn());
        }

        ResultModel<OrderVO> orderInfo = new ResultModel<>();
        orderInfo.setData(orderVO);

        return orderInfo;

    }

    /** 시/도 코드 가져오기**/
    public String selectSidoCode(VisitSO so){
        return proxyDao.selectOne(MapperConstants.VISIT_RSV + "selectSidoCode", so);
    };

    /** 동일시간 예약체크 **/
    public int existsRsvTime(VisitVO vo) {
        return proxyDao.selectOne(MapperConstants.VISIT_RSV + "existsRsvTime", vo);
    };


    /**
     * <pre>
     * 작성일 : 2018. 9. 17.
     * 작성자 : khy
     * 설명   : 현재방문예약목록
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2018. 9. 17. khy - 최초생성
     * </pre>
     *
     * @return
     */
    public List<VisitVO> selectExistVisitList(VisitSO visitSO) {
        return proxyDao.selectList(MapperConstants.VISIT_RSV + "selectExistVisitList", visitSO);
    }




    /**
     * <pre>
     * 작성일 : 2018. 7. .
     * 작성자 : khy
     * 설명   : 기존방문예약에 추가
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2018. 7. . khy - 최초생성
     * </pre>
     *
     * @return
     */
    public int addVisitBook(VisitSO visitSO) throws Exception  {

        VisitVO vo = this.selectVisitDtl(visitSO);
        String orgPurpNm = vo.getVisitPurposeNm();
        visitSO.setVisitPurposeNm(visitSO.getVisitPurposeNm());

        // 방문예약정보
        Map<String, Object> param = new HashMap<>();
        param.put("mallRsvNo", visitSO.getRsvNo());
        param.put("purpose", orgPurpNm + visitSO.getVisitPurposeNm());

        String rsvDate = visitSO.getRsvDate();
        if (rsvDate.length() > 4) rsvDate = rsvDate.replaceAll("-", "");

        param.put("rsvDate", rsvDate);
        param.put("rsvTime", visitSO.getRsvTime());

        Map<String, Object> res = InterfaceUtil.send("IF_RSV_014", param);

        if ("1".equals(res.get("result"))) {
        }else{
            throw new Exception(String.valueOf(res.get("message")));
        }

        //방문예약변경 SMS /알림톡 발송
        try {
            SmsSendSO smsSendSo = new SmsSendSO();
            smsSendSo.setTemplateCode("mk005");
            smsSendSo.setSendTypeCd("26");

            smsSendSo.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
            if(SessionDetailHelper.getDetails().isLogin()) {
                smsSendSo.setReceiverId(SessionDetailHelper.getDetails().getSession().getLoginId());
                smsSendSo.setReceiverNm(SessionDetailHelper.getDetails().getSession().getMemberNm());
                smsSendSo.setRecvTelno(SessionDetailHelper.getDetails().getSession().getMobile());
                smsSendSo.setMemberNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
            }else{
                smsSendSo.setReceiverId("nomember");
                smsSendSo.setReceiverNm(vo.getMemberNm());
                smsSendSo.setMemberNo(999L);
            }
            smsSendSo.setRecvTelno(vo.getNoMemberMobile());

            smsSendSo.setStoreNo(vo.getStoreNo());

            ReplaceCdVO smsReplaceVO = new ReplaceCdVO();
            //방문매장
            smsReplaceVO.setStoreNm(vo.getStoreNm()+"\r\n- 예약번호 : " + vo.getRsvNo());
            //방문일시
            String rsvtime = StringUtil.nvl(visitSO.getRsvTime());
            if(!rsvtime.equals("") && rsvtime.length()==4) {
                rsvtime = rsvtime.substring(0,2) + ":" + rsvtime.substring(2,4);
            }else{
                rsvtime ="";
            }
            smsReplaceVO.setRsvTime(rsvtime);
            SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
            smsReplaceVO.setRsvDate(visitSO.getRsvDate() + " " + rsvtime);
            //문의
            smsReplaceVO.setReqMatr(vo.getReqMatr());
            if(SessionDetailHelper.getDetails().isLogin()) {
                smsReplaceVO.setMemberNm(SessionDetailHelper.getDetails().getSession().getMemberNm());
                smsReplaceVO.setRsvName(SessionDetailHelper.getDetails().getSession().getMemberNm());
            }else{
                smsReplaceVO.setMemberNm(vo.getNoMemberNm());
                smsReplaceVO.setRsvName(vo.getNoMemberNm());
            }
            smsReplaceVO.setRsvGubun(vo.getVisitPurposeNm().trim());

            smsSendService.sendAutoSms(smsSendSo, smsReplaceVO);

        }catch (Exception e){
            log.debug("방문예약접수 SMS 전송 실패 {}" +  e.getMessage());
        }

        return proxyDao.update(MapperConstants.VISIT_RSV + "addVisitBook", visitSO);
    }

    @Override
    public List<VisitVO> selectAffiliateList(VisitSO so) {
        return proxyErpDao.selectList(MapperConstants.VISIT_RSV + "selectAffiliateList", so);
    }

    /**
     * 비회원 방문예약조회 유효성 검사
     */
    @Override
    public boolean selectNonMemberRsv(VisitSO so) {
        boolean rsvYn = false;
        String rsvMobile1 = so.getRsvMobile().replaceAll("-", ""); // 입력받은 번호
        VisitVO visitVO = proxyDao.selectOne(MapperConstants.VISIT_RSV + "selectNonMemberRsv", so);
        if (visitVO != null) {
            String rsvMobile2 = visitVO.getNoMemberMobile().replaceAll("-", ""); // 조회한 번호
            if (rsvMobile1.equals(rsvMobile2)) {
                rsvYn = true;
            }
        }
        return rsvYn;
    }


    @Override
    public int winnerChk(Map<String, String> param) {
        return proxyDao.selectOne(MapperConstants.VISIT_RSV + "winnerChk", param);
    }

    public void ifCancelErpStoreVisitReservation(Map<String, Object> param) throws Exception {

        String ifId = Constants.IFID.STORE_VISIT_RESERVE_CANCEL_FROM_MALL;

        ObjectMapper objectMapper = new ObjectMapper();
        StoreVisitReserveCancelReqDTO storeVisitReserveCancelReqDTO = objectMapper.convertValue(param, StoreVisitReserveCancelReqDTO.class);

        try {

            // 쇼핑몰 처리 부분
            // ERP쪽으로 데이터 전송
            //String resParam = sendUtil.send(param, ifId);
            // ResponseDTO 생성
            StoreVisitReserveCancelResDTO resDto = new StoreVisitReserveCancelResDTO();
            resDto.setResult(Constants.RESULT.SUCCESS);
            resDto.setMessage("");

            // 데이터 등록
            reserveService.cancelErpStoreVisitReserveInfo(storeVisitReserveCancelReqDTO);
            String resParam = JSONObject.fromObject(resDto).toString();
            // 처리 로그 등록
            logService.writeInterfaceLog(ifId, param, resParam, StoreVisitReserveCancelResDTO.class);

        } catch (CustomIfException ce) {
            ce.setReqParam(storeVisitReserveCancelReqDTO);
            ce.setIfId(ifId);
            throw ce;
        } catch (Exception e) {
            e.printStackTrace();
            throw new CustomIfException(e, storeVisitReserveCancelReqDTO, ifId);
        }
    }
}
