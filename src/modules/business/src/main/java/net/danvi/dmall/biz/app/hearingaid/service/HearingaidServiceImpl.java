package net.danvi.dmall.biz.app.hearingaid.service;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import dmall.framework.common.BaseService;
import dmall.framework.common.constants.MapperConstants;
import lombok.extern.slf4j.Slf4j;
import net.danvi.dmall.biz.app.hearingaid.model.HearingaidCheckVO;
import net.danvi.dmall.biz.app.hearingaid.model.HearingaidStep1VO;
import net.danvi.dmall.biz.app.hearingaid.model.HearingaidVO;
import net.danvi.dmall.biz.app.vision.service.VisionCheckServiceImpl;

/**
 * <pre>
 * - 프로젝트명    : 31.front.web
 * - 작성일        : 2019. 1. 8.
 * - 작성자        : yji
 * </pre>
 */
@Slf4j
@Service("hearingaidService")
@Transactional(rollbackFor = Exception.class)
public class HearingaidServiceImpl extends BaseService implements HearingaidService{
	@Override
	public List<HearingaidStep1VO> selectHearingaidStep1(HearingaidStep1VO vo){
		return proxyDao.selectList(MapperConstants.HEARING_AID + "selectHearingaidStep1", vo);
	}
	
	@Override
	public List<HearingaidVO> selectHearingaidRecommend(HearingaidVO vo){
		return proxyDao.selectList(MapperConstants.HEARING_AID + "selectHearingaidRecommend", vo);
	}
	
	@Override
	public void deleteHearingaidCheck(HearingaidCheckVO vo) {
		proxyDao.delete(MapperConstants.HEARING_AID + "deleteHearingaidCheck", vo);
	}
	
	@Override
	public void insertHearingaidCheck(HearingaidCheckVO vo) {
		proxyDao.insert(MapperConstants.HEARING_AID + "insertHearingaidCheck", vo);
	}	
	
	@Override
	public List<HearingaidCheckVO> selectHearingaidCheckList (HearingaidCheckVO vo){
		return proxyDao.selectList(MapperConstants.HEARING_AID + "selectHearingaidCheckList", vo);
	}
	
}
