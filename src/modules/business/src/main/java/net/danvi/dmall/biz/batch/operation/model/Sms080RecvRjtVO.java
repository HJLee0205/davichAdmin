package net.danvi.dmall.biz.batch.operation.model;

import java.io.Serializable;

/**
 * Created by dong on 2016-10-05.
 */
public class Sms080RecvRjtVO implements Serializable {

    private static final long serialVersionUID = 2709119833477232476L;

    private String certifyCd;
    private String dn;
    private String telno;

    public String getCertifyCd() {
        return certifyCd;
    }

    public void setCertifyCd(String certifyCd) {
        this.certifyCd = certifyCd;
    }

    public String getDn() {
        return dn;
    }

    public void setDn(String dn) {
        this.dn = dn;
    }

    public String getTelno() {
        return telno;
    }

    public void setTelno(String telno) {
        this.telno = telno;
    }
}
