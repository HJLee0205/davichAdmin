package net.danvi.dmall.biz.app.setup.base.model;

import lombok.Data;
import dmall.framework.common.model.BaseModel;

/**
 * Created by dong on 2016-05-03.
 */
@Data
public class ManagerGroupVO extends BaseModel<ManagerGroupVO> {
    private Integer rownum;
    private Integer sortNum;
    private Integer cnt;
    private Long authGrpNo;
    private String authGbCd;
    private String authNm;
    private String menuId;
    private String menuNm;
}
