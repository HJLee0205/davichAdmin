package egovframework.kiosk.customer.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import egovframework.kiosk.customer.mapper.CustomerMapper;
import egovframework.kiosk.customer.service.CustomerDavichService;
import egovframework.kiosk.customer.service.CustomerService;
import egovframework.kiosk.customer.vo.CustomerVO;
import egovframework.kiosk.customer.vo.MemberVO;
import egovframework.kiosk.customer.vo.StrBookingVO;
import egovframework.kiosk.monitor.mapper.SimpleMonitorMapper;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

@Service("CustomerDavichService")
public class CustomerDavichServiceImpl extends EgovAbstractServiceImpl implements CustomerDavichService{	
	private static final Logger LOGGER = LoggerFactory.getLogger(CustomerDavichServiceImpl.class);
	
	@Resource(name="SimpleMonitorMapper")
	private SimpleMonitorMapper simpleMonitorMapper;
	
	@Override
	public int countDavichStrBooking(StrBookingVO strBookingVO) throws Exception{
		return simpleMonitorMapper.countDavichStrBooking(strBookingVO);
	}
	
	@Override
	public List<StrBookingVO> selectStrDavichBookingList(StrBookingVO strBookingVO) throws Exception{
		return simpleMonitorMapper.selectStrDavichBookingList(strBookingVO);
	}
	
	@Override
	public List<StrBookingVO> selectStrDavichBookingMobileList(StrBookingVO strBookingVO) throws Exception{
		return simpleMonitorMapper.selectStrDavichBookingMobileList(strBookingVO);
	}
}
