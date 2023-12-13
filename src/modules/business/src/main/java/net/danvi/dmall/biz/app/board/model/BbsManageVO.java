package net.danvi.dmall.biz.app.board.model;

import java.util.List;

import lombok.Data;
import lombok.EqualsAndHashCode;
import dmall.framework.common.model.MultiEditorBaseVO;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 4. 29.
 * 작성자     : dong
 * 설명       : 게시판 VO
 * </pre>
 */
@Data
@EqualsAndHashCode
public class BbsManageVO extends MultiEditorBaseVO<BbsManageVO> {
    // 게시판 설정
    private String rowNum;
    private String bbsId; // 게시판 아이디
    private String bbsNm; // 게시판 명
    private String bbsKindCd; // 게시판 종류 코드
    private String bbsKindCdNm; // 게시판 종류 코드 명
    private String useYn; // 게시판 사용 여부
    private String titleUseYn; // 타이틀 사용 여부
    private String bbsAddr; // 게시판 주소
    private String readListUseYn; // 읽기 리스트 사용 여부
    private String readLettContentUseYn; // 읽기 글 내용 사용 여부
    private String writeLettUseYn; // 쓰기 글 사용 여부
    private String writeCommentUseYn; // 쓰기 코맨드 사용 여부
    private String writeReplyUseYn; // 쓰기 답글 사용 여부
    private String regrDispCd; // 등록자 표시 코드
    private String iconSetUseYn; // 아이콘 설정 사용 여부
    private String iconUseYnHot; // 아이콘 사용 여부 HOT
    private String iconCheckValueHot; // 아이콘 체크 값 1 HOT
    private String iconUseYnNew; // 아이콘 사용 여부 NEW
    private String iconCheckValueNew; // 아이콘 체크 값 2 NEW
    private String sectLettSetYn; // 비밀글 설정 여부
    private String noticeLettSetYn; // 공지 글 설정 여부
    private String bbsSpamPrvntYn; // 게시판 스팸 방지 여부
    private String topHtmlSet; // 상단 HTML 설정
    private String bottomHtmlSet; // 하단 HTML 설정
    private String topHtmlYn; // 상단 HTML 여부
    private String bottomHtmlYn; // 하단 HTML 여부
    private String bbsLettCnt; // 게시판 글 건수
    private String bbsGbCd; // 게시판 구분 코드
    private String bbsIdText; // 게시판 아이디 TEXT
    // 게시판 타이틀
    private String titleNo;
    // 파이틀 명
    private String titleNm;
    private List<BbsManageVO> titleNmArr;

    // 이름
    private String name;
    // 내용
    private String content;
}
