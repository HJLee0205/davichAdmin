package com.davichmall.ifapi.visit.dto;

import com.davichmall.ifapi.cmmn.base.BaseReqDTO;

import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * <pre>
 * - 프로젝트명    : davichmall_interface
 * - 패키지명      : com.davichmall.ifapi.visit.dto
 * - 파일명        : VisitStatusMdfyReqDTO.java
 * - 작성일        : 2018. 8. 6.
 * - 작성자        : CBK
 * - 설명          : 방문고객 상태 수정 요청 DTO
 * </pre>
 */
@Data
@EqualsAndHashCode(callSuper=false)
public class VisitStatusMdfyReqDTO extends BaseReqDTO {

	/**
	 * 고객방문일자 (YYYYMMDD)
	 */
	private String dates;
	
	/**
	 * 방문 매장 코드
	 */
	private String strCode;
	
	/**
	 * 방문 시각(HH24MISS)
	 */
	private String visitTime;
	
	/**
	 * 상태값
	 */
	private String flag;
}
