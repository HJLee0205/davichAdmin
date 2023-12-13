package com.davichmall.ifapi.cmmn.mapp.dto;

import com.davichmall.ifapi.cmmn.base.BaseReqDTO;

import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * <pre>
 * - 프로젝트명    : davichmall_interface
 * - 패키지명      : com.davichmall.ifapi.cmmn.mapp.dto
 * - 파일명        : PreorderMapRegReqDTO.java
 * - 작성일        : 2018. 7. 17.
 * - 작성자        : CBK
 * - 설명          : 사전예약 매핑 등록 요청 DTO
 * </pre>
 */
@Data
@EqualsAndHashCode(callSuper=false)
public class PreorderMapRegReqDTO extends BaseReqDTO {

	/**
	 * 쇼핑몰 사전예약 기획전 번호
	 */
	private String mallPrmtNo;
	
	/**
	 * ERP 사전예약 기획전 번호
	 */
	private String erpPrmtNo;
}
