package net.danvi.dmall.biz.app.operation.model;

import lombok.Data;
import lombok.EqualsAndHashCode;
import dmall.framework.common.model.BaseModel;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 4. 29.
 * 작성자     : dong
 * 설명       : 택배사 VO
 * </pre>
 */
@Data
@EqualsAndHashCode
public class SavedMoneyConfigVO extends BaseModel<SavedMoneyConfigVO> {
    // 마켓포인트 지급 여부
    private String svmnPvdYn;
    // 마켓포인트 지급 기준 코드
    private String svmnPvdStndrdCd;
    // 마켓포인트 지금 율
    private String svmnPvdRate;
    // 마켓포인트 절사 기준 코드
    private String svmnTruncStndrdCd;
    // 마켓포인트 사용 상품 총 금액
    private String svmnUseGoodsTotalAmt;
    // 마켓포인트 사용 가능 보유 금액
    private String svmnUsePsbPossAmt;
    // 마켓포인트 최소 사용 금액
    private String svmnMinUseAmt;
    // 마켓포인트 최대 사용 금액
    private String svmnMaxUseAmt;
    // 마켓포인트 최대 사용 구붙 코드 
    private String svmnMaxUseGbCd;
    // 적림금 사용 단위 코드
    private String svmnUseUnitCd;
    // 적림금 쿠폰 중복 적용 여부
    private String svmnCpDupltApplyYn;
    // 적림금 자동 소멸 여부
    private String svmnAutoExtinctionYn;
    // 마켓포인트 사용 기한
    private String svmnUseLimitday;
    // 마켓포인트 (추천인)
    private String recomPvdRate;
    
    // 포인트 사용 여부
    private String pointPvdYn;
    // 포인트 적립 유효 기간
    private String pointAccuValidPeriod;
    // 포인트 절사 기준 코드
    private String pointTruncStndrdCd;
    // 구매후기 작성 포인트
    private String buyEplgWritePoint;

    private String pointAccuMethodCd;
    private String pointAccuRate;
    private String pointAccuAmt;
    private String pointAccuAmtEachPoint;
    private String buyEplgPointYn;

}
