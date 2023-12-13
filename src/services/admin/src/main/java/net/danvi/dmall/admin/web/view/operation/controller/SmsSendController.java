package net.danvi.dmall.admin.web.view.operation.controller;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.annotation.Resource;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import net.danvi.dmall.admin.web.common.view.View;
import net.danvi.dmall.biz.app.operation.model.*;

import org.apache.commons.lang.StringUtils;
import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import lombok.extern.slf4j.Slf4j;
import net.danvi.dmall.biz.app.member.level.service.MemberLevelService;
import net.danvi.dmall.biz.app.member.manage.model.MemberManageSO;
import net.danvi.dmall.biz.app.member.manage.model.MemberManageVO;
import net.danvi.dmall.biz.app.member.manage.service.MemberManageService;
import net.danvi.dmall.biz.app.operation.service.SmsSendService;
import net.danvi.dmall.biz.app.setup.siteinfo.model.SiteSO;
import net.danvi.dmall.biz.app.setup.siteinfo.model.SiteVO;
import net.danvi.dmall.biz.app.setup.siteinfo.service.SiteInfoService;
import net.danvi.dmall.biz.system.security.SessionDetailHelper;
import net.danvi.dmall.biz.system.validation.UpdateGroup;
import dmall.framework.common.exception.CustomException;
import dmall.framework.common.exception.JsonValidationException;
import dmall.framework.common.model.ResultListModel;
import dmall.framework.common.model.ResultModel;

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
public class SmsSendController {
    @Resource(name = "memberManageService")
    private MemberManageService memberManageService;

    @Resource(name = "memberLevelService")
    private MemberLevelService memberLevelService;

    @Resource(name = "smsSendService")
    private SmsSendService smsSendService;

    @Resource(name = "siteInfoService")
    private SiteInfoService siteInfoService;

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
    @RequestMapping("/sms/individualSend")
    public ModelAndView viewSmsIndividualSend(@Validated MemberManageSO memberManageSO, SmsSendSO smsSendSo,
            BindingResult bindingResult) throws Exception {
        ModelAndView mv = new ModelAndView("/admin/operation/sms/SmsIndividualSend");

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

        smsSendSo.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
        memberManageSO.setPrcId(SessionDetailHelper.getDetails().getUsername());
        memberManageSO.setPrcNm(SessionDetailHelper.getDetails().getSession().getMemberNm());
        memberManageSO.setMemberNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
//        memberManageSO.setSmsRecvYn("Y");

        // 회원등급 리스트 조회
//        mv.addObject("memberGradeListModel", memberLevelService.selectGradeGetList());

        /*MemberManageSO so = new MemberManageSO();
        so.setSort("REG_DTTM");*/
        // 회원 전체 조회
        /*List<MemberManageVO> resultListModelTotal = memberManageService.viewMemList(so);*/
        /*mv.addObject("resultListModelTotal", resultListModelTotal);*/
        /*mv.addObject("totalSize", resultListModelTotal.size());*/

        // 회원 리스트 조회
//        memberManageSO.setSmsSearchYn("Y");
        mv.addObject("resultListModel", memberManageService.viewMemListPaging(memberManageSO));

        // 회원 검색 조회 -- 성능 저하로인한 처리제외
        /*memberManageSO.setOffset(1000);
        List<MemberManageVO> resultListModelSearch = memberManageService.viewMemListCommon(memberManageSO);*/
        /*List<MemberManageVO> resultListModelSearch =  memberManageService.viewMemListPaging(memberManageSO).getResultList();*/
        /*mv.addObject("resultListModelSearch", resultListModelSearch);*/
        /*mv.addObject("searchSize", resultListModelSearch!=null?resultListModelSearch.size():0);*/

        // 검색조건 SO
        mv.addObject("memberManageSO", memberManageSO);

        // 검색된 회원 목록 json을 response
        //ObjectMapper mapper = new ObjectMapper();
        //mv.addObject("srchMemList", mapper.writeValueAsString(memberManageService.selectMemListBySend(memberManageSO)));

        // 발신자 번호 정보
        String adminSmsNo = smsSendService.selectAdminSmsNo(smsSendSo);
        mv.addObject("adminSmsNo", adminSmsNo);

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

    @RequestMapping("/member-list-by-send")
    public @ResponseBody List<MemberManageVO> viewMemListBySend(MemberManageSO memberManageSO) {

        List<MemberManageVO> resultListModel = memberManageService.selectMemListBySend(memberManageSO);
        return resultListModel;
    }

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
    @RequestMapping("/sms/individualSendHist")
    public ModelAndView viewSmsIndividualHist(SmsSendSO smsSendSo) {
        ModelAndView mv = new ModelAndView("/admin/operation/sms/SmsIndividualSendHist");

        smsSendSo.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());

        mv.addObject("smsSendSo", smsSendSo);

        return mv;
    }

    /**
     * <pre>
     * 작성일 : 2023. 1. 27.
     * 작성자 : truesol
     * 설명   : SMS 자동 발송 설정 화면
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2023. 1. 27. truesol - 최초생성
     * </pre>
     *
     * @param smsSendSo
     * @return
     */
    @RequestMapping("/sms/autoSendSet")
    public ModelAndView viewSmsAutoSendSet(SmsSendSO smsSendSo) {
        ModelAndView mv = new ModelAndView("/admin/operation/sms/SmsAutoSendSet");

        smsSendSo.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());

        mv.addObject("smsSendSo", smsSendSo);

        // 관리자 수신 번호 목록
        List<SmsSendVO> adminRecvNo = smsSendService.selectAdminNo(smsSendSo);
        mv.addObject("adminRecvNo", adminRecvNo);

        // 상태별 자동발송 SMS 목록
        List<SmsSendVO> autoSendList = smsSendService.selectStatusSms(smsSendSo);
        mv.addObject("autoSendList", autoSendList);

        return mv;
    }

    /**
     * <pre>
     * 작성일 : 2023. 1. 27.
     * 작성자 : truesol
     * 설명   : SMS 자동 발송 내역 화면
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2023. 1. 27. truesol - 최초생성
     * </pre>
     *
     * @param smsSendSo
     * @return
     */
    @RequestMapping("/sms/autoSendHist")
    public ModelAndView viewSmsAutoSendHist(SmsSendSO smsSendSo) {
        ModelAndView mv = new ModelAndView("/admin/operation/sms/SmsAutoSendHist");

        smsSendSo.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());

        mv.addObject("smsSendSo", smsSendSo);

        return mv;
    }
    /**
     * <pre>
     * 작성일 : 2016. 5. 4.
     * 작성자 : dong
     * 설명   : 검색조건에 따른 회원 정보 리스트 조회
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

    @RequestMapping("/member-list")
    public @ResponseBody ResultListModel<MemberManageVO> viewMemListPaging(MemberManageSO memberManageSO) {
        memberManageSO.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
        ResultListModel<MemberManageVO> resultListModel = memberManageService.viewMemListPaging(memberManageSO);
        return resultListModel;
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 4.
     * 작성자 : dong
     * 설명   : 검색조건에 따른 SMS 발송내역 조회
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

    @RequestMapping("/sms-history-list")
    public @ResponseBody ResultListModel<SmsSendVO> selectSmsHstPaging(SmsSendSO smsSendSo) {
        smsSendSo.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
        ResultListModel<SmsSendVO> resultListModel = smsSendService.selectSmsHstPaging(smsSendSo);
        return resultListModel;
    }

    /**
     * <pre>
     * 작성일 : 2016. 7. 7.
     * 작성자 : dong
     * 설명   : SMS 발송 조회
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 4. dong - 최초생성
     * </pre>
     *
     * @param so
     * @param bindingResult
     * @return
     * @throws Exception
     */

    @RequestMapping("/sms-history-info")
    public @ResponseBody ResultModel<SmsSendVO> selectSmsHstInfo(SmsSendSO smsSendSo) throws Exception {
        smsSendSo.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
        ResultModel<SmsSendVO> resultModel = smsSendService.selectSmsHstInfo(smsSendSo);
        return resultModel;
    }

    @RequestMapping("/sms/sendHistory")
    public @ResponseBody ResultListModel<SmsSendHistVO> getSendHistory(InnerSmsSendHistSO so) {
        return smsSendService.selectSendHistPaging(so);
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 4.
     * 작성자 : dong
     * 설명   : SMS 정보 저장
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
    @RequestMapping("/sms-send")
    public @ResponseBody ResultModel<SmsSendPO> sendSms(@Validated @RequestBody SmsSendSO so) throws Exception {
        ResultModel<SmsSendPO> result = null;
        List<SmsSendPO> listpo = new ArrayList<SmsSendPO>();
        // 추후 홈페이지 인터페이스를 통해 인증된 번호로 변경 예정

        SiteSO siteSo = new SiteSO();
        siteSo.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
        ResultModel<SiteVO> siteInfo = siteInfoService.selectSiteInfo(siteSo);

        SmsSendPO po = new SmsSendPO();
        po.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());

        // 발신번호 설정
        if (siteInfo.getData().getCertifySendNo() == null || ("").equals(siteInfo.getData().getCertifySendNo())) {
            throw new CustomException("biz.exception.operation.certifySendNoNull", new Object[] { "코드그룹" });
        } else {
            po.setSendTelno(siteInfo.getData().getCertifySendNo());
        }
        po.setSendWords("(광고)\n"+ so.getSendWords() +"\n수신거부 0808506177");
        // 회원, 관리자, 운영자 등등
        po.setSendTargetCd(so.getSendTargetCd());
        // sms, 장문
        po.setSendFrmCd(so.getSendFrmCd());
        po.setPossCnt(so.getPossCnt());
        po.setAutoSendYn("N");
        if (SessionDetailHelper.getDetails().getSession().getMemberNo() != null) {
            po.setRegrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
            po.setSenderNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
            po.setSenderId(SessionDetailHelper.getDetails().getSession().getLoginId());
            po.setSenderNm(SessionDetailHelper.getDetails().getSession().getMemberNm());
        }
        po.setFcallback(siteInfo.getData().getCertifySendNo().replaceAll("-", ""));

        if (StringUtils.equals("all", so.getSmsMember())) {
            so = new SmsSendSO();
            result = smsSendService.sendSms(po,"all",so);
        } else if (StringUtils.equals("search", so.getSmsMember())) {
            result = smsSendService.sendSms(po,"search",so);
        } else if (StringUtils.equals("select", so.getSmsMember())) {
            for (int i = 0; i < so.getReceiverNoSelect().length; i++) {
                // SMS 수신 동의
                if("N".equals((so.getReceiverSmsRecvYnSelect())[i])) {
                    continue;
                }
                // 080 수신거부
                if ("Y".equals((so.getReceiverRecvRjtYnSelect())[i])) {
                    continue;
                }

                SmsSendPO selectPo = new SmsSendPO();

                selectPo.setSiteNo(po.getSiteNo());

                selectPo.setSendWords(po.getSendWords());
                selectPo.setSendTargetCd(po.getSendTargetCd());
                selectPo.setSendFrmCd(po.getSendFrmCd());
                selectPo.setPossCnt(po.getPossCnt());
                selectPo.setAutoSendYn(po.getAutoSendYn());

                selectPo.setRegrNo(po.getRegrNo());
                selectPo.setSenderNo(po.getSenderNo());
                selectPo.setSenderId(po.getSenderId());
                selectPo.setSenderNm(po.getSenderNm());

                selectPo.setSendTelno(po.getSendTelno());
                selectPo.setFcallback(po.getFcallback());

                selectPo.setRecvTelNo((so.getRecvTelnoSelect())[i]);
                selectPo.setReceiverNo((so.getReceiverNoSelect())[i]);
                selectPo.setReceiverId((so.getReceiverIdSelect())[i]);
                selectPo.setReceiverNm((so.getReceiverNmSelect())[i]);
                selectPo.setFdestine((so.getRecvTelnoSelect())[i].replaceAll("-", ""));

                listpo.add(selectPo);
            }
            result = smsSendService.sendSms(listpo);
        }

        return result;
    }

    /*@RequestMapping("/sms-send")
    public @ResponseBody ResultModel<SmsSendPO> sendSms(SmsSendSO so) throws Exception {
        ResultModel<SmsSendPO> result = null;
        List<SmsSendPO> listpo = new ArrayList<SmsSendPO>();
        // 추후 홈페이지 인터페이스를 통해 인증된 번호로 변경 예정

        SiteSO siteSo = new SiteSO();
        siteSo.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
        ResultModel<SiteVO> siteInfo = siteInfoService.selectSiteInfo(siteSo);

        if (StringUtils.equals("all", so.getSmsMember())) {

        MemberManageSO memberManageSo = new MemberManageSO();
        so.setSort("REG_DTTM");
        // 회원 전체 조회
        List<MemberManageVO> resultListModelTotal = memberManageService.viewMemList(memberManageSo);
        for (int i = 0; i < resultListModelTotal.size(); i++) {
            *//*for (int i = 0; i < so.getReceiverNoTotal().length; i++) {*//*
            //전체회원
                SmsSendPO po = new SmsSendPO();

                if (siteInfo.getData().getCertifySendNo() == null
                        || ("").equals(siteInfo.getData().getCertifySendNo())) {
                    throw new CustomException("biz.exception.operation.certifySendNoNull", new Object[] { "코드그룹" });
                } else {
                    po.setSendTelno(siteInfo.getData().getCertifySendNo());
                }
                po.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
                po.setSendWords(so.getSendWords());
                po.setSendTargetCd(so.getSendTargetCd());
                // sms, 장문
                po.setSendFrmCd(so.getSendFrmCd());
                po.setPossCnt(so.getPossCnt());
                po.setAutoSendYn("N");
                if (SessionDetailHelper.getDetails().getSession().getMemberNo() != null) {
                    po.setRegrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
                    po.setSenderNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
                    po.setSenderId(SessionDetailHelper.getDetails().getSession().getLoginId());
                    po.setSenderNm(SessionDetailHelper.getDetails().getSession().getMemberNm());
                }

                po.setRecvTelNo((so.getRecvTelnoTotal())[i]);
                po.setReceiverNo((so.getReceiverNoTotal())[i]);
                po.setReceiverId((so.getReceiverIdTotal())[i]);
                po.setReceiverNm((so.getReceiverNmTotal())[i]);
                po.setSendTelno(siteInfo.getData().getCertifySendNo());
                po.setFdestine((so.getRecvTelnoTotal())[i].replaceAll("-", ""));
                po.setFcallback(siteInfo.getData().getCertifySendNo().replaceAll("-", ""));
                if ("Y".equals((so.getReceiverRecvRjtYnTotal())[i])) {
                    // 080 수신 거부 발송 안됨
                } else {
                    listpo.add(po);
                }
            *//*}*//*
            }
        } else if (StringUtils.equals("search", so.getSmsMember())) {
            for (int i = 0; i < so.getReceiverNoSearch().length; i++) {
                SmsSendPO po = new SmsSendPO();

                if (siteInfo.getData().getCertifySendNo() == null
                        || ("").equals(siteInfo.getData().getCertifySendNo())) {
                    throw new CustomException("biz.exception.operation.certifySendNoNull", new Object[] { "코드그룹" });
                } else {
                    po.setSendTelno(siteInfo.getData().getCertifySendNo());
                }

                po.setSendTelno(so.getSendTelno() == null ? "00000000000" : so.getSendTelno());
                po.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
                po.setSendWords(so.getSendWords());
                po.setSendTargetCd(so.getSendTargetCd());
                // sms, 장문
                po.setSendFrmCd(so.getSendFrmCd());
                po.setPossCnt(so.getPossCnt());
                po.setAutoSendYn("N");
                if (SessionDetailHelper.getDetails().getSession().getMemberNo() != null) {
                    po.setRegrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
                    po.setSenderNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
                    po.setSenderId(SessionDetailHelper.getDetails().getSession().getLoginId());
                    po.setSenderNm(SessionDetailHelper.getDetails().getSession().getMemberNm());
                }

                po.setRecvTelNo((so.getRecvTelnoSearch())[i]);
                po.setReceiverNo((so.getReceiverNoSearch())[i]);
                po.setReceiverId((so.getReceiverIdSearch())[i]);
                po.setReceiverNm((so.getReceiverNmSearch())[i]);
                po.setSendTelno(siteInfo.getData().getCertifySendNo());
                po.setFdestine((so.getRecvTelnoSearch())[i].replaceAll("-", ""));
                po.setFcallback(siteInfo.getData().getCertifySendNo().replaceAll("-", ""));
                if ("Y".equals((so.getReceiverRecvRjtYnSearch())[i])) {
                    // 080 수신 거부 발송 안됨
                } else {
                    listpo.add(po);
                }
            }
        } else if (StringUtils.equals("select", so.getSmsMember())) {
            for (int i = 0; i < so.getReceiverNoSelect().length; i++) {
                SmsSendPO po = new SmsSendPO();

                if (siteInfo.getData().getCertifySendNo() == null
                        || ("").equals(siteInfo.getData().getCertifySendNo())) {
                    throw new CustomException("biz.exception.operation.certifySendNoNull", new Object[] { "코드그룹" });
                } else {
                    po.setSendTelno(siteInfo.getData().getCertifySendNo());
                }

                po.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
                po.setSendWords(so.getSendWords());
                po.setSendTargetCd(so.getSendTargetCd());
                // sms, 장문
                po.setSendFrmCd(so.getSendFrmCd());
                po.setPossCnt(so.getPossCnt());
                po.setAutoSendYn("N");
                if (SessionDetailHelper.getDetails().getSession().getMemberNo() != null) {
                    po.setRegrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
                    po.setSenderNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
                    po.setSenderId(SessionDetailHelper.getDetails().getSession().getLoginId());
                    po.setSenderNm(SessionDetailHelper.getDetails().getSession().getMemberNm());
                }
                po.setRecvTelNo((so.getRecvTelnoSelect())[i]);
                po.setReceiverNo((so.getReceiverNoSelect())[i]);
                po.setReceiverId((so.getReceiverIdSelect())[i]);
                po.setReceiverNm((so.getReceiverNmSelect())[i]);
                po.setSendTelno(siteInfo.getData().getCertifySendNo());
                po.setFdestine((so.getRecvTelnoSelect())[i].replaceAll("-", ""));
                po.setFcallback(siteInfo.getData().getCertifySendNo().replaceAll("-", ""));
                if ("Y".equals((so.getReceiverRecvRjtYnSelect())[i])) {
                    // 080 수신 거부 발송 안됨
                } else {
                    listpo.add(po);
                }
            }
        } else {
            SmsSendPO po = new SmsSendPO();

            if (siteInfo.getData().getCertifySendNo() == null || ("").equals(siteInfo.getData().getCertifySendNo())) {
                throw new CustomException("biz.exception.operation.certifySendNoNull", new Object[] { "코드그룹" });
            } else {
                po.setSendTelno(siteInfo.getData().getCertifySendNo());
            }

            po.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
            po.setSendWords(so.getSendWords());
            po.setSendTargetCd(so.getSendTargetCd());
            // sms, 장문
            po.setSendFrmCd(so.getSendFrmCd());
            po.setPossCnt(so.getPossCnt());
            po.setAutoSendYn("N");
            if (SessionDetailHelper.getDetails().getSession().getMemberNo() != null) {
                po.setRegrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
                po.setSenderNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
                po.setSenderId(SessionDetailHelper.getDetails().getSession().getLoginId());
                po.setSenderNm(SessionDetailHelper.getDetails().getSession().getMemberNm());
            }
            po.setRecvTelNo(so.getRecvTelnoSelect()[0]);
            po.setSendTelno(siteInfo.getData().getCertifySendNo());
            po.setFdestine((so.getRecvTelno()).replaceAll("-", ""));
            po.setFcallback(siteInfo.getData().getCertifySendNo().replaceAll("-", ""));
            if ("Y".equals((so.getReceiverRecvRjtYnSelect())[0])) {
                // 080 수신 거부 발송 안됨
            } else {
                listpo.add(po);
            }
        }
        result = smsSendService.sendSms(listpo);
        return result;
    }*/

    /**
     * <pre>
     * 작성일 : 2016. 7. 20.
     * 작성자 : dong
     * 설명   : SMS 자동발송 수정
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 7. 20. dong - 최초생성
     * </pre>
     *
     * @param SmsSendPO
     * @return
     * @throws Exception
     */
    @RequestMapping("/sms-autosend-update")
    public @ResponseBody ResultModel<SmsSendPO> updateStatusSms(@Validated(UpdateGroup.class) SmsSendPO po,
            BindingResult bindingResult) throws Exception {

        // 등록자 번호
        po.setRegrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
        // 사이트 번호
        po.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());

        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }

//        ResultModel<SmsSendPO> result = new ResultModel<>();

        log.info("PO : {}", po);
        ResultModel<SmsSendPO> result = smsSendService.updateStatusSms(po);

        return result;
    }


}
