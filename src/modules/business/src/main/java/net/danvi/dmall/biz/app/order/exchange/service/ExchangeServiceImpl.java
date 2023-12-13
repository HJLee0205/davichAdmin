package net.danvi.dmall.biz.app.order.exchange.service;

import dmall.framework.common.constants.RequestAttributeConstants;
import dmall.framework.common.util.HttpUtil;
import lombok.extern.slf4j.Slf4j;
import net.danvi.dmall.biz.app.goods.model.GoodsDetailSO;
import net.danvi.dmall.biz.app.goods.model.GoodsDetailVO;
import net.danvi.dmall.biz.app.goods.model.GoodsItemVO;
import net.danvi.dmall.biz.app.goods.service.GoodsManageService;
import net.danvi.dmall.biz.app.order.manage.model.*;
import net.danvi.dmall.biz.app.order.manage.service.OrderService;
import net.danvi.dmall.biz.app.order.refund.service.RefundService;
import net.danvi.dmall.biz.common.service.BizService;
import net.danvi.dmall.biz.common.service.EditorService;
import net.danvi.dmall.biz.system.security.SessionDetailHelper;
import org.springframework.dao.DuplicateKeyException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import dmall.framework.common.BaseService;
import dmall.framework.common.constants.MapperConstants;
import dmall.framework.common.constants.UploadConstants;
import dmall.framework.common.exception.CustomException;
import dmall.framework.common.model.ResultListModel;
import dmall.framework.common.model.ResultModel;
import dmall.framework.common.util.FileUtil;
import dmall.framework.common.util.MessageUtil;
import dmall.framework.common.util.StringUtil;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Slf4j
@Service("exchangeService")
@Transactional(rollbackFor = Exception.class)
public class ExchangeServiceImpl extends BaseService implements ExchangeService {

    @Resource(name = "orderService")
    private OrderService orderService;

    @Resource(name = "bizService")
    private BizService bizService;

    @Resource(name = "refundService")
    private RefundService refundService;
    
    @Resource(name = "editorService")
    private EditorService editorService;

    @Resource(name = "goodsManageService")
    private GoodsManageService goodsManageService;

    /**
     * 반품/교환 목록
     */
    @Override
    public ResultListModel<ClaimGoodsVO> selectExchangeListPaging(ClaimSO so) {
        if (so.getSidx().length() == 0) {
            so.setSidx("REG_DTTM");
            so.setSord("DESC");
        }

        return proxyDao.selectListPage(MapperConstants.ORDER_EXCHANGE + "selectExchangeListPaging", so);

    }

    /**
     * 엑셀 다운로드용 목록 조회
     */
    public List<ClaimGoodsVO> selectExchangeListExcel(ClaimSO so) throws CustomException {
        so.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());

        return proxyDao.selectList(MapperConstants.ORDER_EXCHANGE + "selectExchangeListPaging", so);

    }

    /**
     * 
     * <pre>
     * 작성일 : 2016. 6. 29.
     * 작성자 : kdy
     * 설명   : 선택된 주문번호, 주문 상세 번호의 교환 정보 목록
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 29. kdy - 최초생성
     * </pre>
     *
     * @param so
     * @return
     * @throws CustomException
     */
    @Override
    public ResultListModel<ClaimGoodsVO> selectOrdDtlExchange(ClaimSO so) throws CustomException {
        List<ClaimGoodsVO> resultList = new ArrayList<ClaimGoodsVO>();
        List<GoodsDetailVO> goodsDetailList = new ArrayList<GoodsDetailVO>();

        String[] ordNoArr = so.getOrdNoArr();
        String[] ordDtlSeqArr = so.getOrdDtlSeqArr();
        String[] claimQttArr= so.getClaimQttArr();
        log.info("selectOrdDtlExchange ::::::::::::::::::::::::::::::::::::: so = "+so);
        if (ordNoArr != null) {
            for (int i = 0; i < ordNoArr.length; i++) {
                if (!"".equals(ordNoArr[i])) {
                    so.setOrdNo(ordNoArr[i]);
                    so.setOrdDtlSeq(ordDtlSeqArr[i]);
                    so.setClaimQtt(Integer.parseInt(claimQttArr[i]));
                    ClaimGoodsVO vo = proxyDao.selectOne(MapperConstants.ORDER_EXCHANGE + "selectOrdDtlExchange", so);
                    log.info("selectOrdDtlExchange ::::::::::::::::::::::::::::::::::::: vo = "+vo);

                    if(vo != null ) {
                        if(vo.getGoodsNo()!=null) {
                            // 01.상품기본정보 조회
                            GoodsDetailSO goodsDetailSo = new GoodsDetailSO();
                            goodsDetailSo.setGoodsNo(vo.getGoodsNo());
                            ResultModel<GoodsDetailVO> goodsInfo = goodsManageService.selectGoodsInfo(goodsDetailSo);
                            if (goodsInfo.getData().getGoodsItemList() != null) {
                                List<GoodsItemVO> itemList = goodsInfo.getData().getGoodsItemList();
                                vo.setGoodsItemList(itemList);
                            }
                        }
                        resultList.add(vo);
                    }

                }
            }
        }

        ResultListModel<ClaimGoodsVO> result = new ResultListModel<ClaimGoodsVO>();
        result.setResultList(resultList);
        if (resultList == null || resultList.size() == 0) {
            result.setSuccess(false);
            result.setMessage(MessageUtil.getMessage("biz.exception.common.nodata"));
        }

        return result;
    }

    /**
     * 
     * <pre>
     * 작성일 : 2016. 7. 5.
     * 작성자 : kdy
     * 설명   : 교환 팝업 페이지의 상품 목록 출록 
     * 
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 7. 5. kdy - 최초생성
     * </pre>
     *
     * @param vo
     * @return
     * @throws CustomException
     */
    @Override
    public ResultModel<OrderVO> selectOrdDtlForExchange(OrderInfoVO vo) throws CustomException {
        ResultModel<OrderVO> result = new ResultModel<OrderVO>();
        // 처리 로그 정보
        OrderVO rtnVO = new OrderVO();
        List<OrderGoodsVO> ordHistVOList = orderService.selectOrdDtlHistList(vo);
        List<OrderGoodsVO> orderGoodsVO = orderService.selectOrdDtlList(vo);
        rtnVO.setOrdHistVOList(ordHistVOList);
        rtnVO.setOrderGoodsVO(orderGoodsVO);
        result.setData(rtnVO);
        return result;
    }

    /**
     * 교환 정보 처리
     */
    @Override
    public ResultModel<ClaimGoodsVO> processClaimExchange(ClaimGoodsPO po) throws Exception {
        HttpServletRequest request = HttpUtil.getHttpServletRequest();
        ResultModel<ClaimGoodsVO> result = new ResultModel<>();
        try {
            String ordDtlSeqArr[] = po.getOrdDtlSeqArr();
            int idx = 0;
            String ordNoBuf = "", newOrdNo = "";

            HashMap<String, String> map = new HashMap<String, String>();
            String claimNo = String.valueOf(bizService.getSequence("CLAIM_NO", Long.valueOf(1)));
            log.info("claimNo :::::::::::::::::::::::::::::::::: "+claimNo);
            // 임시 경로의 파일을 서비스 경로로 복사, 업로드 했다 에디터에서 삭제한 파일 삭제
            editorService.setEditorImageToService(po, claimNo, "CLAIM_INFO");
            // 에디터 내용의 업로드 이미지 정보 변경
            po.setClaimDtlReason(StringUtil.replaceAll(po.getClaimDtlReason(), (String) request.getAttribute(RequestAttributeConstants.IMAGE_DOMAIN),""));
            po.setClaimDtlReason(StringUtil.replaceAll(po.getClaimDtlReason(), UploadConstants.IMAGE_TEMP_EDITOR_URL,UploadConstants.IMAGE_EDITOR_URL));
            // 파일 구분세팅 및 파일명 세팅
            FileUtil.setEditorImageList(po, "CLAIM_INFO", po.getAttachImages());
            po.setOrdNo(po.getOrdNo());
            log.info("po :::::::::::::::::::::::::::::::::: "+po);
            for (String ordDtlSeq : ordDtlSeqArr) {
                if (ordDtlSeq != null && !"".equals(ordDtlSeq)) {
                    //관리자 교환완료처리시 필요함.
                    if(po.getClaimNoArr()!=null && po.getClaimNoArr().length>0) {
                        po.setClaimNo(po.getClaimNoArr()[idx]);
                    }else{
                        po.setClaimNo(claimNo);
                    }
                    po.setOrdDtlSeq(ordDtlSeq);

                    //관리자 교환처리시..
                    if(po.getClaimNoArr()!=null && po.getClaimNoArr().length>0) {
                        po.setClaimReasonCd(po.getClaimReasonCdArr()[idx]);
                    }else{
                        //교환신청시
                        po.setClaimReasonCd(po.getClaimReasonCdArr()[idx]);
                    }

                    //관리자 교환처리시..
                    if(po.getClaimNoArr()!=null && po.getClaimNoArr().length>0) {
                        po.setReturnCd(po.getClaimReturnCdArr()[0]);
                    }else{
                        //교환신청시
                        po.setReturnCd(po.getClaimReturnCdArr()[idx]);
                    }

                    //관리자 교환처리시..
                    if(po.getClaimNoArr()!=null && po.getClaimNoArr().length>0) {
                        po.setClaimCd(po.getClaimExchangeCdArr()[0]);
                    }else{
                        //교환신청시
                        po.setClaimCd(po.getClaimExchangeCdArr()[idx]);
                    }

                    //관리자 교환처리시..
                    if(po.getClaimNoArr()!=null && po.getClaimNoArr().length>0) {
                        if(po.getOrdDtlItemNoArr().length >0) {
                            po.setItemNo(po.getOrdDtlItemNoArr()[idx]);
                        }
                    }else{

                    }

                    po.setClaimQtt(Integer.parseInt(po.getClaimQttArr()[idx]));

                    result = updateClaimExchange(po);

                    if (!"0".equals(po.getOrdDtlSeq())) {
                        try {
                            // 교환완료일 경우 재주문 정보 등록
                            if ("22".equals(po.getClaimCd())) {
                                map.put("ordNo", po.getOrdNo());
                                map.put("ordDtlSeq", po.getOrdDtlSeq());
                                map.put("regrNo", po.getRegrNo() + "");
                                map.put("goodsNo", po.getGoodsNo() + "");
                                map.put("itemNo", po.getItemNo() + "");
                                map.put("reOrdQtt", po.getClaimQtt() + "");

                                if (!ordNoBuf.equals(po.getOrdNo())) {
                                    newOrdNo = orderService.createOrdNo(0) + "";
                                    map.put("newOrdNo", newOrdNo);
                                    // 주문 기본
                                    proxyDao.insert(MapperConstants.ORDER_EXCHANGE + "insertReOrderInfo", map);
                                }
                                // 주문 상세
                                proxyDao.insert(MapperConstants.ORDER_EXCHANGE + "insertReOrderDtl", map);

                                if (!ordNoBuf.equals(po.getOrdNo())) {
                                    // 주문 배송지
                                    proxyDao.insert(MapperConstants.ORDER_EXCHANGE + "insertReOrdDelivery", map);

                                }
                                // 주문 배송
                                proxyDao.insert(MapperConstants.ORDER_EXCHANGE + "insertReOrdDlvr", map);
                            }
                        } catch (Exception e) {
                            throw new CustomException("biz.exception.common.error", new Object[] { "" }, e);
                        }
                        ordNoBuf = po.getOrdNo();
                    }
                }
                idx++;
            }


            /** 반품등록 interface 호출*/
            try {
                if(result.isSuccess()) {

                    //관리자 교환처리시..
                    if(po.getClaimNoArr()!=null) {
                        refundService.returnConfirm(po);
                    }else{
                        //교환신청시
                        if(po.getOrdNo()!=null && !po.getOrdNo().equals("")) {
                            refundService.returnRegist(po);
                        }
                    }


                }
            } catch (Exception e) {
                e.printStackTrace();
                throw new CustomException("biz.exception.common.error");
            }

        } catch (DuplicateKeyException e) {
            throw new CustomException("biz.exception.common.error", new Object[] { "" }, e);
        }
        return result;
    }

    /*
     * @Override
     * 
     * @Transactional(propagation = Propagation.REQUIRES_NEW)
     * public ResultModel<ClaimGoodsVO> insertClaimExchange(ClaimGoodsPO po) throws CustomException {
     * ResultModel<ClaimGoodsVO> result = new ResultModel<>();
     * ClaimGoodsPO insPo = po;
     * try {
     * insPo.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
     * int claimNo = proxyDao.selectOne(MapperConstants.ORDER_EXCHANGE + "selectClaimNo");
     * insPo.setClaimNo(claimNo + "");
     * proxyDao.insert(MapperConstants.ORDER_EXCHANGE + "insertClaimExchange", insPo);
     * insPo.setClaimTypeCd("02"); // 반품 정보 먼저 넣고
     * proxyDao.insert(MapperConstants.ORDER_EXCHANGE + "insertClaimDtlExchange", insPo);
     * insPo.setClaimTypeCd("03"); // 교환 정보 넣기
     * insPo.setClaimStatusCd(insPo.getClaimStatusCd2());
     * proxyDao.insert(MapperConstants.ORDER_EXCHANGE + "insertClaimDtlExchange", insPo);
     * result.setMessage(MessageUtil.getMessage("biz.common.insert"));
     * } catch (DuplicateKeyException e) {
     * throw new CustomException("biz.exception.common.exist", new Object[] { "" }, e);
     * }
     * return result;
     * }
     */

    /**
     * 교환 정보 수정
     */
    @Override
    public ResultModel<ClaimGoodsVO> updateClaimExchange(ClaimGoodsPO po) throws CustomException {
        ResultModel<ClaimGoodsVO> result = new ResultModel<>();

        //주문수량 조회
        int ordQtt =proxyDao.selectOne(MapperConstants.ORDER_REFUND + "selectTotalOrdQtt", po);
        po.setOrdQtt(String.valueOf(ordQtt));

        if ("13".equals(po.getReturnCd())) { // 요청 철회
            po.setClaimCd("");
            po.setOrdDtlStatusCd("50"); // 배송완료
        }

        //이미 신청된 클레임 수량을 조회
        int preClaimQtt =proxyDao.selectOne(MapperConstants.ORDER_REFUND + "selectRefundClaimQtt", po);
        int claimQtt = 0;


        //클레임테이블 분리로인한 SQL 변경
        int resultCnt =0;

        //반품신청(11) /교환신청(21)
        if(po.getReturnCd().equals("11") && po.getClaimCd().equals("21")){
            claimQtt = preClaimQtt+po.getClaimQtt();
            //클레임 신청수량과 주문수량을 비교하여 부분클레임 여부 판단
            if(Integer.parseInt(po.getOrdQtt()) > claimQtt ){
                //부분교환신청
                po.setOrdDtlStatusCd("62");
            }else if(Integer.parseInt(po.getOrdQtt()) == claimQtt){
                //교환신청
                po.setOrdDtlStatusCd("60");
            }else{
                /*throw new CustomException("biz.exception.ord.failUpdateOrdStatus", new Object[]{po.getOrdNo()});*/
            }
            resultCnt= proxyDao.update(MapperConstants.ORDER_REFUND + "insertClaimRefund", po);
        }else{

            if(po.getReturnCd().equals("12") && po.getClaimCd().equals("21")){
                //반품완료(12) / 교환완료(22)
                claimQtt = preClaimQtt;
                //클레임 신청수량과 주문수량을 비교하여 부분클레임 여부 판단
                if(Integer.parseInt(po.getOrdQtt()) > claimQtt ){
                    //부분교환신청
                    po.setOrdDtlStatusCd("62");
                }else if(Integer.parseInt(po.getOrdQtt()) == claimQtt){
                    //교환신청
                    po.setOrdDtlStatusCd("60");
                }else{
                    /*throw new CustomException("biz.exception.ord.failUpdateOrdStatus", new Object[]{po.getOrdNo()});*/
                }
            }else if(po.getReturnCd().equals("12") && po.getClaimCd().equals("22")){
                //반품완료(12) / 교환완료(22)
                claimQtt = preClaimQtt;
                //클레임 신청수량과 주문수량을 비교하여 부분클레임 여부 판단
                if(Integer.parseInt(po.getOrdQtt()) > claimQtt ){
                    //부분교환완료
                    po.setOrdDtlStatusCd("67");
                }else if(Integer.parseInt(po.getOrdQtt()) == claimQtt){
                    //교환완료
                    po.setOrdDtlStatusCd("66");
                }else{
                    /* throw new CustomException("biz.exception.ord.failUpdateOrdStatus", new Object[]{po.getOrdNo()});*/
                }
            }
            resultCnt= proxyDao.update(MapperConstants.ORDER_EXCHANGE + "updateClaimExchange", po);
        }

        //클레임 처리후 주문상세 상태 변경
        proxyDao.update(MapperConstants.ORDER_REFUND + "updateClaimAllRefund", po);

        if(resultCnt>0) {
            OrderGoodsVO goodsVO = new OrderGoodsVO();
            goodsVO.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
            goodsVO.setOrdNo(po.getOrdNo());
            goodsVO.setOrdDtlSeq(po.getOrdDtlSeq());
            goodsVO.setRegrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());

            try {
                /** 구매 확정 처리 **/
                orderService.updateOrdStatusCdConfirm(goodsVO);

                if ("11".equals(po.getReturnCd())) {// 반품신청
                    Map<String, String> templateCodeMap = new HashMap<>();
                    templateCodeMap.put("member","mk034");
                    templateCodeMap.put("admin","mk035");
                    templateCodeMap.put("seller","mk035");
                    orderService.sendOrdAutoSms("", "12", goodsVO, templateCodeMap);
                    orderService.sendOrdAutoEmail("12", goodsVO);
                }
            } catch (Exception e) {
                log.debug("{}", e.getMessage());
            }
            result.setSuccess(true);
            /*result.setMessage(MessageUtil.getMessage("biz.common.update"));*/
        }
        return result;
    }

}
