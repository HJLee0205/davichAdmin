package net.danvi.dmall.biz.app.goods.model;

import dmall.framework.common.annotation.Encrypt;
import dmall.framework.common.util.CryptoUtil;
import lombok.Data;
import lombok.EqualsAndHashCode;
import dmall.framework.common.constraint.NullOrLength;
import dmall.framework.common.model.BaseSearchVO;

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
public class RestockNotifySO extends BaseSearchVO<RestockNotifySO> {

    // 검색 카테고리1
    @NullOrLength(min = 1, max = 3)
    private String searchCtg1;
    // 검색 카테고리2
    private String searchCtg2;
    // 검색 카테고리3
    private String searchCtg3;
    // 검색 카테고리4
    private String searchCtg4;
    // 검색 카테고리
    private String searchCtg;
    // 검색 일자 유형
    private String searchDateType;
    // 검색 일자 시작일
    private String searchDateFrom;
    // 검색 일자 종료일
    private String searchDateTo;
    // 회원 번호
    private Long memberNo;
    // 상품 상태
    private String[] goodsStatus;
    // 알림 여부
    private String[] notifyYn;
    // 검색어 유형
    private String searchType;
    // 검색어
    private String searchWord;
    // 검색어
    private String searchCode;
    // 검색어 (암호화)
    @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
    private String searchWordEncrypt;

}
