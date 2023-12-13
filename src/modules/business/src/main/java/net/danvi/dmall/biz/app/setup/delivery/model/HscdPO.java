package net.danvi.dmall.biz.app.setup.delivery.model;

import javax.validation.constraints.NotNull;

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
 * 작성일     : 2016. 4. 29.
 * 작성자     : user
 * 설명       :
 * </pre>
 */
@Data
@EqualsAndHashCode
public class HscdPO extends BaseModel<HscdPO> {
    // HS코드 순번
    @NotNull(groups = { DeleteGroup.class })
    private Long hscdSeq;
    // HS코드
    @NotEmpty(groups = { InsertGroup.class, UpdateGroup.class, DeleteGroup.class })
    private String hscd;
    // 항목
    @NotEmpty(groups = { InsertGroup.class, UpdateGroup.class })
    private String item;
}
