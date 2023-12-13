package com.davichmall.ifapi.mem.dto;

import com.davichmall.ifapi.cmmn.base.BaseReqDTO;

import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * <pre>
 * - 프로젝트명    : davichmall_interface
 * - 패키지명      : com.davichmall.ifapi.mem.dto
 * - 파일명        : StoreMemberJoinReqDTO.java
 * - 작성일        : 2018. 9. 7.
 * - 작성자        : CBK
 * - 설명          : 매장에서 쇼핑몰 회원 가입 요청 DTO
 * </pre>
 */
@Data
@EqualsAndHashCode(callSuper=false)
public class StoreMemberJoinReqDTO extends BaseReqDTO {

	/**
	 * 회원ID
	 * */
	private String memberId;

	/**
	 * 회원명
	 */
	private String memberName;
	
	/**
	 * 성별
	 */
	private String gender;
	
	/**
	 * 생념월일
	 */
	private String birth;
	
	/**
	 * 이메일주소
	 */
	private String email;
	
	/**
	 * 휴대폰번호
	 */
	private String hp;
	
	/**
	 * 우편번호
	 */
	private String zipcode;
	
	/**
	 * 주소1
	 */
	private String address1;
	
	/**
	 * 주소2
	 */
	private String address2;
	
	/**
	 * 마케팅 수신동의 - 이메일수신여부
	 */
	private String emailRecvYn;
	
	/**
	 * SMS수신여부
	 */
	private String smsRecvYn;
	
	/**
	 * 추천인ID
	 */
	private String recomMemId;
	
	/**
	 * 다비젼 회원코드
	 */
	private String cdCust;
	
	/**
	 * 다비젼 회원 등급
	 */
	private String lvl;

	/**
	 * 다비젼 생성 비밀번호
	 */
	private String password;


}
