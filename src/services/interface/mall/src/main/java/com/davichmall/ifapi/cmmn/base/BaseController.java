package com.davichmall.ifapi.cmmn.base;

import com.davichmall.ifapi.cmmn.CustomException;
import com.davichmall.ifapi.cmmn.constant.Constants;
import com.davichmall.ifapi.cmmn.mapp.service.MappingService;
import com.davichmall.ifapi.cmmn.service.LogService;
import com.davichmall.ifapi.util.IFCryptoUtil;
import com.davichmall.ifapi.util.IFMessageUtil;
import com.davichmall.ifapi.util.SendUtil;
import lombok.extern.slf4j.Slf4j;
import net.sf.json.JSONObject;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import java.io.PrintWriter;
import java.io.StringWriter;

/**
 * <pre>
 * - 프로젝트명    : davichmall_interface
 * - 패키지명      : com.davichmall.ifapi.cmmn.base
 * - 파일명        : BaseController.java
 * - 작성일        : 2018. 5. 18.
 * - 작성자        : CBK
 * - 설명          :  Global Exception Handling 및 공통요소를 위한 Controller. Controller들은 BaseController를 상속받는다.
 * </pre>
 */
@RequestMapping(produces="application/json; charset=utf-8")
@Slf4j
public class BaseController {
	
	@Resource(name="logService")
	public LogService logService;
	
	@Resource(name="sendUtil")
	public SendUtil sendUtil;
	
	@Resource(name="mappingService")
	public MappingService mappingService;

	public void printException(Exception e){
		StringWriter sw = new StringWriter();
		e.printStackTrace(new PrintWriter(sw));
		String exceptionAsString = sw.toString();
		log.error(exceptionAsString);
	}

	/**
	 * <pre>
	 * 작성일 : 2018. 5. 18.
	 * 작성자 : CBK
	 * 설명   : Global Exception Handler
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 5. 18. CBK - 최초생성
	 * </pre>
	 *
	 * @return
	 * @throws Exception
	 */
	@ExceptionHandler(Exception.class)
	@ResponseBody
	public String handleCustomException(Exception e) {
		BaseResDTO resDto = new BaseResDTO();
		resDto.setResult(Constants.RESULT.FAILURE);

		if ( e instanceof CustomException ) {
			CustomException ce = (CustomException) e;
			if (ce.getOrigException() == null) {
				printException(ce);
				resDto.setMessage(ce.getMessage());
			} else {
				printException(ce.getOrigException());
				resDto.setMessage(IFMessageUtil.getMessage("ifapi.exception.common"));
			}

			if (ce.getIfId() != null) {
				try {
					// 로그 저장
					logService.writeInterfaceLog(ce.getIfId(), ce.getReqParam(), resDto, ce);
				} catch (Exception le) {
					log.error("Interface log write Failed!");
				}
			}

			try {
				return toJsonRes(resDto, ce.getReqParam());
			} catch(Exception ne) {
				return JSONObject.fromObject(resDto).toString();
			}
		} else {
			resDto.setMessage(e.getMessage());
			return JSONObject.fromObject(resDto).toString();
		}
	}


	/**
	 * <pre>
	 * 작성일 : 2018. 6. 27.
	 * 작성자 : CBK
	 * 설명   : ResponseDTO를 JSON으로 변환하고 암호화 하여 반환
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 6. 27. CBK - 최초생성
	 * </pre>
	 *
	 * @param resDto
	 * @return
	 * @throws Exception
	 */
	protected String toJsonRes(Object resDto, BaseReqDTO reqDto) throws Exception {
		if(reqDto.isFromIF()) {
			// 인터페이스에서 온것은 암호화
			return IFCryptoUtil.encryptAES(JSONObject.fromObject(resDto).toString());
		} else {
			// 인터페이스에서 온게 아니면 암호화 안하고 반환
			return JSONObject.fromObject(resDto).toString();
		}
	}
}
