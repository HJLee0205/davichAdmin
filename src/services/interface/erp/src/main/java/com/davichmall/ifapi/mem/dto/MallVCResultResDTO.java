package com.davichmall.ifapi.mem.dto;

import java.util.List;

import com.davichmall.ifapi.cmmn.base.BaseResDTO;

import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * <pre>
 * - 프로젝트명    : davichmall_interface
 * - 패키지명      : com.davichmall.ifapi.mem.dto
 * - 파일명        : MallVCResultResDTO.java
 * - 작성일        : 2018. 7. 27.
 * - 작성자        : CBK
 * - 설명          : 쇼핑몰 비젼체크 결과 조회 응답 DTO
 * </pre>
 */
@Data
@EqualsAndHashCode(callSuper=false)
public class MallVCResultResDTO extends BaseResDTO {

	/**
	 * 비젼체크 결과 리스트
	 */
	private List<MallVCResultDTO> resultList;
	
	/**
	 * <pre>
	 * - 프로젝트명    : davichmall_interface
	 * - 패키지명      : com.davichmall.ifapi.mem.dto
	 * - 파일명        : MallVCResultResDTO.java
	 * - 작성일        : 2018. 7. 27.
	 * - 작성자        : CBK
	 * - 설명          : 비젼체크 결과 DTO
	 * </pre>
	 */
	@Data
	public static class MallVCResultDTO {
		
		/**
		 * 렌즈구분코드 [G:안경렌즈, C:콘택트렌즈]
		 */
		private String lensGbCd;
		
		/**
		 * 렌즈구분명
		 */
		private String lensGbNm;
		
		/**
		 * 선택연령대
		 */
		private String selAge;
		
		/**
		 * 선택항목 (여러개인 경우 콤마(,)구분자로 한번에 보여짐)
		 */
		private String selItem;
		
		/**
		 * 추천렌즈 (여러개인 경우 콤마(,)구분자로 한번에 보여짐)
		 */
		private String recLens;
	}
}
