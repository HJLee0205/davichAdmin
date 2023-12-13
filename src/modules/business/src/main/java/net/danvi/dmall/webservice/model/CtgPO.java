package net.danvi.dmall.webservice.model;

import lombok.Data;
import lombok.EqualsAndHashCode;
import net.danvi.dmall.biz.batch.link.sabangnet.model.SabangnetData;

import java.io.Serializable;

@Data
@EqualsAndHashCode
public class CtgPO extends SabangnetData implements Serializable {

    private Long siteNo;
    private String sellerNo;
    private String SELLER_ID;
    private String SELLER_PW;
    private Integer CTG_NO;
    private String CTG_NM;


}