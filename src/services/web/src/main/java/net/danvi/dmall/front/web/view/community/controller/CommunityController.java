package net.danvi.dmall.front.web.view.community.controller;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import net.danvi.dmall.biz.app.operation.service.BbsManageService;
import net.danvi.dmall.biz.system.security.SessionDetailHelper;
import net.danvi.dmall.biz.system.validation.DeleteGroup;
import net.danvi.dmall.biz.system.validation.InsertGroup;
import net.danvi.dmall.biz.system.validation.UpdateGroup;
import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import lombok.extern.slf4j.Slf4j;
import net.danvi.dmall.biz.app.operation.model.AtchFilePO;
import net.danvi.dmall.biz.app.operation.model.BbsCmntManagePO;
import net.danvi.dmall.biz.app.operation.model.BbsCmntManageSO;
import net.danvi.dmall.biz.app.operation.model.BbsCmntManageVO;
import net.danvi.dmall.biz.app.operation.model.BbsLettManagePO;
import net.danvi.dmall.biz.app.operation.model.BbsLettManageSO;
import net.danvi.dmall.biz.app.operation.model.BbsLettManageVO;
import net.danvi.dmall.biz.app.operation.model.BbsManageSO;
import net.danvi.dmall.biz.app.operation.model.BbsManageVO;
import nl.captcha.servlet.CaptchaServletUtil;
import dmall.framework.common.constants.CommonConstants;
import dmall.framework.common.exception.JsonValidationException;
import dmall.framework.common.model.ResultListModel;
import dmall.framework.common.model.ResultModel;
import dmall.framework.common.util.*;

/**
 * <pre>
 * 프로젝트명 : 31.front.web
 * 작성일     : 2016. 5. 17.
 * 작성자     : dong
 * 설명       : 커뮤니티 관리 컨트롤러
 * </pre>
 */
@Slf4j
@Controller
@RequestMapping("/front/community")
public class CommunityController {

    public static final String CAPTCHA_DATA = "CAPTCHA_DATA";

    @Resource(name = "bbsManageService")
    private BbsManageService bbsManageService;

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

        // LNB 가져오기
        ResultListModel<BbsManageVO> leftMenu = this.getCommunityMenu(bs);
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
            viewName = "community/bbs_list"; // 리스트형
            break;
        case "2":
            so.setRows(8);
            viewName = "community/bbs_gallery_list"; // 갤러리형
            break;
        case "3":
            viewName = "community/bbs_data_list"; // 자료실형
            break;
        }

        // 5.게시글 목록 조회
        String noticeLettSetCd = bbsInfo.getData().getNoticeLettSetYn();
        if ("Y".equals(noticeLettSetCd)) {
            so.setNoticeYn("N");
        }
        ResultListModel<BbsLettManageVO> resultListModel = bbsManageService.selectBbsLettPaging(so);

        mav.setViewName(viewName);
        mav.addObject("so", so);
        mav.addObject("bs", bs);
        mav.addObject("bbsInfo", bbsInfo);
        mav.addObject("leftMenu", leftMenu);
        mav.addObject("resultListModel", resultListModel);

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

        BbsManageSO bs = new BbsManageSO();
        bs.setSiteNo(so.getSiteNo());

        // LNB 가져오기
        ResultListModel<BbsManageVO> leftMenu = this.getCommunityMenu(bs);
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

        mav.setViewName("community/view_bbs");
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

        // LNB 가져오기
        ResultListModel<BbsManageVO> leftMenu = this.getCommunityMenu(bs);
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

        mav.setViewName("community/insert_view_bbs");
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
        BbsManageSO bs = new BbsManageSO();
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
        }

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

        // LNB 가져오기
        ResultListModel<BbsManageVO> leftMenu = this.getCommunityMenu(bs);
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

        mav.setViewName("community/update_view_bbs");
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
     * 작성일 : 2016. 5. 19.
     * 작성자 : dong
     * 설명   : 커뮤니티 좌측 메뉴 정보
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 19. dong - 최초생성
     * </pre>
     *
     * @param so
     * @param bindingResult
     * @return
     * @throws Exception
     */
    public ResultListModel<BbsManageVO> getCommunityMenu(@Validated BbsManageSO so) throws Exception {

        so.setBbsId("");
        so.setBbsGbCd("1");
        ResultListModel<BbsManageVO> result = bbsManageService.selectBbsListPaging(so);

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
