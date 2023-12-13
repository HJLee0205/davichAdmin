package com.davichmall.ifapi.visit.service;

import com.davichmall.ifapi.visit.dto.KioskLoginCheckReqDTO;
import com.davichmall.ifapi.visit.dto.VisitInfoRegReqDTO;
import com.davichmall.ifapi.visit.dto.VisitStatusMdfyReqDTO;

/**
 * <pre>
 * - 프로젝트명    : davichmall_interface
 * - 패키지명      : com.davichmall.ifapi.visit.service
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
	 * 설명   : 키오스크 로그인 정보 체크
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 8. 6. CBK - 최초생성
	 * </pre>
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */
	String checkKioskLoginInfo(KioskLoginCheckReqDTO param) throws Exception;
	
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
