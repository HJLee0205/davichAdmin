package net.danvi.dmall.biz.app.promotion.coupon.model;

import dmall.framework.common.annotation.Encrypt;
import dmall.framework.common.util.CryptoUtil;
import lombok.Data;
import lombok.EqualsAndHashCode;
import dmall.framework.common.model.BaseModel;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 5. 3.
 * 작성자     : 이헌철
 * 설명       : 쿠폰대상VO
 * </pre>
 */
@Data
@EqualsAndHashCode(callSuper = false)
public class CpTargetVO extends BaseModel<CpTargetVO> {
    private int couponNo;
    private int applySeq;

    // 쿠폰대상 카테고리
    private int ctgNo;
    private String ctgNm;

    // 쿠폰대상 상품
    private String rownum;
    private String goodsNo;
    private String goodsNm; // 쿠폰대상 상품이름
    private String imgPath; // 쿠폰대상 상품이미지경로
    private String sellerNm;
    private String salePrice;
    private String supplyPrice;
    private String stockQtt;
    private String goodsSaleStatusNm;
    private String couponApplyLimitCd; // 쿠폰적용예외코드 : // 01. 전체상품 사용가능 02.특정상품/특정카테고리만 쿠폰사용가능 03.특정상품/특정카테고리만 쿠폰사용 불가능

    // 쿠폰 발급 대상 조회
    private int totalCnt; // 회원 전체 수
    private int gradeCnt; // 각 회원등급별 회원수
    private int memberGradeNo; // 회원등급번호
    private String memberGradeNm; // 회원등급이름
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String loginId; // 로그인아이디
    private String memberNm;
    private long memberNo;
}
