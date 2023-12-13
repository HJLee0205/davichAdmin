package net.danvi.dmall.biz.ifapi.mem.dto;

import net.danvi.dmall.biz.ifapi.cmmn.ExceptLog;
import net.danvi.dmall.biz.ifapi.cmmn.base.BaseReqDTO;

import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * <pre>
 * - 프로젝트명    : davichmall_interface
 * - 패키지명      : net.danvi.dmall.admin.ifapi.mem.dto
 * - 파일명        : PrescriptionUrlReqDTO.java
 * - 작성일        : 2018. 7. 10.
 * - 작성자        : CBK
 * - 설명          : 처방전 URL 요청 DTO
 * </pre>
 */
@Data
@EqualsAndHashCode(callSuper=false)
public class PrescriptionUrlReqDTO extends BaseReqDTO {

	/**
	 * 다비젼 회원 번호
	 */
	private String cdCust;
	
	// 변환용 변수
	/**
	 * 쇼핑몰 회원 번호
	 */
	@ExceptLog
	private String memNo;
}
