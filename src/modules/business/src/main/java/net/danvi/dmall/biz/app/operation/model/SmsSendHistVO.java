package net.danvi.dmall.biz.app.operation.model;

import dmall.framework.common.annotation.Encrypt;
import dmall.framework.common.model.BaseModel;
import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * Created by dong on 2016-08-29.
 */
@Data
@EqualsAndHashCode
public class SmsSendHistVO extends BaseModel<SmsSendHistVO> {
    private String senderId;
    @Encrypt
    private String senderNm;
    private String senderNo;
    private String sendWords;
    private String receiverId;
    @Encrypt
    private String receiverNm;
    private String receiverNo;
    @Encrypt
    private String recvTelno;
    private String recvDttm;
    private String sendDttm;
    private String realSendDttm;
    private String status;
    private String msg;
    private String frsltdate;
    private String fsendstat;
    private String frsltstat;
    private String frsltstatnm;
    private String rownum;
    private String rowNum;
    private String sendFrmNm;
    @Encrypt
    private String sendTelno;

    // SMS 실패 관련 변수
    private Integer fsequence;
    private Integer msgkey;
    private Long siteNo;
    private Integer smsFailPoint;

    private String sortNum;
    private String rslt;
}
