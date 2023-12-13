package net.danvi.dmall.biz.app.setup.siteinfo.model;

import javax.validation.constraints.Pattern;

import net.danvi.dmall.biz.system.validation.InsertGroup;
import net.danvi.dmall.biz.system.validation.UpdateGroup;
import org.hibernate.validator.constraints.Email;
import org.hibernate.validator.constraints.NotEmpty;

import lombok.Data;
import lombok.EqualsAndHashCode;
import dmall.framework.common.model.EditorBasePO;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 4. 29.
 * 작성자     : user
 * 설명       : 사이트 정보 PO
 * </pre>
 */
@Data
@EqualsAndHashCode
public class SitePO extends EditorBasePO<SitePO> {
    // 사이트 명
    private String siteNm;
    // 이메일
    @NotEmpty(groups = { InsertGroup.class, UpdateGroup.class })
    @Email
    private String email;
    //기본검색어
    private String defaultSrchWord;
    // 업체명 (업체정보)
    @NotEmpty(groups = { InsertGroup.class, UpdateGroup.class })
    private String companyNm;
    // 업태 (업체정보)
    private String bsnsCdts;
    // 종목 (업체정보)
    private String item;
    // 우편번호 (업체정보)
    @NotEmpty(groups = { InsertGroup.class, UpdateGroup.class })
    private String postNo;
    // 주소 지번 (업체정보)
    private String addrNum;
    // 주소 도로명 (업체정보)
    private String addrRoadnm;
    // 주소 공통 상세 (업체정보)
    @NotEmpty(groups = { InsertGroup.class, UpdateGroup.class })
    private String addrCmnDtl;
    // 사업자 번호 (업체정보)
    private String bizNo;
    // 통신 판매 신고 번호 (업체정보)
    private String commSaleRegistNo;
    // 대표자 명 (업체정보)
    @NotEmpty(groups = { InsertGroup.class, UpdateGroup.class })
    private String ceoNm;
    // 개인정보관리자 (업체정보)
    @NotEmpty(groups = { InsertGroup.class, UpdateGroup.class })
    private String privacymanager;
    // 전화번호 (업체정보)
    // @NotEmpty(groups = { InsertGroup.class, UpdateGroup.class })
    private String telNo;
    // 팩스번호 (업체정보)
    // @NotEmpty(groups = { InsertGroup.class, UpdateGroup.class })
    private String faxNo;

    // 고객 센터 전화 번호
    // @NotEmpty(groups = { InsertGroup.class, UpdateGroup.class })
    private String custCtTelNo;
    // 고객 센터 팩스 번호
    // @NotEmpty(groups = { InsertGroup.class, UpdateGroup.class })
    private String custCtFaxNo;
    // 고객 센터 이메일
    // @NotEmpty
    @Email
    private String custCtEmail;
    // 고객 센터 운영 시간
    private String custCtOperTime;
    // 고객 센터 점심 시간
    private String custCtLunchTime;
    // 고객 센터 휴무일
    private String custCtClosedInfo;
    // 타이틀
    private String title;
    // 자동 LOGOUT 시간
    @Pattern(regexp = "^[0-9]+$")
    private String autoLogoutTime;
    // 파비콘 경로
    private String fvcPath;
    // 파비콘 파일 경로
    private String filePath;
    // 파비콘 파일 명
    private String fileName;
    // 로고 경로
    private String logoPath;
    // 로고 파일 경로
    private String logoFilePath;
    // 로고 파일 명
    private String logoFileName;
    // 하단 로고 정보
    private String bottomLogoPath;
    // 하단 로고 파일 경로
    private String bottomLogoFilePath;
    // 하단 로고 파일 명
    private String bottomLogoFileName;
    // 설명
    private String dscrt;
    // 대표 도메인
    private String dlgtDomain;
    // 임시 도메인
    private String tempDomain;
    // 사이트 정보 코드
    private String siteInfoCd;
    // 내용
    private String content;
    // 표준 약정 적용 여부
    private String stdTermsApplyYn;
    // 사방넥 아이디
    private String sbnID;
    // 사방넷 인증키
    private String sbnCertKey;
    // 사방넷 시작 일자
    private String sbnStartDt;
    // 사방넷 종료 일자
    private String sbnEndDt;
    // 반품지 우편번호
    private String retadrssPost;
    // 반품지 주소 지번
    private String retadrssAddrNum;
    // 반품지 주소 도로명
    private String retadrssAddrRoadnm;
    // 반품지 주소 상세
    private String retadrssAddrDtl;
    // 인증 발신 번호
    private String certifySendNo;
    // 앱 최신버전 IOS
    private String appVersionIos;
    // 강제 업데이트 여부 IOS
    private String forceUpdateYnIos;
    // 앱 최신버전 ANDROID
    private String appVersionAndroid;
    // 강제 업데이트 여부 ANDROID
    private String forceUpdateYnAndroid;


}
