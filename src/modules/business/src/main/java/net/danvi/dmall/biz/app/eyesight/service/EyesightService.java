package net.danvi.dmall.biz.app.eyesight.service;

import java.util.Map;

import net.danvi.dmall.biz.app.eyesight.model.EyesightPO;
import net.danvi.dmall.biz.app.eyesight.model.EyesightVO;

/**
 * <pre>
 * - 프로젝트명    : 03.business
 * - 패키지명      : net.danvi.dmall.biz.app.eyesight.service
 * - 파일명        : EyesightService.java
 * - 작성일        : 2018. 7. 6.
 * - 작성자        : CBK
 * - 설명          : 마이페이지 - 시력 처리 Service
 * </pre>
 */
public interface EyesightService {

	/**
	 * <pre>
	 * 작성일 : 2018. 7. 6.
	 * 작성자 : CBK
	 * 설명   : 시력정보 조회
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 7. 6. CBK - 최초생성
	 * </pre>
	 *
	 * @param memberNo
	 * @return
	 * @throws Exception
	 */
	EyesightVO selectEyesightInfo(Long memberNo) throws Exception;
	
	
	/**
	 * <pre>
	 * 작성일 : 2018. 7. 6.
	 * 작성자 : CBK
	 * 설명   : 시력 등록/수정
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 7. 6. CBK - 최초생성
	 * </pre>
	 *
	 * @param po
	 * @throws Exception
	 */
	void insertOrUpdateEyesightInfo(EyesightPO po) throws Exception;
	
	/**
	 * <pre>
	 * 작성일 : 2018. 7. 6.
	 * 작성자 : CBK
	 * 설명   : 통합회원 여부 확인
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 7. 6. CBK - 최초생성
	 * </pre>
	 *
	 * @param memberNo
	 * @return
	 * @throws Exception
	 */
	boolean checkCombinedMember(Long memberNo) throws Exception;
	
	/**
	 * <pre>
	 * 작성일 : 2018. 7. 6.
	 * 작성자 : CBK
	 * 설명   : 안경점(다비젼) 시력 정보 조회
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 7. 6. CBK - 최초생성
	 * </pre>
	 *
	 * @param memberNo
	 * @return
	 * @throws Exception
	 */
	Map<String, Object> getStoreEyesightInfo(Long memberNo) throws Exception;
	
}
