package net.danvi.dmall.biz.ifapi.mem.dto;

import lombok.Data;

@Data
public class AdminPointConfigVO{
    // (일반) 구매 후기 별 포인트
    private String buyEplgWritePoint;
    // (프리미엄) 구매 후기 별 포인트
    private String buyEplgWritePmPoint;
    // 회원가입 포인트
    private String firstSignupPoint;
    // 포인트 적립가능한 상품군들
    private String pointPvdGoodsTypeCds;
    //최소 보유 포인트일때
    private String svmnUsePsbPossAmt;
    //적립금 최소 사용 금액
    private String svmnMinUseAmt;
    //적립금 최대 사용 율,금액 코드 1,2
    private String svmnMaxUseGbCd;
    //적립금 최대 사용 율,금액
    private String svmnMaxUseAmt;
    //적립금 사용 단위 코드
    private String svmnUseUnitCd;
    //적립금 사용 기한(월)
    private String svmnUseLimitday;
    //적립금 쿠폰 중복 적용 여부YN
    private String svmnCpDupltApplyYn;
    //적립금 사용 단위 코드 이름
    private String svmnUseUnitNm;
    //회원가입시 쿠폰 증정 여부
    private String firstSignupCouponYn;

    //기본배송 상품일경우
    private String couriUseYn;//배송 방법 택배
    private String directVisitRecptYn;//배송방법 매장픽업
    private String defaultDlvrcTypeCd;//1-무료 2-유료 3-주문합계
    private String defaultDlvrc;//기본 배송비
    private String defaultDlvrMinAmt;//주문상품합계 금액의 얼마미만일경우
    private String defaultDlvrMinDlvrc;//금액 부과
    private String dlvrPaymentKindCd;//배송결제방식 1선불,2착불,3선불+착불,4직접매장픽업
}
