package egovframework.kiosk.manager.mapper;

import java.util.List;

import egovframework.kiosk.manager.vo.BannerVO;
import egovframework.rte.psl.dataaccess.mapper.Mapper;

@Mapper("ManagerMapper")
public interface ManagerMapper {
	//메인배너 목록
	List<BannerVO> selectBookingMainBannerList(BannerVO bannerVO) throws Exception;
	//설정 배너목록
	List<BannerVO> selectBookingBannerList(BannerVO bannerVO) throws Exception;
	//배너정보
	BannerVO selectBookingBanner(BannerVO bannerVO) throws Exception;
	//배너등록
	int insertBookingBanner(BannerVO bannerVO) throws Exception;
	//배너 업데이트
	int updateBookingBanner(BannerVO bannerVO) throws Exception;
	//배너 삭제
	int deleteBookingBanner(BannerVO bannerVO) throws Exception;
	//배너 메인에 보이기 설정
	int updateBookingBannerIsView(BannerVO bannerVO) throws Exception;
}
