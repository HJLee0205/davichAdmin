package net.danvi.dmall.biz.ifapi.rsv.dto;

import net.danvi.dmall.biz.ifapi.cmmn.base.BaseReqDTO;

import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * <pre>
 * - 프로젝트명    : davichmall_interface
 * - 패키지명      : net.danvi.dmall.admin.ifapi.rsv.dto
 * - 파일명        : ReserveProductSearchReqDTO.java
 * - 작성일        : 2018. 6. 29.
 * - 작성자        : CBK
 * - 설명          : 방문예약 상품 목록 조회 요청 DTO
 * </pre>
 */
@Data
@EqualsAndHashCode(callSuper=false)
public class ReserveProductSearchReqDTO extends BaseReqDTO {

	/**
	 * 쇼핑몰 방문예약 번호
	 */
	private String mallRsvNo;
}
