package net.danvi.dmall.biz.app.member.manage.service;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.dao.DuplicateKeyException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import dmall.framework.common.BaseService;
import dmall.framework.common.constants.MapperConstants;
import dmall.framework.common.dao.ProxyPushDao;
import dmall.framework.common.dao.ProxyStorePushDao;
import dmall.framework.common.exception.CustomException;
import dmall.framework.common.model.ResultListModel;
import dmall.framework.common.model.ResultModel;
import dmall.framework.common.util.DateUtil;
import dmall.framework.common.util.MessageUtil;
import dmall.framework.common.util.SiteUtil;
import dmall.framework.common.util.StringUtil;
import lombok.extern.slf4j.Slf4j;
import net.danvi.dmall.biz.app.member.manage.model.MemberDeliveryPO;
import net.danvi.dmall.biz.app.member.manage.model.MemberDeliverySO;
import net.danvi.dmall.biz.app.member.manage.model.MemberDeliveryVO;
import net.danvi.dmall.biz.app.member.manage.model.MemberManagePO;
import net.danvi.dmall.biz.app.member.manage.model.MemberManageSO;
import net.danvi.dmall.biz.app.member.manage.model.MemberManageVO;
import net.danvi.dmall.biz.app.member.manage.model.RefundAccountPO;
import net.danvi.dmall.biz.app.member.manage.model.RefundAccountSO;
import net.danvi.dmall.biz.app.member.manage.model.RefundAccountVO;
import net.danvi.dmall.biz.app.operation.model.EmailSendSO;
import net.danvi.dmall.biz.app.operation.model.ReplaceCdVO;
import net.danvi.dmall.biz.app.operation.model.SavedmnPointSO;
import net.danvi.dmall.biz.app.operation.model.SavedmnPointVO;
import net.danvi.dmall.biz.app.operation.model.SmsSendSO;
import net.danvi.dmall.biz.app.operation.service.EmailSendService;
import net.danvi.dmall.biz.app.operation.service.SmsSendService;
import net.danvi.dmall.biz.app.setup.personcertify.model.PersonCertifyConfigVO;
import net.danvi.dmall.biz.app.setup.siteinfo.model.SiteSO;
import net.danvi.dmall.biz.app.setup.siteinfo.model.SiteVO;
import net.danvi.dmall.biz.common.service.BizService;
import net.danvi.dmall.biz.system.login.service.LoginService;
import net.danvi.dmall.biz.system.model.AppLogPO;
import net.danvi.dmall.biz.system.model.LoginVO;
import net.danvi.dmall.biz.system.model.SiteCacheVO;
import net.danvi.dmall.biz.system.security.DmallSessionDetails;
import net.danvi.dmall.biz.system.security.Session;
import net.danvi.dmall.biz.system.security.SessionDetailHelper;
import net.danvi.dmall.biz.system.service.SiteService;
import net.danvi.dmall.biz.system.util.InterfaceUtil;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 5. 9.
 * 작성자     : dong
 * 설명       :
 * </pre>
 */
@Slf4j
@Service("frontMemberService")
@Transactional(rollbackFor = Exception.class)
public class FrontMemberServiceImpl extends BaseService implements FrontMemberService {

    @Resource(name = "memberManageService")
    private MemberManageService memberManageService;

    @Resource(name = "bizService")
    private BizService bizService;

    @Resource(name = "emailSendService")
    private EmailSendService emailSendService;

    @Resource(name = "smsSendService")
    private SmsSendService smsSendService;

    @Resource(name = "siteService")
    private SiteService siteService;

    @Resource(name = "loginService")
    private LoginService loginService;

    @Resource(name = "proxyPushDao")
    private ProxyPushDao proxyPushDao;
    
    @Resource(name = "proxyStorePushDao")
    private ProxyStorePushDao proxyStorePushDao;

    /** 회원정보 조회서비스 **/
    @Override
    @Transactional(readOnly = true)
    public ResultModel<MemberManageVO> selectMember(MemberManageSO so) {
        ResultModel<MemberManageVO> result = new ResultModel<>();
        result = memberManageService.viewMemInfo(so);
        return result;
    }

    /** 회원등록 서비스 **/
    @Override
    public synchronized ResultModel<MemberManagePO> insertMember(MemberManagePO po) throws Exception {
        ResultModel<MemberManagePO> result = new ResultModel<>();

        // ID 중복 한번 더 체크
        MemberManageSO so = new MemberManageSO();
        so.setLoginId(po.getLoginId());
        so.setSiteNo(po.getSiteNo());
        int loginId = this.checkDuplicationId(so);
        log.debug("loginId : " + loginId);
        if (loginId > 0) {
            result.setSuccess(false);
            result.setMessage("사용할 수 없는 아이디입니다.");
            return result;
        }

        // 05. 회원 가입 SMS 발송
        ReplaceCdVO smsReplaceVO = new ReplaceCdVO();
        SiteSO siteSo = new SiteSO();
        siteSo.setSiteNo(po.getSiteNo());
        SiteVO siteVO = proxyDao.selectOne(MapperConstants.SETUP_SITE_INFO + "selectSiteInfo", siteSo);
        smsReplaceVO.setMemberNm(po.getMemberNm());
        smsReplaceVO.setSiteNm(siteVO.getSiteNm());

        SmsSendSO smsSendSo = new SmsSendSO();
        smsSendSo.setSendTypeCd("01");
        smsSendSo.setReceiverId(po.getLoginId());
        smsSendSo.setReceiverNm(po.getMemberNm());
        smsSendSo.setRecvTelno(po.getMobile());
        smsSendSo.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());

        // 05. 회원가입 이메일 발송(EmailSendSO so, ReplaceCdVO replaceVO)
        EmailSendSO emailSendSo = new EmailSendSO();
        emailSendSo.setMailTypeCd("01"); // ERD 메일 유형 코드
        emailSendSo.setReceiverId(po.getLoginId());
        emailSendSo.setReceiverNm(po.getMemberNm());
        emailSendSo.setReceiverEmail(po.getEmail());
        emailSendSo.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());

        /* 변경할 치환 코드 설정 */
        ReplaceCdVO emailReplaceVO = new ReplaceCdVO();
        emailReplaceVO.setUserId(po.getLoginId());
        emailReplaceVO.setEmail(po.getEmail());
        emailReplaceVO.setMemberNm(po.getMemberNm());
        emailReplaceVO.setMobile(po.getMobile());
        emailReplaceVO.setShopName(siteVO.getSiteNm());
        emailReplaceVO.setCustCtEmail(siteVO.getCustCtEmail());
        emailReplaceVO.setCustCtTelNo(siteVO.getCustCtTelNo());
        // replaceVO.setDlgtDomain(siteVO.getDlgtDomain());
        // emailReplaceVO.setDlgtDomain("www.davichmarket.com");
        emailReplaceVO.setDlgtDomain(SiteUtil.getExternalDomain(siteVO.getDlgtDomain()));
        emailReplaceVO.setLogoPath(siteVO.getLogoPath());

        //온라인 멤버쉽 카드번호
        Long memberCardNo = bizService.getSequence("MEMBER_CARD_NO");
        String strMemberCardNo = "33"+String.format("%07d",memberCardNo);
    	po.setMemberCardNo(strMemberCardNo);

        //온라인 카드번호 중복체크 인터페이스
        Map<String, Object> param = new HashMap<>();
        param.put("onlineCardNo", strMemberCardNo);

//        Map<String, Object> res = InterfaceUtil.send("IF_MEM_020", param);

       /* if (!"1".equals(res.get("result"))) {
            throw new CustomException("biz.exception.visit.interface");
        }
*/
//        if ("1".equals(res.get("result"))) {
//        }else{
//            throw new Exception(String.valueOf(res.get("message")));
//        }

        // 휴대폰 뒤 4자리 세팅
        if(!StringUtil.isEmpty(po.getMobile()) && po.getMobile().length() >= 4) {
        	po.setMobileSmr(po.getMobile().substring(po.getMobile().length() - 4));
        }

        // 사업자 회원 미승인 상태 처리
        if("02".equals(po.getMemberTypeCd())){
        	po.setMemberTypeCd("03");
        }

        proxyDao.insert(MapperConstants.MEMBER_INFO + "insertMember", po);

        emailSendSo.setReceiverNo(po.getMemberNo());
        emailSendSo.setMemberNo(po.getMemberNo());
        smsSendSo.setMemberNo(po.getMemberNo());
        smsSendService.sendAutoSms(smsSendSo, smsReplaceVO);
//        emailSendService.emailAutoSend(emailSendSo, emailReplaceVO);
        result.setData(po);
        result.setMessage(MessageUtil.getMessage("biz.common.insert"));
        return result;
    }

    /** 회원정보 변경서비스 **/
    @Override
    public ResultModel<MemberManagePO> updateMember(MemberManagePO po) throws Exception {
        return memberManageService.updateMemInfo(po);
    }

    /** 본인인증서비스 **/
    @Override
    public ResultModel<MemberManagePO> successIdentity(MemberManagePO po) throws Exception {
        ResultModel<MemberManagePO> result = new ResultModel<>();
        try {
            proxyDao.update(MapperConstants.MEMBER_MANAGE + "successIdentity", po);
        } catch (DuplicateKeyException e) {
            throw new CustomException("biz.exception.common.exist", new Object[] { "코드그룹" }, e);
        }
        return result;
    }

    /** 회원탈퇴 서비스 **/
    @Override
    public ResultModel<MemberManagePO> deleteMember(MemberManagePO po) throws Exception {
        return memberManageService.deleteMem(po);
    }

    /** 휴면회원해제 서비스 **/
    @Override
    public ResultModel<MemberManagePO> updateDormantMem(MemberManagePO po) throws Exception {
        return memberManageService.updateDormantMem(po);
    }
    
    /** 탈퇴회원해제 서비스 **/
    @Override
    public ResultModel<MemberManagePO> updateWithdrawalMem(MemberManagePO po) throws Exception {
        return memberManageService.updateWithdrawalMem(po);
    }

    /** 회원주소지 조회 **/
    @Override
    @Transactional(readOnly = true)
    public ResultListModel<MemberDeliveryVO> selectDeliveryListPaging(MemberDeliverySO so) {
        ResultListModel<MemberDeliveryVO> result = new ResultListModel<>();
        result = proxyDao.selectListPageWoTotal(MapperConstants.MEMBER_DELIVERY + "selectDeliveryListPaging", so);
        return result;
    }

    /** 최근 배송지 조회 **/
    @Override
    @Transactional(readOnly = true)
    public ResultModel<MemberDeliveryVO> selectRecentlyDeliveryInfo(MemberDeliverySO so) throws Exception {
        ResultModel<MemberDeliveryVO> result = new ResultModel<>();
        MemberDeliveryVO vo = proxyDao.selectOne(MapperConstants.MEMBER_DELIVERY + "selectRecentlyDeliveryInfo", so);
        // result = proxyDao.selectOne(MapperConstants.MEMBER_DELIVERY +
        // "selectRecentlyDeliveryInfo", so);
        result.setData(vo);
        return result;
    }

    /** 회원주소지 조회(단건) **/
    @Override
    @Transactional(readOnly = true)
    public ResultModel<MemberDeliveryVO> selectDeliveryDtl(MemberDeliverySO so) {
        MemberDeliveryVO vo = proxyDao.selectOne(MapperConstants.MEMBER_DELIVERY + "selectDeliveryDtl", so);
        ResultModel<MemberDeliveryVO> result = new ResultModel<>(vo);
        return result;
    }

    /** 회원주소지 등록서비스 **/
    @Override
    public ResultModel<MemberDeliveryPO> insertDelivery(MemberDeliveryPO po) throws Exception {
        ResultModel<MemberDeliveryPO> result = new ResultModel<>();
        Long memberDeliveryNo = bizService.getSequence("TC_MEMBER_DELIVERY", po.getSiteNo());
        po.setMemberDeliveryNo(memberDeliveryNo);

        int tot_cnt = proxyDao.selectOne(MapperConstants.MEMBER_DELIVERY + "selectDeliveryListPagingCount", po.getMemberNo());
        if(tot_cnt < 1){
        	po.setDefaultYn("Y");
        }
        proxyDao.insert(MapperConstants.MEMBER_DELIVERY + "insertDelivery", po);
        result.setMessage(MessageUtil.getMessage("front.web.mypage.delivery.insert"));
        return result;
    }

    /** 회원주소지 변경서비스 **/
    @Override
    public ResultModel<MemberDeliveryPO> updateDelivery(MemberDeliveryPO po) throws Exception {
        ResultModel<MemberDeliveryPO> result = new ResultModel<>();
        proxyDao.insert(MapperConstants.MEMBER_DELIVERY + "updateDelivery", po);
        result.setMessage(MessageUtil.getMessage("front.web.mypage.delivery.update"));
        return result;
    }

    /** 회원주소지 삭제서비스 **/
    @Override
    public ResultModel<MemberDeliveryPO> deleteDelivery(MemberDeliveryPO po) throws Exception {
        ResultModel<MemberDeliveryPO> result = new ResultModel<>();
        proxyDao.insert(MapperConstants.MEMBER_DELIVERY + "deleteDelivery", po);
        result.setMessage(MessageUtil.getMessage("front.web.mypage.delivery.delete"));
        return result;
    }

    /** 환불계좌 조회 **/
    @Override
    @Transactional(readOnly = true)
    public ResultModel<RefundAccountVO> selectRefundAccount(RefundAccountSO so) {
        RefundAccountVO vo = proxyDao.selectOne(MapperConstants.MEMBER_ACCOUNT + "selectRefundAccount", so);
        ResultModel<RefundAccountVO> result = new ResultModel<>(vo);
        return result;
    }

    /** 환불계좌 등록서비스 **/
    @Override
    public ResultModel<RefundAccountPO> insertRefundAccount(RefundAccountPO po) throws Exception {
        ResultModel<RefundAccountPO> result = new ResultModel<>();
        po.setRefundActSeq(bizService.getSequence("REFUND_ACT_SEQ"));
        proxyDao.insert(MapperConstants.MEMBER_ACCOUNT + "insertRefundAccount", po);
        result.setMessage(MessageUtil.getMessage("front.web.mypage.refund.insert"));
        return result;
    }

    /** 환불계좌 변경서비스 **/
    @Override
    public ResultModel<RefundAccountPO> updateRefundAccount(RefundAccountPO po) throws Exception {
        ResultModel<RefundAccountPO> result = new ResultModel<>();
        proxyDao.insert(MapperConstants.MEMBER_ACCOUNT + "updateRefundAccount", po);
        result.setMessage(MessageUtil.getMessage("front.web.mypage.refund.update"));
        return result;
    }

    /** 환불계좌 삭제서비스 **/
    @Override
    public ResultModel<RefundAccountPO> deleteRefundAccount(RefundAccountPO po) throws Exception {
        ResultModel<RefundAccountPO> result = new ResultModel<>();
        proxyDao.insert(MapperConstants.MEMBER_ACCOUNT + "deleteRefundAccount", po);
        result.setMessage(MessageUtil.getMessage("front.web.mypage.refund.delete"));
        return result;
    }

    /** 아이디 찾기 **/
    @Override
    public List<MemberManageVO> selectMemeberId(MemberManageSO so) throws CustomException {
    	List<MemberManageVO> result = proxyDao.selectList(MapperConstants.MEMBER_INFO + "selectMemeberId", so);
        return result;
    }

    /** 휴면회원 찾기 **/
    @Override
    public List<MemberManageVO> selectInactiveMember(MemberManageSO so) throws CustomException {
    	List<MemberManageVO> result = proxyDao.selectList(MapperConstants.MEMBER_INFO + "selectInactiveMember", so);
        return result;
    }

    /** 휴면회원 로그인 아이디로 찾기 **/
    @Override
    public List<MemberManageVO> selectInactiveMemberById(MemberManageSO so) throws CustomException {
    	List<MemberManageVO> result = proxyDao.selectList(MapperConstants.MEMBER_INFO + "selectInactiveMemberById", so);
        return result;
    }

    /** 인증수단목록조회 **/
    @Override
    public List<PersonCertifyConfigVO> selectCertifyList(MemberManageSO so) throws CustomException {
        List<PersonCertifyConfigVO> result = proxyDao.selectList(MapperConstants.MEMBER_INFO + "selectCertifyList", so);
        return result;
    }

    /** 비밀번호 변경 서비스 **/
    @Override
    public ResultModel<MemberManagePO> updatePwd(MemberManagePO po) throws CustomException {
        ResultModel<MemberManagePO> result = new ResultModel<>();
        Session session = SessionDetailHelper.getSession();

        // 사이트 정보
        SiteCacheVO siteCacheVO = siteService.getSiteInfo(po.getSiteNo());
        if (SessionDetailHelper.getDetails().isLogin()) {
            if (siteCacheVO.getPwChgGuideCycle() != null) {
                // 현재 로그인 회원정보
                LoginVO loginVO = new LoginVO();
                loginVO.setSiteNo(po.getSiteNo());
                loginVO.setLoginId(session.getLoginId());
                loginVO = loginService.getUser(loginVO);

                // 날짜 정보
                Calendar cal = Calendar.getInstance(Locale.KOREA);
                SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd");
                String formatNow = simpleDateFormat.format(cal.getTime());
                String formatNextDate = simpleDateFormat.format(loginVO.getNextPwChgScdDttm());
                int resultCnt = formatNow.compareTo(formatNextDate);
                if (resultCnt == 0 || resultCnt > 0) {
                    // 현재 일자 + 설정의 비밀번호 다음변경 일수
                    cal.add(Calendar.MONTH, siteCacheVO.getPwChgGuideCycle());
                    po.setNextPwChgScdDttm(cal.getTime());
                }
            }
        }

        proxyDao.insert(MapperConstants.MEMBER_INFO + "updatePwd", po);
        // result.setMessage(MessageUtil.getMessage("biz.common.insert"));
        return result;
    }

    /** 이메일 인증 서비스 **/
    @Override
    public ResultModel<MemberManageVO> checkEmailCertify(MemberManageSO so) throws CustomException {
        ResultModel<MemberManageVO> result = new ResultModel<>();
        // proxyDao.insert(MapperConstants.MEMBER_INFO+"updatePwd", so);
        // result.setMessage(MessageUtil.getMessage("biz.common.insert"));
        return result;
    }

    /** 15일이내 소멸 마켓포인트 조회 서비스 **/
    @Override
    public ResultModel<SavedmnPointVO> selectExtinctionSavedMn(SavedmnPointSO so) throws Exception {
        SavedmnPointVO vo = proxyDao.selectOne(MapperConstants.SAVEDMN_POINT + "selectExtinctionSavedMn", so);
        ResultModel<SavedmnPointVO> result = new ResultModel<>(vo);
        return result;
    }

    /** 15일이내 소멸 포인트 조회 서비스 (모바일) **/
    @Override
    public ResultModel<SavedmnPointVO> selectExtinctionPoint(SavedmnPointSO so) throws Exception {
        SavedmnPointVO vo = proxyDao.selectOne(MapperConstants.SAVEDMN_POINT + "selectExtinctionPoint", so);
        ResultModel<SavedmnPointVO> result = new ResultModel<>(vo);
        return result;
    }

    /** 아이디 중복확인 서비스 **/
    public int checkDuplicationId(MemberManageSO so) throws CustomException {
        int result = 0;

        /* 가입불가 아이디 체크 */
        String[] checkId = { "admin", "administration", "administer", "master", "webmaster", "manage", "manager" };
        Boolean checkExe = true;
        for (String ex : checkId) {
            if (ex.equalsIgnoreCase(so.getLoginId())) {
                checkExe = false;
                result = 1;
            }
            log.debug("checkExe : " + checkExe);
        }
        /* 가입불가 아이디 체크 */

        if (checkExe) {
            result = proxyDao.selectOne(MapperConstants.MEMBER_INFO + "checkDuplicationId", so);
        }

        return result;
    }

    /** 휴대전화 중복확인 서비스 **/
    public int checkDuplicationMobile(MemberManagePO po) throws CustomException {
        return proxyDao.selectOne(MapperConstants.MEMBER_INFO + "checkDuplicationMobile", po);
    }

    /** 회원 중복확인 서비스 **/
    public List<MemberManageVO> checkDuplicationMem(MemberManageSO so) throws CustomException {
        return proxyDao.selectList(MapperConstants.MEMBER_INFO + "checkDuplicationMem", so);
    }

    /** 사업자번호 중복확인 서비스 **/
    public int checkDuplicationBizNo(MemberManageSO so) throws CustomException {
        return proxyDao.selectOne(MapperConstants.MEMBER_INFO + "checkDuplicationBizNo", so);
    }

    /** 휴면회원 복구시 DI 값으로 회원정보 조회 **/
    public MemberManageVO selectDormantMemberNo(MemberManageSO so) throws CustomException {
        MemberManageVO result = new MemberManageVO();
        result = proxyDao.selectOne(MapperConstants.MEMBER_INFO + "selectDormantMemberNo", so);
        return result;
    }
    
    /** 탈퇴회원 복구시 DI 값으로 회원정보 조회 **/
    public MemberManageVO selectWithdrawalMemberNo(MemberManageSO so) throws CustomException {
        MemberManageVO result = new MemberManageVO();
        result = proxyDao.selectOne(MapperConstants.MEMBER_INFO + "selectWithdrawalMemberNo", so);
        return result;
    }

    /** 회원가입 이메일인증 키 저장**/
    @Override
    public ResultModel<MemberManagePO> createAuthKey(MemberManagePO po) throws Exception {
        int cnt  = proxyDao.update(MapperConstants.MEMBER_INFO + "insertAuthEmail", po);
        ResultModel resultModel = new ResultModel<>();

        if (cnt > 0) {
            resultModel.setSuccess(true);
        } else {
            throw new RuntimeException("이메일 인증번호 발송 실패 하였습니다.<br/>관리자에게 문의하여 주십시오.");
        }
        return resultModel;
    }

    @Override
    public ResultModel<MemberManageVO> selectEmailAuthKey(MemberManageSO so) {
    	ResultModel<MemberManageVO> result = null;
        MemberManageVO vo = proxyDao.selectOne(MapperConstants.MEMBER_INFO + "getEmailAuthKey", so);

        if(vo!=null) {
            vo.setAuthDate(DateUtil.addMinute(vo.getAuthDate(), "yyyy.MM.dd a hh:mm:ss", 30));
            result = new ResultModel<>(vo);
        }

        return result;
    }
    @Override
    public int deleteEmailAuthKey(MemberManageSO so) {
        return proxyDao.delete(MapperConstants.MEMBER_INFO + "deleteAuthKey", so);
    }

    @Override
    public int updateCustomStore(MemberManagePO po) throws Exception {
    	return proxyDao.update(MapperConstants.MEMBER_MANAGE_DORMANT + "updateCustomStore", po);
    }

	@Override
	public ResultModel<MemberManagePO> updateMemberIntegration(MemberManagePO po) throws Exception {
		ResultModel<MemberManagePO> result = new ResultModel<>();

		try {

            Map<String, Object> param = new HashMap<>();
        	param.put("memNo", po.getMemberNo());
        	param.put("cdCust", po.getCdCust());
        	param.put("lvl", po.getLvl());
        	param.put("onlineCardNo", po.getOnlineCardNo());

            Map<String, Object> res = InterfaceUtil.send("IF_MEM_003", param);
            if (!"1".equals((String) res.get("result"))) {
            	result.setSuccess(false);
            	result.setMessage(res.get("message").toString());
            }else{
            	proxyDao.update(MapperConstants.MEMBER_INFO + "updateMemberIntegration", po);

            	// session의 통합회원구분코드 변경
                DmallSessionDetails details = SessionDetailHelper.getDetails();
                Session session = details.getSession();
                session.setIntegrationMemberGbCd("03");
                details.setSession(session);

                SiteCacheVO siteCacheVO = siteService.getSiteInfo(po.getSiteNo());

                // 쿠키에 변경사항 반영
                if (siteCacheVO.getAutoLogoutTime() == 0) {
                    // 자동로그아웃 미설정 시는 세션 쿠키
                    SessionDetailHelper.setDetailsToCookie(details, -1);
                } else {
                    SessionDetailHelper.setDetailsToCookie(details, siteCacheVO.getAutoLogoutTime() * 60);
                }

                // 멤버쉽 통합 SMS 발송
                try {

                SmsSendSO smsSendSo = new SmsSendSO();
                smsSendSo.setTemplateCode("mk007");
                smsSendSo.setSendTypeCd("23");

                smsSendSo.setReceiverId(SessionDetailHelper.getDetails().getSession().getLoginId());
                smsSendSo.setReceiverNm(SessionDetailHelper.getDetails().getSession().getMemberNm());
                smsSendSo.setRecvTelno(SessionDetailHelper.getDetails().getSession().getMobile());
                smsSendSo.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
                smsSendSo.setMemberNo(po.getMemberNo());

                ReplaceCdVO smsReplaceVO = new ReplaceCdVO();
                smsReplaceVO.setMemberNm(SessionDetailHelper.getDetails().getSession().getMemberNm());

                smsSendService.sendAutoSms(smsSendSo, smsReplaceVO);

                }catch (Exception e){
                     log.debug("멤버쉽 통합 SMS 전송 실패 {}" +  e.getMessage());
                }

            }

        } catch (DuplicateKeyException e) {
            throw new CustomException("biz.exception.common.error", new Object[] { "코드그룹" }, e);
        }

        return result;
	}

	@Override
	public String checkRecomMemberId(MemberManageSO so) throws Exception {
		String result = "";

		result = proxyDao.selectOne(MapperConstants.MEMBER_INFO + "checkRecomMemberId", so);

        return result;
	}


	@Override
    @Transactional(propagation= Propagation.REQUIRES_NEW)
	public ResultModel<MemberManagePO> updateAppInfoCollect(MemberManagePO po) throws Exception {
		ResultModel<MemberManagePO> result = new ResultModel<>();

        SiteCacheVO siteCacheVO = siteService.getSiteInfo(po.getSiteNo());

		if ("1".equals(po.getAutoLoginGb())) {
            SessionDetailHelper.setDetailsToCookie(SessionDetailHelper.getDetails(), 365 * 24 * 60 * 60);
		} else if ("0".equals(po.getAutoLoginGb())) {
            SessionDetailHelper.setDetailsToCookie(SessionDetailHelper.getDetails(), siteCacheVO.getAutoLogoutTime() * 60);
		}

		if(po.getAppToken() != null && !"".equals(po.getAppToken())) {
			proxyDao.update(MapperConstants.MEMBER_INFO + "updateAppToken", po);
		}

    	proxyDao.update(MapperConstants.MEMBER_INFO + "updateAppInfo", po);

        return result;
	}


    public AppLogPO selectAppLoginInfo(AppLogPO po) throws CustomException {
        return proxyDao.selectOne(MapperConstants.MEMBER_MANAGE_DORMANT + "selectAppLoginInfo", po);
    }


    @Override
    public int insertAppLoginInfo(AppLogPO po) throws Exception {
    	return proxyDao.update(MapperConstants.MEMBER_MANAGE_DORMANT + "insertAppLoginInfo", po);
    }

    public int updateAppLoginInfo(AppLogPO po) throws Exception {
    	return proxyDao.update(MapperConstants.MEMBER_MANAGE_DORMANT + "updateAppLoginInfo", po);
    }

    public int deleteAppLoginInfo(AppLogPO po) throws Exception {
    	return proxyDao.update(MapperConstants.MEMBER_MANAGE_DORMANT + "deleteAppLoginInfo", po);
    }

    public MemberManagePO selectAppInfo(MemberManageSO so) throws CustomException {
        return proxyDao.selectOne(MapperConstants.MEMBER_INFO + "selectAppInfo", so);
    }

	@Override
	public void updateAppFirstLogin(MemberManagePO po) throws Exception {
		proxyDao.update(MapperConstants.MEMBER_INFO + "updateAppFirstLogin", po);

	}

	@Override
	public void updateAppPushAgree(MemberManagePO po) throws Exception {
		proxyDao.update(MapperConstants.MEMBER_INFO + "updateAppPushAgree", po);
	}

	@Override
	public void updateTermsApply(MemberManagePO po) throws Exception {
        if(po.getMemberCardNo()!=null && !po.getMemberCardNo().equals("")) {
            proxyDao.update(MapperConstants.MEMBER_INFO + "updateTermsApply", po);
        }
        if(po.getKeyData()!=null && !po.getKeyData().equals("")) {
            proxyDao.update(MapperConstants.MEMBER_INFO + "updateTermsApplyForErp", po);
        }
	}

    @Override
    public ResultModel<MemberManagePO> updateCertify(MemberManagePO po) throws Exception {
        ResultModel<MemberManagePO> result = new ResultModel<>();
        proxyDao.update(MapperConstants.MEMBER_INFO + "updateCertify", po);
        return result;
    }

    @Override
    public ResultListModel<MemberManageVO> selectPushListPaging(MemberManageSO so) {
        if (so.getSidx().length() == 0) {
            so.setSidx("INPUT_DATE");
            so.setSord("DESC");
            so.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
        }
        so.setRows(15);
        return proxyDao.selectListPage(MapperConstants.MEMBER_INFO + "selectPushListPaging", so);
    }

    @Override
    public ResultListModel<MemberManageVO> selectMarketPushListPaging(MemberManageSO so) {
        if (so.getSidx().length() == 0) {
            so.setSidx("SEND_DTTM");
            so.setSord("DESC");
            so.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
        }

        so.setRows(15);
        return proxyPushDao.selectListPage(MapperConstants.PUSH + "selectMarketPushListPaging", so);
    }
    
    
    @Override
    public ResultListModel<MemberManageVO> selectStorePushListPaging(MemberManageSO so) {
        if (so.getSidx().length() == 0) {
            so.setSidx("INPUT_DATE");
            so.setSord("DESC");
            so.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
        }
        so.setRows(15);
        return proxyStorePushDao.selectListPage(MapperConstants.PUSH + "selectStorePushListPaging", so);
    }
    
    @Override
    public int selectNewMarketPushCnt(MemberManageSO so) {
        return proxyPushDao.selectOne(MapperConstants.PUSH + "selectNewMarketPushCnt", so);
    }
    
    @Override
    public int selectNewStorePushCnt(MemberManageSO so) {
        return proxyStorePushDao.selectOne(MapperConstants.PUSH + "selectNewStorePushCnt", so);
    }
    
    @Override
	public String selectStrName(String strCode) {
        return proxyDao.selectOne(MapperConstants.MEMBER_INFO + "selectStrName", strCode);
	}
    
    @Override
    public ResultModel<MemberManageVO> insertPushMessageConfirm(MemberManagePO po) throws Exception {
        ResultModel<MemberManageVO> result = new ResultModel<>();
        int resultCnt = 0;
        if("market".equals(po.getPushType())) {
        	resultCnt = proxyPushDao.insert(MapperConstants.PUSH + "insertMarketPushMessageConfirm", po);
        }else if("store".equals(po.getPushType())) {
        	resultCnt = proxyStorePushDao.insert(MapperConstants.PUSH + "insertStorePushMessageConfirm", po);
        }
        
        if(resultCnt > 0) {
        	result.setSuccess(true);
        }else {
        	result.setSuccess(false);
        }
        
        return result;
    }


    @Override
    @Transactional(readOnly = true)
    public ResultListModel<MemberManageVO> selectBibiemWarrantyList(MemberManageSO so) {
        ResultListModel<MemberManageVO> list = proxyDao.selectListPage(MapperConstants.MEMBER_INFO + "selectBibiemWarrantyList", so);
        return list;
    }
}
