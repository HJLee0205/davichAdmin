package net.danvi.dmall.admin.webservice.service;


import net.danvi.dmall.webservice.model.CtgPO;
import net.danvi.dmall.webservice.model.CtgVO;

import javax.jws.WebMethod;
import javax.jws.WebParam;
import javax.jws.WebResult;
import javax.jws.WebService;
import javax.jws.soap.SOAPBinding;

@WebService
@SOAPBinding(style = SOAPBinding.Style.RPC)
public interface CategoryInfoService {

    @WebResult(name = "RESULT")
    @WebMethod(action = "selectCategoryInfo")
    CtgVO selectCategoryInfo(@WebParam(name = "ctgInfo") CtgPO ctgInfo) throws Exception ;

}


