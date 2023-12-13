package net.danvi.dmall.smsemail.controller;

import net.danvi.dmall.smsemail.model.Sms080RejectPO;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import net.danvi.dmall.smsemail.service.Sms080RejectService;

/**
 * Created by dong on 2016-08-29.
 */
@Controller
@RequestMapping("/080")
public class Sms080RejectController {

    private static final Logger logger = LoggerFactory.getLogger(Sms080RejectController.class);

    @Autowired
    private Sms080RejectService sms080RejectService;

    @RequestMapping("/reject")
    @ResponseBody
    public String add080Reject(Sms080RejectPO po) {

        logger.debug("add 080 receive reject number : {}", po);
        try {
            sms080RejectService.add080Reject(po);
        } catch (Exception e) {
            logger.debug("080 수신 거부 전화번호 등록 실패 : {}", po, e);
            // 080 수신 거부 전화번호 등록 실패
            return "0";
        }
        // 080 수신 거부 전화번호 등록 성공
        return "1";
    }
}
