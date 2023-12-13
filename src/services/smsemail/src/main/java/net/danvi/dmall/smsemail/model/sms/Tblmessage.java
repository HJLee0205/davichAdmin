package net.danvi.dmall.smsemail.model.sms;

import java.util.Date;

import net.danvi.dmall.smsemail.model.request.SmsSendPO;

/**
 * Created by dong on 2016-09-05.
 */
public class Tblmessage {
    private Long fsequence;
    private Long fserial;
    private String fuserid;
    private Date fsenddate;
    private String fsendstat;
    private String frsltstat;
    private String fmobilecomp;
    private String fretry;
    private Date foldsdate;
    private String foldrslt;
    private String fmsgtype;
    private String fdestine;
    private String fcallback;
    private Date frsltdate;
    private Date fmodidate;
    private String ftext;
    private String fetc1;
    private String fetc2;
    private String fetc3;
    private String fetc4;
    private String fetc5;
    private String fetc6;
    private String fetc7;
    private Long fetc8;
    private String fetc9;
    private String fetc10;
    private String fetc11;
    private Integer fetc12;
    private String failedType;
    private String failedSubject;
    private String failedMsg;
    private String templateCode;

    public Tblmessage() {
    }

    public Tblmessage(SmsSendPO po) {
        this.fuserid = "" + po.getSiteNo();
        this.fdestine = po.getFdestine();
        this.fcallback = po.getFcallback();
        this.ftext = po.getSendWords();
        this.fetc1 = "" + po.getSmsSendNo();
        this.failedType=po.getFailedType();
        this.failedSubject=po.getFailedSubject();
        this.failedMsg=po.getFailedMsg();
        this.templateCode=po.getTemplateCode();

    }

    public Long getFsequence() {
        return fsequence;
    }

    public void setFsequence(Long fsequence) {
        this.fsequence = fsequence;
    }

    public Long getFserial() {
        return fserial;
    }

    public void setFserial(Long fserial) {
        this.fserial = fserial;
    }

    public String getFuserid() {
        return fuserid;
    }

    public void setFuserid(String fuserid) {
        this.fuserid = fuserid;
    }

    public Date getFsenddate() {
        return fsenddate;
    }

    public void setFsenddate(Date fsenddate) {
        this.fsenddate = fsenddate;
    }

    public String getFsendstat() {
        return fsendstat;
    }

    public void setFsendstat(String fsendstat) {
        this.fsendstat = fsendstat;
    }

    public String getFrsltstat() {
        return frsltstat;
    }

    public void setFrsltstat(String frsltstat) {
        this.frsltstat = frsltstat;
    }

    public String getFmobilecomp() {
        return fmobilecomp;
    }

    public void setFmobilecomp(String fmobilecomp) {
        this.fmobilecomp = fmobilecomp;
    }

    public String getFretry() {
        return fretry;
    }

    public void setFretry(String fretry) {
        this.fretry = fretry;
    }

    public Date getFoldsdate() {
        return foldsdate;
    }

    public void setFoldsdate(Date foldsdate) {
        this.foldsdate = foldsdate;
    }

    public String getFoldrslt() {
        return foldrslt;
    }

    public void setFoldrslt(String foldrslt) {
        this.foldrslt = foldrslt;
    }

    public String getFmsgtype() {
        return fmsgtype;
    }

    public void setFmsgtype(String fmsgtype) {
        this.fmsgtype = fmsgtype;
    }

    public String getFdestine() {
        return fdestine;
    }

    public void setFdestine(String fdestine) {
        this.fdestine = fdestine;
    }

    public String getFcallback() {
        return fcallback;
    }

    public void setFcallback(String fcallback) {
        this.fcallback = fcallback;
    }

    public Date getFrsltdate() {
        return frsltdate;
    }

    public void setFrsltdate(Date frsltdate) {
        this.frsltdate = frsltdate;
    }

    public Date getFmodidate() {
        return fmodidate;
    }

    public void setFmodidate(Date fmodidate) {
        this.fmodidate = fmodidate;
    }

    public String getFtext() {
        return ftext;
    }

    public void setFtext(String ftext) {
        this.ftext = ftext;
    }

    public String getFetc1() {
        return fetc1;
    }

    public void setFetc1(String fetc1) {
        this.fetc1 = fetc1;
    }

    public String getFetc2() {
        return fetc2;
    }

    public void setFetc2(String fetc2) {
        this.fetc2 = fetc2;
    }

    public String getFetc3() {
        return fetc3;
    }

    public void setFetc3(String fetc3) {
        this.fetc3 = fetc3;
    }

    public String getFetc4() {
        return fetc4;
    }

    public void setFetc4(String fetc4) {
        this.fetc4 = fetc4;
    }

    public String getFetc5() {
        return fetc5;
    }

    public void setFetc5(String fetc5) {
        this.fetc5 = fetc5;
    }

    public String getFetc6() {
        return fetc6;
    }

    public void setFetc6(String fetc6) {
        this.fetc6 = fetc6;
    }

    public String getFetc7() {
        return fetc7;
    }

    public void setFetc7(String fetc7) {
        this.fetc7 = fetc7;
    }

    public Long getFetc8() {
        return fetc8;
    }

    public void setFetc8(Long fetc8) {
        this.fetc8 = fetc8;
    }

    public String getFetc9() {
        return fetc9;
    }

    public void setFetc9(String fetc9) {
        this.fetc9 = fetc9;
    }

    public String getFetc10() {
        return fetc10;
    }

    public void setFetc10(String fetc10) {
        this.fetc10 = fetc10;
    }

    public String getFetc11() {
        return fetc11;
    }

    public void setFetc11(String fetc11) {
        this.fetc11 = fetc11;
    }

    public Integer getFetc12() {
        return fetc12;
    }

    public void setFetc12(Integer fetc12) {
        this.fetc12 = fetc12;
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
        return "Tblmessage{" +
                "fsequence=" + fsequence +
                ", fserial=" + fserial +
                ", fuserid='" + fuserid + '\'' +
                ", fsenddate=" + fsenddate +
                ", fsendstat='" + fsendstat + '\'' +
                ", frsltstat='" + frsltstat + '\'' +
                ", fmobilecomp='" + fmobilecomp + '\'' +
                ", fretry='" + fretry + '\'' +
                ", foldsdate=" + foldsdate +
                ", foldrslt='" + foldrslt + '\'' +
                ", fmsgtype='" + fmsgtype + '\'' +
                ", fdestine='" + fdestine + '\'' +
                ", fcallback='" + fcallback + '\'' +
                ", frsltdate=" + frsltdate +
                ", fmodidate=" + fmodidate +
                ", ftext='" + ftext + '\'' +
                ", fetc1='" + fetc1 + '\'' +
                ", fetc2='" + fetc2 + '\'' +
                ", fetc3='" + fetc3 + '\'' +
                ", fetc4='" + fetc4 + '\'' +
                ", fetc5='" + fetc5 + '\'' +
                ", fetc6='" + fetc6 + '\'' +
                ", fetc7='" + fetc7 + '\'' +
                ", fetc8=" + fetc8 +
                ", fetc9='" + fetc9 + '\'' +
                ", fetc10='" + fetc10 + '\'' +
                ", fetc11='" + fetc11 + '\'' +
                ", fetc12=" + fetc12 +
                ", failedType='" + failedType + '\'' +
                ", failedSubject='" + failedSubject + '\'' +
                ", failedMsg='" + failedMsg + '\'' +
                ", templateCode='" + templateCode + '\'' +
                '}';
    }
}
