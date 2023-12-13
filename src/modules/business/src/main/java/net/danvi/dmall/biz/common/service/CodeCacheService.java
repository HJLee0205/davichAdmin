package net.danvi.dmall.biz.common.service;

import net.danvi.dmall.biz.system.model.CmnCdDtlVO;

import java.util.List;

/**
 * Web service
 * @author	snw
 * @since	    2013.09.02
 */

public interface CodeCacheService {

	public List<CmnCdDtlVO> listCodeCache(String grpCd);

	public List<CmnCdDtlVO> listCodeCache(String grpCd, String usrDfn1Val, String usrDfn2Val, String usrDfn3Val, String usrDfn4Val, String usrDfn5Val);

	public String getCodeName(String grpCd, String dtlCd);

}