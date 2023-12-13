package net.danvi.dmall.biz.ifapi.mem.dto;

import lombok.Data;

/**
 * 2023-07-02 210
 * 각 지점별 가지고 있는 포인트를 집계
 * **/
@Data
public class MemberStoreGroupDPointErpVO {
    //공통
    private String strCode;//지점 코드

    //지점별 총 포인트
    private long pointTotal;//지점별 총 남은 포인트

    //지점 선입 선추을 위해 선입 적립된 포인트 정보
    private String dates;//입력 날짜
    private String inFlag;/* 입력구분 0:적립,1:통합,2:소멸,3:변경,4:사용 */
    private long salPoint;//적립 포인트
    private String cdCust;//erp 회원 번호
    private long strUseTotal;//해당 지점에 총 사용한 포인트
}
