package net.danvi.dmall.biz.ifapi.rsv.dto;

import net.danvi.dmall.biz.ifapi.cmmn.ExceptLog;
import net.danvi.dmall.biz.ifapi.cmmn.base.BaseReqDTO;

import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * <pre>
 * - 프로젝트명    : davichmall_interface
 * - 패키지명      : net.danvi.dmall.admin.ifapi.rsv.dto
 * - 파일명        : PreorderPromotionModReqDTO.java
 * - 작성일        : 2018. 7. 4.
 * - 작성자        : CBK
 * - 설명          : 사전예약 기획전 수정 요청 DTO
 * </pre>
 */
@Data
@EqualsAndHashCode(callSuper=false)
public class PreorderPromotionModReqDTO extends BaseReqDTO {

	/**
	 * 쇼핑몰 기획전 번호
	 */
	private String prmtNo;
	
	/**
	 * 기획전 명
	 */
	private String prmtName;
	
	/**
	 * 기획전 시작일
	 */
	private String prmtSDate;
	
	/**
	 * 기획전 종료일
	 */
	private String prmtEDate;
	
	// 변환용 변수
	/**
	 * ERP 사전예약 기획전 번호
	 */
	@ExceptLog
	private String erpPrmtNo;

}
