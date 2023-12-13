package net.danvi.dmall.biz.app.promotion.coupon.model;

import java.util.Date;
import java.util.List;

import org.apache.poi.ss.formula.functions.T;

import lombok.Data;
import lombok.EqualsAndHashCode;
import dmall.framework.common.model.BaseModel;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 5. 3.
 * 작성자     : 이헌철
 * 설명       :
 * </pre>
 */

@Data
@EqualsAndHashCode(callSuper = false)
public class CouponPO extends BaseModel<T> {
    private static final long serialVersionUID = -1;
    private List<CpTargetVO> couponTargetList; // 쿠폰대상리스트 : 상품 or 카테고리
    private int newCouponNo;
    private int couponNo;
    private int applySeq;
    private String couponKindCd; // 쿠폰 종류코드 : 01:상품쿠폰;02:상품쿠폰(모바일전용);03:생일자쿠폰;04:신규회원가입쿠폰;05:직접발급쿠폰;06:주문서쿠폰
    private String couponQttLimitCd; // 쿠폰발행수량 제한코드
    private int couponQttLimitCnt; // 쿠폰발행수량 제한 건수
    private String couponNm;
    private String couponDscrt;
    private String couponSoloUseYn; // 단독사용여부
    private String couponBnfCd; // 혜택 코드
    private int couponBnfValue; // 혜택 값(%)
    private int couponBnfDcAmt; // 혜택 최대 금액
    private String couponBnfTxt; // 콘택트렌즈 혜택 내용
    private int bnfDcAmt01; // %할인혜택일 경우 최대할인금액
    private int bnfDcAmt02; // 금액할인혜택일 경우 할인금액
    private String bnfDcAmt03; // 콘텍트전용 혜택 입력 내용
    private String couponDupltDwldPsbYn; // 중복다운로드 가능여부
    private String couponApplyPeriodCd; // 쿠폰 유효기간
    private String applyStartDttm;
    private String applyEndDttm;
    private int couponApplyIssueAfPeriod; // 쿠폰 발급일로부터 XX일까지 사용 가능
    private String couponApplyLimitCd; // 쿠폰적용예외코드 : 01. 전체상품 사용가능 02.특정상품/특정카테고리만 쿠폰사용가능 03.특정상품/특정카테고리만 쿠폰사용 불가능
    private String couponApplyTargetCd; // 쿠폰적용대상코드 : 01.상품 02.카테고리 03.상품+카테고리
    private String couponApplyScopeCd; // 쿠폰적용범위코드 : 01.상품쿠폰, 02.주문서쿠폰 구분
    private int couponUseLimitAmt; // 쿠폰을 사용하려면 구매해야하는 최소한의 금액
    private String couponUseYn;
    private String useYn;
    private String goodsNo;
    private String[] goodsNoArr;
    private String[] applyGoodsNoArr; // 적용상품
    private String[] exceptGoodsNoArr; // 예외상품
    private int ctgNo;
    private int[] ctgNoArr; // 카테고리번호 배열
    private int[] applyCtgNoArr; // 적용카테고리번호 배열
    private int[] exceptCtgNoArr; // 예외카테고리번호 배열

    /** 시스템 삭제 여부 */
    private String delYn;

    /** 시스템 삭제자 번호 */
    private Long delrNo;

    /** 시스템 삭제 일시 */
    private Date delDttm;

    /* 쿠폰발행 대상 */
    private long memberNo;
    private long[] memberNoArr; // 회원번호 배열
    private String issueTarget; // 쿠폰발행대상 : 01.전체회원 02.그룹회원 03.개별회원
    private int memberGradeNo; // 회원등급번호 : 그룹별 발급일 경우에 필요

    /* 쿠폰 사용 등록 관련 */
    private int memberCpNo; // 회원쿠폰번호
    private long ordNo;// 주문번호
    private long ordDtlSeq;// 주문상세순번
    private long cpUseAmt;// 쿠폰 사용금액
    private String cpKindCd;// 쿠폰 종류코드(01:상품,02:주문서)
    private Date useDttm; // 쿠폰 사용 날짜

    /* 쿠폰등록 수정 시 날짜 붙이기 */
    private String from; // 시작 일
    private String fromHour; // 시작 시
    private String fromMinute; // 시작 분
    private String to; // 종료 일
    private String toHoure; // 종료 시
    private String toMinute; // 종료 분;
    private String orderCancelYn; // 주문취소

    private int cpLoadrate; //본사부담율
    private String rsvOnlyYn; //예약전용여부
    // 오프라인 쿠폰 번호
    private String cpIssueNo;
    private String offlineOnlyYn; //오프라인전용여부

    private String [] cpIssueNoArr;
    
    private String ageCd;	//쿠폰 연령대
    private String goodsTypeCd;	//쿠폰 제품유형

    private int couponApplyConfirmAfPeriod; // 구매확정일로부터 XX일까지 사용 가능
    private String drtCpIssuYn; // 쿠폰 직접 발급 여부



}
