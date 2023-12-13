package net.danvi.dmall.biz.app.goods.model;

import java.util.List;

import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * <pre>
 * 프로젝트명 : 03.business
 * 작성일     : 2016. 5. 2.
 * 작성자     : kwt
 * 설명       : 상품 추가옵션 정보 Value Objcect
 * </pre>
 */
@Data
@EqualsAndHashCode
public class GoodsAddOptionVO {
    // 상품번호
    private String goodsNo;
    // 추가 옵션 번호
    private long addOptNo;
    // 추가 옵션 명
    private String addOptNm;
    // 필수 여부
    private String requiredYn;
    // 추가옵션 등록, 수정 구분 (I:신규등록, U:수정항목)
    private String registFlag;
    // 추가옵션 상세 정보 DB취득용 배열
    private String addOptDtlSeqArr;
    // 추가 옵션 값 정보
    private String addOptValueArr;
    // 추가 옵션 변경 코드 정보
    private String addOptAmtChgCdArr;
    // 추가 옵션 가격 정보
    private String addOptAmtArr;
    // 옵션 버젼 정보
    private String optVerArr;
    // 추가옵션값 리스트
    private List<GoodsAddOptionDtlVO> addOptionValueList;
    // 추가옵션 사용여부
    private String addOptUseYn;
}
