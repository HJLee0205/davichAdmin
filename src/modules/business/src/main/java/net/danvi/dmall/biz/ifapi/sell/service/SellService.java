package net.danvi.dmall.biz.ifapi.sell.service;

import java.util.List;

import net.danvi.dmall.biz.ifapi.sell.dto.OfflineBuyInfoReqDTO;
import net.danvi.dmall.biz.ifapi.sell.dto.OfflineBuyInfoResDTO.OfflineBuyInfoDTO;
import net.danvi.dmall.biz.ifapi.sell.dto.OfflineRecvCompReqDTO;

/**
 * <pre>
 * - 프로젝트명    : davichmall_interface
 * - 패키지명      : net.danvi.dmall.admin.ifapi.sell.service
 * - 파일명        : SellService.java
 * - 작성일        : 2018. 5. 17.
 * - 작성자        : CBK
 * - 설명          : [판매]분류의 인터페이스 처리를 위한 Service Interface
 * </pre>
 */
public interface SellService {
	
	/**
	 * <pre>
	 * 작성일 : 2018. 6. 14.
	 * 작성자 : CBK
	 * 설명   : 고객판매완료 (구매확정처리)
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 6. 14. CBK - 최초생성
	 * </pre>
	 *
	 * @param param
	 * @throws Exception
	 */
	void completeOfflineRecv(OfflineRecvCompReqDTO param) throws Exception;
	
	/**
	 * <pre>
	 * 작성일 : 2018. 5. 17.
	 * 작성자 : CBK
	 * 설명   : 오프라인 구매 목록 조회
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 5. 17. CBK - 최초생성
	 * </pre>
	 *
	 * @return 
	 * @throws Exception
	 */
	List<OfflineBuyInfoDTO> selectOfflineBuyInfoList(OfflineBuyInfoReqDTO param) throws Exception;
	
	/**
	 * <pre>
	 * 작성일 : 2018. 5. 18.
	 * 작성자 : CBK
	 * 설명   : 오프라인 구매 목록 데이터 개수 조회
	 *
	 * 수정내역(수정일 수정자 - 수정내용)
	 * -------------------------------------------------------------------------
	 * 2018. 5. 18. CBK - 최초생성
	 * </pre>
	 *
	 * @return
	 * @throws Exception
	 */
	int countOfflineBuyInfoList(OfflineBuyInfoReqDTO param) throws Exception;
}
