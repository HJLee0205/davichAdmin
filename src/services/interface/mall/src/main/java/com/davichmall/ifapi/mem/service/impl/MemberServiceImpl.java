package com.davichmall.ifapi.mem.service.impl;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.annotation.Resource;

import com.davichmall.ifapi.mem.dto.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.davichmall.ifapi.cmmn.CustomException;
import com.davichmall.ifapi.cmmn.base.BaseResDTO;
import com.davichmall.ifapi.cmmn.constant.Constants;
import com.davichmall.ifapi.cmmn.mapp.dto.OffPointMapRegReqDTO;
import com.davichmall.ifapi.cmmn.mapp.service.MappingService;
import com.davichmall.ifapi.mem.dao.MemberDAO;
import com.davichmall.ifapi.mem.dto.MallVCResultResDTO.MallVCResultDTO;
import com.davichmall.ifapi.mem.dto.MemberOffLevelResDTO.MemberOffLevelDTO;
import com.davichmall.ifapi.mem.dto.MemberYearEndTaxResDTO.YearEndTaxInfo;
import com.davichmall.ifapi.mem.dto.OffPointHistorySearchResDTO.PointHistoryDTO;
import com.davichmall.ifapi.mem.dto.OfflineMemSearchResDTO.OfflineMemInfo;
import com.davichmall.ifapi.mem.dto.OnlineMemSearchResDTO.OnlineMemInfo;
import com.davichmall.ifapi.mem.dto.StoreVCResultResDTO.VCRecoGoodsDTO;
import com.davichmall.ifapi.mem.dto.StoreVCResultResDTO.VCResultDTO;
import com.davichmall.ifapi.mem.service.MemberService;
import com.davichmall.ifapi.util.SendUtil;
import com.davichmall.ifapi.util.SessionUtil;

import dmall.framework.common.constants.MapperConstants;
import dmall.framework.common.dao.ProxyDao;
import dmall.framework.common.model.ResultModel;
import net.danvi.dmall.biz.app.member.manage.model.MemberManagePO;
import net.danvi.dmall.biz.app.member.manage.model.MemberManageSO;
import net.danvi.dmall.biz.app.member.manage.model.MemberManageVO;
import net.danvi.dmall.biz.app.member.manage.service.FrontMemberService;
import net.danvi.dmall.biz.app.member.manage.service.MemberManageService;
import net.danvi.dmall.biz.app.operation.model.SavedmnPointPO;
import net.danvi.dmall.biz.app.operation.service.SavedMnPointService;
import net.danvi.dmall.biz.system.model.SiteCacheVO;
import net.danvi.dmall.biz.system.service.SiteService;
import net.sf.json.JSONObject;


/**
 * <pre>
 * - 프로젝트명    : davichmall_interface
 * - 패키지명      : com.davichmall.ifapi.mem.service.impl
 * - 파일명        : MemberServiceImpl.java
 * - 작성일        : 2018. 5. 24.
 * - 작성자        : CBK
 * - 설명          : 회원 관련 인터페이스 처리를 위한 Service
 * </pre>
 */
@Service("memberService")
public class MemberServiceImpl implements MemberService {

	@Resource(name="memberDao")
	MemberDAO memberDao;

	@Resource(name="mappingService")
	MappingService mappingService;

	@Resource(name="sendUtil")
	SendUtil sendUtil;

    @Value(value = "#{business['system.domain.product']}")
    private String mallUrl;

    @Resource(name="memberManageService")
    private MemberManageService memberManageService;

    @Resource(name="savedMnPointService")
    private SavedMnPointService savedMnPointService;

    @Resource(name = "frontMemberService")
    private FrontMemberService frontMemberService;

    @Resource(name = "siteService")
    private SiteService siteService;

	@Autowired
	ProxyDao proxyDao;

	@Value("${mall.strcode}")
	String strCode;

	/**
	 * 오프라인 회원 조회
	 */
	@Override
	public List<OfflineMemInfo> getOfflineMemberInfo(OfflineMemSearchReqDTO param) throws Exception {
		return memberDao.getOfflineMemberInfo(param);
	}

	/**
	 * 온라인 회원 조회
	 */
	@Override
	public List<OnlineMemInfo> getOnlineMemberInfo(OnlineMemSearchReqDTO param) throws Exception {
		return memberDao.getOnlineMemberInfo(param);
	}
	
	/**
	 * 온라인 회원 카드번호로 조회
	 */
	@Override
	public List<OnlineMemInfo> getOnlineMemberCardInfo(OnlineMemSearchReqDTO param) throws Exception {
		return memberDao.getOnlineMemberCardInfo(param);
	}

	/**
	 * 회원통합 매핑 정보 등록 및 ERP쪽으로 전송(Transaction처리를 위해 Service에 Method로 구성)
	 */
	@Transactional(transactionManager="transactionManager1", rollbackFor=CustomException.class)
	@Override
	public String insertMemberMapAndSend(MemberCombineReqDTO param, String ifId) throws Exception {
		// 매핑 데이터 등록
		mappingService.insertMemberMap(param.getMemNo(), param.getCdCust(), param.getLvl());

		// ERP 쪽으로 데이터 전송
		String resParam = sendUtil.send(param, ifId);

		MemberCombineResDTO resDto = (MemberCombineResDTO) JSONObject.toBean(JSONObject.fromObject(resParam), MemberCombineResDTO.class);

		if(Constants.RESULT.FAILURE.equals(resDto.getResult())) {
			// 실패면 등록한 데이터 롤백
			throw new CustomException(resDto.getMessage());
		}

		return resParam;
	}

	/**
	 * 회원통합정보 저장(ERP)
	 */
	@Override
	public int insertMemberCombineInfoToErp(MemberCombineReqDTO param) throws Exception {
		// 쇼핑몰 온라인 카드번호 및 통합여부 넣어주기
		return memberDao.insertMemberCombineInfoToErp(param);
	}

	/**
	 * 다비젼에서 회원 통합
	 */
	@Override
	@Transactional(transactionManager="transactionManager1")
	public void combineMemberFromErp(MemberCombineReqDTO param) throws Exception {

		param.setUpdrNo(Constants.IF_REGR_NO.toString());
		param.setSiteNo(Constants.SITE_NO.toString());

		// 통합회원구분코드 조회
		String combineGbCd = memberDao.selectCombineGbCd(param);
		if("03".equals(combineGbCd)) {
			// 이미 통합된 회원입니다.
			throw new CustomException("ifapi.exception.member.combine.already");
		} else if(!"01".equals(combineGbCd)) {
			// 쇼핑몰 정회원만 회원통합이 가능합니다.
			throw new CustomException("ifapi.exception.member.combine.membergb.invalid");
		}

		// 매핑 테이블에 데이터 저장
		mappingService.insertMemberMap(param.getMemNo(), param.getCdCust(), param.getLvl());

		// 회원 통합상태 코드 변경
		param.setCombineGbCd("03");	// 통합회원구분코드 - 통합회원
		memberDao.updateMallMemberInfoCombine(param);
	}
	/**
	 * 쇼핑몰-ERP 회원통합 매핑정보 삭제(플래그변경) 및 ERP쪽으로 데이터 전송(Transaction처리를 위해 Service에 Method로 구성)
	 */
	@Transactional(transactionManager="transactionManager1", rollbackFor= {CustomException.class, Exception.class})
	@Override
	public String deleteMemberMapAndSend(MemberCombineReqDTO param, String ifId) throws Exception {
		// ERP회원번호 조회
		String cdCust = mappingService.getErpMemberNo(param.getMemNo());
		param.setCdCust(cdCust);

		// 매핑 정보 삭제
		mappingService.deleteMemberMapByMall(param.getMemNo());

		// ERP쪽에 전송
		String resParam = sendUtil.send(param, ifId);
		MemberCombineResDTO resDto = (MemberCombineResDTO) JSONObject.toBean(JSONObject.fromObject(resParam), MemberCombineResDTO.class);

		if(Constants.RESULT.FAILURE.equals(resDto.getResult())) {
			throw new CustomException(resDto.getMessage());
		}

		return resParam;
	}

	/**
	 * 회원 통합 정보 삭제(ERP)
	 */
	@Override
	public int deleteMemberCombineInfoFromErp(MemberCombineReqDTO param) throws Exception {
		return memberDao.deleteMemberCombineInfoFromErp(param);
	}

	/**
	 * 회원통합 정보 삭제(쇼핑몰)
	 */
	@Override
	public void deleteMemberCombineInfoFromMall(MemberCombineReqDTO param) throws Exception {
		param.setUpdrNo(Constants.IF_REGR_NO.toString());
		param.setSiteNo(Constants.SITE_NO.toString());

		// 통합회원구분코드 조회
		String combineGbCd = memberDao.selectCombineGbCd(param);
		if(!"03".equals(combineGbCd)) {
			return;	// 통합회원이 아니면 아무것도 안함.
		}

		// 매핑 정보 삭제
		mappingService.deleteMemberMapByErp(param.getCdCust());

		// 회원 통합상태 코드 변경
		param.setCombineGbCd("01");	// 통합회원구분코드 - 정회원(회원통합은 정회원만 가능하므로 회원통합을 해제 할때는 정회원으로 돌려준다.)
		memberDao.updateMallMemberInfoCombine(param);
	}

	/**
	 * ERP 회원 등급 조회
	 * 2019. 3. 14. KDY - 배치성능 저하이슈로인한 dblink 방식으로 변경
	 */
	@Override
	public List<MemberOffLevelDTO> selectErpMemberLvl() throws Exception {
		/*return memberDao.selectErpMemberLvl();*/
		// mall에서는 사용하지 않음
		return null;
	}

	/**
	 * 쇼핑몰에 ERP회원 등급 갱신
	 * 2019. 3. 14. KDY 배치성능 저하이슈로인한 dblink 방식으로 변경
	 */
	@Override
	public void updateErpMemberLvl() throws Exception {
			memberDao.updateMemberLvl();
	}

	/**
	 * 오프라인 포인트 조회
	 */
	@Override
	public int getOfflineAvailPoint(OffPointSearchReqDTO param) throws Exception {
		return memberDao.getOfflineAvailPoint(param);
	}

	/**
	 * 오프라인 포인트 증감내역 조회
	 */
	@Override
	public List<PointHistoryDTO> getOfflinePointHistory(OffPointHistorySearchReqDTO param) throws Exception {
		return memberDao.getOfflinePointHistory(param);
	}

	/**
	 * 오프라인 포인트 증감내역 건수 조회
	 */
	@Override
	public int countOfflinePointHistory(OffPointHistorySearchReqDTO param) throws Exception {
		return memberDao.countOfflinePointHistory(param);
	}

	/**
	 * 매장 (최근 1건의)비젼체크 결과 조회
	 */
	@Override
	public List<VCResultDTO> getLatestStoreVisionCheckResultList(StoreVCResultReqDTO param) throws Exception {
		return memberDao.getLatestStoreVisionCheckResultList(param);
	}

	/**
	 * 매장 (최근 1건의)비젼체크 결과에 따른 추천상품 목록 조회
	 */
	@Override
	public List<VCRecoGoodsDTO> getLatestStoreVisionCheckRecoPrdList(StoreVCResultReqDTO param) throws Exception {
		return memberDao.getLatestStoreVisionCheckRecoPrdList(param);
	}

	/**
	 * 쇼핑몰 비젼체크 결과 목록 조회
	 */
	@Override
	public List<MallVCResultDTO> getLatestMallVisionCheckList(MallVCResultReqDTO param) throws Exception {
		return memberDao.getLatestMallVisionCheckList(param);
	}

	/**
	 * 매장 (최근 1건의)시력검사 결과 조회
	 */
	@Override
	public StoreEyesightInfoResDTO getLatestStoreEyesightInfo(StoreEyesightInfoReqDTO param) throws Exception {
		return memberDao.getLatestStoreEyesightInfo(param);
	}

	/**
	 * 쇼핑몰 (최근 1건의) 시력 정보 조회
	 */
	@Override
	public MallEyesightInfoResDTO getLatestMallEyesightInfo(MallEyesightInfoReqDTO param) throws Exception {
		return memberDao.getLatestMallEyesightInfo(param);
	}

	/**
	 * 최근 1건의 처방전 이미지 URL 조회
	 */
	@Override
	public String getLatestPrescriptionImageURL(PrescriptionUrlReqDTO param) throws Exception {
		String fileId = memberDao.getLatestPrescriptionFileId(param);
		if(fileId == null || "".equals(fileId)) {
			return null;
		}
		return mallUrl + "/image/image-view?type=PRESCRIPTION&id1=" + fileId;
	}

	/**
	 * 온라인 포인트 조회
	 */
	@Override
	public Integer getOnlinePoint(OnPointSearchReqDTO param) throws Exception {
		// 쇼핑몰서비스 호출용 세션 생성
		SessionUtil.setMallSession();

		MemberManageSO memberManageSO = new MemberManageSO();
		memberManageSO.setMemberNo(Long.parseLong(param.getMemNo()));
		ResultModel<MemberManageVO> prcAmt = memberManageService.selectMemSaveMn(memberManageSO);
		if(prcAmt == null) {
			return 0;
		}
		return Integer.parseInt(prcAmt.getData().getPrcAmt());
	}

	/**
	 * 온라인 포인트 사용
	 */
	@Override
	@Transactional
	public void useOnlinePoint(OnPointUseReqDTO param) throws Exception {
		// 쇼핑몰서비스 호출용 세션 생성
		SessionUtil.setMallSession();

        SavedmnPointPO savedmnPointPO = new SavedmnPointPO();
        savedmnPointPO.setSiteNo(Constants.SITE_NO);
        savedmnPointPO.setGbCd("20"); // 차감
        savedmnPointPO.setOrdCanselYn("N"); // 일반차감
        savedmnPointPO.setMemberNo(Long.parseLong(param.getMemNo())); // 회원번호
        savedmnPointPO.setTypeCd("A"); // 유형코드(A:자동, M:수동)
        savedmnPointPO.setReasonCd("05"); // 사유코드(기타)
        savedmnPointPO.setEtcReason(param.getStrName()); // 기타사유-가맹점명
        savedmnPointPO.setDeductGbCd("01"); // 차감구분코드(사용)
        savedmnPointPO.setPrcAmt(param.getUseMallPointAmt().toString());
        savedmnPointPO.setErpOrdNo(param.getErpOrdNo()); // ERP주문번호

		savedMnPointService.insertSavedMn(savedmnPointPO);
	}

	/**
	 * 온라인 포인트 사용 취소
	 */
	@Override
	@Transactional
	public void cancelOnlinePointUse(OnPointUseCancelReqDTO param) throws Exception {
		// 쇼핑몰서비스 호출용 세션 생성
		SessionUtil.setMallSession();

        SavedmnPointPO savedmnPointPO = new SavedmnPointPO();
        savedmnPointPO.setSiteNo(Constants.SITE_NO);
        savedmnPointPO.setGbCd("20"); // 차감
        savedmnPointPO.setOrdCanselYn("Y"); // 차감취소
        savedmnPointPO.setMemberNo(Long.parseLong(param.getMemNo())); // 회원번호
        savedmnPointPO.setEtcReason(param.getStrName()); // 기타사유-가맹점명
        savedmnPointPO.setErpOrdNo(param.getErpOrdNo()); // ERP주문번호

		savedMnPointService.insertSavedMn(savedmnPointPO);
	}

	/**
	 * 오프라인 포인트 사용
	 */
	@Override
	@Transactional(transactionManager="transactionManager2", rollbackFor=Exception.class)
	public synchronized List<String> useOfflinePoint(OffPointUseReqDTO param) throws Exception {
		Integer usePoint = param.getUseOffPointAmt();
		if(usePoint == null || usePoint.intValue() == 0) {
			return null;
		}

		// 결과 반환용 List
		List<String> seqNoList = new ArrayList<>();

		// 보유 포인트 조회
		OffPointSearchReqDTO offPointSearchParam = new OffPointSearchReqDTO();
		offPointSearchParam.setCdCust(param.getCdCust());
		int availOffPoint = this.getOfflineAvailPoint(offPointSearchParam);

		// 보유 포인트 보다 많은 포인트를 사용하려 하면 오류
		if(availOffPoint < param.getUseOffPointAmt().intValue()) {
			// 보유 포인트가 부족합니다.
			throw new CustomException("ifapi.exception.onpoint.overuse");
		}

		// 가맹점별 포인트 목록 조회
		List<Map<String, Object>> strPntList = memberDao.getStorePointList(param.getCdCust());
		for(Map<String, Object> strPnt : strPntList) {
			String strCodeTo = strPnt.get("strCode").toString();
			Integer pointAmt = Integer.parseInt(strPnt.get("pntAmt").toString());

			// 저장용DTO로 전환
			OffPointUseDTO useDto = new OffPointUseDTO(param);
			useDto.setStrCode(this.strCode);
			useDto.setStrCodeTo(strCodeTo);

			// 보유 포인트가 부족한 경우 보유 포인트 만큼만 사용하도록 설정
			if(pointAmt.intValue() < usePoint) {
				useDto.setUsePointAmt(pointAmt);
				usePoint -= pointAmt;
			} else {
				useDto.setUsePointAmt(usePoint);
				usePoint = 0;
			}

			// 트랜잭션번호 조회 및 설정
			useDto.setTrxnNo(memberDao.getTrxnNo(useDto));

			// 저장
			memberDao.insertOfflinePointUse(useDto);

			// 결과 반환을 위해 seqNo를 List에 담기
			seqNoList.add(useDto.getSeqNo());

			if(usePoint.intValue() == 0) {
				break;
			}
		}

		// 매핑 정보 저장
		OffPointMapRegReqDTO mapParam = new OffPointMapRegReqDTO();
		mapParam.setMallOrderNo(param.getOrderNo());
		mapParam.setMallOrderType(Constants.ORDER_MAP_ORDER_TYPE.ORDER);
		mapParam.setErpDates(param.getOrderDate());
		mapParam.setErpMemberNo(param.getCdCust());
		mapParam.setErpSeqNo(seqNoList);
		String resParam = sendUtil.send(mapParam, "insertOffPointMap");

		BaseResDTO mapResult = (BaseResDTO) JSONObject.toBean(JSONObject.fromObject(resParam), BaseResDTO.class);
		if(!Constants.RESULT.SUCCESS.equals(mapResult.getResult())) {
			// 성공이 아니면 오류 -> 롤백
			throw new CustomException("ifapi.exception.common");
		}

		return seqNoList;
	}

	/**
	 * 오프라인 포인트 사용 취소
	 */
	@Override
	@Transactional(transactionManager="transactionManager2", rollbackFor=Exception.class)
	public synchronized List<String> cancelOfflinePointUse(OffPointUseCancelReqDTO param) throws Exception {
		// 원 사용 포인트 목록 조회
		List<OffPointUseDTO> useList = memberDao.getOfflinPointUseList(param);

		// 결과 반환용 List
		List<String> seqNoList = new ArrayList<>();

		for(OffPointUseDTO useDto : useList) {
			// 트랜잭션번호 조회 및 설정
			useDto.setTrxnNo(memberDao.getTrxnNo(useDto));
			// 저장
			memberDao.insertOfflinePointUse(useDto);
			// 결과 반환을 위해 seqNo를 List에 담기
			seqNoList.add(useDto.getSeqNo());
		}


		// 매핑 정보 저장
		OffPointMapRegReqDTO mapParam = new OffPointMapRegReqDTO();
		mapParam.setMallOrderNo(param.getOrderNo());
		mapParam.setMallOrderType(Constants.ORDER_MAP_ORDER_TYPE.RETURN);
		mapParam.setErpDates(param.getOrderDate());
		mapParam.setErpMemberNo(param.getOrgCdCust());
		mapParam.setErpSeqNo(seqNoList);
		String resParam = sendUtil.send(mapParam, "insertOffPointMap");

		BaseResDTO mapResult = (BaseResDTO) JSONObject.toBean(JSONObject.fromObject(resParam), BaseResDTO.class);
		if(!Constants.RESULT.SUCCESS.equals(mapResult.getResult())) {
			// 성공이 아니면 오류 -> 롤백
			throw new CustomException("ifapi.exception.common");
		}

		return seqNoList;
	}

	/**
	 * 온라인 카드번호와 중복되는 오프라인 카드번호가 존재 하는지 확인
	 */
	@Override
	public String onlineCardNoDupCheckWithOfflineCardNo(OfflineCardNoDupCheckReqDTO param) throws Exception {
		// 중복 데이터 개수 조회
		int dupCnt = memberDao.countDupOfflineCardNo(param);
		if(dupCnt > 0) {
			// 데이터가 있으면 Y
			return "Y";
		} else {
			// 데이터가 없으면 N
			return "N";
		}
	}

	/**
	 * 매장에서 쇼핑몰 회원가입
	 */
	@Override
	@Transactional(transactionManager="transactionManager", rollbackFor={Exception.class, CustomException.class, dmall.framework.common.exception.CustomException.class})
	public String memberJoinFromStore(StoreMemberJoinReqDTO param) throws Exception {

		// 쇼핑몰서비스 호출용 세션 생성
		SessionUtil.setMallSession();

		// ID 중복 확인
        MemberManageSO so = new MemberManageSO();
        so.setLoginId(param.getMemberId());
        so.setSiteNo(Constants.SITE_NO);
        int loginIdCnt = frontMemberService.checkDuplicationId(so);
        if(loginIdCnt > 0) {
        	// 사용할 수 없는 ID입니다.
        	throw new CustomException("ifapi.exception.member.id.duplicate");
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
        if(!param.getPassword().equals("") && param.getPassword() !=null) {
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
        		throw new CustomException("ifapi.exception.member.recommend.id.invalid");
        	}
        	po.setRecomMemberNo(recomMemNo);
        }

        // 회원 정보 저장
        ResultModel<MemberManagePO> resultPo = frontMemberService.insertMember(po);

        // 회원 통합
        // 회원 테이블 갱신(통합 상태)
        proxyDao.update(MapperConstants.MEMBER_INFO + "updateMemberIntegration", resultPo.getData());

        // 매장가입여부를 Y로 갱신
		memberDao.setStoreJoinYnToY(resultPo.getData().getMemberNo().toString());


        // 매핑 데이터 저장
        mappingService.insertMemberMap(resultPo.getData().getMemberNo().toString(), param.getCdCust(), param.getLvl());

		return resultPo.getData().getMemberCardNo();
	}

/**
	 * 앱로그인 일시 다비전 기록(ERP)
	 */
	@Override
	public int updateMemberLoginDateFromApp(AppMemberLoginReqDTO param) throws Exception {
		// 앱로그인 일시 다비전 기록
		return memberDao.updateMemberLoginDateFromApp(param);
	}
	
	
	/**
	 * 연말정산 조회
	 */
	@Override
	public List<YearEndTaxInfo> getMemberYearEndTaxList(MemberYearEndTaxReqDTO param) throws Exception {
		return memberDao.getYearEndTaxList(param);
	}
	
	
	/**
	 * 연말정산 조회 (print)
	 */
	@Override
	public List<YearEndTaxInfo> getMemberYearEndTaxPrint(MemberYearEndTaxReqDTO param) throws Exception {
		return memberDao.getYearEndTaxPrint(param);
	}
	
	
	
	/**
	 * 연말정산 신고
	 */
//	@Override
//	public int updateMemberYearEndTaxAuto(MemberYearEndTaxReqDTO param) throws Exception {
//		// 앱로그인 일시 다비전 기록
//		return memberDao.updateMemberYearEndTaxAuto(param);
//	}		
		
}
