package net.danvi.dmall.admin.web.view.operation.controller;

import java.io.File;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import com.fasterxml.jackson.databind.ObjectMapper;
import net.danvi.dmall.biz.app.member.level.model.MemberLevelVO;
import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartRequest;
import org.springframework.web.servlet.ModelAndView;

import dmall.framework.common.constants.UploadConstants;
import dmall.framework.common.model.FileVO;
import dmall.framework.common.model.ResultListModel;
import dmall.framework.common.model.ResultModel;
import dmall.framework.common.util.FileUtil;
import dmall.framework.common.util.SiteUtil;
import lombok.extern.slf4j.Slf4j;
import net.danvi.dmall.biz.app.member.level.service.MemberLevelService;
import net.danvi.dmall.biz.app.member.manage.model.MemberManageSO;
import net.danvi.dmall.biz.app.member.manage.model.MemberManageVO;
import net.danvi.dmall.biz.app.member.manage.service.MemberManageService;
import net.danvi.dmall.biz.app.operation.model.PushSendSO;
import net.danvi.dmall.biz.app.operation.model.PushSendVO;
import net.danvi.dmall.biz.app.operation.service.AppPushService;
import net.danvi.dmall.biz.app.setup.siteinfo.service.SiteInfoService;
import net.danvi.dmall.biz.system.remote.push.PushDelegateService;
import net.danvi.dmall.biz.system.security.SessionDetailHelper;
import net.danvi.dmall.core.remote.homepage.model.result.RemoteBaseResult;
import net.danvi.dmall.smsemail.model.request.PushSendPO;

/**
 * <pre>
 * 프로젝트명 : 41.admin.web
 * 작성일     : 2016. 5. 19.
 * 작성자     : user
 * 설명       :
 * </pre>
 */
@Slf4j
@Controller
@RequestMapping("/admin/operation")
public class AppPushController {
    @Resource(name = "memberManageService")
    private MemberManageService memberManageService;

    @Resource(name = "memberLevelService")
    private MemberLevelService memberLevelService;

    @Resource(name = "appPushService")
    private AppPushService appPushService;

    @Resource(name = "siteInfoService")
    private SiteInfoService siteInfoService;
    
    @Resource(name = "pushDelegateService")
    private PushDelegateService pushDelegateService;

    /**
     * <pre>
     * 작성일 : 2016. 5. 18.
     * 작성자 : dong
     * 설명   : SMS 발송 목록 화면
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 18. dong - 최초생성
     * </pre>
     *
     * @return
     */
    @RequestMapping("/app")
    public ModelAndView viewAppSendMain(@Validated MemberManageSO memberManageSO, PushSendSO pushSendSo,
            BindingResult bindingResult) {
        ModelAndView mv = new ModelAndView("/admin/operation/app/AppSendMain");



        if (pushSendSo.getPageGb() == null || "3".equals(pushSendSo.getPageGb())) {
        	

            
            if (memberManageSO.getSearchAlarmGb() == null) {
            	/*memberManageSO.setSearchAlarmGb("01");*/
            }
            


            //MemberManageSO so = new MemberManageSO();
            //so.setSort("REG_DTTM");
            // 회원 전체 조회
            /*List<MemberManageVO> resultListModelTotal = memberManageService.viewTotalPushList(memberManageSO);
            mv.addObject("resultListModelTotal", resultListModelTotal);
            mv.addObject("totalSize", resultListModelTotal.size());*/



            // 회원 검색 조회
            /*memberManageSO.setOffset(10000000);
            List<MemberManageVO> resultListModelSearch = memberManageService.viewPushListCommon(memberManageSO);
            mv.addObject("resultListModelSearch", resultListModelSearch);
            mv.addObject("searchSize", resultListModelSearch.size());*/
        } else {

            ResultListModel result = new ResultListModel();
            result.setTotalRows(0);
            result.setFilterdRows(0);
            mv.addObject("resultListModel", result);

            if (pushSendSo.getPushNo() != null && !"".equals(pushSendSo.getPushNo())) {
                //푸시 상세내역조회
                mv.addObject("resultPush", appPushService.selectPushManagerInfo(pushSendSo));
            } 
        }
        


        return mv;
    }

    /**
     * <pre>
     * 작성일 : 2023. 1. 27.
     * 작성자 : truesol
     * 설명   : 개별발송 화면
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2023. 1. 27. truesol - 최초생성
     * </pre>
     *
     * @param pushSendSo
     * @return
     */
    @RequestMapping("/app/individualSend")
    public ModelAndView viewAppIndividualSend(@Validated MemberManageSO memberManageSO, PushSendSO pushSendSo, BindingResult bindingResult) throws Exception {
        ModelAndView mv = new ModelAndView("/admin/operation/app/AppIndividualSend");

        mv.addObject(memberManageSO);

        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            return mv;
        }

        // 화면 최초 로딩시 가입일 검색조건을 오늘로 default setting
        if ( (memberManageSO.getJoinStDttm() == null && !"".equals(memberManageSO.getJoinStDttm()))
                && (memberManageSO.getJoinEndDttm() == null && !"".equals(memberManageSO.getJoinEndDttm())) ) {

            SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
            String stDttm = df.format(new Date());
            String endDttm = df.format(new Date());
            memberManageSO.setJoinStDttm(stDttm);
            memberManageSO.setJoinEndDttm(endDttm);
        }

        memberManageSO.setSidx("REG_DTTM");
        memberManageSO.setSord("DESC");

        memberManageSO.setPrcId(SessionDetailHelper.getDetails().getUsername());
        memberManageSO.setPrcNm(SessionDetailHelper.getDetails().getSession().getMemberNm());
        memberManageSO.setMemberNo(SessionDetailHelper.getDetails().getSession().getMemberNo());

        // 회원등급 리스트 조회
        mv.addObject("memberGradeListModel", memberLevelService.selectGradeGetList());

        // 회원 리스트 조회
        mv.addObject("resultListModel", memberManageService.viewSearchPushListPaging(memberManageSO));

        // 검색된 회원 목록 json을 response
//        ObjectMapper mapper = new ObjectMapper();
//        mv.addObject("srchMemList", mapper.writeValueAsString(memberManageService.selectMemListBySend(memberManageSO)));

        // 검색조건 SO
        mv.addObject("memberManageSO", memberManageSO);
        mv.addObject("pushSendSo", pushSendSo);

        mv.addObject("siteNo", SessionDetailHelper.getDetails().getSiteNo());

        return mv;
    }

    /**
     * <pre>
     * 작성일 : 2023. 7. 4.
     * 작성자 : slims
     * 설명   : 검색조건에 따른 회원 정보 리스트 조회
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2023. 7. 4. slims - 최초생성
     * </pre>
     *
     * @param so
     * @param bindingResult
     * @return
     */

    @RequestMapping("/app/member-list-by-send")
    public @ResponseBody List<MemberManageVO> viewMemListBySend(MemberManageSO memberManageSO) {
        memberManageSO.setAppToken("Y");

        List<MemberManageVO> resultListModel = memberManageService.selectMemListBySend(memberManageSO);
        return resultListModel;
    }

    /**
     * <pre>
     * 작성일 : 2023. 1. 27.
     * 작성자 : truesol
     * 설명   : 자동 발송 설정 화면
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2023. 1. 27. truesol - 최초생성
     * </pre>
     *
     * @param pushSendSo
     * @return
     */
    @RequestMapping("/app/autoSendSet")
    public ModelAndView viewAppAutoSendSet(PushSendSO pushSendSo) {
        ModelAndView mv = new ModelAndView("/admin/operation/app/AppAutoSendSet");
        return mv;
    }

    /**
     * <pre>
     * 작성일 : 2023. 1. 27.
     * 작성자 : truesol
     * 설명   : 발송내역 화면
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2023. 1. 27. truesol - 최초생성
     * </pre>
     *
     * @param pushSendSo
     * @return
     */
    @RequestMapping("/app/sendHist")
    public ModelAndView viewAppIndividualSendHist(PushSendSO pushSendSo) {
        ModelAndView mv = new ModelAndView("/admin/operation/app/AppIndividualSendHist");
        return mv;
    }

    /**
     * <pre>
     * 작성일 : 2023. 1. 27.
     * 작성자 : truesol
     * 설명   : 발송내역 상세 화면
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2023. 1. 27. truesol - 최초생성
     * </pre>
     *
     * @param pushSendSo
     * @return
     */
    @RequestMapping("/app/sendHistDtl")
    public ModelAndView viewAppIndividualSendHistDtl(PushSendSO pushSendSo) {
        ModelAndView mv = new ModelAndView("/admin/operation/app/AppIndividualSendDetailHist");
        //푸시 상세내역조회
        mv.addObject("resultPush", appPushService.selectPushManagerInfo(pushSendSo));
        //푸시 수신대상 조회
        PushSendVO po = new PushSendVO();
        po.setPushNo(pushSendSo.getPushNo());
        mv.addObject("receiverList", appPushService.selectPushCondition(po));
        return mv;
    }
    
    /**
     * <pre>
     * 작성일 : 2018. 8. 16.
     * 작성자 : khy
     * 설명   : APP PUSH 전송
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
    @RequestMapping("/app-push")
    public @ResponseBody ResultModel<PushSendVO> appPush(PushSendVO vo, HttpServletRequest mRequest) throws Exception {
    	
    	ResultModel<PushSendVO> result = new ResultModel<>();
    	boolean bflag = true ;
    	
        vo.setSenderNm(SessionDetailHelper.getDetails().getSession().getMemberNm());
        vo.setSenderNo(String.valueOf(SessionDetailHelper.getDetails().getSession().getMemberNo()));
        
        // 파일 등록
        List<FileVO> list = FileUtil.getFileListFromRequest(mRequest, FileUtil.getPath(UploadConstants.PATH_IMAGE, UploadConstants.PATH_PUSH));
        
        if (list != null) {
            for (int i = 0; i < list.size(); i++) {
                vo.setFilePath(list.get(i).getFilePath());
                vo.setFileNm(list.get(i).getFileName());
                vo.setOrgFileNm(list.get(i).getFileOrgName());
            }
        }		
        
        // 푸시번호 
        String pushNo = appPushService.selectPushNo();
        vo.setPushNo(pushNo);
       
        // 푸시전송
    	appPushService.insertPush(vo, mRequest);

    	// 즉시호출
    	if ("1".equals(vo.getSendType())) {
	    	PushSendPO po = new PushSendPO();
	    	po.setPushNo(pushNo);
	    	po.setRecvCndtGb(vo.getRecvCndtGb());
	    	po.setUpdrNo(vo.getSenderNo());
	    	po.setAlarmGb(vo.getAlarmGb());
	    	//푸시서버 연계
	    	RemoteBaseResult rst = pushDelegateService.isConnect(po);
	    	bflag = rst.getSuccess();
	    	
	    	if (bflag) {
		    	pushDelegateService.send(po);
	    	}
    	}
    	
    	if (!bflag) {
    		appPushService.deletePush(vo);
    	}
    	
    	result.setSuccess(bflag);
    	
        return result;
    }
    
    
    /**
     * <pre>
     * 작성일 : 2018. 8. 13.
     * 작성자 : khy
     * 설명   : 검색조건에 따른 PUSH 발송내역 조회
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2018. 8. 13. khy - 최초생성
     * </pre>
     *
     * @param so
     * @param bindingResult
     * @return
     */

    @RequestMapping("/app-history-list")
    public @ResponseBody ResultListModel<PushSendVO> selectAppHstPaging(PushSendSO pushSendSO) {
    	pushSendSO.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
        ResultListModel<PushSendVO> resultListModel = appPushService.selectPushHstPaging(pushSendSO);
        
        return resultListModel;
    }
    
    
    /**
     * <pre>
     * 작성일 : 2018. 8. 21.
     * 작성자 : khy
     * 설명   : APP PUSH 전송
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2018. 8. 21. khy - 최초생성
     * </pre>
     *
     * @param po
     * @param bindingResult
     * @return
     * @throws Exception
     */
    @RequestMapping("/update-push-manager")
    public @ResponseBody ResultModel<PushSendVO> updatePushManager(PushSendVO vo) throws Exception {
    	
    	ResultModel<PushSendVO> result = appPushService.updatePushManager(vo);
    	
        return result;
    }
    
    
    
    /**
     * <pre>
     * 작성일 : 2018. 8. 21.
     * 작성자 : khy
     * 설명   : APP PUSH 전송 취소
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2018. 8. 21. khy - 최초생성
     * </pre>
     *
     * @param po
     * @param bindingResult
     * @return
     * @throws Exception
     */
    @RequestMapping("/app-push-cancel")
    public @ResponseBody ResultModel<PushSendVO> updatePushCancel(PushSendVO vo) throws Exception {
    	
        vo.setCancelerNo(String.valueOf(SessionDetailHelper.getDetails().getSession().getMemberNo()));
    	ResultModel<PushSendVO> result = appPushService.updatePushCancel(vo);
    	
        return result;
    }
    

}
