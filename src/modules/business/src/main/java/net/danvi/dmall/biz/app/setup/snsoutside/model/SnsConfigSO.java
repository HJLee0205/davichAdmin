package net.danvi.dmall.biz.app.setup.snsoutside.model;

import lombok.Data;
import lombok.EqualsAndHashCode;
import dmall.framework.common.model.BaseModel;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 6. 7.
 * 작성자     : dong
 * 설명       : SNS 외부연동 설정 SO
 * </pre>
 */
@Data
@EqualsAndHashCode
public class SnsConfigSO extends BaseModel<SnsConfigSO> {
    // 외부 연동 코드
    private String outsideLinkCd;
}
