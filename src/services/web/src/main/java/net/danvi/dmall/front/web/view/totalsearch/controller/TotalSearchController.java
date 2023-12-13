package net.danvi.dmall.front.web.view.totalsearch.controller;

import net.danvi.dmall.biz.app.design.model.BannerSO;
import net.danvi.dmall.biz.app.design.model.BannerVO;
import net.danvi.dmall.biz.app.design.service.BannerManageService;
import net.danvi.dmall.biz.app.goods.model.CategorySO;
import net.danvi.dmall.biz.app.goods.model.GoodsSO;
import net.danvi.dmall.biz.app.goods.model.GoodsVO;
import net.danvi.dmall.biz.app.goods.service.CategoryManageService;
import net.danvi.dmall.biz.app.goods.service.GoodsManageService;
import net.danvi.dmall.biz.app.multi.qna.model.MultiVO;
import net.danvi.dmall.biz.app.promotion.exhibition.model.ExhibitionSO;
import net.danvi.dmall.biz.app.promotion.exhibition.model.ExhibitionVO;
import net.danvi.dmall.biz.app.promotion.exhibition.service.ExhibitionService;
import net.danvi.dmall.biz.system.security.DmallSessionDetails;
import net.danvi.dmall.biz.system.security.SessionDetailHelper;
import oracle.net.aso.d;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.UnsupportedEncodingException;
import java.nio.charset.Charset;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import javax.annotation.Resource;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang.CharSet;
import org.apache.commons.lang3.StringUtils;
import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.entity.StringEntity;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.protocol.HTTP;
import org.apache.http.util.EntityUtils;
import org.json.JSONObject;
import org.json.simple.JSONArray;
import org.json.simple.parser.JSONParser;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.konantech.ksf.client.CrzClient;
import com.konantech.ksf.client.KsfClient;
import com.konantech.ksf.client.QueryBuilder;
import com.konantech.ksf.client.SearchQuery;
import com.konantech.ksf.client.response.AutocompleteResponse;
import com.konantech.ksf.client.result.SearchResultSet;
import com.konantech.ksf.std.Config;
import com.konantech.ksf.std.Stuffs;

import lombok.extern.slf4j.Slf4j;
import dmall.framework.common.constants.RequestAttributeConstants;
import dmall.framework.common.model.ResultListModel;
import dmall.framework.common.model.ResultModel;
import dmall.framework.common.util.HttpUtil;
import dmall.framework.common.util.SiteUtil;
import dmall.framework.common.util.StringUtil;

/**
 * <pre>
 * - 프로젝트명    : 31.front.web
 * - 패키지명      : front.web.view.totalsearch.controller
 * - 파일명        : TotalSearchController.java
 * - 작성일        : 2019. 5. 20.
 * - 작성자        : Hong
 * - 설명          : 카테고리 리스트 Controller
 * </pre>
 */
@Slf4j
@Controller
@RequestMapping("/front/totalsearch")
public class TotalSearchController {

	@Resource(name = "categoryManageService")
    private CategoryManageService categoryManageService;

    @Resource(name = "goodsManageService")
    private GoodsManageService goodsManageService;

    @Resource(name = "bannerManageService")
    private BannerManageService bannerManageService;

    @Resource(name = "exhibitionService")
    private ExhibitionService exhibitionService;

    @Autowired Properties konan;

    @RequestMapping(value = "/main")
    public ModelAndView goodsSearch(@Validated GoodsSO so, @Validated ExhibitionSO eso,
    		HttpServletRequest request, HttpSession session, BindingResult bindingResult) throws Exception {

    	ModelAndView mav = SiteUtil.getSkinView("/totalsearch/main");

    	String searchWord = request.getParameter("searchWord").replaceAll("[?]","");
    if (request.getParameter("searchWord").length()  == 1) {


    	 searchWord = request.getParameter("searchWord").replaceAll("[?]","''");


    }



    	request. setCharacterEncoding("utf-8");
    	String searchWordOrg = request.getParameter("searchWordOrg");
    	//mav.addObject("searchWord",searchWord);
    	KsfClient ksf = new KsfClient(konan.getProperty("KSF_URL"));

    	if(!StringUtils.defaultString(searchWordOrg).equals(searchWord)){
        	//오타교정
        	boolean corrected = false;
        	String[] tokens = StringUtils.split(searchWord);
        	for (int i = 0; i < tokens.length; i++) {
        	    String[] spells = ksf.suggestSpell(tokens[i]);

        	    if (spells.length > 0) {
        	        // replace incorrect tokens
        	        tokens[i] = spells[0];
        	        corrected = true;
        	    }
        	}

        	if (corrected) {
        	    // save corrected keywords
        	    session.setAttribute("spell", StringUtils.join(tokens, ' '));
        	    mav.addObject("searchWord",StringUtils.join(tokens, ' '));
        	    mav.addObject("searchWordOrg",searchWord);
        	    searchWord = StringUtils.join(tokens, ' ');
        	}else {
        		session.setAttribute("spell", "");
        		mav.addObject("searchWord",searchWord);
        		mav.addObject("searchWordOrg","");
        	}
    	}else {
    		searchWord = searchWordOrg;
    		mav.addObject("searchWord",searchWord);
    		mav.addObject("searchWordOrg","");
    	}
    	so.setSearchWord(searchWord);
    	//연관검색어
    	String[] suggestions = ksf.suggestRelated(0, searchWord, 10);
    	request.setAttribute("suggestions", suggestions);

    	/*//인기검색어
    	String[][] rankings = ksf.getRankings(0, 10);
    	request.setAttribute("rankings", rankings);*/

    	return mav;
    }

    @RequestMapping(value="/api/rankings")
    public @ResponseBody ResultModel<Object> rankings(HttpServletRequest request) throws Exception {
    	ResultModel<Object> result = new ResultModel<>();
    	SimpleDateFormat format = new SimpleDateFormat("yyyy. MM. dd HH:mm:ss 기준");
    	Date date = new Date();
    	String time = format.format(date);

    	KsfClient ksf = new KsfClient(konan.getProperty("KSF_URL"));
    	String[][] rankings = ksf.getRankings(0, 10);

    	Map<String, Object> strObj = new HashMap<String, Object>();
    	strObj.put("rankings", rankings);
    	strObj.put("time", time);
    	result.setData(strObj);

    	return result;
    }


    @RequestMapping(value="/api/suggestCompletion")
    public @ResponseBody ResultModel<Object> suggestCompletion(HttpServletRequest request) throws Exception {
    	ResultModel<Object> result = new ResultModel<>();
    	String seed = "";
    	seed = request.getParameter("seed");
    	String strResult = "";
    	KsfClient ksf = new KsfClient(konan.getProperty("KSF_URL"));

    	HttpClient client = new DefaultHttpClient();

    	HttpGet httpGet = new HttpGet(konan.getProperty("KSF_URL")+"api/suggest?target=complete&domain_no=0&term="+seed+"&mode=s&max_count=5");
    	httpGet.setHeader("Content-Type","application/json; charset=utf-8");
    	/*
    	try {
    		StringEntity strEnd = new StringEntity(s)
    	} catch (UnsupportedEncodingException uee) {
    		uee.printStackTrace();
    	}
    	*/

    	HttpResponse response = client.execute(httpGet);

    	HttpEntity entity = response.getEntity();

    	Map<String, Object> strObj = new HashMap<String, Object>();
    	if(entity != null) {
    		InputStream instream = entity.getContent();
    		int i;
    		byte[] temp = new byte[2048];
    		while ((i = instream.read(temp)) != -1) {
    			strResult = strResult += new String(temp,"utf-8");
    		}
    		strResult = strResult.trim();

    		/*
    		JSONParser parser = new JSONParser();
    		Object parObj = parser.parse(strResult);
    		JSONObject jsonResult = (JSONObject)parObj;
    		*/
        	strObj.put("strResult",strResult);

    		//strResult = convertStreamToString(instream);
    		//strResult = EntityUtils.toString(entity, HTTP.UTF_8);
    		//byte[] strBuffer = strResult.getBytes(Charset.forName("utf-8"));
    		//String ecdResult = new String(strBuffer, "utf-8");
    	}
    	/*
    	AutocompleteResponse suggestCompletion = new AutocompleteResponse();
    	String[][][] arraySuggestCompletion;
    	suggestCompletion = ksf.suggestCompletion(0, seed, "s", 5);
    	arraySuggestCompletion = suggestCompletion.getSuggestions();
    	for (String[][] strings : arraySuggestCompletion) {
			for (String[] strings2 : strings) {
				for (String string : strings2) {
					System.out.println("string ::::: "+string);
				}
			}
		}
		*/

    	result.setData(strObj);
    	return result;
    }

    public String convertStreamToString(InputStream is) {
    	BufferedReader reader = new BufferedReader(new InputStreamReader(is));
    	StringBuilder sb = new StringBuilder();

    	String line = null;
    	try {
    		while ((line = reader.readLine()) != null) {
    			sb.append(line + "\n");
    		}
		} catch (IOException ioe) {
			ioe.printStackTrace();
		} finally {
			try {
				is.close();
			} catch (IOException ioe) {
				ioe.printStackTrace();
			}
		}
    	return sb.toString();
    }

    //메인 카테고리 리스트
    @RequestMapping(value = "/inc/inc_total")
    public ModelAndView incTotal(@Validated GoodsSO so,
				    		@Validated ExhibitionSO eso,
				    		@Validated CategorySO cso,
				    		BindingResult bindingResult,
				    		HttpServletRequest request) throws Exception {

    	ModelAndView mav = SiteUtil.getSkinView("/totalsearch/inc/inc_total");
    	if (so.getDisplayTypeCd() == null || "".equals(so.getDisplayTypeCd())) so.setDisplayTypeCd("01");
        if (so.getSortType() == null || "".equals(so.getSortType())) so.setSortType("02");
        if (so.getSearchType() == null || "".equals(so.getSearchType())) so.setSearchType("1");
        String mobileValue = request.getParameter("mobileValue");
        String query = request.getParameter("totalSearchText");

        so.setSearchWord(request.getParameter("totalSearchText"));
        eso.setSearchWords(request.getParameter("totalSearchText"));

        //상품
        String goodsDisplay[] = { "Y" }; // 전시여부
        so.setGoodsDisplay(goodsDisplay);
        so.setSaleYn("Y");


        if (mobileValue == null) {
        	so.setRows(5);
        } else if (mobileValue.equals("mobileValue")) {
        	so.setRows(12);
        }
        HashMap<String, Object> productMap = this.productProc(so, bindingResult, request);
        ResultListModel<GoodsVO> productList = (ResultListModel<GoodsVO>)productMap.get("productList");
        mav.addObject("productList", productList);
        mav.addObject("so", so);

        //프로모션
        if (mobileValue == null) {
        	eso.setRows(3);
        } else if (mobileValue.equals("mobileValue")) {
        	eso.setRows(3);
        }
        HashMap<String, Object> promotionMap = this.promotionProc(eso, so, bindingResult, request);
        ResultListModel<ExhibitionVO> promotionList = (ResultListModel<ExhibitionVO>)promotionMap.get("promotionList");

        mav.addObject("promotionList", promotionList);
        mav.addObject("eso", eso);

        //D.매거진 검색
        if (mobileValue == null) {
        	so.setRows(3);
        } else if (mobileValue.equals("mobileValue")) {
        	so.setRows(3);
        }
        HashMap<String, Object> magazineMap = this.magazineProc(so, bindingResult, request);
        ResultListModel<GoodsVO> magazineList = (ResultListModel<GoodsVO>)magazineMap.get("magazineList");
        mav.addObject("magazineList", magazineList);

        //QNA 검색
        if (mobileValue == null) {
        	so.setRows(3);
        } else if (mobileValue.equals("mobileValue")) {
        	so.setRows(2);
        }
        HashMap<String, Object> qnaMap = this.qnaProc(so, bindingResult, request);
        ResultListModel<MultiVO> qnaList = (ResultListModel<MultiVO>)qnaMap.get("qnaList");
        mav.addObject("qnaList", qnaList);

        //VIDEO 검색
        if (mobileValue == null) {
        	so.setRows(5);
        } else if (mobileValue.equals("mobileValue")) {
        	so.setRows(3);
        }
        HashMap<String, Object> videoMap = this.videoProc(so, bindingResult, request);
        ResultListModel<MultiVO> videoList = (ResultListModel<MultiVO>)videoMap.get("videoList");
        mav.addObject("videoList", videoList);

        //NEWS 검색
        if (mobileValue == null) {
        	so.setRows(2);
        } else if (mobileValue.equals("mobileValue")) {
        	so.setRows(2);
        }
        HashMap<String, Object> newsMap = this.newsProc(so, bindingResult, request);
        ResultListModel<MultiVO> newsList = (ResultListModel<MultiVO>)newsMap.get("newsList");
        mav.addObject("newsList", newsList);

        //VCS 검색
        if (mobileValue == null) {
        	so.setRows(5);
        } else if (mobileValue.equals("mobileValue")) {
        	so.setRows(5);
        }
        HashMap<String, Object> vcsMap = this.vcsProc(so, bindingResult, request);
        ResultListModel<MultiVO> vcsList = (ResultListModel<MultiVO>)vcsMap.get("vcsList");
        mav.addObject("vcsList", vcsList);

        //dictionary 검색
        if (mobileValue == null) {
        	so.setRows(2);
        } else if (mobileValue.equals("mobileValue")) {
        	so.setRows(2);
        }
        HashMap<String, Object> dictionaryMap = this.dictionaryProc(so, bindingResult, request);
        ResultListModel<MultiVO> dictionaryList = (ResultListModel<MultiVO>)dictionaryMap.get("dictionaryList");
        mav.addObject("dictionaryList", dictionaryList);

        //연관상품 검색
        if (mobileValue == null) {
        	so.setRows(5);
        } else if (mobileValue.equals("mobileValue")) {
        	so.setRows(6);
        }
        HashMap<String, Object> withitemMap = this.withitemProc(so, bindingResult, request);
        ResultListModel<GoodsVO> withitemList = (ResultListModel<GoodsVO>)withitemMap.get("withitemList");
        mav.addObject("withitemList", withitemList);
        mav.addObject("query", query);

        // 배너 조회
        DmallSessionDetails sessionInfo = SessionDetailHelper.getDetails();
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
        bs.setRows(1);
        ResultListModel<BannerVO> bannerVo = new ResultListModel<>();

        if(SiteUtil.isMobile()) {
	        bs.setBannerMenuCd("MO");
	        bs.setBannerAreaCd("MSB");
        }else{
	        bs.setBannerMenuCd("CM");
	        bs.setBannerAreaCd("SB");
        }

        bannerVo = bannerManageService.selectBannerListPaging(bs);
        mav.addObject("search_banner", bannerVo);
    	return mav;
    }

    //상품
    @RequestMapping(value = "/inc/inc_product")
    public ModelAndView incProduct(@Validated GoodsSO so, BindingResult bindingResult, HttpServletRequest request) throws Exception {
        ModelAndView mav = SiteUtil.getSkinView("/totalsearch/inc/inc_product");
        String mobileValue = request.getParameter("mobileValue");

        if (so.getDisplayTypeCd() == null || "".equals(so.getDisplayTypeCd())) so.setDisplayTypeCd("01");
        if (so.getSortType() == null || "".equals(so.getSortType())) so.setSortType("02");
        if (so.getSearchType() == null || "".equals(so.getSearchType())) so.setSearchType("1");

        String goodsDisplay[] = { "Y" }; // 전시여부
        so.setGoodsDisplay(goodsDisplay);
        so.setSaleYn("Y");

        so.setSearchWord(request.getParameter("totalSearchText"));

       /* if(StringUtils.defaultString(request.getParameter("searchWord")).equals("")) {
            so.setSearchWord(request.getParameter("totalSearchText"));
        }else {
        	so.setSearchWord(request.getParameter("searchWord"));
        } */

        //페이징
        if (request.getParameter("targetPage") != "") {
            so.setPage(Integer.parseInt(request.getParameter("targetPage")));
        } else {
        	so.setPage(1);
        }

        if (mobileValue == null) {
        	so.setRows(20);
        } else if (mobileValue.equals("mobileValue")) {
        	so.setRows(20);
        }

        HashMap<String, Object> productMap = this.productProc(so, bindingResult, request);

        ResultListModel<GoodsVO> productList = (ResultListModel<GoodsVO>)productMap.get("productList");

        mav.addObject("resultListModel", productList);
        request.setAttribute("moreYn", request.getParameter("moreYn"));
        mav.addObject("so", so);

        return mav;
    }


    //프로모션
    @RequestMapping(value = "/inc/inc_promotion")
    public ModelAndView incpromotionListAjax(@Validated GoodsSO so, @Validated ExhibitionSO eso, BindingResult bindingResult, HttpServletRequest request) throws Exception {
    	ModelAndView mav = SiteUtil.getSkinView("/totalsearch/inc/inc_promotion");
    	String mobileValue = request.getParameter("mobileValue");

    	so.setSearchWord(request.getParameter("totalSearchText"));

        if (request.getParameter("targetPage") != "") {
            eso.setPage(Integer.parseInt(request.getParameter("targetPage")));
        } else {
        	eso.setPage(1);
        }

        if (mobileValue == null) {
        	eso.setRows(3);
        } else if (mobileValue.equals("mobileValue")) {
        	eso.setRows(3);
        }

        HashMap<String, Object> promotionMap = this.promotionProc(eso, so, bindingResult, request);
        ResultListModel<ExhibitionVO> promotionList = (ResultListModel<ExhibitionVO>)promotionMap.get("promotionList");

        mav.addObject("resultListModel", promotionList);
        mav.addObject("eso", eso);
        request.setAttribute("moreYn", request.getParameter("moreYn"));
        mav.addObject("so", so);
    	return mav;
    }

    //매거진
    @RequestMapping(value = "/inc/inc_magazine")
    public ModelAndView magazine(@Validated GoodsSO so, BindingResult bindingResult, HttpServletRequest request) throws Exception {
        ModelAndView mav = SiteUtil.getSkinView("/totalsearch/inc/inc_magazine");
        String mobileValue = request.getParameter("mobileValue");

        so.setSearchWord(request.getParameter("totalSearchText"));

        if (request.getParameter("targetPage") != "") {
            so.setPage(Integer.parseInt(request.getParameter("targetPage")));
        } else {
        	so.setPage(1);
        }

        if (mobileValue == null) {
        	so.setRows(3);
        } else if (mobileValue.equals("mobileValue")) {
        	so.setRows(3);
        }

        HashMap<String, Object> magazineMap = this.magazineProc(so, bindingResult, request);
        ResultListModel<GoodsVO> magazineList = (ResultListModel<GoodsVO>)magazineMap.get("magazineList");

        mav.addObject("resultListModel", magazineList);
        request.setAttribute("moreYn", request.getParameter("moreYn"));
        mav.addObject("so", so);

        return mav;
    }

    //QNA
    @RequestMapping(value = "/inc/inc_qna")
    public ModelAndView qna(@Validated GoodsSO so, BindingResult bindingResult, HttpServletRequest request) throws Exception {
    	ModelAndView mav = SiteUtil.getSkinView("/totalsearch/inc/inc_qna");
    	String mobileValue = request.getParameter("mobileValue");
    	so.setSearchWord(request.getParameter("totalSearchText"));

    	if (request.getParameter("targetPage") != "") {
            so.setPage(Integer.parseInt(request.getParameter("targetPage")));
        } else {
        	so.setPage(1);
        }

    	if (mobileValue == null) {
        	so.setRows(3);
        } else if (mobileValue.equals("mobileValue")) {
        	so.setRows(2);
        }

    	HashMap<String, Object> qnaMap = this.qnaProc(so, bindingResult, request);
        ResultListModel<MultiVO> qnaList = (ResultListModel<MultiVO>)qnaMap.get("qnaList");

        mav.addObject("resultListModel", qnaList);
        request.setAttribute("moreYn", request.getParameter("moreYn"));
        mav.addObject("so", so);

    	return mav;
    }

    //동영상
    @RequestMapping(value = "/inc/inc_video")
    public ModelAndView video(@Validated GoodsSO so, BindingResult bindingResult, HttpServletRequest request) throws Exception {
    	ModelAndView mav = SiteUtil.getSkinView("/totalsearch/inc/inc_video");
    	String mobileValue = request.getParameter("mobileValue");
    	so.setSearchWord(request.getParameter("totalSearchText"));

    	if (request.getParameter("targetPage") != "") {
            so.setPage(Integer.parseInt(request.getParameter("targetPage")));
        } else {
        	so.setPage(1);
        }

    	if (mobileValue == null) {
        	so.setRows(25);
        } else if (mobileValue.equals("mobileValue")) {
        	so.setRows(3);
        }

    	//VIDEO 검색
        HashMap<String, Object> videoMap = this.videoProc(so, bindingResult, request);
        ResultListModel<MultiVO> videoList = (ResultListModel<MultiVO>)videoMap.get("videoList");

        mav.addObject("resultListModel", videoList);
        request.setAttribute("moreYn", request.getParameter("moreYn"));
        mav.addObject("so", so);

    	return mav;
    }

    //뉴스
    @RequestMapping(value = "/inc/inc_news")
    public ModelAndView news(@Validated GoodsSO so, BindingResult bindingResult, HttpServletRequest request) throws Exception {
    	ModelAndView mav = SiteUtil.getSkinView("/totalsearch/inc/inc_news");
    	String mobileValue = request.getParameter("mobileValue");
    	so.setSearchWord(request.getParameter("totalSearchText"));

    	if (request.getParameter("targetPage") != "") {
            so.setPage(Integer.parseInt(request.getParameter("targetPage")));
        } else {
        	so.setPage(1);
        }

    	if (mobileValue == null) {
        	so.setRows(10);
        } else if (mobileValue.equals("mobileValue")) {
        	so.setRows(2);
        }

    	//NEWS 검색
        HashMap<String, Object> newsMap = this.newsProc(so, bindingResult, request);
        ResultListModel<MultiVO> newsList = (ResultListModel<MultiVO>)newsMap.get("newsList");

        mav.addObject("resultListModel", newsList);
        request.setAttribute("moreYn", request.getParameter("moreYn"));
        mav.addObject("so", so);

    	return mav;
    }

    //관련검사
    @RequestMapping(value = "/inc/inc_vcs")
    public ModelAndView vcs(@Validated GoodsSO so, BindingResult bindingResult, HttpServletRequest request) throws Exception {
    	ModelAndView mav = SiteUtil.getSkinView("/totalsearch/inc/inc_vcs");
    	String mobileValue = request.getParameter("mobileValue");
    	so.setSearchWord(request.getParameter("totalSearchText"));

    	if (request.getParameter("targetPage") != "") {
            so.setPage(Integer.parseInt(request.getParameter("targetPage")));
        } else {
        	so.setPage(1);
        }

        if (mobileValue == null) {
        	so.setRows(6);
        } else if (mobileValue.equals("mobileValue")) {
        	so.setRows(5);
        }

    	//vcs 검색
    	HashMap<String, Object> vcsMap = this.vcsProc(so, bindingResult, request);
        ResultListModel<MultiVO> vcsList = (ResultListModel<MultiVO>)vcsMap.get("vcsList");

        mav.addObject("resultListModel", vcsList);
        request.setAttribute("moreYn", request.getParameter("moreYn"));
        mav.addObject("so", so);

    	return mav;
    }

    //상품지식
    @RequestMapping(value = "/inc/inc_dictionary")
    public ModelAndView dictionary(@Validated GoodsSO so, BindingResult bindingResult, HttpServletRequest request) throws Exception {
    	ModelAndView mav = SiteUtil.getSkinView("/totalsearch/inc/inc_dictionary");
    	String mobileValue = request.getParameter("mobileValue");
    	so.setSearchWord(request.getParameter("totalSearchText"));

    	if (request.getParameter("targetPage") != "") {
            so.setPage(Integer.parseInt(request.getParameter("targetPage")));
        } else {
        	so.setPage(1);
        }

    	 if (mobileValue == null) {
         	so.setRows(2);
         } else if (mobileValue.equals("mobileValue")) {
         	so.setRows(2);
         }

    	//dictionary 검색
        HashMap<String, Object> dictionaryMap = this.dictionaryProc(so, bindingResult, request);
        ResultListModel<MultiVO> dictionaryList = (ResultListModel<MultiVO>)dictionaryMap.get("dictionaryList");

        mav.addObject("dictionaryList", dictionaryList);
        request.setAttribute("moreYn", request.getParameter("moreYn"));
        mav.addObject("so", so);
    	return mav;
    }

    //연관상품
    @RequestMapping(value = "/inc/inc_withitem")
    public ModelAndView incWithitem(@Validated GoodsSO so, BindingResult bindingResult, HttpServletRequest request) throws Exception {
        ModelAndView mav = SiteUtil.getSkinView("/totalsearch/inc/inc_withitem");
        String mobileValue = request.getParameter("mobileValue");
        if (so.getDisplayTypeCd() == null || "".equals(so.getDisplayTypeCd())) so.setDisplayTypeCd("01");
        if (so.getSortType() == null || "".equals(so.getSortType())) so.setSortType("02");
        if (so.getSearchType() == null || "".equals(so.getSearchType())) so.setSearchType("1");

        String goodsDisplay[] = { "Y" }; // 전시여부
        so.setGoodsDisplay(goodsDisplay);
        so.setSaleYn("Y");
        so.setSearchWord(request.getParameter("totalSearchText"));

        //페이징
        if (request.getParameter("targetPage") != "") {
            so.setPage(Integer.parseInt(request.getParameter("targetPage")));
        } else {
        	so.setPage(1);
        }

        if (mobileValue == null) {
        	so.setRows(20);
        } else if (mobileValue.equals("mobileValue")) {
        	so.setRows(20);
        }

        HashMap<String, Object> withitemMap = this.withitemProc(so, bindingResult, request);
        ResultListModel<GoodsVO> withitemList = (ResultListModel<GoodsVO>)withitemMap.get("withitemList");

        mav.addObject("resultListModel", withitemList);
        request.setAttribute("moreYn", request.getParameter("moreYn"));
        mav.addObject("so", so);

        return mav;
    }

    //상품
    private HashMap<String, Object> productProc(@Validated GoodsSO so, BindingResult bindingResult, HttpServletRequest request) throws Exception{
    	HashMap<String, Object> goodsMap = new HashMap<String, Object>();
    	//String query = so.getSearchWord();
    	String query = "";
        //검색옵션 검색어가 있을경우
		if (!StringUtils.defaultString(request.getParameter("searchDetailWord")).equals("")) {
			String searchType = request.getParameter("searchType");
			switch (searchType) {
			case "1":
				query = "GOODS_NM_idx like '*" + request.getParameter("searchDetailWord") + "*'";
				break;
			case "2":
				query = "BRAND_NM_idx like '*" + request.getParameter("searchDetailWord") + "*'";
				break;
			case "3":
				query = "MODEL_NM_idx like '*" + request.getParameter("searchDetailWord") + "*'";
				break;
			case "4":
				query = "MMFT_idx like '*" + request.getParameter("searchDetailWord") + "*'";
				break;
			}
			if (!StringUtils.defaultString(request.getParameter("searchCtg1")).equals("")) {
				String searchCtg1Code = String.format("%04d", Integer.parseInt(request.getParameter("searchCtg1")));
				query += " and CTG_NO1_idx like '*" + searchCtg1Code + "*'";
			}
			if (!StringUtils.defaultString(request.getParameter("searchCtg2")).equals("")) {
				String searchCtg2Code = String.format("%04d", Integer.parseInt(request.getParameter("searchCtg2")));
				query += " and CTG_NO2_idx like '*" + searchCtg2Code + "*'";
			}
			if (!StringUtils.defaultString(request.getParameter("searchCtg3")).equals("")) {
				String searchCtg3Code = String.format("%04d", Integer.parseInt(request.getParameter("searchCtg3")));
				query += " and CTG_NO3_idx like '*" + searchCtg3Code + "*'";
			}
			if (!StringUtils.defaultString(request.getParameter("searchPriceFrom")).equals("") && !StringUtils.defaultString(request.getParameter("searchPriceTo")).equals("")) {
				int priceFrom = Integer.parseInt(request.getParameter("searchPriceFrom"));
				int priceTo = Integer.parseInt(request.getParameter("searchPriceTo"));
				query += " and SALE_PRICE_idx >=" + priceFrom + " and SALE_PRICE_idx <=" + priceTo;
			}

		} else if(!StringUtils.defaultString(request.getParameter("searchCtg1")).equals("")) {
			String searchCtg1Code = String.format("%04d", Integer.parseInt(request.getParameter("searchCtg1")));
			query += "CTG_NO1_idx like '*" + searchCtg1Code + "*'";

			if (!StringUtils.defaultString(request.getParameter("searchCtg2")).equals("")) {
				String searchCtg2Code = String.format("%04d", Integer.parseInt(request.getParameter("searchCtg2")));
				query += " and CTG_NO2_idx like '*" + searchCtg2Code + "*'";
			}
			if (!StringUtils.defaultString(request.getParameter("searchCtg3")).equals("")) {
				String searchCtg3Code = String.format("%04d", Integer.parseInt(request.getParameter("searchCtg3")));
				query += " and CTG_NO3_idx like '*" + searchCtg3Code + "*'";
			}
		} else {

			query = "SEO_SEARCH_WORD_idx = '" + so.getSearchWord() +"' anyword or GOODS_NM_idx = '" + so.getSearchWord() +"' allword or "
					+ "BRAND_NM_idx = '" + so.getSearchWord() +"' anyword or ITEM_NM_idx = '" + so.getSearchWord() +"' anyword or "
					+ "GOODS_NO_idx = '" + so.getSearchWord() +"' or ITEM_NO_idx = '" + so.getSearchWord() +"' or BRAND_NO_idx = '" + so.getSearchWord() +"'";
		}
		  query = "(" + query + ") and DISP_YN_idx = 'Y' order by $MATCHFIELD(GOODS_NM,SEO_SEARCH_WORD) DESC , $relevance desc    ,  SALE_AMT  DESC ,  ORD_QTT  DESC ,  UPD_DTTM  DESC";
		//query = "(" + query + ") and DISP_YN_idx = 'Y' order by $MATCHFIELD(GOODS_NM,SEO_SEARCH_WORD) DESC ,  SALE_AMT  DESC ,  ORD_QTT  DESC ,  UPD_DTTM  DESC";

        //상품 검색
    	QueryBuilder qb = new QueryBuilder();
    	qb.where(query);

		CrzClient crzclient = Config.getCrzClient();
		SearchQuery sq = new SearchQuery("V_SEARCH_PRODUCT", query);

		sq.setWhereClause(qb.getWhereClause());

		//로그
		sq.setLog("DAVICH@PRODUCT+$|첫검색|0|정확도순^"+so.getSearchWord()+"##");

		String pageSize = "";

		if (request.getParameter("mobileValue") == null)
		{
			if (so.getRows() == 5) {
				pageSize = "PAGESIZE_PRODUCT_TOTAL";

			} else {
				pageSize = "PAGESIZE_PRODUCT";

			}
		}
		else if (request.getParameter("mobileValue").equals("mobileValue")) {
			if (so.getRows() == 6) {
				pageSize = "PAGESIZE_PRODUCT_MOBILE_TOTAL";


			} else {
				pageSize = "PAGESIZE_PRODUCT_MOBILE";

			}
		}


		int limit = Config.getPropertyInt(pageSize, so.getRows());
		sq.setLimit(limit);

		//페이징
		if (request.getParameter("mobileValue") == null)
		{
			if(limit == 5) {

				sq.setOffset((so.getPage() * sq.getLimit()) - 5);

			}else {

				sq.setOffset((so.getPage() * sq.getLimit()) - 20);

			}
		}
		else if (request.getParameter("mobileValue").equals("mobileValue")) {
			if(limit == 6) {

				sq.setOffset((so.getPage() * sq.getLimit()) - 6);

			}else {

				sq.setOffset((so.getPage() * sq.getLimit()) - 20);

			}
		}

		SearchResultSet srs = crzclient.search(sq);


		// totalCount = 통합검색 상단에 출력되는 전체결과수
		// realCount = 검색결과 화면 목록 출력 수
		int realCount = 0;
		realCount = srs.getRowCount();

		List<GoodsVO> konanGoodsList = new ArrayList<GoodsVO>();
		GoodsVO konanGoods = new GoodsVO();
		for (int i = 0; i < realCount; i++) {
			Map<String, Object> tempGoodsMap = new HashMap<String, Object>();
			tempGoodsMap = srs.getRows().get(i);

			konanGoods = new GoodsVO();
			konanGoods.setGoodsNo((String)tempGoodsMap.get("GOODS_NO"));
			konanGoods.setGoodsTypeCd((String)tempGoodsMap.get("GOODS_TYPE_CD"));
			konanGoods.setSellerNo((String)tempGoodsMap.get("SELLER_NO"));
			konanGoods.setSellerNm((String)tempGoodsMap.get("SELLER_NM"));
			konanGoods.setGoodsNm((String)tempGoodsMap.get("GOODS_NM"));
			konanGoods.setItemNo((String)tempGoodsMap.get("ITEM_NO"));
			konanGoods.setGoodsSaleStatusCd((String)tempGoodsMap.get("GOODS_SALE_STATUS_CD"));
			konanGoods.setGoodsSaleStatusNm((String)tempGoodsMap.get("GOODS_SALE_STATUS_NM"));
			konanGoods.setDispYn((String)tempGoodsMap.get("DISP_YN"));
			konanGoods.setGoodseachDlvrc(Long.parseLong((String)tempGoodsMap.get("GOODSEACH_DLVRC")));
			konanGoods.setRsvOnlyYn((String)tempGoodsMap.get("RSV_ONLY_YN"));
			konanGoods.setGoodsDispImgA((String)tempGoodsMap.get("GOODS_DISP_IMG_A"));
			konanGoods.setGoodsDispImgB((String)tempGoodsMap.get("GOODS_DISP_IMG_B"));
			konanGoods.setGoodsDispImgC((String)tempGoodsMap.get("GOODS_DISP_IMG_C"));
			konanGoods.setGoodsDispImgD((String)tempGoodsMap.get("GOODS_DISP_IMG_D"));
			konanGoods.setGoodsDispImgE((String)tempGoodsMap.get("GOODS_DISP_IMG_E"));
			konanGoods.setIconImgs((String)tempGoodsMap.get("ICON_IMGS"));
			konanGoods.setAccmGoodslettCnt((String)tempGoodsMap.get("ACCM_SALE_CNT"));
			konanGoods.setGoodsSvmnPolicyUseYn((String)tempGoodsMap.get("GOODS_SVMN_POLICY_USE_YN"));
			konanGoods.setGoodsSvmnAmt((String)tempGoodsMap.get("GOODS_SVMN_AMT"));
			konanGoods.setGoodsScore((String)tempGoodsMap.get("GOODS_SCORE"));
			konanGoods.setBrandNo((String)tempGoodsMap.get("BRAND_NO"));
			konanGoods.setBrandNm((String)tempGoodsMap.get("BRAND_NM"));
			konanGoods.setItemNm((String)tempGoodsMap.get("ITEM_NM"));
			konanGoods.setCustomerPrice(Long.parseLong((String)tempGoodsMap.get("CUSTOMER_PRICE")));
			konanGoods.setSalePrice(Long.parseLong((String)tempGoodsMap.get("SALE_PRICE")));
			konanGoods.setSaleRate((String)tempGoodsMap.get("SALE_RATE"));
			konanGoods.setSupplyPrice(Long.parseLong((String)tempGoodsMap.get("SUPPLY_PRICE")));
			konanGoods.setPrmtDcValue(Long.parseLong((String)tempGoodsMap.get("PRMT_DC_VALUE")));
			konanGoods.setPrmtDcGbCd((String)tempGoodsMap.get("PRMT_DC_GB_CD"));
			konanGoods.setAdultCertifyYn((String)tempGoodsMap.get("ADULT_CERTIFY_YN"));
			// Konan 윤재형 컬럼추가 2020-08-25 BEGIN
			konanGoods.setCouponApplyAmt((String)tempGoodsMap.get("COUPON_APPLY_AMT"));
			konanGoods.setCouponBnfCd((String)tempGoodsMap.get("COUPON_BNF_CD"));
			konanGoods.setCouponBnfTxt((String)tempGoodsMap.get("COUPON_BNF_TXT"));
			konanGoods.setCouponDcRate((String)tempGoodsMap.get("COUPON_DC_RATE"));
			// Konan 윤재형 컬럼추가 2020-08-25 END
			konanGoodsList.add(konanGoods);
		}

        // 현재 페이지 번호 초기화
        if (so.getPage() == 0) {
            so.setPage(1);
        }
        ResultListModel<GoodsVO> goodsList = new ResultListModel<>();
        // 전체 카운트 조회
        int totalRows = srs.getTotalCount();

        if (totalRows < 1) {
            goodsList.setTotalRows(0);
            goodsList.setFilterdRows(0);
            goodsList.setPage(so.getPage());
            goodsList.setRows(so.getRows());
            goodsMap.put("productList", goodsList);
            return goodsMap;
        }
        // 검색결과 카운트 조회
        int filterdRows = realCount;
        if (filterdRows < 1) {
        	goodsList.setTotalRows(totalRows);
        	goodsList.setFilterdRows(0);
        	goodsList.setPage(so.getPage());
        	goodsList.setRows(so.getRows());
        	goodsMap.put("productList", goodsList);
            return goodsMap;
        }

        so.setTotalCount(totalRows);

        so.setLimit((so.getPage() - 1) * so.getRows());
        so.setOffset(so.getRows());

        so.setStartIndex(((so.getPage() - 1) * so.getRows()) + 1);
        so.setEndIndex(((so.getPage() - 1) * so.getRows()) + so.getRows());

        if (StringUtil.isNotBlank(so.getSidx())) {
            so.setSidx(StringUtil.toUnCamelCase(so.getSidx()).toUpperCase());
        }

        if (filterdRows > 0 && filterdRows % so.getRows() == 0) {
        	goodsList.setTotalPages(filterdRows / so.getRows());

        } else {
        	goodsList.setTotalPages(filterdRows / so.getRows() + 1);


        }
        goodsList.setTotalRows(totalRows);
        goodsList.setFilterdRows(filterdRows);
        goodsList.setPage(so.getPage());
        goodsList.setRows(so.getRows());
        goodsList.setResultList(konanGoodsList);

        //페이징 _
        double totalCount = srs.getTotalCount() / 20.0;
		int totalPage = (int) Math.ceil(totalCount);

		goodsList.setTotalPages(totalPage-1);
    	goodsMap.put("productList", goodsList);
    	return goodsMap;
    }

    //프로모션
    private HashMap<String, Object> promotionProc(@Validated ExhibitionSO eso, @Validated GoodsSO so, BindingResult bindingResult, HttpServletRequest request) throws Exception{
		HashMap<String, Object> promotionMap = new HashMap<String, Object>();
    	String query = so.getSearchWord();

        //프로모션 검색
    	QueryBuilder gqb = new QueryBuilder();
		//gqb.where("(PRMT_NM_idx = '*{0}*' anyword AND PRMT_STATUS_NM_idx = '진행중') order by $MATCHFIELD(PRMT_NM ,PRMT_DSCRT) DESC ", query);
		  gqb.where("(PRMT_NM_idx = '{0}' anyword or SEO_SEARCH_WORD =  '{0}'  anyword  or  PRMT_DSCRT  like '*{0}*' )   AND PRMT_STATUS_NM_idx = '진행중'  order by $MATCHFIELD(PRMT_NM ,SEO_SEARCH_WORD,PRMT_DSCRT) DESC , $relevance desc ", query);

    	CrzClient crzclient = Config.getCrzClient();
		SearchQuery sq = new SearchQuery("V_SEARCH_PROMOTION", query);

		sq.setWhereClause(gqb.getWhereClause());

		//로그
		sq.setLog("DAVICH@PROMOTION+$|첫검색|0|정확도순^"+so.getSearchWord()+"##");

		String pageSize = "";

		if (request.getParameter("mobileValue") == null)
		{
			if (eso.getRows() == 3) {
				pageSize = "PAGESIZE_PROMOTION";
			} else {
				pageSize = "PAGESIZE_PROMOTION_TOTAL";
			}
		}
		else if (request.getParameter("mobileValue").equals("mobileValue")) {
			if (eso.getRows() == 3) {
				pageSize = "PAGESIZE_PROMOTION_MOBILE_TOTAL";
			} else {
				pageSize = "PAGESIZE_PROMOTION_MOBILE";
			}
		}

		int limit = Config.getPropertyInt(pageSize, eso.getRows());
		sq.setLimit(limit);

		//페이징
		if (request.getParameter("mobileValue") == null)
		{
			if(limit == 3) {
				sq.setOffset((eso.getPage() * sq.getLimit()) - 3);
			}else {
				sq.setOffset((eso.getPage() * sq.getLimit()) - 3);
			}
		}
		else if (request.getParameter("mobileValue").equals("mobileValue")) {
			if(limit == 3) {
				sq.setOffset((eso.getPage() * sq.getLimit()) - 3);
			}else {
				sq.setOffset((eso.getPage() * sq.getLimit()) - 3);
			}
		}
		SearchResultSet gsrs = crzclient.search(sq);

		int realCount = 0;
		realCount = gsrs.getRowCount();

		List<ExhibitionVO> konanPromotionList = new ArrayList<ExhibitionVO>();
		ExhibitionVO konanPromotion = new ExhibitionVO();

		for (int i = 0; i < realCount; i++) {
			Map<String, Object> tempPromotionMap = new HashMap<String, Object>();
			tempPromotionMap = gsrs.getRows().get(i);
			konanPromotion = new ExhibitionVO();

			//프로모션 31글자 이상 초과시 문자열 자르기
			String prmt_Nm = ((String)tempPromotionMap.get("PRMT_NM"));
			if (prmt_Nm.length() > 31) {
			String prmtNm = prmt_Nm.substring(0, 31).concat(" ...");
			konanPromotion.setPrmtNm(prmtNm);
			} else {
				konanPromotion.setPrmtNm(prmt_Nm);
			}
			konanPromotion.setPrmtNo(Integer.parseInt((String)tempPromotionMap.get("PRMT_NO")));
			konanPromotion.setApplyStartDttm((String)tempPromotionMap.get("APPLY_START_DTTM"));
			konanPromotion.setApplyEndDttm((String)tempPromotionMap.get("APPLY_END_DTTM"));
			konanPromotion.setPrmtWebBannerImgPath((String)tempPromotionMap.get("PRMT_WEB_BANNER_IMG_PATH"));
			konanPromotion.setPrmtWebBannerImg((String)tempPromotionMap.get("PRMT_WEB_BANNER_IMG"));
			konanPromotion.setPrmtMobileBannerImgPath((String)tempPromotionMap.get("PRMT_MOBILE_BANNER_IMG_PATH"));
			konanPromotion.setPrmtMobileBannerImg((String)tempPromotionMap.get("PRMT_MOBILE_BANNER_IMG"));
			konanPromotion.setPrmtStatusNm((String)tempPromotionMap.get("PRMT_STATUS_NM"));
			String regDttm = (String)tempPromotionMap.get("REG_DTTM");
			konanPromotion.setRegDate(regDttm.substring(0,10).replace("-", "."));
			konanPromotion.setPrmtDcGbCd((String)tempPromotionMap.get("PRMT_DC_GB_CD"));
			konanPromotion.setPrmtDcValue(Integer.parseInt((String)tempPromotionMap.get("PRMT_DC_VALUE")));
			konanPromotion.setSiteNo(Long.parseLong((String)tempPromotionMap.get("SITE_NO")));
			konanPromotion.setUseYn((String)tempPromotionMap.get("USE_YN"));
			konanPromotion.setPrmtDscrt((String)tempPromotionMap.get("PRMT_DSCRT"));
			konanPromotion.setPrmtMainExpsUseYn((String)tempPromotionMap.get("PRMT_MAIN_EXPS_USE_YN"));
			konanPromotion.setPrmtMainExpsPst((String)tempPromotionMap.get("PRMT_MAIN_EXPS_PST"));
			konanPromotion.setDetailLink((String)tempPromotionMap.get("DETAIL_LINK"));
			konanPromotion.setSeoSearchWord((String)tempPromotionMap.get("SEO_SEARCH_WORD"));

			konanPromotionList.add(konanPromotion);
		}

		// 현재 페이지 번호 초기화
        if (eso.getPage() == 0) {
            eso.setPage(1);
        }
        ResultListModel<ExhibitionVO> promotionList = new ResultListModel<>();
        // 전체 카운트 조회
        int totalRows = gsrs.getTotalCount();

        if (totalRows < 1) {

        	promotionList.setTotalRows(0);
        	promotionList.setFilterdRows(0);
        	promotionList.setPage(eso.getPage());
            promotionList.setRows(eso.getRows());
            promotionMap.put("promotionList", promotionList);
            return promotionMap;
        }

        // 검색결과 카운트 조회
        int filterdRows = realCount;
        if (filterdRows < 1) {
        	promotionList.setTotalRows(totalRows);
        	promotionList.setFilterdRows(0);
        	promotionList.setPage(eso.getPage());
        	promotionList.setRows(eso.getRows());
        	promotionMap.put("promotionList", promotionList);
            return promotionMap;
        }

        eso.setTotalCount(totalRows);

        eso.setLimit((eso.getPage() - 1) * eso.getRows());
        eso.setOffset(eso.getRows());

        eso.setStartIndex(((eso.getPage() - 1) * eso.getRows()) + 1);
        eso.setEndIndex(((eso.getPage() - 1) * eso.getRows()) + eso.getRows());

        if (StringUtil.isNotBlank(eso.getSidx())) {
            eso.setSidx(StringUtil.toUnCamelCase(eso.getSidx()).toUpperCase());
        }

        if (filterdRows > 0 && filterdRows % eso.getRows() == 0) {
        	promotionList.setTotalPages(filterdRows / eso.getRows());
        } else {
        	promotionList.setTotalPages(filterdRows / eso.getRows() + 1);
        }
        promotionList.setTotalRows(totalRows);
        promotionList.setFilterdRows(filterdRows);
        promotionList.setPage(eso.getPage());
        promotionList.setRows(eso.getRows());
        promotionList.setResultList(konanPromotionList);
        //페이징
        double totalCount = gsrs.getTotalCount() / 3.0;
		int totalPage = (int) Math.ceil(totalCount);
		promotionList.setTotalPages(totalPage);

    	promotionMap.put("promotionList", promotionList);
    	return promotionMap;
    }

    //매거진
    private HashMap<String, Object> magazineProc(@Validated GoodsSO so, BindingResult bindingResult, HttpServletRequest request) throws Exception{
    	HashMap<String, Object> magazineMap = new HashMap<String, Object>();
    	String query = so.getSearchWord();
        //상품 검색
    	QueryBuilder qb = new QueryBuilder();
		//qb.where("(SEO_SEARCH_WORD_idx = '*{0}*' anyword OR GOODS_NM_idx = '*{0}*' anyword OR PR_WORDS_idx = '*{0}*' anyword OR GOODS_NO_idx like '*{0}*') order by $MATCHFIELD(GOODS_NM,SEO_SEARCH_WORD) DESC , UPD_DTTM  DESC", query);
      qb.where("(SEO_SEARCH_WORD_idx = '{0}' anyword OR GOODS_NM_idx = '{0}' anyword OR PR_WORDS_idx = '{0}' anyword OR GOODS_NO_idx like '*{0}*') order by $MATCHFIELD(GOODS_NM,SEO_SEARCH_WORD) DESC , $relevance desc , UPD_DTTM  DESC", query);

		CrzClient crzclient = Config.getCrzClient();
		SearchQuery sq = new SearchQuery("V_SEARCH_MAGAZINE", query);
		sq.setWhereClause(qb.getWhereClause());

		//로그
		sq.setLog("DAVICH@MAGAZINE+$|첫검색|0|정확도순^"+so.getSearchWord()+"##");

		String pageSize = "";

		if (request.getParameter("mobileValue") == null)
		{
			if (so.getRows() == 3) {
				pageSize = "PAGESIZE_MAGAZINE";
			} else {
				pageSize = "PAGESIZE_MAGAZINE_TOTAL";
			}
		}
		else if (request.getParameter("mobileValue").equals("mobileValue")) {
			if (so.getRows() == 3) {
				pageSize = "PAGESIZE_MAGAZINE_MOBILE_TOTAL";
			} else {
				pageSize = "PAGESIZE_MAGAZINE_MOBILE";
			}
		}

		int limit = Config.getPropertyInt(pageSize, so.getRows());
		sq.setLimit(limit);

		//페이징
		if (request.getParameter("mobileValue") == null)
		{
			if(limit == 3) {
				sq.setOffset((so.getPage() * sq.getLimit()) - 3);
			}else {
				sq.setOffset((so.getPage() * sq.getLimit()) - 3);
			}
		}
		else if (request.getParameter("mobileValue").equals("mobileValue")) {
			if(limit == 3) {
				sq.setOffset((so.getPage() * sq.getLimit()) - 3);
			}else {
				sq.setOffset((so.getPage() * sq.getLimit()) - 3);
			}
		}
		SearchResultSet srs = crzclient.search(sq);

		int realCount = 0;
		realCount = srs.getRowCount();

		List<GoodsVO> konanMagazineList = new ArrayList<GoodsVO>();
		GoodsVO konanMagazine = new GoodsVO();
		for (int i = 0; i < realCount; i++) {
			Map<String, Object> tempGoodsMap = new HashMap<String, Object>();
			tempGoodsMap = srs.getRows().get(i);

			konanMagazine = new GoodsVO();
			konanMagazine.setGoodsNo((String)tempGoodsMap.get("GOODS_NO"));
			konanMagazine.setGoodsNm((String)tempGoodsMap.get("GOODS_NM"));
			konanMagazine.setDispYn((String)tempGoodsMap.get("DISP_YN"));
			konanMagazine.setPrWords((String)tempGoodsMap.get("PR_WORDS"));
			konanMagazine.setGoodsImg01((String)tempGoodsMap.get("GOODS_IMG_01"));
			konanMagazine.setGoodsDispImgA((String)tempGoodsMap.get("GOODS_DISP_IMG_A"));
			konanMagazine.setGoodsDispImgB((String)tempGoodsMap.get("GOODS_DISP_IMG_B"));
			konanMagazine.setGoodsDispImgC((String)tempGoodsMap.get("GOODS_DISP_IMG_C"));
			konanMagazine.setGoodsDispImgD((String)tempGoodsMap.get("GOODS_DISP_IMG_D"));
			konanMagazine.setGoodsDispImgE((String)tempGoodsMap.get("GOODS_DISP_IMG_E"));
			if(StringUtils.defaultString((String)tempGoodsMap.get("GOODS_DISP_IMG_P")).equals("")) {
				konanMagazine.setGoodsDispImgM((String)tempGoodsMap.get("GOODS_DISP_IMG_M"));
			} else {
				konanMagazine.setGoodsDispImgM((String)tempGoodsMap.get("GOODS_DISP_IMG_P"));
			}

			konanMagazine.setGoodsThumImg((String)tempGoodsMap.get("GOODS_THUM_IMG"));
			String regDttm = (String)tempGoodsMap.get("REG_DTTM");
			konanMagazine.setRegDate(regDttm.substring(0,10).replace("-", "."));
			konanMagazine.setDetailLink((String)tempGoodsMap.get("DETAIL_LINK"));

			konanMagazineList.add(konanMagazine);
		}

		// 현재 페이지 번호 초기화
		if (so.getPage() == 0) {
		so.setPage(1);
		}
		ResultListModel<GoodsVO> magazineList = new ResultListModel<>();
		// 전체 카운트 조회
		int totalRows = srs.getTotalCount();

		if (totalRows < 1) {

		magazineList.setTotalRows(0);
		magazineList.setFilterdRows(0);
		magazineList.setPage(so.getPage());
		magazineList.setRows(so.getRows());
		magazineMap.put("magazineList", magazineList);
		return magazineMap;
		}

		// 검색결과 카운트 조회
		int filterdRows = realCount;
		if (filterdRows < 1) {
		magazineList.setTotalRows(totalRows);
		magazineList.setFilterdRows(0);
		magazineList.setPage(so.getPage());
		magazineList.setRows(so.getRows());
		magazineMap.put("magazineList", magazineList);
		return magazineMap;
		}

		so.setTotalCount(totalRows);

		so.setLimit((so.getPage() - 1) * so.getRows());
		so.setOffset(so.getRows());

		so.setStartIndex(((so.getPage() - 1) * so.getRows()) + 1);
		so.setEndIndex(((so.getPage() - 1) * so.getRows()) + so.getRows());

		if (StringUtil.isNotBlank(so.getSidx())) {
		so.setSidx(StringUtil.toUnCamelCase(so.getSidx()).toUpperCase());
		}

		if (filterdRows > 0 && filterdRows % so.getRows() == 0) {
		magazineList.setTotalPages(filterdRows / so.getRows());
		} else {
		magazineList.setTotalPages(filterdRows / so.getRows() + 1);
		}
		magazineList.setTotalRows(totalRows);
		magazineList.setFilterdRows(filterdRows);
		magazineList.setPage(so.getPage());
		magazineList.setRows(so.getRows());
		magazineList.setResultList(konanMagazineList);

		//페이징
        double totalCount = srs.getTotalCount() / 3.0;
		int totalPage = (int) Math.ceil(totalCount);
		magazineList.setTotalPages(totalPage);

		magazineMap.put("magazineList", magazineList);
		return magazineMap;
    }

    //QNA
    private HashMap<String, Object> qnaProc(@Validated GoodsSO so, BindingResult bindingResult, HttpServletRequest request) throws Exception {
    	String query = so.getSearchWord();

        //qna 제목 검색
    	QueryBuilder qb = new QueryBuilder();
    	//qb.where("(TITLE_idx = '*{0}*' anyword OR CONTENT_idx = '*{0}*' anyword) order by $MATCHFIELD(TITLE,CONTENT) DESC , REG_DTTM   DESC", query);
    	qb.where("(TITLE_idx = '{0}' anyword OR CONTENT_idx = '{0}' anyword) order by $MATCHFIELD(TITLE,CONTENT) DESC , $relevance desc , REG_DTTM   DESC", query);

		CrzClient crzclient = Config.getCrzClient();
		SearchQuery sq = new SearchQuery("V_SEARCH_QNA", query);

		sq.setWhereClause(qb.getWhereClause());

		//로그
		sq.setLog("DAVICH@QNA+$|첫검색|0|정확도순^"+so.getSearchWord()+"##");

		String pageSize = "";

		if (request.getParameter("mobileValue") == null)
		{
			if (so.getRows() == 3) {
				pageSize = "PAGESIZE_QNA";
			} else {
				pageSize = "PAGESIZE_QNA_TOTAL";
			}
		}
		else if (request.getParameter("mobileValue").equals("mobileValue")) {
			if (so.getRows() == 2) {
				pageSize = "PAGESIZE_QNA_MOBILE_TOTAL";
			} else {
				pageSize = "PAGESIZE_QNA_MOBILE";
			}
		}

		int limit = Config.getPropertyInt(pageSize, so.getRows());
		sq.setLimit(limit);

		//페이징
		if (request.getParameter("mobileValue") == null)
		{
			if(limit == 3) {
				sq.setOffset((so.getPage() * sq.getLimit()) - 3);
			}else {
				sq.setOffset((so.getPage() * sq.getLimit()) - 3);
			}
		}
		else if (request.getParameter("mobileValue").equals("mobileValue")) {
			if(limit == 2) {
				sq.setOffset((so.getPage() * sq.getLimit()) - 2);
			}else {
				sq.setOffset((so.getPage() * sq.getLimit()) - 2);
			}
		}
		SearchResultSet srs = crzclient.search(sq);

		int realCount = 0;
		realCount = srs.getRowCount();

		List<MultiVO> konanQnaList = new ArrayList<MultiVO>();
		MultiVO konanQna = new MultiVO();
		for (int i = 0; i < realCount; i++) {
			Map<String, Object> tempQnaMap = new HashMap<String, Object>();
			tempQnaMap = srs.getRows().get(i);

			konanQna = new MultiVO();
			konanQna.setBbsId((String)tempQnaMap.get("BBS_ID"));
			konanQna.setLeftNo(Integer.parseInt((String)tempQnaMap.get("LETT_NO")));
			konanQna.setTitle((String)tempQnaMap.get("TITLE"));
			konanQna.setCmntCnt(Integer.parseInt((String)tempQnaMap.get("CMNT_CNT")));
			konanQna.setContent((String)tempQnaMap.get("CONTENT"));
			konanQna.setRegrNo(Long.parseLong((String)tempQnaMap.get("REGR_NO")));
			String regDttm = (String)tempQnaMap.get("REG_DTTM");
			konanQna.setRegDate(regDttm.substring(0,10).replace("-", "."));
			konanQna.setRegrDispCd((String)tempQnaMap.get("REGR_DISP_CD"));
			konanQna.setMemberNm((String)tempQnaMap.get("MEMBER_NM"));
			konanQna.setLoginId((String)tempQnaMap.get("LOGIN_ID"));
			/*konanQna.setTitleNo(Integer.parseInt((String)tempQnaMap.get("TITLE_NO")));*/
			konanQna.setIconCheckValueHot((String)tempQnaMap.get("ICON_CHECK_VALUE_HOT"));
			konanQna.setIconCheckValueNew((String)tempQnaMap.get("ICON_CHECK_VALUE_NEW"));
			konanQna.setNoticeYn((String)tempQnaMap.get("NOTICE_YN"));
			konanQna.setInqCnt(Integer.parseInt((String)tempQnaMap.get("INQ_CNT")));
			konanQna.setTitleNm((String)tempQnaMap.get("TITLE_NM"));
			konanQna.setLvl(Integer.parseInt((String)tempQnaMap.get("LVL")));
			konanQna.setSectYn((String)tempQnaMap.get("SECT_YN"));
			konanQna.setLeftLvl((String)tempQnaMap.get("LETT_LVL"));
			konanQna.setImgFilePath((String)tempQnaMap.get("IMG_FILE_PATH"));
			konanQna.setImgFileNm((String)tempQnaMap.get("IMG_FILE_NM"));
			konanQna.setSellerNo(Integer.parseInt((String)tempQnaMap.get("SELLER_NO")));
			konanQna.setSellerNm((String)tempQnaMap.get("SELLER_NM"));
			konanQna.setDetailLink((String)tempQnaMap.get("DETAIL_LINK"));

			konanQnaList.add(konanQna);
		}
		// 현재 페이지 번호 초기화
        if (so.getPage() == 0) {
            so.setPage(1);
        }
        ResultListModel<MultiVO> qnaList = new ResultListModel<>();
        // 전체 카운트 조회
        int totalRows = srs.getTotalCount();

        HashMap<String, Object> qnaMap = new HashMap<String, Object>();

        if (totalRows < 1) {
        	qnaList.setTotalRows(0);
        	qnaList.setFilterdRows(0);
        	qnaList.setPage(so.getPage());
        	qnaList.setRows(so.getRows());
        	qnaMap.put("qnaList", qnaList);
            return qnaMap;
        }

        // 검색결과 카운트 조회
        int filterdRows = realCount;
        if (filterdRows < 1) {
        	qnaList.setTotalRows(totalRows);
        	qnaList.setFilterdRows(0);
        	qnaList.setPage(so.getPage());
        	qnaList.setRows(so.getRows());
        	qnaMap.put("qnaList", qnaList);
            return qnaMap;
        }

        so.setTotalCount(totalRows);

        so.setLimit((so.getPage() - 1) * so.getRows());
        so.setOffset(so.getRows());

        so.setStartIndex(((so.getPage() - 1) * so.getRows()) + 1);
        so.setEndIndex(((so.getPage() - 1) * so.getRows()) + so.getRows());

        if (StringUtil.isNotBlank(so.getSidx())) {
            so.setSidx(StringUtil.toUnCamelCase(so.getSidx()).toUpperCase());
        }

        if (filterdRows > 0 && filterdRows % so.getRows() == 0) {
        	qnaList.setTotalPages(filterdRows / so.getRows());
        } else {
        	qnaList.setTotalPages(filterdRows / so.getRows() + 1);
        }
        qnaList.setTotalRows(totalRows);
        qnaList.setFilterdRows(filterdRows);
        qnaList.setPage(so.getPage());
        qnaList.setRows(so.getRows());
        qnaList.setResultList(konanQnaList);

        //페이징
		double totalCount = srs.getTotalCount() / 3.0;
		int totalPage = (int) Math.ceil(totalCount);
		qnaList.setTotalPages(totalPage);

	    qnaMap.put("qnaList", qnaList);

    	return qnaMap;
    }

    //뉴스
    private HashMap<String, Object> newsProc(@Validated GoodsSO so, BindingResult bindingResult, HttpServletRequest request) throws Exception {
    	String query = so.getSearchWord();

        //news 제목 검색
    	QueryBuilder qb = new QueryBuilder();
    	 // qb.where("(TITLE_idx = '*{0}*' anyword OR CONTENT_idx = '*{0}*' anyword) order by $MATCHFIELD(TITLE,CONTENT) DESC , REG_DTTM  DESC", query);
    	qb.where("(TITLE_idx = '{0}' anyword OR CONTENT_idx = '{0}' anyword) order by $MATCHFIELD(TITLE,CONTENT) DESC , $relevance desc , REG_DTTM  DESC", query);

		CrzClient crzclient = Config.getCrzClient();
		SearchQuery sq = new SearchQuery("V_SEARCH_NEWS", query);

		sq.setWhereClause(qb.getWhereClause());

		//로그
		sq.setLog("DAVICH@NEWS+$|첫검색|0|정확도순^"+so.getSearchWord()+"##");

		String pageSize = "";

		if (request.getParameter("mobileValue") == null)
		{
			if (so.getRows() == 2) {
				pageSize = "PAGESIZE_NEWS_TOTAL";
			} else {
				pageSize = "PAGESIZE_NEWS";
			}
		}
		else if (request.getParameter("mobileValue").equals("mobileValue")) {
			if (so.getRows() == 2) {
				pageSize = "PAGESIZE_NEWS_MOBILE_TOTAL";
			} else {
				pageSize = "PAGESIZE_NEWS_MOBILE";
			}
		}

		int limit = Config.getPropertyInt(pageSize, so.getRows());
		sq.setLimit(limit);

		//페이징
		if (request.getParameter("mobileValue") == null)
		{
			if(limit == 10) {
				sq.setOffset((so.getPage() * sq.getLimit()) - 10);
			}else {
				sq.setOffset((so.getPage() * sq.getLimit()) - 2);
			}
		}
		else if (request.getParameter("mobileValue").equals("mobileValue")) {
			if(limit == 2) {
				sq.setOffset((so.getPage() * sq.getLimit()) - 2);
			}else {
				sq.setOffset((so.getPage() * sq.getLimit()) - 2);
			}
		}
		SearchResultSet srs = crzclient.search(sq);

		int realCount = 0;
		realCount = srs.getRowCount();

		List<MultiVO> konanNewsList = new ArrayList<MultiVO>();
		MultiVO konanNews = new MultiVO();

		for (int i = 0; i < realCount; i++) {
			Map<String, Object> tempNewsMap = new HashMap<String, Object>();
			tempNewsMap = srs.getRows().get(i);

			konanNews = new MultiVO();
			konanNews.setBbsId((String)tempNewsMap.get("BBS_ID"));
			konanNews.setLeftNo(Integer.parseInt((String)tempNewsMap.get("LETT_NO")));
			konanNews.setTitle((String)tempNewsMap.get("TITLE"));
			konanNews.setCmntCnt(Integer.parseInt((String)tempNewsMap.get("CMNT_CNT")));
			konanNews.setContent((String)tempNewsMap.get("CONTENT"));
			konanNews.setRegrNo(Long.parseLong((String)tempNewsMap.get("REGR_NO")));
			String regDttm = (String)tempNewsMap.get("REG_DTTM");
			konanNews.setRegDate(regDttm.substring(0,10).replace("-", "."));
			konanNews.setRegrDispCd((String)tempNewsMap.get("REGR_DISP_CD"));
			konanNews.setMemberNm((String)tempNewsMap.get("MEMBER_NM"));
			konanNews.setLoginId((String)tempNewsMap.get("LOGIN_ID"));
			konanNews.setIconCheckValueHot((String)tempNewsMap.get("ICON_CHECK_VALUE_HOT"));
			konanNews.setIconCheckValueNew((String)tempNewsMap.get("ICON_CHECK_VALUE_NEW"));
			konanNews.setNoticeYn((String)tempNewsMap.get("NOTICE_YN"));
			konanNews.setInqCnt(Integer.parseInt((String)tempNewsMap.get("INQ_CNT")));
			konanNews.setTitleNm((String)tempNewsMap.get("TITLE_NM"));
			konanNews.setLvl(Integer.parseInt((String)tempNewsMap.get("LVL")));
			konanNews.setSectYn((String)tempNewsMap.get("SECT_YN"));
			konanNews.setLeftLvl((String)tempNewsMap.get("LETT_LVL"));
			konanNews.setImgFilePath((String)tempNewsMap.get("IMG_FILE_PATH"));
			konanNews.setImgFileNm((String)tempNewsMap.get("IMG_FILE_NM"));
			konanNews.setSellerNo(Integer.parseInt((String)tempNewsMap.get("SELLER_NO")));
			konanNews.setSellerNm((String)tempNewsMap.get("SELLER_NM"));
			konanNews.setDetailLink((String)tempNewsMap.get("DETAIL_LINK"));

			konanNewsList.add(konanNews);
		}

		// 현재 페이지 번호 초기화
        if (so.getPage() == 0) {
            so.setPage(1);
        }
        ResultListModel<MultiVO> newsList = new ResultListModel<>();
        // 전체 카운트 조회
        int totalRows = srs.getTotalCount();

        HashMap<String, Object> newsMap = new HashMap<String, Object>();

        if (totalRows < 1) {

        	newsList.setTotalRows(0);
        	newsList.setFilterdRows(0);
        	newsList.setPage(so.getPage());
        	newsList.setRows(so.getRows());
        	newsMap.put("newsList", newsList);
            return newsMap;
        }

        // 검색결과 카운트 조회
        int filterdRows = realCount;
        if (filterdRows < 1) {
        	newsList.setTotalRows(totalRows);
        	newsList.setFilterdRows(0);
        	newsList.setPage(so.getPage());
        	newsList.setRows(so.getRows());
        	newsMap.put("newsList", newsList);
            return newsMap;
        }

        so.setTotalCount(totalRows);

        so.setLimit((so.getPage() - 1) * so.getRows());
        so.setOffset(so.getRows());

        so.setStartIndex(((so.getPage() - 1) * so.getRows()) + 1);
        so.setEndIndex(((so.getPage() - 1) * so.getRows()) + so.getRows());

        if (StringUtil.isNotBlank(so.getSidx())) {
            so.setSidx(StringUtil.toUnCamelCase(so.getSidx()).toUpperCase());
        }

        if (filterdRows > 0 && filterdRows % so.getRows() == 0) {
        	newsList.setTotalPages(filterdRows / so.getRows());
        } else {
        	newsList.setTotalPages(filterdRows / so.getRows() + 1);
        }
        newsList.setTotalRows(totalRows);
        newsList.setFilterdRows(filterdRows);
        newsList.setPage(so.getPage());
        newsList.setRows(so.getRows());
        newsList.setResultList(konanNewsList);

        //페이징
        double totalCount = 0;
        if (request.getParameter("mobileValue") == null) {
        	totalCount = srs.getTotalCount() / 10.0;
        }else {
        	totalCount = srs.getTotalCount() / 2.0;
        }
		int totalPage = (int) Math.ceil(totalCount);
		newsList.setTotalPages(totalPage);

	    newsMap.put("newsList", newsList);

    	return newsMap;
    }

    //관련검사
    private HashMap<String, Object> vcsProc(@Validated GoodsSO so, BindingResult bindingResult, HttpServletRequest request) throws Exception {
    	String query = so.getSearchWord();

    	QueryBuilder qb = new QueryBuilder();
    	//qb.where("(TITLE_idx = '*{0}*' anyword OR CONTENT_idx = '*{0}*' anyword) order by $MATCHFIELD(TITLE,CONTENT,REL_SEARCH_WORD) DESC", query);
    	qb.where("(TITLE_idx = '{0}' anyword OR CONTENT_idx = '{0}' anyword or REL_SEARCH_WORD = '{0}' ) order by $MATCHFIELD(TITLE,CONTENT,REL_SEARCH_WORD) DESC , $relevance desc", query);

		CrzClient crzclient = Config.getCrzClient();
		SearchQuery sq = new SearchQuery("V_SEARCH_VCS", query);

		sq.setWhereClause(qb.getWhereClause());

		//로그
		sq.setLog("DAVICH@VCS+$|첫검색|0|정확도순^"+so.getSearchWord()+"##");

		String pageSize = "";

		if (request.getParameter("mobileValue") == null)
		{
			if (so.getRows() == 5) {
				pageSize = "PAGESIZE_VCS_TOTAL";
			} else {
				pageSize = "PAGESIZE_VCS";
			}
		}
		else if (request.getParameter("mobileValue").equals("mobileValue")) {
			if (so.getRows() == 1) {
				pageSize = "PAGESIZE_VCS_MOBILE_TOTAL";
			} else {
				pageSize = "PAGESIZE_VCS_MOBILE";
			}
		}

		int limit = Config.getPropertyInt(pageSize, so.getRows());
		sq.setLimit(limit);

		//페이징
		if (request.getParameter("mobileValue") == null)
		{
			if(limit == 5) {
				sq.setOffset((so.getPage() * sq.getLimit()) - 5);
			}else {
				sq.setOffset((so.getPage() * sq.getLimit()) - 6);
			}
		}
		else if (request.getParameter("mobileValue").equals("mobileValue")) {
			if(limit == 5) {
				sq.setOffset((so.getPage() * sq.getLimit()) - 5);
			}else {
				sq.setOffset((so.getPage() * sq.getLimit()) - 5);
			}
		}
		SearchResultSet srs = crzclient.search(sq);

		int realCount = 0;
		realCount = srs.getRowCount();

		List<MultiVO> konanVcsList = new ArrayList<MultiVO>();
		MultiVO konanVcs = new MultiVO();

		for (int i = 0; i < realCount; i++) {
			Map<String, Object> tempVcsMap = new HashMap<String, Object>();
			tempVcsMap = srs.getRows().get(i);

			konanVcs = new MultiVO();
			konanVcs.setBbsId((String)tempVcsMap.get("BBS_ID"));
			konanVcs.setLeftNo(Integer.parseInt((String)tempVcsMap.get("LETT_NO")));
			konanVcs.setTitle((String)tempVcsMap.get("TITLE"));
			konanVcs.setCmntCnt(Integer.parseInt((String)tempVcsMap.get("CMNT_CNT")));
			konanVcs.setContent((String)tempVcsMap.get("CONTENT"));
			konanVcs.setRegrNo(Long.parseLong((String)tempVcsMap.get("REGR_NO")));
			String regDttm = (String)tempVcsMap.get("REG_DTTM");
			konanVcs.setRegDate(regDttm.substring(0,10).replace("-", "."));
			konanVcs.setRegrDispCd((String)tempVcsMap.get("REGR_DISP_CD"));
			konanVcs.setMemberNm((String)tempVcsMap.get("MEMBER_NM"));
			konanVcs.setLoginId((String)tempVcsMap.get("LOGIN_ID"));
			konanVcs.setIconCheckValueHot((String)tempVcsMap.get("ICON_CHECK_VALUE_HOT"));
			konanVcs.setIconCheckValueNew((String)tempVcsMap.get("ICON_CHECK_VALUE_NEW"));
			konanVcs.setNoticeYn((String)tempVcsMap.get("NOTICE_YN"));
			konanVcs.setInqCnt(Integer.parseInt((String)tempVcsMap.get("INQ_CNT")));
			konanVcs.setTitleNm((String)tempVcsMap.get("TITLE_NM"));
			konanVcs.setLvl(Integer.parseInt((String)tempVcsMap.get("LVL")));
			konanVcs.setSectYn((String)tempVcsMap.get("SECT_YN"));
			konanVcs.setLeftLvl((String)tempVcsMap.get("LETT_LVL"));
			konanVcs.setImgFilePath((String)tempVcsMap.get("IMG_FILE_PATH"));
			konanVcs.setImgFileNm((String)tempVcsMap.get("IMG_FILE_NM"));
			konanVcs.setSellerNo(Integer.parseInt((String)tempVcsMap.get("SELLER_NO")));
			konanVcs.setSellerNm((String)tempVcsMap.get("SELLER_NM"));
			konanVcs.setDetailLink((String)tempVcsMap.get("DETAIL_LINK"));

			konanVcsList.add(konanVcs);
		}

		// 현재 페이지 번호 초기화
        if (so.getPage() == 0) {
            so.setPage(1);
        }
        ResultListModel<MultiVO> vcsList = new ResultListModel<>();
        // 전체 카운트 조회
        int totalRows = srs.getTotalCount();

        HashMap<String, Object> vcsMap = new HashMap<String, Object>();

        if (totalRows < 1) {

        	vcsList.setTotalRows(0);
        	vcsList.setFilterdRows(0);
        	vcsList.setPage(so.getPage());
        	vcsList.setRows(so.getRows());
        	vcsMap.put("vcsList", vcsList);
            return vcsMap;
        }

        // 검색결과 카운트 조회
        int filterdRows = realCount;
        if (filterdRows < 1) {
        	vcsList.setTotalRows(totalRows);
        	vcsList.setFilterdRows(0);
        	vcsList.setPage(so.getPage());
        	vcsList.setRows(so.getRows());
        	vcsMap.put("vcsList", vcsList);
            return vcsMap;
        }

        so.setTotalCount(totalRows);

        so.setLimit((so.getPage() - 1) * so.getRows());
        so.setOffset(so.getRows());

        so.setStartIndex(((so.getPage() - 1) * so.getRows()) + 1);
        so.setEndIndex(((so.getPage() - 1) * so.getRows()) + so.getRows());

        if (StringUtil.isNotBlank(so.getSidx())) {
            so.setSidx(StringUtil.toUnCamelCase(so.getSidx()).toUpperCase());
        }

        if (filterdRows > 0 && filterdRows % so.getRows() == 0) {
        	vcsList.setTotalPages(filterdRows / so.getRows());
        } else {
        	vcsList.setTotalPages(filterdRows / so.getRows() + 1);
        }
        vcsList.setTotalRows(totalRows);
        vcsList.setFilterdRows(filterdRows);
        vcsList.setPage(so.getPage());
        vcsList.setRows(so.getRows());
        vcsList.setResultList(konanVcsList);

        //페이징
		double totalCount = srs.getTotalCount() / 6.0;
		int totalPage = (int) Math.ceil(totalCount);
		vcsList.setTotalPages(totalPage);

	    vcsMap.put("vcsList", vcsList);

    	return vcsMap;
    }

    //상품지식
    private HashMap<String, Object> dictionaryProc(@Validated GoodsSO so, BindingResult bindingResult, HttpServletRequest request) throws Exception {
    	String query = so.getSearchWord();

    	QueryBuilder qb = new QueryBuilder();
    	//qb.where("(TITLE_idx = '*{0}*' anyword OR CONTENT_idx = '*{0}*' anyword) order by $MATCHFIELD(TITLE,CONTENT,REL_SEARCH_WORD ) DESC", query);
    	qb.where("(TITLE_idx = '{0}' anyword OR CONTENT_idx = '{0}' anyword )  order by $MATCHFIELD(TITLE,CONTENT) DESC , $relevance desc", query);

		CrzClient crzclient = Config.getCrzClient();
		SearchQuery sq = new SearchQuery("V_SEARCH_DICTIONARY", query);

		sq.setWhereClause(qb.getWhereClause());

		//로그
		sq.setLog("DAVICH@DICTIONARY+$|첫검색|0|정확도순^"+so.getSearchWord()+"##");

		String pageSize = "";

		if (request.getParameter("mobileValue") == null)
		{
			if (so.getRows() == 2) {
				pageSize = "PAGESIZE_DICTIONARY";
			} else {
				pageSize = "PAGESIZE_DICTIONARY_TOTAL";
			}
		}
		else if (request.getParameter("mobileValue").equals("mobileValue")) {
			if (so.getRows() == 2) {
				pageSize = "PAGESIZE_DICTIONARY_MOBILE_TOTAL";
			} else {
				pageSize = "PAGESIZE_DICTIONARY_MOBILE";
			}
		}

		int limit = Config.getPropertyInt(pageSize, so.getRows());
		sq.setLimit(limit);

		//페이징
		if (request.getParameter("mobileValue") == null)
		{
			if(limit == 2) {
				sq.setOffset((so.getPage() * sq.getLimit()) - 2);
			}else {
				sq.setOffset((so.getPage() * sq.getLimit()) - 2);
			}
		}
		else if (request.getParameter("mobileValue").equals("mobileValue")) {
			if(limit == 2) {
				sq.setOffset((so.getPage() * sq.getLimit()) - 2);
			}else {
				sq.setOffset((so.getPage() * sq.getLimit()) - 20);
			}
		}

		SearchResultSet srs = crzclient.search(sq);

		int realCount = 0;
		realCount = srs.getRowCount();

		List<MultiVO> konanDictionaryList = new ArrayList<MultiVO>();
		MultiVO konanDictionary = new MultiVO();

		for (int i = 0; i < realCount; i++) {
			Map<String, Object> tempDictionaryMap = new HashMap<String, Object>();
			tempDictionaryMap = srs.getRows().get(i);

			konanDictionary = new MultiVO();
			konanDictionary.setBbsId((String)tempDictionaryMap.get("BBS_ID"));
			konanDictionary.setLeftNo(Integer.parseInt((String)tempDictionaryMap.get("LETT_NO")));
			konanDictionary.setTitle((String)tempDictionaryMap.get("TITLE"));
			konanDictionary.setCmntCnt(Integer.parseInt((String)tempDictionaryMap.get("CMNT_CNT")));
			konanDictionary.setContent((String)tempDictionaryMap.get("CONTENT"));
			konanDictionary.setRegrNo(Long.parseLong((String)tempDictionaryMap.get("REGR_NO")));
			String regDttm = (String)tempDictionaryMap.get("REG_DTTM");
			konanDictionary.setRegDate(regDttm.substring(0,10).replace("-", "."));
			konanDictionary.setRegrDispCd((String)tempDictionaryMap.get("REGR_DISP_CD"));
			konanDictionary.setMemberNm((String)tempDictionaryMap.get("MEMBER_NM"));
			konanDictionary.setLoginId((String)tempDictionaryMap.get("LOGIN_ID"));
			konanDictionary.setIconCheckValueHot((String)tempDictionaryMap.get("ICON_CHECK_VALUE_HOT"));
			konanDictionary.setIconCheckValueNew((String)tempDictionaryMap.get("ICON_CHECK_VALUE_NEW"));
			konanDictionary.setNoticeYn((String)tempDictionaryMap.get("NOTICE_YN"));
			konanDictionary.setInqCnt(Integer.parseInt((String)tempDictionaryMap.get("INQ_CNT")));
			konanDictionary.setTitleNm((String)tempDictionaryMap.get("TITLE_NM"));
			konanDictionary.setLvl(Integer.parseInt((String)tempDictionaryMap.get("LVL")));
			konanDictionary.setSectYn((String)tempDictionaryMap.get("SECT_YN"));
			konanDictionary.setLeftLvl((String)tempDictionaryMap.get("LETT_LVL"));
			konanDictionary.setImgFilePath((String)tempDictionaryMap.get("IMG_FILE_PATH"));
			konanDictionary.setImgFileNm((String)tempDictionaryMap.get("IMG_FILE_NM"));
			konanDictionary.setSellerNo(Integer.parseInt((String)tempDictionaryMap.get("SELLER_NO")));
			konanDictionary.setSellerNm((String)tempDictionaryMap.get("SELLER_NM"));
			konanDictionary.setDetailLink((String)tempDictionaryMap.get("DETAIL_LINK"));

			konanDictionaryList.add(konanDictionary);
		}

		// 현재 페이지 번호 초기화
        if (so.getPage() == 0) {
            so.setPage(1);
        }
        ResultListModel<MultiVO> dictionaryList = new ResultListModel<>();
        // 전체 카운트 조회
        int totalRows = srs.getTotalCount();

        HashMap<String, Object> dictionaryMap = new HashMap<String, Object>();

        if (totalRows < 1) {

        	dictionaryList.setTotalRows(0);
        	dictionaryList.setFilterdRows(0);
        	dictionaryList.setPage(so.getPage());
        	dictionaryList.setRows(so.getRows());
        	dictionaryMap.put("dictionaryList", dictionaryList);
            return dictionaryMap;
        }

        // 검색결과 카운트 조회
        int filterdRows = realCount;
        if (filterdRows < 1) {
        	dictionaryList.setTotalRows(totalRows);
        	dictionaryList.setFilterdRows(0);
        	dictionaryList.setPage(so.getPage());
        	dictionaryList.setRows(so.getRows());
        	dictionaryMap.put("dictionaryList", dictionaryList);
            return dictionaryMap;
        }

        so.setTotalCount(totalRows);

        so.setLimit((so.getPage() - 1) * so.getRows());
        so.setOffset(so.getRows());

        so.setStartIndex(((so.getPage() - 1) * so.getRows()) + 1);
        so.setEndIndex(((so.getPage() - 1) * so.getRows()) + so.getRows());

        if (StringUtil.isNotBlank(so.getSidx())) {
            so.setSidx(StringUtil.toUnCamelCase(so.getSidx()).toUpperCase());
        }

        if (filterdRows > 0 && filterdRows % so.getRows() == 0) {
        	dictionaryList.setTotalPages(filterdRows / so.getRows());
        } else {
        	dictionaryList.setTotalPages(filterdRows / so.getRows() + 1);
        }
        dictionaryList.setTotalRows(totalRows);
        dictionaryList.setFilterdRows(filterdRows);
        dictionaryList.setPage(so.getPage());
        dictionaryList.setRows(so.getRows());
        dictionaryList.setResultList(konanDictionaryList);

        //페이징
		double totalCount = srs.getTotalCount() / 2.0;
		int totalPage = (int) Math.ceil(totalCount);
		dictionaryList.setTotalPages(totalPage);

        dictionaryMap.put("dictionaryList", dictionaryList);

    	return dictionaryMap;
    }

    //동영상
    private HashMap<String, Object> videoProc(@Validated GoodsSO so, BindingResult bindingResult, HttpServletRequest request) throws Exception {
    	String query = so.getSearchWord();

        //video 제목 검색
    	QueryBuilder qb = new QueryBuilder();
    	//qb.where("(TITLE_idx = '*{0}*' anyword OR CONTENT_idx = '*{0}*' anyword OR REL_SEARCH_WORD_idx = '*{0}*' anyword) order by $MATCHFIELD(TITLE ,REL_SEARCH_WORD) DESC , REG_DTTM    DESC", query);
    	qb.where("(TITLE_idx = '{0}' anyword OR CONTENT_idx = '{0}' anyword OR REL_SEARCH_WORD_idx = '{0}' anyword) order by $MATCHFIELD(TITLE ,REL_SEARCH_WORD) DESC , $relevance desc , REG_DTTM    DESC", query);

		CrzClient crzclient = Config.getCrzClient();
		SearchQuery sq = new SearchQuery("V_SEARCH_VIDEO", query);

		sq.setWhereClause(qb.getWhereClause());

		//로그
		sq.setLog("DAVICH@VIDEO+$|첫검색|0|정확도순^"+so.getSearchWord()+"##");

		String pageSize = "";

		if (request.getParameter("mobileValue") == null)
		{
			if (so.getRows() == 5) {
				pageSize = "PAGESIZE_VIDEO_TOTAL";
			} else {
				pageSize = "PAGESIZE_VIDEO";
			}
		}
		else if (request.getParameter("mobileValue").equals("mobileValue")) {
			if (so.getRows() == 3) {
				pageSize = "PAGESIZE_VIDEO_MOBILE_TOTAL";
			} else {
				pageSize = "PAGESIZE_VIDEO_MOBILE";
			}
		}

		/*int limit = Config.getPropertyInt(pageSize, so.getRows());*/
		int limit = Config.getPropertyInt(pageSize, so.getRows());
		sq.setLimit(limit);

		//페이징
		if (request.getParameter("mobileValue") == null)
		{
			if(limit == 25) {
				sq.setOffset((so.getPage() * sq.getLimit()) - 25);
			}else {
				sq.setOffset((so.getPage() * sq.getLimit()) - 5);
			}
		}
		else if (request.getParameter("mobileValue").equals("mobileValue")) {
			if(limit == 3) {
				sq.setOffset((so.getPage() * sq.getLimit()) - 3);
			}else {
				sq.setOffset((so.getPage() * sq.getLimit()) - 3);
			}
		}

		SearchResultSet srs = crzclient.search(sq);

		int realCount = 0;
		realCount = srs.getRowCount();

		List<MultiVO> konanVideoList = new ArrayList<MultiVO>();
		MultiVO konanVideo = new MultiVO();

		for (int i = 0; i < realCount; i++) {
			Map<String, Object> tempVideoMap = new HashMap<String, Object>();
			tempVideoMap = srs.getRows().get(i);

			konanVideo = new MultiVO();
			konanVideo.setBbsId((String)tempVideoMap.get("BBS_ID"));
			konanVideo.setLeftNo(Integer.parseInt((String)tempVideoMap.get("LETT_NO")));
			konanVideo.setTitle((String)tempVideoMap.get("TITLE"));
			konanVideo.setCmntCnt(Integer.parseInt((String)tempVideoMap.get("CMNT_CNT")));
			konanVideo.setContent((String)tempVideoMap.get("CONTENT"));
			konanVideo.setRegrNo(Long.parseLong((String)tempVideoMap.get("REGR_NO")));
			String regDttm = (String)tempVideoMap.get("REG_DTTM");
			konanVideo.setRegDate(regDttm.substring(0,10).replace("-", "."));
			konanVideo.setRegrDispCd((String)tempVideoMap.get("REGR_DISP_CD"));
			konanVideo.setMemberNm((String)tempVideoMap.get("MEMBER_NM"));
			konanVideo.setLoginId((String)tempVideoMap.get("LOGIN_ID"));
			konanVideo.setIconCheckValueHot((String)tempVideoMap.get("ICON_CHECK_VALUE_HOT"));
			konanVideo.setIconCheckValueNew((String)tempVideoMap.get("ICON_CHECK_VALUE_NEW"));
			konanVideo.setNoticeYn((String)tempVideoMap.get("NOTICE_YN"));
			konanVideo.setInqCnt(Integer.parseInt((String)tempVideoMap.get("INQ_CNT")));
			konanVideo.setTitleNm((String)tempVideoMap.get("TITLE_NM"));
			konanVideo.setLvl(Integer.parseInt((String)tempVideoMap.get("LVL")));
			konanVideo.setSectYn((String)tempVideoMap.get("SECT_YN"));
			konanVideo.setLeftLvl((String)tempVideoMap.get("LETT_LVL"));
			konanVideo.setImgFilePath((String)tempVideoMap.get("IMG_FILE_PATH"));
			konanVideo.setImgFileNm((String)tempVideoMap.get("IMG_FILE_NM"));
			konanVideo.setSellerNo(Integer.parseInt((String)tempVideoMap.get("SELLER_NO")));
			konanVideo.setSellerNm((String)tempVideoMap.get("SELLER_NM"));
			konanVideo.setLinkUrl((String)tempVideoMap.get("LINK_URL"));
			konanVideo.setRelSearchWord((String)tempVideoMap.get("REL_SEARCH_WORD"));
			konanVideo.setDetailLink((String)tempVideoMap.get("DETAIL_LINK"));

			konanVideoList.add(konanVideo);
		}

		// 현재 페이지 번호 초기화
        if (so.getPage() == 0) {
            so.setPage(1);
        }
        ResultListModel<MultiVO> videoList = new ResultListModel<>();
        // 전체 카운트 조회
        int totalRows = srs.getTotalCount();

        HashMap<String, Object> videoMap = new HashMap<String, Object>();

        if (totalRows < 1) {

        	videoList.setTotalRows(0);
        	videoList.setFilterdRows(0);
        	videoList.setPage(so.getPage());
        	videoList.setRows(so.getRows());
            videoMap.put("videoList", videoList);
            return videoMap;
        }

        // 검색결과 카운트 조회
        int filterdRows = realCount;
        if (filterdRows < 1) {
        	videoList.setTotalRows(totalRows);
        	videoList.setFilterdRows(0);
        	videoList.setPage(so.getPage());
        	videoList.setRows(so.getRows());
        	videoMap.put("videoList", videoList);
            return videoMap;
        }

        so.setTotalCount(totalRows);

        so.setLimit((so.getPage() - 1) * so.getRows());
        so.setOffset(so.getRows());

        so.setStartIndex(((so.getPage() - 1) * so.getRows()) + 1);
        so.setEndIndex(((so.getPage() - 1) * so.getRows()) + so.getRows());

        if (StringUtil.isNotBlank(so.getSidx())) {
            so.setSidx(StringUtil.toUnCamelCase(so.getSidx()).toUpperCase());
        }

        if (filterdRows > 0 && filterdRows % so.getRows() == 0) {
        	videoList.setTotalPages(filterdRows / so.getRows());
        } else {
        	videoList.setTotalPages(filterdRows / so.getRows() + 1);
        }
        videoList.setTotalRows(totalRows);
        videoList.setFilterdRows(filterdRows);
        videoList.setPage(so.getPage());
        videoList.setRows(so.getRows());
        videoList.setResultList(konanVideoList);

        //페이징
        double totalCount = 0;
        if (request.getParameter("mobileValue") == null) {
        	totalCount = srs.getTotalCount() / 25.0;
        }else {
        	totalCount = srs.getTotalCount() / 3.0;
        }
		int totalPage = (int) Math.ceil(totalCount);
	    videoList.setTotalPages(totalPage);

    	videoMap.put("videoList", videoList);

    	return videoMap;
    }


    //연관상품
    private HashMap<String, Object> withitemProc(@Validated GoodsSO so, BindingResult bindingResult, HttpServletRequest request) throws Exception{
    	HashMap<String, Object> goodsMap = new HashMap<String, Object>();
    	String query = so.getSearchWord();
        //상품 검색
		QueryBuilder qb = new QueryBuilder();
		//qb.where("(SEARCH_NM_idx = '*{0}*' anyword OR V_SEO_SEARCH_WORD_idx = '*{0}*' anyword OR V_ITEM_NM_idx = '*{0}*' anyword) ORDER BY UPD_DTTM  DESC", query);
		qb.where("(SEARCH_NM_idx = '{0}' anyword OR V_SEO_SEARCH_WORD_idx = '{0}' anyword OR V_ITEM_NM_idx = '{0}' anyword)  ORDER BY $relevance desc , UPD_DTTM  DESC", query);

		CrzClient crzclient = Config.getCrzClient();
		SearchQuery sq = new SearchQuery("V_SEARCH_WITHITEM", query);

		sq.setWhereClause(qb.getWhereClause());

		//로그
		sq.setLog("DAVICH@WITHITEM+$|첫검색|0|정확도순^"+so.getSearchWord()+"##");

		String pageSize = "";

		if (request.getParameter("mobileValue") == null)
		{
			if (so.getRows() == 5) {
				pageSize = "PAGESIZE_PRODUCT_TOTAL";
			} else {
				pageSize = "PAGESIZE_PRODUCT";
			}
		}
		else if (request.getParameter("mobileValue").equals("mobileValue")) {
			if (so.getRows() == 6) {
				pageSize = "PAGESIZE_PRODUCT_MOBILE_TOTAL";
			} else {
				pageSize = "PAGESIZE_PRODUCT_MOBILE";
			}
		}

		int limit = Config.getPropertyInt(pageSize, so.getRows());
		sq.setLimit(limit);
		//페이징
		if (request.getParameter("mobileValue") == null)
		{
			if(limit == 5) {
				sq.setOffset((so.getPage() * sq.getLimit()) - 5);
			}else {
				sq.setOffset((so.getPage() * sq.getLimit()) - 20);
			}
		}
		else if (request.getParameter("mobileValue").equals("mobileValue")) {
			if(limit == 6) {
				sq.setOffset((so.getPage() * sq.getLimit()) - 6);
			}else {
				sq.setOffset((so.getPage() * sq.getLimit()) - 20);
			}
		}
		SearchResultSet srs = crzclient.search(sq);

		int realCount = 0;
		realCount = srs.getRowCount();

		List<GoodsVO> konanGoodsList = new ArrayList<GoodsVO>();
		GoodsVO konanGoods = new GoodsVO();
		for (int i = 0; i < realCount; i++) {
			Map<String, Object> tempGoodsMap = new HashMap<String, Object>();
			tempGoodsMap = srs.getRows().get(i);

			konanGoods = new GoodsVO();
			konanGoods.setGoodsNo((String)tempGoodsMap.get("GOODS_NO"));
			konanGoods.setGoodsTypeCd((String)tempGoodsMap.get("GOODS_TYPE_CD"));
			konanGoods.setGoodsNm((String)tempGoodsMap.get("GOODS_NM"));
			konanGoods.setItemNo((String)tempGoodsMap.get("ITEM_NO"));
			konanGoods.setGoodsSaleStatusCd((String)tempGoodsMap.get("GOODS_SALE_STATUS_CD"));
			konanGoods.setDispYn((String)tempGoodsMap.get("DISP_YN"));
			konanGoods.setGoodsDispImgA((String)tempGoodsMap.get("GOODS_DISP_IMG_A"));
			konanGoods.setGoodsDispImgB((String)tempGoodsMap.get("GOODS_DISP_IMG_B"));
			konanGoods.setGoodsDispImgC((String)tempGoodsMap.get("GOODS_DISP_IMG_C"));
			konanGoods.setGoodsDispImgD((String)tempGoodsMap.get("GOODS_DISP_IMG_D"));
			konanGoods.setGoodsDispImgE((String)tempGoodsMap.get("GOODS_DISP_IMG_E"));
			konanGoods.setIconImgs((String)tempGoodsMap.get("ICON_IMGS"));
			konanGoods.setAccmGoodslettCnt((String)tempGoodsMap.get("ACCM_SALE_CNT"));
			konanGoods.setGoodsSvmnAmt((String)tempGoodsMap.get("GOODS_SVMN_AMT"));
			konanGoods.setGoodsScore((String)tempGoodsMap.get("GOODS_SCORE"));
			konanGoods.setBrandNo((String)tempGoodsMap.get("BRAND_NO"));
			konanGoods.setBrandNm((String)tempGoodsMap.get("BRAND_NM"));
			konanGoods.setItemNm((String)tempGoodsMap.get("ITEM_NM"));
			konanGoods.setCustomerPrice(Long.parseLong((String)tempGoodsMap.get("CUSTOMER_PRICE")));
			konanGoods.setSalePrice(Long.parseLong((String)tempGoodsMap.get("SALE_PRICE")));
			konanGoods.setSaleRate((String)tempGoodsMap.get("SALE_RATE"));

			konanGoodsList.add(konanGoods);
		}

        // 현재 페이지 번호 초기화
        if (so.getPage() == 0) {
            so.setPage(1);
        }
        ResultListModel<GoodsVO> goodsList = new ResultListModel<>();
        // 전체 카운트 조회
        int totalRows = srs.getTotalCount();
        if (totalRows < 1) {
            goodsList.setTotalRows(0);
            goodsList.setFilterdRows(0);
            goodsList.setPage(so.getPage());
            goodsList.setRows(so.getRows());
            goodsMap.put("withitemList", goodsList);
            return goodsMap;
        }

        // 검색결과 카운트 조회
        int filterdRows = realCount;

        if (filterdRows < 1) {
        	goodsList.setTotalRows(totalRows);
        	goodsList.setFilterdRows(0);
        	goodsList.setPage(so.getPage());
        	goodsList.setRows(so.getRows());
        	goodsMap.put("withitemList", goodsList);
            return goodsMap;
        }

        so.setTotalCount(totalRows);

        so.setLimit((so.getPage() - 1) * so.getRows());
        so.setOffset(so.getRows());

        so.setStartIndex(((so.getPage() - 1) * so.getRows()) + 1);
        so.setEndIndex(((so.getPage() - 1) * so.getRows()) + so.getRows());

        if (StringUtil.isNotBlank(so.getSidx())) {
            so.setSidx(StringUtil.toUnCamelCase(so.getSidx()).toUpperCase());
        }

        if (filterdRows > 0 && filterdRows % so.getRows() == 0) {
        	goodsList.setTotalPages(filterdRows / so.getRows());
        } else {
        	goodsList.setTotalPages(filterdRows / so.getRows() + 1);
        }
        goodsList.setTotalRows(totalRows);
        goodsList.setFilterdRows(filterdRows);
        goodsList.setPage(so.getPage());
        goodsList.setRows(so.getRows());
        goodsList.setResultList(konanGoodsList);

        //페이징
		double totalCount = srs.getTotalCount() / 20.0;
		int totalPage = (int) Math.ceil(totalCount);
        goodsList.setTotalPages(totalPage);
    	goodsMap.put("withitemList", goodsList);

    	return goodsMap;
    }

}
