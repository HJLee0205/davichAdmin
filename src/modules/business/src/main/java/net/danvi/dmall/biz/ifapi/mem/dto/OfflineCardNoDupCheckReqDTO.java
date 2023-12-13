package net.danvi.dmall.biz.ifapi.mem.dto;

import net.danvi.dmall.biz.ifapi.cmmn.base.BaseReqDTO;

import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * <pre>
 * - 프로젝트명    : davichmall_interface
 * - 패키지명      : net.danvi.dmall.admin.ifapi.mem.dto
 * - 파일명        : OfflineCardNoDupCheckReqDTO.java
 * - 작성일        : 2018. 7. 24.
 * - 작성자        : CBK
 * - 설명          : 오프라인 카드 번호 중에 발급하려는 온라인 카드번호의 중복 여부 확인 요청 DTO
 * </pre>
 */
@Data
@EqualsAndHashCode(callSuper=false)
public class OfflineCardNoDupCheckReqDTO extends BaseReqDTO {

	/**
	 * 온라인 카드 번호
	 */
	private String onlineCardNo;
}
