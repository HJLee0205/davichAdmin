package net.danvi.dmall.biz.example.model;

import lombok.Data;
import lombok.EqualsAndHashCode;
import dmall.framework.common.model.BaseSearchVO;

/**
 * Created by dong on 2016-04-08.
 */
@Data
@EqualsAndHashCode
public class CmnCdDtlSO extends BaseSearchVO<CmnCdDtlSO> {
    private String grpCd;
    private String cd;
    private String cdNm;
}
