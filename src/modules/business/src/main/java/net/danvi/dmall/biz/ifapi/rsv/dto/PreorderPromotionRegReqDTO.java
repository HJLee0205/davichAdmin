package net.danvi.dmall.biz.ifapi.rsv.dto;

import net.danvi.dmall.biz.ifapi.cmmn.ExceptLog;
import net.danvi.dmall.biz.ifapi.cmmn.base.BaseReqDTO;

import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * <pre>
 * - 프로젝트명    : davichmall_interface
 * - 패키지명      : net.danvi.dmall.admin.ifapi.rsv.dto
 * - 파일명        : PreorderPromotionRegReqDTO.java
 * - 작성일        : 2018. 7. 2.
 * - 작성자        : CBK
 * - 설명          : 사전예약 기획전 등록 요청 DTO
 * </pre>
 */
@Data
@EqualsAndHashCode(callSuper=false)
public class PreorderPromotionRegReqDTO extends BaseReqDTO {

	/**
	 * 기획전 명
	 */
	private String prmtName;
	
	/**
	 * 쇼핑몰 기획전 번호
	 */
	private String prmtNo;

	// DB 저장용 변수
	/**
	 * 다비젼 사전예약 기획전 번호 (공통코드 (ctr_id: 601)의 신규 (max) ctr_code)
	 */
	@ExceptLog(force=true)
	private String erpPrmtNo;
}
