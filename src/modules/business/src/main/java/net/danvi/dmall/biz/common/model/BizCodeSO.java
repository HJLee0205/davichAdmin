package net.danvi.dmall.biz.common.model;

import lombok.Data;

import java.io.Serializable;

/**
 * BizCode PO
 * 
 * @author snw
 * @since 2015.06.15
 *
 */
@Data
public class BizCodeSO implements Serializable {

	/**
	 *
	 */
	private static final long serialVersionUID = 1L;

	private String	grpCd;
	private String	usrDfn1Val;
	private String	usrDfn2Val;
	private String	usrDfn3Val;
	private String	usrDfn4Val;
	private String	usrDfn5Val;
	private String defaultName;
	private Boolean showValue;

	private String	dtlCd;
	private int usrDfnValIdx;
}