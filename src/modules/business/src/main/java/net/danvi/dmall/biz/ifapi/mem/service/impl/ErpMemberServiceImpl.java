package net.danvi.dmall.biz.ifapi.mem.service.impl;

import dmall.framework.common.BaseService;
import dmall.framework.common.constants.MapperConstants;
import dmall.framework.common.exception.CustomException;
import dmall.framework.common.model.ResultListModel;
import dmall.framework.common.model.ResultModel;
import lombok.extern.slf4j.Slf4j;
import net.danvi.dmall.biz.app.eyesight.service.EyesightService;
import net.danvi.dmall.biz.app.member.manage.model.MemberManagePO;
import net.danvi.dmall.biz.app.member.manage.model.MemberManageSO;
import net.danvi.dmall.biz.app.member.manage.model.MemberManageVO;
import net.danvi.dmall.biz.app.member.manage.service.FrontMemberService;
import net.danvi.dmall.biz.app.operation.service.SavedMnPointService;
import net.danvi.dmall.biz.app.order.manage.model.OrderSO;
import net.danvi.dmall.biz.app.order.manage.service.OrderService;
import net.danvi.dmall.biz.app.promotion.coupon.service.CouponService;
import net.danvi.dmall.biz.common.service.BizService;
import net.danvi.dmall.biz.ifapi.cmmn.CustomIfException;
import net.danvi.dmall.biz.ifapi.cmmn.constant.Constants;
import net.danvi.dmall.biz.ifapi.cmmn.mapp.service.MappingService;
import net.danvi.dmall.biz.ifapi.mem.dto.*;
import net.danvi.dmall.biz.ifapi.mem.service.ErpMemberService;
import net.danvi.dmall.biz.ifapi.mem.service.ErpPointService;
import net.danvi.dmall.biz.system.model.SiteCacheVO;
import net.danvi.dmall.biz.system.service.SiteService;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;
import java.net.URLDecoder;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.*;

import static jdk.nashorn.internal.runtime.regexp.joni.Config.log;


/**
 * <pre>
 * 프로젝트명:davich-ecommerce-backend
 * 파일명:   ErpMemberServiceImpl
 * 작성자:   gh.jo
 * 작성일:   2022/12/02
 * 설명:    다비전 회원관련 인터페시으
 * </pre>
 * ===========================================================
 * DATE                 AUTHOR                NOTE
 * -----------------------------------------------------------
 * 2022/12/02 gh.jo  최초 생성
 */

@Slf4j
@Service("erpMemberService")
@Transactional(rollbackFor = Exception.class)
public class ErpMemberServiceImpl extends BaseService implements ErpMemberService {

    @Resource(name = "frontMemberService")
    private FrontMemberService frontMemberService;

    @Resource(name = "siteService")
    private SiteService siteService;

    @Resource(name="mappingService")
    MappingService mappingService;

    @Resource(name = "bizService")
    private BizService bizService;

    @Resource(name = "eyesightService")
    private EyesightService eyesightService;

    @Resource(name = "couponService")
    private CouponService couponService;

    @Resource(name = "savedMnPointService")
    private SavedMnPointService savedMnPointService;

    @Resource(name = "orderService")
    private OrderService orderService;

    @Resource(name = "erpPointService")
    private ErpPointService erpPointService;


    @Override
    public List<OfflineMemberVO> getOfflineMemberInfo(OfflineMemberSO param) throws Exception {
        return proxyDao.selectList("erp.member.selectOfflineMemberList", param);
    }

    @Override
    public int insertMemberCombineInfoToErp(MemberCombineReqDTO param) throws Exception {
        return proxyDao.insert("member.insertMemberCombineInfo", param);
    }
    /**
     * 다비젼에서 회원 통합
     */
    @Override
//    @Transactional(transactionManager="transactionManager1")
    public int combineMemberFromErp(MemberCombineReqDTO param) throws Exception {
        param.setUpdrNo(Constants.IF_REGR_NO.toString());
        param.setSiteNo(Constants.SITE_NO.toString());
//
//
//          getOnlineMemberInfo
//        OnlineMemSearchReqDTO onlineMemSearchReqDTO = new OnlineMemSearchReqDTO();
//        onlineMemSearchReqDTO.setCustName(param.get);
//        List<OnlineMemSearchResDTO.OnlineMemInfo> memList = this.getOnlineMemberInfo(param);

//
//        // 통합회원구분코드 조회
//        String combineGbCd = this.selectCombineGbCd(param);
//        if("03".equals(combineGbCd)) {
//            // 이미 통합된 회원입니다.
//            throw new CustomException("ifapi.exception.member.combine.already");
//        } else if(!"01".equals(combineGbCd)) {
//            // 쇼핑몰 정회원만 회원통합이 가능합니다.
//            throw new CustomException("ifapi.exception.member.combine.membergb.invalid");
//        }
//
//        // 매핑 테이블에 데이터 저장
//        mappingService.insertMemberMap(param.getMemNo(), param.getCdCust(), param.getLvl());
//
//        // 회원 통합상태 코드 변경
//        param.setCombineGbCd("03");	// 통합회원구분코드 - 통합회원
//        MemberManagePO po = new MemberManagePO();
//        po.setMemberNo(fm_nlMemNo);
//        po.setSiteNo(Long.parseLong(param.getSiteNo()));
//        this.updateMallMemberInfoCombine(param);
        return 0;
    }
    @Override
    public int deleteMemberFromMall(MemberCombineReqDTO param) throws Exception {
//        param.setSiteNo(param.getSiteNo());
        /*param.setSiteNo(Constants.SITE_NO.toString());
        param.setUpdrNo(Constants.IF_REGR_NO.toString());

        param.setCdCust(URLDecoder.decode(param.getCdCust(), "UTF-8"));
        String memNo = mappingService.getMallMemberNo(param.getCdCust());
        if(memNo == null) {
            // 통합회원이 아닙니다.
            //throw new CustomIfException("ifapi.exception.member.notcombined");
            return 1;

        }
        param.setMemNo(memNo);

        // 통합회원구분코드 조회
        String fm_sMemNo = param.getMemNo();
        Long fm_nlMemNo = Long.parseLong(fm_sMemNo);
//        boolean isEMem = eyesightService.checkCombinedMember(fm_nlMemNo);
//        if(!isEMem){
//            //통합된 회원이 아니라면
//            return 1;
//        }

        // 매핑 정보 삭제
        mappingService.deleteMemberMapByMall(fm_sMemNo);

        MemberManageSO so = new MemberManageSO();
        so.setMemberNo(fm_nlMemNo);
        ResultModel<MemberManageVO> resultModel = this.selectMemberErpLeave(so);
        if(resultModel == null || resultModel.getData() == null){
            //회원없으면
            return 2;
        }

        //탈퇴가능여부 확인(진행중인 주문건여부 확인)
        OrderSO orderSO = new OrderSO();
        orderSO.setMemberNo(fm_nlMemNo);
        orderSO.setSiteNo(Long.parseLong(param.getSiteNo()));
        String[] ordDtlStatusCd = { "20", "23", "30", "40", "50", "60", "61", "66", "70", "71" };
        orderSO.setOrdDtlStatusCd(ordDtlStatusCd);
        orderSO.setPage(1);
        orderSO.setRows(1);
        ResultListModel<OrderNewVO> order_list = orderService.selectOrdListFrontPagingNew(orderSO);

        if (order_list.getResultList().size() > 0) {
           //현재 진행중인 거래가 있어 탈퇴처리가 불가능합니다. 해당 내역을 확인하신 후 탈퇴신청하여 주세요.
            return 3;
        }

        MemberManagePO po = new MemberManagePO();
        po.setSiteNo(Long.parseLong(param.getSiteNo()));
        // 회원상태코드(탈퇴:03)
        po.setMemberStatusCd("03");
        po.setWithdrawalTypeCd("01");// 탈퇴 유형 코드(일반, 강제, 탈퇴신청)
        po.setIntegrationMemberGbCd("01");
        po.setLoginId(resultModel.getData().getLoginId());
        po.setMemberNo(resultModel.getData().getMemberNo());
        po.setMemberNm(resultModel.getData().getMemberNm());
        po.setEmail(resultModel.getData().getEmail());
        po.setMobile(resultModel.getData().getMobile());
        po.setMemberCardNo(resultModel.getData().getMemberCardNo());
        po.setErpMemberNo(param.getCdCust());
        po.setStrCode(resultModel.getData().getStrCode());

        // 01.보유쿠폰삭제
        couponService.deleteMemberCoupon(po);
        // 02.마켓포인트삭제
        savedMnPointService.deleteSavedMn(po);
        // 03.탈퇴회원테이블추가
        proxyDao.insert(MapperConstants.MEMBER_MANAGE + "deleteMem", po);
        // 04.회원테이블 탈퇴처리
        proxyDao.update(MapperConstants.MEMBER_MANAGE + "updateWithdrawalMemInfo", po);

        *//** 2023-05-29 210 회원탈퇴 포인트 소멸 **//*
        erpPointService.MemberLeaveDeletePoint(po);*/

        return 0;
    }
    @Override
    public int deleteMemberCombineInfoFromMall(MemberCombineReqDTO param) throws Exception {
        param.setSiteNo(Constants.SITE_NO.toString());
        param.setUpdrNo(Constants.IF_REGR_NO.toString());

        param.setCdCust(URLDecoder.decode(param.getCdCust(), "UTF-8"));
        String memNo = mappingService.getMallMemberNo(param.getCdCust());
        if(memNo == null) {
            // 통합회원이 아닙니다.
            return 1;
        }
        param.setMemNo(memNo);

        // 통합회원구분코드 조회
        String fm_sMemNo = param.getMemNo();
        Long fm_nlMemNo = Long.parseLong(fm_sMemNo);
//        boolean isEMem = eyesightService.checkCombinedMember(fm_nlMemNo);
//        if(!isEMem){
//            // 통합회원이 아닙니다.
//            throw new CustomException("ifapi.exception.member.notcombined");
//        }

        // 매핑 정보 삭제
        mappingService.deleteMemberMapByErp(fm_sMemNo);

        // 회원 통합상태 코드 변경
        param.setCombineGbCd("01");	// 통합회원구분코드 - 정회원(회원통합은 정회원만 가능하므로 회원통합을 해제 할때는 정회원으로 돌려준다.)
//        proxyDao.update("member.updateMallMemberInfoCombine", param);
        MemberManagePO po = new MemberManagePO();
        po.setMemberNo(fm_nlMemNo);
        po.setSiteNo(Long.parseLong(param.getSiteNo()));
        this.updateMallMemberInfoCombine(po);

        return 0;
    }


    @Override
    public String onlineCardNoDupCheckWithOfflineCardNo(OfflineCardNoDupCheckReqDTO param) throws Exception {
        // 중복 데이터 개수 조회
        int dupCnt = countDupOfflineCardNo(param);
        if(dupCnt > 0) {
            // 데이터가 있으면 Y
            return "Y";
        } else {
            // 데이터가 없으면 N
            return "N";
        }
    }
    @Override
    public ResultModel<MemberManageVO> selectMemberErpLeave(MemberManageSO so) {
        MemberManageVO vo = proxyDao.selectOne(MapperConstants.MEMBER_MANAGE + "onlyErpLeaveviewMemInfoDtl", so);
        ResultModel<MemberManageVO> result = new ResultModel<>(vo);
        return result;
    }
    @Override
    public OfflineShopMemberVO getShopMemberInfo(OfflineShopMemberVO param) {
        return proxyDao.selectOne("erp.member.selectShopMemberInfo", param);
    }

    @Override
    public List<OnlineMemSearchResDTO.OnlineMemInfo> getOnlineMemberCardInfo(OnlineMemSearchReqDTO param) {
        return proxyDao.selectList("erp.member.selectOnlineMemberCardList", param);
    }


    private int countDupOfflineCardNo(OfflineCardNoDupCheckReqDTO param) throws Exception {
        return proxyDao.selectOne("erp.member.countDupOfflineCardNo", param);
    }

    private String selectCombineGbCd(MemberCombineReqDTO param) throws Exception {
        return proxyDao.selectOne("member.selectCombineGbCd", param);
    }

    public void deleteMemberMapByErp(String erpMemberNo) throws Exception {
        proxyDao.update("mapping.deleteMemberMapByErp", erpMemberNo);
    }

    public int updateMallMemberInfoCombine(MemberManagePO po) throws Exception {
        //return proxyDao.update("member.updateMallMemberInfoCombine", param);
        return proxyDao.update(MapperConstants.MEMBER_INFO + "updateMemberIntegration", po);
    }

    @Override
    public List<OnlineMemSearchResDTO.OnlineMemInfo> getOnlineMemberInfo(OnlineMemSearchReqDTO param) {
        return proxyDao.selectList("erp.member.selectOnlineMemberList", param);
    }

    @Override
    public void updateErpMemberLvl() {
        proxyDao.update("erp.member.updateMemberLvl");
    }

    @Override
    public String memberJoinFromStore(StoreMemberJoinReqDTO param) throws Exception {
        // 쇼핑몰서비스 호출용 세션 생성
        //SessionUtil.setMallSession();

        // ID 중복 확인
        MemberManageSO so = new MemberManageSO();
        so.setLoginId(param.getMemberId());
        so.setSiteNo(Constants.SITE_NO);
        int loginIdCnt = frontMemberService.checkDuplicationId(so);
        if(loginIdCnt > 0) {
            // 사용할 수 없는 ID입니다.
            throw new CustomIfException("ifapi.exception.member.id.duplicate");
        }

        MemberManagePO po = new MemberManagePO();
        po.setRegrNo(Constants.IF_REGR_NO);
        po.setUpdrNo(Constants.IF_REGR_NO);
        po.setSiteNo(Constants.SITE_NO);

        // 기본 정보 설정
        po.setMemberGradeNo("1");
        po.setJoinPathCd("SHOP");// 가입경로
        po.setMemberTypeCd("01");//회원유형코드(개인:01,사업자:02)
        po.setMemberStatusCd("01");// 회원상태코드
        po.setIntegrationMemberGbCd("01");//통합 회원 구분 코드 (정회원) - 뒤에서 다시 통합을 처리함
        po.setAdultCertifyYn("N");// 미성년자
        if( param.getPassword() !=null && !param.getPassword().equals("")) {
            po.setPw(param.getPassword());    // Default Password
        }else{
            po.setPw("1111");    // Default Password
        }

        // 입력 정보 설정
        po.setLoginId(param.getMemberId());
        po.setMemberNm(param.getMemberName());
        po.setGenderGbCd(param.getGender());
        po.setBirth(param.getBirth());
        po.setEmail(param.getEmail());
        po.setMobile(param.getHp());
        po.setNewPostNo(param.getZipcode());
        po.setStrtnbAddr(param.getAddress1());
        po.setRoadAddr(param.getAddress1());
        po.setDtlAddr(param.getAddress2());
        po.setEmailRecvYn(param.getEmailRecvYn());
        po.setSmsRecvYn(param.getSmsRecvYn());

        po.setRule04Agree("Y"); // 개인정보처리방침 *
        po.setRule10Agree("Y");// 온라인 몰 이용약관
        po.setRule21Agree("Y"); // 청소년 보호정책
        po.setRule22Agree("Y"); // 위치정보 이용약관
        po.setRule09Agree("Y");	// 멤버쉽 회원 이용약관

        // 변경안내 주기 날짜
        Calendar cal = Calendar.getInstance(Locale.KOREA);
        SiteCacheVO siteCacheVO = siteService.getSiteInfo(po.getSiteNo());
        if (siteCacheVO.getPwChgGuideCycle() != null) {
            cal.add(Calendar.MONTH, +siteCacheVO.getPwChgGuideCycle());
            po.setNextPwChgScdDttm(cal.getTime());
        } else {
            // default 6개월
            cal.add(Calendar.MONTH, 6);
            po.setNextPwChgScdDttm(cal.getTime());
        }

        // 추천인 ID로 추천인 memberNo를 조회
        if(param.getRecomMemId() != null && !param.getRecomMemId().equals("")) {
            so.setRecomId(param.getRecomMemId());
            String recomMemNo = frontMemberService.checkRecomMemberId(so);
            if(recomMemNo == null || recomMemNo.equals("")) {
                // 추천인 ID가 정확하지 않습니다.
                throw new CustomIfException("ifapi.exception.member.recommend.id.invalid");
            }
            po.setRecomMemberNo(recomMemNo);
        }

        // 회원 정보 저장
        ResultModel<MemberManagePO> resultPo = frontMemberService.insertMember(po);

        // 회원 통합
        // 회원 테이블 갱신(통합 상태)
        proxyDao.update(MapperConstants.MEMBER_INFO + "updateMemberIntegration", resultPo.getData());

        // 매장가입여부를 Y로 갱신
        setStoreJoinYnToY(resultPo.getData().getMemberNo().toString());

        // 매핑 데이터 저장
        mappingService.insertMemberMap(resultPo.getData().getMemberNo().toString(), param.getCdCust(), param.getLvl());

        return resultPo.getData().getMemberCardNo();
    }

    private void setStoreJoinYnToY(String memberNo) throws Exception {
        proxyDao.update("erp.member.updateStoreJoinYnToY", memberNo);
    }

    @Override
    public List<OffPointHistorySearchResDTO.PointHistoryDTO> getOfflinePointHistory(OffPointHistorySearchReqDTO param) throws Exception {
        return proxyDao.selectList("erp.member.selectOfflinePointHistory", param);
    }

//    @Override
//    public int getOfflineAvailPoint(String f_sCdCust) throws Exception {
//        OffPointSearchReqDTO param = new OffPointSearchReqDTO();
//        param.setCdCust(f_sCdCust);
//        return proxyDao.selectOne("erp.member.selectOfflineAvailPoint", param);
//    }

    @Override
    public int getOfflineAvailStamp(OffPointSearchReqDTO param) throws Exception {
            int re = 0;
            Integer exP = proxyDao.selectOne("erp.member.selectStampQty", param);
            if(exP != null){
                re = exP;
            }
        return re;
    }

    @Override
    public ResultListModel<StampHistoryDto> getOfflineStampHistory(OfflineStampHistorySearchDto param) {
        return proxyDao.selectListPage("erp.member.selectStampHistPaging", param);
    }

    /**
     * 2023-05-12 210
     * 회원 톱합 시키기
     * **/
    @Override
    public Map setErpIntergratedMember(OfflineMemberVO param) throws Exception {
        Map map = new HashMap();
//        map.put("a_MEMBER_NM","조근현");
//        map.put("a_MOBILE","12");
//        map.put("a_MALL_NO_CARD","123456789");
        map.put("a_MEMBER_NM",param.getNmCust());
        map.put("a_MOBILE",param.getHandPhone());
        map.put("a_MALL_NO_CARD",param.getOfflineCardNo());
//        map.put("a_MAN_CODE",param.getStrCode());
        proxyDao.selectOne("erp.member.procedureMemberIntergrated", map);
        if(map.get("o_RETURN").toString().compareTo("0") == 0){
            //정상 입력됨.

        }else{
            throw new CustomException(map.get("o_MESSAGE").toString());
        }
        return map;
    }

    /**
     * 2023-05-19 210
     * 회원탈퇴 할때 이알피쪽 탈퇴디비 맥스 시퀀스 가져오기
     * **/
    @Override
    public Integer selectOfflineLeaveMemberSeq(Map param) throws Exception{
        Integer LeaveSeq = proxyDao.selectOne("erp.member.selectOfflineLeaveMemberSeq", param);
        return LeaveSeq;
    }

    /**
     * 2023-05-19 210
     * 이알피 회원탈퇴 입력
     * **/
    @Override
    public Integer insertOfflineLeaveMember(Map param) throws Exception {
        return proxyDao.insert("erp.member.insertOfflineLeaveMember", param);
    }




}
