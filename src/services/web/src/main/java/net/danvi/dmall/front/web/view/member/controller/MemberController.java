package net.danvi.dmall.front.web.view.member.controller;

import com.fasterxml.jackson.core.JsonProcessingException;
import dmall.framework.common.constants.CommonConstants;
import dmall.framework.common.constants.ExceptionConstants;
import dmall.framework.common.constants.UploadConstants;
import dmall.framework.common.exception.CustomException;
import dmall.framework.common.exception.JsonValidationException;
import dmall.framework.common.model.FileVO;
import dmall.framework.common.model.ResultListModel;
import dmall.framework.common.model.ResultModel;
import dmall.framework.common.util.*;
import lombok.extern.slf4j.Slf4j;
import net.danvi.dmall.biz.app.basket.model.BasketPO;
import net.danvi.dmall.biz.app.basket.model.BasketSO;
import net.danvi.dmall.biz.app.basket.service.FrontBasketService;
import net.danvi.dmall.biz.app.goods.model.GoodsVO;
import net.danvi.dmall.biz.app.goods.model.RestockNotifyPOListWrapper;
import net.danvi.dmall.biz.app.goods.model.RestockNotifySO;
import net.danvi.dmall.biz.app.goods.model.RestockNotifyVO;
import net.danvi.dmall.biz.app.goods.service.RestockNotifyService;
import net.danvi.dmall.biz.app.interest.model.InterestSO;
import net.danvi.dmall.biz.app.interest.service.FrontInterestService;
import net.danvi.dmall.biz.app.member.level.service.MemberLevelService;
import net.danvi.dmall.biz.app.member.manage.model.*;
import net.danvi.dmall.biz.app.member.manage.service.FrontMemberService;
import net.danvi.dmall.biz.app.member.manage.service.MemberManageService;
import net.danvi.dmall.biz.app.operation.model.PushSendVO;
import net.danvi.dmall.biz.app.operation.model.SavedmnPointPO;
import net.danvi.dmall.biz.app.operation.model.SavedmnPointSO;
import net.danvi.dmall.biz.app.operation.model.SmsSendPO;
import net.danvi.dmall.biz.app.operation.service.EmailSendService;
import net.danvi.dmall.biz.app.operation.service.SavedMnPointService;
import net.danvi.dmall.biz.app.operation.service.SmsSendService;
import net.danvi.dmall.biz.app.order.manage.model.OrderGoodsVO;
import net.danvi.dmall.biz.app.order.manage.model.OrderSO;
import net.danvi.dmall.biz.app.order.manage.model.OrderVO;
import net.danvi.dmall.biz.app.order.manage.service.OrderService;
import net.danvi.dmall.biz.app.promotion.coupon.model.CouponPO;
import net.danvi.dmall.biz.app.promotion.coupon.model.CouponSO;
import net.danvi.dmall.biz.app.promotion.coupon.model.CouponVO;
import net.danvi.dmall.biz.app.promotion.coupon.service.CouponService;
import net.danvi.dmall.biz.app.setup.personcertify.model.PersonCertifyConfigVO;
import net.danvi.dmall.biz.app.setup.personcertify.service.PersonCertifyConfigService;
import net.danvi.dmall.biz.app.setup.siteinfo.model.SiteSO;
import net.danvi.dmall.biz.app.setup.siteinfo.model.SiteVO;
import net.danvi.dmall.biz.app.setup.siteinfo.service.SiteInfoService;
import net.danvi.dmall.biz.app.setup.snsoutside.service.SnsOutsideLinkService;
import net.danvi.dmall.biz.app.setup.term.model.TermConfigSO;
import net.danvi.dmall.biz.app.setup.term.service.TermConfigService;
import net.danvi.dmall.biz.common.service.BizService;
import net.danvi.dmall.biz.system.login.model.MemberLoginHistPO;
import net.danvi.dmall.biz.system.login.service.LoginService;
import net.danvi.dmall.biz.system.model.AppLogPO;
import net.danvi.dmall.biz.system.model.CmnCdDtlVO;
import net.danvi.dmall.biz.system.model.LoginVO;
import net.danvi.dmall.biz.system.model.SiteCacheVO;
import net.danvi.dmall.biz.system.remote.push.PushDelegateService;
import net.danvi.dmall.biz.system.security.DmallSessionDetails;
import net.danvi.dmall.biz.system.security.Session;
import net.danvi.dmall.biz.system.security.SessionDetailHelper;
import net.danvi.dmall.biz.system.service.SiteService;
import net.danvi.dmall.biz.system.util.InterfaceUtil;
import net.danvi.dmall.biz.system.util.JsonMapperUtil;
import net.danvi.dmall.biz.system.util.ServiceUtil;
import net.danvi.dmall.biz.system.validation.DeleteGroup;
import net.danvi.dmall.biz.system.validation.InsertGroup;
import net.danvi.dmall.biz.system.validation.UpdateGroup;
import net.danvi.dmall.core.constants.IdentifyConstants;
import net.danvi.dmall.core.model.identity.ipin.IpinVO;
import net.danvi.dmall.core.model.identity.mobile.DreamVO;
import net.danvi.dmall.smsemail.model.request.PushSendPO;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.File;
import java.text.SimpleDateFormat;
import java.util.*;

/**
 * <pre>
 * - 프로젝트명    : 31.front.web
 * - 파일명        : MemberController.java
 * - 작성일        : 2016. 5. 2.
 * - 작성자        : dong
 * - 설명          : 회원 Controller
 * </pre>
 * @param <E>
 */
@Slf4j
@Controller
@RequestMapping("/front/member")
public class MemberController<E> {
    @Resource(name = "frontMemberService")
    private FrontMemberService frontMemberService;

    @Resource(name = "siteInfoService")
    private SiteInfoService siteInfoService;

    @Resource(name = "bizService")
    private BizService bizService;

    @Resource(name = "termConfigService")
    private TermConfigService termConfigService;

    @Resource(name = "savedMnPointService")
    private SavedMnPointService savedMnPointService;

    @Resource(name = "couponService")
    private CouponService couponService;

    @Resource(name = "orderService")
    private OrderService orderService;

    @Resource(name = "memberLevelService")
    private MemberLevelService memberLevelService;

    @Resource(name = "memberManageService")
    private MemberManageService memberManageService;

    @Resource(name = "frontBasketService")
    private FrontBasketService frontBasketService;

    @Resource(name = "frontInterestService")
    private FrontInterestService frontInterestService;

    @Resource(name = "restockNotifyService")
    private RestockNotifyService restockNotifyService;

    @Resource(name = "personCertifyConfigService")
    private PersonCertifyConfigService personCertifyConfigService;

    @Resource(name = "emailSendService")
    private EmailSendService emailSendService;

    @Resource(name = "siteService")
    private SiteService siteService;

    @Resource(name = "snsOutsideLinkService")
    private SnsOutsideLinkService snsOutsideLinkService;

    @Resource(name = "mailSender")
    private JavaMailSender mailSender;

    @Resource(name = "pushDelegateService")
    private PushDelegateService pushDelegateService;
    
    @Resource(name = "loginService")
    private LoginService loginService;
    
    @Resource(name = "smsSendService")
    private SmsSendService smsSendService;

    @RequestMapping("/mypage")
    public ModelAndView mypage(@Validated MemberManageSO so, BindingResult bindingResult) throws Exception {
        ModelAndView mav = SiteUtil.getSkinView("/mypage/mypage");
        mav.addObject("so", so);

        // 조회할 회원정보 set
        DmallSessionDetails sessionInfo = SessionDetailHelper.getDetails();
        so.setMemberNo(sessionInfo.getSession().getMemberNo());

        // 로그인여부 체크
        if (so.getMemberNo() == null || "".equals(so.getMemberNo())) {
            //mav.addObject("exMsg", "로그인이 필요한 서비스 입니다.");
            //mav.setViewName("/error/notice");
        	String returnUrl = UrlUtil.encoder("/front/member/mypage", "UTF-8");
            mav.setViewName("redirect:/front/login/member-login?returnUrl="+returnUrl);
            return mav;
        }

        // 01.회원기본정보 search
        ResultModel<MemberManageVO> member_info = frontMemberService.selectMember(so);

        // 02. 마켓포인트 조회search > 회원기본정보 set
        ResultModel<MemberManageVO> prcAmt = memberManageService.selectMemSaveMn(so);
        if(member_info.getData()!=null && prcAmt.getData()!=null) {
            member_info.getData().setPrcAmt(prcAmt.getData().getPrcAmt());
        }

        // 02. 포인트 조회search > 회원기본정보 set
        ResultModel<MemberManageVO> prcPoint = memberManageService.selectMemPoint(so);
        member_info.getData().setPrcPoint(prcPoint.getData().getPrcPoint());

        // 02.보유쿠폰search > 회원기본정보 set
        Integer couponCount = memberManageService.selectCouponGetPagingCount(so);// 할인쿠폰
        member_info.getData().setCpCnt(Integer.toString(couponCount));

        OrderSO orderSO = new OrderSO();
        orderSO.setMemberNo(sessionInfo.getSession().getMemberNo());
        orderSO.setSiteNo(sessionInfo.getSession().getSiteNo());

        // 03.주문현황조회(주문접수,상품준비,배송중,배송완료)
        ResultModel<OrderVO> order_cnt_info = orderService.selectOrderCountInfo(orderSO);

        // 04.주문내역조회 - 기간검색(최근30일)

        Calendar cal = new GregorianCalendar(Locale.KOREA);
        cal.add(Calendar.DAY_OF_YEAR, -30);
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
        String stRegDttm = df.format(cal.getTime());
        String endRegDttm = df.format(new Date());
        orderSO.setDayTypeCd("01");
        orderSO.setOrdDayS(stRegDttm);
        orderSO.setOrdDayE(endRegDttm);
        /*String[] ordDtlStatusCd = { "10", "11", "20", "21", "30", "40", "50", "60", "61", "66", "70", "71", "74","90" };
        orderSO.setOrdDtlStatusCd(ordDtlStatusCd);*/

        ResultListModel<OrderVO> order_list = orderService.selectOrdListFrontPaging(orderSO);

        // 05.관심상품조회
        InterestSO is = new InterestSO();
        is.setMemberNo(sessionInfo.getSession().getMemberNo());
        is.setSiteNo(sessionInfo.getSession().getSiteNo());
        is.setLimit(0);
        is.setOffset(4);
        List<GoodsVO> interest_goods = frontInterestService.selectInterestList(is);
        int interest_cnt = frontInterestService.selectInterestTotalCount(is);
        // 06.회원배송지 search
        MemberDeliverySO memberDeliverySO = new MemberDeliverySO();
        memberDeliverySO.setMemberNo(sessionInfo.getSession().getMemberNo());
        ResultListModel<MemberDeliveryVO> delivery_list = frontMemberService.selectDeliveryListPaging(memberDeliverySO);

        // 07.조회 Data setting
        mav.addObject("order_cnt_info", order_cnt_info);
        mav.addObject("order_list", order_list);
        mav.addObject("member_info", member_info);
        mav.addObject("interest_cnt", interest_cnt);
        mav.addObject("interest_goods", interest_goods);
        mav.addObject("delivery_list", delivery_list);

        return mav;
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 9.
     * 작성자 : dong
     * 설명   : 회원정보 등록
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 9. dong - 최초생성
     * </pre>
     */
    @RequestMapping("/member-insert")
    public @ResponseBody ResultModel<MemberManagePO> insertMember(@Validated(InsertGroup.class) MemberManagePO po, BindingResult bindingResult,HttpServletRequest mRequest)
            throws Exception {

        ResultModel<MemberManagePO> result = new ResultModel<>();
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }

        MemberManageSO so = new MemberManageSO();
        so.setLoginId(po.getLoginId());
        so.setSiteNo(po.getSiteNo());
        int loginId = frontMemberService.checkDuplicationId(so);
        log.debug("loginId : " + loginId);
        if (loginId > 0) {
            result.setSuccess(false);
            result.setMessage("사용할 수 없는 아이디 입니다.");
            return result;
        }
        log.debug("parameter 검증 ok");

        // 02. 입력정보 설정
        po.setMemberGradeNo("1");
        po.setJoinPathCd("SHOP");// 가입경로
        po.setMemberStatusCd("01");// 회원상태코드
        po.setIntegrationMemberGbCd("01");//통합 회원 구분 코드
        //앞단에서 휴대전화 인증이 완료되었음으로 'Y'로 강제 세팅
        po.setRealnmCertifyYn("Y");

        log.debug("회원정보 셋팅 ok");
        // 성인여부 판별
        po.setAdultCertifyYn("N");// 미성년자
        if (!"".equals(po.getMemberDi()) && po.getMemberDi() != null) { // 아이핀인증 고객에 한해서
            if (po.getMemberDi() != null) { // 아이핀인증 고객에 한해서
                po.setAdultCertifyYn(DateUtil.getAdultYn(po.getBirth()));
            }
            po.setRealnmCertifyYn("Y");
        }
        log.debug("성인여부 판별 OK");

        // 변경안내 주기 날짜
        Calendar cal = Calendar.getInstance(Locale.KOREA);
        SiteCacheVO siteCacheVO = siteService.getSiteInfo(po.getSiteNo());
        if (siteCacheVO.getPwChgGuideCycle() != null) {
            cal.add(Calendar.MONTH, +siteCacheVO.getPwChgGuideCycle());
            po.setNextPwChgScdDttm(cal.getTime());
        } else {
            // default 6개월
            cal.add(Calendar.MONTH, 6);
            po.setNextPwChgScdDttm(cal.getTime());
        }

        // 03. 회원가입
        // 사업자 회원일 경우 사업자등록증사본 업로드

        // 파일 정보 등록
        List<FileVO> list = FileUtil.getFileListFromRequest(mRequest,FileUtil.getPath(UploadConstants.PATH_ATTACH, UploadConstants.PATH_BIZ));

        if (list != null && list.size() == 1) {
            po.setBizFilePath(list.get(0).getFilePath());
            po.setBizFileNm(list.get(0).getFileName());
            po.setBizOrgFileNm(list.get(0).getFileOrgName());
            po.setBizFileSize(list.get(0).getFileSize());
        }

        ResultModel<MemberManagePO> memberManagePO = frontMemberService.insertMember(po);

        // 회원 등록 실패시
        if(!memberManagePO.isSuccess()) {
        	return memberManagePO;
        }
        log.debug("회원가입 ok");

        // 04. 쿠폰발급(회원가입쿠폰이 있을경우 가입한 로그인아이디로 회원키값을 조회하여 쿠폰 발행)
        CouponSO couponSO = new CouponSO();
        couponSO.setSiteNo(po.getSiteNo());
        couponSO.setCouponKindCd("04");// 신규회원가입쿠폰
        List<CouponVO> resultListModel = couponService.selectCouponList(couponSO);// 발급가능 쿠폰조회

        if (resultListModel != null) {
            for (int i = 0; i < resultListModel.size(); i++) {
                CouponVO couponVO = new CouponVO();
                couponVO = resultListModel.get(i);
                CouponPO couponPO = new CouponPO();
                couponPO.setSiteNo(po.getSiteNo());
                couponPO.setCouponNo(couponVO.getCouponNo());
                couponPO.setMemberNo(memberManagePO.getData().getMemberNo());
                couponPO.setRegrNo(memberManagePO.getData().getMemberNo());
                couponPO.setIssueTarget("03");// 개별 발급

                if ("01".equals(couponVO.getCouponQttLimitCd())) { // 수량제한 없을 경우
                    couponService.insertCouponIssue(couponPO);
                } else { // 수량제한 있을 경우
                    if (couponVO.getIssueCnt() < couponVO.getCouponQttLimitCnt()) {
                        couponService.insertCouponIssue(couponPO);
                    }
                }
            }
        }
        log.debug("쿠폰발급 ok");
        return memberManagePO;
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 9.
     * 작성자 : dong
     * 설명   : 회원가입 완료
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 9. dong - 최초생성
     * </pre>
     */
    @RequestMapping("/member-join-complete")
    public ModelAndView insertMemberComplete(@Validated(InsertGroup.class) MemberManagePO po, BindingResult bindingResult,HttpServletRequest mRequest)
            throws Exception {
        ModelAndView mav = SiteUtil.getSkinView("/member/join_step_04");
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }
        mav.addObject("po", po);
        return mav;
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 9.
     * 작성자 : dong
     * 설명   : 개인정보 수정페이지
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 9. dong - 최초생성
     * </pre>
     */
    @RequestMapping("/information-update-form")
    public ModelAndView memberInfoModify(@Validated MemberManageSO so, BindingResult bindingResult) throws Exception {
        ModelAndView mav = SiteUtil.getSkinView("/mypage/member_info_modify");

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
        DmallSessionDetails sessionInfo = SessionDetailHelper.getDetails();
        so.setMemberNo(sessionInfo.getSession().getMemberNo());
        so.setIntegrationMemberGbCd(sessionInfo.getSession().getIntegrationMemberGbCd());

        // 로그인여부 체크
        if (so.getMemberNo() == null || "".equals(so.getMemberNo())) {
            mav.addObject("exMsg", "로그인이 필요한 서비스 입니다.");
            mav.setViewName("/error/notice");
            return mav;
        }

        ResultModel<MemberManageVO> resultModel = frontMemberService.selectMember(so);

        // 본인인증서비스 여부확인
        List<PersonCertifyConfigVO> list = personCertifyConfigService.selectPersonCertifyConfigList(so.getSiteNo());
        boolean ioFlag = personCertifyConfigService.ipinAuthFlag(list, "member");
        boolean moFlag = personCertifyConfigService.mobileAuthFlag(list, "member");

        PersonCertifyConfigVO vo = new PersonCertifyConfigVO();
        // mobile
        if (moFlag) {
            DreamVO dreamVO = new DreamVO();
            vo.setSiteNo(sessionInfo.getSiteNo());
            vo.setCertifyTypeCd("02");
            ResultModel<PersonCertifyConfigVO> result = personCertifyConfigService.selectPersonCertifyConfig(vo);
            dreamVO.setSiteNo(sessionInfo.getSiteNo());
            dreamVO.setSiteCd(result.getData().getSiteCd());
            dreamVO.setSitePw(result.getData().getSitePw());
            dreamVO.setReturnUrl("/front/login/mobile-result-return");
            dreamVO.setServerName(SessionDetailHelper.getSession().getServerName());
            mav.addObject("mo", IdentifyConstants.createDreamSecret(dreamVO));
        }

        // ipin set
        if (ioFlag) {
            IpinVO ipinVO = new IpinVO();
            vo.setSiteNo(sessionInfo.getSiteNo());
            vo.setCertifyTypeCd("01");
            ResultModel<PersonCertifyConfigVO> result = personCertifyConfigService.selectPersonCertifyConfig(vo);
            ipinVO.setSiteNo(sessionInfo.getSiteNo());
            ipinVO.setSiteCd(result.getData().getSiteCd());
            ipinVO.setSitePw(result.getData().getSitePw());
            ipinVO.setReturnUrl("/front/login/ipin-result-return");
            ipinVO.setServerName(SessionDetailHelper.getSession().getServerName());
            mav.addObject("io", IdentifyConstants.createIpin(ipinVO));
        }

        mav.addObject("so", so);
        mav.addObject("vo", resultModel.getData());
        mav.addObject("resultModel", resultModel);
        mav.addObject("leftMenu", "modify_member");
        return mav;
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 9.
     * 작성자 : dong
     * 설명   : 회원정보 변경
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 9. dong - 최초생성
     * </pre>
     */
    @RequestMapping("/member-update")
    public @ResponseBody ResultModel<MemberManagePO> updateMember(@Validated(UpdateGroup.class) MemberManagePO po,BindingResult bindingResult,HttpServletRequest mRequest) throws Exception {
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }
        // return ResultModel
        ResultModel<MemberManagePO> resultModel = new ResultModel<>();

        // 파일 정보 등록
        List<FileVO> list = FileUtil.getFileListFromRequest(mRequest,FileUtil.getPath(UploadConstants.PATH_ATTACH, UploadConstants.PATH_BIZ));

        if (list != null && list.size() == 1) {
        	// 기존파일삭제
        	String fileNm = FileUtil.getPath(UploadConstants.PATH_ATTACH, UploadConstants.PATH_BIZ) + File.separator + po.getBizFileNm();

            File file = new File(fileNm);
            file.delete();


            po.setBizFilePath(list.get(0).getFilePath());
            po.setBizFileNm(list.get(0).getFileName());
            po.setBizOrgFileNm(list.get(0).getFileOrgName());
            po.setBizFileSize(list.get(0).getFileSize());
        }

        // 기존등록된 비밀번호 조회
        MemberManageSO so = new MemberManageSO();
        DmallSessionDetails sessionInfo = SessionDetailHelper.getDetails();
        so.setMemberNo(sessionInfo.getSession().getMemberNo());
        so.setSiteNo(sessionInfo.getSession().getSiteNo());
        ResultModel<MemberManageVO> mmv = frontMemberService.selectMember(so);
        // 개인정보 수정시 비밀번호가 존재하는건 일반회원가입일경우에만 존재한다.
        if (!"".equals(po.getPw()) && "SHOP".equals(mmv.getData().getJoinPathCd())) {
            // 비밀번호 검증
            String oldPw = CryptoUtil.encryptSHA512(po.getPw());
            log.debug("-----------------------------------------------------");
            log.debug("입력받은 현재비밀번호 : " + po.getPw());
            log.debug("입력받은 현재비밀번호(암호화) : " + oldPw);
            log.debug("DB조회한 기존 비밀번호 : " + mmv.getData().getPw());
            log.debug("-----------------------------------------------------");

            if (oldPw.equals(mmv.getData().getPw())) {// 비밀번호 검증
                po.setSiteNo(so.getSiteNo());
                po.setMemberNo(so.getMemberNo());
                resultModel = frontMemberService.updateMember(po);
            } else {// 비밀번호 변경
                resultModel.setMessage("비밀번호가 일치하지 않습니다.");
                resultModel.setSuccess(false);
            }
        } else {
            po.setSiteNo(so.getSiteNo());
            po.setMemberNo(so.getMemberNo());
            resultModel = frontMemberService.updateMember(po);
        }

        return resultModel;
    }

    @RequestMapping("/identity-success")
    public @ResponseBody ResultModel<MemberManagePO> successIdentity(@Validated(UpdateGroup.class) MemberManagePO po,
            BindingResult bindingResult) throws Exception {
        ResultModel<MemberManagePO> resultModel = new ResultModel<>();
        DmallSessionDetails sessionInfo = SessionDetailHelper.getDetails();
        po.setMemberNo(sessionInfo.getSession().getMemberNo());
        po.setSiteNo(sessionInfo.getSession().getSiteNo());

        po.setAdultCertifyYn("N");// 미성년자
        if (!"".equals(po.getMemberDi()) && po.getMemberDi() != null) { // 아이핀인증 고객에 한해서
            if (po.getMemberDi() != null) { // 아이핀인증 고객에 한해서
                po.setAdultCertifyYn(DateUtil.getAdultYn(po.getBirth()));
            }
        }
        log.debug("po.getBirth : " + po.getBirth());
        log.debug("po.getMemberDi : " + po.getMemberDi());
        log.debug("po.getAdultCertifyYn : " + po.getAdultCertifyYn());

        resultModel = frontMemberService.successIdentity(po);

        // SessionDetails 조회
        DmallSessionDetails details = SessionDetailHelper.getDetails();
        // SessionDetails 에서 Session 객제 조회
        Session session = details.getSession();
        // 성인인증여부 변경
        session.setAdult("Y".equals(po.getAdultCertifyYn()));
        // SessionDetails 에 Session 객체 세팅
        details.setSession(session);

        SiteCacheVO siteCacheVO = siteService.getSiteInfo(po.getSiteNo());

        // 쿠키에 변경사항 반영
        if (siteCacheVO.getAutoLogoutTime() == 0) {
            // 자동로그아웃 미설정 시는 세션 쿠키
            SessionDetailHelper.setDetailsToCookie(details, -1);
        } else {
            SessionDetailHelper.setDetailsToCookie(details, siteCacheVO.getAutoLogoutTime() * 60);
        }

        return resultModel;
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 9.
     * 작성자 : dong
     * 설명   : 개인정보 탈퇴페이지 FORM
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 9. dong - 최초생성
     * </pre>
     */
    @RequestMapping("/member-leave-form")
    public ModelAndView memberLeave(@Validated MemberManageSO so, BindingResult bindingResult) {
        ModelAndView mav = SiteUtil.getSkinView("/mypage/member_leave");
        DmallSessionDetails sessionInfo = SessionDetailHelper.getDetails();

        // 로그인여부 체크
        if (!sessionInfo.isLogin()) {
            mav.addObject("exMsg", MessageUtil.getMessage("biz.exception.lng.loginRequired"));
            mav.setViewName("/error/notice");
            return mav;
        }

        mav.addObject("so", so);
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            return mav;
        }

        OrderSO orderSO = new OrderSO();
        orderSO.setMemberNo(sessionInfo.getSession().getMemberNo());
        orderSO.setSiteNo(sessionInfo.getSession().getSiteNo());
        String[] ordDtlStatusCd = { "20", "23", "30", "40", "50", "60",  "70" };
        orderSO.setOrdDtlStatusCd(ordDtlStatusCd);
        ResultListModel<OrderVO> order_list = orderService.selectOrdListFrontPaging(orderSO);
        
        // 회원정보
        so.setMemberNo(sessionInfo.getSession().getMemberNo());
        ResultModel<MemberManageVO> resultModel = frontMemberService.selectMember(so);
        
        // 탈퇴사유공통코드
        List<CmnCdDtlVO> codeListModel = ServiceUtil.listCode("WITHDRAWAL_REASON_CD");
        mav.addObject("codeListModel", codeListModel);
        mav.addObject("so", so);
        mav.addObject("leftMenu", "leave_member");
        mav.addObject("orderCount", order_list.getResultList().size());
        mav.addObject("resultModel", resultModel);
        return mav;
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 9.
     * 작성자 : dong
     * 설명   : 회원 탈퇴(비밀번호검증)
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 9. dong - 최초생성
     * </pre>
     */
    @RequestMapping(value = "/auth-password-check")
    public @ResponseBody ResultModel<MemberManagePO> checkAuthPwd(@Validated MemberManageSO so,
            BindingResult bindingResult) throws Exception {
        // return ResultModel
        ResultModel<MemberManagePO> resultModel = new ResultModel<>();

        DmallSessionDetails sessionInfo = SessionDetailHelper.getDetails();

        OrderSO orderSO = new OrderSO();
        orderSO.setMemberNo(sessionInfo.getSession().getMemberNo());
        orderSO.setSiteNo(sessionInfo.getSession().getSiteNo());
        String[] ordDtlStatusCd = { "20", "23", "30", "40", "50", "60", "61", "66", "70", "71" };
        orderSO.setOrdDtlStatusCd(ordDtlStatusCd);
        ResultListModel<OrderVO> order_list = orderService.selectOrdListFrontPaging(orderSO);

        if (order_list.getResultList().size() > 0) {
            resultModel.setMessage("현재 진행중인 거래가 있어 탈퇴처리가 불가능합니다. 해당 내역을 확인하신 후 탈퇴신청하여 주세요.");
            resultModel.setSuccess(false);
            return resultModel;
        }

        // 기존등록된 비밀번호 조회
        so.setMemberNo(sessionInfo.getSession().getMemberNo());
        ResultModel<MemberManageVO> mmv = frontMemberService.selectMember(so);
        // 비밀번호 검증
        String oldPw = CryptoUtil.encryptSHA512(so.getPw());
        log.debug("-----------------------------------------------------");
        log.debug("입력받은 현재비밀번호 : " + so.getPw());
        log.debug("입력받은 현재비밀번호(암호화) : " + oldPw);
        log.debug("DB조회한 기존 비밀번호 : " + mmv.getData().getPw());
        log.debug("-----------------------------------------------------");
        if (oldPw.equals(mmv.getData().getPw())) {// 비밀번호 검증
            resultModel.setSuccess(true);
        } else {// 비밀번호 변경
            resultModel.setMessage("비밀번호가 일치하지 않습니다.");
            resultModel.setSuccess(false);
        }
        return resultModel;
    }

    @RequestMapping("/leave-possibility-check")
    public @ResponseBody ResultModel<OrderVO> checkLeavePassible(@Validated(DeleteGroup.class) MemberManagePO po,
            BindingResult bindingResult) throws Exception {

        // 03.주문현황조회(주문접수,상품준비,배송중,배송완료)
        /*
         * [주문상태코드]
         * 00 : 주문무효 , 01 : 주문접수 , 10 : 주문완료(상태코드:입금확인중) , 11 : 주문취소 , 20 : 결제완료 , 21 : 결제취소
         * , 22 : 결제실패 , 30 : 배송준비중 , 40 : 배송중 ,
         * 50 : 배송완료 , 60 : 반품(교환)신청 , 61 : 교환취소 , 66 : 교환완료 , 70 : 반품(환불)신청 ,
         * 71 : 환불취소 , 74 : 환불완료 , 90 : 구매확정
         */
        OrderSO orderSO = new OrderSO();
        orderSO.setSiteNo(po.getSiteNo());
        DmallSessionDetails sessionInfo = SessionDetailHelper.getDetails();
        orderSO.setMemberNo(sessionInfo.getSession().getMemberNo());
        String[] ordDtlStatusCd = { "01", "10", "20", "30", "40", "60", "70" };
        orderSO.setOrdDtlStatusCd(ordDtlStatusCd);
        ResultModel<OrderVO> result = orderService.selectStatusOrderCount(orderSO);
        int orderCnt = Integer.parseInt(result.getData().getStatusOrderCount());//
        log.debug("orderCnt : " + orderCnt);
        if (orderCnt > 0) {
            result.setSuccess(false);
        } else {
            result.setSuccess(true);
        }

        return result;
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 9.
     * 작성자 : dong
     * 설명   : 회원 탈퇴처리 - business
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 9. dong - 최초생성
     * </pre>
     */
    @RequestMapping("/member-delete")
    public @ResponseBody ResultModel<MemberManagePO> deleteMember(@Validated(DeleteGroup.class) MemberManagePO po,
            BindingResult bindingResult) throws Exception {
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }
        MemberManageSO so = new MemberManageSO();
        DmallSessionDetails sessionInfo = SessionDetailHelper.getDetails();
        so.setMemberNo(sessionInfo.getSession().getMemberNo());
        so.setSiteNo(sessionInfo.getSiteNo());
        ResultModel<MemberManageVO> resultModel = frontMemberService.selectMember(so);

        // 01. 탈퇴가능여부 확인(진행중인 주문건여부 확인)

        // 02. 탈퇴처리
        ResultModel<MemberManagePO> result = new ResultModel<>();
        // 삭제자 번호
        po.setWithdrawalTypeCd("01");// 탈퇴 유형 코드(일반, 강제, 탈퇴신청)
        po.setMemberNo(SessionDetailHelper.getDetails().getSession().getMemberNo());//
        po.setIntegrationMemberGbCd(SessionDetailHelper.getDetails().getSession().getIntegrationMemberGbCd());//

        po.setLoginId(resultModel.getData().getLoginId());
        po.setMemberNo(resultModel.getData().getMemberNo());
        po.setMemberNm(resultModel.getData().getMemberNm());
        po.setEmail(resultModel.getData().getEmail());
        po.setMobile(resultModel.getData().getMobile());
        // 탈퇴회원번호
        log.debug("getSiteNo >>>>>>>>>>>>>>> " + po.getSiteNo());
        log.debug("getMemberNo >>>>>>>>>>>>>>> " + po.getMemberNo());
        log.debug("getEtcWithdrawalReason >>>>>>>>>>>>>>> " + po.getEtcWithdrawalReason());
        log.debug("getWithdrawalReasonCd >>>>>>>>>>>>>>> " + po.getWithdrawalReasonCd());
        log.debug("getWithdrawalTypeCd >>>>>>>>>>>>>>> " + po.getWithdrawalTypeCd());
        result = frontMemberService.deleteMember(po);
        result.setMessage("탈퇴 처리 되었습니다.");
        result.setSuccess(true);
        return result;
    }
    
    /**
     * <pre>
     * 작성일 : 2019. 08. 06.
     * 작성자 : hskim
     * 설명   : 탈퇴회원해제
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2019. 08. 06. hskim - 최초생성
     * </pre>
     *
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/withdrawal-member-update")
    public @ResponseBody ResultModel<MemberManagePO> updateWithdrawalMem(@Validated MemberManageSO so, 
    		BindingResult bindingResult) throws Exception {
        ResultModel<MemberManagePO> resultModel = new ResultModel<>();
     
        MemberManageVO result = frontMemberService.selectWithdrawalMemberNo(so);
        MemberManagePO po = new MemberManagePO();
        po.setMemberNo(result.getMemberNo());
        resultModel = frontMemberService.updateWithdrawalMem(po);

        return resultModel;
    }

    /**
     * <pre>
     * 작성일 : 2016. 6. 20.
     * 작성자 : dong
     * 설명   : 휴면회원해제서비스
     * -------------------------------------------------------------------------
     * </pre>
     */
    @RequestMapping(value = "/dormant-member-update")
    public @ResponseBody ResultModel<MemberManagePO> updateDormantMem(@Validated MemberManageSO so,
                                                                      BindingResult bindingResult, HttpServletRequest request,
                                                                      HttpServletResponse response, Authentication authentication) throws Exception {
        ResultModel<MemberManagePO> resultModel = new ResultModel<>();

        MemberManageVO result = frontMemberService.selectDormantMemberNo(so);
        MemberManagePO po = new MemberManagePO();
        po.setMemberNo(result.getMemberNo());

        resultModel = frontMemberService.updateDormantMem(po);

        LoginVO vo = new LoginVO();
        vo.setLoginId(result.getLoginId());
        vo.setSiteNo(po.getSiteNo());
        LoginVO user = loginService.getUser(vo);

        // 03.로그인 처리
        List<SimpleGrantedAuthority> authorities = new ArrayList<>();
        authorities.add(new SimpleGrantedAuthority("ROLE_USER"));
        Session session = new Session(user);
        session.setLastAccessDate(Calendar.getInstance().getTime());

        UsernamePasswordAuthenticationToken result2 = new UsernamePasswordAuthenticationToken(result.getLoginId(), "", authorities);

        try {
            result2.setDetails(new DmallSessionDetails(result.getLoginId(), "", session, authorities));
        } catch (Exception e) {
            log.error("로그인 오류", e.getMessage());
        }
        DmallSessionDetails details = (DmallSessionDetails) result2.getDetails();
        session = details.getSession();

        MemberLoginHistPO memberLoginHistPO = new MemberLoginHistPO();
        memberLoginHistPO.setSiteNo(details.getSiteNo());
        memberLoginHistPO.setMemberNo(session.getMemberNo());
        memberLoginHistPO.setRegrNo(session.getMemberNo());
        memberLoginHistPO.setLoginIp(HttpUtil.getClientIp(request));
        loginService.insertLoginHistory(memberLoginHistPO);

        // 로그인된 경우 로그인 쿠키 추가
        if (details.isLogin()) {
            log.debug("로그인 쿠키 추가");
            String cookieValue = null;
            int maxAge = 0;

            try {
                session.setServerName(request.getServerName());
                details.setSession(session);
                cookieValue = JsonMapperUtil.getMapper().writeValueAsString(details);
            } catch (JsonProcessingException e) {
                log.error("로그인 쿠키 값 생성 오류", e.getMessage());
            }

            try {
                AppLogPO app = new AppLogPO();
                String jsessionid = request.getSession().getId();
                app.setMemberNo(details.getSession().getMemberNo());
                app.setJsessionid(jsessionid);
                app.setLoginId(details.getSession().getLoginId());
                app.setCookieVal(CryptoUtil.encryptAES(cookieValue));

            	// 자동로그인이 체크가 되었을경우
            	if (request.getParameter("auto_login") != null && "Y".equals(request.getParameter("auto_login"))) {
                    response.addCookie(CookieUtil.createEncodedCookie(CommonConstants.LOGIN_COOKIE_NAME, cookieValue,365 * 24 * 60 * 60));

                    MemberManagePO poMem = new MemberManagePO();
                    poMem.setAutoLoginGb("1");
                    poMem.setMemberNo(session.getMemberNo());
                    poMem.setSiteNo(details.getSiteNo());
                    frontMemberService.updateAppInfoCollect(poMem);
                    maxAge = 60*60*24*365;
                	// 로그인 - 세션정보 DB저장
                    app.setExpireTime( new Date( System.currentTimeMillis() + ( 1000L * 60L * 60L * 365 * 24)));
            	} else {
                    MemberManagePO poMem = new MemberManagePO();
                    poMem.setAutoLoginGb("0");
                    poMem.setMemberNo(session.getMemberNo());
                    poMem.setSiteNo(details.getSiteNo());
                    frontMemberService.updateAppInfoCollect(poMem);
                    maxAge = getCookieExpireTime(details.getSiteNo());

                    if (getCookieExpireTime(details.getSiteNo()) == -1) {
                        app.setExpireTime( new Date( System.currentTimeMillis() + ( 1000L * 60L * 60L * 365 * 24)));
                    } else {
                        app.setExpireTime( new Date( System.currentTimeMillis() + ( 1000L * getCookieExpireTime(details.getSiteNo()))));
                    }

                    response.addCookie(CookieUtil.createEncodedCookie(CommonConstants.LOGIN_COOKIE_NAME, cookieValue,getCookieExpireTime(details.getSiteNo())));
            	}

                if (SiteUtil.isMobile(request)) {
                    /*CookieUtil.addCookie(response, CommonConstants.JDSESSION_ID_COOKIE_NAME, jsessionid,getCookieExpireTime(details.getSiteNo()));*/
                	frontMemberService.insertAppLoginInfo(app);
                }

            } catch (Exception e) {
                log.error("로그인 쿠키 추가 오류", e.getMessage());
            }
        }

        return resultModel;
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 9.
     * 작성자 : dong
     * 설명   : 회원배송지 조회
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 9. dong - 최초생성
     * </pre>
     */
    @RequestMapping("/delivery-list")
    public ModelAndView selectDeliveryList(@Validated MemberDeliverySO so, BindingResult bindingResult) {
        ModelAndView mav = SiteUtil.getSkinView("/mypage/delivery_list");

        // 로그인여부 체크
        if (!SessionDetailHelper.getDetails().isLogin()) {
            mav.addObject("exMsg", MessageUtil.getMessage("biz.exception.lng.loginRequired"));
            mav.setViewName("/error/notice");
            return mav;
        }

        mav.addObject("so", so);
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            return mav;
        }
        mav.addObject("leftMenu", "delivery");

        DmallSessionDetails sessionInfo = SessionDetailHelper.getDetails();
        so.setMemberNo(sessionInfo.getSession().getMemberNo());
        mav.addObject("resultListModel", frontMemberService.selectDeliveryListPaging(so));
        return mav;
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 10.
     * 작성자 : dong
     * 설명   : 회원배송지 등록팝업
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 10. dong - 최초생성
     * </pre>
     */
    @RequestMapping("/delivery-insert-form")
    public ModelAndView insertDeliveryForm(@Validated MemberDeliverySO so, BindingResult bindingResult) {
        ModelAndView mav = SiteUtil.getSkinView("/mypage/insert_delivery");
        // 팝업 레이어 지정
        return mav;
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 10.
     * 작성자 : dong
     * 설명   : 회원배송지 등록
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 10. dong - 최초생성
     * </pre>
     */
    @RequestMapping("/delivery-insert")
    public @ResponseBody ResultModel<MemberDeliveryPO> insertDelivery(@Validated(InsertGroup.class) MemberDeliveryPO po,
            BindingResult bindingResult) throws Exception {
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }

        if ("Y".equals(po.getDefaultYn())) {
            // 초기화
            MemberDeliveryPO dpo = new MemberDeliveryPO();
            dpo.setMemberNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
            dpo.setDefaultYn("N");
            frontMemberService.updateDelivery(dpo);
        }
        po.setMemberNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
        ResultModel<MemberDeliveryPO> result = frontMemberService.insertDelivery(po);
        return result;
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 10.
     * 작성자 : dong
     * 설명   : 회원배송지 수정팝업
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 10. dong - 최초생성
     * </pre>
     */
    @RequestMapping("/delivery-update-form")
    public ModelAndView updateDeliveryForm(@RequestParam(name = "deNo", required = false) String deNo) {
        ModelAndView mav = SiteUtil.getSkinView("/mypage/update_delivery");
        MemberDeliverySO so = new MemberDeliverySO();
        so.setMemberNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
        so.setMemberDeliveryNo(deNo);
        ResultModel<MemberDeliveryVO> resultModel = frontMemberService.selectDeliveryDtl(so);
        mav.addObject("resultModel", resultModel);
        return mav;
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 10.
     * 작성자 : dong
     * 설명   : 회원배송지 정보 수정
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 10. dong - 최초생성
     * </pre>
     */
    @RequestMapping("/delivery-update")
    public @ResponseBody ResultModel<MemberDeliveryPO> updateDelivery(@Validated(InsertGroup.class) MemberDeliveryPO po,
            BindingResult bindingResult) throws Exception {
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }
        if ("Y".equals(po.getDefaultYn())) {
            // 초기화
            MemberDeliveryPO dpo = new MemberDeliveryPO();
            dpo.setMemberNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
            dpo.setDefaultYn("N");
            frontMemberService.updateDelivery(dpo);
        }
        po.setMemberNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
        ResultModel<MemberDeliveryPO> result = frontMemberService.updateDelivery(po);
        return result;
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 10.
     * 작성자 : dong
     * 설명   : 기본배송지 셋팅
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 10. dong - 최초생성
     * </pre>
     */
    @RequestMapping("/default-delivery-setting")
    public @ResponseBody ResultModel setDefaultDelivery(@Validated(InsertGroup.class) MemberDeliveryPO po,
            BindingResult bindingResult) throws Exception {
        ResultModel<MemberDeliveryPO> result = new ResultModel<>();
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }
        // 초기화
        MemberDeliveryPO dpo = new MemberDeliveryPO();
        dpo.setMemberNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
        dpo.setDefaultYn("N");
        frontMemberService.updateDelivery(dpo);
        // 기본배송지 셋팅
        po.setMemberNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
        result = frontMemberService.updateDelivery(po);
        return result;
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 10.
     * 작성자 : dong
     * 설명   : 회원배송지 삭제
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 10. dong - 최초생성
     * </pre>
     */
    @RequestMapping("/delivery-delete")
    public @ResponseBody ResultModel deleteDelivery(@Validated(DeleteGroup.class) MemberDeliveryPO po,
            BindingResult bindingResult) throws Exception {
        ResultModel<MemberDeliveryPO> result = new ResultModel<>();
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }
        po.setMemberNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
        frontMemberService.deleteDelivery(po);
        return result;
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 9.
     * 작성자 : dong
     * 설명   : 환불계좌 조회
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 9. dong - 최초생성
     * </pre>
     */
    @RequestMapping("/refund-account")
    public ModelAndView selectRefundAccountList(@Validated RefundAccountSO so, BindingResult bindingResult)
            throws Exception {
        ModelAndView mav = SiteUtil.getSkinView("/mypage/view_refund_account");

        // 로그인여부 체크
        if (!SessionDetailHelper.getDetails().isLogin()) {
            mav.addObject("exMsg", MessageUtil.getMessage("biz.exception.lng.loginRequired"));
            mav.setViewName("/error/notice");
            return mav;
        }

        so.setMemberNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
        ResultModel<RefundAccountVO> resultModel = frontMemberService.selectRefundAccount(so);
        mav.addObject("resultModel", resultModel);

        OrderSO orderSO = new OrderSO();
        orderSO.setMemberNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
        String[] ordDtlStatusCd = { "10" }; // 입금대기건만 조회(주문완료(상태코드:입금확인중)상태)
        orderSO.setOrdDtlStatusCd(ordDtlStatusCd);
        orderSO.setPage(so.getPage());
        orderSO.setRows(so.getRows());
        ResultListModel<OrderGoodsVO> resultListModel = orderService.selectOrdDtlAllListPaging(orderSO);

        mav.addObject("resultListModel", resultListModel);
        mav.addObject("so", so);
        mav.addObject("leftMenu", "refund_account");
        return mav;
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 10.
     * 작성자 : dong
     * 설명   : 환불계좌 추가/수정
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 10. dong - 최초생성
     * </pre>
     */
    @RequestMapping("/refund-account-update")
    public @ResponseBody ResultModel<RefundAccountPO> updateRefundAccount(
            @Validated(InsertGroup.class) RefundAccountPO po, BindingResult bindingResult) throws Exception {
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }
        ResultModel<RefundAccountPO> result = new ResultModel<>();

        po.setMemberNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
        // 등록된 환불계좌가 있는지 조회
        RefundAccountSO so = new RefundAccountSO();
        ResultModel<RefundAccountVO> vo = new ResultModel<>();
        so.setMemberNo(po.getMemberNo());
        vo = frontMemberService.selectRefundAccount(so);

        if (vo.getData() == null) { // 등록된 계좌가 없으면 등록
            result = frontMemberService.insertRefundAccount(po);
        } else { // 등록된 계좌가 있으면 수정
            result = frontMemberService.updateRefundAccount(po);
        }
        return result;
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 10.
     * 작성자 : dong
     * 설명   : 환불계좌 삭제
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 10. dong - 최초생성
     * </pre>
     */
    @RequestMapping("/refund-account-delete")
    public @ResponseBody ResultModel<RefundAccountPO> deleteRefundAccount(
            @Validated(InsertGroup.class) RefundAccountPO po, BindingResult bindingResult) throws Exception {
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }
        po.setMemberNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
        ResultModel<RefundAccountPO> result = frontMemberService.deleteRefundAccount(po);
        return result;
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 9.
     * 작성자 : choi-yousung
     * 설명   : 비밀번호 변경
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 9. dong - 최초생성
     * </pre>
     *
     * @param so
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/update-password")
    public @ResponseBody ResultModel<MemberManagePO> updatePwd(@Validated MemberManagePO po,
            BindingResult bindingResult) throws Exception {
        // return ResultModel
        ResultModel<MemberManagePO> resultModel = new ResultModel<>();
        log.debug("-----------------------------------------------------");
        log.debug("입력받은 현재비밀번호 : " + po.getNowPw());
        log.debug("입력받은 신규비밀번호 : " + po.getNewPw());
        // 기존등록된 비밀번호 조회
        MemberManageSO so = new MemberManageSO();
        DmallSessionDetails sessionInfo = SessionDetailHelper.getDetails();
        so.setMemberNo(sessionInfo.getSession().getMemberNo());
        so.setSiteNo(sessionInfo.getSiteNo());
        ResultModel<MemberManageVO> mmv = frontMemberService.selectMember(so);
        // 비밀번호 검증
        log.debug("-----------------------------------------------------");
        log.debug("DB조회한 기존 비밀번호 : " + mmv.getData().getPw());
        log.debug("입력받은 현재비밀번호 : " + po.getNowPw());
        log.debug("입력받은 현재비밀번호(암호화) : " + CryptoUtil.encryptSHA512(po.getNowPw()));
        log.debug("입력받은 신규비밀번호 : " + po.getNewPw());
        log.debug("입력받은 신규비밀번호(암호화) : " + CryptoUtil.encryptSHA512(po.getNewPw()));
        log.debug("-----------------------------------------------------");

        if (mmv.getData().getPw().equals(CryptoUtil.encryptSHA512(po.getNewPw()))) {
            resultModel.setSuccess(false);
            resultModel.setMessage("기존 비밀번호로는 변경하실수 없습니다.");
        } else {
            if (CryptoUtil.encryptSHA512(po.getNowPw()).equals(mmv.getData().getPw())) {
                po.setPw(po.getNewPw());
                po.setMemberNo(sessionInfo.getSession().getMemberNo());
                po.setLoginId(mmv.getData().getLoginId());
                resultModel = frontMemberService.updatePwd(po);
            } else {// 비밀번호 변경
                resultModel.setMessage("비밀번호가 일치하지 않습니다.");
                resultModel.setSuccess(false);
            }
        }
        return resultModel;
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 30.
     * 작성자 : dong
     * 설명   : 사용자 마켓포인트 내역 조회
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 30. dong - 최초생성
     * </pre>
     *
     * @param so
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/savedmoney-list")
    public ModelAndView selectSavedmnList(SavedmnPointSO so, BindingResult bindingResult) throws Exception {
        ModelAndView mav = SiteUtil.getSkinView("/mypage/savedmn_list");

        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            return mav;
        }
        // 로그인여부 체크
        if (!SessionDetailHelper.getDetails().isLogin()) {
            mav.addObject("exMsg", MessageUtil.getMessage("biz.exception.lng.loginRequired"));
            mav.setViewName("/error/notice");
            return mav;
        }

        // 보유 마켓포인트 조회
        long memberNo = SessionDetailHelper.getDetails().getSession().getMemberNo();
        MemberManageSO memberManageSO = new MemberManageSO();
        memberManageSO.setMemberNo(memberNo);
        ResultModel<MemberManageVO> prcAmt = memberManageService.selectMemSaveMn(memberManageSO);
        mav.addObject("mileage", prcAmt.getData().getPrcAmt());

        // default 기간검색(최근15일)
        if (StringUtil.isEmpty(so.getStRegDttm()) || StringUtil.isEmpty(so.getEndRegDttm())) {
            Calendar cal = new GregorianCalendar(Locale.KOREA);
            cal.add(Calendar.DAY_OF_YEAR, -15);
            SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
            String stRegDttm = df.format(cal.getTime());
            String endRegDttm = df.format(new Date());
            so.setStRegDttm(stRegDttm);
            so.setEndRegDttm(endRegDttm);
        }
        so.setMemberNoSelect(memberNo);
        mav.addObject("leftMenu", "my_mileage");
        mav.addObject("so", so);
        mav.addObject("resultListModel", savedMnPointService.selectSavedmnGetPaging(so));
        mav.addObject("extinctionSavedMn", frontMemberService.selectExtinctionSavedMn(so));
        // 등급에 따른 적립율 조회
        MemberManageSO mms = new MemberManageSO();
        mms.setSiteNo(so.getSiteNo());
        mms.setMemberNo(memberNo);
        mav.addObject("memberInfo", frontMemberService.selectMember(mms));

        mav.addObject("couponList", savedMnPointService.selectOfflineCouponList());

        return mav;
    }

    @RequestMapping("/savedmoney-list-paging")
    public ModelAndView selectSavedmnListPaging(@Validated SavedmnPointSO so, BindingResult bindingResult) {

    	ModelAndView mav = SiteUtil.getSkinView("/mypage/savedmn_list_paging");

        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            return mav;
        }

     // default 기간검색(최근15일)
        if (StringUtil.isEmpty(so.getStRegDttm()) || StringUtil.isEmpty(so.getEndRegDttm())) {
            Calendar cal = new GregorianCalendar(Locale.KOREA);
            cal.add(Calendar.DAY_OF_YEAR, -15);
            SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
            String stRegDttm = df.format(cal.getTime());
            String endRegDttm = df.format(new Date());
            so.setStRegDttm(stRegDttm);
            so.setEndRegDttm(endRegDttm);
        }
        long memberNo = SessionDetailHelper.getDetails().getSession().getMemberNo();
        so.setMemberNoSelect(memberNo);

        mav.addObject("leftMenu", "my_mileage");
        mav.addObject("so", so);
        mav.addObject("resultListModel", savedMnPointService.selectSavedmnGetPaging(so));

        return mav;
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 9.
     * 작성자 : kjw
     * 설명   : 마켓포인트 지급/차감
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 9. kjw - 최초생성
     * </pre>
     *
     * @param SavedmnPointPO
     * @return
     */
    @RequestMapping("/savedmoney-insert")
    public @ResponseBody ResultModel<SavedmnPointPO> insertSavedMn(HttpServletRequest request,
            @Validated(InsertGroup.class) SavedmnPointPO po, BindingResult bindingResult) throws Exception {

       if (bindingResult.hasErrors()) {
           log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
           throw new JsonValidationException(bindingResult);
       }

       ResultModel<SavedmnPointPO> result = couponService.issueOfflineCoupon(po);
       return result;
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 30.
     * 작성자 : dong
     * 설명   : 사용자 포인트 내역 조회
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 30. dong - 최초생성
     * </pre>
     *
     * @param so
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/point")
    public ModelAndView selectPointList(SavedmnPointSO so, BindingResult bindingResult) throws Exception {
        ModelAndView mav = SiteUtil.getSkinView("/mypage/point_list");

        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            return mav;
        }
        // 로그인여부 체크
        if (!SessionDetailHelper.getDetails().isLogin()) {
            mav.addObject("exMsg", MessageUtil.getMessage("biz.exception.lng.loginRequired"));
            mav.setViewName("/error/notice");
            return mav;
        }
        // 멤버쉽통합 체크
        String integration = SessionDetailHelper.getDetails().getSession().getIntegrationMemberGbCd();
        if (!"03".equals(integration) || integration == null) {
            mav.addObject("exMsg", "멤버쉽 정보가 없습니다. 멤버쉽 통합을 해주세요.");
            mav.setViewName("/error/notice");
            return mav;
        }

        // 보유 포인트 조회
        /*long memberNo = SessionDetailHelper.getDetails().getSession().getMemberNo();
        MemberManageSO memberManageSO = new MemberManageSO();
        memberManageSO.setMemberNo(memberNo);
        ResultModel<MemberManageVO> prcPoint = memberManageService.selectMemPoint(memberManageSO);
        mav.addObject("point", prcPoint.getData().getPrcPoint());*/

        // 인터페이스로 보유 포인트 조회
        long memberNo = SessionDetailHelper.getDetails().getSession().getMemberNo();
        Map<String, Object> param = new HashMap<>();
    	param.put("memNo", memberNo);

        Map<String, Object> point_res = InterfaceUtil.send("IF_MEM_008", param);

        if ("1".equals(point_res.get("result"))) {
        }else{
            throw new Exception(String.valueOf(point_res.get("message")));
        }
        mav.addObject("point", point_res.get("mtPoint"));

        // default 기간검색(최근15일)
        if (StringUtil.isEmpty(so.getStRegDttm()) || StringUtil.isEmpty(so.getEndRegDttm())) {
            Calendar cal = new GregorianCalendar(Locale.KOREA);
            cal.add(Calendar.DAY_OF_YEAR, -15);
            SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
            String stRegDttm = df.format(cal.getTime());
            String endRegDttm = df.format(new Date());
            so.setStRegDttm(stRegDttm);
            so.setEndRegDttm(endRegDttm);
        }

        // 인터페이스로 포인트 증감내역 조회
        param.put("pageNo",so.getPage()-1);
        param.put("searchFrom",so.getStRegDttm().replace("-", ""));
        param.put("searchTo",so.getEndRegDttm().replace("-", ""));
        Map<String, Object> list_res = InterfaceUtil.send("IF_MEM_009", param);

        if ("1".equals(list_res.get("result"))) {
        }else{
            throw new Exception(String.valueOf(list_res.get("message")));
        }
        mav.addObject("dealList", list_res.get("dealList"));
        int totalCnt = (Integer) list_res.get("totalCnt");

        // 페이징
        ResultListModel<E> result = new ResultListModel<>();

        if (totalCnt < 1) {
            result.setTotalRows(0);
            result.setFilterdRows(0);
            result.setPage(1);
            result.setRows(0);
            mav.addObject("resultListModel", result);
        }

        if (totalCnt > 0 && totalCnt % so.getRows() == 0) {
            result.setTotalPages(totalCnt / so.getRows());
        } else {
            result.setTotalPages(totalCnt / so.getRows() + 1);
        }
        result.setTotalRows(totalCnt);
        result.setFilterdRows(totalCnt);
        result.setPage(so.getPage());
        result.setRows(so.getRows());

        mav.addObject("resultListModel", result);

        mav.addObject("leftMenu", "my_point");
        mav.addObject("so", so);

        /* 2016-09-27 모바일추가 */
        //mav.addObject("extinctionPoint", frontMemberService.selectExtinctionPoint(so));

        return mav;
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 30.
     * 작성자 : dong
     * 설명   : 사용자 포인트 내역 조회
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 30. dong - 최초생성
     * </pre>
     *
     * @param so
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/offline_sal")
    public ModelAndView selectOfflineSalList(SavedmnPointSO so, BindingResult bindingResult) throws Exception {
        ModelAndView mav = SiteUtil.getSkinView("/mypage/offline_sal_list");

        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            return mav;
        }
        // 로그인여부 체크
        if (!SessionDetailHelper.getDetails().isLogin()) {
            mav.addObject("exMsg", MessageUtil.getMessage("biz.exception.lng.loginRequired"));
            mav.setViewName("/error/notice");
            return mav;
        }
        // 멤버쉽통합 체크
        String integration = SessionDetailHelper.getDetails().getSession().getIntegrationMemberGbCd();
        if (!"03".equals(integration) || integration == null) {
            mav.addObject("exMsg", "멤버쉽 정보가 없습니다. 멤버쉽 통합을 해주세요.");
            mav.setViewName("/error/notice");
            return mav;
        }

        // default 기간검색(최근15일)
        if (StringUtil.isEmpty(so.getStRegDttm()) || StringUtil.isEmpty(so.getEndRegDttm())) {
            Calendar cal = new GregorianCalendar(Locale.KOREA);
            cal.add(Calendar.DAY_OF_YEAR, -15);
            SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
            String stRegDttm = df.format(cal.getTime());
            String endRegDttm = df.format(new Date());
            so.setStRegDttm(stRegDttm);
            so.setEndRegDttm(endRegDttm);
        }

        // 인터페이스로 오프라인 구매내역 조회
        long memberNo = SessionDetailHelper.getDetails().getSession().getMemberNo();
        Map<String, Object> param = new HashMap<>();
    	param.put("memNo", memberNo);
        param.put("pageNo",so.getPage()-1);
        param.put("fromDate",so.getStRegDttm().replace("-", ""));
        param.put("toDate",so.getEndRegDttm().replace("-", ""));
        Map<String, Object> list_res = InterfaceUtil.send("IF_SAL_002", param);

        if ("1".equals(list_res.get("result"))) {
        }else{
            throw new Exception(String.valueOf(list_res.get("message")));
        }
        mav.addObject("salList", list_res.get("salList"));
        int totalCnt = (Integer) list_res.get("totalCnt");

        // 페이징
        ResultListModel<E> result = new ResultListModel<>();

        if (totalCnt < 1) {
            result.setTotalRows(0);
            result.setFilterdRows(0);
            result.setPage(1);
            result.setRows(0);
            mav.addObject("resultListModel", result);
        }

        if (totalCnt > 0 && totalCnt % so.getRows() == 0) {
            result.setTotalPages(totalCnt / so.getRows());
        } else {
            result.setTotalPages(totalCnt / so.getRows() + 1);
        }
        result.setTotalRows(totalCnt);
        result.setFilterdRows(totalCnt);
        result.setPage(so.getPage());
        result.setRows(so.getRows());

        mav.addObject("resultListModel", result);

        mav.addObject("leftMenu", "offlineSal");
        mav.addObject("so", so);

        /* 2016-09-27 모바일추가 */
        //mav.addObject("extinctionPoint", frontMemberService.selectExtinctionPoint(so));

        return mav;
    }

    @RequestMapping(value = "/offline_sal-paging")
    public ModelAndView selectOfflineSalListPaging(SavedmnPointSO so, BindingResult bindingResult) throws Exception {
        ModelAndView mav = SiteUtil.getSkinView("/mypage/offline_sal_paging");

        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            return mav;
        }

        // default 기간검색(최근15일)
        if (StringUtil.isEmpty(so.getStRegDttm()) || StringUtil.isEmpty(so.getEndRegDttm())) {
            Calendar cal = new GregorianCalendar(Locale.KOREA);
            cal.add(Calendar.DAY_OF_YEAR, -15);
            SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
            String stRegDttm = df.format(cal.getTime());
            String endRegDttm = df.format(new Date());
            so.setStRegDttm(stRegDttm);
            so.setEndRegDttm(endRegDttm);
        }

        // 인터페이스로 오프라인 구매내역 조회
        long memberNo = SessionDetailHelper.getDetails().getSession().getMemberNo();
        Map<String, Object> param = new HashMap<>();
    	param.put("memNo", memberNo);
        param.put("pageNo",so.getPage()-1);
        param.put("fromDate",so.getStRegDttm().replace("-", ""));
        param.put("toDate",so.getEndRegDttm().replace("-", ""));
        Map<String, Object> list_res = InterfaceUtil.send("IF_SAL_002", param);

        if ("1".equals(list_res.get("result"))) {
        }else{
            throw new Exception(String.valueOf(list_res.get("message")));
        }
        mav.addObject("salList", list_res.get("salList"));
        int totalCnt = (Integer) list_res.get("totalCnt");

        // 페이징
        ResultListModel<E> result = new ResultListModel<>();

        if (totalCnt < 1) {
            result.setTotalRows(0);
            result.setFilterdRows(0);
            result.setPage(1);
            result.setRows(0);
            mav.addObject("resultListModel", result);
        }

        if (totalCnt > 0 && totalCnt % so.getRows() == 0) {
            result.setTotalPages(totalCnt / so.getRows());
        } else {
            result.setTotalPages(totalCnt / so.getRows() + 1);
        }
        result.setTotalRows(totalCnt);
        result.setFilterdRows(totalCnt);
        result.setPage(so.getPage());
        result.setRows(so.getRows());

        mav.addObject("resultListModel", result);

        mav.addObject("leftMenu", "offlineSal");
        mav.addObject("so", so);

        /* 2016-09-27 모바일추가 */
        //mav.addObject("extinctionPoint", frontMemberService.selectExtinctionPoint(so));

        return mav;
    }

    /**
     * <pre>
     * 작성일 : 2016. 6. 8.
     * 작성자 : dong
     * 설명   : 약관동의 페이지 이동(회원가입)
     * -------------------------------------------------------------------------
     * </pre>
     */
    @RequestMapping(value = "/terms-apply")
    public ModelAndView join_step_01(MemberManageSO so,HttpServletRequest request) throws Exception {
        ModelAndView mav = SiteUtil.getSkinView();
       /* Map<String, String> snsMap = new HashMap<>();
        ResultListModel<SnsConfigVO> resultListModel = new ResultListModel<>();
        resultListModel = snsOutsideLinkService.selectSnsConfigList(SessionDetailHelper.getDetails().getSiteNo());
        List<SnsConfigVO> snsConfiglist = resultListModel.getResultList();
        if (snsConfiglist != null && snsConfiglist.size() > 0) {
            for (SnsConfigVO vo : snsConfiglist) {
                if ("Y".equals(vo.getLinkUseYn()) && "Y".equals(vo.getLinkOperYn())) {
                    switch (vo.getOutsideLinkCd()) {
                        case "01":// 페이스북
                            snsMap.put("fbAppId", vo.getAppId());
                            snsMap.put("fbAppSecret", vo.getAppSecret());
                            break;
                        case "02":// 네이버
                            snsMap.put("naverClientId", vo.getAppId());
                            snsMap.put("naverSecret", vo.getAppSecret());
                            break;
                        case "03":// 카카오톡
                            snsMap.put("javascriptKey", vo.getJavascriptKey());
                            break;
                    }
                }
            }
        }
        mav.addObject("snsOutsideLink", resultListModel);
        mav.addObject("snsMap", snsMap);*/


        // 본인인증서비스 여부확인후 있을 경우 인증페이지 없을경우 약관동의 페이지 이동
        List<PersonCertifyConfigVO> list = personCertifyConfigService.selectPersonCertifyConfigList(so.getSiteNo());
        boolean ioFlag = personCertifyConfigService.ipinAuthFlag(list, "member");
        boolean moFlag = personCertifyConfigService.mobileAuthFlag(list, "member");
        mav.addObject("ioFlag", ioFlag);
        mav.addObject("moFlag", moFlag);
        // 아이핀, 휴대폰 본인인증 중 하나라도 true라면 본인인증페이지로 이동한다.
        PersonCertifyConfigVO vo = new PersonCertifyConfigVO();
        if (ioFlag || moFlag) {
            // ipin set
            if (ioFlag) {
                IpinVO ipinVO = new IpinVO();
                vo.setSiteNo(so.getSiteNo());
                vo.setCertifyTypeCd("01");
                ResultModel<PersonCertifyConfigVO> result = personCertifyConfigService.selectPersonCertifyConfig(vo);
                ipinVO.setSiteNo(so.getSiteNo());
                ipinVO.setSiteCd(result.getData().getSiteCd());
                ipinVO.setSitePw(result.getData().getSitePw());
                ipinVO.setReturnUrl("/front/login/ipin-result-return");
                ipinVO.setServerName(SessionDetailHelper.getSession().getServerName());
                mav.addObject("io", IdentifyConstants.createIpin(ipinVO));
            }

            // mobile인증 setting
            if (moFlag) {
                DreamVO dreamVO = new DreamVO();
                vo.setSiteNo(so.getSiteNo());
                vo.setCertifyTypeCd("02");
                ResultModel<PersonCertifyConfigVO> result = personCertifyConfigService.selectPersonCertifyConfig(vo);
                dreamVO.setSiteNo(so.getSiteNo());
                dreamVO.setSiteCd(result.getData().getSiteCd());
                dreamVO.setSitePw(result.getData().getSitePw());
                dreamVO.setReturnUrl("/front/login/mobile-result-return");
                dreamVO.setServerName(SessionDetailHelper.getSession().getServerName());
                mav.addObject("mo", IdentifyConstants.createDreamSecret(dreamVO));
            }
            mav.setViewName("/member/join_step_01");
        } else {

            String memberTypeCd =so.getMemberTypeCd();

            if(memberTypeCd!=null && !memberTypeCd.equals("")){

                mav.addObject("so", so);

                TermConfigSO tso = new TermConfigSO();
                tso.setSiteNo(so.getSiteNo()); // 쇼핑몰 이용약관
                tso.setSiteInfoCd("03"); // 쇼핑몰 이용약관
                mav.addObject("term_03", termConfigService.selectTermConfig(tso));

                tso.setSiteInfoCd("05"); // 개인정보수집이용동의_회원
                mav.addObject("term_05", termConfigService.selectTermConfig(tso));
                tso.setSiteInfoCd("06"); // 개인정보수집이용동의_비회원
                mav.addObject("term_06", termConfigService.selectTermConfig(tso));
                tso.setSiteInfoCd("07"); // 개인정보제3자제공동의
                mav.addObject("term_07", termConfigService.selectTermConfig(tso));
                tso.setSiteInfoCd("08"); // 개인정보취급위탁동의
                mav.addObject("term_08", termConfigService.selectTermConfig(tso));


                tso.setSiteInfoCd("04"); // 개인정보처리방침 *
                mav.addObject("term_04", termConfigService.selectTermConfig(tso));

                tso.setSiteInfoCd("22"); // 위치정보 이용약관
                mav.addObject("term_22", termConfigService.selectTermConfig(tso));

                tso.setSiteInfoCd("21"); // 청소년 보호정책
                mav.addObject("term_21", termConfigService.selectTermConfig(tso));

                tso.setSiteInfoCd("09"); // 멤버쉽 회원 이용약관
                mav.addObject("term_09", termConfigService.selectTermConfig(tso));

                tso.setSiteInfoCd("10"); // 온라인 몰 이용약관
                mav.addObject("term_10", termConfigService.selectTermConfig(tso));

                mav.setViewName("/member/join_step_02");
            }else{
                mav.setViewName("/member/join_step_00");
            }



            //이메일 인증 후 약관페이지로 이동..
            // 이메일 , 인증키 복호화
            /*String user_email = CryptoUtil.decryptAES(request.getParameter("p1"));
            String key =CryptoUtil.decryptAES(request.getParameter("p2"));
            String memberTypeCd =CryptoUtil.decryptAES(request.getParameter("p3"));
            String bizRegNo =CryptoUtil.decryptAES(request.getParameter("p4"));

            if(!user_email.equals("") && !key.equals("")){

                so.setEmail(user_email);
                so.setEmailCertifyValue(key);
                so.setMemberTypeCd(memberTypeCd);
                so.setSearchBizNo(bizRegNo);
                ResultModel<MemberManageVO> result=  frontMemberService.selectEmailAuthKey(so);

                if(result!=null) {
                    mav.addObject("so", so);
                    TermConfigSO tso = new TermConfigSO();
                    tso.setSiteNo(so.getSiteNo()); // 쇼핑몰 이용약관
                    tso.setSiteInfoCd("03"); // 쇼핑몰 이용약관
                    mav.addObject("term_03", termConfigService.selectTermConfig(tso));
                    tso.setSiteInfoCd("04"); // 개인정보처리방침
                    mav.addObject("term_04", termConfigService.selectTermConfig(tso));
                    tso.setSiteInfoCd("05"); // 개인정보수집이용동의_회원
                    mav.addObject("term_05", termConfigService.selectTermConfig(tso));
                    tso.setSiteInfoCd("06"); // 개인정보수집이용동의_비회원
                    mav.addObject("term_06", termConfigService.selectTermConfig(tso));
                    tso.setSiteInfoCd("07"); // 개인정보제3자제공동의
                    mav.addObject("term_07", termConfigService.selectTermConfig(tso));
                    tso.setSiteInfoCd("08"); // 개인정보취급위탁동의
                    mav.addObject("term_08", termConfigService.selectTermConfig(tso));

                    mav.setViewName("/member/join_step_02");

                    // 인증 완료시 인증 데이터 삭제
                    frontMemberService.deleteEmailAuthKey(so);

                }else{
                    *//* 인증번호가 유효하지 않습니다. *//*
                    //throw new CustomException("front.web.member.certify.key");
                    mav.setViewName("/member/join_step_05");

                }
            }else {
               // 이메일 인증 페이지
                mav.setViewName("/member/join_step_00");

            }*/
        }
        return mav;
    }

    @RequestMapping(value = "/terms-apply-detail")
    public ModelAndView join_step_02(MemberManageSO so, BindingResult bindingResult) throws Exception {
        ModelAndView mav = new ModelAndView("/member/join_step_02");
        TermConfigSO tso = new TermConfigSO();
        if ("".equals(so.getMemberDi()) || so.getMemberDi() == null) {
            throw new Exception("본인 인증후 정상적인 경로로 접근하여야합니다.");
        }

        mav.addObject("so", so);
        tso.setSiteNo(so.getSiteNo()); // 쇼핑몰 이용약관
        tso.setSiteInfoCd("03"); // 쇼핑몰 이용약관
        mav.addObject("term_03", termConfigService.selectTermConfig(tso));
        tso.setSiteInfoCd("04"); // 개인정보처리방침
        mav.addObject("term_04", termConfigService.selectTermConfig(tso));
        tso.setSiteInfoCd("05"); // 개인정보수집이용동의_회원
        mav.addObject("term_05", termConfigService.selectTermConfig(tso));
        tso.setSiteInfoCd("06"); // 개인정보수집이용동의_비회원
        mav.addObject("term_06", termConfigService.selectTermConfig(tso));
        tso.setSiteInfoCd("07"); // 개인정보제3자제공동의
        mav.addObject("term_07", termConfigService.selectTermConfig(tso));
        tso.setSiteInfoCd("08"); // 개인정보취급위탁동의
        mav.addObject("term_08", termConfigService.selectTermConfig(tso));
        return mav;
    }

    /**
     * <pre>
     * 작성일 : 2016. 6. 8.
     * 작성자 : dong
     * 설명   : 회원정보 입력페이지 이동(회원가입)
     * -------------------------------------------------------------------------
     * </pre>
     */
    @RequestMapping(value = "/member-insert-form")
    public ModelAndView join_step_03(MemberManageSO so) throws Exception {
        ModelAndView mav = SiteUtil.getSkinView("/member/join_step_03");

        // 본인인증서비스 여부확인후 있을 경우 인증페이지 없을경우 약관동의 페이지 이동
        List<PersonCertifyConfigVO> list = personCertifyConfigService.selectPersonCertifyConfigList(so.getSiteNo());
        boolean ioFlag = personCertifyConfigService.ipinAuthFlag(list, "member");
        boolean moFlag = personCertifyConfigService.mobileAuthFlag(list, "member");

        // 본인인증 수단중 하나라도 사용한다면 본인인증을 했는지 체크한다
        if (ioFlag || moFlag) {
            if ("".equals(so.getMemberDi()) || so.getMemberDi() == null) {
                /* 본인 인증후 정상적인 경로로 접근하여야합니다. */
                throw new CustomException("front.web.member.abnormal.path");
            }
        }

        /*String email = so.getEmail()==null?"":so.getEmail();
        String emailCertifyValue = so.getEmailCertifyValue()==null?"":so.getEmailCertifyValue();

        if (email.equals("") || emailCertifyValue.equals("")) {
            *//* 이메일 인증후 정상적인 경로로 접근하여야합니다. *//*
            throw new CustomException("front.web.member.email.path");
        }*/

        if (SiteUtil.isMobile()) {
            /*so.setRule01Agree("Y");
            so.setRule02Agree("Y");
            so.setRule03Agree("Y");*/
            so.setRule04Agree("Y");
            so.setRule22Agree("Y");
            so.setRule21Agree("Y");
            so.setRule09Agree("Y");
            so.setRule10Agree("Y");
        }

        /*if (so.getRule01Agree() == null || so.getRule02Agree() == null || so.getRule03Agree() == null) {
            *//* 필수약관에 모두 동의하셔야합니다. *//*
            throw new CustomException("front.web.member.apply.terms");
        }*/

        if (so.getRule04Agree() == null ||
            so.getRule22Agree() == null ||
            so.getRule21Agree() == null ||
            so.getRule09Agree() == null ||
            so.getRule10Agree() == null
        ) {
            /* 필수약관에 모두 동의하셔야합니다. */
            throw new CustomException("front.web.member.apply.terms");
        }

        mav.addObject("so", so);


        TermConfigSO tso = new TermConfigSO();
        tso.setSiteNo(so.getSiteNo()); // 쇼핑몰 이용약관
        tso.setSiteInfoCd("03"); // 쇼핑몰 이용약관
        mav.addObject("term_03", termConfigService.selectTermConfig(tso));
        tso.setSiteInfoCd("05"); // 개인정보수집이용동의_회원
        mav.addObject("term_05", termConfigService.selectTermConfig(tso));
        tso.setSiteInfoCd("06"); // 개인정보수집이용동의_비회원
        mav.addObject("term_06", termConfigService.selectTermConfig(tso));
        tso.setSiteInfoCd("07"); // 개인정보제3자제공동의
        mav.addObject("term_07", termConfigService.selectTermConfig(tso));
        tso.setSiteInfoCd("08"); // 개인정보취급위탁동의
        mav.addObject("term_08", termConfigService.selectTermConfig(tso));


        tso.setSiteInfoCd("04"); // 개인정보처리방침 *
        mav.addObject("term_04", termConfigService.selectTermConfig(tso));

        tso.setSiteInfoCd("22"); // 위치정보 이용약관
        mav.addObject("term_22", termConfigService.selectTermConfig(tso));

        tso.setSiteInfoCd("21"); // 청소년 보호정책
        mav.addObject("term_21", termConfigService.selectTermConfig(tso));

        tso.setSiteInfoCd("09"); // 멤버쉽 회원 이용약관
        mav.addObject("term_09", termConfigService.selectTermConfig(tso));

        tso.setSiteInfoCd("10"); // 온라인 몰 이용약관
        mav.addObject("term_10", termConfigService.selectTermConfig(tso));

        return mav;
    }

    /**
     * <pre>
     * 작성일 : 2016. 6. 8.
     * 작성자 : dong
     * 설명   : 아이디 중복확인
     * -------------------------------------------------------------------------
     * </pre>
     */
    @RequestMapping("/duplication-id-check")
    public @ResponseBody ResultModel<MemberManageVO> checkDuplicationId(MemberManageSO so, BindingResult bindingResult)
            throws Exception {
        ResultModel<MemberManageVO> result = new ResultModel<>();
        int loginId = frontMemberService.checkDuplicationId(so);
        if (loginId > 0) {
            result.setSuccess(false);
        } else {
            result.setSuccess(true);
        }
        return result;
    }

    /**
     * <pre>
     * 작성일 : 2018. 11. 2.
     * 작성자 : hskim
     * 설명   : 회원 중복확인
     * -------------------------------------------------------------------------
     * </pre>
     */
    @RequestMapping("/duplication-mem-check")
    public @ResponseBody List<MemberManageVO> checkDuplicationMem(MemberManageSO so, BindingResult bindingResult)
            throws Exception {

    	if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }

        List<MemberManageVO> list = frontMemberService.checkDuplicationMem(so);

        return list;
    }

    /**
     * <pre>
     * 작성일 : 2016. 6. 8.
     * 작성자 : dong
     * 설명   : SNS부가정보 입력
     * -------------------------------------------------------------------------
     * </pre>
     */
    @RequestMapping("/sns-memberinfo-update")
    public @ResponseBody ResultModel<MemberManageVO> updateSnsMemberInfo(
            @Validated(InsertGroup.class) MemberManagePO po, BindingResult bindingResult) throws Exception {
        ResultModel<MemberManageVO> result = new ResultModel<>();
        long memberNo = SessionDetailHelper.getDetails().getSession().getMemberNo();
        po.setMemberNo(memberNo);
        frontMemberService.updateMember(po);
        return result;
    }

    /**
     * <pre>
     * 작성일 : 2016. 6. 8.
     * 작성자 : dong
     * 설명   : 날개배너에 노출할 정보조회(장바구니갯수,관심상품갯수)
     * -------------------------------------------------------------------------
     * </pre>
     */
    @RequestMapping("/quick-info")
    public @ResponseBody ResultModel<MemberManageVO> selectQuickInfo(MemberManageSO so, BindingResult bindingResult,
            HttpServletRequest request) throws Exception {
        ResultModel<MemberManageVO> result = new ResultModel<>();
        int basket_cnt = 0;
        int interest_cnt = 0;
        int delivery_cnt = 0;
        DmallSessionDetails sessionInfo = SessionDetailHelper.getDetails();
        if (sessionInfo.isLogin()) { // 로그인 했을 경우 장바구니,관심상품
                                     // DB조회
            long memberNo = sessionInfo.getSession().getMemberNo();
            BasketSO bs = new BasketSO();
            bs.setSiteNo(so.getSiteNo());
            bs.setMemberNo(memberNo);
            InterestSO is = new InterestSO();
            is.setSiteNo(so.getSiteNo());
            is.setMemberNo(memberNo);
            interest_cnt = frontInterestService.selectInterestTotalCount(is);
            OrderSO orderSO = new OrderSO();
            orderSO.setSiteNo(so.getSiteNo());
            orderSO.setMemberNo(memberNo);
            ResultModel<OrderVO> order_cnt_info = orderService.selectOrderCountInfo(orderSO);
            delivery_cnt = Integer.parseInt(order_cnt_info.getData().getDeliveryOrderCount());

            //DB에 담긴 장바구니 수량 + 비로그인시 세션에 담긴 장바구니 수량
            basket_cnt = frontBasketService.selectBasketTotalCount(bs);

            //HttpSession session = request.getSession();
            //List<BasketPO> basketSession = (List<BasketPO>) session.getAttribute("basketSession");
            //if (basketSession != null) basket_cnt += basketSession.size();

        } else {// 비로그인시 장바구니 수량은 세션조회
            HttpSession session = request.getSession();
            List<BasketPO> basketSession = (List<BasketPO>) session.getAttribute("basketSession");
            if (basketSession != null) basket_cnt = basketSession.size();
        }
        MemberManageVO vo = new MemberManageVO();
        vo.setBasketCnt(Integer.toString(basket_cnt));
        vo.setInterestCnt(Integer.toString(interest_cnt));
        vo.setDeliveryCnt(Integer.toString(delivery_cnt));
        
        if (sessionInfo.isLogin()) {
        	CouponSO couponSO = new CouponSO();
        	couponSO.setSiteNo(so.getSiteNo());
        	couponSO.setMemberNo(sessionInfo.getSession().getMemberNo());
        	Integer couponCount = couponService.selectAvailableDownloadCouponCnt(couponSO);
        	vo.setCpCnt(Integer.toString(couponCount));
        }

        result.setData(vo);
        return result;
    }

    /**
     *
     * <pre>
     * 작성일 : 2016. 8. 12.
     * 작성자 : dong
     * 설명   : 재입고 신청내역조회
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 8. 12. dong - 최초생성
     * </pre>
     *
     * @param so
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/stock-alarm")
    public ModelAndView selectStockAlarm(RestockNotifySO so) throws Exception {
        ModelAndView mav = SiteUtil.getSkinView("/mypage/stock_alarm_list");


        // 로그인여부 체크
        if (!SessionDetailHelper.getDetails().isLogin()) {
            mav.addObject("exMsg", MessageUtil.getMessage("biz.exception.lng.loginRequired"));
            mav.setViewName("/error/notice");
            return mav;
        }

        long memberNo = SessionDetailHelper.getDetails().getSession().getMemberNo();
        so.setMemberNo(memberNo);
        ResultListModel<RestockNotifyVO> resultListModel = restockNotifyService.selectRestockNotifyListPaging(so);
        mav.addObject("so", so);
        mav.addObject("leftMenu", "goods_sms");
        mav.addObject("resultListModel", resultListModel);
        return mav;
    }

    /**
     *
     * <pre>
     * 작성일 : 2016. 8. 12.
     * 작성자 : dong
     * 설명   : 재입금 신청내역삭제
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 8. 12. dong - 최초생성
     * </pre>
     *
     * @param so
     * @return
     * @throws Exception
     */
    @RequestMapping("/restock-notify-delete")
    public @ResponseBody ResultModel<RestockNotifyPOListWrapper> deleteRestockNotify(
            @Validated(DeleteGroup.class) RestockNotifyPOListWrapper po, BindingResult bindingResult) throws Exception {
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }
        ResultModel<RestockNotifyPOListWrapper> result = restockNotifyService.deleteRestockNotify(po);
        return result;
    }

    @RequestMapping(value = "/send-sms-certify")
    public @ResponseBody ResultModel<MemberManagePO> sendEmail(MemberManagePO po) throws Exception {
    	ResultModel<MemberManagePO> resultModel = new ResultModel<>();
    	
        DmallSessionDetails sessionInfo = SessionDetailHelper.getDetails();
        long siteNo = sessionInfo.getSession().getSiteNo();
        po.setSiteNo(siteNo);
        String mobile = po.getMobile();
        po.setMobile(mobile);
        int loginId = frontMemberService.checkDuplicationMobile(po);
        if (loginId > 0) {
        	resultModel.setSuccess(false);
        	resultModel.setMessage("이미 인증 받은 휴대전화 번호입니다.");
        } else {
    	
	    	String key = new TempKey().getKey(6, false); // 인증키 생성
	        po.setEmailCertifyValue(key);
	        resultModel.setExtraString(key);
	        
	        // 사이트정보 조회
	        SiteSO siteSo = new SiteSO();
	        siteSo.setSiteNo(siteNo);
	        ResultModel<SiteVO> siteInfo = siteInfoService.selectSiteInfo(siteSo);
	
	        List<SmsSendPO> listpo = new ArrayList<SmsSendPO>();
	    	SmsSendPO smsSendPO = new SmsSendPO();
	
	        if (siteInfo.getData().getCertifySendNo() == null || ("").equals(siteInfo.getData().getCertifySendNo())) {
	            throw new CustomException("biz.exception.operation.certifySendNoNull", new Object[] { "코드그룹" });
	        } else {
	        	smsSendPO.setSendTelno(siteInfo.getData().getCertifySendNo());
	        }
	
	        smsSendPO.setSiteNo(siteNo);
	        String sendWords = "<#> 다비치마켓 인증코드 : " + key + "\r\n입력란에 인증코드를 입력해 주세요. hbVQxJrjiB8";
	        smsSendPO.setSendWords(sendWords);
	        smsSendPO.setSendTargetCd("01");
	        // sms, 장문
	        smsSendPO.setSendFrmCd("02");
	        smsSendPO.setPossCnt(null);
	        smsSendPO.setAutoSendYn("N");
	        
	        smsSendPO.setRegrNo((long) 9999);
	        smsSendPO.setSenderNo((long) 9999);
	        smsSendPO.setSenderId("admin1");
	        smsSendPO.setSenderNm("관리자");
	
	        if(po.getMemberNo() != null && !"".equals(po.getMemberNo())) {
	        	smsSendPO.setReceiverNo(String.valueOf(po.getMemberNo()));
	        }else {
	        	smsSendPO.setReceiverNo(String.valueOf(0));
	        }
	        smsSendPO.setReceiverNm(CryptoUtil.decryptAES(po.getMemberNm()));
	        smsSendPO.setReceiverId(CryptoUtil.decryptAES(po.getLoginId()));
	        smsSendPO.setRecvTelNo(mobile);
	        smsSendPO.setSendTelno(siteInfo.getData().getCertifySendNo());
	        smsSendPO.setFdestine(mobile);
	        smsSendPO.setFcallback(siteInfo.getData().getCertifySendNo().replaceAll("-", ""));
	       
	        listpo.add(smsSendPO);
	        
	        smsSendService.sendSms(listpo);

	        resultModel.setSuccess(true);
	        resultModel.setMessage("인증코드가 회원님의 휴대전화로 발송되었습니다.");
        }
        
        return resultModel;
    }

    /**
     * <pre>
     * 작성일 : 2018. 7. 23.
     * 작성자 : hskim
     * 설명   : 맴버쉽 통합페이지 FORM
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 7. 23. hskim - 최초생성
     * </pre>
     */
    @RequestMapping("/member-integration-form")
    public ModelAndView memberIntegration(@Validated MemberManageSO so, BindingResult bindingResult) throws Exception {
    	ModelAndView mav = SiteUtil.getSkinView("/mypage/member_integration");

    	// 로그인여부 체크
        if (!SessionDetailHelper.getDetails().isLogin()) {
            mav.addObject("exMsg", MessageUtil.getMessage("biz.exception.lng.loginRequired"));
            mav.setViewName("/error/notice");
            return mav;
        }

        mav.addObject("so", so);
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            return mav;
        }
        DmallSessionDetails sessionInfo = SessionDetailHelper.getDetails();
        so.setMemberNo(sessionInfo.getSession().getMemberNo());
        so.setMemberNm(sessionInfo.getSession().getMemberNm());
        so.setMobile(sessionInfo.getSession().getMobile());
        so.setIntegrationMemberGbCd(sessionInfo.getSession().getIntegrationMemberGbCd());

        // 로그인여부 체크
        if (so.getMemberNo() == null || "".equals(so.getMemberNo())) {
            mav.addObject("exMsg", "로그인이 필요한 서비스 입니다.");
            mav.setViewName("/error/notice");
            return mav;
        }

        // 통합회원여부 체크
        if (so.getIntegrationMemberGbCd() == null || "".equals(so.getIntegrationMemberGbCd())) {
            mav.addObject("exMsg", "멤버쉽 정보가 없습니다. 관리자에게 문의해주세요.");
            mav.setViewName("/error/notice");
            return mav;
        }else if ("02".equals(so.getIntegrationMemberGbCd())) {//간편회원
        	mav.addObject("exMsg", "정회원 전환을 먼저 해주세요.");
        	mav.setViewName("/error/notice");
            return mav;
        }else if ("03".equals(so.getIntegrationMemberGbCd())) {//통합회원
        	mav.addObject("exMsg", "이미 멤버쉽 통합이 완료되었습니다.");
            mav.setViewName("/error/notice");
            return mav;
        }

        // 방문매장 시/도/구/군 목록
        List<CmnCdDtlVO> codeListModel = ServiceUtil.listCode("STORE_AREA_CD");
        mav.addObject("codeListModel", codeListModel);

        PersonCertifyConfigVO vo = new PersonCertifyConfigVO();
        DreamVO dreamVO = new DreamVO();
        vo.setSiteNo(so.getSiteNo());
        vo.setCertifyTypeCd("02");
        ResultModel<PersonCertifyConfigVO> result = personCertifyConfigService.selectPersonCertifyConfig(vo);
        dreamVO.setSiteNo(so.getSiteNo());
        dreamVO.setSiteCd(result.getData().getSiteCd());
        dreamVO.setSitePw(result.getData().getSitePw());
        dreamVO.setReturnUrl("/front/login/mobile-result-return");
        dreamVO.setServerName(SessionDetailHelper.getSession().getServerName());
        mav.addObject("mo", IdentifyConstants.createDreamSecret(dreamVO));


        mav.addObject("so", so);
        mav.addObject("leftMenu", "integration_member");
        return mav;
    }


    /**
     * <pre>
     * 작성일 : 2018. 7. 24.
     * 작성자 : hskim
     * 설명   : 다비전 회원정보 조회
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2018. 7. 24. hskim - 최초생성
     * </pre>
     */
    @RequestMapping("/integration-possibility-check")
    public @ResponseBody ResultModel<MemberManagePO> checkIntegrationPassible(@Validated MemberManagePO po,
    		BindingResult bindingResult) throws Exception {

    	ResultModel<MemberManagePO> resultModel = new ResultModel<>();

    	Map<String, Object> param = new HashMap<>();

    	param.put("custName", po.getCustName());
    	param.put("hp", po.getHp());
    	if(!"".equals(po.getStrCode()) && !StringUtil.isEmpty(po.getStrCode())){
    		param.put("strCode", po.getStrCode());
    	}

    	Map<String, Object> res = InterfaceUtil.send("IF_MEM_001", param);


    	if (!"1".equals((String) res.get("result"))) {
        	resultModel.setSuccess(false);
        	resultModel.setMessage(String.valueOf(res.get("message")));
        } else {
            List<Map<String,String>> custList =  new ArrayList<>();
		    custList = (List<Map<String,String>>) res.get("custList");

        	if (custList.size() > 1) {
        		resultModel.setExtraString("3");
        	}
        	else if (custList.size() < 1) {
        		resultModel.setExtraString("2");
        	}else{
        		resultModel.setExtraString("1");
            	for(Map<String,String> map : custList) {
            		po.setCdCust(map.get("cdCust"));
            		po.setLvl(map.get("lvl"));
            	}
        	}
        	resultModel.setSuccess(true);
        }
    	resultModel.setData(po);

        return resultModel;
    }

    /**
     * <pre>
     * 작성일 : 2018. 7. 24.
     * 작성자 : hskim
     * 설명   : 회원을 멤버쉽 통합회원으로 변경
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2018. 7. 24. hskim - 최초생성
     * </pre>
     */
    @RequestMapping("/integration-update")
    public @ResponseBody ResultModel<MemberManagePO> updateMemberIntegration(@Validated(UpdateGroup.class) MemberManagePO po,
            BindingResult bindingResult) throws Exception {
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }
        // return ResultModel
        ResultModel<MemberManagePO> resultModel = new ResultModel<>();

        resultModel = frontMemberService.updateMemberIntegration(po);

        return resultModel;
    }

    /**
     * <pre>
     * 작성일 : 2018. 7. 23.
     * 작성자 : hskim
     * 설명   : 맴버쉽통합 완료 페이지 FORM
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 7. 23. hskim - 최초생성
     * </pre>
     */
    @RequestMapping("/integration-success-form")
    public ModelAndView integrationSucc(@Validated MemberManageSO so, BindingResult bindingResult) throws Exception {
    	ModelAndView mav = SiteUtil.getSkinView("/mypage/member_integration_succ");

    	DmallSessionDetails sessionInfo = SessionDetailHelper.getDetails();
        so.setMemberNo(sessionInfo.getSession().getMemberNo());

        MemberManageVO vo = memberManageService.selectIntegrationDttm(so);

    	mav.addObject("so", so);
        mav.addObject("leftMenu", "integration_member");
        mav.addObject("integrationDttm", vo.getMemberIntegrationDttm());

        return mav;
    }

    /**
     * <pre>
     * 작성일 : 2018. 8. 17.
     * 작성자 : hskim
     * 설명   : 추천인 아이디 체크
     * -------------------------------------------------------------------------
     * </pre>
     */
    @RequestMapping("/recomMember-id-check")
    public @ResponseBody ResultModel<MemberManageVO> checkRecomMemberId(MemberManageSO so, BindingResult bindingResult)
            throws Exception {
        ResultModel<MemberManageVO> result = new ResultModel<>();
        String chk_memberNo = frontMemberService.checkRecomMemberId(so);

        if (!"".equals(chk_memberNo) && chk_memberNo != null) {
            result.setSuccess(true);
        } else {
            result.setSuccess(false);
        }

        result.setExtraString(chk_memberNo);

        return result;
    }



    /**
     * <pre>
     * 작성일 : 2018. 8. 24.
     * 작성자 : khy
     * 설명   : 회원정보 수정 (토큰,자동로그인,위치정보동의,알림구분)
     * -------------------------------------------------------------------------
     * </pre>
     */
    @RequestMapping("/app-info-collect")
    public @ResponseBody ResultModel<MemberManagePO> appInfoCollect(@Validated(UpdateGroup.class) MemberManagePO po,
            BindingResult bindingResult, HttpServletRequest request) throws Exception {

        ResultModel<MemberManagePO> resultModel = new ResultModel<>();
        DmallSessionDetails sessionInfo = SessionDetailHelper.getDetails();

        if(po.getMemberNo()!=null){
            po.setMemberNo(po.getMemberNo());
        }else{
            po.setMemberNo(sessionInfo.getSession().getMemberNo());
        }

        po.setSiteNo(sessionInfo.getSession().getSiteNo());

        resultModel = frontMemberService.updateAppInfoCollect(po);

		if ("1".equals(po.getAutoLoginGb())) {
	        AppLogPO app = new AppLogPO();
	        String jsessionid = request.getSession().getId();
	        app.setJsessionid(jsessionid);
			app.setExpireTime( new Date( System.currentTimeMillis() + ( 1000L * 60L * 60L * 365 * 24)));
			frontMemberService.updateAppLoginInfo(app);
		} else if ("0".equals(po.getAutoLoginGb())) {
	        AppLogPO app = new AppLogPO();
	        String jsessionid = request.getSession().getId();
	        app.setJsessionid(jsessionid);
            if (getCookieExpireTime(po.getSiteNo()) == -1) {
                app.setExpireTime( new Date( System.currentTimeMillis() + ( 1000L * 60L * 60L * 365 * 24)));
            } else {
                app.setExpireTime( new Date( System.currentTimeMillis() + ( 1000L * getCookieExpireTime(po.getSiteNo()))));
            }
    		frontMemberService.updateAppLoginInfo(app);
		}

		// 다비전에 앱로그인 정보 업데이트 ....
		// 로그인 할경우  다비전에 로그인 일시 UPDATE 하는것으로 변경 ... 2019-02-07
		/*Map<String, Object> param = new HashMap<>();
        param.put("memNo", po.getMemberNo());

        Map<String, Object> result = InterfaceUtil.send("IF_MEM_022", param);
        if ("1".equals(result.get("result"))) {
        }else{
            //처리결과가 어떻든 진행하도록...
            //throw new Exception(String.valueOf(result.get("message")));
        }*/

        // 앱 최초 로그인 일시 DB 업데이트
	    frontMemberService.updateAppFirstLogin(po);


        return resultModel;
    }

    private int getCookieExpireTime(Long siteNo) {
        SiteCacheVO vo = siteService.getSiteInfo(siteNo);

        if (vo.getAutoLogoutTime() == 0) {
            return -1;
        } else {
            return vo.getAutoLogoutTime() * 60;
        }
    }


    /**
     * <pre>
     * 작성일 : 2018. 8. 16.
     * 작성자 : khy
     * 설명   : BEACON - PUSH 전송
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2018. 8. 16. khy - 최초생성
     * </pre>
     *
     * @param po
     * @param bindingResult
     * @return
     * @throws Exception
     */
    @RequestMapping("/beacon-push")
    public @ResponseBody ResultModel<PushSendVO> appPush(PushSendPO po) throws Exception {

    	ResultModel<PushSendVO> result = new ResultModel<>();
    	po.setMemberNo(String.valueOf(SessionDetailHelper.getDetails().getSession().getMemberNo()));
    	//푸시서버 연계
    	pushDelegateService.beaconSend(po);

        return result;
    }


    /**
     * <pre>
     * 작성일 : 2018. 12. 11.
     * 작성자 : khy
     * 설명   : 연말정산 조회
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 9. dong - 최초생성
     * </pre>
     */
    @RequestMapping("/yearend-taxList")
    public ModelAndView selectYearendTaxList(@Validated MemberYearSO so, BindingResult bindingResult) throws Exception {
        ModelAndView mav = SiteUtil.getSkinView("/mypage/yearend_taxList");

        // 로그인여부 체크
        if (!SessionDetailHelper.getDetails().isLogin()) {
            mav.addObject("exMsg", MessageUtil.getMessage("biz.exception.lng.loginRequired"));
            mav.setViewName("/error/notice");
            return mav;
        }

        mav.addObject("so", so);
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            return mav;
        }
        mav.addObject("leftMenu", "yearend_taxList");

        // 인터페이스로 보유 포인트 조회
        long memberNo = SessionDetailHelper.getDetails().getSession().getMemberNo();
        Map<String, Object> param = new HashMap<>();
    	param.put("memNo", memberNo);

// 테스트 회원번호
//    	param.put("memNo", 1877);
//    	param.put("yyyy", "2016");

    	Calendar calendar = new GregorianCalendar(Locale.KOREA);
    	int nYear = calendar.get(Calendar.YEAR);

    	if (so.getYyyy() == null || "".equals(so.getYyyy())) {
        	param.put("yyyy", String.valueOf(nYear));
    	} else {
        	param.put("yyyy", so.getYyyy());
    	}

        Map<String, Object> res = InterfaceUtil.send("IF_MEM_023", param);

//        if ("1".equals(res.get("result"))) {
//        }else{
//            throw new Exception(String.valueOf(res.get("message")));
//        }

        mav.addObject("yearList", res.get("yearEndTaxList"));

        return mav;
    }



    /**
     * <pre>
     * 작성일 : 2018. 12. 11.
     * 작성자 : khy
     * 설명   : 연말정산 조회
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 9. dong - 최초생성
     * </pre>
     */
    @RequestMapping("/yearend-taxPrint")
    public ModelAndView selectYearendTaxPrint(@Validated MemberYearSO so, BindingResult bindingResult) throws Exception {
        ModelAndView mav = SiteUtil.getSkinView("/mypage/yearend_taxPrint");

        // 로그인여부 체크
        if (!SessionDetailHelper.getDetails().isLogin()) {
            mav.addObject("exMsg", MessageUtil.getMessage("biz.exception.lng.loginRequired"));
            mav.setViewName("/error/notice");
            return mav;
        }

        mav.addObject("so", so);
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            return mav;
        }

        // 인터페이스로 보유 포인트 조회
        long memberNo = SessionDetailHelper.getDetails().getSession().getMemberNo();
        Map<String, Object> param = new HashMap<>();
    	param.put("cdCust", so.getCdCust());
    	param.put("yyyy", so.getYyyy());
    	param.put("strCode", so.getStrCode());

//    	param.put("memNo", 1877);
//    	param.put("yyyy", "2016");

        Map<String, Object> res = InterfaceUtil.send("IF_MEM_024", param);

        if ("1".equals(res.get("result"))) {
        }else{
            throw new Exception(String.valueOf(res.get("message")));
        }

        mav.addObject("yearPrint", res.get("yearEndTaxList"));

        return mav;
    }




    /**
     * <pre>
     * 작성일 : 2018. 12. 11.
     * 작성자 : khy
     * 설명   : 연말정산 조회
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 9. dong - 최초생성
     * </pre>
     */
    @RequestMapping("/yearend-auto")
    public @ResponseBody Map<String, Object> updateYearendAuto(@Validated MemberYearSO so, BindingResult bindingResult) throws Exception {


        // 인터페이스로 보유 포인트 조회
        long memberNo = SessionDetailHelper.getDetails().getSession().getMemberNo();
        Map<String, Object> param = new HashMap<>();
    	param.put("memNo", memberNo);
    	//param.put("memNo", 1877);
    	param.put("resNo", so.getResNo());

        Map<String, Object> res = InterfaceUtil.send("IF_MEM_025", param);

        //if ("1".equals(res.get("result"))) {
        //}else{
        // throw new Exception(String.valueOf(res.get("message")));
        //}

        return res;
    }

    /**
     * <pre>
     * 작성일 : 2019. 4. 24.
     * 작성자 : hskim
     * 설명   : 휴대폰인증 화면
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2019. 4. 24. hskim - 최초생성
     * </pre>
     */
    @RequestMapping("/member-certify-form")
    public ModelAndView memberCertify(@Validated MemberManageSO so, BindingResult bindingResult) {
    	ModelAndView mav = SiteUtil.getSkinView("/mypage/member_certify");

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
        DmallSessionDetails sessionInfo = SessionDetailHelper.getDetails();
        so.setMemberNo(sessionInfo.getSession().getMemberNo());
        so.setIntegrationMemberGbCd(sessionInfo.getSession().getIntegrationMemberGbCd());

        // 로그인여부 체크
        if (so.getMemberNo() == null || "".equals(so.getMemberNo())) {
            mav.addObject("exMsg", "로그인이 필요한 서비스 입니다.");
            mav.setViewName("/error/notice");
            return mav;
        }

        ResultModel<MemberManageVO> resultModel = frontMemberService.selectMember(so);

        mav.addObject("so", so);
        mav.addObject("resultModel", resultModel);
        mav.addObject("leftMenu", "member_certify");
        return mav;
    }
    
    /**
     * <pre>
     * 작성일 : 2019. 4. 24.
     * 작성자 : hskim
     * 설명   : 휴대폰인증 완료처리 
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2019. 4. 24. hskim - 최초생성
     * </pre>
     */
    @RequestMapping("/certify-update")
    public @ResponseBody ResultModel<MemberManagePO> updateCertify(@Validated(InsertGroup.class) MemberManagePO po,
            BindingResult bindingResult) throws Exception {
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }
        
        po.setMemberNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
        ResultModel<MemberManagePO> result = frontMemberService.updateCertify(po);

        SiteSO siteSo = new SiteSO();
        siteSo.setSiteNo(po.getSiteNo());
        ResultModel<SiteVO> siteInfo = siteInfoService.selectSiteInfo(siteSo);
    	
        SavedmnPointPO spp = new SavedmnPointPO();
        spp.setMemberNo(po.getRegrNo());
        spp.setGbCd("10");// 구분 코드(10:지급,20:차감)
        spp.setTypeCd("A");// 유형 코드(A:자동,M:수동)
        spp.setReasonCd("12");// 사유코드(휴대폰인증)
        spp.setPrcPoint(po.getCertifyPoint());// 포인트
        String nowday = DateUtil.getNowDate();
        String validPreridDate = DateUtil.addMonths(nowday, siteInfo.getData().getPointAccuValidPeriod());
        spp.setEtcValidPeriod(validPreridDate);// 마켓포인트 유효기간 코드(직접입력,제한없음,12월31일)
        spp.setPointUsePsbYn("Y");// 포인트 사용 가능 여부
        savedMnPointService.insertPoint(spp);
        
        return result;
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 9.
     * 작성자 : dong
     * 설명   : 메세지함(가맹점)
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 9. dong - 최초생성
     * </pre>
     * @throws Exception 
     */
    @RequestMapping("/push-message")
    public ModelAndView selectPushMessageList(@Validated MemberManageSO so, BindingResult bindingResult) throws Exception {
        ModelAndView mav = SiteUtil.getSkinView("/mypage/push_message");
        DmallSessionDetails sessionInfo = SessionDetailHelper.getDetails();

        // 로그인여부 체크
        if (!sessionInfo.isLogin()) {
            mav.addObject("exMsg", MessageUtil.getMessage("biz.exception.lng.loginRequired"));
            mav.setViewName("/error/notice");
            return mav;
        }


        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            return mav;
        }

        // default 기간검색(최근15일)
        if (StringUtil.isEmpty(so.getStAppDate()) || StringUtil.isEmpty(so.getEndAppDate())) {
            Calendar cal = new GregorianCalendar(Locale.KOREA);
            cal.add(Calendar.DAY_OF_YEAR, -15);
            SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
            String stRegDttm = df.format(cal.getTime());
            String endRegDttm = df.format(new Date());
            so.setStAppDate(stRegDttm);
            so.setEndAppDate(endRegDttm);
        }

        so.setSiteNo(sessionInfo.getSiteNo());
        so.setMemberCardNo(String.valueOf(sessionInfo.getSession().getMemberCardNo()));
        so.setMemberNo(sessionInfo.getSession().getMemberNo());
        
        // 안읽은 메세지수
        int newMarketPushCnt = frontMemberService.selectNewMarketPushCnt(so);
        int newStorePushCnt = frontMemberService.selectNewStorePushCnt(so);
        
        ResultListModel<MemberManageVO> resultListModel = frontMemberService.selectStorePushListPaging(so);
        
        if (resultListModel.getResultList() != null && resultListModel.getResultList().size() > 0) {
            for (int i = 0; i < resultListModel.getResultList().size(); i++) {
            	MemberManageVO tempVo = (MemberManageVO) resultListModel.getResultList().get(i);
            	String strCode = tempVo.getStrCode();
            	String strName = "";
            	if(strCode != null && !"".equals(strCode)) {
            		strName = frontMemberService.selectStrName(strCode);
            	}
            	tempVo.setStrName(strName);
            }
        }
        
        mav.addObject("resultListModel", resultListModel);
        mav.addObject("so", so);
        mav.addObject("leftMenu", "push_msg");
        mav.addObject("newMarketPushCnt", newMarketPushCnt);
        mav.addObject("newStorePushCnt", newStorePushCnt);

        return mav;
    }

    @RequestMapping(value = "/push-message-paging")
    public ModelAndView selectPushMessageListPaging(MemberManageSO so, BindingResult bindingResult) throws Exception {
        ModelAndView mav = SiteUtil.getSkinView("/mypage/push_message_paging");
        DmallSessionDetails sessionInfo = SessionDetailHelper.getDetails();

        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            return mav;
        }

        // default 기간검색(최근15일)
        if (StringUtil.isEmpty(so.getStAppDate()) || StringUtil.isEmpty(so.getEndAppDate())) {
            Calendar cal = new GregorianCalendar(Locale.KOREA);
            cal.add(Calendar.DAY_OF_YEAR, -15);
            SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
            String stRegDttm = df.format(cal.getTime());
            String endRegDttm = df.format(new Date());
            so.setStAppDate(stRegDttm);
            so.setEndAppDate(endRegDttm);
        }
        so.setSiteNo(sessionInfo.getSiteNo());
        so.setMemberCardNo(String.valueOf(sessionInfo.getSession().getMemberCardNo()));

        ResultListModel<MemberManageVO> resultListModel = frontMemberService.selectStorePushListPaging(so);

        if (resultListModel.getResultList() != null && resultListModel.getResultList().size() > 0) {
            for (int i = 0; i < resultListModel.getResultList().size(); i++) {
            	MemberManageVO tempVo = (MemberManageVO) resultListModel.getResultList().get(i);
            	String strCode = tempVo.getStrCode();
            	String strName = "";
            	if(strCode != null && !"".equals(strCode)) {
            		strName = frontMemberService.selectStrName(strCode);
            	}
            	tempVo.setStrName(strName);
            }
        }

        mav.addObject("resultListModel", resultListModel);
        mav.addObject("so", so);

        return mav;
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 9.
     * 작성자 : dong
     * 설명   : 메세지함
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 9. dong - 최초생성
     * </pre>
     */
    @RequestMapping("/push-message-market")
    public ModelAndView selectMarketPushMessageList(@Validated MemberManageSO so, BindingResult bindingResult) {
        ModelAndView mav = SiteUtil.getSkinView("/mypage/push_message_market");
        DmallSessionDetails sessionInfo = SessionDetailHelper.getDetails();

        // 로그인여부 체크
        if (!sessionInfo.isLogin()) {
            mav.addObject("exMsg", MessageUtil.getMessage("biz.exception.lng.loginRequired"));
            mav.setViewName("/error/notice");
            return mav;
        }


        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            return mav;
        }

        // default 기간검색(최근15일)
        if (StringUtil.isEmpty(so.getStAppDate()) || StringUtil.isEmpty(so.getEndAppDate())) {
            Calendar cal = new GregorianCalendar(Locale.KOREA);
            cal.add(Calendar.DAY_OF_YEAR, -15);
            SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
            String stRegDttm = df.format(cal.getTime());
            String endRegDttm = df.format(new Date());
            so.setStAppDate(stRegDttm);
            so.setEndAppDate(endRegDttm);
        }

        so.setSiteNo(sessionInfo.getSiteNo());
        so.setMemberNo(sessionInfo.getSession().getMemberNo());
        
        // 안읽은 메세지수
        int newMarketPushCnt = frontMemberService.selectNewMarketPushCnt(so);
        int newStorePushCnt = frontMemberService.selectNewStorePushCnt(so);

        ResultListModel<MemberManageVO> resultListModel = frontMemberService.selectMarketPushListPaging(so);
        mav.addObject("resultListModel", resultListModel);
        mav.addObject("so", so);
        mav.addObject("leftMenu", "push_msg_market");
        mav.addObject("newMarketPushCnt", newMarketPushCnt);
        mav.addObject("newStorePushCnt", newStorePushCnt);

        return mav;
    }

    @RequestMapping(value = "/push-message-market-paging")
    public ModelAndView selectMarketPushMessageListPaging(MemberManageSO so, BindingResult bindingResult) throws Exception {
        ModelAndView mav = SiteUtil.getSkinView("/mypage/push_message_market_paging");
        DmallSessionDetails sessionInfo = SessionDetailHelper.getDetails();

        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            return mav;
        }

        // default 기간검색(최근15일)
        if (StringUtil.isEmpty(so.getStAppDate()) || StringUtil.isEmpty(so.getEndAppDate())) {
            Calendar cal = new GregorianCalendar(Locale.KOREA);
            cal.add(Calendar.DAY_OF_YEAR, -15);
            SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
            String stRegDttm = df.format(cal.getTime());
            String endRegDttm = df.format(new Date());
            so.setStAppDate(stRegDttm);
            so.setEndAppDate(endRegDttm);
        }
        so.setSiteNo(sessionInfo.getSiteNo());
        so.setMemberNo(sessionInfo.getSession().getMemberNo());

        ResultListModel<MemberManageVO> resultListModel = frontMemberService.selectMarketPushListPaging(so);
        mav.addObject("resultListModel", resultListModel);
        mav.addObject("so", so);

        return mav;
    }
    
    /**
     * <pre>
     * 작성일 : 2019. 6. 25.
     * 작성자 : hskim
     * 설명   : 푸쉬메세지 읽음처리
     * -------------------------------------------------------------------------
     * </pre>
     */
    @RequestMapping("/push-message-confirm")
    public @ResponseBody ResultModel<MemberManageVO> insertPushMessageConfirm(MemberManagePO po, BindingResult bindingResult,
            HttpServletRequest request) throws Exception {
    	if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }
    	po.setLoginId(SessionDetailHelper.getDetails().getSession().getLoginId());
        po.setMemberNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
        ResultModel<MemberManageVO> result = frontMemberService.insertPushMessageConfirm(po);
        return result;
    }


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
    @RequestMapping(value = "/bibiem-warranty-list")
    public ModelAndView selectBibiemWarrantyList(@Validated MemberManageSO so, BindingResult bindingResult) throws Exception {

        ModelAndView mav = SiteUtil.getSkinView("/mypage/bibiem_warranty_list");

        // 로그인여부 체크
        if(!SessionDetailHelper.getDetails().isLogin()) {
            mav.addObject("exMsg", MessageUtil.getMessage("biz.exception.lng.loginRequired"));
            mav.setViewName("/error/notice");
            return mav;
        }

        if(bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            return mav;
        }

        so.setMemberNo(SessionDetailHelper.getDetails().getSession().getMemberNo());

        mav.addObject("leftMenu", "bibiem_warranty");
        mav.addObject("so", so);
        mav.addObject("resultListModel", frontMemberService.selectBibiemWarrantyList(so));
        return mav;
    }

    @RequestMapping("/bibiem-warranty-list-paging")
    public ModelAndView couponListPaging(@Validated MemberManageSO so, BindingResult bindingResult) {

    	ModelAndView mav = SiteUtil.getSkinView("/mypage/bibiem_warranty_list_paging");

        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            return mav;
        }

        so.setMemberNo(SessionDetailHelper.getDetails().getSession().getMemberNo());

        mav.addObject("leftMenu", "bibiem_warranty");
        mav.addObject("so", so);
        mav.addObject("resultListModel", frontMemberService.selectBibiemWarrantyList(so));

        return mav;
    }
}