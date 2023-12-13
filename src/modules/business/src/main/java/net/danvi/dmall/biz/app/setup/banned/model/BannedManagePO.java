package net.danvi.dmall.biz.app.setup.banned.model;

import org.hibernate.validator.constraints.Length;
import org.hibernate.validator.constraints.NotEmpty;

import lombok.Data;
import lombok.EqualsAndHashCode;
import dmall.framework.common.model.BaseModel;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 5. 4.
 * 작성자     : user
 * 설명       :
 * </pre>
 */

@Data
@EqualsAndHashCode(callSuper = false)
public class BannedManagePO extends BaseModel<BannedManagePO> {
    private Long seq; // 순번
    @NotEmpty
    @Length(min = 1, max = 50)
    private String bannedWord; // 금칙어
}
