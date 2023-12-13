package net.danvi.dmall.biz.ifapi.visit.dto;

import net.danvi.dmall.biz.ifapi.cmmn.base.BaseReqDTO;

import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * <pre>
 * - 프로젝트명    : davichmall_interface
 * - 패키지명      : net.danvi.dmall.admin.ifapi.visit.dto
 * - 파일명        : KioskLoginCheckReqDTO.java
 * - 작성일        : 2018. 8. 6.
 * - 작성자        : CBK
 * - 설명          : 키오스크 로그인 정보 확인 요청 DTO
 * </pre>
 */
@Data
@EqualsAndHashCode(callSuper=false)
public class KioskLoginCheckReqDTO extends BaseReqDTO {

	/**
	 * 가맹점 코드
	 */
	private String strCode;
	
	/**
	 * 로그인 ID
	 */
	private String loginId;
	
	/**
	 * 로그인 비밀번호
	 */
	private String loginPw;
}
