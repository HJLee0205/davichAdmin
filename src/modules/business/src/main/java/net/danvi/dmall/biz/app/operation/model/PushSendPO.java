package net.danvi.dmall.biz.app.operation.model;

import dmall.framework.common.annotation.Encrypt;
import dmall.framework.common.model.BaseModel;
import dmall.framework.common.util.CryptoUtil;
import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 5. 4.
 * 작성자     : dong
 * 설명       :
 * </pre>
 */
@Data
@EqualsAndHashCode
public class PushSendPO extends BaseModel<PushSendPO> {
    private String pushNo;
    private String receiverNo;
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String receiverId;
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String receiverNm;
    private String appToken;
    private String osType;
    private String srchCndt;
}
