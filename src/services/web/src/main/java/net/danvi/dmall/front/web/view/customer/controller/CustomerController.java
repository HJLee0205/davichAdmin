package net.danvi.dmall.front.web.view.customer.controller;

import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import dmall.framework.common.constants.CommonConstants;
import dmall.framework.common.exception.CustomException;
import dmall.framework.common.exception.JsonValidationException;
import dmall.framework.common.model.ResultListModel;
import dmall.framework.common.model.ResultModel;
import dmall.framework.common.util.CaptchaUtil;
import dmall.framework.common.util.HttpUtil;
import dmall.framework.common.util.MessageUtil;
import dmall.framework.common.util.SiteUtil;
import dmall.framework.common.util.StringUtil;
import lombok.extern.slf4j.Slf4j;
import net.danvi.dmall.biz.app.member.manage.model.MemberManageSO;
import net.danvi.dmall.biz.app.member.manage.model.MemberManageVO;
import net.danvi.dmall.biz.app.member.manage.service.FrontMemberService;
import net.danvi.dmall.biz.app.operation.model.AtchFilePO;
import net.danvi.dmall.biz.app.operation.model.BbsCmntManagePO;
import net.danvi.dmall.biz.app.operation.model.BbsCmntManageSO;
import net.danvi.dmall.biz.app.operation.model.BbsCmntManageVO;
import net.danvi.dmall.biz.app.operation.model.BbsLettManagePO;
import net.danvi.dmall.biz.app.operation.model.BbsLettManageSO;
import net.danvi.dmall.biz.app.operation.model.BbsLettManageVO;
import net.danvi.dmall.biz.app.operation.model.BbsManageSO;
import net.danvi.dmall.biz.app.operation.model.BbsManageVO;
import net.danvi.dmall.biz.app.operation.service.BbsManageService;
import net.danvi.dmall.biz.app.setup.snsoutside.service.SnsOutsideLinkService;
import net.danvi.dmall.biz.app.visit.model.VisitSO;
import net.danvi.dmall.biz.system.model.CmnCdDtlVO;
import net.danvi.dmall.biz.system.security.SessionDetailHelper;
import net.danvi.dmall.biz.system.util.ServiceUtil;
import net.danvi.dmall.biz.system.validation.DeleteGroup;
import net.danvi.dmall.biz.system.validation.InsertGroup;
import net.danvi.dmall.biz.system.validation.UpdateGroup;
import nl.captcha.servlet.CaptchaServletUtil;

/**
 * <pre>
 * 프로젝트명 : 31.front.web
 * 작성일     : 2016. 5. 4.
 * 작성자     : KMS
 * 설명       :
 * </pre>
 */
@Slf4j
@Controller
@RequestMapping("/front/customer")
public class CustomerController {

    @Resource(name = "bbsManageService")
    private BbsManageService bbsManageService;

    @Resource(name = "frontMemberService")
    private FrontMemberService frontMemberService;

    @Resource(name = "snsOutsideLinkService")
    private SnsOutsideLinkService snsOutsideLinkService;
    /**
     * <pre>
     * 작성일 : 2016. 5. 2.
     * 작성자 : dong
     * 설명 : 고객센터 메인
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     */
    @RequestMapping(value = "/customer-main")
    public ModelAndView customerMain(@Validated BbsLettManageSO so, BindingResult bindingResult) throws Exception{
        ModelAndView mav = SiteUtil.getSkinView();
        // 1.공지사항 조회(최근등록순 5건)
        so.setBbsId("notice");
        so.setOrderGb("main");
        ResultListModel<BbsLettManageVO> noticeList = bbsManageService.selectBbsLettPaging(so);
        mav.addObject("noticeList", noticeList);
        // 2.FAQ조회 5건(최근 등록순 5건)
        so.setBbsId("faq");
        ResultListModel<BbsLettManageVO> faqList = bbsManageService.selectBbsLettPaging(so);
        mav.addObject("faqList", faqList);

        // 3. 나의문의 조회
        if (SessionDetailHelper.getDetails().getSession().getMemberNo() != null) {
	        so.setBbsId("inquiry");
	        so.setMemberNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
	        ResultListModel<BbsLettManageVO> inquiryList = bbsManageService.selectBbsLettPaging(so);
	        mav.addObject("inquiryList", inquiryList);
	        
	        // 모바일 추가
	        if(SiteUtil.isMobile()) {
	            BbsLettManageSO mso = new BbsLettManageSO();
	            mso.setBbsId("inquiry");
	            mso.setMemberNo(0);
	            mso.setMobileYn("Y");
	            ResultListModel<BbsLettManageVO> replyList = bbsManageService.selectBbsLettPaging(mso);
	            mav.addObject("replyList", replyList);
	        }
        }

        //LEFT메뉴 FAQ코드 목록 조회
        List<CmnCdDtlVO> faqcodeListModel = ServiceUtil.listCode("FAQ_GB_CD");
        mav.addObject("faqcodeListModel", faqcodeListModel);


        // LNB 가져오기
        BbsManageSO bs = new BbsManageSO();
        bs.setSiteNo(so.getSiteNo());
        ResultListModel<BbsManageVO> leftMenu = this.getCustomerMenu(bs);
        if (leftMenu.getTotalRows() > 0) {
            String bbsId = ((BbsManageVO) leftMenu.getResultList().get(0)).getBbsId();
            if ("".equals(so.getBbsId()) || so.getBbsId() == null) {
                so.setBbsId(bbsId);
                bs.setBbsId(bbsId);
            } else {
                bs.setBbsId(so.getBbsId());
            }
        } else {
        }
        
        // 모바일 추가
        if(SiteUtil.isMobile()) {
        	for (int i = 0; i < leftMenu.getResultList().size(); i++) {
        		BbsLettManageSO mso = new BbsLettManageSO();
        		String bbsId = ((BbsManageVO) leftMenu.getResultList().get(i)).getBbsId();
        		if(!"faq".equals(bbsId) && !"inquiry".equals(bbsId) && !"notice".equals(bbsId)) {
	        		mso.setBbsId(bbsId);
	        		ResultListModel<BbsLettManageVO> bbsList = bbsManageService.selectBbsLettPaging(mso);
	        		mav.addObject(bbsId+"List", bbsList);
        		}
			}
	        
        }

        mav.addObject("leftMenu", leftMenu);
        mav.addObject("so", so);
        mav.addObject(5);
        mav.setViewName("/customer/customer");
        return mav;
    }

    // FAQ 목록보기
    @RequestMapping(value = "/faq-list")
    public ModelAndView selectFaqList(@Validated BbsLettManageSO so, BindingResult bindingResult) throws Exception{
        ModelAndView mav = SiteUtil.getSkinView();
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            return mav;
        }

        List<CmnCdDtlVO> codeListModel = ServiceUtil.listCode("FAQ_GB_CD");
        if ("".equals(so.getFaqGbCd()) || so.getFaqGbCd() == null) {
            // 만약 고객센터 메인에서 자주묻는 질문검색을 한다면 자주묻는질문 페이지에서 탭이 기본으로 선택되지 않게한다.
            if (!"customerMain".equals(so.getSearchKind())) {
                //so.setFaqGbCd("0");
            	so.setFaqGbCd(null);
            }
        }

       //LEFT메뉴 FAQ코드 목록 조회
        List<CmnCdDtlVO> faqcodeListModel = ServiceUtil.listCode("FAQ_GB_CD");
        mav.addObject("faqcodeListModel", faqcodeListModel);

        // LNB 가져오기
        BbsManageSO bs = new BbsManageSO();
        bs.setSiteNo(so.getSiteNo());
        ResultListModel<BbsManageVO> leftMenu = this.getCustomerMenu(bs);
        if (leftMenu.getTotalRows() > 0) {
            String bbsId = ((BbsManageVO) leftMenu.getResultList().get(0)).getBbsId();
            if ("".equals(so.getBbsId()) || so.getBbsId() == null) {
                so.setBbsId(bbsId);
                bs.setBbsId(bbsId);
            } else {
                bs.setBbsId(so.getBbsId());
            }
        } else {
        }

        mav.addObject("leftMenu", leftMenu);

        mav.addObject("so", so);
        /*mav.addObject("leftMenu", "faq");*/
        mav.addObject("codeListModel", codeListModel);
        mav.setViewName("/customer/faq_list");
        return mav;
    }

    // FAQ tab 메뉴
    @RequestMapping(value = "/faq-tab")
    public ModelAndView faqTab(@Validated BbsLettManageSO so, BindingResult bindingResult) throws Exception{

        ModelAndView mav = SiteUtil.getSkinView();
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            return mav;
        }
        so.setBbsId("faq");
        ResultListModel<BbsLettManageVO> faqList = bbsManageService.selectBbsLettPaging(so);

        // LNB 가져오기
        BbsManageSO bs = new BbsManageSO();
        bs.setSiteNo(so.getSiteNo());
        ResultListModel<BbsManageVO> leftMenu = this.getCustomerMenu(bs);
        if (leftMenu.getTotalRows() > 0) {
            String bbsId = ((BbsManageVO) leftMenu.getResultList().get(0)).getBbsId();
            if ("".equals(so.getBbsId()) || so.getBbsId() == null) {
                so.setBbsId(bbsId);
                bs.setBbsId(bbsId);
            } else {
                bs.setBbsId(so.getBbsId());
            }
        } else {
        }

        mav.addObject("leftMenu", leftMenu);

        mav.addObject("so", so);
        mav.addObject("resultListModel", faqList);

        mav.setViewName("/customer/faqTab");
        return mav;
    }

    // FAQ 목록보기(Ajax)
    @RequestMapping(value = "/faq-list-ajax")
    public @ResponseBody ResultListModel<BbsLettManageVO> ajaxfaqList(@Validated BbsLettManageSO so,
            BindingResult bindingResult) throws Exception {
        so.setBbsId("faq");
        if (!"".equals(so.getSearchVal()) && so.getSearchVal() != null) {
            so.setSearchKind("all");
        }

        if ("".equals(so.getFaqGbCd()) || so.getFaqGbCd() == null) {
        	so.setFaqGbCd(null);
        }

        ResultListModel<BbsLettManageVO> faqList = bbsManageService.selectBbsLettPaging(so);
        return faqList;
    }

    // 모바일 - FAQ 목록보기(Ajax)
    /*@RequestMapping(value = "/faq-list-ajax")
    public ModelAndView ajaxFaqList(@Validated BbsLettManageSO so, BindingResult bindingResult) {
        so.setBbsId("faq");
        ModelAndView mav = new ModelAndView();
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            return mav;
        }
        mav.addObject("so", so);
        ResultListModel<BbsLettManageVO> faqList = bbsManageService.selectBbsLettPaging(so);
        mav.addObject("resultListModel", faqList);
        mav.setViewName("/customer/ajaxFaq_list");
        return mav;
    }*/

    // 공지사항 목록보기
    @RequestMapping(value = "/notice-list")
    public ModelAndView selectNoticeList(@Validated BbsLettManageSO so, BindingResult bindingResult) throws Exception {
        ModelAndView mav = SiteUtil.getSkinView();
        so.setBbsId("notice");
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            return mav;
        }
        // 1.게시판 정보 조회
        BbsManageSO bs = new BbsManageSO();
        bs.setBbsId(so.getBbsId());
        ResultModel<BbsManageVO> bbsInfo = bbsManageService.selectBbsDtl(bs);
        // 2.게시글 리스트 조회
        ResultListModel<BbsLettManageVO> noticeList = bbsManageService.selectBbsLettPaging(so);

        //LEFT메뉴 FAQ코드 목록 조회
        List<CmnCdDtlVO> faqcodeListModel = ServiceUtil.listCode("FAQ_GB_CD");
        mav.addObject("faqcodeListModel", faqcodeListModel);

        // LNB 가져오기
        bs = new BbsManageSO();
        bs.setSiteNo(so.getSiteNo());
        ResultListModel<BbsManageVO> leftMenu = this.getCustomerMenu(bs);
        if (leftMenu.getTotalRows() > 0) {
            String bbsId = ((BbsManageVO) leftMenu.getResultList().get(0)).getBbsId();
            if ("".equals(so.getBbsId()) || so.getBbsId() == null) {
                so.setBbsId(bbsId);
                bs.setBbsId(bbsId);
            } else {
                bs.setBbsId(so.getBbsId());
            }
        } else {
        }

        mav.addObject("leftMenu", leftMenu);

        mav.addObject("so", so);
        mav.addObject("bbsInfo", bbsInfo);
        mav.addObject("resultListModel", noticeList);
        /*mav.addObject("leftMenu", "notice");*/
        mav.setViewName("/customer/notice_list");
        return mav;
    }

    // 2016.08.29 추가 - 모바일
    // 공지사항 목록보기_ajax
    @RequestMapping(value = "/notice-list-ajax")
    public ModelAndView ajaxNoticeList(@Validated BbsLettManageSO so, BindingResult bindingResult) {
        ModelAndView mav = new ModelAndView();
        so.setBbsId("notice");
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            return mav;
        }
        ResultListModel<BbsLettManageVO> noticeList = bbsManageService.selectBbsLettPaging(so);
        mav.addObject("so", so);
        mav.addObject("resultListModel", noticeList);
        /*mav.addObject("leftMenu", "notice");*/
        mav.setViewName("/customer/ajaxNotice_list");
        return mav;
    }

    // 공지사항 상세보기
    @RequestMapping(value = "/notice-detail")
    public ModelAndView selectNoticeView(@Validated BbsLettManageSO so, BindingResult bindingResult) throws Exception {
        ModelAndView mav = SiteUtil.getSkinView();
        so.setBbsId("notice");
        // 상세정보
        ResultModel<BbsLettManageVO> resultModel = bbsManageService.selectBbsLettDtl(so);
        // 이전글
        ResultModel<BbsLettManageVO> pResultMap = bbsManageService.preBbsLettNo(so);
        // 다음글
        ResultModel<BbsLettManageVO> nResultMap = bbsManageService.nextBbsLettNo(so);

        //LEFT메뉴 FAQ코드 목록 조회
        List<CmnCdDtlVO> faqcodeListModel = ServiceUtil.listCode("FAQ_GB_CD");
        mav.addObject("faqcodeListModel", faqcodeListModel);

        // LNB 가져오기
        BbsManageSO bs = new BbsManageSO();
        bs.setSiteNo(so.getSiteNo());
        ResultListModel<BbsManageVO> leftMenu = this.getCustomerMenu(bs);
        if (leftMenu.getTotalRows() > 0) {
            String bbsId = ((BbsManageVO) leftMenu.getResultList().get(0)).getBbsId();
            if ("".equals(so.getBbsId()) || so.getBbsId() == null) {
                so.setBbsId(bbsId);
                bs.setBbsId(bbsId);
            } else {
                bs.setBbsId(so.getBbsId());
            }
        } else {
        }

        mav.addObject("leftMenu", leftMenu);


        mav.addObject("resultModel", resultModel);
        mav.addObject("preBbs", pResultMap);
        mav.addObject("nextBbs", nResultMap);
        /*mav.addObject("leftMenu", "notice");*/
        mav.setViewName("/customer/view_notice");
        return mav;
    }

    // 1:1상담 목록보기
    @RequestMapping(value = "/inquiry-list")
    public ModelAndView selectInquiryList(@Validated BbsLettManageSO so, BbsLettManageSO inquirySo, BbsLettManageSO questionSo, BbsLettManageSO reviewSo, BindingResult bindingResult) throws Exception{
        ModelAndView mav = SiteUtil.getSkinView("/mypage/inquiry_list");

        // 최초 접속시에는 현재 1:1문의로 고정
        if (so.getCustomerCd() == null) {
            so.setCustomerCd("inquiry");
        }
        mav.addObject("so", so);
        int page = so.getPage();
        //1:1문의
        inquirySo.setBbsId("inquiry");
        inquirySo.setMemberNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
        if(inquirySo.getCustomerCd().equals("inquiry")){
            inquirySo.setPage(page);
        }else{
            inquirySo.setPage(1);
        }
        ResultListModel<BbsLettManageVO> inquiryList = bbsManageService.selectBbsLettPaging(inquirySo);
        mav.addObject("resultListModel", inquiryList);
        mav.addObject("inquirySo", inquirySo);
        mav.addObject("leftMenu2", "inquiry");

        // 모바일 추가
        if(SiteUtil.isMobile()) {
            BbsLettManageSO mso = new BbsLettManageSO();
            mso.setBbsId("inquiry");
            mso.setMemberNo(0);
            mso.setMobileYn("Y");
            ResultListModel<BbsLettManageVO> replyList = bbsManageService.selectBbsLettPaging(mso);
            mav.addObject("replyList", replyList);
        }

        //상품문의
        questionSo.setBbsId("question");
        questionSo.setMemberNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
        questionSo.setSearchKind(questionSo.getQstSearchKind());
        questionSo.setSearchVal(questionSo.getQstSearchVal());
        if(questionSo.getCustomerCd().equals("question")){
            questionSo.setPage(page);
        }else{
            questionSo.setPage(1);
        }
        ResultListModel<BbsLettManageVO> questionList = bbsManageService.selectBbsLettPaging(questionSo);
        mav.addObject("questionListModel", questionList);
        mav.addObject("questionSo", questionSo);

        //상품후기
        reviewSo.setBbsId("review");
        if(reviewSo.getCustomerCd().equals("review")){
            reviewSo.setPage(page);
        }else{
            reviewSo.setPage(1);
        }
        reviewSo.setMemberNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
        reviewSo.setSearchKind(reviewSo.getRvSearchKind());
        reviewSo.setSearchVal(reviewSo.getRvSearchVal());
        ResultListModel<BbsLettManageVO> reviewList = bbsManageService.selectBbsLettPaging(reviewSo);

        //LEFT메뉴 FAQ코드 목록 조회
        List<CmnCdDtlVO> faqcodeListModel = ServiceUtil.listCode("FAQ_GB_CD");
        mav.addObject("faqcodeListModel", faqcodeListModel);

        // LNB 가져오기
        BbsManageSO bs = new BbsManageSO();
        bs.setSiteNo(so.getSiteNo());
        ResultListModel<BbsManageVO> leftMenu = this.getCustomerMenu(bs);
        if (leftMenu.getTotalRows() > 0) {
            String bbsId = ((BbsManageVO) leftMenu.getResultList().get(0)).getBbsId();
            if ("".equals(so.getBbsId()) || so.getBbsId() == null) {
                so.setBbsId(bbsId);
                bs.setBbsId(bbsId);
            } else {
                bs.setBbsId(so.getBbsId());
            }
        } else {
        }

        mav.addObject("leftMenu", leftMenu);

        mav.addObject("reviewListModel", reviewList);
        mav.addObject("reviewSo", reviewSo);



        return mav;
    }

    // 2016.08.29 - 모바일
    // 1:1상담 목록보기_ajax
    @RequestMapping(value = "/inquiry-list-ajax")
    public ModelAndView ajaxInquiryList(@Validated BbsLettManageSO so, BbsLettManageSO mso,
                                        BindingResult bindingResult) {
        ModelAndView mav = new ModelAndView();
        so.setBbsId("inquiry");
        so.setMemberNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
        ResultListModel<BbsLettManageVO> inquiryList = bbsManageService.selectBbsLettPaging(so);
        mav.addObject("resultListModel", inquiryList);
        mav.addObject("so", so);
        /*mav.addObject("leftMenu", "inquiry");*/

        // 모바일 추가
        mso.setBbsId("inquiry");
        mso.setMemberNo(0);
        mso.setMobileYn("Y");
        ResultListModel<BbsLettManageVO> replyList = bbsManageService.selectBbsLettPaging(mso);
        mav.addObject("replyList", replyList);
        mav.addObject("mso", mso);
        //
        mav.setViewName("/mypage/ajaxInquiryList");
        return mav;
    }

    // 1:1 상담 등록폼
    @RequestMapping(value = "/inquiry-insert-form")
    public ModelAndView insertInquiryForm(@Validated BbsLettManageSO so, BindingResult bindingResult) throws Exception{
        ModelAndView mav = SiteUtil.getSkinView("/customer/insert_inquiry");
        mav.addObject("leftMenu2", "inquiry");

        if(SiteUtil.isMobile()) {
            MemberManageSO mso = new MemberManageSO();
            mso.setSiteNo(so.getSiteNo());
            mso.setMemberNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
            ResultModel<MemberManageVO> resultModel = frontMemberService.selectMember(mso);
            mav.addObject("resultModel", resultModel);
        }

      //LEFT메뉴 FAQ코드 목록 조회
        List<CmnCdDtlVO> faqcodeListModel = ServiceUtil.listCode("FAQ_GB_CD");
        mav.addObject("faqcodeListModel", faqcodeListModel);

        // LNB 가져오기
        BbsManageSO bs = new BbsManageSO();
        bs.setSiteNo(so.getSiteNo());
        ResultListModel<BbsManageVO> leftMenu = this.getCustomerMenu(bs);
        if (leftMenu.getTotalRows() > 0) {
            String bbsId = ((BbsManageVO) leftMenu.getResultList().get(0)).getBbsId();
            if ("".equals(so.getBbsId()) || so.getBbsId() == null) {
                so.setBbsId(bbsId);
                bs.setBbsId(bbsId);
            } else {
                bs.setBbsId(so.getBbsId());
            }
        } else {
        }

        mav.addObject("leftMenu", leftMenu);

        return mav;
    }

    // 1:1 상담 등록
    @RequestMapping(value = "/inquiry-insert")
    public @ResponseBody ResultModel<BbsLettManagePO> insertInquiry(@Validated BbsLettManagePO po,
                                                                    BindingResult bindingResult) throws Exception {
        log.debug("so.getBbsId() : " + po.getBbsId());
        log.debug("so.getInquiryCd() : " + po.getInquiryCd());
        log.debug("so.getTitle() : " + po.getTitle());
        log.debug("so.getContent() : " + po.getContent());
        po.setBbsId("inquiry");
        po.setMemberNo(po.getRegrNo());
        ResultModel<BbsLettManagePO> result = bbsManageService.insertBbsLett(po, HttpUtil.getHttpServletRequest());
        return result;
    }

    // 2016.09.20 - 모바일
    // 1:1 문의 삭제
    @RequestMapping("/inquiry-delete")
    public @ResponseBody ResultModel<BbsLettManagePO> deleteInquiry(@Validated(DeleteGroup.class) BbsLettManagePO po,
                                                                    BindingResult bindingResult) throws Exception {
        ResultModel<BbsLettManagePO> result = new ResultModel<>();
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }
        result = bbsManageService.deleteBbsLett(po);
        return result;
    }


    // 매장 찾기
    @RequestMapping(value = "/store-list")
    public ModelAndView selectStoreList(@Validated VisitSO so, BindingResult bindingResult) throws Exception {
        ModelAndView mav = SiteUtil.getSkinView("/customer/store_list");
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            return mav;
        }

        List<CmnCdDtlVO> areaListModel = ServiceUtil.listCode("STORE_AREA_CD");
        List<CmnCdDtlVO> areaDtlListModel = ServiceUtil.listCode("STORE_AREA_DTL_CD", "00", null, null, null, null);
        mav.addObject("areaListModel", areaListModel);
        mav.addObject("areaDtlListModel", areaDtlListModel);
        mav.addObject("so", so);

        //LEFT메뉴 FAQ코드 목록 조회
        List<CmnCdDtlVO> faqcodeListModel = ServiceUtil.listCode("FAQ_GB_CD");

        // LNB 가져오기
        BbsManageSO bs = new BbsManageSO();
        bs.setSiteNo(so.getSiteNo());
        ResultListModel<BbsManageVO> leftMenu = this.getCustomerMenu(bs);
        if (leftMenu.getTotalRows() > 0) {
            String bbsId = ((BbsManageVO) leftMenu.getResultList().get(0)).getBbsId();
            bs.setBbsId(bbsId);
        } else {
        }

        mav.addObject("leftMenu", leftMenu);

        mav.addObject("faqcodeListModel", faqcodeListModel);
        /*mav.addObject("leftMenu", "store_list");*/
        return mav;
    }
    
    

    // 매장 찾기
    @RequestMapping(value = "/store-list2")
    public ModelAndView selectStoreList2(@Validated VisitSO so, BindingResult bindingResult) throws Exception {
        ModelAndView mav = SiteUtil.getSkinView("/customer/store_list2");
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            return mav;
        }

        List<CmnCdDtlVO> areaListModel = ServiceUtil.listCode("STORE_AREA_CD");
        List<CmnCdDtlVO> areaDtlListModel = ServiceUtil.listCode("STORE_AREA_DTL_CD", "00", null, null, null, null);
        mav.addObject("areaListModel", areaListModel);
        mav.addObject("areaDtlListModel", areaDtlListModel);
        mav.addObject("so", so);

        //LEFT메뉴 FAQ코드 목록 조회
        List<CmnCdDtlVO> faqcodeListModel = ServiceUtil.listCode("FAQ_GB_CD");

        // LNB 가져오기
        BbsManageSO bs = new BbsManageSO();
        bs.setSiteNo(so.getSiteNo());
        ResultListModel<BbsManageVO> leftMenu = this.getCustomerMenu(bs);
        if (leftMenu.getTotalRows() > 0) {
            String bbsId = ((BbsManageVO) leftMenu.getResultList().get(0)).getBbsId();
            bs.setBbsId(bbsId);
        } else {
        }

        mav.addObject("leftMenu", leftMenu);

        mav.addObject("faqcodeListModel", faqcodeListModel);
        /*mav.addObject("leftMenu", "store_list");*/
        return mav;
    }
    

    /**
     * <pre>
     * 작성일 : 2016. 5. 19.
     * 작성자 : dong
     * 설명   : 고객센터 좌측 메뉴 정보
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 19. dong - 최초생성
     * </pre>
     *
     * @param so
     * @return
     * @throws Exception
     */
    public ResultListModel<BbsManageVO> getCustomerMenu(@Validated BbsManageSO so) throws Exception {

        so.setBbsId("");
        so.setBbsGbCd("2");
        so.setUseYn("Y");
        ResultListModel<BbsManageVO> result = bbsManageService.selectBbsListPaging(so);

        return result;
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 17.
     * 작성자 : dong
     * 설명   : 게시판 리스트
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 17. dong - 최초생성
     * </pre>
     *
     * @param so
     * @param bindingResult
     * @return
     */
    @RequestMapping(value = "/board-list")
    public ModelAndView bbsList(@Validated BbsLettManageSO so, BindingResult bindingResult) throws Exception {
        ModelAndView mav = SiteUtil.getSkinView();

        BbsManageSO bs = new BbsManageSO();
        bs.setSiteNo(so.getSiteNo());

        //LEFT메뉴 FAQ코드 목록 조회
        List<CmnCdDtlVO> faqcodeListModel = ServiceUtil.listCode("FAQ_GB_CD");
        mav.addObject("faqcodeListModel", faqcodeListModel);

        // LNB 가져오기
        ResultListModel<BbsManageVO> leftMenu = this.getCustomerMenu(bs);
        if (leftMenu.getTotalRows() > 0) {
            String bbsId = ((BbsManageVO) leftMenu.getResultList().get(0)).getBbsId();
            if ("".equals(so.getBbsId()) || so.getBbsId() == null) {
                so.setBbsId(bbsId);
                bs.setBbsId(bbsId);
            } else {
                bs.setBbsId(so.getBbsId());
            }
        } else {
            throw new Exception("등록된 게시판이 없습니다.");
        }

        // 1.필수 데이터 확인(사이트번호, 게시판아이디)
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            return mav;
        }

        // 2.게시판 정보 조회
        ResultModel<BbsManageVO> bbsInfo = bbsManageService.selectBbsDtl(bs);

        // 3. 리턴 view 확인
        String viewName = "";

        switch (bbsInfo.getData().getBbsKindCd()) {
            case "1":
                viewName = "customer/bbs_list"; // 리스트형
                break;
            case "2":
                //so.setRows(8);
                viewName = "customer/bbs_gallery_list"; // 갤러리형
                break;
            case "3":
                viewName = "customer/bbs_data_list"; // 자료실형
                break;
        }

        // 5.게시글 목록 조회
        String noticeLettSetCd = bbsInfo.getData().getNoticeLettSetYn();
        if ("Y".equals(noticeLettSetCd)) {
            so.setNoticeYn("N");
        }
        
        // 뉴스 게시판
        if("news".equals(bbsInfo.getData().getBbsId())) {
        	viewName = "customer/bbs_news_list"; // 뉴스형
        	so.setBbsId(bbsInfo.getData().getBbsId());
        	
        	//so.setRows(8);
        	so.setNoticeYn("N");
        	ResultListModel<BbsLettManageVO> newsList = bbsManageService.selectBbsLettPaging(so);
        	mav.addObject("newsList", newsList);
        	
        	so.setNoticeYn("Y");
        	ResultListModel<BbsLettManageVO> mainNewsList = bbsManageService.selectBbsLettPaging(so);
        	mav.addObject("mainNewsList", mainNewsList);
        	
        }else {
        	ResultListModel<BbsLettManageVO> resultListModel = bbsManageService.selectBbsLettPaging(so);
        	mav.addObject("resultListModel", resultListModel);
        }

        mav.setViewName(viewName);
        mav.addObject("so", so);
        mav.addObject("bs", bs);
        mav.addObject("bbsInfo", bbsInfo);
        mav.addObject("leftMenu", leftMenu);

        return mav;
    }
    
    @RequestMapping("/bbs-list-ajax")
    public ModelAndView bbsListPaging(@Validated BbsLettManageSO so, BindingResult bindingResult) throws Exception {
        
    	ModelAndView mav = SiteUtil.getSkinView("/mypage/bbs_list_paging");
    	
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            return mav;
        }

        BbsManageSO bs = new BbsManageSO();
        bs.setSiteNo(so.getSiteNo());

        //LEFT메뉴 FAQ코드 목록 조회
        List<CmnCdDtlVO> faqcodeListModel = ServiceUtil.listCode("FAQ_GB_CD");
        mav.addObject("faqcodeListModel", faqcodeListModel);

        // LNB 가져오기
        ResultListModel<BbsManageVO> leftMenu = this.getCustomerMenu(bs);
        if (leftMenu.getTotalRows() > 0) {
            String bbsId = ((BbsManageVO) leftMenu.getResultList().get(0)).getBbsId();
            if ("".equals(so.getBbsId()) || so.getBbsId() == null) {
                so.setBbsId(bbsId);
                bs.setBbsId(bbsId);
            } else {
                bs.setBbsId(so.getBbsId());
            }
        } else {
            throw new Exception("등록된 게시판이 없습니다.");
        }

        // 1.필수 데이터 확인(사이트번호, 게시판아이디)
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            return mav;
        }

        // 2.게시판 정보 조회
        ResultModel<BbsManageVO> bbsInfo = bbsManageService.selectBbsDtl(bs);

        // 3. 리턴 view 확인
        String viewName = "";

        switch (bbsInfo.getData().getBbsKindCd()) {
            case "1":
                viewName = "customer/bbs_list_paging"; // 리스트형
                break;
            case "2":
                //so.setRows(8);
                viewName = "customer/bbs_gallery_list_paging"; // 갤러리형
                break;
            case "3":
                viewName = "customer/bbs_data_list_paging"; // 자료실형
                break;
        }

        // 5.게시글 목록 조회
        String noticeLettSetCd = bbsInfo.getData().getNoticeLettSetYn();
        if ("Y".equals(noticeLettSetCd)) {
            so.setNoticeYn("N");
        }
        
        // 뉴스 게시판
        if("news".equals(bbsInfo.getData().getBbsId())) {
        	viewName = "customer/bbs_news_list_paging"; // 뉴스형
        	so.setBbsId(bbsInfo.getData().getBbsId());
        	
        	//so.setRows(8);
        	so.setNoticeYn("N");
        	ResultListModel<BbsLettManageVO> newsList = bbsManageService.selectBbsLettPaging(so);
        	mav.addObject("newsList", newsList);
        	
        	so.setNoticeYn("Y");
        	ResultListModel<BbsLettManageVO> mainNewsList = bbsManageService.selectBbsLettPaging(so);
        	mav.addObject("mainNewsList", mainNewsList);
        	
        }else {
        	ResultListModel<BbsLettManageVO> resultListModel = bbsManageService.selectBbsLettPaging(so);
        	mav.addObject("resultListModel", resultListModel);
        }

        mav.setViewName(viewName);
        mav.addObject("so", so);
        mav.addObject("bs", bs);
        mav.addObject("bbsInfo", bbsInfo);
        mav.addObject("leftMenu", leftMenu);

        return mav;
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 17.
     * 작성자 : dong
     * 설명   : 게시글 상세 보기
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 17. dong - 최초생성
     * </pre>
     *
     * @param so
     * @param bindingResult
     * @return
     */
    @RequestMapping("/letter-detail")
    public ModelAndView viewBbs(@Validated BbsLettManageSO so, BindingResult bindingResult) throws Exception {
        ModelAndView mav = SiteUtil.getSkinView();

        if (so.getLettNo() == null || "".equals(so.getLettNo())) {
            throw new CustomException("front.web.common.wrongapproach");
        }
        
        BbsManageSO bs = new BbsManageSO();
        bs.setSiteNo(so.getSiteNo());

        //LEFT메뉴 FAQ코드 목록 조회
        List<CmnCdDtlVO> faqcodeListModel = ServiceUtil.listCode("FAQ_GB_CD");
        mav.addObject("faqcodeListModel", faqcodeListModel);

        // LNB 가져오기
        ResultListModel<BbsManageVO> leftMenu = this.getCustomerMenu(bs);
        if (leftMenu.getTotalRows() > 0) {
            String bbsId = ((BbsManageVO) leftMenu.getResultList().get(0)).getBbsId();
            if ("".equals(so.getBbsId()) || so.getBbsId() == null) {
                so.setBbsId(bbsId);
                bs.setBbsId(bbsId);
            } else {
                bs.setBbsId(so.getBbsId());
            }
        } else {
            throw new Exception("등록된 게시판이 없습니다.");
        }

        // 1.필수 데이터 확인(사이트번호, 게시판아이디)
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            return mav;
        }

        // 2.게시판 정보 조회
        ResultModel<BbsManageVO> bbsInfo = bbsManageService.selectBbsDtl(bs);

        // 3. 게시글 조회
        ResultModel<BbsLettManageVO> result = bbsManageService.selectBbsLettDtl(so);
        if ("Y".equals(result.getData().getSectYn())) {
            if (!StringUtil.nvl(so.getPw(), "").equals(result.getData().getPw())) {
                throw new Exception("잘못된 접근 입니다.(비밀번호 불일치)");
            }
        }

        // 4 코멘트 조회
        BbsCmntManageSO cs = new BbsCmntManageSO();
        cs.setSiteNo(so.getSiteNo());
        cs.setLettNo(result.getData().getLettNo());
        ResultListModel<BbsCmntManageVO> comment = bbsManageService.selectBbsCmntList(cs);

        // 5 이전글, 다음글 조회
        ResultModel<BbsLettManageVO> preBbs = bbsManageService.preBbsLettNo(so);
        ResultModel<BbsLettManageVO> nextBbs = bbsManageService.nextBbsLettNo(so);

        // 6.조회수 업데이트
        BbsLettManagePO po = new BbsLettManagePO();
        po.setBbsId(so.getBbsId());
        po.setSiteNo(so.getSiteNo());
        po.setLettNo(so.getLettNo());
        bbsManageService.updateInqCnt(po);

        mav.setViewName("customer/view_bbs");
        mav.addObject("bbsInfo", bbsInfo);
        mav.addObject("leftMenu", leftMenu);
        mav.addObject("so", so);
        mav.addObject("resultModel", result);
        mav.addObject("preBbs", preBbs);
        mav.addObject("nextBbs", nextBbs);
        mav.addObject("commentList", comment);
        return mav;
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 17.
     * 작성자 : dong
     * 설명   : 게시판 등록 화면
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 17. dong - 최초생성
     * </pre>
     *
     * @param so
     * @param bindingResult
     * @return
     */
    @RequestMapping(value = "/letter-insert-form")
    public ModelAndView insertViewBbs(@Validated BbsLettManageSO so, BindingResult bindingResult) throws Exception {
        ModelAndView mav = SiteUtil.getSkinView();

        BbsManageSO bs = new BbsManageSO();
        bs.setSiteNo(so.getSiteNo());

//LEFT메뉴 FAQ코드 목록 조회
        List<CmnCdDtlVO> faqcodeListModel = ServiceUtil.listCode("FAQ_GB_CD");
        mav.addObject("faqcodeListModel", faqcodeListModel);

        // LNB 가져오기
        ResultListModel<BbsManageVO> leftMenu = this.getCustomerMenu(bs);
        if (leftMenu.getTotalRows() > 0) {
            String bbsId = ((BbsManageVO) leftMenu.getResultList().get(0)).getBbsId();
            if ("".equals(so.getBbsId()) || so.getBbsId() == null) {
                so.setBbsId(bbsId);
                bs.setBbsId(bbsId);
            } else {
                bs.setBbsId(so.getBbsId());
            }
        } else {
            throw new Exception("등록된 게시판이 없습니다.");
        }

        // 1.필수 데이터 확인(사이트번호, 게시판아이디)
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            return mav;
        }

        // 2.게시판 정보 조회
        ResultModel<BbsManageVO> bbsInfo = bbsManageService.selectBbsDtl(bs);

        // 3. 답변일 경우 원글 정보 추가
        ResultModel<BbsLettManageVO> result = new ResultModel<>();
        if (!"".equals(so.getGrpNo()) && so.getGrpNo() != null) {
            so.setLettNo(so.getLettNo());
            result = bbsManageService.selectBbsLettDtl(so);
        }

        mav.setViewName("customer/insert_view_bbs");
        mav.addObject("so", so);
        mav.addObject("resultModel", result);
        mav.addObject("bbsInfo", bbsInfo);
        mav.addObject("leftMenu", leftMenu);
        return mav;
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 17.
     * 작성자 : dong
     * 설명   : 게시글/답글 등록
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 17. dong - 최초생성
     * </pre>
     *
     * @param po
     * @param bindingResult
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/letter-insert")
    public @ResponseBody ResultModel<BbsLettManagePO> insertBbsLett(@Validated(InsertGroup.class) BbsLettManagePO po,
                                                                    BindingResult bindingResult, HttpServletRequest request) throws Exception {

        ResultModel<BbsLettManagePO> result = new ResultModel<>();

        // 1.필수 데이터 확인
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }

        if (po.getRegrNo() == null) {
            result.setSuccess(false);
            result.setMessage(MessageUtil.getMessage("biz.exception.lng.loginRequired"));
            return result;
        }

        // 2. 자동입력 방지 확인
        /*BbsManageSO bs = new BbsManageSO();
        bs.setSiteNo(po.getSiteNo());
        bs.setBbsId(po.getBbsId());
        ResultModel<BbsManageVO> bbsInfo = bbsManageService.selectBbsDtl(bs);

        if ("Y".equals(bbsInfo.getData().getBbsSpamPrvntYn())) {
            if (StringUtil.isEmpty(po.getCaptchaCd())) {
                result.setSuccess(false);
                result.setMessage("자동등록방지 문자를 입력하십시요.");
                return result;
            }
            if (!CaptchaUtil.checkCaptchaString(HttpUtil.getHttpServletRequest(), po.getCaptchaCd())) {
                result.setSuccess(false);
                result.setMessage("자동등록방지 문자가 일치하지 않습니다.");
                return result;
            }
        }*/

        // 2. 게시글 등록
        try {
            if ("".equals(po.getGrpNo()) || po.getGrpNo() == null) {
                result = bbsManageService.insertBbsLett(po, request); // 게시글등록
            } else {
                po.setReplyTitle(po.getTitle());
                po.setReplyContent(po.getContent());
                result = bbsManageService.insertBbsReply(po); // 답글 등록
            }
        } catch (Exception e) {
            result.setMessage(e.getMessage());
        }

        log.debug(" ==result : {}", result.getData().getLettNo());

        return result;
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 17.
     * 작성자 : dong
     * 설명   : 게시글/답글 수정 화면
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 17. dong - 최초생성
     * </pre>
     *
     * @param so
     * @param bindingResult
     * @return
     */
    @RequestMapping("/letter-update-form")
    public ModelAndView updateViewBbs(@Validated BbsLettManageSO so, BindingResult bindingResult) throws Exception {
        ModelAndView mav = SiteUtil.getSkinView();

        BbsManageSO bs = new BbsManageSO();
        bs.setSiteNo(so.getSiteNo());

//LEFT메뉴 FAQ코드 목록 조회
        List<CmnCdDtlVO> faqcodeListModel = ServiceUtil.listCode("FAQ_GB_CD");
        mav.addObject("faqcodeListModel", faqcodeListModel);

        // LNB 가져오기
        ResultListModel<BbsManageVO> leftMenu = this.getCustomerMenu(bs);
        if (leftMenu.getTotalRows() > 0) {
            String bbsId = ((BbsManageVO) leftMenu.getResultList().get(0)).getBbsId();
            if ("".equals(so.getBbsId()) || so.getBbsId() == null) {
                so.setBbsId(bbsId);
                bs.setBbsId(bbsId);
            } else {
                bs.setBbsId(so.getBbsId());
            }
        } else {
            throw new Exception("등록된 게시판이 없습니다.");
        }

        // 1.필수 데이터 확인(사이트번호, 게시판아이디)
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            return mav;
        }

        // 2.게시판 정보 조회
        ResultModel<BbsManageVO> bbsInfo = bbsManageService.selectBbsDtl(bs);

        // 3.게시글 조회
        ResultModel<BbsLettManageVO> result = bbsManageService.selectBbsLettDtl(so);

        mav.setViewName("customer/update_view_bbs");
        mav.addObject("bbsInfo", bbsInfo);
        mav.addObject("leftMenu", leftMenu);
        mav.addObject("so", so);
        mav.addObject("resultModel", result);
        return mav;
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 17.
     * 작성자 : dong
     * 설명   : 게시글/답글 수정
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 17. dong - 최초생성
     * </pre>
     *
     * @param po
     * @param bindingResult
     * @return
     * @throws Exception
     */
    @RequestMapping("/letter-update")
    public @ResponseBody ResultModel<BbsLettManagePO> updateBbsLett(@Validated(UpdateGroup.class) BbsLettManagePO po,
                                                                    BindingResult bindingResult, HttpServletRequest request) throws Exception {

        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }

        ResultModel<BbsLettManagePO> result = new ResultModel<>();
        if (po.getRegrNo() == null) {
            result.setSuccess(false);
            result.setMessage(MessageUtil.getMessage("biz.exception.lng.loginRequired"));
            return result;
        }

        log.debug("====po.getGrpNo() : {}", po.getGrpNo());
        try {
            if (!"".equals(po.getGrpNo()) && po.getGrpNo() != null) {
                if (po.getGrpNo().equals(po.getLettNo())) {
                    result = bbsManageService.updateBbsLett(po, request); // 게시글 수정
                } else {
                    po.setReplyContent(po.getContent());
                    po.setReplyTitle(po.getTitle());
                    po.setReplyLettNo(po.getLettNo());
                    result = bbsManageService.updateBbsReply(po); // 답글 수정
                }
            } else {
                result = bbsManageService.updateBbsLett(po, request); // 게시글 수정
            }
        } catch (Exception e) {
            result.setMessage(e.getMessage());
        }

        return result;

    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 17.
     * 작성자 : dong
     * 설명   : 게시글 삭제
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 17. dong - 최초생성
     * </pre>
     *
     * @param po
     * @param bindingResult
     * @return
     * @throws Exception
     */
    @RequestMapping("/letter-delete")
    public @ResponseBody ResultModel<BbsLettManagePO> deleteBbsLett(@Validated(DeleteGroup.class) BbsLettManagePO po,
                                                                    BindingResult bindingResult) throws Exception {
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }

        ResultModel<BbsLettManagePO> result = new ResultModel<>();

        if (po.getRegrNo() == null) {
            result.setSuccess(false);
            result.setMessage(MessageUtil.getMessage("biz.exception.lng.loginRequired"));
            return result;
        }

        result = bbsManageService.deleteBbsLett(po);

        return result;
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 17.
     * 작성자 : dong
     * 설명   : 게시글 코멘트 등록
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 17. dong - 최초생성
     * </pre>
     *
     * @param po
     * @param bindingResult
     * @return
     * @throws Exception
     */
    @RequestMapping("/lettter-comment-insert")
    public @ResponseBody ResultModel<BbsCmntManagePO> insertBbsComment(@Validated(InsertGroup.class) BbsCmntManagePO po,
                                                                       BindingResult bindingResult) throws Exception {
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }
        ResultModel<BbsCmntManagePO> result = new ResultModel<>();

        if (po.getRegrNo() == null) {
            result.setSuccess(false);
            result.setMessage(MessageUtil.getMessage("biz.exception.lng.loginRequired"));
            return result;
        }
        result = bbsManageService.insertBbsComment(po);

        return result;
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 17.
     * 작성자 : dong
     * 설명   : 게시글 코멘트 삭제
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 17. dong - 최초생성
     * </pre>
     *
     * @param po
     * @param bindingResult
     * @return
     * @throws Exception
     */
    @RequestMapping("/letter-comment-delete")
    public @ResponseBody ResultModel<BbsCmntManagePO> deleteBbsComment(@Validated(DeleteGroup.class) BbsCmntManagePO po,
                                                                       BindingResult bindingResult) throws Exception {
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }

        ResultModel<BbsCmntManagePO> result = new ResultModel<>();

        if (po.getRegrNo() == null) {
            result.setSuccess(false);
            result.setMessage(MessageUtil.getMessage("biz.exception.lng.loginRequired"));
            return result;
        }

        result = bbsManageService.deleteBbsComment(po);

        return result;
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 20.
     * 작성자 : dong
     * 설명   : 게시글 비밀번호 설정 여부 확인
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 20. dong - 최초생성
     * </pre>
     *
     * @param so
     * @param bindingResult
     * @return
     * @throws Exception
     */
    @RequestMapping("/check-password-use")
    public @ResponseBody Boolean checkBbsLettPwdYn(@Validated BbsLettManageSO so, BindingResult bindingResult)
            throws Exception {
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }

        Boolean result = false;
        ResultModel<BbsLettManageVO> resultModel = bbsManageService.selectBbsLettDtl(so);
        String pwdYn = resultModel.getData().getSectYn();
        if ("Y".equals(pwdYn)) {
            result = true;
        }

        return result;
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 17.
     * 작성자 : dong
     * 설명   : 게시글 비밀번호 확인
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 17. dong - 최초생성
     * </pre>
     *
     * @param so
     * @param bindingResult
     * @return Boolean
     * @throws Exception
     */
    @RequestMapping("/check-letter-password")
    public @ResponseBody Boolean checkBbsLettPwd(@Validated BbsLettManageSO so, BindingResult bindingResult)
            throws Exception {
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }

        Boolean result = false;
        ResultModel<BbsLettManageVO> resultModel = bbsManageService.selectBbsLettDtl(so);
        String pwd = so.getPw();// CryptoUtil.encryptSHA256(so.getPw()); // 암호화
        if (pwd.equals(resultModel.getData().getPw())) {
            result = true;
        }

        return result;
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 25.
     * 작성자 : dong
     * 설명   : 캡챠코드를 생성한다
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 25. dong - 최초생성
     * </pre>
     *
     * @throws Exception
     */
    @RequestMapping("/capchacode-create")
    public String createCaptchaCode() throws Exception {
        CaptchaServletUtil.writeImage(HttpUtil.getHttpServletResponse(),
                CaptchaUtil.createCaptchaImg(HttpUtil.getHttpServletRequest()).getImage());
        return CommonConstants.VOID_VIEW_NAME;
    }

    /**
     * <pre>
     * 작성일 : 2016. 6. 2.
     * 작성자 : dong
     * 설명   : 첨부 파일을 삭제한다.
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 2. dong - 최초생성
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
