package net.danvi.dmall.biz.app.setup.operationsupport.model;

import lombok.Data;
import lombok.EqualsAndHashCode;
import dmall.framework.common.model.BaseModel;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 8. 24.
 * 작성자     : dong
 * 설명       :
 * </pre>
 */
@Data
@EqualsAndHashCode
public class OperSupportConfigVO extends BaseModel<OperSupportConfigVO> {
    // SEO
    // 공통 사용 여부
    private String cmnUseYn;
    // 공통 제목
    private String cmnTitle;
    // 공통 담당자
    private String cmnManager;
    // 공통 설명
    private String cmnDscrt;
    // 공통 키워드
    private String cmnKeyword;
    // 상품 사용 여부
    private String goodsUseYn;
    // 상품 제목
    private String goodsTitle;
    // 상품 담당자
    private String goodsManager;
    // 검색 파일 위치
    private String srchFilePath;

    // 구글 어날리틱스
    // 사용 여부
    private String useYn;
    // 구글 어날리틱스ID
    private String anlsId;

    // 080 수신거부 서비스
    // 수신 거부 번호
    private String recvRjtNo;
    // 적용 정보
    private String applyInfo;
    // 서비스 이용 시작 기간
    private String svcUseStartPeriod;
    // 서비스 이용 종료 기간
    private String svcUseEndPeriod;

    // 이미지 호스팅
    // 이미지 서버 URL
    private String imgServUrl;
    // 이미지 서버 ID
    private String id;
    // 이미지 서버 용량
    private String disk;
    // 이미지 서버 트래픽
    private String traffic;
}