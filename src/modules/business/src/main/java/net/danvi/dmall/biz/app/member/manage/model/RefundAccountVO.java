package net.danvi.dmall.biz.app.member.manage.model;

import lombok.Data;
import lombok.EqualsAndHashCode;
import dmall.framework.common.model.BaseModel;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 5. 9.
 * 작성자     : dong
 * 설명       :
 * </pre>
 */
@Data
@EqualsAndHashCode
public class RefundAccountVO extends BaseModel<RefundAccountVO> {

    private Long memberNo;
    private String bankCd;
    private String bankNm;
    private String actNo;
    private String holderNm;

}
