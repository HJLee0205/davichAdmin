package net.danvi.dmall.biz.app.setup.banned.model;

import dmall.framework.common.model.BaseModel;
import lombok.Data;
import lombok.EqualsAndHashCode;
import net.danvi.dmall.biz.system.validation.UpdateGroup;
import org.hibernate.validator.constraints.NotEmpty;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2022. 9. 22.
 * 작성자     : slims
 * 설명       :
 * </pre>
 */
@Data
@EqualsAndHashCode
public class BannedConfigPO extends BaseModel<BannedConfigPO> {
    // 금칙어 사용 여부
    @NotEmpty(groups = { UpdateGroup.class })
    private String bannedWordYn;
    private String[] bannedList;
}
