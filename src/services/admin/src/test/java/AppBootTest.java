import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.extern.slf4j.Slf4j;
import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.mock.web.MockHttpSession;
import org.springframework.test.web.servlet.MockMvc;

import java.util.HashMap;
import java.util.Map;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultHandlers.print;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

/**
 * Created by dong on 2016-03-29.
 */

//@RunWith(SpringJUnit4ClassRunnerWithDatasource.class)
//@ContextConfiguration(
//        classes = {ServletContextConfig.class, RootConfig.class}
//)
@Slf4j
public class AppBootTest {

//    @Autowired
//    MessageSourceAccessor m;
//
//    @Test
//    public void test() {
//        log.debug("log : {}", m.getMessage("column.grp_cd", "ko_KR"));
//    }

    @Autowired
    private MockMvc mvc;

    @Autowired
    private ObjectMapper objectMapper;

    @Test
    public void test() {
        String mobile = "0111234567";
        log.debug(mobile.replaceAll("(\\d{3})(\\d{3,4})(\\d{4})", "$1-$2-$3"));
    }

    @Test
    public void test2() throws Exception {
        MockHttpSession session = new MockHttpSession();

        Map<String, String> input = new HashMap<>();
        input.put("useYnArray", "Y");
        input.put("useYnArray", "Y");
        input.put("useYnArray", "Y");
        input.put("useYnArray", "Y");
        input.put("useYnArray", "Y");
        input.put("useYnArray", "Y");
        input.put("useYnArray", "Y");
        input.put("useYnArray", "Y");

        mvc.perform(post("/admin/operation/sms/sms-autosend-update")
                .session(session)
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(input))
        ).andExpect(status().isOk())
        .andDo(print());
    }
}
