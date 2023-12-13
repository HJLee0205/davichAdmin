package net.danvi.dmall.biz.app.operation.model;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.Data;
import lombok.EqualsAndHashCode;
import dmall.framework.common.annotation.Encrypt;
import dmall.framework.common.model.BaseSearchVO;
import dmall.framework.common.util.CryptoUtil;
import net.danvi.dmall.biz.app.board.model.BbsManageSO;
import net.danvi.dmall.biz.app.member.manage.model.MemberManageSO;

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
public class SmsSendSO extends BaseSearchVO<BbsManageSO> {
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

    private String storeNo;

    @JsonFormat(with = JsonFormat.Feature.ACCEPT_SINGLE_VALUE_AS_ARRAY)
    private String[] recvTelnoTotal;
    @JsonFormat(with = JsonFormat.Feature.ACCEPT_SINGLE_VALUE_AS_ARRAY)
    private String[] receiverNoTotal;
    @JsonFormat(with = JsonFormat.Feature.ACCEPT_SINGLE_VALUE_AS_ARRAY)
    private String[] receiverIdTotal;
    @JsonFormat(with = JsonFormat.Feature.ACCEPT_SINGLE_VALUE_AS_ARRAY)
    private String[] receiverNmTotal;
    @JsonFormat(with = JsonFormat.Feature.ACCEPT_SINGLE_VALUE_AS_ARRAY)
    private String[] receiverRecvRjtYnTotal;

    @JsonFormat(with = JsonFormat.Feature.ACCEPT_SINGLE_VALUE_AS_ARRAY)
    private String[] recvTelnoSearch;
    @JsonFormat(with = JsonFormat.Feature.ACCEPT_SINGLE_VALUE_AS_ARRAY)
    private String[] receiverNoSearch;
    @JsonFormat(with = JsonFormat.Feature.ACCEPT_SINGLE_VALUE_AS_ARRAY)
    private String[] receiverIdSearch;
    @JsonFormat(with = JsonFormat.Feature.ACCEPT_SINGLE_VALUE_AS_ARRAY)
    private String[] receiverNmSearch;
    @JsonFormat(with = JsonFormat.Feature.ACCEPT_SINGLE_VALUE_AS_ARRAY)
    private String[] receiverRecvRjtYnSearch;

    @JsonFormat(with = JsonFormat.Feature.ACCEPT_SINGLE_VALUE_AS_ARRAY)
    private String[] recvTelnoSelect;
    @JsonFormat(with = JsonFormat.Feature.ACCEPT_SINGLE_VALUE_AS_ARRAY)
    private String[] receiverNoSelect;
    @JsonFormat(with = JsonFormat.Feature.ACCEPT_SINGLE_VALUE_AS_ARRAY)
    private String[] receiverIdSelect;
    @JsonFormat(with = JsonFormat.Feature.ACCEPT_SINGLE_VALUE_AS_ARRAY)
    private String[] receiverNmSelect;
    @JsonFormat(with = JsonFormat.Feature.ACCEPT_SINGLE_VALUE_AS_ARRAY)
    private String[] receiverRecvRjtYnSelect;
    @JsonFormat(with = JsonFormat.Feature.ACCEPT_SINGLE_VALUE_AS_ARRAY)
    private String[] receiverSmsRecvYnSelect;

    @JsonFormat(with = JsonFormat.Feature.ACCEPT_SINGLE_VALUE_AS_ARRAY)
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
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String searchWords;
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String searchRecvTelno;

    private String sendTypeCd;
    private String autoSendYn;
    private long memberNo;
    private long sellerNo;

    private String templateCode;

    private MemberManageSO memberManageSO;

    private String memberTemplateCode;
    private String adminTemplateCode;
    private String sellerTemplateCode;
    private String storeTemplateCode;
}
