package dmall.framework.common.model;

import lombok.Data;
import lombok.EqualsAndHashCode;
import dmall.framework.common.util.image.ImageType;

/**
 * Created by dong on 2016-05-24.
 */
@Data
@EqualsAndHashCode(callSuper = false)
public class CmnAtchFilePO extends BaseModel<CmnAtchFilePO> {
    private static final long serialVersionUID = -4927181598207250571L;

    /** 이미지 타입 */
    private ImageType imageType;

    /** 파일 번호 */
    private Long fileNo;
    /** 참조 번호(첨부파일이 붙을 대상의 번호 또는 ID) */
    private String refNo;
    /** 파일 구분(참조파일이 붙는 대상의 테이블명) */
    private String fileGb;

    /** 메인 패스 아래의 서브 패스 */
    private String filePath;
    /** 실제 저장된 물리 파일 명 */
    private String fileNm;
    /** 실제 저장된 임시 파일 명(YYYYMMDD_어쩌구저쩌구.... 서브패스_실제파일명 의 형태) */
    private String tempFileNm;
    /** 원본 파일 명 */
    private String orgFileNm;
    /** 파일 사이즈 */
    private Long fileSize;

    /** 임시 파일 여부 */
    private Boolean temp;
}
