package net.danvi.dmall.biz.app.order.manage.model;

import java.util.List;

import lombok.Data;
import lombok.EqualsAndHashCode;
import net.danvi.dmall.biz.app.order.delivery.model.DeliveryVO;
import net.danvi.dmall.biz.app.order.payment.model.OrderPayVO;
import dmall.framework.common.model.BaseModel;
import net.danvi.dmall.biz.app.promotion.event.model.EventVO;
import net.danvi.dmall.biz.app.promotion.exhibition.model.ExhibitionVO;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 5. 2.
 * 작성자     : dong
 * 설명       : 주문정보 취합(조회결과)
 * </pre>
 */
@Data
@EqualsAndHashCode
public class OrderVO extends BaseModel<OrderVO> {

    /*
     * BaseModel 생성
     * private Long companyNo;
     * private Long siteNo;
     * private Long regrNo;
     * private String regrNm;
     */

    private long ordNo; // 주문번호
    private OrderInfoVO orderInfoVO;// 주문정보
    private List<OrderGoodsVO> orderGoodsVO;// 상품정보
    private List<OrderPayVO> orderPayVO;// 결제정보
    private List<OrderPayVO> orderPayFailVO;// 결제실패정보
    private List<DeliveryVO> deliveryVOList; // 배송정보
    private List<OrderGoodsVO> ordHistVOList; // 처리 로그 정보
    private List<ClaimGoodsVO> ordClaimList; // 클레임 이력
    private List<OrderGoodsVO> ordAddedAmountList; // 부가비용 목록
    private ExhibitionVO promotionVo;  // 프로모션
    private EventVO eventVo;           // 이벤트

    private String receiveDepositCount; //입금대기
    private String receiveOrderCount;// 주문접수
    private String prepareOrderCount;;// 상품준비중
    private String deliveryOrderCount;// 배송중
    private String completeOrderCount;// 배송완료
    private String statusOrderCount;// 선택한 상태의 주문건수

    /* front 배열 처리 파라메터 */
    private String goodsNo;// 상품번호
    private String[] goodsNoArr;// 상품번호 배열
    private String[] itemArr; // 아이템 배열(상품번호+아이템정보+추가옵션정보)
    private String[] itemNoArr;// 아이템 번호 배열
    private String[] itemPriceArr;// 아이템 가격 배열
    private int[] buyQttArr;// 아이템 구매 수량
    private long[] addOptNoArr;// 추가옵션 번호
    private long[] addOptDtlSeqArr;// 추가옵션 상세 번호
    private long[] addOptVerArr;// 추가옵션 버전
    private long[] addOptAmtArr;// 추가 옵션 금액
    private String[] addOptAmtChgCdArr;// 추가 옵션 가/감 코드(1:+, 2:-)
    private int[] addOptBuyQttArr;// 추가옵션 구매 수량
    private long totalPrice; // 총 금액

    /* 관리자 수기 주문 관련 */
    private String adminOrdYn;
    
    /** 20160824 모바일 추가 */
    private String cancleOrderCount;//주문취소
    private String exchangeOrderCount;//교환완료
    private String returnOrderCount;//반품완료
    /**  //20160824 모바일 추가 */

    /* 주문상세/장바구니 구분 (goods/basket)*/
    private String npayPageCode;
    
    /* 기획전구분 */
    private String exhibitionYn;
    
    /* 비전체크 */
    private String visionChk;
    
    /* 예약전용여부 */
    private String rsvOnlyYn;
    
    /*방문예약 보청기 체크*/
    private String isHa;
    
    //증정쿠폰 여부
    private String preGoodsYn;
    // 스템프적립
    private String stampYn;
    //증정쿠폰 발행 가능 여부
    private String preAvailableYn;

    private String memberYn;
    private String nomobile;
    private String nomemberNm;
    private String teanseonMiniYn;
    private String ch; // 유입 채널 코드
    private String storeNm;
    private String storeCode;

    private String vegemilYn;
    private String eyeluvYn;


    private String trevuesYn;
    private String teanseanSampleYn;
    private String teanseonNewYn;

    //방문예약
    private String rsvNo;
    private String storeNo;
//    private String storeNm;위
    private String rsvDate;
    private String rsvTime;
    private String visitPurposeNm;
}

