
package net.danvi.dmall.biz.app.promotion.coupon.model;

import java.util.Date;
import java.util.List;

import org.apache.poi.ss.formula.functions.T;

import com.fasterxml.jackson.annotation.JsonFormat;

import lombok.Data;
import lombok.EqualsAndHashCode;
import dmall.framework.common.annotation.Encrypt;
import dmall.framework.common.constants.CommonConstants;
import dmall.framework.common.model.BaseModel;
import dmall.framework.common.util.CryptoUtil;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 5. 3.
 * 작성자     : 이헌철
 * 설명       : 쿠폰 VO
 * </pre>
 */

@Data
@EqualsAndHashCode(callSuper = false)
public class CouponVO extends BaseModel<T> {
    private static final long serialVersionUID = -1;
    private List<CpTargetVO> couponTargetGoodsList; // 쿠폰대상 상품리스트
    private List<CpTargetVO> couponTargetCtgList; // 쿠폰대상 카테고리리스트
    private int couponNo;
    private String couponKindCd; // 쿠폰종류코드 : 01:상품쿠폰;02:상품쿠폰(모바일전용);03:생일자쿠폰;04:신규회원가입쿠폰;05:직접발급쿠폰
    private String couponKindCdNm; // 쿠폰종류코드명
    private String couponQttLimitCd; // 쿠폰수량 제한코드 01.무제한 02. 수량제한
    private int couponQttLimitCnt; // 쿠폰 발급가능수량
    private String couponNm;
    private String couponDscrt;
    private String couponSoloUseYn; // 쿠폰단독사용
    private String couponBnfCd; // 쿠폰혜택코드 : 01.%할인, 지정한 상한금액까지 02.지정금액할인
    private int couponBnfValue; // 쿠폰 할인률
    private int couponBnfDcAmt; // 쿠폰 할인금액
    private String couponBnfTxt; // 콘택트렌즈 혜택 내용
    private String couponApplyTargetCd; // 쿠폰적용대상코드 : 01.상품 02.카테고리 03.상품+카테고리
    private String couponApplyPeriodCd; // 적용기간코드 : 01.시작일시 종료일시 02. 발급일로부터 몇일
    private String applyStartDttm;
    private String applyEndDttm;
    private int couponApplyIssueAfPeriod; // 쿠폰발급일로부터 몇일
    private String couponApplyScopeCd; // 2016.09.05현재 미사용. 쿠폰적용범위코드 : 01.상품쿠폰 02.주문서쿠폰
    private String couponApplyLimitCd; // 쿠폰적용예외코드 : 01. 전체상품 02.특정상품/특정카테고리 쿠폰사용가능 03.특정상품/특정카테고리만 쿠폰사용 불가능
    private int couponUseLimitAmt; // 쿠폰사용제한금액 : 쿠폰사용하려면 구입해야하는 최소한의 금액
    private String couponUseYn; // 사용여부
    private String goodsNo;
    private int memberCpNo; // 회원쿠폰번호 : 주문쪽에서 사용
    private int rownum;
    private int issueCnt; // 쿠폰발급 수
    private int useCnt; // 쿠폰사용 수
    private String[] couponKindCds; // 쿠폰종류코드 : 01:상품쿠폰;02:상품쿠폰(모바일전용);03:생일자쿠폰;04:신규회원가입쿠폰;05:직접발급쿠폰
    @JsonFormat(pattern = CommonConstants.DATE_YYYYMMDDHHMMSS, timezone = CommonConstants.DATE_TIMEZONE, locale = CommonConstants.DATE_LOCALE)
    private Date regDttm;
    private String couponDupltDwldPsbYn; // 중복다운로드 가능여부
    private String issueYn; // 쿠폰발급여부

    /** 시스템 삭제 여부 */
    private String delYn;

    /** 시스템 삭제자 번호 */
    private Long delrNo;

    /** 시스템 삭제 일시 */
    private Date delDttm;

    // 쿠폰 발급/사용내역
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String loginId; // 로그인아이디
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String memberNm;
    private long memberNo;
    private String ordNo; // 주문번호
    private String ordDtlSeq; // 주문번호 상세
    private String imgPath; // 주문한 상품이미지 경로
    private String goodsNm; // 주문한 상품이름
    private long cpUseAmt; // 주문시 쿠폰으로 할인받은 금액
    private String couponBnfAmt; // 쿠폰최대혜택금액
    private String useDttm; // 쿠폰사용일시
    private String couponStatus; // 쿠폰상태 : 사용함, 사용안함, 소멸
    private String useYn; // 쿠폰사용여부

    // 엑셀다운로드
    private String couponApplyPeriodExcel; // 엑셀다운로드용 : 쿠폰적용기간
    private String couponBnfExcel; // 엑셀다운로드용 : 쿠폰혜택
    private String issueUseCntExcel; // 엑셀다운로드용 : 발급사용 수
    private String couponUseLimitAmtExcel; // 엑셀다운로드용 : 쿠폰사용제한금액
    private String regDttmExcel; // 엑셀다운로드용 : 생성일시
    
    private int cpLoadrate; //본사부담율
    private String rsvOnlyYn; //예약전용여부
    // 오프라인 쿠폰 번호
    private String cpIssueNo;
    private String cpApplyEndDttm;
    private String offlineOnlyYn; //오프라인 전용여부
    
    private String goodsTypeCd;
    private String goodsTypeCdNm;
    private String ageCd;
    private String ageCdNm;

    private int couponApplyConfirmAfPeriod; // 구매확정일로부터 XX일까지 사용 가능

    private List<CouponVO> couponTypeArr;

    private String couponOnlineYn;
    private String downloadAll; //쿠폰 전체받기
    private String ageRange;
    private String couponAvlNo;
}
