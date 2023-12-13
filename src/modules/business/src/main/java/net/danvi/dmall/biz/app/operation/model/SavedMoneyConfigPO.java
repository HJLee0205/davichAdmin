package net.danvi.dmall.biz.app.operation.model;

import org.hibernate.validator.constraints.NotEmpty;

import lombok.Data;
import lombok.EqualsAndHashCode;
import net.danvi.dmall.biz.system.validation.UpdateGroup;
import dmall.framework.common.model.BaseModel;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 4. 29.
 * 작성자     : user
 * 설명       :
 * </pre>
 */
@Data
@EqualsAndHashCode
public class SavedMoneyConfigPO extends BaseModel<SavedMoneyConfigPO> {

    // 마켓포인트 지급 여부
    @NotEmpty(groups = { UpdateGroup.class })
    private String svmnPvdYn;
    // 마켓포인트 지급 기준 코드
    private String svmnPvdStndrdCd;
    // 마켓포인트 지급 율
    private String svmnPvdRate;
    // 마켓포인트 지급 율 (추천인)
    private String recomPvdRate;
    // 마켓포인트 절사 기준 코드
    private String svmnTruncStndrdCd;
    // 마켓포인트 사용 상품 총 금액 (사용안함)
    private String svmnUseGoodsTotalAmt;
    // 마켓포인트 사용 가능 보유 금액
    private String svmnUsePsbPossAmt;
    // 마켓포인트 최소 사용 금액
    private String svmnMinUseAmt;
    // 마켓포인트 최대 사용 금액
    private String svmnMaxUseAmt;
    // 마켓포인트 최대 사용 구분 코드
    private String svmnMaxUseGbCd;
    // 마켓포인트 사용 단위 코드
    private String svmnUseUnitCd;
    // 마켓포인트 쿠폰 중복 적용 여부
    private String svmnCpDupltApplyYn;
    // 적림금 자동 소멸 여부
    private String svmnAutoExtinctionYn;
    // 마켓포인트 사용 기한
    private String svmnUseLimitday;
    // 포인트 사용 여부
    private String pointPvdYn;
    // 포인트 적립 유효 기간
    private String pointAccuValidPeriod;
    // 포인트 절사 기준 코드
    private String pointTruncStndrdCd;
    // 구매 후기 작성 포인트
    private String buyEplgWritePoint;

    // 이하 삭제 대상
    private String pointAccuMethodCd;
    private String pointAccuRate;
    private String pointAccuAmt;
    private String pointAccuAmtEachPoint;
    private String buyEplgPointYn;

}
