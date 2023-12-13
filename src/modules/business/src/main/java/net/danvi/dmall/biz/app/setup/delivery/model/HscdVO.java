package net.danvi.dmall.biz.app.setup.delivery.model;

import lombok.Data;
import lombok.EqualsAndHashCode;
import dmall.framework.common.model.BaseModel;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 8. 19.
 * 작성자     : dong
 * 설명       : HS코드 VO
 * </pre>
 */
@Data
@EqualsAndHashCode
public class HscdVO extends BaseModel<HscdVO> {
    // HS코드 순번
    private String hscdSeq;
    // HS코드
    private String hscd;
    // 항목
    private String item;
    // 페이징no
    private int rownum;
}
