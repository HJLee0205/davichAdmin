package net.danvi.dmall.admin.web.view.statistics.controller;

import java.io.Closeable;
import java.lang.reflect.Field;
import java.net.URLEncoder;
import java.text.DecimalFormat;
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
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import lombok.extern.slf4j.Slf4j;
import net.danvi.dmall.admin.web.common.view.View;
import net.danvi.dmall.biz.app.statistics.model.VisitPathSO;
import net.danvi.dmall.biz.app.statistics.model.VisitPathVO;
import net.danvi.dmall.biz.app.statistics.service.VisitPathAnlsService;
import net.danvi.dmall.biz.system.security.SessionDetailHelper;
import net.danvi.dmall.biz.system.security.DmallSessionDetails;
import dmall.framework.common.constants.ExceptionConstants;
import dmall.framework.common.model.ExcelViewParam;
import dmall.framework.common.model.ResultListModel;
import dmall.framework.common.util.MessageUtil;

/**
 * <pre>
 * 프로젝트명 : 41.admin.web
 * 작성일     : 2016. 8. 24.
 * 작성자     : dong
 * 설명       : 방문 경로 분석 통계 Controller
 * </pre>
 */
@Slf4j
@Controller
@RequestMapping("/admin/statistics")
public class VisitPathAnlsController {

    @Resource(name = "visitPathAnlsService")
    private VisitPathAnlsService visitPathAnlsService;

    /**
     * 
     * <pre>
     * 작성일 : 2016. 8. 24.
     * 작성자 : dong
     * 설명   : 방문 경로 분석 메인
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 8. 24. dong - 최초생성
     * </pre>
     *
     * @return
     */
    @RequestMapping("visiting-path-analysis")
    public ModelAndView viewVisitPathList() {
        ModelAndView mv = new ModelAndView("/admin/statistics/visitPathAnls");

        return mv;
    }

    /**
     * 
     * <pre>
     * 작성일 : 2016. 8. 24.
     * 작성자 : dong
     * 설명   : 방문 경로 분석 조회
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 8. 24. dong - 최초생성
     * </pre>
     *
     * @param visitPathSO
     * @return
     */
    @RequestMapping("visitpath-analysis")
    public @ResponseBody ResultListModel<VisitPathVO> selectVisitPathList(VisitPathSO visitPathSO) {
        DmallSessionDetails sessionInfo = SessionDetailHelper.getDetails();
        if (sessionInfo == null) {
            throw new BadCredentialsException(MessageUtil.getMessage(ExceptionConstants.BIZ_EXCEPTION_LNG + ExceptionConstants.ERROR_CODE_LOGIN_SESSION));
        }

        visitPathSO.setSiteNo(sessionInfo.getSession().getSiteNo());
        ResultListModel<VisitPathVO> resultListModel = visitPathAnlsService.selectVisitPathList(visitPathSO);
        return resultListModel;
    }

    /**
     * 
     * <pre>
     * 작성일 : 2016. 8. 25.
     * 작성자 : dong
     * 설명   : 방문 경로 분석 엑셀다운
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 8. 25. dong - 최초생성
     * </pre>
     *
     * @param visitPathSO
     * @param response
     * @return
     * @throws Exception
     */
    @RequestMapping("/visitpath-excel-download")
    public String downloadExcel(VisitPathSO visitPathSO, HttpServletResponse response) throws Exception {
        String eqpm = "";
        String ymd = "";
        String content = "";

        if ("00".equals(visitPathSO.getEqpmGbCd())) {
            eqpm = "전체";
        } else if ("11".equals(visitPathSO.getEqpmGbCd())) {
            eqpm = "PC";
        } else if ("12".equals(visitPathSO.getEqpmGbCd())) {
            eqpm = "모바일";
        }

        if ("D".equals(visitPathSO.getPeriodGb())) {
            ymd = visitPathSO.getYr() + "년 " + visitPathSO.getMm() + "월 " + visitPathSO.getDd() + "일";
        } else if ("M".equals(visitPathSO.getPeriodGb())) {
            ymd = visitPathSO.getYr() + "년 " + visitPathSO.getMm() + "월";
        }

        content = "[" + ymd + "] " + eqpm + " 방문 경로 분석 통계";

        // 엑셀로 출력할 데이터 조회
        ResultListModel<VisitPathVO> resultListModel = visitPathAnlsService.selectVisitPathList(visitPathSO);
        // 엑셀에 출력할 데이터 세팅
        String[] headerName = new String[] { "순위", "검색엔진", "방문자수", "비율" };
        String[] fieldName = new String[] { "rank", "visitPathNm", "vstrCnt", "rto" };

        // 엑셀파일명 PRE
        String excelFileName = "방문 경로 분석 통계";
        // 엑셀파일명에 쓰일 일시포멧
        SimpleDateFormat fileFormat = new SimpleDateFormat("yyyyMMdd_HHmmss");
        // 파일명 지정
        String excelName = excelFileName + "_" + fileFormat.format(new Date()) + ".xlsx";
        // 파일명 처리
        String fileName = URLEncoder.encode(excelName, "UTF-8").replaceAll("\\+", " ");
        // 엑셀작성 파라메터 설정
        ExcelViewParam excel = new ExcelViewParam("방문 경로 분석 목록", headerName, fieldName,
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
     * 작성일 : 2016. 8. 25.
     * 작성자 : dong
     * 설명   : 엑셀다운로드 로우 및 셀 생성
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 8. 25. dong - 최초생성
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
        for (int i = 0; i < param.getHeaderName().length; i++) {
            subjectCell = row.createCell(i, Cell.CELL_TYPE_STRING);
            subjectCell.setCellValue(content);
            subjectCell.setCellStyle(cellStyleS);
        }
        // 제목 셀 통합
        sheet.addMergedRegion(
                new CellRangeAddress(row.getRowNum(), row.getRowNum(), 0, param.getHeaderName().length - 1));

        // 헤더 생성
        row = sheet.createRow(2);
        for (String headName : param.getHeaderName()) {
            headerCell = row.createCell(cnt, Cell.CELL_TYPE_STRING);
            headerCell.setCellValue(headName);
            headerCell.setCellStyle(cellStyleH);
            cnt += 1;
        }

        // 본문 생성
        if (null != param.getDataList() && param.getDataList().size() > 0) {
            int vstrCntSum = 0;
            float rtoSum = 0;

            try {
                for (int i = 0; i < param.getDataList().size(); i++) {
                    row = sheet.createRow(i + 3);
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

                                if ("vstrCnt".equals(fields[j].getName())) {
                                    vstrCntSum += Integer.parseInt(fields[j].get(obj).toString().replace(",", ""));
                                }

                                if ("rto".equals(fields[j].getName())) {
                                    rtoSum += Float.parseFloat(fields[j].get(obj).toString());
                                }
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
            row = sheet.createRow(param.getDataList().size() + 3);
            for (int endI = 0; endI < param.getFieldName().length; endI++) {
                contentCell = row.createCell(endI, Cell.CELL_TYPE_STRING);
                if (endI == 0) {
                    contentCell.setCellValue("합계");
                } else if (endI == 2) {
                    contentCell.setCellValue(df.format(vstrCntSum));
                } else if (endI == 3) {
                    contentCell.setCellValue(rtoSum);
                }
                contentCell.setCellStyle(cellStyleH);
            }
        }
    }
}
