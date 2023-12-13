package net.danvi.dmall.biz.app.hearingaid.service;

import java.util.List;

import net.danvi.dmall.biz.app.hearingaid.model.HearingaidCheckVO;
import net.danvi.dmall.biz.app.hearingaid.model.HearingaidStep1VO;
import net.danvi.dmall.biz.app.hearingaid.model.HearingaidVO;

/**
 * <pre>
 * - 프로젝트명    : 31.front.web
 * - 작성일        : 2019. 1. 8.
 * - 작성자        : yji
 * </pre>
 */
public interface HearingaidService {
	public List<HearingaidStep1VO> selectHearingaidStep1(HearingaidStep1VO hearingaidStep1VO);
	public List<HearingaidVO> selectHearingaidRecommend(HearingaidVO hearingaidVO);
	public void deleteHearingaidCheck(HearingaidCheckVO vo);
	public void insertHearingaidCheck(HearingaidCheckVO vo);
	public List<HearingaidCheckVO> selectHearingaidCheckList (HearingaidCheckVO vo);
}
