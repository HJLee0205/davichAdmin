package net.danvi.dmall.biz.app.order.salesproof.model;

import dmall.framework.common.annotation.Encrypt;
import dmall.framework.common.util.CryptoUtil;
import lombok.Data;
import lombok.EqualsAndHashCode;
import dmall.framework.common.model.BaseSearchVO;

/**
 * Created by dong on 2016-05-02.
 */
@Data
@EqualsAndHashCode
public class SalesProofSO extends BaseSearchVO<SalesProofSO> {
    /** 검색시작일 */
    private String ordDayS;
    /** 검색 종료일 */
    private String ordDayE;
    /** 검색어구분 */
    private String searchCd;
    /** 검색어 */
    private String searchWord;

    private String[] proofType;
    private String[] refundYn;
    private String[] applicantGbCd; // 신청자 구문 01 사용자, 02 관리자

    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String searchOrdrNm;
}
