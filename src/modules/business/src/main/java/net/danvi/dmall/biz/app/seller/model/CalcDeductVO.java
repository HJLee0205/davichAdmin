package net.danvi.dmall.biz.app.seller.model;

import lombok.Data;
import lombok.EqualsAndHashCode;
import dmall.framework.common.model.BaseModel;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 5. 2.
 * 작성자     : dong
 * 설명       :
 * </pre>
 */
@Data
@EqualsAndHashCode
public class CalcDeductVO {
    private String calculateNo;
	private String deductNo;
	private String deductGbCd;
	private Long deductAmt;
	private String deductDscrt;
	private String taxGbCd;
	private String inputGbn;
	private Long regrNo;
	private Long updrNo;
}
