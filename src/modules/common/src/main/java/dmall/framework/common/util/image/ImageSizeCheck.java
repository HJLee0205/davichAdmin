package dmall.framework.common.util.image;

import lombok.extern.slf4j.Slf4j;

import javax.imageio.ImageIO;
import java.awt.image.BufferedImage;
import java.io.File;

@Slf4j
public class ImageSizeCheck implements ImageValid {

	@Override
	public boolean valid(ImageInfoData data) throws Exception {
		String orgImgPath = data.getOrgImgPath();
		BufferedImage originalImage = ImageIO.read(new File(orgImgPath));
		int originWidth = originalImage.getWidth();
		int originHeight = originalImage.getHeight();

		// validation width, height 정보
		int validWidth = data.getImageType().validWidthSize();
		int validHeight = data.getImageType().validHeightSize();

		// validation check
		if (originWidth <= validWidth && originHeight <= validHeight) {
			return true;
		}

		log.debug("##valid## (image size check failed) originWidth=" + originWidth + ", originHeight=" + originHeight + ", validWidth=" + validWidth + ", validHeight=" + validHeight + ", orgImgPath=" + orgImgPath);
		return false;

	}

}
