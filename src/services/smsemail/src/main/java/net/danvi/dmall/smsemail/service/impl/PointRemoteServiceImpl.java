package net.danvi.dmall.smsemail.service.impl;

import java.util.Calendar;

import net.danvi.dmall.smsemail.service.PointRemoteService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import net.danvi.dmall.core.remote.homepage.model.request.PaymentInfoPO;
import net.danvi.dmall.core.remote.homepage.model.result.RemoteBaseResult;
import net.danvi.dmall.smsemail.model.CertKeyPO;
import net.danvi.dmall.smsemail.service.CertKeyService;
import net.danvi.dmall.smsemail.service.EmailService;
import net.danvi.dmall.smsemail.service.SmsService;
import dmall.framework.common.util.CryptoUtil;

/**
 * Created by dong on 2016-08-31.
 */
@Service("pointRemoteService")
public class PointRemoteServiceImpl implements PointRemoteService {

    @Autowired
    private SmsService smsService;

    @Autowired
    private EmailService emailService;

    @Autowired
    private CertKeyService certKeyService;

    @Override
    public RemoteBaseResult addPoint(PaymentInfoPO po) {
        RemoteBaseResult result = new RemoteBaseResult();
        result.setSuccess(true);

        if ("1".equals(po.getPayGbCd())) {
            // SMS
            smsService.addPoint("" + po.getSiteNo(), Integer.valueOf(po.getAmt()), "01");
        } else if ("2".equals(po.getPayGbCd())) {
            // EMAIL
            emailService.addPoint("" + po.getSiteNo(), Integer.valueOf(po.getAmt()), "01");
        } else {
            result.setSuccess(false);
            result.setMessage("처리할 수 없는 지불 구분 코드입니다.");
        }

        return result;
    }

    @Override
    public String getCertKey(Long siteNo) {
        String key = siteNo + "_" + Calendar.getInstance().getTime().getTime();
        key = CryptoUtil.encryptSHA512(key);

        CertKeyPO po = new CertKeyPO();
        po.setSiteNo(siteNo);
        po.setCertKey(key);
        certKeyService.insertCertKey(po);

        // 임시처리
        smsService.addPoint("" + po.getSiteNo(), 1000, "01");
        emailService.addPoint("" + po.getSiteNo(), 1000, "01");

        return key;
    }
}
