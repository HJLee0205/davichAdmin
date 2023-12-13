package net.danvi.dmall.biz.app.setup.securitymanage.service;

import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import net.danvi.dmall.biz.app.setup.securitymanage.model.AccessBlockIpPO;
import net.danvi.dmall.biz.app.setup.securitymanage.model.SecurityManagePO;
import net.danvi.dmall.biz.system.security.SessionDetailHelper;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import net.danvi.dmall.biz.app.setup.securitymanage.model.AccessBlockIpConfigPO;
import net.danvi.dmall.biz.app.setup.securitymanage.model.ContentsProtectionPO;
import net.danvi.dmall.biz.system.remote.AdminRemotingService;
import dmall.framework.common.BaseService;
import dmall.framework.common.constants.CommonConstants;
import dmall.framework.common.constants.MapperConstants;
import dmall.framework.common.model.ResultListModel;
import dmall.framework.common.model.ResultModel;
import dmall.framework.common.util.HttpUtil;

/**
 * Created by dong on 2016-06-13.
 */
@Service("securityManageService")
@Transactional(rollbackFor = Exception.class)
public class SecurityManageServiceImpl extends BaseService implements SecurityManageService {

    @Resource(name = "adminRemotingService")
    private AdminRemotingService adminRemotingService;

    @Override
    @Transactional(readOnly = true)
    public SecurityManagePO selectSecurityConfig() {
        Long siteNo = SessionDetailHelper.getDetails().getSiteNo();
        SecurityManagePO po = proxyDao.selectOne(MapperConstants.SETUP_SECURITY_MANAGE + "selectSecurityConfig",
                siteNo);

        if (po == null) {
            po = new SecurityManagePO();
        }

        return po;
    }

    @Override
    public ResultModel<SecurityManagePO> saveSecurityConfig(SecurityManagePO securityManagePO) {
        ResultModel resultModel = new ResultModel();
        int result = proxyDao.update(MapperConstants.SETUP_SECURITY_MANAGE + "updateSecurityConfig", securityManagePO);

        if (result == 1) {
            resultModel.setSuccess(true);
            // SecurityManagePO po = proxyDao.selectOne(MapperConstants.SETUP_SECURITY_MANAGE + "selectSecurityConfig",
            // securityManagePO.getSiteNo());
            // resultModel.setData(po);
        } else {
            resultModel.setSuccess(false);
        }

        return resultModel;
    }

    @Override
    @Transactional(readOnly = true)
    public AccessBlockIpConfigPO selectAccessBlockIpConfig() {
        Long siteNo = SessionDetailHelper.getDetails().getSiteNo();
        AccessBlockIpConfigPO vo = proxyDao
                .selectOne(MapperConstants.SETUP_SECURITY_MANAGE + "selectAccessBlockIpConfig", siteNo);

        if (vo == null) {
            vo = new AccessBlockIpConfigPO();
        }

        return vo;
    }

    @Override
    @Transactional(readOnly = true)
    public ResultListModel<AccessBlockIpPO> selectAccessBlockIpList(AccessBlockIpPO po) {
        ResultListModel<AccessBlockIpPO> resultListModel = new ResultListModel<>();
        List<AccessBlockIpPO> list = proxyDao
                .selectList(MapperConstants.SETUP_SECURITY_MANAGE + "selectAccessBlockIpList", po);
        resultListModel.setResultList(list);
        return resultListModel;
    }

    @Override
    public ResultModel<AccessBlockIpConfigPO> saveAccessBlockIpConfig(AccessBlockIpConfigPO po) {
        ResultModel<AccessBlockIpConfigPO> result = new ResultModel<>();
        proxyDao.update(MapperConstants.SETUP_SECURITY_MANAGE + "updateAccessBlockIpConfig", po);

        if (CommonConstants.YN_Y.equals(po.getIpConnectLimitUseYn()) && po.getIpList() != null
                && po.getIpList().size() > 0) {
            proxyDao.insert(MapperConstants.SETUP_SECURITY_MANAGE + "insertAccessBlockIp", po);
        }

        // 프론트 사이트 정보 갱신
        /*HttpServletRequest request = HttpUtil.getHttpServletRequest();
        adminRemotingService.refreshSiteInfoCache(po.getSiteNo(), request.getServerName());*/
        // result.setMessage(MessageUtil.getMessage("biz.common.save"));

        return result;
    }

    @Override
    public ResultModel<AccessBlockIpConfigPO> deleteAccessBlockIpConfig(AccessBlockIpConfigPO po) {
        ResultModel<AccessBlockIpConfigPO> result = new ResultModel<>();
        proxyDao.insert(MapperConstants.SETUP_SECURITY_MANAGE + "deleteAccessBlockIp", po);

        // 프론트 사이트 정보 갱신
        /*HttpServletRequest request = HttpUtil.getHttpServletRequest();
        adminRemotingService.refreshSiteInfoCache(po.getSiteNo(), request.getServerName());*/

        return result;
    }

    @Override
    @Transactional(readOnly = true)
    public ContentsProtectionPO selectContentsProtection() {
        Long siteNo = SessionDetailHelper.getDetails().getSiteNo();
        return proxyDao.selectOne(MapperConstants.SETUP_SECURITY_MANAGE + "selectContentsProtection", siteNo);
    }

    @Override
    public ResultModel<ContentsProtectionPO> updateContentsProtection(ContentsProtectionPO po) {
        ResultModel<ContentsProtectionPO> result = new ResultModel<>();
        proxyDao.insert(MapperConstants.SETUP_SECURITY_MANAGE + "updateContentsProtection", po);

        // 프론트 사이트 정보 갱신
        /*HttpServletRequest request = HttpUtil.getHttpServletRequest();
        adminRemotingService.refreshSiteInfoCache(po.getSiteNo(), request.getServerName());*/

        return result;
    }
}
