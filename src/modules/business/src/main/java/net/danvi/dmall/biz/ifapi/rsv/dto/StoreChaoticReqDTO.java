package net.danvi.dmall.biz.ifapi.rsv.dto;

import net.danvi.dmall.biz.ifapi.cmmn.base.BaseReqDTO;

import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * <pre>
 * - 프로젝트명    : davichmall_interface
 * - 패키지명      : net.danvi.dmall.admin.ifapi.rsv.dto
 * - 파일명        : StoreChaoticReqDTO.java
 * - 작성일        : 2018. 6. 22.
 * - 작성자        : CBK
 * - 설명          : 매장 혼잡도 조회 요청 DTO
 * </pre>
 */
@Data
@EqualsAndHashCode(callSuper=false)
public class StoreChaoticReqDTO extends BaseReqDTO {

	/**
	 * 가맹점코드
	 */
	private String strCode;
	
	/**
	 * 요일 [0~6:일~토]
	 */
	private String dow;
}
