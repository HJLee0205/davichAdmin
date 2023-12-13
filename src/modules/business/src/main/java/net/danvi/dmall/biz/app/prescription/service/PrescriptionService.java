package net.danvi.dmall.biz.app.prescription.service;

import java.util.List;

import net.danvi.dmall.biz.app.prescription.model.PrescriptionPO;
import net.danvi.dmall.biz.app.prescription.model.PrescriptionVO;

/**
 * <pre>
 * - 프로젝트명    : 03.business
 * - 패키지명      : net.danvi.dmall.biz.app.prescription.service
 * - 파일명        : PrescriptionService.java
 * - 작성일        : 2018. 7. 9.
 * - 작성자        : CBK
 * - 설명          : 마이페이지 - 처방전 처리 Service
 * </pre>
 */
public interface PrescriptionService {

	/**
	 * <pre>
	 * 작성일 : 2018. 7. 9.
	 * 작성자 : CBK
	 * 설명   : 처방전 목록 조회
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 7. 9. CBK - 최초생성
	 * </pre>
	 *
	 * @param memberNo
	 * @return
	 * @throws Exception
	 */
	List<PrescriptionVO> selectPrescriptionList(Long memberNo) throws Exception;
	
	/**
	 * <pre>
	 * 작성일 : 2018. 7. 10.
	 * 작성자 : CBK
	 * 설명   : 처방전 정보 조회
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 7. 10. CBK - 최초생성
	 * </pre>
	 *
	 * @param memberNo
	 * @param prescriptionNo
	 * @return
	 * @throws Exception
	 */
	PrescriptionVO selectPrescription(Long memberNo, Integer prescriptionNo) throws Exception;
	
	/**
	 * <pre>
	 * 작성일 : 2018. 7. 9.
	 * 작성자 : CBK
	 * 설명   : 등록된 처방전 개수 조회
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 7. 9. CBK - 최초생성
	 * </pre>
	 *
	 * @param memberNo
	 * @return
	 * @throws Exception
	 */
	int countPrescriptionList(Long memberNo) throws Exception;
	
	/**
	 * <pre>
	 * 작성일 : 2018. 7. 9.
	 * 작성자 : CBK
	 * 설명   : 처방전 등록
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 7. 9. CBK - 최초생성
	 * </pre>
	 *
	 * @param po
	 * @throws Exception
	 */
	void insertPrescription(PrescriptionPO po) throws Exception;
	
	/**
	 * <pre>
	 * 작성일 : 2018. 7. 9.
	 * 작성자 : CBK
	 * 설명   : 처방전 삭제
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 7. 9. CBK - 최초생성
	 * </pre>
	 *
	 * @param po
	 * @return
	 * @throws Exception
	 */
	int deletePrescription(PrescriptionPO po) throws Exception;
}
