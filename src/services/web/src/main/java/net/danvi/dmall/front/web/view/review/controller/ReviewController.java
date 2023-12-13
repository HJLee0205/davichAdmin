package net.danvi.dmall.front.web.view.review.controller;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.Locale;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;

import dmall.framework.common.exception.JsonValidationException;
import dmall.framework.common.model.ResultModel;
import dmall.framework.common.util.DateUtil;
import dmall.framework.common.util.MessageUtil;
import dmall.framework.common.util.SiteUtil;
import dmall.framework.common.util.StringUtil;
import lombok.extern.slf4j.Slf4j;
import net.danvi.dmall.biz.app.operation.model.AtchFilePO;
import net.danvi.dmall.biz.app.operation.model.BbsLettManagePO;
import net.danvi.dmall.biz.app.operation.model.BbsLettManageSO;
import net.danvi.dmall.biz.app.operation.model.BbsLettManageVO;
import net.danvi.dmall.biz.app.operation.model.SavedmnPointPO;
import net.danvi.dmall.biz.app.operation.service.BbsManageService;
import net.danvi.dmall.biz.app.operation.service.SavedMnPointService;
import net.danvi.dmall.biz.app.order.manage.model.OrderGoodsVO;
import net.danvi.dmall.biz.app.order.manage.model.OrderSO;
import net.danvi.dmall.biz.app.order.manage.service.OrderService;
import net.danvi.dmall.biz.app.setup.siteinfo.model.SiteSO;
import net.danvi.dmall.biz.app.setup.siteinfo.model.SiteVO;
import net.danvi.dmall.biz.app.setup.siteinfo.service.SiteInfoService;
import net.danvi.dmall.biz.app.setup.term.model.TermConfigSO;
import net.danvi.dmall.biz.app.setup.term.service.TermConfigService;
import net.danvi.dmall.biz.system.security.SessionDetailHelper;
import net.danvi.dmall.biz.system.validation.DeleteGroup;
import net.danvi.dmall.biz.system.validation.InsertGroup;
import net.danvi.dmall.biz.system.validation.UpdateGroup;

/**
 * <pre>
 * - 프로젝트명    : 31.front.web
 * - 패키지명      : front.web.view.review.controller
 * - 파일명        : ReviewController.java
 * - 작성일        : 2016. 5. 2.
 * - 작성자        : dong
 * - 설명          : 상품후기 Controller
 * </pre>
 */
@Slf4j
@Controller
@RequestMapping("/front/review")
public class ReviewController {
    @Resource(name = "bbsManageService")
    private BbsManageService bbsManageService;

    @Resource(name = "orderService")
    private OrderService orderService;

    @Resource(name = "savedMnPointService")
    private SavedMnPointService savedMnPointService;

    @Resource(name = "siteInfoService")
    private SiteInfoService siteInfoService;

    @Value("#{system['system.upload.path']}")
    private String filePath;

    @Resource(name = "termConfigService")
    private TermConfigService termConfigService;

    /**
     * <pre>
     * 작성일 : 2016. 5. 18.
     * 작성자 : dong
     * 설명 : 상품후기 조회
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 18. dong - 최초생성
     */
    @RequestMapping("/review-list")
    public ModelAndView viewBbsListPaging(@Validated BbsLettManageSO so, BindingResult bindingResult) {
        ModelAndView mv = SiteUtil.getSkinView("/mypage/review_list");

        // 로그인여부 체크
        if (!SessionDetailHelper.getDetails().isLogin()) {
            mv.addObject("exMsg", MessageUtil.getMessage("biz.exception.lng.loginRequired"));
            mv.setViewName("/error/notice");
            return mv;
        }

        so.setBbsId("review");
        so.setExpsYn("Y"); // 노출여부
        mv.addObject(so);
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            return mv;
        }
        // default 기간검색(최근3일)
        if (StringUtil.isEmpty(so.getFromRegDt()) || StringUtil.isEmpty(so.getToRegDt())) {
            Calendar cal = new GregorianCalendar(Locale.KOREA);
            cal.add(Calendar.DAY_OF_YEAR, -3);
            SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
            String fromRegDt = df.format(cal.getTime());
            String toRegDt = df.format(new Date());
            so.setFromRegDt(fromRegDt);
            so.setToRegDt(toRegDt);
        }
        so.setMemberNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
        mv.addObject("so", so);
        mv.addObject("leftMenu", "review");
        mv.addObject("resultListModel", bbsManageService.selectBbsLettPaging(so));
        return mv;
    }

    // 2016.08.29 모바일
    // 마이페이지_상품후기 ajax
    @RequestMapping("/revew-paging")
    public ModelAndView viewListPaging(@Validated BbsLettManageSO so, BindingResult bindingResult) {
        ModelAndView mv = new ModelAndView("/mypage/ajaxReviewList");
        so.setBbsId("review");
        so.setExpsYn("Y"); // 노출여부
        mv.addObject(so);
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            return mv;
        }

        so.setMemberNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
        mv.addObject("so", so);
        mv.addObject("leftMenu", "review");
        mv.addObject("resultListModel", bbsManageService.selectBbsLettPaging(so));
        return mv;
    }

    @RequestMapping(value = "/review-list-ajax")
    public ModelAndView ajaxReviewList(@Validated BbsLettManageSO so, BindingResult bindingResult) throws Exception {
        ModelAndView mv = SiteUtil.getSkinView("/goods/goods_info_02");
        so.setBbsId("review");
        so.setExpsYn("Y"); // 노출여부
        mv.addObject(so);
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            return mv;
        }

        ResultModel<BbsLettManageVO> resultModel = bbsManageService.goodsBbsInfo(so);
        boolean ordYn = false; // 상품 구매 여부;
        boolean reviewYn = false; // 구매 후기 작성 여부(일반);
        boolean reviewPmYn = false; // 구매 후기 작성 여부 (프리미엄);
        boolean reviewTotYn = false; // 구매 후기 작성 여부
        if (SessionDetailHelper.getDetails().isLogin()) {
            OrderSO orderSO = new OrderSO();
            orderSO.setGoodsNo(so.getGoodsNo());
            orderSO.setMemberNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
            OrderGoodsVO orderGoodsVO = orderService.selectOrdGoodsReview(orderSO);
            if (orderGoodsVO.getOrdCnt() > 0) {
                ordYn = true;
            }
            
            if (orderGoodsVO.getOrdCnt() <= orderGoodsVO.getReviewCnt()) {
            	reviewYn = true;
            }
            if (orderGoodsVO.getOrdCnt() <= orderGoodsVO.getReviewPmCnt()) {
            	reviewPmYn = true;
            }
            
            if (orderGoodsVO.getOrdCnt() * 2 <= (orderGoodsVO.getReviewCnt() + orderGoodsVO.getReviewPmCnt())) {
            	reviewTotYn = true;
            }
        }

        // 04.상품문의.상품평.상품평평균치 조회
        BbsLettManageSO blmSo = new BbsLettManageSO();
        blmSo.setSiteNo(so.getSiteNo());
        blmSo.setGoodsNo(so.getGoodsNo());
        mv.addObject("goodsBbsInfo", bbsManageService.goodsBbsInfo(blmSo));

        // 06.배송,반품,환불정책 조회
        TermConfigSO tso = new TermConfigSO();
        tso.setSiteNo(so.getSiteNo());
        tso.setSiteInfoCd("14"); // 배송정책
        mv.addObject("term_14", termConfigService.selectTermConfig(tso));
        tso.setSiteInfoCd("15"); // 반품정책tso
        mv.addObject("term_15", termConfigService.selectTermConfig(tso));
        tso.setSiteInfoCd("16"); // 환불정책
        mv.addObject("term_16", termConfigService.selectTermConfig(tso));

        mv.addObject("so", so);
        mv.addObject("ordYn", ordYn); // 상품 구매 여부
        mv.addObject("reviewYn", reviewYn); // 구매 후기 작성 여부 (일반)
        mv.addObject("reviewPmYn", reviewPmYn); // 구매 후기 작성 여부 (프리미엄)
        mv.addObject("reviewTotYn", reviewTotYn); // 구매 후기 작성 여부
        mv.addObject("averageScore", resultModel.getData().getAverageScore());
        mv.addObject("reviewList", bbsManageService.selectBbsLettPaging(so));

        so.setMobileYn("Y");// 모바일 여부
        mv.addObject("replyList", bbsManageService.selectBbsLettPaging(so));
        return mv;
    }

    // 2016.08.29
    // 상품 후기 리스트_ajax 추가
    @RequestMapping(value = "/review-paging-ajax")
    public ModelAndView ajaxReviewPage(@Validated BbsLettManageSO so, BindingResult bindingResult) throws Exception {
        ModelAndView mv = new ModelAndView("/goods/ajaxReviewList");
        so.setBbsId("review");
        so.setExpsYn("Y"); // 노출여부
        mv.addObject(so);
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            return mv;
        }
        ResultModel<BbsLettManageVO> resultModel = bbsManageService.goodsBbsInfo(so);
        mv.addObject("so", so);
        mv.addObject("averageScore", resultModel.getData().getAverageScore());
        mv.addObject("reviewList", bbsManageService.selectBbsLettPaging(so));
        return mv;
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 18.
     * 작성자 : dong
     * 설명 : 상품후기 조회(상세)
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 18. dong - 최초생성
     */
    @RequestMapping(value = "/review-detail")
    public @ResponseBody ResultModel<BbsLettManageVO> selectReview(@Validated BbsLettManageSO so,
            BindingResult bindingResult) throws Exception {
        so.setBbsId("review");
        ResultModel<BbsLettManageVO> result = new ResultModel<>();
        result = bbsManageService.selectBbsLettDtl(so);
        return result;
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 11.
     * 작성자 : dong
     * 설명   : 상품후기 등록
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 11. dong - 최초생성
     * </pre>
     */
    @RequestMapping("/review-insert")
    public @ResponseBody ResultModel insertReview(@Validated(InsertGroup.class) BbsLettManagePO po,
            BindingResult bindingResult, HttpServletRequest request) throws Exception {
        ResultModel<BbsLettManagePO> result = new ResultModel<>();
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }

        if (po.getRegrNo() == null) {
            result.setSuccess(false);
            result.setMessage(MessageUtil.getMessage("biz.exception.lng.loginRequired"));
            return result;
        }
        
        SiteSO siteSo = new SiteSO();
        siteSo.setSiteNo(po.getSiteNo());
        ResultModel<SiteVO> siteInfo = siteInfoService.selectSiteInfo(siteSo);

        if ("Y".equals(siteInfo.getData().getPointPvdYn())) {
        	String buyPoint = Long.toString(siteInfo.getData().getBuyEplgWritePoint());
        	
            // 다중 파일 정보 조회
            if (request instanceof MultipartHttpServletRequest) {
                buyPoint = Long.toString(siteInfo.getData().getBuyEplgWritePmPoint());
            }
            
            po.setSvmnPayYn("Y");  //적립금 지급여부
            po.setSvmnPayAmt(Integer.valueOf(buyPoint)); //상품후기 적립금
        	
            SavedmnPointPO spp = new SavedmnPointPO();
            spp.setMemberNo(po.getRegrNo());
            spp.setGbCd("10");// 구분 코드(10:지급,20:차감)
            spp.setTypeCd("A");// 유형 코드(A:자동,M:수동)
            spp.setReasonCd("03");// 사유코드(신규 회원 가입 지금 : 01 ,상품 구매 추가 적립 : 02,상품 구매 사용 차감 : 03,유효 기간 소멸 차감 : 04, 기타 : 05)
            spp.setPrcPoint(buyPoint);// 구매후기 작성포인트
            String nowday = DateUtil.getNowDate();
            String validPreridDate = DateUtil.addMonths(nowday, siteInfo.getData().getPointAccuValidPeriod());
            spp.setEtcValidPeriod(validPreridDate);// 마켓포인트 유효기간 코드(직접입력,제한없음,12월31일)
            spp.setPointUsePsbYn("Y");// 포인트 사용 가능 여부
            savedMnPointService.insertPoint(spp);
        }
        
        // 다중 파일 정보 조회
        if (request instanceof MultipartHttpServletRequest) {
            po.setBbsGrade("P");  //[프리미엄] 후기등급 
        } else {
            po.setBbsGrade("G");  //[일반] 후기등급  
        }
        
        po.setBbsId("review");
        po.setMemberNo(po.getRegrNo());
        result = bbsManageService.insertBbsLett(po, request);
        
        return result;
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 18.
     * 작성자 : dong
     * 설명 : 상품후기 수정
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 18. dong - 최초생성
     */
    @RequestMapping("/review-update")
    public @ResponseBody ResultModel updateReview(@Validated(UpdateGroup.class) BbsLettManagePO po,
            BindingResult bindingResult, HttpServletRequest request) throws Exception {
        ResultModel<BbsLettManagePO> result = new ResultModel<>();
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }
        result = bbsManageService.updateBbsLett(po, request);
        return result;
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 18.
     * 작성자 : dong
     * 설명 : 상품후기 삭제
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 18. dong - 최초생성
     */
    @RequestMapping("/review-delete")
    public @ResponseBody ResultModel deleteReview(@Validated(DeleteGroup.class) BbsLettManagePO po,
            BindingResult bindingResult) throws Exception {
        ResultModel<BbsLettManagePO> result = new ResultModel<>();
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }
        po.setBbsId("review");
        
        BbsLettManageVO vo = bbsManageService.getSvmnPay(po);
        if ("Y".equals(vo.getSvmnPayYn())) {
            SavedmnPointPO savedmnPointPO = new SavedmnPointPO();
            savedmnPointPO.setSiteNo(po.getSiteNo());
            savedmnPointPO.setGbCd("20"); // 차감
            savedmnPointPO.setOrdCanselYn("N"); // 일반차감
            savedmnPointPO.setMemberNo(po.getRegrNo()); // 회원번호
            savedmnPointPO.setRegrNo(po.getRegrNo()); // 회원번호
            savedmnPointPO.setTypeCd("A"); // 유형코드(A:자동, M:수동)
            savedmnPointPO.setReasonCd("11"); // 구매후기작성취소
            savedmnPointPO.setEtcReason(""); // 기타사유
            savedmnPointPO.setDeductGbCd("02"); // 차감구분코드(취소)
            savedmnPointPO.setPrcAmt(String.valueOf(vo.getSvmnPayAmt()));
            savedMnPointService.insertSavedMn(savedmnPointPO);
        }
        
        result = bbsManageService.deleteBbsLett(po);
        return result;
    }

    /**
     * <pre>
     * 작성일 : 2016. 6. 7.
     * 작성자 : KMS
     * 설명   : 첨부 파일을 삭제한다.
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 2. KMS - 최초생성
     * </pre>
     *
     * @param po
     * @param bindingResult
     * @return
     * @throws Exception
     */
    @RequestMapping("/attach-file-delete")
    public @ResponseBody ResultModel<AtchFilePO> deleteAtchFile(@Validated(DeleteGroup.class) AtchFilePO po,
                                                                BindingResult bindingResult) throws Exception {
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }

        if (SessionDetailHelper.getDetails().getSession().getMemberNo() != null) {
            po.setDelrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
        }

        ResultModel<AtchFilePO> result = bbsManageService.deleteAtchFile(po);

        return result;
    }
}