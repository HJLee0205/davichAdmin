
package net.danvi.dmall.biz.app.promotion.freebiecndt.service;

import java.util.List;

import net.danvi.dmall.biz.app.promotion.freebiecndt.model.FreebieCndtPO;
import net.danvi.dmall.biz.app.promotion.freebiecndt.model.FreebieCndtSO;
import net.danvi.dmall.biz.app.promotion.freebiecndt.model.FreebieCndtVO;
import net.danvi.dmall.biz.app.promotion.freebiecndt.model.FreebieGoodsVO;
import org.springframework.dao.DuplicateKeyException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import net.danvi.dmall.biz.app.promotion.freebiecndt.model.FreebieCndtPOListWrapper;
import net.danvi.dmall.biz.app.promotion.freebiecndt.model.FreebieTargetVO;
import dmall.framework.common.BaseService;
import dmall.framework.common.constants.MapperConstants;
import dmall.framework.common.exception.CustomException;
import dmall.framework.common.model.ResultListModel;
import dmall.framework.common.model.ResultModel;
import dmall.framework.common.util.MessageUtil;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 5. 4.
 * 작성자     : 이헌철
 * 설명       : 사은품이벤트 서비스임플
 * </pre>
 */

@Service("freebieCndtService")
@Transactional(rollbackFor = Exception.class)
public class FreebieCndtServiceImpl extends BaseService implements FreebieCndtService {
    // 사은품이벤트 목록 조회 페이징
    @Override
    public ResultListModel<FreebieCndtVO> selectFreebieCndtListPaging(FreebieCndtSO so) {
        if (so.getPeriodSelOption() == null || so.getPeriodSelOption().equals("")) {
            so.setPeriodSelOption("applyStartDttm");
        }
        ResultListModel<FreebieCndtVO> result = proxyDao
                .selectListPage(MapperConstants.PROMOTION_FREBIECNDT + "selectFreebieCndtListPaging", so);
        return result;
    }

    // 사은품이벤트 등록
    @Override
    public ResultModel<FreebieCndtPO> insertFreebieCndt(FreebieCndtPO po) throws Exception {
        ResultModel<FreebieCndtPO> result = new ResultModel<>();

        // 일 + 시 + 분
        po.setApplyStartDttm(po.getFrom() + " " + po.getFromHour() + ":" + po.getFromMinute());
        po.setApplyEndDttm(po.getTo() + " " + po.getToHoure() + ":" + po.getToMinute());

        // 사은품 증정조건코드내용이 총 결제금액에 따른 사은품 증정이면 사은품대상목록 삭제
        if (po.getFreebiePresentCndtCd().equals("01")) {
            po.setGoodsNoArr(null);
        }

        // 사은품 증정조건코드내용이 개별상품으로 선정이면 총 결제금액 0 주입
        if (po.getFreebiePresentCndtCd().equals("02")) {
            po.setFreebieEventAmt(0);
        }

        try {
            proxyDao.insert(MapperConstants.PROMOTION_FREBIECNDT + "insertFreebieCndt", po);
            int freebieEventNo = po.getFreebieEventNo();
            po.setFreebieEventNo(freebieEventNo);

            // 사은품상품 등록
            String[] freebieNoArr = po.getFreebieNoArr();
            for (int i = 0; i < freebieNoArr.length; i++) {
                po.setFreebieNo(freebieNoArr[i]);
                proxyDao.insert(MapperConstants.PROMOTION_FREBIECNDT + "insertFreebieCndtGoods", po);
            }

            // 사은품대상 등록
            if (po.getGoodsNoArr() != null) {
                String[] goodsNoArr = po.getGoodsNoArr();
                for (int i = 0; i < goodsNoArr.length; i++) {
                    po.setGoodsNo(goodsNoArr[i]);
                    proxyDao.insert(MapperConstants.PROMOTION_FREBIECNDT + "insertFreebieCndtTarget", po);
                }
            }
            result.setMessage(MessageUtil.getMessage("biz.common.insert"));
        } catch (DuplicateKeyException e) {
            throw new CustomException("biz.exception.common.exist", new Object[] { "사은품 등록" }, e);
        }
        return result;
    }

    // 사은품이벤트 수정
    @Override
    public ResultModel<FreebieCndtPO> updateFreebieCndt(FreebieCndtPO po) {
        ResultModel<FreebieCndtPO> result = new ResultModel<>();

        // 일 + 시 + 분
        po.setApplyStartDttm(po.getFrom() + " " + po.getFromHour() + ":" + po.getFromMinute());
        po.setApplyEndDttm(po.getTo() + " " + po.getToHoure() + ":" + po.getToMinute());

        // 사은품 증정조건코드내용이 총 결제금액에 따른 사은품 증정이면 사은품대상목록 삭제
        if (po.getFreebiePresentCndtCd().equals("01")) {
            po.setGoodsNoArr(null);
        }

        // 사은품 증정조건코드내용이 개별상품으로 선정이면 총 결제금액 0 주입
        if (po.getFreebiePresentCndtCd().equals("02")) {
            po.setFreebieEventAmt(0);
        }

        try {
            // 사은품기본정보 업데이트
            proxyDao.update(MapperConstants.PROMOTION_FREBIECNDT + "updateFreebieCndt", po);
            // 사은품상품 삭제 : 조건에 상관없이 지움
            proxyDao.delete(MapperConstants.PROMOTION_FREBIECNDT + "deleteFreebieGoods", po);

            // 사은품대상 삭제 : 수정 전 시점에서 사은품 증정조건이 '지정상품 구매'일 경우
            if (po.getFreebiePresentCndtCdOrigin().equals("02")) {
                proxyDao.delete(MapperConstants.PROMOTION_FREBIECNDT + "deleteFreebieTarget", po);
            }

            // 사은품상품 업데이트
            String[] freebieNoArr = po.getFreebieNoArr();
            for (int i = 0; i < freebieNoArr.length; i++) {
                po.setFreebieNo(freebieNoArr[i]);
                proxyDao.insert(MapperConstants.PROMOTION_FREBIECNDT + "insertFreebieCndtGoods", po);
            }

            // 사은품대상 업데이트 : 사은품증정조건이 '지정상품 구매'일 경우
            String[] goodsNoArr = po.getGoodsNoArr();
            if (po.getFreebiePresentCndtCd().equals("02")) {
                for (int j = 0; j < goodsNoArr.length; j++) {
                    po.setGoodsNo(goodsNoArr[j]);
                    proxyDao.insert(MapperConstants.PROMOTION_FREBIECNDT + "insertFreebieCndtTarget", po);
                }
            }
            result.setMessage(MessageUtil.getMessage("biz.common.update"));
        } catch (DuplicateKeyException e) {
            throw new CustomException("biz.exception.common.exist", new Object[] { "사은품 수정" }, e);
        }
        return result;
    }

    // 사은품이벤트 삭제
    @Override
    public ResultModel<FreebieCndtPO> deleteFreebieCndt(FreebieCndtPOListWrapper wrapper) {
        ResultModel<FreebieCndtPO> result = new ResultModel<>();
        try {
            // 사은품기본정보 삭제
            proxyDao.update(MapperConstants.PROMOTION_FREBIECNDT + "deleteFreebieCndt", wrapper);

            for (int i = 0; i < wrapper.getList().size(); i++) {
                FreebieCndtPO po = wrapper.getList().get(i);
                wrapper.setFreebieEventNo(po.getFreebieEventNo());
                String freebiePresentCndtCd = po.getFreebiePresentCndtCd();

                // 사은품상품 삭제
                proxyDao.delete(MapperConstants.PROMOTION_FREBIECNDT + "deleteFreebieGoods", wrapper);

                // 사은품대상 삭제 : 사은품지급조건이 지정상품 구매 경우에만
                if (freebiePresentCndtCd.equals("02")) {
                    proxyDao.delete(MapperConstants.PROMOTION_FREBIECNDT + "deleteFreebieTarget", wrapper);
                }
            }
            result.setMessage(MessageUtil.getMessage("biz.common.delete"));
        } catch (DuplicateKeyException e) {
            throw new CustomException("biz.exception.common.exist", new Object[] { "사은품 삭제" }, e);
        } catch (Exception e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
        return result;
    }

    // 사은품이벤트 상세조회(단건)
    @Override
    @Transactional(readOnly = true)
    public ResultModel<FreebieCndtVO> selectFreebieCndtDtl(FreebieCndtSO so) {
        FreebieCndtVO vo = proxyDao.selectOne(MapperConstants.PROMOTION_FREBIECNDT + "selectFreebieCndtDtl", so);
        ResultModel<FreebieCndtVO> result = new ResultModel<FreebieCndtVO>(vo);

        // 프론트에서 호출할 경우 null체크
        if (vo != null) {
            // 사은품지급조건이 개별상품구매일 경우, 개별상품을 조회한다.
            if (vo.getFreebiePresentCndtCd().equals("02")) {
                List<FreebieTargetVO> targetResult = proxyDao
                        .selectList(MapperConstants.PROMOTION_FREBIECNDT + "selectFreebieTarget", so);
                result.put("targetResult", targetResult);
            }
        }

        List<FreebieGoodsVO> goodsResult = proxyDao
                .selectList(MapperConstants.PROMOTION_FREBIECNDT + "selectFreebieGoods", so);
        result.put("goodsResult", goodsResult);

        return result;
    }

    // 상품번호로 사은품 이벤트 조회
    @Override
    public ResultListModel<FreebieTargetVO> selectFreebieListByGoodsNo(FreebieCndtSO so) {
        // TODO Auto-generated method stub
        ResultListModel<FreebieTargetVO> result = new ResultListModel<FreebieTargetVO>();
        List<FreebieTargetVO> goodsResult = proxyDao.selectList(MapperConstants.PROMOTION_FREBIECNDT + "selectFreebieListByGoodsNo", so);
        result.put("goodsResult", goodsResult);
        return result;
    }

    // 사은품대상 전체조회
    /*
     * @Override
     * public ResultListModel<FreebieTargetVO> selectFreebieTargetTotal() {
     * ResultListModel<FreebieTargetVO> result = new ResultListModel<FreebieTargetVO>();
     * List<FreebieTargetVO> goodsResult = proxyDao
     * .selectList(MapperConstants.PROMOTION_FREBIECNDT + "selectFreebieCndtTargetTotal");
     * result.put("goodsResult", goodsResult);
     * return result;
     * }
     */

}
