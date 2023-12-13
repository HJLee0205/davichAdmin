package net.danvi.dmall.admin.web.view.seller.setup;

import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import dmall.framework.common.constants.ExceptionConstants;
import dmall.framework.common.constants.RequestAttributeConstants;
import dmall.framework.common.util.CryptoUtil;
import dmall.framework.common.util.MessageUtil;
import net.danvi.dmall.biz.app.operation.model.ReplaceCdVO;
import net.danvi.dmall.biz.app.operation.model.SmsSendSO;
import net.danvi.dmall.biz.app.operation.service.SmsSendService;
import net.danvi.dmall.biz.app.seller.model.SellerPO;
import net.danvi.dmall.biz.app.seller.model.SellerVOListWrapper;
import net.danvi.dmall.biz.app.setup.delivery.model.*;
import net.danvi.dmall.biz.system.security.DmallSessionDetails;
import org.apache.commons.lang.StringUtils;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import lombok.extern.slf4j.Slf4j;
import net.danvi.dmall.biz.app.main.service.MainService;
import net.danvi.dmall.biz.app.member.manage.model.MemberManageSO;
import net.danvi.dmall.biz.app.member.manage.service.MemberManageService;
import net.danvi.dmall.biz.app.operation.model.AtchFilePO;
import net.danvi.dmall.biz.app.board.model.BbsCmntManagePO;
import net.danvi.dmall.biz.app.board.model.BbsCmntManageSO;
import net.danvi.dmall.biz.app.board.model.BbsCmntManageVO;
import net.danvi.dmall.biz.app.board.model.BbsLettManagePO;
import net.danvi.dmall.biz.app.board.model.BbsLettManageSO;
import net.danvi.dmall.biz.app.board.model.BbsLettManageVO;
import net.danvi.dmall.biz.app.board.model.BbsManageSO;
import net.danvi.dmall.biz.app.board.service.BbsManageService;
import net.danvi.dmall.biz.app.seller.model.SellerSO;
import net.danvi.dmall.biz.app.seller.model.SellerVO;
import net.danvi.dmall.biz.app.seller.service.SellerService;
import net.danvi.dmall.biz.system.security.SessionDetailHelper;
import net.danvi.dmall.biz.system.service.MenuService;
import net.danvi.dmall.biz.system.validation.DeleteGroup;
import net.danvi.dmall.biz.system.validation.InsertGroup;
import net.danvi.dmall.biz.system.validation.UpdateGroup;
import dmall.framework.common.constants.UploadConstants;
import dmall.framework.common.exception.JsonValidationException;
import dmall.framework.common.model.FileVO;
import dmall.framework.common.model.ResultListModel;
import dmall.framework.common.model.ResultModel;
import dmall.framework.common.util.FileUtil;
import dmall.framework.common.util.StringUtil;

/**
 * <pre>
 * 프로젝트명 : 41.admin.web
 * 작성일     : 2017. 11. 16.
 * 작성자     : 
 * 설명       : 판매자 컨트롤러
 * </pre>
 */

@Slf4j
@Controller
@RequestMapping("/admin/seller/setup")
public class SellerSetupController {

    @Resource(name = "adminMainService")
    private MainService mainService;    
    
    @Resource(name = "sellerService")
    private SellerService sellerService;
    
    @Resource(name = "menuService")
    private MenuService menuService;
    
    @Resource(name = "bbsManageService")
    private BbsManageService bbsManageService;
    
    @Resource(name = "memberManageService")
    private MemberManageService memberManageService;

    @Resource(name = "smsSendService")
    private SmsSendService smsSendService;
    
    /**
     * <pre>
     * 작성일 : 2017. 11. 16.
     * 작성자 : kimhy
     * 설명   : 판매자 목록 화면
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2017. 11. 16. kimhy - 최초생성
     * </pre>
     *
     * @return
     */
    @RequestMapping("/seller-view")
    public ModelAndView sellerView(@Validated SellerSO so, BindingResult bindingResult) throws Exception {
        ModelAndView mv = new ModelAndView("/admin/seller/setup/SellerView");
        mv.addObject("sellerSO", so);
        
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            return mv;
        }        
        
        so.setSellerNo(String.valueOf(SessionDetailHelper.getSession().getSellerNo()));
        so.setSellerId(SessionDetailHelper.getSession().getSellerId());
        so.setSiteNo(SessionDetailHelper.getSession().getSiteNo());
        
        // 판매자 상세 조회
        mv.addObject("resultModel", sellerService.selectSellerInfo(so));
        
        return mv;
    }        
    
    /**
     * <pre>
     * 작성일 : 2017. 11. 16.
     * 작성자 : kimhy
     * 설명   : 판매자 목록 화면
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2017. 11. 16. kimhy - 최초생성
     * </pre>
     *
     * @return
     */
    @RequestMapping("/seller-detail")
    public ModelAndView sellerDtl(@Validated SellerSO so, BindingResult bindingResult) throws Exception {
        ModelAndView mv = new ModelAndView("/admin/seller/setup/SellerDtl");
        mv.addObject("sellerSO", so);
        
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            return mv;
        }

        so.setSellerNo(String.valueOf(SessionDetailHelper.getSession().getSellerNo()));
        
        // 판매자 상세 조회
        mv.addObject("resultModel", sellerService.selectSellerInfo(so));
        
        return mv;
    }
    
    
    /**
     * <pre>
     * 작성일 : 2017. 12. 1.
     * 작성자 : kimhy
     * 설명   : 판매자공지 목록
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2017. 12. 1. kimhy - 최초생성
     * </pre>
     *
     * @param so
     * @return
     */
    @RequestMapping("/notice-list")
    public ModelAndView noticeList(BbsManageSO so) {
        ModelAndView mv = new ModelAndView("/admin/seller/setup/NoticeList");

        so.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
        so.setBbsId("sellNotice");
        so.setBbsNm("판매자공지");

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
        so.setSelSellerNo(String.valueOf(SessionDetailHelper.getSession().getSellerNo()));
        so.setPageGbn("S");
        ResultListModel<BbsLettManageVO> resultListModel = bbsManageService.selectBbsLettPaging(so);
        return resultListModel;
    }
    
    
    /**
     * <pre>
     * 작성일 : 2017. 12. 1.
     * 작성자 : kimhy
     * 설명   : 게시글 보기 화면
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2017. 12. 1. kimhy - 최초생성
     * </pre>
     *
     * @param so
     * @return
     */
    @RequestMapping("/seller-bbs-detail")
    public ModelAndView viewBbsLettDtl(BbsLettManageSO so) {
        String bbsId = so.getBbsId();
        String viewPage = "";
        if (bbsId.equals("sellQuestion")) {
            viewPage = "/admin/seller/setup/InquiryView";
        } else if (bbsId.equals("sellNotice")) {
            viewPage = "/admin/seller/setup/NoticeView";
        }
        ModelAndView mv = new ModelAndView(viewPage);
        mv.addObject("so", so);
        mv.addObject("memberNo", SessionDetailHelper.getDetails().getSession().getSellerNo());
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
        if(so.getBbsId().equals("sellQuestion")) {
            so.setRegrNo(SessionDetailHelper.getDetails().getSession().getSellerNo());
        }
        ResultModel<BbsLettManageVO> resultModel = bbsManageService.selectBbsLettDtl(so);
        
        return resultModel;
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
    
    @RequestMapping("/member-info")
    public @ResponseBody ResultModel<SellerVO> selectMemInfo(MemberManageSO so) throws Exception {
        ResultModel<SellerVO> resultModel = sellerService.viewMemInfoDtl(so);
        return resultModel;
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
        po.setRegrNo(SessionDetailHelper.getDetails().getSession().getSellerNo());
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
     * 작성일 : 2017. 12. 1.
     * 작성자 : kimhy
     * 설명   : 판매자공지 목록
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2017. 12. 1. kimhy - 최초생성
     * </pre>
     *
     * @param so
     * @return
     */
    @RequestMapping("/inquiry-list")
    public ModelAndView inquiryList(BbsManageSO so) {
        ModelAndView mv = new ModelAndView("/admin/seller/setup/InquiryList");

        so.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
        so.setBbsId("sellQuestion");
        so.setBbsNm("판매자문의");

        mv.addObject("so", so);

        return mv;
    }
    

    /**
     * <pre>
     * 작성일 : 2017. 12. 1.
     * 작성자 : kimhy
     * 설명   : 게시글 등록 화면
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2017. 12. 1. kimhy - 최초생성
     * </pre>
     *
     * @param so
     * @return
     */
    @RequestMapping("/letter-insert-form")
    public ModelAndView viewBbsLettInsert(@Validated BbsLettManageSO so) {
        String bbsId = so.getBbsId();
        String viewPage = "";

        if (bbsId.equals("sellQuestion")) {
            viewPage = "/admin/seller/setup/InquiryInsert";
        } else if (bbsId.equals("sellNotice")) {
            viewPage = "/admin/seller/setup/NoticeInsert";
        }

        ModelAndView mv = new ModelAndView(viewPage);
        mv.addObject("so", so);
        mv.addObject("memberNo", SessionDetailHelper.getDetails().getSession().getSellerNo());
        mv.addObject("siteNo", SessionDetailHelper.getDetails().getSiteNo());
        mv.addObject("loginId", SessionDetailHelper.getSession().getSellerId());
        mv.addObject("memberNm", SessionDetailHelper.getSession().getSellerNm());

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
        if (SessionDetailHelper.getDetails().getSession().getSellerNo() != null) {
            po.setRegrNo(SessionDetailHelper.getDetails().getSession().getSellerNo());
            po.setSellerNo(SessionDetailHelper.getDetails().getSession().getSellerNo());
        } else {

        }
        
        ResultModel<BbsLettManagePO> result = bbsManageService.insertBbsLett(po, request);

        // sms 치환코드 set
        ReplaceCdVO smsReplaceVO = new ReplaceCdVO();

        // send 객체 set
        SmsSendSO smsSendSO = new SmsSendSO();
        smsSendSO.setSiteNo(po.getSiteNo());
        smsSendSO.setSendTypeCd("39");
        smsSendSO.setAdminTemplateCode("mk052");

        smsSendService.sendAutoSms(smsSendSO, smsReplaceVO);

        return result;
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
        po.setSellerNo(SessionDetailHelper.getSession().getSellerNo());
        po.setContent(StringUtil.replaceAll(po.getContent(), (String) request.getAttribute(RequestAttributeConstants.IMAGE_DOMAIN),""));
        po.setContent(StringUtil.replaceAll(po.getContent(), UploadConstants.IMAGE_TEMP_EDITOR_URL, UploadConstants.IMAGE_EDITOR_URL));
        if (SessionDetailHelper.getDetails().getSession().getSellerNo() != null) {
            po.setUpdrNo(SessionDetailHelper.getDetails().getSession().getSellerNo());
        } else {

        }
        ResultModel<BbsLettManagePO> result = bbsManageService.updateBbsLett(po, request);

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
            viewPage = "/admin/seller/setup/InquiryUpdate";
        } 
        
        ModelAndView mv = new ModelAndView(viewPage);
        mv.addObject("so", so);
        mv.addObject("siteNo", SessionDetailHelper.getDetails().getSiteNo());
        mv.addObject("memberNo", SessionDetailHelper.getDetails().getSession().getSellerNo());
        mv.addObject("loginId", SessionDetailHelper.getSession().getSellerId());
        mv.addObject("memberNm", SessionDetailHelper.getSession().getSellerNm());
        
        return mv;
    }    
    
    
    /**
     * <pre>
     * 작성일 : 2017. 11. 23.
     * 작성자 : kimhy
     * 설명   : 판매자 등록/수정
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2017. 11. 23. 김현열 - 최초생성
     * </pre>
     *
     * @param po
     * @param bindingResult
     * @return
     */
    @RequestMapping("/seller-info-save")
    public @ResponseBody ResultModel<SellerVO> saveSeller(@Validated SellerPO po, HttpServletRequest mRequest, BindingResult bindingResult) {
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }
        
        ResultModel<SellerVO> result = null;
        try {
            // 판매자 정보 조회
            SellerSO sellerSO = new SellerSO();
            sellerSO.setSiteNo(po.getSiteNo());
            sellerSO.setSellerNo(po.getSellerNo());
            SellerVO sellerVO = sellerService.selectSellerInfo(sellerSO).getData();

            // 판매자 정보 저장 시 승인 전이면 승인요청 상태로 저장
            if ("N".equals(sellerVO.getAprvYn())) {
                po.setStatusCd("01");
            }

            // 파일 정보 등록
            List<FileVO> list = FileUtil.getSellerFileListFromRequest(mRequest,
                    FileUtil.getPath(UploadConstants.PATH_ATTACH, UploadConstants.PATH_SELLER));
            
            if (list != null) {
	            for (int i = 0; i < list.size(); i++) {
	            	String gb = list.get(i).getUserFile();

                    if ("biz".equals(gb)) {
                        po.setBizFilePath(list.get(i).getFilePath()); //사업자 등록증 파일 경로
                        po.setBizFileNm(list.get(i).getFileName());        //사업자 등록증 파일명
                        po.setBizOrgFileNm(list.get(i).getFileOrgName());  //사업자 등록증 원본 파일명
                    } else if ("copy".equals(gb)) {
                        po.setBkCopyFilePath(list.get(i).getFilePath()); //통장사본 파일 경로
                        po.setBkCopyFileNm(list.get(i).getFileName());        //통장사본 파일 명
                        po.setBkCopyOrgFileNm(list.get(i).getFileOrgName());  //통장사본 원본 파일 명
                    } else if ("etc".equals(gb)) {
                        po.setEtcFilePath(list.get(i).getFilePath()); //기타 파일 경로
                        po.setEtcFileNm(list.get(i).getFileName());        //기타 파일 명
                        po.setEtcOrgFileNm(list.get(i).getFileOrgName());  //기타 원본 파일 명
                    } else if ("ref".equals(gb)) {
                        po.setRefFilePath(list.get(i).getFilePath());   //참조 파일 경로
                        po.setRefFileNm(list.get(i).getFileName());     //참조 파일 명
                        po.setRefOrgFileNm(list.get(i).getFileOrgName());   //참조 원본 파일 명
                        po.setRefFileSize(list.get(i).getFileSize());   //참조 파일 사이즈
                    }
	            }
            }
        	
            result = sellerService.saveSeller(po);

            // 승인요청 시 관리자에게 sms 전송
            if ("N".equals(sellerVO.getAprvYn()) && !StringUtils.isEmpty(sellerVO.getManagerMobileNo())) {
                ReplaceCdVO smsReplaceVO = new ReplaceCdVO();

                SmsSendSO smsSendSO = new SmsSendSO();
                smsSendSO.setSiteNo(po.getSiteNo());
                smsSendSO.setSendTypeCd("35");
                smsSendSO.setAdminTemplateCode("mk048");

                smsSendService.sendAutoSms(smsSendSO, smsReplaceVO);
            }

            if(!sellerVO.getSellerId().equals(CryptoUtil.decryptAES(po.getSellerId()))) {
                result.setMessage("수정되었습니다.<br>아이디가 변경되어 로그아웃됩니다.");
            }
        } catch (Exception e) {
            // TODO Auto-generated catch block
        }
        return result;
    }
    
    
    /**
     * <pre>
     * 작성일 : 2017. 12. 14.
     * 작성자 : khy
     * 설명   : 첨부 파일을 삭제한다
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2017. 12. 14. khy - 최초생성
     * </pre>
     *
     * @param po
     * @param bindingResult
     * @return
     * @throws Exception
     */
    @RequestMapping("/attach-file-delete")
    public @ResponseBody ResultModel<AtchFilePO> deleteAtchFile(@Validated(DeleteGroup.class) SellerVO vo,
            BindingResult bindingResult) throws Exception {
    	
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }
        if (SessionDetailHelper.getDetails().getSession().getMemberNo() != null) {
            vo.setDelrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
        }

        ResultModel<AtchFilePO> result = sellerService.deleteAtchFile(vo);

        return result;
    }
    
    /**
     * <pre>
     * 작성일 : 2017. 11. 21.
     * 작성자 : kimhy
     * 설명   : 아이디 중복확인
     * -------------------------------------------------------------------------
     * </pre>
     */
    @RequestMapping("/duplication-id-check")
    public @ResponseBody ResultModel<SellerVO> checkDuplicationId(SellerSO so, BindingResult bindingResult)
            throws Exception {
        ResultModel<SellerVO> result = new ResultModel<>();
        int loginId = sellerService.checkDuplicationId(so);
        if (loginId > 0) {
            result.setSuccess(false);
        } else {
            result.setSuccess(true);
        }
        return result;
    }


/**
     * <pre>
     * 작성일 : 2016. 9. 22.
     * 작성자 : dong
     * 설명   : 배송관련 설정 화면 (/admin/setup/deliveryConfig)을 반환한다.
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 9. 22. dong - 최초생성
     * </pre>
     *
     * @return
     */
    @RequestMapping("/delivery/delivery-config")
    public ModelAndView viewDeliveryConfig() {
        ModelAndView mav = new ModelAndView("/admin/seller/setup/deliveryConfig");
        return mav;
    }

     /**
     * <pre>
     * 작성일 : 2016. 9. 22.
     * 작성자 : dong
     * 설명   : 배송 관련 설정 정보를 취득하여 json 형태로 반환한다.
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 9. 22. dong - 최초생성
     * </pre>
     *
     * @return
     */
    @RequestMapping("/delivery/delivery-config-info")
    public @ResponseBody ResultModel<DeliveryConfigVO> selectDeliveryConfig(SellerPO po) {
        DmallSessionDetails sessionInfo = SessionDetailHelper.getDetails();
        if (sessionInfo == null) {
            throw new BadCredentialsException(MessageUtil.getMessage(ExceptionConstants.BIZ_EXCEPTION_LNG + ExceptionConstants.ERROR_CODE_LOGIN_SESSION));
        }

        Long siteNo = sessionInfo.getSiteNo();
        Long sellerNo = sessionInfo.getSession().getSellerNo();

        po.setSiteNo(siteNo);
        po.setSellerNo(String.valueOf(sellerNo));

        ResultModel<DeliveryConfigVO> result = sellerService.selectDeliveryConfig(po);
        return result;
    }

    /**
     * <pre>
     * 작성일 : 2016. 9. 22.
     * 작성자 : dong
     * 설명   : 배송 관련 설정 정보를 수정한다.
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 9. 22. dong - 최초생성
     * </pre>
     *
     * @param po
     * @param bindingResult
     * @return
     * @throws Exception
     */
    @RequestMapping("/delivery/delivery-config-update")
    public @ResponseBody ResultModel<DeliveryConfigPO> updateDeliveryConfig(
            @Validated(UpdateGroup.class) DeliveryConfigPO po, BindingResult bindingResult) throws Exception {
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }
        ResultModel<DeliveryConfigPO> result = sellerService.updateDeliveryConfig(po);
        return result;
    }

    /**
     * <pre>
     * 작성일 : 2016. 9. 22.
     * 작성자 : dong
     * 설명   : 지역별 배송비 설정 목록을 취득하여 반환한다.
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 9. 22. dong - 최초생성
     * </pre>
     *
     * @param so
     * @return
     */
    @RequestMapping("/delivery/delivery-area-list")
    public @ResponseBody ResultListModel<DeliveryAreaVO> selectDeliveryAreaListPaging(DeliveryAreaSO so) {
        ResultListModel<DeliveryAreaVO> result = sellerService.selectDeliveryListPaging(so);
        return result;
    }

    /**
     * <pre>
     * 작성일 : 2016. 9. 22.
     * 작성자 : dong
     * 설명   : 지역별 배송비 설정 정보를 등록한다.
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 9. 22. dong - 최초생성
     * </pre>
     *
     * @param po
     * @param bindingResult
     * @return
     * @throws Exception
     */
    @RequestMapping("/delivery/delivery-area-insert")
    public @ResponseBody ResultModel<DeliveryAreaPO> insertDeliveryArea(@Validated(InsertGroup.class) DeliveryAreaPO po,
                                                                        BindingResult bindingResult) throws Exception {
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }
        ResultModel<DeliveryAreaPO> result = sellerService.insertDeliveryArea(po);
        return result;
    }

     /**
     * <pre>
     * 작성일 : 2016. 9. 22.
     * 작성자 : dong
     * 설명   : 지역별 배송비 설정 정보를 수정한다.
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 9. 22. dong - 최초생성
     * </pre>
     *
     * @param po
     * @param bindingResult
     * @return
     * @throws Exception
     */
    @RequestMapping("/delivery/delivery-area-update")
    public @ResponseBody ResultModel<DeliveryAreaPO> updateDeliveryArea(@Validated(UpdateGroup.class) DeliveryAreaPO po,
            BindingResult bindingResult) throws Exception {
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }
        ResultModel<DeliveryAreaPO> result = sellerService.updateDeliveryArea(po);
        return result;
    }

    /**
     * <pre>
     * 작성일 : 2016. 10. 17.
     * 작성자 : dong
     * 설명   : 기본 배송비 설정을 적용한다.
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 10. 17. dong - 최초생성
     * </pre>
     *
     * @param wrapper
     * @param bindingResult
     * @return
     */
    @RequestMapping("/delivery/default-delivery-update")
    public @ResponseBody ResultModel<DeliveryAreaPO> updateApplyDefaultDeliveryArea(DeliveryAreaPO po)
            throws Exception {
        ResultModel<DeliveryAreaPO> resultModel = sellerService.updateApplyDefaultDeliveryArea(po);
        return resultModel;
    }

    /**
     * <pre>
     * 작성일 : 2016. 9. 22.
     * 작성자 : dong
     * 설명   : 지역별 배송비 설정 정보를 삭제한다.
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 9. 22. dong - 최초생성
     * </pre>
     *
     * @param wrapper
     * @param bindingResult
     * @return
     */
    @RequestMapping("/delivery/delivery-area-delete")
    public @ResponseBody ResultModel<DeliveryAreaPO> deleteDeliveryArea(DeliveryAreaPOListWrapper wrapper,
            BindingResult bindingResult) {
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }

        ResultModel<DeliveryAreaPO> resultModel = sellerService.deleteDeliveryArea(wrapper);
        return resultModel;
    }

    /**
     * <pre>
     * 작성일 : 2016. 10. 26.
     * 작성자 : dong
     * 설명   : 지역별 배송비 설정 정보를 전체 삭제한다.
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 10. 26. dong - 최초생성
     * </pre>
     *
     * @param wrapper
     * @param bindingResult
     * @return
     */
    @RequestMapping("/delivery/alldelivery-area-delete")
    public @ResponseBody ResultModel<DeliveryAreaPO> deleteAllDeliveryArea(DeliveryAreaPO po) {
        ResultModel<DeliveryAreaPO> resultModel = sellerService.deleteAllDeliveryArea(po);
        return resultModel;
    }

    /**
     * <pre>
     * 작성일 : 2016. 9. 22.
     * 작성자 : dong
     * 설명   : HS코드 정보 목록을 취득하여 json 형태로 반환한다.
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 9. 22. dong - 최초생성
     * </pre>
     *
     * @param so
     * @return
     */
    @RequestMapping("/delivery/hscode-list")
    public @ResponseBody ResultListModel<HscdVO> selectHscdListPaging(HscdSO so) {
        ResultListModel<HscdVO> result = sellerService.selectHscdListPaging(so);
        return result;
    }

    /**
     * <pre>
     * 작성일 : 2016. 9. 22.
     * 작성자 : dong
     * 설명   : HS코드 정보를 등록 및 수정한다.
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 9. 22. dong - 최초생성
     * </pre>
     *
     * @param po
     * @param bindingResult
     * @return
     * @throws Exception
     */
    @RequestMapping("/delivery/hscode-update")
    public @ResponseBody ResultModel<HscdPO> updateHscd(@Validated(UpdateGroup.class) HscdPO po,
            BindingResult bindingResult) throws Exception {
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }
        ResultModel<HscdPO> result = sellerService.updateHscd(po);
        return result;
    }

    /**
     * <pre>
     * 작성일 : 2016. 9. 22.
     * 작성자 : dong
     * 설명   : HS코드 정보를 삭제한다.
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 9. 22. dong - 최초생성
     * </pre>
     *
     * @param po
     * @param bindingResult
     * @return
     * @throws Exception
     */
    @RequestMapping("/delivery/hscode-delete")
    public @ResponseBody ResultModel<HscdPO> deleteHscd(HscdPO po, BindingResult bindingResult) throws Exception {
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }

        ResultModel<HscdPO> resultModel = sellerService.deleteHscd(po);
        return resultModel;
    }

    /**
     * <pre>
     * 작성일 : 2023. 1. 18.
     * 작성자 : truesol
     * 설명   : 승인요청 상태로 변경한다.
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2023. 1. 18. truesol - 최초생성
     * </pre>
     * @param wrapper
     * @param bindingResult
     * @return
     * @throws Exception
     */
    @RequestMapping("/seller-status-change")
    public @ResponseBody ResultModel<SellerVO> updateSellerChange(SellerVOListWrapper wrapper, BindingResult bindingResult) throws Exception {
        // 리스트 화면에서 전시 미전시 처리
        ResultModel<SellerVO> result = sellerService.updateSellerSt(wrapper);

        result.setMessage("거래 승인이 요청되었습니다.");

        return result;
    }
}
