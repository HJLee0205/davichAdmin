package net.danvi.dmall.biz.example.model;

import lombok.Data;
import lombok.EqualsAndHashCode;
import org.hibernate.validator.constraints.NotEmpty;
import dmall.framework.common.model.BaseModel;

/**
 * Created by dong on 2016-04-08.
 */
@Data
@EqualsAndHashCode
public class CmnCdGrpVO extends BaseModel<CmnCdGrpVO> {
    @NotEmpty
    private String grpCd;
    private String grpNm;
    private String grpDscrt;
    private String useYn;
    private String userDefine1Nm;
    private String userDefine2Nm;
    private String userDefine3Nm;
    private String userDefine4Nm;
    private String userDefine5Nm;
    private String delYn;
}
