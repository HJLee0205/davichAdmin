package dmall.framework.common.util;

import org.springframework.web.context.request.RequestAttributes;
import org.springframework.web.context.request.RequestContextHolder;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

public class SessionUtil {

	/**
	 * <pre>
	 * - 프로젝트명	: 01.common
	 * - 파일명		: SessionUtils.java
	 * - 작성일		: 2016. 3. 3.
	 * - 작성자		: dykim
	 * - 설명		: attribute 설정 method
	 * </pre>
	 * @param name
	 * @return
	 */
	public static Object getAttribute(String name) {
		return (Object) RequestContextHolder.getRequestAttributes().getAttribute(name, RequestAttributes.SCOPE_SESSION);
	}

	/**
	 * <pre>
	 * - 프로젝트명	: 01.common
	 * - 파일명		: SessionUtils.java
	 * - 작성일		: 2016. 3. 3.
	 * - 작성자		: dykim
	 * - 설명		: attribute 설정 method
	 * </pre>
	 * @param name
	 * @param object
	 */
	public static void setAttribute(String name, Object object) {
		RequestContextHolder.getRequestAttributes().setAttribute(name, object, RequestAttributes.SCOPE_SESSION);
	}

	/**
	 * <pre>
	 * - 프로젝트명	: 01.common
	 * - 파일명		: SessionUtils.java
	 * - 작성일		: 2016. 3. 3.
	 * - 작성자		: dykim
	 * - 설명		: 설정한 attribute 삭제
	 * </pre>
	 * @param name
	 */
	public static void removeAttribute(String name) {
		RequestContextHolder.getRequestAttributes().removeAttribute(name, RequestAttributes.SCOPE_SESSION);
	}

	/**
	 * <pre>
	 * - 프로젝트명	: 01.common
	 * - 파일명		: SessionUtils.java
	 * - 작성일		: 2016. 3. 3.
	 * - 작성자		: dykim
	 * - 설명		: session id
	 * </pre>
	 * @return
	 */
	public static String getSessionId() {
		return RequestContextHolder.getRequestAttributes().getSessionId();
	}

	/**
	 * <pre>
	 * - 프로젝트명	: 01.common
	 * - 파일명		: SessionUtils.java
	 * - 작성일		: 2016. 3. 3.
	 * - 작성자		: dykim
	 * - 설명		: HttpSession에 주어진 키 값으로 세션 객체를 생성하는 기능
	 * </pre>
	 * @param request
	 * @param keyStr
	 * @param obj
	 */
	public static void setSessionAttribute(HttpServletRequest request, String keyStr, Object obj) {
		HttpSession session = request.getSession();
		session.setAttribute(keyStr, obj);
	}

	/**
	 * <pre>
	 * - 프로젝트명	: 01.common
	 * - 파일명		: SessionUtils.java
	 * - 작성일		: 2016. 3. 3.
	 * - 작성자		: dykim
	 * - 설명		: HttpSession에 존재하는 주어진 키 값에 해당하는 세션 값을 얻어오는 기능
	 * </pre>
	 * @param request
	 * @param keyStr
	 * @return
	 */
	public static Object getSessionAttribute(HttpServletRequest request, String keyStr) {
		HttpSession session = request.getSession();
		return session.getAttribute(keyStr);
	}

	/**
	 * <pre>
	 * - 프로젝트명	: 01.common
	 * - 파일명		: SessionUtils.java
	 * - 작성일		: 2016. 3. 3.
	 * - 작성자		: dykim
	 * - 설명		: HttpSession에 존재하는 세션을 주어진 키 값으로 삭제하는 기능
	 * </pre>
	 * @param request
	 * @param keyStr
	 */
	public static void removeSessionAttribute(HttpServletRequest request, String keyStr) {
		HttpSession session = request.getSession();
		session.removeAttribute(keyStr);
	}

	/**
	 * <pre>
	 * - 프로젝트명	: 01.common
	 * - 파일명		: SessionUtils.java
	 * - 작성일		: 2016. 3. 3.
	 * - 작성자		: dykim
	 * - 설명		: 세션 존재 유무
	 * </pre>
	 * @param request
	 * @param keyStr
	 * @return
	 */
	public static boolean isSessionAttribute(HttpServletRequest request, String keyStr) {
		Object result = getSessionAttribute(request, keyStr);
		if(result != null) {
			return true;
		} else {
			return false;
		}
	}
}
