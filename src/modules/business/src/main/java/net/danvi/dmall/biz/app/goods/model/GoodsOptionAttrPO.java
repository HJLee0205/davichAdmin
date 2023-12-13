package net.danvi.dmall.biz.app.goods.model;

import org.hibernate.validator.constraints.NotEmpty;

import lombok.Data;
import lombok.EqualsAndHashCode;
import dmall.framework.common.model.BaseModel;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 7. 12.
 * 작성자     : dong
 * 설명       : 옵션 속성 정보 등록 Parameter Object
 * </pre>
 */
@Data
@EqualsAndHashCode
public class GoodsOptionAttrPO extends BaseModel<GoodsOptionAttrPO> {
    // 속성 번호
    private long attrNo;
    // 옵션 번호
    private long optNo;
    // 속성 명
    @NotEmpty
    private String attrNm;
    // 이전 속성명
    private String preAttrNm;
    // 사용 여부
    private String useYn;
    // 등록 적용 FLAG
    private String registFlag;
}
