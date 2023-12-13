package egovframework.kiosk.manager.service;

import java.util.List;

import egovframework.kiosk.manager.vo.BannerVO;
import egovframework.kiosk.manager.vo.LoginVO;

public interface ManagerService {
	List<BannerVO> selectBookingMainBannerList(BannerVO bannerVO) throws Exception;	
	List<BannerVO> selectBookingBannerList(BannerVO bannerVO) throws Exception;
	BannerVO selectBookingBanner(BannerVO bannerVO) throws Exception;
	int insertBookingBanner(BannerVO bannerVO) throws Exception;
	int updateBookingBanner(BannerVO bannerVO) throws Exception;
	int deleteBookingBanner(BannerVO bannerVO) throws Exception;
	int updateBookingBannerIsView(BannerVO bannerVO) throws Exception;
	int selectAm030tbl8888(LoginVO loginVO) throws Exception;
}
