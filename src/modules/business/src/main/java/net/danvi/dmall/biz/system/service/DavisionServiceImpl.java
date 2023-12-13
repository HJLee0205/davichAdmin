package net.danvi.dmall.biz.system.service;

import dmall.framework.common.BaseService;
import dmall.framework.common.constants.MapperConstants;
import lombok.extern.slf4j.Slf4j;
import net.danvi.dmall.biz.system.model.*;
import org.springframework.stereotype.Service;

import java.util.List;

@Slf4j
@Service("davisionService")
public class DavisionServiceImpl extends BaseService implements DavisionService {

    @Override
    public DavisionItmVO selectDavisionItm(DavisionItmSO so) {
        return proxyDao.selectOne(MapperConstants.SYSTEM_DAVISION + "selectDavisionItm", so);
    }

    @Override
    public List<DavisionItmVO> selectDavisionItmList(DavisionItmSO so) {
        return proxyDao.selectList(MapperConstants.SYSTEM_DAVISION + "selectDavisionItmList", so);
    }

}