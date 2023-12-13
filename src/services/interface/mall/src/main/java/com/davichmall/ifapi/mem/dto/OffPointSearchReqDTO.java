package com.davichmall.ifapi.mem.dto;

import com.davichmall.ifapi.cmmn.base.BaseReqDTO;

import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * <pre>
 * - 프로젝트명    : davichmall_interface
 * - 패키지명      : com.davichmall.ifapi.mem.dto
 * - 파일명        : OffPointSearchReqDTO.java
 * - 작성일        : 2018. 5. 29.
 * - 작성자        : CBK
 * - 설명          : 오프라인 보유 포인트 조회 요청 DTO
 * </pre>
 */
@Data
@EqualsAndHashCode(callSuper=false)
public class OffPointSearchReqDTO extends BaseReqDTO {

	/**
	 * 쇼핑몰 회원번호
	 */
	private String memNo;
	
	/**
	 * 다비젼 회원번호
	 */
	private String cdCust;
}
