package com.davichmall.ifapi.dist.dto;

import lombok.Data;

/**
 * <pre>
 * - 프로젝트명    : davichmall_interface
 * - 패키지명      : com.davichmall.ifapi.dist.dto
 * - 파일명        : ReturnInfoDTO.java
 * - 작성일        : 2018. 9. 6.
 * - 작성자        : CBK
 * - 설명          : 반품 정보 DTO
 * </pre>
 */
@Data
public class ReturnInfoDTO {

	private String ordDate;
	private String strCode;
	private String ordSlip;
	private String ordSeq;
	private String ordAddNo;
	private int sprc;
	private int supQty;
	private String orgOrdDate;
	private String orgStrCode;
	private String orgOrdSlip;
	private String orgOrdSeq;
	private String orgOrdAddNo;
}
