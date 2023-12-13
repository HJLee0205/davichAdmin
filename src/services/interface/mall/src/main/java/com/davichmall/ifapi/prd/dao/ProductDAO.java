package com.davichmall.ifapi.prd.dao;

import java.util.List;

import org.springframework.stereotype.Repository;

import com.davichmall.ifapi.cmmn.base.BaseDAO;
import com.davichmall.ifapi.prd.dto.BrandSearchReqDTO;
import com.davichmall.ifapi.prd.dto.BrandSearchResDTO.BrandDTO;
import com.davichmall.ifapi.prd.dto.ItmKindSearchResDTO.ItmKindDTO;
import com.davichmall.ifapi.prd.dto.ProductSearchReqDTO;
import com.davichmall.ifapi.prd.dto.ProductSearchResDTO.ProductInfoDTO;
import com.davichmall.ifapi.prd.dto.ProductStockReqDTO;

/**
 * <pre>
 * - 프로젝트명    : davichmall_interface
 * - 패키지명      : com.davichmall.ifapi.prd.dao
 * - 파일명        : ProductDAO.java
 * - 작성일        : 2018. 5. 18.
 * - 작성자        : CBK
 * - 설명          : 상품분류의 인터페이스 처리를 위한 DAO
 * </pre>
 */
@Repository("productDao")
public class ProductDAO extends BaseDAO {
	
	/**
	 * <pre>
	 * 작성일 : 2018. 5. 18.
	 * 작성자 : CBK
	 * 설명   : 상품목록 조회 (ERP)
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 5. 18. CBK - 최초생성
	 * </pre>
	 *
	 * @return
	 * @throws Exception
	 */
	public List<ProductInfoDTO> getProductList(ProductSearchReqDTO param) throws Exception {
		return sqlSession2.selectList("product.selectProductList", param);
	}
	
	/**
	 * <pre>
	 * 작성일 : 2018. 5. 18.
	 * 작성자 : CBK
	 * 설명   : 상품목록 건수 조회(ERP)
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 5. 18. CBK - 최초생성
	 * </pre>
	 *
	 * @return
	 * @throws Exception
	 */
	public int countProductList(ProductSearchReqDTO param) throws Exception {
		return sqlSession2.selectOne("product.countProductList", param);
	}

	/**
	 * <pre>
	 * 작성일 : 2018. 5. 18.
	 * 작성자 : CBK
	 * 설명   : 상품 재고 조회(ERP)
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 5. 18. CBK - 최초생성
	 * </pre>
	 *
	 * @return
	 * @throws Exception
	 */
	public int selectProductStock(ProductStockReqDTO param) throws Exception {
		return sqlSession2.selectOne("product.selectProductStock", param);
	}
	
	/**
	 * <pre>
	 * 작성일 : 2018. 5. 31.
	 * 작성자 : CBK
	 * 설명   : 브랜드 목록 검색
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 5. 31. CBK - 최초생성
	 * </pre>
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public List<BrandDTO> getBrandList(BrandSearchReqDTO param) throws Exception {
		return sqlSession2.selectList("product.selectBrandList", param);
	}
	
	/**
	 * <pre>
	 * 작성일 : 2018. 5. 31.
	 * 작성자 : CBK
	 * 설명   : 상품분류 목록 조회
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 5. 31. CBK - 최초생성
	 * </pre>
	 *
	 * @return
	 * @throws Exception
	 */
	public List<ItmKindDTO> getItmKindLis() throws Exception {
		return sqlSession2.selectList("product.selectItmKindList");
	}
	

}
