package com.davichmall.ifapi.mem.dto;

import com.davichmall.ifapi.cmmn.base.BaseReqDTO;

import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * <pre>
 * - 프로젝트명    : davichmall_interface
 * - 패키지명      : com.davichmall.ifapi.mem.dto
 * - 파일명        : MemberSearchReqDTO.java
 * - 작성일        : 2018. 5. 24.
 * - 작성자        : CBK
 * - 설명          : 오프라인 회원 조회시 사용하는 요청 DTO (온라인->오프라인 조회시)
 * </pre>
 */
@Data
@EqualsAndHashCode(callSuper=false)
public class OfflineMemSearchReqDTO extends BaseReqDTO {

	/**
	 * 이름
	 */
	private String custName;
	
	/**
	 * 휴대폰번호
	 */
	private String hp;
	
	/**
	 * 가맹점 코드(최근방문매장)
	 */
	private String strCode;
}
