package net.danvi.dmall.admin.web.common.util;

import lombok.extern.slf4j.Slf4j;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFCell;
import org.springframework.stereotype.Component;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Slf4j
@Component("excelReader")
public class ExcelReader {

    /**
     * <pre>
     * 엑셀파일을 읽어 List<Map>형식으로 반환
     * </pre>
     * 
     * @param file
     * @return
     * @throws IOException
     */
    public List<Map<String, Object>> convertExcelToListByMap(MultipartFile file) throws Exception {
        List<Map<String, Object>> result = new ArrayList<Map<String, Object>>();

        try (InputStream is = file.getInputStream(); Workbook workbook = WorkbookFactory.create(is)) {
            Sheet sheet = workbook.getSheetAt(0);

            Row row;
            Cell cell;
            Map<String, Object> cells;
            List<String> keys = new ArrayList<String>();
            int rowIdx;
            int cellIdx;

            for (rowIdx = 0; rowIdx < sheet.getPhysicalNumberOfRows(); rowIdx++) {
                row = sheet.getRow(rowIdx);

                cells = new HashMap<>();

                for (cellIdx = 0; cellIdx < row.getPhysicalNumberOfCells(); cellIdx++) {
                    cell = row.getCell(cellIdx);

                    if (rowIdx == 0) {
                        if (cell == null) {
                            throw new Exception("엑셀 헤더에 값이 없는 열이 있습니다.");
                        }
                        keys.add(cell.getStringCellValue());
                    } else {

                        // 셀이 빈값일경우를 위한 널체크
                        if (cell == null) {
                            continue;
                        } else {
                            // 타입별로 내용 읽기
                            switch (cell.getCellType()) {
                            case XSSFCell.CELL_TYPE_FORMULA:
                                cells.put(keys.get(cellIdx), cell.getCellFormula());
                                break;
                            case XSSFCell.CELL_TYPE_NUMERIC:
                                cells.put(keys.get(cellIdx), cell.getNumericCellValue());
                                break;
                            case XSSFCell.CELL_TYPE_STRING:
                                cells.put(keys.get(cellIdx), cell.getStringCellValue());
                                break;
                            case XSSFCell.CELL_TYPE_BLANK:
                                cells.put(keys.get(cellIdx), cell.getBooleanCellValue());
                                break;
                            case XSSFCell.CELL_TYPE_ERROR:
                                cells.put(keys.get(cellIdx), cell.getErrorCellValue());
                                break;
                            }
                        }
                    }
                }
                if (rowIdx > 0) {
                    result.add(cells);
                }
            }
        } catch (Exception e) {
            log.error("엑셀 읽기 오류", e);
            throw e;
        }

        return result;
    }

    /**
     * <pre>
     * 엑셀파일을 읽어 List<List>형식으로 반환
     * </pre>
     * 
     * @param file
     * @return
     * @throws IOException
     */
    public List<List<Object>> convertExcelToListByList(MultipartFile file) throws Exception {
        List<List<Object>> result = new ArrayList<List<Object>>();

        try (InputStream is = file.getInputStream(); Workbook workbook = WorkbookFactory.create(is)) {
            Sheet sheet = workbook.getSheetAt(0);

            Row row;
            Cell cell;
            List<Object> cells;
            List<String> keys = new ArrayList<String>();
            int rowIdx;
            int cellIdx;

            for (rowIdx = 0; rowIdx < sheet.getPhysicalNumberOfRows(); rowIdx++) {
                row = sheet.getRow(rowIdx);
                cells = new ArrayList<Object>();

                for (cellIdx = 0; cellIdx < row.getPhysicalNumberOfCells(); cellIdx++) {
                    cell = row.getCell(cellIdx);

                    // 셀이 빈값일경우를 위한 널체크
                    if (cell == null) {
                        cells.add(null);
                    } else {
                        // 타입별로 내용 읽기
                        switch (cell.getCellType()) {
                        case XSSFCell.CELL_TYPE_FORMULA:
                            cells.add(cell.getCellFormula());
                            break;
                        case XSSFCell.CELL_TYPE_NUMERIC:
                            cells.add(cell.getNumericCellValue());
                            break;
                        case XSSFCell.CELL_TYPE_STRING:
                            cells.add(cell.getStringCellValue());
                            break;
                        case XSSFCell.CELL_TYPE_BLANK:
                            cells.add(cell.getBooleanCellValue());
                            break;
                        case XSSFCell.CELL_TYPE_ERROR:
                            cells.add(cell.getErrorCellValue());
                            break;
                        }
                    }
                }

                result.add(cells);
            }
        } catch (Exception e) {
            log.error("엑셀 읽기 오류", e);
            throw e;
        }

        return result;
    }
}
