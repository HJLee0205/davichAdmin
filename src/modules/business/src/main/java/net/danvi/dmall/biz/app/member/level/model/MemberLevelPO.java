package net.danvi.dmall.biz.app.member.level.model;

import lombok.Data;
import lombok.EqualsAndHashCode;
import net.danvi.dmall.biz.system.validation.DeleteGroup;
import dmall.framework.common.model.BaseModel;

import javax.validation.constraints.NotNull;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 5. 3.
 * 작성자     : kjw
 * 설명       : 회원 정보 등록, 수정, 삭제 관련 Value Object 클래스
 * </pre>
 */
@Data
@EqualsAndHashCode(callSuper = false)
public class MemberLevelPO extends BaseModel<MemberLevelPO> {
    // 회원등급 자동산정 코드
    private String gradeManageCd;
    // 회원등급 자동산정 기준 주기
    private String gradeStndrdCycle;
    // 회원등급 자동산정 날짜
    private String gradeStndrdDate;
    // 회원등급 자동산정 산출 기간
    private String gradeCcltPeriod;
    // 회원 등급 관리 코드(10:마켓포인트&구매횟수, 20:포인트)
    private String memberGradeManageCd;
    // 회원 등급 명
    private String memberGradeNm;
    // 총 구매 금액
    private String totBuyAmt;
    // 총 구매 건수
    private String totBuyCnt;
    // 총 포인트
    private String totPoint;
    // 회원 등급 레벨
    private String memberGradeLvl;
    // 회원 등급 자동 산정 여부
    private String autoYn;
    // 회원 등급 삭제 여부
    private String delYn;

    // 삭제 회원 등급 번호
    @NotNull(groups = { DeleteGroup.class })
    private String[] delMemGradeNo;

    // 회원 등급 번호
    private String memberGradeNo;

    // 회원 등급 혜택
    private Long memberGradeBnfNo;
    private String useYn;

    private String dcUnitCd;
    private String dcValue;

    private String svmnUnitCd;
    private String svmnValue;

    private String[] arrMemberGradeNo;
    private String[] arrDcUnitCd;
    private String[] arrDcValue;
    private String[] arrSvmnUnitCd;
    private String[] arrSvmnValue;
    private String[] arrChk;

    // 등급 산정 조건
    private String rearrangeWhere;

    private long firstSignupPoint;
    private String pointPvdGoodsTypeCds;
    private String[] pointPvdGoodsTypeCdsArr;
    private String firstSignupCouponYn;
}
