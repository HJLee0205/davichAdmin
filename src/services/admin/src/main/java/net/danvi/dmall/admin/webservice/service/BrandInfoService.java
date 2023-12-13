package net.danvi.dmall.admin.webservice.service;

import net.danvi.dmall.webservice.model.BrandPO;
import net.danvi.dmall.webservice.model.BrandVO;

import javax.jws.WebMethod;
import javax.jws.WebParam;
import javax.jws.WebResult;
import javax.jws.WebService;
import javax.jws.soap.SOAPBinding;

@WebService
@SOAPBinding(style = SOAPBinding.Style.RPC, use = SOAPBinding.Use.LITERAL)
public interface BrandInfoService {

    @WebResult(name = "RESULT")
    @WebMethod(action = "selectBrandInfo")
    BrandVO selectBrandInfo(@WebParam(name = "brandInfo") BrandPO brandInfo);
}


