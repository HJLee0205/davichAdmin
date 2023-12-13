package net.danvi.dmall.biz.ifapi.prd.service;

import java.util.List;

import net.danvi.dmall.biz.ifapi.prd.dto.BrandSearchReqDTO;
import net.danvi.dmall.biz.ifapi.prd.dto.BrandSearchResDTO.BrandDTO;
import net.danvi.dmall.biz.ifapi.prd.dto.ItmKindSearchResDTO.ItmKindDTO;
import net.danvi.dmall.biz.ifapi.prd.dto.ProductMappingBundleReqDTO;
import net.danvi.dmall.biz.ifapi.prd.dto.ProductSearchReqDTO;
import net.danvi.dmall.biz.ifapi.prd.dto.ProductSearchResDTO.ProductInfoDTO;
import net.danvi.dmall.biz.ifapi.prd.dto.ProductStockReqDTO;

/**
 * <pre>
 * - 프로젝트명    : davichmall_interface
 * - 패키지명      : net.danvi.dmall.admin.ifapi.prd.service
 * - 파일명        : ProductService.java
 * - 작성일        : 2018. 5. 18.
 * - 작성자        : CBK
 * - 설명          : [상품]분류의 인터페이스 처리를 위한 Service
 * </pre>
 */
public interface ProductService {

	/**
	 * <pre>
	 * 작성일 : 2018. 5. 18.
	 * 작성자 : CBK
	 * 설명   : 상품검색
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 5. 18. CBK - 최초생성
	 * </pre>
	 *
	 * @return
	 * @throws Exception
	 */
	List<ProductInfoDTO> getProductList(ProductSearchReqDTO param) throws Exception;
	
	/**
	 * <pre>
	 * 작성일 : 2018. 5. 18.
	 * 작성자 : CBK
	 * 설명   : 상품목록 개수 조회
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 5. 18. CBK - 최초생성
	 * </pre>
	 *
	 * @return
	 * @throws Exception
	 */
	int countProductList(ProductSearchReqDTO param) throws Exception;
	
	/**
	 * <pre>
	 * 작성일 : 2018. 5. 18.
	 * 작성자 : CBK
	 * 설명   : 상품 재고 조회
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 5. 18. CBK - 최초생성
	 * </pre>
	 *
	 * @return
	 * @throws Exception
	 */
	int selectProductStock(ProductStockReqDTO param) throws Exception;

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
	List<BrandDTO> getBrandList(BrandSearchReqDTO param) throws Exception;
	
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
	List<ItmKindDTO> getItmKindList() throws Exception;
	
	/**
	 * <pre>
	 * 작성일 : 2018. 8. 2.
	 * 작성자 : CBK
	 * 설명   : 상품 매핑 정보 등록/삭제 일괄처리
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 8. 2. CBK - 최초생성
	 * </pre>
	 *
	 * @param param
	 * @throws Exception
	 */
	void bundleProductMapping(ProductMappingBundleReqDTO param) throws Exception;

	/**
	 * <pre>
	 * 작성일 : 2023. 03. 29.
	 * 작성자 : slims
	 * 설명   : 상품 filter 검색
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2023. 03. 29. slims - 최초생성
	 * </pre>
	 *
	 * @return
	 * @throws Exception
	 */
	List<ProductInfoDTO> getProductFilterList(ProductSearchReqDTO param) throws Exception;
}
