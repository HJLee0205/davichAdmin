package com.davichmall.ifapi.visit.service.impl;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.davichmall.ifapi.visit.dao.VisitDAO;
import com.davichmall.ifapi.visit.dto.KioskLoginCheckReqDTO;
import com.davichmall.ifapi.visit.dto.VisitInfoRegReqDTO;
import com.davichmall.ifapi.visit.dto.VisitStatusMdfyReqDTO;
import com.davichmall.ifapi.visit.service.VisitService;

/**
 * <pre>
 * - 프로젝트명    : davichmall_interface
 * - 패키지명      : com.davichmall.ifapi.visit.service.impl
 * - 파일명        : VisitServiceImpl.java
 * - 작성일        : 2018. 8. 6.
 * - 작성자        : CBK
 * - 설명          : 고객방문 정보 처리 Service(키오스크/전광판)
 * </pre>
 */
@Service("visitService")
public class VisitServiceImpl implements VisitService {

	@Resource(name="visitDao")
	VisitDAO visitDao;
	
	/**
	 * 키오스크 로그인 정보 체크
	 */
	public String checkKioskLoginInfo(KioskLoginCheckReqDTO param) throws Exception {
		return visitDao.countErpLoginInfo(param) == 0 ? "N" : "Y";
	}
	
	/**
	 * 고객 방문 정보를 다비젼에 등록
	 */
	@Override
	public void insertVisitInfo(VisitInfoRegReqDTO param) throws Exception {
		visitDao.insertVisitInfo(param);
	}
	
	/**
	 * 고객 상태를 다비젼에 갱신
	 */
	@Override
	public void updateErpVisitStatus(VisitStatusMdfyReqDTO param) throws Exception {
		visitDao.updateErpVisitStatus(param);
	}

	/**
	 * 고객 상태를 키오스크에 갱신
	 */
	@Override
	public void updateKioskVisitStatus(VisitStatusMdfyReqDTO param) throws Exception {
		visitDao.updateKioskVisitStatus(param);
	}

}
