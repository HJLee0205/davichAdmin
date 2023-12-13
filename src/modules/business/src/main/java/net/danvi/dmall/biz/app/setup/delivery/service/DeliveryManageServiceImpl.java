package net.danvi.dmall.biz.app.setup.delivery.service;

import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import net.danvi.dmall.biz.common.service.BizService;
import net.danvi.dmall.biz.system.remote.AdminRemotingService;
import net.danvi.dmall.biz.system.security.SessionDetailHelper;
import org.apache.commons.lang.StringUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import lombok.extern.slf4j.Slf4j;
import net.danvi.dmall.biz.app.setup.delivery.model.CourierPO;
import net.danvi.dmall.biz.app.setup.delivery.model.CourierSO;
import net.danvi.dmall.biz.app.setup.delivery.model.CourierVO;
import net.danvi.dmall.biz.app.setup.delivery.model.DeliveryAreaPO;
import net.danvi.dmall.biz.app.setup.delivery.model.DeliveryAreaPOListWrapper;
import net.danvi.dmall.biz.app.setup.delivery.model.DeliveryAreaSO;
import net.danvi.dmall.biz.app.setup.delivery.model.DeliveryAreaVO;
import net.danvi.dmall.biz.app.setup.delivery.model.DeliveryConfigPO;
import net.danvi.dmall.biz.app.setup.delivery.model.DeliveryConfigVO;
import net.danvi.dmall.biz.app.setup.delivery.model.HscdPO;
import net.danvi.dmall.biz.app.setup.delivery.model.HscdSO;
import net.danvi.dmall.biz.app.setup.delivery.model.HscdVO;
import dmall.framework.common.BaseService;
import dmall.framework.common.constants.MapperConstants;
import dmall.framework.common.model.ResultListModel;
import dmall.framework.common.model.ResultModel;
import dmall.framework.common.util.HttpUtil;
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
@Service("deliveryManageService")
@Transactional(rollbackFor = Exception.class)
public class DeliveryManageServiceImpl extends BaseService implements DeliveryManageService {

    @Resource(name = "bizService")
    private BizService bizService;

    @Resource(name = "adminRemotingService")
    private AdminRemotingService adminRemotingService;

    /*
     * (non-Javadoc)
     * 
     * @see
     * DeliveryManageService#
     * selectCourierListPaging(net.danvi.dmall.biz.app.setup.delivery.model.
     * CourierSO)
     */
    @Override
    @Transactional(readOnly = true)
    public ResultListModel<CourierVO> selectCourierListPaging(CourierSO so) {
        so.setSidx("REG_DTTM");
        so.setSord("DESC");
        return proxyDao.selectListPage(MapperConstants.SETUP_DELIVERY + "selectCourierListPaging", so);
    }

    /*
     * (non-Javadoc)
     * 
     * @see
     * DeliveryManageService#
     * selectCourier(CourierVO)
     */
    @Override
    @Transactional(readOnly = true)
    public ResultModel<CourierVO> selectCourier(CourierVO vo) {
        CourierVO resultVO = proxyDao.selectOne(MapperConstants.SETUP_DELIVERY + "selectCourier", vo);
        ResultModel<CourierVO> result = new ResultModel<>(resultVO);

        return result;
    }

    /*
     * (non-Javadoc)
     * 
     * @see
     * DeliveryManageService#
     * selectCourierList(net.danvi.dmall.biz.app.setup.delivery.model.
     * CourierVO)
     */
    @Override
    @Transactional(readOnly = true)
    public List<String> selectCourierList(CourierVO vo) {
        return proxyDao.selectList(MapperConstants.SETUP_DELIVERY + "selectCourierList", vo);
    }

    /** 택배사 추가, 수정 등록서비스 **/
    /*
     * (non-Javadoc)
     * 
     * @see
     * DeliveryManageService#
     * updateCourierForUse(net.danvi.dmall.biz.app.setup.delivery.model.
     * CourierPO)
     */
    @Override
    public ResultModel<CourierPO> updateCourierForUse(CourierPO po) throws Exception {
        ResultModel<CourierPO> result = new ResultModel<>();
        proxyDao.update(MapperConstants.SETUP_DELIVERY + "updateCourierForUse", po);
        result.setMessage(MessageUtil.getMessage("biz.common.update"));
        return result;
    }

    /*
     * (non-Javadoc)
     * 
     * @see
     * DeliveryManageService#
     * insertCourier(CourierPO)
     */
    @Override
    public ResultModel<CourierPO> insertCourier(CourierPO po) throws Exception {
        ResultModel<CourierPO> result = new ResultModel<>();
        proxyDao.insert(MapperConstants.SETUP_DELIVERY + "insertCourier", po);
        result.setMessage(MessageUtil.getMessage("biz.common.insert"));
        return result;
    }

    /** 택배사 정보 삭제 처리 서비스 **/
    /*
     * (non-Javadoc)
     * 
     * @see
     * DeliveryManageService#
     * deleteCourier(CourierPO)
     */
    @Override
    public ResultModel<CourierPO> deleteCourier(CourierPO po) throws Exception {
        ResultModel<CourierPO> result = new ResultModel<>();
        proxyDao.delete(MapperConstants.SETUP_DELIVERY + "deleteCourier", po);
        result.setMessage(MessageUtil.getMessage("biz.common.delete"));
        return result;
    }

    /*
     * (non-Javadoc)
     * 
     * @see
     * DeliveryManageService#
     * selectDeliveryConfig(long)
     */
    @Override
    @Transactional(readOnly = true)
    public ResultModel<DeliveryConfigVO> selectDeliveryConfig(long siteNo) {
        DeliveryConfigVO resultVO = proxyDao.selectOne(MapperConstants.SETUP_DELIVERY + "selectDeliveryConfig", siteNo);
        ResultModel<DeliveryConfigVO> result = new ResultModel<>(resultVO);
        return result;
    }

    /** 배송 설정 정보 수정 서비스 **/
    /*
     * (non-Javadoc)
     * 
     * @see
     * DeliveryManageService#
     * updateDeliveryConfig(net.danvi.dmall.biz.app.setup.delivery.model.
     * DeliveryConfigPO)
     */
    @Override
    public ResultModel<DeliveryConfigPO> updateDeliveryConfig(DeliveryConfigPO po) throws Exception {
        ResultModel<DeliveryConfigPO> result = new ResultModel<>();
        if (po.getDefaultDlvrc() != null && po.getDefaultDlvrc().trim().length() < 1) {
            po.setDefaultDlvrc(null);
        }
        if (po.getDefaultDlvrMinAmt() != null && po.getDefaultDlvrMinAmt().trim().length() < 1) {
            po.setDefaultDlvrMinAmt(null);
        }
        if (po.getDefaultDlvrMinDlvrc() != null && po.getDefaultDlvrMinDlvrc().trim().length() < 1) {
            po.setDefaultDlvrMinDlvrc(null);
        }

        if (StringUtils.isEmpty(po.getCouriUseYn())) {
            po.setCouriUseYn("N");
        }
        if (StringUtils.isEmpty(po.getDirectVisitRecptYn())) {
            po.setDirectVisitRecptYn("N");
        }

        po.setSiteNo(po.getSiteNo()); // 사이트 번호 세팅
        po.setUpdrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
        po.setRegrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
        proxyDao.update(MapperConstants.SETUP_DELIVERY + "updateDeliveryConfig", po);

        // 프론트 사이트 정보 갱신
        /*HttpServletRequest request = HttpUtil.getHttpServletRequest();
        adminRemotingService.refreshSiteInfoCache(po.getSiteNo(), request.getServerName());*/

        result.setMessage(MessageUtil.getMessage("biz.common.update"));
        return result;
    }

    /*
     * (non-Javadoc)
     * 
     * @see
     * DeliveryManageService#
     * selectDeliveryListPaging(net.danvi.dmall.biz.app.setup.delivery.model.
     * DeliveryAreaSO)
     */
    @Override
    @Transactional(readOnly = true)
    public ResultListModel<DeliveryAreaVO> selectDeliveryListPaging(DeliveryAreaSO so) {
        if (so.getSidx().length() == 0) {
            so.setSidx("REG_DTTM");
            so.setSord("DESC");
        }
        return proxyDao.selectListPage(MapperConstants.SETUP_DELIVERY + "selectDeliveryListPaging", so);
    }

    /*
     * (non-Javadoc)
     * 
     * @see
     * DeliveryManageService#
     * selectDeliveryListPaging(net.danvi.dmall.biz.app.setup.delivery.model.
     * DeliveryAreaSO)
     */
    @Override
    @Transactional(readOnly = true)
    public ResultListModel<DeliveryAreaVO> selectDeliveryList(DeliveryAreaSO so) {
        if (so.getSidx().length() == 0) {
            so.setSidx("REG_DTTM");
            so.setSord("DESC");
        }
        ResultListModel<DeliveryAreaVO> result = new ResultListModel<>();
        List areaDeliveryList = proxyDao.selectList(MapperConstants.SETUP_DELIVERY + "selectDeliveryList", so);
        result.setResultList(areaDeliveryList);
        return result;
    }

    /*
     * (non-Javadoc)
     * 
     * @see
     * DeliveryManageService#
     * selectDefaultDeliveryListPaging(net.danvi.dmall.biz.app.setup.delivery.
     * model.DeliveryAreaSO)
     */
    @Override
    @Transactional(readOnly = true)
    public ResultListModel<DeliveryAreaVO> selectDefaultDeliveryListPaging(DeliveryAreaSO so) {
        if (so.getSidx().length() == 0) {
            so.setSidx("REG_DTTM");
            so.setSord("DESC");
        }
        return proxyDao.selectListPage(MapperConstants.SETUP_DELIVERY + "selectDefaultDeliveryListPaging", so);
    }

    @Override
    public ResultModel<DeliveryAreaPO> insertDeliveryArea(DeliveryAreaPO po) throws Exception {
        ResultModel<DeliveryAreaPO> result = new ResultModel<>();
        int cnt = proxyDao.selectOne(MapperConstants.SETUP_DELIVERY + "selectCountDeliveryArea", po);
        if (cnt > 0) {
            result.setMessage(MessageUtil.getMessage("biz.exception.common.exist", new Object[] { "우편번호" }));
        } else {
            po.setUpdrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
            po.setRegrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
            proxyDao.update(MapperConstants.SETUP_DELIVERY + "updateDeliveryArea", po);
            result.setMessage(MessageUtil.getMessage("biz.common.save"));
        }
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
    public ResultModel<DeliveryAreaPO> updateDeliveryArea(DeliveryAreaPO po) throws Exception {
        ResultModel<DeliveryAreaPO> result = new ResultModel<>();
        po.setUpdrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
        po.setRegrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
        proxyDao.update(MapperConstants.SETUP_DELIVERY + "updateDeliveryArea", po);
        result.setMessage(MessageUtil.getMessage("biz.common.update"));
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
    public ResultModel<DeliveryAreaPO> updateApplyDefaultDeliveryArea(DeliveryAreaPO po) throws Exception {
        ResultModel<DeliveryAreaPO> result = new ResultModel<>();
        po.setUpdrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
        po.setRegrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
        proxyDao.update(MapperConstants.SETUP_DELIVERY + "updateApplyDefaultDeliveryArea", po);
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
    public ResultModel<DeliveryAreaPO> deleteDeliveryArea(DeliveryAreaPOListWrapper wrapper) {
        ResultModel<DeliveryAreaPO> resultModel = new ResultModel<>();

        for (DeliveryAreaPO po : wrapper.getList()) {
            po.setSiteNo(wrapper.getSiteNo()); // 사이트 번호 세팅
            po.setUpdrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
            proxyDao.delete(MapperConstants.SETUP_DELIVERY + "deleteDeliveryArea", po);
        }
        resultModel.setMessage(MessageUtil.getMessage("biz.common.delete"));
        return resultModel;
    }

    /*
     * (non-Javadoc)
     * 
     * @see
     * DeliveryManageService#
     * deleteAllDeliveryArea(net.danvi.dmall.biz.app.setup.delivery.model.
     * DeliveryAreaPOListWrapper)
     */
    public ResultModel<DeliveryAreaPO> deleteAllDeliveryArea(DeliveryAreaPO po) {
        ResultModel<DeliveryAreaPO> resultModel = new ResultModel<>();
        po.setUpdrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
        po.setRegrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
        proxyDao.delete(MapperConstants.SETUP_DELIVERY + "deleteAllDeliveryArea", po);
        resultModel.setMessage(MessageUtil.getMessage("biz.common.delete"));
        return resultModel;
    }

    @Override
    @Transactional(readOnly = true)
    public ResultListModel<HscdVO> selectHscdListPaging(HscdSO so) {
        if (so.getSidx().length() == 0) {
            so.setSidx("REG_DTTM");
            so.setSord("DESC");
        }
        return proxyDao.selectListPage(MapperConstants.SETUP_DELIVERY + "selectHscdListPaging", so);
    }

    /** HS코드 정보 등록, 수정 처리 서비스 **/
    @Override
    public ResultModel<HscdPO> updateHscd(HscdPO po) throws Exception {
        ResultModel<HscdPO> result = new ResultModel<>();
        if (po.getHscdSeq() == null) {
            Long hscdSeq = bizService.getSequence("HSCD_SEQ", po.getSiteNo());
            po.setHscdSeq(hscdSeq);
        }
        proxyDao.insert(MapperConstants.SETUP_DELIVERY + "updateHscd", po);
        result.setMessage(MessageUtil.getMessage("biz.common.save"));
        return result;
    }

    /** HS코드 정보 삭제 처리 서비스 **/
    @Override
    public ResultModel<HscdPO> deleteHscd(HscdPO po) throws Exception {
        ResultModel<HscdPO> result = new ResultModel<>();
        proxyDao.delete(MapperConstants.SETUP_DELIVERY + "deleteHscd", po);
        result.setMessage(MessageUtil.getMessage("biz.common.delete"));
        return result;
    }

}
