package com.davichmall.ifapi.cmmn;


import com.davichmall.ifapi.cmmn.base.BaseReqDTO;
import com.davichmall.ifapi.util.IFMessageUtil;

import lombok.Getter;
import lombok.Setter;

/**
 * <pre>
 * - 프로젝트명    : davichmall_interface
 * - 패키지명      : com.davichmall.ifapi.cmmn
 * - 파일명        : CustomException.java
 * - 작성일        : 2018. 5. 18.
 * - 작성자        : CBK
 * - 설명          : 내부적으로 Exception 처리를 하기 위한 Class
 * </pre>
 */
@Setter
@Getter
public class CustomException extends Exception {

	
	public CustomException() {
		super();
	}
	public CustomException(Exception e) {
		super();
		this.origException = e;
	}
	public CustomException(Exception e, BaseReqDTO reqParam, String ifId) {
		super();
		this.origException = e;
		this.reqParam = reqParam;
		this.ifId = ifId;
	}
//	public CustomException(String message) {
//		super(message);
//	}
	
	public CustomException(String exCode) {
		super(IFMessageUtil.getMessage(exCode));
		this.exCode = exCode;
	}

	/**
	 * 인터페이스ID
	 */
	String ifId;
	
	/**
	 * 요청 파라미터
	 */
	BaseReqDTO reqParam;
	
	/**
	 * 원본 Exception개체
	 */
	Exception origException;
	
	/**
	 * 익셉션 코드
	 */
	String exCode;
	
	
}
