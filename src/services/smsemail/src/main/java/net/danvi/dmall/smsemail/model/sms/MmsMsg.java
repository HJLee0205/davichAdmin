package net.danvi.dmall.smsemail.model.sms;

import java.util.Date;

import net.danvi.dmall.smsemail.model.request.SmsSendPO;

/**
 * Created by dong on 2016-09-05.
 */
public class MmsMsg {
    private Long msgkey;
    private String subject;
    private String phone;
    private String callback;
    private String status;
    private Date reqdate;
    private String msg;
    private Long fileCnt;
    private Long fileCntReal;
    private String filePath1;
    private Long filePath1Siz;
    private String filePath2;
    private Long filePath2Siz;
    private String filePath3;
    private Long filePath3Siz;
    private String filePath4;
    private Long filePath4Siz;
    private String filePath5;
    private Long filePath5Siz;
    private String expiretime;
    private Date sentdate;
    private Date rsltdate;
    private Date reportdate;
    private Date terminateddate;
    private String rslt;
    private String retry;
    private Date oldreqdate;
    private String oldrslt;
    private String type;
    private String telcoinfo;
    private String id;
    private String post;
    private String etc1;
    private String etc2;
    private String etc3;
    private String etc4;
    private String etc5;
    private String etc6;
    private String etc7;
    private String etc8;
    private String etc9;
    private String etc10;
    private String failedType;
    private String failedSubject;
    private String failedMsg;
    private String templateCode;

    public MmsMsg(SmsSendPO po) {
        // this.phone = po.getRecvTelno();
        this.phone = po.getFdestine();
        // this.callback = po.getSendTelno();
        this.callback = po.getFcallback();
        this.msg = po.getSendWords();
        this.etc1 = "" + po.getSmsSendNo();
        this.subject = po.getSubject();
        this.failedType=po.getFailedType();
        this.failedSubject=po.getFailedSubject();
        this.failedMsg=po.getFailedMsg();
        this.templateCode=po.getTemplateCode();
    }

    public Long getMsgkey() {
        return msgkey;
    }

    public void setMsgkey(Long msgkey) {
        this.msgkey = msgkey;
    }

    public String getSubject() {
        return subject;
    }

    public void setSubject(String subject) {
        this.subject = subject;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getCallback() {
        return callback;
    }

    public void setCallback(String callback) {
        this.callback = callback;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Date getReqdate() {
        return reqdate;
    }

    public void setReqdate(Date reqdate) {
        this.reqdate = reqdate;
    }

    public String getMsg() {
        return msg;
    }

    public void setMsg(String msg) {
        this.msg = msg;
    }

    public Long getFileCnt() {
        return fileCnt;
    }

    public void setFileCnt(Long fileCnt) {
        this.fileCnt = fileCnt;
    }

    public Long getFileCntReal() {
        return fileCntReal;
    }

    public void setFileCntReal(Long fileCntReal) {
        this.fileCntReal = fileCntReal;
    }

    public String getFilePath1() {
        return filePath1;
    }

    public void setFilePath1(String filePath1) {
        this.filePath1 = filePath1;
    }

    public Long getFilePath1Siz() {
        return filePath1Siz;
    }

    public void setFilePath1Siz(Long filePath1Siz) {
        this.filePath1Siz = filePath1Siz;
    }

    public String getFilePath2() {
        return filePath2;
    }

    public void setFilePath2(String filePath2) {
        this.filePath2 = filePath2;
    }

    public Long getFilePath2Siz() {
        return filePath2Siz;
    }

    public void setFilePath2Siz(Long filePath2Siz) {
        this.filePath2Siz = filePath2Siz;
    }

    public String getFilePath3() {
        return filePath3;
    }

    public void setFilePath3(String filePath3) {
        this.filePath3 = filePath3;
    }

    public Long getFilePath3Siz() {
        return filePath3Siz;
    }

    public void setFilePath3Siz(Long filePath3Siz) {
        this.filePath3Siz = filePath3Siz;
    }

    public String getFilePath4() {
        return filePath4;
    }

    public void setFilePath4(String filePath4) {
        this.filePath4 = filePath4;
    }

    public Long getFilePath4Siz() {
        return filePath4Siz;
    }

    public void setFilePath4Siz(Long filePath4Siz) {
        this.filePath4Siz = filePath4Siz;
    }

    public String getFilePath5() {
        return filePath5;
    }

    public void setFilePath5(String filePath5) {
        this.filePath5 = filePath5;
    }

    public Long getFilePath5Siz() {
        return filePath5Siz;
    }

    public void setFilePath5Siz(Long filePath5Siz) {
        this.filePath5Siz = filePath5Siz;
    }

    public String getExpiretime() {
        return expiretime;
    }

    public void setExpiretime(String expiretime) {
        this.expiretime = expiretime;
    }

    public Date getSentdate() {
        return sentdate;
    }

    public void setSentdate(Date sentdate) {
        this.sentdate = sentdate;
    }

    public Date getRsltdate() {
        return rsltdate;
    }

    public void setRsltdate(Date rsltdate) {
        this.rsltdate = rsltdate;
    }

    public Date getReportdate() {
        return reportdate;
    }

    public void setReportdate(Date reportdate) {
        this.reportdate = reportdate;
    }

    public Date getTerminateddate() {
        return terminateddate;
    }

    public void setTerminateddate(Date terminateddate) {
        this.terminateddate = terminateddate;
    }

    public String getRslt() {
        return rslt;
    }

    public void setRslt(String rslt) {
        this.rslt = rslt;
    }

    public String getRetry() {
        return retry;
    }

    public void setRetry(String retry) {
        this.retry = retry;
    }

    public Date getOldreqdate() {
        return oldreqdate;
    }

    public void setOldreqdate(Date oldreqdate) {
        this.oldreqdate = oldreqdate;
    }

    public String getOldrslt() {
        return oldrslt;
    }

    public void setOldrslt(String oldrslt) {
        this.oldrslt = oldrslt;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public String getTelcoinfo() {
        return telcoinfo;
    }

    public void setTelcoinfo(String telcoinfo) {
        this.telcoinfo = telcoinfo;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getPost() {
        return post;
    }

    public void setPost(String post) {
        this.post = post;
    }

    public String getEtc1() {
        return etc1;
    }

    public void setEtc1(String etc1) {
        this.etc1 = etc1;
    }

    public String getEtc2() {
        return etc2;
    }

    public void setEtc2(String etc2) {
        this.etc2 = etc2;
    }

    public String getEtc3() {
        return etc3;
    }

    public void setEtc3(String etc3) {
        this.etc3 = etc3;
    }

    public String getEtc4() {
        return etc4;
    }

    public void setEtc4(String etc4) {
        this.etc4 = etc4;
    }

    public String getEtc5() {
        return etc5;
    }

    public void setEtc5(String etc5) {
        this.etc5 = etc5;
    }

    public String getEtc6() {
        return etc6;
    }

    public void setEtc6(String etc6) {
        this.etc6 = etc6;
    }

    public String getEtc7() {
        return etc7;
    }

    public void setEtc7(String etc7) {
        this.etc7 = etc7;
    }

    public String getEtc8() {
        return etc8;
    }

    public void setEtc8(String etc8) {
        this.etc8 = etc8;
    }

    public String getEtc9() {
        return etc9;
    }

    public void setEtc9(String etc9) {
        this.etc9 = etc9;
    }

    public String getEtc10() {
        return etc10;
    }

    public void setEtc10(String etc10) {
        this.etc10 = etc10;
    }

    public String getFailedType() {
        return failedType;
    }

    public void setFailedType(String failedType) {
        this.failedType = failedType;
    }

    public String getFailedSubject() {
        return failedSubject;
    }

    public void setFailedSubject(String failedSubject) {
        this.failedSubject = failedSubject;
    }

    public String getFailedMsg() {
        return failedMsg;
    }

    public void setFailedMsg(String failedMsg) {
        this.failedMsg = failedMsg;
    }

    public String getTemplateCode() {
        return templateCode;
    }

    public void setTemplateCode(String templateCode) {
        this.templateCode = templateCode;
    }

    @Override
    public String toString() {
        return "MmsMsg{" +
                "msgkey=" + msgkey +
                ", subject='" + subject + '\'' +
                ", phone='" + phone + '\'' +
                ", callback='" + callback + '\'' +
                ", status='" + status + '\'' +
                ", reqdate=" + reqdate +
                ", msg='" + msg + '\'' +
                ", fileCnt=" + fileCnt +
                ", fileCntReal=" + fileCntReal +
                ", filePath1='" + filePath1 + '\'' +
                ", filePath1Siz=" + filePath1Siz +
                ", filePath2='" + filePath2 + '\'' +
                ", filePath2Siz=" + filePath2Siz +
                ", filePath3='" + filePath3 + '\'' +
                ", filePath3Siz=" + filePath3Siz +
                ", filePath4='" + filePath4 + '\'' +
                ", filePath4Siz=" + filePath4Siz +
                ", filePath5='" + filePath5 + '\'' +
                ", filePath5Siz=" + filePath5Siz +
                ", expiretime='" + expiretime + '\'' +
                ", sentdate=" + sentdate +
                ", rsltdate=" + rsltdate +
                ", reportdate=" + reportdate +
                ", terminateddate=" + terminateddate +
                ", rslt='" + rslt + '\'' +
                ", retry='" + retry + '\'' +
                ", oldreqdate=" + oldreqdate +
                ", oldrslt='" + oldrslt + '\'' +
                ", type='" + type + '\'' +
                ", telcoinfo='" + telcoinfo + '\'' +
                ", id='" + id + '\'' +
                ", post='" + post + '\'' +
                ", etc1='" + etc1 + '\'' +
                ", etc2='" + etc2 + '\'' +
                ", etc3='" + etc3 + '\'' +
                ", etc4='" + etc4 + '\'' +
                ", etc5='" + etc5 + '\'' +
                ", etc6='" + etc6 + '\'' +
                ", etc7='" + etc7 + '\'' +
                ", etc8='" + etc8 + '\'' +
                ", etc9='" + etc9 + '\'' +
                ", etc10='" + etc10 + '\'' +
                ", failedType='" + failedType + '\'' +
                ", failedSubject='" + failedSubject + '\'' +
                ", failedMsg='" + failedMsg + '\'' +
                ", templateCode='" + templateCode + '\'' +
                '}';
    }
}
