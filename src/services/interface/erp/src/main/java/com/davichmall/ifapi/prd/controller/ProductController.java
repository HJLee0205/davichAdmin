package com.davichmall.ifapi.prd.controller;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.davichmall.ifapi.cmmn.CustomException;
import com.davichmall.ifapi.cmmn.base.BaseController;
import com.davichmall.ifapi.cmmn.base.BaseReqDTO;
import com.davichmall.ifapi.cmmn.constant.Constants;
import com.davichmall.ifapi.prd.dto.BrandSearchReqDTO;
import com.davichmall.ifapi.prd.dto.BrandSearchResDTO;
import com.davichmall.ifapi.prd.dto.ItmKindSearchResDTO;
import com.davichmall.ifapi.prd.dto.ProductMappingBundleReqDTO;
import com.davichmall.ifapi.prd.dto.ProductMappingReqDTO;
import com.davichmall.ifapi.prd.dto.ProductSearchReqDTO;
import com.davichmall.ifapi.prd.dto.ProductSearchResDTO;
import com.davichmall.ifapi.prd.dto.ProductSearchResDTO.ProductInfoDTO;
import com.davichmall.ifapi.prd.dto.ProductStockReqDTO;
import com.davichmall.ifapi.prd.dto.ProductStockResDTO;
import com.davichmall.ifapi.prd.service.ProductService;

/**
 * <pre>
 * - 프로젝트명    : davichmall_interface
 * - 패키지명      : com.davichmall.ifapi.prd.controller
 * - 파일명        : ProductController.java
 * - 작성일        : 2018. 5. 18.
 * - 작성자        : CBK
 * - 설명          : [상품]분류의 인터페이스 처리를 위한 Controller
 * </pre>
 */
@Controller
public class ProductController extends BaseController {
	
	@Resource(name="productService")
	ProductService productService;

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
	@RequestMapping(value="/" + Constants.IFID.PRODUCT_SEARCH)
	public @ResponseBody String searchProducts(@ModelAttribute ProductSearchReqDTO param) throws Exception {
		
		String ifId = Constants.IFID.PRODUCT_SEARCH;
		
		try {
			// ERP 처리부분
			
			// ResponseDTO 생성
			ProductSearchResDTO resDto = new ProductSearchResDTO();
			resDto.setResult(Constants.RESULT.SUCCESS);
			resDto.setMessage("");
			
			// 상품목록
			List<ProductInfoDTO> prdList = productService.getProductList(param);
			if(prdList.size() > 100) {
				prdList = prdList.subList(0, 10);
			}
			resDto.setPrdList(prdList);
			
			// 목록개수
			resDto.setTotalCnt(productService.countProductList(param));
			
			logService.writeInterfaceLog(ifId, param, resDto);
			
			return toJsonRes(resDto, param);
		} catch (CustomException ce) {
			ce.setReqParam(param);
			ce.setIfId(ifId);
			throw ce;
		} catch (Exception e) {
			e.printStackTrace();
			throw new CustomException(e, param, ifId);
		}
	}
	
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
	@RequestMapping(value="/" + Constants.IFID.PRODUCT_STOCK)
	public @ResponseBody String getProductStock(ProductStockReqDTO param) throws Exception {

		String ifId = Constants.IFID.PRODUCT_STOCK;
		
		try {
			
			// ERP 처리 부분 
			// ResponseDTO 생성
			ProductStockResDTO resDto = new ProductStockResDTO();
			resDto.setResult(Constants.RESULT.SUCCESS);
			resDto.setMessage("");

			// ERP 재고 조회
			int stock = productService.selectProductStock(param);
			resDto.setQty(stock);
			
			logService.writeInterfaceLog(ifId, param, resDto);
			
			return toJsonRes(resDto, param);
			
		} catch (CustomException ce) {
			ce.setReqParam(param);
			ce.setIfId(ifId);
			throw ce;
		} catch (Exception e) {
			throw new CustomException(e, param, ifId);
		}
	}
	
	/**
	 * <pre>
	 * 작성일 : 2018. 5. 21.
	 * 작성자 : CBK
	 * 설명   : 쇼핑몰 - ERP 상품코드 매핑정보 등록
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 5. 21. CBK - 최초생성
	 * </pre>
	 *
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/" + Constants.IFID.PRODUCT_MAPPING_REG)
	public @ResponseBody String insertProductMapping(ProductMappingReqDTO param) throws Exception {

		String ifId = Constants.IFID.PRODUCT_MAPPING_REG;
		
		// ERP에서는 이 메소드를 사용하지 않음
		return "";
	}
	
	/**
	 * <pre>
	 * 작성일 : 2018. 5. 23.
	 * 작성자 : CBK
	 * 설명   : 쇼핑몰 - ERP 상품코드 매핑정보 삭제
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 5. 23. CBK - 최초생성
	 * </pre>
	 *
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/" + Constants.IFID.PRODUCT_MAPPING_DEL)
	public @ResponseBody String deleteProductMapping(ProductMappingReqDTO param) throws Exception {

		String ifId = Constants.IFID.PRODUCT_MAPPING_DEL;

		// ERP에서는 이 메소드를 사용하지 않음
		return "";
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
	@RequestMapping(value="/" + Constants.IFID.BRAND_SEARCH)
	public @ResponseBody String searchBrandList(BrandSearchReqDTO param) throws Exception {

		String ifId = Constants.IFID.BRAND_SEARCH;
		
		try {
			
			// ERP처리부분
			// ResponseDTO 생성
			BrandSearchResDTO resDto = new BrandSearchResDTO();
			resDto.setResult(Constants.RESULT.SUCCESS);
			resDto.setMessage("");
			
			// 데이터 조회 및 설정
			resDto.setBrandList(productService.getBrandList(param));
			
			// 처리로그 등록
			logService.writeInterfaceLog(ifId, param, resDto);
			
			return toJsonRes(resDto, param);
			
		} catch (CustomException ce) {
			ce.setReqParam(param);
			ce.setIfId(ifId);
			throw ce;
		} catch (Exception e) {
			throw new CustomException(e, param, ifId);
		}
	}
	
	/**
	 * <pre>
	 * 작성일 : 2018. 5. 31.
	 * 작성자 : CBK
	 * 설명   : 상품 분류코드 조회
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 5. 31. CBK - 최초생성
	 * </pre>
	 *
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/" + Constants.IFID.ITM_KIND_SEARCH)
	public @ResponseBody String searchItmKindList(BaseReqDTO param) throws Exception {

		String ifId = Constants.IFID.ITM_KIND_SEARCH;
		
		try {
			
			// ERP처리부분
			// ResponseDTO 생성
			ItmKindSearchResDTO resDto = new ItmKindSearchResDTO();
			resDto.setResult(Constants.RESULT.SUCCESS);
			resDto.setMessage("");
			
			// 데이터 조회 및 설정
			resDto.setItmKindList(productService.getItmKindList());
			
			// 처리로그 등록
			logService.writeInterfaceLog(ifId, param, resDto);
			
			return toJsonRes(resDto, param);
			
		} catch (CustomException ce) {
			ce.setReqParam(param);
			ce.setIfId(ifId);
			throw ce;
		} catch (Exception e) {
			throw new CustomException(e, param, ifId);
		}
	}

	
	/**
	 * <pre>
	 * 작성일 : 2018. 8. 2.
	 * 작성자 : CBK
	 * 설명   : 쇼핑몰 - ERP 상품코드 매핑정보 등록/삭제 일괄처리 
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 8. 2. CBK - 최초생성
	 * </pre>
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/" + Constants.IFID.PRODUCT_MAPPING_BUNDLE)
	public @ResponseBody String bundleProductMapping(ProductMappingBundleReqDTO param) throws Exception {
		String ifId = Constants.IFID.PRODUCT_MAPPING_BUNDLE;

		// ERP에서는 이 메소드를 사용하지 않음
		
		return null;
	}	
	
	
}
