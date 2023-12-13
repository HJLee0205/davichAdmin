package net.danvi.dmall.biz.app.setup.banned.model;

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
@EqualsAndHashCode
public class BannedManageVO extends BaseModel<BannedManageVO> {
    private String seq; // 순번
    private String bannedWord; // 금칙어
}
