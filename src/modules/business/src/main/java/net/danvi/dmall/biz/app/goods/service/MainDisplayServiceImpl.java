package net.danvi.dmall.biz.app.goods.service;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import net.danvi.dmall.biz.system.security.SessionDetailHelper;
import org.springframework.dao.DuplicateKeyException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import net.danvi.dmall.biz.app.design.model.BannerSO;
import net.danvi.dmall.biz.app.design.model.BannerVO;
import net.danvi.dmall.biz.app.design.service.BannerManageService;
import net.danvi.dmall.biz.app.goods.model.DisplayGoodsListWrapper;
import net.danvi.dmall.biz.app.goods.model.DisplayGoodsPO;
import net.danvi.dmall.biz.app.goods.model.DisplayGoodsSO;
import net.danvi.dmall.biz.app.goods.model.DisplayGoodsVO;
import net.danvi.dmall.biz.app.goods.model.GoodsVO;
import net.danvi.dmall.biz.app.promotion.event.model.EventVO;
import net.danvi.dmall.biz.app.promotion.exhibition.model.ExhibitionPO;
import net.danvi.dmall.biz.app.promotion.exhibition.model.ExhibitionPOListWrapper;
import net.danvi.dmall.biz.app.promotion.exhibition.service.ExhibitionServiceImpl;
import net.danvi.dmall.biz.common.service.BizService;
import net.danvi.dmall.biz.system.security.DmallSessionDetails;
import dmall.framework.common.BaseService;
import dmall.framework.common.constants.MapperConstants;
import dmall.framework.common.constants.RequestAttributeConstants;
import dmall.framework.common.constants.UploadConstants;
import dmall.framework.common.exception.CustomException;
import dmall.framework.common.model.ResultListModel;
import dmall.framework.common.model.ResultModel;
import dmall.framework.common.util.*;
import lombok.extern.slf4j.Slf4j;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 6. 1.
 * 작성자     : dong
 * 설명       :
 * </pre>
 */
@Slf4j
@Service("mainDisplayService")
@Transactional(rollbackFor = Exception.class)
public class MainDisplayServiceImpl extends BaseService implements MainDisplayService {
    @Resource(name = "bizService")
    private BizService bizService;
    @Resource(name = "bannerManageService")
    private BannerManageService bannerManageService;
    @Resource(name = "mainDisplayService")
    private MainDisplayService mainDisplayService;

    @Override
    @Transactional(readOnly = true)
    public ResultModel<DisplayGoodsVO> selectMainDisplayGoods(DisplayGoodsSO so) throws Exception {

        // 메인전시관리 화면 조회
        // 화면에 필요한 기본정보 조회
        List<DisplayGoodsVO> temp = proxyDao.selectList(MapperConstants.GOODS_MAIN_DISPLAY + "selectMainDisplay", so);
        DisplayGoodsVO vo = new DisplayGoodsVO();
        vo.setDisplayArr(temp);

        // 기본정보안에 들어간 상품 정보 조회
        List<DisplayGoodsVO> temp2 = proxyDao.selectList(MapperConstants.GOODS_MAIN_DISPLAY + "selectMainDisplayGoods",
                so);
        vo.setDisplayGoodsArr(temp2);

        ResultModel<DisplayGoodsVO> result = new ResultModel<DisplayGoodsVO>(vo);

        return result;
    }

    @Override
    public ResultModel<DisplayGoodsPO> insertMainDisplay(DisplayGoodsPO po) throws Exception {
        ResultModel<DisplayGoodsPO> result = new ResultModel<>();

        try {
            // 메인전시 등록
            // 메인전시 시퀀시 조회
            /*Long siteDispSeq = bizService.getSequence("MAIN_DISPLAY");

            po.setSiteDispSeq(siteDispSeq);*/
        	System.out.println("======impl"+po.getSiteDispSeq());

            File file;
            File ofile;

            // 저장 경로 및 파일명 처리
            String newfilePathNm = DateUtil.getNowDate();
            String newfilePath = newfilePathNm.substring(0, 4) + File.separator + newfilePathNm.substring(4, 6)
                    + File.separator + newfilePathNm.substring(6);

            // 브랜드 디폴트 이미지가 있을경우 임시 경로에서 리얼 경로로 이동
            if (po.getDftFilePath() != null && po.getDftFilePath() != "") {

                file = new File(FileUtil.getPath(UploadConstants.PATH_IMAGE, UploadConstants.PATH_MAIN_DISPLAY,
                        newfilePath, po.getDftFileName()));

                ofile = new File(FileUtil.getTempPath() + File.separator + po.getDftFilePath() + File.separator
                        + po.getDftFileName());

                if (!file.getParentFile().exists()) {
                    file.getParentFile().mkdirs();
                }

                FileUtil.move(ofile, file);
                po.setDispImgPath(newfilePathNm);
                po.setDispImgNm(po.getDftFileName());
            }

            // 메인 기본 정보 저장
            proxyDao.insert(MapperConstants.GOODS_MAIN_DISPLAY + "insertMainDisplay", po);

            // 메인 상품 정보 전체 삭제
            proxyDao.delete(MapperConstants.GOODS_MAIN_DISPLAY + "deleteMainDisplayGoods", po);

            String strGoods = po.getGoodsNo();

            // 배열로 받은 상품 상세 정보 구분, 저장을 위한 값들 셋팅
            String[] goods = strGoods.split(",");
            Long i = (long) 0;
            for (String wo : goods) {
                i++;
                po.setGoodsNo(wo);
                po.setPriorRank(i);

                // 상품 정보가 없으면 등록 안함
                if (!wo.equals("")) {
                    // int goodData =
                    // proxyDao.update(MapperConstants.GOODS_MAIN_DISPLAY +
                    // "updateMainDisplayGoods", po);
                    // if (goodData == 0) {
                    proxyDao.insert(MapperConstants.GOODS_MAIN_DISPLAY + "insertMainDisplayGoods", po);
                    // }
                }
            }

            result.setMessage(MessageUtil.getMessage("biz.common.insert"));

        } catch (DuplicateKeyException e) {
            throw new CustomException("biz.exception.common.exist", new Object[] { "메인전시관리" }, e);
        }
        return result;
    }

    @Override
    public ResultModel<DisplayGoodsPO> updateMainDisplay(DisplayGoodsPO po) throws Exception {
        ResultModel<DisplayGoodsPO> result = new ResultModel<>();

        try {

            File file;
            File ofile;

            // 이미지 변경할것인지 구분하는 값 정의
            String mainDftImgYn = "N";

            // 저장 경로 및 파일명 처리
            String newfilePathNm = DateUtil.getNowDate();
            String newfilePath = newfilePathNm.substring(0, 4) + File.separator + newfilePathNm.substring(4, 6)
                    + File.separator + newfilePathNm.substring(6);

            // 메인전시 디폴트 이미지가 있을경우 임시 경로에서 리얼 경로로 이동
            if (po.getDftFilePath() != null && po.getDftFilePath() != "") {

                file = new File(FileUtil.getPath(UploadConstants.PATH_IMAGE, UploadConstants.PATH_MAIN_DISPLAY,
                        newfilePath, po.getDftFileName()));

                ofile = new File(FileUtil.getTempPath() + File.separator + po.getDftFilePath() + File.separator
                        + po.getDftFileName());

                if (!file.getParentFile().exists()) {
                    file.getParentFile().mkdirs();
                }

                FileUtil.move(ofile, file);
                po.setDispImgPath(newfilePathNm);
                po.setDispImgNm(po.getDftFileName());

                mainDftImgYn = "Y";
            }

            // 이미지 정보가 등록된것이 있을경우 기존이미지 정보 불러오기
            GoodsVO voVal = new GoodsVO();
            if (mainDftImgYn.equals("Y")) {
                voVal = proxyDao.selectOne(MapperConstants.GOODS_MAIN_DISPLAY + "selectMainDisplay", po);
            }

            // 메인 기본 정보 수정
            proxyDao.insert(MapperConstants.GOODS_MAIN_DISPLAY + "updateMainDisplay", po);

            // 메인 상품 정보 전체 삭제
            proxyDao.delete(MapperConstants.GOODS_MAIN_DISPLAY + "deleteMainDisplayGoods", po);

            String strGoods = po.getGoodsNo();

            String[] goods = strGoods.split(",");
            Long i = (long) 0;
            for (String wo : goods) {
                i++;
                po.setGoodsNo(wo);
                po.setPriorRank(i);

                // 상품 정보가 없으면 등록 안함
                if (!wo.equals("")) {
                    // int goodData =
                    // proxyDao.update(MapperConstants.GOODS_MAIN_DISPLAY +
                    // "updateMainDisplayGoods", po);
                    // if (goodData == 0) {
                    proxyDao.insert(MapperConstants.GOODS_MAIN_DISPLAY + "insertMainDisplayGoods", po);
                    // }
                }
            }

            // 이미지 정보가 등록된것이 있을경우 기존이미지 파일 삭제
            // 메인전시 기본이미지 삭제처리
            if (mainDftImgYn.equals("Y")) {
                // 경로와 파일명이 데이터가 빈값이 아닐경우에만 처리한다.
                if (!"".equals(StringUtil.nvl(voVal.getDispImgPath()))
                        && !"".equals(StringUtil.nvl(voVal.getDispImgNm()))) {
                    String filePathNm = FileUtil.getDatePath(voVal.getDispImgPath() + "_" + voVal.getDispImgNm());
                    File imgFile = new File(FileUtil.getPath(UploadConstants.PATH_IMAGE,
                            UploadConstants.PATH_MAIN_DISPLAY, filePathNm));
                    if (imgFile.exists()) {
                        FileUtil.delete(imgFile);
                    }
                }
            }

            result.setMessage(MessageUtil.getMessage("biz.common.update"));

        } catch (DuplicateKeyException e) {
            throw new CustomException("biz.exception.common.exist", new Object[] { "메인전시관리" }, e);
        }
        return result;
    }

    @Transactional(readOnly = true)
    public Map<String, Object> seleceAllMainDisplayGoodsFront(DisplayGoodsSO so) throws Exception {
        DmallSessionDetails sessionInfo = SessionDetailHelper.getDetails();
        HttpServletRequest request = HttpUtil.getHttpServletRequest();
        ResultListModel<BannerVO> bannerVo = new ResultListModel<>();

        // 프론트에 조회하는 메인전시관리 데이터
        Map result = new HashMap();

        // 01. MAIN VIsual Banner 조회
        BannerSO bs = new BannerSO();
        bs.setSiteNo(sessionInfo.getSiteNo());// 사이트번호셋팅
        String skinNo = "";

        if(SiteUtil.isMobile()) {
            if (request.getAttribute(RequestAttributeConstants.SKIN_NO) != null) {
            	skinNo = request.getAttribute(RequestAttributeConstants.SKIN_NO).toString();
            } else {
            	skinNo = "119";
            }
        }else {      	
	        if (request.getAttribute(RequestAttributeConstants.SKIN_NO) != null) {
	        	skinNo = request.getAttribute(RequestAttributeConstants.SKIN_NO).toString();
	        } else {
	        	skinNo = "2";
	        }
        }


        if(SiteUtil.isMobile()) {

            //모바일 메인 상단배너
            bs.setSkinNo(skinNo);// 쇼핑몰의 리얼 스킨번호를 가져온다.
            bs.setBannerMenuCd("MO");
            bs.setBannerAreaCd("MMB");
            bs.setDispYn("Y");
            bs.setTodayYn("Y");
            bs.setSidx("SORT_SEQ");
            bs.setSord("ASC");
            //bannerVo = new ResultListModel<>();
            bannerVo = bannerManageService.selectBannerListPaging(bs);
            result.put("mo_main_banner_top", bannerVo);

           //모바일 메인 비쥬얼배너
            bs.setSkinNo(skinNo);// 쇼핑몰의 리얼 스킨번호를 가져온다.
            bs.setBannerMenuCd("MO");
            bs.setBannerAreaCd("MMV");
            bs.setDispYn("Y");
            bs.setTodayYn("Y");
            bs.setSidx("SORT_SEQ");
            bs.setSord("ASC");
            //bannerVo = new ResultListModel<>();
            bannerVo = bannerManageService.selectBannerListPaging(bs);
            result.put("mo_visual_banner", bannerVo);


            //모바일 메인 빅배너
            bs.setSkinNo(skinNo);// 쇼핑몰의 리얼 스킨번호를 가져온다.
            bs.setBannerMenuCd("MO");
            bs.setBannerAreaCd("MBB");
            bs.setDispYn("Y");
            bs.setTodayYn("Y");
            bs.setSidx("SORT_SEQ");
            bs.setSord("ASC");
           // bannerVo = new ResultListModel<>();
            bannerVo = bannerManageService.selectBannerListPaging(bs);
            result.put("mo_main_banner_big", bannerVo);

            //모바일 메인 하단배너
            bs.setSkinNo(skinNo);// 쇼핑몰의 리얼 스킨번호를 가져온다.
            bs.setBannerMenuCd("MO");
            bs.setBannerAreaCd("MMF");
            bs.setDispYn("Y");
            bs.setTodayYn("Y");
            bs.setSidx("SORT_SEQ");
            bs.setSord("ASC");
            //bannerVo = new ResultListModel<>();
            bannerVo = bannerManageService.selectBannerListPaging(bs);
            result.put("mo_main_banner_bottom", bannerVo);

             //모바일 디매거진 배너
            bs.setSkinNo(skinNo);// 쇼핑몰의 리얼 스킨번호를 가져온다.
            bs.setBannerMenuCd("MO");
            bs.setBannerAreaCd("MTZ");
            bs.setDispYn("Y");
            bs.setTodayYn("Y");
            bs.setSidx("SORT_SEQ");
            bs.setSord("ASC");
           // bannerVo = new ResultListModel<>();
            bannerVo = bannerManageService.selectBannerListPaging(bs);
            result.put("mo_main_banner_magazine", bannerVo);


            //메인 영역에 따른 상품
            GoodsVO vo = new GoodsVO();

            so.setDispSeq(null);
            so.setMainAreaGbCd("01");

            List<GoodsVO> mainAreaTypeA = proxyDao.selectList(MapperConstants.GOODS_MAIN_DISPLAY + "selectMainDisplay", so);
            mainAreaTypeA =proxyDao.selectList(MapperConstants.GOODS_MAIN_DISPLAY + "selectMainDisplay", so);
            result.put("mainAreaTypeA", mainAreaTypeA);
            for(int i=0; i<mainAreaTypeA.size(); i++) {
                vo = (GoodsVO)mainAreaTypeA.get(i);
                so.setDispSeq(vo.getDispSeq());
                ResultModel<DisplayGoodsVO> displayGoods = selectMainDisplayGoodsFront(so);
                result.put("mainAreaTypeA"+i, displayGoods.getData().getDisplayGoodsMoArr());
            }

            so.setDispSeq(null);
            so.setMainAreaGbCd("02");

            List<GoodsVO> mainAreaTypeB = proxyDao.selectList(MapperConstants.GOODS_MAIN_DISPLAY + "selectMainDisplay", so);
            result.put("mainAreaTypeB", mainAreaTypeB);

            for(int i=0; i<mainAreaTypeB.size(); i++) {
                vo = mainAreaTypeB.get(i);
                so.setDispSeq(vo.getDispSeq());
                ResultModel<DisplayGoodsVO> displayGoods = selectMainDisplayGoodsFront(so);
                result.put("mainAreaTypeB"+i, displayGoods.getData().getDisplayGoodsMoArr());
            }

            so.setDispSeq(null);
            so.setMainAreaGbCd("03");

            List<GoodsVO> mainAreaTypeC = proxyDao.selectList(MapperConstants.GOODS_MAIN_DISPLAY + "selectMainDisplay", so);
            result.put("mainAreaTypeC", mainAreaTypeC);

            for(int i=0; i<mainAreaTypeC.size(); i++) {
                vo = mainAreaTypeC.get(i);
                so.setDispSeq(vo.getDispSeq());
                ResultModel<DisplayGoodsVO> displayGoods = selectMainDisplayGoodsFront(so);
                result.put("mainAreaTypeC"+i, displayGoods.getData().getDisplayGoodsMoArr());
            }

        }

        if(!SiteUtil.isMobile()) {
          //메인비쥬얼 Full-Width
            bs.setSkinNo(skinNo);// 쇼핑몰의 리얼 스킨번호를 가져온다.
            bs.setDispYn("Y");
            bs.setTodayYn("Y");
            bs.setSidx("SORT_SEQ");
            bs.setSord("ASC");

            bs.setBannerMenuCd("MN");
            bs.setBannerAreaCd("MB1");
            bannerVo = bannerManageService.selectBannerListPaging(bs);
            result.put("visual_banner", bannerVo);

            //메인 사이드
            bs.setSkinNo(skinNo);// 쇼핑몰의 리얼 스킨번호를 가져온다.
            bs.setBannerMenuCd("MN");
            bs.setBannerAreaCd("MB2");
            bs.setDispYn("Y");
            bs.setTodayYn("Y");
            bs.setSidx("SORT_SEQ");
            bs.setSord("ASC");
            //bannerVo = new ResultListModel<>();
            bannerVo = bannerManageService.selectBannerListPaging(bs);
            result.put("visual_banner_side", bannerVo);

             //메인전시A영역 배너
            bs.setSkinNo(skinNo);// 쇼핑몰의 리얼 스킨번호를 가져온다.
            bs.setBannerMenuCd("MN");
            bs.setBannerAreaCd("MB3");
            bs.setDispYn("Y");
            bs.setTodayYn("Y");
            bs.setSidx("SORT_SEQ");
            bs.setSord("ASC");
            //bannerVo = new ResultListModel<>();
            bannerVo = bannerManageService.selectBannerListPaging(bs);
            result.put("main_banner_A", bannerVo);

            //메인전시중간좌 배너
            bs.setSkinNo(skinNo);// 쇼핑몰의 리얼 스킨번호를 가져온다.
            bs.setBannerMenuCd("MN");
            bs.setBannerAreaCd("MB4");
            bs.setDispYn("Y");
            bs.setTodayYn("Y");
            bs.setSidx("SORT_SEQ");
            bs.setSord("ASC");
            //bannerVo = new ResultListModel<>();
            bannerVo = bannerManageService.selectBannerListPaging(bs);
            result.put("main_banner_middle_left", bannerVo);


            //메인전시중간우 배너
            bs.setSkinNo(skinNo);// 쇼핑몰의 리얼 스킨번호를 가져온다.
            bs.setBannerMenuCd("MN");
            bs.setBannerAreaCd("MB5");
            bs.setDispYn("Y");
            bs.setTodayYn("Y");
            bs.setSidx("SORT_SEQ");
            bs.setSord("ASC");
            //bannerVo = new ResultListModel<>();
            bannerVo = bannerManageService.selectBannerListPaging(bs);
            result.put("main_banner_middle_right", bannerVo);

            //메인전시B 영역
            bs.setSkinNo(skinNo);// 쇼핑몰의 리얼 스킨번호를 가져온다.
            bs.setBannerMenuCd("MN");
            bs.setBannerAreaCd("MB6");
            bs.setDispYn("Y");
            bs.setTodayYn("Y");
            bs.setSidx("SORT_SEQ");
            bs.setSord("ASC");
            //bannerVo = new ResultListModel<>();
            bannerVo = bannerManageService.selectBannerListPaging(bs);
            result.put("main_banner_B", bannerVo);


           //텍스트슬라이드 영역
            bs.setSkinNo(skinNo);// 쇼핑몰의 리얼 스킨번호를 가져온다.
            bs.setBannerMenuCd("MN");
            bs.setBannerAreaCd("MB7");
            bs.setDispYn("Y");
            bs.setTodayYn("Y");
            bs.setSidx("SORT_SEQ");
            bs.setSord("ASC");
            //bannerVo = new ResultListModel<>();
            bannerVo = bannerManageService.selectBannerListPaging(bs);
            result.put("main_banner_text", bannerVo);

             //디매거진 배너
            bs.setSkinNo(skinNo);// 쇼핑몰의 리얼 스킨번호를 가져온다.
            bs.setBannerMenuCd("MN");
            bs.setBannerAreaCd("MB9");
            bs.setDispYn("Y");
            bs.setTodayYn("Y");
            bs.setSidx("SORT_SEQ");
            bs.setSord("ASC");
            //bannerVo = new ResultListModel<>();
            bannerVo = bannerManageService.selectBannerListPaging(bs);
            result.put("main_banner_magazine", bannerVo);


            //메인 영역에 따른 상품
            GoodsVO vo = new GoodsVO();

            so.setDispSeq(null);
            so.setMainAreaGbCd("01");

            List<GoodsVO> mainAreaTypeA = proxyDao.selectList(MapperConstants.GOODS_MAIN_DISPLAY + "selectMainDisplay", so);
            mainAreaTypeA =proxyDao.selectList(MapperConstants.GOODS_MAIN_DISPLAY + "selectMainDisplay", so);
            result.put("mainAreaTypeA", mainAreaTypeA);
            for(int i=0; i<mainAreaTypeA.size(); i++) {
                vo = (GoodsVO)mainAreaTypeA.get(i);
                so.setDispSeq(vo.getDispSeq());
                ResultModel<DisplayGoodsVO> displayGoods = selectMainDisplayGoodsFront(so);
                result.put("mainAreaTypeA"+i, displayGoods.getData().getDisplayGoodsArr());
            }

            so.setDispSeq(null);
            so.setMainAreaGbCd("02");

            List<GoodsVO> mainAreaTypeB = proxyDao.selectList(MapperConstants.GOODS_MAIN_DISPLAY + "selectMainDisplay", so);
            result.put("mainAreaTypeB", mainAreaTypeB);

            for(int i=0; i<mainAreaTypeB.size(); i++) {
                vo = mainAreaTypeB.get(i);
                so.setDispSeq(vo.getDispSeq());
                ResultModel<DisplayGoodsVO> displayGoods = selectMainDisplayGoodsFront(so);
                result.put("mainAreaTypeB"+i, displayGoods.getData().getDisplayGoodsArr());
            }

            so.setDispSeq(null);
            so.setMainAreaGbCd("03");

            List<GoodsVO> mainAreaTypeC = proxyDao.selectList(MapperConstants.GOODS_MAIN_DISPLAY + "selectMainDisplay", so);
            result.put("mainAreaTypeC", mainAreaTypeC);

            for(int i=0; i<mainAreaTypeC.size(); i++) {
                vo = mainAreaTypeC.get(i);
                so.setDispSeq(vo.getDispSeq());
                ResultModel<DisplayGoodsVO> displayGoods = selectMainDisplayGoodsFront(so);
                result.put("mainAreaTypeC"+i, displayGoods.getData().getDisplayGoodsArr());
            }

        }



        /*so.setDispSeq("1");
        ResultModel<DisplayGoodsVO> displayGoods1 = selectMainDisplayGoodsFront(so);
        result.put("displayGoods1", displayGoods1.getData().getDisplayGoodsArr());
        so.setDispSeq("2");
        ResultModel<DisplayGoodsVO> displayGoods2 = selectMainDisplayGoodsFront(so);
        result.put("displayGoods2", displayGoods2.getData().getDisplayGoodsArr());
        so.setDispSeq("3");
        ResultModel<DisplayGoodsVO> displayGoods3 = selectMainDisplayGoodsFront(so);
        result.put("displayGoods3", displayGoods3.getData().getDisplayGoodsArr());
        so.setDispSeq("4");
        ResultModel<DisplayGoodsVO> displayGoods4 = selectMainDisplayGoodsFront(so);
        result.put("displayGoods4", displayGoods4.getData().getDisplayGoodsArr());
        so.setDispSeq("5");
        ResultModel<DisplayGoodsVO> displayGoods5 = selectMainDisplayGoodsFront(so);
        result.put("displayGoods5", displayGoods5.getData().getDisplayGoodsArr());*/

        return result;
    }

    @Transactional(readOnly = true)
    public Map<String, Object> selectIntroFront(DisplayGoodsSO so) throws Exception {
        DmallSessionDetails sessionInfo = SessionDetailHelper.getDetails();
        HttpServletRequest request = HttpUtil.getHttpServletRequest();

        // 프론트에 조회하는 메인전시관리 데이터
        Map result = new HashMap();

        // 01. MAIN VIsual Banner 조회
        BannerSO bs = new BannerSO();
        bs.setSiteNo(sessionInfo.getSiteNo());// 사이트번호셋팅
        String skinNo = "";

        if(SiteUtil.isMobile()) {
            if (request.getAttribute(RequestAttributeConstants.SKIN_NO) != null) {
            	skinNo = request.getAttribute(RequestAttributeConstants.SKIN_NO).toString();
            } else {
            	skinNo = "119";
            }
        }else {
	        if (request.getAttribute(RequestAttributeConstants.SKIN_NO) != null) {
	        	skinNo = request.getAttribute(RequestAttributeConstants.SKIN_NO).toString();
	        } else {
	        	skinNo = "2";
	        }
        }

        ResultListModel<BannerVO> bannerVo = new ResultListModel<>();

       //모바일 메인 비쥬얼배너
        bs.setSkinNo(skinNo);// 쇼핑몰의 리얼 스킨번호를 가져온다.
        bs.setBannerMenuCd("MO");
        bs.setBannerAreaCd("MMV");
        bs.setDispYn("Y");
        bs.setTodayYn("Y");
        bs.setSidx("SORT_SEQ");
        bs.setSord("ASC");
        bannerVo = new ResultListModel<>();
        bannerVo = bannerManageService.selectBannerListPaging(bs);
        result.put("mo_visual_banner", bannerVo);

        return result;
    }

    @Override
    @Transactional(readOnly = true)
    public ResultModel<DisplayGoodsVO> selectMainDisplayGoodsFront(DisplayGoodsSO so) throws Exception {
        DisplayGoodsVO vo = new DisplayGoodsVO();


        if(SiteUtil.isMobile()) {
             List<GoodsVO> temp = proxyDao.selectList(MapperConstants.GOODS_MAIN_DISPLAY + "selectMainDisplayGoodsMobile", so);
              for(int i=0; i<temp.size(); i++) {

                    if(temp.get(i).getCouponAvlInfo()!=null && !temp.get(i).getCouponAvlInfo().equals("")) {
                        GoodsVO dispVo = temp.get(i);
                        int avlLen = temp.get(i).getCouponAvlInfo().split("\\|").length;

                        for(int j=0;j<avlLen;j++){
                            if(j==0)
                            dispVo.setCouponApplyAmt(temp.get(i).getCouponAvlInfo().split("\\|")[j]);
                            if(j==1)
                            dispVo.setCouponDcAmt(temp.get(i).getCouponAvlInfo().split("\\|")[j]);
                            if(j==2)
                            dispVo.setCouponDcRate(temp.get(i).getCouponAvlInfo().split("\\|")[j]);
                            if(j==3)
                            dispVo.setCouponDcValue(temp.get(i).getCouponAvlInfo().split("\\|")[j]);
                            if(j==4)
                            dispVo.setCouponBnfCd(temp.get(i).getCouponAvlInfo().split("\\|")[j]);
                            if(j==5)
                            dispVo.setCouponBnfValue(temp.get(i).getCouponAvlInfo().split("\\|")[j]);
                            if(j==6)
                            dispVo.setCouponBnfTxt(temp.get(i).getCouponAvlInfo().split("\\|")[j]);
                        }
                    }
              }

              vo.setDisplayGoodsMoArr(temp);
        }else{
             List<DisplayGoodsVO> temp =  proxyDao.selectList(MapperConstants.GOODS_MAIN_DISPLAY + "selectMainDisplayGoodsFront", so);

              for(int i=0; i<temp.size(); i++) {

                    if(temp.get(i).getCouponAvlInfo()!=null && !temp.get(i).getCouponAvlInfo().equals("")) {
                        DisplayGoodsVO dispVo = temp.get(i);
                        int avlLen = temp.get(i).getCouponAvlInfo().split("\\|").length;

                        for(int j=0;j<avlLen;j++){
                            if(j==0)
                            dispVo.setCouponApplyAmt(temp.get(i).getCouponAvlInfo().split("\\|")[j]);
                            if(j==1)
                            dispVo.setCouponDcAmt(temp.get(i).getCouponAvlInfo().split("\\|")[j]);
                            if(j==2)
                            dispVo.setCouponDcRate(temp.get(i).getCouponAvlInfo().split("\\|")[j]);
                            if(j==3)
                            dispVo.setCouponDcValue(temp.get(i).getCouponAvlInfo().split("\\|")[j]);
                            if(j==4)
                            dispVo.setCouponBnfCd(temp.get(i).getCouponAvlInfo().split("\\|")[j]);
                            if(j==5)
                            dispVo.setCouponBnfValue(temp.get(i).getCouponAvlInfo().split("\\|")[j]);
                            if(j==6)
                            dispVo.setCouponBnfTxt(temp.get(i).getCouponAvlInfo().split("\\|")[j]);
                        }
                    }
                }

                vo.setDisplayGoodsArr(temp);
        }

        ResultModel<DisplayGoodsVO> result = new ResultModel<DisplayGoodsVO>(vo);
        return result;
    }

    @Override
    public int getMaxSiteDispSeq(DisplayGoodsSO so) throws Exception {
    	
    	 // TODO Auto-generated method stub
    	int nextSiteDispSeq  = proxyDao.selectOne(MapperConstants.GOODS_MAIN_DISPLAY + "getMaxSiteDispSeq", so);
     
        return nextSiteDispSeq;
    }
    
    // 메인전시 삭제
    @Override
    public ResultModel<DisplayGoodsPO> deleteMainDisplay(DisplayGoodsPO po) throws Exception {
        ResultModel<DisplayGoodsPO> result = new ResultModel<>();

        try {
            	// 기획전기본정보 삭제
            
            	String deletePath = FileUtil.getPath(UploadConstants.PATH_MAIN_DISPLAY);
  
                // 기획전대상상품 삭제
            	proxyDao.delete(MapperConstants.GOODS_MAIN_DISPLAY + "deleteMainDisplayGoods", po);
                proxyDao.delete(MapperConstants.GOODS_MAIN_DISPLAY + "deleteMainDisplay", po);
                // 배너 이미지 삭제
                File fileWeb = new File(deletePath + File.separator + po.getDispImgPath() + File.separator
                        + po.getDispImgNm());

                log.debug("deletePath : !!!!!!!!!!!! " + deletePath);
                log.debug("PrmtWebBannerImgPath : !!!!!!!!!!!! " + po.getDispImgPath());
                log.debug("separator : !!!!!!!!!!!! " + File.separator);
                log.debug("PrmtWebBannerImg : !!!!!!!!!!!! " + po.getDispImgNm());
                log.debug("fileWeb : !!!!!!!!!!!! " + fileWeb);

                if (fileWeb.exists()) {
                    FileUtil.delete(fileWeb);
                }

         
            result.setMessage(MessageUtil.getMessage("biz.common.delete"));
        } catch (DuplicateKeyException e) {
            throw new CustomException("biz.exception.common.exist", new Object[] { "메인전시 삭제" }, e);
        }
        return result;

    }
}
