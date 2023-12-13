package net.danvi.dmall.biz.batch.goods.service;

import dmall.framework.common.BaseService;
import dmall.framework.common.constants.UploadConstants;
import dmall.framework.common.util.FileUtil;
import dmall.framework.common.util.SiteUtil;
import lombok.extern.slf4j.Slf4j;
import net.danvi.dmall.biz.app.goods.service.GoodsManageService;
import net.danvi.dmall.biz.batch.goods.salestatus.model.GoodsBatchVO;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.lang.reflect.InvocationTargetException;
import java.nio.charset.Charset;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

@Service("goodsBatchService")
@Slf4j
public class GoodsBatchServiceImpl extends BaseService implements GoodsBatchService {

    @Resource(name = "goodsManageService")
    private GoodsManageService goodsManageService;

    // 1.상품 판매여부 변경
    /*
     * (non-Javadoc)
     * 
     * @see GoodsBatchService#
     * updateGoodsSaleStatus(net.danvi.dmall.biz.batch.goods.salestatus.model.
     * GoodsBatchVO)
     */
    @Override
    public void updateGoodsSaleStatus(GoodsBatchVO vo)
            throws InvocationTargetException, NoSuchMethodException, IllegalAccessException, IOException {
        log.debug("상품 판매여부 변경 시작");
        proxyDao.update("batch.goods." + "updateGoodsSaleStatus", vo);
        log.debug("상품 판매여부 변경 완료");

    }

    // 2.상품 판매정보 변경
    /*
     * (non-Javadoc)
     * 
     * @see GoodsBatchService#
     * updateGoodsSortInfo(net.danvi.dmall.biz.batch.goods.salestatus.model.
     * GoodsBatchVO)
     */
    @Override
    public void updateGoodsSortInfo(GoodsBatchVO vo)
            throws InvocationTargetException, NoSuchMethodException, IllegalAccessException, IOException {
        log.debug("상품 판매정보 변경 시작");
        proxyDao.update("batch.goods." + "updateGoodsSortInfo", vo);
        log.debug("상품 판매정보 변경 완료");

    }

    // 네이버 지식쇼핑 상품 정보 생성
    /*
     * (non-Javadoc)
     *
     * @see GoodsBatchService#
     * createEpGoodsInfo(net.danvi.dmall.biz.batch.goods.salestatus.model.GoodsBatchVO)
     */
    @Override
    public void createEpGoodsInfo()
            throws InvocationTargetException, NoSuchMethodException, IllegalAccessException, IOException {
        log.debug("네이버 지식쇼핑 상품 정보 생성 시작");

        //출력 스트림 생성
        BufferedWriter bufWriter = null;
        try{
            String epTxtFilename="ep.txt";
            String epfilePath = SiteUtil.getSiteUplaodRootPath("id1")+ FileUtil.getCombinedPath(UploadConstants.PATH_INTERFACE, "ep")+File.separator+epTxtFilename;

            File orgFile = new File(epfilePath);
            if (!orgFile.getParentFile().exists()) {
                orgFile.getParentFile().mkdirs();
            }

            File targetFile = new File(SiteUtil.getSiteUplaodRootPath("id1") + FileUtil.getCombinedPath(UploadConstants.PATH_INTERFACE, "ep")
                                        +File.separator + FileUtil.getNowdatePath() + File.separator +epTxtFilename);
            if (orgFile != null && orgFile.exists()) {
                FileUtil.copy(orgFile, targetFile);
            }else{
                orgFile.createNewFile();
            }

            bufWriter = Files.newBufferedWriter(Paths.get(epfilePath), Charset.forName("euc-kr"));

            // CSV 헤더 작성
            /*String [] header = {
                                "상품 ID","상품명 ","상품 가격 ","모바일 상품 가격 ",
                                "정가 ","상품 URL ","상품 모바일 URL","이미지 URL ",
                                "추가 이미지 URL","제휴사 카테고리명(대분류)","제휴사 카테고리명(중분류)","제휴사 카테고리명(소분류)",
                                "제휴사 카테고리명(세분류)","네이버 카테고리","가격비교 페이지 ID","상품상태",
                                "해외구매대행 여부","병행수입 여부","주문제작상품 여부","판매방식 구분",
                                "미성년자 구매불가 상품 여부","상품 구분","바코드","제품코드",
                                "모델명","브랜드","제조사","원산지",
                                "카드명/카드할인가격","이벤트","일반/제휴쿠폰","쿠폰다운로드필요 여부",
                                "카드 무이자 할부 정보","포인트","별도 설치비 유무","사전매칭코드",
                                "검색태그","Group ID","제휴사 상품 ID","코디상품ID",
                                "최소구매수량","상품평(리뷰,구매평) 개수","배송료","차등배송비 여부",
                                "차등배송비 내용","상품속성","구매옵션","셀러 ID (오픈마켓에 한함)",
                                "주 이용 고객층","성별","배송부가정보"
                                };*/
            String [] header = {
                                "id",//"상품 ID",
                                "title",//"상품명 ",
                                "price_pc",//"상품 가격 ",
                                "price_mobile",//"모바일 상품 가격 ",
                                "normal_price",//"정가 ",
                                "link",//"상품 URL ",
                                "mobile_link",//"상품 모바일 URL",
                                "image_link",//"이미지 URL ",
                                "add_image_link",//"추가 이미지 URL",
                                "category_name1",//"제휴사 카테고리명(대분류)",
                                "category_name2",//"제휴사 카테고리명(중분류)",
                                "category_name3",//"제휴사 카테고리명(소분류)",
                                "category_name4",//"제휴사 카테고리명(세분류)",
                                "naver_category",//"네이버 카테고리",
                                "naver_product_id",//"가격비교 페이지 ID",
                                "condition",//"상품상태",
                                "import_flag",//"해외구매대행 여부",
                                "parallel_import",//"병행수입 여부",
                                "order_made",//"주문제작상품 여부",
                                "product_flag",//"판매방식 구분",
                                "adult",//"미성년자 구매불가 상품 여부",
                                "goods_type",//"상품 구분",
                                "barcode",//"바코드",
                                "manufacture_define_number",//"제품코드",
                                "model_number",//"모델명",
                                "brand",//"브랜드",
                                "maker",//"제조사",
                                "origin",//"원산지",
                                "card_event",//"카드명/카드할인가격",
                                "event_words",//"이벤트",
                                "coupon",//"일반/제휴쿠폰",
                                "partner_coupon_download",//"쿠폰다운로드필요 여부",
                                "interest_free_event",//"카드 무이자 할부 정보",
                                "point",//"포인트",
                                "installation_costs",//"별도 설치비 유무",
                                "pre_match_code",//"사전매칭코드",
                                "search_tag",//"검색태그",
                                "group_id",//"Group ID",
                                "vendor_id",//"제휴사 상품 ID",
                                "coordi_id",//"코디상품ID",
                                "minimum_purchase_quantity",//"최소구매수량",
                                "review_count",//"상품평(리뷰,구매평) 개수",
                                "shipping",//"배송료",
                                "delivery_grade",//"차등배송비 여부",
                                "delivery_detail",//"차등배송비 내용",
                                "attribute",//"상품속성",
                                "option_detail",//"구매옵션",
                                "seller_id",//"셀러 ID (오픈마켓에 한함)",
                                "age_group",//"주 이용 고객층",
                                "gender",//"성별",
                                "shipping_settings",//"배송부가정보"
                                };
            List<Map<String, Object>> goodsList =  proxyDao.selectList("batch.goods." + "selectEpGoodsList");
            List<Map<String, Object>> allData = goodsList;
            String headers ="";
            for(String head : header){
                headers +=head+"\t";
            }
            bufWriter.write(headers);
            bufWriter.newLine();
            for(Map<String, Object> newLine : allData){
                Iterator<String> keys = newLine.keySet().iterator();
                 while (keys.hasNext()) {
                    String key = keys.next();
                    Object value = newLine.get(key);
                    if(key.equals("TITLE")){
                        value = StringReplace((String) value);
                    }
                    bufWriter.write(String.valueOf(value==null?"":value));
                    bufWriter.write("\t");
                }
                //개행코드추가
                bufWriter.newLine();
            }
        }catch(FileNotFoundException e){
            e.printStackTrace();
        }catch(IOException e){
            e.printStackTrace();
        } catch (Exception e) {
            e.printStackTrace();
        } finally{
            try{
                if(bufWriter != null){
                    bufWriter.close();
                }
            }catch(IOException e){
                e.printStackTrace();
            }
        }

        log.debug("네이버 지식쇼핑 상품 정보 생성 완료");

    }

    //특수문자 제거 하기
   public static String StringReplace(String str){
      return str.replaceAll("&amp;", "&")
				.replaceAll("&lt;", "<")
				.replaceAll("&gt;", ">")
				.replaceAll("&quot;", "\"")
				.replaceAll("&#39;", "\'")
				.replaceAll("&times;", "×");
   }
}
