package dmall.framework.common.model;

import com.fasterxml.jackson.annotation.JsonFormat;
import dmall.framework.common.constants.CommonConstants;

import java.io.Serializable;
import java.util.Date;

/**
 * Created by dong on 2016-04-08.
 */
public class BaseModel<T> implements Serializable {
    private static final long serialVersionUID = 5222444252153304005L;
    private Long companyNo;
    private String siteNo;

    private Long regrNo;
    private String regrNm;

    @JsonFormat(pattern = CommonConstants.DATE_YYYYMMDD, timezone = CommonConstants.DATE_TIMEZONE, locale = CommonConstants.DATE_LOCALE)
    private Date regDttm;

    private Long updrNo;
    private String updrNm;

    @JsonFormat(pattern = CommonConstants.DATE_YYYYMMDD, timezone = CommonConstants.DATE_TIMEZONE, locale = CommonConstants.DATE_LOCALE)
    private Date updDttm;

    private Long delrNo;
    private String delrNm;

    @JsonFormat(pattern = CommonConstants.DATE_YYYYMMDD, timezone = CommonConstants.DATE_TIMEZONE, locale = CommonConstants.DATE_LOCALE)
    private Date delDttm;
}
