package net.danvi.dmall.admin.webservice.service;

import net.danvi.dmall.webservice.model.GoodsPO;
import net.danvi.dmall.webservice.model.GoodsVO;

import javax.jws.WebMethod;
import javax.jws.WebParam;
import javax.jws.WebResult;
import javax.jws.WebService;
import javax.jws.soap.SOAPBinding;

@WebService
@SOAPBinding(style = SOAPBinding.Style.RPC, use = SOAPBinding.Use.LITERAL)
public interface GoodsAddService {
    @WebResult(name = "RESULT")
    @WebMethod(action = "insertGoods")
    GoodsVO insertGoods(@WebParam(name = "goodsInfo") GoodsPO goodsInfo);

}


