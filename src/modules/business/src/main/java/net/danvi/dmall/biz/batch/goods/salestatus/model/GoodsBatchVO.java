package net.danvi.dmall.biz.batch.goods.salestatus.model;

import java.io.Serializable;

import lombok.Data;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 8. 24.
 * 작성자     : dong
 * 설명       :
 * </pre>
 */
@Data
public class GoodsBatchVO implements Serializable {

    private static final long serialVersionUID = 4763862544556193935L;

    private Long regrNo;
    private Long updrNo;
    private Long siteNo;
}
