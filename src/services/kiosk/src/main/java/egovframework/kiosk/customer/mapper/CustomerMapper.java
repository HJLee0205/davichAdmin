package egovframework.kiosk.customer.mapper;

import java.util.List;

import egovframework.kiosk.customer.vo.CustomerVO;
import egovframework.kiosk.customer.vo.MemberVO;
import egovframework.kiosk.customer.vo.StrBookingVO;
import egovframework.rte.psl.dataaccess.mapper.Mapper;

@Mapper("CustomerMapper")
public interface CustomerMapper {
	//방문예약 카운트
	int selectVisitCount(CustomerVO customerVO) throws Exception;
	//방문예약 목록
	List<CustomerVO> selectVisitList(CustomerVO customerVO) throws Exception;
	
	List<CustomerVO> selectNoVisitList(CustomerVO customerVO) throws Exception;
	
	//회원카운트
	int selectMemberCount(CustomerVO customerVO) throws Exception;
	//회원정보 목록
	List<MemberVO> selectMemberList(CustomerVO customerVO) throws Exception;
	
	//매장 방문자 정보 등록
	int insertStrBoonikg(StrBookingVO strBookingVO) throws Exception;
	//방문예약 처리
	void updateVisitRsvYN(StrBookingVO strBookingVO) throws Exception;
	//오늘 매장방문자 카운트
	int countStrBooking(StrBookingVO strBookingVO) throws Exception;
	//오늘매장 방문자 목록(패이징)
	List<StrBookingVO> selectStrBookingList(StrBookingVO strBookingVO) throws Exception;
	//오늘매장방문자 목록 전체
	List<StrBookingVO> selectStrBookingListAll(StrBookingVO strBookingVO) throws Exception;
	//매장방문 처리
	void updateStrBookingFlag(StrBookingVO strBookingVO) throws Exception;
	
	//오늘안경완성자 목록
	List<StrBookingVO> selectStrBookingListComplete(StrBookingVO strBookingVO) throws Exception;
	
	//TTS 음성 부른사람 있나 확인
	int selectCountStrBookingListTts(StrBookingVO strBookingVO) throws Exception;
	
	//TTS 음성 부른사람 등록
	int insertStrBoonikgTtsList(StrBookingVO strBookingVO) throws Exception;
	
	String selectTcMemberCardNo (int member_no)throws Exception;
	
	int selectNoMemberCount(CustomerVO customerVO) throws Exception;
	
	List<MemberVO> selectNoMemberList(CustomerVO customerVO) throws Exception;

}
