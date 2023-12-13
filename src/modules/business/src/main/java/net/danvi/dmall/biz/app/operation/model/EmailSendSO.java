package net.danvi.dmall.biz.app.operation.model;

import lombok.Data;
import lombok.EqualsAndHashCode;
import dmall.framework.common.annotation.Encrypt;
import dmall.framework.common.model.BaseSearchVO;
import dmall.framework.common.util.CryptoUtil;

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
public class EmailSendSO extends BaseSearchVO<EmailSendSO> {
    private String fromRegDt;
    private String toRegDt;
    private String fromRecvDttm;
    private String toRecvDttm;
    private String useYn;
    private String searchKind;
    private String searchVal;
    private String pageGb;
    private String mailTypeCd;
    private long ordNo;
    private long memberNo;
    private long sellerNo;
    private String mailSendNo;
    private String sendEmail;
    private String emailMember;
    private String autoSendYn;
    private String sendDttm;
    private String sendStndrd;
    private long regrNo;

    private long receiverNo;
    private String receiverId;
    private String receiverNm;
    private String receiverEmail;

    private String[] recvEmailTotal;
    private long[] receiverNoTotal;
    private String[] receiverNmTotal;

    private String[] recvEmailSearch;
    private long[] receiverNoSearch;
    private String[] receiverNmSearch;

    private String[] recvEmailSelect;
    private long[] receiverNoSelect;
    private String[] receiverNmSelect;

    // 삭제 이메일 발송 번호
    private String[] delEmailShotHst;
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String memberNm;
    // 결과코드
    private String resultCd;
}
