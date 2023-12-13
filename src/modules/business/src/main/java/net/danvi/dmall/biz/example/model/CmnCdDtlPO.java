package net.danvi.dmall.biz.example.model;

import lombok.Data;
import lombok.EqualsAndHashCode;
import dmall.framework.common.model.BaseModel;

/**
 * Created by dong on 2016-04-08.
 */
@Data
@EqualsAndHashCode
public class CmnCdDtlPO extends BaseModel<CmnCdDtlPO> {
    private String grpCd;
    private String cd;
    private String cdNm;
    private String cdShortNm;
    private String cdDscrp;
    private Integer sortSeq;
    private String useYn;
    private String userDefine1;
    private String userDefine2;
    private String userDefine3;
    private String userDefine4;
    private String userDefine5;
    private String delYn;
    private Long regrNo;
    private Long updrNo;
    private Long delrNo;
}
