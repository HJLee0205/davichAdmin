package net.danvi.dmall.biz.app.setup.delivery.model;

import lombok.Data;
import lombok.EqualsAndHashCode;
import dmall.framework.common.model.BaseSearchVO;

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
public class HscdSO extends BaseSearchVO<HscdSO> {
    // 검색어 유형
    private String searchWordType;
    // 검색어
    private String searchWord;
}
