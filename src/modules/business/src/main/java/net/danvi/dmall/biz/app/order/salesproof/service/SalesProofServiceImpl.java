package net.danvi.dmall.biz.app.order.salesproof.service;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import net.danvi.dmall.biz.app.setup.payment.model.CommPaymentConfigVO;
import net.danvi.dmall.biz.system.security.SessionDetailHelper;
import org.springframework.dao.DuplicateKeyException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import lombok.extern.slf4j.Slf4j;
import net.danvi.dmall.biz.app.order.salesproof.model.SalesProofPO;
import net.danvi.dmall.biz.app.order.salesproof.model.SalesProofSO;
import net.danvi.dmall.biz.app.order.salesproof.model.SalesProofVO;
import net.danvi.dmall.biz.app.setup.payment.model.CommPaymentConfigSO;
import net.danvi.dmall.biz.app.setup.payment.service.PaymentManageService;
import net.danvi.dmall.biz.system.remote.payment.PaymentAdapterService;
import net.danvi.dmall.core.model.payment.PaymentModel;
import dmall.framework.common.BaseService;
import dmall.framework.common.constants.MapperConstants;
import dmall.framework.common.exception.CustomException;
import dmall.framework.common.model.ResultListModel;
import dmall.framework.common.model.ResultModel;

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
@Service("salesProofService")
@Transactional(rollbackFor = Exception.class)
public class SalesProofServiceImpl extends BaseService implements SalesProofService {
    @Resource(name = "paymentAdapterService")
    private PaymentAdapterService paymentAdapterService;

    @Resource(name = "paymentManageService")
    private PaymentManageService paymentManageService;

    /**
     * 매출 증빙 목록
     */
    @Override
    public ResultListModel<SalesProofVO> selectSalesProofListPaging(SalesProofSO so) {
        if (so.getSidx().length() == 0) {
            so.setSidx("A.REG_DTTM");
            so.setSord("DESC");
        }

        if (("all").equals(so.getSearchCd())) {
            so.setSearchOrdrNm(so.getSearchWord());
        } else if (("01").equals(so.getSearchCd())) {
            so.setSearchOrdrNm(so.getSearchWord());
        }

        return proxyDao.selectListPage(MapperConstants.ORDER_SALES_PROOF + "selectSalesProofListPaging", so);

    }

    /**
     * 엑셀 다운로드용 목록 조회
     */
    public List<SalesProofVO> selectSalesProofListExcel(SalesProofSO so) throws CustomException {
        so.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());

        if (("all").equals(so.getSearchCd())) {
            so.setSearchOrdrNm(so.getSearchWord());
        } else if (("01").equals(so.getSearchCd())) {
            so.setSearchOrdrNm(so.getSearchWord());
        }

        return proxyDao.selectList(MapperConstants.ORDER_SALES_PROOF + "selectSalesProofListPaging", so);

    }

    /**
     * 메모 내용 조회
     */
    @Override
    public SalesProofVO selectSalesProofMemo(SalesProofVO vo) throws CustomException {
        return proxyDao.selectOne(MapperConstants.ORDER_SALES_PROOF + "selectSalesProofMemo", vo);
    }

    /**
     * 메모 내용 수정
     *
     * <pre>
     * 작성일 : 2016. 7. 28.
     * 작성자 : kdy
     * 설명   :
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 7. 28. kdy - 최초생성
     * </pre>
     *
     * @param po
     * @return
     */
    @Override
    public boolean updateSalesProofMemo(SalesProofVO vo) throws CustomException {
        int rCnt = 0;
        rCnt = proxyDao.update(MapperConstants.ORDER_SALES_PROOF + "updateSalesProofMemo", vo);
        return (rCnt > 0) ? true : false;
    }

    /**
     * 현금영수증 발급신청 결과등록
     *
     * <pre>
     * 작성일 : 2016. 7. 28.
     * 작성자 : kdy
     * 설명   :
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 7. 28. kdy - 최초생성
     * </pre>
     *
     * @param po
     * @return
     */
    @Override
    public ResultModel<SalesProofVO> insertCashRctIssue(SalesProofPO salesProofPO,
            @RequestParam Map<String, Object> reqMap) throws Exception {
        ResultModel<SalesProofVO> result = new ResultModel<>();
        try {
            if (!"".equals(salesProofPO.getPaymentPgCd()) && !"00".equals(salesProofPO.getPaymentPgCd())) { // PG 존재할 경우
                ModelAndView mav = new ModelAndView();

                log.debug("salesProofPO.getPaymentPgCd() " + salesProofPO.getPaymentPgCd());
                // PG정보 조회
                CommPaymentConfigSO so = new CommPaymentConfigSO();
                so.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
                so.setPgCd(salesProofPO.getPaymentPgCd());
                CommPaymentConfigVO vo = paymentManageService.selectCommPaymentConfig(so).getData();
                PaymentModel<?> paymentModel = new PaymentModel<>();
                paymentModel.setPaymentPgCd(salesProofPO.getPaymentPgCd());
                paymentModel.setPgId(vo.getPgId());
                paymentModel.setPgKey(vo.getPgKey());
                paymentModel.setPgKey2(vo.getPgKey2());
                paymentModel.setPgKey3(vo.getPgKey3());
                paymentModel.setPgKey4(vo.getPgKey4());
                paymentModel.setKeyPasswd(vo.getKeyPasswd());
                paymentModel.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());

                // 추가셋팅
                paymentModel.setReqMode(salesProofPO.getReqMode());
                paymentModel.setOrdNo(salesProofPO.getOrdNo());
                paymentModel.setCashRctStatusCd("02"); // 상태코드(01:접수,02:승인,03:오류)
                paymentModel.setApplicantGbCd("01"); // 신청자구분코드 (01:구매자, 02:관리자)
                paymentModel.setMemberNo(Long.toString(salesProofPO.getRegrNo())); // 주문자번호
                paymentModel.setUseGbCd(salesProofPO.getUseGbCd()); // 사용구분코드(01:소득공제, 02:지출증빙)
                paymentModel.setIssueWayCd(salesProofPO.getIssueWayCd()); // 발급수단코드(01:주민등록번호,02:휴대폰,03:사업자등록번호)
                paymentModel.setIssueWayNo(salesProofPO.getIssueWayNo()); // 발급수단번호
                paymentModel.setTotAmt(Long.valueOf(salesProofPO.getTotAmt())); // 총금액
                paymentModel.setAcceptDttm(salesProofPO.getRegDttm()); // 접수일시
                paymentModel.setLinkTxNo(salesProofPO.getLinkTxNo());
                paymentModel.setApplicantNm(salesProofPO.getApplicantNm()); // 신청자명
                paymentModel.setRegrNo(salesProofPO.getRegrNo()); // 등록자
                paymentModel.setRegDttm(salesProofPO.getRegDttm()); // 등록일자

                try {
                    PaymentModel model = new PaymentModel<>();
                    model.setPaymentPgCd(paymentModel.getPaymentPgCd());
                    ResultModel<PaymentModel<?>> rsm = paymentAdapterService.receipt(paymentModel);
                    log.debug("현금영수증 pg 발급 처리 결과  : " + rsm.isSuccess());
                    // 01. 성공/실패시 로직 처리
                    if (rsm.isSuccess()) {
                        PaymentModel resultPayment = rsm.getData();
                        salesProofPO.setCashRctStatusCd("02"); // 승인
                        salesProofPO.setLinkTxNo(rsm.getData().getLinkTxNo()); // 거래번호
                        salesProofPO.setLinkResultCd(resultPayment.getConfirmResultCd()); // 결과코드
                        salesProofPO.setLinkResultMsg(resultPayment.getConfirmResultMsg()); // 결과 메시지

                        long totAmt = salesProofPO.getTotAmt();// 총금액
                        salesProofPO.setSupplyAmt(Math.round((totAmt / 1.1)));// 공급가액
                        salesProofPO.setVatAmt((totAmt - (Math.round((totAmt / 1.1)))));/* 부가세금액 */

                        proxyDao.insert(MapperConstants.ORDER_SALES_PROOF + "insertCashRct", salesProofPO);
                        result.setSuccess(true);
                    } else {
                        result.setSuccess(false);
                        result.setMessage(rsm.getMessage());
                    }
                } catch (Exception e) {
                    log.debug("{}", e.getMessage());
                    result.setSuccess(false);
                }
            }else {
            	result.setSuccess(false);
            	result.setMessage("PG사를 통한 결제만 현금영수증 처리가 가능합니다.");
            }
        } catch (DuplicateKeyException e) {
            log.debug("{}", e.getMessage());
            result.setSuccess(false);
            throw new CustomException("biz.exception.common.exist", new Object[] { "현금 영수증 신청결과 등록" }, e);
        }
        return result;
    }

    /**
     * 현금영수증 발급신청 결과등록
     *
     * <pre>
     * 작성일 : 2016. 7. 28.
     * 작성자 : kdy
     * 설명   :
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 7. 28. kdy - 최초생성
     * </pre>
     *
     * @param po
     * @return
     */
    @Override
    public ResultModel<SalesProofVO> insertCashRct(SalesProofPO salesProofPO) throws Exception {
        ResultModel<SalesProofVO> result = new ResultModel<>();
        long totAmt = salesProofPO.getTotAmt();// 총금액
        salesProofPO.setSupplyAmt(Math.round((totAmt / 1.1)));// 공급가액
        salesProofPO.setVatAmt((totAmt - (Math.round((totAmt / 1.1)))));/* 부가세금액 */

        try {
            proxyDao.insert(MapperConstants.ORDER_SALES_PROOF + "insertCashRct", salesProofPO);
        } catch (DuplicateKeyException e) {
            throw new CustomException("biz.exception.common.exist", new Object[] { "현금 영수증 신청결과 등록" }, e);
        }
        return result;
    }

    /**
     * 세금계산서 신청 내용 등록
     *
     * <pre>
     * 작성일 : 2016. 7. 28.
     * 작성자 : kdy
     * 설명   :
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 7. 28. kdy - 최초생성
     * </pre>
     *
     * @param po
     * @return
     */
    @Override
    public ResultModel<SalesProofVO> insertTaxBill(SalesProofPO po) throws Exception {
        ResultModel<SalesProofVO> result = new ResultModel<>();
        try {
            proxyDao.insert(MapperConstants.ORDER_SALES_PROOF + "insertTaxBill", po);
            result.setSuccess(true);
        } catch (DuplicateKeyException e) {
            throw new CustomException("biz.exception.common.exist", new Object[] { "세금계산서 신청 등록" }, e);
        }
        return result;
    }

    /**
     * 현금영수증 발급신청 내용 조회
     *
     * <pre>
     * 작성일 : 2016. 7. 28.
     * 작성자 : kdy
     * 설명   :
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 7. 28. kdy - 최초생성
     * </pre>
     *
     * @param po
     * @return
     */
    @Override
    public ResultModel<SalesProofVO> selectCashRct(SalesProofVO vo) throws Exception {
        ResultModel<SalesProofVO> result = new ResultModel<>();
        try {
            SalesProofVO resultVO = proxyDao.selectOne(MapperConstants.ORDER_SALES_PROOF + "selectCashRct", vo);
            result.setData(resultVO);
        } catch (DuplicateKeyException e) {
            throw new CustomException("biz.exception.common.exist", new Object[] { "현금 영수증 신청 조회" }, e);
        }
        return result;
    }

    /**
     * 세금계산서 신청 내용 조회
     *
     * <pre>
     * 작성일 : 2016. 7. 28.
     * 작성자 : kdy
     * 설명   :
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 7. 28. kdy - 최초생성
     * </pre>
     *
     * @param po
     * @return
     */
    @Override
    public ResultModel<SalesProofVO> selectTaxBill(SalesProofVO vo) throws Exception {
        ResultModel<SalesProofVO> result = new ResultModel<>();
        try {
            SalesProofVO resultVO = proxyDao.selectOne(MapperConstants.ORDER_SALES_PROOF + "selectTaxBill", vo);
            result.setData(resultVO);
        } catch (DuplicateKeyException e) {
            throw new CustomException("biz.exception.common.exist", new Object[] { "세금계산서 신청 조회" }, e);
        }
        return result;
    }

    /**
     *
     * <pre>
     * 작성일 : 2016. 8. 24.
     * 작성자 : kdy
     * 설명   : 증빙서류의 존재하는 주문번호 조회
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 8. 24. kdy - 최초생성
     * </pre>
     *
     * @param vo
     * @return
     * @throws CustomException
     */
    public ResultModel<SalesProofVO> selectSalesProofOrdNo(SalesProofVO vo) throws CustomException {
        ResultModel<SalesProofVO> result = new ResultModel<SalesProofVO>();
        vo.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
        SalesProofVO sVo = proxyDao.selectOne(MapperConstants.ORDER_SALES_PROOF + "selectSalesProofOrdNo", vo);
        result.setData(sVo);
        return result;
    }

    /**
     * 현금영수증 발급신청 결과수정
     *
     * <pre>
     * 작성일 : 2016. 9. 01.
     * 작성자 : dong
     * 설명   :
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2016. 9. 01. kdy - 최초생성
     * </pre>
     *
     * @param po
     * @return
     */
    @Override
    public ResultModel<SalesProofVO> updateCashRct(SalesProofPO po) throws Exception {
        ResultModel<SalesProofVO> result = new ResultModel<>();
        try {
            proxyDao.update(MapperConstants.ORDER_SALES_PROOF + "updateCashRct", po);
        } catch (DuplicateKeyException e) {
            throw new CustomException("biz.exception.common.exist", new Object[] { "현금 영수증 신청결과 수정" }, e);
        }
        return result;
    }
}
