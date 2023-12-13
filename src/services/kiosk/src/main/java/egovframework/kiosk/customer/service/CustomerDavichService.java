package egovframework.kiosk.customer.service;

import java.util.List;

import egovframework.kiosk.customer.vo.StrBookingVO;

public interface CustomerDavichService {
	int countDavichStrBooking(StrBookingVO strBookingVO) throws Exception;
	
	List<StrBookingVO> selectStrDavichBookingList(StrBookingVO strBookingVO) throws Exception;
	
	List<StrBookingVO> selectStrDavichBookingMobileList(StrBookingVO strBookingVO) throws Exception;
}
