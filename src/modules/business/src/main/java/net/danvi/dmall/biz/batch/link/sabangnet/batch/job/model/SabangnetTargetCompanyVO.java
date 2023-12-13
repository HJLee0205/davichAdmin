package net.danvi.dmall.biz.batch.link.sabangnet.batch.job.model;

import java.io.Serializable;

import lombok.Data;

@Data
public class SabangnetTargetCompanyVO implements Serializable {
    private static final long serialVersionUID = -5868615968347416367L;

    private Long companyNo;
    private Long siteNo;
    private String companyNm;
    private String siteId;
    private String siteNm;
    private String sendCompaynyId;
    private String sendAuthKey;
    private String sendDate;
    private String dlgtDomain;
    private String stDate;
    private String edDate;
}
