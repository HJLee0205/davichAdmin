package net.danvi.dmall.admin.web.view.operation.controller;

import java.text.DecimalFormat;
import java.util.Calendar;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import dmall.framework.common.constants.RequestAttributeConstants;
import dmall.framework.common.util.HttpUtil;
import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import lombok.extern.slf4j.Slf4j;
import net.danvi.dmall.biz.app.member.level.service.MemberLevelService;
import net.danvi.dmall.biz.app.member.manage.model.MemberManageSO;
import net.danvi.dmall.biz.app.member.manage.model.MemberManageVO;
import net.danvi.dmall.biz.app.member.manage.service.MemberManageService;
import net.danvi.dmall.biz.app.operation.model.EmailSendPO;
import net.danvi.dmall.biz.app.operation.model.EmailSendSO;
import net.danvi.dmall.biz.app.operation.model.EmailSendVO;
import net.danvi.dmall.biz.app.operation.service.EmailSendService;
import net.danvi.dmall.biz.common.service.EditorService;
import net.danvi.dmall.biz.system.security.SessionDetailHelper;
import net.danvi.dmall.biz.system.validation.InsertGroup;
import dmall.framework.common.constants.UploadConstants;
import dmall.framework.common.exception.JsonValidationException;
import dmall.framework.common.model.CmnAtchFilePO;
import dmall.framework.common.model.ResultListModel;
import dmall.framework.common.model.ResultModel;
import dmall.framework.common.util.FileUtil;
import dmall.framework.common.util.MessageUtil;
import dmall.framework.common.util.StringUtil;

/**
 * <pre>
 * 프로젝트명 : 41.admin.web
 * 작성일     : 2016. 7. 6.
 * 작성자     : dong
 * 설명       : 이메일 관리
 * </pre>
 */
@Slf4j
@Controller
@RequestMapping("/admin/operation")
public class EmailSendController {

    @Resource(name = "memberManageService")
    private MemberManageService memberManageService;

    @Resource(name = "memberLevelService")
    private MemberLevelService memberLevelService;

    @Resource(name = "emailSendService")
    private EmailSendService emailSendService;

    @Resource(name = "editorService")
    private EditorService editorService;

    /**
     * <pre>
     * 작성일 : 2016. 5. 18.
     * 작성자 : dong
     * 설명   : 이메일 개별 발송
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 18. dong - 최초생성
     * </pre>
     *
     * @return
     */
    @RequestMapping("/email")
    public ModelAndView viewEmailSendMain(@Validated MemberManageSO memberManageSO, EmailSendSO emailSendSO,
            BindingResult bindingResult) {
        ModelAndView mv = new ModelAndView("/admin/operation/email/EmailSendMain");
        mv.addObject(memberManageSO);
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            return mv;
        }

        memberManageSO.setPrcId(SessionDetailHelper.getDetails().getUsername());
        memberManageSO.setPrcNm(SessionDetailHelper.getDetails().getSession().getMemberNm());

        // 검색조건 SO
        mv.addObject("memberManageSO", memberManageSO);

        // 회원등급 리스트 조회
        mv.addObject("memberGradeListModel", memberLevelService.selectGradeGetList());

        /*MemberManageSO so = new MemberManageSO();*/
        // 회원 전체 조회
        /*List<MemberManageVO> resultListModelTotal = memberManageService.viewMemList(so);
        mv.addObject("resultListModelTotal", resultListModelTotal);
        mv.addObject("totalSize", resultListModelTotal.size());*/

        EmailSendVO siteInfo = emailSendService.selectAdminEmail(emailSendSO);
        mv.addObject("siteInfo", siteInfo);
        mv.addObject("emailSendSo", emailSendSO);
        return mv;
    }

    /**
     * <pre>
     * 작성일 : 2023. 1. 27.
     * 작성자 : truesol
     * 설명   : 이메일 자동 발송 설정 화면
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2023. 1. 27. truesol - 최초생성
     * </pre>
     *
     * @param emailSendSo
     * @return
     */
    @RequestMapping("/email/autoSendSet")
    public ModelAndView viewEmailAutoSendSet(EmailSendSO emailSendSo) {
        ModelAndView mv = new ModelAndView("/admin/operation/email/EmailAutoSendSet");
        return mv;
    }

    /**
     * <pre>
     * 작성일 : 2023. 1. 27.
     * 작성자 : truesol
     * 설명   : 이메일 발송 내역 화면
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2023. 1. 27. truesol - 최초생성
     * </pre>
     *
     * @param emailSendSo
     * @return
     */
    @RequestMapping("/email/autoSendHist")
    public ModelAndView viewEmailAutoSendHist(EmailSendSO emailSendSo) {
        ModelAndView mv = new ModelAndView("/admin/operation/email/EmailAutoSendHist");
        return mv;
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 4.
     * 작성자 : dong
     * 설명   : 검색조건에 따른 EMAIL 자동 발송 내역 리스트 조회
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 4. dong - 최초생성
     * </pre>
     *
     * @param so
     * @param bindingResult
     * @return
     */

    @RequestMapping("/email-autosend-list")
    public @ResponseBody ResultListModel<EmailSendVO> selectSendEmailPaging(EmailSendSO so) {
        so.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
        so.setAutoSendYn("Y");
        ResultListModel<EmailSendVO> resultListModel = emailSendService.selectSendEmailPaging(so);
        return resultListModel;
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 18.
     * 작성자 : dong
     * 설명   : Email 발송 정보 조회
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
    @RequestMapping("/email-send-info")
    public @ResponseBody ResultModel<EmailSendVO> selectAutoSendEmailInfo(EmailSendSO so) throws Exception {
        ResultModel<EmailSendVO> result = emailSendService.selectSendEmailInfo(so);
        return result;
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 18.
     * 작성자 : dong
     * 설명   : Email 정보 조회 함수
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
    @RequestMapping("/email-autosend-detail")
    public @ResponseBody ResultModel<EmailSendVO> selectAutoEmailSendSetDtl(EmailSendSO so) throws Exception {
        ResultModel<EmailSendVO> result = emailSendService.selectStatusCfg(so);

        if (result.getData() == null) {
            EmailSendVO vo = new EmailSendVO();
            vo.setMailTypeCd(so.getMailTypeCd());

            vo.setMemberSendYn("");
            vo.setAdminSendYn("");
            vo.setSellerSendYn("");
            vo.setStoreSendYn("");
            vo.setStaffSendYn("");

            vo.setMailTitle("");
            vo.setMailContent("");

            result.setData(vo);
        }
        return result;
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 4.
     * 작성자 : dong
     * 설명   : 이메일 설정 등록 함수
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
    @RequestMapping("/email-autosend-set")
    public @ResponseBody ResultModel<EmailSendPO> updateStatusEmail(@Validated(InsertGroup.class) EmailSendPO po,
            BindingResult bindingResult) throws Exception {
        HttpServletRequest request = HttpUtil.getHttpServletRequest();
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }
        po.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
        po.setAutoSendYn("Y");
        if (SessionDetailHelper.getDetails().getSession().getMemberNo() != null) {
            po.setRegrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
            po.setUpdrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
        }
        po.setMailContent(StringUtil.replaceAll(po.getMailContent(), (String) request.getAttribute(RequestAttributeConstants.IMAGE_DOMAIN),""));
        po.setMailContent(StringUtil.replaceAll(po.getMailContent(), UploadConstants.IMAGE_TEMP_EDITOR_URL,UploadConstants.IMAGE_EDITOR_URL));

        ResultModel<EmailSendPO> result = emailSendService.updateStatusEmail(po);
        return result;
    }

    /**
     * <pre>
     * 작성일 : 2016. 7. 21.
     * 작성자 : dong
     * 설명   : 이메일 발송
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 7. 21. dong - 최초생성
     * </pre>
     *
     * @param po
     * @param bindingResult
     * @return
     * @throws Exception
     */
    @RequestMapping("/email-send")
    public @ResponseBody ResultModel<EmailSendPO> sendEmail(EmailSendPO po) throws Exception {
        boolean result = false;
        boolean solutionUseFlag = false;
        po.setAutoSendYn("N");
        po.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
        po.setOrdNo(0);

        // 현재 년, 월, 일
        DecimalFormat df = new DecimalFormat();
        Calendar calendar = Calendar.getInstance();
        String nowYear = Integer.toString(calendar.get(Calendar.YEAR));
        String nowMonth = Integer.toString(calendar.get(Calendar.MONTH) + 1);
        String nowDay = Integer.toString(calendar.get(Calendar.DATE));

        if (nowMonth.length() < 2) {
            nowMonth = "0" + nowMonth;
        }
        if (nowDay.length() < 2) {
            nowDay = "0" + nowDay;
        }

        if (SessionDetailHelper.getDetails().getSession().getMemberNo() != null) {
            po.setRegrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
            po.setUpdrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
        }

        /*----------에디터 처리 start-----------*/

        // 임시 경로의 파일을 서비스 경로로 복사, 업로드 했다 에디터에서 삭제한 파일 삭제
        editorService.setEditorImageToService(po, Long.toString(po.getSiteNo()), "TB_MAIL_SEND_HIST");

        // 에디터 내용의 업로드 이미지 정보 변경
        HttpServletRequest request = HttpUtil.getHttpServletRequest();
        po.setMailContent(StringUtil.replaceAll(po.getMailContent(), (String) request.getAttribute(RequestAttributeConstants.IMAGE_DOMAIN),""));
        po.setMailContent(StringUtil.replaceAll(po.getMailContent(), UploadConstants.IMAGE_TEMP_EDITOR_URL,po.getCurPage() + UploadConstants.IMAGE_EDITOR_URL));

        // 파일 구분세팅 및 파일명 세팅
        FileUtil.setEditorImageList(po, "TB_MAIL_SEND_HIST", po.getAttachImages());
        log.debug("TB_CMN_ATCH_FILE 에 저장할 첨부파일 정보 : {}", po.getAttachImages());

        // 파일 정보 디비 저장
        for (CmnAtchFilePO p : po.getAttachImages()) {
            if (p.getTemp()) {
                p.setRefNo(Long.toString(po.getSiteNo())); // 참조의 번호(게시판 번호,
                                                           // 팝업번호 등...)
                editorService.insertCmnAtchFile(p);
            }
        }

        // 임시 경로의 이미지 삭제
        FileUtil.deleteEditorTempImageList(po.getAttachImages());

        /*----------에디터 처리 end-----------*/

        if (("ad").equals(po.getEmailshotGb())) {
            po.setMailTitle("(광고)" + po.getMailTitle());
        } else if (("urgency").equals(po.getEmailshotGb())) {
            po.setMailTitle("(공지)" + po.getMailTitle());
        }

        String mailFooter = "본 메일은 " + nowYear + "년 " + nowMonth + "월 " + nowDay + "일 기준으로 회원님의 이메일 수신동의 여부를 확인한 결과, "
                + "수신에 동의하였기에 발송되었습니다. 메일 수신을 원하지 않으시면 " + "<a href=\" " + po.getCurPage()
                + "/front/login/member-login?type=adult&returnUrl=/front/member/information-update-form \" target=\"_balnk\" class=\"tbl_link\">[수신거부]</a> 를 클릭해 주십시오.<br><br>"
                + "If you don't want to receive this email anymore, " + "click <a href=\" " + po.getCurPage()
                + "/front/login/member-login?type=adult&returnUrl=/front/member/information-update-form \" target=\"_balnk\" class=\"tbl_link\">[HERE]</a><br>"
                + "본 메일은 발신전용으로 회신되지 않으므로 문의사항은 [고객센터]를 이용하여 주시기 바랍니다.";

        if (("Y").equals(po.getFooterUseYn())) {
            po.setMailContent(po.getMailContent() + "<br/><br/><br/>" + mailFooter);
        }

        MemberManageSO memberManageSO = new MemberManageSO();
        if (("memGrade").equals(po.getSendTargetType())) {
            solutionUseFlag = true;
            memberManageSO.setMemberGradeNo(po.getMemberGrade());
        } else if (("anniversary").equals(po.getSendTargetType())) {
            solutionUseFlag = true;
            if (("birth").equals(po.getAnniversarySel())) {
                memberManageSO.setBornMonth(po.getBornMonth());
            }
        } else {
            solutionUseFlag = false;
            memberManageSO.setMemberNo(po.getReceiverNoSelect()[0]);
        }

        po.setExcludeRecvN(po.getExcludeRecvN() == null ? "N" : po.getExcludeRecvN());
        if (("Y").equals(po.getExcludeRecvN())) {
            memberManageSO.setEmailRecvYn("Y");
        }

        List<MemberManageVO> toMailList = memberManageService.viewMemList(memberManageSO);

        ResultModel<EmailSendPO> resultPo = new ResultModel<>();

        if (toMailList.size() > 0) {
            for (int i = 0; i < toMailList.size(); i++) {
                MemberManageVO vo = toMailList.get(i);
                vo.setAuthGbCd("01");
            }

            if (!solutionUseFlag) {
                result = emailSendService.commonSendEmail(toMailList, po);
            } else {
                // 메일 발송(메일 발송 솔루션)
                result = emailSendService.sendEmail(toMailList, po);
            }

            if (result) {
                resultPo.setMessage(MessageUtil.getMessage("biz.opeeration.sendEmail"));
            } else {
                resultPo.setMessage(MessageUtil.getMessage("biz.opeeration.sendEmailFail"));
            }
        } else {
            resultPo.setMessage(MessageUtil.getMessage("biz.opeeration.sendEmailNoneTarget"));
        }

        return resultPo;
    }

    /**
     * <pre>
     * 작성일 : 2016. 8. 08.
     * 작성자 : dong
     * 설명   : 최근 발송 이메일 조회
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 8. 08. dong - 최초생성
     * </pre>
     *
     * @param EmailSendSO
     * @param
     * @return
     */
    @RequestMapping("/email-history")
    public @ResponseBody List<EmailSendVO> selectEmailHst(EmailSendSO so, BindingResult bindingResult) {

        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }
        so.setMemberNo(SessionDetailHelper.getDetails().getSession().getMemberNo());

        List<EmailSendVO> result = emailSendService.selectEmailHst(so);

        return result;
    }

    /**
     * <pre>
     * 작성일 : 2016. 8. 08.
     * 작성자 : dong
     * 설명   : 최근 발송 이메일 조회(단건)
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 8. 08. dong - 최초생성
     * </pre>
     *
     * @param EmailSendSO
     * @param
     * @return
     */
    @RequestMapping("/email-send-history")
    public @ResponseBody ResultModel<EmailSendVO> selectSendEmailHstOne(EmailSendSO so, BindingResult bindingResult) {

        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }
        so.setMemberNo(SessionDetailHelper.getDetails().getSession().getMemberNo());

        ResultModel<EmailSendVO> result = emailSendService.selectSendEmailHstOne(so);

        return result;
    }

    /**
     * <pre>
     * 작성일 : 2016. 8. 17.
     * 작성자 : dong
     * 설명   : 대량메일발송
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 8. 17. dong - 최초생성
     * </pre>
     *
     * @return
     */
    @RequestMapping("/bulk-mailing")
    public ModelAndView viewEmailshotSendMain(@Validated MemberManageSO memberManageSO, EmailSendSO emailSendSO,
            BindingResult bindingResult) {
        ModelAndView mv = new ModelAndView("/admin/operation/email/EmailshotSendMain");
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            return mv;
        }

        memberManageSO.setPrcId(SessionDetailHelper.getDetails().getUsername());
        memberManageSO.setPrcNm(SessionDetailHelper.getDetails().getSession().getMemberNm());

        // 검색조건 SO
        mv.addObject("memberManageSO", memberManageSO);

        // 회원등급 리스트 조회
        mv.addObject("memberGradeListModel", memberLevelService.selectGradeGetList());

        // 관리자 이메일, 사이트명 조회
        EmailSendVO siteInfo = emailSendService.selectAdminEmail(emailSendSO);
        mv.addObject("siteInfo", siteInfo);

        mv.addObject("emailSendSo", emailSendSO);

        mv.addObject("siteNo", SessionDetailHelper.getDetails().getSiteNo());

        // 예약 발송 시간 현재 시간으로 set
        DecimalFormat df = new DecimalFormat();
        Calendar calendar = Calendar.getInstance();
        String nowYear = Integer.toString(calendar.get(Calendar.YEAR));
        String nowMonth = Integer.toString(calendar.get(Calendar.MONTH) + 1);
        String nowDay = Integer.toString(calendar.get(Calendar.DATE));
        String nowTime = "";

        if (calendar.get(Calendar.AM_PM) == Calendar.PM) {
            nowTime = df.format(calendar.get(Calendar.HOUR) + 12);
        } else {
            nowTime = df.format(calendar.get(Calendar.HOUR));
        }

        if (nowMonth.length() < 2) {
            nowMonth = "0" + nowMonth;
        }
        if (nowDay.length() < 2) {
            nowDay = "0" + nowDay;
        }
        if (nowTime.length() < 2) {
            nowTime = "0" + nowTime;
        }
        mv.addObject("nowYear", nowYear);
        mv.addObject("nowMonth", nowMonth);
        mv.addObject("nowDay", nowDay);
        mv.addObject("nowTime", nowTime);

        return mv;
    }

    /**
     * <pre>
     * 작성일 : 2023. 1. 27.
     * 작성자 : truesol
     * 설명   : 서비스 안내 화면
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2023. 1. 27. truesol - 최초생성
     * </pre>
     *
     * @param emailSendSo
     * @return
     */
    @RequestMapping("/bulk-mailing/sendGuide")
    public ModelAndView viewEmailshotGuide(EmailSendSO emailSendSo) {
        ModelAndView mv = new ModelAndView("/admin/operation/email/EmailshotGuide");
        return mv;
    }

    /**
     * <pre>
     * 작성일 : 2023. 1. 27.
     * 작성자 : truesol
     * 설명   : 대량메일 충전 관리 화면
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2023. 1. 27. truesol - 최초생성
     * </pre>
     *
     * @param emailSendSo
     * @return
     */
    @RequestMapping("/bulk-mailing/sendPaid")
    public ModelAndView viewEmailshotPaid(EmailSendSO emailSendSo) {
        ModelAndView mv = new ModelAndView("/admin/operation/email/EmailPaid");
        return mv;
    }

    /**
     * <pre>
     * 작성일 : 2023. 1. 27.
     * 작성자 : truesol
     * 설명   : 대량메일 발송 설정 화면
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2023. 1. 27. truesol - 최초생성
     * </pre>
     *
     * @param emailSendSo
     * @return
     */
    @RequestMapping("/bulk-mailing/sendSet")
    public ModelAndView viewEmailshotSendSet(EmailSendSO emailSendSo) {
        ModelAndView mv = new ModelAndView("/admin/operation/email/EmailshotSend");
        return mv;
    }

    /**
     * <pre>
     * 작성일 : 2023. 1. 27.
     * 작성자 : truesol
     * 설명   : 대량메일 발송 내역 화면
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2023. 1. 27. truesol - 최초생성
     * </pre>
     *
     * @param emailSendSo
     * @return
     */
    @RequestMapping("/bulk-mailing/sendHist")
    public ModelAndView viewEmailshotSendHist(EmailSendSO emailSendSo) {
        ModelAndView mv = new ModelAndView("/admin/operation/email/EmailIndividualSendHist");
        return mv;
    }
}
