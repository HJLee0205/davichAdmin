package net.danvi.dmall.biz.app.order.delivery.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import net.danvi.dmall.biz.app.order.delivery.model.DeliveryPO;
import net.danvi.dmall.biz.app.order.delivery.model.DeliveryVO;
import net.danvi.dmall.biz.app.order.manage.model.OrderGoodsVO;
import net.danvi.dmall.biz.app.order.manage.model.OrderInfoVO;
import net.danvi.dmall.biz.app.setup.payment.model.CommPaymentConfigVO;
import net.danvi.dmall.biz.app.setup.siteinfo.model.SiteSO;
import net.danvi.dmall.biz.app.setup.siteinfo.model.SiteVO;
import net.danvi.dmall.biz.batch.order.epost.model.EpostVO;
import net.danvi.dmall.biz.common.service.CacheService;
import net.danvi.dmall.biz.system.remote.parcel.ParcelAdapterService;
import net.danvi.dmall.biz.system.remote.payment.PaymentAdapterService;
import net.danvi.dmall.biz.system.security.SessionDetailHelper;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.servlet.ModelAndView;

import lombok.extern.slf4j.Slf4j;
import net.danvi.dmall.biz.app.order.constants.OrdStatusConstants;
import net.danvi.dmall.biz.app.order.delivery.model.DeliverySO;
import net.danvi.dmall.biz.app.order.manage.service.OrderService;
import net.danvi.dmall.biz.app.order.payment.model.OrderPayVO;
import net.danvi.dmall.biz.app.setup.payment.model.CommPaymentConfigSO;
import net.danvi.dmall.core.model.payment.PaymentModel;
import dmall.framework.common.BaseService;
import dmall.framework.common.constants.CommonConstants;
import dmall.framework.common.constants.MapperConstants;
import dmall.framework.common.exception.CustomException;
import dmall.framework.common.model.ResultListModel;
import dmall.framework.common.model.ResultModel;
import dmall.framework.common.util.DateUtil;
import dmall.framework.common.util.MessageUtil;
import dmall.framework.common.util.StringUtil;

/**
 * Created by dong on 2016-05-02.
 */
@Service("deliveryService")
@Transactional(rollbackFor = Exception.class)
@Slf4j
public class DeliveryServiceImpl extends BaseService implements DeliveryService {

    @Resource(name = "orderService")
    private OrderService orderService;

    @Resource(name = "parcelAdapterService")
    private ParcelAdapterService parcelAdapterService;

    @Resource(name = "paymentAdapterService")
    private PaymentAdapterService paymentAdapterService;

    @Value("#{datasource['main.database.type']}")
    private String dbType;

    @Resource(name = "cacheService")
    private CacheService cacheService;

    /**
     * <pre>
     * 작성일 : 2016. 6. 15.
     * 작성자 : dong
     * 설명   : 검색조건에 맞는 출고 목록을 조회하여 리턴
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 15. dong - 최초생성
     * </pre>
     *
     * @return
     */
    public ResultListModel<DeliveryVO> selectDeliveryListPaging(DeliverySO so) {
        // so.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
        if (so.getSidx().length() == 0) {
            so.setSidx("A.REG_DTTM");
            so.setSord("DESC");
        }

        ResultListModel<DeliveryVO> resultListModel = proxyDao.selectListPage(MapperConstants.ORDER_DELIVERY + "selectDeliveryListPaging", so);
        return resultListModel;
    }

    /**
     * 엑셀 다운로드용 목록 조회
     */
    public List<DeliveryVO> selectDeliveryListExcel(DeliverySO so) throws CustomException {
        so.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());

        List<DeliveryVO> resultList = proxyDao.selectList(MapperConstants.ORDER_DELIVERY + "selectDeliveryListPaging",
                so);
        return resultList;

    }

    /**
     * 배송지 정보 수정
     */
    public boolean updateOrdDtlDeliveryAddr(DeliveryPO po) {
        int rCnt = 0;
        rCnt = proxyDao.update(MapperConstants.ORDER_DELIVERY + "updateOrdDtlDeliveryAddr", po);
        return (rCnt > 0) ? true : false;
    }

    /**
     * <pre>
     * 작성일 : 2016. 6. 20.
     * 작성자 : dong
     * 설명   : 송장번호 일괄등록을 위한 목록을 조회한다
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 20. dong - 최초생성
     * </pre>
     *
     * @return
     */
    public ResultListModel<DeliveryVO> downInvoiceAddList(DeliverySO so) {
        ResultListModel<DeliveryVO> resultListModel = new ResultListModel<>();
        // so.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
        List<DeliveryVO> list = proxyDao.selectList(MapperConstants.ORDER_DELIVERY + "selectDownInvoiceAddList", so);

        resultListModel.setResultList(list);
        return resultListModel;
    }

    /**
     * <pre>
     * 작성일 : 2016. 6. 21.
     * 작성자 : dong
     * 설명   : 업로드된 엑셀파일의 내용으로 송장일괄등록 목록을 조회한다
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 21. dong - 최초생성
     * </pre>
     *
     * @return
     */
    public List<DeliveryVO> upInvoiceAddList(List<Map<String, Object>> plist) {
        List<DeliveryVO> list = new ArrayList<DeliveryVO>();
        for (Map<String, Object> map : plist) {
            DeliveryVO vo = new DeliveryVO();
            vo.setOrdNo((String) map.get("주문번호"));
            vo.setOrdDtlSeq((String) map.get("주문상세번호"));
            vo.setRlsInvoiceNo((String) map.get("송장번호"));
            vo.setRlsCourierCd((String) map.get("배송업체(업체코드)"));
            DeliveryVO resultVo = proxyDao.selectOne(MapperConstants.ORDER_DELIVERY + "selectUpInvoiceAddList", vo);
            if (resultVo != null) list.add(resultVo);

        }
        return list;
    }

    /**
     * <pre>
     * 작성일 : 2016. 6. 22.
     * 작성자 : dong
     * 설명   : 송장일괄목록을 등록한다
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 6. 22. dong - 최초생성
     * </pre>
     *
     * @return
     * @throws Exception
     */
    public int insertInvoiceAddList(List<DeliveryPO> listPO) throws CustomException {
        int rCnt = 0;
        try {
            for (DeliveryPO po : listPO) {
                Map<String, Object> reqMap = new HashMap<String, Object>();
                ModelAndView mav = new ModelAndView();
                String method = "dlv"; // 배송등록
                if ("98".equals(po.getRlsCourierCd())) {
                    method = "receive"; // 직접배송
                }
                ResultModel<PaymentModel<?>> resultModel = doEscrowAction(po, reqMap, mav, method);
                if (resultModel.isSuccess()) {
                    // 송장 정보 등록
                    rCnt += proxyDao.update(MapperConstants.ORDER_DELIVERY + "updateInvoice", po);
                    // 주문 상태 변경 - 배송중으로
                    OrderGoodsVO gVO = new OrderGoodsVO();
                    gVO.setOrdNo(po.getOrdNo());
                    gVO.setOrdDtlSeq(po.getOrdDtlSeq());
                    gVO.setOrdStatusCd(OrdStatusConstants.DELIV_DOING);
                    gVO.setGoodsNo(po.getGoodsNo());
                    String curOrdStatusCd = po.getOrdStatusCd();
                    orderService.updateOrdStatus(gVO, curOrdStatusCd);
                }
            }
        } catch (Exception e) {
            log.debug("{}", e.getMessage());
        }
        return rCnt;

    }

    /**
     * 주문 번호별 배송 정보 조회
     */
    public List<DeliveryVO> selectOrdDtlDelivery(DeliveryVO vo) {
        return proxyDao.selectList(MapperConstants.ORDER_DELIVERY + "selectOrdDtlDelivery", vo);
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 31.
     * 작성자 : dong
     * 설명   : 배송 처리를 위한 목록
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 31. dong - 최초생성
     * </pre>
     *
     * @return List<DeliveryVO>
     */
    public List<DeliveryVO> selectOrdDtlInvoice(DeliveryVO vo) {
        return proxyDao.selectList(MapperConstants.ORDER_DELIVERY + "selectOrdDtlInvoice", vo);
    }

    /**
     * <pre>
     * 작성일 : 2016. 5. 31.
     * 작성자 : dong
     * 설명   : 배송 처리 (등록 및 수정)
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 5. 31. dong - 최초생성
     * </pre>
     *
     * @return List<DeliveryVO>
     */

    // @Transactional(transactionManager = "JtaTransactionManager") /* 이기종 DB가 확정되어 XA 처리를 하기 전까지 임시로 막음 */
    @Override
    public boolean updateOrdDtlInvoiceNew(DeliveryPO po) throws CustomException{
        boolean returnflag = true;
        try {
            // ## 배송 데이터 입력
            // proxyDao.update(proxyDao.getXA1(), MapperConstants.ORDER_DELIVERY + "updateOrdDtlInvoiceNew", po);
            Map<String, Object> reqMap = new HashMap<String, Object>();
            ModelAndView mav = new ModelAndView();
            String method = "dlv"; // 배송등록
            if ("98".equals(po.getRlsCourierCd())) {
                method = "receive"; // 직접배송
            }
            ResultModel<PaymentModel<?>> resultModel = doEscrowAction(po, reqMap, mav, method);
            if (resultModel.isSuccess()) {

                proxyDao.update(MapperConstants.ORDER_DELIVERY + "updateOrdDtlInvoiceNew", po);

                // ## 주문 상태값 변경
                OrderGoodsVO vo = new OrderGoodsVO();
                vo.setOrdNo(po.getOrdNo());
                vo.setOrdDtlSeq(po.getOrdDtlSeq());
                vo.setGoodsNo(po.getGoodsNo());
                vo.setOrdStatusCd(OrdStatusConstants.DELIV_DOING); // 배송 중으로 상태 변경
                vo.setSmsSendYn(po.getSmsSendYn());
                String curOrdStatusCd = po.getOrdStatusCd();

                orderService.updateOrdStatus(vo, curOrdStatusCd);
                // 기존 proxyDao를 이용한 update시 lock 에러 발생하여 아래와 같이 insert, update 구문을 모두 XA로 변경하기 위해 메소드를 풀어서 처리함
                /*
                 * ResultModel<OrderInfoVO> resultOrd = new ResultModel<>();
                 * OrderGoodsVO curVo = proxyDao.selectOne(proxyDao.getXA1(),
                 * MapperConstants.ORDER_MANAGE + "selectCurOrdStatus", vo);
                 * if (curVo.getOrdStatusCd().equals("")) {
                 * returnflag = false;
                 * throw new CustomException("biz.exception.ord.failUpdateOrdStatus", new Object[] { vo.getOrdNo() });
                 * }
                 * // 변경 하려는 시점의 주문상태가 현재 상태와 같은 경우면 상태 변경
                 * if (curVo.getOrdStatusCd().equals(curOrdStatusCd)) {
                 * int cnt = proxyDao.update(proxyDao.getXA1(), MapperConstants.ORDER_MANAGE + "updateOrdStatus", vo);
                 * 	if(CommonConstants.DATABASE_TYPE_ORACLE.equals(dbType) && cnt > 0){
                 * 		proxyDao.update(MapperConstants.ORDER_MANAGE + "updateOrdStatusDtl", vo);
                 * 	}
                 * if (cnt > 0) {
                 * // 주문 테이블의 주문 상태 : 부분 배송중, 부분 배송 완료를 배송중 배송 완료로 변경
                 * if (OrdStatusConstants.DELIV_DOING.equals(vo.getOrdStatusCd())
                 * || OrdStatusConstants.DELIV_DONE.equals(vo.getOrdStatusCd())) {
                 * int inCnt = proxyDao.update(proxyDao.getXA1(),
                 * MapperConstants.ORDER_MANAGE + "updateOrdStatusDone", vo);
                 * if (inCnt > 0) {
                 * resultOrd.setMessage(MessageUtil.getMessage("biz.common.update"));
                 * }
                 * }
                 * String args[] = { "1" };
                 * resultOrd.setMessage(MessageUtil.getMessage("biz.result.ord.updateOrdStatus", args));
                 * } else {// 주문번호[{0}]의 상태를 변경할 수 없습니다.
                 * returnflag = false;
                 * throw new CustomException("biz.exception.ord.failUpdateOrdStatus", new Object[] { vo.getOrdNo() });
                 * }
                 * } else { // 주문번호[{0}]의 주문상태를 다시 확인하세요
                 * returnflag = false;
                 * throw new CustomException("biz.exception.ord.invalidOrdStatus", new Object[] { vo.getOrdNo() });
                 * }
                 */

                /*
                 * if (!po.getRlsCourierCd().equals("98") && !po.getRlsCourierCd().equals("99")) { // 직접 배송, 방문 수령이 아니면
                 * // ## 배송요청 인테페이스 호출
                 * ResultModel<ParcelModel<?>> resultInf = new ResultModel<>();
                 * ParcelCommonService psc = parcelAdapterService.getParcelService(po.getRlsCourierCd());
                 * ParcelModel parcelModel = parcelAdapterService.getChildPO(po.getRlsCourierCd()).newInstance();
                 * parcelModel.setOrdNo(po.getOrdNo());
                 * parcelModel.setOrdDtlSeq(po.getOrdDtlSeq());
                 * parcelModel.setCourierCd(po.getRlsCourierCd());
                 * parcelModel.setInvoiceNo(po.getRlsInvoiceNo());
                 * parcelModel.setGoodsNo(po.getGoodsNo());
                 * resultInf = psc.deliverySend(parcelModel);// 배송요청 메소스 호출
                 * if (!resultInf.isSuccess()) {
                 * returnflag = false;
                 * // <entry key="core.parcel.deliverysend.fail">배송요청 인터페이스 처리가 실패하였습니다. - 택배사코드{0}, 주문번호{1}, 송장번호{2}
                 * // </entry>
                 * throw new CustomException("core.exception.common.error",
                 * new Object[] { po.getRlsCourierCd(), po.getOrdNo(), po.getRlsInvoiceNo() });
                 * }
                 * }
                 */
            } else {
                returnflag = false;
            }
        } catch (CustomException e){
            throw e;
        } catch (Exception e) {
            log.debug("{}", e.getMessage());
            e.printStackTrace();
            returnflag = false;
        }

        return returnflag;
    }

    /**
     * 송장번호 수정
     */
    public boolean updateOrdDtlInvoice(DeliveryPO po) {
        int rCnt = 0;
        rCnt = proxyDao.update(MapperConstants.ORDER_DELIVERY + "updateOrdDtlInvoice", po);
        return (rCnt > 0) ? true : false;
    }

    /**
     *
     * <pre>
     * 작성일 : 2016. 7. 7.
     * 작성자 : kdy
     * 설명   : 택배 업체별 송장 번호 유효성 체크
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 7. 7. kdy - 최초생성
     * </pre>
     *
     * @param rlsCourierCd
     * @param rlsInvoiceNo
     * @param goodsflowUseYn
     * @return
     */
    public ResultModel checkRlsInvoiceNo(String rlsCourierCd, String rlsInvoiceNo, String goodsflowUseYn) {
        ResultModel result = new ResultModel();
        try {
            boolean isRightCourierCd = false; // 업체에서 이용하는 택배사 코드인지

            DeliveryVO vo = new DeliveryVO();
            vo.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
            List<DeliveryVO> deliveryVoList = selectSiteCourierList();

            for (DeliveryVO dVo : deliveryVoList) {
                if (rlsCourierCd.equals(dVo.getRlsCourierCd())) {
                    isRightCourierCd = true;
                    break;
                }
            }
            if (rlsCourierCd.equals("98")) // 직접배송
                isRightCourierCd = true;

            if (!isRightCourierCd) {
                result.setSuccess(false);
                result.setMessage(MessageUtil.getMessage("biz.exception.ord.notValidCourierCd"));
                return result;
            }

            if ("korex".equals(rlsCourierCd)) { // 대한통운
                if (rlsInvoiceNo.length() == 10 || rlsInvoiceNo.length() == 12) {
                    result.setSuccess(true);
                    return result;
                }
                result.setSuccess(false);
            }
            if ("08".equals(rlsCourierCd)) { // 아주택배
                if (rlsInvoiceNo.length() == 10) {
                    result.setSuccess(true);
                    return result;
                }
                result.setSuccess(false);
            }
            if ("daesin".equals(rlsCourierCd)) { // 대신택배
                if (rlsInvoiceNo.length() == 13) {
                    result.setSuccess(true);
                    return result;
                }
                result.setSuccess(false);
            }
            if ("05".equals(rlsCourierCd)) { // CJGLS
                if (rlsInvoiceNo.length() == 10) {
                    // 마지막 숫자는 체크번호(마지막숫자를 제외한 숫자를 7로 나눈 나머지)
                    if ((Long.parseLong(rlsInvoiceNo.substring(0, 9))) % 7 == Long
                            .parseLong(rlsInvoiceNo.substring(9, 10))) {
                        result.setSuccess(true);
                        return result;
                    }
                } else if (rlsInvoiceNo.length() == 11) {
                    // 또는 4자리부터 10자리까지/7로 나누어 끝자리 (11번째) 체크 디지트 구성
                    if ((Long.parseLong(rlsInvoiceNo.substring(3, 10))) % 7 == Long
                            .parseLong(rlsInvoiceNo.substring(10, 11))) {
                        result.setSuccess(true);
                        return result;
                        // 또는 11자리이고 앞 한자리가 9로 시작하는 일련번호
                    } else if (rlsInvoiceNo.substring(0, 1).equals("9")) {
                        result.setSuccess(true);
                        return result;
                    }
                } else if (rlsInvoiceNo.length() == 12) {
                    // 또는 3자리~11번째까지 7로 나누어 끝자리(12번째) 체크번호 구성(앞2자리는 유지)
                    if ((Long.parseLong(rlsInvoiceNo.substring(2, 11))) % 7 == Long
                            .parseLong(rlsInvoiceNo.substring(11, 12))) {
                        result.setSuccess(true);
                        return result;
                    }
                }
                result.setSuccess(false);
            }
            if ("06".equals(rlsCourierCd)) { // CJHTH
                if (rlsInvoiceNo.length() == 11) {
                    // 마지막숫자는 체크번호(마지막숫자와 앞3자리를 제외한 숫자를 7로 나눈 나머지)
                    if ((Long.parseLong(rlsInvoiceNo.substring(3, 10))) % 7 == Long
                            .parseLong(rlsInvoiceNo.substring(10, 11))) {
                        result.setSuccess(true);
                        return result;
                    }
                } else if (rlsInvoiceNo.length() == 12) {
                    // 또는 3자리~11번째까지 7로 나누어 끝자리(12번째) 체크번호 구성(앞2자리는 유지)
                    if ((Long.parseLong(rlsInvoiceNo.substring(2, 11))) % 7 == Long
                            .parseLong(rlsInvoiceNo.substring(11, 12))) {
                        result.setSuccess(true);
                        return result;
                    }
                }
                result.setSuccess(false);
            }
            if ("sagawa".equals(rlsCourierCd)) { // 사가와익스프레스
                if (rlsInvoiceNo.length() == 10) {
                    // 마지막 숫자는 체크번호(마지막숫자를 제외한 숫자를 7로 나눈 나머지)
                    if ((Long.parseLong(rlsInvoiceNo.substring(0, 9))) % 7 == Long
                            .parseLong(rlsInvoiceNo.substring(9, 10))) {
                        result.setSuccess(true);
                        return result;
                    }
                } else if (rlsInvoiceNo.length() == 12) {
                    // 또는 3자리~11번째까지 7로 나누어 끝자리(12번째) 체크번호 구성(앞2자리는 유지)
                    if ((Long.parseLong(rlsInvoiceNo.substring(2, 11))) % 7 == Long
                            .parseLong(rlsInvoiceNo.substring(11, 12))) {
                        result.setSuccess(true);
                        return result;
                    }
                }
                result.setSuccess(false);
            }
            if ("10".equals(rlsCourierCd)) { // 옐로우캡
                if (rlsInvoiceNo.length() == 11) {
                    // 마지막숫자는 체크번호(마지막숫자를 제외한 숫자를 7로 나눈 나머지)
                    if ((Long.parseLong(rlsInvoiceNo.substring(0, 10))) % 7 == Long
                            .parseLong(rlsInvoiceNo.substring(10, 11))) {
                        result.setSuccess(true);
                        return result;
                    }
                }
                result.setSuccess(false);
            }
            if ("13".equals(rlsCourierCd)) { // 로젠택배
                if (rlsInvoiceNo.length() == 11) {
                    // 마지막 숫자는 체크번호(마지막숫자를 제외한 숫자를 7로 나눈 나머지)
                    if ((Long.parseLong(rlsInvoiceNo.substring(0, 10))) % 7 == Long.parseLong(rlsInvoiceNo.substring(10, 11))) {
                        result.setSuccess(true);
                        return result;
                    }
                }
                result.setSuccess(false);
            }
            if ("09".equals(rlsCourierCd)) { // 동부택배
                if (rlsInvoiceNo.length() == 12) {
                    // 마지막 숫자는 체크번호(마지막숫자를 제외한 숫자를 7로 나눈 나머지)
                    if ((Long.parseLong(rlsInvoiceNo.substring(0, 11))) % 7 == Long
                            .parseLong(rlsInvoiceNo.substring(11, 12))) {
                        result.setSuccess(true);
                        return result;
                    }
                }
                result.setSuccess(false);
            }
            if ("16".equals(rlsCourierCd)) { // 우체국택배 6104447043674
                if (rlsInvoiceNo.length() == 13) {
                    // 마지막 숫자는 체크번호(마지막숫자를 제외한 숫자를 7로 나눈 나머지)
                    String firstChar = rlsInvoiceNo.substring(0, 1);
                    if ("6".equals(firstChar) || "7".equals(firstChar) || "8".equals(firstChar)) {
                        result.setSuccess(true);
                        return result;
                    }
                }
                result.setSuccess(false);
            }
            if ("registpost".equals(rlsCourierCd)) { // 우편등기
                if (rlsInvoiceNo.length() == 13) {
                    // 마지막 숫자는 체크번호(마지막숫자를 제외한 숫자를 7로 나눈 나머지)
                    String firstChar = rlsInvoiceNo.substring(0, 1);
                    if ("1".equals(firstChar) || "2".equals(firstChar) || "3".equals(firstChar)) {
                        result.setSuccess(true);
                        return result;
                    }
                }
                result.setSuccess(false);
            }
            if ("02".equals(rlsCourierCd)) { // 한진택배
                if (rlsInvoiceNo.length() == 10) {
                    // 마지막 숫자는 체크번호(마지막숫자를 제외한 숫자를 7로 나눈 나머지)
                    if ((Long.parseLong(rlsInvoiceNo.substring(0, 9))) % 7 == Long
                            .parseLong(rlsInvoiceNo.substring(9, 10))) {
                        result.setSuccess(true);
                        return result;
                    }
                }
                if (rlsInvoiceNo.length() == 12) {
                    // 마지막 숫자는 체크번호(마지막숫자를 제외한 숫자를 7로 나눈 나머지)
                    if ((Long.parseLong(rlsInvoiceNo.substring(0, 11))) % 7 == Long
                            .parseLong(rlsInvoiceNo.substring(11, 12))) {
                        result.setSuccess(true);
                        return result;
                    }
                }
                result.setSuccess(false);
            }
            if ("01".equals(rlsCourierCd)) { // 현대택배
                if (rlsInvoiceNo.length() == 10) {
                    // 마지막 숫자는 체크번호(마지막숫자를 제외한 숫자를 7로 나눈 나머지)
                    if ((Long.parseLong(rlsInvoiceNo.substring(0, 9))) % 7 == Long
                            .parseLong(rlsInvoiceNo.substring(9, 10))) {
                        result.setSuccess(true);
                        return result;
                    }
                }
                if (rlsInvoiceNo.length() == 12) {
                    // 마지막 숫자는 체크번호(마지막숫자를 제외한 숫자를 7로 나눈 나머지)
                    if ((Long.parseLong(rlsInvoiceNo.substring(0, 11))) % 7 == Long
                            .parseLong(rlsInvoiceNo.substring(11, 12))) {
                        result.setSuccess(true);
                        return result;
                    }
                }
                result.setSuccess(false);
            }
            if ("12".equals(rlsCourierCd)) { // KGB택배
                if (rlsInvoiceNo.length() == 10) {
                    // 마지막 숫자는 체크번호(마지막숫자를 제외한 숫자를 7로 나눈 나머지)
                    // 또는 처음 시작 운송장번호가 9로 시작하는 일련번호
                    if ((Long.parseLong(rlsInvoiceNo.substring(0, 9))) % 7 == Long
                            .parseLong(rlsInvoiceNo.substring(9, 10)) || "9".equals(rlsInvoiceNo.substring(0, 1))) {
                        result.setSuccess(true);
                        return result;
                    }
                }
                result.setSuccess(false);
            }
            if ("03".equals(rlsCourierCd)) { // 하나로택배
                if (rlsInvoiceNo.length() == 10) {
                    // 마지막 숫자는 체크번호(마지막숫자를 제외한 숫자를 7로 나눈 나머지)
                    if ((Long.parseLong(rlsInvoiceNo.substring(0, 9))) % 7 == Long
                            .parseLong(rlsInvoiceNo.substring(9, 10))) {
                        result.setSuccess(true);
                        return result;
                    }
                }
                result.setSuccess(false);
            }
            if ("sedex".equals(rlsCourierCd)) { // SEDEX
                if (rlsInvoiceNo.length() == 10) {
                    // 마지막 숫자는 체크번호(마지막숫자를 제외한 숫자를 7로 나눈 나머지)
                    if ((Long.parseLong(rlsInvoiceNo.substring(0, 9))) % 7 == Long
                            .parseLong(rlsInvoiceNo.substring(9, 10))) {
                        result.setSuccess(true);
                        return result;
                    }
                }
                result.setSuccess(false);
            }
            if ("ktlogistics".equals(rlsCourierCd)) { // 동원로엑스택배
                if (rlsInvoiceNo.length() == 10) {
                    result.setSuccess(true);
                    return result;
                }
                result.setSuccess(false);
            }
            if ("nedex".equals(rlsCourierCd)) { // 네덱스택배
                if (rlsInvoiceNo.length() == 10) {
                    // 마지막 숫자는 체크번호(마지막숫자를 제외한 숫자를 7로 나눈 나머지)
                    if ((Long.parseLong(rlsInvoiceNo.substring(0, 9))) % 7 == Long
                            .parseLong(rlsInvoiceNo.substring(9, 10))) {
                        result.setSuccess(true);
                        return result;
                    }
                }
                result.setSuccess(false);
            }
            if ("innogis".equals(rlsCourierCd)) { // 이노지스택배
                if (rlsInvoiceNo.length() == 13) {
                    // 마지막 숫자는 체크번호(마지막숫자를 제외한 숫자를 7로 나눈 나머지)
                    String firstChar = rlsInvoiceNo.substring(0, 1);
                    if ("6".equals(firstChar) || "7".equals(firstChar) || "8".equals(firstChar)) {
                        result.setSuccess(true);
                        return result;
                    }
                }
                result.setSuccess(false);
            }
            if (!result.isSuccess()) result.setMessage(MessageUtil.getMessage("biz.exception.ord.notValidInvoiceNo"));
            /*
             * if( StringUtils.defaultString(goodsflowUseYn).equals("N") ){ // 굿스플로워 대상이 아니면 체크할 필요 없다.
             * result.setSuccess(true);
             * }
             */
        } catch (Exception e) {
            log.debug("{}", e.getMessage());
        }

        return result;
    }

    /**
     * 사이트의 택배사 코드 조회
     */
    public List<DeliveryVO> selectSiteCourierList() throws CustomException {
    	HashMap map = new HashMap();
    	map.put("siteNo", SessionDetailHelper.getDetails().getSiteNo());
        return proxyDao.selectList(MapperConstants.ORDER_DELIVERY + "selectSiteCourierList", map);
    }

    /**
     *
     * <pre>
     * 작성일 : 2016. 8. 4.
     * 작성자 : kdy
     * 설명   : 택배사 인터페이스에서 배송정보 업데이트를 위해 호출
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 8. 4. kdy - 최초생성
     * </pre>
     *
     * @param vo.rlsCourierCd
     *            택배사 코드
     * @param vo.rlsInvoiceNo
     *            송장 번호
     * @return
     * @throws CustomException
     */
    @Override
    public boolean updateDlvrByCourier(DeliveryVO vo) throws CustomException {

        try {
            int rCnt = proxyDao.update(MapperConstants.ORDER_DELIVERY + "updateDlvrByCourier", vo);
            if (rCnt > 0) {
                List<OrderGoodsVO> goodsList = proxyDao
                        .selectList(MapperConstants.ORDER_DELIVERY + "selectOrdDtlByCourier", vo);
                for (OrderGoodsVO goodsVo : goodsList) {
                    String curOrdStatusCd = goodsVo.getOrdDtlStatusCd(); // 현재 주문 상세 상태
                    goodsVo.setOrdDtlStatusCd("50"); // 배송 완료
                    orderService.updateOrdStatus(goodsVo, curOrdStatusCd);
                }

            }
        } catch (Exception e) {
            return false;
        }
        return true;
    }

    /**
     *
     * <pre>
     * 작성일 : 2016. 9. 27.
     * 작성자 : kdy
     * 설명   : Escrow 보내기
     *          Pay
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 9. 27. kdy - 최초생성
     * </pre>
     *
     * @param po
     * @param reqMap
     * @param mav
     * @param method
     * @return ResultModel<PaymentModel<?>>
     * @throws Exception
     */
    public ResultModel<PaymentModel<?>> doEscrowAction(DeliveryPO po, Map<String, Object> reqMap, ModelAndView mav,
            String method) throws Exception {
        ResultModel<PaymentModel<?>> result = new ResultModel<>();
        // 배송정보 DeliveryPO po
        log.debug("=== deliveryPO : {}", po);

        // PG 에스크로 처리
        try {
            // 주문번호가 없으면 실패 처리
            if (StringUtil.isEmpty(po.getOrdNo())) {
                // 선택된 주문이 없습니다.
                result.setMessage(MessageUtil.getMessage("biz.exception.ord.noOrderNo"));
                result.setSuccess(false);
            }
            // dlv:배송등록,receive:수령확인, confirm:구매확정,dcnf:거절확인, cancel:거래취소
            else if (!"dlv.receive.confirm.dcnf.cancel".contains(method)) {
                // 지원하지 않는 서비스입니다.
                result.setMessage(MessageUtil.getMessage("biz.exception.common.not.support.service"));
                result.setSuccess(false);
            }
            // PG 에스크로 처리
            else {
                PaymentModel reqPaymentModel = new PaymentModel();
                // 주문기본정보 조회 (주문 + 배송지)
                OrderInfoVO ordInfo = new OrderInfoVO();
                ordInfo.setOrdNo(po.getOrdNo());
                ordInfo.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
                // PG 결제정보만 조회(마켓포인트제외)
                ordInfo.setPgType("Y");
                List<OrderPayVO> payList = orderService.selectOrderPayInfoList(ordInfo);
                if (payList != null && !"Y".equals(payList.get(0).getEscrowYn())) { // 에스크로여부 N 이면 처리 필요없음
                    log.debug("=== EscroYn : {}", "N");
                    result.setSuccess(true);
                    return result;
                }else if (payList != null && "Y".equals(payList.get(0).getEscrowYn())) {
                    reqPaymentModel.setTxNo(payList.get(0).getTxNo());


                }

                ordInfo = orderService.selectOrdDtlInfo(ordInfo);
                log.debug("=== ordInfo : {}", ordInfo);

                // PgId 조회
                CommPaymentConfigSO payConfSo = new CommPaymentConfigSO();
                payConfSo.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
                if (!StringUtil.isEmpty(ordInfo.getPaymentPgCd())) {
                    payConfSo.setPgCd(ordInfo.getPaymentPgCd());
                }
                CommPaymentConfigVO payConfVo = proxyDao.selectOne(MapperConstants.SETUP_PAYMENT_MANAGE + "selectCommPaymentConfig", payConfSo);

                // 공통
                reqPaymentModel.setSiteNo(payConfSo.getSiteNo());
                reqPaymentModel.setEscrowTxCd(method); // 에스크로 처리모드 dlv:배송등록,receive:수령확인, confirm:구매확정,dcnf:거절확인,cancel:거래취소
                reqPaymentModel.setPaymentPgCd(ordInfo.getPaymentPgCd()); // PgCd
                reqPaymentModel.setPaymentWayCd(ordInfo.getPaymentWayCd()); // 결제수단
                reqPaymentModel.setPaymentAmt(ordInfo.getPaymentAmt());//결제금액
                reqPaymentModel.setPgId(payConfVo.getPgId()); // PgId
                reqPaymentModel.setOrdNo(Long.valueOf(ordInfo.getOrdNo())); // 주문번호
                reqPaymentModel.setGoodsNm(ordInfo.getGoodsNm());

                reqPaymentModel.setEscrowConfirmno(ordInfo.getEscrowConfirmno()); // 에스크로 승인번호
                reqPaymentModel.setEscrowTxDttm(DateUtil.removeFormat(DateUtil.getNowDateTime())); // 에스크로 처리일시
                reqPaymentModel.setRlsCourierCd(po.getRlsCourierCd()); // 택배사코드
                reqPaymentModel.setRlsInvoiceNo(po.getRlsInvoiceNo()); // 송장번호
                reqPaymentModel.setDlvrPaymentCd(po.getDlvrcPaymentCd());// 배송비지급방법(착불,선불)

                reqPaymentModel.setOrdrNm(ordInfo.getOrdrNm()); // 주문자명
                reqPaymentModel.setOrdrTel(ordInfo.getOrdrTel()); // 주문자 전화
                reqPaymentModel.setOrdrMobile(ordInfo.getOrdrMobile()); // 주문자 휴대폰번호

                reqPaymentModel.setAdrsNm(ordInfo.getAdrsNm()); // 수취인명
                reqPaymentModel.setPostNo(ordInfo.getPostNo()); //수취인 우편번호
                reqPaymentModel.setRoadnmAddr(ordInfo.getRoadnmAddr());//수취인주소1
                reqPaymentModel.setNumAddr(ordInfo.getNumAddr());//수취인주소2
                reqPaymentModel.setAdrsMobile(ordInfo.getAdrsMobile());// 수신자 전화번호(필수)


                reqPaymentModel.setPaymentCmpltDttm(ordInfo.getPaymentCmpltDttm().toString()); // 결제완료일시
                reqPaymentModel.setMemberNo(ordInfo.getMemberNo()); // 회원번호
                reqPaymentModel.setPaymentMobile(ordInfo.getOrdrMobile()); // 휴대폰번호(구매확인,거절시 처리)

                reqPaymentModel.setPgKey(payConfVo.getPgKey()); // 상점키
                reqPaymentModel.setKeyPasswd(payConfVo.getKeyPasswd()); // 상점패스워드

                /*이니시스 송신자 정보 세팅..*/
                   SiteSO ss = new SiteSO();
                   ss.setSiteNo(payConfSo.getSiteNo());
                   SiteVO site_info = cacheService.selectBasicInfo(ss);
                   reqPaymentModel.setRegrNm(SessionDetailHelper.getDetails().getSession().getMemberNm());
                   reqPaymentModel.setSendName(site_info.getSiteNm());
                   reqPaymentModel.setSendPost(site_info.getPostNo());
                   reqPaymentModel.setSendAddr1(site_info.getAddrRoadnm());
                   reqPaymentModel.setSendAddr2(site_info.getAddrNum());
                   reqPaymentModel.setSendTel(site_info.getTelNo());

                // PG 에스크로 인터페이스 호출
                result = paymentAdapterService.escrowSend(reqPaymentModel, reqMap, mav);
                // 01. 성공/실패시 로직 처리
                if (result.isSuccess()) {
                    result.setData(result.getData());
                } else {
                    result.setSuccess(false);
                    log.debug("### 처리에러 발생 ## ==> " + result.getMessage());
                }
            }
        } catch (Exception e) {
            result.setSuccess(false);
        }
        return result;
    }

    /**
     * <pre>
     * 작성일 : 2016. 09. 30.
     * 작성자 : dong
     * 설명   : 주문번호를 변수로 받아 주문한 배송완료 상품 목록 정보를 조회

     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 09. 30. dong - 최초생성
     * </pre>
     *
     * @return
     */
    public List<OrderGoodsVO> selectDeliveryCompletedList(int cnt) throws CustomException {
        return proxyDao.selectList(MapperConstants.ORDER_DELIVERY + "selectDeliveryCompletedList", cnt);
    }

    /**
     * <pre>
     * 작성일 : 2016. 09. 30.
     * 작성자 : dong
     * 설명   : 배송중 조회 ( 우체국 )

     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 09. 30. dong - 최초생성
     * </pre>
     *
     * @return
     */
    public List<EpostVO> selectDeliveryEpostList() throws CustomException {
        return proxyDao.selectList(MapperConstants.ORDER_DELIVERY + "selectDeliveryEpostList", "");
    }

}
