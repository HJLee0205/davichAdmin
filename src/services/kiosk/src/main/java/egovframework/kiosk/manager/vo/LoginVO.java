package egovframework.kiosk.manager.vo;

import java.io.Serializable;

public class LoginVO implements Serializable{
	private String strCode = "";
	private String loginId = "";
	private String loginPw = "";
	private String result = "";
	private String message = "";
	private String checkResult = "";
	private String strName = "";
	
	public String getStrCode() {
		return strCode;
	}
	public void setStrCode(String strCode) {
		this.strCode = strCode;
	}
	public String getLoginId() {
		return loginId;
	}
	public void setLoginId(String loginId) {
		this.loginId = loginId;
	}
	public String getLoginPw() {
		return loginPw;
	}
	public void setLoginPw(String loginPw) {
		this.loginPw = loginPw;
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
	public String getCheckResult() {
		return checkResult;
	}
	public void setCheckResult(String checkResult) {
		this.checkResult = checkResult;
	}
	public String getStrName() {
		return strName;
	}
	public void setStrName(String strName) {
		this.strName = strName;
	}

	@Override
	public String toString() {
		return "LoginVO{" +
				"strCode='" + strCode + '\'' +
				", loginId='" + loginId + '\'' +
				", loginPw='" + loginPw + '\'' +
				", result='" + result + '\'' +
				", message='" + message + '\'' +
				", checkResult='" + checkResult + '\'' +
				", strName='" + strName + '\'' +
				'}';
	}
}
