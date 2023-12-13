package net.danvi.dmall.biz.app.operation.model;

import java.util.Date;

import com.fasterxml.jackson.annotation.JsonFormat;

import lombok.Data;
import lombok.EqualsAndHashCode;
import dmall.framework.common.annotation.Encrypt;
import dmall.framework.common.constants.CommonConstants;
import dmall.framework.common.model.EditorBaseVO;
import dmall.framework.common.util.CryptoUtil;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 6. 16.
 * 작성자     : dong
 * 설명       :
 * </pre>
 */
@Data
@EqualsAndHashCode
public class EmailSendVO extends EditorBaseVO<EmailSendVO> {
    private String memberSendYn;
    private String adminSendYn;
    private String sellerSendYn;
    private String storeSendYn;
    private String staffSendYn;

    private String managerSendYn;
    private String operatorSendYn;

    private String mailTitle;
    private String mailContent;
    private String sendFrmCd;

    // Email 발송 이력
    private String rowNum;
    private String mailSendNo;
    private String ordNo;
    private String sendTargetCd;
    private String mailTypeCd;
    private String mailTypeNm;
    private String resultCd;
    private String sendEmail;
    private String sendTitle;
    private String sendContent;
    private String senderNo;
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String senderNm;
    @JsonFormat(pattern = CommonConstants.DATE_YYYYMMDDHHMMSS, timezone = CommonConstants.DATE_TIMEZONE, locale = CommonConstants.DATE_LOCALE)
    private Date sendDttm;
    private String receiverEmail;
    private String receiverNo;
    private String receiverId;
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String receiverNm;
    private String autoSendYn;
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String loginId;
    private String managerEmail;
    private String custCtEmail;
    private String siteNm;
    private String groupCnt;
    private String successCnt;
    // 발송 기준
    private String sendStndrd;
    // 발송자명+발송 이메일
    private String sendNmAndEmail;
    // 수신자 명
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String memberNm;

}
