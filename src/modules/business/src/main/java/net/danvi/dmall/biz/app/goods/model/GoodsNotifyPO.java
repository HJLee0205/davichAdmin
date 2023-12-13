package net.danvi.dmall.biz.app.goods.model;

import org.hibernate.validator.constraints.NotEmpty;

import lombok.Data;
import lombok.EqualsAndHashCode;
import net.danvi.dmall.biz.system.validation.DeleteGroup;
import net.danvi.dmall.biz.system.validation.InsertGroup;
import net.danvi.dmall.biz.system.validation.UpdateGroup;
import dmall.framework.common.model.BaseModel;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 7. 12.
 * 작성자     : dong
 * 설명       : 상품 고시 정보 등록 Parameter Object
 * </pre>
 */
@Data
@EqualsAndHashCode
public class GoodsNotifyPO extends BaseModel<GoodsNotifyPO> {
    // 상품 번호
    @NotEmpty(groups = { InsertGroup.class, UpdateGroup.class, DeleteGroup.class })
    private String goodsNo;
    // 고시 항목 번호
    @NotEmpty(groups = { InsertGroup.class, UpdateGroup.class, DeleteGroup.class })
    private Long itemNo;
    // 고시 항목 설정 값
    @NotEmpty(groups = { InsertGroup.class })
    private String itemValue;
    // 등록 수정 삭제 대상 FLAG
    private String registFlag;
    // 상품 복사시 복사원본 상품번호
    private String targetGoodsNo;
    // 상품 복사시 복사생성 상품번호
    private String newGoodsNo;
    // 고시 번호
    private String notifyNo;
}
