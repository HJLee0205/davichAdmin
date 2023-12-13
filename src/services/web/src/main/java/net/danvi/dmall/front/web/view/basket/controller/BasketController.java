package net.danvi.dmall.front.web.view.basket.controller;

import java.lang.reflect.Array;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import net.danvi.dmall.biz.app.basicinfo.model.BasicInfoVO;
import net.danvi.dmall.biz.app.basket.model.BasketOptPO;
import net.danvi.dmall.biz.app.basket.service.FrontBasketService;
import net.danvi.dmall.biz.app.goods.model.GoodsItemVO;
import net.danvi.dmall.biz.app.member.manage.model.MemberManageVO;
import net.danvi.dmall.biz.app.promotion.freebiecndt.model.FreebieCndtVO;
import net.danvi.dmall.biz.app.promotion.freebiecndt.model.FreebieGoodsVO;
import net.danvi.dmall.biz.app.promotion.freebiecndt.service.FreebieCndtService;
import net.danvi.dmall.biz.system.security.SessionDetailHelper;
import net.danvi.dmall.biz.system.security.DmallSessionDetails;
import net.danvi.dmall.biz.system.validation.InsertGroup;
import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.fasterxml.jackson.databind.ObjectMapper;

import lombok.extern.slf4j.Slf4j;
import net.danvi.dmall.biz.app.basicinfo.service.BasicInfoService;
import net.danvi.dmall.biz.app.basket.model.BasketOptSO;
import net.danvi.dmall.biz.app.basket.model.BasketOptVO;
import net.danvi.dmall.biz.app.basket.model.BasketPO;
import net.danvi.dmall.biz.app.basket.model.BasketSO;
import net.danvi.dmall.biz.app.basket.model.BasketVO;
import net.danvi.dmall.biz.app.goods.model.GoodsDetailSO;
import net.danvi.dmall.biz.app.goods.model.GoodsDetailVO;
import net.danvi.dmall.biz.app.goods.model.GoodsVO;
import net.danvi.dmall.biz.app.goods.service.CategoryManageService;
import net.danvi.dmall.biz.app.goods.service.GoodsManageService;
import net.danvi.dmall.biz.app.interest.model.InterestSO;
import net.danvi.dmall.biz.app.interest.service.FrontInterestService;
import net.danvi.dmall.biz.app.member.manage.model.MemberManageSO;
import net.danvi.dmall.biz.app.member.manage.service.FrontMemberService;
import net.danvi.dmall.biz.app.member.manage.service.MemberManageService;
import net.danvi.dmall.biz.app.order.manage.service.OrderService;
import net.danvi.dmall.biz.app.promotion.exhibition.model.ExhibitionSO;
import net.danvi.dmall.biz.app.promotion.exhibition.service.ExhibitionService;
import net.danvi.dmall.biz.app.promotion.freebiecndt.model.FreebieCndtSO;
import net.danvi.dmall.biz.app.promotion.freebiecndt.model.FreebieTargetVO;
import net.danvi.dmall.biz.app.setup.siteinfo.model.SiteVO;
import net.danvi.dmall.biz.system.validation.DeleteGroup;
import net.danvi.dmall.biz.system.validation.UpdateGroup;
import dmall.framework.common.constants.RequestAttributeConstants;
import dmall.framework.common.exception.JsonValidationException;
import dmall.framework.common.model.ResultListModel;
import dmall.framework.common.model.ResultModel;
import dmall.framework.common.util.MessageUtil;
import dmall.framework.common.util.SiteUtil;

/**
 * <pre>
 * - 프로젝트명    : 31.front.web
 * - 패키지명      : front.web.view.basket.controller
 * - 파일명        : BasketController.java
 * - 작성일        : 2016. 5. 2.
 * - 작성자        : dong
 * - 설명          : 장바구니 Controller
 * </pre>
 */
@Slf4j
@Controller
@RequestMapping("/front/basket")
public class BasketController {
    @Resource(name = "frontBasketService")
    private FrontBasketService frontBasketService;

    @Resource(name = "goodsManageService")
    private GoodsManageService goodsManageService;

    @Resource(name = "frontInterestService")
    private FrontInterestService frontInterestService;

    @Resource(name = "orderService")
    private OrderService orderService;

    @Resource(name = "categoryManageService")
    private CategoryManageService categoryManageService;

    @Resource(name = "exhibitionService")
    private ExhibitionService exhibitionService;

    @Resource(name = "frontMemberService")
    private FrontMemberService frontMemberService;

    @Resource(name = "memberManageService")
    private MemberManageService memberManageService;

    @Resource(name = "freebieCndtService")
    private FreebieCndtService freebieCndtService;

    @Resource(name = "basicInfoService")
    private BasicInfoService basicInfoService;

    /**
     * <pre>
     * 작성일 : 2016. 5. 2.
     * 작성자 : dong
     * 설명   : 장바구니 상품정보 조회
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 2. dong - 최초생성
     * </pre>
     *
     * @param mav
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/basket-list")
    public ModelAndView selectBasketList(@Validated BasketSO so, BindingResult bindingResult,
            HttpServletRequest request) throws Exception {
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
        }

        ModelAndView mav = SiteUtil.getSkinView();

        DmallSessionDetails sessionInfo = SessionDetailHelper.getDetails();

        mav.setViewName("/basket/basket_list");
        Long memberNo = sessionInfo.getSession().getMemberNo();
        String memberNoYn = "N";
        List<BasketVO> basket_list = new ArrayList<>();

         /** 회원인경우 세션 + DB 조회*/
        if (memberNo != null) {
        	
        	HttpSession session = request.getSession();
            List<BasketPO> basket_session = (List<BasketPO>) session.getAttribute("basketSession");
            BasketVO itemInfo = new BasketVO();
            if (basket_session != null) {
                for (int i = 0; i < basket_session.size(); i++) {
                	BasketPO po = new BasketPO();
                	po = basket_session.get(i);
                	String[] itemNoArr = {basket_session.get(i).getItemNo()};
                	po.setItemNoArr(itemNoArr);
                	int[] buyQttArr = {basket_session.get(i).getBuyQtt()};
                	po.setBuyQttArr(buyQttArr);
                	po.setSiteNo(sessionInfo.getSession().getSiteNo());
                	po.setMemberNo(sessionInfo.getSession().getMemberNo());
                	po.setRegrNo(sessionInfo.getSession().getMemberNo());
                	po.setUpdrNo(sessionInfo.getSession().getMemberNo());
                	po.setBasketNo(null);
                	
                	frontBasketService.insertBasket(po);
                }
                
                session.removeAttribute("basketSession");
            }
            //basket_list.add((BasketVO) basketCookieList(request,so));
            memberNoYn = "Y";
            so.setMemberNo(memberNo);

            ResultListModel<BasicInfoVO> result = basicInfoService.selectBasicInfo(so.getSiteNo());
            SiteVO siteVo = (SiteVO) result.get(RequestAttributeConstants.FRONT_SITE_INFO);

            if ("Y".equals(siteVo.getGoodsKeepQttLimitYn())) {
                so.setLimit(Integer.parseInt(siteVo.getGoodsKeepQtt()));
            }

            basket_list.addAll(frontBasketService.selectBasketList(so));
            //basket_list.add((BasketVO) frontBasketService.selectBasketList(so));

            if (basket_list != null) {
                for (int i = 0; i < basket_list.size(); i++) {
                    BasketVO tempVo = basket_list.get(i);
                    tempVo.setSiteNo(so.getSiteNo());
                    // 기획전 할인정보 조회
                    tempVo = frontBasketService.promotionDcInfo(tempVo);
                    log.debug("== tempVO {} ", tempVo);

                }
            }

            // 회원기본정보 조회(비회원이거나 수기주문일 경우 제외)
            if (SessionDetailHelper.getDetails().isLogin()) {
                MemberManageSO mmso = new MemberManageSO();
                mmso.setMemberNo(memberNo);
                mmso.setSiteNo(so.getSiteNo());
                ResultModel<MemberManageVO> member_info = frontMemberService.selectMember(mmso);

                // 보유쿠폰search > 회원기본정보 set
                Integer couponCount = memberManageService.selectCouponGetPagingCount(mmso);// 할인쿠폰
                member_info.getData().setCpCnt(Integer.toString(couponCount));

                // 보유 마켓포인트 조회
                ResultModel<MemberManageVO> prcAmt = memberManageService.selectMemSaveMn(mmso);
                member_info.getData().setPrcAmt(prcAmt.getData().getPrcAmt());

                mav.addObject("member_info", member_info); // 회원정보
            }
        } else {
            /** 비회원인 경우 세션에서만 조회 */
            basket_list = basketCookieList(request,so);
        }



        // 배송비 계산(묶음 관련)
        String type = "basket";
        Map map = orderService.calcDlvrAmt(basket_list, type);
        List<BasketVO> list = (List<BasketVO>) map.get("list");
        Map dlvrPriceMap = (Map) map.get("dlvrPriceMap");
        Map dlvrCountMap = (Map) map.get("dlvrCountMap");

        mav.addObject("dlvrPriceMap", dlvrPriceMap);
        mav.addObject("dlvrCountMap", dlvrCountMap);

        String jsonList = "";
        if (list != null) {
            ObjectMapper mapper = new ObjectMapper();
            jsonList = mapper.writeValueAsString(list);
        }

        // 관심상품조회
        InterestSO is = new InterestSO();
        is.setMemberNo(sessionInfo.getSession().getMemberNo());
        is.setSiteNo(sessionInfo.getSession().getSiteNo());
        is.setLimit(0);
        is.setOffset(5);
        List<GoodsVO> interest_goods = frontInterestService.selectInterestList(is);

        List<BasketVO> basketList = new ArrayList();
        if(list!=null && list.size() >0) {
            for (int i = 0; i < list.size(); i++) {

                // 10.사은품대상조회
                ResultListModel<FreebieTargetVO> freebieEventList = new ResultListModel<>();
                FreebieCndtSO freebieCndtSO = new FreebieCndtSO();
                freebieCndtSO.setGoodsNo(list.get(i).getGoodsNo());
                freebieCndtSO.setSiteNo(list.get(i).getSiteNo());
                freebieEventList = freebieCndtService.selectFreebieListByGoodsNo(freebieCndtSO);

                List<FreebieGoodsVO> freebieList = (List<FreebieGoodsVO>) freebieEventList.getExtraData().get("goodsResult");
                List<FreebieGoodsVO> freebieGoodsList = new ArrayList();
                // 사은품 조회
                if (freebieList != null && freebieList.size() > 0) {
                    for (int j = 0; j < freebieList.size(); j++) {
                        FreebieGoodsVO freebieEventVO = freebieList.get(j);
                        FreebieCndtSO freebieGoodsSO = new FreebieCndtSO();
                        freebieGoodsSO.setSiteNo(list.get(i).getSiteNo());
                        freebieGoodsSO.setFreebieEventNo(freebieEventVO.getFreebieEventNo());
                        ResultModel<FreebieCndtVO> freeGoodsList = new ResultModel<>();
                        freeGoodsList = freebieCndtService.selectFreebieCndtDtl(freebieGoodsSO);
                        log.debug("== freeGoodsList : {}", freeGoodsList.getExtraData().get("goodsResult"));
                        List<FreebieGoodsVO> freebieList2 = new ArrayList();
                        freebieList2 = (List<FreebieGoodsVO>) freeGoodsList.getExtraData().get("goodsResult");
                        if (freebieList2 != null && freebieList2.size() > 0) {
                            for (int m = 0; m < freebieList2.size(); m++) {
                                FreebieGoodsVO freebieGoodsVO = freebieList2.get(m);
                                freebieGoodsList.add(freebieGoodsVO);
                            }
                        }
                    }
                }
                // 사은품 제공 조건에 따라 해당 사은품을 추출
                long maxAmt = 0;
                int freebie_No = 0;
                for (int k = 0; k < freebieGoodsList.size(); k++) {
                    FreebieGoodsVO freebieGoodsVO = freebieGoodsList.get(k);
                    if ("02".equals(freebieGoodsVO.getFreebiePresentCndtCd())) {
                        freebie_No = freebieGoodsVO.getFreebieEventNo();
                        break;
                    } else {
                        if (maxAmt < freebieGoodsVO.getFreebieEventAmt()) {
                            maxAmt = freebieGoodsVO.getFreebieEventAmt();
                            freebie_No = freebieGoodsVO.getFreebieEventNo();
                        }
                    }
                }
                // 사은품목록에서 해당 사은품을 제외한 나머지는 삭제
                for (int k = 0; k < freebieGoodsList.size(); k++) {
                    FreebieGoodsVO freebieGoodsVO = freebieGoodsList.get(k);
                    if (freebie_No != freebieGoodsVO.getFreebieEventNo()) {
                        freebieGoodsList.remove(k);
                    }
                }
                list.get(i).setFreebieGoodsList(freebieGoodsList);
            }
        }

        mav.addObject("so", so);
        mav.addObject("basket_list", list);
        mav.addObject("basket_list_json", jsonList);
        mav.addObject("basket_size", basket_list.size());
        mav.addObject("memberNoYn", memberNoYn);
        mav.addObject("interest_goods", interest_goods);

        return mav;
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 2.
     * 작성자 : dong
     * 설명   : 장바구니 쿠키정보 조회
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 2. dong - 최초생성
     * </pre>
     *
     * @param mav
     * @return
     * @throws Exception
     */
    public  List<BasketVO> basketCookieList(HttpServletRequest request,BasketSO so) throws Exception{
        List<BasketVO> basket_list = new ArrayList<>();
        HttpSession session = request.getSession();
        List<BasketPO> basket_session = (List<BasketPO>) session.getAttribute("basketSession");
        BasketVO itemInfo = new BasketVO();
        if (basket_session != null) {
            for (int i = 0; i < basket_session.size(); i++) {
                String itemNo = basket_session.get(i).getItemNo();
                long attrVer = basket_session.get(i).getAttrVer();
                String dlvrcPaymentCd = basket_session.get(i).getDlvrcPaymentCd();
                String ctgNo = basket_session.get(i).getCtgNo();
                BasketSO basketSO = new BasketSO();
                basketSO.setItemNo(itemNo);
                basketSO.setAttrVer(attrVer);
                basketSO.setSiteNo(so.getSiteNo());
                itemInfo = frontBasketService.selectItemInfo(basketSO);

                BasketVO basketVO = new BasketVO();
                basketVO.setBasketNo(basket_session.get(i).getBasketNo());
                basketVO.setItemNo(itemNo);
                basketVO.setGoodsSaleStatusCd(itemInfo.getGoodsSaleStatusCd());
                basketVO.setStockQtt(itemInfo.getStockQtt());
                basketVO.setUseYn(itemInfo.getUseYn());
                basketVO.setGoodsDispImgC(itemInfo.getGoodsDispImgC());
                basketVO.setGoodsNo(itemInfo.getGoodsNo());
                basketVO.setBrandNo(itemInfo.getBrandNo());
                basketVO.setGoodsNm(itemInfo.getGoodsNm());
                basketVO.setOptNo1Nm(itemInfo.getOptNo1Nm());
                basketVO.setAttrNo1Nm(itemInfo.getAttrNo1Nm());
                basketVO.setOptNo2Nm(itemInfo.getOptNo2Nm());
                basketVO.setAttrNo2Nm(itemInfo.getAttrNo2Nm());
                basketVO.setOptNo3Nm(itemInfo.getOptNo3Nm());
                basketVO.setAttrNo3Nm(itemInfo.getAttrNo3Nm());
                basketVO.setOptNo4Nm(itemInfo.getOptNo4Nm());
                basketVO.setAttrNo4Nm(itemInfo.getAttrNo4Nm());
                basketVO.setDlvrcPaymentCd(dlvrcPaymentCd);
                basketVO.setDlvrSetCd(itemInfo.getDlvrSetCd());
                basketVO.setMinOrdLimitYn(itemInfo.getMinOrdLimitYn());
                basketVO.setMinOrdQtt(itemInfo.getMinOrdQtt());
                basketVO.setMaxOrdLimitYn(itemInfo.getMaxOrdLimitYn());
                basketVO.setMaxOrdQtt(itemInfo.getMaxOrdQtt());
                basketVO.setMultiOptYn(itemInfo.getMultiOptYn());
                basketVO.setRsvOnlyYn(itemInfo.getRsvOnlyYn());
                basketVO.setCtgNo(Long.parseLong(ctgNo));
                if (basket_session.get(i).getItemVer() == itemInfo.getItemVer()) {
                    basketVO.setItemVerChk("Y");
                } else {
                    basketVO.setItemVerChk("N");
                }

                if (basket_session.get(i).getAttrVer() == itemInfo.getAttrVer()) {
                    basketVO.setAttrVerChk("Y");
                } else {
                    basketVO.setAttrVerChk("N");
                }

                // 기획전 할인정보 조회
                basketVO.setSiteNo(so.getSiteNo());
                basketVO = frontBasketService.promotionDcInfo(basketVO);
                int addTotalPrice = 0;
                int addBuyQtt = 0;
                int addPrice = 0;
                List<BasketOptVO> basketOptVOList = new ArrayList<>();
                List<BasketOptPO> basketOpt_session = basket_session.get(i).getBasketOptList();
                if (basketOpt_session != null) {
                    for (int j = 0; j < basketOpt_session.size(); j++) {
                        BasketOptVO basketOptVOInfo = new BasketOptVO();
                        BasketOptSO basketOptSO = new BasketOptSO();
                        basketOptSO.setGoodsNo(basket_session.get(i).getGoodsNo());
                        basketOptSO.setAddOptNo(basketOpt_session.get(j).getAddOptNo());
                        basketOptSO.setAddOptDtlSeq(basketOpt_session.get(j).getAddOptDtlSeq());
                        BasketOptVO addOptInfo = frontBasketService.addOptInfo(basketOptSO);
                        basketOptVOInfo.setAddOptNo(addOptInfo.getAddOptNo());
                        basketOptVOInfo.setAddOptDtlSeq(addOptInfo.getAddOptDtlSeq());
                        basketOptVOInfo.setAddOptNm(addOptInfo.getAddOptNm());
                        basketOptVOInfo.setAddOptValue(addOptInfo.getAddOptValue());
                        basketOptVOInfo.setAddOptAmtChgCd(addOptInfo.getAddOptAmtChgCd());
                        basketOptVOInfo.setAddOptAmt(addOptInfo.getAddOptAmt());
                        basketOptVOInfo.setOptBuyQtt(basketOpt_session.get(j).getOptBuyQtt());
                        basketOptVOList.add(basketOptVOInfo);

                        addBuyQtt = basketOptVOInfo.getOptBuyQtt();
                        String addOptAmtChgCd = basketOptVOInfo.getAddOptAmtChgCd();

                        addPrice = basketOptVOInfo.getAddOptAmt();
                        if ("2".equals(addOptAmtChgCd)) {
                            addPrice = -addPrice;
                        }
                        addTotalPrice = addTotalPrice + addBuyQtt * addPrice;

                    }
                }
                int buyQtt = basket_session.get(i).getBuyQtt();
                int salePrice = (int) itemInfo.getSalePrice();
                int dcAmt = (int) itemInfo.getDcAmt();
                int totalPrice = salePrice * buyQtt - dcAmt + addTotalPrice;

                basketVO.setBuyQtt(buyQtt);
                basketVO.setSalePrice(salePrice);
                basketVO.setTotalPrice(totalPrice);
                basketVO.setBasketOptList(basketOptVOList);
                basket_list.add(basketVO);
            }
        }

        return basket_list;
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 2.
     * 작성자 : dong
     * 설명   : 장바구니 상품정보 등록
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 2. dong - 최초생성
     * </pre>
     *
     * @param mav
     * @return
     * @throws Exception
     */
    @RequestMapping("/basket-insert")
    public @ResponseBody ResultModel<BasketPO> insertBasket(@Validated(InsertGroup.class) BasketPO po,
            BindingResult bindingResult, HttpServletRequest request, HttpSession session) throws Exception {
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }
        ResultModel<BasketPO> result = new ResultModel<>();
        Long memberNo = SessionDetailHelper.getDetails().getSession().getMemberNo();

        // 상품보관갯수 검증
        ResultListModel<BasicInfoVO> cacheResult = basicInfoService.selectBasicInfo(po.getSiteNo());
        SiteVO siteVo = (SiteVO) cacheResult.get(RequestAttributeConstants.FRONT_SITE_INFO);

        int listCnt = 0;
        if (memberNo != null) {
            BasketSO countSo = new BasketSO();
            countSo.setSiteNo(po.getSiteNo());
            countSo.setMemberNo(memberNo);
            listCnt = frontBasketService.selectBasketTotalCount(countSo).intValue();
        } else {
            List<BasketPO> sessionList = (List<BasketPO>) session.getAttribute("basketSession");
            if (sessionList != null) {
                listCnt = sessionList.size();
            }
        }

        if ("Y".equals(siteVo.getGoodsKeepQttLimitYn())) {
            int keepQtt = Integer.parseInt(siteVo.getGoodsKeepQtt());
            if (listCnt >= keepQtt) {
                result.setSuccess(false);
                result.setMessage("장바구니 등록은 최대 " + keepQtt + "개 까지 가능합니다.");
                return result;
            }
        }

        // 01.상품기본정보 조회
        GoodsDetailSO gso = new GoodsDetailSO();
        gso.setSaleYn("Y");
        gso.setGoodsNo(po.getGoodsNo());
        ResultModel<GoodsDetailVO> goodsInfo = new ResultModel<GoodsDetailVO>();
        goodsInfo = goodsManageService.selectGoodsInfo(gso);

        // 회원 장바구니 정보를 DB에 담기
        if (memberNo != null) {
            // 02.성인상품 검증
            if (goodsInfo != null && goodsInfo.getData() != null) {
                String adultCertifyYn = goodsInfo.getData().getAdultCertifyYn();
                if ("Y".equals(adultCertifyYn)) {
                    if (!SessionDetailHelper.getDetails().getSession().getAdult()) {
                        BasketPO tempPo = new BasketPO();
                        tempPo.setAdultFlag("Y");
                        result.setData(tempPo);
                        result.setSuccess(false);
                        return result;
                    }
                }
            }
            result = frontBasketService.insertBasket(po);
        } else {
            // 비회원 장바구니 정보를 세션에 담기
            // 02.성인상품 검증
            if (goodsInfo != null && goodsInfo.getData() != null) {
                String adultCertifyYn = goodsInfo.getData().getAdultCertifyYn();
                if ("Y".equals(adultCertifyYn)) {
                    BasketPO tempPo = new BasketPO();
                    tempPo.setAdultFlag("Y");
                    result.setData(tempPo);
                    result.setSuccess(false);
                    return result;
                }
            }
            result = frontBasketService.insertBasketSession(po, request);
        }
        return result;
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 2.
     * 작성자 : dong
     * 설명   : 장바구니 상품정보 수량 변경
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 2. dong - 최초생성
     * </pre>
     *
     * @param mav
     * @return
     * @throws Exception
     */
    @RequestMapping("/basket-count-update")
    public @ResponseBody ResultModel<BasketPO> updateBasketCnt(@Validated(UpdateGroup.class) BasketPO po,
            BindingResult bindingResult, HttpServletRequest request) throws Exception {
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }
        ResultModel<BasketPO> result = new ResultModel<>();
        Long memberNo = SessionDetailHelper.getDetails().getSession().getMemberNo();

        if (memberNo != null) {// 회원 장바구니 정보를 DB에 담기
            po.setMemberNo(memberNo);
            result = frontBasketService.updateBasketCnt(po);
        } else {// 비회원 장바구니 정보를 쿠키에 담기
            result = frontBasketService.updateBasketCntSession(po, request);
        }
        return result;
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 2.
     * 작성자 : dong
     * 설명   : 장바구니 상품정보 삭제
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 2. dong - 최초생성
     * </pre>
     *
     * @param mav
     * @return
     * @throws Exception
     */
    @RequestMapping("/basket-delete")
    public @ResponseBody ResultModel<BasketPO> deleteBasket(@Validated(DeleteGroup.class) BasketPO po,
            BindingResult bindingResult, HttpServletRequest request) throws Exception {
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }
        ResultModel<BasketPO> result = new ResultModel<>();
        Long memberNo = SessionDetailHelper.getDetails().getSession().getMemberNo();

        if (memberNo != null) {// 회원 장바구니 정보를 DB에 담기
            po.setMemberNo(memberNo);
            result = frontBasketService.deleteBasket(po);
        } else {// 비회원 장바구니 정보를 쿠키에 담기
            result = frontBasketService.deleteBasketSession(po, request);
        }
        return result;
    }

    @RequestMapping("/check-basket-delete")
    public @ResponseBody ResultModel<BasketPO> selectDeleteBasket(@Validated(DeleteGroup.class) BasketPO po,
            BindingResult bindingResult, HttpServletRequest request) throws Exception {
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }
        ResultModel<BasketPO> result = new ResultModel<>();
        Long memberNo = SessionDetailHelper.getDetails().getSession().getMemberNo();
        long[] selectBasketNoList = po.getDelBasketNoArr();

        BasketPO bpo = new BasketPO();
        HttpSession session = request.getSession();

        int sessionSize = 0;
        List<BasketPO> basketSession = null;
        if (memberNo == null) {
            basketSession = (List<BasketPO>) session.getAttribute("basketSession");
            sessionSize = basketSession.size();
        }

        for (int i = 0; i < selectBasketNoList.length; i++) {
            if (memberNo != null) {
                bpo.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
                bpo.setBasketNo((int) (long) selectBasketNoList[i]);
                bpo.setMemberNo(memberNo);
                result = frontBasketService.deleteBasket(bpo);
            } else {
                if (selectBasketNoList.length == sessionSize) { // 전체삭제
                    bpo.setSessionIndex(0);
                    bpo.setAllDeleteFlag("Y");
                } else { // 선택삭제
                    bpo.setSessionIndex((int) selectBasketNoList[i]);
                    bpo.setAllDeleteFlag("N");
                }
                result = frontBasketService.deleteBasketSession(bpo, request);
            }
        }

        return result;
    }

    /**
     * <pre>
     * 작성일 : 2016. 7. 20.
     * 작성자 : dong
     * 설명   : 장바구니 상품상세 조회
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 7. 20. dong - 최초생성
     * </pre>
     *
     * @param so
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/goods-detail")
    public ModelAndView selectGoodsInfo(@Validated GoodsDetailSO so, BindingResult bindingResult,
            HttpServletRequest request, HttpServletResponse response) throws Exception {

        ModelAndView mav = SiteUtil.getSkinView();

        mav.setViewName("/basket/basket_update");

        if ("".equals(so.getGoodsNo()) || so.getGoodsNo() == null) {
            throw new Exception(MessageUtil.getMessage("front.web.common.wrongapproach"));
        }

        // 01.상품기본정보 조회
        String itemNo = so.getItemNo();
        so.setItemNo("");
        // 01.상품기본정보 조회
        so.setSaleYn("Y");
        so.setDelYn("N");
        String[] goodsStatus = { "1", "2" };
        so.setGoodsStatus(goodsStatus);
        ResultModel<GoodsDetailVO> goodsInfo = goodsManageService.selectGoodsInfo(so);
        mav.addObject("goodsInfo", goodsInfo);

        // 02.단품정보
        String jsonList = "";
        if (goodsInfo.getData().getGoodsItemList() != null) {
            ObjectMapper mapper = new ObjectMapper();
            jsonList = mapper.writeValueAsString(goodsInfo.getData().getGoodsItemList());
        }

        // 03.장바구니 단건 조회
        Long memberNo = SessionDetailHelper.getDetails().getSession().getMemberNo();
        if (memberNo != null) {// 회원 장바구니 정보를 DB에 담기
            BasketSO basketSo = new BasketSO();
            basketSo.setItemNo(itemNo);
            basketSo.setMemberNo(memberNo);
            List<BasketVO> basketList = frontBasketService.selectBasketList(basketSo);
            BasketVO basketInfo = basketList.get(0);
            List<BasketOptVO> basketOptVOList = basketList.get(0).getBasketOptList();
            String jsonList2 = "";
            ObjectMapper mapper = new ObjectMapper();
            jsonList2 = mapper.writeValueAsString(basketOptVOList);
            List<GoodsItemVO> itemInfoList = goodsInfo.getData().getGoodsItemList();
            GoodsItemVO itemInfo = new GoodsItemVO();
            if (itemInfoList != null) {
                for (int i = 0; i < itemInfoList.size(); i++) {
                    if (basketInfo.getItemNo().equals(itemInfoList.get(i).getItemNo())) {
                        itemInfo = itemInfoList.get(i);
                    }
                }
            }
            mav.addObject("basketInfo", basketInfo);
            mav.addObject("basketOptInfo", jsonList2);
            mav.addObject("itemInfo", itemInfo);
        } else {
            HttpSession session = request.getSession();
            List<BasketPO> basketSession = (List<BasketPO>) session.getAttribute("basketSession");
            BasketPO basketInfo = basketSession.get(so.getSessionIndex());

            List<GoodsItemVO> itemInfoList = goodsInfo.getData().getGoodsItemList();
            GoodsItemVO itemInfo = new GoodsItemVO();
            if (itemInfoList != null) {
                for (int i = 0; i < itemInfoList.size(); i++) {
                    if (basketInfo.getItemNo().equals(itemInfoList.get(i).getItemNo())) {
                        itemInfo = itemInfoList.get(i);
                    }
                }
            }
            if (basketInfo.getItemVer() == itemInfo.getItemVer()) {
                basketInfo.setItemVerChk("Y");
            } else {
                basketInfo.setItemVerChk("N");
            }

            if (basketInfo.getAttrVer() == itemInfo.getAttrVer()) {
                basketInfo.setAttrVerChk("Y");
            } else {
                basketInfo.setAttrVerChk("N");
            }

            List<BasketOptPO> basketOptPOList = basketInfo.getBasketOptList();

            List<BasketOptVO> basketOptVOList = new ArrayList<BasketOptVO>();
            if (basketOptPOList != null) {

                for (int j = 0; j < basketOptPOList.size(); j++) {
                    BasketOptSO basketOptSO = new BasketOptSO();
                    basketOptSO.setGoodsNo(so.getGoodsNo());
                    basketOptSO.setAddOptNo(basketOptPOList.get(j).getAddOptNo());
                    basketOptSO.setAddOptDtlSeq(basketOptPOList.get(j).getAddOptDtlSeq());

                    BasketOptVO addOptInfo = frontBasketService.addOptInfo(basketOptSO);
                    addOptInfo.setOptBuyQtt(basketOptPOList.get(j).getOptBuyQtt());
                    basketOptVOList.add(addOptInfo);
                }
            }
            String jsonList2 = "";
            ObjectMapper mapper = new ObjectMapper();
            jsonList2 = mapper.writeValueAsString(basketOptVOList);

            mav.addObject("basketInfo", basketInfo);
            mav.addObject("basketOptInfo", jsonList2);
            mav.addObject("itemInfo", itemInfo);
        }

        // 09.기획전 할인정보 조회
        ExhibitionSO pso = new ExhibitionSO();
        pso.setSiteNo(so.getSiteNo());
        pso.setGoodsNo(so.getGoodsNo());
        String prmtBrandNo ="";
        if(goodsInfo.getData().getBrandNo()!=null && !goodsInfo.getData().getBrandNo().equals("")) {
            prmtBrandNo = goodsInfo.getData().getBrandNo();
            pso.setPrmtBrandNo(prmtBrandNo);
        }
        mav.addObject("promotionInfo", exhibitionService.selectExhibitionByGoods(pso));

        // 10.사은품대상조회
        ResultListModel<FreebieTargetVO> freebieEventList = new ResultListModel<>();
        FreebieCndtSO freebieCndtSO = new FreebieCndtSO();
        freebieCndtSO.setGoodsNo(goodsInfo.getData().getGoodsNo());
        freebieCndtSO.setSiteNo(so.getSiteNo());
        freebieEventList = freebieCndtService.selectFreebieListByGoodsNo(freebieCndtSO);
        List<FreebieGoodsVO> freebieList = (List<FreebieGoodsVO>) freebieEventList.getExtraData().get("goodsResult");
        List<FreebieGoodsVO> freebieGoodsList = new ArrayList();
        // 사은품 조회
        if (freebieList != null && freebieList.size() > 0) {
            for (int j = 0; j < freebieList.size(); j++) {
                FreebieGoodsVO freebieEventVO = freebieList.get(j);
                FreebieCndtSO freebieGoodsSO = new FreebieCndtSO();
                freebieGoodsSO.setSiteNo(so.getSiteNo());
                freebieGoodsSO.setFreebieEventNo(freebieEventVO.getFreebieEventNo());
                ResultModel<FreebieCndtVO> freeGoodsList = new ResultModel<>();
                freeGoodsList = freebieCndtService.selectFreebieCndtDtl(freebieGoodsSO);
                log.debug("== freeGoodsList : {}", freeGoodsList.getExtraData().get("goodsResult"));
                List<FreebieGoodsVO> freebieList2 = new ArrayList();
                freebieList2 = (List<FreebieGoodsVO>) freeGoodsList.getExtraData().get("goodsResult");
                if (freebieList2 != null && freebieList2.size() > 0) {
                    for (int m = 0; m < freebieList2.size(); m++) {
                        FreebieGoodsVO freebieGoodsVO = freebieList2.get(m);
                        freebieGoodsList.add(freebieGoodsVO);
                    }
                }
            }
        }
        // 사은품 제공 조건에 따라 해당 사은품을 추출
        long maxAmt = 0;
        String freebie_No = "";
        for (int i = 0; i < freebieGoodsList.size(); i++) {
            FreebieGoodsVO freebieGoodsVO = freebieGoodsList.get(i);
            if ("02".equals(freebieGoodsVO.getFreebiePresentCndtCd())) {
                freebie_No = freebieGoodsVO.getFreebieNo();
                break;
            } else {
                if (maxAmt < freebieGoodsVO.getFreebieEventAmt()) {
                    maxAmt = freebieGoodsVO.getFreebieEventAmt();
                    freebie_No = freebieGoodsVO.getFreebieNo();
                }
            }
        }
        // 사은품목록에서 해당 사은품을 제외한 나머지는 삭제
        for (int i = 0; i < freebieGoodsList.size(); i++) {
            FreebieGoodsVO freebieGoodsVO = freebieGoodsList.get(i);
            if (freebie_No != freebieGoodsVO.getFreebieNo()) {
                freebieGoodsList.remove(i);
            }
        }
        mav.addObject("freebieGoodsList", freebieGoodsList);

        mav.addObject("goodsItemInfo", jsonList);
        mav.addObject("so", so);
        return mav;
    }
}