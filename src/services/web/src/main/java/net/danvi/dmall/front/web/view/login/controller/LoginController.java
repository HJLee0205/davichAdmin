package net.danvi.dmall.front.web.view.login.controller;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.URL;
import java.net.URLConnection;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.JSONException;
import org.json.JSONObject;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.fasterxml.jackson.core.JsonProcessingException;

import dmall.framework.common.constants.CommonConstants;
import dmall.framework.common.exception.CustomException;
import dmall.framework.common.exception.JsonValidationException;
import dmall.framework.common.model.ResultListModel;
import dmall.framework.common.model.ResultModel;
import dmall.framework.common.util.CookieUtil;
import dmall.framework.common.util.CryptoUtil;
import dmall.framework.common.util.HttpUtil;
import dmall.framework.common.util.SiteUtil;
import dmall.framework.common.util.TempKey;
import lombok.extern.slf4j.Slf4j;
import net.danvi.dmall.biz.app.member.manage.model.MemberManagePO;
import net.danvi.dmall.biz.app.member.manage.model.MemberManageSO;
import net.danvi.dmall.biz.app.member.manage.model.MemberManageVO;
import net.danvi.dmall.biz.app.member.manage.service.FrontMemberService;
import net.danvi.dmall.biz.app.operation.model.EmailSendSO;
import net.danvi.dmall.biz.app.operation.model.ReplaceCdVO;
import net.danvi.dmall.biz.app.operation.model.SmsSendPO;
import net.danvi.dmall.biz.app.operation.service.EmailSendService;
import net.danvi.dmall.biz.app.operation.service.SmsSendService;
import net.danvi.dmall.biz.app.promotion.coupon.model.CouponPO;
import net.danvi.dmall.biz.app.promotion.coupon.model.CouponSO;
import net.danvi.dmall.biz.app.promotion.coupon.model.CouponVO;
import net.danvi.dmall.biz.app.promotion.coupon.service.CouponService;
import net.danvi.dmall.biz.app.setup.personcertify.model.PersonCertifyConfigVO;
import net.danvi.dmall.biz.app.setup.personcertify.service.PersonCertifyConfigService;
import net.danvi.dmall.biz.app.setup.siteinfo.model.SiteSO;
import net.danvi.dmall.biz.app.setup.siteinfo.model.SiteVO;
import net.danvi.dmall.biz.app.setup.siteinfo.service.SiteInfoService;
import net.danvi.dmall.biz.app.setup.snsoutside.model.SnsConfigSO;
import net.danvi.dmall.biz.app.setup.snsoutside.model.SnsConfigVO;
import net.danvi.dmall.biz.app.setup.snsoutside.service.SnsOutsideLinkService;
import net.danvi.dmall.biz.system.login.model.MemberLoginHistPO;
import net.danvi.dmall.biz.system.login.service.LoginService;
import net.danvi.dmall.biz.system.model.AppLogPO;
import net.danvi.dmall.biz.system.model.LoginVO;
import net.danvi.dmall.biz.system.model.SiteCacheVO;
import net.danvi.dmall.biz.system.security.DmallSessionDetails;
import net.danvi.dmall.biz.system.security.Session;
import net.danvi.dmall.biz.system.security.SessionDetailHelper;
import net.danvi.dmall.biz.system.service.SiteService;
import net.danvi.dmall.biz.system.util.JsonMapperUtil;
import net.danvi.dmall.core.constants.IdentifyConstants;
import net.danvi.dmall.core.model.identity.ipin.IpinVO;
import net.danvi.dmall.core.model.identity.mobile.DreamVO;
import net.danvi.dmall.front.web.config.view.View;

/**
 * <pre>
 * - 프로젝트명	: 31.front.web
 * - 패키지명	: front.web.view.login.controller
 * - 파일명		: LoginController.java
 * - 작성일		: 2016. 3. 2.
 * - 작성자		: snw
 * - 설명		: 로그인 Controller
 * </pre>
 */
@Slf4j
@Controller
@RequestMapping("/front/login")
public class LoginController {

    @Resource(name = "frontMemberService")
    private FrontMemberService frontMemberService;

    @Resource(name = "loginService")
    private LoginService loginService;

    @Resource(name = "siteService")
    private SiteService siteService;

    @Resource(name = "snsOutsideLinkService")
    private SnsOutsideLinkService snsOutsideLinkService;

    @Resource(name = "personCertifyConfigService")
    private PersonCertifyConfigService personCertifyConfigService;

    @Resource(name = "couponService")
    private CouponService couponService;

    @Resource(name = "emailSendService")
    private EmailSendService emailSendService;

    @Resource(name = "siteInfoService")
    private SiteInfoService siteInfoService;
    
    @Resource(name = "smsSendService")
    private SmsSendService smsSendService;

    private String returnUrl;

    public void setReturnUrl(String returnUrl) {
        this.returnUrl = returnUrl;
    }

    /**
     * <pre>
     * - 프로젝트명	: 31.front.web
     * - 파일명		: LoginController.java
     * - 작성일		: 2016. 3. 2.
     * - 작성자		: snw
     * - 설명		: 로그인 페이지 화면
     * </pre>
     *
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/member-login")
    public ModelAndView indexLogin(HttpServletRequest request, HttpServletResponse response) throws Exception {
        ModelAndView mav = SiteUtil.getSkinView("login/login");
        Map<String, String> snsMap = new HashMap<>();
        ResultListModel<SnsConfigVO> resultListModel = new ResultListModel<>();
        resultListModel = snsOutsideLinkService.selectSnsConfigList(SessionDetailHelper.getDetails().getSiteNo());
        List<SnsConfigVO> list = resultListModel.getResultList();
        if (list != null && list.size() > 0) {
            for (SnsConfigVO vo : list) {
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
        mav.addObject("snsMap", snsMap);

        // 주문관련 처리
        String[] itemArr = request.getParameterValues("itemArr");
        if (itemArr != null) {
            mav.addObject("itemArr", itemArr);
            mav.addObject("orderYn", "Y");
        }else {
            String referer = request.getHeader("referer");

            if(referer!=null && referer.indexOf("vision") > 0) {
                // 렌즈추천 검사결과 데이터 랜딩
                Enumeration<?> paramNames = request.getParameterNames();
                Map<String, String> paramMap = new HashMap<String, String>();
                while (paramNames.hasMoreElements()) {
                    String name = paramNames.nextElement().toString();
                    String value = request.getParameter(name);
                    paramMap.put(name, value);
                }
                if (paramMap != null && !paramMap.isEmpty()) {
                    mav.addObject("visionMap", paramMap);
                    mav.addObject("visionYn", "Y");
                }
            }
        }

        return mav;
    }
    
    
    /**
     * <pre>
     * - 프로젝트명	: 31.front.web
     * - 파일명		: LoginController.java
     * - 작성일		: 2016. 3. 2.
     * - 작성자		: snw
     * - 설명		: 로그인 페이지 화면
     * </pre>
     *
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/app-member-login")
    public ModelAndView indexLoginApp(HttpServletRequest request, HttpServletResponse response) throws Exception {
        ModelAndView mav = SiteUtil.getSkinView("login/app_login_test");
        Map<String, String> snsMap = new HashMap<>();
        ResultListModel<SnsConfigVO> resultListModel = new ResultListModel<>();
        resultListModel = snsOutsideLinkService.selectSnsConfigList(SessionDetailHelper.getDetails().getSiteNo());
        List<SnsConfigVO> list = resultListModel.getResultList();
        if (list != null && list.size() > 0) {
            for (SnsConfigVO vo : list) {
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
        mav.addObject("snsMap", snsMap);

        // 주문관련 처리
        String[] itemArr = request.getParameterValues("itemArr");
        if (itemArr != null) {
            mav.addObject("itemArr", itemArr);
            mav.addObject("orderYn", "Y");
        }

        return mav;
    }    

    /**
     * <pre>
     * 작성일 : 2016. 5. 17.
     * 작성자 : dong
     * 설명   : 로그인 페이지 팝업 화면
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 17. dong - 최초생성
     * </pre>
     *
     * @param request
     * @param response
     * @return
     * @throws Exception
     */
    // @RequestMapping(value = "/member-login-pop")
    // public ModelAndView indexLoginPop(HttpServletRequest request,
    // HttpServletResponse response) throws Exception {
    // ModelAndView mav = new ModelAndView("login/login");
    // return mav;
    // }

    /**
     * <pre>
     * 작성일 : 2016. 6. 8.
     * 작성자 : dong
     * 설명   : 아이디/비밀번호 찾기 페이지(view)
     * -------------------------------------------------------------------------
     * </pre>
     */
    @RequestMapping(value = "/account-search")
    public ModelAndView accountSearch(MemberManageSO so) throws Exception {
        ModelAndView mv = SiteUtil.getSkinView("/login/account_search");

        // 사이트에 설정된 인증 수단 조회(PRSN_CHECK_CERTIFY 테이블)
        List<PersonCertifyConfigVO> list = personCertifyConfigService.selectPersonCertifyConfigList(so.getSiteNo());
        boolean ioFlag = personCertifyConfigService.ipinAuthFlag(list, "find");
        boolean moFlag = personCertifyConfigService.mobileAuthFlag(list, "find");

        PersonCertifyConfigVO vo = new PersonCertifyConfigVO();
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
            mv.addObject("mo", IdentifyConstants.createDreamSecret(dreamVO));
        }

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
            mv.addObject("io", IdentifyConstants.createIpin(ipinVO));
        }
        // 조회 set
        mv.addObject("mode", so.getMode());
        mv.addObject("so", so);
        return mv;
    }

    /**
     * <pre>
     * 작성일 : 2016. 6. 8.
     * 작성자 : dong
     * 설명   : 이메일계정/IPIN/모바일일 값으로 회원정보 조회
     * -------------------------------------------------------------------------
     * </pre>
     */
    @RequestMapping("/account-detail")
    public @ResponseBody List<MemberManageVO> selectAccountEmail(@Validated MemberManageSO so,
                                                                        BindingResult bindingResult) throws Exception {
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }
        
        List<MemberManageVO> list = frontMemberService.selectMemeberId(so);
        
        return list;
    }

    /**
     * <pre>
     * 작성일 : 2016. 6. 8.
     * 작성자 : dong
     * 설명   : 휴면회원 계정 정보 조회
     * -------------------------------------------------------------------------
     * </pre>
     */
    @RequestMapping("/inactive-member-detail")
    public @ResponseBody List<MemberManageVO> selectInactiveMember(@Validated MemberManageSO so,
                                                                        BindingResult bindingResult) throws Exception {
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }

        List<MemberManageVO> list = frontMemberService.selectInactiveMember(so);

        return list;
    }

    /**
     * <pre>
     * 작성일 : 2016. 6. 8.
     * 작성자 : dong
     * 설명   : 비밀번호 변경
     * -------------------------------------------------------------------------
     * </pre>
     */
    @RequestMapping(value = "/update-password")
    public @ResponseBody ResultModel<MemberManagePO> updatePwd(@Validated MemberManagePO po,
                                                               BindingResult bindingResult) throws Exception {
        ResultModel<MemberManagePO> resultModel = new ResultModel<>();
        // DB입력시 암호화처리
        String newPw = CryptoUtil.encryptSHA512(po.getNewPw());
        po.setPw(po.getNewPw());

        // 기존등록된 비밀번호 조회(기존비밀번호는 등록불가)
        MemberManageSO so = new MemberManageSO();
        DmallSessionDetails sessionInfo = SessionDetailHelper.getDetails();
        so.setMemberNo(po.getMemberNo());
        so.setSiteNo(sessionInfo.getSiteNo());
        ResultModel<MemberManageVO> mmv = frontMemberService.selectMember(so);
        log.debug("-----------------------------------------------------");
        log.debug("입력받은 신규비밀번호 : " + newPw);
        log.debug("DB조회한 기존 비밀번호 : " + mmv.getData().getPw());
        log.debug("-----------------------------------------------------");
        if (newPw.equals(mmv.getData().getPw())) {// 비밀번호 검증
            resultModel.setSuccess(false);
            resultModel.setMessage("기존 비밀번호로는 변경하실수 없습니다.");
        } else {
            resultModel = frontMemberService.updatePwd(po);
        }
        return resultModel;
    }

    /**
     * <pre>
     * 작성일 : 2016. 6. 8.
     * 작성자 : dong
     * 설명   : 휴면회원일 경우 이동
     * -------------------------------------------------------------------------
     * </pre>
     */
    @RequestMapping(value = "/inactive-member-view")
    public ModelAndView viewInactive(HttpServletRequest request) throws Exception {
        String inactiveLoginId = request.getParameter("inactiveLoginId");
        // 사이트 정보
        SiteCacheVO siteCacheVO = siteService.getSiteInfo(SessionDetailHelper.getDetails().getSiteNo());
        String url = "";
        if ("1".equals(siteCacheVO.getDormantMemberCancelMethod())) { // 휴면회원 해제방법이 로그인 해제(1)라면
            url = "/login/viewInactiveLogin";
        } else if ("2".equals(siteCacheVO.getDormantMemberCancelMethod())) { // 휴면회원 해제방법이 본인인증후 해제(2)라면
            url = "/login/viewInactive";
        }

        ModelAndView mv = SiteUtil.getSkinView(url);
        DmallSessionDetails sessionInfo = SessionDetailHelper.getDetails();
        // 본인인증서비스 여부확인
        List<PersonCertifyConfigVO> list = personCertifyConfigService.selectPersonCertifyConfigList(SessionDetailHelper.getDetails().getSiteNo());
        boolean ioFlag = personCertifyConfigService.ipinAuthFlag(list, "drmt");
        boolean moFlag = personCertifyConfigService.mobileAuthFlag(list, "drmt");

        if ("1".equals(siteCacheVO.getDormantMemberCancelMethod())) { // 휴면회원 해제방법이 로그인 해제(1)라면
            mv.addObject("loginId", inactiveLoginId);
        }else{
            mv.addObject("loginId", inactiveLoginId);
        }

        MemberManageSO so = new MemberManageSO();
        so.setSearchLoginId(inactiveLoginId);
        so.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
        List<MemberManageVO> inactiveMemlist = frontMemberService.selectInactiveMemberById(so);

        mv.addObject("memberNo", inactiveMemlist.get(0).getMemberNo()); //회원번호
        mv.addObject("email", inactiveMemlist.get(0).getEmail()); //가입된 이메일 주소
        mv.addObject("mobile", inactiveMemlist.get(0).getMobile()); //가입된 휴대폰 번호


        if (ioFlag || moFlag) { // 본인인증 모듈 사용, (아이핀/휴대폰 둘중에 하나라도 사용한다면)
            if ("2".equals(siteCacheVO.getDormantMemberCancelMethod())) { // 휴면회원 해제방법이 본인인증후 해제(2)라면
                PersonCertifyConfigVO vo = new PersonCertifyConfigVO();
                // ipin set
                if (ioFlag) {
                   /* IpinVO ipinVO = new IpinVO();
                    vo.setSiteNo(sessionInfo.getSiteNo());
                    vo.setCertifyTypeCd("01");
                    ResultModel<PersonCertifyConfigVO> result = personCertifyConfigService
                            .selectPersonCertifyConfig(vo);
                    ipinVO.setSiteNo(sessionInfo.getSiteNo());
                    ipinVO.setSiteCd(result.getData().getSiteCd());
                    ipinVO.setSitePw(result.getData().getSitePw());
                    ipinVO.setServerName(SessionDetailHelper.getSession().getServerName());
                    ipinVO.setReturnUrl("/front/login/ipin-result-return");

                    mv.addObject("io", IdentifyConstants.createIpin(ipinVO));*/
                }

                // mobile인증 setting
                if (moFlag) {
                    /*DreamVO dreamVO = new DreamVO();
                    vo.setSiteNo(sessionInfo.getSiteNo());
                    vo.setCertifyTypeCd("02");
                    ResultModel<PersonCertifyConfigVO> result = personCertifyConfigService
                            .selectPersonCertifyConfig(vo);
                    dreamVO.setSiteNo(sessionInfo.getSiteNo());
                    dreamVO.setSiteCd(result.getData().getSiteCd());
                    dreamVO.setSitePw(result.getData().getSitePw());
                    dreamVO.setReturnUrl("/front/login/mobile-result-return");
                    dreamVO.setServerName(SessionDetailHelper.getSession().getServerName());
                    mv.addObject("mo", IdentifyConstants.createDreamSecret(dreamVO));*/
                }
            }
        }
        return mv;
    }

    @RequestMapping(value = "/account-active-init")
    public @ResponseBody ResultModel doActive(MemberManagePO po) throws Exception {
        ResultModel resultModel = loginService.checkEmailCertify(po);
        return resultModel;
    }

    @RequestMapping(value = "/change-password-step1")
    public ModelAndView viewChangePwStep1(HttpServletRequest request) throws Exception {
        ModelAndView mv = SiteUtil.getSkinView("/login/viewChangePwStep1");
        SiteCacheVO siteCacheVO = siteService.getSiteInfo(SessionDetailHelper.getDetails().getSiteNo());
        mv.addObject("siteInfo", siteCacheVO);
        return mv;
    }

    @RequestMapping(value = "/password-nextchange-update")
    public @ResponseBody ResultModel<MemberManageVO> setChangePwNext(MemberManagePO po, HttpServletRequest request, HttpServletResponse response) throws Exception {
        ResultModel<MemberManageVO> resultModel = new ResultModel<>();
        resultModel= loginService.updateChangePwNext(po);

        return resultModel;
    }

    @RequestMapping(value = "/change-password-step2")
    public ModelAndView viewChangePwStep2(HttpServletRequest request) throws Exception {
        ModelAndView mav = SiteUtil.getSkinView("/login/viewChangePwStep2");
        return mav;
    }

    @RequestMapping(value = "/password-update")
    public @ResponseBody ResultModel updatePassword(MemberManagePO po) throws Exception {
        ResultModel resultModel = frontMemberService.updatePwd(po);
        return resultModel;
    }

    // mobile result-return
    @RequestMapping(value = "/mobile-result-return")
    public ModelAndView return_mobile(HttpServletRequest request) throws Exception {
        ModelAndView mv = new ModelAndView("/login/return_mobile");
        PersonCertifyConfigVO vo = new PersonCertifyConfigVO();
        DreamVO dreamVO = new DreamVO();
        Session session = SessionDetailHelper.getSession();
        vo.setSiteNo(session.getSiteNo());
        vo.setCertifyTypeCd("02");
        ResultModel<PersonCertifyConfigVO> result = personCertifyConfigService.selectPersonCertifyConfig(vo);
        dreamVO.setSiteNo(session.getSiteNo());
        dreamVO.setSiteCd(result.getData().getSiteCd());
        dreamVO.setSitePw(result.getData().getSitePw());
        dreamVO.setPriInfo(request.getParameter("priinfo"));
        dreamVO.setServerName(SessionDetailHelper.getSession().getServerName());
        mv.addObject("mo", IdentifyConstants.returnMobile(dreamVO));

        return mv;
    }

    // ipin result-return
    @RequestMapping(value = "/ipin-result-return")
    public ModelAndView return_ipin(HttpServletRequest request) throws Exception {
        ModelAndView mv = new ModelAndView("/login/return_ipin");
        PersonCertifyConfigVO vo = new PersonCertifyConfigVO();
        IpinVO ipinVO = new IpinVO();
        Session session = SessionDetailHelper.getSession();
        vo.setSiteNo(session.getSiteNo());
        vo.setCertifyTypeCd("01");
        ResultModel<PersonCertifyConfigVO> result = personCertifyConfigService.selectPersonCertifyConfig(vo);
        ipinVO.setSiteNo(session.getSiteNo());
        ipinVO.setSiteCd(result.getData().getSiteCd());
        ipinVO.setSitePw(result.getData().getSitePw());
        ipinVO.setEncData(request.getParameter("enc_data"));
        ipinVO.setServerName(SessionDetailHelper.getSession().getServerName());
        IpinVO io = IdentifyConstants.returnIpin(ipinVO);
        log.debug("io.getDupInfo() : " + io.getDupInfo());
        mv.addObject("io", io);
        return mv;
    }

    @RequestMapping(value = "/sns-addinfo-pop")
    public String pop_sns(HttpServletRequest request, HttpServletResponse response) throws Exception {
        return "login/pop_sns";
    }

    /**
     * <pre>
     * 작성일 : 2016. 6. 30.
     * 작성자 : dong
     * 설명   : 소셜 로그인 - 회원가입, 로그인 처리
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 30. dong - 최초생성
     * </pre>
     *
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/sns-login")
    public @ResponseBody ResultModel<LoginVO> snsLogin(MemberManagePO po, HttpServletRequest request,
            HttpServletResponse response, Authentication authentication) throws Exception {
        ResultModel<LoginVO> resultModel = new ResultModel<>();

        // 01.사용자 정보 조회
        String name = "";
        String email = "";
        String id = "";
        String path = request.getParameter("path");
        String token = request.getParameter("accessToken");

        if ("FB".equals(path)) { // 페이스북
            String graph = getFBGraph(token);
            Map facebookMap = this.getGraphData(graph);
            name = (String) facebookMap.get("name");
            email = (String) facebookMap.get("email");
            id = (String) facebookMap.get("id");
        } else if ("KT".equals(path)) { // 카카오톡
            String kapi = getKtUserInfo(token);
            Map kakaoMap = this.getKapiData(kapi);
            name = (String) kakaoMap.get("name");
            email = "";
            id = Long.toString((Long) kakaoMap.get("id"));
        } else if ("NV".equals(path)) { // 네이버
            String api = getNaverUserInfo(token);
            Map naverMap = this.getNaverData(api);
            name = (String) naverMap.get("name");
            email = (String) naverMap.get("email");
            id = (String) naverMap.get("id");
        }

        if (id == null || "".equals(id)) {
            throw new Exception("SNS Login fail");
        }

        // 02.회원 가입 처리
        id = path.toLowerCase() + "_" + id;
        LoginVO vo = new LoginVO();
        vo.setLoginId(id);
        vo.setSiteNo(po.getSiteNo());
        LoginVO user = loginService.getUser(vo);
        if (user == null) {
            po.setLoginId(id);
            po.setMemberNm(name);
            po.setEmail(email);
            po.setJoinPathCd(path);
            po.setMemberGradeNo("1");
            po.setMemberGbCd("10");// 회원구분(국내/해외)
            po.setMemberStatusCd("01");// 회원상태코드
            po.setIntegrationMemberGbCd("02");//통합 회원 구분 코드
            po.setRealnmCertifyYn("N");
            po.setMemberTypeCd("01"); //회원유형코드 (개인,사업자)
            // 변경안내 주기 날짜
            Calendar cal = Calendar.getInstance(Locale.KOREA);
            SiteCacheVO siteCacheVO = siteService.getSiteInfo(po.getSiteNo());
            if (siteCacheVO.getPwChgGuideCycle() != null) {
                cal.add(Calendar.MONTH, +siteCacheVO.getPwChgGuideCycle());
                po.setNextPwChgScdDttm(cal.getTime());
            }
            ResultModel<MemberManagePO> memberManagePO = frontMemberService.insertMember(po);
            if(memberManagePO.getData() == null) {
            	resultModel.setSuccess(false);
            	//resultModel.setMessage("사용할 수 없는 계정입니다.");
            	resultModel.setExtraString(id);
            	return resultModel;
            }
            vo.setLoginId(CryptoUtil.decryptAES(vo.getLoginId()));
            user = loginService.getUser(vo);
            if(user!=null) {
                user.setFirstJoinYn("Y");
            }

            // 쿠폰발급
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
        } else {
            user.setFirstJoinYn("N");
        }
        resultModel.setData(user);

        // 03.로그인 처리
        List<SimpleGrantedAuthority> authorities = new ArrayList<>();
        authorities.add(new SimpleGrantedAuthority("ROLE_USER"));
        Session session = new Session(user);
        session.setLastAccessDate(Calendar.getInstance().getTime());

        UsernamePasswordAuthenticationToken result = new UsernamePasswordAuthenticationToken(name, "", authorities);

        try {
            result.setDetails(new DmallSessionDetails(name, "", session, authorities));
        } catch (Exception e) {
            log.error("로그인 오류", e.getMessage());
        }

        DmallSessionDetails details = (DmallSessionDetails) result.getDetails();
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
     *
     * <pre>
     * 작성일 : 2016. 7. 1.
     * 작성자 : dong
     * 설명 : 페이스북 그래프 API 조회
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     */
    public String getFBGraph(String accessToken) {
        String graph = null;
        BufferedReader in = null;
        try {

            String g = "https://graph.facebook.com/me?access_token=" + accessToken + "&fields=email,name,id&locale=ko.KR";
            URL u = new URL(g);
            URLConnection c = u.openConnection();
            in = new BufferedReader(new InputStreamReader(c.getInputStream()));
            String inputLine;
            StringBuffer b = new StringBuffer();
            while ((inputLine = in.readLine()) != null)
                b.append(inputLine + "\n");
            graph = b.toString();
        } catch (Exception e) {
            throw new RuntimeException("ERROR in getting FB graph data[1]. " + e);
        } finally {
            if (in != null) {
                try {
                    in.close();
                } catch (Exception e) {
                    throw new RuntimeException("ERROR in getting FB graph data[2]. " + e);
                }
            }
        }
        return graph;
    }

    /**
     *
     * <pre>
     * 작성일 : 2016. 7. 1.
     * 작성자 : dong
     * 설명 : 페이스북 사용자 데이터 조회
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     */
    public Map getGraphData(String fbGraph) {
        Map fbProfile = new HashMap();
        try {
            JSONObject json = new JSONObject(fbGraph);
            log.debug(" === json : {}", json.toString());
            fbProfile.put("id", json.getString("id"));
            fbProfile.put("name", json.getString("name"));
            if(json.has("email") && !json.isNull("email"))
                fbProfile.put("email", json.getString("email"));
            else
                fbProfile.put("email", "");

        } catch (JSONException e) {
            throw new RuntimeException("ERROR in parsing FB graph data. " + e);
        }
        return fbProfile;
    }

    /**
     *
     * <pre>
     * 작성일 : 2016. 7. 1.
     * 작성자 : dong
     * 설명 : 카카오톡 사용자 정보 조회
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     */
    public String getKtUserInfo(String accessToken) {
        String kapi = null;
        BufferedReader in = null;
        try {
            String apiRequestUrl = "https://kapi.kakao.com/v2/user/me?access_token=" + accessToken;

            URL u = new URL(apiRequestUrl);
            URLConnection c = u.openConnection();
            in = new BufferedReader(new InputStreamReader(c.getInputStream(),"UTF-8"));
            String inputLine;
            StringBuffer b = new StringBuffer();
            while ((inputLine = in.readLine()) != null)
                b.append(inputLine + "\n");
            kapi = b.toString();

        } catch (Exception e) {
            log.error(" === exception : {}", e.getMessage());
            throw new RuntimeException("ERROR in getting KAKAO user data[1]. " + e.getMessage());
        } finally {
            if (in != null) {
                try {
                    in.close();
                } catch (Exception e) {
                    throw new RuntimeException("ERROR in getting KAKAO user data[2]. " + e.getMessage());
                }
            }
        }
        return kapi;
    }

    /**
     *
     * <pre>
     * 작성일 : 2016. 7. 1.
     * 작성자 : dong
     * 설명 : 카카오톡 사용자 데이터 조회
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     */
    public Map getKapiData(String kapi) {
        Map fbProfile = new HashMap();
        try {
            JSONObject json = new JSONObject(kapi);
            log.debug(" === json : {}", json.toString());
            fbProfile.put("id", json.get("id"));
            JSONObject properties = json.getJSONObject("properties");
            fbProfile.put("name", properties.getString("nickname"));
        } catch (JSONException e) {
            throw new RuntimeException("ERROR in parsing FB graph data. " + e);
        }
        return fbProfile;
    }

    /**
     *
     * <pre>
     * 작성일 : 2016. 7. 1.
     * 작성자 : dong
     * 설명 : 네이버 사용자 정보 조회
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     */
    public String getNaverUserInfo(String accessToken) {
        String api = null;
        BufferedReader in = null;
        try {
            String apiRequestUrl = "https://openapi.naver.com/v1/nid/me";
            URL u = new URL(apiRequestUrl);
            URLConnection c = u.openConnection();
            accessToken = accessToken.replaceAll("\r", "").replaceAll("\n", "");
            c.setRequestProperty("Authorization", "Bearer " + accessToken);
            in = new BufferedReader(new InputStreamReader(c.getInputStream()));
            String inputLine;
            StringBuffer b = new StringBuffer();
            while ((inputLine = in.readLine()) != null)
                b.append(inputLine + "\n");
            api = b.toString();
        } catch (Exception e) {
            throw new RuntimeException("ERROR in getting Naver user data[1]. " + e);
        } finally {
            if (in != null) {
                try {
                    in.close();
                } catch (Exception e) {
                    throw new RuntimeException("ERROR in getting Naver user data[2]. " + e);
                }
            }
        }
        return api;
    }

    /**
     *
     * <pre>
     * 작성일 : 2016. 7. 1.
     * 작성자 : dong
     * 설명 : 네이버 사용자 데이터 조회
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     */
    public Map getNaverData(String api) {
        Map profile = new HashMap();
        try {
            JSONObject json = new JSONObject(api);
            log.debug(" === json : {}", json.toString());
            JSONObject response = json.getJSONObject("response");
            profile.put("id", response.get("id"));
            if(response.has("name") && !response.isNull("name")) {
            	profile.put("name", response.get("name"));
            }else {
            	if(response.has("nickname") && !response.isNull("nickname")) {
                	profile.put("name", response.get("nickname"));
                }else {
                	profile.put("name", response.get("id"));
                }
            }
            if(response.has("email") && !response.isNull("email")) {
            	profile.put("email", response.get("email"));
            }else {
            	profile.put("email", "");
            }
        } catch (JSONException e) {
            throw new RuntimeException("ERROR in parsing NAVER data. " + e);
        }
        return profile;
    }

    /**
     * <pre>
     * 작성일 : 2016. 6. 30.
     * 작성자 : dong
     * 설명   : 네이버 로그인 리턴 페이지
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 30. dong - 최초생성
     * </pre>
     *
     * @return
     */
    @RequestMapping(value = "/naver-login-return")
    public ModelAndView naverLogin() {
        ModelAndView mav = new ModelAndView("/login/naver_return");
        Map<String, String> snsMap = new HashMap<>();
        ResultModel<SnsConfigVO> resultModel = new ResultModel<>();
        SnsConfigSO so = new SnsConfigSO();
        so.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
        so.setOutsideLinkCd("02"); // 네이버
        resultModel = snsOutsideLinkService.selectSnsConfig(so);

        mav.addObject("snsConfig", resultModel);
        return mav;
    }

    protected int getCookieExpireTime(Long siteNo) throws Exception {
        SiteCacheVO vo = siteService.getSiteInfo(siteNo);

        if (vo.getAutoLogoutTime() == 0) {
            return 365 * 24 * 60 * 60;
        } else {
            return vo.getAutoLogoutTime() * 60;
        }
    }

    @RequestMapping(value = "/send-email")
    public @ResponseBody ResultModel sendEmail(MemberManagePO po) throws Exception {
        String key = new TempKey().getKey(6, false); // 인증키 생성
        po.setEmailCertifyValue(key);
        ResultModel resultModel = loginService.createAuthKey(po); // 인증키 DB저장
        // 사이트정보 조회
        SiteSO siteSo = new SiteSO();
        siteSo.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
        ResultModel<SiteVO> siteInfo = siteInfoService.selectSiteInfo(siteSo);

        if(po.getSearchMethod() != null && "mobile".equals(po.getSearchMethod())){
        	
        	List<SmsSendPO> listpo = new ArrayList<SmsSendPO>();
        	SmsSendPO smsSendPO = new SmsSendPO();

            if (siteInfo.getData().getCertifySendNo() == null || ("").equals(siteInfo.getData().getCertifySendNo())) {
                throw new CustomException("biz.exception.operation.certifySendNoNull", new Object[] { "코드그룹" });
            } else {
            	smsSendPO.setSendTelno(siteInfo.getData().getCertifySendNo());
            }

            smsSendPO.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
            String sendWords = "다비치마켓 비밀번호 재설정을 위한 인증절차입니다.\r\n" + 
            		"\r\n" + 
            		"다비치마켓 비밀번호 찾기 화면에 아래의 인증코드를 입력하신 후\r\n" + 
            		"\r\n" + 
            		"새로운 비밀번호를 설정해 주세요.";
            smsSendPO.setSendWords(sendWords + "\r\n\r\n인증코드 : " + key);
            smsSendPO.setSendTargetCd("01");
            // sms, 장문
            smsSendPO.setSendFrmCd("02");
            smsSendPO.setPossCnt(null);
            smsSendPO.setAutoSendYn("N");
            
            smsSendPO.setRegrNo((long) 9999);
            smsSendPO.setSenderNo((long) 9999);
            smsSendPO.setSenderId("admin1");
            smsSendPO.setSenderNm("관리자");

            smsSendPO.setReceiverNo(String.valueOf(po.getMemberNo()));
            smsSendPO.setReceiverNm(CryptoUtil.decryptAES(po.getMemberNm()));
            smsSendPO.setReceiverId(CryptoUtil.decryptAES(po.getLoginId()));
            smsSendPO.setRecvTelNo(CryptoUtil.decryptAES(po.getMobile()));
            smsSendPO.setSendTelno(siteInfo.getData().getCertifySendNo());
            smsSendPO.setFdestine(CryptoUtil.decryptAES(po.getMobile()));
            smsSendPO.setFcallback(siteInfo.getData().getCertifySendNo().replaceAll("-", ""));
           
            listpo.add(smsSendPO);
            
            smsSendService.sendSms(listpo);
        }else{
        	// 비밀번호 찾기 인증코드 이메일 발송(EmailSendSO so, ReplaceCdVO replaceVO)
	        EmailSendSO emailSendSo = new EmailSendSO();
	        emailSendSo.setMailTypeCd("26"); //  메일 유형 코드
	        emailSendSo.setReceiverEmail(po.getEmail());
	        emailSendSo.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
	        emailSendSo.setReceiverNo(0);
	        emailSendSo.setMemberNo(0);
	
	        /* 변경할 치환 코드 설정 */
	        ReplaceCdVO emailReplaceVO = new ReplaceCdVO();
	        emailReplaceVO.setDlgtDomain(SiteUtil.getExternalDomain(siteInfo.getData().getDlgtDomain()));
	        emailReplaceVO.setEmailCertifyValue(key);
	
//	        emailSendService.emailAutoSend(emailSendSo, emailReplaceVO);
        }
        return resultModel;
    }

    @RequestMapping(value = "/send-cetifyvalue")
    public @ResponseBody ResultModel sendCetifyvalue(MemberManagePO po) throws Exception {
        String key = new TempKey().getKey(6, false); // 인증키 생성
        po.setEmailCertifyValue(key);
        ResultModel resultModel = loginService.createAuthKey(po); // 인증키 DB저장
        // 사이트정보 조회
        SiteSO siteSo = new SiteSO();
        siteSo.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
        ResultModel<SiteVO> siteInfo = siteInfoService.selectSiteInfo(siteSo);

        if(po.getSearchMethod() != null && "mobile".equals(po.getSearchMethod())){

        	List<SmsSendPO> listpo = new ArrayList<SmsSendPO>();
        	SmsSendPO smsSendPO = new SmsSendPO();

            if (siteInfo.getData().getCertifySendNo() == null || ("").equals(siteInfo.getData().getCertifySendNo())) {
                throw new CustomException("biz.exception.operation.certifySendNoNull", new Object[] { "코드그룹" });
            } else {
            	smsSendPO.setSendTelno(siteInfo.getData().getCertifySendNo());
            }

            smsSendPO.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
            String sendWords = "<#> 다비치마켓 인증코드 : " + key + "\r\n입력란에 인증코드를 입력해 주세요.";

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

            smsSendPO.setReceiverNo(String.valueOf(po.getMemberNo()));
            smsSendPO.setReceiverNm(CryptoUtil.decryptAES(po.getMemberNm()));
            smsSendPO.setReceiverId(CryptoUtil.decryptAES(po.getLoginId()));
            smsSendPO.setRecvTelNo(CryptoUtil.decryptAES(po.getMobile()));
            smsSendPO.setSendTelno(siteInfo.getData().getCertifySendNo());
            smsSendPO.setFdestine(CryptoUtil.decryptAES(po.getMobile()));
            smsSendPO.setFcallback(siteInfo.getData().getCertifySendNo().replaceAll("-", ""));

            listpo.add(smsSendPO);

            smsSendService.sendSms(listpo);
        }else{
        	// 비밀번호 찾기 인증코드 이메일 발송(EmailSendSO so, ReplaceCdVO replaceVO)
	        EmailSendSO emailSendSo = new EmailSendSO();
	        emailSendSo.setMailTypeCd("27"); //  메일 유형 코드
	        emailSendSo.setReceiverEmail(po.getEmail());
	        emailSendSo.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
	        emailSendSo.setReceiverNo(0);
	        emailSendSo.setMemberNo(0);

	        /* 변경할 치환 코드 설정 */
	        ReplaceCdVO emailReplaceVO = new ReplaceCdVO();
	        emailReplaceVO.setDlgtDomain(SiteUtil.getExternalDomain(siteInfo.getData().getDlgtDomain()));
	        emailReplaceVO.setEmailCertifyValue(key);

//	        emailSendService.emailAutoSend(emailSendSo, emailReplaceVO);
        }
        return resultModel;
    }

    @RequestMapping(value = "/confirm-email")
    public @ResponseBody ResultModel confirmEmail(MemberManagePO po) throws Exception {
        ResultModel<MemberManageVO> resultModel = new ResultModel<>();

        MemberManageVO result = loginService.selectEmailAuthKey(po); // 인증키
        if(result!=null) {
            if(result.getEmailCertifyValue().equals(po.getEmailCertifyValue())) {
                resultModel.setSuccess(true);
                resultModel.setData(result);
            }else{
                resultModel.setSuccess(false);
                resultModel.setData(null);
            }
        }
        return resultModel;
    }
}