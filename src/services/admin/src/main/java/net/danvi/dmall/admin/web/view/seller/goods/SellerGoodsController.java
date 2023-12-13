package net.danvi.dmall.admin.web.view.seller.goods;

import java.io.Closeable;
import java.lang.reflect.Field;
import java.net.URLEncoder;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.danvi.dmall.biz.app.goods.model.*;
import net.danvi.dmall.biz.app.goods.service.FilterManageService;
import net.danvi.dmall.biz.app.operation.model.ReplaceCdVO;
import net.danvi.dmall.biz.app.operation.model.SmsSendSO;
import net.danvi.dmall.biz.app.operation.service.SmsSendService;
import org.apache.commons.lang.StringUtils;
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
import org.springframework.validation.BindingResult;
import org.springframework.validation.Errors;
import org.springframework.validation.Validator;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;

import dmall.framework.common.constants.ExceptionConstants;
import dmall.framework.common.exception.JsonValidationException;
import dmall.framework.common.model.ExcelViewParam;
import dmall.framework.common.model.ResultListModel;
import dmall.framework.common.model.ResultModel;
import dmall.framework.common.util.DateUtil;
import dmall.framework.common.util.FileUtil;
import dmall.framework.common.util.LucyUtil;
import dmall.framework.common.util.MessageUtil;
import dmall.framework.common.util.StringUtil;
import lombok.extern.slf4j.Slf4j;
import net.danvi.dmall.admin.web.common.util.ExcelReader;
import net.danvi.dmall.admin.web.common.view.View;
import net.danvi.dmall.biz.app.goods.service.GoodsManageService;
import net.danvi.dmall.biz.app.main.service.MainService;
import net.danvi.dmall.biz.app.seller.model.SellerSO;
import net.danvi.dmall.biz.app.seller.model.SellerVO;
import net.danvi.dmall.biz.app.seller.service.SellerService;
import net.danvi.dmall.biz.system.security.DmallSessionDetails;
import net.danvi.dmall.biz.system.security.SessionDetailHelper;
import net.danvi.dmall.biz.system.service.MenuService;
import net.danvi.dmall.biz.system.service.SiteQuotaService;
import net.danvi.dmall.biz.system.util.ServiceUtil;

/**
 * <pre>
 * 프로젝트명 : 41.admin.web
 * 작성일     : 2017. 11. 16.
 * 작성자     : 
 * 설명       : 판매자 컨트롤러
 * </pre>
 */

@Slf4j
@Controller
@RequestMapping("/admin/seller/goods")
public class SellerGoodsController {

    @Resource(name = "adminMainService")
    private MainService mainService;    
    
    @Resource(name = "sellerService")
    private SellerService sellerService;
    
    @Resource(name = "menuService")
    private MenuService menuService;
    
    @Resource(name = "goodsManageService")
    private GoodsManageService goodsManageService;
    
    @Resource(name = "siteQuotaService")
    private SiteQuotaService siteQuotaService;
    
    @Resource(name = "excelReader")
    private ExcelReader excelReader;

    @Resource(name = "filterManageService")
    private FilterManageService filterManageService;

    @Resource(name = "smsSendService")
    private SmsSendService smsSendService;

    /**
     * <pre>
     * 작성일 : 2016. 5. 12.
     * 작성자 : dong
     * 설명   : 판매상품관리 화면(/admin/goods/goodsManageList)을 반환한다.
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 12. dong - 최초생성
     * </pre>
     *
     * @return
     */
    @RequestMapping("/sales-item")
    public ModelAndView viewGoodsList(HttpServletRequest req) {
        ModelAndView mav = new ModelAndView("/admin/seller/goods/goodsManageList");//
        mav.addObject("siteNo", SessionDetailHelper.getDetails().getSiteNo());

        String typeCd = req.getParameter("typeCd");
        mav.addObject("typeCd", typeCd);

        DmallSessionDetails sessionInfo = SessionDetailHelper.getDetails();
        if (sessionInfo == null) {
            throw new BadCredentialsException(MessageUtil.getMessage(ExceptionConstants.BIZ_EXCEPTION_LNG + ExceptionConstants.ERROR_CODE_LOGIN_SESSION));
        }

        FilterSO filterSO = new FilterSO();
        filterSO.setSiteNo(sessionInfo.getSiteNo());
        filterSO.setGoodsTypeCd(typeCd);
        if (typeCd.equals("01")) {
            filterSO.setFilterMenuLvl("2");
            filterSO.setFilterItemLvl("3");
            filterSO.setFilterNo("1");
        } else if (typeCd.equals("02")) {
            filterSO.setFilterMenuLvl("2");
            filterSO.setFilterItemLvl("3");
            filterSO.setFilterNo("2");
        }

        List<FilterVO> filterVOList = filterManageService.selectFilterListGoodsType(filterSO);
        mav.addObject("resultFilterList", filterVOList);

        String referer = req.getHeader("Referer");
        if (referer.contains("/goods-detail") || referer.contains("/goods-detail-edit")) {
            mav.addObject("viewList", true);
        } else {
            mav.addObject("viewList", false);
        }

        return mav;
    }

    /**
     * <pre>
     * 작성일 : 2022. 9. 19.
     * 작성자 : slims
     * 설명   : 판매상품관리 화면(/admin/seller/goods/goodsManageGlassesFrameList)을 반환한다.
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2022. 9. 19. slims - 최초생성
     * </pre>
     *
     * @return
     */
    @RequestMapping("/glasses-frame")
    public ModelAndView viewGoodsGlassesFrameList() {
        ModelAndView mav = new ModelAndView("/admin/seller/goods/goodsManageGlassesFrameList");//
        mav.addObject("siteNo", SessionDetailHelper.getDetails().getSiteNo());
        return mav;
    }

    /**
     * <pre>
     * 작성일 : 2022. 9. 19.
     * 작성자 : slims
     * 설명   : 판매상품관리 화면(/admin/seller/goods/goodsManageSunGlassesList)을 반환한다.
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2022. 9. 19. slims - 최초생성
     * </pre>
     *
     * @return
     */
    @RequestMapping("/sun-glasses")
    public ModelAndView viewGoodsSunGlassesList() {
        ModelAndView mav = new ModelAndView("/admin/seller/goods/goodsManageSunGlassesList");//
        mav.addObject("siteNo", SessionDetailHelper.getDetails().getSiteNo());
        return mav;
    }

    /**
     * <pre>
     * 작성일 : 2022. 9. 19.
     * 작성자 : slims
     * 설명   : 판매상품관리 화면(/admin/seller/goods/goodsManageContactLensesList)을 반환한다.
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2022. 9. 19. slims - 최초생성
     * </pre>
     *
     * @return
     */
    @RequestMapping("/contact-lenses")
    public ModelAndView viewGoodsContactLensesList() {
        ModelAndView mav = new ModelAndView("/admin/seller/goods/goodsManageContactLensesList");//
        mav.addObject("siteNo", SessionDetailHelper.getDetails().getSiteNo());
        return mav;
    }

    /**
     * <pre>
     * 작성일 : 2022. 9. 19.
     * 작성자 : slims
     * 설명   : 판매상품관리 화면(/admin/seller/goods/goodsManageGlassesLensesList)을 반환한다.
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2022. 9. 19. slims - 최초생성
     * </pre>
     *
     * @return
     */
    @RequestMapping("/glasses-lenses")
    public ModelAndView viewGoodsGlassesLensesList() {
        ModelAndView mav = new ModelAndView("/admin/seller/goods/goodsManageGlassesLensesList");//
        mav.addObject("siteNo", SessionDetailHelper.getDetails().getSiteNo());
        return mav;
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 12.
     * 작성자 : dong
     * 설명   : 상품관리 화면(/admin/goods/goodsDetail)을 반환한다.
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 12. dong - 최초생성
     * </pre>
     *
     * @return
     */
    @RequestMapping("/goods-detail")
    public ModelAndView viewGoodsDetail(GoodsSO so) {
        ModelAndView mav = new ModelAndView("/admin/seller/goods/goodsDetail");
        mav.addObject("resultModel", goodsManageService.getNewGoodsNo(so));
        
        // 판매자 상세 조회
        SellerSO sellerSO = new SellerSO();
        sellerSO.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
        sellerSO.setSellerNo(String.valueOf(SessionDetailHelper.getDetails().getSession().getSellerNo()));
        ResultModel<SellerVO> vo = sellerService.selectSellerInfo(sellerSO);
        mav.addObject("sellerCmsRate", vo.getData().getSellerCmsRate());
        
        // 아이콘 추가 가능 여부
        boolean isAbleAddIcon = siteQuotaService.isIconAddible(so.getSiteNo());
        mav.addObject("isAbleAddIcon", isAbleAddIcon);
        mav.addObject("siteNo", SessionDetailHelper.getDetails().getSiteNo());

        FilterSO filterSO = new FilterSO();
        filterSO.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
        filterSO.setGoodsTypeCd(so.getTypeCd());
        if (so.getTypeCd().equals("01")) {
            filterSO.setFilterMenuLvl("2");
            filterSO.setFilterItemLvl("3");
            filterSO.setFilterNo("1");
        } else if (so.getTypeCd().equals("02")) {
            filterSO.setFilterMenuLvl("2");
            filterSO.setFilterItemLvl("3");
            filterSO.setFilterNo("2");
        }
        List<FilterVO> filterVOList = filterManageService.selectFilterListGoodsType(filterSO);

        mav.addObject("resultFilter", filterVOList);

        mav.addObject("typeCd", so.getTypeCd());
        return mav;
    }
    
    /**
     * <pre>
     * 작성일 : 2016. 5. 12.
     * 작성자 : dong
     * 설명   : 상품등록(대량) 화면(/admin/goods/goodsUploadForm)을 반환한다.
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 12. dong - 최초생성
     * </pre>
     *
     * @return
     */
    @RequestMapping("/goods-bulk-regist")
    public ModelAndView viewGoodsUpload(GoodsSO so) {
        ModelAndView mav = new ModelAndView("/admin/seller/goods/goodsUploadForm");
        return mav;
    }
    

    /**
     * <pre>
     * 작성일 : 2016. 5. 12.
     * 작성자 : dong
     * 설명   : 판매상품관리 화면에서 선택한 조건에 해당하는
     *          상품 관련 정보를 조회하여 JSON 형태로 반환한다.
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 12. dong - 최초생성
     * </pre>
     *
     * @param goodsSO
     * @return
     */
    @RequestMapping("/goods-list")
    public @ResponseBody ResultListModel<GoodsVO> selectGoodsListPaging(GoodsSO goodsSO) {
        DmallSessionDetails sessionInfo = SessionDetailHelper.getDetails();
        if (sessionInfo == null) {
            throw new BadCredentialsException(MessageUtil.getMessage(ExceptionConstants.BIZ_EXCEPTION_LNG + ExceptionConstants.ERROR_CODE_LOGIN_SESSION));
        }
        
        //판매자 세팅
        goodsSO.setSearchSeller(String.valueOf(SessionDetailHelper.getSession().getSellerNo()));
        goodsSO.setSearchSellerLogin("Y");
        goodsSO.setAdminYn("Y");
        ResultListModel<GoodsVO> result = goodsManageService.selectGoodsList(goodsSO);
        return result;
    }
    
    

    /**
     * <pre>
     * 작성일 : 2016. 9. 28.
     * 작성자 : dong
     * 설명   : 상품 수정 화면(/admin/goods/goodsDetail)을 반환한다.
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 9. 28. dong - 최초생성
     * </pre>
     *
     * @param so
     * @return
     */
    @RequestMapping("/goods-detail-edit")
    public ModelAndView editGoodsDetail(GoodsSO so) {
        ModelAndView mav = new ModelAndView("/admin/seller/goods/goodsDetail");
        ResultModel<GoodsVO> resultModel = new ResultModel<>();
        GoodsVO vo = new GoodsVO();
        vo.setGoodsNo(so.getGoodsNo());
        vo.setEditModeYn("Y");
        resultModel.setData(vo);
        mav.addObject("resultModel", resultModel);
        
        // 아이콘 추가 가능 여부
        boolean isAbleAddIcon = siteQuotaService.isIconAddible(so.getSiteNo());
        log.debug("isAbleAddIcon : " + isAbleAddIcon);
        mav.addObject("isAbleAddIcon", String.valueOf(isAbleAddIcon));
        mav.addObject("siteNo", SessionDetailHelper.getDetails().getSiteNo());

        FilterSO filterSO = new FilterSO();
        filterSO.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
        filterSO.setGoodsTypeCd(so.getTypeCd());
        if (so.getTypeCd().equals("01")) {
            filterSO.setFilterMenuLvl("2");
            filterSO.setFilterItemLvl("3");
            filterSO.setFilterNo("1");
        } else if (so.getTypeCd().equals("02")) {
            filterSO.setFilterMenuLvl("2");
            filterSO.setFilterItemLvl("3");
            filterSO.setFilterNo("2");
        }
        filterSO.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
        List<FilterVO> filterVOList = filterManageService.selectFilterListGoodsType(filterSO);


        mav.addObject("resultFilter", filterVOList);
        mav.addObject("goodsInfoChangeHist", goodsManageService.selectGoodsInfoChangeHist(so));

        mav.addObject("typeCd", so.getTypeCd());
        return mav;
    }
    
    
    /**
     * <pre>
     * 작성일 : 2016. 9. 28.
     * 작성자 : dong
     * 설명   : JSON형태로 상품 정보를 입력받아 해당 상품 정보를 등록한다.
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 9. 28. dong - 최초생성
     * </pre>
     *
     * @param po
     * @param bindingResult
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/goods-info-insert")
    public @ResponseBody ResultModel<GoodsDetailPO> insertGoodsInfo(@Validated @RequestBody GoodsDetailPO po,
            BindingResult bindingResult) throws Exception {

        // JSON 요청에 대한 LUCY 필터 수동 적용
        //LucyUtil.filter("/admin/seller/goods/goods-info-insert", po);

        GoodsDetailPOValidator validator = new GoodsDetailPOValidator();
        validator.validate(po, bindingResult);
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }

        //po.setRsvOnlyYn("N"); //예약전용 defult setting
        po.setSellerNo(String.valueOf(SessionDetailHelper.getSession().getSellerNo()));

        // 판매자가 상품을 최초 등폭시 관리자의 승인을 받아야함. 디폴트로 판매대기로 저정한다.
        // 관리자 승인후 판매 상태 변경 가능
        if (po.getGoodsSaleStatusCd() == null || "".equals(po.getGoodsSaleStatusCd())) {
        	po.setGoodsSaleStatusCd("3");
        }
        
        ResultModel<GoodsDetailPO> resultModel = goodsManageService.insertGoodsInfo(po);

        // 상품 승인 요청일 때 관리자에게 sms 전송
        if ("3".equals(po.getGoodsSaleStatusCd())) {
            ReplaceCdVO smsReplaceVO = new ReplaceCdVO();
            smsReplaceVO.setGoodsNm(po.getGoodsNm());

            SmsSendSO smsSendSO = new SmsSendSO();
            smsSendSO.setSiteNo(po.getSiteNo());
            smsSendSO.setSendTypeCd("37");
            smsSendSO.setAdminTemplateCode("mk050");

            smsSendService.sendAutoSms(smsSendSO, smsReplaceVO);
        }
        return resultModel;
    }
    
    
    /**
     * <pre>
     * 작성일 : 2016. 8. 16.
     * 작성자 : dong
     * 설명   : 상품 업로드 엑셀입력 처리
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 8. 16. dong - 최초생성
     * </pre>
     *
     * @param mRequest
     * @return
     * @throws Exception
     */
    @RequestMapping("/goods-excel-upload")
    public @ResponseBody ResultListModel<GoodsDetailPO> uploadGoodsInsertList(MultipartHttpServletRequest mRequest)
            throws Exception {
        ResultListModel<GoodsDetailPO> result = new ResultListModel();

        // FileVO result = new FileVO();
        MultipartFile file = FileUtil.getExcel(mRequest, "excel");

        // 엑셀 파일을 읽어 리스트 형태로 반환
        List<Map<String, Object>> list = excelReader.convertExcelToListByMap(file);
        // log.info("=================> kwt list : " + list);
        
        List<Map<String, Object>> slist = new ArrayList<Map<String, Object>>();
        for (Map<String, Object> map : list) {
        	map = list.get(0);
        	map.put("sellerNo", SessionDetailHelper.getSession().getSellerNo());
        	slist.add(map);
        }
        log.info("=================> kwt slist : " + slist);
        
        result.setResultList(goodsManageService.uploadGoodsInsertList(slist, mRequest));

        // log.info("=================> kwt result.getResultList() : " +
        // result.getResultList());

        if (result.getResultList() != null && result.getResultList().size() > 0) {
            result.setTotalRows(result.getResultList().size());
            result.setMessage("업로드된 상품 정보가 등록되었습니다.");
            result.setSuccess(true);
        } else {
            result.setTotalRows(result.getResultList().size());
            result.setMessage("등록된 상품 정보가 없습니다..");
            result.setSuccess(false);
        }
        return result;
    }
    
    

    /**
     * <pre>
     * 작성일 : 2016. 6. 10.
     * 작성자 : dong
     * 설명   : 판매상품관리 화면에서 엑셀출력 버튼 클릭시 화면에 표시된 검색결과를 받아
     *          상품 정보를 조회하여 엑셀형식으로 출력한다.
     *          공통 엑셀다운로드 기능의 경우 엑셀 시트의 헤더 및 본문의 병합을 지원하지않아
     *          별도 처리 로직을 구현.
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 10. dong - 최초생성
     * </pre>
     *
     * @param so
     * @param response
     * @return
     * @throws Exception
     */
    @RequestMapping("/download-excel")
    public String downloadExcel(GoodsSO so, HttpServletResponse response) throws Exception {
    	
    	so.setSearchSeller(String.valueOf(SessionDetailHelper.getSession().getSellerNo()));
    	
        // 엑셀로 출력할 데이터 조회
        ResultListModel<GoodsVO> resultListModel = goodsManageService.selectGoodsExcelList(so);
        // 엑셀의 헤더 정보 세팅 {{ 컬럼헤더명, 시작컬럼, 종료컬럼, 시작열, 종료열 }}
        String[][] headerConfigName = { { "번호", "0", "0", "0", "1" }, { "상품명", "1", "1", "0", "1" },
                { "상품코드", "2", "2", "0", "1" }, { "옵션1", "3", "3", "0", "0" }, { "옵션2", "4", "4", "0", "0" },
                { "옵션3", "5", "5", "0", "0" }, { "옵션4", "6", "6", "0", "0" }, { "브랜드", "7", "7", "0", "1" },
                { "판매자", "8", "8", "0", "1" }, { "원가", "9", "9", "0", "1" }, { "판매가", "10", "10", "0", "1" }, { "택배가", "11", "11", "0", "1" },
                { "공급가", "12", "12", "0", "1" }, { "재고", "13", "13", "0", "1" }, { "판매상태", "14", "14", "0", "1" },
                { "다비전상품코드", "15", "15", "0", "1" }, { "등록일", "16", "16", "0", "1" }, { "옵션값", "3", "3", "1", "1" },
                { "옵션값", "4", "4", "1", "1" }, { "옵션값", "5", "5", "1", "1" }, { "옵션값", "6", "6", "1", "1" }
        };
        // 엑셀에 출력할 데이터 세팅
        String[] fieldName = new String[] { "rownum", "goodsNm", "goodsNo", "attr1", "attr2", "attr3", "attr4", "brandNm",
                "sellerNm", "cost", "salePrice", "goodseachDlvrc", "customerPrice", "stockQtt", "goodsSaleStatusNm",
                "erpItmCode", "regDate" };
        // 엑셀파일명 PRE
        String excelFileName = "goods_list";
        // 엑셀파일명에 쓰일 일시포멧
        SimpleDateFormat fileFormat = new SimpleDateFormat("yyyyMMdd_HHmmss");
        // 파일명 지정
        String excelName = excelFileName + "_" + fileFormat.format(new Date()) + ".xlsx";
        // 파일명 처리
        String fileName = URLEncoder.encode(excelName, "UTF-8").replaceAll("\\+", " ");
        // 엑셀작성 파라메터 설정
        ExcelViewParam excel = new ExcelViewParam("판매상품목록", headerConfigName, fieldName,
                resultListModel.getResultList());
        // 엑셀파일 처리를 위한 설정
        response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
        response.setHeader("Content-Disposition", "attachment; filename=\"" + fileName + "\"");

        // POI Workbook 설정
        Workbook workbook = new XSSFWorkbook();
        // 엑셀 Sheet 내용 생성
        createSheet(workbook, excel);
        // 생성된 Workbook 출력
        workbook.write(response.getOutputStream());

        // 자원 종료. Closeable only implemented as of POI 3.10
        if (workbook instanceof Closeable) {
            ((Closeable) workbook).close();
        }
        // 공 view 반환
        return View.voidView();
    }
    
    /**
     * <pre>
     * 작성일 : 2016. 6. 10.
     * 작성자 : dong
     * 설명   : POI 를 이용하여 엑셀 Sheet를 생성한다.
     *          공통으로 사용하는 ExcelView의 내용을 기반으로
     *          헤더정보의 병합처리 및 특정 컬럼의 값을 비교하여 동일할 경우,
     *          상하 Row를 병합하는 처리를 추가하였다.
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 10. dong - 최초생성
     * </pre>
     *
     * @param workbook
     * @param param
     */
    private void createSheet(Workbook workbook, ExcelViewParam param) {
        Sheet sheet = workbook.createSheet(param.getSheetName());
        sheet.setDefaultColumnWidth(20);
        sheet.setDisplayGridlines(true);
        sheet.setDefaultRowHeightInPoints((short) 15);

        // 헤더 Style
        CellStyle cellStyleH = workbook.createCellStyle();
        Font cellFontH = workbook.createFont();
        cellFontH = createCellFont(cellFontH);
        cellStyleH = createCellStyle(cellStyleH, cellFontH);
        cellStyleH.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
        cellStyleH.setFillForegroundColor(IndexedColors.GREY_25_PERCENT.getIndex());
        cellStyleH.setFillPattern(CellStyle.SOLID_FOREGROUND);

        // 본문 Style
        CellStyle cellStyle = workbook.createCellStyle();
        Font cellFont = workbook.createFont();
        cellFont = createCellFont(cellFont);
        cellStyle = createCellStyle(cellStyle, cellFont);
        cellStyle.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
        cellStyle.setFillForegroundColor(IndexedColors.WHITE.getIndex());
        cellStyle.setFillPattern(CellStyle.SOLID_FOREGROUND);

        // 생성대상 row
        int i = 0;

        // 헤더정보 생성
        if (null != param.getHeaderConfigName() && param.getHeaderConfigName().length > 0) {
            i = makeExHeader(param.getHeaderConfigName(), sheet, workbook, cellStyleH) + 1;
        }

        // 본문 생성
        if (null != param.getDataList() && param.getDataList().size() > 0) {
            Row row = null;
            String currentId = "";
            String preId = "";
            int currentIdStartNo = i;

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
                                            String grpCd = fieldName;// .substring(0,
                                            // fieldName.lastIndexOf("_CD"));
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
                                }
                            } catch (Exception e) {
                                //
                            }
                            row.createCell(j).setCellValue(fieldValue);
                            row.getCell(j).setCellStyle(cellStyle);

                            if ("goodsNo".equalsIgnoreCase(name)) {
                                currentId = fieldValue;
                            }
                        } catch (Exception e) {
                            //
                        }
                        j++;
                    }
                    ;

                    // 공통에 추가된 부분
                    // 특정 컬럼의 값이 이전 행의 값과 다를 경우 이전 행을 병합처리한다.
                    if (!currentId.equals(preId)) {
                        if (currentIdStartNo + 1 < i) {
                            sheet.addMergedRegion(new CellRangeAddress(currentIdStartNo, i - 1, 1, 1));
                            sheet.addMergedRegion(new CellRangeAddress(currentIdStartNo, i - 1, 2, 2));
                            sheet.addMergedRegion(new CellRangeAddress(currentIdStartNo, i - 1, 3, 3));
                            sheet.addMergedRegion(new CellRangeAddress(currentIdStartNo, i - 1, 4, 4));

                            sheet.addMergedRegion(new CellRangeAddress(currentIdStartNo, i - 1, 12, 12));
                            sheet.addMergedRegion(new CellRangeAddress(currentIdStartNo, i - 1, 13, 13));
                            sheet.addMergedRegion(new CellRangeAddress(currentIdStartNo, i - 1, 14, 14));
                            sheet.addMergedRegion(new CellRangeAddress(currentIdStartNo, i - 1, 15, 15));
                        }
                        currentIdStartNo = i;
                    }
                    preId = currentId;
                }
                i++;
            }
        }
    }
    
    

    /**
     * <pre>
     * 작성일 : 2016. 6. 10.
     * 작성자 : dong
     * 설명   : 헤더정보를 이용하여 엑셀시트내의 테이블의 헤더정보를 생성한다.
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 10. dong - 최초생성
     * </pre>
     *
     * @param header
     *            헤더정보
     * @param sheet
     *            POI Sheet
     * @param wb
     *            POI Workbook
     * @param headerStyle
     *            POI CellStyle
     * @return
     */
    private int makeExHeader(String[][] header, Sheet sheet, Workbook wb, CellStyle headerStyle) {
        int rowMax = 0;
        int rowCnt = -1;
        for (int j = 0; j < header.length; j++) {
            // 컬럼사이즈 지정
            sheet.autoSizeColumn(j);

            // 헤더 정보에 있는 설정을 이용하여 테이블 헤더의 병합내용을 설정한다.
            int rowStart = Integer.parseInt(header[j][3]);
            int rowEnd = Integer.parseInt(header[j][4]);
            if (rowMax <= rowEnd) {
                rowMax = rowEnd;
            }
            if (rowCnt != rowStart) {
                rowCnt = rowStart;
            }
            int sCol = Integer.parseInt(header[j][1]);

            // 헤더부분의 POI 열 생성 및 컬럼값, 스타일을 적용한다.
            Cell headerCell = null;
            Row row = null;
            for (int k = rowStart; k < rowEnd + 1; k++) {
                row = sheet.getRow(k);
                if (row == null) {
                    row = sheet.createRow(k);
                }
                headerCell = row.createCell(sCol, Cell.CELL_TYPE_STRING); 
                headerCell.setCellValue(header[j][0]);
                headerCell.setCellStyle(headerStyle);
            }
            // 설정된 병합값으로 헤더를 병합한다.
            sheet.addMergedRegion(
                    new CellRangeAddress(Integer.parseInt(header[j][3]), (short) Integer.parseInt(header[j][4]),
                            Integer.parseInt(header[j][1]), (short) Integer.parseInt(header[j][2])));
        }

        // 헤더표시에 사용된 Row 값을 반환한다.
        return rowMax;
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
    
    
    
    
    /**
     * <pre>
     * 프로젝트명 : 41.admin.web
     * 작성일     : 2016. 9. 28.
     * 작성자     : dong
     * 설명       : 상품 설정 정보 유효성 검증 클래스
     * </pre>
     */
    class GoodsDetailPOValidator implements Validator {

        @Override
        public boolean supports(Class clazz) {
            return GoodsDetailPO.class.equals(clazz);
        }

        @Override
        public void validate(Object target, Errors errors) {
            GoodsDetailPO po = (GoodsDetailPO) target;

            if ("Y".equals(po.getMultiOptYn())) {
                if (po.getGoodsItemList() != null) {
                    List<GoodsItemPO> goodsItemPOList = po.getGoodsItemList();

                    List<String> attrNmList = new ArrayList<String>();
                    GoodsItemPO goodsItemPO = null;
                    for (int i = 0; i < goodsItemPOList.size(); i++) {
                        goodsItemPO = goodsItemPOList.get(i);

                        if (goodsItemPO.getSalePrice() == null) {
                            errors.rejectValue("goodsItemList[" + i + "].salePrice", "admin.web.gds.validate");
                        }

                        if (goodsItemPO.getSupplyPrice() == null) {
                            errors.rejectValue("goodsItemList[" + i + "].supplyPrice", "admin.web.gds.validate");
                        }

                        if (goodsItemPO.getSalePrice() != null && goodsItemPO.getSalePrice() > 0
                                && goodsItemPO.getSupplyPrice() != null && goodsItemPO.getSupplyPrice() > 0) {
                            if (goodsItemPO.getSupplyPrice() > goodsItemPO.getSalePrice()) {
                                errors.rejectValue("goodsItemList[" + i + "].supplyPrice", "admin.web.gds.validate");
                            }
                        }

                        String attrNm1 = StringUtils.isEmpty(goodsItemPO.getAttrValue1()) ? "": goodsItemPO.getAttrValue1().trim();
                        String attrNm2 = StringUtils.isEmpty(goodsItemPO.getAttrValue2()) ? "": goodsItemPO.getAttrValue2().trim();
                        String attrNm3 = StringUtils.isEmpty(goodsItemPO.getAttrValue3()) ? "": goodsItemPO.getAttrValue3().trim();
                        String attrNm4 = StringUtils.isEmpty(goodsItemPO.getAttrValue4()) ? "": goodsItemPO.getAttrValue4().trim();

                        StringBuffer sbTemp = new StringBuffer().append(attrNm1).append("^").append(attrNm2).append("^").append(attrNm3).append("^").append(attrNm4);

                        for (String attrNm : attrNmList) {
                            if (attrNm != null && attrNm.equals(sbTemp.toString())) {
                                errors.rejectValue("goodsItemList[" + i + "].attrValue1", "admin.web.gds.validate");
                            }
                        }
                        attrNmList.add(sbTemp.toString());

                    }
                }

            } else {
                if (!StringUtils.isEmpty(po.getSaleStartDt()) && !StringUtils.isEmpty(po.getSaleEndDt())) {
                    if (DateUtil.compareToCalerdar(po.getSaleEndDt(), po.getSaleStartDt()) < 0) {
                        errors.rejectValue("saleStartDt", "admin.web.gds.validate");
                    }
                }
            }

            if (po.getGoodsNotifyList() != null) {
                List<GoodsNotifyPO> goodsNotifyPOList = po.getGoodsNotifyList();
                GoodsNotifyPO goodsNotifyPO = null;
                for (int i = 0; i < goodsNotifyPOList.size(); i++) {
                    goodsNotifyPO = goodsNotifyPOList.get(i);
                    if (goodsNotifyPO.getItemNo() < 1) {
                        errors.rejectValue("goodsNotifyPOList[" + i + "].itemNo", "itemNo");
                    }
                    if (StringUtils.isEmpty(goodsNotifyPO.getItemValue())) {
                        errors.rejectValue("goodsNotifyPOList[" + i + "].itemValue", "itemValue");
                    }
                }
            }

        }

    }
    
    
    /**
     * <pre>
     * 작성일 : 2018. 8. 2.
     * 작성자 : khy
     * 설명   : 판매자별 수소료 조회
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2018. 8. 2. khy - 최초생성
     * </pre>
     *
     * @param SellerVO
     * @return
     */
    @RequestMapping("/seller-info")
    public @ResponseBody ResultModel<SellerVO> selectSelelrCmsRate(SellerSO so) {
    	return sellerService.selectSellerInfo(so);
    }
        
    
}
