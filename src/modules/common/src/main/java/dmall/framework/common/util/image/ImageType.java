package dmall.framework.common.util.image;

import java.util.ArrayList;
import java.util.List;

public enum ImageType {

    // Goods_image
    GOODS_IMAGE {
        @Override
        public List<String> imageSizeList() {
            List<String> imageSizeList = new ArrayList<String>();
            imageSizeList.add("500x500");
            imageSizeList.add("240x240");
            imageSizeList.add("130x130");
            imageSizeList.add("110x110");
            imageSizeList.add("90x90");
            imageSizeList.add("50x50");
            return imageSizeList;
        }

        @Override
        public int validWidthSize() {
            return 600;
        }

        @Override
        public int validHeightSize() {
            return 600;
        }

        @Override
        public String imgFormat() {
            // return "jpg";
            return "PNG";
        }
    },

    GOODS_IMAGE_TYPE_A {
        @Override
        public List<String> imageSizeList() {
            List<String> imageSizeList = new ArrayList<String>();
            imageSizeList.add("500x500");
            imageSizeList.add("110x110");
            return imageSizeList;
        }

        @Override
        public int validWidthSize() {
            return 600;
        }

        @Override
        public int validHeightSize() {
            return 600;
        }

        @Override
        public String imgFormat() {
            // return "jpg";
            return "PNG";
        }
    },

    GOODS_IMAGE_TYPE_B {
        @Override
        public List<String> imageSizeList() {
            List<String> imageSizeList = new ArrayList<String>();
            imageSizeList.add("240x240");
            imageSizeList.add("110x110");
            return imageSizeList;
        }

        @Override
        public int validWidthSize() {
            return 600;
        }

        @Override
        public int validHeightSize() {
            return 600;
        }

        @Override
        public String imgFormat() {
            // return "jpg";
            return "PNG";
        }
    },

    GOODS_IMAGE_TYPE_C {
        @Override
        public List<String> imageSizeList() {
            List<String> imageSizeList = new ArrayList<String>();
            imageSizeList.add("130x130");
            imageSizeList.add("110x110");
            return imageSizeList;
        }

        @Override
        public int validWidthSize() {
            return 600;
        }

        @Override
        public int validHeightSize() {
            return 600;
        }

        @Override
        public String imgFormat() {
            // return "jpg";
            return "PNG";
        }
    },

    GOODS_IMAGE_TYPE_D {
        @Override
        public List<String> imageSizeList() {
            List<String> imageSizeList = new ArrayList<String>();
            imageSizeList.add("90x90");
            imageSizeList.add("110x110");
            return imageSizeList;
        }

        @Override
        public int validWidthSize() {
            return 600;
        }

        @Override
        public int validHeightSize() {
            return 600;
        }

        @Override
        public String imgFormat() {
            // return "jpg";
            return "PNG";
        }
    },

    GOODS_IMAGE_TYPE_E {
        @Override
        public List<String> imageSizeList() {
            List<String> imageSizeList = new ArrayList<String>();
            imageSizeList.add("50x50");
            imageSizeList.add("110x110");
            return imageSizeList;
        }

        @Override
        public int validWidthSize() {
            return 600;
        }

        @Override
        public int validHeightSize() {
            return 600;
        }

        @Override
        public String imgFormat() {
            // return "jpg";
            return "PNG";
        }
    },

    EDITOR_IMAGE {
        @Override
        public List<String> imageSizeList() {
            List<String> imageSizeList = new ArrayList<String>();
            imageSizeList.add("150x100");
            return imageSizeList;
        }

        @Override
        public int validWidthSize() {
            return 600;
        }

        @Override
        public int validHeightSize() {
            return 600;
        }

        @Override
        public String imgFormat() {
            // return "jpg";
            return "PNG";
        }
    },

    EDITOR_IMAGE_BBS {
        @Override
        public List<String> imageSizeList() {
            List<String> imageSizeList = new ArrayList<String>();
            imageSizeList.add("150x150");
            return imageSizeList;
        }

        @Override
        public int validWidthSize() {
            return 600;
        }

        @Override
        public int validHeightSize() {
            return 600;
        }

        @Override
        public String imgFormat() {
            // return "jpg";
            return "PNG";
        }
    };

    /**
     * <pre>
     * imageSizeList
     * 사이즈 리스트
     * 
     * <pre>
     * 
     * @return
     */
    public abstract List<String> imageSizeList();

    /**
     * <pre>
     * validWidthSize
     * 유효성 검사 가로 사이즈
     * 
     * <pre>
     * 
     * @return
     */
    public abstract int validWidthSize();

    /**
     * <pre>
     * validHeightSize
     * 유효성 검사 세로 사이즈
     * 
     * <pre>
     * 
     * @return
     */
    public abstract int validHeightSize();

    /**
     * <pre>
     * imgFormat
     * 이미지 format (JPG, PNG 등)
     * 
     * <pre>
     * 
     * @return
     */
    public abstract String imgFormat();

}
