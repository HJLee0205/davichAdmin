package net.danvi.dmall.biz.ifapi.mem.dto;

import java.util.List;

import net.danvi.dmall.biz.ifapi.cmmn.base.BaseResDTO;

import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * <pre>
 * - 프로젝트명    : davichmall_interface
 * - 패키지명      : net.danvi.dmall.admin.ifapi.mem.dto
 * - 파일명        : OffPointUseResDTO.java
 * - 작성일        : 2018. 7. 18.
 * - 작성자        : CBK
 * - 설명          : 오프라인 포인트 사용 응답 DTO
 * </pre>
 */
@Data
@EqualsAndHashCode(callSuper=false)
public class OffPointUseResDTO extends BaseResDTO {

	/**
	 * ERP 포인트 로그 순번
	 */
	private List<String> erpPointSeq;

}
