package net.danvi.dmall.biz.app.goods.model;

import java.util.ArrayList;
import java.util.List;

import javax.validation.Valid;

import lombok.Data;
import lombok.EqualsAndHashCode;
import dmall.framework.common.model.BaseModel;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 8. 29.
 * 작성자     : user
 * 설명       : 상품 이미지 사이즈 설정 Parameter Object
 * </pre>
 */
@Data
@EqualsAndHashCode
public class GoodsImageSizePO extends BaseModel<GoodsImageSizePO> {
    // 상품 기본 이미지 가로
    private String goodsDefaultImgWidth;
    // 상품 기본 이미지 세로
    private String goodsDefaultImgHeight;
    // 상품 리스트 이미지 가로
    private String goodsListImgWidth;
    // 상품 리스트 이미지 세로
    private String goodsListImgHeight;
    // 상품 전시 이미지 TypeA 가로
    private String goodsDispImgTypeAWidth;
    // 상품 전시 이미지 TypeA 세로
    private String goodsDispImgTypeAHeight;
    // 상품 전시 이미지 TypeB 가로
    private String goodsDispImgTypeBWidth;
    // 상품 전시 이미지 TypeB 세로
    private String goodsDispImgTypeBHeight;
    // 상품 전시 이미지 TypeC 가로
    private String goodsDispImgTypeCWidth;
    // 상품 전시 이미지 TypeC 세로
    private String goodsDispImgTypeCHeight;
    // 상품 전시 이미지 TypeD 가로
    private String goodsDispImgTypeDWidth;
    // 상품 전시 이미지 TypeD 세로
    private String goodsDispImgTypeDHeight;
    // 상품 전시 이미지 TypeE 가로
    private String goodsDispImgTypeEWidth;
    // 상품 전시 이미지 TypeE 세로
    private String goodsDispImgTypeEHeight;

    // 상품 전시 이미지 TypeF 가로
    private String goodsDispImgTypeFWidth;
    // 상품 전시 이미지 TypeF 세로
    private String goodsDispImgTypeFHeight;
    // 상품 전시 이미지 TypeG 가로
    private String goodsDispImgTypeGWidth;
    // 상품 전시 이미지 TypeG 세로
    private String goodsDispImgTypeGHeight;
    // 상품 전시 이미지 TypeS 가로
    private String goodsDispImgTypeSWidth;
    // 상품 전시 이미지 TypeS 세로
    private String goodsDispImgTypeSHeight;
    
    // 상품 전시 이미지 TypeM 가로
    private String goodsDispImgTypeMWidth;
    // 상품 전시 이미지 TypeM 세로
    private String goodsDispImgTypeMHeight;
    
    // 상품 전시 이미지 TypeO 가로
    private String goodsDispImgTypeOWidth;
    // 상품 전시 이미지 TypeO 세로
    private String goodsDispImgTypeOHeight;


    public GoodsImageSizePO() {
        this.iconList = new ArrayList<>();
    }

    // 사이트에 등록된 ICON 목록
    @Valid
    private List<GoodsIconPO> iconList;

    public List<GoodsIconPO> getIconList() {
        return iconList;
    }
}
