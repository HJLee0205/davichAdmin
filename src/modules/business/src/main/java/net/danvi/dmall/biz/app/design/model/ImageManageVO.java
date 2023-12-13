package net.danvi.dmall.biz.app.design.model;

import java.util.List;

import lombok.Data;
import lombok.EqualsAndHashCode;
import dmall.framework.common.model.BaseSearchVO;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 6. 9.
 * 작성자     : dong
 * 설명       : html edit관리 VO
 * </pre>
 */

@Data
@EqualsAndHashCode
public class ImageManageVO extends BaseSearchVO<ImageManageVO> {
    private String fileNm; // 파일명
    private String baseFilePath; // 기본파일경로
    private String filePath; // 파일경로
    private String fileSize; // 파일사이즈
    private String fileDate; // 파일등록일
    private String imgNm; // 이미지명
    private String imgPath; // 이미지 경로
    private int fileCnt; // 파일갯수

    private int idxData; // 트리용 순번
    private int beforeIdx; // 트리용 이전 순번

    private List<ImageManageVO> fileInfoArr; //
}
