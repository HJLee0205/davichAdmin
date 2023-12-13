package net.danvi.dmall.biz.app.vision.service;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import dmall.framework.common.model.ResultModel;
import net.danvi.dmall.biz.app.operation.model.AtchFilePO;
import net.danvi.dmall.biz.app.operation.model.AtchFileVO;
import net.danvi.dmall.biz.app.vision.model.VisionCheckCdPO;
import net.danvi.dmall.biz.app.vision.model.VisionCheckContactPO;
import net.danvi.dmall.biz.app.vision.model.VisionCheckDscrtVO;
import net.danvi.dmall.biz.app.vision.model.VisionCheckGlassesPO;
import net.danvi.dmall.biz.app.vision.model.VisionCheckResultVO;
import net.danvi.dmall.biz.app.vision.model.VisionCheckSO;
import net.danvi.dmall.biz.app.vision.model.VisionCheckVO;
import net.danvi.dmall.biz.app.vision.model.VisionGunVO;
import net.danvi.dmall.biz.app.vision.model.VisionStepVO;
import net.danvi.dmall.biz.app.vision.model.VisionVO;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2018. 7. 24.
 * 작성자     : yji
 * 설명       : 비전체크 서비스 인터페이스
 * </pre>
 */
public interface VisionCheckService {
	 public List<VisionCheckDscrtVO> selectVisonCheckDscrtList(VisionVO vo);
	 public List<VisionCheckDscrtVO> selectVisonCheckDscrtList2(VisionStepVO vo);
	 public void insertVisionCheck(VisionCheckVO visionCheckVO);
	 public void deleteVisionCheck(VisionCheckVO visionCheckVO);
	 public List<VisionCheckVO> selectVisionCheckList(VisionCheckVO visionCheckVO);
	 public List<VisionCheckVO> selectPoMatrAjax(VisionCheckSO so);
	 public List<VisionCheckVO> selectLifeStyleAjax(VisionCheckSO so);
	 public List<VisionCheckVO> selectContactAjax(VisionCheckSO so);
	 
	 public List<VisionStepVO> selectVisionAge(VisionStepVO vo);
	 public List<VisionStepVO> selectVisionStep1(VisionStepVO vo);
	 public List<VisionStepVO> selectVisionStep2(VisionStepVO vo);
	 public List<VisionStepVO> selectVisionStep3(VisionStepVO vo);
	 public List<VisionStepVO> selectVisionStep4(VisionStepVO vo);
	 public List<VisionStepVO> selectVisionStep4g(VisionStepVO vo);
	 public List<VisionStepVO> selectVisionStep5(VisionStepVO vo);
	 public List<VisionStepVO> selectVisionStep5c(VisionStepVO vo);
	 public List<VisionStepVO> selectVisionStep10(VisionStepVO vo);
	 
	 public List<VisionStepVO> selectStepNm(VisionStepVO vo);
	 
	 public int insertVisionCheckGun(VisionGunVO vo) throws Exception;
	 public List<VisionGunVO> selectVisionCheckGunList(VisionGunVO vo) throws Exception;
	 public ResultModel<VisionGunVO> selectVisionCheckGun(VisionGunVO vo) throws Exception;
	 ResultModel<VisionGunVO> updateVisionCheckGun(VisionGunVO vo, HttpServletRequest request) throws Exception;
	 ResultModel<AtchFilePO> insertAtchFile(HttpServletRequest request, VisionGunVO vo) throws Exception;
	 ResultModel<AtchFilePO> deleteAtchFile(AtchFilePO po) throws Exception ;
	 
	 public List<VisionCheckCdPO> selectVisionCheckCD(VisionCheckCdPO po) throws Exception;
	 public List<VisionCheckCdPO> selectVisionCheckRecommTestGr(VisionCheckCdPO po) throws Exception;
	 public List<VisionCheckCdPO> selectVisionCheckRecommCmntGr(VisionCheckCdPO po) throws Exception;
	 public List<VisionCheckCdPO> selectVisionCheckRecommTestCr(VisionCheckCdPO po) throws Exception;
	 public List<VisionCheckCdPO> selectVisionCheckResult(VisionCheckCdPO po) throws Exception;
	 public List<VisionGunVO> selectVisionCheckGunInGlasses(VisionCheckGlassesPO po) throws Exception;
	 public List<VisionGunVO> selectVisionCheckGunInContact(VisionCheckContactPO po) throws Exception;
	 public List<AtchFileVO> selectVisionCheckGunImage(int lettNo) throws Exception;
	 
	 public void insertVisionCheckResult(VisionCheckResultVO vo)  throws Exception;
	 public void deleteVisionCheckResult(VisionCheckResultVO vo)  throws Exception;
	 
	 public VisionCheckResultVO selectVisionCheck2Result(VisionCheckResultVO vo)  throws Exception;
	 
}
