package dmall.framework.common.model;

import java.io.Serializable;

import lombok.Data;

/**
 * File Download VO
 * 
 * @author snw
 * @since 2013.09.25
 */
@Data
public class FileVO implements Serializable {

    private static final long serialVersionUID = 2673233224857218831L;

    /** 파일 이름 */
    private String fileName;

    /** 파일 이름 */
    private String fileOrgName;

    /** 파일 경로 */
    private String filePath;

    /** 파일 크기 */
    private Long fileSize;

    /** 파일 타입 */
    private String fileType;

    /** 파일 확장자 */
    private String fileExtension;

    /** 파일 가로 크기 */
    private String fileWidth;

    /** 파일 세로 크기 */
    private String fileHeight;

    /** 이미지 여부 */
    private String imgYn;
    
    /** 파일 구분 */
    private String userFile;
    
    /** 대표 이미지 여부 */
    private String dlgtImgYn;
}