package net.danvi.dmall.biz.example.model;

import net.danvi.dmall.biz.system.validation.InsertGroup;
import net.danvi.dmall.biz.system.validation.UpdateGroup;
import org.hibernate.validator.constraints.NotEmpty;

import lombok.Data;
import lombok.EqualsAndHashCode;
import dmall.framework.common.model.BaseModel;

/**
 * Created by dong on 2016-04-08.
 */
@Data
@EqualsAndHashCode(callSuper = false)
public class CmnCdGrpPO extends BaseModel<CmnCdGrpPO> {
    @NotEmpty
    private String grpCd;
    @NotEmpty(groups = { InsertGroup.class, UpdateGroup.class })
    private String grpNm;
    private String grpDscrt;
    @NotEmpty(groups = { InsertGroup.class, UpdateGroup.class })
    private String useYn;
    private String userDefine1Nm;
    private String userDefine2Nm;
    private String userDefine3Nm;
    private String userDefine4Nm;
    private String userDefine5Nm;
    @NotEmpty(groups = { InsertGroup.class, UpdateGroup.class })
    private String delYn;
}
