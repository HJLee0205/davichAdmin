package net.danvi.dmall.biz.app.order.manage.model;

import java.util.List;
import java.util.Map;

import lombok.Data;
import lombok.EqualsAndHashCode;
import net.danvi.dmall.biz.app.basket.model.BasketVO;
import dmall.framework.common.model.BaseModel;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 5. 2.
 * 작성자     : dong
 * 설명       : 수기주문 장바구니 데이터
 * </pre>
 */
@Data
@EqualsAndHashCode
public class AdminOrderVO extends BaseModel<OrderVO> {

    /*
     * BaseModel 생성
     * private Long companyNo;
     * private Long siteNo;
     * private Long regrNo;
     * private String regrNm;
     */
    // 배송비 맵의 String 값
    private String dlvrPriceMapStr;
    // 배송비 맵
    private Map dlvrPriceMap;
    // 배송비 컬럼 로우
    private Map dlvrCountMap;
    // 장바구니 리스트
    private List<BasketVO> basketList;
    // 장바구니 리스트의 Json 스트링
    private String basketListJson;
    // 장바구니 크기
    private int basketSize;
    // 총 결제 금액
    private long totalsOrdPrice;
    // 할인 금액
    private long totalsDcAmt;
    private long totalsPrice;
}
