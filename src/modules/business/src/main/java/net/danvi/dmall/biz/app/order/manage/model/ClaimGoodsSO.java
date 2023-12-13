package net.danvi.dmall.biz.app.order.manage.model;

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
public class ClaimGoodsSO extends BaseSearchVO<ClaimGoodsSO> {
    /** 검색시작일 */
    private String refundDayS;
    /** 검색 종료일 */
    private String refundDayE;
    /** 환불 상태 코드 */
    private String[] refundStatusCd;
    /** 회원구분 */
    private String memberOrdYn;
    /** 검색어구분 */
    private String searchCd;
    /** 검색어 */
    private String searchWord;
    /** 회원(주문자) 번호 */
    private long memberNo;
    /** 회원(주문자) ID */
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String loginId;
    /** 주문 번호 */
    private String refundNo;
    /** 주문 상세 번호 */
    private String ordDtlSeq;
}
