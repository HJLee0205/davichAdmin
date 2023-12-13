package com.davichmall.ifapi.mem.dto;

import com.davichmall.ifapi.cmmn.base.BaseReqDTO;

import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * <pre>
 * - 프로젝트명    : davichmall_interface
 * - 패키지명      : com.davichmall.ifapi.mem.dto
 * - 파일명        : OnlineMemSearchReqDTO.java
 * - 작성일        : 2018. 5. 24.
 * - 작성자        : CBK
 * - 설명          : 온라인 회원 조회시 사용하는 요청 DTO (오프라인->온라인 조회시)
 * </pre>
 */
@Data
@EqualsAndHashCode(callSuper=false)
public class OnlineMemSearchReqDTO extends BaseReqDTO {

	/**
	 * 이름
	 */
	private String custName;
	
	/**
	 * 휴대폰번호 뒤 4자리
	 */
	private String hp;

	/**
	 * 전체 휴대폰번호
	 */
	private String fullHp;
	
	/**
	 * 온라인카드번호
	 */
	private String onlineCardNo;
	
	/**
	 * 회원 통합 여부
	 */
	private String combineYn;	
}
