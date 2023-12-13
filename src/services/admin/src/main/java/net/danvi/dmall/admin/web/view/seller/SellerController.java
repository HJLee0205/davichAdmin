package net.danvi.dmall.admin.web.view.seller;

import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import net.danvi.dmall.biz.app.goods.model.*;
import net.danvi.dmall.biz.app.goods.service.FilterManageService;
import net.danvi.dmall.biz.app.goods.service.GoodsManageService;
import net.danvi.dmall.biz.app.seller.model.SellerPO;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.validation.BindingResult;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import lombok.extern.slf4j.Slf4j;
import net.danvi.dmall.admin.web.common.view.View;
import net.danvi.dmall.biz.app.operation.model.AtchFilePO;
import net.danvi.dmall.biz.app.board.model.BbsLettManagePO;
import net.danvi.dmall.biz.app.board.model.BbsLettManageSO;
import net.danvi.dmall.biz.app.board.model.BbsManageSO;
import net.danvi.dmall.biz.app.board.service.BbsManageService;
import net.danvi.dmall.biz.app.seller.model.SellerSO;
import net.danvi.dmall.biz.app.seller.model.SellerVO;
import net.danvi.dmall.biz.app.seller.model.SellerVOListWrapper;
import net.danvi.dmall.biz.app.seller.service.SellerService;
import net.danvi.dmall.biz.common.service.BizService;
import net.danvi.dmall.biz.system.security.SessionDetailHelper;
import net.danvi.dmall.biz.system.service.SiteQuotaService;
import net.danvi.dmall.biz.system.validation.DeleteGroup;
import dmall.framework.admin.constants.AdminConstants;
import dmall.framework.common.constants.CommonConstants;
import dmall.framework.common.constants.UploadConstants;
import dmall.framework.common.exception.JsonValidationException;
import dmall.framework.common.model.ExcelViewParam;
import dmall.framework.common.model.FileVO;
import dmall.framework.common.model.FileViewParam;
import dmall.framework.common.model.ResultListModel;
import dmall.framework.common.model.ResultModel;
import dmall.framework.common.util.DateUtil;
import dmall.framework.common.util.FileUtil;
import dmall.framework.common.util.MessageUtil;

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
@RequestMapping("/admin/seller")
public class SellerController {
    @Resource(name = "bizService")
    private BizService bizService;

    @Resource(name = "siteQuotaService")
    private SiteQuotaService siteQuotaService;
    
    @Resource(name = "sellerService")
    private SellerService sellerService;
    
    @Resource(name = "bbsManageService")
    private BbsManageService bbsManageService;

    @Resource(name = "goodsManageService")
    private GoodsManageService goodsManageService;

    @Resource(name = "filterManageService")
    private FilterManageService filterManageService;

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
    @RequestMapping("/seller-list")
    public ModelAndView sellerList(@Validated SellerSO so, BindingResult bindingResult) throws Exception {
        ModelAndView mv = new ModelAndView("/admin/seller/SellerList");

        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            return mv;
        }
        
        try {
            // 문의를 제외한 거래상태
            if(so.getStatusCds() == null || so.getStatusCds().length == 0) {
                so.setStatusCds(new String[]{"01", "02", "03"});
            }
            so.setSearchSellerId(so.getSearchWords());

//            so.setSidx("UPD_DTTM DESC");

            // 판매자 목록조회
            mv.addObject("resultListModel", sellerService.selectSellerList(so));
        } catch (Exception e) {
            throw new Exception("판매자 목록 조회 오류");
        }

        // 사이트 번호
        mv.addObject("siteNo", SessionDetailHelper.getDetails().getSiteNo());
        // 검색조건
        mv.addObject("sellerSO", so);
        
        return mv;
    }



    /**
     * <pre>
     * 작성일 : 2017. 12. 05.
     * 작성자 : kimhy
     * 설명   : 입점대기 판매자 목록 화면
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2017. 12. 05. kimhy - 최초생성
     * </pre>
     *
     * @return
     */
    @RequestMapping("/stand-seller-list")
    public ModelAndView standSellerList(@Validated SellerSO so, BindingResult bindingResult) throws Exception {
        ModelAndView mv = new ModelAndView("/admin/seller/StandSellerList");

        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            return mv;
        }

        try {
        	//입점대기
        	so.setStatusCd("04");
            // 판매자 목록조회
            mv.addObject("resultListModel", sellerService.selectSellerList(so));
        } catch (Exception e) {
            throw new Exception("판매자 목록 조회 오류");
        }

        // 사이트 번호
        mv.addObject("siteNo", SessionDetailHelper.getDetails().getSiteNo());
        // 검색조건
        mv.addObject("sellerSO", so);

        return mv;
    }


    /**
     * <pre>
     * 작성일 : 2017. 11. 16.
     * 작성자 : kimhy
     * 설명   : 검색조건에 따른 판매자 목록을 조회 함수
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2017. 11. 16. kimhy - 최초생성
     * </pre>
     *
     * @param so
     * @return
     */

    @RequestMapping("/seller-list-paging")
    public @ResponseBody ResultListModel<SellerVO> selectSellerListPaging(SellerSO so, BindingResult bindingResult) {
        so.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
        
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }
        
        ResultListModel<SellerVO> resultListModel;
		resultListModel = sellerService.selectSellerList(so);

        return resultListModel;
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
        ModelAndView mv = new ModelAndView("/admin/seller/SellerDtl");
        mv.addObject("sellerSO", so);
        
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            return mv;
        }
        
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
    @RequestMapping("/seller-view")
    public ModelAndView sellerView(@Validated SellerSO so, BindingResult bindingResult) throws Exception {
        ModelAndView mv = new ModelAndView("/admin/seller/SellerView");
        mv.addObject("sellerSO", so);
        
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            return mv;
        }        
        
        // 판매자 상세 조회
        mv.addObject("resultModel", sellerService.selectSellerInfo(so));
        
        return mv;
    }
    
    /**
     * <pre>
     * 작성일 : 2018. 09. 06.
     * 작성자 : yji
     * 설명   : 판매자 입점/제휴 문의 목록 화면
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2018. 09. 06. yji - 최초생성
     * </pre>
     *
     * @return
     */
    @RequestMapping("/seller-ref-view")
    public ModelAndView sellerRefView(@Validated SellerSO so, BindingResult bindingResult) throws Exception {
        ModelAndView mv = new ModelAndView("/admin/seller/StandSellerView");
        mv.addObject("sellerSO", so);
        
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            return mv;
        }        
        
        // 판매자 상세 조회
        mv.addObject("resultModel", sellerService.selectSellerInfo(so));
        
        return mv;
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
     * 작성일 : 2017. 11. 23.
     * 작성자 : kimhy
     * 설명   : 판매자 등록/수정
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2017. 11. 23. 김현열 - 최초생성
     * </pre>
     *
     * @param eventPO
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
        } catch (Exception e) {
            // TODO Auto-generated catch block
        }
        return result;
    }
    
    
    /**
     * <pre>
     * 작성일 : 2017. 11. 26.
     * 작성자 : khy
     * 설명   : 검색 조건에 따른 회원리스트 Excel 다운로드
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2017. 11. 26. khy - 최초생성
     * </pre>
     *
     * @return
     */
    @RequestMapping("/seller-excel-download")
    public String selectSellerListExcel(SellerSO so, BindingResult bindingResult, Model model) {

        if(so.getStatusCds() == null || so.getStatusCds().length == 0) {
            so.setStatusCds(new String[]{"01", "02", "03"});
        }
        so.setSearchSellerId(so.getSearchWords());
        so.setSidx("UPD_DTTM DESC");
        so.setSord(", REG_DTTM DESC");
        so.setOffset(10000000);

        List<SellerVO> resultList = sellerService.selectSellerListExcel(so);

        // 엑셀의 헤더 정보 세팅
        String[] headerName = new String[] { "번호", "판매자번호", "아이디", "업체명", "담당자", "담당자 전화번호", "담당자 휴대폰", "담당자 이메일", "거래상태"};
        // 엑셀에 출력할 데이터 세팅
        String[] fieldName = new String[] { "rowNum", "sellerNo", "sellerId", "sellerNm", "managerNm", "managerTelno", "managerMobileNo", "managerEmail", "statusNm"};

        model.addAttribute(CommonConstants.EXCEL_PARAM_NAME, new ExcelViewParam("판매자 목록", headerName, fieldName, resultList));

        // 파일명
        model.addAttribute(CommonConstants.EXCEL_PARAM_FILE_NAME, "sellerlist_" + DateUtil.getNowDate()); // 엑셀

        return View.excelDownload();
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
        ModelAndView mv = new ModelAndView("/admin/seller/NoticeList");

        so.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
        so.setBbsId("sellNotice");
        so.setBbsNm("판매자공지");

        mv.addObject("so", so);

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
    @RequestMapping("/inquiry-list")
    public ModelAndView inquiryList(BbsManageSO so) {
        ModelAndView mv = new ModelAndView("/admin/seller/InquiryList");

        so.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
        so.setBbsId("sellQuestion");

        mv.addObject("so", so);

        return mv;
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
            viewPage = "/admin/seller/InquiryView";
        } else if (bbsId.equals("sellNotice")) {
            viewPage = "/admin/seller/NoticeView";
        }
        ModelAndView mv = new ModelAndView(viewPage);
        mv.addObject("so", so);
        mv.addObject("memberNo", SessionDetailHelper.getDetails().getSession().getMemberNo());
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
            viewPage = "/admin/seller/InquiryInsert";
        } else if (bbsId.equals("sellNotice")) {
            viewPage = "/admin/seller/NoticeUpdate";
        }

        ModelAndView mv = new ModelAndView(viewPage);
        mv.addObject("so", so);
        mv.addObject("memberNo", SessionDetailHelper.getDetails().getSession().getMemberNo());
        mv.addObject("siteNo", SessionDetailHelper.getDetails().getSiteNo());

        return mv;
    }

    /**
     * <pre>
     * 작성일 : 2017. 12. 1.
     * 작성자 : kimhy
     * 설명   : 게시글 수정 화면
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2017. 12. 1. kimhy - 최초생성
     * </pre>
     *
     * @param so
     * @return
     */
    @RequestMapping("/letter-update-form")
    public ModelAndView viewBbsLettUpdate(BbsLettManageSO so) {
        String bbsId = so.getBbsId();
        String viewPage = "";

        if (bbsId.equals("sellNotice")) {
            viewPage = "/admin/seller/NoticeUpdate";
        } else if (bbsId.equals("sellNotice")) {
        	viewPage = "/admin/seller/NoticeUpdate";
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
        ModelAndView mv = new ModelAndView("/admin/seller/InquiryReplyInsert");

        mv.addObject("so", so);
        mv.addObject("siteNo", SessionDetailHelper.getDetails().getSiteNo());
        mv.addObject("memberNo", SessionDetailHelper.getDetails().getSession().getMemberNo());
        return mv;
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
     * 작성일 : 2016. 10. 5.
     * 작성자 : dong
     * 설명   : 파일 다운로드
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 10. 5. dong - 최초생성
     * </pre>
     *
     * @param map
     * @param fileDownloadSO
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/download")
    public String fileDownload(ModelMap map, SellerVO vo) throws Exception {
        FileVO file;
        
        file = sellerService.selectAtchFileDtl(vo);

        FileViewParam fileView = new FileViewParam();
        fileView.setFilePath(FileUtil.getAllowedFilePath(file.getFilePath()));
        fileView.setFileName(FileUtil.getAllowedFilePath(file.getFileOrgName()));

        map.put(AdminConstants.FILE_PARAM_NAME, fileView);

        return View.fileDownload();
    }    
    
    
    @RequestMapping("/seller-approve")
    public @ResponseBody ResultModel<SellerVO> updateSellerSt(SellerVOListWrapper wrapper,
            BindingResult bindingResult) throws Exception {

        // 리스트 화면에서 전시 미전시 처리
        ResultModel<SellerVO> result = sellerService.updateSellerSt(wrapper);

        return result;
    }
    
    @RequestMapping("/seller-status-change")
    public @ResponseBody ResultModel<SellerVO> updateSellerChange(SellerVOListWrapper wrapper,
            BindingResult bindingResult) throws Exception {

        // 리스트 화면에서 전시 미전시 처리
        ResultModel<SellerVO> result = sellerService.updateSellerSt(wrapper);

        String status = "";
        String aprvYn = "";
        for (SellerVO vo : wrapper.getList()) {
        	status = vo.getStatusCd();
            aprvYn = vo.getAprvYn();
        }
        
        if ("02".equals(status)) {
            if ("N".equals(aprvYn)) {
                result.setMessage("판매자의 거래가 승인되었습니다.");
            } else {
                result.setMessage(MessageUtil.getMessage("admin.web.seller.rework"));
            }
        } else if ("03".equals(status)) {
            result.setMessage(MessageUtil.getMessage("admin.web.seller.suspend"));
        }

        return result;
    }
    
    @RequestMapping("/seller-delete")
    public @ResponseBody ResultModel<SellerVO> deleteSellerSt(SellerVOListWrapper wrapper,
            BindingResult bindingResult) throws Exception {

        // 리스트 화면에서 전시 미전시 처리
        ResultModel<SellerVO> result = sellerService.deleteSellerSt(wrapper);

        return result;
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
    public @ResponseBody ResultModel<BbsLettManagePO> insertBbsReply(BbsLettManagePO po, 
    		BindingResult bindingResult, HttpServletRequest request) throws Exception {
    	
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }
        
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
     *     작성일 : 2023. 01. 05.
     *     작성자 : truesol
     *     설명 : 입점/제휴 문의 답변 등록 페이지를 보여준다.
     *
     *     수정내역(수정일 수정자 - 수정내용)
     *     -------------------------------------------------------------------------
     *     2023. 01. 05. truesol - 최초생성
     * </pre>
     * @param so
     * @param bindingResult
     * @return
     * @throws Exception
     */
    @RequestMapping("/seller-reply-form")
    public ModelAndView sellerReplyForm(@Validated SellerSO so, BindingResult bindingResult) throws Exception {
        ModelAndView mv = new ModelAndView("/admin/seller/StandSellerReply");

        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            return mv;
        }

        // 판매자 상세 조회
        ResultModel<SellerVO> result = sellerService.selectSellerInfo(so);
        mv.addObject("resultModel", result);

        ObjectMapper mapper = new ObjectMapper();
        mv.addObject("attachImages", mapper.writeValueAsString(result.getData().getAttachImages()));
        return mv;
    }

    /**
     * <pre>
     *     작성일 : 2023. 01. 05.
     *     작성자 : truesol
     *     설명 : 입점/제휴 문의 답변 등록
     *
     *     수정내역(수정일 수정자 - 수정내용)
     *     -------------------------------------------------------------------------
     *     2023. 01. 05. truesol - 최초생성
     * </pre>
     * @param po
     * @param bindingResult
     * @param request
     * @return
     * @throws Exception
     */
    @RequestMapping("/seller-reply-insert")
    public @ResponseBody ResultModel<SellerPO> insertSellerReply(@Validated(DeleteGroup.class) SellerPO po,
            BindingResult bindingResult, HttpServletRequest request) throws Exception {
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }

        if(SessionDetailHelper.getDetails().getSession().getMemberNo() != null) {
            po.setReplyRegrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
        }

        ResultModel<SellerPO> result = sellerService.insertSellerReply(po, request);

        return result;
    }

    /**
     * <pre>
     *     작성일 : 2023. 01. 13.
     *     작성자 : truesol
     *     설명 : 판매자 상품 관리 목록 페이지를 보여준다.
     *
     *     수정내역(수정일 수정자 - 수정내용)
     *     -------------------------------------------------------------------------
     *     2023. 01. 13. truesol - 최초생성
     * </pre>
     * @param so
     * @param bindingResult
     * @return
     * @throws Exception
     */
    @RequestMapping("/seller-goods-list")
    public ModelAndView sellerGoodsList(@Validated GoodsSO goodsSO, BindingResult bindingResult) throws Exception {
        ModelAndView mv = new ModelAndView("/admin/seller/SellerGoodsList");

        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            return mv;
        }

        try {
            // 판매자 상품 목록 조회
            goodsSO.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
            if(goodsSO.getSearchDateType() == null || goodsSO.getSearchDateType().equals("")) {
                goodsSO.setSearchDateType("1");
            }
            if(goodsSO.getSearchType() == null || goodsSO.getSearchType().equals("")) {
                goodsSO.setSearchType("1");
            }
            if(goodsSO.getGoodsStatus() == null || goodsSO.getGoodsStatus().length == 0) {
                goodsSO.setGoodsStatus(new String[]{"3"});
            }
            goodsSO.setSellerYn("Y");
            mv.addObject("resultListModel", goodsManageService.selectGoodsList(goodsSO));
        } catch (Exception e) {
            throw new Exception("판매자 상품 목록 조회 오류");
        }

        mv.addObject("siteNo", SessionDetailHelper.getDetails().getSiteNo());
        mv.addObject("goodsSO", goodsSO);

        return mv;
    }

    /**
     * <pre>
     *     작성일 : 2023. 01. 13.
     *     작성자 : truesol
     *     설명 : 판매자 상품 보기 페이지를 보여준다.
     *
     *     수정내역(수정일 수정자 - 수정내용)
     *     -------------------------------------------------------------------------
     *     2023. 01. 13. truesol - 최초생성
     * </pre>
     * @param so
     * @param bindingResult
     * @return
     * @throws Exception
     */
    @RequestMapping("/seller-goods-detail")
    public ModelAndView sellerGoodsDetail(@Validated GoodsDetailSO so, BindingResult bindingResult) throws Exception {
        ModelAndView mv = new ModelAndView("/admin/seller/SellerGoodsDtl");

        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            return mv;
        }

        try {
            // 판매자 상품 상세정보 조회
            ResultModel<GoodsDetailVO> goodsDetailVOResultModel = goodsManageService.selectGoodsInfo(so);
            // 필터 정보 조회
            FilterSO filterSO = new FilterSO();
            filterSO.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
            filterSO.setGoodsTypeCd(so.getTypeCd());
            switch (so.getTypeCd()) {
                case "01":
                    filterSO.setFilterMenuLvl("2");
                    filterSO.setFilterItemLvl("3");
                    filterSO.setFilterNo("1");
                    break;
                case "02":
                    filterSO.setFilterMenuLvl("2");
                    filterSO.setFilterItemLvl("3");
                    filterSO.setFilterNo("2");
                    break;
                case "03":
                    filterSO.setFilterMenuLvl("2");
                    filterSO.setFilterItemLvl("3");
                    filterSO.setFilterNo("3");
                    break;
                case "04":
                    filterSO.setFilterMenuLvl("3");
                    filterSO.setFilterItemLvl("4");
                    filterSO.setFilterNo("4");
                    filterSO.setGoodsNo(so.getGoodsNo());

                    GoodsVO vo = new GoodsVO();
                    vo.setGoodsNo(so.getGoodsNo());
                    vo.setEditModeYn("Y");
                    vo.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());

                    FilterVO filterVO = goodsManageService.selectGoodsFilterLvl2Info(vo);
                    filterSO.setSelectedFilterNo(filterVO.getUpFilterNo());
                    break;
                default:
                    filterSO.setFilterMenuLvl("2");
                    filterSO.setFilterItemLvl("3");
                    filterSO.setFilterNo("5");
                    break;
            }
            filterSO.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
            List<FilterVO> filterVOList = filterManageService.selectFilterListGoodsType(filterSO);
            // 상품 상세내용 조회
            GoodsContentsVO goodsContentsVO = new GoodsContentsVO();
            goodsContentsVO.setGoodsNo(so.getGoodsNo());
            ResultModel<GoodsContentsVO> goodsContentsVOResultModel = goodsManageService.selectGoodsContents(goodsContentsVO);
            // 상품 고시정보 조회
            GoodsNotifySO goodsNotifySO = new GoodsNotifySO();
            goodsNotifySO.setNotifyNo("4");
            List<GoodsNotifyVO> goodsNotifyVOList = goodsManageService.selectGoodsNotifyItemList(goodsNotifySO);

            mv.addObject("typeCd", so.getTypeCd());
            mv.addObject("resultModel", goodsDetailVOResultModel);
            mv.addObject("resultFilter", filterVOList);
            mv.addObject("goodsContentsModel", goodsContentsVOResultModel);
            mv.addObject("goodsNotifyModel", goodsNotifyVOList);
        } catch (Exception e) {
            throw new Exception("판매자 상품 상세정보 조회 오류");
        }

        return mv;
    }
}
