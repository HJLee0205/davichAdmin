package net.danvi.dmall.biz.app.goods.model;

import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 5. 2.
 * 작성자     : kwt
 * 설명       : 추가 옵션 상세 항목 취득용 Value Object
 * </pre>
 */
@Data
@EqualsAndHashCode
public class GoodsAddOptionDtlVO {
    // 상품번호
    private String goodsNo;
    // 추가 옵션 번호
    private long addOptNo;
    // 추가 옵션 명
    private String addOptNm;
    // 추가 옵션 상세 순번
    private long addOptDtlSeq;
    // 추가 옵션 금액 증감 코드 (1:가액(+), 2:감액(-))
    private String addOptAmtChgCd;
    // 추가 옵션 값
    private String addOptValue;
    // 추가 옵션 금액
    private String addOptAmt;
    // 추가 옵션 버젼
    private String optVer;
    // 추가옵션 등록, 수정 구분 (I:신규등록, U:수정항목)
    private String registFlag;
    // 주문 관련 추가 옵션 구매 수량
    private int addOptBuyQtt;

}
