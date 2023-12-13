package net.danvi.dmall.biz.app.order.deposit.model;

import lombok.Data;
import lombok.EqualsAndHashCode;
import dmall.framework.common.model.BaseSearchVO;

/**
 * Created by dong on 2016-05-02.
 */
@Data
@EqualsAndHashCode
public class DepositSO extends BaseSearchVO<DepositSO> {
    /** 결제시작일 */
    private String searchDayS;
    /** 결제 종료일 */
    private String searchDayE;
    /** 주문 상태 */
    private String[] ordStatusCd;
    /** 검색어구분 */
    private String searchCd;
    /** 검색어 */
    private String searchWord;
    /** 결제 방법 코드 */
    private String paymentWayCd;
}
