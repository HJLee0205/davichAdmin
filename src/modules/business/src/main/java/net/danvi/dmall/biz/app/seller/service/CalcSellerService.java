package net.danvi.dmall.biz.app.seller.service;

import java.util.List;

import net.danvi.dmall.biz.app.seller.model.CalcDeductVO;
import net.danvi.dmall.biz.app.seller.model.CalcDeductVOListWrapper;
import net.danvi.dmall.biz.app.seller.model.CalcDtlVO;
import net.danvi.dmall.biz.app.seller.model.CalcVO;
import net.danvi.dmall.biz.app.seller.model.CalcVOListWrapper;
import net.danvi.dmall.biz.app.seller.model.SellerSO;
import net.danvi.dmall.biz.app.seller.model.SellerVO;
import net.danvi.dmall.biz.app.seller.model.SellerVOListWrapper;
import dmall.framework.common.model.ResultListModel;
import dmall.framework.common.model.ResultModel;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2017. 11. 20.
 * 작성자     : 김현열
 * 설명       :
 * </pre>
 */

public interface CalcSellerService {

    public ResultListModel<SellerVO> selectCalcSellerList(SellerSO sellerSO);
    public ResultModel<SellerVO> calculationSeller(SellerSO so) throws Exception;
    public int selectChkCalculate(SellerSO so);
    public ResultListModel<CalcDtlVO> selectLedgerDtlList(SellerSO sellerSO); 
    public List<SellerVO> selectCalcTotalExcel(SellerSO sellerSO) ;
    public List<SellerVO> selectCalcDtlExcel(SellerSO sellerSO);
    public List<CalcDeductVO> selectDeductList(SellerSO sellerSO);
    public ResultModel<CalcDeductVO> saveCalcDeduct(CalcDeductVOListWrapper wrapper)  throws Exception;
    public ResultModel<CalcVO> deleteCalculate(CalcVOListWrapper wrapper) throws Exception ;
    public ResultModel<CalcVO> updateCalcChange(CalcVOListWrapper wrapper) throws Exception;
    public ResultModel<CalcVO> updateCalcChange(CalcVO vo) throws Exception;
}
