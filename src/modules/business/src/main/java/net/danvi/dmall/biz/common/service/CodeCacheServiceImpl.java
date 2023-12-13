package net.danvi.dmall.biz.common.service;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import net.danvi.dmall.biz.system.model.CmnCdDtlVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import dmall.framework.admin.constants.AdminConstants;
import dmall.framework.common.handler.CacheHandler;
import dmall.framework.common.util.StringUtil;

@Service("codeCacheService")
public class CodeCacheServiceImpl implements CodeCacheService {

    @Autowired
    private CacheHandler cacheHandler;

    @Override
    public List<CmnCdDtlVO> listCodeCache(String grpCd) {
        Map<String, List<CmnCdDtlVO>> codeMap = (Map<String, List<CmnCdDtlVO>>) cacheHandler.getValue(AdminConstants.CACHE_CODE);

        List<CmnCdDtlVO> list = codeMap.get(grpCd);

        List<CmnCdDtlVO> newList = new ArrayList<>();

        if (list != null && list.size() > 0) {
            return list;
        }

        return newList;
    }

    @Override
    public List<CmnCdDtlVO> listCodeCache(String grpCd, String usrDfn1Val, String usrDfn2Val, String usrDfn3Val,
            String usrDfn4Val, String usrDfn5Val) {

        Map<String, List<CmnCdDtlVO>> codeMap = (Map<String, List<CmnCdDtlVO>>) cacheHandler.getValue(AdminConstants.CACHE_CODE);

        List<CmnCdDtlVO> list = codeMap.get(grpCd);

        List<CmnCdDtlVO> newList = new ArrayList<>();

        if (list != null && list.size() > 0) {
            if (StringUtil.isBlank(usrDfn1Val) && StringUtil.isBlank(usrDfn2Val)
                    && StringUtil.isBlank(usrDfn3Val)
                    && StringUtil.isBlank(usrDfn4Val) && StringUtil.isBlank(usrDfn5Val)) {
                return list;
            }

            for (CmnCdDtlVO vo : list) {
                Boolean addCheck = true;

                if (AdminConstants.USE_YN_Y.equals(vo.getUseYn())) {
                    if (StringUtil.isNotBlank(usrDfn1Val) && usrDfn1Val.equals(vo.getUserDefien1()) && addCheck) {
                        newList.add(vo);
                        addCheck = false;
                    }
                    if (StringUtil.isNotBlank(usrDfn2Val) && usrDfn2Val.equals(vo.getUserDefien2()) && addCheck) {
                        newList.add(vo);
                        addCheck = false;
                    }
                    if (StringUtil.isNotBlank(usrDfn3Val) && usrDfn3Val.equals(vo.getUserDefien3()) && addCheck) {
                        newList.add(vo);
                        addCheck = false;
                    }
                    if (StringUtil.isNotBlank(usrDfn4Val) && usrDfn4Val.equals(vo.getUserDefien4()) && addCheck) {
                        newList.add(vo);
                        addCheck = false;
                    }
                    if (StringUtil.isNotBlank(usrDfn5Val) && usrDfn5Val.equals(vo.getUserDefien5()) && addCheck) {
                        newList.add(vo);
                        addCheck = false;
                    }
                }
            }
        }

        return newList;
    }

    @Override
    public String getCodeName(String grpCd, String dtlCd) {
        Map<String, Map<String, String>> codeMap = (Map<String, Map<String, String>>) cacheHandler.getValue(AdminConstants.CACHE_CODE_VALUE);
        String reulst = null;
        if (codeMap != null) {
            Map<String, String> codeValue = codeMap.get(grpCd);
            if (codeValue != null) {
                reulst = codeValue.get(dtlCd);
            }
        }
        return reulst;
    }

}
