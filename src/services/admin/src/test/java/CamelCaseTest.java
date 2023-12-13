import dmall.framework.common.util.DateUtil;
import dmall.framework.common.util.StringUtil;
import org.junit.Test;

import java.util.Calendar;

/**
 * Created by dong on 2016-04-06.
 */
public class CamelCaseTest {
        @Test
        public void test() throws Exception{
            String [] str = {
             "ifSno"
            ,"ifId"
            ,"ifNo"
            ,"siteNo"
            ,"num"
            ,"mallId"
            ,"mallUserId"
            ,"csStatus"
            ,""
            ,""
            ,""
            ,"regDm"
            ,"orderId"
            ,"productId"
            ,"mallProdId"
            ,"productNm"
            ,"subject"
            ,"cnts"
            ,"insNm"
            ,"insDm"
            ,"rplyCnts"
            ,"updNm"
            ,"updDm"
            ,"sendDm"
            ,"csGubun"
            ,"regrNo"

            };

            for (String name : str) {
                name = StringUtil.toUnCamelCase(name);
                System.out.println(name);
            }
    }

    @Test
    public void test1() throws Exception{
        /*Calendar cal = DateUtil.CalendarFromString("2018-02-02 16:43:58", "yyyy-MM-dd HH:mm:ss");
        System.out.println(cal);
        String date = DateUtil.getFormatDate(cal,"yyyyMMdd");
    System.out.println(date);
           System.out.println(DateUtil.addDays(date, -3));*/

           String str ="내사랑포도드링크(15)팩185㎖&amp;&times;24";
    System.out.println(StringReplace(str));


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
