package net.danvi.dmall.biz.ifapi.mem.dto;

import net.danvi.dmall.biz.ifapi.cmmn.base.BaseReqDTO;

import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * <pre>
 * - 프로젝트명    : davichmall_interface
 * - 패키지명      : net.danvi.dmall.admin.ifapi.mem.dto
 * - 파일명        : BeaconDataResDTO.java
 * - 작성일        : 2019. 1. 22.
 * - 작성자        : khy
 * - 설명          : 비콘자료조회
 * </pre>
 */
@Data
@EqualsAndHashCode(callSuper=false)
public class BeaconDataReqDTO extends BaseReqDTO {

		/**
		 * 비콘 아이디
		 */
		private String beaconId;

}
