package net.danvi.dmall.biz.app.main.model;

import lombok.Data;

import java.io.Serializable;

/**
 * Created by dong on 2016-07-20.
 */
@Data
public class MallOperStatusVO implements Serializable {
    private String dayOfWeek;
    // 상품 분류
    private String goodsTypeNm;
    // 매출액
    private int salesAmt;
    private int salesAmt2;
    // 결제완료
    private int paymentCmplt;
    // 배송준비
    private int dlvrReady;
    // 배송중
    private int dlvrStart;
    // 배송완료
    private int dlvrCmplt;
    // 구매확정
    private int buyCmplt;
    // 취소
    private int ordCancel;
    // 교환
    private int ordExchange;
    // 환불
    private int ordRefund;
    // 상품 후기
    private int goodsReview;
    // 상품 예약
    private int goodsRsv;
    // 방문 예약
    private int visitRsv;

    /* 모바일용 추가 시작 */
    private int payClaimCnt; //취소
    private int exchnClaimCnt; //교환
    private int returnClaimCnt; //환불
    /* 모바일용 추가 끝 */
    private int claimCnt; //취소+교환+환불
    private int reviewCnt;

    private int ordCnt; // 모든 주문
    private int rsvCnt; // 모든 예약
    private int visitCnt; // 방문자 수
}
