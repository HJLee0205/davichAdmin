package net.danvi.dmall.front.web.view.question.controller;

import javax.annotation.Resource;

import net.danvi.dmall.biz.app.operation.model.BbsLettManagePO;
import net.danvi.dmall.biz.app.operation.model.BbsLettManageSO;
import net.danvi.dmall.biz.app.setup.term.model.TermConfigSO;
import net.danvi.dmall.biz.app.setup.term.service.TermConfigService;
import net.danvi.dmall.biz.system.security.SessionDetailHelper;
import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import lombok.extern.slf4j.Slf4j;
import net.danvi.dmall.biz.app.operation.model.BbsLettManageVO;
import net.danvi.dmall.biz.app.operation.service.BbsManageService;
import net.danvi.dmall.biz.system.validation.DeleteGroup;
import net.danvi.dmall.biz.system.validation.UpdateGroup;
import dmall.framework.common.exception.JsonValidationException;
import dmall.framework.common.model.ResultListModel;
import dmall.framework.common.model.ResultModel;
import dmall.framework.common.util.HttpUtil;
import dmall.framework.common.util.MessageUtil;
import dmall.framework.common.util.SiteUtil;

/**
 * <pre>
 * - 프로젝트명    : 31.front.web
 * - 패키지명      : front.web.view.inquiry.controller
 * - 파일명        : QuestionController.java
 * - 작성일        : 2016. 5. 2.
 * - 작성자        : dong
 * - 설명          : 상품문의 Controller
 * </pre>
 */
@Slf4j
@Controller
@RequestMapping("/front/question")
public class QuestionController {

    @Resource(name = "bbsManageService")
    private BbsManageService bbsManageService;

    @Resource(name = "termConfigService")
    private TermConfigService termConfigService;

    /**
     * <pre>
     * 작성일 : 2016. 5. 11.
     * 작성자 : dong
     * 설명   : 상품문의 목록조회
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 11. dong - 최초생성
     * </pre>
     */
    @RequestMapping("/question-list")
    public ModelAndView viewBbsListPaging(@Validated BbsLettManageSO so, BindingResult bindingResult) {
        ModelAndView mv = SiteUtil.getSkinView("/mypage/question_list");

        // 로그인여부 체크
        if (!SessionDetailHelper.getDetails().isLogin()) {
            mv.addObject("exMsg", MessageUtil.getMessage("biz.exception.lng.loginRequired"));
            mv.setViewName("/error/notice");
            return mv;
        }

        so.setBbsId("question");
        so.setExpsYn("Y"); // 노출여부
        mv.addObject(so);
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            return mv;
        }

        log.debug("so.getSearchKind() : " + so.getSearchKind());
        log.debug("so.getSearchVal() : " + so.getSearchVal());
        mv.addObject("so", so);
        mv.addObject("leftMenu", "question");
        so.setMemberNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
        mv.addObject("resultListModel", bbsManageService.selectBbsLettPaging(so));
        
        // 모바일 추가
        if(SiteUtil.isMobile()) {
            BbsLettManageSO mso = new BbsLettManageSO();
            mso.setBbsId("question");
            mso.setMemberNo(0);
            mso.setMobileYn("Y");
            ResultListModel<BbsLettManageVO> replyList = bbsManageService.selectBbsLettPaging(mso);
            mv.addObject("replyList", replyList);
        }
        return mv;
    }

    // 2016.08.29 - 모바일
    // 마이페이지 상품문의 페이징 ajax
    @RequestMapping("/question-pagnig")
    public ModelAndView viewListPaging(@Validated BbsLettManageSO so, BbsLettManageSO mso,
                                       BindingResult bindingResult) {
        ModelAndView mv = new ModelAndView("/mypage/ajaxQuestionList");
        so.setBbsId("question");
        so.setExpsYn("Y");
        mv.addObject(so);
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            return mv;
        }

        log.debug("so.getSearchKind() : " + so.getSearchKind());
        log.debug("so.getSearchVal() : " + so.getSearchVal());
        mv.addObject("so", so);
        mv.addObject("leftMenu", "question");
        so.setMemberNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
        mv.addObject("resultListModel", bbsManageService.selectBbsLettPaging(so));

        // 모바일 추가
        mso.setBbsId("question");
        mso.setExpsYn("Y");
        mso.setMobileYn("Y");
        mso.setMemberNo(0);
        mv.addObject("replyList", bbsManageService.selectBbsLettPaging(mso));
        //
        return mv;
    }

    @RequestMapping(value = "/question-list-ajax")
    public ModelAndView ajaxQuestionList(@Validated BbsLettManageSO so, BindingResult bindingResult) throws Exception {
        ModelAndView mv = SiteUtil.getSkinView("/goods/goods_info_03");
        so.setBbsId("question");
        so.setExpsYn("Y"); // 노출여부
        mv.addObject(so);
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            return mv;
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
        mv.addObject("questionList", bbsManageService.selectBbsLettPaging(so));

         // 모바일 추가
        so.setMobileYn("Y");// 모바일 여부
        mv.addObject("replyList", bbsManageService.selectBbsLettPaging(so));

        return mv;
    }

    // 2016.08.29 - 모바일
    // 상품문의 리스트_ajax
    @RequestMapping(value = "/ajax-question-paging")
    public ModelAndView ajaxQuestionPage(@Validated BbsLettManageSO so, BbsLettManageSO mso,
                                         BindingResult bindingResult) {
        ModelAndView mv = new ModelAndView("/goods/ajaxQuestionList");
        so.setBbsId("question");
        so.setExpsYn("Y");
        mv.addObject(so);
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            return mv;
        }
        mv.addObject("so", so);
        mv.addObject("questionList", bbsManageService.selectBbsLettPaging(so));

        // 모바일 추가
        mso.setBbsId("question");
        mso.setExpsYn("Y"); // 노출여부
        mso.setMobileYn("Y");// 모바일 여부
        mv.addObject("mso", mso);
        mv.addObject("replyList", bbsManageService.selectBbsLettPaging(mso));
        //
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
    @RequestMapping(value = "/question-detail")
    public @ResponseBody ResultModel<BbsLettManageVO> selectQuestion(@Validated BbsLettManageSO so,
            BindingResult bindingResult) throws Exception {
        so.setBbsId("question");
        ResultModel<BbsLettManageVO> result = new ResultModel<>();
        result = bbsManageService.selectBbsLettDtl(so);
        return result;
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 11.
     * 작성자 : dong
     * 설명   : 상품문의 등록
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 11. dong - 최초생성
     * </pre>
     */
    @RequestMapping("/question-insert")
    public @ResponseBody ResultModel insertQuestion(@Validated BbsLettManagePO po, BindingResult bindingResult)
            throws Exception {
        ResultModel<BbsLettManagePO> result = new ResultModel<>();
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }

        if (!SessionDetailHelper.getDetails().isLogin()) {
            result.setSuccess(false);
            result.setMessage(MessageUtil.getMessage("biz.exception.lng.loginRequired"));
            return result;
        }

        po.setBbsId("question");
        po.setMemberNo(po.getRegrNo());
        result = bbsManageService.insertBbsLett(po, HttpUtil.getHttpServletRequest());
        return result;
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 18.
     * 작성자 : dong
     * 설명 : 상품문의 수정
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 18. dong - 최초생성
     */
    @RequestMapping("/question-update")
    public @ResponseBody ResultModel updateQuestion(@Validated(UpdateGroup.class) BbsLettManagePO po,
            BindingResult bindingResult) throws Exception {
        ResultModel<BbsLettManagePO> result = new ResultModel<>();
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }
        result = bbsManageService.updateBbsLett(po, HttpUtil.getHttpServletRequest());
        return result;
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 18.
     * 작성자 : dong
     * 설명 : 상품문의 삭제
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 18. dong - 최초생성
     */
    @RequestMapping("/question-delete")
    public @ResponseBody ResultModel deleteQuestion(@Validated(DeleteGroup.class) BbsLettManagePO po,
            BindingResult bindingResult) throws Exception {
        ResultModel<BbsLettManagePO> result = new ResultModel<>();
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }
        result = bbsManageService.deleteBbsLett(po);
        return result;
    }

}