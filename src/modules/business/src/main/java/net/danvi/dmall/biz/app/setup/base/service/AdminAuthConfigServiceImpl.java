package net.danvi.dmall.biz.app.setup.base.service;

import lombok.extern.slf4j.Slf4j;
import net.danvi.dmall.biz.system.model.SiteCacheVO;
import net.danvi.dmall.biz.system.security.DmallSessionDetails;
import net.danvi.dmall.biz.system.security.Session;
import net.danvi.dmall.biz.system.security.SessionDetailHelper;
import net.danvi.dmall.biz.system.service.SiteQuotaService;
import net.danvi.dmall.biz.app.setup.base.model.*;
import net.danvi.dmall.biz.common.service.BizService;

import net.danvi.dmall.biz.system.service.SiteService;
import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import dmall.framework.common.BaseService;
import dmall.framework.common.constants.CommonConstants;
import dmall.framework.common.constants.MapperConstants;
import dmall.framework.common.exception.CustomException;
import dmall.framework.common.model.ResultListModel;
import dmall.framework.common.model.ResultModel;
import dmall.framework.common.util.MessageUtil;

import javax.annotation.Resource;
import java.util.List;

/**
 * Created by dong on 2016-05-03.
 */
@Service("adminAuthConfigService")
@Slf4j
@Transactional(rollbackFor = Exception.class)
public class AdminAuthConfigServiceImpl extends BaseService implements AdminAuthConfigService {

    @Resource(name = "siteQuotaService")
    private SiteQuotaService siteQuotaService;

    @Resource(name = "bizService")
    private BizService bizService;

    @Value("#{datasource['main.database.type']}")
    private String dbType;

    @Resource(name = "siteService")
    private SiteService siteService;

    @Override
    public ResultListModel<ManagerVO> selectManagerPaging(ManagerSO so) {
        return proxyDao.selectListPageWoTotal(MapperConstants.SETUP_BASE_ADMINAUTHCONFIG + "selectManagerPaging", so);
    }

    @Override
    public ResultModel<ManagerPO> saveManager(ManagerPOListWrapper wrapper) {
        ResultModel<ManagerPO> resultModel = new ResultModel<>();

        Integer resultCount = -1;

        if(!siteQuotaService.isManagerAddible(wrapper.getSiteNo())) {
            resultModel.setMessage("운영자를 추가할 수 없습니다.");
            resultModel.setSuccess(false);
            return resultModel;
        }

        long adminNo = SessionDetailHelper.getSession().getMemberNo();
        for (ManagerPO po : wrapper.getList()) {
            po.setSiteNo(wrapper.getSiteNo()); // 사이트 번호 세팅
            po.setRegrNo(adminNo);
            po.setUpdrNo(adminNo);

            if (resultCount < 0) {
                resultCount = proxyDao.selectOne(MapperConstants.SETUP_BASE_ADMINAUTHCONFIG + "selectSuperManagerCount", po);
            }

            if (po.getAuthGrpNo().equals(0L)) {
                // 권한 그룹 번호가 0이면 삭제
                proxyDao.delete(MapperConstants.SETUP_BASE_ADMINAUTHCONFIG + "deleteManager", po);
            } else if (po.getOrgAuthGrpNo().equals(0L)) {
                // 원본 권한 그룹 번호가 0이면 등록
                if (resultCount > 0) {
                    log.debug("슈퍼관리자 권한을 가진 관리자가 이미 존재하여 등록할 수 없음. 삭제해야함.");
                    throw new CustomException("biz.exception.setup.existSuperAdmin");
                }
                proxyDao.insert(MapperConstants.SETUP_BASE_ADMINAUTHCONFIG + "insertManager", po);
            } else {
                if (resultCount > 0) {
                    log.debug("슈퍼관리자 권한을 가진 관리자가 이미 존재하여 수정할 수 없음. 삭제해야함.");
                    throw new CustomException("biz.exception.setup.existSuperAdmin");
                }
                proxyDao.update(MapperConstants.SETUP_BASE_ADMINAUTHCONFIG + "updateManager", po);
            }

            if (!po.getAuthGrpNo().equals(0L) && po.getMemberNo() == adminNo) {
                String managerAuthGbCd = proxyDao.selectOne(MapperConstants.SETUP_BASE_ADMINAUTHCONFIG + "selectManagerGbCd", po);
                if (StringUtils.isNotEmpty(managerAuthGbCd)) {
                    DmallSessionDetails details = SessionDetailHelper.getDetails();
                    Session session = details.getSession();
                    session.setAuthGbCd(managerAuthGbCd);
                    details.setSession(session);

                    SiteCacheVO siteCacheVO = siteService.getSiteInfo(po.getSiteNo());

                    try {
                        if (siteCacheVO.getAutoLogoutTime() == 0) {
                            SessionDetailHelper.setDetailsToCookie(details, -1);
                        } else {
                            SessionDetailHelper.setDetailsToCookie(details, siteCacheVO.getAutoLogoutTime() * 60);
                        }
                    } catch (Exception e) {
                        throw new CustomException("biz.exception.common.error", new Object[] { "" }, e);
                    }
                }
            }
        }

        resultModel.setMessage(MessageUtil.getMessage("biz.common.insert"));

        return resultModel;
    }

    @Override
    public ResultListModel<ManagerGroupVO> selectManagerGroupList(ManagerGroupSO so) {
        ResultListModel<ManagerGroupVO> resultListModel = new ResultListModel<>();

        List<ManagerGroupVO> list = proxyDao.selectList(MapperConstants.SETUP_BASE_ADMINAUTHCONFIG + "selectManagerGroupList", so);
        resultListModel.setResultList(list);

        return resultListModel;
    }

    @Override
    public ResultModel<ManagerGroupVO> selectManagerGroup(ManagerGroupVO vo) {
        ResultModel<ManagerGroupVO> result = new ResultModel<>();
        vo = proxyDao.selectOne(MapperConstants.SETUP_BASE_ADMINAUTHCONFIG + "selectManagerGroup", vo);
        result.setData(vo);

        return result;
    }

    @Override
    public ResultModel<ManagerGroupPO> insertManagerGroup(ManagerGroupPO po) {
        ResultModel<ManagerGroupPO> result = new ResultModel<>();

        if (po.getMenuId().contains("A")) {
            po.setAuthGbCd(CommonConstants.AUTH_GB_CD_ADMIN); // 관리자

            Integer resultCount = proxyDao.selectOne(MapperConstants.SETUP_BASE_ADMINAUTHCONFIG + "selectSuperManagerGroupCount", po);
            if (resultCount > 0) {
                log.debug("슈퍼관리자 권한 그룹이 이미 존재하여 등록할 수 없음");
                throw new CustomException("biz.exception.setup.existSuperAdminGrp");
            }
        } else {
            po.setAuthGbCd(CommonConstants.AUTH_GB_CD_MANAGER); // 운영자
        }

        // 권한 그룹 등록
        proxyDao.insert(MapperConstants.SETUP_BASE_ADMINAUTHCONFIG + "insertManagerGroup", po);

        // 운영자일 경우 권한 메뉴 등록
        insertManagerAuthMenu(po);

        result.setData(po);
        result.setMessage(MessageUtil.getMessage("biz.common.insert"));

        return result;
    }

    @Override
    public ResultModel<ManagerGroupPO> updateManagerGroup(ManagerGroupPO po) {

        Integer resultCount = proxyDao.selectOne(MapperConstants.SETUP_BASE_ADMINAUTHCONFIG + "selectSuperManagerGroupCount", po);

        if (po.getMenuId().contains("A")) {
            // 수정하려는 권한이 관리자 권한이고
            if (resultCount > 0) {
                // 이미 관리자 권한 그룹이 있으면
                log.debug("슈퍼관리자 권한 그룹이 이미 존재하여 변경할 수 없음");
                throw new CustomException("biz.exception.setup.existSuperAdminGrp");
            }
        }

        ResultModel<ManagerGroupPO> result = new ResultModel<>();
        proxyDao.delete(MapperConstants.SETUP_BASE_ADMINAUTHCONFIG + "deleteAllManagerAuthMenu", po);

        if (po.getMenuId().contains("A")) {
            po.setAuthGbCd("A"); // 관리자
        } else {
            po.setAuthGbCd("M"); // 운영자
        }

        // 권한 그룹 수정
        proxyDao.insert(MapperConstants.SETUP_BASE_ADMINAUTHCONFIG + "updateManagerGroup", po);

        // 운영자일 경우 권한 메뉴 등록
        insertManagerAuthMenu(po);

        result.setMessage(MessageUtil.getMessage("biz.common.update"));

        return result;
    }

    private void insertManagerAuthMenu(ManagerGroupPO po) {
        if ("M".equals(po.getAuthGbCd())) {
            MenagerAuthMenuPO mam = new MenagerAuthMenuPO(po);
            for (String menuId : po.getMenuId()) {
                mam.setMenuId(menuId);
                proxyDao.insert(MapperConstants.SETUP_BASE_ADMINAUTHCONFIG + "insertManagerAuthMenu", mam);
            }
        }
    }

    @Override
    public ResultModel<ManagerGroupPO> deleteManagerGroup(ManagerGroupPO po) {
        ResultModel<ManagerGroupPO> result = new ResultModel<>();
        MenagerAuthMenuPO mam = new MenagerAuthMenuPO(po);
        proxyDao.delete(MapperConstants.SETUP_BASE_ADMINAUTHCONFIG + "deleteAllManagerAuthMenu", mam);
        proxyDao.delete(MapperConstants.SETUP_BASE_ADMINAUTHCONFIG + "deleteAllManagerOfAuthGrp", po);
        proxyDao.delete(MapperConstants.SETUP_BASE_ADMINAUTHCONFIG + "deleteManagerAuthGrp", po);

        result.setMessage(MessageUtil.getMessage("biz.common.delete"));

        return result;
    }

    @Override
    public ResultModel isAddible(ManagerSO so) {
        ResultModel<ManagerGroupPO> result = new ResultModel<>();
        result.setSuccess(false);
        result.setMessage("추가할 수 있는 운영자 한도에 도달하였습니다.<br/>운영자를 추가하기 위해 운영자 추가 한도를 늘려 주시기바랍니다.");

        if(siteQuotaService.isManagerAddible(so.getSiteNo())) {
            result.setSuccess(true);
            result.setMessage(null);
        }

        return result;
    }
}
