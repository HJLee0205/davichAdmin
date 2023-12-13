package net.danvi.dmall.biz.ifapi.prd.service.impl;

import java.util.List;

import javax.annotation.Resource;

import dmall.framework.common.BaseService;
import lombok.extern.slf4j.Slf4j;
import net.danvi.dmall.biz.ifapi.cmmn.mapp.service.MappingService;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import net.danvi.dmall.biz.ifapi.prd.dto.BrandSearchReqDTO;
import net.danvi.dmall.biz.ifapi.prd.dto.BrandSearchResDTO.BrandDTO;
import net.danvi.dmall.biz.ifapi.prd.dto.ItmKindSearchResDTO.ItmKindDTO;
import net.danvi.dmall.biz.ifapi.prd.dto.ProductMappingBundleReqDTO;
import net.danvi.dmall.biz.ifapi.prd.dto.ProductMappingReqDTO;
import net.danvi.dmall.biz.ifapi.prd.dto.ProductSearchReqDTO;
import net.danvi.dmall.biz.ifapi.prd.dto.ProductSearchResDTO.ProductInfoDTO;
import net.danvi.dmall.biz.ifapi.prd.dto.ProductStockReqDTO;
import net.danvi.dmall.biz.ifapi.prd.service.ProductService;

/**
 * <pre>
 * - 프로젝트명   : davichmall_interface
 * - 패키지명     : net.danvi.dmall.admin.ifapi.prd.service.impl
 * - 파일명       : ProductServiceImpl.java
 * - 작성일       : 2018. 5. 18.
 * - 작성자       : CBK
 * - 설명         : [상품]분류의 인터페이스 처리를 위한 Service
 * </pre>
 */
@Slf4j
@Service("productService")
@Transactional(rollbackFor = Exception.class)
public class ProductServiceImpl extends BaseService implements ProductService {
	
	@Resource(name="mappingService")
	public MappingService mappingService;
	
	/**
	 * 상품목록검색
	 */
	@Override
	public List<ProductInfoDTO> getProductList(ProductSearchReqDTO param) throws Exception {
		return proxyDao.selectList("product.selectProductList", param);
	}

	/**
	 * 상품목록 건수조회
	 */
	@Override
	public int countProductList(ProductSearchReqDTO param) throws Exception {
		return proxyDao.selectOne("product.countProductList", param);
	}

	/**
	 * 상품 재고 조회
	 */
	@Override
	public int selectProductStock(ProductStockReqDTO param) throws Exception {
		return proxyDao.selectOne("product.selectProductStock", param);
	}
	
	/**
	 * 브랜드 목록 검색
	 */
	@Override
	public List<BrandDTO> getBrandList(BrandSearchReqDTO param) throws Exception {
		return proxyDao.selectList("product.selectBrandList", param);
	}

	/**
	 * 상품분류 목록 조회
	 */
	@Override
	public List<ItmKindDTO> getItmKindList() throws Exception {
		return proxyDao.selectList("product.selectItmKindList");
	}

	/**
	 * 상품 매핑 정보 등록/삭제 일괄처리
	 */
	@Override
//	@Transactional(transactionManager="transactionManager1")
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

	@Override
	public List<ProductInfoDTO> getProductFilterList(ProductSearchReqDTO param) throws Exception {
		return null;
	}

}
