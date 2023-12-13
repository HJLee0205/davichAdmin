package net.danvi.dmall.biz.app.operation.model;

import lombok.Data;
import lombok.EqualsAndHashCode;
import dmall.framework.common.annotation.Encrypt;
import dmall.framework.common.model.BaseSearchVO;
import dmall.framework.common.util.CryptoUtil;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 5. 10.
 * 작성자     : kjw
 * 설명       : 마켓포인트 내역 조회 Value Object 클래스
 * </pre>
 */
@Data
@EqualsAndHashCode(callSuper = false)
public class SavedmnPointSO extends BaseSearchVO<SavedmnPointSO> {
    // 검색 종류
    private String searchKind;
    // 검색 값
    private String searchVal;
    // 회원번호
    private long memberNoSelect;
    // 지급/차감일 시작
    private String stRegDttm;
    // 지급/차감일 종료
    private String endRegDttm;
    // 마켓포인트/포인트 구분 코드(지급,차감)
    private String pointGbCd;
    // 마켓포인트/포인트 사유 코드
    private String reasonCd;
    // 주문번호
    private String ordNo;
    // 회원명 검색
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String memberNm;
    // ERP 주문번호(ERP에서 몰마켓포인트 사용시) [ERP판매테이블 PK조합]
    private String erpOrdNo;
    private String memberNo;
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String loginId;
}
