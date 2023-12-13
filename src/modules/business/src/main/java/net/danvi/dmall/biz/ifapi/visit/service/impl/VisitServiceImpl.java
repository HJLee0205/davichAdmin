package net.danvi.dmall.biz.ifapi.visit.service.impl;

import javax.annotation.Resource;

import dmall.framework.common.BaseService;
import net.danvi.dmall.biz.ifapi.visit.dto.VisitInfoRegReqDTO;
import net.danvi.dmall.biz.ifapi.visit.dto.VisitStatusMdfyReqDTO;
import net.danvi.dmall.biz.ifapi.visit.service.VisitService;
import org.springframework.stereotype.Service;

/**
 * <pre>
 * - 프로젝트명    : davichmall_interface
 * - 패키지명      : net.danvi.dmall.admin.ifapi.visit.service.impl
 * - 파일명        : VisitServiceImpl.java
 * - 작성일        : 2018. 8. 6.
 * - 작성자        : CBK
 * - 설명          : 고객방문 정보 처리 Service(키오스크/전광판)
 * </pre>
 */
@Service("visitService")
public class VisitServiceImpl extends BaseService implements VisitService {
	
	/**
	 * 고객 방문 정보를 다비젼에 등록
	 */
	@Override
	public void insertVisitInfo(VisitInfoRegReqDTO param) throws Exception {
		proxyDao.insert("visit.insertStoreVisitInfo", param);
	}
	
	/**
	 * 고객 상태를 다비젼에 갱신
	 */
	@Override
	public void updateErpVisitStatus(VisitStatusMdfyReqDTO param) throws Exception {
		proxyDao.update("visit.updateErpStoreVisitStatus", param);
	}

	/**
	 * 고객 상태를 키오스크에 갱신
	 */
	@Override
	public void updateKioskVisitStatus(VisitStatusMdfyReqDTO param) throws Exception {
		proxyDao.update("visit.updateKioskStoreVisitStatus", param);
	}

}
