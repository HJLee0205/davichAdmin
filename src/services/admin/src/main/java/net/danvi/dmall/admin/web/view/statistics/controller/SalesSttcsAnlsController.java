package net.danvi.dmall.admin.web.view.statistics.controller;

import java.io.Closeable;
import java.lang.reflect.Field;
import java.net.URLEncoder;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

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
import net.danvi.dmall.biz.app.statistics.model.SalesSttcsSO;
import net.danvi.dmall.biz.app.statistics.model.SalesSttcsVO;
import net.danvi.dmall.biz.app.statistics.service.SalesSttcsAnlsService;
import net.danvi.dmall.biz.system.security.SessionDetailHelper;
import net.danvi.dmall.biz.system.security.DmallSessionDetails;
import dmall.framework.common.constants.ExceptionConstants;
import dmall.framework.common.model.ExcelViewParam;
import dmall.framework.common.model.ResultListModel;
import dmall.framework.common.util.MessageUtil;

/**
 * <pre>
 * 프로젝트명 : 41.admin.web
 * 작성일     : 2016. 9. 9.
 * 작성자     : dong
 * 설명       :
 * </pre>
 */
@Slf4j
@Controller
@RequestMapping("/admin/statistics")
public class SalesSttcsAnlsController {

    @Resource(name = "salesSttcsAnlsService")
    private SalesSttcsAnlsService salesSttcsAnlsService;

    /**
     * 
     * <pre>
     * 작성일 : 2016. 9. 9.
     * 작성자 : dong
     * 설명   : 매출통계 메인 화면
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 9. 9. dong - 최초생성
     * </pre>
     *
     * @param salesSttcsSO
     * @return
     */
    @RequestMapping("sales-statistics")
    public ModelAndView viewOrdSttcsList(@Validated SalesSttcsSO salesSttcsSO) {
        ModelAndView mv = new ModelAndView("/admin/statistics/salesSttcsAnls");

        return mv;
    }

    /**
     * 
     * <pre>
     * 작성일 : 2016. 9. 12.
     * 작성자 : dong
     * 설명   : 매출 현황 조회
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 9. 12. dong - 최초생성
     * </pre>
     *
     * @param salesSttcsSO
     * @return
     */
    @RequestMapping("sales-statistics-stauts")
    public @ResponseBody ResultListModel<SalesSttcsVO> selectSalesSttcsList(SalesSttcsSO salesSttcsSO) {
        DmallSessionDetails sessionInfo = SessionDetailHelper.getDetails();
        if (sessionInfo == null) {
            throw new BadCredentialsException(MessageUtil
                    .getMessage(ExceptionConstants.BIZ_EXCEPTION_LNG + ExceptionConstants.ERROR_CODE_LOGIN_SESSION));
        }
        salesSttcsSO.setSiteNo(sessionInfo.getSession().getSiteNo());

        ResultListModel<SalesSttcsVO> resultListModel = salesSttcsAnlsService.selectSalesSttcsList(salesSttcsSO);
        return resultListModel;
    }

    /**
     * 
     * <pre>
     * 작성일 : 2016. 9. 12.
     * 작성자 : dong
     * 설명   : 매출 현황 엑셀다운
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 9. 12. dong - 최초생성
     * </pre>
     *
     * @param salesSttcsSO
     * @param response
     * @return
     * @throws Exception
     */
    @RequestMapping("/salesstatistics-excel-download")
    public String downloadExcel(SalesSttcsSO salesSttcsSO, HttpServletResponse response) throws Exception {
        String eqpm = "";
        String ymd = "";
        String period = "";
        String content = "";

        // 엑셀로 출력할 데이터 조회
        ResultListModel<SalesSttcsVO> resultListModel = salesSttcsAnlsService.selectSalesSttcsList(salesSttcsSO);
        // 엑셀에 출력할 데이터 세팅
        String[][] headerConfigName = { { "시간별", "" }, { "결제금액", "결재금액" }, { "", "구폰할인" }, { "", "기타할인" },
                { "", "실결제금액" }, { "환불금액", "반품" }, { "", "취소" }, { "", "환불액" }, { "매출액", "" } };

        if ("00".equals(salesSttcsSO.getEqpmGbCd())) {
            eqpm = "전체";
        } else if ("11".equals(salesSttcsSO.getEqpmGbCd())) {
            eqpm = "PC";
        } else if ("12".equals(salesSttcsSO.getEqpmGbCd())) {
            eqpm = "모바일";
        }

        if ("T".equals(salesSttcsSO.getPeriodGb())) {
            ymd = salesSttcsSO.getYr() + "년 " + salesSttcsSO.getMm() + "월 " + salesSttcsSO.getDd() + "일";
            period = "시";
        } else if ("D".equals(salesSttcsSO.getPeriodGb())) {
            ymd = salesSttcsSO.getYr() + "년 " + salesSttcsSO.getMm() + "월 ";
            period = "일";
        } else if ("M".equals(salesSttcsSO.getPeriodGb())) {
            ymd = salesSttcsSO.getYr() + "년 ";
            period = "월";
        }

        content = "[" + ymd + "] " + eqpm + " 매출통계";

        String[] fieldName = new String[] { "dt", "paymentAmt", "cpDcAmt", "etcDcAmt", "realPaymentAmt",
                "returnRefundAmt", "cancelRefundAmt", "refundAmt", "salesAmt" };

        // 엑셀파일명 PRE
        String excelFileName = "매출통계";
        // 엑셀파일명에 쓰일 일시포멧
        SimpleDateFormat fileFormat = new SimpleDateFormat("yyyyMMdd_HHmmss");
        // 파일명 지정
        String excelName = excelFileName + "_" + fileFormat.format(new Date()) + ".xlsx";
        // 파일명 처리
        String fileName = URLEncoder.encode(excelName, "UTF-8").replaceAll("\\+", " ");
        // 엑셀작성 파라메터 설정
        ExcelViewParam excel = new ExcelViewParam("매출통계 목록", headerConfigName, fieldName,
                resultListModel.getResultList());
        // 엑셀파일 처리를 위한 설정
        response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
        response.setHeader("Content-Disposition", "attachment; filename=\"" + fileName + "\"");

        // POI Workbook 설정
        Workbook workbook = new XSSFWorkbook();

        createSheet(workbook, excel, content, period);

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
     * 작성일 : 2016. 9. 12.
     * 작성자 : dong
     * 설명   : 엑셀다운로드 로우 및 셀 생성
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 9. 12. dong - 최초생성
     * </pre>
     *
     * @param workbook
     * @param param
     * @param content
     * @param period
     */
    private void createSheet(Workbook workbook, ExcelViewParam param, String content, String period) {
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
        String fihead = "";
        String[][] headEx = param.getHeaderConfigName();
        for (int headI = 0; headI < headEx[0].length; headI++) {
            row = sheet.createRow(headI + 2);

            for (int headJ = 0; headJ < headEx.length; headJ++) {
                headerCell = row.createCell(headJ, Cell.CELL_TYPE_STRING);
                if (headI == 0 && headJ == 0) {
                    if ("시".equals(period)) {
                        fihead = "시간별";
                    } else if ("일".equals(period)) {
                        fihead = "일별";
                    } else if ("월".equals(period)) {
                        fihead = "월별";
                    }
                    headerCell.setCellValue(fihead);
                } else {
                    headerCell.setCellValue(headEx[headJ][headI]);
                }
                headerCell.setCellStyle(cellStyleH);

                if (headI == 0) {
                    if (headJ == 0 || headJ == headEx.length - 1) {
                        sheet.addMergedRegion(new CellRangeAddress(row.getRowNum(), row.getRowNum() + 1, headJ, headJ));
                    } else if (headJ == 1) {
                        sheet.addMergedRegion(new CellRangeAddress(row.getRowNum(), row.getRowNum(), headJ, headJ + 3));
                    } else if (headJ == 5) {
                        sheet.addMergedRegion(new CellRangeAddress(row.getRowNum(), row.getRowNum(), headJ, headJ + 2));
                    }
                }
            }
        }

        // 본문 생성
        if (null != param.getDataList() && param.getDataList().size() > 0) {
            int paymentAmtSum = 0;
            int cpDcAmtSum = 0;
            int etcDcAmtSum = 0;
            int realPaymentAmtSum = 0;
            int returnRefundAmtSum = 0;
            int cancelRefundAmtSum = 0;
            int refundAmtSum = 0;
            int salesAmtSum = 0;

            Map<String, Object> sumMap = new HashMap<String, Object>();

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
                                if ("dt".equals(fields[j].getName())) {
                                    contentCell.setCellValue(fields[j].get(obj).toString() + period);
                                } else {
                                    contentCell.setCellValue(fields[j].get(obj).toString());
                                }
                                contentCell.setCellStyle(cellStyleC);

                                if ("paymentAmt".equals(fields[j].getName())) {
                                    paymentAmtSum += Integer.parseInt(fields[j].get(obj).toString().replace(",", ""));
                                    sumMap.put("SUM1", paymentAmtSum);
                                } else if ("cpDcAmt".equals(fields[j].getName())) {
                                    cpDcAmtSum += Integer.parseInt(fields[j].get(obj).toString().replace(",", ""));
                                    sumMap.put("SUM2", cpDcAmtSum);
                                } else if ("etcDcAmt".equals(fields[j].getName())) {
                                    etcDcAmtSum += Integer.parseInt(fields[j].get(obj).toString().replace(",", ""));
                                    sumMap.put("SUM3", etcDcAmtSum);
                                } else if ("realPaymentAmt".equals(fields[j].getName())) {
                                    realPaymentAmtSum += Integer
                                            .parseInt(fields[j].get(obj).toString().replace(",", ""));
                                    sumMap.put("SUM4", realPaymentAmtSum);
                                } else if ("returnRefundAmt".equals(fields[j].getName())) {
                                    returnRefundAmtSum += Integer
                                            .parseInt(fields[j].get(obj).toString().replace(",", ""));
                                    sumMap.put("SUM5", returnRefundAmtSum);
                                } else if ("cancelRefundAmt".equals(fields[j].getName())) {
                                    cancelRefundAmtSum += Integer
                                            .parseInt(fields[j].get(obj).toString().replace(",", ""));
                                    sumMap.put("SUM6", cancelRefundAmtSum);
                                } else if ("refundAmt".equals(fields[j].getName())) {
                                    refundAmtSum += Integer.parseInt(fields[j].get(obj).toString().replace(",", ""));
                                    sumMap.put("SUM7", refundAmtSum);
                                } else if ("salesAmt".equals(fields[j].getName())) {
                                    salesAmtSum += Integer.parseInt(fields[j].get(obj).toString().replace(",", ""));
                                    sumMap.put("SUM8", salesAmtSum);
                                }

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

            // 합계

            DecimalFormat df = new DecimalFormat("#,##0");
            row = sheet.createRow(param.getDataList().size() + 4);
            for (int endI = 0; endI < param.getFieldName().length; endI++) {
                contentCell = row.createCell(endI, Cell.CELL_TYPE_STRING);
                if (endI == 0) {
                    contentCell.setCellValue("합계");
                } else {
                    contentCell.setCellValue(df.format(Integer.parseInt(sumMap.get("SUM" + endI).toString())));
                }
                contentCell.setCellStyle(cellStyleH);
            }

        }
    }
}
