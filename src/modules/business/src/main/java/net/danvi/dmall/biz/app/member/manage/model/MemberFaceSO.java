package net.danvi.dmall.biz.app.member.manage.model;

import dmall.framework.common.model.BaseSearchVO;
import lombok.Data;
import lombok.EqualsAndHashCode;

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
public class MemberFaceSO extends BaseSearchVO<MemberFaceSO> {

    // face레벨
    private String faceLvl;
    // 상위face 번호
    private String upFaceNo;
    // face번호
    private String faceNo;
    // face명
    private String faceNm;
    // face 적용 상품쿤 유형
    private String[] goodsTypeCd;
}
