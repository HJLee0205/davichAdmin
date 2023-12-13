package net.danvi.dmall.biz.app.goods.model;

import lombok.Data;
import lombok.EqualsAndHashCode;
import dmall.framework.common.model.BaseModel;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 7. 2.
 * 작성자     : kwt
 * 설명       : 상품 옵션 정보 Value Object
 * </pre>
 */
@Data
@EqualsAndHashCode
public class GoodsOptionVO extends BaseModel<GoodsOptionVO> {
    // 상품번호
    private String goodsNo;
    // 옵션 번호
    private String optNo;
    // 옵션 명
    private String optNm;
    // 옵션 등록 순번
    private String regSeq;
    // 옵션 순번 (1 ~ 4 단품속성 적용 순번)
    private long optSeq;
    // 속성 번호 (,구분 배열)
    private String attrNoArr;
    // 속성 명 (,구분 배열)
    private String attrNmArr;
    // 옵션 그룹명 (최근 옵션 불러오기 표시용)
    private String optGrpNm;
}
