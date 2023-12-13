package net.danvi.dmall.biz.system.model;

import lombok.Data;
import dmall.framework.common.model.BaseModel;

import java.util.Date;

/**
 * Created by dong on 2016-07-12.
 */
@Data
public class WebLogPO extends BaseModel {
    private String jsessionid;
    private String ip;
    private Date accessDttm;
    private String deviceType; // 0:PC, 1:mobile
    private String referer;
    private String url;
    private Long memberNo;
}
