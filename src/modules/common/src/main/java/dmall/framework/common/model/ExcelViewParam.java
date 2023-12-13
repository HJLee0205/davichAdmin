package dmall.framework.common.model;

import java.io.Serializable;
import java.util.List;

import lombok.Getter;

/**
 * JqGrid Return VO
 * 
 * @author snw
 * @since 2013.07.31
 */
public class ExcelViewParam implements Serializable {

    @Getter
    private String sheetName;

    @Getter
    private String[] headerName;

    @Getter
    private String[][] headerConfigName;

    @Getter
    private String[] fieldName;

    @Getter
    private List<? extends Object> dataList;

    /**
     * @param sheetName
     *            시트 명
     * @param headerName
     *            헤더 명 배열
     * @param fieldName
     *            필드 명 배열
     * @param dataList
     *            데이터 리스트
     */
    public ExcelViewParam(String sheetName, String[] headerName, String[] fieldName, List<? extends Object> dataList) {
        this.sheetName = sheetName;
        this.headerName = headerName;
        this.fieldName = fieldName;
        this.dataList = dataList;
    }

    /**
     * @param sheetName
     *            시트 명
     * @param headerConfigName
     *            헤더 정보 배열
     * @param fieldName
     *            필드 명 배열
     * @param dataList
     *            데이터 리스트
     */
    public ExcelViewParam(String sheetName, String[][] headerConfigName, String[] fieldName,
            List<? extends Object> dataList) {
        this.sheetName = sheetName;
        this.headerConfigName = headerConfigName;
        this.fieldName = fieldName;
        this.dataList = dataList;
    }

}