package dmall.framework.common.model;

import java.io.Serializable;

import lombok.Data;


/**
 * File Download VO
 * @author 	snw
 * @since		2013.09.25
 */
@Data
public class FileViewParam implements Serializable {

	/**
	 *
	 */
	private static final long serialVersionUID = 1L;

	private String	fileName;

	private String	filePath;

}