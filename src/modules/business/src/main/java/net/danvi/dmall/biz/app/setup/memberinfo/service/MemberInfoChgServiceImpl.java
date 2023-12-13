package net.danvi.dmall.biz.app.setup.memberinfo.service;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import net.danvi.dmall.biz.app.setup.memberinfo.model.PasswordChgConfigPO;
import net.danvi.dmall.biz.app.setup.memberinfo.model.PasswordChgConfigVO;
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
 * 작성일     : 2016. 5. 31.
 * 작성자     : dong
 * 설명       :
 * </pre>
 */
@Slf4j
@Service("memberinfoChgService")
@Transactional(rollbackFor = Exception.class)
public class MemberInfoChgServiceImpl extends BaseService implements MemberInfoChgService {
    @Resource(name = "adminRemotingService")
    private AdminRemotingService adminRemotingService;

    /** 비밀번호 변경 안내 설정 정보 조회 서비스 **/
    @Override
    @Transactional(readOnly = true)
    public ResultModel<PasswordChgConfigVO> selectPasswordChgConfig(Long siteNo) {
        PasswordChgConfigVO resultVO = proxyDao.selectOne(MapperConstants.SETUP_MEMBER_INFO + "selectPasswordChgConfig",
                siteNo);
        ResultModel<PasswordChgConfigVO> result = new ResultModel<>(resultVO);
        return result;
    }

    /** 비밀번호 변경 안내 설정 정보 수정 서비스 **/
    @Override
    public ResultModel<PasswordChgConfigPO> updatePasswordChgConfig(PasswordChgConfigPO po) throws Exception {
        ResultModel<PasswordChgConfigPO> resultModel = new ResultModel<>();

        po.setUpdrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
        proxyDao.update(MapperConstants.SETUP_MEMBER_INFO + "updatePasswordChgConfig", po);

        // 프론트 사이트 정보 갱신
        /*HttpServletRequest request = HttpUtil.getHttpServletRequest();
        adminRemotingService.refreshSiteInfoCache(po.getSiteNo(), request.getServerName());*/

        resultModel.setMessage(MessageUtil.getMessage("biz.common.update"));
        return resultModel;
    }
}
