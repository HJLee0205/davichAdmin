package net.danvi.dmall.biz.app.setup.delivery.model;

import lombok.Data;
import lombok.EqualsAndHashCode;
import dmall.framework.common.model.BaseModel;

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
public class DeliveryAreaPO extends BaseModel<DeliveryAreaPO> {
    // 지역 배송비 세트 번호
    private String areaDlvrSetNo;
    // 우편 번호
    private String postNo;
    // 배송비
    private String dlvrc;
    // 주소
    private String numAddr;
    // 도로명 주소
    private String roadnmAddr;
    // 지역 명
    private String areaNm;

    //판매자 번호
    private long sellerNo;
}
