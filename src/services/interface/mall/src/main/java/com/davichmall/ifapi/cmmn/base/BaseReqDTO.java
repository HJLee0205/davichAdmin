package com.davichmall.ifapi.cmmn.base;

import com.davichmall.ifapi.cmmn.ExceptLog;

import lombok.Data;

@Data
public class BaseReqDTO {

	/**
	 * 반대편 인터페이스 서버에서 전송했는지 여부
	 */
	@ExceptLog(force=true)
	private boolean fromIF;
}
