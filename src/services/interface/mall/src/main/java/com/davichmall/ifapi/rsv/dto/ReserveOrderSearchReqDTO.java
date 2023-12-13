package com.davichmall.ifapi.rsv.dto;

import com.davichmall.ifapi.cmmn.base.BaseReqDTO;

import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * <pre>
 * - 프로젝트명    : davichmall_interface
 * - 패키지명      : com.davichmall.ifapi.rsv.dto
 * - 파일명        : ReserveOrderSearchReqDTO.java
 * - 작성일        : 2018. 6. 29.
 * - 작성자        : CBK
 * - 설명          : 방문 예약 주문 목록 조회 요청 DTO
 * </pre>
 */
@Data
@EqualsAndHashCode(callSuper=false)
public class ReserveOrderSearchReqDTO extends BaseReqDTO {
	
	/**
	 * 쇼핑몰 방문 예약 번호
	 */
	private String mallRsvNo;
}
