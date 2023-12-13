package net.danvi.dmall.admin.web.view.board.controller;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import dmall.framework.admin.constants.AdminConstants;
import dmall.framework.common.constants.RequestAttributeConstants;
import dmall.framework.common.model.FileVO;
import dmall.framework.common.model.FileViewParam;
import dmall.framework.common.util.FileUtil;
import dmall.framework.common.util.HttpUtil;
import dmall.framework.common.view.View;
import net.danvi.dmall.biz.common.model.FileDownloadSO;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.validation.BindingResult;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import lombok.extern.slf4j.Slf4j;
import net.danvi.dmall.biz.app.operation.model.AtchFilePO;
import net.danvi.dmall.biz.app.board.model.BbsCmntManagePO;
import net.danvi.dmall.biz.app.board.model.BbsCmntManageSO;
import net.danvi.dmall.biz.app.board.model.BbsCmntManageVO;
import net.danvi.dmall.biz.app.board.model.BbsLettManagePO;
import net.danvi.dmall.biz.app.board.model.BbsLettManageSO;
import net.danvi.dmall.biz.app.board.model.BbsLettManageVO;
import net.danvi.dmall.biz.app.board.model.BbsManagePO;
import net.danvi.dmall.biz.app.board.model.BbsManageSO;
import net.danvi.dmall.biz.app.board.model.BbsManageVO;
import net.danvi.dmall.biz.app.board.model.BbsTitleManagePO;
import net.danvi.dmall.biz.app.board.service.BbsManageService;
import net.danvi.dmall.biz.common.service.BizService;
import net.danvi.dmall.biz.system.security.SessionDetailHelper;
import net.danvi.dmall.biz.system.service.SiteQuotaService;
import net.danvi.dmall.biz.system.validation.DeleteGroup;
import net.danvi.dmall.biz.system.validation.InsertGroup;
import net.danvi.dmall.biz.system.validation.UpdateGroup;
import dmall.framework.common.constants.UploadConstants;
import dmall.framework.common.exception.JsonValidationException;
import dmall.framework.common.model.ResultListModel;
import dmall.framework.common.model.ResultModel;
import dmall.framework.common.util.StringUtil;

/**
 * <pre>
 * 프로젝트명 : 41.admin.web
 * 작성일     : 2016. 4. 29.
 * 작성자     : dong
 * 설명       : 게시판 컨트롤러
 * </pre>
 */

@Slf4j
@Controller
@RequestMapping("/admin/board")
public class BbsManageController {
    @Resource(name = "bizService")
    private BizService bizService;

    @Resource(name = "siteQuotaService")
    private SiteQuotaService siteQuotaService;

    @Resource(name = "bbsManageService")
    private BbsManageService bbsManageService;

    /**
     * <pre>
     * 작성일 : 2016. 5. 18.
     * 작성자 : dong
     * 설명   : 게시판 목록 화면
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 18. dong - 최초생성
     * </pre>
     *
     * @return
     */
    @RequestMapping("/board")
    public ModelAndView viewBbsList() {
        ModelAndView mv = new ModelAndView("admin/board/BbsList");
        boolean isBbsAddible = siteQuotaService.isBbsAddible(SessionDetailHelper.getDetails().getSiteNo());
        mv.addObject("isBbsAddible", isBbsAddible);
        return mv;
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 4.
     * 작성자 : dong
     * 설명   : 검색조건에 따른 게시판 목록을 조회 함수
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 4. dong - 최초생성
     * </pre>
     *
     * @param so
     * @return
     */

    @RequestMapping("/board-list")
    public @ResponseBody ResultListModel<BbsManageVO> selectBbsListPaging(BbsManageSO so) {
        so.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
        ResultListModel<BbsManageVO> resultListModel = bbsManageService.selectBbsListPaging(so);

        return resultListModel;
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 18.
     * 작성자 : dong
     * 설명   : 게시판 조회 함수
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 18. dong - 최초생성
     * </pre>
     *
     * @param so
     * @return
     * @throws Exception
     */
    @RequestMapping("/board-detail")
    public @ResponseBody ResultModel<BbsManageVO> selectBbsDtl(BbsManageSO so) throws Exception {
        ResultModel<BbsManageVO> resultModel = bbsManageService.selectBbsDtl(so);
        return resultModel;
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 4.
     * 작성자 : dong
     * 설명   : 게시판 등록 화면
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 4. dong - 최초생성
     * </pre>
     *
     * @param so
     * @return
     */
    @RequestMapping("/board-insert-form")
    public ModelAndView viewBbsInsert(BbsManageSO so) {
        ModelAndView mv = new ModelAndView("admin/board/BbsInsert");
        mv.addObject("so", so);
        return mv;
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 4.
     * 작성자 : dong
     * 설명   : 게시판을 등록 함수
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 4. dong - 최초생성
     * </pre>
     *
     * @param po
     * @param bindingResult
     * @return
     * @throws Exception
     */
    @RequestMapping("/board-insert")
    public @ResponseBody ResultModel<BbsManagePO> insertBbs(@Validated(InsertGroup.class) BbsManagePO po,
            BindingResult bindingResult) throws Exception {
        HttpServletRequest request = HttpUtil.getHttpServletRequest();
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }
        po.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
        if (SessionDetailHelper.getDetails().getSession().getMemberNo() != null) {
            po.setRegrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
        }

        po.setTopHtmlSet(StringUtil.replaceAll(po.getTopHtmlSet(), (String) request.getAttribute(RequestAttributeConstants.IMAGE_DOMAIN),""));
        po.setTopHtmlSet(StringUtil.replaceAll(po.getTopHtmlSet(), UploadConstants.IMAGE_TEMP_EDITOR_URL,UploadConstants.IMAGE_EDITOR_URL));
        po.setBottomHtmlSet(StringUtil.replaceAll(po.getBottomHtmlSet(), (String) request.getAttribute(RequestAttributeConstants.IMAGE_DOMAIN),""));
        po.setBottomHtmlSet(StringUtil.replaceAll(po.getBottomHtmlSet(), UploadConstants.IMAGE_TEMP_EDITOR_URL,UploadConstants.IMAGE_EDITOR_URL));

        ResultModel<BbsManagePO> result = bbsManageService.insertBbs(po);

        return result;
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 4.
     * 작성자 : dong
     * 설명   : 게시판 수정 화면
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 4. dong - 최초생성
     * </pre>
     *
     * @param so
     * @return
     */
    @RequestMapping("/board-update-form")
    public ModelAndView viewBbsUpdate(BbsManageSO so) {
        so.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
        ModelAndView mv = new ModelAndView("admin/board/BbsUpdate");
        mv.addObject("so", so);
        return mv;
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 4.
     * 작성자 : dong
     * 설명   : 게시판을 수정한다
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 4. dong - 최초생성
     * </pre>
     *
     * @param po
     * @param bindingResult
     * @return
     * @throws Exception
     */
    @RequestMapping("/board-update")
    public @ResponseBody ResultModel<BbsManagePO> updateBbs(@Validated(UpdateGroup.class) BbsManagePO po,
            BindingResult bindingResult) throws Exception {
        HttpServletRequest request = HttpUtil.getHttpServletRequest();
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }
        po.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
        if (SessionDetailHelper.getDetails().getSession().getMemberNo() != null) {
            po.setRegrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
            po.setUpdrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
        }
        po.setTopHtmlSet(StringUtil.replaceAll(po.getTopHtmlSet(), (String) request.getAttribute(RequestAttributeConstants.IMAGE_DOMAIN),""));
        po.setTopHtmlSet(StringUtil.replaceAll(po.getTopHtmlSet(), UploadConstants.IMAGE_TEMP_EDITOR_URL,UploadConstants.IMAGE_EDITOR_URL));
        po.setBottomHtmlSet(StringUtil.replaceAll(po.getBottomHtmlSet(), (String) request.getAttribute(RequestAttributeConstants.IMAGE_DOMAIN),""));
        po.setBottomHtmlSet(StringUtil.replaceAll(po.getBottomHtmlSet(), UploadConstants.IMAGE_TEMP_EDITOR_URL,UploadConstants.IMAGE_EDITOR_URL));

        ResultModel<BbsManagePO> result = bbsManageService.updateBbs(po);

        return result;
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 18.
     * 작성자 : dong
     * 설명   : 게시글 목록 화면
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 18. dong - 최초생성
     * </pre>
     *
     * @param so
     * @return
     */
    @RequestMapping("/letter")
    public ModelAndView viewBbsLettList(BbsManageSO so) {
        String bbsId = so.getBbsId();
        String viewPage = "";

        switch(bbsId) {
            case "vote":
                viewPage = "/admin/board/styleVote/StyleVoteList";
                break;
            case "pick":
                viewPage ="/admin/board/stylePick/StylePickList";
                break;
            case "collection":
                viewPage = "/admin/board/collection/CollectionList";
                break;
            case "faq":
                viewPage = "/admin/board/faq/FaqList";
                break;
            case "partnership":
                viewPage = "/admin/board/partnership/PartnershipList";
                break;
            case "inquiry":
                viewPage = "/admin/board/inquiry/InquiryList";
                break;
            case "notice":
                viewPage = "/admin/board/notice/NoticeList";
                break;
            case "magazine":
                viewPage = "/admin/board/magazine/MagazineList";
                break;
            case "eyetest":
                viewPage = "/admin/board/inspection/InspectionList";
                break;
            default:
                viewPage = "/admin/board/LettList";
                break;
        }
        so.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
        ModelAndView mv = new ModelAndView(viewPage);
        mv.addObject("so", so);

        return mv;
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 4.
     * 작성자 : dong
     * 설명   : 게시글 리스트를 조회 함수
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 4. dong - 최초생성
     * </pre>
     *
     * @param so
     * @return
     */
    @RequestMapping("/board-letter-list")
    public @ResponseBody ResultListModel<BbsLettManageVO> selectBbsLettListPaging(BbsLettManageSO so) {
        so.setPageGb("admin");
        ResultListModel<BbsLettManageVO> resultListModel = bbsManageService.selectBbsLettPaging(so);
        return resultListModel;
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 4.
     * 작성자 : dong
     * 설명   : 게시글 보기 화면
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 4. dong - 최초생성
     * </pre>
     *
     * @param so
     * @return
     */
    @RequestMapping("/letter-detail")
    public ModelAndView viewBbsLettDtl(BbsLettManageSO so) {
        String bbsId = so.getBbsId();
        String viewPage = "";
        if (bbsId.equals("inquiry") || bbsId.equals("sellQuestion")) {
            viewPage = "/admin/board/inquiry/InquiryView";
        } else if (bbsId.equals("faq")) {
            viewPage = "/admin/board/faq/FaqView";
        } else if (bbsId.equals("notice")) {
            viewPage = "/admin/board/notice/NoticeView";
        } else if (bbsId.equals("vote")) {
            viewPage = "/admin/board/styleVote/StyleVoteView";
        } else if (bbsId.equals("pick")) {
            viewPage = "/admin/board/stylePick/StylePickView";
        } else if (bbsId.equals("eyetest")) {
            viewPage = "/admin/board/inspection/InspectionView";
        }
        ModelAndView mv = new ModelAndView(viewPage);
        mv.addObject("so", so);
        mv.addObject("memberNo", SessionDetailHelper.getDetails().getSession().getMemberNo());
        return mv;
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 18.
     * 작성자 : dong
     * 설명   : 게시글 조회 함수
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 18. dong - 최초생성
     * </pre>
     *
     * @param so
     * @return
     * @throws Exception
     */
    @RequestMapping("/board-letter-detail")
    public @ResponseBody ResultModel<BbsLettManageVO> selectBbsLettDtl(BbsLettManageSO so) throws Exception {
        so.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
        ResultModel<BbsLettManageVO> resultModel = bbsManageService.selectBbsLettDtl(so);
        return resultModel;
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 4.
     * 작성자 : dong
     * 설명   : 게시글 등록 화면
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 4. dong - 최초생성
     * </pre>
     *
     * @param so
     * @return
     */
    @RequestMapping("/letter-insert-form")
    public ModelAndView viewBbsLettInsert(@Validated BbsLettManageSO so) {
        String bbsId = so.getBbsId();
        String viewPage = "";
        if (bbsId.equals("inquiry") || bbsId.equals("sellQuestion")) {
            viewPage = "/admin/board/inquiry/InquiryInsert";
        } else if (bbsId.equals("faq")) {
            viewPage = "/admin/board/faq/FaqInsert";
        } else if (bbsId.equals("notice")) {
            viewPage = "/admin/board/notice/NoticeInsert";
        } else if (bbsId.equals("pick")){
            viewPage = "/admin/board/stylePick/StylePickInsert";
        } else if (bbsId.equals("collection")) {
            viewPage = "/admin/board/collection/CollectionInsert";
            String newLettNo = bbsManageService.selectNewLettNo(so.getBbsId());
            so.setLettNo(newLettNo);
        } else if (bbsId.equals("eyetest")) {
            viewPage = "/admin/board/inspection/InspectionInsert";
        } else {
            viewPage = "/admin/board/LettInsert";
        }
        ModelAndView mv = new ModelAndView(viewPage);
        mv.addObject("so", so);
        mv.addObject("memberNo", SessionDetailHelper.getDetails().getSession().getMemberNo());
        mv.addObject("siteNo", SessionDetailHelper.getDetails().getSiteNo());

        return mv;
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 4.
     * 작성자 : dong
     * 설명   : 게시글을 등록한다
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 4. dong - 최초생성
     * </pre>
     *
     * @param po
     * @param bindingResult
     * @return
     * @throws Exception
     */
    @RequestMapping("/board-letter-insert")
    public @ResponseBody ResultModel<BbsLettManagePO> insertBbsLett(@Validated(InsertGroup.class) BbsLettManagePO po,
            BindingResult bindingResult, HttpServletRequest request) throws Exception {
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }
        if (SessionDetailHelper.getDetails().getSession().getMemberNo() != null) {
            po.setRegrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
        } else {

        }
        ResultModel<BbsLettManagePO> result = bbsManageService.insertBbsLett(po, request);

        return result;
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 4.
     * 작성자 : dong
     * 설명   : 게시글 수정 화면
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 4. dong - 최초생성
     * </pre>
     *
     * @param so
     * @return
     */
    @RequestMapping("/letter-update-form")
    public ModelAndView viewBbsLettUpdate(BbsLettManageSO so) {
        String bbsId = so.getBbsId();
        String viewPage = "";
        if (bbsId.equals("inquiry") || bbsId.equals("sellQuestion")) {
            viewPage = "/admin/board/inquiry/InquiryReplyInsert";
        } else if (bbsId.equals("faq")) {
            viewPage = "/admin/board/faq/FaqUpdate";
        } else if (bbsId.equals("notice")) {
            viewPage = "/admin/board/notice/NoticeUpdate";
        } else if (bbsId.equals("pick")) {
            viewPage = "/admin/board/stylePick/StylePickUpdate";
        } else if (bbsId.equals("collection")) {
            viewPage = "/admin/board/collection/CollectionUpdate";
        } else if (bbsId.equals("eyetest")) {
            viewPage = "/admin/board/inspection/InspectionUpdate";
        } else {
            viewPage = "/admin/board/LettUpdate";
        }
        ModelAndView mv = new ModelAndView(viewPage);
        mv.addObject("so", so);
        mv.addObject("siteNo", SessionDetailHelper.getDetails().getSiteNo());
        return mv;
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 4.
     * 작성자 : dong
     * 설명   : 게시글을 수정한다
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 4. dong - 최초생성
     * </pre>
     *
     * @param po
     * @param bindingResult
     * @return
     * @throws Exception
     */
    @RequestMapping("/board-letter-update")
    public @ResponseBody ResultModel<BbsLettManagePO> updateBbsLett(@Validated(UpdateGroup.class) BbsLettManagePO po,
            BindingResult bindingResult, HttpServletRequest request) throws Exception {
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }
        po.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());

        po.setContent(StringUtil.replaceAll(po.getContent(), (String) request.getAttribute(RequestAttributeConstants.IMAGE_DOMAIN),""));
        po.setContent(StringUtil.replaceAll(po.getContent(), UploadConstants.IMAGE_TEMP_EDITOR_URL,UploadConstants.IMAGE_EDITOR_URL));


        if (SessionDetailHelper.getDetails().getSession().getMemberNo() != null) {
            po.setUpdrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
        } else {

        }
        ResultModel<BbsLettManagePO> result = bbsManageService.updateBbsLett(po, request);

        return result;
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 4.
     * 작성자 : dong
     * 설명   : 게시글을 삭제한다
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 4. dong - 최초생성
     * </pre>
     *
     * @param po
     * @param bindingResult
     * @return
     * @throws Exception
     */
    @RequestMapping("/board-letter-delete")
    public @ResponseBody ResultModel<BbsLettManagePO> deleteBbsLett(@Validated(DeleteGroup.class) BbsLettManagePO po,
            BindingResult bindingResult) throws Exception {
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }

        if (SessionDetailHelper.getDetails().getSession().getMemberNo() != null) {
            po.setDelrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
            po.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
        }
        ResultModel<BbsLettManagePO> result = bbsManageService.deleteBbsLett(po);

        return result;
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 18.
     * 작성자 : dong
     * 설명   : 게시글 선택 삭제 함수
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 18. dong - 최초생성
     * </pre>
     *
     * @param so
     * @return
     * @throws Exception
     */
    @RequestMapping("/deleteSelectBbsLett.do")
    public @ResponseBody ResultModel<BbsLettManagePO> deleteSelectBbsLett(BbsLettManageSO so) throws Exception {
        String[] selectLettNoList = so.getDelLettNo();
        ResultModel<BbsLettManagePO> result = null;
        for (int i = 0; i < selectLettNoList.length; i++) {
            BbsLettManagePO po = new BbsLettManagePO();
            po.setLettNo(selectLettNoList[i]);
            po.setBbsId(so.getBbsId());
            if (SessionDetailHelper.getDetails().getSession().getMemberNo() != null) {
                po.setDelrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
                po.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
            }
            result = bbsManageService.deleteBbsLett(po);
        }

        return result;
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 4.
     * 작성자 : dong
     * 설명   : 노출, 비노출 변경
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 4. dong - 최초생성
     * </pre>
     *
     * @param so
     * @return
     * @throws Exception
     */
    @RequestMapping("/board-letterexpose-update")
    public @ResponseBody ResultModel<BbsLettManagePO> updateBbsLettExpsYn(BbsLettManageSO so) throws Exception {
        String[] selectLettNoList = so.getDelLettNo();
        ResultModel<BbsLettManagePO> result = null;
        for (int i = 0; i < selectLettNoList.length; i++) {
            BbsLettManagePO po = new BbsLettManagePO();
            po.setLettNo(selectLettNoList[i]);
            po.setBbsId(so.getBbsId());
            po.setExpsYn(so.getExpsYn());
            if (SessionDetailHelper.getDetails().getSession().getMemberNo() != null) {
                po.setUpdrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
                po.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
            }
            result = bbsManageService.updateBbsLettExpsYn(po);
        }
        return result;
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 4.
     * 작성자 : dong
     * 설명   : 게시글 조회수 업데이트
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 4. dong - 최초생성
     * </pre>
     *
     * @param po
     * @param bindingResult
     * @return
     * @throws Exception
     */
    @RequestMapping("/letter-count-update")
    public @ResponseBody ResultModel<BbsLettManagePO> updateInqCnt(@Validated(UpdateGroup.class) BbsLettManagePO po,
            BindingResult bindingResult) throws Exception {
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }
        ResultModel<BbsLettManagePO> result = bbsManageService.updateInqCnt(po);

        return result;
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 4.
     * 작성자 : dong
     * 설명   : 게시글 답변 화면
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 4. dong - 최초생성
     * </pre>
     *
     * @param so
     * @return
     */
    @RequestMapping("/letter-reply-form")
    public ModelAndView viewBbsLettReplyInsert(BbsLettManageSO so) {
        String bbsId = so.getBbsId();
        String viewPage = "";
        if (bbsId.equals("inquiry") || bbsId.equals("sellQuestion")) {
            viewPage = "/admin/board/inquiry/InquiryReplyInsert";
        } else if (bbsId.equals("faq")) {
            viewPage = "/admin/board/faq/FaqReplyInsert";
        } else {
            viewPage = "/admin/board/LettReplyInsert";
        }
        ModelAndView mv = new ModelAndView(viewPage);
        mv.addObject("so", so);
        mv.addObject("siteNo", SessionDetailHelper.getDetails().getSiteNo());
        mv.addObject("memberNo", SessionDetailHelper.getDetails().getSession().getMemberNo());
        return mv;
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 4.
     * 작성자 : dong
     * 설명   : 답변을 등록한다
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 4. dong - 최초생성
     * </pre>
     *
     * @param po
     * @return
     * @throws Exception
     */
    @RequestMapping("/board-reply-insert")
    public @ResponseBody ResultModel<BbsLettManagePO> insertBbsReply(BbsLettManagePO po) throws Exception {
        ResultModel<BbsLettManagePO> result = null;
        if (po.getReplyLettNo() == null || po.getReplyLettNo().equals("")) {
            result = bbsManageService.insertBbsReply(po);
        } else {
            result = bbsManageService.updateBbsReply(po);
        }

        return result;
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 4.
     * 작성자 : dong
     * 설명   : 답변을 수정한다
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 4. dong - 최초생성
     * </pre>
     *
     * @param po
     * @param bindingResult
     * @return
     * @throws Exception
     */
    @RequestMapping("/board-reply-update")
    public @ResponseBody ResultModel<BbsLettManagePO> updateBbsReply(@Validated(UpdateGroup.class) BbsLettManagePO po,
            BindingResult bindingResult) throws Exception {
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }

        ResultModel<BbsLettManagePO> result = bbsManageService.updateBbsReply(po);

        return result;
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 4.
     * 작성자 : dong
     * 설명   : 답변을 삭제한다
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 4. dong - 최초생성
     * </pre>
     *
     * @param po
     * @param bindingResult
     * @return
     * @throws Exception
     */
    @RequestMapping("/board-reply-delete")
    public @ResponseBody ResultModel<BbsLettManagePO> deleteBbsReply(@Validated(DeleteGroup.class) BbsLettManagePO po,
            BindingResult bindingResult) throws Exception {
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }

        ResultModel<BbsLettManagePO> result = bbsManageService.deleteBbsReply(po);

        return result;
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 18.
     * 작성자 : dong
     * 설명   : 게시글 댓글 목록 조회 함수
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 18. dong - 최초생성
     * </pre>
     *
     * @param so
     * @return
     */
    @RequestMapping("/board-comment-list")
    public @ResponseBody ResultListModel<BbsCmntManageVO> selectBbsCmntList(BbsCmntManageSO so) {
        ResultListModel<BbsCmntManageVO> result = bbsManageService.selectBbsCmntList(so);
        return result;
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 4.
     * 작성자 : dong
     * 설명   : 댓글을 등록한다
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 4. dong - 최초생성
     * </pre>
     *
     * @param po
     * @param bindingResult
     * @return
     * @throws Exception
     */
    @RequestMapping("/board-comment-insert")
    public @ResponseBody ResultModel<BbsCmntManagePO> insertBbsComment(@Validated(InsertGroup.class) BbsCmntManagePO po,
            BindingResult bindingResult) throws Exception {
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }
        po.setRegrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
        ResultModel<BbsCmntManagePO> result = bbsManageService.insertBbsComment(po);

        return result;
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 4.
     * 작성자 : dong
     * 설명   : 댓글을 삭제한다
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 4. dong - 최초생성
     * </pre>
     *
     * @param po
     * @param bindingResult
     * @return
     * @throws Exception
     */
    @RequestMapping("/board-comment-delete")
    public @ResponseBody ResultModel<BbsCmntManagePO> deleteBbsComment(@Validated(DeleteGroup.class) BbsCmntManagePO po,
            BindingResult bindingResult) throws Exception {
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }

        ResultModel<BbsCmntManagePO> result = bbsManageService.deleteBbsComment(po);

        return result;
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 4.
     * 작성자 : dong
     * 설명   : 게시판 말머리 목록을 조회한다
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 4. dong - 최초생성
     * </pre>
     *
     * @param so
     * @return
     */
    @RequestMapping("/board-title-list")
    public @ResponseBody ResultListModel<BbsManageVO> selectBbsTitleList(BbsManageSO so) {
        ResultListModel<BbsManageVO> result = bbsManageService.selectBbsTitleList(so);
        return result;
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 4.
     * 작성자 : dong
     * 설명   : 게시판 말머리를 등록한다
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 4. dong - 최초생성
     * </pre>
     *
     * @param po
     * @param bindingResult
     * @return
     * @throws Exception
     */
    @RequestMapping("/board-title-insert")
    public @ResponseBody ResultModel<BbsManagePO> insertBbsTitle(@Validated(InsertGroup.class) BbsManagePO po,
            BindingResult bindingResult) throws Exception {
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }
        po.setRegrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
        ResultModel<BbsManagePO> result = bbsManageService.insertBbsTitle(po);

        return result;
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 4.
     * 작성자 : dong
     * 설명   : 게시판 말머리를 삭제한다
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 4. dong - 최초생성
     * </pre>
     *
     * @param po
     * @param bindingResult
     * @return
     * @throws Exception
     */
    @RequestMapping("/baord-title-delete")
    public @ResponseBody ResultModel<BbsTitleManagePO> deleteBbsTitle(@Validated(DeleteGroup.class) BbsTitleManagePO po,
            BindingResult bindingResult) throws Exception {
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }
        if (SessionDetailHelper.getDetails().getSession().getMemberNo() != null) {
            po.setDelrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
        }

        ResultModel<BbsTitleManagePO> result = bbsManageService.deleteBbsTitle(po);

        return result;
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 4.
     * 작성자 : dong
     * 설명   : 첨부 파일을 삭제한다
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 4. dong - 최초생성
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


    /**
     * <pre>
     * �옉�꽦�씪 : 2016. 5. 18.
     * �옉�꽦�옄 : dong
     * �꽕紐�   : 寃뚯떆湲� �꽑�깮 �궘�젣 �븿�닔
     *
     * �닔�젙�궡�뿭(�닔�젙�씪 �닔�젙�옄 - �닔�젙�궡�슜)
     * -------------------------------------------------------------------------
     * 2016. 5. 18. dong - 理쒖큹�깮�꽦
     * </pre>
     *
     * @param so
     * @return
     * @throws Exception
     */
    @RequestMapping("/board-checkedletter-delete")
    public @ResponseBody ResultModel<BbsLettManagePO> deleteCheckBbsLett(BbsLettManageSO so) throws Exception {
        String[] selectLettNoList = so.getDelLettNo();
        ResultModel<BbsLettManagePO> result = null;
        for (int i = 0; i < selectLettNoList.length; i++) {
            BbsLettManagePO po = new BbsLettManagePO();
            po.setLettNo(selectLettNoList[i]);
            po.setBbsId(so.getBbsId());
            if (SessionDetailHelper.getDetails().getSession().getMemberNo() != null) {
                po.setDelrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
                po.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
            }
            result = bbsManageService.deleteBbsLett(po);
        }

        return result;
    }

    @RequestMapping("/board-checkedcomment-delete")
    public @ResponseBody ResultModel<BbsCmntManagePO> deleteCheckBbsCmnt(BbsCmntManageSO so) throws Exception {
        String[] selectCmntSeqList = so.getDelCmntSeq();
        ResultModel<BbsCmntManagePO> result = null;
        for (int i = 0; i < selectCmntSeqList.length; i++) {
            BbsCmntManagePO param = new BbsCmntManagePO();
            param.setCmntSeq(selectCmntSeqList[i]);
            result = bbsManageService.deleteBbsComment(param);
        }
        return result;
    }

    @RequestMapping("/download")
    public String fileDownload(ModelMap map, AtchFilePO po) throws Exception {
        FileVO file = bbsManageService.selectAtchFileDtl(po);

        FileViewParam fileView = new FileViewParam();
        fileView.setFilePath(FileUtil.getAllowedFilePath(file.getFilePath()));
        fileView.setFileName(FileUtil.getAllowedFilePath(file.getFileOrgName()));

        map.put(AdminConstants.FILE_PARAM_NAME, fileView);

        return View.fileDownload();
    }
}
