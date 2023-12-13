package net.danvi.dmall.smsemail.model.sms;

import lombok.Data;
import lombok.EqualsAndHashCode;
import net.danvi.dmall.smsemail.model.MemberManageSO;

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
public class SmsSendSO {
    private String fromRegDt;
    private String toRegDt;
    private String fromRecvDttm;
    private String toRecvDttm;
    private String useYn;
    private String searchKind;
    private String searchVal;
    private String pageGb;

    private String smsSendNo;
    private String smsMember;
    private Integer possCnt;
    private String sendWords;
    private String sendTelno;
    private String[] recvTelnoTotal;
    private String[] receiverNoTotal;
    private String[] receiverIdTotal;
    private String[] receiverNmTotal;
    private String[] receiverRecvRjtYnTotal;

    private String[] recvTelnoSearch;
    private String[] receiverNoSearch;
    private String[] receiverIdSearch;
    private String[] receiverNmSearch;
    private String[] receiverRecvRjtYnSearch;

    private String[] recvTelnoSelect;
    private String[] receiverNoSelect;
    private String[] receiverIdSelect;
    private String[] receiverNmSelect;
    private String[] receiverRecvRjtYnSelect;

    private String[] fdestineArr;
    private String fcallback;

    // SMS 발송 내역
    private String receiverId;
    private String receiverNm;
    private String[] resultCd;
    private String recvTelno;

    private String sendFrmCd;
    private String sendTargetCd;
    private String searchType;
    private String searchWords;
    private String searchRecvTelno;

    private String sendTypeCd;
    private String autoSendYn;
    private long memberNo;

    private String templateCode;

    private MemberManageSO memberManageSO;
}
