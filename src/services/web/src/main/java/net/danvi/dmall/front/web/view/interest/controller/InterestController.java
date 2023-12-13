package net.danvi.dmall.front.web.view.interest.controller;

import java.text.SimpleDateFormat;
import java.util.*;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import dmall.framework.common.util.StringUtil;
import net.danvi.dmall.biz.app.basket.service.FrontBasketService;
import net.danvi.dmall.biz.system.validation.InsertGroup;
import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import lombok.extern.slf4j.Slf4j;
import net.danvi.dmall.biz.app.basicinfo.model.BasicInfoVO;
import net.danvi.dmall.biz.app.basicinfo.service.BasicInfoService;
import net.danvi.dmall.biz.app.basket.model.BasketPO;
import net.danvi.dmall.biz.app.basket.model.BasketSO;
import net.danvi.dmall.biz.app.goods.model.GoodsDetailSO;
import net.danvi.dmall.biz.app.goods.model.GoodsDetailVO;
import net.danvi.dmall.biz.app.goods.service.GoodsManageService;
import net.danvi.dmall.biz.app.interest.model.InterestPO;
import net.danvi.dmall.biz.app.interest.model.InterestSO;
import net.danvi.dmall.biz.app.interest.service.FrontInterestService;
import net.danvi.dmall.biz.app.setup.siteinfo.model.SiteVO;
import net.danvi.dmall.biz.system.security.SessionDetailHelper;
import net.danvi.dmall.biz.system.validation.DeleteGroup;
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
 * - 파일명        : InterestController.java
 * - 작성일        : 2016. 5. 2.
 * - 작성자        : dong
 * - 설명          : 관심상품 Controller
 * </pre>
 */
@Slf4j
@Controller
@RequestMapping("/front/interest")
public class InterestController {
    @Resource(name = "frontInterestService")
    private FrontInterestService frontInterestService;

    @Resource(name = "frontBasketService")
    private FrontBasketService frontBasketService;

    @Resource(name = "goodsManageService")
    private GoodsManageService goodsManageService;

    @Resource(name = "basicInfoService")
    private BasicInfoService basicInfoService;

    /**
     * <pre>
     * 작성일 : 2016. 5. 2.
     * 작성자 : dong
     * 설명   : 관심상품에 등록된 상품정보를 조회한다.
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 2. dong - 최초생성
     * </pre>
     */
    @RequestMapping("/interest-item-list")
    public ModelAndView viewInterestListPaging(@Validated InterestSO so, BindingResult bindingResult) {
        ModelAndView mav = SiteUtil.getSkinView("/mypage/interest_list");
        

        // 로그인여부 체크
        if (!SessionDetailHelper.getDetails().isLogin()) {
            mav.addObject("exMsg", MessageUtil.getMessage("biz.exception.lng.loginRequired"));
            mav.setViewName("/error/notice");
            return mav;
        }

        mav.addObject(so);
        Long memberNo = SessionDetailHelper.getDetails().getSession().getMemberNo();// 사이트번호
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            return mav;
        }
        so.setMemberNo(memberNo);

        // default 기간검색(최근15일)
        if (StringUtil.isEmpty(so.getStRegDttm()) || StringUtil.isEmpty(so.getEndRegDttm())) {
            Calendar cal = new GregorianCalendar(Locale.KOREA);
            cal.add(Calendar.DAY_OF_YEAR, -180);
            SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
            String stRegDttm = df.format(cal.getTime());
            String endRegDttm = df.format(new Date());
            so.setStRegDttm(stRegDttm);
            so.setEndRegDttm(endRegDttm);
        }

        mav.addObject("so", so);
        mav.addObject("leftMenu", "interest");
        mav.addObject("resultListModel", frontInterestService.selectInterestListPaging(so));
        return mav;
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 2.
     * 작성자 : dong
     * 설명   : 관심상품에 상품정보를 등록한다.
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 2. dong - 최초생성
     * </pre>
     */
    @RequestMapping("/interest-item-insert")
    public @ResponseBody ResultModel<InterestPO> insertInterest(@Validated(InsertGroup.class) InterestPO po,
            BindingResult bindingResult) throws Exception {
        Long memberNo = SessionDetailHelper.getDetails().getSession().getMemberNo();// 사이트번호
        if (bindingResult.hasErrors()) {// parameter 검증
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }
        ResultModel<InterestPO> result = new ResultModel<InterestPO>();
        if (memberNo != null) {// 로그인한 고객
            po.setMemberNo(memberNo);
            int goodsCnt = frontInterestService.duplicationCheck(po);
            if (goodsCnt > 0) {
                result.setSuccess(false);
                result.setMessage("이미 등록된 상품이 있습니다");
            } else {
                result = frontInterestService.insertInterest(po);
            }
        } else {
            result.setSuccess(false);
            result.setMessage("로그인후 이용가능합니다.");
        }
        return result;
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 2.
     * 작성자 : dong
     * 설명   : 관심상품 상품정보를 삭제한다
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 2. dong - 최초생성
     * </pre>
     */
    @RequestMapping("/interest-item-delete")
    public @ResponseBody ResultModel<InterestPO> deleteInterest(@Validated(DeleteGroup.class) InterestPO po,
            BindingResult bindingResult) throws Exception {
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }
        ResultModel<InterestPO> result = new ResultModel<InterestPO>();

        result = frontInterestService.deleteInterest(po);

        log.debug("po " + po);
        return result;
    }

    /**
     * <pre>
     * 작성일 : 2016. 8. 3.
     * 작성자 : dong
     * 설명   : 관심상품 상품정보를 장바구니에 등록
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 8. 3. dong - 최초생성
     * </pre>
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

        // 상품기본정보 조회
        for (int i = 0; i < po.getGoodsNoArr().length; i++) {
            GoodsDetailSO validSo = new GoodsDetailSO();
            validSo.setSiteNo(po.getSiteNo());
            validSo.setSaleYn("Y");
            validSo.setDelYn("N");
            validSo.setGoodsNo(po.getGoodsNoArr()[i]);
            ResultModel<GoodsDetailVO> validGoodsInfo = goodsManageService.selectGoodsInfo(validSo);

            if (validGoodsInfo.getData() == null) {
                result.setSuccess(false);
                result.setMessage(
                        "상품[" + validSo.getGoodsNo() + "]" + MessageUtil.getMessage("front.web.goods.noSale"));
                return result;
            }
        }

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

        // 1. 장바구니에 등록하기전 19금상품인지를 조회한다.
        for (int i = 0; i < po.getGoodsNoArr().length; i++) {
            // 01.상품기본정보 조회
            GoodsDetailSO gso = new GoodsDetailSO();
            gso.setSaleYn("Y");
            gso.setGoodsNo(po.getGoodsNoArr()[i]);
            ResultModel<GoodsDetailVO> goodsInfo = new ResultModel<GoodsDetailVO>();
            goodsInfo = goodsManageService.selectGoodsInfo(gso);

            if (memberNo != null) {// 회원 장바구니 정보를 DB에 담기
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
            } else { // 비회원
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
            }
        }

        // 2. 성인인증을 했다면 등록한다.
        if (memberNo != null) {// 회원 장바구니 정보를 DB에 담기
            result = frontInterestService.insertBasket(po);
        } else {// 비회원 장바구니 정보를 쿠키에 담기
            if (po.getGoodsNoArr().length == 1) {
                po.setGoodsNo(po.getGoodsNoArr()[0]);
            }
            InterestSO so = new InterestSO();
            so.setGoodsNo(po.getGoodsNoArr()[0]);
            String[] itemNoArr = new String[1];
            String itemNo = frontInterestService.selectInterest(so).getData().getItemNo();
            itemNoArr[0] = itemNo;
            po.setItemNoArr(itemNoArr);

            String[] noBuyQttArr = new String[1];
            noBuyQttArr[0] = "N";
            po.setNoBuyQttArr(noBuyQttArr);
            result = frontBasketService.insertBasketSession(po, request);
        }
        return result;
    }

    /**
     * <pre>
     * 작성일 : 2016. 8. 22.
     * 작성자 : dong
     * 설명   : 상품정보를 장바구니에 등록(메인,카테고리 -> 장바구니)
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 8. 322. dong - 최초생성
     * </pre>
     */
    @RequestMapping("/check-basket-insert")
    public @ResponseBody ResultModel<BasketPO> insertBasketFromList(@Validated(InsertGroup.class) BasketPO po,
            BindingResult bindingResult, HttpServletRequest request, HttpSession session) throws Exception {
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }

        ResultModel<BasketPO> result = new ResultModel<>();
        Long memberNo = SessionDetailHelper.getDetails().getSession().getMemberNo();

        // 상품기본정보 조회
        GoodsDetailSO validSo = new GoodsDetailSO();
        validSo.setSiteNo(po.getSiteNo());
        validSo.setSaleYn("Y");
        validSo.setDelYn("N");
        validSo.setGoodsNo(po.getGoodsNoArr()[0]);
        ResultModel<GoodsDetailVO> validGoodsInfo = goodsManageService.selectGoodsInfo(validSo);

        if (validGoodsInfo.getData() == null) {
            result.setSuccess(false);
            result.setMessage(MessageUtil.getMessage("front.web.goods.noSale"));
            return result;
        }

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

        if (memberNo != null) {// 회원 장바구니 정보를 DB에 담기
            // 01.상품기본정보 조회
            GoodsDetailSO gso = new GoodsDetailSO();
            gso.setSaleYn("Y");
            gso.setGoodsNo(po.getGoodsNoArr()[0]);
            ResultModel<GoodsDetailVO> goodsInfo = new ResultModel<GoodsDetailVO>();
            goodsInfo = goodsManageService.selectGoodsInfo(gso);

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

            result = frontInterestService.insertBasket(po);
        } else {// 비회원 장바구니 정보를 쿠키에 담기

            if (po.getGoodsNoArr().length == 1) {
                po.setGoodsNo(po.getGoodsNoArr()[0]);
            }

            // 01.상품기본정보 조회
            GoodsDetailSO gso = new GoodsDetailSO();
            gso.setSaleYn("Y");
            gso.setGoodsNo(po.getGoodsNo());
            ResultModel<GoodsDetailVO> goodsInfo = new ResultModel<GoodsDetailVO>();
            goodsInfo = goodsManageService.selectGoodsInfo(gso);

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

            InterestSO so = new InterestSO();
            so.setGoodsNo(po.getGoodsNoArr()[0]);
            String[] itemNoArr = new String[1];
            String itemNo = frontInterestService.selectInterest(so).getData().getItemNo();
            itemNoArr[0] = itemNo;
            po.setItemNoArr(itemNoArr);

            String[] noBuyQttArr = new String[1];
            noBuyQttArr[0] = "N";
            po.setNoBuyQttArr(noBuyQttArr);
            result = frontBasketService.insertBasketSession(po, request);
        }
        return result;
    }

    /**
     * <pre>
     * 작성일 : 2016. 8. 29.
     * 작성자 : dong
     * 설명   : 성인제한페이지 이동
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 8. 29. dong - 최초생성
     * </pre>
     */
    @RequestMapping("/adult-restriction")
    public ModelAndView adultPage() {
        ModelAndView adult_page = new ModelAndView("/login/adult_noti");
        return adult_page;
    }
}