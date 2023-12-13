package net.danvi.dmall.biz.system.model;

import lombok.Data;

import java.io.Serializable;

@Data
public class DavisionItmVO implements Serializable {

	private static final long serialVersionUID = 7578588457598339712L;

	/*상품코드*/
	private String itmCode;
	/*상품명*/
	private String itmName;
	/*제조사코드*/
	private String markCode;
	/*제조사명*/
	private String venName;
	/*0:취급, 1:취급중지*/
	private Integer useInd;
	/*브랜드 코드*/
	private String brandCode;
	/*브랜드 명*/
	private String brandName;
	/*사이즈코드*/
	private String sizeMark;
	/*사이즈명칭*/
	private String sizeName;
	/*모양코드*/
	private String shapeCode;
	/*모양명칭*/
	private String shapeName;
	/*메인제질코드*/
	private String materialCode;
	/*메인제질명칭*/
	private String materialName;

	private String glassType;

}