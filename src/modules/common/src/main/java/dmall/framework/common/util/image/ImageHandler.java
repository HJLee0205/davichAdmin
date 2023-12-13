package dmall.framework.common.util.image;


import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.List;

@Slf4j
@Component("imageHandler")
public class ImageHandler {
	/** validation check list */
	private final List<ImageValid> validCheckList;

	/**
	 * constructor
	 */
	public ImageHandler() {
		validCheckList = new ArrayList<ImageValid>();
		validCheckList.add(new ImageSizeCheck());
	}

	/**
	 * <pre>
	 * job
	 * 이미지 resize handle
	 * <pre>
	 * @param data
	 * @return
	 */
	public boolean job(ImageInfoData data) {
		boolean isSuccess = false;
		try {

			// 이미지 resize
			ImageResizer resizer = new ImageResizer(data);
			resizer.process();

		} catch (Exception ex ) {
			log.debug("##job## (exception failed) data={}", data, ex);

			isSuccess = false;
		}

		return isSuccess;
	}


}
