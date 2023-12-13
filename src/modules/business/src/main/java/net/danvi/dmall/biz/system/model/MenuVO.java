package net.danvi.dmall.biz.system.model;

import lombok.Data;

import java.io.Serializable;

@Data
public class MenuVO implements Serializable {

	private String menuId;
	private String upMenuId;
	private String menuNm;
	private String url;
	private Integer menuLvl;
	private String siteTypeCd;
	private String screenYn;
	private Boolean isSeller;
	private String sellerStatusCd;
	private long memberNo;
}