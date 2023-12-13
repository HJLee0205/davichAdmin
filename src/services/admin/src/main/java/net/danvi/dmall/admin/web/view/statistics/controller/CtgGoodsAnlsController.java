package net.danvi.dmall.admin.web.view.statistics.controller;

import java.io.Closeable;
import java.lang.reflect.Field;
import java.net.URLEncoder;
import java.text.SimpleDateFormat;
import java.util.Date;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletResponse;

import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.Font;
import org.apache.poi.ss.usermodel.IndexedColors;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.stereotype.Controller;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import lombok.extern.slf4j.Slf4j;
import net.danvi.dmall.admin.web.common.view.View;
import net.danvi.dmall.biz.app.statistics.model.CtgGoodsSO;
import net.danvi.dmall.biz.app.statistics.model.CtgGoodsVO;
import net.danvi.dmall.biz.app.statistics.service.CtgGoodsAnlsService;
import net.danvi.dmall.biz.system.security.SessionDetailHelper;
import net.danvi.dmall.biz.system.security.DmallSessionDetails;
import dmall.framework.common.constants.ExceptionConstants;
import dmall.framework.common.model.ExcelViewParam;
import dmall.framework.common.model.ResultListModel;
import dmall.framework.common.util.MessageUtil;

/**
 * <pre>
 * 프로젝트명 : 41.admin.web
 * 작성일     : 2016. 9. 1.
 * 작성자     : dong
 * 설명       :
 * </pre>
 */
@Slf4j
@Controller
@RequestMapping("/admin/statistics")
public class CtgGoodsAnlsController {

    @Resource(name = "ctgGoodsAnlsService")
    private CtgGoodsAnlsService ctgGoodsAnlsService;

    /**
     * 카테고리상품 분석 메인 화면
     * 
     * <pre>
     * 작성일 : 2016. 9. 1.
     * 작성자 : dong
     * 설명   : 카테고리상품 분석 메인 화면
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 9. 1. dong - 최초생성
     * </pre>
     *
     * @param memberSvmnSO
     * @return
     */
    @RequestMapping("category-product-analysis")
    public ModelAndView viewCtgGoodsList(@Validated CtgGoodsSO ctgGoodsSO) {
        ModelAndView mv = new ModelAndView("/admin/statistics/ctgGoodsAnls");

        return mv;
    }

    /**
     * 
     * <pre>
     * 작성일 : 2016. 9. 1.
     * 작성자 : dong
     * 설명   : 카테고리 인기순위 현황 조회
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 9. 1. dong - 최초생성
     * </pre>
     *
     * @param ctgGoodsSO
     * @return
     */
    @RequestMapping("category-rank-status")
    public @ResponseBody ResultListModel<CtgGoodsVO> selectCtgGoodsList(CtgGoodsSO ctgGoodsSO) {
        DmallSessionDetails sessionInfo = SessionDetailHelper.getDetails();
        if (sessionInfo == null) {
            throw new BadCredentialsException(MessageUtil
                    .getMessage(ExceptionConstants.BIZ_EXCEPTION_LNG + ExceptionConstants.ERROR_CODE_LOGIN_SESSION));
        }
        ctgGoodsSO.setSiteNo(sessionInfo.getSession().getSiteNo());

        ResultListModel<CtgGoodsVO> resultListModel = ctgGoodsAnlsService.selectCtgGoodsList(ctgGoodsSO);
        return resultListModel;
    }

    /**
     * 
     * <pre>
     * 작성일 : 2016. 9. 1.
     * 작성자 : dong
     * 설명   : 카테고리 인기순위 현황 엑셀다운
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 9. 1. dong - 최초생성
     * </pre>
     *
     * @param ctgGoodsSO
     * @param response
     * @return
     * @throws Exception
     */
    @RequestMapping("/category-excel-download")
    public String downloadExcel(CtgGoodsSO ctgGoodsSO, HttpServletResponse response) throws Exception {
        String peridod = "";
        String ymd = "";
        String content = "";

        if ("D".equals(ctgGoodsSO.getPeriodGb())) {
            ymd = ctgGoodsSO.getYr() + "년 " + ctgGoodsSO.getMm() + "월 " + ctgGoodsSO.getDd() + "일";
            peridod = "일별";
        } else if ("M".equals(ctgGoodsSO.getPeriodGb())) {
            ymd = ctgGoodsSO.getYr() + "년 " + ctgGoodsSO.getMm() + "월";
            peridod = "월별";
        }

        content = "[" + ymd + "] " + peridod + " 카테고리 상품 분석 통계";

        // 엑셀로 출력할 데이터 조회
        ResultListModel<CtgGoodsVO> resultListModel = ctgGoodsAnlsService.selectCtgGoodsList(ctgGoodsSO);
        // 엑셀에 출력할 데이터 세팅
        String[][] headerConfigName = { { "인기순위", "" }, { "구분", "대분류" }, { "", "중분류" }, { "전체", "판매수량" },
                { "", "판매금액" }, { "", "리뷰" }, { "PC", "판매수량" }, { "", "판매금액" }, { "모바일", "판매수량" }, { "", "판매금액" } };
        String[] fieldName = new String[] { "rank", "largeClsfNm", "mediumClsfNm", "allSaleQtt", "allSaleAmt",
                "reviewCnt", "pcSaleQtt", "pcSaleAmt", "mobileSaleQtt", "mobileSaleAmt" };

        // 엑셀파일명 PRE
        String excelFileName = "카테고리 상품 분석 통계";
        // 엑셀파일명에 쓰일 일시포멧
        SimpleDateFormat fileFormat = new SimpleDateFormat("yyyyMMdd_HHmmss");
        // 파일명 지정
        String excelName = excelFileName + "_" + fileFormat.format(new Date()) + ".xlsx";
        // 파일명 처리
        String fileName = URLEncoder.encode(excelName, "UTF-8").replaceAll("\\+", " ");
        // 엑셀작성 파라메터 설정
        ExcelViewParam excel = new ExcelViewParam("카테고리 상품 분석 목록", headerConfigName, fieldName,
                resultListModel.getResultList());
        // 엑셀파일 처리를 위한 설정
        response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
        response.setHeader("Content-Disposition", "attachment; filename=\"" + fileName + "\"");

        // POI Workbook 설정
        Workbook workbook = new XSSFWorkbook();

        createSheet(workbook, excel, content);

        // 생성된 Workbook 출력
        workbook.write(response.getOutputStream());

        // 자원 종료. Closeable only implemented as of POI 3.10
        if (workbook instanceof Closeable) {
            ((Closeable) workbook).close();
        }
        return View.voidView();
    }

    /**
     * 
     * <pre>
     * 작성일 : 2016. 9. 1.
     * 작성자 : dong
     * 설명   : 엑셀다운로드 로우 및 셀 생성
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 8. 30. dong - 최초생성
     * </pre>
     *
     * @param workbook
     * @param param
     * @param content
     */
    private void createSheet(Workbook workbook, ExcelViewParam param, String content) {
        Sheet sheet = workbook.createSheet(param.getSheetName());
        Cell subjectCell = null;
        Cell headerCell = null;
        Cell contentCell = null;
        Row row = null;
        int cnt = 0; //
        sheet.setDefaultColumnWidth(20);
        sheet.setDisplayGridlines(true);
        sheet.setDefaultRowHeightInPoints((short) 15);

        // 제목 Style
        CellStyle cellStyleS = workbook.createCellStyle();
        cellStyleS.setAlignment(CellStyle.ALIGN_CENTER);
        cellStyleS.setVerticalAlignment(CellStyle.VERTICAL_CENTER);

        // 헤더 Style
        CellStyle cellStyleH = workbook.createCellStyle();
        Font cellFontH = workbook.createFont();
        cellFontH.setColor(Font.COLOR_NORMAL);
        cellFontH.setFontHeightInPoints((short) 10);
        cellStyleH.setBorderTop((short) 1);
        cellStyleH.setBorderLeft((short) 1);
        cellStyleH.setBorderRight((short) 1);
        cellStyleH.setBorderBottom((short) 1);
        cellStyleH.setAlignment(CellStyle.ALIGN_CENTER);
        cellStyleH.setFont(cellFontH);
        cellStyleH.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
        cellStyleH.setFillForegroundColor(IndexedColors.GREY_25_PERCENT.getIndex());
        cellStyleH.setFillPattern(CellStyle.SOLID_FOREGROUND);

        // 본문 Style
        CellStyle cellStyleC = workbook.createCellStyle();
        cellStyleC.setBorderTop((short) 1);
        cellStyleC.setBorderLeft((short) 1);
        cellStyleC.setBorderRight((short) 1);
        cellStyleC.setBorderBottom((short) 1);
        cellStyleC.setAlignment(CellStyle.ALIGN_CENTER);
        cellStyleC.setFont(cellFontH);
        cellStyleC.setVerticalAlignment(CellStyle.VERTICAL_CENTER);

        // 제목 생성
        row = sheet.createRow(0);
        for (int i = 0; i < param.getHeaderConfigName().length; i++) {
            subjectCell = row.createCell(i, Cell.CELL_TYPE_STRING);
            subjectCell.setCellValue(content);
            subjectCell.setCellStyle(cellStyleS);
        }
        // 제목 셀 통합
        sheet.addMergedRegion(
                new CellRangeAddress(row.getRowNum(), row.getRowNum(), 0, param.getHeaderConfigName().length - 1));

        // 헤더 생성
        String[][] headEx = param.getHeaderConfigName();
        for (int headI = 0; headI < headEx[0].length; headI++) {
            row = sheet.createRow(headI + 2);

            for (int headJ = 0; headJ < headEx.length; headJ++) {
                headerCell = row.createCell(headJ, Cell.CELL_TYPE_STRING);
                headerCell.setCellValue(headEx[headJ][headI]);
                headerCell.setCellStyle(cellStyleH);

                if (headI == 0) {
                    if (headJ == 0) {
                        sheet.addMergedRegion(new CellRangeAddress(row.getRowNum(), row.getRowNum() + 1, headJ, headJ));
                    } else if (headJ < 5) {
                        if (headJ % 2 == 1) {
                            sheet.addMergedRegion(
                                    new CellRangeAddress(row.getRowNum(), row.getRowNum(), headJ, headJ + 1));
                        }
                    } else if (headJ > 5) {
                        if (headJ % 2 == 0) {
                            sheet.addMergedRegion(
                                    new CellRangeAddress(row.getRowNum(), row.getRowNum(), headJ, headJ + 1));
                        }
                    }
                }
            }
        }

        // 본문 생성
        if (null != param.getDataList() && param.getDataList().size() > 0) {
            try {
                for (int i = 0; i < param.getDataList().size(); i++) {
                    row = sheet.createRow(i + 4);
                    Object obj = param.getDataList().get(i);
                    Field[] fields = obj.getClass().getDeclaredFields();

                    cnt = 0;
                    for (String fieldName : param.getFieldName()) {
                        for (int j = 0; j < fields.length; j++) {
                            if (fieldName.equals(fields[j].getName())) {
                                contentCell = row.createCell(cnt, Cell.CELL_TYPE_STRING);
                                contentCell.setCellValue(fields[j].get(obj).toString());
                                contentCell.setCellStyle(cellStyleC);
                                cnt += 1;
                            }
                        }
                    }
                }
            } catch (IllegalArgumentException e) {
                log.debug("## IllegalArgumentException : {}", e);
            } catch (IllegalAccessException e) {
                log.debug("## IllegalAccessException : {}", e);
            } catch (Exception e) {
                log.debug("## Exception : {}", e);
            }
        }
    }
}
