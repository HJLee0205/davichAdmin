package net.danvi.dmall.biz.app.prescription.model;

import dmall.framework.common.model.BaseModel;
import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * <pre>
 * - 프로젝트명    : 03.business
 * - 패키지명      : net.danvi.dmall.biz.app.prescription.model
 * - 파일명        : PrescriptionPO.java
 * - 작성일        : 2018. 7. 9.
 * - 작성자        : CBK
 * - 설명          : 처방전 정보 VO
 * </pre>
 */
@Data
@EqualsAndHashCode(callSuper=false)
public class PrescriptionVO extends BaseModel<PrescriptionVO> {

	private static final long serialVersionUID = -4883282006659779599L;

	/**
	 * 회원 번호
	 */
	private Long memberNo;
	
	/**
	 * 처방전 번호
	 */
	private Integer prescriptionNo;
	
	/**
	 * 검사 일자
	 */
	private String checkupDt;
	
	/**
	 * 검사 기관 명
	 */
	private String checkupInstituteNm;
	
	/**
	 * 처방전 파일 경로
	private String prescriptionFilePath;
	
	/**
	 * 처방전 파일 명
	private String prescriptionFileNm;
	
	/**
	 * 처방전 파일 크기
	private Long prescriptionFileSize;
	*/
	
	/**
	 * 처방전 원본 파일 명
	 */
	private String prescriptionOrgFileNm;
	
	/**
	 * 이미지 뷰를 위한 ID
	 */
	private String prescriptionFileId;
}
