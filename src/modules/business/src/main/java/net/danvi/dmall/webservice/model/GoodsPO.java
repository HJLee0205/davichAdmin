package net.danvi.dmall.webservice.model;

import lombok.Data;
import lombok.EqualsAndHashCode;
import net.danvi.dmall.biz.batch.link.sabangnet.model.SabangnetData;

import java.io.Serializable;

@Data
@EqualsAndHashCode
public class GoodsPO extends SabangnetData implements Serializable {
    private String ifSno;
    private String ifNo;
    private String ifId;
    private Long siteNo;
    private String sellerNo;
    private String goodsNo;
    private String itemNo;
    private String attrVer;

    private String SELLER_ID;
    private String SELLER_PW;
    private String SBN_GOODS_NO;
    private String GOODS_NM;
    private String MODEL_NM;
    private int BRAND_NO;
    private int CTG_NO_1;
    private int CTG_NO_2;
    private int CTG_NO_3;
    private int CTG_NO_4;
    private String GOODS_SEARCH;
    private String MAKER;
    private String ORIGIN;
    private String STATUS;
    private String TAX_YN;
    private String DELV_TYPE;
    private String DELV_COST;
    private int DELV_EXPECT_DAYS;
    private String GOODS_COST;
    private String GOODS_PRICE;
    private String GOODS_CONSUMER_PRICE;

    private String CHAR_1_NM;
    private String CHAR_1_VAL;
    private String CHAR_2_NM;
    private String CHAR_2_VAL;
    private String PROP1_CD;
    private String PROP_VAL1;
    private String PROP_VAL2;
    private String PROP_VAL3;
    private String PROP_VAL4;
    private String PROP_VAL5;
    private String PROP_VAL6;
    private String PROP_VAL7;
    private String PROP_VAL8;
    private String PROP_VAL9;
    private String PROP_VAL10;
    private String PROP_VAL11;
    private String PROP_VAL12;
    private String PROP_VAL13;
    private String PROP_VAL14;
    private String PROP_VAL15;
    private String PROP_VAL16;
    private String PROP_VAL17;
    private String PROP_VAL18;
    private String PROP_VAL19;
    private String PROP_VAL20;
    private String PROP_VAL21;
    private String PROP_VAL22;
    private String PROP_VAL23;
    private String PROP_VAL24;
    private String PROP_VAL25;
    private String PROP_VAL26;
    private String PROP_VAL27;
    private String PROP_VAL28;

    private String IMG_PATH;
    private String IMG_PATH1;
    private String IMG_PATH2;
    private String IMG_PATH3;
    private String IMG_PATH4;
    private String IMG_PATH5;
    private String GOODS_REMARKS;

    private Long regrNo;
    private Long updrNo;


}