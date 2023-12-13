package net.danvi.dmall.admin.web.view.goods.controller;

import java.io.Closeable;
import java.io.File;
import java.io.IOException;
import java.lang.reflect.Field;
import java.net.URLEncoder;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import dmall.framework.common.constants.*;
import dmall.framework.common.model.*;
import net.danvi.dmall.biz.app.design.model.BannerVO;
import net.danvi.dmall.biz.app.design.model.IconSO;
import net.danvi.dmall.biz.app.design.model.IconVO;
import net.danvi.dmall.biz.app.design.service.IconManageService;
import net.danvi.dmall.biz.app.goods.model.*;
import net.danvi.dmall.biz.app.goods.service.FilterManageService;
import net.danvi.dmall.biz.app.member.manage.service.MemberManageService;
import net.danvi.dmall.biz.ifapi.cmmn.CustomIfException;
import net.danvi.dmall.biz.ifapi.cmmn.base.BaseReqDTO;
import net.danvi.dmall.biz.ifapi.cmmn.constant.Constants;
import net.danvi.dmall.biz.ifapi.cmmn.mapp.service.MappingService;
import net.danvi.dmall.biz.ifapi.cmmn.service.LogService;
import net.danvi.dmall.biz.ifapi.prd.dto.*;
import net.danvi.dmall.biz.ifapi.prd.service.ProductService;
import net.danvi.dmall.biz.ifapi.rsv.dto.ReserveProductSearchReqDTO;
import net.danvi.dmall.biz.ifapi.rsv.dto.ReserveProductSearchResDTO;
import net.danvi.dmall.biz.ifapi.rsv.service.ReserveService;
import net.danvi.dmall.biz.ifapi.util.IFCryptoUtil;
import net.sf.json.JSONObject;
import org.apache.commons.io.FilenameUtils;
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
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.validation.BindingResult;
import org.springframework.validation.Errors;
import org.springframework.validation.Validator;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;

import lombok.extern.slf4j.Slf4j;
import net.danvi.dmall.admin.web.common.util.ExcelReader;
import net.danvi.dmall.admin.web.common.util.GoodsImageHandler;
import net.danvi.dmall.admin.web.common.util.GoodsImageInfoData;
import net.danvi.dmall.admin.web.common.util.GoodsImageType;
import net.danvi.dmall.admin.web.common.view.View;
import net.danvi.dmall.biz.app.goods.service.GoodsManageService;
import net.danvi.dmall.biz.app.setup.base.service.AdminAuthConfigService;
import net.danvi.dmall.biz.app.setup.siteinfo.model.SiteSO;
import net.danvi.dmall.biz.app.setup.siteinfo.service.SiteInfoService;
import net.danvi.dmall.biz.system.model.SiteCacheVO;
import net.danvi.dmall.biz.system.security.SessionDetailHelper;
import net.danvi.dmall.biz.system.security.DmallSessionDetails;
import net.danvi.dmall.biz.system.service.SiteQuotaService;
import net.danvi.dmall.biz.system.service.SiteService;
import net.danvi.dmall.biz.system.util.InterfaceUtil;
import net.danvi.dmall.biz.system.util.ServiceUtil;
import net.danvi.dmall.biz.system.validation.UpdateGroup;
import dmall.framework.admin.constants.AdminConstants;
import dmall.framework.common.exception.CustomException;
import dmall.framework.common.exception.JsonValidationException;
import dmall.framework.common.util.CryptoUtil;
import dmall.framework.common.util.DateUtil;
import dmall.framework.common.util.FileUtil;
import dmall.framework.common.util.MessageUtil;
import dmall.framework.common.util.StringUtil;

/**
 * 판매상품관리 Controller
 *
 * @author dong
 * @since 2016.05.04
 */
/**
 * 네이밍 룰
 * View 화면
 * Grid 그리드
 * Tree 트리
 * Ajax Ajax
 * Insert 입력
 * Update 수정
 * Delete 삭제
 * Save 입력 / 수정
 */
@Slf4j
@Controller
@RequestMapping("/admin/goods")
public class GoodsManageController {

    @Value("#{system['system.upload.file.size']}")
    private Long fileSize;

    @Resource(name = "excelReader")
    private ExcelReader excelReader;

    @Value("#{system['system.upload.path']}")
    private String uplaodFilePath;

    @Resource(name = "goodsImageHandler")
    private GoodsImageHandler imageHandler;

    @Resource(name = "adminAuthConfigService")
    private AdminAuthConfigService adminAuthConfigService;

    @Resource(name = "goodsManageService")
    private GoodsManageService goodsManageService;

    @Resource(name = "filterManageService")
    private FilterManageService filterManageService;

    @Resource(name = "memberManageService")
    private MemberManageService memberManageService;

    @Resource(name = "siteService")
    private SiteService siteService;

    @Resource(name = "siteInfoService")
    private SiteInfoService siteInfoService;

    @Resource(name = "siteQuotaService")
    private SiteQuotaService siteQuotaService;

    @Resource(name = "logService")
    private LogService logService;

    @Resource(name = "productService")
    private ProductService productService;

    @Resource(name = "reserveService")
    private ReserveService reserveService;

    @Resource(name = "iconManageService")
    private IconManageService iconManageService;
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
    public ModelAndView viewGoodsList(HttpServletRequest request) {
        ModelAndView mav = new ModelAndView("/admin/goods/goodsManageList");//
        mav.addObject("siteNo", SessionDetailHelper.getDetails().getSiteNo());
        String typeCd = request.getParameter("typeCd");
        log.info("glasses-frame typeCd = " + typeCd);
        mav.addObject("typeCd", typeCd);

        DmallSessionDetails sessionInfo = SessionDetailHelper.getDetails();
        if (sessionInfo == null) {
            throw new BadCredentialsException(MessageUtil.getMessage(ExceptionConstants.BIZ_EXCEPTION_LNG + ExceptionConstants.ERROR_CODE_LOGIN_SESSION));
        }

        FilterSO filterSO = new FilterSO();
        filterSO.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
        filterSO.setGoodsTypeCd(typeCd);
        if (typeCd.equals("01")) {
            filterSO.setFilterMenuLvl("2");
            filterSO.setFilterItemLvl("3");
            filterSO.setFilterNo("1");
        } else if (typeCd.equals("02")) {
            filterSO.setFilterMenuLvl("2");
            filterSO.setFilterItemLvl("3");
            filterSO.setFilterNo("2");
        } else if (typeCd.equals("03")) {
            filterSO.setFilterMenuLvl("2");
            filterSO.setFilterItemLvl("3");
            filterSO.setFilterNo("3");
        } else if (typeCd.equals("04")) {
            filterSO.setFilterMenuLvl("3");
            filterSO.setFilterItemLvl("4");
            filterSO.setFilterNo("4");
        } else {
            filterSO.setFilterMenuLvl("2");
            filterSO.setFilterItemLvl("3");
            filterSO.setFilterNo("5");
        }
        List<FilterVO> filterVOList = filterManageService.selectFilterListGoodsType(filterSO);
        mav.addObject("resultFilterList", filterVOList);

        String referer = request.getHeader("Referer");
        if (referer.contains("/goods-detail") || referer.contains("/goods-detail-edit")) {
            mav.addObject("viewList", true);
        } else {
            mav.addObject("viewList", false);
        }

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
        goodsSO.setSiteNo(sessionInfo.getSiteNo());
        goodsSO.setAdminYn("Y");
        ResultListModel<GoodsVO> result = goodsManageService.selectGoodsList(goodsSO);
        return result;
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 12.
     * 작성자 : dong
     * 설명   : 해당 사이트의 카테고리 목록을 조회하여 JSON 형태로 반환한다.
     *          파라메터에 설정된 상위 카테고리 번호가 존재할 경우
     *          해당 상위 카테고리의 하위 카테고리 목록을 반환한다.
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 12. dong - 최초생성
     * </pre>
     *
     * @param vo
     * @return
     */
    @RequestMapping("/goods-category-list")
    public @ResponseBody ResultListModel<CtgVO> selectCtgList(CtgVO vo) {
        ResultListModel<CtgVO> result = new ResultListModel<>();

        List<CtgVO> list = goodsManageService.selectCtgList(vo);
        result.setResultList(list);
        result.setSuccess(list.size() > 0 ? true : false);

        return result;
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 12.
     * 작성자 : dong
     * 설명   : 해당 사이트의 브랜드 목록을 조회하여 JSON 형태로 반환한다.
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 12. dong - 최초생성
     * </pre>
     *
     * @param vo
     * @return
     */
    @RequestMapping("/brand-list")
    public @ResponseBody ResultListModel<BrandVO> selectBrandList(BrandVO vo) {
        ResultListModel<BrandVO> result = new ResultListModel<>();

        List<BrandVO> list = goodsManageService.selectBrandList(vo);
        result.setResultList(list);
        result.setSuccess(list.size() > 0 ? true : false);

        return result;
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 12.
     * 작성자 : dong
     * 설명   : 다수의 상품정보를 받아서 해당 상품의 상품판매상태를 품절로 변경 한다.
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 12. dong - 최초생성
     * </pre>
     *
     * @param po
     * @param bindingResult
     * @return
     */
    @RequestMapping("/soldout-update")
    public @ResponseBody ResultModel<GoodsPO> updateSoldOut(GoodsPOListWrapper wrapper, BindingResult bindingResult) {

        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }

        ResultModel<GoodsPO> resultModel = goodsManageService.updateSoldOut(wrapper);
        return resultModel;
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 12.
     * 작성자 : dong
     * 설명   : 다수의 상품정보를 받아서 해당 상품의 상품전시상태를 전시/미전시 로 변경 한다.
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 12. dong - 최초생성
     * </pre>
     *
     * @param po
     * @param bindingResult
     * @return
     */
    @RequestMapping("/display-update")
    public @ResponseBody ResultModel<GoodsPO> updateDisplay(GoodsPOListWrapper wrapper, BindingResult bindingResult) {

        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }
        //전시/미전시 수정
        ResultModel<GoodsPO> resultModel = goodsManageService.updateDisplay(wrapper);
        return resultModel;
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 12.
     * 작성자 : dong
     * 설명   : 다수의 상품정보를 받아서 해당 상품의 상품판매상태를 판매중지로 변경 한다.
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 12. dong - 최초생성
     * </pre>
     *
     * @param po
     * @param bindingResult
     * @return
     */
    @RequestMapping("/salestop-update")
    public @ResponseBody ResultModel<GoodsPO> updateSaleStop(GoodsPOListWrapper wrapper, BindingResult bindingResult) {

        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }

        ResultModel<GoodsPO> resultModel = goodsManageService.updateSaleStop(wrapper);
        return resultModel;
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 12.
     * 작성자 : dong
     * 설명   : 다수의 상품정보를 받아서 해당 상품의 상품판매상태를 판매중으로 변경 한다.
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 12. dong - 최초생성
     * </pre>
     *
     * @param po
     * @param bindingResult
     * @return
     */
    @RequestMapping("/salestart-update")
    public @ResponseBody ResultModel<GoodsPO> updateSaleStart(GoodsPOListWrapper wrapper, BindingResult bindingResult) {

        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }

        ResultModel<GoodsPO> resultModel = goodsManageService.updateSaleStart(wrapper);
        return resultModel;
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 12.
     * 작성자 : dong
     * 설명   : 다수의 상품정보를 받아서 해당 상품의 상태 정보를 변경한다.
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 12. dong - 최초생성
     * </pre>
     *
     * @param po
     * @param bindingResult
     * @return
     */
    @RequestMapping("/goods-status-update")
    public @ResponseBody ResultModel<GoodsPO> updateGoodsStatus(GoodsPOListWrapper wrapper,
            BindingResult bindingResult) throws Exception {

        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }

        ResultModel<GoodsPO> resultModel = goodsManageService.updateGoodsStatus(wrapper);
        return resultModel;
    }

    /**
     * <pre>
     * 작성일 : 2016. 8. 11.
     * 작성자 : dong
     * 설명   : 다수의 상품정보를 삭제로 변경한다.(상품 삭제는 Flag 처리)
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 8. 11. dong - 최초생성
     * </pre>
     *
     * @param po
     * @param bindingResult
     * @return
     */
    @RequestMapping("/goods-delete")
    public @ResponseBody ResultModel<GoodsPO> deleteGoods(GoodsPOListWrapper wrapper, BindingResult bindingResult) {

        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }

        ResultModel<GoodsPO> resultModel = goodsManageService.deleteGoods(wrapper);
        return resultModel;
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

//        // 엑셀로 출력할 데이터 조회
//        ResultListModel<GoodsVO> resultListModel = goodsManageService.selectGoodsExcelList(so);
//        // 엑셀의 헤더 정보 세팅 {{ 컬럼헤더명, 시작컬럼, 종료컬럼, 시작열, 종료열 }}
//        String[][] headerConfigName = { { "번호", "0", "0", "0", "0" }, { "상품명", "1", "1", "0", "0" },
//                { "상품코드", "2", "2", "0", "0" }, { "브랜드", "3", "3", "0", "0" }, { "판매자", "4", "4", "0", "0" },
//                { "판매가", "5", "5", "0", "0" }, { "공급가", "6", "6", "0", "0" }, { "재고", "7", "7", "0", "0" },
//                { "판매상태", "8", "8", "0", "0" }, { "다비젼상품코드", "9", "9", "0", "0" } };
//        // 엑셀에 출력할 데이터 세팅
//        String[] fieldName = new String[] { "rownum", "goodsNm", "goodsNo", "brandNm", "sellerNm", "salePrice", "supplyPrice",
//                "stockQtt", "goodsSaleStatusNm", "erpItmCode" };
//        // 엑셀파일명 PRE
//        String excelFileName = "goods_list";
//        // 엑셀파일명에 쓰일 일시포멧
//        SimpleDateFormat fileFormat = new SimpleDateFormat("yyyyMMdd_HHmmss");
//        // 파일명 지정
//        String excelName = excelFileName + "_" + fileFormat.format(new Date()) + ".xlsx";
//        // 파일명 처리
//        String fileName = URLEncoder.encode(excelName, "UTF-8").replaceAll("\\+", " ");
//        // 엑셀작성 파라메터 설정
//        ExcelViewParam excel = new ExcelViewParam("판매상품목록", headerConfigName, fieldName,
//                resultListModel.getResultList());
//        // 엑셀파일 처리를 위한 설정
//        response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
//        response.setHeader("Content-Disposition", "attachment; filename=\"" + fileName + "\"");
//
//        // POI Workbook 설정
//        Workbook workbook = new XSSFWorkbook();
//        // 엑셀 Sheet 내용 생성
//        createSheet(workbook, excel);
//        // 생성된 Workbook 출력
//        workbook.write(response.getOutputStream());
//
//        // 자원 종료. Closeable only implemented as of POI 3.10
//        if (workbook instanceof Closeable) {
//            ((Closeable) workbook).close();
//        }
//        // 공 view 반환
//        return View.voidView();
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

        ModelAndView mav = new ModelAndView("/admin/goods/goodsDetail");
        mav.addObject("resultModel", goodsManageService.getNewGoodsNo(so));

        // 아이콘 추가 가능 여부
        boolean isAbleAddIcon = true/*siteQuotaService.isIconAddible(so.getSiteNo())*/;
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
        } else if (so.getTypeCd().equals("03")) {
            filterSO.setFilterMenuLvl("2");
            filterSO.setFilterItemLvl("3");
            filterSO.setFilterNo("3");
        } else if (so.getTypeCd().equals("04")) {
            filterSO.setFilterMenuLvl("3");
            filterSO.setFilterItemLvl("4");
            filterSO.setFilterNo("4");
        } else {
            filterSO.setFilterMenuLvl("2");
            filterSO.setFilterItemLvl("3");
            filterSO.setFilterNo("5");
        }
        List<FilterVO> filterVOList = filterManageService.selectFilterListGoodsType(filterSO);

        log.info("filterVOList = "+filterVOList);

        mav.addObject("resultFilter", filterVOList);
        mav.addObject("goodsInfoChangeHist", goodsManageService.selectGoodsInfoChangeHist(so));
        mav.addObject("typeCd", so.getTypeCd());
        return mav;
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
        ModelAndView mav = new ModelAndView("/admin/goods/goodsDetail");
        ResultModel<GoodsVO> resultModel = new ResultModel<>();
        GoodsVO vo = new GoodsVO();
        vo.setGoodsNo(so.getGoodsNo());
        vo.setEditModeYn("Y");
        vo.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
        resultModel.setData(vo);
        mav.addObject("resultModel", resultModel);

        // 아이콘 추가 가능 여부
        boolean isAbleAddIcon = siteQuotaService.isIconAddible(so.getSiteNo());
        log.info("isAbleAddIcon : " + isAbleAddIcon);
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
        } else if (so.getTypeCd().equals("03")) {
            filterSO.setFilterMenuLvl("2");
            filterSO.setFilterItemLvl("3");
            filterSO.setFilterNo("3");
        } else if (so.getTypeCd().equals("04")) {
            filterSO.setFilterMenuLvl("3");
            filterSO.setFilterItemLvl("4");
            filterSO.setFilterNo("4");
            filterSO.setGoodsNo(so.getGoodsNo());
            FilterVO filterVO = goodsManageService.selectGoodsFilterLvl2Info(vo);
            filterSO.setSelectedFilterNo(filterVO.getUpFilterNo());
        } else {
            filterSO.setFilterMenuLvl("2");
            filterSO.setFilterItemLvl("3");
            filterSO.setFilterNo("5");
        }
        filterSO.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
        List<FilterVO> filterVOList = filterManageService.selectFilterListGoodsType(filterSO);


        mav.addObject("resultFilter", filterVOList);
        mav.addObject("goodsInfoChangeHist", goodsManageService.selectGoodsInfoChangeHist(so));
        //log.info("editGoodsDetail param so : " + so);
        mav.addObject("typeCd", so.getTypeCd());
        return mav;
    }

    /**
     * <pre>
     * 작성일 : 2022. 10. 27.
     * 작성자 : slims
     * 설명   : filter list contact 리스트 조회
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2022. 10. 27. slims - 최초생성
     * </pre>
     *
     * @param so
     * @param
     * @return
     */
    @RequestMapping("/goods-contact-filter-list")
    public @ResponseBody ResultListModel<FilterVO> selectFilterListContact(FilterSO so, BindingResult bindingResult) {

        ResultListModel<FilterVO> result = new ResultListModel<>();

        List<FilterVO> list = filterManageService.selectFilterListGoodsType(so);
        result.setResultList(list);
        result.setSuccess(list.size() > 0 ? true : false);

        return result;
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
        ModelAndView mav = new ModelAndView("/admin/goods/goodsUploadForm");
        return mav;
    }

    /**
     * <pre>
     * 작성일 : 2016. 9. 28.
     * 작성자 : dong
     * 설명   : 상품 등록 및 수정 화면에 필요한 상품 설정에 관련된
     *          기본 정보를 취득하여 반환한다.
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 9. 28. dong - 최초생성
     * </pre>
     *
     * @param so
     * @return
     */
    @RequestMapping("/default-display-info")
    public @ResponseBody ResultModel<GoodsDisplayInfoVO> getDefaultDisplayInfo(GoodsDetailSO so) {
        ResultModel<GoodsDisplayInfoVO> resultModel = goodsManageService.getDefaultDisplayInfo(so);
        return resultModel;
    }

    /**
     * <pre>
     * 작성일 : 2016. 9. 28.
     * 작성자 : dong
     * 설명   : 상품 정보를 취득하여 반환한다.
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 9. 28. dong - 최초생성
     * </pre>
     *
     * @param so
     * @return
     */
    @RequestMapping("/goods-info")
    public @ResponseBody ResultModel<GoodsDetailVO> selectGoodsInfo(GoodsDetailSO so) {
        ResultModel<GoodsDetailVO> resultModel = goodsManageService.selectGoodsInfo(so);
        return resultModel;
    }

    /**
     * <pre>
     * 작성일 : 2016. 9. 28.
     * 작성자 : dong
     * 설명   : 최근 등록 옵션 목록을 취득하여 반환한다.
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 9. 28. dong - 최초생성
     * </pre>
     *
     * @param vo
     * @param bindingResult
     * @return
     * @throws Exception
     */
    @RequestMapping("/recent-option")
    public @ResponseBody ResultListModel<Map<String, Object>> selectRecentOption(@Validated GoodsOptionVO vo,
            BindingResult bindingResult) throws Exception {
        ResultListModel<Map<String, Object>> resultListModel = goodsManageService.selectRecentOption(vo);
        return resultListModel;
    }

    /**
     * <pre>
     * 작성일 : 2016. 9. 28.
     * 작성자 : dong
     * 설명   : 상품 고시 정보 목록을 취득하여 반환한다.
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 9. 28. dong - 최초생성
     * </pre>
     *
     * @param so
     * @return
     */
    @RequestMapping("/goods-notify-item")
    public @ResponseBody ResultListModel<GoodsNotifyVO> selectGoodsNotifyItemList(GoodsNotifySO so) {
        ResultListModel<GoodsNotifyVO> result = new ResultListModel<>();

        List<GoodsNotifyVO> list = goodsManageService.selectGoodsNotifyItemList(so);
        result.setResultList(list);
        result.setSuccess(list.size() > 0 ? true : false);

        return result;
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
        //LucyUtil.filter("/admin/goods/goods-info-insert", po);

        GoodsDetailPOValidator validator = new GoodsDetailPOValidator();
        validator.validate(po, bindingResult);

        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }

        ResultModel<GoodsDetailPO> resultModel = goodsManageService.insertGoodsInfo(po);
        return resultModel;
    }

    /**
     * <pre>
     * 작성일 : 2016. 9. 28.
     * 작성자 : dong
     * 설명   : 상품 상세 설명 내용을 취득하여 반환한다.
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 9. 28. dong - 최초생성
     * </pre>
     *
     * @param vo
     * @param bindingResult
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/goods-contents")
    public @ResponseBody ResultModel<GoodsContentsVO> selectGoodsContents(@Validated GoodsContentsVO vo)
            throws Exception {
        ResultModel<GoodsContentsVO> resultModel = goodsManageService.selectGoodsContents(vo);
        return resultModel;
    }

    /**
     * <pre>
     * 작성일 : 2016. 9. 28.
     * 작성자 : dong
     * 설명   : 상품 상세 설명 내용을 저장한다.
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
    @RequestMapping(value = "/goods-contents-insert")
    public @ResponseBody ResultModel<GoodsContentsPO> saveGoodsContents(
            @Validated(UpdateGroup.class) GoodsContentsPO po, BindingResult bindingResult) throws Exception {
        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }
        ResultModel<GoodsContentsPO> result = goodsManageService.saveGoodsContents(po);
        return result;
    }

    /**
     * <pre>
     * 작성일 : 2016. 9. 28.
     * 작성자 : dong
     * 설명   : 기존 상품 정보를 복사하여 새로운 상품으로 등록한다.
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 9. 28. dong - 최초생성
     * </pre>
     *
     * @param po
     * @return
     * @throws Exception
     */
    @RequestMapping("/goods-copy")
    public @ResponseBody ResultModel<GoodsDetailVO> insertGoodsCopy(GoodsPO po) throws Exception {
        ResultModel<GoodsDetailVO> resultModel = goodsManageService.copyGoodsInfo(po);
        return resultModel;
    }

    /**
     * <pre>
     * 작성일 : 2016. 9. 28.
     * 작성자 : dong
     * 설명   : 판매상품 등록 페이지에서 업로드된 상품 이미지를 사이트 설정에 설정된
     *          각각의 이미지 사이즈로 리사이징 처리한 루 임시 경로에 저장한다.
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 9. 28. dong - 최초생성
     * </pre>
     *
     * @param model
     * @param mRequest
     * @return
     */
    @RequestMapping(value = "/goods-image-upload")
    @ResponseBody
    public Map goodsImageUploadResult(Model model, MultipartHttpServletRequest mRequest) {
        GoodsImageUploadVO result;
        List<GoodsImageUploadVO> resultList = new ArrayList<>();
        Iterator<String> fileIter = mRequest.getFileNames();
        Long siteNo = SessionDetailHelper.getDetails().getSiteNo();
        Map map = new HashMap();

        // 계정별 디스크 쿼터 잔량 체크, 불가능시 익셉션 발생함
        FileUtil.checkUploadable(mRequest);

        // 사이트 설정 정보 서비스에서 사이트에 설정된 상품 이미지 정보를 취득한다.
        SiteSO so = new SiteSO();
        so.setSiteNo(siteNo);
        ResultModel<GoodsImageSizeVO> goodsImageSizeVO = siteInfoService.selectGoodsImageInfo(so);

        log.info("");
        if (goodsImageSizeVO != null) {
            try {
                String fileOrgName;
                String extension;
                String fileName;
                File file;
                String filePath;
                String path;
                // 상품 이미지는 이하 5가지 확장자만 가능
                String[] fileFilter = { "jpg", "jpeg", "png", "gif", "bmp" };
                Boolean checkExe;
                List<MultipartFile> files;
                GoodsImageInfoData imageInfoData;
                // 업로드된 이미지 종류(GOODS : 상품 이미지, DISP : 전시 이미지, WEAR : 착용샷 이미지)
                String imageKind = mRequest.getParameter("img_param_1");
                // 이미지 유형
                // (상품이미지 - A Type, B Type, 전시이미지 - A Type, B Type, C Type, D Type, E Type, F Type, G Type, S Type, M Type)
                String imageType = mRequest.getParameter("img_param_2");

                while (fileIter.hasNext()) {
                    files = mRequest.getMultiFileMap().get(fileIter.next());
                    for (MultipartFile mFile : files) {

                        // 이미지 확장자 확인
                        fileOrgName = mFile.getOriginalFilename();
                        extension = FilenameUtils.getExtension(fileOrgName);
                        checkExe = true;
                        for (String ex : fileFilter) {
                            if (ex.equalsIgnoreCase(extension)) {
                                checkExe = false;
                            }
                        }
                        //
                        if (checkExe) {
                            throw new CustomException(ExceptionConstants.BAD_EXE_FILE_EXCEPTION);
                        }
                        // 이미지 최대 사이즈(system.upload.file.size) 확인
                        if (mFile != null && mFile.getSize() > fileSize) {
                            throw new CustomException(ExceptionConstants.BAD_SIZE_FILE_EXCEPTION);
                        }

                        // 업로드 등록할 이미지 파일명
                        fileName = CryptoUtil.encryptSHA256(System.currentTimeMillis() + "." + extension);
                        // 파일 경로
                        path = FileUtil.getNowdatePath();
                        filePath = getTempRootPath() + File.separator + path + File.separator + fileName;
                        file = new File(filePath);

                        if (!file.getParentFile().exists()) {
                            file.getParentFile().mkdirs();
                        }

                        // log.debug("원본파일 : {}", mFile);
                        // log.debug("대상파일 : {}", file);

                        // 파일 생성
                        mFile.transferTo(file);

                        // 리사이징 정보등을 담은 이미지 객체 생성
                        imageInfoData = new GoodsImageInfoData();

                        log.info("imageKind :::::::::::::::::::::::::::::::: "+imageKind);
                        log.info("imageType :::::::::::::::::::::::::::::::: "+imageType);
                        // 업로드 이미지 정보에 따라 이미지 객체에 이미지 유형 설정
                        if ("GOODS".equals(imageKind)) {
                            switch (imageType) {
                            case "02":
                                imageInfoData.setGoodsImageType(GoodsImageType.GOODS_IMAGE_TYPE_A);
                                break;
                            case "03":
                                imageInfoData.setGoodsImageType(GoodsImageType.GOODS_IMAGE_TYPE_B);
                                break;
                            default:
                                imageInfoData.setGoodsImageType(GoodsImageType.GOODS_IMAGE);
                                break;
                            }
                        } else if("WEAR".equals(imageKind)){
                             switch (imageType) {
                            case "02":
                                imageInfoData.setGoodsImageType(GoodsImageType.LEFT_WEAR_IMAGE);
                                break;
                            case "03":
                                imageInfoData.setGoodsImageType(GoodsImageType.RIGHT_WEAR_IMAGE);
                                break;
                            case "04":
                                imageInfoData.setGoodsImageType(GoodsImageType.LEFT_LENS_IMAGE);
                                break;
                            case "05":
                                imageInfoData.setGoodsImageType(GoodsImageType.RIGHT_LENS_IMAGE);
                                break;
                            default:
                                break;
                            }
                        } else {
                            switch (imageType) {
                            case "A":
                                imageInfoData.setGoodsImageType(GoodsImageType.DISP_IMAGE_TYPE_A);
                                break;
                            case "B":
                                imageInfoData.setGoodsImageType(GoodsImageType.DISP_IMAGE_TYPE_B);
                                break;
                            case "C":
                                imageInfoData.setGoodsImageType(GoodsImageType.DISP_IMAGE_TYPE_C);
                                break;
                            case "D":
                                imageInfoData.setGoodsImageType(GoodsImageType.DISP_IMAGE_TYPE_D);
                                break;
                            case "E":
                                imageInfoData.setGoodsImageType(GoodsImageType.DISP_IMAGE_TYPE_E);
                                break;
                            case "F":
                                imageInfoData.setGoodsImageType(GoodsImageType.DISP_IMAGE_TYPE_F);
                                break;
                            case "G":
                                imageInfoData.setGoodsImageType(GoodsImageType.DISP_IMAGE_TYPE_G);
                                break;
                            case "S":
                                imageInfoData.setGoodsImageType(GoodsImageType.DISP_IMAGE_TYPE_S);
                                break;
                            case "M":
                                imageInfoData.setGoodsImageType(GoodsImageType.DISP_IMAGE_TYPE_M);
                                break;
                            case "O":
                                imageInfoData.setGoodsImageType(GoodsImageType.DISP_IMAGE_TYPE_O);
                                break;
                            case "P":
                                imageInfoData.setGoodsImageType(GoodsImageType.DISP_IMAGE_TYPE_P);
                                break;
                            default:
                                imageInfoData.setGoodsImageType(GoodsImageType.DISP_IMAGE);
                                break;
                            }
                        }

                        // 사이트 설정에서 취득한 상품 이미지 설정 정보를 세팅
                        imageInfoData.setWidthForGoodsDetail(Integer.valueOf(goodsImageSizeVO.getData().getGoodsDefaultImgWidth()));
                        imageInfoData.setHeightForGoodsDetail(Integer.valueOf(goodsImageSizeVO.getData().getGoodsDefaultImgHeight()));

                        imageInfoData.setWidthForGoodsThumbnail(Integer.valueOf(goodsImageSizeVO.getData().getGoodsListImgWidth()));
                        imageInfoData.setHeightForGoodsThumbnail(Integer.valueOf(goodsImageSizeVO.getData().getGoodsListImgHeight()));

                        imageInfoData.setWidthForDispTypeA(Integer.valueOf(goodsImageSizeVO.getData().getGoodsDispImgTypeAWidth()));
                        imageInfoData.setHeightForDispTypeA(Integer.valueOf(goodsImageSizeVO.getData().getGoodsDispImgTypeAHeight()));

                        imageInfoData.setWidthForDispTypeB(Integer.valueOf(goodsImageSizeVO.getData().getGoodsDispImgTypeBWidth()));
                        imageInfoData.setHeightForDispTypeB(Integer.valueOf(goodsImageSizeVO.getData().getGoodsDispImgTypeBHeight()));

                        imageInfoData.setWidthForDispTypeC(Integer.valueOf(goodsImageSizeVO.getData().getGoodsDispImgTypeCWidth()));
                        imageInfoData.setHeightForDispTypeC(Integer.valueOf(goodsImageSizeVO.getData().getGoodsDispImgTypeCHeight()));

                        imageInfoData.setWidthForDispTypeD(Integer.valueOf(goodsImageSizeVO.getData().getGoodsDispImgTypeDWidth()));
                        imageInfoData.setHeightForDispTypeD(Integer.valueOf(goodsImageSizeVO.getData().getGoodsDispImgTypeDHeight()));

                        imageInfoData.setWidthForDispTypeE(Integer.valueOf(goodsImageSizeVO.getData().getGoodsDispImgTypeEWidth()));
                        imageInfoData.setHeightForDispTypeE(Integer.valueOf(goodsImageSizeVO.getData().getGoodsDispImgTypeEHeight()));

                        imageInfoData.setWidthForDispTypeF(Integer.valueOf(goodsImageSizeVO.getData().getGoodsDispImgTypeFWidth()));
                        imageInfoData.setHeightForDispTypeF(Integer.valueOf(goodsImageSizeVO.getData().getGoodsDispImgTypeFHeight()));

                        imageInfoData.setWidthForDispTypeG(Integer.valueOf(goodsImageSizeVO.getData().getGoodsDispImgTypeGWidth()));
                        imageInfoData.setHeightForDispTypeG(Integer.valueOf(goodsImageSizeVO.getData().getGoodsDispImgTypeGHeight()));

                        imageInfoData.setWidthForDispTypeS(Integer.valueOf(goodsImageSizeVO.getData().getGoodsDispImgTypeSWidth()));
                        imageInfoData.setHeightForDispTypeS(Integer.valueOf(goodsImageSizeVO.getData().getGoodsDispImgTypeSHeight()));

                        imageInfoData.setWidthForDispTypeM(Integer.valueOf(goodsImageSizeVO.getData().getGoodsDispImgTypeMWidth()));
                        imageInfoData.setHeightForDispTypeM(0);
                        
                        imageInfoData.setWidthForDispTypeO(Integer.valueOf(goodsImageSizeVO.getData().getGoodsDispImgTypeOWidth()));
                        imageInfoData.setHeightForDispTypeO(Integer.valueOf(goodsImageSizeVO.getData().getGoodsDispImgTypeOHeight()));
                        
                        imageInfoData.setWidthForDispTypeP(Integer.valueOf(goodsImageSizeVO.getData().getGoodsDispImgTypePWidth()));
                        imageInfoData.setHeightForDispTypeP(Integer.valueOf(goodsImageSizeVO.getData().getGoodsDispImgTypePHeight()));

                        imageInfoData.setWidthForWearL(Integer.valueOf(goodsImageSizeVO.getData().getGoodsWearImgWidth()));
                        imageInfoData.setHeightForWearL(Integer.valueOf(goodsImageSizeVO.getData().getGoodsWearImgHeight()));

                        imageInfoData.setWidthForWearR(Integer.valueOf(goodsImageSizeVO.getData().getGoodsWearImgWidth()));
                        imageInfoData.setHeightForWearR(Integer.valueOf(goodsImageSizeVO.getData().getGoodsWearImgHeight()));

                        imageInfoData.setWidthForLensL(Integer.valueOf(goodsImageSizeVO.getData().getGoodsLensImgWidth()));
                        imageInfoData.setHeightForLensL(Integer.valueOf(goodsImageSizeVO.getData().getGoodsLensImgHeight()));

                        imageInfoData.setWidthForLensR(Integer.valueOf(goodsImageSizeVO.getData().getGoodsLensImgWidth()));
                        imageInfoData.setHeightForLensR(Integer.valueOf(goodsImageSizeVO.getData().getGoodsLensImgHeight()));

                        imageInfoData.setOrgImgPath(file.getAbsolutePath());
                        // 이미지 리사이징 실행
                        imageHandler.job(imageInfoData);

                        // 이미지 업로드 결과로 반환 할 결과 목록객체 생성
                        List<File> destFileList = imageInfoData.getDestFileList();

                        for (File destFile : destFileList) {
                            // 화면에 반환할 정보 설정
                            String targetFileName = destFile.getName();
                            String[] fileInfoArr = targetFileName.split("_");
                            String[] sizeArr = fileInfoArr[1].split("x");

                            result = new GoodsImageUploadVO();
                            result.setFileName(fileOrgName);
                            result.setImageWidth(sizeArr[0]);
                            result.setImageHeight(sizeArr[1]);
                            result.setImgType(targetFileName.substring(targetFileName.lastIndexOf("x") + 1,targetFileName.length()));
                            result.setTempFileName(DateUtil.getNowDate() + "_" + destFile.getName());
                            result.setFileSize(mFile.getSize());
                            // 이미지 미리보기 URL
                            result.setImageUrl(mRequest.getAttribute(RequestAttributeConstants.IMAGE_DOMAIN) +UploadConstants.IMAGE_TEMP_EDITOR_URL + DateUtil.getNowDate() + "_" + targetFileName);
                            // 이미지 썸네일 URL
                            result.setThumbUrl(mRequest.getAttribute(RequestAttributeConstants.IMAGE_DOMAIN)+ UploadConstants.IMAGE_TEMP_EDITOR_URL + DateUtil.getNowDate() + "_"+ (targetFileName).substring(0, targetFileName.lastIndexOf("_"))+ CommonConstants.IMAGE_GOODS_THUMBNAIL_PREFIX);

                            resultList.add(result);
                        }

                    }
                }

                // 반환 정보 설정
                map.put("files", resultList);
                // JSON 형태로 반환
                return map;

            } catch (IllegalStateException e) {
                log.debug("{}", e);
                throw new CustomException(ExceptionConstants.ERROR_CODE_DEFAULT);
            } catch (IOException e) {
                log.debug("{}", e);
                throw new CustomException(ExceptionConstants.ERROR_CODE_DEFAULT);
            } finally {
                // 사이트별 파일 권한 처리
//                ExecuteExtCmdUtil.chown(SiteUtil.getSiteId());
            }
        } else {
            throw new CustomException(ExceptionConstants.ERROR_CODE_DEFAULT);
        }
    }

    /**
     * <pre>
     * 작성일 : 2023. 02. 08.
     * 작성자 : slims
     * 설명   : 판매상품 등록 페이지에서 업로드된 상품 이미지를 사이트 설정에 설정된
     *          각각의 이미지 사이즈로 리사이징 처리한 루 임시 경로에 저장한다.
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2023. 02. 08. slims - 최초생성
     * </pre>
     *
     * @param model
     * @param mRequest
     * @return
     */
    @RequestMapping(value = "/goods-item-image-upload")
    @ResponseBody
    public Map goodsItemImageUploadResult(Model model, MultipartHttpServletRequest mRequest) {
        GoodsImageUploadVO result;
        List<GoodsImageUploadVO> resultList = new ArrayList<>();
        Iterator<String> fileIter = mRequest.getFileNames();
        Long siteNo = SessionDetailHelper.getDetails().getSiteNo();
        Map map = new HashMap();

        // 계정별 디스크 쿼터 잔량 체크, 불가능시 익셉션 발생함
        FileUtil.checkUploadable(mRequest);

        // 사이트 설정 정보 서비스에서 사이트에 설정된 상품 이미지 정보를 취득한다.
        SiteSO so = new SiteSO();
        so.setSiteNo(siteNo);
        ResultModel<GoodsImageSizeVO> goodsImageSizeVO = siteInfoService.selectGoodsImageInfo(so);

        if (goodsImageSizeVO != null) {
            try {
                String fileOrgName;
                String extension;
                String fileName;
                File file;
                String filePath;
                String path;
                // 상품 이미지는 이하 5가지 확장자만 가능
                String[] fileFilter = { "jpg", "jpeg", "png", "gif", "bmp" };
                Boolean checkExe;
                List<MultipartFile> files;
                GoodsImageInfoData imageInfoData;

                while (fileIter.hasNext()) {
                    files = mRequest.getMultiFileMap().get(fileIter.next());
                    for (MultipartFile mFile : files) {

                        // 이미지 확장자 확인
                        fileOrgName = mFile.getOriginalFilename();
                        extension = FilenameUtils.getExtension(fileOrgName);
                        checkExe = true;
                        for (String ex : fileFilter) {
                            if (ex.equalsIgnoreCase(extension)) {
                                checkExe = false;
                            }
                        }
                        //
                        if (checkExe) {
                            throw new CustomException(ExceptionConstants.BAD_EXE_FILE_EXCEPTION);
                        }
                        // 이미지 최대 사이즈(system.upload.file.size) 확인
                        if (mFile != null && mFile.getSize() > fileSize) {
                            throw new CustomException(ExceptionConstants.BAD_SIZE_FILE_EXCEPTION);
                        }

                        // 업로드 등록할 이미지 파일명
                        fileName = CryptoUtil.encryptSHA256(System.currentTimeMillis() + "." + extension);
                        // 파일 경로
                        path = FileUtil.getNowdatePath();
                        filePath = getTempRootPath() + File.separator + path + File.separator + fileName;
                        file = new File(filePath);

                        if (!file.getParentFile().exists()) {
                            file.getParentFile().mkdirs();
                        }

                        // log.debug("원본파일 : {}", mFile);
                        // log.debug("대상파일 : {}", file);

                        // 파일 생성
                        mFile.transferTo(file);

                        // 리사이징 정보등을 담은 이미지 객체 생성
                        imageInfoData = new GoodsImageInfoData();

                        // 업로드 이미지 정보에 따라 이미지 객체에 이미지 유형 설정
                        imageInfoData.setGoodsImageType(GoodsImageType.GOODS_ITEM_IMAGE);

                        // 사이트 설정에서 취득한 상품 이미지 설정 정보를 세팅
                        imageInfoData.setWidthForGoodsDetail(Integer.valueOf(goodsImageSizeVO.getData().getGoodsDefaultImgWidth()));
                        imageInfoData.setHeightForGoodsDetail(Integer.valueOf(goodsImageSizeVO.getData().getGoodsDefaultImgHeight()));

                        imageInfoData.setWidthForGoodsThumbnail(Integer.valueOf(goodsImageSizeVO.getData().getGoodsListImgWidth()));
                        imageInfoData.setHeightForGoodsThumbnail(Integer.valueOf(goodsImageSizeVO.getData().getGoodsListImgHeight()));


                        imageInfoData.setOrgImgPath(file.getAbsolutePath());
                        // 이미지 리사이징 실행
                        imageHandler.job(imageInfoData);

                        // 이미지 업로드 결과로 반환 할 결과 목록객체 생성
                        List<File> destFileList = imageInfoData.getDestFileList();

                        for (File destFile : destFileList) {
                            // 화면에 반환할 정보 설정
                            String targetFileName = destFile.getName();
                            String[] fileInfoArr = targetFileName.split("_");
                            String[] sizeArr = fileInfoArr[1].split("x");

                            result = new GoodsImageUploadVO();
                            result.setFileName(fileOrgName);
                            result.setImageWidth(sizeArr[0]);
                            result.setImageHeight(sizeArr[1]);
                            result.setImgType(targetFileName.substring(targetFileName.lastIndexOf("x") + 1,targetFileName.length()));
                            result.setTempFileName(DateUtil.getNowDate() + "_" + destFile.getName());
                            result.setFileSize(mFile.getSize());
                            result.setFilePath(path);
                            // 이미지 미리보기 URL
                            result.setImageUrl(UploadConstants.IMAGE_TEMP_EDITOR_URL + DateUtil.getNowDate() + "_" + targetFileName);
                            resultList.add(result);
                        }

                    }
                }

                // 반환 정보 설정
                map.put("files", resultList);
                // JSON 형태로 반환
                return map;

            } catch (IllegalStateException e) {
                log.debug("{}", e);
                throw new CustomException(ExceptionConstants.ERROR_CODE_DEFAULT);
            } catch (IOException e) {
                log.debug("{}", e);
                throw new CustomException(ExceptionConstants.ERROR_CODE_DEFAULT);
            } finally {
                // 사이트별 파일 권한 처리
//                ExecuteExtCmdUtil.chown(SiteUtil.getSiteId());
            }
        } else {
            throw new CustomException(ExceptionConstants.ERROR_CODE_DEFAULT);
        }
    }

    /**
     * <pre>
     * 작성일 : 2016. 8. 3.
     * 작성자 : dong
     * 설명   : 단품 가격 변경 이력 취득 목록을 리턴한다.
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 8. 3. dong - 최초생성
     * </pre>
     *
     * @return
     */
    @RequestMapping("/item-price-history")
    public @ResponseBody ResultListModel<GoodsItemHistoryVO> selectItemPriceHist(GoodsItemHistoryVO vo)
            throws Exception {
        ResultListModel<GoodsItemHistoryVO> result = new ResultListModel<>();

        List<GoodsItemHistoryVO> list = goodsManageService.selectItemPriceHist(vo);
        result.setResultList(list);
        result.setSuccess(list.size() > 0 ? true : false);

        return result;
    }

    /**
     * <pre>
     * 작성일 : 2016. 8. 3.
     * 작성자 : dong
     * 설명   : 단품 수량 변경 이력 취득 목록을 리턴한다.
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 8. 3. dong - 최초생성
     * </pre>
     *
     * @return
     */
    @RequestMapping("/item-quantity-history")
    public @ResponseBody ResultListModel<GoodsItemHistoryVO> selectItemQttHist(GoodsItemHistoryVO vo) throws Exception {
        ResultListModel<GoodsItemHistoryVO> result = new ResultListModel<>();

        List<GoodsItemHistoryVO> list = goodsManageService.selectItemQttHist(vo);
        result.setResultList(list);
        result.setSuccess(list.size() > 0 ? true : false);

        return result;
    }

    /**
     * <pre>
     * 작성일 : 2023. 2. 15.
     * 작성자 : slims
     * 설명   : 다수의 상품정보를 받아서 해당 상품의 예상 배송 소요일을 변경 한다.
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2023. 2. 15. slims - 최초생성
     * </pre>
     *
     * @param po
     * @param bindingResult
     * @return
     */
    @RequestMapping("/dlvrExpectDays-update")
    public @ResponseBody ResultModel<GoodsPO> updateDlvrExpectDays(GoodsPOListWrapper wrapper, BindingResult bindingResult) {

        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }
        ResultModel<GoodsPO> resultModel = goodsManageService.updateDlvrExpectDays(wrapper);
        return resultModel;
    }

    /**
     * <pre>
     * 작성일 : 2023. 2. 15.
     * 작성자 : slims
     * 설명   : 다수의 상품정보를 받아서 해당 상품의 배송비 설정을 변경 한다.
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2023. 2. 15. slims - 최초생성
     * </pre>
     *
     * @param po
     * @param bindingResult
     * @return
     */
    @RequestMapping("/dlvrCost-update")
    public @ResponseBody ResultModel<GoodsPO> updateDlvrCost(GoodsPOListWrapper wrapper, BindingResult bindingResult) {

        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }
        //전시/미전시 수정
        ResultModel<GoodsPO> resultModel = goodsManageService.updateDlvrCost(wrapper);
        return resultModel;
    }

    /**
     * <pre>
     * 작성일 : 2023. 2. 15.
     * 작성자 : slims
     * 설명   : 다수의 상품정보를 받아서 해당 상품의 이벤트 안내문을 변경 한다.
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2023. 2. 15. slims - 최초생성
     * </pre>
     *
     * @param po
     * @param bindingResult
     * @return
     */
    @RequestMapping("/eventWords-update")
    public @ResponseBody ResultModel<GoodsPO> updateEventWords(GoodsPOListWrapper wrapper, BindingResult bindingResult) {

        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }
        //전시/미전시 수정
        ResultModel<GoodsPO> resultModel = goodsManageService.updateEventWords(wrapper);
        return resultModel;
    }

    /**
     * <pre>
     * 작성일 : 2023. 2. 15.
     * 작성자 : slims
     * 설명   : 다수의 상품정보를 받아서 해당 상품의 판매가를 변경 한다.
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2023. 2. 15. slims - 최초생성
     * </pre>
     *
     * @param po
     * @param bindingResult
     * @return
     */
    @RequestMapping("/salesPrice-update")
    public @ResponseBody ResultModel<GoodsPO> updateSalesPrice(GoodsPOListWrapper wrapper, BindingResult bindingResult) {

        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }
        //전시/미전시 수정
        ResultModel<GoodsPO> resultModel = goodsManageService.updateSalePrice(wrapper);
        return resultModel;
    }

    /**
     * <pre>
     * 작성일 : 2023. 2. 15.
     * 작성자 : slims
     * 설명   : 아이콘 정보를 조회 한다.
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2023. 2. 15. slims - 최초생성
     * </pre>
     *
     * @param IconSO
     * @return
     */
    @RequestMapping("/icon-list")
    public @ResponseBody List<IconVO> selectIcon(IconSO so) {

        //전시/미전시 수정
        List<IconVO> resultList = iconManageService.selectIconList(so);
        return resultList;
    }

    /**
     * <pre>
     * 작성일 : 2023. 2. 15.
     * 작성자 : slims
     * 설명   : 다수의 상품정보를 받아서 해당 상품의 아이콘 정보를 변경 한다.
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2023. 2. 15. slims - 최초생성
     * </pre>
     *
     * @param po
     * @param bindingResult
     * @return
     */
    @RequestMapping("/icon-update")
    public @ResponseBody ResultModel<GoodsPO> updateIcon(GoodsPOListWrapper wrapper, BindingResult bindingResult) {

        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }
        //전시/미전시 수정
        ResultModel<GoodsPO> resultModel = goodsManageService.updateGoodsIcon(wrapper);
        return resultModel;
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
        log.info("=================> kwt list : " + list);
        result.setResultList(goodsManageService.uploadGoodsInsertList(list, mRequest));

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
     * 작성일 : 2023. 04. 11.
     * 작성자 : slims
     * 설명   : 상품 이미지 일괄 업로드 엑셀입력 처리
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2023. 04. 11. slims - 최초생성
     * </pre>
     *
     * @param mRequest
     * @return
     * @throws Exception
     */
    @RequestMapping("/goods-img-excel-upload")
    public @ResponseBody ResultListModel<GoodsImageDtlPO> uploadGoodsImgInsertList(MultipartHttpServletRequest mRequest)
            throws Exception {
        ResultListModel<GoodsImageDtlPO> result = new ResultListModel();

        // FileVO result = new FileVO();
        MultipartFile file = FileUtil.getExcel(mRequest, "excel");

        // 엑셀 파일을 읽어 리스트 형태로 반환
        List<Map<String, Object>> list = excelReader.convertExcelToListByMap(file);
        //log.info("=================> slims list : " + list);
        result.setResultList(goodsManageService.uploadGoodsImgList(list, mRequest));

        //log.info("=================> slims result.getResultList() : " +result.getResultList());

        if (result.getResultList() != null && result.getResultList().size() > 0) {
            result.setTotalRows(result.getResultList().size());
            result.setMessage("업로드된 상품 이미지 정보가 등록되었습니다.");
            result.setSuccess(true);
        } else {
            result.setTotalRows(result.getResultList().size());
            result.setMessage("등록된 상품 이미지 정보가 없습니다..");
            result.setSuccess(false);
        }
        return result;
    }

    /**
     * <pre>
     * 작성일 : 2016. 10. 5.
     * 작성자 : dong
     * 설명   : 파일 다운로드
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 10. 5. dong - 최초생성
     * </pre>
     *
     * @param map
     * @param fileDownloadSO
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/goods-download")
    public String fileDownload(ModelMap map, HttpServletRequest request) throws Exception {
        FileViewParam fileView = new FileViewParam();
        String filePath = request.getSession().getServletContext()
                .getRealPath("excel" + File.separator + "goodsUpload.xlsx");
        // log.debug("filePath : {}", filePath);
        fileView.setFilePath(filePath);
        fileView.setFileName("goodsUpload.xlsx");
        map.put(AdminConstants.FILE_PARAM_NAME, fileView);
        return View.fileDownload();
    }

    
    /**
     * <pre>
     * 작성일 : 2018. 7. 30.
     * 작성자 : CBK
     * 설명   : 다비젼 상품 분류 목록 조회
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2018. 7. 30. CBK - 최초생성
     * </pre>
     *
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/erp-item-kind")
    public @ResponseBody List<ItmKindSearchResDTO.ItmKindDTO> getErpIetmKindList() throws Exception {
        BaseReqDTO param = new BaseReqDTO();
        String ifId = Constants.IFID.ITM_KIND_SEARCH;
        try {

            // ERP처리부분
            // ResponseDTO 생성
            ItmKindSearchResDTO resDto = new ItmKindSearchResDTO();
            resDto.setResult(Constants.RESULT.SUCCESS);
            resDto.setMessage("");

            // 데이터 조회 및 설정
            List<ItmKindSearchResDTO.ItmKindDTO> itmKindList = productService.getItmKindList();
            resDto.setItmKindList(itmKindList);

            // 처리로그 등록
            logService.writeInterfaceLog(ifId, param, resDto);

            return itmKindList;
        } catch (CustomIfException ce) {
            ce.setReqParam(param);
            ce.setIfId(ifId);
            throw ce;
        } catch (Exception e) {
            throw new CustomIfException(e, param, ifId);
        }
    	//return InterfaceUtil.send2("IF_PRD_006", null);
    }

        /**
         * <pre>
         * 작성일 : 2018. 7. 30.
         * 작성자 : CBK
         * 설명   : 다비젼 브랜드 목록 검색
         *
         * 수정내역(수정일 수정자 - 수정내용)
         * -------------------------------------------------------------------------
         * 2018. 7. 30. CBK - 최초생성
         * </pre>
         *
         * @param itmKind
         * @param brandName
         * @return
         * @throws Exception
         */
    @RequestMapping(value = "/erp-brand-list")
    public @ResponseBody List<BrandSearchResDTO.BrandDTO> searchErpBrandList(BrandSearchReqDTO param) throws Exception {
        //return InterfaceUtil.send2("IF_PRD_005", param);
        String ifId = Constants.IFID.BRAND_SEARCH;

        try {

            // ERP처리부분
            // ResponseDTO 생성
            BrandSearchResDTO resDto = new BrandSearchResDTO();
            resDto.setResult(Constants.RESULT.SUCCESS);
            resDto.setMessage("");

            // 데이터 조회 및 설정
            List<BrandSearchResDTO.BrandDTO> brandList = productService.getBrandList(param);
            resDto.setBrandList(brandList);

            // 처리로그 등록
            logService.writeInterfaceLog(ifId, param, resDto);

            return brandList;

        } catch (CustomIfException ce) {
            ce.setReqParam(param);
            ce.setIfId(ifId);
            throw ce;
        } catch (Exception e) {
            throw new CustomIfException(e, param, ifId);
        }
    }
    
    /**
     * <pre>
     * 작성일 : 2018. 7. 30.
     * 작성자 : CBK
     * 설명   : 다비젼 상품 목록 검색
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2018. 7. 30. CBK - 최초생성
     * </pre>
     *
     * @param param
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/erp-goods-list")
    public @ResponseBody ProductSearchResDTO searchErpGoodsList(ProductSearchReqDTO param) throws Exception {
        String ifId = Constants.IFID.RESERVE_PRODUCT_SEARCH;

        try {

            // 쇼핑몰 처리 부분
            // Response DTO 생성
            ProductSearchResDTO resDto = new ProductSearchResDTO();
            resDto.setResult(Constants.RESULT.SUCCESS);
            resDto.setMessage("");

            // 상품목록
            List<ProductSearchResDTO.ProductInfoDTO> prdList = productService.getProductList(param);
            if(prdList.size() > 100) {
                prdList = prdList.subList(0, 10);
            }
            resDto.setPrdList(prdList);

            // 목록개수
            resDto.setTotalCnt(productService.countProductList(param));

            logService.writeInterfaceLog(ifId, param, resDto);

            return resDto;

        } catch (CustomIfException ce) {
            ce.setReqParam(param);
            ce.setIfId(ifId);
            throw ce;
        }
        //return InterfaceUtil.send2("IF_PRD_001", param);
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
        headerStyle.setFillForegroundColor(Font.COLOR_NORMAL);
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

    private String getTempRootPath() {
        return getSiteRootPath() + File.separator + UploadConstants.PATH_TEMP;
    }

    private String getSiteRootPath() {
        Long siteNo = SessionDetailHelper.getDetails().getSiteNo();
        SiteCacheVO vo = siteService.getSiteInfo(siteNo);

        return uplaodFilePath + File.separator + vo.getSiteId();
    }

    /**
     * <pre>
     * 작성일 : 2019. 3. 25.
     * 작성자 : dong
     * 설명   : D-매거진 관리 화면(/admin/goods/magazineManageList)을 반환한다.
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2019. 3. 25. dong - 최초생성
     * </pre>
     *
     * @return
     */
    @RequestMapping("/magazine")
    public ModelAndView viewMagazineList() {
        ModelAndView mav = new ModelAndView("/admin/goods/magazineManageList");
        mav.addObject("siteNo", SessionDetailHelper.getDetails().getSiteNo());
        return mav;
    }

    /**
     * <pre>
     * 작성일 : 2019. 3. 25.
     * 작성자 : dong
     * 설명   : D-매거진 관리 화면(/admin/goods/magazineDetail)을 반환한다.
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 12. dong - 최초생성
     * </pre>
     *
     * @return
     */
    @RequestMapping("/magazine-detail")
    public ModelAndView viewMagazineDetail(GoodsSO so) {
        ModelAndView mav = new ModelAndView("/admin/goods/magazineDetail");
        mav.addObject("resultModel", goodsManageService.getNewGoodsNo(so));

        // 아이콘 추가 가능 여부
        boolean isAbleAddIcon = siteQuotaService.isIconAddible(so.getSiteNo());
        mav.addObject("isAbleAddIcon", isAbleAddIcon);
        mav.addObject("siteNo", SessionDetailHelper.getDetails().getSiteNo());
        return mav;
    }

    /**
     * <pre>
     * 작성일 : 2019. 3. 25.
     * 작성자 : dong
     * 설명   : D-매거진 수정 화면(/admin/goods/goodsDetail)을 반환한다.
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 9. 28. dong - 최초생성
     * </pre>
     *
     * @param so
     * @return
     */
    @RequestMapping("/magazine-detail-edit")
    public ModelAndView editMagazineDetail(GoodsSO so) {
        ModelAndView mav = new ModelAndView("/admin/goods/magazineDetail");
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
        return mav;
    }

    /**
     * <pre>
     * 작성일 : 2023. 06. 18.
     * 작성자 : slims
     * 설명   : 상품 정보 일괄 업로드 엑셀입력 처리 - 다비젼 상품 정보 업데이트
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2023. 06. 18. slims - 최초생성
     * </pre>
     *
     * @param mRequest
     * @return
     * @throws Exception
     */
    @RequestMapping("/goods-info-excel-upload-davision")
    public @ResponseBody ResultListModel<GoodsItemVO> uploadGoodsUpdateList(MultipartHttpServletRequest mRequest)
            throws Exception {
        ResultListModel<GoodsItemVO> result = new ResultListModel();

        // FileVO result = new FileVO();
        MultipartFile file = FileUtil.getExcel(mRequest, "excel");

        // 엑셀 파일을 읽어 리스트 형태로 반환
        List<Map<String, Object>> list = excelReader.convertExcelToListByMap(file);
        log.info("=================> slims list : " + list);
        result.setResultList(goodsManageService.uploadGoodsUpdateList(list, mRequest));

        log.info("=================> slims result.getResultList() : " +result.getResultList());

        if (result.getResultList() != null && result.getResultList().size() > 0) {
            result.setTotalRows(result.getResultList().size());
            result.setMessage("업로드된 상품 정보가 업데이트 되었습니다.");
            result.setSuccess(true);
        } else {
            result.setTotalRows(result.getResultList().size());
            result.setMessage("업데이트된 상품 정보가 없습니다..");
            result.setSuccess(false);
        }
        return result;
    }

    @RequestMapping("/item-excel-download")
    public String itemExcelDownload(ItemExcelWrapper wrapper, Model model) throws Exception {
        List<String> headerNameList = new ArrayList<>();
        headerNameList.add("기준옵션");
        int i = 1;
        for (GoodsOptionPO optionPO : wrapper.getOptData()) {
            headerNameList.add("옵션" + i);
            i++;
        }
        headerNameList.add("원가");
        headerNameList.add("정상가");
        headerNameList.add("판매가");
        headerNameList.add("공급가");
        headerNameList.add("재고");
        headerNameList.add("다비전상품코드");

        // 엑셀 헤더 정보
        String[] headerName = headerNameList.toArray(new String[0]);

        List<String> fieldNameList = new ArrayList<>();
        fieldNameList.add("standardPriceYn");
        for (int optionIdx = 1; optionIdx <= wrapper.getOptData().size(); optionIdx++) {
            fieldNameList.add("optValue" + optionIdx);
        }
        fieldNameList.add("cost");
        fieldNameList.add("customerPrice");
        fieldNameList.add("salePrice");
        fieldNameList.add("supplyPrice");
        fieldNameList.add("stockQtt");
        fieldNameList.add("erpItmCode");

        // 엑셀에 바인드할 데이터 필드
        String[] fieldName = fieldNameList.toArray(new String[0]);

        model.addAttribute(CommonConstants.EXCEL_PARAM_NAME, new ExcelViewParam("상품옵션목록", headerName, fieldName, wrapper.getItmData()));
        model.addAttribute(CommonConstants.EXCEL_PARAM_FILE_NAME, "옵션정보");

        return View.excelDownload();
    }

    @RequestMapping("/item-excel-upload")
    public @ResponseBody ResultModel<List<GoodsItemPO>> itemExcelUpload(MultipartHttpServletRequest mRequest) throws Exception {
        ResultModel<List<GoodsItemPO>> result = new ResultModel<>();

        MultipartFile file = FileUtil.getExcel(mRequest, "excel");

        // 엑셀 읽어서 리스트로 반환
        List<Map<String, Object>> list = excelReader.convertExcelToListByMap(file);
        // 기준옵션 검증
        int standardPriceYnCnt = 0;
        for (Map<String, Object> map : list) {
            String standardPriceYn = (String) getExcelInputValue(map.get("기준옵션"), "string");
            if ("Y".equals(standardPriceYn)) {
                standardPriceYnCnt++;
            }
        }
        if(standardPriceYnCnt > 1) {
            result.setMessage("기준옵션은 하나만 존재해야 합니다.");
            result.setSuccess(false);
            return result;
        }
        // return 값 생성
        List<GoodsItemPO> itmData = new ArrayList<>();
        for (Map<String, Object> map : list) {
            GoodsItemPO itm = new GoodsItemPO();
            itm.setStandardPriceYn((String) getExcelInputValue(map.get("기준옵션"), "string"));
            itm.setOptValue1((String) getExcelInputValue(map.get("옵션1"), "string"));
            itm.setOptValue2((String) getExcelInputValue(map.get("옵션2"), "string"));
            itm.setOptValue3((String) getExcelInputValue(map.get("옵션3"), "string"));
            itm.setOptValue4((String) getExcelInputValue(map.get("옵션4"), "string"));
            itm.setCost((Long) getExcelInputValue(map.get("원가"), "long"));
            itm.setCustomerPrice((Long) getExcelInputValue(map.get("정상가"), "long"));
            itm.setSalePrice((Long) getExcelInputValue(map.get("판매가"), "long"));
            itm.setSupplyPrice((Long) getExcelInputValue(map.get("공급가"), "long"));
            itm.setStockQtt((Long) getExcelInputValue(map.get("재고"), "long"));
            itm.setErpItmCode((String) getExcelInputValue(map.get("다비전상품코드"), "string"));
            itmData.add(itm);
        }

        result.setData(itmData);
        result.setSuccess(true);

        return result;
    }

    /**
     * <pre>
     * 작성일 : 2018. 6. 27.
     * 작성자 : CBK
     * 설명   : ResponseDTO를 JSON으로 변환하고 암호화 하여 반환
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2018. 6. 27. CBK - 최초생성
     * </pre>
     *
     * @param resDto
     * @return
     * @throws Exception
     */
    public String toJsonRes(Object resDto, BaseReqDTO reqDto) throws Exception {
        if(reqDto.isFromIF()) {
            // 인터페이스에서 온것은 암호화
            return IFCryptoUtil.encryptAES(JSONObject.fromObject(resDto).toString());
        } else {
            // 인터페이스에서 온게 아니면 암호화 안하고 반환
            return JSONObject.fromObject(resDto).toString();
        }
    }

    private static Object getExcelInputValue(Object value, String type) {
        Object obj = null;
        if (value instanceof Boolean && !(((Boolean) value).booleanValue())) {
            if ("string".equals(type)) {
                obj = "";
            } else if ("long".equals(type)) {
                obj = 0L;
            } else if ("double".equals(type)) {
                obj = 0D;
            }
        } else {
            if ("string".equals(type)) {
                if (value instanceof Double) {
                    obj = String.valueOf(value);
                } else {
                    obj = value;
                }
            } else if ("long".equals(type)) {
                if (value instanceof Double) {
                    obj = (long) ((double) value);
                } else if (value instanceof String) {
                    obj = Long.valueOf((String) value);
                } else {
                    obj = value;
                }
            } else if ("double".equals(type)) {
                obj = value;
            }
        }
        return obj;
    }
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

class ItemExcelWrapper extends BaseModel<ItemExcelWrapper> {

    private List<GoodsOptionPO> optData;
    private List<GoodsItemPO> itmData;

    public ItemExcelWrapper() {
        this.optData = new ArrayList<>();
        this.itmData = new ArrayList<>();
    }

    public List<GoodsOptionPO> getOptData() {
        return optData;
    }

    public void setOptData(List<GoodsOptionPO> optData) {
        this.optData = optData;
    }

    public List<GoodsItemPO> getItmData() {
        return itmData;
    }

    public void setItmData(List<GoodsItemPO> itmData) {
        this.itmData = itmData;
    }
}

