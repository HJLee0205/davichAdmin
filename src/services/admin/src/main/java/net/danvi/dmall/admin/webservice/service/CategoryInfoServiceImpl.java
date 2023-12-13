package net.danvi.dmall.admin.webservice.service;

import dmall.framework.common.BaseService;
import dmall.framework.common.constants.ExceptionConstants;
import dmall.framework.common.util.CryptoUtil;
import dmall.framework.common.util.MessageUtil;
import lombok.extern.slf4j.Slf4j;
import net.danvi.dmall.biz.system.login.service.LoginService;
import net.danvi.dmall.biz.system.model.LoginVO;
import net.danvi.dmall.webservice.model.CtgPO;
import net.danvi.dmall.webservice.model.CtgVO;

import javax.annotation.Resource;
import javax.jws.WebService;
import java.util.List;
import org.jdom2.Element;

/*
* http://id1.test.com/admin/service/CategoryInfo?wsdl
* http://davichmarket.co.kr/admin/service/CategoryInfo?wsdl
* http://davichmarket.com/admin/service/CategoryInfo?wsdl
* */
@Slf4j
@WebService(endpointInterface = "net.danvi.dmall.admin.webservice.service.CategoryInfoService")
public class CategoryInfoServiceImpl extends BaseService implements CategoryInfoService {

    @Resource(name = "loginService")
    private LoginService loginService;


    @Override
    public CtgVO selectCategoryInfo(CtgPO ctgInfo) throws Exception{
        CtgVO result = new CtgVO();
        /** 데이터 검증 */
        // 셀러 로그인 아이디와 비밀버호 체크
        LoginVO user = new LoginVO();
        user.setLoginId(ctgInfo.getSELLER_ID());
        user.setSiteNo(1L);
        user = loginService.getUser(user);
        ctgInfo.setSellerNo(String.valueOf(user.getMemberNo()));
        if (user.getPw().equals(CryptoUtil.encryptSHA512(ctgInfo.getSELLER_PW()))) {
            ctgInfo.setSiteNo(1L);
            List<CtgVO> ctgList = proxyDao.selectList("system.link.sabangnet." + "selectCategoryInfoList",ctgInfo);
            // 카테고리 조회
            //Element data = new Element("DATA");

          /*  for (CtgVO ctgVO : ctgList) {
                Element element = new Element(elementName);
                element.setText(value);
                data.addContent(element);
            }*/

            result.setSTATUS("OK");
            result.setMESSAGE("정상적으로 처리되었습니다.");
            result.setCTG_LIST(ctgList);


        }else{
            result.setSTATUS("fail");
            result.setMESSAGE(MessageUtil.getMessage(ExceptionConstants.BIZ_EXCEPTION_LNG + ExceptionConstants.ERROR_CODE_WRONG_PASSWORD));
            return  result;
        }



        return result;

    }

}
