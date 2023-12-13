package net.danvi.dmall.biz.app.operation.model;

import org.hibernate.validator.constraints.NotEmpty;

import lombok.Data;
import lombok.EqualsAndHashCode;
import dmall.framework.common.annotation.Encrypt;
import dmall.framework.common.model.BaseModel;
import dmall.framework.common.util.CryptoUtil;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 5. 10.
 * 작성자     : kjw
 * 설명       : 마켓포인트/포인트 관리 Value Object 클래스
 * </pre>
 */
@Data
@EqualsAndHashCode
public class SavedmnPointVO extends BaseModel<SavedmnPointVO> {

    // 유형명(자동,수동)
    private String typeNm;
    private String svmnTypeNm;
    // 마켓포인트 사유코드
    private String svmnReasonCd;
    // 포인트 사유코드
    private String pointReasonCd;
    // 기타 사유
    private String etcReason;
    // 처리금액
    private String prcAmt;
    // 처리포인트
    private String prcPoint;
    // 유효기간
    private String validPeriod;
    // 마켓포인트 구분(지급,차감)
    private String svmnType;
    // 포인트 구분(지급,차감)
    private String pointType;
    // 사유명
    private String reasonNm;
    // 마켓포인트 사용 가능 금액
    private String usePsbAmt;

    private String rownum;

    private String rowNum;

    private String classNm;
    private String className;
    private String gubun;
    @NotEmpty
    // 회원번호
    private Long memberNo;
    // 회원 아이디
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String loginId;
    // 회원 명
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String memberNm;
    private String memberGradeNm; // 멤버 등급 이름
    // 내용
    private String content;
    // 포인트 구분 명(지급,차감)
    private String pointTypeNm;
    // 마켓포인트 번호
    private long svmnSeq;
    // 마켓포인트 유형 코드(자동:A, 수동:M)
    private String svmnTypeCd;
    // 주문번호
    private String ordNo;
    // 결제금액
    private String paymentAmt;
    // 차감 구분 코드
    private String deductGbCd;

    // 총 마켓포인트
    private String totalSvmnPvd;
    private String totalSvmnUse;
    private String totalPointPvd;
    private String totalPointUse;
    /* 잔여적림금 모바일 추가 2016-09-01 */
    private String restPoint;
    // ERP 주문번호(ERP에서 몰마켓포인트 사용시) [ERP판매테이블 PK조합]
    private String erpOrdNo;
    
    //오프라인쿠폰
    private String couponNo;
    private String couponNm;
    private String couponBnfDcAmt;

    private String pointGbCd;
    private String curPoint;

    private String regDt;
}
