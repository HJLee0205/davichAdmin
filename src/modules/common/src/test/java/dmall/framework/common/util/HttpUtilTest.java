package dmall.framework.common.util;

import lombok.extern.slf4j.Slf4j;

/**
 * Created by dong on 2016-07-01.
 */
@Slf4j
public class HttpUtilTest {

    public void test() {
        String html = HttpUtil.getJsonByRestTemplate("http://davichmarket.com/front/customer/faq-list-ajax?bbsId=faq");
        log.debug(html);

    }
}
