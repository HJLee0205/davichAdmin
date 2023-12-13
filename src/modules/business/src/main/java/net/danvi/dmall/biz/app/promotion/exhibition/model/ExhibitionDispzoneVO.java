package net.danvi.dmall.biz.app.promotion.exhibition.model;

import dmall.framework.common.model.BaseModel;
import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 5. 3.
 * 작성자     : 이헌철
 * 설명       : 기획전 VO
 * </pre>
 */
@Data
@EqualsAndHashCode
public class ExhibitionDispzoneVO extends BaseModel<ExhibitionDispzoneVO> {
    
	private String prmtDispzoneNo;
	private String dispzoneNm;
	private String useYn;
}
