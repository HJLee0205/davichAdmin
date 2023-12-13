package net.danvi.dmall.biz.app.setup.banned.model;

import dmall.framework.common.model.BaseModel;
import lombok.Data;
import lombok.EqualsAndHashCode;

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
public class BannedConfigVO extends BaseModel<BannedConfigVO> {
    private String bannedWordYn; // 금칙어 사용 여부
}
