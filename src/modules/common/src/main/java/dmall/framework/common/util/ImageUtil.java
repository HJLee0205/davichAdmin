package dmall.framework.common.util;

import javax.imageio.ImageIO;
import java.awt.*;
import java.awt.image.BufferedImage;
import java.io.File;

/**
 * 이미지 관련 Util
 * 
 */
public class ImageUtil {

	/**
	 * 이미지 리사이즈
	 * @param imageFile 원본 이미지
	 * @param imageType 이미지 타입(jpg/png 등)
	 * @param width 이미지 가로 길이
	 * @param height 이미지 세로 길이
	 * @throws Exception
	 */
	public static void resizeImage(File imageFile, String imageType, int width, int height) throws Exception {

		BufferedImage orgImg = ImageIO.read(imageFile);
		
		BufferedImage resizeImage = createResized(orgImg, width, height, true);
		
		ImageIO.write(resizeImage, imageType, imageFile);
	}
	
	private static BufferedImage createResized(Image org_img, int width, int height, boolean alpha) throws Exception{
		
		int imgType = alpha ? BufferedImage.TYPE_INT_RGB : BufferedImage.TYPE_INT_ARGB;
		
		BufferedImage scale = new BufferedImage(width, height, imgType);
		
		Graphics2D g = scale.createGraphics();
		
		if(alpha){
			g.setComposite(AlphaComposite.Src);
		}
		
		g.drawImage(org_img, 0, 0, width, height, null);
		g.dispose();
		
		return scale;
	}

}
