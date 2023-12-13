package net.danvi.dmall.biz.app.member.level.model;

import java.util.List;

import org.hibernate.validator.constraints.NotEmpty;

import lombok.Data;
import lombok.EqualsAndHashCode;
import dmall.framework.common.model.BaseModel;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 5. 3.
 * 작성자     : kjw
 * 설명       : 회원 정보 관리 Value Object 클래스
 * </pre>
 */
@Data
@EqualsAndHashCode
public class MemberLevelVO extends BaseModel<MemberLevelVO> {
    // 회원등급 명
    private String memberGradeNm;
    // 회원등급 표시 방법
    private String gradeDispMethod;
    // 총 구매 금액
    private String totBuyAmt;
    // 총 포인트
    private String totPoint;
    // 총 구매 건수
    private String totBuyCnt;
    // 할인 사용여부
    private String dcUseYn;
    // 회원등급 관리 코드
    private String memberGradeManageCd;
    // 할인 단위 코드
    private String dcUnitCd;
    // 할인 값
    private String dcValue;
    // 마켓포인트 단위 코드
    private String svmnUnitCd;
    // 마켓포인트 값
    private String svmnValue;
    // 삭제 여부
    private String delYn;
    // 회원 통계(소속된 회원 분포)
    private String memStatistic;
    // 회원등급에 속한 회원 수
    private String memCnt;
    // 회원등급 산정 자동 여부명(자동,수동)
    private String autoYnNm;
    // 회원등급 자동 산정 여부
    private String autoYn;
    // 회원등급 생성 일시
    private String makeDttm;
    // 회원등급 자동산정 기준 주기
    private String gradeStndrdCycle;
    // 회원등급 자동산정 날짜
    private String gradeStndrdDate;
    // 회원등급 자동산정 산출 기간
    private String gradeCcltPeriod;
    // 회원등급 레벨(1~10, 1이 최하위)
    private String memberGradeLvl;
    // 회원등급 플래그(insert, update 구분)
    private String flag;

    @NotEmpty
    // 회원등급 번호
    private String memberGradeNo;
    // 회원등급 혜택 번호
    private String memberGradeBnfNo;
    // 회원등급 혜택 표출
    private String dcUnitCdText;
    private String dcCndtAmtText;
    private String dcValueText;
    private String accumCndtValueText;
    private String svmnValueText;

    private String useYn;
    private String chk;
    List<MemberLevelVO> memGradeBenefitList;

    private String firstSignupPoint;
    private String pointPvdGoodsTypeCds;
    private String firstSignupCouponYn;
}
