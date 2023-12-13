package net.danvi.dmall.admin.web.view.promotion.coupon.controller;

import java.util.List;

import javax.annotation.Resource;

import dmall.framework.common.util.StringUtil;
import net.danvi.dmall.biz.system.model.CmnCdDtlVO;
import net.danvi.dmall.biz.system.security.SessionDetailHelper;
import net.danvi.dmall.biz.system.util.ServiceUtil;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import lombok.extern.slf4j.Slf4j;
import net.danvi.dmall.admin.web.common.view.View;
import net.danvi.dmall.biz.app.member.manage.model.MemberManageSO;
import net.danvi.dmall.biz.app.member.manage.model.MemberManageVO;
import net.danvi.dmall.biz.app.member.manage.service.MemberManageService;
import net.danvi.dmall.biz.app.promotion.coupon.model.CouponPO;
import net.danvi.dmall.biz.app.promotion.coupon.model.CouponPOListWrapper;
import net.danvi.dmall.biz.app.promotion.coupon.model.CouponSO;
import net.danvi.dmall.biz.app.promotion.coupon.model.CouponVO;
import net.danvi.dmall.biz.app.promotion.coupon.model.CpTargetVO;
import net.danvi.dmall.biz.app.promotion.coupon.service.CouponService;
import net.danvi.dmall.biz.system.validation.DeleteGroup;
import dmall.framework.common.constants.CommonConstants;
import dmall.framework.common.exception.JsonValidationException;
import dmall.framework.common.model.ExcelViewParam;
import dmall.framework.common.model.ResultListModel;
import dmall.framework.common.model.ResultModel;
import dmall.framework.common.util.DateUtil;

/**
 * <pre>
 * 프로젝트명 : 41.admin.web
 * 작성일     : 2016. 5. 02.
 * 작성자     : dong
 * 설명       : 쿠폰 컨트롤러
 * </pre>
 */

@Slf4j
@Controller
@RequestMapping("/admin/promotion")
public class CouponController {

    @Resource(name = "couponService")
    private CouponService couponService;

    @Resource(name = "memberManageService")
    private MemberManageService memberManageService;

    /**
     * <pre>
     * 작성일 : 2016. 5. 2.
     * 작성자 : dong
     * 설명   : 쿠폰목록조회
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 2. dong - 최초생성
     * </pre>
     * 
     * @param so
     * @param bindingResult
     * @return
     */
    @RequestMapping("/coupon")
    public ModelAndView viewCouponListPaging(@Validated CouponSO so, BindingResult bindingResult) {
        ModelAndView mv = new ModelAndView("/admin/promotion/viewCouponList");
        mv.addObject(so);

        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            return mv;
        }

        // 쿠폰종류 초기값으로 모든 종류 선택
        if (so.getCouponKindCds() == null) {
            String[] kindCds = { "01", "03", "04","07" };
            so.setCouponKindCds(kindCds);
        }

        // 페이지번호 오리지널( 목록에서 다른 view로 넘어가기 전, 페이지번호)을 페이지로 주입
        if (so.getPageNoOri() != 0) {
            so.setPage(so.getPageNoOri());
        }
        so.setCouponKindCd(StringUtil.convertStringArrayToString(so.getCouponKindCds(), ","));
        log.info("so : {}", so);
        mv.addObject("so", so);
        mv.addObject("resultListModel", couponService.selectCouponListPaging(so));
        return mv;
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 2.
     * 작성자 : dong
     * 설명   : 쿠폰등록 화면
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 2. dong - 최초생성
     * </pre>
     *
     * @return
     */
    @RequestMapping("/coupon-insert-form")
    public ModelAndView viewCouponInsert() {
        ModelAndView mv = new ModelAndView("/admin/promotion/viewCouponInsert");

        mv.addObject("siteNo", SessionDetailHelper.getDetails().getSiteNo());

        List<CmnCdDtlVO> cmnCdDtlVOList = ServiceUtil.listCode("COUPON_KIND_CD");
        mv.addObject("codeList", cmnCdDtlVOList);

        return mv;
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 2.
     * 작성자 : dong
     * 설명   : 쿠폰수정 화면
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 2. dong - 최초생성
     * </pre>
     *
     * @param so
     * @param bindingResult
     * @return
     */
    @RequestMapping("/coupon-update-form")
    public ModelAndView viewCouponUpdate(@Validated CouponSO so, BindingResult bindingResult)  throws Exception{
        ModelAndView mv = new ModelAndView("/admin/promotion/viewCouponUpdate");

        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }
        // 검색조건
        mv.addObject("so", so);
        // 쿠폰 상세
        mv.addObject("resultModel", couponService.selectCouponDtl(so));
        // 사이트 번호
        mv.addObject("siteNo", SessionDetailHelper.getDetails().getSiteNo());
        // 쿠폰종류 코드
        List<CmnCdDtlVO> cmnCdDtlVOList = ServiceUtil.listCode("COUPON_KIND_CD");
        mv.addObject("codeList", cmnCdDtlVOList);

        return mv;
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 2.
     * 작성자 : dong
     * 설명   : 회원쿠폰발급팝업 화면_ 발급 대상 조회 + 이미 발급한 회원목록 조회
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 2. dong - 최초생성
     * </pre>
     * 
     * @param so
     * @param bindingResult
     * @return
     */
    @RequestMapping("/coupon-target-list")
    public @ResponseBody ResultListModel<CpTargetVO> selectIssueTargetListPop(@Validated CouponSO so,
            BindingResult bindingResult) {
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }
        ResultListModel<CpTargetVO> result = new ResultListModel<CpTargetVO>();
        List<CpTargetVO> list = couponService.selectIssueTargetListPop(so);
        List<CpTargetVO> listed = couponService.selectIssuedTargetListPop(so); /* 쿠폰 중복발급 방지 */
        result.setResultList(list);
        result.put("extra", listed);
        return result;
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 2.
     * 작성자 : dong
     * 설명   : 회원쿠폰발급팝업_ 쿠폰 발급 
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 2. dong - 최초생성
     * </pre>
     * 
     * @param po
     * @param bindingResult
     * @return
     * @throws Exception
     */
    @RequestMapping("/coupon-issue-insert")
    public @ResponseBody ResultModel<CouponPO> insertCouponIssue(@Validated CouponPO po, BindingResult bindingResult)
            throws Exception {
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }
        ResultModel<CouponPO> result = couponService.insertCouponIssue(po);
        return result;
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 2.
     * 작성자 : dong
     * 설명   : 쿠폰내역(발급과 사용) 팝업
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 2. dong - 최초생성
     * </pre>
     * 
     * @param so
     * @param bindingResult
     * @return
     */
    @RequestMapping("/coupon-use-history")
    public @ResponseBody ResultListModel<CpTargetVO> selectCouponIssueUseHist(@Validated CouponSO so,
            BindingResult bindingResult) {
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }
        ResultListModel<CpTargetVO> list = couponService.selectCouponIssueUseHist(so);
        /*
         * ResultListModel<CpTargetVO> result = new ResultListModel<CpTargetVO>();
         * result.setResultList(list);
         */
        return list;
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 2.
     * 작성자 : dong
     * 설명   : 쿠폰목록 엑셀다운로드
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 2. dong - 최초생성
     * </pre>
     * 
     * @param so
     * @param bindingResult
     * @return
     */
    @RequestMapping("/coupon-excel-download")
    public String downloadExcelCouponList(CouponSO so, Model model) throws Exception {
        // 엑셀로 출력할 데이터 조회
        ResultListModel<CouponVO> resultListModel = couponService.selectCouponListPaging(so);
        // 엑셀의 헤더 정보 세팅
        String[] headerName = new String[] { "번호", "생성일", "쿠폰명", "사용제한금액", "유효기간", "혜택", "발급/사용" };
        // 엑셀에 출력할 데이터 세팅
        String[] fieldName = new String[] { "rownum", "regDttmExcel", "couponNm", "couponUseLimitAmtExcel",
                "couponApplyPeriodExcel", "couponBnfExcel", "issueUseCntExcel" };

        model.addAttribute(CommonConstants.EXCEL_PARAM_NAME,
                new ExcelViewParam("쿠폰 목록", headerName, fieldName, resultListModel.getResultList()));
        model.addAttribute(CommonConstants.EXCEL_PARAM_FILE_NAME, "couponExcel_" + DateUtil.getNowDateTime()); // 엑셀 파일명

        return View.excelDownload();
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 2.
     * 작성자 : dong
     * 설명   : 쿠폰기본정보 등록
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 2. dong - 최초생성
     * </pre>
     * 
     * @param po
     * @param bindingResult
     * @return
     */
    @RequestMapping("/coupon-info-insert")
    public @ResponseBody ResultModel<CouponPO> insertCouponInfo(@Validated CouponPO po, BindingResult bindingResult)
            throws Exception {
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }

        ResultModel<CouponPO> result = couponService.insertCouponInfo(po);
        return result;
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 2.
     * 작성자 : dong
     * 설명   : 쿠폰기본정보 수정
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 2. dong - 최초생성
     * </pre>
     * 
     * @param po
     * @param bindingResult
     * @return
     */
    @RequestMapping("/coupon-info-update")
    public @ResponseBody ResultModel<CouponPO> updateCouponInfo(@Validated CouponPO po, BindingResult bindingResult)
            throws Exception {
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }
        ResultModel<CouponPO> result = couponService.updateCouponInfo(po);
        return result;
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 2.
     * 작성자 : dong
     * 설명   : 쿠폰기본정보 삭제
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 2. dong - 최초생성
     * </pre>
     * 
     * @param wrapper
     * @param bindingResult
     * @return
     */
    @RequestMapping("/coupon-info-delete")
    public @ResponseBody ResultModel<CouponPO> deleteCouponInfo(
            @Validated(DeleteGroup.class) CouponPOListWrapper wrapper, BindingResult bindingResult) throws Exception {
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }
        ResultModel<CouponPO> result = couponService.deleteCouponInfo(wrapper);
        return result;
    }

    /**
     * <pre>
     * 작성일 : 2016. 7. 11.
     * 작성자 : dong
     * 설명   : 쿠폰 상세(단건) 
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 7. 11. Administrator - 최초생성
     * </pre>
     *
     * @param so
     * @param bindingResult
     * @return
     */
    @RequestMapping("/coupon-detail")
    public ModelAndView selectCouponDtl(@Validated CouponSO so, BindingResult bindingResult) throws Exception{
        ModelAndView mv = new ModelAndView("/admin/promotion/viewCouponDtl");

        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }

        // 검색조건
        mv.addObject("so", so);
        mv.addObject("siteNo", SessionDetailHelper.getDetails().getSiteNo());
        // 기획전 상세
        mv.addObject("resultModel", couponService.selectCouponDtl(so));
        return mv;

    }

    @RequestMapping("/member-list")
    public @ResponseBody List<MemberManageVO> memberList(@Validated MemberManageSO memberManageSO,
            BindingResult bindingResult) {
        log.debug("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }
        memberManageSO.setOffset(10000000);
        List<MemberManageVO> list = memberManageService.viewMemListCommon(memberManageSO);
        return list;
    }


    @RequestMapping("/coupon-copy")
    public @ResponseBody ResultModel<CouponPO> copyCouponInfo(@Validated CouponPO po, BindingResult bindingResult)
            throws Exception {
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }

        ResultModel<CouponPO> result = couponService.copyCouponInfo(po);
        return result;
    }
}
