package net.danvi.dmall.smsemail.controller;

import net.danvi.dmall.core.remote.homepage.model.result.RemoteBaseResult;
import net.danvi.dmall.smsemail.model.EmailHistDelPO;
import net.danvi.dmall.smsemail.model.EmailSendHistSO;
import net.danvi.dmall.smsemail.model.email.EmailSendHistVO;
import net.danvi.dmall.smsemail.model.email.InnerEmailSendHistSO;
import net.danvi.dmall.smsemail.service.EmailService;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import dmall.framework.common.model.ResultListModel;

import javax.annotation.Resource;
import java.lang.reflect.Method;

/**
 * Created by dong on 2016-08-29.
 */
@Controller
@RequestMapping("/email")
public class EmailController {

    @Resource(name = "emailService")
    private EmailService emailService;

    @RequestMapping("/history")
    @ResponseBody
    public ResultListModel getSendHistory(EmailSendHistSO so) {
        Class cls = emailService.getClass();
        Method[] methods = cls.getMethods();

        return emailService.selectSendHistoryPaging(new InnerEmailSendHistSO(so));
    }

    @RequestMapping("/viewHistory")
    @ResponseBody
    public EmailSendHistVO viewSendHistory(EmailSendHistSO so) {
        Class cls = emailService.getClass();
        Method[] methods = cls.getMethods();

        return emailService.viewSendHistory(new InnerEmailSendHistSO(so));
    }

    @RequestMapping("/point/{siteNo}")
    @ResponseBody
    public Integer getSmsPoint(@PathVariable String siteNo) {
        if (siteNo == null) return 0;
        return emailService.getPoint(siteNo);
    }

    @RequestMapping("/updateDelYn")
    @ResponseBody
    public RemoteBaseResult deleteMailSendHst(EmailHistDelPO po) {
        Class cls = emailService.getClass();
        Method[] methods = cls.getMethods();

        // emailService.selectSendHistoryPaging(new InnerEmailSendHistSO(so))
        return emailService.deleteSendHistory(po);
    }
}
