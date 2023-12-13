package net.danvi.dmall.biz.app.goods.model;

import java.util.List;

import javax.validation.Valid;

import org.hibernate.validator.constraints.NotEmpty;

import lombok.Data;
import lombok.EqualsAndHashCode;
import dmall.framework.common.model.BaseModel;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 5. 2.
 * 작성자     : kwt
 * 설명       : 상품 옵션 정보 등록 Parameter Object
 * </pre>
 */
@Data
@EqualsAndHashCode
public class GoodsOptionPO extends BaseModel<GoodsOptionPO> {

    // 상품 번호
    private String goodsNo;
    // 옵션 명
    @NotEmpty
    private String optNm;
    // 사용 여부
    private String useYn;
    // 옵션 번호
    private long optNo;
    // 등록 순번
    private long regSeq;
    // 옵션 순번 (1 ~ 4 단품속성 적용 순번)
    private long optSeq;
    // 적용 FLAG
    private String registFlag;
    // 속성 리스트
    @Valid
    private List<GoodsOptionAttrPO> optionValueList;
}
