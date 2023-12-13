package net.danvi.dmall.biz.ifapi.prd.dto;

import java.util.List;

import net.danvi.dmall.biz.ifapi.cmmn.base.BaseResDTO;

import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * <pre>
 * - 프로젝트명    : davichmall_interface
 * - 패키지명      : net.danvi.dmall.admin.ifapi.prd.dto
 * - 파일명        : ProductSearchResDTO.java
 * - 작성일        : 2018. 5. 18.
 * - 작성자        : CBK
 * - 설명          : 상품조회 응답 DTO
 * </pre>
 */
@Data
@EqualsAndHashCode(callSuper=false)
public class ProductSearchResDTO extends BaseResDTO {

	/**
	 * 데이터 총 개수
	 */
	private int totalCnt = 0;
	
	/**
	 * 상품리스트
	 */
	private List<ProductInfoDTO> prdList;
	
	/**
	 * 상품정보 DTO
	 * (상품조회응답DTO에서 List형태로 담기 위한 DTO)
	 */
	@Data
	public static class ProductInfoDTO {
		String itmCode;
		String itmName;
		String stdPrc;
		String clsName;
		String makCode;
		String makName;
		String brand;
		String brandCode;
		String focusName;
		String refractionName;
		Float sph;
		Float cyl;
		String useInd;/*0:취급, 1:취급중지*/
		String ordRute;/*4번 재고 일때 물류 재고 연동*/
		String cprc;/*원가*/
		String supplyPrc;/*공급가*/
		String salePrc;/*판매가*/
		String jego;/*물류재고*/

		String myfaceCodeShape;/*얼굴형*/
		String myfaceCodeTone;/*피부톤*/
		String myfaceCodeStyle;/*스타일*/

		String myeyeCodeShape;/*모양*/
		String myeyeCodeSize;/*사이즈*/
		String myeyeCodeStyle;/*스타일*/
		String myeyeCodeColor;/*컬러*/

		String frameSizeCode;/*사이즈코드*/
		String frameSize;/*사이즈 명칭*/
		String frameShapeCode;/*모양코드*/
		String frameShape;/*모양명칭*/
		String frameStructCode;/*구조 코드*/
		String frameStruct;/*구조 명칭*/
		String frameMaterialCode;/*소재코드*/
		String frameMaterial;/*소재명칭*/
		String frameMainColorCode;/*메인컬러코드*/
		String frameMainColor;/*메인컬러명칭*/
		String frameSubColorCode;/*서브컬러코드*/
		String frameSubColor;/*서브컬러명칭*/

		String jaewonOverallSize; /*프레임 전면부(전체)*/
		String jaewonBridgeSize;/*브릿지 사이즈*/
		String jaewonHorizontalSize;/*가로 사이즈*/
		String jaewonVerticalSize;/*세로 사이즈*/
		String jaewonLegSize;/*다리 사이즈*/

		String lensKindsCode; /*종류 코드*/
		String lensKinds; /*종류 명*/
		String lensCorrectionCode; /*시력교정 코드*/
		String lensCorrection; /*시력교정 명*/
		String lensProtectionCode; /*시력보호 코드*/
		String lensProtection; /*시력보호 명*/
		String lensAgeCode; /*연령대 코드*/
		String lensAge; /*연령대 명*/
		String lensManufacturerCode; /*제조사 코드*/
		String lensManufacturer; /*제조사 명*/

		String contOptCode; /*투명/컬러 코드*/
		String contOpt; /*투명/컬러 명칭*/
		String contKindsCode; /*시력구분 코드*/
		String contKinds; /*시력구분 명*/
		String contWearCode; /*착용주기*/
		String contWear; /*착용주기명*/
		String contColorCode; /*컬러코드*/
		String contColor; /*컬러명*/
		String contDiameterCode; /*그래픽 직경 코드*/
		String contDiameter; /*그래픽 직경 명*/

	}
}
