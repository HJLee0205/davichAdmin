package net.danvi.dmall.biz.app.promotion.timedeal.service;

import dmall.framework.common.BaseService;
import dmall.framework.common.constants.MapperConstants;
import dmall.framework.common.constants.UploadConstants;
import dmall.framework.common.exception.CustomException;
import dmall.framework.common.model.CmnAtchFileSO;
import dmall.framework.common.model.ResultListModel;
import dmall.framework.common.model.ResultModel;
import dmall.framework.common.util.*;
import lombok.extern.slf4j.Slf4j;
import net.danvi.dmall.biz.app.goods.model.GoodsVO;
import net.danvi.dmall.biz.app.promotion.exhibition.model.ExhibitionSO;
import net.danvi.dmall.biz.app.promotion.timedeal.model.*;
import net.danvi.dmall.biz.common.service.BizService;
import net.danvi.dmall.biz.common.service.EditorService;
import net.danvi.dmall.biz.system.security.SessionDetailHelper;
import net.danvi.dmall.biz.system.util.InterfaceUtil;
import org.springframework.dao.DuplicateKeyException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import java.io.File;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 5. 3.
 * 작성자     : 이헌철
 * 설명       : 타임딜서비스임플
 * </pre>
 */
@Slf4j
@Service("timeDealService")
@Transactional(rollbackFor = Exception.class)
public class TimeDealServiceImpl extends BaseService implements TimeDealService {

    @Resource(name = "editorService")
    private EditorService editorService;

    @Resource(name = "bizService")
    private BizService bizService;

    // 타임딜목록 조회 페이징
    @Override
    public ResultListModel<TimeDealVO>  selectTimeDealListPaging(TimeDealSO so) {
        ResultListModel<TimeDealVO> result = proxyDao.selectListPage(MapperConstants.PROMOTION_TIMEDEAL + "selectTimeDealListPaging", so);
        return result;
    }

    // 타임딜 등록
    @Override
    public ResultModel<TimeDealPO> insertTimeDeal(TimeDealPO po) throws Exception {
        ResultModel<TimeDealPO> result = new ResultModel<TimeDealPO>();

        TimeDealVO prmtNo = proxyDao.selectOne(MapperConstants.PROMOTION_TIMEDEAL + "selectTimeDealNewPromotionNo", null);
        po.setPrmtNo(prmtNo.getPrmtNo());

        // 일 + 시 + 분
        po.setApplyStartDttm(po.getFrom() + " " + po.getFromHour() + ":" + po.getFromMinute());
        po.setApplyEndDttm(po.getTo() + " " + po.getToHoure() + ":" + po.getToMinute());

        // 타임딜 정보 등록
        proxyDao.insert(MapperConstants.PROMOTION_TIMEDEAL + "insertTimeDeal", po);

        // 타임딜 상품 등록
        TimeDealVO applySeq = proxyDao.selectOne(MapperConstants.PROMOTION_TIMEDEAL + "selectTimeDealNewApplySeq", null);

        TimeDealTargetVO timeDealTargetVO = new TimeDealTargetVO();
        timeDealTargetVO.setApplySeq(Integer.toString(applySeq.getApplySeq()));
        timeDealTargetVO.setPrmtNo(Integer.toString(po.getPrmtNo()));
        timeDealTargetVO.setGoodsNo(po.getGoodsNo());
        timeDealTargetVO.setRegrNo(po.getRegrNo());

        proxyDao.insert(MapperConstants.PROMOTION_TIMEDEAL + "insertTimeDealTargetGoods", timeDealTargetVO);

        result.setMessage(MessageUtil.getMessage("biz.common.insert"));
        return result;
    }

    // 타임딜 수정
    @Override
    public ResultModel<TimeDealPO> updateTimeDeal(TimeDealPOListWrapper wrapper) throws Exception {
        ResultModel<TimeDealPO> result = new ResultModel<TimeDealPO>();

        try {
            for (TimeDealPO po : wrapper.getList()) {
                if (!StringUtil.isEmpty(po.getApplyAlwaysYn()) && po.getApplyAlwaysYn().equals("Y")) {
                    po.setApplyStartDttm("");
                    po.setApplyEndDttm("");
                }

                po.setSiteNo(wrapper.getSiteNo());
                po.setUpdrNo(wrapper.getUpdrNo());
                proxyDao.update(MapperConstants.PROMOTION_TIMEDEAL + "updateTimeDeal", po);
            }
            result.setMessage(MessageUtil.getMessage("biz.common.update"));
        } catch (DuplicateKeyException e) {
            throw new CustomException("biz.exception.common.exist", new Object[] { "타임딜 수정" }, e);
        }
        return result;
    }

    // 타임딜 삭제
    @Override
    public ResultModel<TimeDealPO> deleteTimeDeal(TimeDealPOListWrapper wrapper) throws Exception {
        ResultModel<TimeDealPO> result = new ResultModel<>();
        try {
            // 타임딜기본정보 삭제
            proxyDao.update(MapperConstants.PROMOTION_TIMEDEAL + "deleteTimeDeal", wrapper);
            // 타임딜 상품 삭제
            for (TimeDealPO po : wrapper.getList()) {
                proxyDao.delete(MapperConstants.PROMOTION_TIMEDEAL + "deleteTimeDealTargetGoods", po);
            }
            result.setMessage(MessageUtil.getMessage("biz.common.delete"));
        } catch (DuplicateKeyException e) {
            throw new CustomException("biz.exception.common.exist", new Object[] { "타임딜 삭제" }, e);
        }
        return result;

    }

    // 타임딜 상세조회(단건)
    @Override
    public ResultModel<TimeDealVO> selectTimeDealDtl(TimeDealSO so) throws Exception {
        TimeDealVO vo = proxyDao.selectOne(MapperConstants.PROMOTION_TIMEDEAL + "selectTimeDealDtl", so);
        HttpServletRequest request = HttpUtil.getHttpServletRequest();

        ResultModel<TimeDealVO> result = new ResultModel<TimeDealVO>(vo);


        // 상품번호 가져오기
        List<TimeDealTargetVO> goodsList = proxyDao.selectList(MapperConstants.PROMOTION_TIMEDEAL + "selectTimeDealTargetGoods", so);
        vo.setGoodsList(goodsList);

        // 첨부파일 조회 조건 세팅
        CmnAtchFileSO s = new CmnAtchFileSO();
        s.setSiteNo(so.getSiteNo());
        s.setRefNo(Integer.toString(so.getPrmtNo()));
        s.setFileGb("TP_PROMOTION");

        // 공통 첨부 파일 조회
        editorService.setCmnAtchFileToEditorVO(s, vo);

        result.setData(vo);
        return result;

    }

    // 타임딜 설정내용조회
    @Override
    public ResultModel<TimeDealVO> selectTimeDealInfo(TimeDealSO so) {
        HttpServletRequest request = HttpUtil.getHttpServletRequest();
        TimeDealVO vo = proxyDao.selectOne(MapperConstants.PROMOTION_TIMEDEAL + "selectTimeDealDtl", so);
        ResultModel<TimeDealVO> result = new ResultModel<TimeDealVO>(vo);
        return result;
    }

    // 타임딜적용 상품리스트조회
    @Override
    public ResultListModel<GoodsVO> selectTimeDealGoodsList(TimeDealSO so) {
        ResultListModel<GoodsVO> result = new ResultListModel<GoodsVO>();
        result = proxyDao
                .selectListPageWoTotal(MapperConstants.PROMOTION_TIMEDEAL + "selectTimeDealGoodsListPaging", so);
        return result;
    }

    // 상품번호/카테고리로 타임딜 조회
    @Override
    public ResultModel<TimeDealVO> selectTimeDealByGoods(TimeDealSO so) throws Exception {
        TimeDealVO vo = proxyDao.selectOne(MapperConstants.PROMOTION_TIMEDEAL + "selectTimeDealByGoods", so);
        ResultModel<TimeDealVO> result = new ResultModel<>(vo);
        return result;
    }

    // 타임딜대상 전체조회 : 타임딜대상 중복방지
    @Override
    public ResultListModel<TimeDealTargetVO> selectTimeDealTargetTotal(TimeDealSO so) {
        ResultListModel<TimeDealTargetVO> result = new ResultListModel<TimeDealTargetVO>();
        List<TimeDealTargetVO> goodsResult = proxyDao
                .selectList(MapperConstants.PROMOTION_TIMEDEAL + "selectTimeDealTargetTotal");
        result.put("goodsResult", goodsResult);
        return result;
    }

    // 타임딜 복사
    @Override
    public ResultModel<TimeDealPO> copyTimeDealInfo(TimeDealPO po) throws CustomException {

        ResultModel<TimeDealPO> result = new ResultModel<>();

        try {
            // 기본 타임딜정보 복사
            proxyDao.insert(MapperConstants.PROMOTION_TIMEDEAL + "copyTimeDealInfo", po);
            // 타임딜대상 복사
            proxyDao.insert(MapperConstants.PROMOTION_TIMEDEAL + "copyTimeDealTargetGoods", po);


        } catch (DuplicateKeyException e) {
            throw new CustomException("biz.exception.common.exist", new Object[] { "타임딜복사" }, e);
        }
        result.setMessage(MessageUtil.getMessage("biz.common.insert"));
        return result;
    }

    @Override
    @Transactional(readOnly = true)
    public List<GoodsVO> selectTimeDealTargetGoodsList(TimeDealSO so) {
        // 사이트 번호
        so.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
        log.info("selectTimeDealTargetGoodsList so = "+so);
        List<GoodsVO> result = proxyDao.selectList(MapperConstants.PROMOTION_TIMEDEAL + "selectTimeDealTargetGoodsList", so);
        if(result != null && result.size() > 0) {
            for (int i = 0; i < result.size(); i++) {
                result.get(i).setRownum(i + 1);
            }
        }
        return result;
    }

    /**
     * <pre>
     * 작성일 : 2023. 03. 17.
     * 작성자 : slims
     * 설명   : 프로모션에 이미 등록 되어있으면 1 없으면 0을 반환한다.
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------------------------------------------
     * 2023. 03. 17. slims - 최초생성
     * </pre>
     *
     * @param vo
     * @return
     */
    @Override
    @Transactional(readOnly = true)
    public Integer selectTimeDealTargetGoodsExist(TimeDealSO so) {
        Integer result = proxyDao.selectOne(MapperConstants.PROMOTION_TIMEDEAL + "selectTimeDealTargetGoodsExist", so);
        return result;
    }
}