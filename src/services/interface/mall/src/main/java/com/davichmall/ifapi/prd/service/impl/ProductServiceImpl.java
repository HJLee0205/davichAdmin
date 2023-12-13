package com.davichmall.ifapi.prd.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.davichmall.ifapi.cmmn.mapp.service.MappingService;
import com.davichmall.ifapi.prd.dao.ProductDAO;
import com.davichmall.ifapi.prd.dto.BrandSearchReqDTO;
import com.davichmall.ifapi.prd.dto.BrandSearchResDTO.BrandDTO;
import com.davichmall.ifapi.prd.dto.ItmKindSearchResDTO.ItmKindDTO;
import com.davichmall.ifapi.prd.dto.ProductMappingBundleReqDTO;
import com.davichmall.ifapi.prd.dto.ProductMappingReqDTO;
import com.davichmall.ifapi.prd.dto.ProductSearchReqDTO;
import com.davichmall.ifapi.prd.dto.ProductSearchResDTO.ProductInfoDTO;
import com.davichmall.ifapi.prd.dto.ProductStockReqDTO;
import com.davichmall.ifapi.prd.service.ProductService;

/**
 * <pre>
 * - 프로젝트명    : davichmall_interface
 * - 패키지명      : com.davichmall.ifapi.prd.service.impl
 * - 파일명        : ProductServiceImpl.java
 * - 작성일        : 2018. 5. 18.
 * - 작성자        : CBK
 * - 설명          : [상품]분류의 인터페이스 처리를 위한 Service
 * </pre>
 */
@Service("productService")
public class ProductServiceImpl implements ProductService {

	@Resource(name="productDao")
	ProductDAO productDao;
	
	@Resource(name="mappingService")
	public MappingService mappingService;
	
	/**
	 * 상품목록검색
	 */
	@Override
	public List<ProductInfoDTO> getProductList(ProductSearchReqDTO param) throws Exception {
		return productDao.getProductList(param);
	}

	/**
	 * 상품목록 건수조회
	 */
	@Override
	public int countProductList(ProductSearchReqDTO param) throws Exception {
		return productDao.countProductList(param);
	}

	/**
	 * 상품 재고 조회
	 */
	@Override
	public int selectProductStock(ProductStockReqDTO param) throws Exception {
		return productDao.selectProductStock(param);
	}
	
	/**
	 * 브랜드 목록 검색
	 */
	@Override
	public List<BrandDTO> getBrandList(BrandSearchReqDTO param) throws Exception {
		return productDao.getBrandList(param);
	}

	/**
	 * 상품분류 목록 조회
	 */
	@Override
	public List<ItmKindDTO> getItmKindList() throws Exception {
		return productDao.getItmKindLis();
	}

	/**
	 * 상품 매핑 정보 등록/삭제 일괄처리
	 */
	@Override
	@Transactional(transactionManager="transactionManager1")
	public void bundleProductMapping(ProductMappingBundleReqDTO param) throws Exception {
		// 삭제
		if(param.getDeleteList() != null && param.getDeleteList().size() > 0) {
			for(ProductMappingReqDTO delDto : param.getDeleteList()) {
				mappingService.deleteItemCodeMap(delDto.getMallGoodsNo(), delDto.getMallItmCode());
			}
		}
		
		// 등록
		if(param.getInsertList() != null && param.getInsertList().size() > 0) {
			for(ProductMappingReqDTO insDto : param.getInsertList()) {
				mappingService.insertItemCodeMap(insDto.getMallGoodsNo(), insDto.getMallItmCode(), insDto.getErpItmCode().trim());
			}
		}
	}

}
