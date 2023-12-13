package net.danvi.dmall.smsemail.service.impl;

import net.danvi.dmall.smsemail.model.request.Sms080RecvRjtVO;
import net.danvi.dmall.smsemail.dao.ProxyDao;
import net.danvi.dmall.smsemail.model.Sms080RejectPO;
import net.danvi.dmall.smsemail.service.Sms080RejectService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import org.springframework.transaction.annotation.Transactional;
import dmall.framework.common.util.StringUtil;

import java.util.List;

/**
 * Created by dong on 2016-10-04.
 */
@Service("sms080RejectService")
@Transactional(rollbackFor = Exception.class)
public class Sms080RejectServiceImpl implements Sms080RejectService {

    @Autowired
    private ProxyDao proxyDao;

    @Override
    public void add080Reject(Sms080RejectPO po) {

        /*String temp = StringUtil.trim(po.getPhone());*/
        String temp = StringUtil.trim(po.getrNumber());
        po.setPhone(StringUtil.phoneNumber(temp));

        /*temp = StringUtil.trim(po.getDN());*/
        temp = StringUtil.trim(po.getuNumber());
        po.setDN(StringUtil.phoneNumber(temp));


        proxyDao.insert("sms080Reject.insert", po);
    }

    @Override
    public List<Sms080RecvRjtVO> select080RectList() {
        // 신규 등록된 거부 대상을 작업 대상 상태로 변경
        proxyDao.update("sms080Reject.updateReady");
        // 작업 대상 상태의 데이터 조회
        return proxyDao.selectList("sms080Reject.select");
    }

    @Override
    public void updateProcYn(List<Sms080RecvRjtVO> list) {
        for(Sms080RecvRjtVO vo : list) {
            proxyDao.update("sms080Reject.update", vo);
        }
    }
}
