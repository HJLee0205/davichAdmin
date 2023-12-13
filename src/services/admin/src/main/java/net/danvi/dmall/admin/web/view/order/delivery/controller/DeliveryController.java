package net.danvi.dmall.admin.web.view.order.delivery.controller;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;

import lombok.extern.slf4j.Slf4j;
import net.danvi.dmall.admin.web.common.util.ExcelReader;
import net.danvi.dmall.admin.web.common.view.View;
import net.danvi.dmall.biz.app.order.delivery.model.DeliveryPO;
import net.danvi.dmall.biz.app.order.delivery.model.DeliverySO;
import net.danvi.dmall.biz.app.order.delivery.model.DeliveryVO;
import net.danvi.dmall.biz.app.order.delivery.service.DeliveryService;
import net.danvi.dmall.biz.system.model.CmnCdDtlVO;
import net.danvi.dmall.biz.system.security.SessionDetailHelper;
import net.danvi.dmall.biz.system.util.ServiceUtil;
import dmall.framework.common.constants.CommonConstants;
import dmall.framework.common.exception.JsonValidationException;
import dmall.framework.common.model.ExcelViewParam;
import dmall.framework.common.model.FileVO;
import dmall.framework.common.model.ResultListModel;
import dmall.framework.common.model.ResultModel;
import dmall.framework.common.util.CryptoUtil;
import dmall.framework.common.util.DateUtil;
import dmall.framework.common.util.FileUtil;
import dmall.framework.common.util.MessageUtil;

/**
 * <pre>
 * 프로젝트명 : 41.admin.web
 * 작성일     : 2016. 5. 02.
 * 작성자     : dong
 * 설명       :
 * </pre>
 */
@Slf4j
@Controller
@RequestMapping("/admin/order/delivery")
public class DeliveryController {

    @Resource(name = "deliveryService")
    private DeliveryService deliveryService;

    @Value("#{system['system.upload.temp.path']}")
    private String tempFilePath;

    @Resource(name = "excelReader")
    private ExcelReader excelReader;

    /**
     * <pre>
     * 작성일 : 2016. 5. 2.
     * 작성자 : dong
     * 설명   : 출고(배송)목록을 조회하는 화면
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 2. dong - 최초생성
     * </pre>
     *
     * @return
     */
    @RequestMapping("/delivery")
    public ModelAndView viewDeliveryListPaging(DeliverySO so) {
        log.debug("================================");
        log.debug("Start : " + "출고(배송)목록을 조회하는 화면");
        log.debug("================================");
        ModelAndView mv = new ModelAndView("/admin/order/delivery/viewDeliveryListPaging");
        if ((so.getPage() == 0) || "".equals(so.getPage())) so.setPage(1);

        List<CmnCdDtlVO> ordStatusCdList = ServiceUtil.listCode("ORD_STATUS_CD", "ON", null, null, null, null);
        String deliveryCds = "30,40,50";
        List<CmnCdDtlVO> ordStatusCdListCopy = new ArrayList<CmnCdDtlVO>();

        for (CmnCdDtlVO vo : ordStatusCdList) {
            if (deliveryCds.indexOf(vo.getDtlCd()) > -1) ordStatusCdListCopy.add(vo);
        }
        mv.addObject("deliverySO", so);
        mv.addObject("ordStatusCdList", ordStatusCdListCopy);
        mv.addObject("saleChannelCdList", ServiceUtil.listCode("SALE_CHANNEL_CD", null, null, null, null, null));
        mv.addObject("siteNo", SessionDetailHelper.getDetails().getSiteNo());
        return mv;
    }

    @RequestMapping("/delivery-list")
    public @ResponseBody ResultListModel<DeliveryVO> selectDeliveryListPaging(DeliverySO so,
            BindingResult bindingResult) throws Exception {

        log.debug("================================");
        log.debug("Start : " + "viewOrdListPaging 에서 넘어온 검색조건에 맞는 주문 목록을 조회하여 리턴");
        log.debug("================================");

        if (bindingResult.hasErrors()) {
            log.debug("ERROR : {}", bindingResult.getAllErrors().toString());
            throw new JsonValidationException(bindingResult);
        }

        if ("02".equals(so.getSearchCd())) { // 주문자명
            so.setSearchWord(CryptoUtil.encryptAES(so.getSearchWord()));
        }

        ResultListModel<DeliveryVO> resultList = deliveryService.selectDeliveryListPaging(so);
        return resultList;
    }

    @RequestMapping("/delivery-excel-download")
    public String selectDeliveryListExcel(DeliverySO so, BindingResult bindingResult, Model model) throws Exception {
        log.debug("================================");
        log.debug("Start : " + "검색 조건에 따른 주문목록의 전체를 Excel파일 형태로 다운로드하기 위한 화면");
        log.debug("================================");
        so.setOffset(10000000);
        if ("02".equals(so.getSearchCd())) { // 주문자명
            so.setSearchWord(CryptoUtil.encryptAES(so.getSearchWord()));
        }
        List<DeliveryVO> resultList = deliveryService.selectDeliveryListExcel(so);

        // 엑셀의 헤더 정보 세팅
        String[] headerName = new String[] { "주문일시", "배송시작일시", "주문번호", "주문상품", "주문자명", "주문자아이디", "주문자등급", "배송상태",
                "택배사명", "송장번호" };
        // 엑셀에 출력할 데이터 세팅
        String[] fieldName = new String[] { "ordAcceptDttm", "rlsCmpltDttm", "ordNo", "goodsNm", "ordrNm", "loginId",
                "memberGradeNm", "ordDtlStatusNm", "rlsCourierNm", "rlsInvoiceNo" };

        model.addAttribute(CommonConstants.EXCEL_PARAM_NAME,
                new ExcelViewParam("주문 관리", headerName, fieldName, resultList));
        model.addAttribute(CommonConstants.EXCEL_PARAM_FILE_NAME, "deliveryList_" + DateUtil.getNowDate()); // 엑셀
        // 파일명

        return View.excelDownload();
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 30.
     * 작성자 : dong
     * 설명   : 주문 상세 페이지에서 호출되어 배송정보를 수정한다.
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 30. dong - 최초생성
     * </pre>
     *
     * @return
     */
    @RequestMapping("/order-address-update")
    public @ResponseBody ResultModel<DeliveryPO> updateOrdDtlDeliveryAddr(DeliveryPO po, BindingResult bindingResult) {
        ResultModel<DeliveryPO> result = new ResultModel<>();
        result.setMessage(MessageUtil.getMessage("biz.common.update"));
        if (deliveryService.updateOrdDtlDeliveryAddr(po))
            result.setMessage(MessageUtil.getMessage("biz.common.update"));
        else
            result.setMessage(MessageUtil.getMessage("biz.exception.common.error"));
        return result;

    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 2.
     * 작성자 : dong
     * 설명   : 송장번호 일괄등록을 위한 목록을 조회한다.
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 2. dong - 최초생성
     * </pre>
     *
     * @return
     */
    @RequestMapping("/invoice-list")
    public ModelAndView viewInvoiceAddList() {
        log.debug("================================");
        log.debug("Start : " + "송장번호 일괄등록을 위한 목록을 조회한다.");
        log.debug("================================");

        ModelAndView mv = new ModelAndView("/admin/order/delivery/viewInvoiceAddList");
        mv.addObject("siteNo", SessionDetailHelper.getDetails().getSiteNo());
        mv.addObject("courierCdList", ServiceUtil.listCode("COURIER_CD", null, null, null, null, null));
        return mv;
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 2.
     * 작성자 : dong
     * 설명   : 송장번호 일괄등록을 위한 엑셀파일을 다운로드한다.
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 2. dong - 최초생성
     * </pre>
     *
     * @return
     */
    @RequestMapping("/invoice-temp-download")
    public String downInvoiceAddList(DeliverySO so, Model model) {
        log.debug("================================");
        log.debug("Start : " + "송장번호 일괄등록을 위한 엑셀파일을 다운로드한다.");
        log.debug("================================");
        // 엑셀로 출력할 데이터 조회
        ResultListModel<DeliveryVO> resultListModel = deliveryService.downInvoiceAddList(so);
        // 엑셀의 헤더 정보 세팅
        String[] headerName = new String[] { "상품명", "옵션명", "주문번호", "주문상세번호", "상태", "주문자명", "주문수량", "배송처리된수량",
                "배송처리가능수량", "배송업체(업체코드)|A", "송장번호|A", "주소", "", "", "" };
        // 엑셀에 출력할 데이터 세팅
        String[] fieldName = new String[] { "goodsNm", "itemNm", "ordNo", "ordDtlSeq", "ordDtlStatusNm", "ordrNm",
                "ordQtt", "dlvrQtt", "ordQtt", "rlsCourierCd", "rlsInvoiceNo", "postNo", "roadnmAddr", "numAddr",
                "dtlAddr" };

        model.addAttribute(CommonConstants.EXCEL_PARAM_NAME,new ExcelViewParam("송장 일괄 등록", headerName, fieldName, resultListModel.getResultList()));
        model.addAttribute(CommonConstants.EXCEL_PARAM_FILE_NAME, "invoice_" + DateUtil.getNowDate()); // 엑셀
        // 파일명

        return View.excelDownload();
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 2.
     * 작성자 : dong
     * 설명   : 작성한 송장번호 일괄등록 엑셀파일을 업로드한다
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 2. dong - 최초생성
     * </pre>
     *
     * @return
     */
    @RequestMapping("/invoice-excel-download")
    public @ResponseBody ResultListModel<DeliveryVO> upInvoiceAddList(MultipartHttpServletRequest mRequest)
            throws Exception {
        ResultListModel<DeliveryVO> result = new ResultListModel();

        // FileVO result = new FileVO();
        MultipartFile file = FileUtil.getExcel(mRequest, "excel");

        // 엑셀 파일을 읽어 리스트 형태로 반환
        List<Map<String, Object>> list = excelReader.convertExcelToListByMap(file);
        result.setResultList(deliveryService.upInvoiceAddList(list));
        result.setTotalRows(result.getResultList().size());
        return result;
    }

    @RequestMapping("/invoice-upload")
    public @ResponseBody ResultModel uploadInvoiceForm(DeliveryPO po, HttpServletRequest request) {
        ResultModel result = new ResultModel();
        /**
         * 파일 정보 추출
         * 임시 폴더로 보내던 실제 서비스 폴더로 보내던, 업로드 한 파일을 filePath에 저장함
         * 여기서 임시 폴더로 filePath를 지정할 경우, 서비스 폴더로 나중에 이동시켜야 함.
         */
        List<FileVO> fileList = FileUtil.getFileListFromRequest(request, tempFilePath);

        // TODO: PO 정보 저장
        return result;
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 2.
     * 작성자 : dong
     * 설명   : 송장번호 일괄 등록.
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 2. dong - 최초생성
     * </pre>
     *
     * @return
     */
    @RequestMapping("/invoice-all-insert")
    public @ResponseBody ResultModel insertInvoiceAddList(@RequestParam Map<String, Object> map) {
        log.debug("================================");
        log.debug("Start : " + "송장번호 일괄 목록을 등록한다.");
        log.debug("================================");

        List<String> ordNoList = new ArrayList<String>(Arrays.asList(((String) map.get("ordNoArr")).split(",")));
        List<String> ordDtlSeqList = new ArrayList<String>(Arrays.asList(((String) map.get("ordDtlSeqArr")).split(",")));
        List<String> rlsCourierCdList = new ArrayList<String>(Arrays.asList(((String) map.get("rlsCourierCdArr")).split(",")));
        List<String> rlsInvoiceNoList = new ArrayList<String>(Arrays.asList(((String) map.get("rlsInvoiceNoArr")).split(",")));
        List<String> dlvrQttList = new ArrayList<String>(Arrays.asList(((String) map.get("dlvrQttArr")).split(",")));
        List<String> goodsNoList = new ArrayList<String>(Arrays.asList(((String) map.get("goodsNoArr")).split(",")));
        List<String> ordDtlStatusCdList = new ArrayList<String>(Arrays.asList(((String) map.get("ordDtlStatusCdArr")).split(",")));

        List<DeliveryPO> listPO = new ArrayList<DeliveryPO>();
        int index = 0;
        for (String str : ordNoList) {
            DeliveryPO po = new DeliveryPO();
            if (!"".equals(str) && !"".equals(ordDtlSeqList.get(index))) {
                po.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
                po.setOrdNo(str);
                po.setOrdDtlSeq(ordDtlSeqList.get(index));
                po.setRlsCourierCd(rlsCourierCdList.get(index));
                po.setRlsInvoiceNo(rlsInvoiceNoList.get(index));
                po.setDlvrQtt(dlvrQttList.get(index));
                po.setOrdStatusCd(ordDtlStatusCdList.get(index));
                po.setGoodsNo(goodsNoList.get(index));
                // 송장번호 유효성 체크
                ResultModel<String> chkModel = deliveryService.checkRlsInvoiceNo(po.getRlsCourierCd(),po.getRlsInvoiceNo(), "");
                if (chkModel.isSuccess()) {
                    listPO.add(po);
                }
            }
            index++;
        }

        int resultCnt = 0;
        if (listPO.size() > 0) resultCnt = deliveryService.insertInvoiceAddList(listPO);

        ResultModel result = new ResultModel();
        result.setMessage(MessageUtil.getMessage("biz.common.insert"));
        log.debug("###############" + (ordNoList.size() - 1) + "####" + resultCnt);
        if (resultCnt > 0) {
            result.setMessage(MessageUtil.getMessage("biz.common.insert"));
            if ((ordNoList.size() - 1) > resultCnt) {
                String args[] = { resultCnt + "" };
                result.setMessage(MessageUtil.getMessage("biz.exception.ord.notValidInvoiceNoPartly", args));
            }
        } else
            result.setMessage(MessageUtil.getMessage("biz.exception.common.error"));
        return result;

    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 2.
     * 작성자 : dong
     * 설명   : 주문 상세 페이지에서 호출되는 배송정보 입력 및 수정 팝업.
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 2. dong - 최초생성
     * </pre>
     *
     * @return
     */
    @RequestMapping("/invoice-popup")
    public @ResponseBody ResultListModel<DeliveryVO> viewPopupOrdDtlInvoice(DeliveryVO vo,
            BindingResult bindingResult) {
        log.debug("================================");
        log.debug("Start : " + "주문 상세 페이지에서 호출되는 배송정보 입력 및 수정 팝업");
        log.debug("================================");
        ResultListModel<DeliveryVO> listModel = new ResultListModel<DeliveryVO>();

        Long sellerNo = SessionDetailHelper.getSession().getSellerNo();
        if(sellerNo!=null && sellerNo >0){
            vo.setSellerNo(String.valueOf(sellerNo));
        }

        List<DeliveryVO> list = deliveryService.selectOrdDtlInvoice(vo);
        listModel.setResultList(list);
        listModel.setTotalRows(list.size());

        return listModel;
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 2.
     * 작성자 : dong
     * 설명   : 주문의 배송처리 - 배송정보를 등록한다.
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 2. dong - 최초생성
     * </pre>
     *
     * @return
     */
    @RequestMapping("/order-newinvoice-update")
    public @ResponseBody ResultModel updateOrdDtlInvoiceNew(DeliveryPO po, BindingResult bindingResult) {
        log.debug("================================");
        log.debug("Start : " + "주문의 배송정보를 등록한다");
        log.debug("================================");
        ResultModel<DeliveryPO> result = new ResultModel<DeliveryPO>();

        if (!"04".equals(po.getDlvrcPaymentCd())) { // 방문 수령 제외
            // 송장번호 유효성 체크
            ResultModel<String> chkModel = deliveryService.checkRlsInvoiceNo(po.getRlsCourierCd(), po.getRlsInvoiceNo(),"");
            if (!chkModel.isSuccess()) {
                result.setSuccess(false);
                result.setMessage(chkModel.getMessage());
                return result;
            }
        }
        boolean isSuccess = deliveryService.updateOrdDtlInvoiceNew(po);
        result.setSuccess(isSuccess);
        result.setData(po);
        result.setMessage(MessageUtil.getMessage("biz.common.insert"));
        if (isSuccess)
            result.setMessage(MessageUtil.getMessage("biz.common.insert"));
        else
            result.setMessage(MessageUtil.getMessage("biz.exception.common.error"));
        return result;

    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 2.
     * 작성자 : dong
     * 설명   : 주문의 상세페이지의 배송정보를 수정한다.
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 2. dong - 최초생성
     * </pre>
     *
     * @return
     */
    @RequestMapping("/order-invoice-update")
    public @ResponseBody ResultModel<DeliveryPO> updateOrdDtlInvoice(DeliveryPO po, BindingResult bindingResult) {
        log.debug("================================");
        log.debug("Start : " + "주문의 배송정보를 수정한다");
        log.debug("================================");
        ResultModel<DeliveryPO> result = new ResultModel<DeliveryPO>();

        // 송장번호 유효성 체크
        ResultModel<String> chkModel = deliveryService.checkRlsInvoiceNo(po.getRlsCourierCd(), po.getRlsInvoiceNo(),
                "");
        if (!chkModel.isSuccess()) {
            result.setSuccess(false);
            result.setMessage(chkModel.getMessage());
            return result;
        }

        boolean isSuccess = deliveryService.updateOrdDtlInvoice(po);
        result.setSuccess(isSuccess);
        result.setData(po);
        result.setMessage(MessageUtil.getMessage("biz.common.update"));
        if (isSuccess)
            result.setMessage(MessageUtil.getMessage("biz.common.update"));
        else
            result.setMessage(MessageUtil.getMessage("biz.exception.common.error"));
        return result;
    }

    @RequestMapping("/site-courier-list")
    public @ResponseBody ResultListModel<DeliveryVO> selectSiteCourierList(DeliveryVO vo, BindingResult bindingResult) {
        log.debug("================================");
        log.debug("Start : " + "배송방법 입력을 위한 택배사 목록을 조회한다.");
        log.debug("================================");
        ResultListModel<DeliveryVO> listModel = new ResultListModel<DeliveryVO>();
        List<DeliveryVO> list = deliveryService.selectSiteCourierList();
        listModel.setResultList(list);
        listModel.setTotalRows(list.size());

        return listModel;
    }
}
