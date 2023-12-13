package net.danvi.dmall.biz.ifapi.visit.service;

import net.danvi.dmall.biz.ifapi.visit.dto.KioskLoginCheckReqDTO;
import net.danvi.dmall.biz.ifapi.visit.dto.VisitInfoRegReqDTO;
import net.danvi.dmall.biz.ifapi.visit.dto.VisitStatusMdfyReqDTO;

/**
 * <pre>
 * - 프로젝트명    : davichmall_interface
 * - 패키지명      : net.danvi.dmall.admin.ifapi.visit.service
 * - 파일명        : VisitService.java
 * - 작성일        : 2018. 8. 6.
 * - 작성자        : CBK
 * - 설명          : 고객방문 정보 처리 Service(키오스크/전광판)
 * </pre>
 */
public interface VisitService {
	
	/**
	 * <pre>
	 * 작성일 : 2018. 8. 6.
	 * 작성자 : CBK
	 * 설명   : 고객 방문 정보를 다비젼에 등록
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 8. 6. CBK - 최초생성
	 * </pre>
	 *
	 * @param param
	 * @throws Exception
	 */
	void insertVisitInfo(VisitInfoRegReqDTO param) throws Exception;
	
	/**
	 * <pre>
	 * 작성일 : 2018. 8. 6.
	 * 작성자 : CBK
	 * 설명   : 고객 상태를 다비젼에 갱신
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 8. 6. CBK - 최초생성
	 * </pre>
	 *
	 * @param param
	 * @throws Exception
	 */
	void updateErpVisitStatus(VisitStatusMdfyReqDTO param) throws Exception;
	
	/**
	 * <pre>
	 * 작성일 : 2018. 8. 6.
	 * 작성자 : CBK
	 * 설명   : 고객 상태를 키오스크에 갱신
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 8. 6. CBK - 최초생성
	 * </pre>
	 *
	 * @param param
	 * @throws Exception
	 */
	void updateKioskVisitStatus(VisitStatusMdfyReqDTO param) throws Exception;
}
