package net.danvi.dmall.biz.app.setup.delivery.model;

import lombok.Data;
import lombok.EqualsAndHashCode;
import dmall.framework.common.model.BaseModel;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 4. 29.
 * 작성자     : dong
 * 설명       : 택배사 VO
 * </pre>
 */
@Data
@EqualsAndHashCode
public class DeliveryConfigVO extends BaseModel<DeliveryConfigVO> {
    // 택배 사용 여부
    private String couriUseYn;
    // 작접 방문 사용 여부
    private String directVisitRecptYn;
    // 기타 사용 여부
    private String etcUseYn;
    // 기본 배송 유형 코드
    private String defaultDlvrcTypeCd;
    // 기본 배송비
    private String defaultDlvrc;
    // 기본 배송 최소 수량
    private String defaultDlvrMinAmt;
    // 기본 배송 최소 배송비
    private String defaultDlvrMinDlvrc;
    // 배송비 지불 유형 코드
    private String dlvrPaymentKindCd;
    // 행번호
    private int rownum;

}
