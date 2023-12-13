package net.danvi.dmall.biz.app.main.model;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.Data;
import dmall.framework.common.constants.CommonConstants;
import dmall.framework.common.model.BaseModel;

import java.util.Date;

/**
 * Created by dong on 2016-07-12.
 */
@Data
public class AdminInfoVO extends BaseModel<AdminInfoVO> {
    private String version = "1.0";
    @JsonFormat(pattern = "yyyy.MM.dd", timezone = CommonConstants.DATE_TIMEZONE, locale = CommonConstants.DATE_LOCALE)
    private Date regDttm;
    @JsonFormat(pattern = "yyyy.MM.dd", timezone = CommonConstants.DATE_TIMEZONE, locale = CommonConstants.DATE_LOCALE)
    private Date svcStartDt;
    @JsonFormat(pattern = "yyyy.MM.dd", timezone = CommonConstants.DATE_TIMEZONE, locale = CommonConstants.DATE_LOCALE)
    private Date svcEndDt;
    private Integer restDate;
    private String domain;
    private Integer sms = 0;
    private String totalSpace = "0";
    private String useSpace = "0";
    private String useSpacePercent = "0%";

}
