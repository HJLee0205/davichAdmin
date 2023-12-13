package net.danvi.dmall.front.web.view.search.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import net.danvi.dmall.biz.system.util.InterfaceUtil;
import org.springframework.beans.BeanUtils;
import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import dmall.framework.common.constants.RequestAttributeConstants;
import dmall.framework.common.model.ResultListModel;
import dmall.framework.common.model.ResultModel;
import dmall.framework.common.util.HttpUtil;
import dmall.framework.common.util.SiteUtil;
import lombok.extern.slf4j.Slf4j;
import net.danvi.dmall.biz.app.design.model.BannerSO;
import net.danvi.dmall.biz.app.design.model.BannerVO;
import net.danvi.dmall.biz.app.design.service.BannerManageService;
import net.danvi.dmall.biz.app.goods.model.BrandVO;
import net.danvi.dmall.biz.app.goods.model.CategoryDisplayManageSO;
import net.danvi.dmall.biz.app.goods.model.CategoryDisplayManageVO;
import net.danvi.dmall.biz.app.goods.model.CategorySO;
import net.danvi.dmall.biz.app.goods.model.CategoryVO;
import net.danvi.dmall.biz.app.goods.model.ContactWearSO;
import net.danvi.dmall.biz.app.goods.model.ContactWearVO;
import net.danvi.dmall.biz.app.goods.model.CtgVO;
import net.danvi.dmall.biz.app.goods.model.GoodsSO;
import net.danvi.dmall.biz.app.goods.model.GoodsVO;
import net.danvi.dmall.biz.app.goods.service.CategoryManageService;
import net.danvi.dmall.biz.app.goods.service.GoodsManageService;
import net.danvi.dmall.biz.app.promotion.event.model.EventLettVO;
import net.danvi.dmall.biz.app.setup.snsoutside.model.SnsConfigVO;
import net.danvi.dmall.biz.system.security.DmallSessionDetails;
import net.danvi.dmall.biz.system.security.SessionDetailHelper;

/**
 * <pre>
 * - 프로젝트명    : 31.front.web
 * - 패키지명      : front.web.view.search.controller
 * - 파일명        : SearchController.java
 * - 작성일        : 2016. 5. 2.
 * - 작성자        : dong
 * - 설명          : 조회 Controller
 * </pre>
 */
@Slf4j
@Controller
@RequestMapping("/front/search")
public class SearchController {

    @Resource(name = "categoryManageService")
    private CategoryManageService categoryManageService;

    @Resource(name = "goodsManageService")
    private GoodsManageService goodsManageService;

    @Resource(name = "bannerManageService")
    private BannerManageService bannerManageService;

    @RequestMapping(value = "/category")
    public ModelAndView categorySearch(@Validated CategorySO so, BindingResult bindingResult) throws Exception {
        ModelAndView mav = SiteUtil.getSkinView("/category/search_list");

        ResultModel<CategoryVO> category_info = categoryManageService.selectCategory(so);
        mav.addObject("category_info", category_info.getData());
        //필터 유형 코드
        so.setFilterTypeCd(category_info.getData().getFilterTypeCd());

        List<CategoryVO> navigation = categoryManageService.selectUpNavagation(so);
        mav.addObject("navigation", navigation);

        // 01-1.전시카테고리 리스트 조회
        CategoryDisplayManageSO cdm = new CategoryDisplayManageSO();
        cdm.setSiteNo(so.getSiteNo());
        cdm.setCtgNo(so.getCtgNo());
        cdm.setUseYn("Y");
        cdm.setSaleYn("Y"); // 판매중인 상품 조건
        List<CategoryDisplayManageVO> resultListModel = categoryManageService.selectCtgDispMngList(cdm);
        mav.addObject("category_list", resultListModel);

        if (so.getDisplayTypeCd() == null || "".equals(so.getDisplayTypeCd())) {
            so.setDisplayTypeCd("01");
        }

        // 01-2.전시카테고리 상품리스트 조회
        for (int i = 0; i < resultListModel.size(); i++) {
            cdm.setCtgDispzoneNo(resultListModel.get(i).getCtgDispzoneNo());
            List<GoodsVO> ctgDisplayGoodsList = categoryManageService.selectCtgDispGoodsList(cdm);
            if (ctgDisplayGoodsList != null && ctgDisplayGoodsList.size() > 0) {
                for(int j = 0; j < ctgDisplayGoodsList.size(); j++) {


                    /*for(int k=0; k<ctgDisplayGoodsList.size(); k++) {*/

                        if(ctgDisplayGoodsList.get(j).getCouponAvlInfo()!=null && !ctgDisplayGoodsList.get(j).getCouponAvlInfo().equals("")) {
                            GoodsVO dispVo = ctgDisplayGoodsList.get(j);
                            int avlLen = ctgDisplayGoodsList.get(j).getCouponAvlInfo().split("\\|").length;

                            for(int l=0;l<avlLen;l++){
                                if(l==0)
                                dispVo.setCouponApplyAmt(ctgDisplayGoodsList.get(j).getCouponAvlInfo().split("\\|")[l]);
                                if(l==1)
                                dispVo.setCouponDcAmt(ctgDisplayGoodsList.get(j).getCouponAvlInfo().split("\\|")[l]);
                                if(l==2)
                                dispVo.setCouponDcRate(ctgDisplayGoodsList.get(j).getCouponAvlInfo().split("\\|")[l]);
                                if(l==3)
                                dispVo.setCouponDcValue(ctgDisplayGoodsList.get(j).getCouponAvlInfo().split("\\|")[l]);
                                if(l==4)
                                dispVo.setCouponBnfCd(ctgDisplayGoodsList.get(j).getCouponAvlInfo().split("\\|")[l]);
                                if(l==5)
                                dispVo.setCouponBnfValue(ctgDisplayGoodsList.get(j).getCouponAvlInfo().split("\\|")[l]);
                                if(l==6)
                                dispVo.setCouponBnfTxt(ctgDisplayGoodsList.get(j).getCouponAvlInfo().split("\\|")[l]);
                            }
                        }
                    /*}*/

                    if(ctgDisplayGoodsList.get(j).getCtgDispzoneNo().equals(resultListModel.get(i).getCtgDispzoneNo())){
                        ctgDisplayGoodsList.get(j).setCtgDispDispTypeCd(resultListModel.get(i).getCtgDispDispTypeCd());
                        mav.addObject("category_display_goods_" + cdm.getCtgDispzoneNo(), ctgDisplayGoodsList);
                    }


                }
            }
        }

        // 02.카테고리 상품 조회
        GoodsSO gs = new GoodsSO();
        BeanUtils.copyProperties(so, gs);
        String goodsDisplay[] = { "Y" }; // 전시여부
        gs.setGoodsDisplay(goodsDisplay);
        gs.setSaleYn("Y");

        if ("".equals(so.getSortType()) || so.getSortType() == null) so.setSortType("02");
        if ("01".equals(so.getSortType())) {// 판매순
            gs.setSidx("ACCM_SALE_AMT");
            gs.setSord("DESC");
        } else if ("02".equals(so.getSortType())) {// 신상품순
            gs.setSidx("REG_DTTM");
            gs.setSord("DESC");
        } else if ("03".equals(so.getSortType())) {// 낮은가격순
            gs.setSidx("SALE_PRICE");
            gs.setSord("ASC");
        } else if ("04".equals(so.getSortType())) {// 높은가격순
            gs.setSidx("SALE_PRICE");
            gs.setSord("DESC");
        } else if ("05".equals(so.getSortType())) {// 상품평 많은순
            gs.setSidx("ACCM_GOODSLETT_CNT");
            gs.setSord("DESC");
        }
        
        
        //카테고리 배너
        DmallSessionDetails sessionInfo = SessionDetailHelper.getDetails();
        HttpServletRequest request = HttpUtil.getHttpServletRequest();
        BannerSO bs = new BannerSO();
        bs.setSiteNo(sessionInfo.getSiteNo());// 사이트번호셋팅
        String skinNo = "";
        
        if (request.getAttribute(RequestAttributeConstants.SKIN_NO) != null) {
            skinNo = request.getAttribute(RequestAttributeConstants.SKIN_NO).toString();
        } else {
            skinNo = "2";
        }

        bs.setSkinNo(skinNo);// 쇼핑몰의 리얼 스킨번호를 가져온다.
        bs.setDispYn("Y");
        bs.setTodayYn("Y");
        bs.setSidx("SORT_SEQ");
        bs.setSord("ASC");
        ResultListModel<BannerVO> bannerVo = new ResultListModel<>();
        
        if(SiteUtil.isMobile()) {      
	        bs.setBannerMenuCd("MCT");
	        bs.setBannerAreaCd("MCT"+so.getCtgNo());
        }else{
	        bs.setBannerMenuCd("CT");
	        bs.setBannerAreaCd("CT"+so.getCtgNo());
        }
        
        bannerVo = bannerManageService.selectBannerListPaging(bs);
        mav.addObject("category_banner", bannerVo);
        
        if("all".equals(so.getSearchAll())) {
        	so.setCtgLvl("2");
        }

        if (!"1".equals(so.getCtgLvl())) {

	        if (so.getRows() < 20) so.setRows(20); // 최소 20개씨 노출
	        gs.setRows(so.getRows());
	        for (int i = 0; i < navigation.size(); i++) {
	            if ("1".equals(navigation.get(i).getCtgLvl())) {
	                gs.setSearchCtg1(navigation.get(i).getCtgNo());
	            } else if ("2".equals(navigation.get(i).getCtgLvl())) {
	                gs.setSearchCtg2(navigation.get(i).getCtgNo());
	            } else if ("3".equals(navigation.get(i).getCtgLvl())) {
	                gs.setSearchCtg3(navigation.get(i).getCtgNo());
	            } else if ("4".equals(navigation.get(i).getCtgLvl())) {
	                gs.setSearchCtg4(navigation.get(i).getCtgNo());
	            }
	        }
	        if(gs.getStPrice()!=null)
	            gs.setStPrice(gs.getStPrice().replaceAll(",",""));
	
	        if(gs.getEndPrice()!=null)
	        gs.setEndPrice(gs.getEndPrice().replaceAll(",",""));
	
	        // 필터 조건
	        ResultListModel<GoodsVO> result = goodsManageService.selectGoodsList(gs);
	        mav.addObject("resultListModel", result);
        
        }

        // 베스트 브랜드 리스트 조회
        BrandVO bv = new BrandVO();
        String [] bestBrandNo = null;
        String brandNo = "";
        if(category_info.getData().getBestBrandNo()!=null){
            bestBrandNo  =  category_info.getData().getBestBrandNo().split(",");
            for(int i=0;i<bestBrandNo.length;i++){
                brandNo+="'"+bestBrandNo[i]+"'";
                if(i!=bestBrandNo.length-1){
                    brandNo+=",";
                }
            }
        }

        bv.setSiteNo(so.getSiteNo());
        bv.setBrandNo(brandNo);
        // 카테고리 컨텐츠 구분 코드에 맞춰서 이동
        String goodsContsGbCd = "";
        if(category_info.getData().getGoodsContsGbCd()!=null && !category_info.getData().getGoodsContsGbCd().equals("") && !category_info.getData().getGoodsContsGbCd().equals("01")){
            goodsContsGbCd ="02"; //컨텐츠
        }else{
            goodsContsGbCd ="01"; //실물
        }
        if(goodsContsGbCd.equals("01")) {
            // 03.카테고리 레벨에 맞춰서 이동
            if ("1".equals(so.getCtgLvl())) {
                mav.setViewName("/category/category_goods_list_01");
                List<BrandVO> brand_list = goodsManageService.selectBrandList(bv);
                mav.addObject("brand_list", brand_list);
                
                List<BrandVO> contact_wear_brand_list = goodsManageService.selectContactWearBrandList(bv);
                mav.addObject("contact_wear_brand_list", contact_wear_brand_list);


                
            /*} else if ("2".equals(so.getCtgLvl())) {
                mav.setViewName("/category/category_goods_list_02");
            } else if ("3".equals(so.getCtgLvl())) {
                mav.setViewName("/category/category_goods_list_03");
            } else if ("4".equals(so.getCtgLvl())) {
                so.setUpCtgNo(navigation.get(2).getCtgNo());
                mav.setViewName("/category/category_goods_list_04");*/
            } else {
                //상품속성별 브랜드만 필터 노출
                bv.setGoodsTypeCd(so.getFilterTypeCd());
                List<BrandVO> brand_list = goodsManageService.selectBrandList(bv);
                mav.addObject("brand_list", brand_list);

                // 배너 조회
                //BannerSO bs = new BannerSO();
                bs.setSiteNo(so.getSiteNo());// 사이트번호셋팅
                //String skinNo = "";
                //HttpServletRequest request = HttpUtil.getHttpServletRequest();
                if (request.getAttribute(RequestAttributeConstants.SKIN_NO) != null) {
                    skinNo = request.getAttribute(RequestAttributeConstants.SKIN_NO).toString();
                } else {
                    skinNo = "2";
                }

                // 쇼핑몰의 리얼 스킨번호를 가져온다.
                bs.setSkinNo(skinNo);
                if (SiteUtil.isMobile()) {
                    bs.setBannerMenuCd("MO");
                    bs.setBannerAreaCd("MCF");
                } else {
                    bs.setBannerMenuCd("CM");
                    bs.setBannerAreaCd("CTF");
                }
                bs.setDispYn("Y");
                bs.setTodayYn("Y");
                bs.setSidx("SORT_SEQ");
                bs.setSord("ASC");
                bannerVo = new ResultListModel<>();
                bannerVo = bannerManageService.selectBannerListPaging(bs);
                mav.addObject("visual_banner", bannerVo);

                mav.setViewName("/category/category_goods_list_02");
            }

            // 방문예약 매장 총 개수 조회
            Map<String, Object> param = new HashMap<>();
            Map<String, Object> result = new HashMap<>();
            result = InterfaceUtil.send("IF_RSV_006", param);
            if ("1".equals(result.get("result"))) {
            mav.addObject("storeTotCnt", result.get("totalCnt"));

            }else{
                throw new Exception(String.valueOf(result.get("message")));
            }
        }else{

            gs.setGoodsContsGbCd("02");//컨텐츠

            if (so.getRows() < 20){
                so.setRows(1000); // 최소 1000개씨 노출
            }
	        gs.setRows(so.getRows());
	        for (int i = 0; i < navigation.size(); i++) {
	            if ("1".equals(navigation.get(i).getCtgLvl())) {
	                gs.setSearchCtg1(navigation.get(i).getCtgNo());
	            } else if ("2".equals(navigation.get(i).getCtgLvl())) {
	                gs.setSearchCtg2(navigation.get(i).getCtgNo());
	            } else if ("3".equals(navigation.get(i).getCtgLvl())) {
	                gs.setSearchCtg3(navigation.get(i).getCtgNo());
	            } else if ("4".equals(navigation.get(i).getCtgLvl())) {
	                gs.setSearchCtg4(navigation.get(i).getCtgNo());
	            }
	        }


	        // 필터 조건
	        ResultListModel<GoodsVO> result = goodsManageService.selectGoodsList(gs);
	        mav.addObject("resultListModel", result);

            mav.setViewName("/category/category_goods_list_05");

        }
        
        //베스트 카테고리
        if (so.getBestCtg() != null && "Y".equals(so.getBestCtg())) {
        	mav.setViewName("/category/category_goods_list_06");
        }
        
        //착용샷 페이지
        if(so.getWearYn() != null && "Y".equals(so.getWearYn())) {
        	mav.setViewName("/category/contact_wear_list");
        }
        
        mav.addObject("so", so);
        return mav;
    }

    @RequestMapping(value = "/category-ajax")
    public @ResponseBody ResultListModel<GoodsVO>  categorySearchAjax(@Validated CategorySO so, BindingResult bindingResult) throws Exception {

        //ModelAndView mav = SiteUtil.getSkinView("/category/search_list");

        ResultModel<CategoryVO> category_info = categoryManageService.selectCategory(so);
       // mav.addObject("category_info", category_info.getData());
        //필터 유형 코드
        //so.setFilterTypeCd(category_info.getData().getFilterTypeCd());

        List<CategoryVO> navigation = categoryManageService.selectUpNavagation(so);
       // mav.addObject("navigation", navigation);

        // 01-1.전시카테고리 리스트 조회
       /* CategoryDisplayManageSO cdm = new CategoryDisplayManageSO();
        cdm.setSiteNo(so.getSiteNo());
        cdm.setCtgNo(so.getCtgNo());
        cdm.setUseYn("Y");
        cdm.setSaleYn("Y"); // 판매중인 상품 조건
        List<CategoryDisplayManageVO> resultListModel = categoryManageService.selectCtgDispMngList(cdm);
        mav.addObject("category_list", resultListModel);

        if (so.getDisplayTypeCd() == null || "".equals(so.getDisplayTypeCd())) {
            so.setDisplayTypeCd("01");
        }*/

        // 01-2.전시카테고리 상품리스트 조회
        /*for (int i = 0; i < resultListModel.size(); i++) {
            cdm.setCtgDispzoneNo(resultListModel.get(i).getCtgDispzoneNo());
            List<GoodsVO> ctgDisplayGoodsList = categoryManageService.selectCtgDispGoodsList(cdm);
            if (ctgDisplayGoodsList != null && ctgDisplayGoodsList.size() > 0) {
                for(int j = 0; j < ctgDisplayGoodsList.size(); j++) {
                    if(ctgDisplayGoodsList.get(j).getCtgDispzoneNo().equals(resultListModel.get(i).getCtgDispzoneNo())){
                        ctgDisplayGoodsList.get(j).setCtgDispDispTypeCd(resultListModel.get(i).getCtgDispDispTypeCd());
                        mav.addObject("category_display_goods_" + cdm.getCtgDispzoneNo(), ctgDisplayGoodsList);
                    }
                }
            }
        }*/

        // 02.카테고리 상품 조회
        GoodsSO gs = new GoodsSO();
        BeanUtils.copyProperties(so, gs);
        String goodsDisplay[] = { "Y" }; // 전시여부
        gs.setGoodsDisplay(goodsDisplay);
        gs.setSaleYn("Y");
        if ("".equals(so.getSortType()) || so.getSortType() == null) so.setSortType("02");

        gs.setGoodsContsGbCd("02");//컨텐츠

        if (!"1".equals(so.getCtgLvl())) {

	        if (so.getRows() < 1000) so.setRows(1000); // 최소 120개씨 노출
	        gs.setRows(so.getRows());
	        for (int i = 0; i < navigation.size(); i++) {
	            if ("1".equals(navigation.get(i).getCtgLvl())) {
	                gs.setSearchCtg1(navigation.get(i).getCtgNo());
	            } else if ("2".equals(navigation.get(i).getCtgLvl())) {
	                gs.setSearchCtg2(navigation.get(i).getCtgNo());
	            } else if ("3".equals(navigation.get(i).getCtgLvl())) {
	                gs.setSearchCtg3(navigation.get(i).getCtgNo());
	            } else if ("4".equals(navigation.get(i).getCtgLvl())) {
	                gs.setSearchCtg4(navigation.get(i).getCtgNo());
	            }
	        }
	        if(gs.getStPrice()!=null)
	            gs.setStPrice(gs.getStPrice().replaceAll(",",""));

	        if(gs.getEndPrice()!=null)
	        gs.setEndPrice(gs.getEndPrice().replaceAll(",",""));

	        // 필터 조건
	        ResultListModel<GoodsVO> result = goodsManageService.selectGoodsList(gs);
	        /*mav.addObject("resultListModel", result);*/

        }
           if (so.getRows() < 1000) so.setRows(1000); // 최소 1000개씨 노출
	        gs.setRows(so.getRows());
	        for (int i = 0; i < navigation.size(); i++) {
	            if ("1".equals(navigation.get(i).getCtgLvl())) {
	                gs.setSearchCtg1(navigation.get(i).getCtgNo());
	            } else if ("2".equals(navigation.get(i).getCtgLvl())) {
	                gs.setSearchCtg2(navigation.get(i).getCtgNo());
	            } else if ("3".equals(navigation.get(i).getCtgLvl())) {
	                gs.setSearchCtg3(navigation.get(i).getCtgNo());
	            } else if ("4".equals(navigation.get(i).getCtgLvl())) {
	                gs.setSearchCtg4(navigation.get(i).getCtgNo());
	            }
	        }

        ResultListModel<GoodsVO> result = goodsManageService.selectGoodsList(gs);

        return result;
    }

    @RequestMapping(value = "/goods-list-search")
    public ModelAndView goodsSearch(@Validated GoodsSO so, BindingResult bindingResult) throws Exception {
        ModelAndView mav = SiteUtil.getSkinView("/category/search_list");
        if (so.getDisplayTypeCd() == null || "".equals(so.getDisplayTypeCd())) so.setDisplayTypeCd("01");
        if (so.getSortType() == null || "".equals(so.getSortType())) so.setSortType("02");
        if (so.getSearchType() == null || "".equals(so.getSearchType())) so.setSearchType("1");

        if ("01".equals(so.getSortType())) {// 판매순
            so.setSidx("ACCM_SALE_AMT");
            so.setSord("DESC");
        } else if ("02".equals(so.getSortType())) {// 신상품순
            so.setSidx("REG_DTTM");
            so.setSord("DESC");
        } else if ("03".equals(so.getSortType())) {// 낮은가격순
            so.setSidx("SALE_PRICE");
            so.setSord("ASC");
        } else if ("04".equals(so.getSortType())) {// 높은가격순
            so.setSidx("SALE_PRICE");
            so.setSord("DESC");
        } else if ("05".equals(so.getSortType())) {// 상품평 많은순
            so.setSidx("ACCM_GOODSLETT_CNT");
            so.setSord("DESC");
        }

        String goodsDisplay[] = { "Y" }; // 전시여부
        so.setGoodsDisplay(goodsDisplay);
        so.setSaleYn("Y");
        if (so.getRows() < 20) so.setRows(20); // 최소 20개씨 노출
        
        /*비전체크 후 검색*/
        if(so.getSearchVisionCtg() != null) {        	
        	if(so.getSearchVisionCtgAll() == null) {
        		so.setSearchVisionCtgAll(so.getSearchVisionCtg());
        		so.setSearchVisionCtgNmAll(so.getSearchVisionCtgNm());        		
        	}
        	
        	List<GoodsSO> searchVisionCtg = new ArrayList<GoodsSO>();
        	if(so.getSearchVisionCtgAll().indexOf(",") > 0){        		
				String[] strTmp = so.getSearchVisionCtgAll().split(",");
				String[] strTmp1 = so.getSearchVisionCtgNmAll().split(",");
				for(int i=0; i<strTmp.length; i++){
					GoodsSO vcSO = new GoodsSO();
					vcSO.setSearchVisionCtg(strTmp[i]);
					vcSO.setSearchVisionCtgNm(strTmp1[i]);
					searchVisionCtg.add(vcSO);
				}				
        	}else {
        		
        		GoodsSO vcSO = new GoodsSO();
				vcSO.setSearchVisionCtg(so.getSearchVisionCtg());
				vcSO.setSearchVisionCtgNm(so.getSearchVisionCtgNm());
				searchVisionCtg.add(vcSO);
        	}        	
        	mav.addObject("searchVisionCtg", searchVisionCtg);
        	
        	
        	List<String> ctgMap = new ArrayList<>();
        	if(so.getSearchVisionCtg().indexOf(",") > 0){
				String[] strTmp = so.getSearchVisionCtg().split(",");
				for(int i=0; i<strTmp.length; i++){
				if(strTmp[i]!=null && !strTmp[i].equals(""))
					ctgMap.add(strTmp[i]);
				}				
        	}else {
                if(so.getSearchVisionCtg()!=null && !so.getSearchVisionCtg().equals(""))
        		ctgMap.add(so.getSearchVisionCtg());
        	}
        	if(ctgMap.size()>0) {
                so.setCtgMap(ctgMap);
            }
        }
        
        /*보청기 추천 후 검색*/        
        if(so.getSearchGoodsNos() != null) {
        	List<String> goodsNoMap = new ArrayList<>();
        	if(so.getSearchGoodsNos().indexOf(",") > 0){
				String[] strTmp = so.getSearchGoodsNos().split(",");
				for(int i=0; i<strTmp.length; i++){
				if(strTmp[i]!=null && !strTmp[i].equals(""))
					goodsNoMap.add(strTmp[i]);
				}				
        	}else {
                if(so.getSearchGoodsNos()!=null && !so.getSearchGoodsNos().equals(""))
                	goodsNoMap.add(so.getSearchGoodsNos());
        	}
        	
        	if(goodsNoMap.size()>0) {
                so.setGoodsNoMap(goodsNoMap);
            }
        }
        
        ResultListModel<GoodsVO> result = goodsManageService.selectGoodsList(so);
        mav.addObject("resultListModel", result);
        mav.addObject("so", so);
        
        
        
        return mav;
    }

    @RequestMapping("/category-list")
    public @ResponseBody ResultListModel<CtgVO> selectCtgList(CtgVO vo) {
        ResultListModel<CtgVO> result = new ResultListModel<>();

        List<CtgVO> list = goodsManageService.selectCtgList(vo);
        result.setResultList(list);
        result.setSuccess(list.size() > 0 ? true : false);

        return result;
    }
    
    /**
     * <pre>
     * 작성일 : 2019. 6. 17.
     * 작성자 : hskim
     * 설명   : 렌즈 착용샷 페이지(ajax)
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * </pre>
     */
    @RequestMapping("/contact-wear-list-ajax")
    public ModelAndView ajaxPromotionList(@Validated ContactWearSO so, BindingResult bindingResult) throws Exception {
        ModelAndView mv = SiteUtil.getSkinView("/category/contact_wear_list_tab");
        mv.addObject("so", so);
        
        so.setWearImgType("02"); //왼쪽 착용샷
        so.setLensImgType("04"); //왼쪽 렌즈
        mv.addObject("left_wear_list", goodsManageService.selectContactWearList(so));
        
        so.setWearImgType("03"); //오른쪽 착용샷
        so.setLensImgType("05"); //오른쪽 렌즈
        mv.addObject("right_wear_list", goodsManageService.selectContactWearList(so));
        return mv;
    }
    
    /**
     * <pre>
     * 작성일 : 2019. 6. 17.
     * 작성자 : hskim
     * 설명   : 렌즈 착용샷 페이지(ajax) - 모바일용
     *
     * 수정내역(수정일 수정자 - 수정내용)
     * </pre>
     */
    @RequestMapping("/mobile-contact-wear-list-ajax")
    public ModelAndView ajaxMobilePromotionList(@Validated ContactWearSO so, BindingResult bindingResult) throws Exception {
        ModelAndView mv = SiteUtil.getSkinView("/category/contact_wear_list_tab");
        
        so.setRows(20);
        so.setSidx("GOODS_NO");
        so.setSord("DESC");
        
        // 브랜드별 상품 목록 
        ResultListModel<ContactWearVO> result = goodsManageService.selectWearImgsetNoList(so);
        
        so.setWearImgType("02"); //오른쪽 착용샷
        so.setLensImgType("04"); //오른쪽 렌즈
        
        Map<String, Object> wearMap = new HashMap<>();
        for (int i = 0; i < result.getResultList().size(); i++) {
        	ContactWearVO vo = (ContactWearVO) result.getResultList().get(i);
        	so.setArrWearImgsetNo(vo.getArrWearImgsetNo());
        	//상품별 착용샷 정보 목록
        	List<ContactWearVO> wearList = goodsManageService.selectContactWearList(so);
        	wearMap.put("wearList_"+i, wearList);
        }
        
        mv.addObject("so", so);
        mv.addObject("wearImgsetNoList", result.getResultList());
        mv.addObject("wearMap", wearMap);
        mv.addObject("wearTotPages", result.getTotalPages());
        
        return mv;
    }
}