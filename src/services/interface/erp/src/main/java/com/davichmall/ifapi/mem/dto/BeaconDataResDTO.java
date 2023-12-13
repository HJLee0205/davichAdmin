package com.davichmall.ifapi.mem.dto;

import com.davichmall.ifapi.cmmn.base.BaseResDTO;

import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * <pre>
 * - 프로젝트명    : davichmall_interface
 * - 패키지명      : com.davichmall.ifapi.mem.dto
 * - 파일명        : BeaconDataResDTO.java
 * - 작성일        : 2019. 1. 22.
 * - 작성자        : khy
 * - 설명          : 비콘자료조회
 * </pre>
 */
@Data
@EqualsAndHashCode(callSuper=false)
public class BeaconDataResDTO extends BaseResDTO {

		/**
		 * 푸시 내역
		 */
		private String memo;
		
		/**
		 * 푸시 링크
		 */
		private String linkUrl;
		
		/**
		 * 푸시 이미지
		 */
		private String imgUrl;
		
		
		/**
		 * 비콘 아이디
		 */
		private String beaconId;


}
