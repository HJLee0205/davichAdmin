package net.danvi.dmall.biz.app.promotion.coupon.model;

import java.util.List;

import lombok.Data;
import lombok.EqualsAndHashCode;
import dmall.framework.common.annotation.Encrypt;
import dmall.framework.common.model.BaseSearchVO;
import dmall.framework.common.util.CryptoUtil;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 5. 3.
 * 작성자     : 이헌철
 * 설명       :
 * </pre>
 */
@Data
@EqualsAndHashCode
public class CouponSO extends BaseSearchVO<CouponSO> {

    // admin
    private String couponKindCd; // 쿠폰 종류 : 01:상품쿠폰;02:상품쿠폰(모바일전용);03:생일자쿠폰;04:신규회원가입쿠폰;05:직접발급쿠폰
    private String[] couponKindCds;
    private String searchStartDate; // 검색시작일
    private String searchEndDate; // 검색종료일
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String searchWords; // 암호화 한 검색어. 회원이름은 암호화 되어있음.
    private String searchWordsNoChiper; // 암호화 안한 검색어. 회원아이디는 암호화 되어있지 않음. 쿠폰명(쿠폰목록조회).
    private String searchKind; // 검색어 종류 : 발급사용내역조회
    private String couponDupltDwldPsbYn; // 중복다운로드 가능여부
    private String goodsNo; // goodsController에서 사용
    private long ctgNo;
    private int couponNo; // 단건조회
    private String couponApplyLimitCd; // 01. 전체상품 02.특정상품/특정카테고리 쿠폰사용가능 03.특정상품/특정카테고리만 쿠폰사용 불가능
    private int pageNoOri; // 페이지번호 오리지널( 목록에서 다른 view로 넘어가기 전, 페이지번호)

    // front
    private String couponCtgNoArr;// 사용가능 쿠폰 조회용
    private long memberNo;
    private List<CouponSO> couopnGoodsInfoList;
    private String couponApplyTargetCd; // 01.상품 02.카테고리 03.상품+카테고리
    private String useYn;
    private String issueTarget;
    // 오프라인 쿠폰 번호
    private String cpIssueNo;
    
    // 쿠폰존 검색조건
    private String couponOnlineYn;
    private String goodsTypeCd;
    private String ageCd;
    private String downloadAll; //쿠폰 전체받기
    private String ageRange;
    
    private String drtCpIssuYn; // 쿠폰 직접 발급 여부
    private String drtCpNo; // 직접 발급 쿠폰 번호
}

