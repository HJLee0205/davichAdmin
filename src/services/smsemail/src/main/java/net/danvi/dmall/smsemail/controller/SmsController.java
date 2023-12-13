package net.danvi.dmall.smsemail.controller;

import net.danvi.dmall.smsemail.model.SmsSendHistSO;
import net.danvi.dmall.smsemail.model.sms.InnerSmsSendHistSO;
import net.danvi.dmall.smsemail.service.SmsService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import dmall.framework.common.model.ResultListModel;

/**
 * Created by dong on 2016-08-29.
 */
@Controller
@RequestMapping("/sms")
public class SmsController {

    @Autowired
    private SmsService smsService;

    @RequestMapping("/history")
    @ResponseBody
    public ResultListModel getSendHistory(SmsSendHistSO so) {
        return smsService.selectSendHistoryPaging(new InnerSmsSendHistSO(so));
    }

    @RequestMapping("/autoSendHistory")
    @ResponseBody
    public ResultListModel getAutoSendHistory(SmsSendHistSO so) {
        return smsService.selectAutoSendHistoryPaging(new InnerSmsSendHistSO(so));
    }

    @RequestMapping("/point/{siteNo}")
    @ResponseBody
    public Integer getSmsPoint(@PathVariable String siteNo) {
        if (siteNo == null) return 0;
        return smsService.getPoint(siteNo);
    }
}
