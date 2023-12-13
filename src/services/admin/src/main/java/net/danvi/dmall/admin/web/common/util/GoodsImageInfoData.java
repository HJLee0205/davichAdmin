package net.danvi.dmall.admin.web.common.util;

import lombok.Data;
import dmall.framework.common.util.image.ImageInfoData;

@Data
public class GoodsImageInfoData extends ImageInfoData {

    /** 이미지 타입 */
    private GoodsImageType goodsImageType;

    /** 사이트에 설정된 상품 상세 이미지 넓이 */
    private int widthForGoodsDetail;
    /** 사이트에 설정된 상품 상세 이미지 높이 */
    private int heightForGoodsDetail;
    /** 사이트에 설정된 상품 Thumbnail 이미지 넓이 */
    private int widthForGoodsThumbnail;
    /** 사이트에 설정된 상품 Thumbnail 이미지 높이 */
    private int heightForGoodsThumbnail;

    private int widthForDispTypeA;
    private int heightForDispTypeA;

    private int widthForDispTypeB;
    private int heightForDispTypeB;

    private int widthForDispTypeC;
    private int heightForDispTypeC;

    private int widthForDispTypeD;
    private int heightForDispTypeD;

    private int widthForDispTypeE;
    private int heightForDispTypeE;

    private int widthForDispTypeF;
    private int heightForDispTypeF;
    private int widthForDispTypeG;
    private int heightForDispTypeG;
    private int widthForDispTypeS;
    private int heightForDispTypeS;

    private int widthForDispTypeM;
    private int heightForDispTypeM;
    
    private int widthForDispTypeO;
    private int heightForDispTypeO;
    
    private int widthForDispTypeP;
    private int heightForDispTypeP;


    private int widthForWearL;
    private int heightForWearL;

    private int widthForWearR;
    private int heightForWearR;

    private int widthForLensL;
    private int heightForLensL;

    private int widthForLensR;
    private int heightForLensR;
}
