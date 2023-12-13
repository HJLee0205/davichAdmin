package net.danvi.dmall.biz.app.setup.siteinfo.model;

import lombok.Data;
import lombok.EqualsAndHashCode;
import dmall.framework.common.model.EditorBaseVO;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 4. 29.
 * 작성자     : dong
 * 설명       : 사이트 정보 SO
 * </pre>
 */
@Data
@EqualsAndHashCode
public class SiteSO extends EditorBaseVO<SiteSO> {
    // 사이트 정보 코드
    private String siteInfoCd;
    // 내용
    private String content;
    // 표준 약정 적용 여부
    private String stdTermsApplyYn;

}
