package com.davichmall.ifapi.sell.dao;

import java.util.List;

import org.springframework.stereotype.Repository;

import com.davichmall.ifapi.cmmn.base.BaseDAO;
import com.davichmall.ifapi.sell.dto.OfflineBuyInfoReqDTO;
import com.davichmall.ifapi.sell.dto.OfflineBuyInfoResDTO.OfflineBuyInfoDTO;

/**
 * <pre>
 * - 프로젝트명    : davichmall_interface
 * - 패키지명      : com.davichmall.ifapi.sell.dao
 * - 파일명        : SellDAO.java
 * - 작성일        : 2018. 5. 17.
 * - 작성자        : CBK
 * - 설명          : [판매]분류의 인터페이스 처리를 위한 DAO
 * </pre>
 */
@Repository("sellDao")
public class SellDAO extends BaseDAO {
	
	/**
	 * <pre>
	 * 작성일 : 2018. 5. 18.
	 * 작성자 : CBK
	 * 설명   : 오프라인 구매 내역 조회
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 5. 18. CBK - 최초생성
	 * </pre>
	 *
	 * @return
	 * @throws Exception
	 */
	public List<OfflineBuyInfoDTO> selectOfflineBuyInfoList(OfflineBuyInfoReqDTO param) throws Exception {
		return sqlSession2.selectList("sell.selectOfflineBuyInfoList", param);
	}
	
	/**
	 * <pre>
	 * 작성일 : 2018. 5. 18.
	 * 작성자 : CBK
	 * 설명   : 오프라인 구매 내역 개수 조회
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 5. 18. CBK - 최초생성
	 * </pre>
	 *
	 * @return
	 * @throws Exception
	 */
	public int countOfflineBuyInfoList(OfflineBuyInfoReqDTO param) throws Exception {
		return sqlSession2.selectOne("sell.countOfflineBuyInfoList", param);
	}
	
}
