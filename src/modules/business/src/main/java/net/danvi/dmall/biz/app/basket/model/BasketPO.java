package net.danvi.dmall.biz.app.basket.model;

import java.util.List;

import lombok.Data;
import lombok.EqualsAndHashCode;
import dmall.framework.common.model.BaseModel;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 5. 2.
 * 작성자     : dong
 * 설명       :
 * </pre>
 */
@Data
@EqualsAndHashCode
public class BasketPO extends BaseModel<BasketPO> {

    /* 장바구니 */
    private Integer basketNo; // 장바구니 번호
    private long memberNo; // 회원번호
    private int buyQtt; // 구매수량
    private String sessionId; // 세션 아이디
    private String goodsNo; // 상품번호
    private String[] goodsNoArr;
    private String goodsNm; // 상품번호
    private String itemNo; // 단품번호
    private long itemVer; // 단품 버전
    private long attrVer; // 단품 버전
    private String dlvrcPaymentCd; // 배송비 결제 코드
    private String ordMediaCd; // 주문매체코드(01:PC, 02:MOBILE)

    private int[] buyQttArr; // 상품수량 배열
    private String[] itemNoArr; // 단품번호 배열

    /* 장바구니 추가 옵션 */
    private long basketAddOptNo;
    private long[] addOptNoArr;// 추가옵션 번호 배열
    private long[] addOptDtlSeqArr;// 추가옵션상세 순번 배열
    private int[] addOptVerArr; // 추가 옵션 버전 배열
    private int[] addOptBuyQttArr;// 추가 옵션 구매수량 배열
    private int[] addOptAmtArr;// 추가 옵션 구매수량 배열
    private int[] basketAddOptNoArr;// 추가 옵션 구매수량 배열

    List<BasketOptPO> basketOptList; // 장바구니추가옵션

    private String[] noBuyQttArr; // 장바구니 등록/수정인지 확인
    private String[] addNoBuyQttArr; // 장바구니 추가옵션 등록/수정인지 확인

    private String delChkYn;
    private String delItemYn;
    private String oldItemNo;
    private long[] delAddOptNo;
    private long[] delAddOptDtlSeq;
    private long[] delBasketAddOptNo;
    private int sessionIndex;

    private String itemVerChk;
    private String attrVerChk;

    private long[] delBasketNoArr;

    private String directMove; // 장바구니 바로이동
    private String allDeleteFlag;
    private String adultFlag;

    // 대표 카테고리 여부
    private String ctgNo;
}
