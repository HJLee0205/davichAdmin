package net.danvi.dmall.biz.app.member.manage.service;

import java.io.File;
import java.text.SimpleDateFormat;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.annotation.Resource;
import javax.mail.MessagingException;
import javax.mail.internet.AddressException;
import javax.servlet.http.HttpServletRequest;

import net.danvi.dmall.biz.app.member.manage.model.*;
import net.danvi.dmall.biz.ifapi.mem.dto.MemberDPointCtVO;
import net.danvi.dmall.biz.ifapi.mem.service.ErpMemberService;
import net.danvi.dmall.biz.ifapi.mem.service.ErpPointService;
import org.apache.commons.lang.StringUtils;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.dao.DuplicateKeyException;
import org.springframework.security.web.context.HttpRequestResponseHolder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import com.google.common.collect.Maps;

import dmall.framework.common.BaseService;
import dmall.framework.common.constants.MapperConstants;
import dmall.framework.common.constants.UploadConstants;
import dmall.framework.common.exception.CustomException;
import dmall.framework.common.model.FileVO;
import dmall.framework.common.model.ResultListModel;
import dmall.framework.common.model.ResultModel;
import dmall.framework.common.util.CryptoUtil;
import dmall.framework.common.util.MessageUtil;
import dmall.framework.common.util.SiteUtil;
import dmall.framework.common.util.StringUtil;
import lombok.extern.slf4j.Slf4j;
import net.danvi.dmall.biz.app.operation.model.AtchFilePO;
import net.danvi.dmall.biz.app.operation.model.EmailSendSO;
import net.danvi.dmall.biz.app.operation.model.ReplaceCdVO;
import net.danvi.dmall.biz.app.operation.model.SmsSendSO;
import net.danvi.dmall.biz.app.operation.service.EmailSendService;
import net.danvi.dmall.biz.app.operation.service.SavedMnPointService;
import net.danvi.dmall.biz.app.operation.service.SmsSendService;
import net.danvi.dmall.biz.app.order.manage.model.OrderSO;
import net.danvi.dmall.biz.app.order.manage.model.OrderVO;
import net.danvi.dmall.biz.app.order.manage.service.OrderService;
import net.danvi.dmall.biz.app.promotion.coupon.service.CouponService;
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
import net.danvi.dmall.biz.system.util.JsonMapperUtil;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 5. 3.
 * 작성자     : kjw
 * 설명       : 회원 정보 관리 컴포넌트의 구현 클래스
 * </pre>
 */
@Slf4j
@Service("memberManageService")
@Transactional(rollbackFor = Exception.class)
public class MemberManageServiceImpl extends BaseService implements MemberManageService {

    @Resource(name = "orderService")
    private OrderService orderService;

    @Resource(name = "couponService")
    private CouponService couponService;

    @Resource(name = "savedMnPointService")
    private SavedMnPointService savedMnPointService;

    @Resource(name = "siteService")
    private SiteService siteService;

    @Resource(name = "emailSendService")
    private EmailSendService emailSendService;

    @Resource(name = "smsSendService")
    private SmsSendService smsSendService;

    @Resource(name = "loginService")
    private LoginService loginService;
    
    @Resource(name = "bizService")
    private BizService bizService;
    
    @Resource(name = "sqlSessionTemplate")
    private SqlSessionTemplate sqlSessionTemplate;

    @Resource(name = "erpPointService")
    private ErpPointService erpPointService;

    @Resource(name = "erpMemberService")
    private ErpMemberService erpMemberService;

    @Override
    @Transactional(readOnly = true)
    public ResultListModel<MemberManageVO> viewMemListPaging(MemberManageSO memberManageSO) {

        memberManageSO.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());

        // 회원상태코드 set(일반:01, 휴면:02, 탈퇴:03)
        memberManageSO.setMemberStatusCd("01");

        if (("all").equals(memberManageSO.getSearchType())) {
            memberManageSO.setSearchName(memberManageSO.getSearchWords());
            memberManageSO.setSearchMobile(memberManageSO.getSearchWords());
            memberManageSO.setSearchLoginId(memberManageSO.getSearchWords());
            memberManageSO.setSearchEmail(memberManageSO.getSearchWords());
            memberManageSO.setSearchMemberNo(memberManageSO.getSearchWords());
            memberManageSO.setSearchNn(memberManageSO.getSearchWords());
        } else if (("name").equals(memberManageSO.getSearchType())) {
            memberManageSO.setSearchName(memberManageSO.getSearchWords());
        } else if (("mobile").equals(memberManageSO.getSearchType())) {
            memberManageSO.setSearchMobile(memberManageSO.getSearchWords());
        } else if (("id").equals(memberManageSO.getSearchType())) {
            memberManageSO.setSearchLoginId(memberManageSO.getSearchWords());
        } else if (("email").equals(memberManageSO.getSearchType())) {
            memberManageSO.setSearchEmail(memberManageSO.getSearchWords());
        } else if (("memberNo").equals(memberManageSO.getSearchType())) {
            memberManageSO.setSearchMemberNo(memberManageSO.getSearchWords());
        } else if (("nickname").equals(memberManageSO.getSearchType())) {
            memberManageSO.setSearchNn(memberManageSO.getSearchWords());
        }

        if (memberManageSO.getSidx().length() == 0) {
            memberManageSO.setSidx("REG_DTTM");
            memberManageSO.setSord("DESC");
        }

        return proxyDao.selectListPage(MapperConstants.MEMBER_MANAGE + "selectMemListPaging", memberManageSO);
    }

    @Override
    @Transactional(readOnly = true)
    public List<MemberManageVO> viewMemListCommon(MemberManageSO memberManageSO) {

        memberManageSO.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());

        // 회원상태코드 set(일반:01, 휴면:02, 탈퇴:03)
        memberManageSO.setMemberStatusCd("01");

        if (("all").equals(memberManageSO.getSearchType())) {
            memberManageSO.setSearchName(memberManageSO.getSearchWords());
            memberManageSO.setSearchMobile(memberManageSO.getSearchWords());
            memberManageSO.setSearchLoginId(memberManageSO.getSearchWords());
            memberManageSO.setSearchEmail(memberManageSO.getSearchWords());
            memberManageSO.setSearchMemberNo(memberManageSO.getSearchWords());
            memberManageSO.setSearchNn(memberManageSO.getSearchWords());
        } else if (("name").equals(memberManageSO.getSearchType())) {
            memberManageSO.setSearchName(memberManageSO.getSearchWords());
        } else if (("mobile").equals(memberManageSO.getSearchType())) {
            memberManageSO.setSearchMobile(memberManageSO.getSearchWords());
        } else if (("id").equals(memberManageSO.getSearchType())) {
            memberManageSO.setSearchLoginId(memberManageSO.getSearchWords());
        } else if (("email").equals(memberManageSO.getSearchType())) {
            memberManageSO.setSearchEmail(memberManageSO.getSearchWords());
        } else if (("memberNo").equals(memberManageSO.getSearchType())) {
            memberManageSO.setSearchMemberNo(memberManageSO.getSearchWords());
        } else if (("nickname").equals(memberManageSO.getSearchType())) {
            memberManageSO.setSearchNn(memberManageSO.getSearchWords());
        }

        if (memberManageSO.getSidx().length() == 0) {
            memberManageSO.setSidx("REG_DTTM");
            memberManageSO.setSord("ASC");
        }

        return proxyDao.selectList(MapperConstants.MEMBER_MANAGE + "selectMemListPaging", memberManageSO);
    }
    @Override
    public ResultModel<MemberManagePO> deleteMem(MemberManagePO po) {
        ResultModel<MemberManagePO> result = new ResultModel<>();

        po.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());

        // 진행중인 주문 검증
        String[] ordDtlStatusCd = { "20", "23", "30", "40", "50", "60", "62", "70", "72" };
        OrderSO orderSO = new OrderSO();
        orderSO.setSiteNo(po.getSiteNo());
        orderSO.setMemberNo(po.getMemberNo());
        orderSO.setOrdDtlStatusCd(ordDtlStatusCd);
        ResultModel<OrderVO> ordResult = orderService.selectStatusOrderCount(orderSO);
        int orderCnt = Integer.parseInt(ordResult.getData().getStatusOrderCount());

        if (orderCnt > 0) {
            throw new CustomException("biz.memberManage.existOrder", new Object[] { "코드그룹" });
        }

        try {
            // 회원정보 조회
            MemberManageVO memberManageVO = proxyDao.selectOne(MapperConstants.MEMBER_MANAGE + "viewMemInfoDtl", po);
            if(memberManageVO != null && StringUtil.isNotEmpty(memberManageVO.getErpMemberNo())) {
                // 회원탈퇴 포인트 소멸
                MemberDPointCtVO memberDPointCtVO = new MemberDPointCtVO();
                memberDPointCtVO.setCdCust(memberManageVO.getErpMemberNo());
                memberDPointCtVO.setMemberCardNo(memberManageVO.getMemberCardNo());
                memberDPointCtVO.setMemberNo(memberManageVO.getMemberNo());
                memberDPointCtVO.setStrCode(memberManageVO.getStrCode());
                erpPointService.MemberLeaveDeletePoint(memberDPointCtVO);

                // 매핑 정보 삭제
                /**
                 * 2023-07-20 210
                 * 맵핑정보를 분리로 바꾸는건 탈퇴할때 처리 안해도됨
                 * 어차피 탈퇴고 다시 가입하더라도 멤버 번호가바뀌기때문에 기존 탈퇴 한 맵핑 정보는 앞으로 쓸일이 없기때문에 나둬도 무방하지만
                 * 그냥 해줌
                 * **/
                erpPointService.deleteMemberMapByMall(Long.toString(po.getMemberNo()));
            }

            // 회원상태코드(탈퇴:03)
            po.setMemberStatusCd("03");
            // 탈퇴유형코드(강제 탈퇴 : 02)
            po.setWithdrawalTypeCd("02");
            // 탈퇴사유코드(강제 탈퇴 : 01)
            po.setWithdrawalReasonCd("01");
            // 기타탈퇴사유
            po.setEtcWithdrawalReason("강제탈퇴");

            // 01.보유쿠폰삭제
            couponService.deleteMemberCoupon(po);
            // 02.마켓포인트삭제
            savedMnPointService.deleteSavedMn(po);
            // 03.탈퇴회원테이블추가
            proxyDao.insert(MapperConstants.MEMBER_MANAGE + "deleteMem", po);
            // 04.회원테이블 탈퇴처리
            proxyDao.update(MapperConstants.MEMBER_MANAGE + "updateWithdrawalMemInfo", po);
            // 05.SMS 전송
//            SiteSO siteSo = new SiteSO();
//            siteSo.setSiteNo(po.getSiteNo());
//            SiteVO siteVO = proxyDao.selectOne(MapperConstants.SETUP_SITE_INFO + "selectSiteInfo", siteSo);

            // sms 치환코드 set
            ReplaceCdVO smsReplaceVO = new ReplaceCdVO();

            // sms send 객체 set
            SmsSendSO smsSendSo = new SmsSendSO();
            smsSendSo.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
            smsSendSo.setSendTypeCd("02"); // SMS 메일 유형 코드 참조
            smsSendSo.setMemberNo(memberManageVO.getMemberNo());
            smsSendSo.setMemberTemplateCode("mk014");

            smsSendService.sendAutoSms(smsSendSo, smsReplaceVO);

            if(/*"03".equals(memberManageVO.getIntegrationMemberGbCd()) && */!StringUtils.isEmpty(memberManageVO.getErpMemberNo())) {
                if(StringUtils.isEmpty(memberManageVO.getStrCode())) {
                    memberManageVO.setStrCode("0000");
                }
                LocalDateTime now = LocalDateTime.now();
                String formateNow = now.format(DateTimeFormatter.ofPattern("yyyyMMdd"));
                Map erpleaveseqparam = new HashMap();
                erpleaveseqparam.put("ls_ymd", formateNow);
                erpleaveseqparam.put("ls_str_code", memberManageVO.getStrCode());
                Integer erpmaxseq = erpMemberService.selectOfflineLeaveMemberSeq(erpleaveseqparam);
                if(erpmaxseq == null) {
                    erpmaxseq = 1;
                } else {
                    erpmaxseq += 1;
                }
                erpleaveseqparam.put("ls_ymd",formateNow);
                erpleaveseqparam.put("ls_str_code",po.getStoreNo());
                erpleaveseqparam.put("ll_seq",erpmaxseq);
                erpleaveseqparam.put("ls_emp", po.getStrCode());
                erpleaveseqparam.put("ls_cd_cust", memberManageVO.getErpMemberNo());
                erpleaveseqparam.put("ls_comments", po.getEtcWithdrawalReason());
                erpleaveseqparam.put("ls_check_flg", "0");
                erpleaveseqparam.put("ls_pop_ret", "Y");
                erpleaveseqparam.put("ls_point_del", "Y");
                erpleaveseqparam.put("is_in_type", "1");
                Integer erpInset = erpMemberService.insertOfflineLeaveMember(erpleaveseqparam);
            }
        } catch (Exception e) {
            throw new CustomException("biz.exception.common.error", new Object[] { "코드그룹" }, e);
        }
        return result;
    }

    @Override
    public ResultModel<MemberManagePO> confirmMemInfo(MemberManagePO po) throws Exception {
        ResultModel<MemberManagePO> result = new ResultModel<>();

        try {
            po.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
            
            proxyDao.update(MapperConstants.MEMBER_MANAGE + "confirmMemInfo", po);

        } catch (DuplicateKeyException e) {
            throw new CustomException("biz.exception.common.error", new Object[] { "코드그룹" }, e);
        }

        return result;
    }
    
    @Override
    public ResultModel<MemberManagePO> updateMemInfo(MemberManagePO po) throws Exception {
        ResultModel<MemberManagePO> result = new ResultModel<>();

        try {
            po.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
            if (po.getBirth() != null && po.getBirth() != "") {
                po.setBirth(po.getBirth().replaceAll("[^0-9]", ""));
            }
            
            // 정회원 전환 시 온라인 멤버쉽 카드번호 세팅
            if("02".equals(po.getIntegrationMemberGbCd())){
            	Long memberCardNo = bizService.getSequence("MEMBER_CARD_NO");
            	String strMemberCardNo = "33"+String.format("%07d",memberCardNo);
            	po.setMemberCardNo(strMemberCardNo);


                //온라인 카드번호 중복체크 인터페이스
                Map<String, Object> param = new HashMap<>();
                param.put("onlineCardNo", strMemberCardNo);

                Map<String, Object> res = InterfaceUtil.send("IF_MEM_020", param);

                /*if (!"1".equals(res.get("result"))) {
                    throw new CustomException("biz.exception.visit.interface");
                }*/
                if ("1".equals(res.get("result"))) {
                }else{
                    throw new Exception(String.valueOf(res.get("message")));
                }
            }
            
            // 휴대폰 뒤 4자리 세팅
            if(!StringUtil.isEmpty(po.getMobile()) && po.getMobile().length() >= 4) {
            	po.setMobileSmr(po.getMobile().substring(po.getMobile().length() - 4));
            }
            
            String loginId = "";
            if("Y".equals(po.getIdChgYn()) && !StringUtil.isEmpty(po.getChgId()) && !"".equals(po.getChgId())) {
            	loginId = po.getChgId();
            }

            proxyDao.update(MapperConstants.MEMBER_MANAGE + "updateMemInfo", po);
            
            if("Y".equals(po.getIdChgYn())) {
            	po.setLoginId(po.getChgId());
            }

//            this.sqlSessionTemplate.update(MapperConstants.MEMBER_MANAGE + "insertMemInfoHis", po);
            
            /*if (po.getPw() != null && po.getPw() != "") {
                updateChangePwNext(po);
            }*/
            
            // 아이디 변경 시 session값 변경
            if("Y".equals(po.getIdChgYn()) && !"".equals(loginId)) {
            	// session 세팅
                DmallSessionDetails details = SessionDetailHelper.getDetails();
                Session session = details.getSession();
                session.setLoginId(loginId);
                details.setSession(session);           
                
                SiteCacheVO siteCacheVO = siteService.getSiteInfo(po.getSiteNo());

                // 쿠키에 변경사항 반영
                if (siteCacheVO.getAutoLogoutTime() == 0) {
                    // 자동로그아웃 미설정 시는 세션 쿠키
                    SessionDetailHelper.setDetailsToCookie(details, -1);
                } else {
                    SessionDetailHelper.setDetailsToCookie(details, siteCacheVO.getAutoLogoutTime() * 60);
                }
                
                HttpServletRequest request;
                request = ((ServletRequestAttributes) RequestContextHolder.currentRequestAttributes()).getRequest();
                
                AppLogPO app = new AppLogPO();
                String jsessionid = request.getSession().getId();
                app.setJsessionid(jsessionid);
                app.setCookieVal(CryptoUtil.encryptAES(JsonMapperUtil.getMapper().writeValueAsString(details)));
                proxyDao.update(MapperConstants.MEMBER_MANAGE_DORMANT + "updateAppCookieInfo", app);
            }
            
            // 이름 변경 시 session값 변경
            if(po.getChgMemberNm() != null && !"".equals(po.getChgMemberNm())) {
            	DmallSessionDetails details = SessionDetailHelper.getDetails();
            	Session session = details.getSession();
            	session.setMemberNm(po.getChgMemberNm());
            	details.setSession(session); 
            	
            	SiteCacheVO siteCacheVO = siteService.getSiteInfo(po.getSiteNo());

                // 쿠키에 변경사항 반영
                if (siteCacheVO.getAutoLogoutTime() == 0) {
                    // 자동로그아웃 미설정 시는 세션 쿠키
                    SessionDetailHelper.setDetailsToCookie(details, -1);
                } else {
                    SessionDetailHelper.setDetailsToCookie(details, siteCacheVO.getAutoLogoutTime() * 60);
                }
                
                HttpServletRequest request;
                request = ((ServletRequestAttributes) RequestContextHolder.currentRequestAttributes()).getRequest();
                
                AppLogPO app = new AppLogPO();
                String jsessionid = request.getSession().getId();
                app.setJsessionid(jsessionid);
                app.setCookieVal(CryptoUtil.encryptAES(JsonMapperUtil.getMapper().writeValueAsString(details)));
                proxyDao.update(MapperConstants.MEMBER_MANAGE_DORMANT + "updateAppCookieInfo", app);
            }
            
            // 정회원 전환 시 session의 통합회원구분코드 변경
            if("02".equals(po.getIntegrationMemberGbCd())){
            	// session 세팅
                DmallSessionDetails details = SessionDetailHelper.getDetails();
                Session session = details.getSession();
                session.setIntegrationMemberGbCd("01");
                session.setMemberCardNo(po.getMemberCardNo());
                details.setSession(session);           
                
                SiteCacheVO siteCacheVO = siteService.getSiteInfo(po.getSiteNo());

                // 쿠키에 변경사항 반영
                if (siteCacheVO.getAutoLogoutTime() == 0) {
                    // 자동로그아웃 미설정 시는 세션 쿠키
                    SessionDetailHelper.setDetailsToCookie(details, -1);
                } else {
                    SessionDetailHelper.setDetailsToCookie(details, siteCacheVO.getAutoLogoutTime() * 60);
                }
                
                HttpServletRequest request;
                request = ((ServletRequestAttributes) RequestContextHolder.currentRequestAttributes()).getRequest();
                
                AppLogPO app = new AppLogPO();
                String jsessionid = request.getSession().getId();
                app.setJsessionid(jsessionid);
                app.setCookieVal(CryptoUtil.encryptAES(JsonMapperUtil.getMapper().writeValueAsString(details)));
                proxyDao.update(MapperConstants.MEMBER_MANAGE_DORMANT + "updateAppCookieInfo", app);
                
            }
            
        } catch (DuplicateKeyException e) {
            throw new CustomException("biz.exception.common.error", new Object[] { "코드그룹" }, e);
        }

        return result;
    }

    @Override
    @Transactional(readOnly = true)
    public ResultModel<MemberManageVO> viewMemInfoDtl(MemberManageSO memberManageSO) {

        // 마지막 로그인 정보 조회 resultModel
        ResultModel<MemberManageVO> lastLoginInfo = new ResultModel<>();

        // 회원정보 최근 수정일 resultModel
        ResultModel<MemberManageVO> lastUpdateInfo = new ResultModel<>();

        // 방문횟수 resultModel
        ResultModel<MemberManageVO> visetCnt = new ResultModel<>();

        // 쿠폰 갯수 resultModel
        ResultModel<MemberManageVO> memCpCnt = new ResultModel<>();

        // 마켓포인트 resultModel
        ResultModel<MemberManageVO> memSavedMn = new ResultModel<>();

        // 포인트 resultModel
        ResultModel<MemberManageVO> memPoint = new ResultModel<>();

        // 1:1문의게시판 글 갯수 resultModel
        ResultModel<MemberManageVO> memInquiryCnt = new ResultModel<>();

        // 상품문의 글 갯수 resultModel
        ResultModel<MemberManageVO> memQuestionCnt = new ResultModel<>();

        // 상품후기 글 갯수 resultModel
        ResultModel<MemberManageVO> memReviewCnt = new ResultModel<>();

        // 스탬프 resultModel
        ResultModel<MemberManageVO> memStamp = new ResultModel<>();

        MemberManageVO vo = proxyDao.selectOne(MapperConstants.MEMBER_MANAGE + "viewMemInfoDtl", memberManageSO);

        // 마지막 로그인 정보 조회
        lastLoginInfo = selectLastLoinInfo(memberManageSO);

        // 마지막 로그인 정보 데이터 set
        if (lastLoginInfo.getData() != null) {
            if (lastLoginInfo.getData().getLastLoginDttm() != null) {
                vo.setLastLoginDttm(lastLoginInfo.getData().getLastLoginDttm());
            }
            if (lastLoginInfo.getData().getLoginIp() != null) {
                vo.setLoginIp(lastLoginInfo.getData().getLoginIp());
            }
        }

        // 회원정보 최근 수정일 정보 조회
        lastUpdateInfo = selectLastUpdate(memberManageSO);

        // 회원정보 최근 수정일 정보 데이터 set
        if (lastUpdateInfo.getData() != null) {
            if (lastUpdateInfo.getData().getChgDttm() != null) {
                vo.setChgDttm(lastUpdateInfo.getData().getChgDttm());
            }
        }

        // 방문횟수 조회
        visetCnt = selectVisitCnt(memberManageSO);

        // 방문횟수 데이터 set
        if (visetCnt.getData() != null) {
            if (visetCnt.getData().getLoginCnt() != null) {
                vo.setLoginCnt(visetCnt.getData().getLoginCnt());
            }
        }

        // 쿠폰갯수 조회
        memCpCnt = selectMemCpCnt(memberManageSO);

        // 쿠폰갯수 데이터 set
        if (memCpCnt.getData() != null) {
            if (memCpCnt.getData().getCpCnt() != null) {
                vo.setCpCnt(memCpCnt.getData().getCpCnt());
            }
        }

        // 마켓포인트 조회
        memSavedMn = selectMemSaveMn(memberManageSO);

        // 마켓포인트 데이터 set
        if (memSavedMn.getData() != null) {
            if (memSavedMn.getData().getPrcAmt() != null) {
                vo.setPrcAmt(memSavedMn.getData().getPrcAmt());
            }
        }

        // 포인트 조회
        memPoint = selectMemPoint(memberManageSO);

        // 포인트 데이터 set
        if (memPoint.getData() != null) {
            if (memPoint.getData().getPrcPoint() != null) {
                vo.setPrcPoint(memPoint.getData().getPrcPoint());
            }
        }

        // 1:1문의게시판 글 갯수 조회
        memInquiryCnt = selectInquirytCnt(memberManageSO);

        // 1:1문의게시판 전체 등록 글 갯수 데이터 set
        if (memInquiryCnt.getData() != null) {
            if (memInquiryCnt.getData().getInquiryCnt() != null) {
                vo.setInquiryCnt(memInquiryCnt.getData().getInquiryCnt());
            }
        }

        // 1:1문의게시판 답변 완료 글 갯수 데이터 set
        if (memInquiryCnt.getData() != null) {
            if (memInquiryCnt.getData().getCompletInquiryCnt() != null) {
                vo.setCompletInquiryCnt(memInquiryCnt.getData().getCompletInquiryCnt());
            }
        }

        // 상품문의 글 갯수 조회
        memQuestionCnt = selectQuestionCnt(memberManageSO);

        // 상품문의 글 갯수 데이터 set
        if (memQuestionCnt.getData() != null) {
            if (memQuestionCnt.getData().getQuestionCnt() != null) {
                vo.setQuestionCnt(memQuestionCnt.getData().getQuestionCnt());
            }
        }

        // 상품후기 글 갯수 조회
        memReviewCnt = selectReviewCnt(memberManageSO);

        // 상품후기 글 갯수 데이터 set
        if (memReviewCnt.getData() != null) {
            if (memReviewCnt.getData().getReviewCnt() != null) {
                vo.setReviewCnt(memReviewCnt.getData().getReviewCnt());
            }
        }

        // 스탬프 조회
        memStamp = selectMemStamp(memberManageSO);

        // 스탬프 데이터 set
        if(memStamp.getData() != null) {
            if(memStamp.getData().getPrcStamp() != null) {
                vo.setPrcStamp(memStamp.getData().getPrcStamp());
            }
        }

        OrderSO orderSo = new OrderSO();
        orderSo.setSiteNo(memberManageSO.getSiteNo());
        orderSo.setMemberNo(memberManageSO.getMemberNo());

        // 주문금액, 주문횟수 조회
        MemberManageVO orderInfoVO = orderService.selectOrdHistbyMember(orderSo);

        // 주문횟수 데이터 set
        if (orderInfoVO.getOrdCnt() != null) {
            vo.setOrdCnt(orderInfoVO.getOrdCnt());
        }

        // 주문금액 데이터 set
        if (orderInfoVO.getSaleAmt() != null) {
            vo.setSaleAmt(orderInfoVO.getSaleAmt());
        }

        // 배송준비 건수 데이터 set
        if (orderInfoVO.getDeliveryReadyCnt() != null) {
            vo.setDeliveryReadyCnt(orderInfoVO.getDeliveryReadyCnt());
        }

        // 배송중 건수 데이터 set
        if (orderInfoVO.getDeliveryCnt() != null) {
            vo.setDeliveryCnt(orderInfoVO.getDeliveryCnt());
        }

        // 배송완료 건수 데이터 set
        if (orderInfoVO.getDeliveryCompleteCnt() != null) {
            vo.setDeliveryCompleteCnt(orderInfoVO.getDeliveryCompleteCnt());
        }

        // 맞교환 접수 건수 데이터 set
        if (orderInfoVO.getExchangeReceiptCnt() != null) {
            vo.setExchangeReceiptCnt(orderInfoVO.getExchangeReceiptCnt());
        }

        // 맞교환 완료 건수 데이터 set
        if (orderInfoVO.getExchangeCompleteCnt() != null) {
            vo.setExchangeCompleteCnt(orderInfoVO.getExchangeCompleteCnt());
        }

        // 환불 접수 건수 데이터 set
        if (orderInfoVO.getRefundReceiptCnt() != null) {
            vo.setRefundReceiptCnt(orderInfoVO.getRefundReceiptCnt());
        }

        ResultModel<MemberManageVO> result = new ResultModel<>(vo);

        return result;
    }

    @Override
    @Transactional(readOnly = true)
    public ResultModel<MemberManageVO> viewMemInfo(MemberManageSO memberManageSO) {
        MemberManageVO vo = proxyDao.selectOne(MapperConstants.MEMBER_MANAGE + "viewMemInfoDtl", memberManageSO);
        ResultModel<MemberManageVO> result = new ResultModel<>(vo);
        return result;
    }

    @Override
    @Transactional(readOnly = true)
    public ResultModel<MemberManageVO> selectLastLoinInfo(MemberManageSO memberManageSO) {
        MemberManageVO vo = new MemberManageVO();
        vo = proxyDao.selectOne(MapperConstants.MEMBER_MANAGE + "selectLastLoinInfo", memberManageSO);
        ResultModel<MemberManageVO> result = new ResultModel<>(vo);
        return result;
    }

    @Override
    @Transactional(readOnly = true)
    public ResultModel<MemberManageVO> selectLastUpdate(MemberManageSO memberManageSO) {
        MemberManageVO vo = new MemberManageVO();
        vo = proxyDao.selectOne(MapperConstants.MEMBER_MANAGE + "selectLastUpdate", memberManageSO);
        ResultModel<MemberManageVO> result = new ResultModel<>(vo);
        return result;
    }

    @Override
    @Transactional(readOnly = true)
    public ResultModel<MemberManageVO> selectMemPoint(MemberManageSO memberManageSO) {
        MemberManageVO vo = new MemberManageVO();
        vo = proxyDao.selectOne(MapperConstants.MEMBER_MANAGE + "selectMemPoint", memberManageSO);
        ResultModel<MemberManageVO> result = new ResultModel<>(vo);
        return result;
    }

    @Override
    @Transactional(readOnly = true)
    public ResultModel<MemberManageVO> selectMemSaveMn(MemberManageSO memberManageSO) {
        MemberManageVO vo = new MemberManageVO();
        vo = proxyDao.selectOne(MapperConstants.MEMBER_MANAGE + "selectMemSaveMn", memberManageSO);
        ResultModel<MemberManageVO> result = new ResultModel<>(vo);
        return result;
    }

    @Override
    @Transactional(readOnly = true)
    public ResultModel<MemberManageVO> selectMemCpCnt(MemberManageSO memberManageSO) {
        memberManageSO.setUseYn("N");
        MemberManageVO vo = new MemberManageVO();
        vo = proxyDao.selectOne(MapperConstants.MEMBER_MANAGE + "selectMemCpCnt", memberManageSO);
        ResultModel<MemberManageVO> result = new ResultModel<>(vo);
        return result;
    }

    @Override
    @Transactional(readOnly = true)
    public ResultModel<MemberManageVO> selectVisitCnt(MemberManageSO memberManageSO) {
        MemberManageVO vo = new MemberManageVO();
        vo = proxyDao.selectOne(MapperConstants.MEMBER_MANAGE + "selectVisitCnt", memberManageSO);
        ResultModel<MemberManageVO> result = new ResultModel<>(vo);
        return result;
    }

    @Override
    @Transactional(readOnly = true)
    public ResultModel<MemberManageVO> selectInquirytCnt(MemberManageSO memberManageSO) {
        MemberManageVO vo = new MemberManageVO();
        vo = proxyDao.selectOne(MapperConstants.MEMBER_MANAGE + "selectInquirytCnt", memberManageSO);
        ResultModel<MemberManageVO> result = new ResultModel<>(vo);
        return result;
    }

    @Override
    @Transactional(readOnly = true)
    public ResultModel<MemberManageVO> selectQuestionCnt(MemberManageSO memberManageSO) {
        memberManageSO.setBbsId("question");
        MemberManageVO vo = new MemberManageVO();
        vo = proxyDao.selectOne(MapperConstants.MEMBER_MANAGE + "selectQuestionCnt", memberManageSO);
        ResultModel<MemberManageVO> result = new ResultModel<>(vo);
        return result;
    }

    @Override
    @Transactional(readOnly = true)
    public ResultModel<MemberManageVO> selectReviewCnt(MemberManageSO memberManageSO) {
        memberManageSO.setBbsId("review");
        MemberManageVO vo = new MemberManageVO();
        vo = proxyDao.selectOne(MapperConstants.MEMBER_MANAGE + "selectReviewCnt", memberManageSO);
        ResultModel<MemberManageVO> result = new ResultModel<>(vo);
        return result;
    }

    @Override
    @Transactional(readOnly = true)
    public ResultModel<MemberManageVO> selectMemStamp(MemberManageSO memberManageSO) {
        MemberManageVO vo = new MemberManageVO();
        vo = proxyDao.selectOne(MapperConstants.MEMBER_MANAGE + "selectMemStamp", memberManageSO);
        ResultModel<MemberManageVO> result = new ResultModel<>(vo);
        return result;
    }

    @Override
    @Transactional(readOnly = true)
    public ResultListModel<MemberManageVO> selectDeliveryList(MemberManageSO memberManageSO) {
        ResultListModel<MemberManageVO> list = proxyDao
                .selectListPage(MapperConstants.MEMBER_MANAGE + "selectDeliveryList", memberManageSO);

        return list;
    }

    @Override
    @Transactional(readOnly = true)
    public ResultListModel<MemberManageVO> viewWithdrwMemPaging(MemberManageSO memberManageSO) {
        memberManageSO.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
        memberManageSO.setSidx("WITHDRAWAL_DTTM");
        memberManageSO.setSord("DESC");

        if (("all").equals(memberManageSO.getSearchType())) {
            memberManageSO.setSearchMobile(memberManageSO.getSearchWords());
            memberManageSO.setSearchTel(memberManageSO.getSearchWords());
            memberManageSO.setSearchName(memberManageSO.getSearchWords());
        } else if (("name").equals(memberManageSO.getSearchType())) {
            memberManageSO.setSearchName(memberManageSO.getSearchWords());
        } else if (("id").equals(memberManageSO.getSearchType())) {
            memberManageSO.setSearchLoginId(memberManageSO.getSearchWords());
        }

        return proxyDao.selectListPage(MapperConstants.MEMBER_MANAGE_WITHDRWAL + "selectWithdrawalMemberPaging",memberManageSO);
    }

    @Override
    @Transactional(readOnly = true)
    public ResultModel<MemberManageVO> viewWithdrwMemDtl(MemberManageSO memberManageSO) {
        memberManageSO.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
        MemberManageVO vo = proxyDao.selectOne(MapperConstants.MEMBER_MANAGE_WITHDRWAL + "viewWithdrawalMemberInfoDtl", memberManageSO);
        ResultModel<MemberManageVO> result = new ResultModel<>(vo);

        return result;
    }

    @Override
    @Transactional(readOnly = true)
    public ResultListModel<MemberManageVO> viewDormantMemGetPaging(MemberManageSO memberManageSO) {
        memberManageSO.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
        memberManageSO.setSidx("DORMANT_DTTM");
        memberManageSO.setSord("ASC");

        if (("all").equals(memberManageSO.getSearchType())) {
            memberManageSO.setSearchName(memberManageSO.getSearchWords());
            memberManageSO.setSearchMobile(memberManageSO.getSearchWords());
            memberManageSO.setSearchLoginId(memberManageSO.getSearchWords());
            memberManageSO.setSearchEmail(memberManageSO.getSearchWords());
        } else if (("name").equals(memberManageSO.getSearchType())) {
            memberManageSO.setSearchName(memberManageSO.getSearchWords());
        } else if (("mobile").equals(memberManageSO.getSearchType())) {
            memberManageSO.setSearchMobile(memberManageSO.getSearchWords());
        } else if (("id").equals(memberManageSO.getSearchType())) {
            memberManageSO.setSearchLoginId(memberManageSO.getSearchWords());
        } else if (("email").equals(memberManageSO.getSearchType())) {
            memberManageSO.setSearchEmail(memberManageSO.getSearchWords());
        }

        return proxyDao.selectListPage(MapperConstants.MEMBER_MANAGE_DORMANT + "selectDormantMemberPaging", memberManageSO);
    }

    @Override
    @Transactional(readOnly = true)
    public ResultModel<MemberManageVO> viewDormantMemDtl(MemberManageSO memberManageSO) {
        memberManageSO.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
        // 마지막 로그인 정보 조회 resultModel
        ResultModel<MemberManageVO> lastLoginInfo = new ResultModel<>();

        // 회원정보 최근 수정일 resultModel
        ResultModel<MemberManageVO> lastUpdateInfo = new ResultModel<>();

        // 방문횟수 resultModel
        ResultModel<MemberManageVO> visetCnt = new ResultModel<>();

        // 쿠폰 갯수 resultModel
        ResultModel<MemberManageVO> memCpCnt = new ResultModel<>();

        // 마켓포인트 resultModel
        ResultModel<MemberManageVO> memSavedMn = new ResultModel<>();

        // 포인트 resultModel
        ResultModel<MemberManageVO> memPoint = new ResultModel<>();

        // 1:1문의게시판 글 갯수 resultModel
        ResultModel<MemberManageVO> memInquiryCnt = new ResultModel<>();

        // 상품문의 글 갯수 resultModel
        ResultModel<MemberManageVO> memQuestionCnt = new ResultModel<>();

        // 상품후기 글 갯수 resultModel
        ResultModel<MemberManageVO> memReviewCnt = new ResultModel<>();

        MemberManageVO vo = proxyDao.selectOne(MapperConstants.MEMBER_MANAGE_DORMANT + "viewDormantMemberInfoDtl",
                memberManageSO);

        // 마지막 로그인 정보 조회
        lastLoginInfo = selectLastLoinInfo(memberManageSO);

        // 마지막 로그인 정보 데이터 set
        if (lastLoginInfo.getData() != null) {
            if (lastLoginInfo.getData().getLastLoginDttm() != null) {
                vo.setLastLoginDttm(lastLoginInfo.getData().getLastLoginDttm());
            }
        }

        if (lastLoginInfo.getData() != null) {
            if (lastLoginInfo.getData().getLoginIp() != null) {
                vo.setLoginIp(lastLoginInfo.getData().getLoginIp());
            }
        }

        // 회원정보 최근 수정일 정보 조회
        lastUpdateInfo = selectLastUpdate(memberManageSO);

        // 회원정보 최근 수정일 정보 데이터 set
        if (lastUpdateInfo.getData() != null) {
            if (lastUpdateInfo.getData().getChgDttm() != null) {
                vo.setChgDttm(lastUpdateInfo.getData().getChgDttm());
            }
        }

        // 방문횟수 조회
        visetCnt = selectVisitCnt(memberManageSO);

        // 방문횟수 데이터 set
        if (visetCnt.getData() != null) {
            if (visetCnt.getData().getLoginCnt() != null) {
                vo.setLoginCnt(visetCnt.getData().getLoginCnt());
            }
        }

        // 쿠폰갯수 조회
        memCpCnt = selectMemCpCnt(memberManageSO);

        // 쿠폰갯수 데이터 set
        if (memCpCnt.getData() != null) {
            if (memCpCnt.getData().getCpCnt() != null) {
                vo.setCpCnt(memCpCnt.getData().getCpCnt());
            }
        }

        // 마켓포인트 조회
        memSavedMn = selectMemSaveMn(memberManageSO);

        // 마켓포인트 데이터 set
        if (memSavedMn.getData() != null) {
            if (memSavedMn.getData().getPrcAmt() != null) {
                vo.setPrcAmt(memSavedMn.getData().getPrcAmt());
            }
        }

        // 포인트 조회
        memPoint = selectMemPoint(memberManageSO);

        // 포인트 데이터 set
        if (memPoint.getData() != null) {
            if (memPoint.getData().getPrcPoint() != null) {
                vo.setPrcPoint(memPoint.getData().getPrcPoint());
            }
        }

        // 1:1문의게시판 글 갯수 조회
        memInquiryCnt = selectInquirytCnt(memberManageSO);

        // 1:1문의게시판 전체 등록 글 갯수 데이터 set
        if (memInquiryCnt.getData() != null) {
            if (memInquiryCnt.getData().getInquiryCnt() != null) {
                vo.setInquiryCnt(memInquiryCnt.getData().getInquiryCnt());
            }
        }

        // 1:1문의게시판 답변 완료 글 갯수 데이터 set
        if (memInquiryCnt.getData() != null) {
            if (memInquiryCnt.getData().getCompletInquiryCnt() != null) {
                vo.setCompletInquiryCnt(memInquiryCnt.getData().getCompletInquiryCnt());
            }
        }

        // 상품문의 글 갯수 조회
        memQuestionCnt = selectQuestionCnt(memberManageSO);

        // 상품문의 글 갯수 데이터 set
        if (memQuestionCnt.getData() != null) {
            if (memQuestionCnt.getData().getQuestionCnt() != null) {
                vo.setQuestionCnt(memQuestionCnt.getData().getQuestionCnt());
            }
        }

        // 상품후기 글 갯수 조회
        memReviewCnt = selectReviewCnt(memberManageSO);

        // 상품후기 글 갯수 데이터 set
        if (memReviewCnt.getData() != null) {
            if (memReviewCnt.getData().getReviewCnt() != null) {
                vo.setReviewCnt(memReviewCnt.getData().getReviewCnt());
            }
        }

        OrderSO orderSo = new OrderSO();
        orderSo.setSiteNo(memberManageSO.getSiteNo());
        orderSo.setMemberNo(memberManageSO.getMemberNo());

        // 주문금액, 주문횟수 조회
        MemberManageVO orderInfoVO = orderService.selectOrdHistbyMember(orderSo);

        // 주문횟수 데이터 set
        if (orderInfoVO.getOrdCnt() != null) {
            vo.setOrdCnt(orderInfoVO.getOrdCnt());
        }

        // 주문금액 데이터 set
        if (orderInfoVO.getSaleAmt() != null) {
            vo.setSaleAmt(orderInfoVO.getSaleAmt());
        }

        ResultModel<MemberManageVO> result = new ResultModel<>(vo);

        return result;
    }

    @Override
    public ResultModel<MemberManagePO> updateDormantMem(MemberManagePO po)
            throws AddressException, MessagingException, Exception {
        ResultModel<MemberManagePO> result = new ResultModel<>();
        po.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());

        MemberManageSO so = new MemberManageSO();
        so.setMemberNo(po.getMemberNo());
        so.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());

        MemberManageVO vo = proxyDao.selectOne(MapperConstants.MEMBER_MANAGE_DORMANT + "viewDormantMemberInfoDtl", so);

        // sms 치환코드 set
        ReplaceCdVO smsReplaceVO = new ReplaceCdVO();
        smsReplaceVO.setMemberNm(vo.getMemberNm());
        smsReplaceVO.setUserId(vo.getLoginId());

        // sms send 객체 set
        SmsSendSO smsSendSo = new SmsSendSO();
        smsSendSo.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
        smsSendSo.setSendTypeCd("23"); // SMS 메일 유형 코드 참조
        smsSendSo.setMemberNo(vo.getMemberNo());
        smsSendSo.setMemberTemplateCode("mk017");

//        SiteVO siteVO = proxyDao.selectOne(MapperConstants.SETUP_SITE_INFO + "selectSiteInfo", so);
//
//        /* 변경할 치환 코드 설정 */
//        ReplaceCdVO emailReplaceVO = new ReplaceCdVO();
//        emailReplaceVO.setUserId(vo.getLoginId());
//        emailReplaceVO.setShopName(siteVO.getSiteNm());
//        emailReplaceVO.setCustCtEmail(siteVO.getCustCtEmail());
//        emailReplaceVO.setCustCtTelNo(siteVO.getCustCtTelNo());
//        // replaceVO.setDlgtDomain(siteVO.getDlgtDomain());
//        // emailReplaceVO.setDlgtDomain("www.davichmarket.com");
//        emailReplaceVO.setDlgtDomain(SiteUtil.getExternalDomain(siteVO.getDlgtDomain()));
//        emailReplaceVO.setLogoPath(siteVO.getLogoPath());
//        emailReplaceVO.setDormantDttm(df.format(today));
//
//        /* 이메일 자동 발송 기본 설정 */
//        EmailSendSO emailSendSo = new EmailSendSO();
//        emailSendSo.setMailTypeCd("04"); // ERD 메일 유형 코드 참조 ex)1:1문의 답변 코드 : 23
//        emailSendSo.setMemberNo(vo.getMemberNo());
//        emailSendSo.setReceiverNo(vo.getMemberNo());
//        emailSendSo.setReceiverId(vo.getLoginId());
//        emailSendSo.setReceiverNm(vo.getMemberNm());
//        emailSendSo.setReceiverEmail(vo.getEmail());
//        emailSendSo.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
//        emailSendSo.setRegrNo(vo.getSiteNo());

        int updateMemInfo = proxyDao.update(MapperConstants.MEMBER_MANAGE_DORMANT + "updateMemInfo", vo);

        if (updateMemInfo > 0) {
            proxyDao.delete(MapperConstants.MEMBER_MANAGE_DORMANT + "deleteDormantMem", so);
            result.setMessage(MessageUtil.getMessage("biz.memberDormant.updateMemInfo"));
//            emailSendService.emailAutoSend(emailSendSo, emailReplaceVO);
            smsSendService.sendAutoSms(smsSendSo, smsReplaceVO);
        } else {
            result.setMessage(MessageUtil.getMessage("biz.exception.common.error"));
        }

        return result;
    }
    
    @Override
    public ResultModel<MemberManagePO> updateWithdrawalMem(MemberManagePO po)
            throws AddressException, MessagingException, Exception {
        ResultModel<MemberManagePO> result = new ResultModel<>();
        po.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
        MemberManageSO so = new MemberManageSO();
        so.setMemberNo(po.getMemberNo());
        so.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm");
        Date today = new Date();
        MemberManageVO vo = proxyDao.selectOne(MapperConstants.MEMBER_MANAGE_WITHDRWAL + "viewWithdrawalMemberInfoDtl", so);
        SiteVO siteVO = proxyDao.selectOne(MapperConstants.SETUP_SITE_INFO + "selectSiteInfo", so);

        /* 변경할 치환 코드 설정 */
        /*ReplaceCdVO emailReplaceVO = new ReplaceCdVO();
        emailReplaceVO.setUserId(vo.getLoginId());
        emailReplaceVO.setShopName(siteVO.getSiteNm());
        emailReplaceVO.setCustCtEmail(siteVO.getCustCtEmail());
        emailReplaceVO.setCustCtTelNo(siteVO.getCustCtTelNo());
        // replaceVO.setDlgtDomain(siteVO.getDlgtDomain());
        // emailReplaceVO.setDlgtDomain("www.davichmarket.com");
        emailReplaceVO.setDlgtDomain(SiteUtil.getExternalDomain(siteVO.getDlgtDomain()));
        emailReplaceVO.setLogoPath(siteVO.getLogoPath());
        emailReplaceVO.setDormantDttm(df.format(today));*/

        /* 이메일 자동 발송 기본 설정 */
        /*EmailSendSO emailSendSo = new EmailSendSO();
        emailSendSo.setMailTypeCd("04"); // ERD 메일 유형 코드 참조 ex)1:1문의 답변 코드 : 23
        emailSendSo.setMemberNo(vo.getMemberNo());
        emailSendSo.setReceiverNo(vo.getMemberNo());
        emailSendSo.setReceiverId(vo.getLoginId());
        emailSendSo.setReceiverNm(vo.getMemberNm());
        emailSendSo.setReceiverEmail(vo.getEmail());
        emailSendSo.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
        emailSendSo.setRegrNo(vo.getSiteNo());*/
        Integer updateMemInfo = proxyDao.update(MapperConstants.MEMBER_MANAGE_WITHDRWAL + "updateMemInfo", vo);

        if (updateMemInfo > 0) {
            proxyDao.delete(MapperConstants.MEMBER_MANAGE_WITHDRWAL + "deleteWithdrawalMem", so);
            result.setMessage(MessageUtil.getMessage("biz.memberWithdrawal.updateMemInfo"));
            result.setSuccess(true);
            /*emailSendService.emailAutoSend(emailSendSo, emailReplaceVO);*/
        } else {
            result.setMessage(MessageUtil.getMessage("biz.exception.common.error"));
            result.setSuccess(false);
        }

        return result;
    }

    @Override
    public ResultListModel<MemberManageVO> selectCouponGetPaging(MemberManageSO so) {
        ResultListModel<MemberManageVO> list = proxyDao.selectListPage(MapperConstants.MEMBER_MANAGE + "selectCouponGetPaging", so);
        return list;
    }

    public Integer selectCouponGetPagingCount(MemberManageSO so) {
        Integer couponCount = proxyDao.selectOne(MapperConstants.MEMBER_MANAGE + "selectCouponGetPagingTotalCount", so);
        return couponCount;
    }

    @Override
    @Transactional(readOnly = true)
    public List<MemberManageVO> viewMemList(MemberManageSO memberManageSO) {
        memberManageSO.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
        memberManageSO.setMemberStatusCd("01");
        List<MemberManageVO> list = proxyDao.selectList(MapperConstants.MEMBER_MANAGE + "selectMemList",memberManageSO);
        return list;
    }

    @Override
    public String selectAdmin(MemberManageSO so) {
        String adminNo = proxyDao.selectOne(MapperConstants.MEMBER_MANAGE + "selectAdmin", so);
        return adminNo;
    }

    @Override
    @Transactional(readOnly = true)
    public List<MemberManageVO> selectLog(MemberManageSO memberManageSO) {
        List<MemberManageVO> list = proxyDao.selectList(MapperConstants.MEMBER_MANAGE + "selectLog", memberManageSO);

        for (MemberManageVO memberManageVO : list) {
            memberManageVO.setPrcNm("[" + memberManageVO.getAuthNm() + "] [" + memberManageVO.getLoginId() + "]");
        }

        return list;
    }

    @Override
    public void updateChangePwNext(MemberManagePO po) {
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
            /*loginVO.setLoginId(po.getLoginId());*/
            loginVO = loginService.getUser(loginVO);

            // 회원의 다음 비밀번호 변경 일수 적용(회원의 다음변경 일수 + 설정의 다음변경 일수)
            if ("".equals(loginVO.getNextPwChgScdDttm()) || loginVO.getNextPwChgScdDttm() == null) {
                Calendar today = Calendar.getInstance(Locale.KOREA);
                today.add(Calendar.MONTH, 6);
                cal.setTime(today.getTime());
            } else {
                cal.setTime(loginVO.getNextPwChgScdDttm());
            }
            cal.add(Calendar.DATE, siteCacheVO.getPwChgNextChgDcnt());
            po.setNextPwChgScdDttm(cal.getTime());
        }
        po.setUpdrNo(session.getMemberNo());
        proxyDao.update(MapperConstants.SYSTEM_LOGIN + "updateChangePwNext", po);
    }

    @Override
    public void updateRecvRjtYnMemInfo(String[] memberTelnoTarget) {
        Map<String, String[]> paramMap = Maps.newHashMap();
        paramMap.put("recvRJtMobile", memberTelnoTarget);
        proxyDao.update(MapperConstants.MEMBER_MANAGE + "updateRecvRjtYnMemInfo", paramMap);
    }

    @Override
    public ResultModel<AtchFilePO> deleteAtchFile(MemberManagePO po) throws Exception {
        ResultModel<AtchFilePO> result = new ResultModel<>();
        po.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());

        FileVO fo = proxyDao.selectOne(MapperConstants.MEMBER_MANAGE + "selectAtchFile", po);
        String fileNm = "";
        if(("04").equals(po.getMemberTypeCd())) {
            fileNm = SiteUtil.getSiteUplaodRootPath() + File.separator + UploadConstants.PATH_IMAGE + File.separator
                    + UploadConstants.PATH_PROFILE + fo.getFilePath() + File.separator + fo.getFileName();
        } else if(("05").equals(po.getMemberTypeCd())) {
            fileNm = SiteUtil.getSiteUplaodRootPath() + File.separator + UploadConstants.PATH_ATTACH + File.separator
                    + UploadConstants.PATH_BIZ + fo.getFilePath() + File.separator + fo.getFileName();
        }

        File file = new File(fileNm);
        file.delete();

        // 게시글 파일 정보 삭제
        try {

            proxyDao.update(MapperConstants.MEMBER_MANAGE + "deleteAtchFile", po);

            result.setMessage(MessageUtil.getMessage("biz.common.delete"));
        } catch (DuplicateKeyException e) {
            throw new CustomException("biz.exception.common.exist", new Object[] { "코드그룹" }, e);
        }
        return result;
    }

    @Override
    @Transactional(readOnly = true)
    public FileVO selectAtchFileDtl(MemberManagePO po) throws Exception {
        po.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());

        FileVO fo = proxyDao.selectOne(MapperConstants.MEMBER_MANAGE + "selectAtchFile", po);

        fo.setFilePath(SiteUtil.getSiteUplaodRootPath() + File.separator + UploadConstants.PATH_ATTACH + File.separator
                + UploadConstants.PATH_BIZ + fo.getFilePath() + File.separator + fo.getFileName());

        return fo;
    }
    
    /**
     * 회원 쿠폰 상세보기
     */
	public ResultModel<MemberManageVO> selectMemCouponInfo(MemberManageSO so) {
		
		MemberManageVO vo = proxyDao.selectOne(MapperConstants.MEMBER_MANAGE + "selectMemCouponInfo", so);
		
		ResultModel<MemberManageVO> result = new ResultModel<>(restoreClearXSS(vo));
		
		return result;
       
	}

	public MemberManageVO restoreClearXSS(MemberManageVO vo) {
        if (vo.getCouponDscrt() != null && !"".equals(vo.getCouponDscrt())) {
            vo.setCouponDscrt(vo.getCouponDscrt().trim());
            vo.setCouponDscrt(vo.getCouponDscrt().replaceAll("&#35;", "#"));
            vo.setCouponDscrt(vo.getCouponDscrt().replaceAll("&lt;", "<"));
            vo.setCouponDscrt(vo.getCouponDscrt().replaceAll("&gt;", ">"));
            vo.setCouponDscrt(vo.getCouponDscrt().replaceAll("&#34;", "\\\""));
            vo.setCouponDscrt(vo.getCouponDscrt().replaceAll("&#39;", "'"));
            vo.setCouponDscrt(vo.getCouponDscrt().replaceAll("&#40;", "\\("));
            vo.setCouponDscrt(vo.getCouponDscrt().replaceAll("&#41;", "\\)"));
            vo.setCouponDscrt(vo.getCouponDscrt().replaceAll("&quot;", "\""));
            vo.setCouponDscrt(vo.getCouponDscrt().replaceAll("&rarr;", "\\→"));

        }
        return vo;
    }
	
	
    /**
     * 푸시 전체 대상자 조회
     */
    @Override
    @Transactional(readOnly = true)
    public List<MemberManageVO> viewTotalPushList(MemberManageSO memberManageSO) {
        memberManageSO.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
        memberManageSO.setMemberStatusCd("01");
        List<MemberManageVO> list = proxyDao.selectList(MapperConstants.MEMBER_MANAGE + "selectTotalPushList",
                memberManageSO);
        return list;
    }
    
    /**
     * 푸시 알림 보내기 화면의 검색 결과 조회
     */
    @Override
    @Transactional(readOnly = true)
    public ResultListModel<MemberManageVO> viewSearchPushListPaging(MemberManageSO memberManageSO) {

        memberManageSO.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());

        // 회원상태코드 set(일반:01, 휴면:02, 탈퇴:03)
        memberManageSO.setMemberStatusCd("01");

        if (("all").equals(memberManageSO.getSearchType())) {
            memberManageSO.setSearchMobile(memberManageSO.getSearchWords());
            memberManageSO.setSearchTel(memberManageSO.getSearchWords());
            memberManageSO.setSearchName(memberManageSO.getSearchWords());
            memberManageSO.setSearchLoginId(memberManageSO.getSearchWords());
            memberManageSO.setSearchEmail(memberManageSO.getSearchWords());
        } else if (("name").equals(memberManageSO.getSearchType())) {
            memberManageSO.setSearchName(memberManageSO.getSearchWords());
        } else if (("tel").equals(memberManageSO.getSearchType())) {
            memberManageSO.setSearchTel(memberManageSO.getSearchWords());
        } else if (("mobile").equals(memberManageSO.getSearchType())) {
            memberManageSO.setSearchMobile(memberManageSO.getSearchWords());
        } else if (("id").equals(memberManageSO.getSearchType())) {
            memberManageSO.setSearchLoginId(memberManageSO.getSearchWords());
        } else if (("email").equals(memberManageSO.getSearchType())) {
            memberManageSO.setSearchEmail(memberManageSO.getSearchWords());
        }

        if (memberManageSO.getSidx().length() == 0) {
            memberManageSO.setSidx("REG_DTTM");
            memberManageSO.setSord("DESC");
        }
        
        // token이 존재하는 회원
        memberManageSO.setAppToken("Y");

        return proxyDao.selectListPage(MapperConstants.MEMBER_MANAGE + "selectMemListPaging", memberManageSO);
    }
    
    
    @Override
    @Transactional(readOnly = true)
    public List<MemberManageVO> viewPushListCommon(MemberManageSO memberManageSO) {

        memberManageSO.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());

        // 회원상태코드 set(일반:01, 휴면:02, 탈퇴:03)
        memberManageSO.setMemberStatusCd("01");

        if (("all").equals(memberManageSO.getSearchType())) {
            memberManageSO.setSearchMobile(memberManageSO.getSearchWords());
            memberManageSO.setSearchTel(memberManageSO.getSearchWords());
            memberManageSO.setSearchName(memberManageSO.getSearchWords());
            memberManageSO.setSearchLoginId(memberManageSO.getSearchWords());
            memberManageSO.setSearchEmail(memberManageSO.getSearchWords());
        } else if (("name").equals(memberManageSO.getSearchType())) {
            memberManageSO.setSearchName(memberManageSO.getSearchWords());
        } else if (("tel").equals(memberManageSO.getSearchType())) {
            memberManageSO.setSearchTel(memberManageSO.getSearchWords());
        } else if (("mobile").equals(memberManageSO.getSearchType())) {
            memberManageSO.setSearchMobile(memberManageSO.getSearchWords());
        } else if (("id").equals(memberManageSO.getSearchType())) {
            memberManageSO.setSearchLoginId(memberManageSO.getSearchWords());
        } else if (("email").equals(memberManageSO.getSearchType())) {
            memberManageSO.setSearchEmail(memberManageSO.getSearchWords());
        }

        if (memberManageSO.getSidx().length() == 0) {
            memberManageSO.setSidx("REG_DTTM");
            memberManageSO.setSord("ASC");
        }
        
        // token이 존재하는 회원
        memberManageSO.setAppToken("Y");

        return proxyDao.selectList(MapperConstants.MEMBER_MANAGE + "selectMemListPaging", memberManageSO);
    }    
    
    
    
	@Override
	@Transactional(readOnly = true)
	public List<MemberManageVO> viewPushListCommonByMap(Map<String,Object> map) {
		
		Map<String,Object> map2 = new HashMap<>();
		map2.put("memberStatusCd", "01"); 
		
	    return proxyDao.selectList(MapperConstants.MEMBER_MANAGE + "selectMemListByPush", map2);
	}

	@Override
	public MemberManageVO selectIntegrationDttm(MemberManageSO so) {

		return proxyDao.selectOne(MapperConstants.MEMBER_MANAGE + "selectIntegrationDttm", so);
	}

    @Override
    public List<MemberFaceVO> selectFaceList(MemberFaceSO po) throws Exception {
        List<MemberFaceVO> result;

        try {
            po.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());

            result = proxyDao.selectList(MapperConstants.MEMBER_MANAGE + "selectFaceList", po);
            log.info("selectFaceList : {}", result);
        } catch (DuplicateKeyException e) {
            throw new CustomException("biz.exception.common.error", new Object[] { "코드그룹" }, e);
        }

        return result;
    }

    @Override
    public List<MemberFaceVO> selectFaceInfoList(MemberFaceSO po) throws Exception {
        List<MemberFaceVO> result;

        try {
            po.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());

            result = proxyDao.selectList(MapperConstants.MEMBER_MANAGE + "selectFaceInfoList", po);
            log.info("selectFaceInfoList : {}", result);
        } catch (DuplicateKeyException e) {
            throw new CustomException("biz.exception.common.error", new Object[] { "코드그룹" }, e);
        }

        return result;
    }

    @Override
    public int checkDuplicationNickname(MemberManageVO so) throws Exception {
        int result = 0;

        String[] notAllowedNn = { "관리자", "운영자" };
        boolean chkAllowed = true;
        for(String el : notAllowedNn) {
            if(el.equals(so.getMemberNn())) {
                chkAllowed = false;
                result = 9999;
            }
        }

        if(chkAllowed) {
            result = proxyDao.selectOne(MapperConstants.MEMBER_MANAGE + "checkDuplicationNickname", so);
        }

        return result;
    }

    @Override
    @Transactional(readOnly = true)
    public ResultListModel<MemberManageVO> selectStampList(MemberManageSO memberManageSO) {
        return proxyDao.selectListPage(MapperConstants.MEMBER_MANAGE + "selectStampListPaging", memberManageSO);
    }

    @Override
    public List<MemberManageVO> selectMemListBySend(MemberManageSO memberManageSO) {
        memberManageSO.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());

        // 회원상태코드 set(일반:01, 휴면:02, 탈퇴:03)
        memberManageSO.setMemberStatusCd("01");

        if (("all").equals(memberManageSO.getSearchType())) {
            memberManageSO.setSearchName(memberManageSO.getSearchWords());
            memberManageSO.setSearchMobile(memberManageSO.getSearchWords());
            memberManageSO.setSearchLoginId(memberManageSO.getSearchWords());
            memberManageSO.setSearchEmail(memberManageSO.getSearchWords());
            memberManageSO.setSearchMemberNo(memberManageSO.getSearchWords());
            memberManageSO.setSearchNn(memberManageSO.getSearchWords());
        } else if (("name").equals(memberManageSO.getSearchType())) {
            memberManageSO.setSearchName(memberManageSO.getSearchWords());
        } else if (("mobile").equals(memberManageSO.getSearchType())) {
            memberManageSO.setSearchMobile(memberManageSO.getSearchWords());
        } else if (("id").equals(memberManageSO.getSearchType())) {
            memberManageSO.setSearchLoginId(memberManageSO.getSearchWords());
        } else if (("email").equals(memberManageSO.getSearchType())) {
            memberManageSO.setSearchEmail(memberManageSO.getSearchWords());
        } else if (("memberNo").equals(memberManageSO.getSearchType())) {
            memberManageSO.setSearchMemberNo(memberManageSO.getSearchWords());
        } else if (("nickname").equals(memberManageSO.getSearchType())) {
            memberManageSO.setSearchNn(memberManageSO.getSearchWords());
        }

        if (memberManageSO.getSidx().length() == 0) {
            memberManageSO.setSidx("REG_DTTM");
            memberManageSO.setSord("DESC");
        }
        memberManageSO.setLimit((memberManageSO.getPage() - 1) * memberManageSO.getRows());
        memberManageSO.setOffset(memberManageSO.getRows());
        return proxyDao.selectList(MapperConstants.MEMBER_MANAGE + "selectMemListBySend", memberManageSO);
    }
}
