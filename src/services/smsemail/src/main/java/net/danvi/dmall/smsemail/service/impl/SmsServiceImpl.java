package net.danvi.dmall.smsemail.service.impl;

import net.danvi.dmall.core.remote.homepage.model.result.RemoteBaseResult;
import net.danvi.dmall.smsemail.dao.ProxyDao;
import net.danvi.dmall.smsemail.model.MemberManageVO;
import net.danvi.dmall.smsemail.model.SmsEmailPointHistPO;
import net.danvi.dmall.smsemail.model.SmsEmailPointPO;
import net.danvi.dmall.smsemail.model.request.SmsSendPO;
import net.danvi.dmall.smsemail.model.sms.InnerSmsSendHistSO;
import net.danvi.dmall.smsemail.model.sms.MmsMsg;
import net.danvi.dmall.smsemail.model.sms.SmsSendHistPO;
import net.danvi.dmall.smsemail.model.sms.Tblmessage;
import net.danvi.dmall.smsemail.service.SmsService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.transaction.interceptor.TransactionAspectSupport;
import dmall.framework.common.model.ResultListModel;
import dmall.framework.common.util.StringUtil;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by dong on 2016-08-30.
 */
@Service("smsService")
public class SmsServiceImpl implements SmsService {
    Logger log = LoggerFactory.getLogger(this.getClass());

    @Autowired
    private ProxyDao proxyDao;

    // @Autowired
    // private JtaDao jtaDao;

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Integer addPoint(String siteNo, Integer point, String gbCd) {
        SmsEmailPointPO po = new SmsEmailPointPO();
        po.setSiteNo(siteNo);
        po.setPoint(point);
        proxyDao.insert("sms.updatePoint", po);
        SmsEmailPointHistPO histPO = new SmsEmailPointHistPO(po);
        histPO.setGbCd(gbCd);
        insertPointHist(histPO);

        return getPoint(siteNo);
    }

    @Transactional(rollbackFor = Exception.class)
    private void insertPointHist(SmsEmailPointHistPO po) {
        if (po.getGbCd() == null) throw new RuntimeException("포인트 구분 코드가 존재하지 않습니다.");
        proxyDao.insert("sms.insertPointHist", po);
    }
    // @Transactional(rollbackFor = Exception.class)
    // private void insertPointHistXa(SmsEmailPointHistPO po) {
    // if (po.getGbCd() == null) throw new RuntimeException("포인트 구분 코드가 존재하지 않습니다.");
    // jtaDao.insert(jtaDao.getMainXA(), "sms.insertPointHist", po);
    // }

    @Transactional(rollbackFor = Exception.class)
    public Integer subPoint(String siteNo, Integer point) {
        SmsEmailPointPO po = new SmsEmailPointPO();
        po.setSiteNo(siteNo);
        po.setPoint(-(Math.abs(point)));
        proxyDao.insert("sms.updatePoint", po);
        SmsEmailPointHistPO histPO = new SmsEmailPointHistPO(po);
        histPO.setGbCd("02"); // 전송차감
        insertPointHist(histPO);

        return getPoint(siteNo);
    }

    // @Transactional(rollbackFor = Exception.class)
    // private void subPointXa(Long siteNo, Integer point) {
    // log.debug("{} 에서 {}포인트 차감", siteNo, point);
    //
    // SmsEmailPointPO po = new SmsEmailPointPO();
    // po.setSiteNo(siteNo);
    // po.setPoint(-(Math.abs(point)));
    // jtaDao.insert(jtaDao.getMainXA(), "sms.updatePoint", po);
    // SmsEmailPointHistPO histPO = new SmsEmailPointHistPO(po);
    // histPO.setGbCd("02"); // 전송차감
    // insertPointHistXa(histPO);
    // }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public RemoteBaseResult send(String siteNo, List<SmsSendPO> list) {
        RemoteBaseResult result = new RemoteBaseResult();
        List<Tblmessage> smsList = new ArrayList<>();
        List<MmsMsg> lmsList = new ArrayList<>();

        String temp;
        byte[] test;
        int bytelength;
        int smsPoint = 0;
        SmsSendHistPO smsSendHistPO;

        try {
            for (SmsSendPO po : list) {
                temp = po.getSendWords();
                temp = StringUtil.convertCharset(temp, "UTF-8", "EUC-KR");
                test = temp.getBytes("EUC-KR");
                bytelength = test.length;

                log.debug("메시지 byte : {}", bytelength);

                if (bytelength < 90) {
                    // SMS
                    po.setSendFrmCd("01");
                    smsSendHistPO = new SmsSendHistPO(po);
                    // jtaDao.insert(jtaDao.getMainXA(), "sms.insertSmsSendHist", smsSendHistPO);
                    proxyDao.insert("sms.insertSmsSendHist", smsSendHistPO);
                    po.setSmsSendNo(smsSendHistPO.getSmsSendNo());
                    po.setFailedType("SMS");
                    po.setFailedMsg(po.getSendWords());
                    smsList.add(new Tblmessage(po));
                    /*smsPoint++;*/
                } else {
                    // LMS
                    po.setSendFrmCd("02");
                    smsSendHistPO = new SmsSendHistPO(po);
                    // jtaDao.insert(jtaDao.getMainXA(), "sms.insertSmsSendHist", smsSendHistPO);
                    proxyDao.insert("sms.insertSmsSendHist", smsSendHistPO);
                    po.setSmsSendNo(smsSendHistPO.getSmsSendNo());
                    po.setFailedType("LMS");
                    po.setFailedMsg(po.getSendWords());
                    lmsList.add(new MmsMsg(po));
                    /*smsPoint += 3;*/
                }
            }

        } catch (Exception e) {
            log.error("SMS 전송 에러", e);
            TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
            result.setSuccess(false);
            result.setMessage("SMS 전송 에러");
            return result;
        }

        // if (smsPoint > getPointXa(siteNo)) {
        /*if (smsPoint > getPoint(siteNo)) {
            TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
            result.setSuccess(false);
            result.setMessage("SMS 포인트가 부족합니다.");
            return result;
        }*/

        // 포인트 차감
        // subPointXa(siteNo, smsPoint);
        /*subPoint(siteNo, smsPoint);*/

        log.debug("sms : {}", smsList);
        log.debug("lms : {}", lmsList);

        if (smsList.size() > 0) {
            // jtaDao.insert(jtaDao.getSmsXA(), "sms.insertSMS", smsList);
            //proxyDao.insert("sms.insertSMS", smsList);

            //카카오메세지 전송
            proxyDao.insert("sms.insertKkoSmsMsg", smsList);
        }

        if (lmsList.size() > 0) {
            // jtaDao.insert(jtaDao.getSmsXA(), "sms.insertLMS", lmsList);
            //proxyDao.insert("sms.insertLMS", lmsList);
            //카카오메세지 전송
            proxyDao.insert("sms.insertKkoLmsMsg", lmsList);

        }

        return result;
    }

    @Override
    public ResultListModel selectSendHistoryPaging(InnerSmsSendHistSO so) {
        if (so.getSidx().length() == 0) {
            so.setSidx("REG_DTTM");
            so.setSord("ASC");
        }
        return proxyDao.selectListPage("sms.selectSendHistoryList", so);
    }

    @Override
    public ResultListModel selectAutoSendHistoryPaging(InnerSmsSendHistSO so) {
        return proxyDao.selectListPage("sms.selectSendHistoryList", so);
    }

    @Override
    public Integer getPoint(String siteNo) {
        return proxyDao.selectOne("sms.getPoint", siteNo);
    }

    // private Integer getPointXa(Long siteNo) {
    // return jtaDao.selectOne(jtaDao.getMainXA(), "sms.getPoint", siteNo);
    // }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public RemoteBaseResult send(String siteNo, List<MemberManageVO> list , SmsSendPO smsSendPO) {
        RemoteBaseResult result = new RemoteBaseResult();
        List<Tblmessage> smsList = new ArrayList<>();
        List<MmsMsg> lmsList = new ArrayList<>();

        String temp;
        byte[] test;
        int bytelength;
        int smsPoint = 0;
        SmsSendHistPO smsSendHistPO;
        int smsRowcount = 0;
        int lmsRowcount = 0;
        int lmsBatchCount =0;
        int smsBatchCount =0;

        try {

            log.info("===★★★★★★★★★★★★★★★★★★★★★★★★★★★★★===");
            log.info(System.currentTimeMillis() + " Sms LOG ... Send start. ");
            log.info("===★★★★★★★★★★★★★★★★★★★★★★★★★★★★★===");

            temp = smsSendPO.getSendWords();
            temp = StringUtil.convertCharset(temp, "UTF-8", "EUC-KR");
            test = temp.getBytes("EUC-KR");
            bytelength = test.length;

            /*log.debug("메시지 byte : {}", bytelength);*/

            if (bytelength < 90) {
                // SMS
                smsSendPO.setSendFrmCd("01");
            } else {
                // LMS
                smsSendPO.setSendFrmCd("02");
            }

            for (MemberManageVO memberManageVO : list) {
                smsSendPO.setSiteNo(siteNo);
                smsSendPO.setRecvTelno(memberManageVO.getMobile());
                smsSendPO.setReceiverNo(memberManageVO.getMemberNo());
                smsSendPO.setReceiverId(memberManageVO.getLoginId());
                smsSendPO.setReceiverNm(memberManageVO.getMemberNm());
                String fdestine = memberManageVO.getMobile()!=null?memberManageVO.getMobile().replaceAll("-", ""):"";
                smsSendPO.setFdestine(fdestine);
                smsSendPO.setFailedMsg(smsSendPO.getSendWords());


                if (bytelength < 90) {
                    if (memberManageVO.getRecvRjtYn()!=null && "Y".equals((memberManageVO.getRecvRjtYn()))){

                    }else {
                        //테스트용 관리자,김형신
                        /*if(smsSendPO.getReceiverNo()==1000 || smsSendPO.getReceiverNo()==11522) {*/
                            smsSendHistPO = new SmsSendHistPO(smsSendPO);
                            // jtaDao.insert(jtaDao.getMainXA(), "sms.insertSmsSendHist", smsSendHistPO);
                            proxyDao.insert("sms.insertSmsSendHist", smsSendHistPO);
                            smsSendPO.setSmsSendNo(smsSendHistPO.getSmsSendNo());
                            smsSendPO.setFailedType("SMS");
                            smsList.add(new Tblmessage(smsSendPO));
                        /*}*/
                    }
                    /*smsPoint++;*/
                     smsRowcount++;
                    if(smsRowcount % 1000 ==0 && smsList.size()>0){
                      //카카오메세지 전송
                      proxyDao.insert("sms.insertKkoSmsMsg", smsList);
                      smsBatchCount++;
                    }
                } else {

                    if (memberManageVO.getRecvRjtYn()!=null &&  "Y".equals((memberManageVO.getRecvRjtYn()))){

                    }else {
                        //테스트용 관리자,김형신
                        /*if(smsSendPO.getReceiverNo()==1000 || smsSendPO.getReceiverNo()==11522) {*/
                            smsSendHistPO = new SmsSendHistPO(smsSendPO);
                            // jtaDao.insert(jtaDao.getMainXA(), "sms.insertSmsSendHist", smsSendHistPO);
                            proxyDao.insert("sms.insertSmsSendHist", smsSendHistPO);
                            smsSendPO.setSmsSendNo(smsSendHistPO.getSmsSendNo());
                            smsSendPO.setFailedType("LMS");
                            lmsList.add(new MmsMsg(smsSendPO));
                        /*}*/
                    }

                    /*smsPoint += 3;*/
                    lmsRowcount++;
                    if(lmsRowcount % 1000 ==0 && lmsList.size() > 0){
                        //카카오메세지 전송
                        proxyDao.insert("sms.insertKkoLmsMsg", lmsList);
                        lmsBatchCount++;
                    }
                }
            }

            log.debug("sms : {}", smsList);
            log.debug("lms : {}", lmsList);

            if ((smsBatchCount * 1000) < smsList.size()) {
                // jtaDao.insert(jtaDao.getSmsXA(), "sms.insertSMS", smsList);
                //proxyDao.insert("sms.insertSMSMSG", smsList);
                //카카오메세지 전송
                proxyDao.insert("sms.insertKkoSmsMsg", smsList);
            }

            if ((lmsBatchCount * 1000) < lmsList.size()) {
                // jtaDao.insert(jtaDao.getSmsXA(), "sms.insertLMS", lmsList);
                //proxyDao.insert("sms.insertMMSMSG", lmsList);
                //카카오메세지 전송
                proxyDao.insert("sms.insertKkoLmsMsg", lmsList);

            }

            log.info("===★★★★★★★★★★★★★★★★★★★★★★★★★★★★★===");
            log.info(System.currentTimeMillis() + " Sms LOG ... Send end. ");
            log.info("===★★★★★★★★★★★★★★★★★★★★★★★★★★★★★===");

        } catch (Exception e) {
            log.error("SMS 전송 에러", e);
            TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
            result.setSuccess(false);
            result.setMessage("SMS 전송 에러");
            return result;
        }

        return result;
    }
}
