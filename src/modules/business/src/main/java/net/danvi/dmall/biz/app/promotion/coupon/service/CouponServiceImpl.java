package net.danvi.dmall.biz.app.promotion.coupon.service;

import java.util.*;

import javax.annotation.Resource;

import net.danvi.dmall.biz.app.operation.model.ReplaceCdVO;
import net.danvi.dmall.biz.app.operation.model.SmsSendSO;
import net.danvi.dmall.biz.app.operation.service.SmsSendService;
import org.apache.commons.lang3.StringUtils;
import org.springframework.dao.DuplicateKeyException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import dmall.framework.common.BaseService;
import dmall.framework.common.constants.MapperConstants;
import dmall.framework.common.exception.CustomException;
import dmall.framework.common.model.ResultListModel;
import dmall.framework.common.model.ResultModel;
import dmall.framework.common.util.MessageUtil;
import lombok.extern.slf4j.Slf4j;
import net.danvi.dmall.biz.app.goods.model.CategorySO;
import net.danvi.dmall.biz.app.goods.model.CategoryVO;
import net.danvi.dmall.biz.app.goods.model.GoodsCtgVO;
import net.danvi.dmall.biz.app.goods.service.CategoryManageService;
import net.danvi.dmall.biz.app.member.manage.model.MemberManagePO;
import net.danvi.dmall.biz.app.operation.model.SavedmnPointPO;
import net.danvi.dmall.biz.app.operation.service.SavedMnPointService;
import net.danvi.dmall.biz.app.promotion.coupon.model.CouponPO;
import net.danvi.dmall.biz.app.promotion.coupon.model.CouponPOListWrapper;
import net.danvi.dmall.biz.app.promotion.coupon.model.CouponSO;
import net.danvi.dmall.biz.app.promotion.coupon.model.CouponVO;
import net.danvi.dmall.biz.app.promotion.coupon.model.CpTargetVO;
import net.danvi.dmall.biz.system.security.SessionDetailHelper;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 5. 3.
 * 작성자     : 이헌철
 * 설명       : 쿠폰 서비스임플
 * </pre>
 */
@Slf4j
@Service("couponService")
@Transactional(rollbackFor = Exception.class)
public class CouponServiceImpl extends BaseService implements CouponService {

    @Resource(name = "categoryManageService")
    private CategoryManageService categoryManageService;
    
    @Resource(name = "savedMnPointService")
    private SavedMnPointService savedMnPointService;

      @Resource(name = "smsSendService")
    private SmsSendService smsSendService;

    // 쿠폰목록 조회
    @Override
    @Transactional(readOnly = true)
    public List<CouponVO> selectCouponList(CouponSO so) {
        return proxyDao.selectList(MapperConstants.PROMOTION_COUPON + "selectCouponList", so);
    }

    // 쿠폰목록 조회 페이징
    @Override
    public ResultListModel<CouponVO> selectCouponListPaging(CouponSO so) {
        if (so.getSidx().length() == 0) {
            so.setSidx("REG_DTTM");
            so.setSord("DESC");
        }

        return proxyDao.selectListPage(MapperConstants.PROMOTION_COUPON + "selectCouponListPaging", so);
    }

    // 쿠폰 등록
    @Override
    public ResultModel<CouponPO> insertCouponInfo(CouponPO po) throws CustomException {

        // 01.상품쿠폰, 02.주문서쿠폰 구분
        if (po.getCouponKindCd().equals("06")) {
            po.setCouponApplyScopeCd("02");
        } else {
            po.setCouponApplyScopeCd("01");
        }

        // 일 + 시 + 분
        po.setApplyStartDttm(po.getFrom() + " " + po.getFromHour() + ":" + po.getFromMinute());
        po.setApplyEndDttm(po.getTo() + " " + po.getToHoure() + ":" + po.getToMinute());

        // 쿠폰혜택코드내용이 %할인 경우
        if (po.getCouponBnfCd().equals("01")) {
            po.setCouponBnfDcAmt(po.getBnfDcAmt01());
        }

        // 쿠폰혜택코드내용이 금액할인 경우 : %할인값에 0 넣기
        if (po.getCouponBnfCd().equals("02")) {
            po.setCouponBnfDcAmt(po.getBnfDcAmt02());
            po.setCouponBnfValue(0);
        }

        // 쿠폰혜택내용이 콘택트전용 쿠폰 일경우
        if (po.getCouponBnfCd().equals("03")) {
            po.setCouponBnfTxt(po.getBnfDcAmt03());
            po.setCouponBnfDcAmt(0);
            po.setCouponBnfValue(0);
        }

        // 쿠폰유효기간 조건이 시작종료일시 지정 경우 : 몇일동안 값에 0 넣기
        if (po.getCouponApplyPeriodCd().equals("01")) {
            po.setCouponApplyIssueAfPeriod(0);
        }

        // 쿠폰유효기간 조건이 '발급일로부터 XX일'이면, 시작종료일시에 null넣기
        if (po.getCouponApplyPeriodCd().equals("02") || po.getCouponApplyPeriodCd().equals("03")) {
            po.setApplyStartDttm(null);
            po.setApplyEndDttm(null);
        }

        // 적용코드가 상품+카테고리 선택일 경우 값을 03으로 변경 : 전체상품일 경우에는 적용코드가 null이라 조건주기
        if (!po.getCouponApplyLimitCd().equals("01")) {
            if (po.getCouponApplyTargetCd().equals("01,02")) {
                po.setCouponApplyTargetCd("03");
            }
        }

        // 중복 다운로드 가능 : 체크되지 않았을 경우에 'N'값 주입
        if (po.getCouponDupltDwldPsbYn() == null || po.getCouponDupltDwldPsbYn().equals("")) {
            po.setCouponDupltDwldPsbYn("N");
        }

        // 예약전용 쿠폰 : 체크되지 않았을 경우에 'N'값 주입
        if ( (po.getRsvOnlyYn() == null || po.getRsvOnlyYn().equals("")) && (!po.getCouponKindCd().equals("99") && !po.getCouponKindCd().equals("97"))) {
            po.setRsvOnlyYn("N");
        }

        // 오프라인전용 쿠폰 : 체크되지 않았을 경우에 'N'값 주입
        if (po.getOfflineOnlyYn() == null || po.getOfflineOnlyYn().equals("")) {
            po.setOfflineOnlyYn("N");
        }

        // 적용조건이 전체일 경우 : 적용상품, 예외상품, 적용카테, 예외카테 모두 삭제

        // 전체상품이 아닐 경우에만 쿠폰 대상 주입
        if (!po.getCouponApplyLimitCd().equals("01")) {
            // 적용조건이 적용이고 상품일 경우 : 적용카테, 예외상품, 예외카테 모두 삭제
            if (po.getCouponApplyLimitCd().equals("02") && po.getCouponApplyTargetCd().equals("01")) {
                po.setGoodsNoArr(po.getApplyGoodsNoArr());
            }
            // 적용조건이 적용이고 카테일 경우 : 적용상품, 예외상품, 예외카테 모두 삭제
            if (po.getCouponApplyLimitCd().equals("02") && po.getCouponApplyTargetCd().equals("02")) {
                po.setCtgNoArr(po.getApplyCtgNoArr());
            }
            // 적용조건이 적용이고 상품+카테일 경우 : 예외상품, 예외카테 모두 삭제
            if (po.getCouponApplyLimitCd().equals("02") && po.getCouponApplyTargetCd().equals("03")) {
                po.setGoodsNoArr(po.getApplyGoodsNoArr());
                po.setCtgNoArr(po.getApplyCtgNoArr());
            }
            // 적용조건이 예외이고 상품일 경우 : 적용상품, 적용카테, 예외카테 모두 삭제
            if (po.getCouponApplyLimitCd().equals("03") && po.getCouponApplyTargetCd().equals("01")) {
                po.setGoodsNoArr(po.getExceptGoodsNoArr());
            }
            // 적용조건이 예외이고 카테일 경우 : 적용상품, 적용카테, 예외상품 모두 삭제
            if (po.getCouponApplyLimitCd().equals("03") && po.getCouponApplyTargetCd().equals("02")) {
                po.setCtgNoArr(po.getExceptCtgNoArr());
            }
            // 적용조건이 예외이고 상품+카테일 경우 : 적용상품, 적용카테 모두 삭제
            if (po.getCouponApplyLimitCd().equals("03") && po.getCouponApplyTargetCd().equals("03")) {
                po.setGoodsNoArr(po.getExceptGoodsNoArr());
                po.setCtgNoArr(po.getExceptCtgNoArr());
            }
        }

        ResultModel<CouponPO> result = new ResultModel<>();

        try {
            // 기본 쿠폰정보 등록
            proxyDao.insert(MapperConstants.PROMOTION_COUPON + "insertCouponInfo", po);

            // 쿠폰대상 등록: 전체상품
            if (po.getCouponApplyLimitCd().equals("01")) {
                // 사이트번호로 전체상품을 조회한 후, 쿠폰번호를 삽입

                /*proxyDao.insert(MapperConstants.PROMOTION_COUPON + "insertCouponTargetGoodsList", po);*/
                List<CouponPO> targetResult = proxyDao
                        .selectList(MapperConstants.PROMOTION_COUPON + "selectTotalGoodsList", po);
                for (int i = 0; i < targetResult.size(); i++) {
                    po.setGoodsNo(targetResult.get(i).getGoodsNo());
                    proxyDao.insert(MapperConstants.PROMOTION_COUPON + "insertCouponTargetGoods", po);
                }
            }

            // 쿠폰대상 등록 : 상품 등록/ 카테 등록/ 상품+카테
            if (po.getCouponApplyLimitCd().equals("02") || po.getCouponApplyLimitCd().equals("03")) {
                if (po.getCouponApplyTargetCd().equals("01")) {
                    String[] goodsNoArr = po.getGoodsNoArr();
                    if (goodsNoArr != null) {
                        for (int k = 0; k < goodsNoArr.length; k++) {
                            po.setGoodsNo(goodsNoArr[k]);
                            proxyDao.insert(MapperConstants.PROMOTION_COUPON + "insertCouponTargetGoods", po);
                        }
                    }
                }
                if (po.getCouponApplyTargetCd().equals("02")) {
                    int[] ctgNoArr = po.getCtgNoArr();
                    if (ctgNoArr != null) {
                        for (int j = 0; j < ctgNoArr.length; j++) {
                            po.setCtgNo(ctgNoArr[j]);
                            proxyDao.insert(MapperConstants.PROMOTION_COUPON + "insertCouponTargetCtg", po);
                        }
                    }
                }
                if (po.getCouponApplyTargetCd().equals("03")) {
                    String[] goodsNoArr = po.getGoodsNoArr();
                    if (goodsNoArr != null) {
                        for (int k = 0; k < goodsNoArr.length; k++) {
                            po.setGoodsNo(goodsNoArr[k]);
                            proxyDao.insert(MapperConstants.PROMOTION_COUPON + "insertCouponTargetGoods", po);
                        }
                    }
                    int[] ctgNoArr = po.getCtgNoArr();
                    if (ctgNoArr != null) {
                        for (int j = 0; j < ctgNoArr.length; j++) {
                            po.setCtgNo(ctgNoArr[j]);
                            proxyDao.insert(MapperConstants.PROMOTION_COUPON + "insertCouponTargetCtg", po);
                        }
                    }
                }
            }
        } catch (DuplicateKeyException e) {
            throw new CustomException("biz.exception.common.exist", new Object[] { "쿠폰등록" }, e);
        }
        result.setMessage(MessageUtil.getMessage("biz.common.insert"));
        return result;
    }

    // 쿠폰 수정
    @Override
    public ResultModel<CouponPO> updateCouponInfo(CouponPO po) throws CustomException {
        ResultModel<CouponPO> result = new ResultModel<>();

        // 01.상품쿠폰, 02.주문서쿠폰 구분
        if (po.getCouponKindCd().equals("06")) {
            po.setCouponApplyScopeCd("02");
        } else {
            po.setCouponApplyScopeCd("01");
        }

        // 일 + 시 + 분
        po.setApplyStartDttm(po.getFrom() + " " + po.getFromHour() + ":" + po.getFromMinute());
        po.setApplyEndDttm(po.getTo() + " " + po.getToHoure() + ":" + po.getToMinute());

        // 쿠폰혜택코드내용이 %할인 경우
        if (po.getCouponBnfCd().equals("01")) {
            po.setCouponBnfDcAmt(po.getBnfDcAmt01());
        }
        // 쿠폰혜택코드내용이 금액할인 경우 : %할인값에 0 넣기
        if (po.getCouponBnfCd().equals("02")) {
            po.setCouponBnfDcAmt(po.getBnfDcAmt02());
            po.setCouponBnfValue(0);
        }
        // 쿠폰혜택내용이 콘택트전용 쿠폰 일경우
        if (po.getCouponBnfCd().equals("03")) {
            po.setCouponBnfTxt(po.getBnfDcAmt03());
            po.setCouponBnfDcAmt(0);
            po.setCouponBnfValue(0);
        }

        // 적용기간코드내용이 시작종료일시 지정 경우 : 몇일동안 값에 0 넣기
        if (po.getCouponApplyPeriodCd().equals("01")) {
            po.setCouponApplyIssueAfPeriod(0);
        }
        // 적용기간코드내용이 '발급일로부터 XX일' 경우 : 시작종료일시에 null넣기
        if (po.getCouponApplyPeriodCd().equals("02") || po.getCouponApplyPeriodCd().equals("03") ) {
            po.setApplyStartDttm(null);
            po.setApplyEndDttm(null);
        }

        // 적용코드가 상품+카테고리 선택일 경우 값을 03으로 변경 : 전체상품일 경우에는 적용코드가 null이라 조건주기
        if (!po.getCouponApplyLimitCd().equals("01")) {
            if (po.getCouponApplyTargetCd().equals("01,02")) {
                po.setCouponApplyTargetCd("03");
            }
        }

        // 중복 다운로드 가능 : 체크되지 않았을 경우에 'N'값 주입
        if (po.getCouponDupltDwldPsbYn() == null || po.getCouponDupltDwldPsbYn().equals("")) {
            po.setCouponDupltDwldPsbYn("N");
        }
        // 예약전용 쿠폰 : 체크되지 않았을 경우에 'N'값 주입
        if ( (po.getRsvOnlyYn() == null || po.getRsvOnlyYn().equals("")) && (!po.getCouponKindCd().equals("99") && !po.getCouponKindCd().equals("97"))) {
            po.setRsvOnlyYn("N");
        }

        // 오프라인전용 쿠폰 : 체크되지 않았을 경우에 'N'값 주입
        if (po.getOfflineOnlyYn() == null || po.getOfflineOnlyYn().equals("")) {
            po.setOfflineOnlyYn("N");
        }

        // 적용조건이 전체일 경우 : 적용상품, 예외상품, 적용카테, 예외카테 모두 삭제

        // 전체상품이 아닐 경우에만 쿠폰 대상 주입
        if (!po.getCouponApplyLimitCd().equals("01")) {
            // 적용조건이 적용이고 상품일 경우 : 적용카테, 예외상품, 예외카테 모두 삭제
            if (po.getCouponApplyLimitCd().equals("02") && po.getCouponApplyTargetCd().equals("01")) {
                po.setGoodsNoArr(po.getApplyGoodsNoArr());
            }
            // 적용조건이 적용이고 카테일 경우 : 적용상품, 예외상품, 예외카테 모두 삭제
            if (po.getCouponApplyLimitCd().equals("02") && po.getCouponApplyTargetCd().equals("02")) {
                po.setCtgNoArr(po.getApplyCtgNoArr());
            }
            // 적용조건이 적용이고 상품+카테일 경우 : 예외상품, 예외카테 모두 삭제
            if (po.getCouponApplyLimitCd().equals("02") && po.getCouponApplyTargetCd().equals("03")) {
                po.setGoodsNoArr(po.getApplyGoodsNoArr());
                po.setCtgNoArr(po.getApplyCtgNoArr());
            }
            // 적용조건이 예외이고 상품일 경우 : 적용상품, 적용카테, 예외카테 모두 삭제
            if (po.getCouponApplyLimitCd().equals("03") && po.getCouponApplyTargetCd().equals("01")) {
                po.setGoodsNoArr(po.getExceptGoodsNoArr());
            }
            // 적용조건이 예외이고 카테일 경우 : 적용상품, 적용카테, 예외상품 모두 삭제
            if (po.getCouponApplyLimitCd().equals("03") && po.getCouponApplyTargetCd().equals("02")) {
                po.setCtgNoArr(po.getExceptCtgNoArr());
            }
            // 적용조건이 예외이고 상품+카테일 경우 : 적용상품, 적용카테 모두 삭제
            if (po.getCouponApplyLimitCd().equals("03") && po.getCouponApplyTargetCd().equals("03")) {
                po.setGoodsNoArr(po.getExceptGoodsNoArr());
                po.setCtgNoArr(po.getExceptCtgNoArr());
            }
        }

        try {
            // 기본정보 업데이트
            proxyDao.update(MapperConstants.PROMOTION_COUPON + "updateCouponInfo", po);

            String couponApplyTargetCd = po.getCouponApplyTargetCd();
            // (수정 전)쿠폰대상 상품 삭제 : 01.상품 03.상품+카테고리
            if (couponApplyTargetCd != null && (couponApplyTargetCd.equals("01") || couponApplyTargetCd.equals("03"))) {
                proxyDao.delete(MapperConstants.PROMOTION_COUPON + "deleteCouponTargetGoods", po);
            }
            // (수정 전)쿠폰대상 카테고리 삭제 : 02.카테고리 03.상품+카테고리
            if (couponApplyTargetCd != null && (couponApplyTargetCd.equals("02") || couponApplyTargetCd.equals("03"))) {
                proxyDao.delete(MapperConstants.PROMOTION_COUPON + "deleteCouponTargetCtg", po);
            }

            // 쿠폰대상 등록 : 전체상품
            if (po.getCouponApplyLimitCd().equals("01")) {
                // 사이트번호로 전체상품을 조회한 후, 쿠폰번호를 삽입
                List<CouponPO> targetResult = proxyDao
                        .selectList(MapperConstants.PROMOTION_COUPON + "selectTotalGoodsList", po);
                for (int i = 0; i < targetResult.size(); i++) {
                    po.setGoodsNo(targetResult.get(i).getGoodsNo());
                    proxyDao.insert(MapperConstants.PROMOTION_COUPON + "insertCouponTargetGoods", po);
                }
            }

            // 쿠폰대상 등록 : 상품 등록/ 카테 등록/ 상품+카테
            if (po.getCouponApplyLimitCd().equals("02") || po.getCouponApplyLimitCd().equals("03")) {
                if (po.getCouponApplyTargetCd().equals("01")) {
                    String[] goodsNoArr = po.getGoodsNoArr();
                    if (goodsNoArr != null) {
                        for (int k = 0; k < goodsNoArr.length; k++) {
                            po.setGoodsNo(goodsNoArr[k]);
                            proxyDao.insert(MapperConstants.PROMOTION_COUPON + "insertCouponTargetGoods", po);
                        }
                    }
                }
                if (po.getCouponApplyTargetCd().equals("02")) {
                    int[] ctgNoArr = po.getCtgNoArr();
                    if (ctgNoArr != null) {
                        for (int j = 0; j < ctgNoArr.length; j++) {
                            po.setCtgNo(ctgNoArr[j]);
                            proxyDao.insert(MapperConstants.PROMOTION_COUPON + "insertCouponTargetCtg", po);
                        }
                    }
                }
                if (po.getCouponApplyTargetCd().equals("03")) {
                    String[] goodsNoArr = po.getGoodsNoArr();
                    if (goodsNoArr != null) {
                        for (int k = 0; k < goodsNoArr.length; k++) {
                            po.setGoodsNo(goodsNoArr[k]);
                            proxyDao.insert(MapperConstants.PROMOTION_COUPON + "insertCouponTargetGoods", po);
                        }
                    }
                    int[] ctgNoArr = po.getCtgNoArr();
                    if (ctgNoArr != null) {
                        for (int j = 0; j < ctgNoArr.length; j++) {
                            po.setCtgNo(ctgNoArr[j]);
                            proxyDao.insert(MapperConstants.PROMOTION_COUPON + "insertCouponTargetCtg", po);
                        }
                    }
                }
            }
        } catch (DuplicateKeyException e) {
            throw new CustomException("biz.exception.common.exist", new Object[] { "쿠폰수정" }, e);
        }
        result.setMessage(MessageUtil.getMessage("biz.common.update"));
        return result;
    }

    // 쿠폰 삭제
    @Override
    public ResultModel<CouponPO> deleteCouponInfo(CouponPOListWrapper wrapper) throws Exception {
        ResultModel<CouponPO> result = new ResultModel<>();

        try {
            proxyDao.update(MapperConstants.PROMOTION_COUPON + "deleteCouponInfo", wrapper);

            for (int i = 0; i < wrapper.getList().size(); i++) {
                CouponPO po = wrapper.getList().get(i);

                if(po.getCouponApplyLimitCd().equals("01")) {
                    proxyDao.delete(MapperConstants.PROMOTION_COUPON + "deleteCouponTargetGoods", po);
                } else {
                    if(po.getCouponApplyTargetCd().equals("01")) {
                        proxyDao.delete(MapperConstants.PROMOTION_COUPON + "deleteCouponTargetGoods", po);
                    }
                    if(po.getCouponApplyTargetCd().equals("02")) {
                        proxyDao.delete(MapperConstants.PROMOTION_COUPON + "deleteCouponTargetCtg", po);
                    }
                }

                // 회원이 발급 받았지만 사용하지 않은 쿠폰을 삭제
                proxyDao.delete(MapperConstants.PROMOTION_COUPON + "deleteCouponMemberHas", po);
            }

            result.setMessage(MessageUtil.getMessage("biz.common.delete"));
        } catch (DuplicateKeyException e) {
            throw new CustomException("biz.exception.common.exist", new Object[] { "쿠폰 삭제" }, e);
        }
        return result;
    }

    // 쿠폰 상세 조회(단건)
    @Override
    public ResultModel<CouponVO> selectCouponDtl(CouponSO so) throws Exception {
        CouponVO vo = proxyDao.selectOne(MapperConstants.PROMOTION_COUPON + "selectCouponInfo", so);
        if (!vo.getCouponApplyLimitCd().equals("01")) { // 전체상품 조건이면 대상목록 불필요
            if(vo.getCouponApplyTargetCd().equals("01")) {
                // 상품 목록
                List<CpTargetVO> goodsList = proxyDao.selectList(MapperConstants.PROMOTION_COUPON + "selectCouponTargetGoodsList", so);
                vo.setCouponTargetGoodsList(goodsList);
            }

            if(vo.getCouponApplyTargetCd().equals("02")) {

            }
        }
        ResultModel<CouponVO> result = new ResultModel<>(vo);
        return result;
    }

    // 쿠폰 발급
    @Override
    public ResultModel<CouponPO> insertCouponIssue(CouponPO po) throws Exception{

        ResultModel<CouponPO> result = new ResultModel<>();
        try {
            // 전체회원 선택일 경우
            if (po.getIssueTarget().equals("01")) {
                // 사이트번호 조건으로 전체회원의 번호를 가져와서 발급
                /*List<CpTargetVO> targetResult = proxyDao.selectList(MapperConstants.PROMOTION_COUPON + "selectMemberTotalList", po);
                for (int i = 0; i < targetResult.size(); i++) {
                    po.setMemberNo(targetResult.get(i).getMemberNo());
                    proxyDao.insert(MapperConstants.PROMOTION_COUPON + "insertCouponIssue", po);
                }*/
                    proxyDao.insert(MapperConstants.PROMOTION_COUPON + "insertCouponIssueToAll", po);

            }

            // 그룹회원 선택일 경우
            if (po.getIssueTarget().equals("02")) {
                // 사이트번호 그룹번호로 그룹회원의 번호를 가져와서 발급
                /*List<CpTargetVO> targetResult = proxyDao.selectList(MapperConstants.PROMOTION_COUPON + "selectMemberGroupList", po);
                for (int i = 0; i < targetResult.size(); i++) {
                    po.setMemberNo(targetResult.get(i).getMemberNo());
                    proxyDao.insert(MapperConstants.PROMOTION_COUPON + "insertCouponIssue", po);
                }*/
                proxyDao.insert(MapperConstants.PROMOTION_COUPON + "insertCouponIssueToGroup", po);
            }


            // 개별회원 선택일 경우
            if (po.getIssueTarget().equals("03")) {
                long[] memberNoArr = po.getMemberNoArr();
                String [] cpIssueNo = null;
                if(memberNoArr!=null && memberNoArr.length>0){
                    cpIssueNo = new String[memberNoArr.length];

                }else{
                    cpIssueNo = new String[1];
                }
                if (memberNoArr != null) {// 다건(다수발행)

                    for (int i = 0; i < memberNoArr.length; i++) {
                        po.setMemberNo(memberNoArr[i]);
                         proxyDao.insert(MapperConstants.PROMOTION_COUPON + "insertCouponIssue", po);
                         cpIssueNo[i]=po.getCpIssueNo();
                    }
                } else {// 단건(한명발행)
                    proxyDao.insert(MapperConstants.PROMOTION_COUPON + "insertCouponIssue", po);
                    cpIssueNo[0]=po.getCpIssueNo();

                }
                result.setData(po);

            }

            result.setMessage(MessageUtil.getMessage("biz.common.insert"));
        } catch (DuplicateKeyException e) {
            throw new CustomException("biz.exception.common.exist", new Object[] { "쿠폰수정" }, e);
        }
        return result;
    }

    // 상품상세 사용가능한 쿠폰 리스트
    @Override
    @Transactional(readOnly = true)
    public List<CouponVO> selectAvailableGoodsCouponList(CouponSO so) {
        return proxyDao.selectList(MapperConstants.PROMOTION_COUPON + "selectAvailableGoodsCouponList", so);
    }

    // 주문적용시 사용가능 쿠폰 리스트
    @Override
    @Transactional(readOnly = true)
    public List<CouponVO> selectAvailableOrderCouponList(CouponSO so) {
        List<CouponVO> result = new ArrayList<>();

        // 상품쿠폰 조회
        long siteNo = SessionDetailHelper.getDetails().getSession().getSiteNo();
        for (CouponSO goodsInfo : so.getCouopnGoodsInfoList()) {

            String couponCtgNoArr = "";
            List<CategoryVO> parentCtglist = new ArrayList<>();
            List<GoodsCtgVO> ctgList = new ArrayList<>();
            CategorySO categorySO = new CategorySO();
            categorySO.setSiteNo(so.getSiteNo());
            goodsInfo.setSiteNo(so.getSiteNo());
            ctgList = proxyDao.selectList(MapperConstants.PROMOTION_COUPON + "selectGoodsCtgList", goodsInfo);
            for (int i = 0; i < ctgList.size(); i++) {
                GoodsCtgVO gcvs = ctgList.get(i);
                categorySO.setCtgNo(gcvs.getCtgNo());
                parentCtglist = categoryManageService.selectUpNavagation(categorySO);
                for (int k = 0; k < parentCtglist.size(); k++) {
                    CategoryVO vo = (CategoryVO) parentCtglist.get(k);
                    if (!"".equals(couponCtgNoArr)) {
                        couponCtgNoArr += ",";
                    }
                    couponCtgNoArr += vo.getCtgNo();
                }
            }

            log.debug("==== couponCtgNoArr : {}", couponCtgNoArr);
            goodsInfo.setMemberNo(so.getMemberNo());
            goodsInfo.setCouponCtgNoArr(couponCtgNoArr);
            goodsInfo.setSiteNo(siteNo);
            List<CouponVO> couponGoodsList = proxyDao.selectList(MapperConstants.PROMOTION_COUPON + "selectGoodsAvailableCouponList", goodsInfo);
            result.addAll(couponGoodsList);

            // 주문쿠폰 조회
            List<CouponVO> couponOrderList = proxyDao.selectList(MapperConstants.PROMOTION_COUPON + "selectOrderAvailableCouponList", so);
            result.addAll(couponOrderList);
        }


        // 중복제거
        HashSet hs = new HashSet(result);
        List<CouponVO> resultList = new ArrayList<CouponVO>(hs);

        return resultList;
    }

    // 쿠폰 적용 대상 조회
    @Override
    public ResultModel<CouponVO> selectCouponApplyTargetList(CouponSO so) {
        CouponVO vo = new CouponVO();
        ResultModel<CouponVO> result = new ResultModel<>();
        List<CpTargetVO> list = new ArrayList<>();

        if (StringUtils.equals("01", so.getCouponApplyTargetCd())) { // 상품
            list = proxyDao.selectList(MapperConstants.PROMOTION_COUPON + "selectCouponTargetGoodsList", so);
            vo.setCouponTargetGoodsList(list);
        } else if (StringUtils.equals("02", so.getCouponApplyTargetCd())) { // 카테고리
            list = proxyDao.selectList(MapperConstants.PROMOTION_COUPON + "selectCouponTargetCtgList", so);
            vo.setCouponTargetCtgList(list);
        } else if (StringUtils.equals("03", so.getCouponApplyTargetCd())) { // 상품+카테고리
            list = proxyDao.selectList(MapperConstants.PROMOTION_COUPON + "selectCouponTargetGoodsList", so);
            vo.setCouponTargetGoodsList(list);
            list = proxyDao.selectList(MapperConstants.PROMOTION_COUPON + "selectCouponTargetCtgList", so);
            vo.setCouponTargetCtgList(list);
        }
        result.setData(vo);

        return result;
    }

    /* 발급 후보 회원목록 */
    @Override
    public List<CpTargetVO> selectIssueTargetListPop(CouponSO so) {
        // TODO Auto-generated method stub
        List<CpTargetVO> issueTargetListResult = proxyDao
                .selectList(MapperConstants.PROMOTION_COUPON + "selectIssueTargetListPop", so);
        return issueTargetListResult;
    }

    /* 발급 받은 회원목록 */
    @Override
    public List<CpTargetVO> selectIssuedTargetListPop(CouponSO so) {
        // TODO Auto-generated method stub
        List<CpTargetVO> issuedTargetListResult = proxyDao
                .selectList(MapperConstants.PROMOTION_COUPON + "selectIssuedTargetListPop", so);
        return issuedTargetListResult;
    }

    // 쿠폰발급/사용내역 조회
    @Override
    public ResultListModel<CpTargetVO> selectCouponIssueUseHist(CouponSO so) {
        // TODO Auto-generated method stub
        so.setSearchWordsNoChiper(so.getSearchWords()); // 회원이름은 암호화, 로그인아이디는 암호화X. 그래서 빈 두개 사용.
        ResultListModel<CpTargetVO> issueUseHistResult = proxyDao
                .selectListPage(MapperConstants.PROMOTION_COUPON + "selectCouponIssueUseHist", so);
        return issueUseHistResult;
    }

    // 사용하지 않은 회원 보유 쿠폰 조회
    public int selectMemberCoupon(CouponSO so) {
        int cnt = proxyDao.selectOne(MapperConstants.PROMOTION_COUPON + "selectMemberCoupon", so);
        return cnt;
    }

    // 회원쿠폰 사용정보 수정
    public ResultModel<CouponPO> updateMemberUseCoupon(List<CouponPO> poList) throws Exception {
        ResultModel<CouponPO> result = new ResultModel<>();
        try {
            for (CouponPO po : poList) {
                proxyDao.update(MapperConstants.PROMOTION_COUPON + "updateMemberUseCoupon", po);
            }
            result.setMessage(MessageUtil.getMessage("biz.common.update"));
        } catch (DuplicateKeyException e) {
            throw new CustomException("biz.exception.common.error", new Object[] { "회원 쿠폰 사용 등록" }, e);
        }
        return result;
    }

    /**
     * 회원탈퇴시 발급한 쿠폰 모두 삭제처리하는 메서드
     */
    public ResultModel<MemberManagePO> deleteMemberCoupon(MemberManagePO po) throws Exception {
        ResultModel<MemberManagePO> result = new ResultModel<>();
        try {
            proxyDao.delete(MapperConstants.PROMOTION_COUPON + "deleteMemberCoupon", po);
        } catch (Exception e) {
            throw new CustomException("biz.exception.common.exist", new Object[] { "탈퇴쿠폰삭제처리 실패" }, e);
        }
        return result;
    }

    /**
     * 오프라인 쿠폰 발급
     */
	@Override
	public ResultModel<SavedmnPointPO> issueOfflineCoupon(SavedmnPointPO po) throws Exception {

		// 마켓포인트 사용 가능 여부
		po.setSvmnUsePsbYn("Y");
		// 등록자 번호
		po.setRegrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
		// 마켓포인트 차감 구분 코드 (사용)
		po.setDeductGbCd("01");
      
		// 포인트 차감
        ResultModel<SavedmnPointPO> result = savedMnPointService.insertSavedMn(po);

        if (!result.isSuccess()) {
            log.error("=== insertSavedMn ERROR : {}", result.getMessage());
            throw new Exception(result.getMessage());
        }
        
        
    	CouponPO cpo = new CouponPO();
    	cpo.setCouponNo(po.getCouponNo());
    	cpo.setCouponKindCd(po.getCouponKindCd());
    	cpo.setMemberNo(po.getMemberNo());
    	cpo.setIssueTarget("03");
    	cpo.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
    	cpo.setRegrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
    	
    	// 쿠폰 발급
    	ResultModel<CouponPO> couponResult = this.insertCouponIssue(cpo);
        
    	if (!couponResult.isSuccess()) {
            log.error("=== insertCouponIssue ERROR : {}", couponResult.getMessage());
            throw new Exception(couponResult.getMessage());
        }
    	
    	return result;
	}
	
	/**
     * 예약전용 쿠폰 발급
     */
	@Override
	public ResultModel<CouponPO> rsvOnlyCoupon(CouponPO po) throws Exception {

		ResultModel<CouponPO> result = new ResultModel<>();
		
		po.setIssueTarget("03");
    	po.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
    	po.setRegrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
    	
		List<CouponPO> rsvOnlyCouponList = proxyDao.selectList(MapperConstants.PROMOTION_COUPON + "selectRsvOnlyCouponList", po);
		
		if(rsvOnlyCouponList.size() > 0){
		    String [] cpIssueNo = null;
		    if(rsvOnlyCouponList!=null && rsvOnlyCouponList.size()>0){
                cpIssueNo = new String[rsvOnlyCouponList.size()];
            }else{
                cpIssueNo = new String[1];
            }

			for(int i=0;i<rsvOnlyCouponList.size();i++){
				po.setCouponNo(rsvOnlyCouponList.get(i).getCouponNo());
				// 쿠폰 발급
		    	result = this.insertCouponIssue(po);

		    	cpIssueNo[i]= result.getData().getCpIssueNo();

		    	try {
                    //예약전용 오프라인 쿠폰발행 SMS / 알림톡 발송
                    CouponSO so = new CouponSO();
                    so.setCouponNo(po.getCouponNo());
                    so.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
                    so.setMemberNo(po.getMemberNo());
                    so.setCpIssueNo(po.getCpIssueNo());

                    CouponVO couponInfo = this.selectMemberCouponInfo(so);

                    SmsSendSO smsSendSo = new SmsSendSO();
                    smsSendSo.setTemplateCode("mk008");
                    smsSendSo.setSendTypeCd("24");

                    smsSendSo.setReceiverId(SessionDetailHelper.getDetails().getSession().getLoginId());
                    smsSendSo.setReceiverNm(SessionDetailHelper.getDetails().getSession().getMemberNm());
                    smsSendSo.setRecvTelno(SessionDetailHelper.getDetails().getSession().getMobile());
                    smsSendSo.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
                    smsSendSo.setMemberNo(po.getMemberNo());

                    ReplaceCdVO smsReplaceVO = new ReplaceCdVO();

                    //쿠폰번호
                    smsReplaceVO.setCouponNo(Integer.parseInt(couponInfo.getCpIssueNo()));
                    //쿠폰명
                    smsReplaceVO.setCouponNm(couponInfo.getCouponNm());
                    //사용기한
                    smsReplaceVO.setApplyEndDttm(couponInfo.getCpApplyEndDttm());

                    smsSendService.sendAutoSms(smsSendSo, smsReplaceVO);

                }catch (Exception e){
                    e.printStackTrace();
                     log.debug("오프라인 쿠폰발행 SMS 전송 실패 {}" +  e.getMessage());
                }

			}
			po.setCpIssueNoArr(cpIssueNo);
			result.setData(po);
			result.setSuccess(true);


		}else{
			result.setSuccess(false);
		}

    	return result;
	}

	/**
     * 첫구매 쿠폰 발급
     */
	@Override
	public ResultModel<CouponPO> firstOrdCoupon(CouponPO po) throws Exception {

		ResultModel<CouponPO> result = new ResultModel<>();

		po.setIssueTarget("03");
    	po.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
    	po.setRegrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());

		List<CouponPO> firstOrdCouponList = proxyDao.selectList(MapperConstants.PROMOTION_COUPON + "selectFirstOrdCouponList", po);

		if(firstOrdCouponList.size() > 0){
		    String [] cpIssueNo = null;
		    if(firstOrdCouponList!=null && firstOrdCouponList.size()>0){
                cpIssueNo = new String[firstOrdCouponList.size()];
            }else{
                cpIssueNo = new String[1];
            }

			for(int i=0;i<firstOrdCouponList.size();i++){
				po.setCouponNo(firstOrdCouponList.get(i).getCouponNo());
				// 쿠폰 발급
		    	result = this.insertCouponIssue(po);
		    	cpIssueNo[i]= result.getData().getCpIssueNo();
			}
			po.setCpIssueNoArr(cpIssueNo);
			result.setData(po);
			result.setSuccess(true);
		}else{
			result.setSuccess(false);
		}

    	return result;
	}

	// 회원 쿠폰 상세 조회(단건)
    public CouponVO selectMemberCouponInfo(CouponSO so) throws Exception {
        CouponVO vo = proxyDao.selectOne(MapperConstants.PROMOTION_COUPON + "selectMemberCouponInfo", so);
        return vo;
    }

    // 예약시 발급받은 쿠폰 조회
    public List<CouponVO>  selectRsvCouponIssue(String[] cpIssueNo) throws Exception {
        List<CouponVO> cpVoList = proxyDao.selectList(MapperConstants.PROMOTION_COUPON + "selectRsvCouponIssue", cpIssueNo);
        return cpVoList;
    }
    
    // 쿠폰존 사용가능한 쿠폰 리스트
    @Override
    public List<CouponVO> selectAvailableGoodsCouponZoneList(CouponSO so) {
        return proxyDao.selectList(MapperConstants.PROMOTION_COUPON + "selectAvailableGoodsCouponZoneList", so);
    }

    @Override
    public Map<String, Object> selectAvailableGoodsCouponZoneNewList(CouponSO so) {
        Map result = new HashMap();
        List<CouponVO> goodsType = proxyDao.selectList(MapperConstants.PROMOTION_COUPON + "selectAvailableGoodsCouponGoodsTypeList", so);
        result.put("couponTypeList", goodsType);


        for(int i=0; i<goodsType.size(); i++) {
            CouponVO vo = new CouponVO();
            vo = (CouponVO)goodsType.get(i);
            vo.setSiteNo(so.getSiteNo());
            vo.setAgeRange(so.getAgeRange());
            vo.setMemberNo(so.getMemberNo());
            vo.setCouponOnlineYn(so.getCouponOnlineYn());
            vo.setAgeCd(so.getAgeCd());
            List<CouponVO> couponList = proxyDao.selectList(MapperConstants.PROMOTION_COUPON + "selectAvailableGoodsCouponZoneList", vo);
            result.put("couponList"+i, couponList);
        }

        return result;
    }
    
    // 다운로드 가능한 쿠폰 갯수
    @Override
    public int selectAvailableDownloadCouponCnt(CouponSO couponSO){
    	return proxyDao.selectOne(MapperConstants.PROMOTION_COUPON + "selectAvailableDownloadCouponCnt", couponSO);
    }
    
    // 증정 쿠폰 갯수
    @Override
    public int selectGoodsPreGoodsCnt(CouponSO couponSO){
    	return proxyDao.selectOne(MapperConstants.PROMOTION_COUPON + "selectGoodsPreGoodsCnt", couponSO);
    }

    // 증정 쿠폰 발급 수량 체크
    @Override
    public String selectCouponLimitQttYn(CouponSO couponSO){
    	return proxyDao.selectOne(MapperConstants.PROMOTION_COUPON + "selectCouponLimitQttCheck", couponSO);
    }


    // 쿠폰 복사
    @Override
    public ResultModel<CouponPO> copyCouponInfo(CouponPO po) throws CustomException {

        ResultModel<CouponPO> result = new ResultModel<>();

        try {
            // 기본 쿠폰정보 복사
            proxyDao.insert(MapperConstants.PROMOTION_COUPON + "copyCouponInfo", po);
            // 쿠폰대상 복사
            proxyDao.insert(MapperConstants.PROMOTION_COUPON + "copyCouponTargetGoods", po);

        } catch (DuplicateKeyException e) {
            throw new CustomException("biz.exception.common.exist", new Object[] { "쿠폰복사" }, e);
        }
        result.setMessage(MessageUtil.getMessage("biz.common.insert"));
        return result;
    }

}
