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
import net.danvi.dmall.biz.app.statistics.model.PayWaySalesSttcsSO;
import net.danvi.dmall.biz.app.statistics.model.PayWaySalesSttcsVO;
import net.danvi.dmall.biz.app.statistics.service.PayWaySalesSttcsAnlsService;
import net.danvi.dmall.biz.system.security.SessionDetailHelper;
import net.danvi.dmall.biz.system.security.DmallSessionDetails;
import dmall.framework.common.constants.ExceptionConstants;
import dmall.framework.common.model.ExcelViewParam;
import dmall.framework.common.model.ResultListModel;
import dmall.framework.common.util.MessageUtil;

/**
 * <pre>
 * 프로젝트명 : 41.admin.web
 * 작성일     : 2016. 9. 13.
 * 작성자     : dong
 * 설명       :
 * </pre>
 */
@Slf4j
@Controller
@RequestMapping("/admin/statistics")
public class PayWaySalesSttcsAnlsController {

    @Resource(name = "payWaySalesSttcsAnlsService")
    private PayWaySalesSttcsAnlsService payWaySalesSttcsAnlsService;

    /**
     * 
     * <pre>
     * 작성일 : 2016. 9. 13.
     * 작성자 : dong
     * 설명   : 결제수단별 매출 통계 메인 화면
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 9. 13. dong - 최초생성
     * </pre>
     *
     * @param payWaySalesSttcsSO
     * @return
     */
    @RequestMapping("paymentmethod-salses-statistcs")
    public ModelAndView viewPayWaySalesSttcsList(@Validated PayWaySalesSttcsSO payWaySalesSttcsSO) {
        ModelAndView mv = new ModelAndView("/admin/statistics/payWaySalesSttcsAnls");

        return mv;
    }

    /**
     * 
     * <pre>
     * 작성일 : 2016. 9. 13.
     * 작성자 : dong
     * 설명   : 결제수단별 매출 현황 조회
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 9. 13. dong - 최초생성
     * </pre>
     *
     * @param payWaySalesSttcsSO
     * @return
     */
    @RequestMapping("payway-sales-statistics")
    public @ResponseBody ResultListModel<PayWaySalesSttcsVO> selectPayWaySalesSttcsList(
            PayWaySalesSttcsSO payWaySalesSttcsSO) {
        DmallSessionDetails sessionInfo = SessionDetailHelper.getDetails();
        if (sessionInfo == null) {
            throw new BadCredentialsException(MessageUtil
                    .getMessage(ExceptionConstants.BIZ_EXCEPTION_LNG + ExceptionConstants.ERROR_CODE_LOGIN_SESSION));
        }
        payWaySalesSttcsSO.setSiteNo(sessionInfo.getSession().getSiteNo());

        ResultListModel<PayWaySalesSttcsVO> resultListModel = payWaySalesSttcsAnlsService
                .selectPayWaySalesSttcsList(payWaySalesSttcsSO);
        return resultListModel;
    }

    /**
     * 
     * <pre>
     * 작성일 : 2016. 9. 13.
     * 작성자 : dong
     * 설명   : 결제수단별 매출 현황 엑셀다운
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 9. 13. dong - 최초생성
     * </pre>
     *
     * @param payWaySalesSttcsSO
     * @param response
     * @return
     * @throws Exception
     */
    @RequestMapping("/paywaysalesstatistics-excel-download")
    public String downloadExcel(PayWaySalesSttcsSO payWaySalesSttcsSO, HttpServletResponse response) throws Exception {
        String eqpm = "";
        String ymd = "";
        String period = "";
        String content = "";

        // 엑셀로 출력할 데이터 조회
        ResultListModel<PayWaySalesSttcsVO> resultListModel = payWaySalesSttcsAnlsService
                .selectPayWaySalesSttcsList(payWaySalesSttcsSO);
        // 엑셀에 출력할 데이터 세팅
        String[][] headerConfigName = { { "시간별", "" }, { "가상계좌", "건수" }, { "", "매출" }, { "신용카드", "건수" }, { "", "매출" },
                { "실시간계좌이체", "건수" }, { "", "매출" }, { "휴대폰결제", "건수" }, { "", "매출" }, { "간편결제", "건수" }, { "", "매출" },
                { "PAYPAL", "건수" }, { "", "매출" }, { "합계", "건수" }, { "", "매출" } };

        if ("00".equals(payWaySalesSttcsSO.getEqpmGbCd())) {
            eqpm = "전체";
        } else if ("11".equals(payWaySalesSttcsSO.getEqpmGbCd())) {
            eqpm = "PC";
        } else if ("12".equals(payWaySalesSttcsSO.getEqpmGbCd())) {
            eqpm = "모바일";
        }

        if ("T".equals(payWaySalesSttcsSO.getPeriodGb())) {
            ymd = payWaySalesSttcsSO.getYr() + "년 " + payWaySalesSttcsSO.getMm() + "월 " + payWaySalesSttcsSO.getDd()
                    + "일";
            period = "시";
        } else if ("D".equals(payWaySalesSttcsSO.getPeriodGb())) {
            ymd = payWaySalesSttcsSO.getYr() + "년 " + payWaySalesSttcsSO.getMm() + "월 ";
            period = "일";
        } else if ("M".equals(payWaySalesSttcsSO.getPeriodGb())) {
            ymd = payWaySalesSttcsSO.getYr() + "년 ";
            period = "월";
        }

        content = "[" + ymd + "] " + eqpm + " 결재수단별 매출통계";

        String[] fieldName = new String[] { "dt", "virtActDpstCnt", "virtActDpstAmt", "credPaymentCnt",
                "credPaymentAmt", "actTransCnt", "actTransAmt", "mobilePaymentCnt", "mobilePaymentAmt",
                "simpPaymentCnt", "simpPaymentAmt", "paypalCnt", "paypalAmt", "totalCnt", "totalAmt" };

        // 엑셀파일명 PRE
        String excelFileName = "결재수단별 매출통계";
        // 엑셀파일명에 쓰일 일시포멧
        SimpleDateFormat fileFormat = new SimpleDateFormat("yyyyMMdd_HHmmss");
        // 파일명 지정
        String excelName = excelFileName + "_" + fileFormat.format(new Date()) + ".xlsx";
        // 파일명 처리
        String fileName = URLEncoder.encode(excelName, "UTF-8").replaceAll("\\+", " ");
        // 엑셀작성 파라메터 설정
        ExcelViewParam excel = new ExcelViewParam("결재수단별 매출통계 목록", headerConfigName, fieldName,
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
     * 작성일 : 2016. 9. 13.
     * 작성자 : dong
     * 설명   : 엑셀다운로드 로우 및 셀 생성
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 9. 13. dong - 최초생성
     * </pre>
     *
     * @param workbook
     * @param param
     * @param content
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
                    if (headJ == 0) {
                        sheet.addMergedRegion(new CellRangeAddress(row.getRowNum(), row.getRowNum() + 1, headJ, headJ));
                    } else if (headJ % 2 == 1) {
                        sheet.addMergedRegion(new CellRangeAddress(row.getRowNum(), row.getRowNum(), headJ, headJ + 1));
                    }
                }
            }
        }

        // 본문 생성
        if (null != param.getDataList() && param.getDataList().size() > 0) {

            int virtActDpstCntSum = 0;
            int virtActDpstAmtSum = 0;
            int credPaymentCntSum = 0;
            int credPaymentAmtSum = 0;
            int actTransCntSum = 0;
            int actTransAmtSum = 0;
            int mobilePaymentCntSum = 0;
            int mobilePaymentAmtSum = 0;
            int simpPaymentCntSum = 0;
            int simpPaymentAmtSum = 0;
            int paypalCntSum = 0;
            int paypalAmtSum = 0;
            int totalCntSum = 0;
            int totalAmtSum = 0;

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

                                if ("virtActDpstCnt".equals(fields[j].getName())) {
                                    virtActDpstCntSum += Integer
                                            .parseInt(fields[j].get(obj).toString().replace(",", ""));
                                    sumMap.put("SUM1", virtActDpstCntSum);
                                } else if ("virtActDpstAmt".equals(fields[j].getName())) {
                                    virtActDpstAmtSum += Integer
                                            .parseInt(fields[j].get(obj).toString().replace(",", ""));
                                    sumMap.put("SUM2", virtActDpstAmtSum);
                                } else if ("credPaymentCnt".equals(fields[j].getName())) {
                                    credPaymentCntSum += Integer
                                            .parseInt(fields[j].get(obj).toString().replace(",", ""));
                                    sumMap.put("SUM3", credPaymentCntSum);
                                } else if ("credPaymentAmt".equals(fields[j].getName())) {
                                    credPaymentAmtSum += Integer
                                            .parseInt(fields[j].get(obj).toString().replace(",", ""));
                                    sumMap.put("SUM4", credPaymentAmtSum);
                                } else if ("actTransCnt".equals(fields[j].getName())) {
                                    actTransCntSum += Integer.parseInt(fields[j].get(obj).toString().replace(",", ""));
                                    sumMap.put("SUM5", actTransCntSum);
                                } else if ("actTransAmt".equals(fields[j].getName())) {
                                    actTransAmtSum += Integer.parseInt(fields[j].get(obj).toString().replace(",", ""));
                                    sumMap.put("SUM6", actTransAmtSum);
                                } else if ("mobilePaymentCnt".equals(fields[j].getName())) {
                                    mobilePaymentCntSum += Integer
                                            .parseInt(fields[j].get(obj).toString().replace(",", ""));
                                    sumMap.put("SUM7", mobilePaymentCntSum);
                                } else if ("mobilePaymentAmt".equals(fields[j].getName())) {
                                    mobilePaymentAmtSum += Integer
                                            .parseInt(fields[j].get(obj).toString().replace(",", ""));
                                    sumMap.put("SUM8", mobilePaymentAmtSum);
                                } else if ("simpPaymentCnt".equals(fields[j].getName())) {
                                    simpPaymentCntSum += Integer
                                            .parseInt(fields[j].get(obj).toString().replace(",", ""));
                                    sumMap.put("SUM9", simpPaymentCntSum);
                                } else if ("simpPaymentAmt".equals(fields[j].getName())) {
                                    simpPaymentAmtSum += Integer
                                            .parseInt(fields[j].get(obj).toString().replace(",", ""));
                                    sumMap.put("SUM10", simpPaymentAmtSum);
                                } else if ("paypalCnt".equals(fields[j].getName())) {
                                    paypalCntSum += Integer.parseInt(fields[j].get(obj).toString().replace(",", ""));
                                    sumMap.put("SUM11", paypalCntSum);
                                } else if ("paypalAmt".equals(fields[j].getName())) {
                                    paypalAmtSum += Integer.parseInt(fields[j].get(obj).toString().replace(",", ""));
                                    sumMap.put("SUM12", paypalAmtSum);
                                } else if ("totalCnt".equals(fields[j].getName())) {
                                    totalCntSum += Integer.parseInt(fields[j].get(obj).toString().replace(",", ""));
                                    sumMap.put("SUM13", totalCntSum);
                                } else if ("totalAmt".equals(fields[j].getName())) {
                                    totalAmtSum += Integer.parseInt(fields[j].get(obj).toString().replace(",", ""));
                                    sumMap.put("SUM14", totalAmtSum);
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
