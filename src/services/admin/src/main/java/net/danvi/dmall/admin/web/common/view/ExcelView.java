package net.danvi.dmall.admin.web.common.view;

import dmall.framework.common.constants.CommonConstants;
import dmall.framework.common.model.ExcelViewParam;
import dmall.framework.common.util.StringUtil;
import lombok.extern.slf4j.Slf4j;
import net.danvi.dmall.biz.system.util.ServiceUtil;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.web.servlet.view.document.AbstractXlsxView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.lang.reflect.Field;
import java.net.URLEncoder;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Locale;
import java.util.Map;

/**
 * Excel View
 * 
 * @author snw
 * @since 2013.07.30
 */
@Slf4j
public class ExcelView extends AbstractXlsxView {

    @Override
    @SuppressWarnings("unchecked")
    protected void buildExcelDocument(Map<String, Object> model, Workbook workbook, HttpServletRequest request,
            HttpServletResponse response) throws Exception {

        String excelFileName = (String) model.get(CommonConstants.EXCEL_PARAM_FILE_NAME);

        ExcelViewParam excel = (ExcelViewParam) model.get(CommonConstants.EXCEL_PARAM_NAME);
        List<ExcelViewParam> listExcel = (List<ExcelViewParam>) model.get(CommonConstants.EXCEL_LIST_PARAM_NAME);

        if (StringUtil.isBlank(excelFileName)) {
            excelFileName = "excel";
        }

        String excelName = createFileName(excelFileName);

        String fileName = URLEncoder.encode(excelName, "UTF-8");
        fileName = fileName.replaceAll("\\+", " ");
        log.debug(">>>>>>>>Excel Name=" + excelName);
        log.debug(">>>>>>>>File Name=" + fileName);

        int indexDot = fileName.lastIndexOf(".");
        if (indexDot == -1 ) indexDot = 0;
        String fileExtention = fileName.substring(indexDot).toLowerCase();
        if (".xlsx".equals(fileExtention)) {
            workbook = new XSSFWorkbook();
        } else {
            workbook = new HSSFWorkbook();
        }

        response.setHeader("Content-Disposition", "attachment; filename=" + fileName + "");

        if (listExcel != null && listExcel.size() > 0) {
            for (ExcelViewParam excelViewParam : listExcel) {
                createSheet(workbook, excelViewParam);
            }
        } else {
            createSheet(workbook, excel);
        }
        workbook.write(response.getOutputStream());
    }

    @SuppressWarnings("rawtypes")
    private void createSheet(Workbook workbook, ExcelViewParam param) {
        Sheet sheet = workbook.createSheet(param.getSheetName());
        sheet.setDefaultColumnWidth(20);
        sheet.setDisplayGridlines(true);
        sheet.setDefaultRowHeightInPoints((short) 15);

        Row row = null;

        // Header Style
        CellStyle headerStyle = workbook.createCellStyle();
        Font headerFont = workbook.createFont();
        headerFont = createHeaderFont(headerFont);
        headerStyle = createHeaderCellStyle(headerStyle, headerFont);
        // Each Header Style
        CellStyle eachHeaderStyle = workbook.createCellStyle();
        Font eachHeaderFont = workbook.createFont();
        eachHeaderFont = createHeaderFont(eachHeaderFont);
        eachHeaderStyle = createEachHeaderCellStyle(eachHeaderStyle, eachHeaderFont);

        DataFormat df = workbook.createDataFormat();
        headerStyle.setDataFormat(df.getFormat("text"));

        // 본문 Style
        CellStyle cellStyle = workbook.createCellStyle();
        Font cellFont = workbook.createFont();
        cellFont = createCellFont(cellFont);
        cellStyle = createCellStyle(cellStyle, cellFont);
        cellStyle.setDataFormat(df.getFormat("text"));

        int i = 0;
        if (null != param.getHeaderName() && param.getHeaderName().length > 0) {
            row = sheet.createRow(i);
            int j = 0;
            for (String name : param.getHeaderName()) {
                String [] names = name.split("\\|");

                if(names.length>1){
                    row.createCell(j).setCellValue(names[0]);
                    row.getCell(j).setCellStyle(eachHeaderStyle);
                }else{
                    row.createCell(j).setCellValue(name);
                    row.getCell(j).setCellStyle(headerStyle);
                }

                j++;
            }
            i++;
        }

        if (null != param.getDataList() && param.getDataList().size() > 0) {
            for (Object obj : param.getDataList()) {
                Class cls = obj.getClass();
                row = sheet.createRow(i);
                if (null != param.getFieldName() && param.getFieldName().length > 0) {
                    int j = 0;

                    for (String name : param.getFieldName()) {
                        try {
                            Field f = cls.getDeclaredField(name);
                            String fieldValue = "";
                            try {
                                f.setAccessible(true);
                                if (f.get(obj) != null) {
                                    if (f.getType().getName().equals("java.lang.String")) {
                                        String fieldName = StringUtil.toUnCamelCase(name);
                                        if (fieldName.lastIndexOf("_CD") > -1) {
                                            String grpCd = fieldName;// .substring(0, fieldName.lastIndexOf("_CD"));
                                            String dtlCd = (String) f.get(obj);
                                            if (StringUtil.isNotBlank(dtlCd)) {
                                                fieldValue = ServiceUtil.getCodeName(grpCd, dtlCd);
                                            }
                                        } else {
                                            fieldValue = (String) f.get(obj);
                                        }
                                    }

                                    if (f.getType().getName().equals("java.lang.Long")
                                            || f.getType().getName().equals("long")) {
                                        fieldValue = f.get(obj).toString();
                                    }

                                    if (f.getType().getName().equals("java.lang.Integer")
                                            || f.getType().getName().equals("int")) {
                                        fieldValue = f.get(obj).toString();
                                    }

                                    if (f.getType().getName().equals("java.lang.Double")
                                            || f.getType().getName().equals("double")) {
                                        fieldValue = f.get(obj).toString();
                                    }

                                    if (f.getType().getName().equals("java.sql.Timestamp")) {
                                        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss",
                                                Locale.KOREA);
                                        Timestamp t = (Timestamp) f.get(obj);
                                        if (t != null) {
                                            fieldValue = sdf.format(t);
                                        }
                                    }

                                    if (f.getType().getName().equals("java.util.Date")) {

                                        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss",
                                                Locale.KOREA);
                                        Date t = (Date) f.get(obj);

                                        if (t != null) {
                                            fieldValue = sdf.format(t);
                                        }
                                    }
                                }
                            } catch (IllegalArgumentException e) {
                                log.debug("IllegalArgumentException", e);
                            } catch (IllegalAccessException e) {
                                log.debug("IllegalAccessException", e);
                            }
                            row.createCell(j).setCellValue(fieldValue);
                            row.getCell(j).setCellStyle(cellStyle);
                        } catch (NoSuchFieldException e1) {
                            log.debug("NoSuchFieldException", e1);
                        } catch (SecurityException e1) {
                            log.debug("SecurityException", e1);
                        }
                        j++;
                    }
                }
                i++;
            }
        }

    }

    /**
     * Header Cell Style 정의
     * 
     * @param headerStyle
     * @return
     */
    private CellStyle createHeaderCellStyle(CellStyle headerStyle, Font headerFont) {
        headerStyle.setBorderTop((short) 1);
        headerStyle.setBorderLeft((short) 1);
        headerStyle.setBorderRight((short) 1);
        headerStyle.setBorderBottom((short) 1);
        headerStyle.setAlignment(CellStyle.ALIGN_CENTER);

        /*headerStyle.setFillForegroundColor(IndexedColors.WHITE.getIndex());
        headerStyle.setFillPattern(CellStyle.SOLID_FOREGROUND);*/
        headerStyle.setFont(headerFont);

        return headerStyle;
    }

    private CellStyle createEachHeaderCellStyle(CellStyle headerStyle, Font headerFont) {
        headerStyle.setBorderTop((short) 1);
        headerStyle.setBorderLeft((short) 1);
        headerStyle.setBorderRight((short) 1);
        headerStyle.setBorderBottom((short) 1);
        headerStyle.setAlignment(CellStyle.ALIGN_CENTER);
        headerStyle.setFillForegroundColor(IndexedColors.YELLOW.getIndex());
        headerStyle.setFillPattern(CellStyle.SOLID_FOREGROUND);
        headerStyle.setFont(headerFont);

        return headerStyle;
    }
    /**
     * Header Font 정의
     * 
     * @param headerFont
     * @return
     */
    private Font createHeaderFont(Font headerFont) {
        headerFont.setColor(Font.COLOR_NORMAL);
        headerFont.setFontHeightInPoints((short) 11);
        return headerFont;
    }

    /**
     * Cell Style 정의
     * 
     * @param cellStyle
     * @return
     */
    private CellStyle createCellStyle(CellStyle cellStyle, Font cellFont) {
        cellStyle.setBorderTop((short) 1);
        cellStyle.setBorderLeft((short) 1);
        cellStyle.setBorderRight((short) 1);
        cellStyle.setBorderBottom((short) 1);
        cellStyle.setAlignment(CellStyle.ALIGN_CENTER);
        cellStyle.setFont(cellFont);
       // cellStyle.setDataFormat(Short.parseShort("0x31"));
        return cellStyle;
    }

    /**
     * Cell Font 정의
     * 
     * @param cellFont
     * @return
     */
    private Font createCellFont(Font cellFont) {
        cellFont.setColor(Font.COLOR_NORMAL);
        cellFont.setFontHeightInPoints((short) 10);
        return cellFont;
    }

    private String createFileName(String fName) {
        SimpleDateFormat fileFormat = new SimpleDateFormat("yyyyMMdd");
        return fName + "_" + fileFormat.format(new Date()) + ".xlsx";
    }

}
