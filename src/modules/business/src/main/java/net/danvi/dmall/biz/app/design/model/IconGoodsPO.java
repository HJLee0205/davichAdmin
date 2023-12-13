package net.danvi.dmall.biz.app.design.model;

import dmall.framework.common.model.BaseModel;
import lombok.Data;
import lombok.EqualsAndHashCode;
import net.danvi.dmall.biz.system.validation.DeleteGroup;
import net.danvi.dmall.biz.system.validation.UpdateGroup;

import javax.validation.constraints.NotNull;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2023. 01. 17.
 * 작성자     : slims
 * 설명       : 아이콘관리 VO
 * </pre>
 */

@Data
@EqualsAndHashCode
public class IconGoodsPO extends BaseModel<IconGoodsPO> {
    // private String siteNo;
    @NotNull(groups = { UpdateGroup.class, DeleteGroup.class })
    private Long iconNo; // 배너 번호
    private String goodsNo; // 상품 번호
    // 등록자 번호
    private Long regrNo;
    // 사용자 번호
    private Long updrNo;
    // private String siteNo;


}
