package net.danvi.dmall.biz.app.member.manage.model;

import lombok.Data;
import lombok.EqualsAndHashCode;
import dmall.framework.common.model.BaseModel;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 5. 3.
 * 작성자     : kjw
 * 설명       : 회원 정보 등록, 수정, 삭제 관련 Value Object 클래스
 * </pre>
 */
@Data
@EqualsAndHashCode(callSuper = false)
public class RefundAccountPO extends BaseModel<RefundAccountPO> {

    private Long memberNo;
    private String bankCd;
    private String actNo;
    private String holderNm;
    private Long refundActSeq;

}
