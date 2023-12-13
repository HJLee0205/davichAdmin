package net.danvi.dmall.smsemail.service;

import java.util.List;

import net.danvi.dmall.smsemail.model.Sms080RejectPO;
import net.danvi.dmall.smsemail.model.request.Sms080RecvRjtVO;

/**
 * Created by dong on 2016-10-04.
 */
public interface Sms080RejectService {
    public void add080Reject(Sms080RejectPO po);

    public List<Sms080RecvRjtVO> select080RectList();

    public void updateProcYn(List<Sms080RecvRjtVO> list);
}
