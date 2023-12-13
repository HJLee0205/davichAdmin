package net.danvi.dmall.biz.system.model;

import lombok.Data;
import dmall.framework.common.model.BaseModel;

import java.io.Serializable;

/**
 * Created by dong on 2016-08-18.
 */
@Data
public class SiteQuotaPO extends BaseModel<SiteQuotaPO> implements Serializable {

    private Integer managerActCnt;
    private Integer nopbActCnt;
    private Integer iconCnt;
    private Integer bbsCnt;
}
