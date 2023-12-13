package net.danvi.dmall.biz.system.login.service;

import java.util.Calendar;
import java.util.Locale;

import javax.annotation.Resource;

import dmall.framework.common.util.MessageUtil;
import net.danvi.dmall.biz.app.member.manage.model.MemberManagePO;
import net.danvi.dmall.biz.app.member.manage.model.MemberManageVO;
import net.danvi.dmall.biz.system.login.model.MemberLoginHistPO;
import net.danvi.dmall.biz.system.security.SessionDetailHelper;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import lombok.extern.slf4j.Slf4j;
import net.danvi.dmall.biz.system.model.LoginVO;
import net.danvi.dmall.biz.system.model.SiteCacheVO;
import net.danvi.dmall.biz.system.security.Session;
import net.danvi.dmall.biz.system.service.SiteService;
import dmall.framework.common.BaseService;
import dmall.framework.common.constants.MapperConstants;
import dmall.framework.common.model.ResultModel;

@Slf4j
@Service("loginService")
// @Transactional(rollbackFor = Exception.class)
public class LoginServiceImpl extends BaseService implements LoginService {

    @Resource(name = "siteService")
    private SiteService siteService;

    @Resource(name = "loginService")
    private LoginService loginService;

    @Override
    @Transactional(propagation= Propagation.REQUIRES_NEW)
    public void updateLoginErrorCount(LoginVO vo) {
        proxyDao.update(MapperConstants.SYSTEM_LOGIN + "updateUserFailCnt", vo);
    }

    @Override
    public void insertLoginHistory(MemberLoginHistPO po) {

        proxyDao.insert(MapperConstants.SYSTEM_LOGIN + "insertUserLoginHist", po);
    }

    @Override
    public LoginVO getUser(LoginVO user) {
        return proxyDao.selectOne(MapperConstants.SYSTEM_LOGIN + "getUser", user);
    }

    @Override
    public void resetUserFailCnt(LoginVO user) throws CloneNotSupportedException {
        proxyDao.update(MapperConstants.SYSTEM_LOGIN + "resetUserFailCnt", user.clone());
    }

    @Override
    public ResultModel checkEmailCertify(MemberManagePO po) {
        ResultModel resultModel = new ResultModel<>();
        po = proxyDao.selectOne(MapperConstants.SYSTEM_LOGIN + "getUserForEmailAuth", po);

        if (po != null && po.getMemberNo() > 0) {

            proxyDao.update(MapperConstants.SYSTEM_LOGIN + "updateUserActive", po);

            resultModel.setSuccess(true);
            resultModel.setMessage("휴면상태에서 해제가 <br/>완료되었습니다.");
        } else {
            resultModel.setSuccess(false);
            resultModel.setMessage("잘못된 회원 정보입니다.<br/>확인 후 다시 입력하여 주십시오.");
        }
        return resultModel;
    }

    @Override
    public ResultModel updateMemberActivate(MemberManagePO po) throws Exception {

        int cnt = proxyDao.update(MapperConstants.SYSTEM_LOGIN + "updateUserActive", po);

        ResultModel resultModel = new ResultModel<>();

        if (cnt > 0) {
            resultModel.setSuccess(true);
            resultModel.setMessage("휴면상태에서 해제가 <br/>완료되었습니다.");
        } else {
            throw new RuntimeException("휴면상태 해제가 실패했습니다.<br/>관리자에게 문의하여 주십시오.");
        }
        return resultModel;
    }

    @Override
    public ResultModel<MemberManageVO> updateChangePwNext(MemberManagePO po) {

        ResultModel<MemberManageVO> result = new ResultModel<>();

        Session session = SessionDetailHelper.getSession();
        // 날짜 정보
        Calendar cal = Calendar.getInstance(Locale.KOREA);

        // 사이트 정보
        SiteCacheVO siteCacheVO = siteService.getSiteInfo(po.getSiteNo());
        if (siteCacheVO.getPwChgNextChgDcnt() != null && !"".equals(siteCacheVO.getPwChgNextChgDcnt())) {
            // 현재 로그인한 회원 정보
            LoginVO loginVO = new LoginVO();
            loginVO.setSiteNo(session.getSiteNo());
            loginVO.setLoginId(session.getLoginId());
            loginVO = loginService.getUser(loginVO);

            // 회원의 다음 비밀번호 변경 일수 적용(회원의 다음변경 일수 + 설정의 다음변경 일수)
            cal.setTime(loginVO.getNextPwChgScdDttm());
            cal.add(Calendar.DATE, siteCacheVO.getPwChgNextChgDcnt());
            po.setNextPwChgScdDttm(cal.getTime());
        }
        po.setMemberNo(session.getMemberNo());

        Integer updateMemInfo = proxyDao.update(MapperConstants.SYSTEM_LOGIN + "updateChangePwNext", po);

        result.setSuccess(true);

        return result;
    }

    @Override
    public ResultModel createAuthKey(MemberManagePO po) {

        int cnt  = proxyDao.update(MapperConstants.SYSTEM_LOGIN + "updateAuthEmail", po);
        ResultModel resultModel = new ResultModel<>();

        if (cnt > 0) {
            resultModel.setSuccess(true);
        } else {
            throw new RuntimeException("이메일 인증번호 발송 실패 하였습니다.<br/>관리자에게 문의하여 주십시오.");
        }
        return resultModel;

    }

    @Override
    public MemberManageVO selectEmailAuthKey(MemberManagePO po) {
        return proxyDao.selectOne(MapperConstants.SYSTEM_LOGIN + "getEmailAuthKey", po);
    }
}
