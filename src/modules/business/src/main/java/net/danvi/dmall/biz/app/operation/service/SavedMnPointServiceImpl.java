package net.danvi.dmall.biz.app.operation.service;

import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import dmall.framework.common.util.HttpUtil;
import dmall.framework.common.util.MessageUtil;
import net.danvi.dmall.biz.app.member.manage.model.MemberManagePO;
import net.danvi.dmall.biz.app.operation.model.SavedmnPointPO;
import net.danvi.dmall.biz.app.operation.model.SavedmnPointSO;
import net.danvi.dmall.biz.app.operation.model.SavedmnPointVO;
import net.danvi.dmall.biz.app.order.manage.model.OrderGoodsPO;
import net.danvi.dmall.biz.app.operation.model.SavedMoneyConfigPO;
import net.danvi.dmall.biz.app.operation.model.SavedMoneyConfigSO;
import net.danvi.dmall.biz.app.operation.model.SavedMoneyConfigVO;
import net.danvi.dmall.biz.app.operation.model.PointConfigPO;
import net.danvi.dmall.biz.app.operation.model.PointConfigSO;
import net.danvi.dmall.biz.app.operation.model.PointConfigVO;
import net.danvi.dmall.biz.common.service.BizService;
import net.danvi.dmall.biz.system.remote.AdminRemotingService;
import net.danvi.dmall.biz.system.security.SessionDetailHelper;
import org.apache.commons.lang.StringUtils;
import org.springframework.dao.DuplicateKeyException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import lombok.extern.slf4j.Slf4j;
import dmall.framework.common.BaseService;
import dmall.framework.common.constants.MapperConstants;
import dmall.framework.common.exception.CustomException;
import dmall.framework.common.model.ResultListModel;
import dmall.framework.common.model.ResultModel;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 5. 4.
 * 작성자     : user
 * 설명       :
 * </pre>
 */

@Slf4j
@Service("savedMnPointService")
@Transactional(rollbackFor = Exception.class)
public class SavedMnPointServiceImpl extends BaseService implements SavedMnPointService {

    @Resource(name = "bizService")
    private BizService bizService;

    @Resource(name = "adminRemotingService")
    private AdminRemotingService adminRemotingService;

    /** 마켓포인트 설정 정보 조회 서비스 **/
    /*
     * (non-Javadoc)
     *
     * @see net.danvi.dmall.biz.app.setup.savedmoney.service.
     * SavedMoneyConfigService#selectSavedMoneyConfig(net.danvi.dmall.biz.app.
     * setup.savedmoney.model.SavedMoneyConfigSO)
     */
    @Override
    @Transactional(readOnly = true)
    public ResultModel<SavedMoneyConfigVO> selectSavedMoneyConfig(SavedMoneyConfigSO so) {
        so.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
        SavedMoneyConfigVO resultVO = proxyDao.selectOne(MapperConstants.SAVEDMN_POINT + "selectSavedMoneyConfig", so);
        ResultModel<SavedMoneyConfigVO> result = new ResultModel<>(resultVO);
        return result;
    }

    /** 마켓포인트 설정 정보 수정 서비스 **/
    /*
     * (non-Javadoc)
     *
     * @see net.danvi.dmall.biz.app.setup.savedmoney.service.
     * SavedMoneyConfigService#updateSavedMoneyConfig(net.danvi.dmall.biz.app.
     * setup.savedmoney.model.SavedMoneyConfigPO)
     */
    @Override
    public ResultModel<SavedMoneyConfigPO> updateSavedMoneyConfig(SavedMoneyConfigPO po) throws Exception {
        ResultModel<SavedMoneyConfigPO> resultModel = new ResultModel<>();
        po.setUpdrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
        po.setRegrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
        proxyDao.update(MapperConstants.SAVEDMN_POINT + "updateSavedMoneyConfig", po);

        // 프론트 사이트 정보 갱신
        /*HttpServletRequest request = HttpUtil.getHttpServletRequest();
        adminRemotingService.refreshSiteInfoCache(po.getSiteNo(), request.getServerName());*/

        resultModel.setMessage(MessageUtil.getMessage("biz.common.update"));
        return resultModel;
    }

    @Override
    public ResultListModel<SavedmnPointVO> selectSavedmnGetPaging(SavedmnPointSO so) {
        if (so.getSidx().length() == 0) {
            so.setSidx("REG_DTTM");
            so.setSord("DESC");
            so.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
        }

        if (!StringUtils.isEmpty(so.getSearchVal())) {
            so.setMemberNm(so.getSearchVal());
            so.setLoginId(so.getSearchVal());
        }

        // 적립글 리스트 조회
        ResultListModel<SavedmnPointVO> list = proxyDao.selectListPage(MapperConstants.SAVEDMN_POINT + "selectSavedmnGetPaging", so);
        // 리스트의 전체 포인트 조회
        List<String> totalPointList = proxyDao.selectList(MapperConstants.SAVEDMN_POINT + "selectTotalSaveUseMoney", so);

        list.put("totalPointList", totalPointList);

        return list;
    }

    @Override
    public ResultModel<SavedmnPointVO> selectTotalSvmn(SavedmnPointSO so) {
        ResultModel<SavedmnPointVO> result = new ResultModel<>();

        SavedmnPointVO vo = new SavedmnPointVO();
        if (so.getSearchKind() != null && so.getSearchKind() != "") {
            if (("searchMemberNm").equals(so.getSearchKind())) {
                so.setMemberNm(so.getSearchVal());
            }
        }
        // 전체 사용 마켓포인트 조회
        List<String> list = proxyDao.selectList(MapperConstants.SAVEDMN_POINT + "selectTotalSaveUseMoney", so);
        vo.setTotalSvmnPvd((String) list.get(0));
        vo.setTotalSvmnUse((String) list.get(1));
        result.setData(vo);
        return result;
    }

    @Override
    public ResultModel<SavedmnPointPO> insertSavedMn(SavedmnPointPO po) {
        ResultModel<SavedmnPointPO> result = new ResultModel<>();
        try {
            // 지급
            if ("10".equals(po.getGbCd())) {
                long seqNo = bizService.getSequence("TC_MEMBER_SVMN_PVD");
                po.setSvmnSeq(seqNo);
                proxyDao.insert(MapperConstants.SAVEDMN_POINT + "insertSavedMn", po);
            }
            // 차감
            else {
                SavedmnPointSO so = new SavedmnPointSO();
                SavedmnPointPO useSavedMnPo = new SavedmnPointPO();
                so.setMemberNoSelect(po.getMemberNo());
                useSavedMnPo.setRegrNo(po.getRegrNo());
                // 일반 차감
                if (("N").equals(po.getOrdCanselYn())) {
                	// 마켓포인트 차감 금액
                	Integer prcAmt = Integer.parseInt(po.getPrcAmt());
                	
                    // 마켓포인트 사용 가능한 목록 조회
                    List<SavedmnPointVO> savedMnList = proxyDao.selectList(MapperConstants.SAVEDMN_POINT + "selectSavedMnPvd", so);

                    for (int i = 0; i < savedMnList.size(); i++) {
                        // 조회된 사용가능 마켓포인트
                        Integer usePsbAmt = Integer.parseInt(savedMnList.get(i).getUsePsbAmt());
                        long seqNo = bizService.getSequence("TC_MEMBER_SVMN_USE");

                        useSavedMnPo.setSvmnSeq(savedMnList.get(i).getSvmnSeq());
                        useSavedMnPo.setMemberNo(po.getMemberNo());
                        useSavedMnPo.setUseNo(seqNo);
                        useSavedMnPo.setTypeCd(po.getTypeCd());
                        useSavedMnPo.setReasonCd(po.getReasonCd());
                        useSavedMnPo.setEtcReason(po.getEtcReason());
                        useSavedMnPo.setDeductGbCd(po.getDeductGbCd());

                        if (po.getOrdNo() != null && po.getOrdNo() != "") {
                            useSavedMnPo.setOrdNo(po.getOrdNo());
                        }
                        if(po.getErpOrdNo() != null && !"".equals(po.getErpOrdNo())) {
                        	useSavedMnPo.setErpOrdNo(po.getErpOrdNo());
                        }

                        useSavedMnPo.setEtcReason(po.getEtcReason() == null ? "" : po.getEtcReason());
                        //사용가능금액 < 차감금액
                        if (usePsbAmt < prcAmt) {
                            useSavedMnPo.setPrcAmt(savedMnList.get(i).getUsePsbAmt());
                            useSavedMnPo.setSvmnUsePsbAmt("0");
                            prcAmt = prcAmt - usePsbAmt;
                            // 마켓포인트 사용 테이블 등록
                            proxyDao.insert(MapperConstants.SAVEDMN_POINT + "insertSavedMnUse", useSavedMnPo);
                            // 마켓포인트 사용 가능 금액 업데이트
                            proxyDao.update(MapperConstants.SAVEDMN_POINT + "updateUsePsbAmt", useSavedMnPo);

                        }else {
                            useSavedMnPo.setPrcAmt(Integer.toString(prcAmt));
                            useSavedMnPo.setSvmnUsePsbAmt(Integer.toString(usePsbAmt - prcAmt));
                            // 마켓포인트 사용 테이블 등록
                            proxyDao.insert(MapperConstants.SAVEDMN_POINT + "insertSavedMnUse", useSavedMnPo);
                            // 마켓포인트 사용 가능 금액 업데이트
                            proxyDao.update(MapperConstants.SAVEDMN_POINT + "updateUsePsbAmt", useSavedMnPo);
                            break;
                        }
                    }
                    
                    if (po.getOrdNo() != null && po.getOrdNo() != "" && po.getOrderGoodsPO() != null) {
                        for (int j = 0; j < po.getOrderGoodsPO().size(); j++) {
                        	OrderGoodsPO orderGoodsPO = po.getOrderGoodsPO().get(j);
                        	long mileageUseAmt = orderGoodsPO.getGoodsDmoneyUseAmt();
                        	
                        	if (mileageUseAmt > 0) {
                                useSavedMnPo.setOrdDtlSeq(orderGoodsPO.getOrdDtlSeq());
                                useSavedMnPo.setPrcAmt(String.valueOf(mileageUseAmt));
                                //마켓포인트 사용 상세 테이블 등록
                                proxyDao.insert(MapperConstants.SAVEDMN_POINT + "insertSavedMnUseDtl", useSavedMnPo);
                        	}
                        }
                    }                    

                } else {
                    // 주문 취소
                    so.setOrdNo(po.getOrdNo());
                    so.setErpOrdNo(po.getErpOrdNo());
                    List<SavedmnPointVO> savedMnUseList = proxyDao.selectList(MapperConstants.SAVEDMN_POINT + "selectSavedMnUse", so);

                    for (int i = 0; i < savedMnUseList.size(); i++) {
                        long seqNo = bizService.getSequence("TC_MEMBER_SVMN_USE");
                        useSavedMnPo.setUseNo(seqNo);
                        useSavedMnPo.setMemberNo(savedMnUseList.get(i).getMemberNo());
                        useSavedMnPo.setSvmnSeq(savedMnUseList.get(i).getSvmnSeq());
                        useSavedMnPo.setTypeCd(savedMnUseList.get(i).getSvmnTypeCd());
                        useSavedMnPo.setReasonCd("06");
                        useSavedMnPo.setPrcAmt(Integer.toString(-Integer.parseInt(savedMnUseList.get(i).getPrcAmt())));
                        useSavedMnPo.setSvmnUsePsbAmt(savedMnUseList.get(i).getPrcAmt());
                        useSavedMnPo.setOrdNo(savedMnUseList.get(i).getOrdNo());
                        // 차감 구분 코드(01:사용, 02:취소, 03:소멸)
                        useSavedMnPo.setDeductGbCd("02");

                        useSavedMnPo.setEtcReason(po.getEtcReason() == null ? "" : po.getEtcReason());
                        useSavedMnPo.setErpOrdNo(savedMnUseList.get(i).getErpOrdNo());
                        
                        // 마켓포인트 사용 테이블 등록
                        proxyDao.insert(MapperConstants.SAVEDMN_POINT + "insertSavedMnUse", useSavedMnPo);
                        // 마켓포인트 사용 가능 금액 원복
                        proxyDao.update(MapperConstants.SAVEDMN_POINT + "updatePvdPsbAmt", useSavedMnPo);
                    }
                    // 마켓포인트 사용 가능 여부 수정
                    proxyDao.update(MapperConstants.SAVEDMN_POINT + "updateSvmnUsePsbYn", useSavedMnPo);
                }

            }
        } catch (DuplicateKeyException e) {
            throw new CustomException("biz.exception.common.error", new Object[] { "코드그룹" }, e);
        } catch (Exception e) {
            throw new CustomException("biz.exception.common.error", new Object[] { "코드그룹" }, e);
        }
        return result;
    }

    @Override
    public ResultListModel<SavedmnPointVO> selectPointGetPaging(SavedmnPointSO so) {
        if (so.getSidx().length() == 0) {
            so.setSidx("REG_DTTM");
            so.setSord("ASC");
            so.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
        }
        if (so.getSearchKind() != null && so.getSearchKind() != "") {
            if (("searchMemberNm").equals(so.getSearchKind())) {
                so.setMemberNm(so.getSearchVal());
            }
        }
        // 회원별 포인트 리스트 조회
        ResultListModel<SavedmnPointVO> list = proxyDao
                .selectListPage(MapperConstants.SAVEDMN_POINT + "selectPointGetPaging", so);

        return list;
    }

    @Override
    public ResultModel<SavedmnPointVO> selectTotalPoint(SavedmnPointSO so) {
        ResultModel<SavedmnPointVO> result = new ResultModel<>();
        SavedmnPointVO vo = new SavedmnPointVO();
        if (so.getSearchKind() != null && so.getSearchKind() != "") {
            if (("searchMemberNm").equals(so.getSearchKind())) {
                so.setMemberNm(so.getSearchVal());
            }
        }
        // 회원별 전체 포인트 조회
        List<String> list = proxyDao.selectList(MapperConstants.SAVEDMN_POINT + "selectTotalSaveUsePoint", so);
        vo.setTotalPointPvd((String) list.get(0));
        vo.setTotalPointUse((String) list.get(1));
        result.setData(vo);
        return result;
    }

    @Override
    public ResultModel<SavedmnPointPO> insertPoint(SavedmnPointPO po) {
        ResultModel<SavedmnPointPO> result = new ResultModel<>();
        try {
        	/*
            long seqNo = bizService.getSequence("TC_MEMBER_POINT");
            po.setPointSeq(seqNo);
            // 포인트 정보 등록
            proxyDao.insert(MapperConstants.SAVEDMN_POINT + "insertPoint", po);
            result.setMessage(MessageUtil.getMessage("biz.opeeration.savedMnPoint.insertPoint"));
            */
        	// 포인트 대신 마켓포인트이 지급 되도록 변경
        	po.setPrcAmt(po.getPrcPoint());
        	po.setSvmnUsePsbYn(po.getPointUsePsbYn());
        	// 사유코드 변환
        	switch (po.getReasonCd()) {
        	case "01":
        		po.setReasonCd("07");
        		break;
        	case "03":
        		po.setReasonCd("08");
        		break;
        	case "05":
        		po.setReasonCd("09");
        	}
        	result = this.insertSavedMn(po);
        } catch (DuplicateKeyException e) {
            throw new CustomException("biz.exception.common.error", new Object[] { "코드그룹" }, e);
        } catch (Exception e) {
            throw new CustomException("biz.exception.common.error", new Object[] { "코드그룹" }, e);
        }
        return result;
    }

    @Override
    public int selectPointGiveHistoryCnt(SavedmnPointSO so) {
        int result = 0;
        try {
            // 포인트 지급 내역 건수 조회
//            result = proxyDao.selectOne(MapperConstants.SAVEDMN_POINT + "selectPointGiveHistoryCnt", so);
        	// 마켓포인트 지금내역 건수 조회

        	// 사유코드 변환
        	switch (so.getReasonCd()) {
        	case "01":
        		so.setReasonCd("07");
        		break;
        	case "03":
        		so.setReasonCd("08");
        		break;
        	case "05":
        		so.setReasonCd("09");
        	}
            result = proxyDao.selectOne(MapperConstants.SAVEDMN_POINT + "selectSvmnGiveHistoryCnt", so);
        } catch (Exception e) {
            throw new CustomException("biz.exception.common.error", new Object[] { "코드그룹" }, e);
        }
        return result;
    }

    @Override
    public ResultModel<SavedmnPointPO> deleteSavedMn(MemberManagePO po) {
        ResultModel<SavedmnPointPO> result = new ResultModel<>();
        // 지급/차감 된 마켓포인트 목록 삭제(회원탈퇴시)
        proxyDao.delete(MapperConstants.SAVEDMN_POINT + "deleteSavedMnUse", po);
        proxyDao.delete(MapperConstants.SAVEDMN_POINT + "deleteSavedMnPvd", po);
        // result.setMessage(MessageUtil.getMessage("biz.opeeration.savedMnPoint.insertPoint"));
        return result;
    }

	@Override
	public List<SavedmnPointVO> selectOfflineCouponList() {

		List<SavedmnPointVO> list = proxyDao.selectList(MapperConstants.SAVEDMN_POINT + "selectOfflineCouponList");
		
		return list;

	}

    /** 포인트 설정 정보 조회 서비스 **/
    /*
     * (non-Javadoc)
     *
     * @see PointConfigService#
     * selectPointConfig(net.danvi.dmall.biz.app.setup.point.model.
     * PointConfigSO)
     */
    @Override
    @Transactional(readOnly = true)
    public ResultModel<PointConfigVO> selectPointConfig(PointConfigSO so) {
        PointConfigVO resultVO = proxyDao.selectOne(MapperConstants.SAVEDMN_POINT + "selectPointConfig", so);
        ResultModel<PointConfigVO> result = new ResultModel<>(resultVO);
        return result;
    }

    /** 포인트 설정 정보 수정 서비스 **/
    /*
     * (non-Javadoc)
     *
     * @see PointConfigService#
     * updatePointConfig(net.danvi.dmall.biz.app.setup.point.model.
     * PointConfigPO)
     */
    @Override
    public ResultModel<PointConfigPO> updatePointConfig(PointConfigPO po) throws Exception {
        ResultModel<PointConfigPO> resultModel = new ResultModel<>();
        po.setUpdrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
        po.setRegrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
        proxyDao.update(MapperConstants.SAVEDMN_POINT + "updatePointConfig", po);

        // 프론트 사이트 정보 갱신
        /*HttpServletRequest request = HttpUtil.getHttpServletRequest();
        adminRemotingService.refreshSiteInfoCache(po.getSiteNo(), request.getServerName());*/

        resultModel.setMessage(MessageUtil.getMessage("biz.common.update"));
        return resultModel;
    }
}
