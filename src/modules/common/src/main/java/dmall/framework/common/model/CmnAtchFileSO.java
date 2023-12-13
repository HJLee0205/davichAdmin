package dmall.framework.common.model;

import lombok.Data;

@Data
public class CmnAtchFileSO extends BaseModel<CmnAtchFileSO> {

    private static final long serialVersionUID = -1284766639723880742L;

    /** 파일 번호 */
    private Long fileNo;
    /** 참조 번호(첨부파일이 붙을 대상의 번호 또는 ID) */
    private String refNo;
    /** 사이트 번호 */
    private Long siteNo;
    /** 파일 구분 */
    private String fileGb;
}