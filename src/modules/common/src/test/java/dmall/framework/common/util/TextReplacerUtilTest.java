package dmall.framework.common.util;

import lombok.extern.slf4j.Slf4j;
import org.junit.Test;

import java.util.HashMap;
import java.util.Map;

import static org.hamcrest.CoreMatchers.is;
import static org.junit.Assert.assertThat;

/**
 * Created by dong on 2016-06-30.
 */
@Slf4j
public class TextReplacerUtilTest {

    @Test
    public void test() throws Exception {
        String a = "<li>#[aa]</li><li>#[bb</li><li>##[cc]</li><li>#[m.a]</li><li>#[m.b.a]</li>";
        Map obj = new HashMap();
        Map m1 = new HashMap();
        Map m2 = new HashMap();
        obj.put("aa", "a");
        obj.put("bb", "b");
        obj.put("cc", "c");
        obj.put("dd", "d");

        m2.put("a", "obj.m1.m2");

        m1.put("a", "m.a");
        m1.put("b", m2);

        obj.put("m", m1);

        log.debug("대상 문자열 : {} ", a);
        log.debug("obj : {}", obj);
        log.debug("m1 : {}", m1);
        log.debug("m2 : {}", m2);

        String result = TextReplacerUtil.replace(obj, a);
        log.debug("결과 : {}", result);
        assertThat(result, is("<li>a</li><li>#[bb</li><li>#c</li><li>m.a</li><li>obj.m1.m2</li>"));
    }
}
