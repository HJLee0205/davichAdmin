package com.davichmall.ifapi.visit.dao;

import org.springframework.stereotype.Repository;

import com.davichmall.ifapi.cmmn.base.BaseDAO;
import com.davichmall.ifapi.visit.dto.KioskLoginCheckReqDTO;
import com.davichmall.ifapi.visit.dto.VisitInfoRegReqDTO;
import com.davichmall.ifapi.visit.dto.VisitStatusMdfyReqDTO;

/**
 * <pre>
 * - 프로젝트명    : davichmall_interface
 * - 패키지명      : com.davichmall.ifapi.visit.dao
 * - 파일명        : VisitDAO.java
 * - 작성일        : 2018. 8. 6.
 * - 작성자        : CBK
 * - 설명          : 고객방문 정보 처리 DAO(키오스크/전광판)
 * </pre>
 */
@Repository("visitDao")
public class VisitDAO extends BaseDAO {
	
	/**
	 * <pre>
	 * 작성일 : 2018. 8. 6.
	 * 작성자 : CBK
	 * 설명   : 로그인 정보 개수
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
	public int countErpLoginInfo(KioskLoginCheckReqDTO param) throws Exception {
		return sqlSession2.selectOne("visit.countErpLoginInfo", param);
	}

	/**
	 * <pre>
	 * 작성일 : 2018. 8. 6.
	 * 작성자 : CBK
	 * 설명   : 고객 방문 정보를 다비젼 DB에 등록
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 8. 6. CBK - 최초생성
	 * </pre>
	 *
	 * @param param
	 * @throws Exception
	 */
	public void insertVisitInfo(VisitInfoRegReqDTO param) throws Exception {
		sqlSession2.insert("visit.insertStoreVisitInfo", param);
	}
	
	/**
	 * <pre>
	 * 작성일 : 2018. 8. 6.
	 * 작성자 : CBK
	 * 설명   : 고객 상태를 다비젼 DB에 갱신
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 8. 6. CBK - 최초생성
	 * </pre>
	 *
	 * @param param
	 * @throws Exception
	 */
	public void updateErpVisitStatus(VisitStatusMdfyReqDTO param) throws Exception {
		sqlSession2.update("visit.updateErpStoreVisitStatus", param);
	}
	
	/**
	 * <pre>
	 * 작성일 : 2018. 8. 6.
	 * 작성자 : CBK
	 * 설명   : 고객 상태를 키오스크 DB에 등록
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 8. 6. CBK - 최초생성
	 * </pre>
	 *
	 * @param param
	 * @throws Exception
	 */
	public void updateKioskVisitStatus(VisitStatusMdfyReqDTO param) throws Exception {
		sqlSession1.update("visit.updateKioskStoreVisitStatus", param);
	}
}
