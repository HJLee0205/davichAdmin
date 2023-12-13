package net.danvi.dmall.biz.ifapi.rsv.dto;

import net.danvi.dmall.biz.ifapi.cmmn.base.BaseReqDTO;

import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * <pre>
 * - 프로젝트명    : davichmall_interface
 * - 패키지명      : net.danvi.dmall.admin.ifapi.rsv.dto
 * - 파일명        : StoreHolidayReqDTO.java
 * - 작성일        : 2018. 7. 27.
 * - 작성자        : CBK
 * - 설명          : 매장 휴일 조회 요청 DTO
 * </pre>
 */
@Data
@EqualsAndHashCode(callSuper=false)
public class StoreHolidayReqDTO extends BaseReqDTO {
	
	/**
	 * 가맹점코드
	 */
	private String strCode;
	
	/**
	 * 조회 대상 연월 (YYYYMM)
	 */
	private String targetYM;
	
	/**
	 * 조회 대상 일(D)
	 */
	private String targetD;

}
