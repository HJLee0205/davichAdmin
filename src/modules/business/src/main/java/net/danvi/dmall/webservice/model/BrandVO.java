package net.danvi.dmall.webservice.model;

import lombok.Data;
import lombok.EqualsAndHashCode;

import java.io.Serializable;
import java.util.List;

@Data
@EqualsAndHashCode
public class BrandVO implements Serializable {
    private String brandNo;
    private String brandKorNm;
    private String brandEngNm;

    private String STATUS;
    private String MESSAGE;
    private List<BrandVO> BRAND_LIST;


}