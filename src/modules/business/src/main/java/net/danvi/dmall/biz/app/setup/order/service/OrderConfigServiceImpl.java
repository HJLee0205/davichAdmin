package net.danvi.dmall.biz.app.setup.order.service;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import net.danvi.dmall.biz.app.setup.order.model.OrderConfigVO;
import net.danvi.dmall.biz.system.remote.AdminRemotingService;
import net.danvi.dmall.biz.system.security.SessionDetailHelper;
import org.apache.commons.lang.StringUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import lombok.extern.slf4j.Slf4j;
import net.danvi.dmall.biz.app.setup.order.model.OrderConfigPO;
import dmall.framework.common.BaseService;
import dmall.framework.common.constants.MapperConstants;
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
@Service("orderConfigService")
@Transactional(rollbackFor = Exception.class)
public class OrderConfigServiceImpl extends BaseService implements OrderConfigService {

    @Resource(name = "adminRemotingService")
    private AdminRemotingService adminRemotingService;

    /** 주문 관련 설정 정보 조회 서비스 **/
    /*
     * (non-Javadoc)
     * 
     * @see OrderConfigService#
     * selectOrderConfig(java.lang.Long)
     */
    @Override
    @Transactional(readOnly = true)
    public ResultModel<OrderConfigVO> selectOrderConfig(Long siteNo) {
        OrderConfigVO resultVO = proxyDao.selectOne(MapperConstants.SETUP_ORDER_CONFIG + "selectOrderConfig", siteNo);
        ResultModel<OrderConfigVO> result = new ResultModel<>(resultVO);
        return result;
    }

    /** 주문 관련 설정 정보 수정 서비스 **/
    /*
     * (non-Javadoc)
     * 
     * @see OrderConfigService#
     * updateOrderConfig(net.danvi.dmall.biz.app.setup.order.model.
     * OrderConfigPO)
     */
    @Override
    public ResultModel<OrderConfigPO> updateOrderConfig(OrderConfigPO po) throws Exception {
        ResultModel<OrderConfigPO> resultModel = new ResultModel<>();
        po.setUpdrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
        if (StringUtils.isEmpty(po.getAvailStockQtt())) {
            po.setAvailStockQtt(null);
        }
        if (StringUtils.isEmpty(po.getGoodsKeepDcnt())) {
            po.setGoodsKeepDcnt(null);
        }

        proxyDao.update(MapperConstants.SETUP_ORDER_CONFIG + "updateOrderConfig", po);

        // 프론트 사이트 정보 갱신
        /*HttpServletRequest request = HttpUtil.getHttpServletRequest();
        adminRemotingService.refreshSiteInfoCache(po.getSiteNo(), request.getServerName());*/

        resultModel.setMessage(MessageUtil.getMessage("biz.common.update"));
        return resultModel;
    }

}
