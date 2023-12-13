package net.danvi.dmall.smsemail.service.impl;

import net.danvi.dmall.smsemail.dao.ProxyDao;
import net.danvi.dmall.smsemail.model.CertKeyPO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import net.danvi.dmall.smsemail.service.CertKeyService;
import dmall.framework.common.util.StringUtil;

/**
 * Created by dong on 2016-10-04.
 */
@Service("certKeyService")
@Transactional(rollbackFor = Exception.class)
public class CertKeyServiceImpl implements CertKeyService {

    @Autowired
    private ProxyDao proxyDao;

    @Override
    public void insertCertKey(CertKeyPO po) {
        proxyDao.insert("certKey.insertCertKey", po);
    }

    @Override
    @Transactional(readOnly = true)
    public String getCertKey(Long siteNo) {
        String certKey = proxyDao.selectOne("certKey.selectCertKey", siteNo);
        return StringUtil.nvl(certKey);
    }
}
