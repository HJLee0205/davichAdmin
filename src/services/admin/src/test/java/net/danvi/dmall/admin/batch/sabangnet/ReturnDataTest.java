package net.danvi.dmall.admin.batch.sabangnet;

import dmall.framework.common.util.StringUtil;
import org.junit.Test;

/**
 * Created by dong on 2016-04-06.
 */
public class ReturnDataTest {

    @Test
    public void test2() throws Exception{
        String resultData = "[2] 실패 : 22287761 - 주문이 존재하지 않습니다.주문번호를 확인해주세요";
        // [2] 실패 : 182904
        String srchKey = resultData.substring(resultData.lastIndexOf(": ") + 2).trim();
        srchKey = srchKey.substring(0, srchKey.lastIndexOf("("));
        System.out.println( srchKey);
    }
}
