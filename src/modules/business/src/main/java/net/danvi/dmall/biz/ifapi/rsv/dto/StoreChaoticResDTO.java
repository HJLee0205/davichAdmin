package net.danvi.dmall.biz.ifapi.rsv.dto;

import java.util.List;

import net.danvi.dmall.biz.ifapi.cmmn.base.BaseResDTO;

import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * <pre>
 * - 프로젝트명    : davichmall_interface
 * - 패키지명      : net.danvi.dmall.admin.ifapi.rsv.dto
 * - 파일명        : StoreChaoticResDTO.java
 * - 작성일        : 2018. 6. 22.
 * - 작성자        : CBK
 * - 설명          : 매장 혼잡도 조회 응답 DTO
 * </pre>
 */
@Data
@EqualsAndHashCode(callSuper=false)
public class StoreChaoticResDTO extends BaseResDTO {
	
	/**
	 * 시간대별 매장 혼잡도 목록
	 */
	private List<StoreChaoticDTO> storeChaoticList;
	
	/**
	 * <pre>
	 * - 프로젝트명    : davichmall_interface
	 * - 패키지명      : net.danvi.dmall.admin.ifapi.rsv.dto
	 * - 파일명        : StoreChaoticResDTO.java
	 * - 작성일        : 2018. 6. 22.
	 * - 작성자        : CBK
	 * - 설명          : 시간대별 매장 혼잡도 DTO
	 * </pre>
	 */
	@Data
	public static class StoreChaoticDTO {
		/**
		 * 시간 HHMM
		 */
		private String hour;
		
		/**
		 * 혼잡도 [01~]
		 */
		private String chaotic;
		
		/**
		 * 혼잡도 이름
		 */
		private String chaoticName;
	}
}
