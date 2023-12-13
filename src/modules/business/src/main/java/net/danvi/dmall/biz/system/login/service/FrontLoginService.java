package net.danvi.dmall.biz.system.login.service;




/**
* <pre>
* - 프로젝트명	: 03.business
* - 패키지명	: biz.app.login.service
* - 파일명		: FrontLoginService.java
* - 작성일		: 2016. 3. 3.
* - 작성자		: snw
* - 설명		: Front 로그인 서비스 Interface
* </pre>
*/
public interface FrontLoginService {
	

	/**
	* <pre>
	* - 프로젝트명	: 03.business
	* - 파일명		: FrontLoginService.java
	* - 작성일		: 2016. 3. 3.
	* - 작성자		: snw
	* - 설명		: 회원 로그인 체크
	*             1:정상, -1:회원정보 없음, -2:비밀번호오류, -3: 휴면회원, -4:사용자상태오류
	* </pre>
	* @param loginId
	* @param password
	* @return
	* @throws Exception
	*/
	int checkLogin(String loginId, String password) throws Exception;


}