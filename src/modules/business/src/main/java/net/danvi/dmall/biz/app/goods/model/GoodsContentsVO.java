package net.danvi.dmall.biz.app.goods.model;

import dmall.framework.common.model.MultiEditorBaseVO;
import lombok.Data;
import lombok.EqualsAndHashCode;
import dmall.framework.common.model.EditorBaseVO;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 6. 29.
 * 작성자     : kwt
 * 설명       : 상품 상세 설명 에디터 정보 Value Object
 * </pre>
 */
@Data
@EqualsAndHashCode
public class GoodsContentsVO extends MultiEditorBaseVO<GoodsContentsVO> {
    // 상품 번호
    private String goodsNo;
    // 서비스 구분 코드
    private String svcGbCd;
    // 내용
    private String content;

}
