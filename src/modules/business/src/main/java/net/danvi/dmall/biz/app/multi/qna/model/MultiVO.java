package net.danvi.dmall.biz.app.multi.qna.model;

import java.util.Date;

import lombok.Data;
import lombok.EqualsAndHashCode;
import dmall.framework.common.model.BaseModel;

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
public class MultiVO extends BaseModel<MultiVO> {
	
	private String bbsId;
	private int leftNo;
	private String title;
	private int cmntCnt;
	private String content;
	private Long regrNo;
	private Date regDttm;
	private String regDate;
	private String regrDispCd;
	private String memberNm;
	private String loginId;
	private int titleNo;
	private String iconCheckValueHot;
	private String iconCheckValueNew;
	private String noticeYn;
	private int inqCnt;
	private String titleNm;
	private int lvl;
	private String sectYn;
	private String leftLvl;
	private String imgFilePath;
	private String imgFileNm;
	private int sellerNo;
	private String sellerNm;
	private String linkUrl;
	private String relSearchWord;
	private String detailLink;

	
}
