package net.danvi.dmall.biz.app.basicinfo.service;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import net.danvi.dmall.biz.app.basicinfo.model.BasicInfoVO;
import net.danvi.dmall.biz.app.setup.operationsupport.model.OperSupportConfigVO;
import net.danvi.dmall.biz.app.setup.operationsupport.service.OperationSupportConfigService;
import net.danvi.dmall.biz.app.setup.siteinfo.model.SiteSO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import net.danvi.dmall.biz.app.design.model.PopManageVO;
import net.danvi.dmall.biz.app.setup.payment.model.NopbPaymentConfigVO;
import net.danvi.dmall.biz.app.setup.siteinfo.model.SiteVO;
import net.danvi.dmall.biz.app.setup.siteinfo.service.SiteInfoService;
import net.danvi.dmall.biz.common.service.CacheService;
import dmall.framework.common.BaseService;
import dmall.framework.common.model.ResultListModel;
import dmall.framework.common.model.ResultModel;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 5. 2.
 * 작성자     : dong
 * 설명       :
 * </pre>
 */
@Service("basicInfoService")
@Transactional(rollbackFor = Exception.class)
public class BasicInfoServiceImpl extends BaseService implements BasicInfoService {

    @Resource(name = "siteInfoService")
    private SiteInfoService siteInfoService;

    @Resource(name = "operationSupportConfigService")
    private OperationSupportConfigService operationSupportConfigService;

    @Autowired
    private CacheService cacheService;


    /** 사이트 공통정보 조회 (GNB,BOTTOM INFO) **/
    public ResultListModel<BasicInfoVO> selectBasicInfo(long siteNo) throws Exception {
        ResultListModel<BasicInfoVO> result = new ResultListModel<>();// 공통정보
        SiteSO so = new SiteSO();
        so.setSiteNo(siteNo);

        // 카테고리 정보 조회
        Map gcvo = cacheService.selectGnbInfo(so);
        result.put("gnb_info", gcvo);
        Map lcvo = cacheService.selectLnbInfo(so);
        result.put("lnb_info", lcvo);
        // SITE정보 조회
        SiteVO svo = cacheService.selectBasicInfo(so);
        result.put("site_info", svo);
        // 무통장계좌 조회
        List<NopbPaymentConfigVO> npvo = cacheService.selectNopbInfo(so);
        result.put("nopb_info", npvo);
        // 팝업 정보 조회
        List<PopManageVO> popupvo = cacheService.selectPopupInfo(so);
        result.put("popup_info", popupvo);

        ResultModel<OperSupportConfigVO> anls = operationSupportConfigService.selectGaConfig(siteNo);
        result.put("anlsId",anls.getData().getAnlsId());

        return result;
    }

}
