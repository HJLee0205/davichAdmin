package net.danvi.dmall.admin;

import dmall.framework.common.BaseService;
import lombok.extern.slf4j.Slf4j;
import net.danvi.dmall.biz.app.operation.service.EmailSendService;
import net.danvi.dmall.biz.app.operation.service.SmsSendService;
import net.danvi.dmall.biz.app.order.exchange.service.ExchangeService;
import net.danvi.dmall.biz.system.service.SiteService;
import net.danvi.dmall.biz.system.util.InterfaceUtil;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import javax.annotation.Resource;
import java.util.HashMap;
import java.util.Map;

@Slf4j
@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = {"classpath:spring/context/context-datasource.xml"
    ,"classpath:spring/context/context-application.xml"
    ,"classpath:spring/context/context-security.xml"
        ,"classpath:spring/context/context-ehcache.xml"
     })

public class interFaceTest extends BaseService {

    @Resource(name = "siteService")
    private SiteService siteService;

    @Resource(name = "exchangeService")
    private ExchangeService exchangeService;

    @Resource(name = "emailSendService")
    private EmailSendService emailSendService;

    @Resource(name = "smsSendService")
    private SmsSendService smsSendService;


    @Test
    public void test() throws Exception {

            /*Map<String, Object> param = new HashMap<>();
        	param.put("memNo", "1120");

            Map<String, Object> result = InterfaceUtil.send("IF_MEM_022", param);*/

        /*Map<String, Object> param = new HashMap<>();
    	param.put("memNo", "264204");

        Map<String, Object> point_res = InterfaceUtil.send("IF_MEM_008", param);*/

        String aaa = "2222-111-5455".replaceAll("[$|^|*|+|?|/|:|\\-|,|.|\\s]", "");
        System.out.println(aaa);
    }
}