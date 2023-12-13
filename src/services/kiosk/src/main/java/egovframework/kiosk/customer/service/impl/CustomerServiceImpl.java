package egovframework.kiosk.customer.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import egovframework.kiosk.customer.mapper.CustomerMapper;
import egovframework.kiosk.customer.service.CustomerService;
import egovframework.kiosk.customer.vo.Am700tblVO;
import egovframework.kiosk.customer.vo.CustomerVO;
import egovframework.kiosk.customer.vo.MemberVO;
import egovframework.kiosk.customer.vo.SimpleDataOptionVO;
import egovframework.kiosk.customer.vo.SimpleDataVO;
import egovframework.kiosk.customer.vo.StrBookingVO;
import egovframework.kiosk.monitor.mapper.SimpleMonitorMapper;
import egovframework.kiosk.monitor.service.MonitorService;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

@Service("CustomerService")
public class CustomerServiceImpl extends EgovAbstractServiceImpl implements CustomerService{	
	private static final Logger LOGGER = LoggerFactory.getLogger(CustomerServiceImpl.class);
	
	@Resource(name="CustomerMapper")
	private CustomerMapper customerMapper;
	
	@Resource(name="SimpleMonitorMapper")
	private SimpleMonitorMapper simpleMonitorMapper;
	
	@Resource(name="MonitorService")
	private MonitorService monitorService;
	
	
	@Override
	public int selectVisitCount(CustomerVO customerVO) throws Exception{
		return customerMapper.selectVisitCount(customerVO);
	}
	
	@Override
	public List<CustomerVO> selectVisitList(CustomerVO customerVO) throws Exception {
		return customerMapper.selectVisitList(customerVO);
	}
	
	@Override
	public List<CustomerVO> selectNoVisitList(CustomerVO customerVO) throws Exception {
		return customerMapper.selectNoVisitList(customerVO);
	}
	
	@Override
	public int selectMemberCount(CustomerVO customerVO) throws Exception{
		return customerMapper.selectMemberCount(customerVO);
	}	

	@Override
	public List<MemberVO> selectMemberList(CustomerVO customerVO) throws Exception{
		return customerMapper.selectMemberList(customerVO);
	}
	
	@Override
	public int insertStrBoonikg(StrBookingVO strBookingVO) throws Exception{
		return customerMapper.insertStrBoonikg(strBookingVO);
	}

	@Override
	public void updateVisitRsvYN(StrBookingVO strBookingVO) throws Exception{
		customerMapper.updateVisitRsvYN(strBookingVO);
	}

	@Override
	public int countStrBooking(StrBookingVO strBookingVO) throws Exception{
		/*return customerMapper.countStrBooking(strBookingVO);*/
		return simpleMonitorMapper.countKvisionStrBooking(strBookingVO);
	}

	@Override
	public List<StrBookingVO> selectStrBookingList(StrBookingVO strBookingVO) throws Exception{
		return customerMapper.selectStrBookingList(strBookingVO);
	}

	@Override
	public List<StrBookingVO> selectStrBookingListAll(StrBookingVO strBookingVO) throws Exception{
		/*return customerMapper.selectStrBookingListAll(strBookingVO);*/
		return simpleMonitorMapper.selectKvisionStrBookingListAll(strBookingVO);
	}
	
	@Override
	public void updateStrBookingFlag(StrBookingVO strBookingVO) throws Exception{
		customerMapper.updateStrBookingFlag(strBookingVO);
	}
	
	@Override
	public List<StrBookingVO> selectStrBookingListComplete(StrBookingVO strBookingVO) throws Exception{
		//return customerMapper.selectStrBookingListComplete(strBookingVO);
		return simpleMonitorMapper.selectDavichStrBookingListComplete(strBookingVO);
	}
	
	@Override
	public int selectCountStrBookingListTts(StrBookingVO strBookingVO) throws Exception{
		//return customerMapper.selectCountStrBookingListTts(strBookingVO);
		return simpleMonitorMapper.selectDavichCountStrBookingListTts(strBookingVO);
	}
	@Override
	public int insertStrBoonikgTtsList(StrBookingVO strBookingVO) throws Exception{
		int seq_no = Integer.parseInt(strBookingVO.getSeq_no());
		strBookingVO.setSeq_no2(seq_no);
		//return customerMapper.insertStrBoonikgTtsList(strBookingVO);
		return simpleMonitorMapper.insertDavichStrBoonikgTtsList(strBookingVO);
	}
	
	@Override
	public String selectTcMemberCardNo(int member_no) throws Exception{
		return customerMapper.selectTcMemberCardNo(member_no);
	}
	
	@Override
	public String selectDavichCardNo(String mallNoCard) throws Exception{
		return simpleMonitorMapper.selectDavichCardNo(mallNoCard);
	}
	
	@Override
	public int selectDavichVisitCount(CustomerVO customerVO) throws Exception{
		return simpleMonitorMapper.selectDavichVisitCount(customerVO);
	}
	
	@Override
	public List<CustomerVO> selectDavichVisitList(CustomerVO customerVO) throws Exception{
		return simpleMonitorMapper.selectDavichVisitList(customerVO);
	}
	
	@Override
	public int selectDavichCustomerCount(String mobile) throws Exception{
		return simpleMonitorMapper.selectDavichCustomerCount(mobile);
	}
	
	@Override
	public int selectNoMemberCount(CustomerVO customerVO) throws Exception{
		return customerMapper.selectNoMemberCount(customerVO);
	}
	
	@Override
	public List<CustomerVO> selectDavichCustomerList(String mobile) throws Exception{
		return simpleMonitorMapper.selectDavichCustomerList(mobile);
	}
	
	@Override
	public List<MemberVO> selectNoMemberList(CustomerVO customerVO) throws Exception{
		return customerMapper.selectNoMemberList(customerVO);
	}
	
	@Override
	public List<StrBookingVO> selectDavichStrBookingListTTS01(StrBookingVO strBookingVO) throws Exception{
		return simpleMonitorMapper.selectDavichStrBookingListTTS01(strBookingVO);
	}
	
	@Override
	public List<StrBookingVO> selectDavichStrBookingListTTS02(StrBookingVO strBookingVO) throws Exception{
		return simpleMonitorMapper.selectDavichStrBookingListTTS02(strBookingVO);
	}
	
	@Override
	public int selectCountStrBookingListTts01(StrBookingVO strBookingVO) throws Exception{
		return simpleMonitorMapper.selectCountStrBookingListTts01(strBookingVO);
	}
	
	@Override
	public int selectCountStrBookingListTts02(StrBookingVO strBookingVO) throws Exception{
		return simpleMonitorMapper.selectCountStrBookingListTts02(strBookingVO);
	}
	
	@Override
	public int selectCountStrBookingListTts02Dates(StrBookingVO strBookingVO) throws Exception{
		return simpleMonitorMapper.selectCountStrBookingListTts02Dates(strBookingVO);
	}
	
	@Override
	public String deleteStrBookingListTts02(StrBookingVO strBookingVO) throws Exception{
		String result = ""; 
		simpleMonitorMapper.deleteStrBookingListTts02(strBookingVO);
		Am700tblVO am700tblVO = new Am700tblVO();
		am700tblVO.setCtr_code("002");
		am700tblVO.setCtr_id("341");
		Am700tblVO ment = simpleMonitorMapper.selectAm700tbl(am700tblVO);
		result = monitorService.pushInsert(strBookingVO.getCd_cust(),ment.getCtr_desc(),strBookingVO.getStr_code());
		return result;
	}
	
	@Override
	public String updateMallStrBookingTTS_02(StrBookingVO strBookingVO) throws Exception{
		String result = "";
		simpleMonitorMapper.updateMallStrBookingTTS_02(strBookingVO);
		Am700tblVO am700tblVO = new Am700tblVO();
		am700tblVO.setCtr_code("002");
		am700tblVO.setCtr_id("341");
		Am700tblVO ment = simpleMonitorMapper.selectAm700tbl(am700tblVO);
		result = monitorService.pushInsert(strBookingVO.getCd_cust(),ment.getCtr_desc(),strBookingVO.getStr_code());
		return result;
	}
	
	@Override
	public int countDuplicateChck(StrBookingVO strBookingVO) throws Exception{
		return simpleMonitorMapper.countDuplicateChck(strBookingVO);
	}
	
	@Override
	public int selectCountStrBookingListTts01Dates(StrBookingVO strBookingVO) throws Exception{
		return simpleMonitorMapper.selectCountStrBookingListTts01Dates(strBookingVO);
	}
	//백업
	/*@Override
	public String deleteStrBookingListTts01(StrBookingVO strBookingVO) throws Exception{
		String result = ""; 
		simpleMonitorMapper.deleteStrBookingListTts01(strBookingVO);
		Am700tblVO am700tblVO = new Am700tblVO();
		am700tblVO.setCtr_code("001");
		am700tblVO.setCtr_id("341");
		Am700tblVO ment = simpleMonitorMapper.selectAm700tbl(am700tblVO);
		result = monitorService.pushInsert(strBookingVO.getCd_cust(),ment.getCtr_desc(),strBookingVO.getStr_code());
		return result;
	}*/
	@Override
	public String deleteStrBookingListTts01(StrBookingVO strBookingVO) throws Exception{
		String result = ""; 
		simpleMonitorMapper.deleteStrBookingListTts02(strBookingVO);
		Am700tblVO am700tblVO = new Am700tblVO();
		am700tblVO.setCtr_code("001");
		am700tblVO.setCtr_id("341");
		Am700tblVO ment = simpleMonitorMapper.selectAm700tbl(am700tblVO);
		result = monitorService.pushInsert(strBookingVO.getCd_cust(),ment.getCtr_desc(),strBookingVO.getStr_code());
		return result;
	}
	
	@Override
	public List<StrBookingVO> selectDavichStrBookingListTTS04(StrBookingVO strBookingVO) throws Exception{
		return simpleMonitorMapper.selectDavichStrBookingListTTS04(strBookingVO);
	}
	
	@Override
	public int selectCountStrBookingListTts04(StrBookingVO strBookingVO) throws Exception{
		return simpleMonitorMapper.selectCountStrBookingListTts04(strBookingVO);
	}
	
	@Override
	public int selectTestStoreCount(String storeCode) throws Exception{
		return simpleMonitorMapper.selectTestStoreCount(storeCode);
	}
	
	@Override
	public List<SimpleDataVO> selectSimpleData(SimpleDataVO simpleDataVO) throws Exception{
		return simpleMonitorMapper.selectSimpleData(simpleDataVO);
	}
	
	@Override
	public int selectSimpleDataCount(SimpleDataVO simpleDataVO) throws Exception{
		return simpleMonitorMapper.selectSimpleDataCount(simpleDataVO);
	}
	
	@Override
	public int selectAm010tblTestCount(SimpleDataVO simpleDataVO) throws Exception{
		return simpleMonitorMapper.selectAm010tblTestCount(simpleDataVO);
	}
	
	@Override
	public SimpleDataOptionVO selectSimpleDataOptionList(SimpleDataOptionVO simpleDataOptionVO) throws Exception{
		return simpleMonitorMapper.selectSimpleDataOptionList(simpleDataOptionVO);
	}
	
	@Override
	public int selectSimpleDataOptionCount(SimpleDataOptionVO simpleDataOptionVO) throws Exception{
		return simpleMonitorMapper.selectSimpleDataOptionCount(simpleDataOptionVO);
	}
	
	@Override
	public void insertSimpleDataOption(SimpleDataOptionVO simpleDataOptionVO) throws Exception{
		int count = simpleMonitorMapper.selectSimpleDataOptionCount(simpleDataOptionVO);
		if(count > 0){
			simpleMonitorMapper.updateSimpleDataOption(simpleDataOptionVO);
		}else{
			simpleMonitorMapper.insertSimpleDataOption(simpleDataOptionVO);
		}
	}
	
	@Override
	public List<SimpleDataVO> selectSimpleData_test(SimpleDataVO simpleDataVO) throws Exception{
		return simpleMonitorMapper.selectSimpleData_test(simpleDataVO);
	}
	
	@Override
	public int selectSimpleDataCount_test(SimpleDataVO simpleDataVO) throws Exception{
		return simpleMonitorMapper.selectSimpleDataCount_test(simpleDataVO);
	}

	//2022 03 08 예약,as,수령 화면 구분자
	@Override
	public List<SimpleDataVO> nullJudg(SimpleDataVO simpleDataVO) throws Exception{
		return simpleMonitorMapper.nullJudg(simpleDataVO);
	}
}
