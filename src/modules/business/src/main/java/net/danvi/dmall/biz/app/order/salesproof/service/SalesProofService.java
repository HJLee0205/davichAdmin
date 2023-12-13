package net.danvi.dmall.biz.app.order.salesproof.service;

import java.util.List;
import java.util.Map;

import org.springframework.web.bind.annotation.RequestParam;

import net.danvi.dmall.biz.app.order.salesproof.model.SalesProofPO;
import net.danvi.dmall.biz.app.order.salesproof.model.SalesProofSO;
import net.danvi.dmall.biz.app.order.salesproof.model.SalesProofVO;
import dmall.framework.common.exception.CustomException;
import dmall.framework.common.model.ResultListModel;
import dmall.framework.common.model.ResultModel;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 5. 3.
 * 작성자     : kdy
 * 설명       :
 * </pre>
 */
public interface SalesProofService {
    public ResultListModel<SalesProofVO> selectSalesProofListPaging(SalesProofSO so) throws CustomException;

    public List<SalesProofVO> selectSalesProofListExcel(SalesProofSO so) throws CustomException;

    public SalesProofVO selectSalesProofMemo(SalesProofVO vo) throws CustomException;

    public boolean updateSalesProofMemo(SalesProofVO vo) throws CustomException;

    // 현금영수증 발급신청 결과등록
    public ResultModel<SalesProofVO> insertCashRctIssue(SalesProofPO salesProofPO,
            @RequestParam Map<String, Object> reqMap) throws Exception;

    public ResultModel<SalesProofVO> insertCashRct(SalesProofPO salesProofPO) throws Exception;

    // 세금계산서 신청내역등록
    public ResultModel<SalesProofVO> insertTaxBill(SalesProofPO po) throws Exception;

    // 현금영수증 신청내역조회
    public ResultModel<SalesProofVO> selectCashRct(SalesProofVO vo) throws Exception;

    // 세금계산서 신청내역조회
    public ResultModel<SalesProofVO> selectTaxBill(SalesProofVO vo) throws Exception;

    // 증빙서류의 주문 번호 조회
    public ResultModel<SalesProofVO> selectSalesProofOrdNo(SalesProofVO vo) throws CustomException;

    // 현금영수증 상태값 수정 ( 취소 )
    public ResultModel<SalesProofVO> updateCashRct(SalesProofPO po) throws Exception;

}
