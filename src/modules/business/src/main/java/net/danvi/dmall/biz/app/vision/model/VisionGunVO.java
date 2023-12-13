package net.danvi.dmall.biz.app.vision.model;

import java.util.List;

import dmall.framework.common.model.EditorBaseVO;
import lombok.Data;
import lombok.EqualsAndHashCode;
import net.danvi.dmall.biz.app.operation.model.AtchFileVO;

/**
 * <pre>
 * 프로젝트명 : 비전체크 군 관리
 * 작성일     : 2019. 2. 1.
 * 작성자     : yang ji
 * 설명       : 
 * </pre>
 */
@Data
@EqualsAndHashCode
public class VisionGunVO extends EditorBaseVO<VisionGunVO> {	
	
	/*상품번호*/
	private String goodsNo;
	/*카테고리*/
	private String goodsTypeCd;	
	/*카테고리 명*/
	private String goodsTypeCdNm;	
	/*군 */
	private int gunNo;	
	/*군 명*/
	private String gunNm;
	/*가격대*/
	private String priceRange;
	/*간단설명*/
	private String simpleDscrt;
	/*대표이미지*/
	private int repImgNo;
	/*사용여부(Y/N)*/
	private String isUse;
	
	/*첨부파일*/
	private String imgYn;
	
	private List<AtchFileVO> atchFileArr;
    private String lettNo; // 글 번호

    // 저장 대상인지 여부 (DB취득의 경우 'U'값을 설정)
    private String registFlag;

    private String filePath;
    private String fileNm;
    private int imgCnt;

}
