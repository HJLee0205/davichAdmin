package net.danvi.dmall.biz.ifapi.rsv.dto;

import java.util.List;

import net.danvi.dmall.biz.ifapi.cmmn.base.BaseResDTO;

import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * <pre>
 * - 프로젝트명    : davichmall_interface
 * - 패키지명      : net.danvi.dmall.admin.ifapi.rsv.dto
 * - 파일명        : StoreSearchResDTO.java
 * - 작성일        : 2018. 6. 18.
 * - 작성자        : CBK
 * - 설명          : 가맹점 목록 조회 응답 DTO
 * </pre>
 */
@Data
@EqualsAndHashCode(callSuper=false)
public class StoreSearchResDTO extends BaseResDTO {

	/**
	 * 데이터 총 개수
	 */
	private int totalCnt = 0;
	
	/**
	 * 가맹점 정보 리스트
	 */
	private List<StoreInfoDTO> strList;
	
	/**
	 * <pre>
	 * - 프로젝트명    : davichmall_interface
	 * - 패키지명      : net.danvi.dmall.admin.ifapi.rsv.dto
	 * - 파일명        : StoreSearchResDTO.java
	 * - 작성일        : 2018. 6. 18.
	 * - 작성자        : CBK
	 * - 설명          : 가맹점 정보 DTO
	 * </pre>
	 */
	@Data
	public static class StoreInfoDTO {
		/**
		 * 가맹점코드
		 */
		private String strCode;
		
		/**
		 * 가맹점이름
		 */
		private String strName;
		
		/**
		 * 내용
		 */
		private String cont;
		
		/**
		 * 매장수령/방문예약 가능여부
		 */
		private String recvAllowYn;
		
		/**
		 * 보청기 취급여부
		 */
		private String hearingAidYn;
		
		/**
		 * 매장주소
		 */
		private String addr1;
		
		/**
		 * 매장주소 상세
		 */
		private String addr2;
		
		/**
		 * 매장 전화번호
		 */
		private String telNo;
		
		
	}
}
