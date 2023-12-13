package net.danvi.dmall.biz.system.model;

import lombok.Data;

/**
 * Created by dong on 2016-08-18.
 */
@Data
public class SiteQuotaVO {
    private String siteTypeCd;
    private Integer realCount;
    private Integer quotaCount;
}
