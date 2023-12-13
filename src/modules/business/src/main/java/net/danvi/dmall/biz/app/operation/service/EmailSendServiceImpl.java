package net.danvi.dmall.biz.app.operation.service;

import java.security.Security;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Properties;

import javax.annotation.Resource;
import javax.mail.*;
import javax.mail.internet.AddressException;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

import net.danvi.dmall.biz.app.member.manage.model.MemberManageVO;
import net.danvi.dmall.biz.app.operation.model.EmailSendPO;
import net.danvi.dmall.biz.app.operation.model.EmailSendSO;
import net.danvi.dmall.biz.system.security.SessionDetailHelper;
import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import lombok.extern.slf4j.Slf4j;
import net.danvi.dmall.biz.app.member.manage.service.MemberManageService;
import net.danvi.dmall.biz.app.operation.model.EmailSendVO;
import net.danvi.dmall.biz.app.operation.model.ReplaceCdVO;
import net.danvi.dmall.biz.app.setup.siteinfo.service.SiteInfoService;
import net.danvi.dmall.biz.system.remote.smseml.EmailDelegateService;
import net.danvi.dmall.biz.system.service.SiteService;
import net.danvi.dmall.core.remote.homepage.model.result.RemoteBaseResult;
import net.danvi.dmall.smsemail.model.request.EmailReceiverPO;
import dmall.framework.common.BaseService;
import dmall.framework.common.constants.MapperConstants;
import dmall.framework.common.exception.CustomException;
import dmall.framework.common.model.ResultListModel;
import dmall.framework.common.model.ResultModel;
import dmall.framework.common.util.CryptoUtil;
import dmall.framework.common.util.MessageUtil;
import dmall.framework.common.util.TextReplacerUtil;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 5. 4.
 * 작성자     : user
 * 설명       :
 * </pre>
 */
@Slf4j
@Service("emailSendService")
@Transactional(rollbackFor = Exception.class)
public class EmailSendServiceImpl extends BaseService implements EmailSendService {
    @Resource(name = "siteInfoService")
    private SiteInfoService siteInfoService;

    @Resource(name = "memberManageService")
    private MemberManageService memberManageService;

    @Resource(name = "siteService")
    private SiteService siteService;

    @Resource(name = "emailDelegateService")
    private EmailDelegateService emailDelegateService;

    @Value("#{system['system.email.smtp.ip']}")
    private String smtpIp;

    @Value("#{system['system.email.smtp.username']}")
    private String username;

    @Value("#{system['system.email.smtp.password']}")
    private String password;

    @Value(value = "#{system['system.server']}")
    private String server;

    @Override
    public boolean sendEmail(List<MemberManageVO> toMailList, EmailSendPO po) throws Exception {
        boolean result = false;
        // SiteSO siteSo = new SiteSO();
        EmailSendSO emailSendSO = new EmailSendSO();
        emailSendSO.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
        EmailSendVO siteInfo = selectAdminEmail(emailSendSO);
        String sendAdress = "";

        List<EmailReceiverPO> emailReceiverPoList = new ArrayList<>();

        net.danvi.dmall.smsemail.model.request.EmailSendPO emailSendPO = new net.danvi.dmall.smsemail.model.request.EmailSendPO();

        if (siteInfo.getManagerEmail() == null || ("").equals(siteInfo.getManagerEmail())) {
            throw new CustomException("biz.exception.operation.managerEmailNull", new Object[] { "코드그룹" });
        } else {
            sendAdress = siteInfo.getCustCtEmail();
        }

        // String senderName = po.getSenderNm();

        // long time = System.currentTimeMillis();
        // SimpleDateFormat dayTime = new SimpleDateFormat("yyyy-MM-dd
        // HH:mm:ss");
        // String nowTime = dayTime.format(new Date(time));

        // emailSendPO.setSendDttm(nowTime);
        emailSendPO.setSendEmail(sendAdress);
        emailSendPO.setSenderNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
        emailSendPO.setRegrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
        // emailSendPO.setSenderNm(SessionDetailHelper.getDetails().getSession().getMemberNm());
        emailSendPO.setSenderNm(siteInfo.getSiteNm());
        emailSendPO.setSiteNo("" + SessionDetailHelper.getDetails().getSiteNo());
        emailSendPO.setSendStndrd(po.getSendStndrd());
        emailSendPO.setSendTimeSel(po.getSendTimeSel());

        if (toMailList.get(0).getAuthGbCd() != null && toMailList.get(0).getAuthGbCd() != "") {
            emailSendPO.setSendTargetCd(toMailList.get(0).getAuthGbCd());
        }
        if (po.getMailTitle() != null && po.getMailTitle() != "") {
            emailSendPO.setSendTitle(po.getMailTitle());
        }
        if (po.getMailContent() != null && po.getMailContent() != "") {
            emailSendPO.setSendContent(po.getMailContent());
        }
        if (po.getReservationDttm() != null && po.getReservationDttm() != "") {
            emailSendPO.setReservationDttm(po.getReservationDttm());
        }
        // if (po.getSenderNm() != null && po.getSenderNm() != "") {
        // emailSendPO.setSenderNm(po.getSenderNm());
        // }
        for (int i = 0; i < toMailList.size(); i++) {
            EmailReceiverPO receiverPO = new EmailReceiverPO();
            // if (po.getMailTypeCd() != null && po.getMailTypeCd() != "") {
            // sendPo.setMailTypeCd(po.getMailTypeCd());
            // }
            // sendPo.setResultCd("Y");
            // sendPo.setSenderNm(SessionDetailHelper.getDetails().getSession().getMemberNm());
            // sendPo.setSenderNm(po.getSenderNm());
            receiverPO.setReceiverNo(toMailList.get(i).getMemberNo());
            if (toMailList.get(i).getEmail() != null && toMailList.get(i).getEmail() != "") {
                receiverPO.setReceiverEmail(toMailList.get(i).getEmail());
            }
            if (toMailList.get(i).getMemberNm() != null && toMailList.get(i).getMemberNm() != "") {
                receiverPO.setReceiverNm(toMailList.get(i).getMemberNm());
            }
            // insertEmailSendHst(sendPo);
            // proxyDao.update(MapperConstants.EMAIL + "updateEmailPossCnt",
            // po);
            emailReceiverPoList.add(i, receiverPO);
        }

        RemoteBaseResult remoteResult = new RemoteBaseResult();
        if (emailReceiverPoList.size() > 0) {
            emailSendPO.setEmailReceiverPOList(emailReceiverPoList);
            remoteResult = emailDelegateService.send(emailSendPO);
        }

        if (remoteResult.getSuccess()) {
            result = true;
        } else {
            result = false;
        }
        return result;
    }

    @Override
    public ResultListModel<EmailSendVO> selectSendEmailPaging(EmailSendSO so) {
        if (so.getSidx().length() == 0) {
            so.setSidx("hist.REG_DTTM");
            so.setSord("DESC");
            so.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
        }

        if (("searchMemberNm").equals(so.getSearchKind()) || ("all").equals(so.getSearchKind())) {
            so.setMemberNm(so.getSearchVal());
        }

        // 이메일 정보 리스트 조회
        return proxyDao.selectListPage(MapperConstants.EMAIL + "selectSendEmailPaging", so);
    }

    @Override
    @Transactional(readOnly = true)
    public ResultModel<EmailSendVO> selectSendEmailInfo(EmailSendSO so) throws Exception {
        so.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
        // 이메일 정보 단건 조회
        EmailSendVO vo = proxyDao.selectOne(MapperConstants.EMAIL + "selectSendEmailInfo", so);
        vo.setSendNmAndEmail(vo.getSenderNm() + "\n(" + vo.getSendEmail() + ")");
        ResultModel<EmailSendVO> result = new ResultModel<EmailSendVO>(vo);
        result.setData(vo);
        return result;
    }

    @Override
    public ResultModel<EmailSendPO> updateStatusEmail(EmailSendPO po) throws Exception {
        ResultModel<EmailSendPO> result = new ResultModel<>();
        int chk = proxyDao.selectOne(MapperConstants.EMAIL + "getSaveGb", po);
        // 자동 발송 설정 정보 등록 or 수정
        if (chk > 0) {
            proxyDao.insert(MapperConstants.EMAIL + "updateEmailSendAutoSet", po);
            result.setMessage(MessageUtil.getMessage("biz.common.update"));
        } else {
            proxyDao.update(MapperConstants.EMAIL + "insertEmailSendAutoSet", po);
            result.setMessage(MessageUtil.getMessage("biz.common.insert"));
        }
        return result;
    }

    @Override
    @Transactional(readOnly = true)
    public ResultModel<EmailSendVO> selectStatusCfg(EmailSendSO so) throws Exception {
        so.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
        // 상태별 이메일 정보 조회
        EmailSendVO vo = null;
        vo = proxyDao.selectOne(MapperConstants.EMAIL + "selectStatusCfg", so);
        ResultModel<EmailSendVO> result = new ResultModel<EmailSendVO>(vo);
        result.setData(vo);
        return result;
    }

    @Override
    public ResultModel<EmailSendPO> insertEmailSendHst(EmailSendPO po) throws Exception {
        ResultModel<EmailSendPO> result = new ResultModel<>();
        // 이메일 발송 내역 등록
        proxyDao.insert(MapperConstants.EMAIL + "insertEmailSendHst", po);
        result.setMessage(MessageUtil.getMessage("biz.common.insert"));
        return result;
    }

    @SuppressWarnings("unused")
    @Override
    public boolean emailAutoSend(EmailSendSO so, ReplaceCdVO replaceVO)
            throws Exception, AddressException, MessagingException {
        boolean result = false;
        EmailSendVO emailInfo = proxyDao.selectOne(MapperConstants.EMAIL + "selectStatusCfg", so);

        if (emailInfo != null) {
            String subject = TextReplacerUtil.replace(replaceVO, emailInfo.getMailTitle());
            String content = TextReplacerUtil.replace(replaceVO, emailInfo.getMailContent());

//            List<MemberManageVO> toMailList = proxyDao.selectList(MapperConstants.EMAIL + "selectSendEmailManageAdmin",emailInfo);
            List<MemberManageVO> toMailList = new ArrayList<>();

            // 자동발송 이메일 형식이 회원에게 전달하는 경우
            if ("Y".equals(emailInfo.getMemberSendYn())) {
                MemberManageVO mvo = new MemberManageVO();
                mvo.setMemberNo(so.getReceiverNo());
                mvo.setLoginId(so.getReceiverId());
                mvo.setMemberNm(so.getReceiverNm());
                mvo.setEmail(so.getReceiverEmail());
                mvo.setAuthGbCd("01");
                if(so.getReceiverEmail()!=null && !so.getReceiverEmail().equals("") && so.getReceiverEmail().length() > 1) {
                    toMailList.add(mvo);
                }
            }

            // 자동발송 이메일 형식이 판매자에게 전달하는 경우
            if ("Y".equals(emailInfo.getSellerSendYn())) {
                MemberManageVO svo = new MemberManageVO();
                svo.setMemberNo(so.getReceiverNo());
                svo.setLoginId(so.getReceiverId());
                svo.setMemberNm(so.getReceiverNm());
                svo.setEmail(so.getReceiverEmail());
                svo.setAuthGbCd("S");
                if(!StringUtils.isEmpty(so.getReceiverEmail()) && so.getReceiverEmail().length() > 1) {
                    toMailList.add(svo);
                }
            }

            EmailSendPO po = new EmailSendPO();
            po.setOrdNo(so.getOrdNo());
            po.setAutoSendYn("Y");
            po.setMailTitle(subject);
            po.setMailContent(content);
            po.setMailTypeCd(emailInfo.getMailTypeCd());// MailTypeCd 추가 08.24
            po.setMailTypeNm(emailInfo.getMailTypeNm());// MailTypeCd 추가 08.24
            po.setRegrNo(so.getRegrNo());
            po.setSiteNo(so.getSiteNo());
            if (toMailList.size() > 0) {
                result = commonSendEmail(toMailList, po); // 이메일 전송합니다.
            } else {
                result = true;
            }
        }

        return result;
    }

    @Override
    public boolean commonSendEmail(List<MemberManageVO> toMailList, EmailSendPO po)
            throws Exception, AddressException, MessagingException {
        boolean result = false;
        Properties p = getEmailProperties();
        try {
            Session session = Session.getInstance(p, new Authenticator() {
                protected PasswordAuthentication getPasswordAuthentication() {
                    return new PasswordAuthentication(username, password);
                }
            });
//            session.setDebug(true);

            // 사이트 담당자 이메일 조회
            EmailSendSO siteSo = new EmailSendSO();
            siteSo.setSiteNo(po.getSiteNo());
            EmailSendVO vo = selectAdminEmail(siteSo);
            if (vo.getManagerEmail() == null || ("").equals(vo.getManagerEmail())) {
                throw new CustomException("biz.exception.operation.managerEmailNull", new Object[]{"코드그룹"});
            }

            // 수신자 배열 set
            List<Address> addrList = new ArrayList<>();
            for (MemberManageVO memberManageVO : toMailList) {
                if(memberManageVO.getEmail() != null && !memberManageVO.getEmail().equals("") && memberManageVO.getEmail().length() > 1) {
                    addrList.add(new InternetAddress(memberManageVO.getEmail()));
                    memberManageVO.setResultCd("Y");
                }
            }
            Address[] addr = addrList.toArray(new Address[0]);

            // 발신 set
            String fromAddr = "davich000@davichmarket.com";
            MimeMessage msg = new MimeMessage(session);
            msg.setFrom(new InternetAddress(fromAddr, vo.getSiteNm())); // 보내는 사람
            msg.setRecipients(Message.RecipientType.TO, addr);
            msg.setSubject(po.getMailTitle()); // 제목
            msg.setContent(po.getMailContent(), "text/html;charset=utf-8"); // 내용

            if ((po.getMailTitle() != null && po.getMailTitle() != "") || (po.getMailContent() != null && po.getMailContent() != "")) {
                Security.setProperty("jdk.tls.disabledAlgorithms", "");
                Transport.send(msg);

                // Email 발송 이력 저장
                for (int i = 0; i < toMailList.size(); i++) {
                    EmailSendPO sendPo = new EmailSendPO();
                    sendPo.setOrdNo(po.getOrdNo());
                    sendPo.setAutoSendYn(po.getAutoSendYn());
                    sendPo.setSendTargetCd(toMailList.get(i).getAuthGbCd());
                    sendPo.setResultCd(toMailList.get(i).getResultCd());
                    sendPo.setSendEmail(fromAddr);
                    sendPo.setSendTitle(po.getMailTitle());
                    sendPo.setSendContent(po.getMailContent());
                    if (("Y").equals(po.getAutoSendYn())) {
                        if (po.getMailTypeCd() != null && po.getMailTypeCd() != "") {
                            sendPo.setMailTypeCd(po.getMailTypeCd());
                            sendPo.setSendStndrd(po.getMailTypeNm());
                        }
                        sendPo.setSenderNo(vo.getSiteNo());// 발송자가 로그인한사람
                        sendPo.setSenderNm(vo.getSiteNm());// ??? 발송자가 로그인한 사람?
                    } else {
                        sendPo.setSenderNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
                        sendPo.setSenderNm(SessionDetailHelper.getDetails().getSession().getMemberNm());
                        sendPo.setSendStndrd(toMailList.get(i).getLoginId() + " 회원");
                    }

                    sendPo.setReceiverEmail(toMailList.get(i).getEmail());
                    sendPo.setReceiverNo(toMailList.get(i).getMemberNo());
                    sendPo.setReceiverId(toMailList.get(i).getLoginId());
                    sendPo.setReceiverNm(toMailList.get(i).getMemberNm());
                    sendPo.setRegrNo(po.getRegrNo());
                    sendPo.setSiteNo(vo.getSiteNo());
                    insertEmailSendHst(sendPo);
                    // proxyDao.update(MapperConstants.EMAIL +
                    // "updateEmailPossCnt",
                    // po);
                }
                result = true;
            }
        }catch (AddressException addr_e) {
            log.info("{}", addr_e);
            /*throw new CustomException("biz.exception.common.error", new Object[] { "코드그룹" }, addr_e);*/
        } catch (MessagingException msg_e) {
            log.info("{}", msg_e);
            /*throw new CustomException("biz.exception.common.error", new Object[] { "코드그룹" }, msg_e);*/
        }

        return result;
    }

    public Properties getEmailProperties() {
        Properties p = new Properties();
        /**** ORG 설정 ****/
       /* p.put("mail.smtp.auth", "true");
        p.put("mail.smtp.connectiontimeout", "5000"); // 5초
        p.put("mail.smtp.timeout", "5000"); // 5초
        p.put("mail.smtp.host", smtpIp);
        p.put("mail.smtp.port", "587");
        p.put("mail.transport.protocol", "smtp");
        p.put("mail.smtp.starttls.enable", "true");
        p.put("mail.smtp.socketFactory.class", "javax.net.ssl.SSLSocketFactory");
        p.put("mail.smtp.socketFactory.fallback", "true");*/

        /**** hiworks 용  설정 ***/
        p.put("mail.smtp.ssl.enable", "true");
        p.put("mail.smtp.host", smtpIp);
        p.put("mail.smtp.port", "465");
        p.put("mail.smtp.auth", "true");

        if(server.equals("product")) {
            p.put("mail.debug", "false");
        }else{
            p.put("mail.debug", "true");
        }

        //p.put("mail.smtp.connectiontimeout", "1000"); // 5초
        //p.put("mail.smtp.timeout", "1000"); // 5초


        /** gmail */
        /*p.put("mail.smtp.host", smtpIp);
        p.put("mail.smtp.port", "25");
        p.put("mail.debug", "true");
        p.put("mail.smtp.auth", "true");
        p.put("mail.smtp.starttls.enable","true");
        p.put("mail.smtp.EnableSSL.enable","true");
        p.setProperty("mail.smtp.socketFactory.class", "javax.net.ssl.SSLSocketFactory");
        p.setProperty("mail.smtp.socketFactory.fallback", "false");
        p.setProperty("mail.smtp.port", "465");
        p.setProperty("mail.smtp.socketFactory.port", "465");*/



        return p;
    }

    @Override
    public EmailSendVO selectAdminEmail(EmailSendSO so) {
        // so.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
        return proxyDao.selectOne(MapperConstants.EMAIL + "selectAdminEmail", so);
    }

    @Override
    public List<EmailSendVO> selectEmailHst(EmailSendSO so) {
        return proxyDao.selectList(MapperConstants.EMAIL + "selectEmailHst", so);
    }

    @Override
    public ResultModel<EmailSendVO> selectSendEmailHstOne(EmailSendSO so) {
        EmailSendVO vo = proxyDao.selectOne(MapperConstants.EMAIL + "selectSendEmailHstOne", so);
        ResultModel<EmailSendVO> result = new ResultModel<EmailSendVO>(vo);
        result.setData(vo);
        return result;
    }

}
