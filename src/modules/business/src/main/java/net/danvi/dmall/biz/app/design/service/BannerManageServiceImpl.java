package net.danvi.dmall.biz.app.design.service;

import java.io.File;
import java.util.List;

import javax.annotation.Resource;

import net.danvi.dmall.biz.app.design.model.*;
import net.danvi.dmall.biz.app.goods.model.GoodsRecommendPO;
import net.danvi.dmall.biz.app.goods.model.GoodsVO;
import net.danvi.dmall.biz.app.promotion.exhibition.model.ExhibitionSO;
import net.danvi.dmall.biz.system.security.SessionDetailHelper;
import org.springframework.dao.DuplicateKeyException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import lombok.extern.slf4j.Slf4j;

import net.danvi.dmall.biz.common.service.BizService;
import dmall.framework.common.BaseService;
import dmall.framework.common.constants.MapperConstants;
import dmall.framework.common.constants.UploadConstants;
import dmall.framework.common.exception.CustomException;
import dmall.framework.common.model.ResultListModel;
import dmall.framework.common.model.ResultModel;
import dmall.framework.common.util.FileUtil;
import dmall.framework.common.util.MessageUtil;
import dmall.framework.common.util.StringUtil;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 07. 04.
 * 작성자     : dong
 * 설명       :
 * </pre>
 */
@Slf4j
@Service("bannerManageService")
@Transactional(rollbackFor = Exception.class)
public class BannerManageServiceImpl extends BaseService implements BannerManageService {

    @Resource(name = "bizService")
    private BizService bizService;

    @Override
    @Transactional(readOnly = true)
    public ResultListModel<BannerVO> selectSkinList(BannerSO so) {

        // 스킨리스트 조회 - 셀렉트 박스에서 조회할 스킨 정보조회
        List<SkinVO> temp = proxyDao.selectList(MapperConstants.DESIGN_BANNER + "selectBannerSkin", so);

        ResultListModel<BannerVO> resultListModel = new ResultListModel<BannerVO>();
        resultListModel.put("skinList", temp);

        return resultListModel;
    }

    @Override
    @Transactional(readOnly = true)
    public List<BannerVO> selectBannerList(BannerSO so) {
        // 배너 리스트 조회
        return proxyDao.selectList(MapperConstants.DESIGN_BANNER + "selectBannerList", so);
    }

    @Override
    @Transactional(readOnly = true)
    public ResultListModel<BannerVO> selectBannerListPaging(BannerSO so) {
        // 배너 기본 조회시 정렬값 기본 셋팅
        if (so.getSidx().length() == 0 && so.getSord().length() == 0) {
            so.setSidx("REG_DTTM");
            so.setSord("DESC");
        }
        //PC & MOBILE의 Full width main banner일 경우 배너 갯수 제한 없음
        /*if("MB1".equals(so.getBannerAreaCd()) || "MMV".equals(so.getBannerAreaCd())) {
        	so.setRows(100);
        }*/
        // 배너 리스트 페이징 처리
        return proxyDao.selectListPage(MapperConstants.DESIGN_BANNER + "selectBannerPaging", so);
    }

    @Override
    @Transactional(readOnly = true)
    public ResultModel<BannerVO> viewBannerDtl(BannerSO so) {
        // 배너 상세
        // 상세에 보여줄 스킨리스트 조회
        //List<SkinVO> temp = proxyDao.selectList(MapperConstants.DESIGN_BANNER + "selectBannerSkin", so);
        // BannerVO vo = new BannerVO();
        // 배너 상세 정보 조회
        BannerVO vo = proxyDao.selectOne(MapperConstants.DESIGN_BANNER + "selectBanner", so);
        //vo.setSkinList(temp);
        log.info("vo = " + vo);

        ResultModel<BannerVO> result = new ResultModel<BannerVO>(vo);

        return result;
    }

    @Override
    @Transactional(readOnly = true)
    public ResultModel<BannerVO> viewBannerDtlNew(BannerSO so) {

        // 배너 등록
        // 배너 등록에 보여줄 스킨리스트 조회
        List<SkinVO> temp = proxyDao.selectList(MapperConstants.DESIGN_BANNER + "selectBannerSkin", so);
        BannerVO vo = new BannerVO();
        // BannerVO vo = proxyDao.selectOne(MapperConstants.DESIGN_BANNER +
        // "selectBanner", so);
        vo.setSkinList(temp);

        ResultModel<BannerVO> result = new ResultModel<BannerVO>(vo);

        return result;
    }

    @Override
    public ResultModel<BannerPO> insertBanner(BannerPO po) throws Exception {
        ResultModel<BannerPO> result = new ResultModel<>();

        try {

            // 배너 시퀀스 정보 가져오기
            Long bannerNo = bizService.getSequence("BANNER", po.getSiteNo());

            po.setBannerNo(bannerNo);

            // 배너 등록
            proxyDao.insert(MapperConstants.DESIGN_BANNER + "insertBanner", po);

            for(String goodsNo:po.getGoodsList()) {
                BannerGoodsPO bannerGoodsPO = new BannerGoodsPO();
                bannerGoodsPO.setGoodsNo(goodsNo);
                bannerGoodsPO.setBannerNo(bannerNo);
                bannerGoodsPO.setSiteNo(SessionDetailHelper.getDetails().getSession().getSiteNo());
                bannerGoodsPO.setRegrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
                proxyDao.insert(MapperConstants.DESIGN_BANNER + "insertBannerGoods", bannerGoodsPO);
            }
            result.setMessage(MessageUtil.getMessage("biz.common.insert"));

        } catch (DuplicateKeyException e) {
            throw new CustomException("biz.exception.common.exist", new Object[] { "배너관리" }, e);
        }
        return result;
    }

    @Override
    public ResultModel<BannerPO> updateBanner(BannerPO po) throws Exception {
        ResultModel<BannerPO> result = new ResultModel<>();

        try {

            // 이미지 수정일경우 - 이미지 정보가 넘어왔을때 이미지 정보 삭제 처리
            // 파일 사이즈가 널이 아니고 0보다 클때를 이미지 정보가 있는걸로 간주
            BannerVO voVal = new BannerVO();
            if (po.getFileSize() != null && po.getFileSize() > 0) {
                // 데이터 조회
                voVal = proxyDao.selectOne(MapperConstants.DESIGN_BANNER + "selectBanner", po);
            }

            // 배너 수정
            proxyDao.update(MapperConstants.DESIGN_BANNER + "updateBanner", po);

            // 이미지 수정일경우 - 이미지 정보가 넘어왔을때 이미지 정보 삭제 처리
            // 파일 사이즈가 널이 아니고 0보다 클때를 이미지 정보가 있는걸로 간주
            if (po.getFileSize() != null && po.getFileSize() > 0) {
                // 경로와 파일명이 데이터가 빈값이 아닐경우에만 처리한다.
                if (!"".equals(StringUtil.nvl(voVal.getFilePath())) && !"".equals(StringUtil.nvl(voVal.getFileNm()))) {
                    // 이미지 삭제
                    String deletePath = FileUtil.getPath(UploadConstants.PATH_IMAGE, UploadConstants.PATH_BANNER);
                    File file = new File(deletePath + voVal.getFilePath() + File.separator + voVal.getFileNm());
                    if (file.exists()) { // 존재한다면 삭제
                        FileUtil.delete(file);
                    }
                }
            }

            // 모바일 image
            if (po.getFileSizeM() != null && po.getFileSizeM() > 0) {
                // 경로와 파일명이 데이터가 빈값이 아닐경우에만 처리한다.
                if (!"".equals(StringUtil.nvl(voVal.getFilePathM())) && !"".equals(StringUtil.nvl(voVal.getFileNmM()))) {
                    // 이미지 삭제
                    String deletePath = FileUtil.getPath(UploadConstants.PATH_IMAGE, UploadConstants.PATH_BANNER);
                    File mFile = new File(deletePath + voVal.getFilePathM() + File.separator + voVal.getFileNmM());
                    if (mFile.exists()) { // 존재한다면 삭제
                        FileUtil.delete(mFile);
                    }
                }
            }

            proxyDao.delete(MapperConstants.DESIGN_BANNER + "deleteBannerGoods", po);
            //proxyDao.delete(MapperConstants.PROMOTION_EXHIBITION + "deleteExhibitionDispzone", po);

            for(String goodsNo:po.getGoodsList()) {
                BannerGoodsPO bannerGoodsPO = new BannerGoodsPO();
                bannerGoodsPO.setGoodsNo(goodsNo);
                bannerGoodsPO.setBannerNo(po.getBannerNo());
                bannerGoodsPO.setSiteNo(SessionDetailHelper.getDetails().getSession().getSiteNo());
                bannerGoodsPO.setRegrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());
                proxyDao.insert(MapperConstants.DESIGN_BANNER + "insertBannerGoods", bannerGoodsPO);
            }

            result.setMessage(MessageUtil.getMessage("biz.common.update"));

        } catch (DuplicateKeyException e) {
            throw new CustomException("biz.exception.common.error", new Object[] {}, e);
        }
        return result;
    }

    @Override
    public ResultModel<BannerPO> updateBannerView(BannerPOListWrapper wrapper) throws Exception {
        ResultModel<BannerPO> result = new ResultModel<>();

        try {
            // 배너 전시 미전시 리스트에서 선택된 정보만 처리하도록 loop 처리
            for (BannerPO po : wrapper.getList()) {
                po.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());

                po.setUpdrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());

                // 전시 미전시 데이터 업데이트
                proxyDao.update(MapperConstants.DESIGN_BANNER + "updateBannerView", po);
            }
            result.setMessage(MessageUtil.getMessage("biz.common.update"));

        } catch (Exception e) {
            throw new CustomException("biz.exception.common.error", new Object[] {}, e);
        }
        return result;
    }

    @Override
    public ResultModel<BannerPO> updateBannerSort(BannerPO po) throws Exception {
        ResultModel<BannerPO> result = new ResultModel<>();

        try {
            // 배너 순서저장 리스트에서 선택된 정보만 처리하도록 loop 처리
            /*for (BannerPO po : wrapper.getList()) {
                po.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());

                po.setUpdrNo(SessionDetailHelper.getDetails().getSession().getMemberNo());

                // 배너 순서정보 데이터 업데이트
                proxyDao.update(MapperConstants.DESIGN_BANNER + "updateBannerSort", po);
            }*/
            po.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());

            proxyDao.update(MapperConstants.DESIGN_BANNER + "updateBannerSort", po);

            BannerPO bannerPO = new BannerPO();
            bannerPO.setSiteNo(po.getSiteNo());
            bannerPO.setSortSeq(po.getOrgSortSeq());
            bannerPO.setOrgBannerNo(po.getBannerNo());

            proxyDao.update(MapperConstants.DESIGN_BANNER + "updateBannerSort", bannerPO);
            //result.setMessage(MessageUtil.getMessage("biz.common.update"));

        } catch (Exception e) {
            throw new CustomException("biz.exception.common.error", new Object[] {}, e);
        }
        return result;
    }

    @Override
    public ResultModel<BannerPO> deleteBanner(BannerPOListWrapper wrapper) throws Exception {
        ResultModel<BannerPO> result = new ResultModel<>();

        try {
            // 배너 삭제
            // 배너 이미지 삭제 경로
            String deletePath = FileUtil.getPath(UploadConstants.PATH_IMAGE, UploadConstants.PATH_BANNER);
            for (BannerPO po : wrapper.getList()) {
                po.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
                // 이미지 삭제
                File file = new File(deletePath + po.getFilePath() + File.separator + po.getFileNm());
                if (file.exists()) { // 존재한다면 삭제
                    FileUtil.delete(file);
                }
                File mFile = new File(deletePath + po.getFilePathM() + File.separator + po.getFileNmM());
                if (mFile.exists()) { // 존재한다면 삭제
                    FileUtil.delete(mFile);
                }

                // 배너 데이터 삭제
                proxyDao.delete(MapperConstants.DESIGN_BANNER + "deleteBanner", po);
                proxyDao.delete(MapperConstants.DESIGN_BANNER + "deleteBannerGoods", po);
            }
            result.setMessage(MessageUtil.getMessage("biz.common.delete"));

        } catch (Exception e) {
            throw new CustomException("biz.exception.common.error", new Object[] {}, e);
        }
        return result;
    }

    @Override
    @Transactional(readOnly = true)
    public ResultListModel<GoodsVO> selectBannerGoodsList(BannerSO so) {
        // 사이트 번호
        so.setSiteNo(SessionDetailHelper.getDetails().getSiteNo());
        log.info("selectExhibitionTargetGoodsList so = "+so);
        ResultListModel<GoodsVO> result = proxyDao.selectListPage(MapperConstants.DESIGN_BANNER + "selectBannerGoodsList", so);

        return result;
    }
}
