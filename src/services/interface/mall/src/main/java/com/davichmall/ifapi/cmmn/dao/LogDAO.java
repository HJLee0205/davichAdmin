package com.davichmall.ifapi.cmmn.dao;

import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Repository;

import com.davichmall.ifapi.cmmn.base.BaseDAO;
import com.davichmall.ifapi.util.StringUtil;

/**
 * <pre>
 * - 프로젝트명    : davichmall_interface
 * - 패키지명      : com.davichmall.ifapi.cmmn.dao
 * - 파일명        : LogDAO.java
 * - 작성일        : 2018. 5. 18.
 * - 작성자        : CBK
 * - 설명          : 인터페이스 로그 처리를 위한 DAO
 * </pre>
 */
@Repository("logDao")
public class LogDAO extends BaseDAO {

	// DB charSet
    @Value(value = "#{datasource_if['mall.database.charset']}")
    private String dbCharset;

	/**
	 * <pre>
	 * 작성일 : 2018. 5. 18.
	 * 작성자 : CBK
	 * 설명   : 처리 로그 저장
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 5. 18. CBK - 최초생성
	 * </pre>
	 *
	 * @return
	 * @throws Exception
	 */
	public void insertInterfaceLog(String ifId, String reqParam, String resParam, String errMsg) throws Exception {
		Map<String, String> param = new HashMap<String, String>();

		reqParam = StringUtil.getMaxByteString(reqParam, 4000, dbCharset);
		resParam = StringUtil.getMaxByteString(resParam, 4000, dbCharset);
		errMsg = StringUtil.getMaxByteString(errMsg, 4000, dbCharset);
		
		param.put("seq", sqlSession1.selectOne("log.getNextSeq").toString());
		param.put("interfaceId", ifId);
		param.put("reqParam", reqParam);
		param.put("resParam", resParam);
		param.put("errMsg", errMsg);
		
		sqlSession1.insert("log.insertInterfaceLog", param);

	}
}
