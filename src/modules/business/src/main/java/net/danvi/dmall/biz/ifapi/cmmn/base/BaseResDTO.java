package net.danvi.dmall.biz.ifapi.cmmn.base;

/**
 * <pre>
 * - 프로젝트명    : davichmall_interface
 * - 패키지명      : net.danvi.dmall.admin.ifapi.cmmn.base
 * - 파일명        : BaseResDTO.java
 * - 작성일        : 2018. 5. 18.
 * - 작성자        : CBK
 * - 설명          : 응답 BASE DTO. 응답DTO의 공통 속성을 보유.
 * </pre>
 */
public class BaseResDTO {
	
	/**
	 * 결과코드 (1:성공, 2:실패)
	 */
	private String result;
	
	/**
	 * 메시지 (오류 발생시 오류 메시지)
	 */
	private String message;

	private Object[] args = null;

	public Object[] getArgs() {
		return args;
	}

	public void setArgs(Object[] args) {
		this.args = args;
	}

	public String getResult() {
		return result;
	}

	public void setResult(String result) {
		this.result = result;
	}

	public String getMessage() {
		return message;
	}

	public void setMessage(String message) {
		this.message = message;
	}
	
	
}
