package net.danvi.dmall.biz.app.prescription.service;

import java.util.List;

import org.springframework.stereotype.Service;

import dmall.framework.common.BaseService;
import dmall.framework.common.constants.MapperConstants;
import net.danvi.dmall.biz.app.prescription.model.PrescriptionPO;
import net.danvi.dmall.biz.app.prescription.model.PrescriptionVO;

/**
 * <pre>
 * - 프로젝트명    : 03.business
 * - 패키지명      : net.danvi.dmall.biz.app.prescription.service
 * - 파일명        : PrescriptionServiceImpl.java
 * - 작성일        : 2018. 7. 9.
 * - 작성자        : CBK
 * - 설명          : 마이페이지 - 처방전 처리 Service
 * </pre>
 */
@Service("prescriptionService")
public class PrescriptionServiceImpl extends BaseService implements PrescriptionService {

	/**
	 * 처방전 목록 조회
	 */
	@Override
	public List<PrescriptionVO> selectPrescriptionList(Long memberNo) throws Exception {
		PrescriptionPO po = new PrescriptionPO();
		po.setMemberNo(memberNo);
		return proxyDao.selectList(MapperConstants.PRESCRIPTION + "selectPrecription", po);
	}
	
	/**
	 * 처방전 정보 조회
	 */
	@Override
	public PrescriptionVO selectPrescription(Long memberNo, Integer prescriptionNo) throws Exception {
		PrescriptionPO po = new PrescriptionPO();
		po.setMemberNo(memberNo);
		po.setPrescriptionNo(prescriptionNo);
		return proxyDao.selectOne(MapperConstants.PRESCRIPTION + "selectPrecription", po);
	}

	/**
	 * 등록된 처방전 개수 조회
	 */
	@Override
	public int countPrescriptionList(Long memberNo) throws Exception {
		return proxyDao.selectOne(MapperConstants.PRESCRIPTION + "countPrescriptionList", memberNo);
	}

	/**
	 * 처방전 등록
	 */
	@Override
	public void insertPrescription(PrescriptionPO po) throws Exception {
		// 처방전 번호 조회
		int prescriptionNo = proxyDao.selectOne(MapperConstants.PRESCRIPTION + "selectMaxPrescriptionNo", po.getMemberNo());
		po.setPrescriptionNo(prescriptionNo);
		
		// 처방전 등록
		proxyDao.insert(MapperConstants.PRESCRIPTION + "insertPrescription", po);
	}

	/**
	 * 처방전 삭제
	 */
	@Override
	public int deletePrescription(PrescriptionPO po) throws Exception {
		return proxyDao.update(MapperConstants.PRESCRIPTION + "deletePrescription", po);
	}

	
}
