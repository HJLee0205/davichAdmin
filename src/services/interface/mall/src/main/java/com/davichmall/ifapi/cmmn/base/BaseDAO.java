package com.davichmall.ifapi.cmmn.base;

import javax.annotation.Resource;

import org.apache.ibatis.session.SqlSession;

/**
 * <pre>
 * - 프로젝트명    : davichmall_interface
 * - 패키지명      : com.davichmall.ifapi.cmmn.base
 * - 파일명        : BaseDAO.java
 * - 작성일        : 2018. 5. 18.
 * - 작성자        : CBK
 * - 설명          : DAO에서 공통으로 사용하는 부분. DAO들은 BaseDAO를 상속받는다.
 * </pre>
 */
public class BaseDAO {
	/**
	 * 쇼핑몰 접속용
	 */
	@Resource(name="sqlSession1")
	protected SqlSession sqlSession1;
	
	/**
	 * ERP접속용
	 */
//	@Resource(name="sqlSession2")
	protected SqlSession sqlSession2;
	
}
