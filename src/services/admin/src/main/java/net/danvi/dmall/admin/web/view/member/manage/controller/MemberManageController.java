package net.danvi.dmall.admin.web.view.member.manage.controller;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang.StringUtils;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.validation.BindingResult;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import dmall.framework.admin.constants.AdminConstants;
import dmall.framework.common.constants.CommonConstants;
import dmall.framework.common.constants.UploadConstants;
import dmall.framework.common.exception.JsonValidationException;
import dmall.framework.common.model.ExcelViewParam;
import dmall.framework.common.model.FileVO;
import dmall.framework.common.model.FileViewParam;
import dmall.framework.common.model.ResultListModel;
import dmall.framework.common.model.ResultModel;
import dmall.framework.common.util.CryptoUtil;
import dmall.framework.common.util.DateUtil;
import dmall.framework.common.util.FileUtil;
import dmall.framework.common.util.MessageUtil;
import lombok.extern.slf4j.Slf4j;
import net.danvi.dmall.admin.web.common.view.View;
import net.danvi.dmall.biz.app.member.level.service.MemberLevelService;
import net.danvi.dmall.biz.app.member.manage.model.MemberManagePO;
import net.danvi.dmall.biz.app.member.manage.model.MemberManageSO;
import net.danvi.dmall.biz.app.member.manage.model.MemberManageVO;
import net.danvi.dmall.biz.app.member.manage.service.MemberManageService;
import net.danvi.dmall.biz.app.operation.model.AtchFilePO;
import net.danvi.dmall.biz.app.operation.service.EmailSendService;
import net.danvi.dmall.biz.app.operation.service.SmsSendService;
import net.danvi.dmall.biz.system.security.SessionDetailHelper;
import net.danvi.dmall.biz.system.util.InterfaceUtil;
import net.danvi.dmall.biz.system.validation.DeleteGroup;
import net.danvi.dmall.biz.system.validation.UpdateGroup;

/**
 * <pre>
 * 프로젝트명 : 41.admin.web
 * 작성일     : 2016. 5. 03.
 * 작성자     : dong
 * 설명       : 회원 정보 관리 컴포넌트의 컨트롤러 클래스
 * </pre>
 */
@Slf4j
@Controller
@RequestMapping("/admin/member/")
public class MemberManageController {

    @Resource(name = "memberManageService")
    private MemberManageService memberManageService;

    @Resource(name = "memberLevelService")
    private MemberLevelService memberLevelService;

    @Resource(name = "smsSendService")
    private SmsSendService smsSendService;

    @Resource(name = "emailSendService")
    private EmailSendService emailSendService;

    /**
     * <pre>
     * 작성일 : 2016. 5. 3.
     * 작성자 : dong
     * 설명   : 회원 리스트 화면
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 3. dong - 최초생성
     * </pre>
     *
     * @param memberManageSO
     * @return
     */
    @RequestMapping("/manage/member")
    public ModelAndView viewMemListPaging(@Validated MemberManageSO memberManageSO, BindingResult bindingResult)
            throws Exception {
        ModelAndView mv = new ModelAndView("/admin/member/manage/MemberList");
        mv.addObject(memberManageSO);

        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            return mv;
        }

        memberManageSO.setPrcId(SessionDetailHelper.getDetails().getUsername());
        memberManageSO.setPrcNm(SessionDetailHelper.getDetails().getSession().getMemberNm());

        try {
        	// 화면 최초 로딩시 가입일 검색조건을 오늘로 default setting
        	if ( (memberManageSO.getJoinStDttm() == null && !"".equals(memberManageSO.getJoinStDttm()))
        			&& (memberManageSO.getJoinEndDttm() == null && !"".equals(memberManageSO.getJoinEndDttm())) ) {
            	
            	SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
                String stDttm = df.format(new Date());
                String endDttm = df.format(new Date());
                memberManageSO.setJoinStDttm(stDttm);
                memberManageSO.setJoinEndDttm(endDttm);
            }
            // 회원 리스트 조회
            mv.addObject("resultListModel", memberManageService.viewMemListPaging(memberManageSO));

            // 검색조건 SO
            mv.addObject("memberManageSO", memberManageSO);
        } catch (Exception e) {
            throw new Exception("회원 정보 조회 오류");
        }

        // 사이트 번호
        mv.addObject("siteNo", SessionDetailHelper.getDetails().getSiteNo());

        return mv;
    }

    /**
     * <pre>
     * 작성일 : 2018. 8. 23.
     * 작성자 : hskim
     * 설명   : 사업자 회원 승인 처리
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2018. 8. 23. hskim - 최초생성
     * </pre>
     *
     * @param MemberManagePO
     * @return
     */
    @RequestMapping("/manage/member-info-confirm")
    public @ResponseBody ResultModel<MemberManagePO> confirmMemInfo(@Validated(UpdateGroup.class) MemberManagePO po,
            BindingResult bindingResult,HttpServletRequest mRequest) throws Exception {

        // 등록자 번호
        po.setRegrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());

        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }

        ResultModel<MemberManagePO> result = memberManageService.confirmMemInfo(po);

        return result;
    }
    
    /**
     * <pre>
     * 작성일 : 2016. 5. 12.
     * 작성자 : dong
     * 설명   : 회원정보 수정
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 12. dong - 최초생성
     * </pre>
     *
     * @param MemberManagePO
     * @return
     */
    @RequestMapping("/manage/member-info-update")
    public @ResponseBody ResultModel<MemberManagePO> updateMemInfo(@Validated(UpdateGroup.class) MemberManagePO po,
            BindingResult bindingResult,HttpServletRequest mRequest) throws Exception {

        // 등록자 번호
        po.setRegrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());

        // if (po.getBirth() != null && po.getBirth() != "") {
        // po.setBirth(po.getBirth().replaceAll("-", ""));
        // }

        String[] birthArr = new String[3];
        if (po.getBirth() != null && po.getBirth() != "") {
            birthArr = po.getBirth().split("-");
            if(birthArr.length>0) {
                if (birthArr[0] != null && !birthArr[0].equals(""))
                    po.setBornYear(birthArr[0]);
                if (birthArr[1] != null && !birthArr[1].equals(""))
                    po.setBornMonth(birthArr[1]);
            }
        }

        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }

        // 파일 정보 등록
        if(("05").equals(po.getMemberTypeCd())) {   // 사업자등록증
            List<FileVO> list = FileUtil.getFileListFromRequest(mRequest,FileUtil.getPath(UploadConstants.PATH_ATTACH, UploadConstants.PATH_BIZ));

            if (list != null && list.size() == 1) {
                po.setBizFilePath(list.get(0).getFilePath());
                po.setBizFileNm(list.get(0).getFileName());
                po.setBizOrgFileNm(list.get(0).getFileOrgName());
                po.setBizFileSize(list.get(0).getFileSize());
            }
        } else if(("04").equals(po.getMemberTypeCd())) {    // 프로필 이미지
            List<FileVO> list = FileUtil.getFileListFromRequest(mRequest,FileUtil.getPath(UploadConstants.PATH_IMAGE, UploadConstants.PATH_PROFILE));

            if (list != null && list.size() == 1) {
                po.setImgPath(list.get(0).getFilePath());
                po.setImgNm(list.get(0).getFileName());
                po.setImgOrgNm(list.get(0).getFileOrgName());
            }
        }

        ResultModel<MemberManagePO> result = memberManageService.updateMemInfo(po);
        result.setMessage(MessageUtil.getMessage("biz.memberManage.updateMemInfo"));

        return result;
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 12.
     * 작성자 : dong
     * 설명   : 회원 상세 화면
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 12. dong - 최초생성
     * </pre>
     *
     * @param memberManageSO
     * @return
     * @throws Exception 
     */
    @RequestMapping("/manage/memberinfo-detail")
    public ModelAndView viewMemInfoDtl(@Validated MemberManageSO memberManageSO, BindingResult bindingResult) throws Exception {
        ModelAndView mv = new ModelAndView("/admin/member/manage/MemberDtlInfoView");

        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            return mv;
        }

        memberManageSO.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
        memberManageSO.setPrcId(SessionDetailHelper.getDetails().getUsername());
        memberManageSO.setPrcNm(SessionDetailHelper.getDetails().getSession().getMemberNm());

        // 회원 상세 조회
        ResultModel<MemberManageVO> resultModel = memberManageService.viewMemInfoDtl(memberManageSO);
        // 사업자등록번호 하이픈 추가
        MemberManageVO data = resultModel.getData();
        if(data.getBizRegNo() != null && data.getBizRegNo() != "") {
            data.setBizRegNo(data.getBizRegNo().replaceAll("^(\\d{0,3})(\\d{0,2})(\\d{0,5})$", "$1-$2-$3"));
            resultModel.setData(data);
        }
        mv.addObject("resultModel", resultModel);

        // 회원등급 리스트 조회
//        mv.addObject("memberGradeListModel", memberLevelService.selectGradeGetList());

        // 관리자 권한 코드
        mv.addObject("authCd", SessionDetailHelper.getDetails().getSession().getAuthGbCd());

        // 슈퍼관리자
        mv.addObject("adminNo", memberManageService.selectAdmin(memberManageSO));

        // 처리 로그 조회
        mv.addObject("prcLog", memberManageService.selectLog(memberManageSO));

        // 사이트 번호
        mv.addObject("siteNo", SessionDetailHelper.getDetails().getSiteNo());
        
        // 보유 가맹점 포인트 조회
        // 인터페이스로 보유 포인트 조회
//        Map<String, Object> param = new HashMap<>();
//        param.put("memNo", memberManageSO.getMemberNo());
//        String integrationMemberGbCd = resultModel.getData().getIntegrationMemberGbCd();
//        if("03".equals(integrationMemberGbCd)){
//            Map<String, Object> point_res = InterfaceUtil.send("IF_MEM_008", param);
//
//            if ("1".equals(point_res.get("result"))) {
//            }else{
//                point_res.put("mtPoint",0);
//            }
//            mv.addObject("mtPoint", String.valueOf(point_res.get("mtPoint")));
//        }else {
//        	mv.addObject("mtPoint", 0);
//        }

        return mv;
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 12.
     * 작성자 : dong
     * 설명   : 회원 상세 화면(Ajax)
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 12. dong - 최초생성
     * </pre>
     *
     * @param memberManageSO
     * @return
     */
    @RequestMapping("/manage/member-info-detail")
    public @ResponseBody ResultModel<MemberManageVO> selectMemInfoDtl(@Validated MemberManageSO memberManageSO,
            BindingResult bindingResult) {
        ModelAndView mv = new ModelAndView("/admin/member/manage/MemberDtlInfoView");

        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }

        memberManageSO.setPrcId(SessionDetailHelper.getDetails().getUsername());
        memberManageSO.setPrcNm(SessionDetailHelper.getDetails().getSession().getMemberNm());

        // 회원 상세 조회
        ResultModel<MemberManageVO> result = memberManageService.viewMemInfoDtl(memberManageSO);

        return result;
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 16.
     * 작성자 : dong
     * 설명   : 회원 탈퇴
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 16. dong - 최초생성
     * </pre>
     *
     * @param MemberManagePO
     * @return
     */
    @RequestMapping("/manage/member-delete")
    public @ResponseBody ResultModel<MemberManagePO> deleteMem(@Validated(DeleteGroup.class) MemberManagePO po,
            BindingResult bindingResult) throws Exception {

        // 삭제자 번호
        po.setRegrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());

        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }

        ResultModel<MemberManagePO> result = memberManageService.deleteMem(po);
        result.setMessage(MessageUtil.getMessage("biz.memberManage.deleteMem"));

        return result;
    }

    /**
     * <pre>
     * 작성일 : 2016. 6. 02.
     * 작성자 : dong
     * 설명   : 쿠폰 리스트 조회
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 02. dong - 최초생성
     * </pre>
     *
     * @param SavedmnPointSO
     * @param
     * @return
     */
    @RequestMapping("/manage/coupon-list")
    public @ResponseBody ResultListModel<MemberManageVO> selectCouponGetPaging(MemberManageSO so,
            BindingResult bindingResult) {

        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }

        ResultListModel<MemberManageVO> result = memberManageService.selectCouponGetPaging(so);

        return result;
    }

    /**
     * <pre>
     * 작성일 : 2016. 6. 06.
     * 작성자 : dong
     * 설명   : 자주쓰는 배송지 리스트 조회
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 06. dong - 최초생성
     * </pre>
     *
     * @param SavedmnPointSO
     * @param
     * @return
     */
    @RequestMapping("/manage/frequently-delivery-list")
    public @ResponseBody ResultListModel<MemberManageVO> selectDeliveryList(MemberManageSO so,
            BindingResult bindingResult) {

        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }

        ResultListModel<MemberManageVO> result = memberManageService.selectDeliveryList(so);

        return result;
    }

    /**
     * <pre>
     * 작성일 : 2016. 6. 8.
     * 작성자 : dong
     * 설명   : 휴먼 회원 리스트 화면
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 8. dong - 최초생성
     * </pre>
     *
     * @param memberManageSO
     * @return
     */
    @RequestMapping("/manage/dormant-member")
    public ModelAndView viewDormantMemberListPaging(@Validated MemberManageSO memberManageSO,
            BindingResult bindingResult) {
        ModelAndView mv = new ModelAndView("/admin/member/manage/DormantMemberList");
        mv.addObject(memberManageSO);

        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            return mv;
        }

        memberManageSO.setPrcId(SessionDetailHelper.getDetails().getUsername());
        memberManageSO.setPrcNm(SessionDetailHelper.getDetails().getSession().getMemberNm());

//        if (StringUtils.isEmpty(memberManageSO.getDormantStDttm()) || StringUtils.isEmpty(memberManageSO.getDormantEndDttm())) {
//            SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
//            String stDttm = df.format(new Date());
//            String endDttm = df.format(new Date());
//            memberManageSO.setDormantStDttm(stDttm);
//            memberManageSO.setDormantEndDttm(endDttm);
//        }

        // 검색조건 SO
        mv.addObject("memberManageSO", memberManageSO);

        // 회원 리스트 조회
        mv.addObject("resultListModel", memberManageService.viewDormantMemGetPaging(memberManageSO));

        return mv;
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 12.
     * 작성자 : dong
     * 설명   : 휴면 회원 상세 화면
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 12. dong - 최초생성
     * </pre>
     *
     * @param memberManageSO
     * @return
     */
    @RequestMapping("/manage/dormant-memberinfo-detail")
    public ModelAndView viewDormantMemInfoDtl(@Validated MemberManageSO memberManageSO, BindingResult bindingResult) {
        ModelAndView mv = new ModelAndView("/admin/member/manage/DormantMemberDtlInfoView");

        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            return mv;
        }

        memberManageSO.setPrcId(SessionDetailHelper.getDetails().getUsername());
        memberManageSO.setPrcNm(SessionDetailHelper.getDetails().getSession().getMemberNm());

        // 회원 상세 조회
        mv.addObject("resultModel", memberManageService.viewDormantMemDtl(memberManageSO));

        // 처리 로그 조회
        mv.addObject("prcLog", memberManageService.selectLog(memberManageSO));
        return mv;
    }

    /**
     * <pre>
     * 작성일 : 2016. 6. 8.
     * 작성자 : dong
     * 설명   : 탈퇴 회원 리스트 화면
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 8. dong - 최초생성
     * </pre>
     *
     * @param memberManageSO
     * @return
     */
    @RequestMapping("/manage/leaving-member")
    public ModelAndView viewWithdrawalMemberListPaging(@Validated MemberManageSO memberManageSO,
            BindingResult bindingResult) {
        ModelAndView mv = new ModelAndView("/admin/member/manage/WithdrawalMemberList");
        mv.addObject(memberManageSO);

        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            return mv;
        }

        memberManageSO.setPrcId(SessionDetailHelper.getDetails().getUsername());
        memberManageSO.setPrcNm(SessionDetailHelper.getDetails().getSession().getMemberNm());

        // 검색조건 SO
        mv.addObject("memberManageSO", memberManageSO);

        // 회원 리스트 조회
        mv.addObject("resultListModel", memberManageService.viewWithdrwMemPaging(memberManageSO));

        return mv;
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 12.
     * 작성자 : dong
     * 설명   : 탈퇴 회원 상세 화면
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 12. dong - 최초생성
     * </pre>
     *
     * @param memberManageSO
     * @return
     */
    @RequestMapping("/manage/withdrawal-member-info")
    public ModelAndView viewWithdrawalMemInfoDtl(@Validated MemberManageSO memberManageSO,
            BindingResult bindingResult) {
        ModelAndView mv = new ModelAndView("/admin/member/manage/WithdrawalMemberDtlInfoView");

        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            return mv;
        }

        memberManageSO.setPrcId(SessionDetailHelper.getDetails().getUsername());
        memberManageSO.setPrcNm(SessionDetailHelper.getDetails().getSession().getMemberNm());

        // 회원 상세 조회
        mv.addObject("resultModel", memberManageService.viewWithdrwMemDtl(memberManageSO));

        // 처리 로그 조회
        mv.addObject("prcLog", memberManageService.selectLog(memberManageSO));

        return mv;
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 16.
     * 작성자 : dong
     * 설명   : 회원 휴면
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 16. dong - 최초생성
     * </pre>
     *
     * @param MemberManagePO
     * @return
     */
    @RequestMapping("/manage/dormant-member-update")
    public @ResponseBody ResultModel<MemberManagePO> updateDormantMem(MemberManageSO so) throws Exception {
        Long[] selectMemberList = so.getUpdMemberNo();
        ResultModel<MemberManagePO> result = null;

        for (int i = 0; i < selectMemberList.length; i++) {
            MemberManagePO po = new MemberManagePO();
            po.setMemberNo(selectMemberList[i]);
            if (SessionDetailHelper.getDetails().getSession().getMemberNo() != null) {
                po.setDelrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
                po.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
            }
            result = memberManageService.updateDormantMem(po);
        }

        return result;
    }

    /**
     * <pre>
     * 작성일 : 2016. 6. 30.
     * 작성자 : dong
     * 설명   : 회원조회POPUP _ 쿠폰 대상자를 찾기 위한
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 30. dong - 최초생성
     * </pre>
     *
     * @param memberManageSO
     * @param bindingResult
     * @return
     */
    @RequestMapping("/manage/member-list-pop")
    public @ResponseBody ResultListModel<MemberManageVO> viewMemListPagingPop(MemberManageSO memberManageSO,
            BindingResult bindingResult) {

        ResultListModel<MemberManageVO> list = memberManageService.viewMemListPaging(memberManageSO);
        return list;
    }

    /**
     * <pre>
     * 작성일 : 2016. 8. 16.
     * 작성자 : dong
     * 설명   : 검색 조건에 따른 회원리스트 Excel 다운로드
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 8. 16. dong - 최초생성
     * </pre>
     *
     * @return
     */
    @RequestMapping("/manage/memberinfo-excel")
    public String viewMemListExcel(MemberManageSO memberManageSO, BindingResult bindingResult, Model model) {
        memberManageSO.setOffset(10000000);
        List<MemberManageVO> resultList = memberManageService.viewMemListCommon(memberManageSO);

        // 엑셀의 헤더 정보 세팅
        String[] headerName = new String[] { "번호", "회원유형", "상태", "가입유형",
                                             "이름", "아이디", "이메일", "휴대폰번호",
                                             "가입일", "포인트" };
        // 엑셀에 출력할 데이터 세팅
        String[] fieldName = new String[] { "pagingNum", "memberTypeNm", "memberStatusNm", "joinPathNm",
                                            "memberNm", "loginId", "email","mobile",
                                            "joinDttm", "prcPoint" };
        model.addAttribute(CommonConstants.EXCEL_PARAM_NAME,new ExcelViewParam("회원 목록", headerName, fieldName, resultList));// 파일명
        model.addAttribute(CommonConstants.EXCEL_PARAM_FILE_NAME, "회원목록_" + DateUtil.getNowDate()); // 엑셀

        return View.excelDownload();
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
    @RequestMapping("/manage/attach-file-delete")
    public @ResponseBody ResultModel<AtchFilePO> deleteAtchFile(@Validated(DeleteGroup.class) MemberManagePO po,
                                                                BindingResult bindingResult) throws Exception {
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }

        ResultModel<AtchFilePO> result = memberManageService.deleteAtchFile(po);

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
     * @param po
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/manage/download")
    public String fileDownload(ModelMap map, MemberManagePO po) throws Exception {
        FileVO file;

        file = memberManageService.selectAtchFileDtl(po);

        FileViewParam fileView = new FileViewParam();

        fileView.setFilePath(FileUtil.getAllowedFilePath(file.getFilePath()));
        fileView.setFileName(FileUtil.getAllowedFilePath(file.getFileOrgName()));
        map.put(AdminConstants.FILE_PARAM_NAME, fileView);

        return View.fileDownload();
    }

    /**
     * <pre>
     * 작성일 : 2023. 2. 2.
     * 작성자 : truesol
     * 설명   : 닉네임 중복확인
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2023. 2. 2. truesol - 최초생성
     * </pre>
     *
     * @param so
     * @return
     * @throws Exception
     */
    @RequestMapping("/manage/duplication-nickname-check")
    public @ResponseBody ResultModel<MemberManageVO> checkDuplicationNickname(MemberManageVO so) throws Exception {
        ResultModel<MemberManageVO> result = new ResultModel<>();
        int nickname = memberManageService.checkDuplicationNickname(so);
        if(nickname > 0) {
            result.setSuccess(false);
        } else {
            result.setSuccess(true);
        }
        return result;
    }

    @RequestMapping("/manage/stamp-list")
    public @ResponseBody ResultListModel<MemberManageVO> selectStampList(MemberManageSO memberManageSO, BindingResult bindingResult) {
        ResultListModel<MemberManageVO> list = memberManageService.selectStampList(memberManageSO);
        return list;
    }
}
