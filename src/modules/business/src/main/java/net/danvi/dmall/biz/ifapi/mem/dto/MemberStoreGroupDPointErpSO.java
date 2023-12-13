package net.danvi.dmall.biz.ifapi.mem.dto;

import lombok.Data;
/**
 * 2023-07-02 210
 * 각 지점별 가지고 있는 포인트를 집계
 * **/
@Data
public class MemberStoreGroupDPointErpSO {
    private String cdCust;//erp 멤버 번호
    private String strCode;//지점 코드
}
