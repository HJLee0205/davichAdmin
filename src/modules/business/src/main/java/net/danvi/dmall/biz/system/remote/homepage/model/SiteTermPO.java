package net.danvi.dmall.biz.system.remote.homepage.model;

import lombok.Data;
import dmall.framework.common.model.BaseModel;

/**
 * Created by dong on 2016-09-05.
 */
@Data
public class SiteTermPO extends BaseModel<SiteTermPO> {
    private String siteInfoCd;
    private String content;
}
