package net.danvi.dmall.admin.webservice.service;

import dmall.framework.common.BaseService;
import dmall.framework.common.constants.ExceptionConstants;
import dmall.framework.common.util.CryptoUtil;
import dmall.framework.common.util.MessageUtil;
import lombok.extern.slf4j.Slf4j;
import net.danvi.dmall.biz.system.login.service.LoginService;
import net.danvi.dmall.biz.system.model.LoginVO;
import net.danvi.dmall.webservice.model.BrandPO;
import net.danvi.dmall.webservice.model.BrandVO;


import javax.annotation.Resource;
import javax.jws.WebService;
import java.util.List;

/*
* http://id1.test.com/admin/service/BrandInfo?wsdl
* http://davichmarket.co.kr/admin/service/BrandInfo?wsdl
* http://davichmarket.com/admin/service/BrandInfo?wsdl
* */
@Slf4j
@WebService(endpointInterface = "net.danvi.dmall.admin.webservice.service.BrandInfoService")
public class BrandInfoServiceImpl extends BaseService implements BrandInfoService {

    @Resource(name = "loginService")
    private LoginService loginService;


    @Override
        public BrandVO selectBrandInfo(BrandPO ctgInfo) {
        BrandVO result = new BrandVO();
        /** 데이터 검증 */
        // 셀러 로그인 아이디와 비밀번호 체크
        LoginVO user = new LoginVO();
        user.setLoginId(ctgInfo.getSELLER_ID());
        user.setSiteNo(1L);
        user = loginService.getUser(user);
        ctgInfo.setSellerNo(String.valueOf(user.getMemberNo()));
        if (user.getPw().equals(CryptoUtil.encryptSHA512(ctgInfo.getSELLER_PW()))) {
            ctgInfo.setSiteNo(1L);
            List<BrandVO> brandList = proxyDao.selectList("system.link.sabangnet." + "selectBrandInfoList",ctgInfo);
                        result.setSTATUS("OK");
            result.setMESSAGE("정상적으로 처리되었습니다.");
            result.setBRAND_LIST(brandList);


        }else{
            result.setSTATUS("fail");
            result.setMESSAGE(MessageUtil.getMessage(ExceptionConstants.BIZ_EXCEPTION_LNG + ExceptionConstants.ERROR_CODE_WRONG_PASSWORD));
            return  result;
        }



        return result;

    }

}
