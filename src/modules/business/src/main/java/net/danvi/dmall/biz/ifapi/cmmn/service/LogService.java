package net.danvi.dmall.biz.ifapi.cmmn.service;

import net.danvi.dmall.biz.ifapi.cmmn.CustomIfException;
import net.danvi.dmall.biz.ifapi.cmmn.base.BaseResDTO;

/**
 * <pre>
 * - 프로젝트명    : davichmall_interface
 * - 패키지명      : net.danvi.dmall.admin.ifapi.cmmn.service
 * - 파일명        : LogService.java
 * - 작성일        : 2018. 5. 18.
 * - 작성자        : CBK
 * - 설명          : 인터페이스 로그 처리를 위한 Service
 * </pre>
 */
public interface LogService {
	/**
	 * <pre>
	 * 작성일 : 2018. 5. 21.
	 * 작성자 : CBK
	 * 설명   : 인터페이스 처리 로그 등록 (resParam이 DTO인 경우)
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 5. 21. CBK - 최초생성
	 * </pre>
	 *
	 * @return
	 * @throws Exception
	 */
	void writeInterfaceLog(String ifId, Object reqParam, BaseResDTO resParam);
	
	/**
	 * <pre>
	 * 작성일 : 2018. 5. 21.
	 * 작성자 : CBK
	 * 설명   : 인터페이스 처리 로그 등록(resParam이 String인 경우)
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 5. 21. CBK - 최초생성
	 * </pre>
	 *
	 * @return
	 * @throws Exception
	 */
	void writeInterfaceLog(String ifId, Object reqParam, String resParam, Class<? extends BaseResDTO> resDtoClass);
	
	/**
	 * <pre>
	 * 작성일 : 2018. 5. 21.
	 * 작성자 : CBK
	 * 설명   : 인터페이스 처리 실패 로그 등록
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 5. 21. CBK - 최초생성
	 * </pre>
	 *
	 * @return
	 * @throws Exception
	 */
	void writeInterfaceLog(String ifId, Object reqParam, BaseResDTO resParam, CustomIfException ce);
}
