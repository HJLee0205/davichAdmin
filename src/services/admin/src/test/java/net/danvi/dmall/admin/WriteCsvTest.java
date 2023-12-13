package net.danvi.dmall.admin;


import dmall.framework.common.BaseService;
import dmall.framework.common.constants.UploadConstants;
import dmall.framework.common.util.FileUtil;
import dmall.framework.common.util.SiteUtil;
import lombok.extern.slf4j.Slf4j;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.nio.charset.Charset;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

@Slf4j
@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = {"classpath:spring/context/context-datasource.xml"
    ,"classpath:spring/context/context-application.xml"
    ,"classpath:spring/context/context-security.xml"
        ,"classpath:spring/context/context-ehcache.xml"
     })
public class WriteCsvTest extends BaseService {

@Test
public void main(){
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

            //csv파일 읽기
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
                    System.out.println(key);
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
