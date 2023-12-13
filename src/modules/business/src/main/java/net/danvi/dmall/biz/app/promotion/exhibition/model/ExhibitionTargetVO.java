package net.danvi.dmall.biz.app.promotion.exhibition.model;

import lombok.Data;
import lombok.EqualsAndHashCode;
import dmall.framework.common.model.BaseModel;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 5. 3.
 * 작성자     : 이헌철
 * 설명       :
 * </pre>
 */
@Data
@EqualsAndHashCode
public class ExhibitionTargetVO extends BaseModel<ExhibitionTargetVO> {
    // 기획전대상 상품
    private String prmtNo;
    private String prmtNm;
    private String goodsNo;
    private String goodsNm;
    private String imgPath;
    private String prmtTargetExptCd; // 기획전 상세(단건)조회에서 필요_ 1.전체 02.적용대상
    private String prmtDispzoneNo;

    private String rownum;
    private String brandNm;
    private String sellerNm;
    private String salePrice;
    private String stockQtt;
    private String goodsSaleStatusNm;
    private String erpItmCode;
}
