package net.danvi.dmall.biz.app.seller.service;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import net.danvi.dmall.biz.app.seller.model.CalcDeductVO;
import net.danvi.dmall.biz.app.seller.model.CalcDeductVOListWrapper;
import net.danvi.dmall.biz.app.seller.model.CalcDtlVO;
import net.danvi.dmall.biz.app.seller.model.CalcVO;
import net.danvi.dmall.biz.app.seller.model.CalcVOListWrapper;
import net.danvi.dmall.biz.app.seller.model.SellerSO;
import net.danvi.dmall.biz.app.seller.model.SellerVO;
import net.danvi.dmall.biz.app.setup.siteinfo.service.SiteInfoService;
import net.danvi.dmall.biz.system.security.SessionDetailHelper;
import dmall.framework.common.BaseService;
import dmall.framework.common.constants.MapperConstants;
import dmall.framework.common.model.ResultListModel;
import dmall.framework.common.model.ResultModel;
import dmall.framework.common.util.MessageUtil;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 5. 2.
 * 작성자     : dong
 * 설명       :
 * </pre>
 */
@Service("calcSellerService")
@Transactional(rollbackFor = Exception.class)
public class CalcSellerServiceImpl extends BaseService implements CalcSellerService {

    @Resource(name = "siteInfoService")
    private SiteInfoService siteInfoService;

    public ResultListModel<SellerVO> selectCalcSellerList(SellerSO sellerSO) {
        return proxyDao.selectListPage(MapperConstants.CALC_SELLER + "selectCalcListPaging", sellerSO);
    }

    public ResultListModel<SellerVO> selectCalcDtlList(SellerSO sellerSO) {
        return proxyDao.selectListPage(MapperConstants.CALC_SELLER + "selectCalcListPaging", sellerSO);
    }
    
    @Override
    public ResultModel<SellerVO> calculationSeller(SellerSO so) throws Exception {
    	
        ResultModel<SellerVO> result = new ResultModel<>();
        
        List<SellerVO> li = proxyDao.selectList(MapperConstants.CALC_SELLER + "targetSellerList", so);
        
        // [정산대상 체크]
        if (li.size() == 0) {
            result.setMessage(MessageUtil.getMessage("admin.web.seller.targetCalc"));
            result.setSuccess(false);
            return result;
        }

        // [정산체크]
        int chkNumber = 0;
        for (SellerVO vo : li) {
            so.setSellerNo(vo.getSellerNo());
            chkNumber += selectChkCalculate(so);
        }
        
        if (chkNumber >= li.size()) {
          result.setMessage(MessageUtil.getMessage("admin.web.seller.chkCalculate"));
          result.setSuccess(false);
          return result;
        }
        
        for (SellerVO vo : li) {
            so.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
            so.setRegrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
            so.setSellerNo(vo.getSellerNo());
            
            int rtn = selectChkCalculate(so);
            
            if (rtn == 0) {
                String calculateNo = proxyDao.selectOne(MapperConstants.CALC_SELLER + "getCalculateNumber");
                so.setCalculateNo(calculateNo);
            	
                // 정산상세내역 처리
                proxyDao.insert(MapperConstants.CALC_SELLER + "calculateSellerDtl", so);
                
                // 정산상세내역 처리 (환불이 있을경우)
                proxyDao.insert(MapperConstants.CALC_SELLER + "refundCalculate", so);
                
                // 정산내역 처리
                proxyDao.insert(MapperConstants.CALC_SELLER + "calculateSellerMst", so);
            }
        }
        
        result.setMessage(MessageUtil.getMessage("admin.web.seller.calculate"));
        
        return result;
    }        
    
    /** 전체 정산시 중복확인  **/
    public int selectChkCalculate(SellerSO so) {
        return proxyDao.selectOne(MapperConstants.CALC_SELLER + "selectChkCalculate", so);
    }
        

    public ResultListModel<CalcDtlVO> selectLedgerDtlList(SellerSO sellerSO) {
        return proxyDao.selectListPage(MapperConstants.CALC_SELLER + "selectLedgerDtlListPaging", sellerSO);
    }
    
    
    public List<SellerVO> selectCalcTotalExcel(SellerSO sellerSO) {
        return proxyDao.selectList(MapperConstants.CALC_SELLER + "selectCalcListPaging", sellerSO);
    }
        
    
    public List<SellerVO> selectCalcDtlExcel(SellerSO sellerSO) {
        return proxyDao.selectList(MapperConstants.CALC_SELLER + "selectLedgerDtlExcel", sellerSO);
    }
    
    
    public List<CalcDeductVO> selectDeductList(SellerSO sellerSO) {
        return proxyDao.selectList(MapperConstants.CALC_SELLER + "selectDeductList", sellerSO);
    }
    
    
    
    
    @Override
    public ResultModel<CalcDeductVO> saveCalcDeduct(CalcDeductVOListWrapper wrapper) throws Exception {
    	
        ResultModel<CalcDeductVO> result = new ResultModel<>();
        
        for (CalcDeductVO vo : wrapper.getList()) {
        	
            if ("I".equals(vo.getInputGbn())) {
            	vo.setRegrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
                proxyDao.insert(MapperConstants.CALC_SELLER + "insertDeductList", vo);
            } else {
                vo.setUpdrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
                proxyDao.update(MapperConstants.CALC_SELLER + "updateDeductList", vo);
            }
        }
        
        result.setMessage(MessageUtil.getMessage("admin.web.common.save"));
        
        return result;
    }
    
    
    @Override
    public ResultModel<CalcVO> deleteCalculate(CalcVOListWrapper wrapper) throws Exception {
        ResultModel<CalcVO> result = new ResultModel<>();

        for (CalcVO vo : wrapper.getList()) {
            vo.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());

            proxyDao.delete(MapperConstants.CALC_SELLER + "deleteCalculateDeduct", vo);
            proxyDao.delete(MapperConstants.CALC_SELLER + "deleteCalculateDtl", vo);
            proxyDao.delete(MapperConstants.CALC_SELLER + "deleteCalculateMst", vo);
        }

        result.setMessage(MessageUtil.getMessage("admin.web.common.delete"));
        return result;
    }    
        
    
    
    @Override
    public ResultModel<CalcVO> updateCalcChange(CalcVOListWrapper wrapper) throws Exception {
        ResultModel<CalcVO> result = new ResultModel<>();

        for (CalcVO vo : wrapper.getList()) {
            vo.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
            vo.setUpdrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
            proxyDao.update(MapperConstants.CALC_SELLER + "updateCalcChange", vo);
        }

        result.setMessage(MessageUtil.getMessage("admin.web.common.update"));
        return result;
    }      
    
    
    @Override
    public ResultModel<CalcVO> updateCalcChange(CalcVO vo) throws Exception {
        ResultModel<CalcVO> result = new ResultModel<>();

        vo.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
        vo.setUpdrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
        proxyDao.update(MapperConstants.CALC_SELLER + "updateCalcChange", vo);

        result.setMessage(MessageUtil.getMessage("admin.web.common.update"));
        return result;
    }     
    
}
