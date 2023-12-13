package net.danvi.dmall.webservice.model;

import lombok.Data;
import lombok.EqualsAndHashCode;
import net.danvi.dmall.biz.batch.link.sabangnet.model.SabangnetData;

import java.io.Serializable;

@Data
@EqualsAndHashCode
public class BrandPO extends SabangnetData implements Serializable {

    private Long siteNo;
    private String sellerNo;
    private String SELLER_ID;
    private String SELLER_PW;

    private String BRAND_NO;
    private String BRAND_KOR_NM;



}