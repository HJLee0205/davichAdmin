package net.danvi.dmall.biz.system.util;

import java.util.List;

import net.danvi.dmall.biz.app.seller.model.SellerSO;
import net.danvi.dmall.biz.app.seller.model.SellerVO;
import net.danvi.dmall.biz.app.seller.service.SellerService;
import net.danvi.dmall.biz.common.service.CodeCacheService;
import net.danvi.dmall.biz.system.model.CmnCdDtlVO;
import dmall.framework.common.util.BeansUtil;

public class ServiceUtil {

    public static List<CmnCdDtlVO> listCode(String grpCd) {
        return listCode(grpCd, null, null, null, null, null);
    }

    public static List<CmnCdDtlVO> listCode(String grpCd, String usrDfn1Val, String usrDfn2Val, String usrDfn3Val,
            String usrDfn4Val, String usrDfn5Val) {
        CodeCacheService codeCacheService = BeansUtil.getBean(CodeCacheService.class);
        return codeCacheService.listCodeCache(grpCd, usrDfn1Val, usrDfn2Val, usrDfn3Val, usrDfn4Val, usrDfn5Val);
    }

    public static String getCodeName(String grpCd, String dtlCd) {
        CodeCacheService codeCacheService = BeansUtil.getBean(CodeCacheService.class);
        return codeCacheService.getCodeName(grpCd, dtlCd);
    }
    
    public static List<SellerVO> listSellerCode(SellerSO so) throws Exception {
    	SellerService sellerService = BeansUtil.getBean(SellerService.class);
        return sellerService.getSellerList(so);
    }      
    
    
    
}
