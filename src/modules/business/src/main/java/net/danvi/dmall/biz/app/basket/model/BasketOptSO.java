package net.danvi.dmall.biz.app.basket.model;

import lombok.Data;
import lombok.EqualsAndHashCode;
import dmall.framework.common.model.BaseSearchVO;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 5. 2.
 * 작성자     : dong
 * 설명       : 장바구니 추가 옵션 value object
 * </pre>
 */
@Data
@EqualsAndHashCode
public class BasketOptSO extends BaseSearchVO<BasketOptSO> {
    private String goodsNo; // 상품 번호
    private long basketAddOptNo; // 장바구니 추가옵션번호
    private long basketNo; // 장바구니번호
    private long optNo; // 옵션번호
    private long optDtlSeq; // 옵션상세순번
    private int optVer; // 옵션버전
    private int optBuyQtt;// 추가옵션 구매 수량

    private long addOptNo; // 추가 옵션번호
    private long addOptDtlSeq; // 추가 옵션상세순번

}
