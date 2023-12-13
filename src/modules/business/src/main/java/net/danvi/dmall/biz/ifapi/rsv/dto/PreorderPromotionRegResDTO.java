package net.danvi.dmall.biz.ifapi.rsv.dto;

import net.danvi.dmall.biz.ifapi.cmmn.base.BaseResDTO;

import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * <pre>
 * - 프로젝트명    : davichmall_interface
 * - 패키지명      : net.danvi.dmall.admin.ifapi.rsv.dto
 * - 파일명        : PreorderPromotionRegResDTO.java
 * - 작성일        : 2018. 7. 2.
 * - 작성자        : CBK
 * - 설명          : 사전예약 기획전 등록 응답 DTO
 * </pre>
 */
@Data
@EqualsAndHashCode(callSuper=false)
public class PreorderPromotionRegResDTO extends BaseResDTO {

	/**
	 * 쇼핑몰 기획전 번호
	 */
	private String mallPrmtNo;
	
	/**
	 * ERP 기획전 번호
	 */
	private String erpPrmtNo;
	
}
