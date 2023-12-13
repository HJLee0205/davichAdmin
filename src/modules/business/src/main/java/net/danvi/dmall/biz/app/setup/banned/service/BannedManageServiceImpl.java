package net.danvi.dmall.biz.app.setup.banned.service;

import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import net.danvi.dmall.biz.app.setup.banned.model.*;
import net.danvi.dmall.biz.common.service.BizService;
import net.danvi.dmall.biz.system.remote.AdminRemotingService;
import net.danvi.dmall.biz.system.security.SessionDetailHelper;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import lombok.extern.slf4j.Slf4j;
import dmall.framework.common.BaseService;
import dmall.framework.common.constants.MapperConstants;
import dmall.framework.common.model.ResultModel;
import dmall.framework.common.util.HttpUtil;
import dmall.framework.common.util.MessageUtil;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 5. 4.
 * 작성자     : user
 * 설명       :
 * </pre>
 */
@Slf4j
@Service("bannedManageService")
@Transactional(rollbackFor = Exception.class)
public class BannedManageServiceImpl extends BaseService implements BannedManageService {
    @Resource(name = "bizService")
    private BizService bizService;

    @Resource(name = "adminRemotingService")
    private AdminRemotingService adminRemotingService;

    @Override
    @Transactional(readOnly = true)
    public List<BannedManageVO> selectBannedList(BannedManageSO so) {
        return proxyDao.selectList(MapperConstants.BANNED_BASE + "selectBannedList", so); // 금칙어
                                                                                          // 리스트
                                                                                          // 조회
    }

    @Override
    public ResultModel<BannedManagePO> insertBanned(BannedManagePO po) throws Exception {
        ResultModel<BannedManagePO> result = new ResultModel<>();

        if (selectBannedWordChk(po) > 0) {
            // 중복 검사 메시지(이미 등록되어있는 {0}입니다.)
            result.setMessage(MessageUtil.getMessage("biz.exception.operation.existWord", new Object[] { "금칙어" }));
        } else {
            try {
                // 금칙어 등록
                po.setSeq(bizService.getSequence("TB_BANNED_WORD"));
                proxyDao.insert(MapperConstants.BANNED_BASE + "insertBanned", po);
                result.setMessage(MessageUtil.getMessage("biz.common.insert"));
            } catch (Exception e) {
                result.setMessage(MessageUtil.getMessage("biz.exception.common.error"));
            }
        }

        // 프론트 사이트 정보 갱신
        //HttpServletRequest request = HttpUtil.getHttpServletRequest();
        //adminRemotingService.refreshSiteInfoCache(po.getSiteNo(), request.getServerName());

        return result;
    }

    @Override
    public ResultModel<BannedManagePO> deleteBanned(BannedManagePO po) {
        ResultModel<BannedManagePO> result = new ResultModel<>();

        if (selectBannedWordChk(po) > 0) {
            try {
                // 금칙어 삭제 여부 변경
                proxyDao.update(MapperConstants.BANNED_BASE + "deleteBanned", po);

                // 프론트 사이트 정보 갱신
                //HttpServletRequest request = HttpUtil.getHttpServletRequest();
                //adminRemotingService.refreshSiteInfoCache(po.getSiteNo(), request.getServerName());

                result.setMessage(MessageUtil.getMessage("biz.common.delete"));
            } catch (Exception e) {
                result.setMessage(MessageUtil.getMessage("biz.exception.common.error"));
            }
        } else {
            result.setMessage(MessageUtil.getMessage("biz.exception.operation.bannedChk"));
        }

        return result;
    }

    @Override
    public ResultModel<BannedManagePO> updateBannedInit(BannedManagePO po) {
        ResultModel<BannedManagePO> result = new ResultModel<>();
        try {
            // 금칙어 초기화
            proxyDao.update(MapperConstants.BANNED_BASE + "updateBannedInitY", po);
            proxyDao.update(MapperConstants.BANNED_BASE + "updateBannedInitN", po);
            result.setMessage(MessageUtil.getMessage("biz.common.init"));

            // 프론트 사이트 정보 갱신
            //HttpServletRequest request = HttpUtil.getHttpServletRequest();
            //adminRemotingService.refreshSiteInfoCache(po.getSiteNo(), request.getServerName());
        } catch (Exception e) {
            result.setMessage(MessageUtil.getMessage("biz.exception.common.error"));
        }
        return result;
    }

    public int selectBannedWordChk(BannedManagePO po) {
        // 금칙어 중복 검사
        int result = proxyDao.selectOne(MapperConstants.BANNED_BASE + "selectBannedWordChk", po);
        return result;
    }

    @Override
    public ResultModel<BannedConfigVO> selectBannedConfig(Long siteNo) {
        BannedConfigVO resultVO = proxyDao.selectOne(MapperConstants.BANNED_BASE + "selectBannedConfig", siteNo);
        ResultModel<BannedConfigVO> result = new ResultModel<>(resultVO);
        return result;
    }

    @Override
    public ResultModel<BannedConfigPO> updateBannedConfig(BannedConfigPO po) throws Exception {
        ResultModel<BannedConfigPO> resultModel = new ResultModel<>();
        po.setUpdrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());

        proxyDao.update(MapperConstants.BANNED_BASE + "updateBannedConfig", po);

        // 프론트 사이트 정보 갱신
        //HttpServletRequest request = HttpUtil.getHttpServletRequest();
        //adminRemotingService.refreshSiteInfoCache(po.getSiteNo(), request.getServerName());

        resultModel.setMessage(MessageUtil.getMessage("biz.common.update"));
        return resultModel;
    }
}
