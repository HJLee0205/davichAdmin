package net.danvi.dmall.biz.ifapi.mem.dto;

import lombok.Data;

/**
 * <pre>
 * 프로젝트명:davich-ecommerce-backend
 * 파일명:   OfflineStampHistoryDto
 * 작성자:   gh.jo
 * 작성일:   2023/02/23
 * 설명:    스탬프 증감내역
 * </pre>
 * ===========================================================
 * DATE                 AUTHOR                NOTE
 * -----------------------------------------------------------
 * 2023/02/23 gh.jo  최초 생성
 */

@Data
public class StampHistoryDto {

    private String dealDate;

    private String storeName;

    private String content;

    //private String cancType;

    private int qty;


}
