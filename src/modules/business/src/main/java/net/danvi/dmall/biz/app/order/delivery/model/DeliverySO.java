package net.danvi.dmall.biz.app.order.delivery.model;

import lombok.Data;
import lombok.EqualsAndHashCode;
import dmall.framework.common.model.BaseSearchVO;

/**
 * Created by dong on 2016-05-02.
 */
@Data
@EqualsAndHashCode
public class DeliverySO extends BaseSearchVO<DeliverySO> {
    /** 검색시작일 */
    private String ordDayS;
    /** 검색 종료일 */
    private String ordDayE;
    /** 주문일/입금일 */
    private String dayTypeCd;
    /** 주문 상태 코드 */
    private String[] ordStatusCd;
    /** 판매채널 코드 */
    private String[] saleChannelCd;
    /** 검색어구분 */
    private String searchCd;
    /** 검색어 */
    private String searchWord;
    /** 판매자 */
    private String searchSeller;
}
