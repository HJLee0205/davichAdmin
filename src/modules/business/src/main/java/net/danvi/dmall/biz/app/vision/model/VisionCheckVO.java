package net.danvi.dmall.biz.app.vision.model;

import java.util.Date;

import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2018. 7. 25.
 * 작성자     : yji
 * 설명       :
 * </pre>
 */
@Data
@EqualsAndHashCode
public class VisionCheckVO {
	//비전체크 번호
	private long visionCheckNo;
	//회원 번호
	private long memberNo;
	//관련 활동
	private String relateActivity;
	//연령
	private String age;
	//렌즈 구분 코드
	private String lensGbCd;
	//체크 번호
	private int checkNo;
	//등록자 번호
	private long regrNo;
	//등록 일시
	private Date regDttm;
	//수정자 번호
	private long updrNo;
	//수정 일시
	private Date updDttm;
	
	//체크명
	private String checkNm;
	//간단 설명
	private String simpleDscrt; 
	 //상세 설명
	private String dtlDscrt;
	//이미지명
	private String imgNm;
	
	private String checkNos;
	 
	
	//제품추천
	private String poMatrCd;
	private String poMatrNm;
	private String lifeStyleCd;
	private String lifeStyleNm;
	
	//전체결과
	private String resultAll;
	
}
