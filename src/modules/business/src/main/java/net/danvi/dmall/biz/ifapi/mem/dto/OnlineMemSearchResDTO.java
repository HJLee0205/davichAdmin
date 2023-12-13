package net.danvi.dmall.biz.ifapi.mem.dto;

import java.util.List;

import net.danvi.dmall.biz.ifapi.cmmn.base.BaseResDTO;

import dmall.framework.common.annotation.Encrypt;
import dmall.framework.common.util.CryptoUtil;
import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * <pre>
 * - 프로젝트명    : davichmall_interface
 * - 패키지명      : net.danvi.dmall.admin.ifapi.mem.dto
 * - 파일명        : OnlineMemSearchResDTO.java
 * - 작성일        : 2018. 5. 24.
 * - 작성자        : CBK
 * - 설명          : 온라인 회원 조회시 사용하는 응답 DTO (오프라인->온라인 조회시)
 * </pre>
 */
@Data
@EqualsAndHashCode(callSuper=false)
public class OnlineMemSearchResDTO extends BaseResDTO {

	/**
	 * 회원정보 목록
	 */
	 private List<OnlineMemInfo> memList;
	
	/**
	 * <pre>
	 * - 프로젝트명    : davichmall_interface
	 * - 패키지명      : net.danvi.dmall.admin.ifapi.mem.dto
	 * - 파일명        : OnlineMemSearchResDTO.java
	 * - 작성일        : 2018. 5. 24.
	 * - 작성자        : CBK
	 * - 설명          : 온라인 회원 조회시 사용되는 회원정보 DTO
	 * </pre>
	 */
	@Data
	public static class OnlineMemInfo {
		/**
		 * 쇼핑몰 회원번호
		 */
		private String memNo;
		
		/**
		 * 쇼핑몰 사용자 ID
		 */
		@Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
		private String mallUserId;
		
		/**
		 * 이름
		 */
		@Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
		private String memName;
		
		/**
		 * 휴대폰번호
		 */
		@Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
		private String hp;
		
		/**
		 * 전화번호
		 */
		@Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
		private String tel;
		
		/**
		 * 성별 [M/F]
		 */
		@Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
		private String gender;
		
		/**
		 * 생년월일
		 */
		@Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
		private String birthDay;
		
		/**
		 * 우편번호
		 */
		@Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
		private String postNo;
		
		/**
		 * 주소(도로명주소)
		 */
		@Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
		private String address1;
		
		/**
		 * 상세주소
		 */
		@Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
		private String address2;
		
		/**
		 * 온라인 카드 번호
		 */
		private String onlineCardNo;
		
		/**
		 * 회원 통합 여부
		 */
        @Encrypt(type = CryptoUtil.CHIPER, algorithm = CryptoUtil.CHIPER_AES)
		private String combineYn;
		
		/**
		 * 다비젼고객코드
		 */
		private String cdCust;
	}
}
