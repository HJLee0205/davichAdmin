package net.danvi.dmall.front.web.view.coupon.controller;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.List;
import java.util.Locale;

import javax.annotation.Resource;

import dmall.framework.common.util.DateUtil;
import org.springframework.beans.BeanUtils;
import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import dmall.framework.common.exception.JsonValidationException;
import dmall.framework.common.model.ResultListModel;
import dmall.framework.common.model.ResultModel;
import dmall.framework.common.util.MessageUtil;
import dmall.framework.common.util.SiteUtil;
import dmall.framework.common.util.StringUtil;
import lombok.extern.slf4j.Slf4j;
import net.danvi.dmall.biz.app.goods.model.CategorySO;
import net.danvi.dmall.biz.app.goods.model.GoodsSO;
import net.danvi.dmall.biz.app.goods.model.GoodsVO;
import net.danvi.dmall.biz.app.member.manage.model.MemberManageSO;
import net.danvi.dmall.biz.app.member.manage.model.MemberManageVO;
import net.danvi.dmall.biz.app.member.manage.service.MemberManageService;
import net.danvi.dmall.biz.app.promotion.coupon.model.CouponPO;
import net.danvi.dmall.biz.app.promotion.coupon.model.CouponSO;
import net.danvi.dmall.biz.app.promotion.coupon.model.CouponVO;
import net.danvi.dmall.biz.app.promotion.coupon.service.CouponService;
import net.danvi.dmall.biz.system.security.SessionDetailHelper;

/**
 * <pre>
 * 프로젝트명 : 31.front.web
 * 작성일     : 2016. 5. 2.
 * 작성자     : 강명식
 * 설명       : 쿠폰 조회 컨트롤러
 * </pre>
 */
@Slf4j
@Controller
@RequestMapping("/front/coupon")
public class CouponController {

    @Resource(name = "couponService")
    private CouponService couponService;

    @Resource(name = "memberManageService")
    private MemberManageService memberManageService;

    /**
     * <pre>
     * 작성일 : 2016. 5. 2.
     * 작성자 : dong
     * 설명   : 회원번호에 해당하는 쿠폰 목록 조회
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 2. dong - 최초생성
     * </pre>
     *
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/coupon-list")
    public ModelAndView selectMemberCouponList(@Validated MemberManageSO so, BindingResult bindingResult)
            throws Exception {
        ModelAndView mav = SiteUtil.getSkinView("/mypage/coupon_list");

        // 로그인여부 체크
        if (!SessionDetailHelper.getDetails().isLogin()) {
            mav.addObject("exMsg", MessageUtil.getMessage("biz.exception.lng.loginRequired"));
            mav.setViewName("/error/notice");
            return mav;
        }

        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            return mav;
        }

        /*// default 기간검색(최근3일)
        if (StringUtil.isEmpty(so.getFromRegDt()) || StringUtil.isEmpty(so.getToRegDt())) {
            Calendar cal = new GregorianCalendar(Locale.KOREA);
            cal.add(Calendar.DAY_OF_YEAR, -3);
            SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
            String fromRegDt = df.format(cal.getTime());
            String toRegDt = df.format(new Date());
            so.setFromRegDt(fromRegDt);
            so.setToRegDt(toRegDt);
        }*/
        so.setMemberNo(SessionDetailHelper.getDetails().getSession().getMemberNo());

        mav.addObject("leftMenu", "my_coupon");
        mav.addObject("so", so);
        mav.addObject("resultListModel", memberManageService.selectCouponGetPaging(so));
        return mav;
    }
    
    @RequestMapping("/coupon-list-paging")
    public ModelAndView couponListPaging(@Validated MemberManageSO so, BindingResult bindingResult) {
        
    	ModelAndView mav = SiteUtil.getSkinView("/mypage/coupon_list_paging");
    	
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            return mav;
        }

        so.setMemberNo(SessionDetailHelper.getDetails().getSession().getMemberNo());

        mav.addObject("leftMenu", "my_coupon");
        mav.addObject("so", so);
        mav.addObject("resultListModel", memberManageService.selectCouponGetPaging(so));
        
        return mav;
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 2.
     * 작성자 : dong
     * 설명   : 단건 쿠폰 정보 조회
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 2. dong - 최초생성
     * </pre>
     *
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/coupon-info")
    public ModelAndView selectCouponInfo(@Validated CouponSO so, BindingResult bindingResult) throws Exception {
        ModelAndView mv = new ModelAndView("jsp경로");
        // 필수 파라메터(사이트번호, 회원번호, 날짜)
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            return mv;
        }
        // mv.addObject("resultListModel", couponService.selectCoupon(so));
        return mv;
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 2.
     * 작성자 : dong
     * 설명   : 회원번호에 해당하는 사용한 쿠폰 목록 조회
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 2. dong - 최초생성
     * </pre>
     *
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/coupon-use-list")
    public ModelAndView selectUseCouponList(@Validated CouponSO so, BindingResult bindingResult) throws Exception {
        ModelAndView mv = new ModelAndView("jsp경로");
        // 필수 파라메터(사이트번호, 회원번호, 날짜)
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            return mv;
        }
        mv.addObject("resultListModel", couponService.selectCouponList(so));
        return mv;
    }

    /**
     * <pre>
     * 작성일 : 2016. 6. 8.
     * 작성자 : dong
     * 설명   : 주문에서 사용가능한 쿠폰 리스트를 조회한다.
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 8. dong - 최초생성
     * </pre>
     *
     * @param so
     * @param bindingResult
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/available-ordercoupon-list")
    public @ResponseBody ResultListModel<CouponVO> selectAvailableOrderCouponList(@Validated CouponSO so,BindingResult bindingResult) throws Exception {

        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }

        ResultListModel<CouponVO> result = new ResultListModel<>();

        if (SessionDetailHelper.getDetails().isLogin()) { // 회원만
            so.setMemberNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
            result.setResultList(couponService.selectAvailableOrderCouponList(so));
        }

        return result;
    }

    /**
     * <pre>
     * 작성일 : 2016. 6. 15.
     * 작성자 : dong
     * 설명   : 상품 쿠폰 다운로드 팝업
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 15. dong - 최초생성
     * </pre>
     *
     * @param so
     * @param bindingResult
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/coupon-download-pop")
    public @ResponseBody ResultListModel<CouponVO> downloadCoupon(@Validated CouponSO so, BindingResult bindingResult)
            throws Exception {
        // 필수 파라메터(상품번호, 카테고리번호)
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }

        // 1. 다운로드 가능 쿠폰 정보 조회
        List<CouponVO> couponList = couponService.selectAvailableGoodsCouponList(so);

        // 2. 쿠폰 다운로드(1건인경우 다운로드, 그외는 팝업)
        List<CouponVO> availCouponList = new ArrayList<>(); // 다건
        ResultListModel<CouponVO> result = new ResultListModel<>();
        if (couponList.size() > 0 && couponList != null) {
            CouponSO couponSO = new CouponSO();
            long memberNo = SessionDetailHelper.getDetails().getSession().getMemberNo();
            long siteNo = SessionDetailHelper.getDetails().getSession().getSiteNo();
            couponSO.setMemberNo(memberNo);
            for (int i = 0; i < couponList.size(); i++) {
                CouponVO vo = couponList.get(i);
                couponSO.setCouponNo(vo.getCouponNo());
                couponSO.setSiteNo(siteNo);
                couponSO.setIssueTarget("03");
                if ("Y".equals(vo.getCouponDupltDwldPsbYn())) {
                    couponSO.setUseYn("N");
                }
                int cnt = couponService.selectMemberCoupon(couponSO);
                log.debug(" === cnt : {}", cnt);
                if (cnt == 0) {
                    vo.setIssueYn("N");
                } else {
                    vo.setIssueYn("Y");
                }
                availCouponList.add(vo);
            }

            CouponPO po = new CouponPO();
            int issueAvailableCnt = 0;
            for (int i = 0; i < availCouponList.size(); i++) {
                CouponVO vo = availCouponList.get(i);
                if ("N".equals(vo.getIssueYn())) {
                    issueAvailableCnt++;
                }
            }

            // 1건인 경우 발급
            /*
             * if (issueAvailableCnt == 1) {
             * for (int i = 0; i < availCouponList.size(); i++) {
             * CouponVO vo = (CouponVO) availCouponList.get(i);
             * if ("N".equals(vo.getIssueYn())) {
             * po.setMemberNo(memberNo);
             * po.setRegrNo(memberNo);
             * po.setCouponNo(vo.getCouponNo());
             * po.setSiteNo(siteNo);
             * po.setIssueTarget("03");
             * couponService.insertCouponIssue(po);
             * }
             * }
             * result.setResultList(availCouponList);
             * } else { // 그외 팝업
             */
            result.setResultList(availCouponList);
            // }
            result.setSuccess(true);

        } else {
            result.setSuccess(false);
        }

        return result;
    }

    @RequestMapping(value = "/coupon-issue")
    public @ResponseBody ResultModel<CouponPO> issueCoupon(@Validated CouponPO po, BindingResult bindingResult)
            throws Exception {
        ResultModel<CouponPO> result = new ResultModel<>();

        long memberNo = SessionDetailHelper.getDetails().getSession().getMemberNo();
        long siteNo = SessionDetailHelper.getDetails().getSession().getSiteNo();
        try {
            po.setMemberNo(memberNo);
            po.setRegrNo(memberNo);
            po.setSiteNo(siteNo);
            po.setIssueTarget("03");

            //발급 가능 여부 체크
            CouponSO so = new CouponSO();
            so.setMemberNo(memberNo);
            so.setCouponNo(po.getCouponNo());
            so.setSiteNo(siteNo);
            //쿠폰 상세 정보
            ResultModel<CouponVO> couponVo = couponService.selectCouponDtl(so);
            //중복 다운로드 가능 쿠폰일경우 추가 발행하기위한 파라미터 세팅..
            if ("Y".equals(couponVo.getData().getCouponDupltDwldPsbYn())) {
              so.setUseYn("N");
            }
            // 사용하지 않은 회원 보유 쿠폰 조회
            int cnt = couponService.selectMemberCoupon(so);
            if (cnt == 0) {
                //보유하고 있지 않을경우 발행
                couponService.insertCouponIssue(po);
                result.setSuccess(true);

             }else{

               if(po.getDrtCpIssuYn()==null || !po.getDrtCpIssuYn().equals("Y")){
                    result.setSuccess(false);
                    result.setMessage("이미 발급 받으신 쿠폰입니다.");
               }else{
                   result.setSuccess(true);

               }
             }

        }catch (Exception e){
            e.printStackTrace();
           result.setSuccess(false);
           result.setMessage("오류가 발생하였습니다.<br>관리자에게 문의하시기 바랍니다.");
           return result;
        }

        return result;
    }

    @RequestMapping(value = "/coupon-issue-all")
    public @ResponseBody ResultModel<CouponPO> issueCouponAll(@Validated CouponSO so, BindingResult bindingResult)
            throws Exception {
        // 필수 파라메터(상품번호, 카테고리번호)
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }

        // 1. 다운로드 가능 쿠폰 정보 조회
        List<CouponVO> couponList = couponService.selectAvailableGoodsCouponList(so);

        // 2. 쿠폰 다운로드
        ResultModel<CouponPO> result = new ResultModel<>();
        if (couponList.size() > 0 && couponList != null) {
            CouponPO po = new CouponPO();
            long memberNo = SessionDetailHelper.getDetails().getSession().getMemberNo();
            long siteNo = SessionDetailHelper.getDetails().getSession().getSiteNo();
            po.setMemberNo(memberNo);
            po.setRegrNo(memberNo);
            int issueCnt = 0; // 발급수량
            for (int i = 0; i < couponList.size(); i++) {
                CouponVO vo = couponList.get(i);
                po.setCouponNo(vo.getCouponNo());
                po.setSiteNo(siteNo);
                po.setIssueTarget("03");
                if ("Y".equals(vo.getCouponDupltDwldPsbYn())) {
                    so.setUseYn("N");
                }
                so.setMemberNo(memberNo);
                int cnt = couponService.selectMemberCoupon(so);
                if (cnt == 0) {
                    couponService.insertCouponIssue(po);
                    issueCnt++;
                }
            }
            if (couponList.size() == 0) { // 발급가능한 쿠폰이 없는 경우
                result.setSuccess(false);
            } else if (couponList.size() > 0 && issueCnt == 0) { // 발급가능 쿠폰은 있지만 모두 발급받은 경우
                result.setSuccess(false);
            } else if (couponList.size() > 0 && issueCnt != 0) { // 발급
                result.setSuccess(true);
            }
        }

        return result;
    }

    /**
     * <pre>
     * 작성일 : 2016. 7. 20.
     * 작성자 : dong
     * 설명   : 쿠폰 적용 대상 조회
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 7. 20. dong - 최초생성
     * </pre>
     *
     * @param so
     * @param bindingResult
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/coupon-applytarget-list")
    public @ResponseBody ResultModel<CouponVO> selectCouponApplyTargetList(@Validated CouponSO so,
            BindingResult bindingResult) throws Exception {

        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }

        ResultModel<CouponVO> result = new ResultModel<>();
        result = couponService.selectCouponApplyTargetList(so);

        result.setSuccess(true);
        return result;
    }
    
    /**
     * <pre>
     * 작성일 : 2016. 7. 20.
     * 작성자 : dong
     * 설명   : 쿠폰 적용 대상 조회
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 7. 20. dong - 최초생성
     * </pre>
     *
     * @param so
     * @param bindingResult
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/coupon-info-ajax")
    public @ResponseBody ResultModel<MemberManageVO> memCouponInfo(@Validated MemberManageSO so,
            BindingResult bindingResult) throws Exception {

    	ResultModel<MemberManageVO> result = new ResultModel<>();
    	
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }

        so.setMemberNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
        result = memberManageService.selectMemCouponInfo(so);

        result.setSuccess(true);
        return result;
    }
    
    /**
     * <pre>
     * 작성일 : 2019. 4. 3.
     * 작성자 : hskim
     * 설명   : 쿠폰존 조회
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2019. 4. 3. hskim - 최초생성
     * </pre>
     *
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/coupon-zone")
    public ModelAndView selectCouponZoneList(@Validated CouponSO so, BindingResult bindingResult)
            throws Exception {
        ModelAndView mav = SiteUtil.getSkinView("/mypage/coupon_zone");

        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            return mav;
        }
        so.setSiteNo(SessionDetailHelper.getDetails().getSession().getSiteNo());
        if (SessionDetailHelper.getDetails().isLogin()){
        	so.setMemberNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
        	String birth = SessionDetailHelper.getDetails().getSession().getBirth();
        	String ageRange ="";
        	if(birth!=null)
        	ageRange = String.valueOf(DateUtil.getAge(birth)).substring(0,1)+"0";

        	so.setAgeRange(ageRange);
    	}
        // 다운로드 가능 쿠폰 정보 조회
        mav.addAllObjects(couponService.selectAvailableGoodsCouponZoneNewList(so));
        //List<CouponVO> couponList = couponService.selectAvailableGoodsCouponZoneList(so);
        
        /*mav.addObject("resultList", couponList); */
        mav.addObject("so", so);
        
        return mav;
    }

    @RequestMapping(value = "/coupon-zone-ajax")
    public ModelAndView selectCouponZoneAjaxList(@Validated CouponSO so, BindingResult bindingResult)
            throws Exception {
        ModelAndView mav = SiteUtil.getSkinView("/mypage/coupon_zone_ajax");

        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            return mav;
        }
        so.setSiteNo(SessionDetailHelper.getDetails().getSession().getSiteNo());
        if (SessionDetailHelper.getDetails().isLogin()){
        	so.setMemberNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
    	}
        // 다운로드 가능 쿠폰 정보 조회
        mav.addAllObjects(couponService.selectAvailableGoodsCouponZoneNewList(so));
        //List<CouponVO> couponList = couponService.selectAvailableGoodsCouponZoneList(so);

        /*mav.addObject("resultList", couponList);
        mav.addObject("so", so);*/

        return mav;
    }
    
    @RequestMapping(value = "/coupon-zone-issue-all")
    public @ResponseBody ResultModel<CouponPO> issueCouponZoneAll(@Validated CouponSO so, BindingResult bindingResult)
            throws Exception {
    	
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }

        long siteNo = SessionDetailHelper.getDetails().getSession().getSiteNo();
        long memberNo = SessionDetailHelper.getDetails().getSession().getMemberNo();
        so.setSiteNo(siteNo);
        so.setMemberNo(memberNo);
        so.setDownloadAll("Y");
        
        // 다운로드 가능 쿠폰 정보 조회
        List<CouponVO> couponList = couponService.selectAvailableGoodsCouponZoneList(so);

        // 쿠폰 다운로드
        ResultModel<CouponPO> result = new ResultModel<>();
        if (couponList.size() > 0 && couponList != null) {
        	
            CouponPO po = new CouponPO();
            po.setSiteNo(siteNo);
            po.setMemberNo(memberNo);
            po.setRegrNo(memberNo);
            int issueCnt = 0; // 발급수량
            
            for (int i = 0; i < couponList.size(); i++) {
                CouponVO vo = couponList.get(i);
                if("N".equals(vo.getIssueYn())) {
                	po.setCouponNo(vo.getCouponNo());
                    po.setIssueTarget("03");
                    
                    couponService.insertCouponIssue(po);
                    issueCnt++;
                }
            }
            
            if(issueCnt > 0) {
            	result.setSuccess(true);
            }else {
            	result.setSuccess(false);
            }
        }else {
        	result.setSuccess(false);
        }

        return result;
    }
}
