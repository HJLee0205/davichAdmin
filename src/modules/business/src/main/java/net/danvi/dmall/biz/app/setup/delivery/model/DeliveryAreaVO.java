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
public class DeliveryAreaVO extends BaseModel<DeliveryAreaVO> {

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
    // 행번호
    private int rownum;
    //판매자 번호
    private  long sellerNo;

}
