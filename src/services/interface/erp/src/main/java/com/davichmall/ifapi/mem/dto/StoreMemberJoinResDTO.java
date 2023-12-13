package com.davichmall.ifapi.mem.dto;

import com.davichmall.ifapi.cmmn.base.BaseResDTO;

import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * <pre>
 * - 프로젝트명    : davichmall_interface
 * - 패키지명      : com.davichmall.ifapi.mem.dto
 * - 파일명        : StoreMemberJoinResDTO.java
 * - 작성일        : 2018. 9. 7.
 * - 작성자        : CBK
 * - 설명          : 매장에서 쇼핑몰 회원 가입 요청 DTO
 * </pre>
 */
@Data
@EqualsAndHashCode(callSuper=false)
public class StoreMemberJoinResDTO extends BaseResDTO {

	/**
	 * 쇼핑몰 회원 카드 번호
	 */
	private String onlineCardNo;
}
