package net.danvi.dmall.biz.app.eyesight.service;

import java.util.HashMap;
import java.util.Map;

import org.springframework.stereotype.Service;

import dmall.framework.common.BaseService;
import dmall.framework.common.constants.MapperConstants;
import lombok.extern.slf4j.Slf4j;
import net.danvi.dmall.biz.app.eyesight.model.EyesightPO;
import net.danvi.dmall.biz.app.eyesight.model.EyesightVO;
import net.danvi.dmall.biz.system.util.InterfaceUtil;

/**
 * <pre>
 * - 프로젝트명    : 03.business
 * - 패키지명      : net.danvi.dmall.biz.app.eyesight.service
 * - 파일명        : EyesightServiceImpl.java
 * - 작성일        : 2018. 7. 6.
 * - 작성자        : CBK
 * - 설명          : 마이페이지 - 시력 처리 Service 
 * </pre>
 */
@Slf4j
@Service("eyesightService")
public class EyesightServiceImpl extends BaseService implements EyesightService {

	/**
	 * 시력정보 조회
	 */
	@Override
	public EyesightVO selectEyesightInfo(Long memberNo) throws Exception {
		
		EyesightVO vo = proxyDao.selectOne(MapperConstants.EYESIGHT + "selectEyesightInfo", memberNo);
		
		if(vo != null) {
			//SPH
			vo.setSphR(maskWord(vo.getSphR()));
			vo.setSphL(maskWord(vo.getSphL()));
			//CYL
			vo.setCylR(maskWord(vo.getCylR()));
			vo.setCylL(maskWord(vo.getCylL()));
			//AXIS
			vo.setAxisR(maskWord(vo.getAxisR()));
			vo.setAxisL(maskWord(vo.getAxisL()));
			//PRISM
			vo.setPrismR(maskWord(vo.getPrismR()));
			vo.setPrismL(maskWord(vo.getPrismL()));
			//BASE
			vo.setBaseR(maskWord(vo.getBaseR()));
			vo.setBaseL(maskWord(vo.getBaseL()));
			//ADD
			vo.setAddR(maskWord(vo.getAddR()));
			vo.setAddL(maskWord(vo.getAddL()));
			//PD
			vo.setPdR(maskWord(vo.getPdR()));
			vo.setPdL(maskWord(vo.getPdL()));
		}
        
		return vo;
	}
	
	/**
	 * 시력정보 등록/수정
	 */
	@Override
	public void insertOrUpdateEyesightInfo(EyesightPO po) throws Exception {
		// 기존 데이터 존재 여부 확인
		int cnt = proxyDao.selectOne(MapperConstants.EYESIGHT + "countEyesightInfo", po.getMemberNo());
		if(cnt > 0) {
			// 기존 데이터가 있으면 수정
			proxyDao.update(MapperConstants.EYESIGHT + "updateEyesightInfo", po);
		} else {
			// 기존 데이터가 없으면 등록
			proxyDao.insert(MapperConstants.EYESIGHT + "insertEyesightInfo", po);
			
		}
	}

	/**
	 * 통합회원 여부 확인
	 */
	@Override
	public boolean checkCombinedMember(Long memberNo) throws Exception {
		return proxyDao.selectOne(MapperConstants.MEMBER_INFO + "checkMemberCombined", memberNo).equals("Y") ? true : false;
	}

	/**
	 * 안경점(다비젼) 시력 정보 조회
	 */
	@Override
	public Map<String, Object> getStoreEyesightInfo(Long memberNo) throws Exception {
		Map<String, Object> param = new HashMap<>();
		param.put("memNo", memberNo);
		return InterfaceUtil.send("IF_MEM_012", param);
	}
	
	private String maskWord(String str) {
		if("".equals(str) || str == null ) return "";
				
        String newStr = "";
        boolean dot = false;
        if(str.contains(".")) {
	        for(int i=0;i<str.length();i++) {
	        	if(dot) newStr += "*";
	        	else newStr += str.charAt(i);
	        	
	        	if(str.charAt(i) == '.') {
	        		dot = true;
	        	}
	        }
        }else {
        	newStr = "**";
        }
        
        return newStr;
	}
	
}
