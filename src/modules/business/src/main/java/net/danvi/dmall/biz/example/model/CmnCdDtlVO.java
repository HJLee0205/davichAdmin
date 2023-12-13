package net.danvi.dmall.biz.example.model;

import lombok.Data;
import lombok.EqualsAndHashCode;
import dmall.framework.common.model.BaseModel;

import java.util.Date;

/**
 * Created by dong on 2016-04-08.
 */
@Data
@EqualsAndHashCode
public class CmnCdDtlVO extends BaseModel<CmnCdDtlVO> {
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
    private Date delDttm;
    private Long delrNo;
}
