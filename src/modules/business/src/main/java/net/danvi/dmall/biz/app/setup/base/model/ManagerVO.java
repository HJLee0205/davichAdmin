package net.danvi.dmall.biz.app.setup.base.model;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.Data;
import dmall.framework.common.annotation.Encrypt;
import dmall.framework.common.constants.CommonConstants;
import dmall.framework.common.model.BaseModel;
import dmall.framework.common.util.CryptoUtil;

import java.util.Date;

/**
 * Created by dong on 2016-05-03.
 */
@Data
public class ManagerVO extends BaseModel<ManagerVO> {
    private String rownum;
    private String sortNum;
    private String memberNo;
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String memberNm;
    @JsonFormat(pattern = CommonConstants.DATE_YYYYMMDD, timezone = CommonConstants.DATE_TIMEZONE, locale = CommonConstants.DATE_LOCALE)
    private Date joinDttm;
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String loginId;
    @JsonFormat(pattern = CommonConstants.DATE_YYYYMMDDHHMMSS, timezone = CommonConstants.DATE_TIMEZONE, locale = CommonConstants.DATE_LOCALE)
    private Date loginDttm;
    private String authGbCd;
    private String authNm;
    private String authGrpNm;
    private Long authGrpNo;
}
