package net.danvi.dmall.biz.app.operation.service;

import java.util.ArrayList;
import java.util.List;

import javax.annotation.Resource;

import dmall.framework.common.exception.CustomException;
import dmall.framework.common.util.BeansUtil;
import net.danvi.dmall.biz.app.member.manage.model.MemberManageSO;
import net.danvi.dmall.biz.app.member.manage.model.MemberManageVO;
import net.danvi.dmall.biz.app.operation.model.*;
import net.danvi.dmall.biz.app.seller.model.SellerVO;
import net.danvi.dmall.biz.app.setup.siteinfo.model.SiteSO;
import net.danvi.dmall.biz.app.setup.siteinfo.model.SiteVO;
import net.danvi.dmall.biz.app.setup.siteinfo.service.SiteInfoService;
import net.danvi.dmall.biz.system.security.SessionDetailHelper;
import org.apache.commons.lang.StringUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import lombok.extern.slf4j.Slf4j;
import net.danvi.dmall.biz.system.remote.smseml.SmsDelegateService;
import net.danvi.dmall.core.remote.homepage.model.result.RemoteBaseResult;
import dmall.framework.common.BaseService;
import dmall.framework.common.constants.MapperConstants;
import dmall.framework.common.model.ResultListModel;
import dmall.framework.common.model.ResultModel;
import dmall.framework.common.util.MessageUtil;
import dmall.framework.common.util.TextReplacerUtil;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 6. 14.
 * 작성자     : dong
 * 설명       :
 * </pre>
 */
@Slf4j
@Service("smsSendService")
@Transactional(rollbackFor = Exception.class)
public class SmsSendServiceImpl extends BaseService implements SmsSendService {
    @Resource(name = "siteInfoService")
    private SiteInfoService siteInfoService;

    @Resource(name = "smsDelegateService")
    private SmsDelegateService smsDelegateService;

    @Override
    public boolean sendAutoSms(SmsSendSO so, ReplaceCdVO replaceCdVO) throws Exception {
        boolean resultFlag = false;
        // 자동발송 설정 데이터 조회(보내는 내용, 사용 유무 등)
        SmsSendVO smsInfo = proxyDao.selectOne(MapperConstants.SMS + "sendStatusSms", so);

        if (smsInfo != null && ("Y").equals(smsInfo.getUseYn())) {
            // 사이트 정보
            SiteSO siteSo = new SiteSO();
            siteSo.setSiteNo(so.getSiteNo());
            ResultModel<SiteVO> siteInfo = siteInfoService.selectSiteInfo(siteSo);

            // 발신번호 검증
            if (StringUtils.isEmpty(siteInfo.getData().getCertifySendNo())) {
                return resultFlag;
            }

            // 수신자 목록을 담을 list
            List<SmsSendPO> listPo = new ArrayList<>();

            // 고객 수신자 설정
            if (("Y").equals(smsInfo.getMemberSendYn()) && so.getMemberNo() != 0 && StringUtils.isNotEmpty(so.getMemberTemplateCode())) {
                MemberManageVO memberVO = proxyDao.selectOne(MapperConstants.MEMBER_MANAGE + "viewMemInfoDtl", so);
                if (("Y").equals(memberVO.getSmsRecvYn())) {
                    SmsSendPO memberPO = new SmsSendPO();
                    memberPO.setRecvTelNo(memberVO.getMobile());
                    memberPO.setReceiverNo(String.valueOf(memberVO.getMemberNo()));
                    memberPO.setReceiverId(memberVO.getLoginId());
                    memberPO.setReceiverNm(memberVO.getMemberNm());
                    memberPO.setSendTargetCd("01");
                    memberPO.setTemplateCode(so.getMemberTemplateCode());

                    listPo.add(memberPO);
                }
            }

            // 비회원 수신자 설정
            if(so.getMemberNo() == 9999) {
                SmsSendPO nomemberPO = new SmsSendPO();
                nomemberPO.setRecvTelNo(so.getRecvTelno());
                nomemberPO.setReceiverNo("1000");
                nomemberPO.setReceiverId("");
                nomemberPO.setReceiverNm("guest");
                nomemberPO.setSendTargetCd("01");
                nomemberPO.setTemplateCode(so.getMemberTemplateCode());

                listPo.add(nomemberPO);
            }

            // 관리자 수신자 설정
            if (("Y").equals(smsInfo.getAdminSendYn()) && StringUtils.isNotEmpty(so.getAdminTemplateCode())) {
                List<SmsSendVO> adminNoList = proxyDao.selectList(MapperConstants.SMS + "selectAdminNo", so);
                int i = 1;
                for (SmsSendVO adminNo : adminNoList) {
                    SmsSendPO adminPO = new SmsSendPO();
                    adminPO.setRecvTelNo(adminNo.getRecvMobile());
                    adminPO.setReceiverNo("2000");
                    adminPO.setReceiverId("");
                    adminPO.setReceiverNm("관리자" + i);
                    adminPO.setSendTargetCd("02");
                    adminPO.setTemplateCode(so.getAdminTemplateCode());

                    listPo.add(adminPO);
                    i++;
                }
            }

            // 판매자 수신자 설정
            if (("Y").equals(smsInfo.getSellerSendYn()) && so.getSellerNo() != 0 && StringUtils.isNotEmpty(so.getSellerTemplateCode())) {
                SellerVO sellerVO = proxyDao.selectOne(MapperConstants.SELLER + "selectSellerDtl", so);
                SmsSendPO sellerPO = new SmsSendPO();
                sellerPO.setRecvTelNo(sellerVO.getManagerMobileNo());
                sellerPO.setReceiverNo(sellerVO.getSellerNo());
                sellerPO.setReceiverId(sellerVO.getSellerId());
                sellerPO.setReceiverNm(sellerVO.getSellerNm());
                sellerPO.setSendTargetCd("03");
                sellerPO.setTemplateCode(so.getSellerTemplateCode());

                listPo.add(sellerPO);
            }

            // 가맹점 수신자 설정
            if (("Y").equals(smsInfo.getStoreSendYn()) && StringUtils.isNotEmpty(so.getStoreNo()) && StringUtils.isNotEmpty(so.getStoreTemplateCode())) {
                List<SmsSendVO> storeNoList = proxyDao.selectList(MapperConstants.SMS + "selectStoreAdminNo", so);
                int i = 1;
                for (SmsSendVO storeNo : storeNoList) {
                    SmsSendPO storePO = new SmsSendPO();
                    storePO.setRecvTelNo(storeNo.getStoreHandPhone());
                    storePO.setReceiverNo("4000");
                    storePO.setReceiverId("");
                    storePO.setReceiverNm("가맹점" + i);
                    storePO.setSendTargetCd("04");
                    storePO.setTemplateCode(so.getStoreTemplateCode());

                    listPo.add(storePO);
                    i++;
                }
            }

            // 후처리 (발신자 설정 및 기타)
            List<SmsSendPO> recvList = new ArrayList<>();
            for (int i = 0; i < listPo.size(); i++) {
                SmsSendPO smsSendPO = listPo.get(i);
                smsSendPO.setSiteNo(so.getSiteNo());
                switch(smsSendPO.getSendTargetCd()) {
                    case "01":  // 회원
                        smsSendPO.setSendWords(TextReplacerUtil.replace(replaceCdVO, smsInfo.getMemberSendWords()));
                        break;
                    case "02":  // 관리자
                        smsSendPO.setSendWords(TextReplacerUtil.replace(replaceCdVO, smsInfo.getAdminSendWords()));
                        break;
                    case "03":  // 판매자
                        smsSendPO.setSendWords(TextReplacerUtil.replace(replaceCdVO, smsInfo.getSellerSendWords()));
                        break;
                    case "04":  // 가맹점
                        smsSendPO.setSendWords(TextReplacerUtil.replace(replaceCdVO, smsInfo.getStoreSendWords()));
                        break;
                }
                smsSendPO.setAutoSendYn("Y");
                smsSendPO.setSendTypeCd(so.getSendTypeCd());
                smsSendPO.setRegrNo(1L);
                smsSendPO.setSenderNo(1L);
                smsSendPO.setSenderNm(siteInfo.getData().getSiteNm());
                smsSendPO.setSendTelno(siteInfo.getData().getCertifySendNo());

                if (StringUtils.isNotEmpty(smsSendPO.getRecvTelNo())) {
                    smsSendPO.setRecvTelNo(smsSendPO.getRecvTelNo().replaceAll("[^0-9]", ""));
                }
                if(StringUtils.isNotEmpty(smsSendPO.getRecvTelNo())) {
                    recvList.add(smsSendPO);
                }
            }

            if(recvList.size() > 0) {
                sendSms(recvList);
                resultFlag = true;
            }
        }
        return resultFlag;
    }

    @Override
    public ResultModel<SmsSendPO> sendSms(List<SmsSendPO> listpo) throws Exception {
        ResultModel<SmsSendPO> result = new ResultModel<>();

        List<net.danvi.dmall.smsemail.model.request.SmsSendPO> sendPoList = new ArrayList<>();
        for (int i = 0; i < listpo.size(); i++) {
            SmsSendPO po = listpo.get(i);
            net.danvi.dmall.smsemail.model.request.SmsSendPO smsSendPO = new net.danvi.dmall.smsemail.model.request.SmsSendPO();

            smsSendPO.setFcallback(po.getSendTelno().replaceAll("-", ""));
            smsSendPO.setFdestine(po.getRecvTelNo().replaceAll("-", ""));
            smsSendPO.setSiteNo("" + po.getSiteNo());
            if (po.getSendTypeCd() != null && po.getSendTypeCd() != "") {
                smsSendPO.setSendTypeCd(po.getSendTypeCd());
            }
            if (po.getSendTargetCd() != null && po.getSendTargetCd() != "") {
                smsSendPO.setSendTargetCd(po.getSendTargetCd());
            }
            if (po.getSendFrmCd() != null && po.getSendFrmCd() != "") {
                smsSendPO.setSendFrmCd(po.getSendFrmCd());
            }
            if (po.getSendTelno() != null && po.getSendTelno() != "") {
                smsSendPO.setSendTelno(po.getSendTelno());
            }
            if (po.getSendWords() != null && po.getSendWords() != "") {
                smsSendPO.setSendWords(po.getSendWords());
            }
            smsSendPO.setSenderNo(po.getSenderNo());
            if (po.getSenderId() != null && po.getSenderId() != "") {
                smsSendPO.setSenderId(po.getSenderId());
            }
            if (po.getSenderNm() != null && po.getSenderNm() != "") {
                smsSendPO.setSenderNm(po.getSenderNm());
            }
            if (po.getSendDttm() != null && po.getSendDttm() != "") {
                smsSendPO.setSendDttm(po.getSendDttm());
            }
            if (po.getRecvTelNo() != null && po.getRecvTelNo() != "") {
                smsSendPO.setRecvTelno(po.getRecvTelNo());
            }
            if (po.getReceiverNo() != null && po.getReceiverNo() != "") {
                smsSendPO.setReceiverNo(Long.parseLong(po.getReceiverNo()));
            }
            if (po.getReceiverId() != null && po.getReceiverId() != "") {
                smsSendPO.setReceiverId(po.getReceiverId());
            }
            if (po.getReceiverNm() != null && po.getReceiverNm() != "") {
                smsSendPO.setReceiverNm(po.getReceiverNm());
            }
            if (po.getRecvDttm() != null && po.getRecvDttm() != "") {
                smsSendPO.setRecvDttm(po.getRecvDttm());
            }
            if (po.getAutoSendYn() != null && po.getAutoSendYn() != "") {
                smsSendPO.setAutoSendYn(po.getAutoSendYn());
            }
            if (po.getOrdNo() != null && po.getOrdNo() != "") {
                smsSendPO.setOrdNo(po.getOrdNo());
            }
            if (po.getTemplateCode() != null && po.getTemplateCode() != "") {
                smsSendPO.setTemplateCode(po.getTemplateCode());
            }

            // 전송에서 타이틀을 사이트명으로 SET
            SiteSO siteSo = new SiteSO();
            siteSo.setSiteNo(Long.parseLong(smsSendPO.getSiteNo()));
            ResultModel<SiteVO> siteInfo = siteInfoService.selectSiteInfo(siteSo);
            smsSendPO.setSubject(siteInfo.getData().getSiteNm());
            smsSendPO.setFailedSubject(siteInfo.getData().getSiteNm());

            // 필수 값 검증(필수 값이 없을 경우 발송 대상에 추가 안함)
            if ((po.getRecvTelNo() != null && po.getRecvTelNo() != "") || (po.getSendTelno() != null && po.getSendTelno() != "")|| (po.getSendWords() != null && po.getSendWords() != "")) {
                // 받는사람 휴대폰 번호 검증
                sendPoList.add(i, smsSendPO);
                /*
                 * if (imNumber(po.getRecvTelNo())&& (po.getRecvTelNo().length() == 10 || po.getRecvTelNo().length() == 11)) {
                 * sendPoList.add(i, smsSendPO);
                 * }
                 */
            }
        }
        RemoteBaseResult remoteResult = new RemoteBaseResult();
        if (listpo.size() > 0) {
            try {
                remoteResult = smsDelegateService.send(listpo.get(0).getSiteNo(), sendPoList);
            } catch (Exception e) {
                remoteResult.setSuccess(false);
            }
        } else {
            remoteResult.setSuccess(true);
        }
        if (remoteResult.getSuccess()) {
            result.setMessage(MessageUtil.getMessage("biz.opeeration.sendSms"));
        } else {
            result.setMessage(MessageUtil.getMessage("biz.opeeration.sendSmsFail"));
        }
        return result;
    }

    @Override
    public ResultModel<SmsSendPO> sendSms(SmsSendPO po,String smsMember,SmsSendSO so) throws Exception {
        ResultModel<SmsSendPO> result = new ResultModel<>();
        RemoteBaseResult remoteResult = new RemoteBaseResult();

        net.danvi.dmall.smsemail.model.request.SmsSendPO smsSendPO =BeansUtil.copyProperties(po, null, net.danvi.dmall.smsemail.model.request.SmsSendPO.class);

        // 전송에서 타이틀을 사이트명으로 SET
        SiteSO siteSo = new SiteSO();
        siteSo.setSiteNo(po.getSiteNo());
        ResultModel<SiteVO> siteInfo = siteInfoService.selectSiteInfo(siteSo);
        smsSendPO.setSubject(siteInfo.getData().getSiteNm());
        smsSendPO.setFailedSubject(siteInfo.getData().getSiteNm());

        try {
            remoteResult = smsDelegateService.send(po.getSiteNo(),smsSendPO,smsMember,so);
            remoteResult.setSuccess(true);
        } catch (Exception e) {
            remoteResult.setSuccess(false);
        }

        if (remoteResult.getSuccess()) {
            result.setMessage(MessageUtil.getMessage("biz.opeeration.sendSms"));
        } else {
            result.setMessage(MessageUtil.getMessage("biz.opeeration.sendSmsFail"));
        }
        return result;
    }

    public boolean imNumber(String phoneNumber) {
        // 유효성 체크
        if (phoneNumber == null || phoneNumber.equals("")) return false;

        for (int i = 0; i < phoneNumber.length(); i++) {
            char ch = phoneNumber.charAt(i);

            if (ch < '0' || ch > '9') {
                return false;
            }
        }
        return true;
    }

    @Override
    public ResultListModel<SmsSendVO> selectSmsHstPaging(SmsSendSO so) {
        if (so.getSidx().length() == 0) {
            so.setSidx("REG_DTTM");
            so.setSord("DESC");
            so.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
        }

        return proxyDao.selectListPage(MapperConstants.SMS + "selectSmsHstPaging", so);
    }

    @Override
    @Transactional(readOnly = true)
    public ResultModel<SmsSendVO> selectSmsHstInfo(SmsSendSO so) throws Exception {
        so.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
        SmsSendVO vo = proxyDao.selectOne(MapperConstants.SMS + "selectSmsHstInfo", so);
        ResultModel<SmsSendVO> result = new ResultModel<SmsSendVO>(vo);
        result.setData(vo);
        return result;
    }

    @Override
    public ResultModel<SmsSendPO> updateStatusSms(SmsSendPO po) {
        // 상태코드
        String[] useYnCode = po.getUseYnCode();
        // 사용여부
        String[] useYnArr = po.getUseYnArray();

        // 회원 발송 여부 Array
        String[] memSendYnArr = po.getMemberSendYnArr();
        // 관리자 발송 여부 Array
        String[] adminSendYnArr = po.getAdminSendYnArr();
        // 판매자 발송 여부 Array
        String[] sellerSendYnArr = po.getSellerSendYnArr();
        // 가맹점 발송 여부 Array
        String[] storeSendYnArr = po.getStoreSendYnArr();
        // 임직원 발송 여부 Array
        String[] staffSendYnArr = po.getStaffSendYnArr();

        // 회원 발송 문구 Array
        String[] memSendWord = po.getMemberSendWords();
        // 관리자 발송 문구 Array
        String[] adminSendWord = po.getAdminSendWords();
        // 판매자 발송 문구 Array
        String[] sellerSendWord = po.getSellerSendWords();
        // 가맹점 발송 문구 Array
        String[] storeSendWord = po.getStoreSendWords();
        // 임직원 발송 문구 Array
        String[] staffSendWord = po.getStaffSendWords();

        // 관리자 수신 번호1 Array
        String[] adminRcvNo1 = po.getAdminRcvNo1();

        for (int i = 0; i < useYnCode.length; i++) {
            SmsSendPO tpo = new SmsSendPO();
            tpo.setSiteNo(po.getSiteNo());
            // 상태코드
            tpo.setSendTypeCd(useYnCode[i]);
            // 사용여부
            tpo.setUseYn(useYnArr[i]);
            // 고객
            tpo.setMemberSendYn(memSendYnArr[i]);
            tpo.setMemberSendWord(memSendWord[i]);
            // 관리자
            tpo.setAdminSendYn(adminSendYnArr[i]);
            tpo.setAdminSendWord(adminSendWord[i]);
            // 판매자
            tpo.setSellerSendYn(sellerSendYnArr[i]);
            tpo.setSellerSendWord(sellerSendWord[i]);
            // 가맹점
            tpo.setStoreSendYn(storeSendYnArr[i]);
            tpo.setStoreSendWord(storeSendWord[i]);
            // 임직원
            tpo.setStaffSendYn(staffSendYnArr[i]);
            tpo.setStaffSendWord(staffSendWord[i]);

            proxyDao.update(MapperConstants.SMS + "updateStatusSms", tpo);
        }

        // 기존에 저장된 관리자 수신번호 삭제
        deleteAdminNo(po);

        // 새로 등록한 관리자 수신번호 추가
        for (String s : adminRcvNo1) {
            s = s.replaceAll("(\\d{3})(\\d{4})(\\d{4})", "$1-$2-$3");
            po.setRecvMobile(s);
            insertAdminNo(po);
        }

        ResultModel<SmsSendPO> result = new ResultModel<>();
        result.setMessage(MessageUtil.getMessage("biz.common.update"));

        return result;
    }

    @Override
    public List<SmsSendVO> selectAdminNo(SmsSendSO so) {

        return proxyDao.selectList(MapperConstants.SMS + "selectAdminNo", so);
    }

    @Override
    public ResultModel<SmsSendPO> insertAdminNo(SmsSendPO po) {
        ResultModel<SmsSendPO> result = new ResultModel<>();
        proxyDao.insert(MapperConstants.SMS + "insertAdminNo", po);
        result.setMessage(MessageUtil.getMessage("biz.common.insert"));
        return result;
    }

    @Override
    public ResultModel<SmsSendPO> deleteAdminNo(SmsSendPO po) {
        ResultModel<SmsSendPO> result = new ResultModel<>();
        proxyDao.update(MapperConstants.SMS + "deleteAdminNo", po);
        result.setMessage(MessageUtil.getMessage("biz.common.delete"));
        return result;
    }

    @Override
    public List<SmsSendVO> selectStatusSms(SmsSendSO so) {

        return proxyDao.selectList(MapperConstants.SMS + "selectStatusSms", so);
    }

    @Override
    public String selectAdminSmsNo(SmsSendSO so) {
        so.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
        return proxyDao.selectOne(MapperConstants.SMS + "selectAdminSmsNo", so);
    }

    @Override
    @Transactional(readOnly = true)
    public ResultListModel<SmsSendHistVO> selectSendHistPaging(InnerSmsSendHistSO so) {
        if (so.getSidx().length() == 0) {
            so.setSidx("REG_DTTM");
            so.setSord("ASC");
        }
        ResultListModel<SmsSendHistVO> list = proxyDao.selectListPage(MapperConstants.SMS + "selectSendHistoryList", so);
        log.info("list = "+list);
        return list;
    }
}
