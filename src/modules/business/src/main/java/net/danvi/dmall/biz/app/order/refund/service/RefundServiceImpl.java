package net.danvi.dmall.biz.app.order.refund.service;

import java.text.SimpleDateFormat;
import java.util.*;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import com.fasterxml.jackson.databind.ObjectMapper;
import dmall.framework.common.constants.RequestAttributeConstants;
import dmall.framework.common.constants.UploadConstants;
import dmall.framework.common.model.CmnAtchFilePO;
import dmall.framework.common.model.CmnAtchFileSO;
import dmall.framework.common.util.FileUtil;
import dmall.framework.common.util.HttpUtil;
import dmall.framework.common.util.StringUtil;
import net.danvi.dmall.biz.app.order.manage.model.*;
import net.danvi.dmall.biz.app.visit.model.VisitVO;
import net.danvi.dmall.biz.common.service.BizService;
import net.danvi.dmall.biz.common.service.EditorService;
import net.danvi.dmall.biz.ifapi.cmmn.CustomIfException;
import net.danvi.dmall.biz.ifapi.cmmn.constant.Constants;
import net.danvi.dmall.biz.ifapi.cmmn.mapp.dto.OrderMapDTO;
import net.danvi.dmall.biz.ifapi.cmmn.mapp.service.MappingService;
import net.danvi.dmall.biz.ifapi.cmmn.service.LogService;
import net.danvi.dmall.biz.ifapi.dist.dto.*;
import net.danvi.dmall.biz.ifapi.dist.service.DistService;
import net.danvi.dmall.biz.ifapi.mem.dto.MemberDPointCtVO;
import net.danvi.dmall.biz.ifapi.mem.dto.OfflineMemberSO;
import net.danvi.dmall.biz.ifapi.mem.dto.OfflineMemberVO;
import net.danvi.dmall.biz.ifapi.mem.service.ErpMemberService;
import net.danvi.dmall.biz.ifapi.mem.service.ErpPointService;
import net.sf.json.JSONObject;
import org.springframework.dao.DuplicateKeyException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import dmall.framework.common.BaseService;
import dmall.framework.common.constants.MapperConstants;
import dmall.framework.common.exception.CustomException;
import dmall.framework.common.model.ResultListModel;
import dmall.framework.common.model.ResultModel;
import dmall.framework.common.util.MessageUtil;
import lombok.extern.slf4j.Slf4j;
import net.danvi.dmall.biz.app.order.constants.OrdStatusConstants;
import net.danvi.dmall.biz.app.order.manage.service.OrderService;
import net.danvi.dmall.biz.app.order.payment.model.OrderPayPO;
import net.danvi.dmall.biz.app.order.payment.model.OrderPayVO;
import net.danvi.dmall.biz.system.security.SessionDetailHelper;
import net.danvi.dmall.core.constants.CoreConstants;

/**
 * Created by dong on 2016-05-02.
 */
/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 5. 3.
 * 작성자     : dong
 * 설명       : 반품/환불 관리 컴포넌트의 서비스 인터페이스
 * </pre>
 */
@Slf4j
@Service("refundService")
@Transactional(rollbackFor = Exception.class)
public class RefundServiceImpl extends BaseService implements RefundService {

    @Resource(name = "orderService")
    private OrderService orderService;

    @Resource(name = "mappingService")
    private MappingService mappingService;

    @Resource(name = "bizService")
    private BizService bizService;

    @Resource(name = "editorService")
    private EditorService editorService;

    @Resource(name = "distService")
    private DistService distService;

    @Resource(name="logService")
    private LogService logService;

    @Resource(name="erpPointService")
    private ErpPointService erpPointService;

    @Resource(name="erpMemberService")
    private ErpMemberService erpMemberService;

    /**
     * 반품/교환 목록
     */
    @Override
    public ResultListModel<ClaimGoodsVO> selectRefundListPaging(ClaimSO so) {
        if (so.getSidx().length() == 0) {
            so.setSidx("REG_DTTM");
            so.setSord("DESC");
        }

        return proxyDao.selectListPage(MapperConstants.ORDER_REFUND + "selectRefundListPaging", so);

    }

    /**
     * 엑셀 다운로드용 목록 조회
     */
    public List<ClaimGoodsVO> selectRefundListExcel(ClaimSO so) throws CustomException {
        so.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());

        List<ClaimGoodsVO> resultList = proxyDao.selectList(MapperConstants.ORDER_REFUND + "selectRefundListPaging",
                so);
        return resultList;

    }

    /**
     * <pre>
     * 작성일 : 2016. 6. 09.
     * 작성자 : dong
     * 설명   : 환불 처리를 위한 목록
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 09. dong - 최초생성
     * </pre>
     *
     * @return List<DeliveryVO>
     */
    public List<ClaimGoodsVO> selectOrdDtlRefund(ClaimGoodsVO vo) throws Exception{
        return proxyDao.selectList(MapperConstants.ORDER_REFUND + "selectOrdDtlRefund", vo);
    }

    /**
     * 반품/환불
     */
    @Override
    public ResultModel<ClaimGoodsVO> updateClaimAllRefund(ClaimGoodsPO po) throws Exception {
        ResultModel<ClaimGoodsVO> result = new ResultModel<>();
        HttpServletRequest request = HttpUtil.getHttpServletRequest();
        String ordDtlSeqArr[] = po.getOrdDtlSeqArr();
        int idx = 0;
        String ordNoBuf = "", newOrdNo = "";

        HashMap<String, String> map = new HashMap<String, String>();
        String claimNo = String.valueOf(bizService.getSequence("CLAIM_NO", Long.valueOf(1)));
        // 임시 경로의 파일을 서비스 경로로 복사, 업로드 했다 에디터에서 삭제한 파일 삭제
        editorService.setEditorImageToService(po, claimNo, "CLAIM_INFO");
        // 에디터 내용의 업로드 이미지 정보 변경
        po.setClaimDtlReason(StringUtil.replaceAll(po.getClaimDtlReason(), (String) request.getAttribute(RequestAttributeConstants.IMAGE_DOMAIN),""));
        po.setClaimDtlReason(StringUtil.replaceAll(po.getClaimDtlReason(), UploadConstants.IMAGE_TEMP_EDITOR_URL,UploadConstants.IMAGE_EDITOR_URL));
        // 파일 구분세팅 및 파일명 세팅
        FileUtil.setEditorImageList(po, "CLAIM_INFO", po.getAttachImages());
        int claimResult =0;
        po.setOrdNo(po.getOrdNo());
        po.setClaimNo(claimNo);
        for (String ordDtlSeq : ordDtlSeqArr) {
            if(!ordDtlSeq.equals("")) {
                if (po.getOrdNo() != null && !"".equals(po.getOrdNo())) {
                    po.setOrdDtlSeq(ordDtlSeq);
                    po.setClaimReasonCd(po.getClaimReasonCdArr()[idx]);
                    po.setReturnCd(po.getClaimReturnCdArr()[idx]);
                    po.setClaimCd(po.getClaimExchangeCdArr()[idx]);
                    po.setClaimQtt(Integer.parseInt(po.getClaimQttArr()[idx]));
                    po.setOrdQtt(po.getOrdQttArr()[idx]);

                    if ("11".equals(po.getReturnCd()) && "11".equals(po.getClaimCd())) { // 반품신청, 환불신청
                        po.setOrdDtlStatusCd("70"); // 환불신청
                    } else {
                        throw new CustomException("biz.exception.ord.failUpdateOrdStatus", new Object[]{po.getOrdNo()});
                    }


                    //이미 신청된 반품/환불신청 수량을 조회
                    int preClaimQtt =proxyDao.selectOne(MapperConstants.ORDER_REFUND + "selectRefundClaimQtt", po);
                    int claimQtt = po.getClaimQtt();

                    //클레임 신청수량과 주문수량을 비교하여 부분클레임 여부 판단
                    log.info("preClaimQtt ::::::::::::부분 환불 신청::::::::::::::::::::::::::::::::::: ", preClaimQtt);
                    log.info("po.getOrdQtt() ::::::::::::부분 환불 신청:::::::::::::::주문 수량:::::::::::::::::::: ", po.getOrdQtt());
                    log.info("claimQtt ::::::::::::::부분 환불 신청:::::::::::::::환불 신청 수량:::::::::::::::::: ", claimQtt);
                    if(Integer.parseInt(po.getOrdQtt()) > claimQtt ){
                        //부분환불신청
                        po.setOrdDtlStatusCd("72");
                    }else if(Integer.parseInt(po.getOrdQtt()) == claimQtt){
                        //환불신청
                        po.setOrdDtlStatusCd("70");
                    }else{
                        throw new CustomException("biz.exception.ord.failUpdateOrdStatus", new Object[]{po.getOrdNo()});
                    }

                    //전체 반품/환불 일때 처리 -> 수량 반품/환불로 변경후 별도 테이블로 저장함.
                    claimResult += proxyDao.update(MapperConstants.ORDER_REFUND + "insertClaimRefund", po);

                    //클레임 처리후 주문상세 상태 변경
                    proxyDao.update(MapperConstants.ORDER_REFUND + "updateClaimAllRefund", po);
                }
                idx++;
            }
        }

        // 파일 정보 디비 저장
        for (CmnAtchFilePO p : po.getAttachImages()) {
            // 파일이 임시 파일일 경우만 등록 처리(2016.09.26)
            if (p.getTemp()) {
                p.setRefNo(claimNo); // 참조의 번호
                editorService.insertCmnAtchFile(p);
            }
        }
        // 임시 경로의 이미지 삭제
        FileUtil.deleteEditorTempImageList(po.getAttachImages());


        /** 반품등록 interface 호출*/
        try {
            if(claimResult>0) {
                this.returnRegist(po);
            }
        } catch (Exception e) {

            throw new CustomException("biz.exception.common.error");
        }


        return result;
    }

    /**
     * 클레임 결제 현금 환불 정보 등록
     * table : TO_PAYMENT_CASH_REFUND
     */
    @Override
    public ResultModel<ClaimPayRefundPO> insertPaymerCashRefund(ClaimPayRefundPO po) throws Exception {
        ResultModel<ClaimPayRefundPO> result = new ResultModel<>();
        // 주문정보 등록 Biz실행
        int i = 0;
        i = selectCashRefundCount(po);

        if (i > 0) {
            proxyDao.update(MapperConstants.ORDER_REFUND + "updatePaymerCashRefund", po);
        } else {
            proxyDao.insert(MapperConstants.ORDER_REFUND + "insertPaymerCashRefund", po);
        }
        return result;
    }

    /**
     * 프론트용 주문 취소 신청
     */
    @Override
    public ResultModel<OrderPO> frontOrderCancelRequest(OrderPO po) throws Exception {
        ResultModel<OrderPO> result = new ResultModel<>();

        // ClaimGoodsPO cpo = new ClaimGoodsPO();
        ClaimPayRefundPO cprp = new ClaimPayRefundPO();


        String claimNoArr[] = po.getClaimNoArr();
        //사용자 결제취소신청시....
        if(claimNoArr==null || claimNoArr.length==0){
            String claimNo = String.valueOf(bizService.getSequence("CLAIM_NO", Long.valueOf(1)));
            po.setClaimNo(claimNo);
        }

            // 취소신청 상태변경
            for (int i = 0; i < po.getOrdDtlSeqArr().length; i++) {
                ClaimGoodsPO cpo = new ClaimGoodsPO();
                //결제취소 처리시...
                if(claimNoArr!=null && claimNoArr.length>0){
                    cpo.setClaimNo(claimNoArr[i]);
                }
                cpo.setSiteNo(po.getSiteNo());
                cpo.setOrdNo(Long.toString(po.getOrdNo()));
                cpo.setOrdDtlSeq(po.getOrdDtlSeqArr()[i]);
                cpo.setOrdDtlStatusCd(po.getCancelStatusCd());
                cpo.setReturnCd("11"); // 반품코드(반품신청)
                cpo.setClaimCd("31"); // 클레임코드(결제취소신청)
                cpo.setClaimReasonCd(po.getClaimReasonCd());
                cpo.setClaimDtlReason(po.getClaimDtlReason());
                cpo.setUpdrNo(po.getUpdrNo());
                cpo.setClaimQtt(Integer.parseInt(po.getClaimQttArr()[i]));
                cpo.setCancelStatusCd(po.getCancelStatusCd());
                cpo.setClaimNo(po.getClaimNo());
                this.updateClaimRefund(cpo);
            }

            // 현금 환불 계좌 등록
            log.debug("결제번호 : " + po.getPaymentNo());
            log.debug("결제유형코드 : " + po.getRefundTypeCd());
            log.debug("환불상태코드 : " + po.getRefundStatusCd());
            log.debug("환불금액 : " + po.getRefundAmt());
            log.debug("환불메모 : " + po.getRefundMemo());
            log.debug("은행코드 : " + po.getBankCd());
            log.debug("계좌번호 : " + po.getActNo());
            log.debug("예금주 : " + po.getHolderNm());
            cprp.setPaymentNo(po.getPaymentNo());
            cprp.setRefundTypeCd("01"); // 환불유형코드(결제취소환불)
            cprp.setRefundStatusCd("01"); // 환불상태코드(접수)
            cprp.setBankCd(po.getBankCd());
            cprp.setActNo(po.getActNo());
            cprp.setHolderNm(po.getHolderNm());
            cprp.setOrdNo(Long.toString(po.getOrdNo()));
            cprp.setAcceptNo(Long.toString(po.getRegrNo()));
            cprp.setRegrNo(po.getRegrNo());
            this.insertPaymerCashRefund(cprp);
            result.setSuccess(true);

        return result;
    }

    /**
     *
     * <pre>
     * 작성일 : 2016. 8. 25.
     * 작성자 : dong
     * 설명   : 주문 결제 ( 메모 환불 금액 등 ) 환불, 결제취소
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 29. dong - 최초생성
     * </pre>
     *
     * @param so
     * @return
     * @throws CustomException
     */
    @Override
    public ResultModel<ClaimVO> selectOrdDtlPayCancelInfo(ClaimSO so) throws Exception {
        ResultModel<ClaimVO> result = new ResultModel<ClaimVO>();
        /*ClaimVO claimVO = new ClaimVO();
        List<ClaimGoodsVO> claimGoodsList = new ArrayList<ClaimGoodsVO>();
        List<ClaimPayRefundVO> claimPayRefundList = new ArrayList<ClaimPayRefundVO>();

        long totalDlvrPrice = 0;
        String[] ordDtlSeqArr = so.getOrdDtlSeqArr();

        OrderInfoVO oiv = new OrderInfoVO();
        oiv.setOrdNo(so.getOrdNo());
        // 전체 주문상품 조회
        List<OrderGoodsVO> orderGoodsList = orderService.selectOrdDtlList(oiv);
        log.info("orderGoodsList ::::::::::::::::::::::::::::::::::::::::::::::: "+orderGoodsList);
        // 옵션상품제거
        for (int o = 0; o < orderGoodsList.size(); o++) {
            if ("Y".equals(orderGoodsList.get(o).getAddOptYn())) {
                orderGoodsList.remove(o);
                o--;
            }
        }

        // 선택된 상품제거
        for (int i = 0; i < so.getOrdDtlSeqArr().length; i++) {
            String ordDtlSeq = so.getOrdDtlSeqArr()[i];
            log.info("ordDtlSeq ::::::::::::::::::::::::::::::::::::::::::::::: "+ordDtlSeq);
            if (ordDtlSeq != null && !"".equals(ordDtlSeq)) {
                for (int ov = 0; ov < orderGoodsList.size(); ov++) {
                    if (ordDtlSeq.equals(orderGoodsList.get(ov).getOrdDtlSeq())) {
                        orderGoodsList.remove(ov);
                    }
                }
            }
        }
        // 취소된 상품 제거 ( 과거 부분취소 제거 )
        // 11:주문취소, 21:결제취소, 66:교환완료, 74:환불완료
        for (int ov = 0; ov < orderGoodsList.size(); ov++) {
            if ((orderGoodsList.get(ov).getOrdDtlStatusCd().equals("11")
                    || orderGoodsList.get(ov).getOrdDtlStatusCd().equals("21")
                    || orderGoodsList.get(ov).getOrdDtlStatusCd().equals("66")
                    || orderGoodsList.get(ov).getOrdDtlStatusCd().equals("74"))) {
                orderGoodsList.remove(ov);
            }
        }

        // 재주문된 상품에 대해 배송비 재계산
        Map map;
        String grpCd = "";
        String preGrpCd = "";
        map = orderService.calcDlvrAmt(orderGoodsList, "order");
        Map<String, Long> dlvrPriceMap = (Map<String, Long>) map.get("dlvrPriceMap");
        if (orderGoodsList != null && orderGoodsList.size() > 0) {
            for (OrderGoodsVO vo : orderGoodsList) {
                if ("1".equals(vo.getDlvrSetCd()) && "01".equals(vo.getDlvrcPaymentCd())) { // 기본 무료
                    grpCd = vo.getSellerNo() + "**" + vo.getDlvrSetCd() + "**" + vo.getDlvrcPaymentCd();
                } else if ("1".equals(vo.getDlvrSetCd()) && ("02".equals(vo.getDlvrcPaymentCd()) )) {// 기본 선불 || "04".equals(vo.getDlvrcPaymentCd())
                    grpCd = vo.getSellerNo() + "**" + vo.getDlvrSetCd() + "**" + vo.getDlvrcPaymentCd();
                } else if ("4".equals(vo.getDlvrSetCd()) && ("02".equals(vo.getDlvrcPaymentCd()) )) {// 포장단위별 || "04".equals(vo.getDlvrcPaymentCd())
                    grpCd = vo.getGoodsNo() + "**" + vo.getDlvrSetCd() + "**" + vo.getDlvrcPaymentCd();
                } else if ("6".equals(vo.getDlvrSetCd()) && ("02".equals(vo.getDlvrcPaymentCd()) )) {  //상품별배송비(조건부무료)  선불 || "04".equals(vo.getDlvrcPaymentCd())
                    grpCd = vo.getGoodsNo() + "**" + vo.getDlvrSetCd() + "**" + vo.getDlvrcPaymentCd();
                } else {
                    grpCd = vo.getItemNo() + "**" + vo.getDlvrSetCd() + "**" + vo.getDlvrcPaymentCd();
                }

                if (!grpCd.equals(preGrpCd)) {
                    totalDlvrPrice += dlvrPriceMap.get(grpCd);
                }
            }
        }
        log.info("totalDlvrPrice ::::::::::::::::::::::::::::::::::::: "+totalDlvrPrice);

        log.info("so ::::::::::::::::::::::::::::::::::::: "+so);
        String[] claimQttArr = so.getClaimQttArr();
        long eAmt =0;
        // 취소정보 조회
        if (so.getOrdNo() != null) {
            for (int i = 0; i < ordDtlSeqArr.length; i++) {
                if (!"".equals(ordDtlSeqArr[i])) {

                    // 취소할 주문 상품 조회
                    so.setOrdNo(so.getOrdNo());
                    so.setOrdDtlSeq(ordDtlSeqArr[i]);
                    //관리자 반품 수량 입력시...
                    if(claimQttArr!=null && claimQttArr.length>0) {
                        so.setClaimQtt(Integer.parseInt(claimQttArr[i]));
                    }


                    List<ClaimGoodsVO> claimGoods = proxyDao.selectList(MapperConstants.ORDER_EXCHANGE + "selectOrdDtlExchange",so);
                    for(ClaimGoodsVO vo :claimGoods){
                        claimGoodsList.add(vo);
                    }
                    *//*ClaimGoodsVO vo = proxyDao.selectOne(MapperConstants.ORDER_EXCHANGE + "selectOrdDtlExchange",so);
                    claimGoodsList.add(vo);*//*

                    // 배송비, 환불, 결제취소정보 조회
                    if(so.getRefundType()==null || so.getRefundType().equals("V")) {
                        if (i == 0) {
                            log.debug("재계산 배송비 : " + totalDlvrPrice);
                            so.setTotalDlvrAmt(totalDlvrPrice);

                            List<ClaimPayRefundVO> claimPayrefunds = proxyDao.selectList(MapperConstants.ORDER_REFUND + "selectOrdDtlPayCancelInfo", so);
                            for(ClaimPayRefundVO vo:claimPayrefunds){
                                eAmt +=vo.getEAmt();
                                vo.setEAmt(eAmt);
                                claimPayRefundList.add(vo);
                            }

                            if(claimPayRefundList.size()>1){
                                claimVO.setClaimPayRefundVO(claimPayRefundList.get((claimPayRefundList.size()-1)));
                            }else{
                                claimVO.setClaimPayRefundVO(claimPayRefundList.get(0));
                            }

                            // 이미지 정보 조회 조건 세팅
                            CmnAtchFileSO fileso = new CmnAtchFileSO();
                            fileso.setSiteNo(so.getSiteNo());
                            fileso.setRefNo(String.valueOf(claimVO.getClaimPayRefundVO().getClaimNo()));
                            fileso.setFileGb("CLAIM_INFO");

                            // 공통 첨부 파일 조회
                            editorService.setCmnAtchFileToEditorVO(fileso, claimVO.getClaimPayRefundVO());

                            *//*ClaimPayRefundVO vog = proxyDao.selectOne(MapperConstants.ORDER_REFUND + "selectOrdDtlPayCancelInfo", so);
                            claimVO.setClaimPayRefundVO(vog);*//*
                        }
                    }else if(so.getRefundType()!=null && !so.getRefundType().equals("V")){
                        log.debug("재계산 배송비 : " + totalDlvrPrice);
                        so.setTotalDlvrAmt(totalDlvrPrice);
                        //관리자 반품 수량 입력시...
                        if (claimQttArr.length > 0 && claimQttArr != null)
                            so.setClaimQtt(Integer.parseInt(claimQttArr[i]));

                        List<ClaimPayRefundVO> claimPayrefunds = proxyDao.selectList(MapperConstants.ORDER_REFUND + "selectOrdDtlPayCancelInfo", so);
                        log.debug("claimPayrefunds :::::::::::::::::::::::::::::::::::::::::: " + claimPayrefunds);
                        for(ClaimPayRefundVO vo:claimPayrefunds){
                            eAmt +=vo.getEAmt();
                            vo.setEAmt(eAmt);
                            claimPayRefundList.add(vo);
                        }
                        if(claimPayRefundList.size()>1){
                            claimVO.setClaimPayRefundVO(claimPayRefundList.get((claimPayRefundList.size()-1)));
                        }else{
                            claimVO.setClaimPayRefundVO(claimPayRefundList.get(0));
                        }

                        *//*ClaimPayRefundVO vog = proxyDao.selectOne(MapperConstants.ORDER_REFUND + "selectOrdDtlPayCancelInfo", so);
                        eAmt +=vog.getEAmt();
                        vog.setEAmt(eAmt);
                        claimVO.setClaimPayRefundVO(vog);*//*

                    }else{

                    }

                }
            }
        }
        log.debug("step.10");
        claimVO.setClaimGoodsVO(claimGoodsList);
        result.setData(claimVO);
        *//*result.getData().getClaimPayRefundVO();*//*
        if (result == null) {
            result.setSuccess(false);
            result.setMessage(MessageUtil.getMessage("biz.exception.common.nodata"));
        }*/
        return result;
    }

    /**
     *
     * <pre>
     * 작성일 : 2016. 8. 25.
     * 작성자 : dong
     * 설명   : 주문 결제 ( 메모 환불 금액 등 ) 환불, 결제취소
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 29. dong - 최초생성
     * </pre>
     *
     * @param so
     * @return
     * @throws CustomException
     */
    @Override
    public ResultModel<ClaimVO> selectOrdDtlPayPartCancelInfo(ClaimSO so) throws Exception {
        ResultModel<ClaimVO> result = new ResultModel<ClaimVO>();
        ClaimVO claimVO = new ClaimVO();
        List<ClaimGoodsVO> claimGoodsList = new ArrayList<ClaimGoodsVO>();
        List<ClaimPayRefundVO> claimPayRefundList = new ArrayList<ClaimPayRefundVO>();
        log.info("selectOrdDtlPayPartCancelInfo ::::::::::::::::::::::::::::::::::::::::::::::: "+so);
        long totalDlvrPrice = 0;
        String[] ordDtlSeqArr = so.getOrdDtlSeqArr();

        OrderInfoVO oiv = new OrderInfoVO();
        oiv.setClaimGoodsNoArr(so.getClaimGoodsNoArr());
        oiv.setOrdNo(so.getOrdNo());
        // 전체 주문상품 조회
        List<OrderGoodsVO> orderGoodsList = orderService.selectOrdDtlList(oiv);
        log.info("orderGoodsList ::::::::::::::::::::::::::::::::::::::::::::::: "+orderGoodsList);
        // 옵션상품제거
        for (int o = 0; o < orderGoodsList.size(); o++) {
            if ("Y".equals(orderGoodsList.get(o).getAddOptYn())) {
                orderGoodsList.remove(o);
                o--;
            }
        }

        // 선택된 상품제거
        for (int i = 0; i < so.getOrdDtlSeqArr().length; i++) {
            String ordDtlSeq = so.getOrdDtlSeqArr()[i];
            log.info("ordDtlSeq ::::::::::::::::::::::::::::::::::::::::::::::: "+ordDtlSeq);
            if (ordDtlSeq != null && !"".equals(ordDtlSeq)) {
                for (int ov = 0; ov < orderGoodsList.size(); ov++) {
                    if (ordDtlSeq.equals(orderGoodsList.get(ov).getOrdDtlSeq())) {
                        orderGoodsList.remove(ov);
                    }
                }
            }
        }
        // 취소된 상품 제거 ( 과거 부분취소 제거 )
        // 11:주문취소, 21:결제취소, 66:교환완료, 74:환불완료
        for (int ov = 0; ov < orderGoodsList.size(); ov++) {
            if ((orderGoodsList.get(ov).getOrdDtlStatusCd().equals("11")
                    || orderGoodsList.get(ov).getOrdDtlStatusCd().equals("21")
                    || orderGoodsList.get(ov).getOrdDtlStatusCd().equals("66")
                    || orderGoodsList.get(ov).getOrdDtlStatusCd().equals("74"))) {
                orderGoodsList.remove(ov);
            }
        }
        log.info("orderGoodsList :::::::::::::::::::2222:::::::::::::::::::::::::::: "+orderGoodsList);
        // 재주문된 상품에 대해 배송비 재계산
        Map map;
        String grpCd = "";
        String preGrpCd = "";
        map = orderService.calcDlvrAmt(orderGoodsList, "order");
        log.info("calcDlvrMap ::::::::::::::::::::::::::::::::::::::::::::::: "+map);
        Map<String, Long> dlvrPriceMap = (Map<String, Long>) map.get("dlvrPriceMap");
        if (orderGoodsList != null && orderGoodsList.size() > 0) {
            for (OrderGoodsVO vo : orderGoodsList) {
                if ("1".equals(vo.getDlvrSetCd()) && "01".equals(vo.getDlvrcPaymentCd())) { // 기본 무료
                    grpCd = vo.getSellerNo() + "**" + vo.getDlvrSetCd() + "**" + vo.getDlvrcPaymentCd();
                } else if ("1".equals(vo.getDlvrSetCd()) && ("02".equals(vo.getDlvrcPaymentCd()) )) {// 기본 선불 || "04".equals(vo.getDlvrcPaymentCd())
                    grpCd = vo.getSellerNo() + "**" + vo.getDlvrSetCd() + "**" + vo.getDlvrcPaymentCd();
                } else if ("4".equals(vo.getDlvrSetCd()) && ("02".equals(vo.getDlvrcPaymentCd()) )) {// 포장단위별 || "04".equals(vo.getDlvrcPaymentCd())
                    grpCd = vo.getGoodsNo() + "**" + vo.getDlvrSetCd() + "**" + vo.getDlvrcPaymentCd();
                } else if ("6".equals(vo.getDlvrSetCd()) && ("02".equals(vo.getDlvrcPaymentCd()) )) {  //상품별배송비(조건부무료)  선불 || "04".equals(vo.getDlvrcPaymentCd())
                    grpCd = vo.getGoodsNo() + "**" + vo.getDlvrSetCd() + "**" + vo.getDlvrcPaymentCd();
                } else {
                    grpCd = vo.getItemNo() + "**" + vo.getDlvrSetCd() + "**" + vo.getDlvrcPaymentCd();
                }
                log.info("grpCd ::::::::::::::::::::::::::::::::::::::::::::::: "+grpCd);
                if (!grpCd.equals(preGrpCd)) {
                    totalDlvrPrice += dlvrPriceMap.get(grpCd);
                }
            }
        }
        log.info("totalDlvrPrice ::::::::::::::::::::::::::::::::::::: "+totalDlvrPrice);

        log.info("so ::::::::::::::::::::::::::::::::::::: "+so);
        String[] claimQttArr = so.getClaimQttArr();
        String[] claimGoodsNoArr = so.getClaimGoodsNoArr();
        long eAmt =0;
        long dlvrAmt =0;
        long goodsDmoneyUseAmt =0;
        int lastIdx = ordDtlSeqArr.length - 2;
        // 취소정보 조회
        if (so.getOrdNo() != null) {
            for (int i = 0; i < ordDtlSeqArr.length; i++) {
                if (!"".equals(ordDtlSeqArr[i])) {

                    // 취소할 주문 상품 조회
                    so.setOrdNo(so.getOrdNo());
                    so.setOrdDtlSeq(ordDtlSeqArr[i]);
                    //관리자 반품 수량 입력시...
                    if(claimQttArr != null && claimQttArr.length>0) {
                        so.setClaimQtt(Integer.parseInt(claimQttArr[i]));
                    }
                    if (claimGoodsNoArr != null && claimGoodsNoArr.length > 0) {
                        so.setClaimGoodsNo(claimGoodsNoArr[i]);
                    }
                    log.info("so ::::::::::::::::22222222222:::::::::::::::: "+so);
                    List<ClaimGoodsVO> claimGoods = proxyDao.selectList(MapperConstants.ORDER_EXCHANGE + "selectOrdDtlExchange",so);
                    log.info("claimGoods ::::::::::::::::::::::::::::::::::::: "+claimGoods);
                    for(ClaimGoodsVO vo :claimGoods){
                        claimGoodsList.add(vo);
                    }
                    /*ClaimGoodsVO vo = proxyDao.selectOne(MapperConstants.ORDER_EXCHANGE + "selectOrdDtlExchange",so);
                    claimGoodsList.add(vo);*/

                    // 배송비, 환불, 결제취소정보 조회
                    if(so.getRefundType()==null || so.getRefundType().equals("V")) {
                        if (i == 0) {
                            log.debug("재계산 배송비 : " + totalDlvrPrice);
                            so.setTotalDlvrAmt(totalDlvrPrice);
                            /*ClaimPayRefundVO vog = proxyDao.selectOne(MapperConstants.ORDER_REFUND + "selectOrdDtlPayCancelInfo", so);
                            claimVO.setClaimPayRefundVO(vog);*/
                        }
                        if (claimQttArr != null && claimQttArr.length > 0) {
                            so.setClaimQtt(Integer.parseInt(claimQttArr[i]));
                        }

                        if (claimGoodsNoArr != null && claimGoodsNoArr.length > 0) {
                            so.setClaimGoodsNo(claimGoodsNoArr[i]);
                        }
                        List<ClaimPayRefundVO> claimPayrefunds = proxyDao.selectList(MapperConstants.ORDER_REFUND + "selectOrdDtlPayCancelInfo", so);
                        for(ClaimPayRefundVO vo:claimPayrefunds){
                            eAmt +=vo.getEAmt();
                            vo.setEAmt(eAmt);

                            dlvrAmt += vo.getDlvrAmt();
                            vo.setDlvrAmt(dlvrAmt);

                            goodsDmoneyUseAmt += vo.getGoodsDmoneyUseAmt();
                            vo.setGoodsDmoneyUseAmt(goodsDmoneyUseAmt);

                            claimPayRefundList.add(vo);
                        }

                        log.info("claimPayrefunds ::::::::::::::::::::::::::::::::::::::::::: "+claimPayrefunds);
                        log.info("claimPayRefundList ::::::::::::::::::::::::::::::::::::::::::: "+claimPayRefundList);
                        if(lastIdx == i) {
                            if (claimPayRefundList.size() > 1) {
                                claimVO.setClaimPayRefundVO(claimPayRefundList.get((claimPayRefundList.size() - 1)));
                            } else {
                                claimVO.setClaimPayRefundVO(claimPayRefundList.get(0));
                            }

                            // 이미지 정보 조회 조건 세팅
                            CmnAtchFileSO fileso = new CmnAtchFileSO();
                            fileso.setSiteNo(so.getSiteNo());
                            fileso.setRefNo(String.valueOf(claimVO.getClaimPayRefundVO().getClaimNo()));
                            fileso.setFileGb("CLAIM_INFO");

                            // 공통 첨부 파일 조회
                            editorService.setCmnAtchFileToEditorVO(fileso, claimVO.getClaimPayRefundVO());
                        }

                    }else if(so.getRefundType()!=null && !so.getRefundType().equals("V")){
                        log.debug("재계산 배송비 : " + totalDlvrPrice);
                        so.setTotalDlvrAmt(totalDlvrPrice);
                        //관리자 반품 수량 입력시...
                        if (claimQttArr != null && claimQttArr.length > 0) {
                            so.setClaimQtt(Integer.parseInt(claimQttArr[i]));
                        }

                        if (claimGoodsNoArr != null && claimGoodsNoArr.length > 0) {
                            so.setClaimGoodsNo(claimGoodsNoArr[i]);
                        }

                        List<ClaimPayRefundVO> claimPayrefunds = proxyDao.selectList(MapperConstants.ORDER_REFUND + "selectOrdDtlPayCancelInfo", so);
                        log.debug("claimPayrefunds :::::::::::::::::::::::::::::::::::::::::: " + claimPayrefunds);
                        for(ClaimPayRefundVO vo:claimPayrefunds){
                            eAmt +=vo.getEAmt();
                            vo.setEAmt(eAmt);

                            dlvrAmt += vo.getDlvrAmt();
                            vo.setDlvrAmt(dlvrAmt);

                            goodsDmoneyUseAmt += vo.getGoodsDmoneyUseAmt();
                            vo.setGoodsDmoneyUseAmt(goodsDmoneyUseAmt);

                            claimPayRefundList.add(vo);
                        }
                        if(lastIdx == i) {
                            if (claimPayRefundList.size() > 1) {
                                claimVO.setClaimPayRefundVO(claimPayRefundList.get((claimPayRefundList.size() - 1)));
                            } else {
                                claimVO.setClaimPayRefundVO(claimPayRefundList.get(0));
                            }
                        }

                        /*ClaimPayRefundVO vog = proxyDao.selectOne(MapperConstants.ORDER_REFUND + "selectOrdDtlPayCancelInfo", so);
                        eAmt +=vog.getEAmt();
                        vog.setEAmt(eAmt);
                        claimVO.setClaimPayRefundVO(vog);*/

                    }else{

                    }

                }
            }
        }
        log.debug("step.10");
        claimVO.setClaimGoodsVO(claimGoodsList);
        result.setData(claimVO);
        /*result.getData().getClaimPayRefundVO();*/
        if (result == null) {
            result.setSuccess(false);
            result.setMessage(MessageUtil.getMessage("biz.exception.common.nodata"));
        }
        return result;
    }

    @Override
    public ResultModel<ClaimGoodsVO> updateClaimRefund(ClaimGoodsPO po) throws CustomException {
        ResultModel<ClaimGoodsVO> result = new ResultModel<>();

        if (OrdStatusConstants.PAY_CANCEL.equals(po.getOrdDtlStatusCd())) { // 결제 취소 완료
            po.setReturnCd("12");
            po.setClaimCd("32");
            po.setOrdDtlStatusCd(OrdStatusConstants.PAY_CANCEL);
        } else if (OrdStatusConstants.PAY_CANEL_REQUEST.equals(po.getOrdDtlStatusCd())) { // 결제 취소신청
            po.setReturnCd("11");
            po.setClaimCd("31");
            po.setOrdDtlStatusCd(OrdStatusConstants.PAY_CANEL_REQUEST);
        } else if (OrdStatusConstants.ORD_CANCEL.equals(po.getOrdDtlStatusCd())) { // 주문 취소
            po.setReturnCd("");
            po.setClaimCd("");
            po.setOrdDtlStatusCd(OrdStatusConstants.ORD_CANCEL);
        }else if (OrdStatusConstants.RETURN_DONE.equals(po.getOrdDtlStatusCd())) { // 반품완료
            po.setReturnCd("12");
            po.setClaimCd("12");
            /*po.setOrdDtlStatusCd(OrdStatusConstants.RETURN_DONE);*/
        }else if (OrdStatusConstants.RETURN_APPLY.equals(po.getOrdDtlStatusCd()) && (po.getReturnCd().equals("12") || po.getReturnCd().equals("13"))) { // 환불 취소 신청 ( 반품완료 or 반품철회 )
            //po.setOrdDtlStatusCd(OrdStatusConstants.RETURN_APPLY);
            //반품요청철회시 환불신청 ->  요청철회 처리..
            if(po.getReturnCd().equals("13")){
                po.setReturnCd("13");
                po.setClaimCd("13");
            }
        } else if (OrdStatusConstants.RETURN_APPLY.equals(po.getOrdDtlStatusCd())) { // 환불 취소 신청
            po.setReturnCd("11");
            po.setClaimCd("11");
            /*po.setOrdDtlStatusCd(OrdStatusConstants.RETURN_APPLY);*/
        } else if (OrdStatusConstants.RETURN_CANCEL.equals(po.getOrdDtlStatusCd())) { // 환불 취소 반려
            po.setReturnCd("13");
            po.setClaimCd("13");
            /*po.setOrdDtlStatusCd(OrdStatusConstants.RETURN_CANCEL);*/

        } else {
            throw new CustomException("biz.exception.ord.failUpdateOrdStatus", new Object[] { po.getOrdNo() });
        }
        log.info(":po :::::::::::::::::::::::::::::::: = "+po);
        //주문수량 조회
        int ordQtt =proxyDao.selectOne(MapperConstants.ORDER_REFUND + "selectTotalOrdQtt", po);
        log.info("ordQtt ::::::::::::::::::::::::::::::::: = "+ordQtt);
        po.setOrdQtt(String.valueOf(ordQtt));

        //클레임테이블 분리로인한 SQL 변경
        if(po.getReturnCd().equals("11") && po.getClaimCd().equals("11")){
            //이미 신청된 반품/환불신청 수량을 조회
            int preClaimQtt =proxyDao.selectOne(MapperConstants.ORDER_REFUND + "selectRefundClaimQtt", po);
            int claimQtt = preClaimQtt+po.getClaimQtt();

            log.info("preClaimQtt ::::::::::::::::::::::::::::::::: = "+preClaimQtt);
            log.info("claimQtt ::::::::::::::::::::::::::::::::: = "+claimQtt);
            //클레임 신청수량과 주문수량을 비교하여 부분클레임 여부 판단
            if(Integer.parseInt(po.getOrdQtt()) > claimQtt ){
                //부분환불신청
                po.setOrdDtlStatusCd("72");
            }else if(Integer.parseInt(po.getOrdQtt()) == claimQtt){
                //환불신청
                po.setOrdDtlStatusCd("70");
            }else{
                throw new CustomException("biz.exception.ord.failUpdateOrdStatus", new Object[]{po.getOrdNo()});
            }

            proxyDao.update(MapperConstants.ORDER_REFUND + "insertClaimRefund", po);
            //클레임 처리후 주문상세 상태 변경
            proxyDao.update(MapperConstants.ORDER_REFUND + "updateClaimAllRefund", po);

            OrderGoodsVO orderGoodsVO = new OrderGoodsVO();
            orderGoodsVO.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
            orderGoodsVO.setOrdNo(po.getOrdNo());
            orderGoodsVO.setOrdDtlSeq(po.getOrdDtlSeq());

            Map<String, String> templateCodeMap = new HashMap<>();
            templateCodeMap.put("member","mk034");
            templateCodeMap.put("admin","mk035");
            templateCodeMap.put("seller","mk035");
            try {
                orderService.sendOrdAutoSms("", "12", orderGoodsVO, templateCodeMap);
            } catch (Exception e) {
                throw new CustomException("biz.exception.ord.failUpdateOrdStatus", new Object[]{po.getOrdNo()});
            }
        }else{
            if(po.getOrdDtlStatusCd().equals(OrdStatusConstants.PAY_CANCEL) || po.getOrdDtlStatusCd().equals(OrdStatusConstants.PAY_CANEL_REQUEST) || po.getOrdDtlStatusCd().equals(OrdStatusConstants.ORD_CANCEL) ) {
                proxyDao.update(MapperConstants.ORDER_REFUND + "insertClaimRefund", po);
            }else {
                int claimQtt = po.getClaimQtt();
                if(Integer.parseInt(po.getOrdQtt()) > claimQtt ){
                    if(po.getReturnCd().equals("12")  && po.getClaimCd().equals("12")) {
                        //부분환불완료
                        po.setOrdDtlStatusCd("75");
                    }else if(po.getReturnCd().equals("12") && po.getClaimCd().equals("22")){
                        //부분교환완료
                        po.setOrdDtlStatusCd("67");
                    }else if(po.getReturnCd().equals("12") && po.getClaimCd().equals("11")){
                        //부분환불신청
                        po.setOrdDtlStatusCd("72");
                    }else if(po.getReturnCd().equals("13") && po.getClaimCd().equals("13")){
                        //요청철회
                        po.setOrdDtlStatusCd("73");
                    }else{
                        throw new CustomException("biz.exception.ord.failUpdateOrdStatus", new Object[]{po.getOrdNo()});
                    }
                }else if(Integer.parseInt(po.getOrdQtt()) == claimQtt){

                    if(po.getReturnCd().equals("12") && po.getClaimCd().equals("12")) {
                        //환불완료
                        po.setOrdDtlStatusCd("74");
                    }else if(po.getReturnCd().equals("12") && po.getClaimCd().equals("22")){
                        //교환완료
                        po.setOrdDtlStatusCd("66");
                    }else if(po.getReturnCd().equals("12") && po.getClaimCd().equals("11")){
                        //환불신청
                        po.setOrdDtlStatusCd("70");
                    }else if(po.getReturnCd().equals("13") && po.getClaimCd().equals("13")){
                        //요청철회
                        po.setOrdDtlStatusCd("71");
                    }else{
                        throw new CustomException("biz.exception.ord.failUpdateOrdStatus", new Object[]{po.getOrdNo()});
                    }

                }else{
                    throw new CustomException("biz.exception.ord.failUpdateOrdStatus", new Object[]{po.getOrdNo()});
                }

                proxyDao.update(MapperConstants.ORDER_EXCHANGE + "updateClaimExchange", po);
            }
            //주문상세 상태 변경
            proxyDao.update(MapperConstants.ORDER_REFUND + "updateClaimAllRefund", po);

            // 결제취소신청이면 알림톡 발송
            if ("31".equals(po.getClaimCd())) {
                OrderGoodsVO orderGoodsVO = new OrderGoodsVO();
                orderGoodsVO.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
                orderGoodsVO.setOrdNo(po.getOrdNo());
                orderGoodsVO.setOrdDtlSeq(po.getOrdDtlSeq());

                Map<String, String> templateCodeMap = new HashMap<>();
                //templateCodeMap.put("member","mk028");
                templateCodeMap.put("admin","mk029");
                try {
                    orderService.sendOrdAutoSms("", "10", orderGoodsVO, templateCodeMap);
                } catch (Exception e) {
                    throw new CustomException("biz.exception.ord.failUpdateOrdStatus", new Object[]{po.getOrdNo()});
                }
            }
        }
        result.setSuccess(true);
        result.setMessage(MessageUtil.getMessage("biz.common.update"));
        return result;
    }


    /**
     * 반품등록
     */
    public void returnRegist(ClaimGoodsPO po)  throws Exception{
        Map<String, Object> param = new HashMap<>();
        param.put("claimNo",po.getClaimNo());
        param.put("orderNo",po.getOrdNo());

        SimpleDateFormat dateformat = new SimpleDateFormat("yyyyMMdd");
        String orderDate = dateformat.format(new java.util.Date());

        param.put("orderDate",orderDate);

        /*
        long memNo = SessionDetailHelper.getDetails().getSession().getMemberNo();
        String receiverName = SessionDetailHelper.getDetails().getSession().getMemberNm();
        String receiverHp = SessionDetailHelper.getDetails().getSession().getMobile();
        */

        //관리자에서 처리시 판매자 정보 세팅...
        long sellerNo = 0;
        // 관리자반품처리여부를 세션에 세팅된 판매자정보로 판단...
        // 관리자 처리여부
        String sellerYn="N";
        if(SessionDetailHelper.getDetails().getSession().getSellerNo()!=null) {
            sellerNo = SessionDetailHelper.getDetails().getSession().getSellerNo();
            sellerYn="Y";
        }else{
            sellerYn="N";
        }
        
        OrderInfoVO orderVo =  proxyDao.selectOne(MapperConstants.ORDER_MANAGE + "selectOrdDtlInfo", po);

        if(orderVo.getMemberNo()!=null && !orderVo.getMemberNo().equals("")) {
            param.put("memNo", orderVo.getMemberNo());
        }else{
            param.put("memNo", null);
        }

        param.put("receiverName",orderVo.getAdrsNm());
        param.put("receiverHp",orderVo.getAdrsMobile());

        /*param.put("bigo",po.getClaimMemo());*/


//        OrderInfoVO orderInfoVo = new OrderInfoVO();
//        orderInfoVo.setOrdNo(po.getOrdNo());
//        orderInfoVo.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());

        //반품신청 리스트 조회
        List<OrderGoodsVO> goodsList = orderService.selectReturnRegistList(po);

        List<Map<String, Object>> ordDtlList = new ArrayList<>();
        for(OrderGoodsVO dtl : goodsList){
            log.info("dtl :::::::::::::::::::::::::::::::::::::::::::::: "+dtl);
            Map<String, Object> listParam = new HashMap<>();
            //다비치 상품의경우만 인터페이스 호출
            if(dtl.getSellerNo()!=null && dtl.getSellerNo().equals("1")) {
                String destType = "";
                if(dtl.getSellerNo() != null && !"".equals(dtl.getSellerNo()) && !dtl.getSellerNo().equals("1") ) {
                    destType = "3";	//셀러상품 매장픽업
                    param.put("venCode", "100000");
                }else {
                    if (dtl.getDlvrcPaymentCd().equals("04")) {
                        destType = "2";	//다비치상품 매장픽업
                    } else {
                        destType = "1";	//다비치상품 택배
                    }
                    param.put("venCode", "000000");
                }

                param.put("destType", destType);
                param.put("ordRute", destType);
                log.info("param :::::::::::::::::::::::::::::::::::::::::::::: "+param);
                listParam.put("ordDtlSeq", dtl.getOrdDtlSeq());
                listParam.put("goodsNo", dtl.getGoodsNo());
                listParam.put("itmCode", dtl.getItemNo());
                listParam.put("addOptYn", dtl.getAddOptYn());
                listParam.put("goodsNm", dtl.getGoodsNm());
                if(dtl.getAddOptNm() != null && dtl.getAddOptYn().equals("Y")) {
                    listParam.put("optNm", dtl.getAddOptNm());
                }
                String tax = "";
                if (dtl.getTaxGbCd() == null || dtl.getTaxGbCd().equals("1")) {
                    tax = "1";
                } else {
                    tax = "2";
                }
                listParam.put("tax", tax);
                listParam.put("qty", dtl.getClaimQtt());
                listParam.put("wprc", dtl.getSupplyAmt());
                listParam.put("sprc", dtl.getSaleAmt());
                log.info("listParam :::::::::::::::::::::::::::::::::::::::::::::: "+listParam);
                if("99".equals(dtl.getClaimReasonCd())) {
                	// 반품 사유가 [매장입고]인 경우, 매장입고 가능여부 Y
                	listParam.put("strIpYn", "Y");
                }
                ordDtlList.add(listParam);
            }
        }
        log.info("ordDtlList :::::::::::::::::::::::::::::::::::::::::::::: "+ordDtlList);
        if(sellerYn.equals("Y")) {
            if (ordDtlList.size() > 0 && sellerNo == 1) {
                param.put("ordDtlList", ordDtlList);
                //ifReturnReg(param); // interface_block_temp
                /*Map<String, Object> result = InterfaceUtil.send("IF_ORD_005", param);

                if ("1".equals(result.get("result"))) {
                } else {
                    throw new Exception(String.valueOf(result.get("message")));
                }*/
            }
        }else{
            if (ordDtlList.size() > 0 ) {
                param.put("ordDtlList", ordDtlList);
                //ifReturnReg(param); // interface_block_temp
                /*Map<String, Object> result = InterfaceUtil.send("IF_ORD_005", param);

                if ("1".equals(result.get("result"))) {
                } else {
                    throw new Exception(String.valueOf(result.get("message")));
                }*/
            }
        }
    }

    /**
     * 발주취소
     */
    public void orderCancel(ClaimGoodsPO po) throws Exception{
        Map<String, Object> param = new HashMap<>();
        param.put("orderNo",po.getOrdNo());
        //ifCancelOrder(param); // interface_block_temp
        /*Map<String, Object> result = InterfaceUtil.send("IF_ORD_002", param);

        if ("1".equals(result.get("result"))) {
        }else{
            throw new Exception(String.valueOf(result.get("message")));
        }*/
    }

    /**
     * 환불완료
     */
    public void refundConfirm(ClaimGoodsPO po) throws Exception{

        Map<String, Object> param = new HashMap<>();
        param.put("claimNo",po.getClaimNo());
        param.put("orderNo",po.getOrdNo());
        SimpleDateFormat dateformat = new SimpleDateFormat("yyyyMMdd");
        String payDate = dateformat.format(new java.util.Date());
        param.put("payDate",payDate);
        
        List<Map<String, Object>> ordDtlList = proxyDao.selectList(MapperConstants.ORDER_REFUND + "selectClaimDetailListForInterface", po); // 다비치 상품에 대한 반품 정보만 넘겨줌
        param.put("ordDtlList", ordDtlList);

        /*
        OrderInfoVO orderInfoVo = new OrderInfoVO();
        orderInfoVo.setOrdNo(po.getOrdNo());
        orderInfoVo.setOrdDtlSeq(po.getOrdDtlSeq());
        orderInfoVo.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());

        //환불완료건을 제외한 주문 상세 리스트
        List<OrderGoodsVO> goodsList = orderService.selectRefundConfirmList(orderInfoVo);

        int dlvrAmt = 0;
        for(OrderGoodsVO orderGoodsVo : goodsList){
            dlvrAmt += Integer.parseInt(orderGoodsVo.getRealDlvrAmt());
        }
        param.put("dlvrAmt",dlvrAmt);

        List<Map<String, Object>> ordDtlList = new ArrayList<>();

        for(OrderGoodsVO dtl : goodsList){
            Map<String, Object> listParam = new HashMap<>();
            listParam.put("ordDtlSeq",dtl.getOrdDtlSeq());
            listParam.put("goodsNo",dtl.getGoodsNo());
            listParam.put("itmCode",dtl.getItemNo());
            listParam.put("addOptYn",dtl.getAddOptYn());
            listParam.put("goodsNm",dtl.getGoodsNm());
            listParam.put("optNm",dtl.getAddOptNm());
            String tax="";
            if(dtl.getTaxGbCd().equals("1")){
                tax="1";
            }else{
                tax="2";
            }
            listParam.put("tax",tax);
            listParam.put("qty",dtl.getRemainQtt());
            listParam.put("wprc",dtl.getSupplyAmt());
            listParam.put("sprc",dtl.getSaleAmt());
            String davichPrdYn="N";
            if(dtl.getSellerNo().equals("1")){
                davichPrdYn="Y";
            }
            listParam.put("davichPrdYn",davichPrdYn);
            ordDtlList.add(listParam);
        }


        if(ordDtlList.size() >0) {
            param.put("ordDtlList", ordDtlList);

            //결제정보만 조회
            List<OrderPayVO> payResultist = orderService.selectOrderPayInfoList(orderInfoVo);

            List<Map<String, Object>> payList = new ArrayList<>();
            for (OrderPayVO payVo : payResultist) {
                Map<String, Object> listParam = new HashMap<>();
                listParam.put("payWayCd", payVo.getPaymentWayCd());
                listParam.put("payWayNm", payVo.getPaymentWayNm());
                listParam.put("payAmt", payVo.getPaymentAmt());
                payList.add(listParam);
            }
            param.put("payList", payList);

            //쿠폰사용 주문내역 조회
            List<CouponVO> cpList = orderService.selectCouponList(orderInfoVo);

            List<Map<String, Object>> couponList = new ArrayList<>();
            for (CouponVO cpVo : cpList) {
                Map<String, Object> listParam = new HashMap<>();
                listParam.put("ordDtlSeq", cpVo.getOrdDtlSeq());
                listParam.put("dcAmt", cpVo.getCpUseAmt());
                listParam.put("dcCode", cpVo.getCouponKindCd());
                listParam.put("dcName", cpVo.getCouponKindCdNm());
                couponList.add(listParam);
            }
            param.put("couponList", couponList);
        }
        */

        // 다비치 상품일 경우만 인터페이스 호출
        if (ordDtlList != null && ordDtlList.size() > 0) {
            //ifCompleteRefund(param); // interface_block_temp
	        /*Map<String, Object> result = InterfaceUtil.send("IF_ORD_011", param);
	
	        if ("1".equals(result.get("result"))) {
	        }else{
	            throw new Exception(String.valueOf(result.get("message")));
	        }*/
        }
    }

    /**
     * 교환완료
     */
    public void exchangeConfirm(ClaimGoodsPO po) throws Exception{

        OrderInfoVO orderInfoVo = new OrderInfoVO();
        orderInfoVo.setOrdNo(po.getOrdNo());
        orderInfoVo.setOrdDtlSeq(po.getOrdDtlSeq());
        orderInfoVo.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());

        OrderVO orderVo = orderService.selectOrdDtl(orderInfoVo);

        Map<String, Object> param = new HashMap<>();
        param.put("claimNo",po.getClaimNo());
        param.put("orgOrderNo",orderVo.getOrderInfoVO().getOrgOrdNo());
        param.put("orderNo",po.getOrdNo());
        SimpleDateFormat transFormat = new SimpleDateFormat("yyyyMMdd");
        String payDate = transFormat.format(po.getClaimCmpltDttm());
        param.put("payDate",payDate);

        //주문번호에 해당하는 방문예약정보조회(매장코드)
        VisitVO visitVO = orderService.selectStrCode(orderInfoVo);
        String delivStrCode ="";
        String destType="";
        if(visitVO!=null && visitVO.getStoreNo()!=null) {
            delivStrCode = visitVO.getStoreNo();
        }

        if(!delivStrCode.equals("")){
            destType ="2";
        }else{
            destType ="1";
        }

        param.put("destType",destType);
        param.put("delivStrCode",delivStrCode);
        param.put("address1",orderVo.getOrderInfoVO().getRoadnmAddr());
        param.put("address2",orderVo.getOrderInfoVO().getDtlAddr());
        param.put("zipcode",orderVo.getOrderInfoVO().getPostNo());
        param.put("receiverName",orderVo.getOrderInfoVO().getAdrsNm());
        param.put("receiverHp",orderVo.getOrderInfoVO().getAdrsMobile());
        param.put("memNo",orderVo.getOrderInfoVO().getMemberNo());
        param.put("bigo",orderVo.getOrderInfoVO().getMemoContent());

        //TODO...주문상세정보...
        List<OrderGoodsVO> goodsList = orderService.selectOrdDtlList(orderInfoVo);
        List<Map<String, Object>> ordDtlList = new ArrayList<>();

        for(OrderGoodsVO dtl : goodsList){
            Map<String, Object> listParam = new HashMap<>();
            listParam.put("orgOrdDtlSeq",dtl.getOrdDtlSeq());
            listParam.put("ordDtlSeq",dtl.getOrdDtlSeq());
            listParam.put("goodsNo",dtl.getGoodsNo());
            listParam.put("itmCode",dtl.getItemNo());
            listParam.put("addOptYn",dtl.getAddOptYn());
            listParam.put("goodsNm",dtl.getGoodsNm());
            listParam.put("optNm",dtl.getAddOptNm());
            String tax="";
            if(dtl.getTaxGbCd() == null || dtl.getTaxGbCd().equals("1")){
                tax="1";
            }else{
                tax="2";
            }
            listParam.put("tax",tax);
            listParam.put("qty",dtl.getOrdQtt());
            listParam.put("wprc",dtl.getSupplyAmt());
            listParam.put("sprc",dtl.getSaleAmt());

            ordDtlList.add(listParam);
        }

        param.put("ordDtlList",ordDtlList);

        //ifCompleteExchange(param); // interface_block_temp
        /*Map<String, Object> result = InterfaceUtil.send("IF_ORD_012", param);

        if ("1".equals(result.get("result"))) {
        }else{
            throw new Exception(String.valueOf(result.get("message")));
        }*/
    }

    /**
     * 반품 취소
     */
    public void returnCancel(ClaimGoodsPO po) throws Exception{
        Map<String, Object> param = new HashMap<>();
        param.put("claimNo",po.getClaimNo());

        //ifCancelReturn(param); // interface_block_temp
        /*Map<String, Object> result = InterfaceUtil.send("IF_ORD_010", param);

        if ("1".equals(result.get("result"))) {
        }else{
            throw new Exception(String.valueOf(result.get("message")));
        }*/
    }

    /**
     * 반품확정
     */
    public void returnConfirm(ClaimGoodsPO po) throws Exception{
        OrderInfoVO orderInfoVo = new OrderInfoVO();
        orderInfoVo.setOrdNo(po.getOrdNo());
        orderInfoVo.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());

        String refundType = "";
        if(po.getClaimCd().equals("11") || po.getClaimCd().equals("12")){
        //환불시 반품확정
            refundType ="R";
            List<OrderGoodsVO> goodsList = orderService.selectReturnConfirmList(orderInfoVo);
            List<OrderGoodsPO> stockGoodsList = new ArrayList<>();
            List<Map<String, Object>> claimList = new ArrayList<>();
            Date today = new Date();
            Map<String, Object> param = new HashMap<>();
            for(OrderGoodsVO dtl : goodsList){
                OrderGoodsPO stockGoodsPO = new OrderGoodsPO();
                stockGoodsPO.setGoodsNo(dtl.getGoodsNo());
                stockGoodsPO.setRealDlvrAmt(0);
                stockGoodsPO.setAreaAddDlvrc(0);
                stockGoodsPO.setSiteNo(orderInfoVo.getSiteNo());
                stockGoodsPO.setOrdNo(Long.parseLong(orderInfoVo.getOrdNo()));
                log.debug("-주문 vo.getOrdDtlSeq() :::::::::::::::::::::: " + dtl.getOrdDtlSeq());
                stockGoodsPO.setOrdDtlSeq(Long.parseLong(dtl.getOrdDtlSeq()));
                stockGoodsPO.setOrgDlvrAmt(dtl.getOrgDlvrAmt());
                stockGoodsPO.setDlvrQtt(dtl.getDlvrQtt());
                stockGoodsPO.setDlvrMsg(dtl.getDlvrMsg());
                stockGoodsPO.setDlvrPrcTypeCd(dtl.getDlvrPrcTypeCd());
                stockGoodsPO.setDlvrcPaymentCd(dtl.getDlvrcPaymentCd());
                stockGoodsPO.setDlvrSetCd(dtl.getDlvrSetCd());
                stockGoodsPO.setDlvrcPaymentCd(dtl.getDlvrcPaymentCd());
                stockGoodsPO.setAddOptYn(dtl.getAddOptYn());
                stockGoodsPO.setDlvrMsg(dtl.getDlvrMsg());
                stockGoodsPO.setDlvrQtt((int) dtl.getOrdQtt());
                stockGoodsPO.setRegrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
                stockGoodsPO.setRegDttm(today);
                stockGoodsPO.setSaleAmt(dtl.getSaleAmt());
                stockGoodsPO.setDcAmt(dtl.getDcAmt());
                stockGoodsPO.setGoodsDmoneyUseAmt(dtl.getGoodsDmoneyUseAmt());
                stockGoodsPO.setDlvrAmt(dtl.getDlvrAmt());
                stockGoodsPO.setGoodsSvmnAmt(dtl.getPvdSvmn());//이컬럼이 좀 햇갈리는데 결재 할때 기존에 이렇게 써서 일단은 따른다
                stockGoodsPO.setDlvrAddAmt(dtl.getDlvrAddAmt());
                log.debug("ogVO.getDlvrAddAmt() 지역 추가 배송비 ::::: " + dtl.getDlvrAddAmt());
                // 재고 정보
                log.debug("ogVO.getItemNo() 단품번호 ::::: " + dtl.getItemNo());
                log.debug("ogVO.getOrdQtt() * (-1) 수량 ::::: " + dtl.getOrdQtt() * (-1));
                log.debug("ogVO.getClaimQtt() * (-1) 수량 ::::: " + dtl.getClaimQtt() * (-1));
                stockGoodsPO.setItemNo(dtl.getItemNo());
                stockGoodsPO.setOrdQtt(dtl.getOrdQtt() * (-1));
                stockGoodsPO.setClaimQtt(dtl.getClaimQtt() * (-1));
                stockGoodsList.add(stockGoodsPO);
            }

            // 다비치 상품일 경우만 인터페이스 호출
            // 반품 완료시 포인트 돌려 받기
            if (claimList != null && claimList.size() > 0) {
                param.put("claimList",claimList);
                OfflineMemberSO oso = new OfflineMemberSO();
                oso.setCustName(orderInfoVo.getOrdrNm());
                oso.setHp(orderInfoVo.getOrdrMobile().replace("-", ""));

                List<OfflineMemberVO>  offLineMembers =  erpMemberService.getOfflineMemberInfo(oso);
                log.debug("offLineMembers : {}",offLineMembers);
                if(offLineMembers.size() != 1){
                    throw new CustomException("다비젼 회원정보 오류입니다. 관리자에게 문의 부탁드립니다.");
                }
                MemberDPointCtVO memberDPointCtVO = new MemberDPointCtVO();
                memberDPointCtVO.setSubType(2);
                memberDPointCtVO.setCdCust(offLineMembers.get(0).getCdCust());
                memberDPointCtVO.setMemberCardNo(offLineMembers.get(0).getOfflineCardNo());
                memberDPointCtVO.setMemberNo(po.getRegrNo());
                memberDPointCtVO.setStrCode(offLineMembers.get(0).getStrCode());
                memberDPointCtVO.setOrderGoodsPOS(stockGoodsList);
                memberDPointCtVO.setOrdNo(Long.parseLong(orderInfoVo.getOrdNo()));
                memberDPointCtVO.setPaymentWayCd(po.getPaymentWayCd());
                memberDPointCtVO.setOrdDtlSeqArr(po.getOrdDtlSeqArr());
                if (po.getPayReserveAmt() > 0) {
                    erpPointService.PaymentDPoint(memberDPointCtVO);//사용했던 포인트 돌려받기
                }
                //ifMallReturnConfirm(param); // interface_block_temp
	        /*Map<String, Object> result = InterfaceUtil.send("IF_ORD_006", param);

	        if ("1".equals(result.get("result"))) {
	        }else{
	            throw new Exception(String.valueOf(result.get("message")));
	        }*/
            }
        }

        if(po.getClaimCd().equals("21") || po.getClaimCd().equals("22")){
        //교환시 반품확정
            refundType ="E";
        }

        orderInfoVo.setRefundType(refundType);
        //반품완료 리스트 조회
        /*List<OrderGoodsVO> goodsList = orderService.selectReturnConfirmList(orderInfoVo);
        List<OrderGoodsPO> stockGoodsList = new ArrayList<>();
        List<Map<String, Object>> claimList = new ArrayList<>();
        Date today = new Date();
        Map<String, Object> param = new HashMap<>();
        for(OrderGoodsVO dtl : goodsList){
            OrderGoodsPO stockGoodsPO = new OrderGoodsPO();
            stockGoodsPO.setGoodsNo(dtl.getGoodsNo());
            stockGoodsPO.setRealDlvrAmt(0);
            stockGoodsPO.setAreaAddDlvrc(0);
            stockGoodsPO.setSiteNo(orderInfoVo.getSiteNo());
            stockGoodsPO.setOrdNo(Long.parseLong(orderInfoVo.getOrdNo()));
            log.debug("-주문 vo.getOrdDtlSeq() :::::::::::::::::::::: " + dtl.getOrdDtlSeq());
            stockGoodsPO.setOrdDtlSeq(Long.parseLong(dtl.getOrdDtlSeq()));
            stockGoodsPO.setOrgDlvrAmt(dtl.getOrgDlvrAmt());
            stockGoodsPO.setDlvrQtt(dtl.getDlvrQtt());
            stockGoodsPO.setDlvrMsg(dtl.getDlvrMsg());
            stockGoodsPO.setDlvrPrcTypeCd(dtl.getDlvrPrcTypeCd());
            stockGoodsPO.setDlvrcPaymentCd(dtl.getDlvrcPaymentCd());
            stockGoodsPO.setDlvrSetCd(dtl.getDlvrSetCd());
            stockGoodsPO.setDlvrcPaymentCd(dtl.getDlvrcPaymentCd());
            stockGoodsPO.setAddOptYn(dtl.getAddOptYn());
            stockGoodsPO.setDlvrMsg(dtl.getDlvrMsg());
            stockGoodsPO.setDlvrQtt((int) dtl.getOrdQtt());
            stockGoodsPO.setRegrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
            stockGoodsPO.setRegDttm(today);
            stockGoodsPO.setSaleAmt(dtl.getSaleAmt());
            stockGoodsPO.setDcAmt(dtl.getDcAmt());
            stockGoodsPO.setGoodsDmoneyUseAmt(dtl.getGoodsDmoneyUseAmt());
            stockGoodsPO.setDlvrAmt(dtl.getDlvrAmt());
            stockGoodsPO.setGoodsSvmnAmt(dtl.getPvdSvmn());//이컬럼이 좀 햇갈리는데 결재 할때 기존에 이렇게 써서 일단은 따른다
            stockGoodsPO.setDlvrAddAmt(dtl.getDlvrAddAmt());
            log.debug("ogVO.getDlvrAddAmt() 지역 추가 배송비 ::::: " + dtl.getDlvrAddAmt());
            // 재고 정보
            log.debug("ogVO.getItemNo() 단품번호 ::::: " + dtl.getItemNo());
            log.debug("ogVO.getOrdQtt() * (-1) 수량 ::::: " + dtl.getOrdQtt() * (-1));
            log.debug("ogVO.getClaimQtt() * (-1) 수량 ::::: " + dtl.getClaimQtt() * (-1));
            stockGoodsPO.setItemNo(dtl.getItemNo());
            stockGoodsPO.setOrdQtt(dtl.getOrdQtt() * (-1));
            stockGoodsPO.setClaimQtt(dtl.getClaimQtt() * (-1));
            stockGoodsList.add(stockGoodsPO);
        }
        
        // 다비치 상품일 경우만 인터페이스 호출
        // 반품 완료시 포인트 돌려 받기
        if (claimList != null && claimList.size() > 0) {
	        param.put("claimList",claimList);
            OfflineMemberSO oso = new OfflineMemberSO();
            oso.setCustName(orderInfoVo.getOrdrNm());
            oso.setHp(orderInfoVo.getOrdrMobile().replace("-", ""));

            List<OfflineMemberVO>  offLineMembers =  erpMemberService.getOfflineMemberInfo(oso);
            log.debug("offLineMembers : {}",offLineMembers);
            if(offLineMembers.size() != 1){
                throw new CustomException("다비젼 회원정보 오류입니다. 관리자에게 문의 부탁드립니다.");
            }
            MemberDPointCtVO memberDPointCtVO = new MemberDPointCtVO();
            memberDPointCtVO.setSubType(2);
            memberDPointCtVO.setCdCust(offLineMembers.get(0).getCdCust());
            memberDPointCtVO.setMemberCardNo(offLineMembers.get(0).getOfflineCardNo());
            memberDPointCtVO.setMemberNo(po.getRegrNo());
            memberDPointCtVO.setStrCode(offLineMembers.get(0).getStrCode());
            memberDPointCtVO.setOrderGoodsPOS(stockGoodsList);
            memberDPointCtVO.setOrdNo(Long.parseLong(orderInfoVo.getOrdNo()));
            memberDPointCtVO.setPaymentWayCd(po.getPaymentWayCd());
            memberDPointCtVO.setOrdDtlSeqArr(po.getOrdDtlSeqArr());
            if (po.getPayReserveAmt() > 0) {
                erpPointService.PaymentDPoint(memberDPointCtVO);//사용했던 포인트 돌려받기
            }
            //ifMallReturnConfirm(param); // interface_block_temp
	        *//*Map<String, Object> result = InterfaceUtil.send("IF_ORD_006", param);
	
	        if ("1".equals(result.get("result"))) {
	        }else{
	            throw new Exception(String.valueOf(result.get("message")));
	        }*//*
        }*/
    }

    /**
     * 현금 환불 정보 등록 확인
     */
    @Override
    @Transactional(readOnly = true)
    public Integer selectCashRefundCount(ClaimPayRefundPO po) {
        Integer result = proxyDao.selectOne(MapperConstants.ORDER_REFUND + "selectCashRefundCount", po);
        return result;
    }

    /**
     * 환불 신청 프로세스
     * STEP. 1 현재 주문상태 검증, 금액검증
     * STEP. 2 결제 정보 확인
     * STEP. 3-1 환불, 취소정보 상태 상세 업데이트
     * STEP. 3-2 환불, 취소정보 상태 상세 업데이트
     * STEP. 3-7 환불정보 등록 or 수정
     */
    @Override
    public ResultModel<OrderPayPO> updateRefund(OrderPO po) throws Exception {
        HttpServletRequest request = HttpUtil.getHttpServletRequest();
        ResultModel<OrderPayPO> result = new ResultModel<>();

        log.info("/** STEP. 1 현재 주문상태 검증, 금액검증 *******************************************************/");
        // 프론트/관리자 분기 처리
        log.info("po :::::::::::::: " + po);
        log.info("OrdNo ::::::::::::::::: " + po.getOrdNo());
        log.info("pgType ::::::::::::::::: " + po.getPgType());
        log.info("pgAmt ::::::::::::::::: " + po.getPgAmt());
        log.info("refundAmt ::::::::::::::::: " + po.getRefundAmt());
        log.info("payReserveAmt ::::::::::::::::: " + po.getPayReserveAmt());
        log.info("bankCd ::::::::::::::::: " + po.getBankCd());
        log.info("actNo ::::::::::::::::: " + po.getActNo());
        log.info("holderNm ::::::::::::::::: " + po.getHolderNm());
        log.info("partCancelYn ::::::::::::::::: " + po.getPartCancelYn());
        log.info("siteNo :::::::::::::: " + po.getSiteNo());
        log.info("restAmt :::::::::::::: " + po.getRestAmt());
        log.info("orgAmt :::::::::::::: " + po.getOrgReserveAmt());
        log.info("cancelType :::::::::::::: " + po.getCancelType());
        log.info("ClaimMemo :::::::::::::: " + po.getClaimMemo());

        String strOrdNo = Long.toString(po.getOrdNo());
        long longSiteNo = SessionDetailHelper.getDetails().getSession().getSiteNo();
        String strOrdStatusCd = "";

        long longMemberNo = 0;
        String tempMemberNo = String.valueOf(SessionDetailHelper.getDetails().getSession().getMemberNo());
        if (!"null".equals(tempMemberNo)) {
            longMemberNo = Integer.parseInt(tempMemberNo);
        }
        if (po.getClaimCd().equals("11")) {
            // 신청
            strOrdStatusCd = OrdStatusConstants.RETURN_APPLY;
        } else if (po.getClaimCd().equals("23")){
            strOrdStatusCd = OrdStatusConstants.PAY_CANEL_REQUEST;
        } else {
            throw new CustomException("biz.exception.ord.failUpdateOrdStatus", new Object[] { strOrdNo });
        }

        log.info("/** STEP. 2 결제 정보 확인 *********************************************************************/");
        OrderInfoVO infoVo = new OrderInfoVO();
        infoVo.setOrdNo(strOrdNo);
        infoVo.setSiteNo(po.getSiteNo());
        infoVo.setPgType("Y"); // 마켓포인트 제외 결제수단 확인
        OrderPayVO payVo = proxyDao.selectOne(MapperConstants.ORDER_MANAGE + "selectOrdDtlPayInfo", infoVo);
        payVo.setPgType("N");

        boolean standBydeposit = false;
        // 무통장,가상계좌라면
        log.info("payVo.getPaymentWayCd() 결제 수단 코드 ::::::: " + payVo.getPaymentWayCd());
        if (CoreConstants.PAYMENT_WAY_CD_NOPB.equals(payVo.getPaymentWayCd()) || CoreConstants.PAYMENT_WAY_CD_VIRT_ACT_TRANS.equals(payVo.getPaymentWayCd())) {
            standBydeposit = true;
        }

        try {
            String ordDtlSeqArr[] = po.getOrdDtlSeqArr();
            String claimQttArr[] = po.getClaimQttArr();
            String claimNoArr[] = po.getClaimNoArr();
            int idx = 0;
            HashMap<String, String> map = new HashMap<String, String>();

            ClaimGoodsPO cpo = new ClaimGoodsPO();
            cpo.setOrdNo(strOrdNo);
            log.info("cpo.getOrdNo() ::::::::::: " + cpo.getOrdNo());

            cpo.setClaimReasonCd(po.getClaimReasonCd()); // 10:제품파손, 20:제품불일치, 30:사이즈안맞음, 90:기타
            cpo.setReturnCd(po.getReturnCd()); //
            cpo.setClaimCd(po.getClaimCd());
            cpo.setRegrNo(longMemberNo);
            // 에디터 내용의 업로드 이미지 정보 변경
            cpo.setClaimDtlReason(StringUtil.replaceAll(po.getClaimDtlReason(), (String) request.getAttribute(RequestAttributeConstants.IMAGE_DOMAIN),""));
            cpo.setClaimDtlReason(StringUtil.replaceAll(po.getClaimDtlReason(), UploadConstants.IMAGE_TEMP_EDITOR_URL,UploadConstants.IMAGE_EDITOR_URL));
            cpo.setSiteNo(longSiteNo);
            cpo.setClaimMemo(po.getClaimMemo());
            cpo.setOrdDtlStatusCd(strOrdStatusCd); // 주문 취소시 적용
            cpo.setPaymentWayCd(payVo.getPaymentWayCd());
            cpo.setPayReserveAmt(po.getPayReserveAmt());

            //관리자 반품/환불 신청시...
            if(claimQttArr!=null && claimQttArr.length>0){
                String claimNo = String.valueOf(bizService.getSequence("CLAIM_NO", Long.valueOf(1)));
                cpo.setClaimNo(claimNo);
                // 임시 경로의 파일을 서비스 경로로 복사, 업로드 했다 에디터에서 삭제한 파일 삭제
                editorService.setEditorImageToService(po, claimNo, "CLAIM_INFO");
                // 파일 구분세팅 및 파일명 세팅
                FileUtil.setEditorImageList(po, "CLAIM_INFO", po.getAttachImages());
            }
            ResultModel<ClaimGoodsVO> claimresult = new ResultModel<ClaimGoodsVO>();
            for (String ordDtlSeq : ordDtlSeqArr) {
                cpo.setOrdDtlStatusCd(strOrdStatusCd);

                log.info("idx ::::::::::::::::::::::::::::::: " + idx);
                if (!"".equals(ordDtlSeq)) {
                    log.info("/** STEP. 3-1 환불, 취소정보 상태 상세 업데이트 *******************************/");
                    cpo.setOrdDtlSeq(ordDtlSeq);

                    //관리자 반품/환불신청시..
                    if(claimQttArr!=null && claimQttArr.length>0){
                        cpo.setClaimQtt(Integer.parseInt(claimQttArr[idx]));
                    }

                    //관리자 반품/환불 처리시...
                    if(claimNoArr!=null && claimNoArr.length>0){
                        cpo.setClaimNo(claimNoArr[idx]);
                        // 임시 경로의 파일을 서비스 경로로 복사, 업로드 했다 에디터에서 삭제한 파일 삭제
                        editorService.setEditorImageToService(po, claimNoArr[idx], "CLAIM_INFO");
                        // 파일 구분세팅 및 파일명 세팅
                        FileUtil.setEditorImageList(po, "CLAIM_INFO", po.getAttachImages());
                    }

                    /** 클레임 정보 저장 */
                    claimresult = updateClaimRefund(cpo);

                    log.info("claimresult ::::::::::::::::::::::::::::::: "+claimresult);
                    log.info("claimQttArr ::::::::::::::::::::::::::::::: "+claimQttArr);
                    log.info("claimQttArr ::::::::::::::::::::::::::::::: "+claimQttArr.length);
                    //관리자 반품/환불신청시..
                    if(claimQttArr!=null && claimQttArr.length>0){
                        // 파일 정보 디비 저장
                        for (CmnAtchFilePO p : po.getAttachImages()) {
                            // 파일이 임시 파일일 경우만 등록 처리(2016.09.26)
                            if (p.getTemp()) {
                                p.setRefNo(cpo.getClaimNo()); // 참조의 번호
                                editorService.insertCmnAtchFile(p);
                            }
                        }
                    }

                    //관리자 반품/환불 처리시...
                    if(claimNoArr!=null && claimNoArr.length>0){
                        // 파일 정보 디비 저장
                        for (CmnAtchFilePO p : po.getAttachImages()) {
                            // 파일이 임시 파일일 경우만 등록 처리(2016.09.26)
                            if (p.getTemp()) {
                                p.setRefNo(claimNoArr[idx]); // 참조의 번호
                                editorService.insertCmnAtchFile(p);
                            }
                        }
                    }
                }
                idx++;
            }

            // 임시 경로의 이미지 삭제
            FileUtil.deleteEditorTempImageList(po.getAttachImages());

            // 무통장, 가상계좌
            if (standBydeposit) {
                log.info("/** 환불정보 등록 or 수정 */");
                ClaimPayRefundPO cprp = new ClaimPayRefundPO();
                // cprp.setCashRefundNo("현금환불번호");
                log.info("결제번호 : " + payVo.getPaymentNo());
                log.info("결제유형코드 : " + po.getRefundTypeCd());
                log.info("환불상태코드 : " + po.getRefundStatusCd());
                log.info("환불메모 : " + po.getRefundMemo());
                log.info("은행코드 : " + po.getBankCd());
                log.info("계좌번호 : " + po.getActNo());
                log.info("예금주 : " + po.getHolderNm());
                cprp.setPaymentNo(payVo.getPaymentNo());
                // 환불
                cprp.setRefundTypeCd("");
                cprp.setRefundStatusCd("");

                cprp.setScdAmt(String.valueOf(po.getPgAmt()));
                cprp.setRefundMemo(po.getClaimDtlReason());
                cprp.setBankCd(po.getBankCd());
                cprp.setActNo(po.getActNo());
                cprp.setHolderNm(po.getHolderNm());
                cprp.setOrdNo(strOrdNo);
                cprp.setRegrNo(longMemberNo);

                insertPaymerCashRefund(cprp);
                log.info("환불금액 등록 완료 ");
            }
            result.setMessage(MessageUtil.getMessage("biz.common.update"));

            /** 반품등록 interface 호출*/
            try {
                log.info("po ::::::::::::::::::::::::::::::: "+po);
                //결제취소시엔 인터페이스 안테움
                if(claimresult.isSuccess() && !po.getClaimCd().equals("23")) {
                    //관리자 반품/환불신청시..
                    if(claimQttArr!=null && claimQttArr.length>0) {
                        this.returnRegist(cpo);
                    }

                    //관리자 반품/환불 처리시...
                    if(claimNoArr!=null && claimNoArr.length>0){
                        this.returnConfirm(cpo);
                    }
                }
            } catch (Exception e) {
                throw new CustomException("biz.exception.common.error");
            }


        } catch (DuplicateKeyException e) {
            throw new CustomException("biz.exception.common.error", new Object[] { "" }, e);
        }

        return result;
    }

	@Override
	public ClaimVO selectRefundChk(ClaimPO po) throws Exception {
		ClaimVO result = new ClaimVO();
		
		result = proxyDao.selectOne(MapperConstants.ORDER_REFUND + "selectRefundChk",po);
		
		return result;
	}

	@Override
	public ResultModel<ClaimVO> updateRefundChk(ClaimPO po) throws Exception {
		ResultModel<ClaimVO> result = new ResultModel<>();
		
		proxyDao.update(MapperConstants.ORDER_REFUND + "updateRefundChk", po);
		
		return result;
	}
	
	@Override
	public ClaimGoodsVO selectClaimReason(ClaimPO po) throws Exception {

		ClaimGoodsVO claimGoodsVo = proxyDao.selectOne(MapperConstants.ORDER_REFUND + "selectClaimDetail",po);
		return claimGoodsVo;
		
	}

    @Override
    public ResultModel<OrderVO> selectRefundRequestList(OrderInfoVO vo) {
        ResultModel<OrderVO> result = new ResultModel<>();
        OrderVO rvo = new OrderVO();

        List<OrderGoodsVO> list = proxyDao.selectList(MapperConstants.ORDER_REFUND + "selectRefundRequestList", vo);
        rvo.setOrderGoodsVO(list);

        List<OrderGoodsVO> ordHistList = orderService.selectOrdDtlHistList(vo);
        rvo.setOrdHistVOList(ordHistList);

        result.setData(rvo);
        return result;
    }

    public void ifReturnReg(Map<String, Object> param) throws Exception {

        String ifId = Constants.IFID.MALL_RETURN_REG;

        log.info("MALL_RETURN_REG :::::::::::::::::::::::::::::::::::::");
        ObjectMapper objectMapper = new ObjectMapper();
        OrderRegReqDTO orderRegReqDTO = objectMapper.convertValue(param, OrderRegReqDTO.class);

        try {
            // 쇼핑몰 처리 부분
            String claimNo="";
            if(orderRegReqDTO.getClaimNo()!=null && !orderRegReqDTO.getClaimNo().equals("")){
                claimNo = orderRegReqDTO.getClaimNo();
            }

            // ERP 상품코드로 변경
            for(OrderRegReqDTO.OrderDetailDTO dtlDto : orderRegReqDTO.getOrdDtlList()) {
                if("Y".equals(dtlDto.getAddOptYn())) {
                    // 추가 옵션 상품인 경우 상품코드 설정 안함.
                    continue;
                }
                String erpItmCode = mappingService.getErpItemCode(dtlDto.getItmCode());
                log.info("erpItmCode :::::::::::::::::::::::::::::::::::::::::::::: "+erpItmCode);
                if(erpItmCode == null) {
                    // 매핑되지 않은 상품입니다.
                    throw new CustomException("ifapi.exception.product.notmapped");
                }
                dtlDto.setErpItmCode(erpItmCode);

            }

            // 회원번호를 ERP회원코드로 변경 (없으면 없는대로 설정)
            if(orderRegReqDTO.getMemNo() != null) {
                orderRegReqDTO.setCdCust(mappingService.getErpMemberNo(orderRegReqDTO.getMemNo()));
            }

            // 쇼핑몰 원발주 번호를 ERP 발주 번호로 변경
            /*OrderMapDTO orgMapDto = mappingService.getErpOrderNo(orderRegReqDTO.getOrderNo());*/
            //반품등록시에는 claim no 강제 세팅...
            orderRegReqDTO.setClaimNo(null);
            OrderMapDTO orgMapDto = mappingService.getErpOrderNo(orderRegReqDTO);
            if(orgMapDto == null) {
                // 매핑되지 않은 주문번호입니다.
                throw new CustomException("ifapi.exception.order.orderno.notmapped");
            }
            //클레임 번호 다시 세팅...
            orderRegReqDTO.setClaimNo(claimNo);
            orderRegReqDTO.setOrgOrdDate(orgMapDto.getErpOrdDate());
            orderRegReqDTO.setOrgStrCode(orgMapDto.getErpStrCode());
            orderRegReqDTO.setOrgOrdSlip(orgMapDto.getErpOrdSlip());
            log.info("orderRegReqDTO :::::::::::::::::::::::::::::::::::::::::::::: "+orderRegReqDTO);
            // 주문 상세 데이터에 ERP 원 주문 번호 설정(결제 정보 등록시 원본 데이터를 참조하기 위해)
            for(OrderRegReqDTO.OrderDetailDTO dtlDto : orderRegReqDTO.getOrdDtlList()) {
                OrderMapDTO mapDto = mappingService.getErpOrderDtlNo(orderRegReqDTO.getOrderNo(), dtlDto.getOrdDtlSeq());
                log.info("mapDto :::::::::::::::::::::::::::::::::::::::::::::: "+mapDto);
                if(mapDto == null) {
                    // 매핑되지 않은 주문상세번호입니다.
                    throw new CustomException("ifapi.exception.order.orderdtlseq.notmapped");
                }
                dtlDto.setOrgOrdDate(mapDto.getErpOrdDate());
                dtlDto.setOrgStrCode(mapDto.getErpStrCode());
                dtlDto.setOrgOrdSlip(mapDto.getErpOrdSlip());
                dtlDto.setOrgOrdSeq(mapDto.getErpOrderDtlNo().toString());
                dtlDto.setOrgOrdAddNo(mapDto.getErpOrderAddNo().toString());
            }

            // ERP쪽으로 데이터 전송
            //String resParam = sendUtil.send(param, ifId);
            // ResponseDTO 생성
            OrderRegResDTO resDto = new OrderRegResDTO();
            resDto.setResult(Constants.RESULT.SUCCESS);
            resDto.setMessage("");

            // 기본 값 설정
            //  발주구분 : 반품발주
            orderRegReqDTO.setGubun(Constants.ORDER_GUBUN.RETURN);
            // 배송루트 (빤품은 그냥 고정)
            String ordRute = Constants.ORD_RUTE.DIRECT_RECV;
            orderRegReqDTO.setOrdRute(ordRute);
            log.info("orderRegReqDTO :::::::::::::::::::::::::::::::::::::::::::::: "+orderRegReqDTO);
            // 데이터 저장
            distService.insertMallReturnReq(orderRegReqDTO);

            String resParam = JSONObject.fromObject(resDto).toString();

            // 처리 로그 등록
            logService.writeInterfaceLog(ifId, orderRegReqDTO, resParam, OrderRegResDTO.class);

        } catch (CustomIfException ce) {
            ce.setReqParam(orderRegReqDTO);
            ce.setIfId(ifId);
            throw ce;
        }/* catch (Exception e) {
            e.printStackTrace();
            throw new CustomIfException(e, orderRegReqDTO, ifId);
        }*/
    }

    public void ifCancelOrder(Map<String, Object> param) throws Exception {

        String ifId = Constants.IFID.ORDER_CANCEL;

        ObjectMapper objectMapper = new ObjectMapper();
        OrderCancelReqDTO orderCancelReqDTO = objectMapper.convertValue(param, OrderCancelReqDTO.class);

        try {

            // 쇼핑몰 처리부분

            // 주문번호를 ERP주문번호로 변경
            OrderMapDTO mapDto = mappingService.getErpOrderNo(orderCancelReqDTO.getOrderNo());

            if(mapDto == null) {
                // 매핑되지 않은 주문번호입니다.
                throw new CustomException("ifapi.exception.order.orderno.notmapped");
            }

            // ERP주문 Key를 파라미터에 담기
            orderCancelReqDTO.setOrdDate(mapDto.getErpOrdDate());
            orderCancelReqDTO.setStrCode(mapDto.getErpStrCode());
            orderCancelReqDTO.setOrdSlip(mapDto.getErpOrdSlip());

            // ERP쪽으로 데이터 전송
            //String resParam = sendUtil.send(param, ifId);
            // ResponseDTO 생성
           /* OrderCancelResDTO resDto = new OrderCancelResDTO();
            resDto.setResult(Constants.RESULT.SUCCESS);
            resDto.setMessage("");

            // 데이터 처리
            distService.cancelOrder(orderCancelReqDTO);

            String resParam = JSONObject.fromObject(resDto).toString();

            // 처리 로그 등록
            logService.writeInterfaceLog(ifId, param, resParam, OrderCancelResDTO.class);*/

        } catch (CustomIfException ce) {
            ce.setReqParam(orderCancelReqDTO);
            ce.setIfId(ifId);
            throw ce;
        } catch (Exception e) {
            e.printStackTrace();
            throw new CustomIfException(e, orderCancelReqDTO, ifId);
        }
    }

    public void ifCompleteRefund(Map<String, Object> param) throws Exception {
        String ifId = Constants.IFID.REFUND_CMPLT;

        ObjectMapper objectMapper = new ObjectMapper();
        RefundCmpltReqDTO refundCmpltReqDTO = objectMapper.convertValue(param, RefundCmpltReqDTO.class);

        try {
            OrderMapDTO mapDto = mappingService.getErpClaimNo(refundCmpltReqDTO.getClaimNo(), refundCmpltReqDTO.getOrderNo(), null);
            refundCmpltReqDTO.setOrdDate(mapDto.getErpOrdDate());
            refundCmpltReqDTO.setStrCode(mapDto.getErpStrCode());
            refundCmpltReqDTO.setOrdSlip(mapDto.getErpOrdSlip());

            // 쇼핑몰 반품 상세 번호를 ERP반품 상세 번호로 변경
            for(RefundCmpltReqDTO.RefundItemDTO dtl : refundCmpltReqDTO.getOrdDtlList()) {
                OrderMapDTO dtlMapDto = mappingService.getErpClaimNo(refundCmpltReqDTO.getClaimNo(), refundCmpltReqDTO.getOrderNo(), dtl.getOrderDtlSeq());
                dtl.setOrdSeq(dtlMapDto.getErpOrderDtlNo());
                dtl.setOrdAddNo(dtlMapDto.getErpOrderAddNo());
            }
            // ERP 처리 부분
            // Response DTO 생성
            /*RefundCmpltResDTO resDto = new RefundCmpltResDTO();
            resDto.setResult(Constants.RESULT.SUCCESS);
            resDto.setMessage("");

            // 데이터 저장
            distService.completeRefund(refundCmpltReqDTO);
            String resParam = JSONObject.fromObject(resDto).toString();

            // 처리 로그 등록
            logService.writeInterfaceLog(ifId, refundCmpltReqDTO, resParam, RefundCmpltResDTO.class);*/

        } catch (CustomIfException ce) {
            ce.setReqParam(refundCmpltReqDTO);
            ce.setIfId(ifId);
            throw ce;
        } catch (Exception e) {
            e.printStackTrace();
            throw new CustomIfException(e, refundCmpltReqDTO, ifId);
        }
    }

    public void ifMallReturnConfirm(Map<String, Object> param) throws Exception {
        String ifId = Constants.IFID.MALL_RETURN_CONFIRM;

        ObjectMapper objectMapper = new ObjectMapper();
        MallReturnConfirmReqDTO mallReturnConfirmReqDTO = objectMapper.convertValue(param, MallReturnConfirmReqDTO.class);

        try {
            // 쇼핑몰 처리 부분
            // 쇼핑몰 반품번호로  ERP주문번호 조회
            for(MallReturnConfirmReqDTO.ClaimInfoDTO dto : mallReturnConfirmReqDTO.getClaimList()) {
                OrderMapDTO mapDto = mappingService.getErpClaimNo(dto.getClaimNo(), dto.getOrderNo(), dto.getOrdDtlSeq());

                if(mapDto == null) {
                    // 매핑되지 않은 주문번호입니다.
                    throw new CustomException("ifapi.exception.order.orderno.notmapped");
                }

                // ERP주문 Key를 파라미터에 담기
                dto.setOrdDate(mapDto.getErpOrdDate());
                dto.setStrCode(mapDto.getErpStrCode());
                dto.setOrdSlip(mapDto.getErpOrdSlip());
                dto.setOrdSeq(mapDto.getErpOrderDtlNo());
                dto.setOrdAddNo(mapDto.getErpOrderAddNo());
            }


            // ERP쪽으로 데이터 전송
            //String resParam = sendUtil.send(param, ifId);
            // ERP 처리부분

            // ResponseDTO 생성
            /*MallReturnConfirmResDTO resDto = new MallReturnConfirmResDTO();
            resDto.setResult(Constants.RESULT.SUCCESS);
            resDto.setMessage("");

            // 반품완료 상태로 수정
            distService.updateErpReturnComfirm(mallReturnConfirmReqDTO);
            String resParam = JSONObject.fromObject(resDto).toString();
            // 처리 로그 등록
            logService.writeInterfaceLog(ifId, mallReturnConfirmReqDTO, resParam, MallReturnConfirmResDTO.class);*/

        } catch (CustomIfException ce) {
            ce.setReqParam(mallReturnConfirmReqDTO);
            ce.setIfId(ifId);
            throw ce;
        } catch (Exception e) {
            e.printStackTrace();
            throw new CustomIfException(e, mallReturnConfirmReqDTO, ifId);
        }
    }

    public void ifCancelReturn(Map<String, Object> param) throws Exception {
        String ifId = Constants.IFID.RETURN_CANCEL;

        ObjectMapper objectMapper = new ObjectMapper();
        OrderCancelReqDTO orderCancelReqDTO = objectMapper.convertValue(param, OrderCancelReqDTO.class);

        try {
            // 쇼핑몰 처리 부분
            // 쇼핑몰 반품 번호를 다비젼 반품 번호로 변경
            OrderMapDTO mapDto = mappingService.getErpClaimNo(orderCancelReqDTO.getClaimNo(), null, null);
            if(mapDto == null) {
                // 매핑되지 않은 주문번호입니다.
                throw new CustomException("ifapi.exception.order.orderno.notmapped");
            }
            orderCancelReqDTO.setOrdDate(mapDto.getErpOrdDate());
            orderCancelReqDTO.setStrCode(mapDto.getErpStrCode());
            orderCancelReqDTO.setOrdSlip(mapDto.getErpOrdSlip());

            // ERP 쪽으로 데이터 전송
            //String resParam = sendUtil.send(param, ifId);

            // Response DTO 생성
            /*OrderCancelResDTO resDto = new OrderCancelResDTO();
            resDto.setResult(Constants.RESULT.SUCCESS);
            resDto.setMessage("");

            // 반품 취소 처리
            distService.cancelOrder(orderCancelReqDTO);
            String resParam = JSONObject.fromObject(resDto).toString();
            // 처리 로그 등록
            logService.writeInterfaceLog(ifId, orderCancelReqDTO, resParam, OrderCancelResDTO.class);*/

        } catch (CustomIfException ce) {
            ce.setReqParam(orderCancelReqDTO);
            ce.setIfId(ifId);
            throw ce;
        } catch (Exception e) {
            e.printStackTrace();
            throw new CustomIfException(e, orderCancelReqDTO, ifId);
        }
    }

    public void ifCompleteExchange(Map<String, Object> param) throws Exception {
        String ifId = Constants.IFID.EXCHANGE_CMPLT;

        ObjectMapper objectMapper = new ObjectMapper();
        OrderRegReqDTO orderRegReqDTO = objectMapper.convertValue(param, OrderRegReqDTO.class);

        try {
            // 쇼핑몰 처리 부분
            // 쇼핑몰 반품 번호를 ERP반품 번호로 변경
            OrderMapDTO mapDto = mappingService.getErpClaimNo(orderRegReqDTO.getClaimNo(), orderRegReqDTO.getOrgOrderNo(), null);
            if(mapDto == null) {
                // 매핑되지 않은 주문번호입니다.
                throw new CustomException("ifapi.exception.order.orderno.notmapped");
            }
            orderRegReqDTO.setOrderDate(mapDto.getErpOrdDate());
            orderRegReqDTO.setStrCode(mapDto.getErpStrCode());
            orderRegReqDTO.setOrdSlip(mapDto.getErpOrdSlip());

            // 쇼핑몰 반품상세번호로  ERP주문상세번호 조회
            for(OrderRegReqDTO.OrderDetailDTO dto : orderRegReqDTO.getOrdDtlList()) {
                OrderMapDTO dtlMapDto = mappingService.getErpClaimNo(orderRegReqDTO.getClaimNo(), orderRegReqDTO.getOrderNo(), dto.getOrgOrdDtlSeq());

                if(dtlMapDto == null) {
                    // 매핑되지 않은 주문번호입니다.
                    throw new CustomException("ifapi.exception.order.orderno.notmapped");
                }

                // ERP주문 Key를 파라미터에 담기
                dto.setOrdDate(dtlMapDto.getErpOrdDate());
                dto.setStrCode(dtlMapDto.getErpStrCode());
                dto.setOrdSlip(dtlMapDto.getErpOrdSlip());
                dto.setErpOrdDtlSeq(dtlMapDto.getErpOrderDtlNo());
                dto.setErpOrdAddNo(dtlMapDto.getErpOrderAddNo());
            }

            // ERP 상품코드로 변경
            for(OrderRegReqDTO.OrderDetailDTO dtlDto : orderRegReqDTO.getOrdDtlList()) {
                if("Y".equals(dtlDto.getAddOptYn())) {
                    // 추가 옵션 상품인 경우 상품코드 설정 안함.
                    continue;
                }
                String erpItmCode = mappingService.getErpItemCode(dtlDto.getItmCode());
                if(erpItmCode == null) {
                    // 매핑되지 않은 상품입니다.
                    throw new CustomException("ifapi.exception.product.notmapped");
                }
                dtlDto.setErpItmCode(erpItmCode);
            }

            // 회원번호를 ERP회원코드로 변경 (없으면 없는대로 설정)
            if(orderRegReqDTO.getMemNo() != null) {
                orderRegReqDTO.setCdCust(mappingService.getErpMemberNo(orderRegReqDTO.getMemNo()));
            }

            // ERP쪽으로 데이터 전송
            //String resParam = sendUtil.send(param, ifId);
            // ERP 처리 부분
            // Response DTO 생성
            /*OrderRegResDTO resDto = new OrderRegResDTO();
            resDto.setResult(Constants.RESULT.SUCCESS);
            resDto.setMessage("");

            // 데이터 처리
            distService.completeChange(orderRegReqDTO);
            String resParam = JSONObject.fromObject(resDto).toString();
            // 처리 로그 등록
            logService.writeInterfaceLog(ifId, orderRegReqDTO, resParam, OrderRegResDTO.class);*/

        } catch (CustomIfException ce) {
            ce.setReqParam(orderRegReqDTO);
            ce.setIfId(ifId);
            throw ce;
        } catch (Exception e) {
            e.printStackTrace();
            throw new CustomIfException(e, orderRegReqDTO, ifId);
        }
    }
}
