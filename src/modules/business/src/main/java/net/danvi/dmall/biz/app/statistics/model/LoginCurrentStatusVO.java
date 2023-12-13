package net.danvi.dmall.biz.app.statistics.model;

import dmall.framework.common.annotation.Encrypt;
import dmall.framework.common.util.CryptoUtil;
import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 8. 29.
 * 작성자     : sin
 * 설명       :
 * </pre>
 */
@Data
@EqualsAndHashCode(callSuper = false)
public class LoginCurrentStatusVO {
    private String rank;
    public String yr;
    public String mm;
    public String dt;
    private String eqpmGbCd;
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String loginId;
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String memberNm;
    private String lastLoginDttm;
    private String totLoginCnt;
    private String pageVw;
}
