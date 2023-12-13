package egovframework.kiosk.manager.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import egovframework.kiosk.manager.mapper.ManagerMapper;
import egovframework.kiosk.manager.service.ManagerService;
import egovframework.kiosk.manager.vo.BannerVO;
import egovframework.kiosk.manager.vo.LoginVO;
import egovframework.kiosk.monitor.mapper.SimpleMonitorMapper;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

@Service("ManagerService")
public class ManagerServiceImpl  extends EgovAbstractServiceImpl implements ManagerService{
	private static final Logger LOGGER = LoggerFactory.getLogger(ManagerServiceImpl.class);
	
	@Resource(name="ManagerMapper")
	private ManagerMapper managerMapper;
	
	@Resource(name="SimpleMonitorMapper")
	private SimpleMonitorMapper simpleMonitorMapper;	

	@Override
	public List<BannerVO> selectBookingMainBannerList(BannerVO bannerVO) throws Exception{
		return managerMapper.selectBookingMainBannerList(bannerVO);
	}
	
	@Override
	public List<BannerVO> selectBookingBannerList(BannerVO bannerVO) throws Exception{
		return managerMapper.selectBookingBannerList(bannerVO);
	}
	
	@Override
	public BannerVO selectBookingBanner(BannerVO bannerVO) throws Exception{
		return managerMapper.selectBookingBanner(bannerVO);
	}
	
	@Override
	public int insertBookingBanner(BannerVO bannerVO) throws Exception{
		return managerMapper.insertBookingBanner(bannerVO);
	}
	
	@Override
	public int updateBookingBanner(BannerVO bannerVO) throws Exception{
		return managerMapper.updateBookingBanner(bannerVO);
	}

	@Override
	public int deleteBookingBanner(BannerVO bannerVO) throws Exception{
		return managerMapper.deleteBookingBanner(bannerVO);
	}

	@Override
	public int updateBookingBannerIsView(BannerVO bannerVO) throws Exception{
		return managerMapper.updateBookingBannerIsView(bannerVO);
	}
	
	@Override
	public int selectAm030tbl8888(LoginVO loginVO) throws Exception{
		return simpleMonitorMapper.selectAm030tbl8888(loginVO);
	}
}
