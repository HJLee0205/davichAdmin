package net.danvi.dmall.biz.app.setup.delivery.service;

import net.danvi.dmall.biz.app.setup.delivery.model.CourierPO;
import net.danvi.dmall.biz.app.setup.delivery.model.CourierVO;
import net.danvi.dmall.biz.app.setup.siteinfo.model.SiteSO;
import net.danvi.dmall.biz.app.setup.siteinfo.model.SiteVO;
import net.danvi.dmall.biz.system.security.SessionDetailHelper;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import lombok.extern.slf4j.Slf4j;
import dmall.framework.common.BaseService;
import dmall.framework.common.constants.MapperConstants;
import dmall.framework.common.model.ResultModel;
import dmall.framework.common.util.MessageUtil;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 5. 4.
 * 작성자     : dong
 * 설명       :
 * </pre>
 */
@Slf4j
@Service("deliveryInterfaceService")
@Transactional(rollbackFor = Exception.class)
public class DeliveryInterfaceServiceImpl extends BaseService implements DeliveryInterfaceService {

    /*
     * (non-Javadoc)
     * 
     * @see
     * DeliveryManageService#
     * selectCourier(CourierVO)
     */
    @Override
    @Transactional(readOnly = true)
    public ResultModel<CourierVO> selectDeliveryInterface(CourierVO vo) {
        // 기존 정보 취득
        CourierVO resultVO = proxyDao.selectOne(MapperConstants.SETUP_DELIVERY_INTERFACE + "selectDeliveryInterface",
                vo);
        // 기존 정보가 없을 경우
        if (resultVO == null) {
            resultVO = new CourierVO();
            resultVO.setLinkUseYn("N");
        }

        // 업체 정보에서 기본 정보를 취득
        SiteSO so = new SiteSO();
        so.setSiteNo(vo.getSiteNo());
        SiteVO siteVO = proxyDao.selectOne(MapperConstants.SETUP_SITE_INFO + "selectSiteInfo", so);
        if (siteVO != null) {
            // 상점ID
            resultVO.setSiteNo(siteVO.getSiteNo());
            // 상호명
            resultVO.setCompanyNm(siteVO.getCompanyNm());
            // 사업자번호
            resultVO.setBizNo(siteVO.getBizNo());
            // 대표자명
            resultVO.setCeoNm(siteVO.getCeoNm());
            // 전화번호
            resultVO.setTelNo(siteVO.getTelNo());
            // e-mail
            resultVO.setEmail(siteVO.getEmail());
            // 우편번호
            resultVO.setPostNo(siteVO.getPostNo());
            // 주소
            resultVO.setAddrNum(siteVO.getAddrNum());
            // 상세주소
            resultVO.setAddrRoadnm(siteVO.getAddrRoadnm());
            // 공통주소
            resultVO.setAddrCmnDtl(siteVO.getAddrCmnDtl());
        }
        ResultModel<CourierVO> result = new ResultModel<>(resultVO);
        return result;
    }

    /*
     * (non-Javadoc)
     * 
     * @see
     * DeliveryManageService#
     * updateDeliveryArea(net.danvi.dmall.biz.app.setup.delivery.model.
     * DeliveryAreaPO)
     */
    @Override
    public ResultModel<CourierPO> updateDeliveryInterface(CourierPO po) throws Exception {
        ResultModel<CourierPO> result = new ResultModel<>();
        po.setSiteNo(po.getSiteNo()); // 사이트 번호 세팅
        po.setUpdrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
        po.setRegrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
        proxyDao.update(MapperConstants.SETUP_DELIVERY_INTERFACE + "updateDeliveryInterface", po);
        result.setMessage(MessageUtil.getMessage("biz.common.update"));
        return result;
    }

    /*
     * (non-Javadoc)
     * 
     * @see
     * DeliveryManageService#
     * deleteDeliveryArea(net.danvi.dmall.biz.app.setup.delivery.model.
     * DeliveryAreaPOListWrapper)
     */
    @Override
    public ResultModel<CourierPO> deleteDeliveryInterface(CourierPO po) {
        ResultModel<CourierPO> resultModel = new ResultModel<>();
        po.setUpdrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
        proxyDao.delete(MapperConstants.SETUP_DELIVERY_INTERFACE + "deleteDeliveryInterface", po);
        resultModel.setMessage(MessageUtil.getMessage("biz.common.delete"));
        return resultModel;
    }

}
