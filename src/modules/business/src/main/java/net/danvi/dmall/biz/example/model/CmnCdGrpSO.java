package net.danvi.dmall.biz.example.model;

import lombok.Data;
import lombok.EqualsAndHashCode;
import dmall.framework.common.constraint.NullOrLength;
import dmall.framework.common.model.BaseSearchVO;

/**
 * Created by dong on 2016-04-08.
 */
@Data
@EqualsAndHashCode
public class CmnCdGrpSO extends BaseSearchVO<CmnCdGrpSO> {
    @NullOrLength(min= 2, max= 5)
    private String grpNm;
    private String fromRegDt;
    private String toRegDt;
    private String useYn;
    private String delYn;
    private String userDefine1Nm;
    private String userDefine2Nm;
    private String userDefine3Nm;
    private String userDefine4Nm;
    private String userDefine5Nm;
}
