package net.danvi.dmall.biz.app.operation.model;

import lombok.Data;
import lombok.EqualsAndHashCode;
import dmall.framework.common.model.BaseModel;
import net.danvi.dmall.biz.app.board.model.BbsCmntManageVO;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 5. 30.
 * 작성자     : dong
 * 설명       :
 * </pre>
 */
@Data
@EqualsAndHashCode(callSuper = false)
public class AtchFileVO extends BaseModel<BbsCmntManageVO> {
    private String fileNo; // 파일 번호
    private String bbsId; // 게시판 아이디
    private String lettNo; // 글 번호
    private String fileGb; // 파일 구분
    /** 파일 경로 */
    private String filePath; // 파일 경로
    /** 파일 이름 */
    private String fileNm; // 파일 명
    /** 파일 크기 */
    private Long fileSize; // 파일 크기
    /** 파일 이름 */
    private String orgFileNm; // 원본 파일 명
    /** 파일 확장자 */
    private String extsn; // 확장자
    private String imgYn; // 이미지 여부
}
