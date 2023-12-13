package net.danvi.dmall.biz.app.goods.service;

import dmall.framework.common.BaseService;
import dmall.framework.common.constants.CommonConstants;
import dmall.framework.common.constants.MapperConstants;
import dmall.framework.common.constants.RequestAttributeConstants;
import dmall.framework.common.constants.UploadConstants;
import dmall.framework.common.model.CmnAtchFilePO;
import dmall.framework.common.model.CmnAtchFileSO;
import dmall.framework.common.model.ResultListModel;
import dmall.framework.common.model.ResultModel;
import dmall.framework.common.util.*;
import lombok.extern.slf4j.Slf4j;
import net.danvi.dmall.biz.app.goods.model.*;
import net.danvi.dmall.biz.common.service.BizService;
import net.danvi.dmall.biz.common.service.EditorService;
import net.danvi.dmall.biz.system.security.SessionDetailHelper;
import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2022. 11. 08.
 * 작성자     : slims
 * 설명       : 추천상품 구현 클래스
 * </pre>
 */
@Slf4j
@Service("recommendManageService")
@Transactional(rollbackFor = Exception.class)
public class RecommendManageServiceImpl extends BaseService implements RecommendManageService {

    /**
     * 작성자 : slims
     * 설명 : 사은품 정보 목록 조회.
     */
    @Override
    @Transactional(readOnly = true)
    public List<GoodsRecommendVO> selectGoodsRecommendList(GoodsRecommendSO so) {
        if (so.getSidx().length() == 0) {
            so.setSidx("REG_DTTM");
            so.setSord("DESC");
        }
        log.info("selectGoodsRecommendList param getSiteNo = " + so.getSiteNo());
        return proxyDao.selectList(MapperConstants.RECOMMEND_MANAGE + "selectRecommendList", so);
    }

    /**
     * 작성자 : slims
     * 설명 : 사은품 정보 단건 조회.
     */
    @Override
    @Transactional(readOnly = true)
    public ResultModel<GoodsRecommendVO> selectGoodsRecommendContents(GoodsRecommendSO so) throws Exception {
        GoodsRecommendVO resultVO = proxyDao.selectOne(MapperConstants.RECOMMEND_MANAGE + "selectFreebieContents", so);
        ResultModel<GoodsRecommendVO> result = new ResultModel<GoodsRecommendVO>(resultVO);

        /*// 이미지 정보 조회 조건 세팅
        CmnAtchFileSO fileso = new CmnAtchFileSO();
        fileso.setSiteNo(so.getSiteNo());
        fileso.setRefNo(so.getFreebieNo());
        fileso.setFileGb("TG_FREEBIE");

        // 공통 첨부 파일 조회
        editorService.setCmnAtchFileToEditorVO(fileso, resultVO);

        // 사은품 이미지 조회
        this.loadFreebieImage(so, resultVO);*/

        result.setData(resultVO);
        return result;
    }

    /**
     * 작성자 : slims
     * 설명 : 사은품 정보 등록.
     */
    @Override
    public ResultModel<GoodsRecommendPO> insertGoodsRecommendItems(GoodsRecommendPO po) throws Exception {
        ResultModel<GoodsRecommendPO> result = new ResultModel<>();

        if(po.getDelList() != null && po.getDelList().length > 0) {
            for (String goodsNo : po.getDelList()) {
                GoodsRecommendPO temp = new GoodsRecommendPO();
                temp.setSiteNo(po.getSiteNo());
                temp.setRecType(po.getRecType());
                temp.setGoodsNo(goodsNo);
                proxyDao.delete(MapperConstants.RECOMMEND_MANAGE + "deleteRecommendContents", temp);
            }
        }

        if(po.getInsRecommendGoodsNoList() != null && po.getInsRecommendGoodsNoList().size() > 0) {
            ArrayList<String> recommendNoArr = po.getInsRecommendGoodsNoList();
            int insertCnt = 0;
            for (int i = 0; i < recommendNoArr.size(); i++) {
                GoodsRecommendPO goodsRecommendPO = new GoodsRecommendPO();
                goodsRecommendPO.setSiteNo(po.getSiteNo());
                goodsRecommendPO.setGoodsNo(recommendNoArr.get(i));
                goodsRecommendPO.setRegrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
                goodsRecommendPO.setRecType(po.getRecType());

                insertCnt = insertCnt + proxyDao.insert(MapperConstants.RECOMMEND_MANAGE + "insertGoodsRecommendItems", goodsRecommendPO);
            }
            po.setInsCnt(insertCnt);
        }

        // 등록성공 메세지 설정
        result.setData(po);
        result.setMessage(MessageUtil.getMessage("biz.common.insert"));
        return result;
    }

    /**
     * 작성자 : slims
     * 설명 : 사은품 정보 수정.
     */
    @Override
    public ResultModel<GoodsRecommendPO> updateGoodsRecommendContents(GoodsRecommendPO po) throws Exception {
        ResultModel<GoodsRecommendPO> result = new ResultModel<>();
        // 에디터 내용의 업로드 이미지 정보 변경
//        this.editUploadPathReplace(po);
        proxyDao.update(MapperConstants.RECOMMEND_MANAGE + "updateGoodsRecommendContents", po);

        // 에디터 이미지 저장
//        this.saveFreebieEditContents(po);

        GoodsRecommendSO so = new GoodsRecommendSO();
        so.setSiteNo(po.getSiteNo());
//        so.setFreebieNo(po.getFreebieNo());
        proxyDao.selectOne(MapperConstants.RECOMMEND_MANAGE + "selectRecommendContents", so);

        // 수정성공 메세지 설정
        result.setData(po);
        result.setMessage(MessageUtil.getMessage("biz.common.update"));
        return result;
    }

    /**
     * 작성자 : slims
     * 설명 : 사은품 정보 삭제.
     */
    @Override
    public ResultModel<GoodsRecommendPO> deleteGoodsRecommendContents(GoodsRecommendPO po) throws Exception {
        ResultModel<GoodsRecommendPO> result = new ResultModel<>();

        ArrayList<String> recommendGoodsList = po.getInsRecommendGoodsNoList();

        log.info("recommendGoodsList = " + recommendGoodsList);
        for (int i = 0; i < recommendGoodsList.size(); i++) {

            GoodsRecommendPO goodsRecommendPO = new GoodsRecommendPO();
            goodsRecommendPO.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
            goodsRecommendPO.setGoodsNo(recommendGoodsList.get(i));
            goodsRecommendPO.setRecType(po.getRecType());

            proxyDao.delete(MapperConstants.RECOMMEND_MANAGE + "deleteRecommendContents", goodsRecommendPO);
        }

        // 삭제성공 메세지 설정
        result.setData(po);
        result.setMessage(MessageUtil.getMessage("biz.common.delete"));
        return result;
    }

    /**
     * 작성자 : truesol
     * 설명 : 추천상품 순서 변경
     */
    @Override
    public List<GoodsRecommendVO> updateRecommendSort(GoodsRecommendPO po) throws Exception {
        // 변경할 상품과 원본 상품의 sort_seq를 서로 바꿈
        proxyDao.update(MapperConstants.RECOMMEND_MANAGE + "updateRecommendSort", po);

        GoodsRecommendPO recommendPO = new GoodsRecommendPO();
        recommendPO.setSortSeq(po.getOrgSortSeq());
        recommendPO.setRecType(po.getRecType());
        recommendPO.setOrgGoodsNo(po.getGoodsNo());

        proxyDao.update(MapperConstants.RECOMMEND_MANAGE + "updateRecommendSort", recommendPO);

        return proxyDao.selectList(MapperConstants.RECOMMEND_MANAGE + "selectRecommendList", po);
    }


}