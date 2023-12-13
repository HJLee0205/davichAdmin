<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="t" uri="http://tiles.apache.org/tags-tiles"%>
<%@ taglib prefix="data" tagdir="/WEB-INF/tags/data" %>
<t:insertDefinition name="davichLayout">
    <t:putAttribute name="title">${site_info.siteNm}</t:putAttribute>
    <sec:authentication var="user" property='details'/>
    <t:putAttribute name="script">
        <script src="//developers.kakao.com/sdk/js/kakao.min.js"></script>
    </t:putAttribute>
    <t:putAttribute name="content">

        <div id="main_container">
            <%@ include file="main_visual.jsp" %>
            <!-- Best of Best -->
            <div class="best_area">
                <div class="main_layout_middle">
                    <h2 class="main_title">Best of Best</h2>
                    <div class="main_mid_tab">
                        <a href="#" data-slide-index="0" class="active"><span>안경테</span></a>
                        <a href="#" data-slide-index="1"><span>선글라스</span></a>
                        <a href="#" data-slide-index="2"><span>콘텍트렌즈</span></a>
                        <a href="#" data-slide-index="3"><span>렌즈</span></a>
                        <a href="#" data-slide-index="4"><span>보청기</span></a>
                    </div>
                    <!-- slider -->
                    <div class="BB_slider">
                        <!-- 안경테 -->
                        <ul class="BB_list">
                            <li class="w">
                                <a href="#">
                                    <div class="img_area">
                                        <img src="${_SKIN_IMG_PATH}/main/BB_product01.jpg" alt="리아슬림 우드 탁자의 쿠션세트">
                                    </div>
                                    <div class="text_area">
                                        <p class="name">WILLEM02 C2_윌리엄02 C2</p>
                                        <p class="price">39,000</p>
                                    </div>
                                </a>
                            </li>
                            <li class="h">
                                <a href="#">
                                    <div class="text_area">
                                        <p class="name">WILLEM02 C2_윌리엄02 C2</p>
                                        <p class="price">39,000</p>
                                    </div>
                                    <img src="${_SKIN_IMG_PATH}/main/BB_h_product01.jpg" alt="리아슬림 우드 탁자의 쿠션세트">
                                </a>
                            </li>
                            <li>
                                <a href="#">
                                    <div class="img_area">
                                        <img src="${_SKIN_IMG_PATH}/main/BB_product02.jpg" alt="리아슬림 우드 탁자의 쿠션세트">
                                    </div>
                                    <div class="text_area">
                                        <p class="name">WILLEM02 C2_윌리엄02 C2</p>
                                        <p class="price">39,000</p>
                                    </div>
                                </a>
                            </li>
                            <li>
                                <a href="#">
                                    <div class="img_area">
                                        <img src="${_SKIN_IMG_PATH}/main/BB_product03.jpg" alt="리아슬림 우드 탁자의 쿠션세트">
                                    </div>
                                    <div class="text_area">
                                        <p class="name">WILLEM02 C2_윌리엄02 C2</p>
                                        <p class="price">39,000</p>
                                    </div>
                                </a>
                            </li>
                            <li>
                                <a href="#">
                                    <div class="img_area">
                                        <img src="${_SKIN_IMG_PATH}/main/BB_product04.jpg" alt="리아슬림 우드 탁자의 쿠션세트">
                                    </div>
                                    <div class="text_area">
                                        <p class="name">WILLEM02 C2_윌리엄02 C2</p>
                                        <p class="price">39,000</p>
                                    </div>
                                </a>
                            </li>
                            <li>
                                <a href="#">
                                    <div class="img_area">
                                        <img src="${_SKIN_IMG_PATH}/main/BB_product05.jpg" alt="리아슬림 우드 탁자의 쿠션세트">
                                    </div>
                                    <div class="text_area">
                                        <p class="name">WILLEM02 C2_윌리엄02 C2</p>
                                        <p class="price">39,000</p>
                                    </div>
                                </a>
                            </li>
                            <li>
                                <a href="#">
                                    <div class="img_area">
                                        <img src="${_SKIN_IMG_PATH}/main/BB_product06.jpg" alt="리아슬림 우드 탁자의 쿠션세트">
                                    </div>
                                    <div class="text_area">
                                        <p class="name">WILLEM02 C2_윌리엄02 C2</p>
                                        <p class="price">39,000</p>
                                    </div>
                                </a>
                            </li>
                        </ul>
                        <!--// 안경테 -->
                        <!-- 선글라스 -->
                        <ul class="BB_list">
                            <li class="w">
                                <a href="#">
                                    <div class="img_area">
                                        <img src="${_SKIN_IMG_PATH}/main/BB_product06.jpg" alt="리아슬림 우드 탁자의 쿠션세트">
                                    </div>
                                    <div class="text_area">
                                        <p class="name">WILLEM02 C2_윌리엄02 C2</p>
                                        <p class="price">39,000</p>
                                    </div>
                                </a>
                            </li>
                            <li class="h">
                                <a href="#">
                                    <div class="text_area">
                                        <p class="name">WILLEM02 C2_윌리엄02 C2</p>
                                        <p class="price">39,000</p>
                                    </div>
                                    <img src="${_SKIN_IMG_PATH}/main/BB_h_product01.jpg" alt="리아슬림 우드 탁자의 쿠션세트">
                                </a>
                            </li>
                            <li>
                                <a href="#">
                                    <div class="img_area">
                                        <img src="${_SKIN_IMG_PATH}/main/BB_product05.jpg" alt="리아슬림 우드 탁자의 쿠션세트">
                                    </div>
                                    <div class="text_area">
                                        <p class="name">WILLEM02 C2_윌리엄02 C2</p>
                                        <p class="price">39,000</p>
                                    </div>
                                </a>
                            </li>
                            <li>
                                <a href="#">
                                    <div class="img_area">
                                        <img src="${_SKIN_IMG_PATH}/main/BB_product04.jpg" alt="리아슬림 우드 탁자의 쿠션세트">
                                    </div>
                                    <div class="text_area">
                                        <p class="name">WILLEM02 C2_윌리엄02 C2</p>
                                        <p class="price">39,000</p>
                                    </div>
                                </a>
                            </li>
                            <li>
                                <a href="#">
                                    <div class="img_area">
                                        <img src="${_SKIN_IMG_PATH}/main/BB_product03.jpg" alt="리아슬림 우드 탁자의 쿠션세트">
                                    </div>
                                    <div class="text_area">
                                        <p class="name">WILLEM02 C2_윌리엄02 C2</p>
                                        <p class="price">39,000</p>
                                    </div>
                                </a>
                            </li>
                            <li>
                                <a href="#">
                                    <div class="img_area">
                                        <img src="${_SKIN_IMG_PATH}/main/BB_product02.jpg" alt="리아슬림 우드 탁자의 쿠션세트">
                                    </div>
                                    <div class="text_area">
                                        <p class="name">WILLEM02 C2_윌리엄02 C2</p>
                                        <p class="price">39,000</p>
                                    </div>
                                </a>
                            </li>
                            <li>
                                <a href="#">
                                    <div class="img_area">
                                        <img src="${_SKIN_IMG_PATH}/main/BB_product01.jpg" alt="리아슬림 우드 탁자의 쿠션세트">
                                    </div>
                                    <div class="text_area">
                                        <p class="name">WILLEM02 C2_윌리엄02 C2</p>
                                        <p class="price">39,000</p>
                                    </div>
                                </a>
                            </li>
                        </ul>
                        <!--// 선글라스 -->
                        <!-- 콘텍트렌즈 -->
                        <ul class="BB_list">
                            <li class="w">
                                <a href="#">
                                    <div class="img_area">
                                        <img src="${_SKIN_IMG_PATH}/main/BB_product01.jpg" alt="리아슬림 우드 탁자의 쿠션세트">
                                    </div>
                                    <div class="text_area">
                                        <p class="name">WILLEM02 C2_윌리엄02 C2</p>
                                        <p class="price">39,000</p>
                                    </div>
                                </a>
                            </li>
                            <li class="h">
                                <a href="#">
                                    <div class="text_area">
                                        <p class="name">WILLEM02 C2_윌리엄02 C2</p>
                                        <p class="price">39,000</p>
                                    </div>
                                    <img src="${_SKIN_IMG_PATH}/main/BB_h_product01.jpg" alt="리아슬림 우드 탁자의 쿠션세트">
                                </a>
                            </li>
                            <li>
                                <a href="#">
                                    <div class="img_area">
                                        <img src="${_SKIN_IMG_PATH}/main/BB_product02.jpg" alt="리아슬림 우드 탁자의 쿠션세트">
                                    </div>
                                    <div class="text_area">
                                        <p class="name">WILLEM02 C2_윌리엄02 C2</p>
                                        <p class="price">39,000</p>
                                    </div>
                                </a>
                            </li>
                            <li>
                                <a href="#">
                                    <div class="img_area">
                                        <img src="${_SKIN_IMG_PATH}/main/BB_product03.jpg" alt="리아슬림 우드 탁자의 쿠션세트">
                                    </div>
                                    <div class="text_area">
                                        <p class="name">WILLEM02 C2_윌리엄02 C2</p>
                                        <p class="price">39,000</p>
                                    </div>
                                </a>
                            </li>
                            <li>
                                <a href="#">
                                    <div class="img_area">
                                        <img src="${_SKIN_IMG_PATH}/main/BB_product04.jpg" alt="리아슬림 우드 탁자의 쿠션세트">
                                    </div>
                                    <div class="text_area">
                                        <p class="name">WILLEM02 C2_윌리엄02 C2</p>
                                        <p class="price">39,000</p>
                                    </div>
                                </a>
                            </li>
                            <li>
                                <a href="#">
                                    <div class="img_area">
                                        <img src="${_SKIN_IMG_PATH}/main/BB_product05.jpg" alt="리아슬림 우드 탁자의 쿠션세트">
                                    </div>
                                    <div class="text_area">
                                        <p class="name">WILLEM02 C2_윌리엄02 C2</p>
                                        <p class="price">39,000</p>
                                    </div>
                                </a>
                            </li>
                            <li>
                                <a href="#">
                                    <div class="img_area">
                                        <img src="${_SKIN_IMG_PATH}/main/BB_product06.jpg" alt="리아슬림 우드 탁자의 쿠션세트">
                                    </div>
                                    <div class="text_area">
                                        <p class="name">WILLEM02 C2_윌리엄02 C2</p>
                                        <p class="price">39,000</p>
                                    </div>
                                </a>
                            </li>
                        </ul>
                        <!--// 콘텍트렌즈 -->
                        <!-- 렌즈 -->
                        <ul class="BB_list">
                            <li class="w">
                                <a href="#">
                                    <div class="img_area">
                                        <img src="${_SKIN_IMG_PATH}/main/BB_product06.jpg" alt="리아슬림 우드 탁자의 쿠션세트">
                                    </div>
                                    <div class="text_area">
                                        <p class="name">WILLEM02 C2_윌리엄02 C2</p>
                                        <p class="price">39,000</p>
                                    </div>
                                </a>
                            </li>
                            <li class="h">
                                <a href="#">
                                    <div class="text_area">
                                        <p class="name">WILLEM02 C2_윌리엄02 C2</p>
                                        <p class="price">39,000</p>
                                    </div>
                                    <img src="${_SKIN_IMG_PATH}/main/BB_h_product01.jpg" alt="리아슬림 우드 탁자의 쿠션세트">
                                </a>
                            </li>
                            <li>
                                <a href="#">
                                    <div class="img_area">
                                        <img src="${_SKIN_IMG_PATH}/main/BB_product05.jpg" alt="리아슬림 우드 탁자의 쿠션세트">
                                    </div>
                                    <div class="text_area">
                                        <p class="name">WILLEM02 C2_윌리엄02 C2</p>
                                        <p class="price">39,000</p>
                                    </div>
                                </a>
                            </li>
                            <li>
                                <a href="#">
                                    <div class="img_area">
                                        <img src="${_SKIN_IMG_PATH}/main/BB_product04.jpg" alt="리아슬림 우드 탁자의 쿠션세트">
                                    </div>
                                    <div class="text_area">
                                        <p class="name">WILLEM02 C2_윌리엄02 C2</p>
                                        <p class="price">39,000</p>
                                    </div>
                                </a>
                            </li>
                            <li>
                                <a href="#">
                                    <div class="img_area">
                                        <img src="${_SKIN_IMG_PATH}/main/BB_product03.jpg" alt="리아슬림 우드 탁자의 쿠션세트">
                                    </div>
                                    <div class="text_area">
                                        <p class="name">WILLEM02 C2_윌리엄02 C2</p>
                                        <p class="price">39,000</p>
                                    </div>
                                </a>
                            </li>
                            <li>
                                <a href="#">
                                    <div class="img_area">
                                        <img src="${_SKIN_IMG_PATH}/main/BB_product02.jpg" alt="리아슬림 우드 탁자의 쿠션세트">
                                    </div>
                                    <div class="text_area">
                                        <p class="name">WILLEM02 C2_윌리엄02 C2</p>
                                        <p class="price">39,000</p>
                                    </div>
                                </a>
                            </li>
                            <li>
                                <a href="#">
                                    <div class="img_area">
                                        <img src="${_SKIN_IMG_PATH}/main/BB_product01.jpg" alt="리아슬림 우드 탁자의 쿠션세트">
                                    </div>
                                    <div class="text_area">
                                        <p class="name">WILLEM02 C2_윌리엄02 C2</p>
                                        <p class="price">39,000</p>
                                    </div>
                                </a>
                            </li>
                        </ul>
                        <!--// 렌즈 -->
                        <!-- 보청기 -->
                        <ul class="BB_list">
                            <li class="w">
                                <a href="#">
                                    <div class="img_area">
                                        <img src="${_SKIN_IMG_PATH}/main/BB_product01.jpg" alt="리아슬림 우드 탁자의 쿠션세트">
                                    </div>
                                    <div class="text_area">
                                        <p class="name">WILLEM02 C2_윌리엄02 C2</p>
                                        <p class="price">39,000</p>
                                    </div>
                                </a>
                            </li>
                            <li class="h">
                                <a href="#">
                                    <div class="text_area">
                                        <p class="name">WILLEM02 C2_윌리엄02 C2</p>
                                        <p class="price">39,000</p>
                                    </div>
                                    <img src="${_SKIN_IMG_PATH}/main/BB_h_product01.jpg" alt="리아슬림 우드 탁자의 쿠션세트">
                                </a>
                            </li>
                            <li>
                                <a href="#">
                                    <div class="img_area">
                                        <img src="${_SKIN_IMG_PATH}/main/BB_product02.jpg" alt="리아슬림 우드 탁자의 쿠션세트">
                                    </div>
                                    <div class="text_area">
                                        <p class="name">WILLEM02 C2_윌리엄02 C2</p>
                                        <p class="price">39,000</p>
                                    </div>
                                </a>
                            </li>
                            <li>
                                <a href="#">
                                    <div class="img_area">
                                        <img src="${_SKIN_IMG_PATH}/main/BB_product03.jpg" alt="리아슬림 우드 탁자의 쿠션세트">
                                    </div>
                                    <div class="text_area">
                                        <p class="name">WILLEM02 C2_윌리엄02 C2</p>
                                        <p class="price">39,000</p>
                                    </div>
                                </a>
                            </li>
                            <li>
                                <a href="#">
                                    <div class="img_area">
                                        <img src="${_SKIN_IMG_PATH}/main/BB_product04.jpg" alt="리아슬림 우드 탁자의 쿠션세트">
                                    </div>
                                    <div class="text_area">
                                        <p class="name">WILLEM02 C2_윌리엄02 C2</p>
                                        <p class="price">39,000</p>
                                    </div>
                                </a>
                            </li>
                            <li>
                                <a href="#">
                                    <div class="img_area">
                                        <img src="${_SKIN_IMG_PATH}/main/BB_product05.jpg" alt="리아슬림 우드 탁자의 쿠션세트">
                                    </div>
                                    <div class="text_area">
                                        <p class="name">WILLEM02 C2_윌리엄02 C2</p>
                                        <p class="price">39,000</p>
                                    </div>
                                </a>
                            </li>
                            <li>
                                <a href="#">
                                    <div class="img_area">
                                        <img src="${_SKIN_IMG_PATH}/main/BB_product06.jpg" alt="리아슬림 우드 탁자의 쿠션세트">
                                    </div>
                                    <div class="text_area">
                                        <p class="name">WILLEM02 C2_윌리엄02 C2</p>
                                        <p class="price">39,000</p>
                                    </div>
                                </a>
                            </li>
                        </ul>
                        <!--// 보청기 -->
                    </div>
                    <!--// slider -->
                    <div class="BB_slider_btn">
                        <button type="button" class="btn_BB_list_prev">이전으로</button>
                        <button type="button" class="btn_BB_list_next">다음으로</button>
                    </div>
                </div>
            </div>
            <!--// Best of Best -->

            <!-- Beauty & Living -->
            <div class="main_layout_middle">
                <div class="mid_banner_area">
                    <a href="#" class="floatL"><img src="${_SKIN_IMG_PATH}/main/mid_banner01.gif" alt="배너1"></a>
                    <a href="#" class="floatR"><img src="${_SKIN_IMG_PATH}/main/mid_banner02.gif" alt="배너2"></a>
                </div>
                <h2 class="main_title">Beauty & Living</h2>
                <div class="BL_left">
                    <a href="#"><img src="${_SKIN_IMG_PATH}/main/BL_banner01.jpg" alt="데일리 섀도 팔레트"></a>
                </div>
                <div class="BL_right">
                    <ul class="BL_list">
                        <li>
                            <a href="#">
                                <div class="img_area">
                                    <img src="${_SKIN_IMG_PATH}/main/BL_product01.jpg" alt="리아슬림 우드 탁자의 쿠션세트">
                                </div>
                                <div class="text_area">
                                    <p class="name">[이즈마인]</p>
                                    리아슬림 우드 탁자의 쿠션세트
                                    <p class="price">16,000원</p>
                                </div>
                            </a>
                        </li>
                        <li>
                            <a href="#">
                                <div class="img_area">
                                    <img src="${_SKIN_IMG_PATH}/main/BL_product02.jpg" alt="리아슬림 우드 탁자의 쿠션세트">
                                </div>
                                <div class="text_area">
                                    <p class="name">[이즈마인]</p>
                                    리아슬림 우드 탁자의 쿠션세트
                                    <p class="price">16,000원</p>
                                </div>
                            </a>
                        </li>
                        <li class="w">
                            <a href="#">
                                <div class="img_area">
                                    <img src="${_SKIN_IMG_PATH}/main/BL_w_product01.jpg" alt="리아슬림 우드 탁자의 쿠션세트">
                                </div>
                                <div class="text_area">
                                    <p class="name">[이즈마인]</p>
                                    리아슬림 우드 탁자의 쿠션세트
                                    <p class="price">16,000원</p>
                                </div>
                            </a>
                        </li>
                    </ul>
                </div>
                <ul class="BL_list bottom">
                    <li>
                        <a href="#">
                            <div class="img_area"><img src="${_SKIN_IMG_PATH}/main/BL_product03.jpg" alt=""></div>
                            <div class="text_area">
                                <p class="name">[이즈마인]</p>
                                리아슬림 우드 탁자의 쿠션세트
                                <p class="price">16,000원</p>
                            </div>
                        </a>
                    </li>
                    <li>
                        <a href="#">
                            <div class="img_area"><img src="${_SKIN_IMG_PATH}/main/BL_product04.jpg" alt=""></div>
                            <div class="text_area">
                                <p class="name">[이즈마인]</p>
                                리아슬림 우드 탁자의 쿠션세트
                                <p class="price">16,000원</p>
                            </div>
                        </a>
                    </li>
                    <li>
                        <a href="#">
                            <div class="img_area"><img src="${_SKIN_IMG_PATH}/main/BL_product05.jpg" alt=""></div>
                            <div class="text_area">
                                <p class="name">[이즈마인]</p>
                                리아슬림 우드 탁자의 쿠션세트
                                <p class="price">16,000원</p>
                            </div>
                        </a>
                    </li>
                    <li>
                        <a href="#">
                            <div class="img_area"><img src="${_SKIN_IMG_PATH}/main/BL_product06.jpg" alt=""></div>
                            <div class="text_area">
                                <p class="name">[이즈마인]</p>
                                리아슬림 우드 탁자의 쿠션세트
                                <p class="price">16,000원</p>
                            </div>
                        </a>
                    </li>
                </ul>
            </div>
            <!--// Beauty & Living -->

            <!-- MD Pick -->
            <div class="main_layout_middle">
                <div class="MD_top">
                    <a href="#" class="MD_prev"><i>이전으로</i></a>
                    <a href="#" class="MD_next"><i>다음으로</i></a>
                    <h2>Davich O 사이트 오픈 이벤트 1.3.5.7 특별 기획전</h2>
                </div>
                <h2 class="main_title">MD Pick</h2>
                <ul class="MD_list">
                    <li>
                        <a href="#">
                            <div class="img_area"><img src="${_SKIN_IMG_PATH}/main/MD_product01.jpg" alt=""></div>
                            <div class="text_area">
                                <p class="name">CNBLUE C2_씨엔블루01 C2</p>
                                <p class="price">190,800</p>
                            </div>
                        </a>
                    </li>
                    <li>
                        <a href="#">
                            <div class="img_area"><img src="${_SKIN_IMG_PATH}/main/MD_product02.jpg" alt=""></div>
                            <div class="text_area">
                                <p class="name">CNBLUE C2_씨엔블루01 C2</p>
                                <p class="price">190,800</p>
                            </div>
                        </a>
                    </li>
                    <li>
                        <a href="#">
                            <div class="img_area"><img src="${_SKIN_IMG_PATH}/main/MD_product03.jpg" alt=""></div>
                            <div class="text_area">
                                <p class="name">CNBLUE C2_씨엔블루01 C2</p>
                                <p class="price">190,800</p>
                            </div>
                        </a>
                    </li>
                    <li>
                        <a href="#">
                            <div class="img_area"><img src="${_SKIN_IMG_PATH}/main/MD_product04.jpg" alt=""></div>
                            <div class="text_area">
                                <p class="name">CNBLUE C2_씨엔블루01 C2</p>
                                <p class="price">190,800</p>
                            </div>
                        </a>
                    </li>
                    <li>
                        <a href="#">
                            <div class="img_area"><img src="${_SKIN_IMG_PATH}/main/MD_product05.jpg" alt=""></div>
                            <div class="text_area">
                                <p class="name">CNBLUE C2_씨엔블루01 C2</p>
                                <p class="price">190,800</p>
                            </div>
                        </a>
                    </li>
                    <li>
                        <a href="#">
                            <div class="img_area"><img src="${_SKIN_IMG_PATH}/main/MD_product06.jpg" alt=""></div>
                            <div class="text_area">
                                <p class="name">CNBLUE C2_씨엔블루01 C2</p>
                                <p class="price">190,800</p>
                            </div>
                        </a>
                    </li>
                    <li>
                        <a href="#">
                            <div class="img_area"><img src="${_SKIN_IMG_PATH}/main/MD_product07.jpg" alt=""></div>
                            <div class="text_area">
                                <p class="name">CNBLUE C2_씨엔블루01 C2</p>
                                <p class="price">190,800</p>
                            </div>
                        </a>
                    </li>
                    <li>
                        <a href="#">
                            <div class="img_area"><img src="${_SKIN_IMG_PATH}/main/MD_product08.jpg" alt=""></div>
                            <div class="text_area">
                                <p class="name">CNBLUE C2_씨엔블루01 C2</p>
                                <p class="price">190,800</p>
                            </div>
                        </a>
                    </li>
                </ul>
            </div>
            <!--// MD Pick -->

            <!-- BRAND SHOP -->
            <div class="main_layout_middle">
                <h2 class="main_title">BRAND SHOP</h2>
                <ul class="brand_list">
                    <li><a href="#"><img src="${_SKIN_IMG_PATH}/main/brand_img01.gif" alt="RayBan"></a></li>
                    <li><a href="#"><img src="${_SKIN_IMG_PATH}/main/brand_img02.gif" alt="roberto cavalli"></a></li>
                    <li><a href="#"><img src="${_SKIN_IMG_PATH}/main/brand_img03.gif" alt="POLICE"></a></li>
                    <li><a href="#"><img src="${_SKIN_IMG_PATH}/main/brand_img04.gif" alt="ESCADA"></a></li>
                    <li><a href="#"><img src="${_SKIN_IMG_PATH}/main/brand_img05.gif" alt="BALLY"></a></li>
                    <li><a href="#"><img src="${_SKIN_IMG_PATH}/main/brand_img06.gif" alt="BVLGARI"></a></li>
                </ul>
            </div>
            <!--// BRAND SHOP -->
        </div>

        <input type="hidden" id = "popupGrpCd" name = "popupGrpCd" value = "MM" />
        <%@ include file="/WEB-INF/views/include/popupLayer.jsp" %>
        <!-- 상품이미지 미리보기 팝업 -->
        <div id="div_goodsPreview"  class="popup_goods_plus" style="display: none;">
            <div id ="goodsPreview"></div>
        </div>
        <!--- popup 장바구니 등록성공 --->
        <div class="alert_body" id="success_basket" style="display: none;">
            <button type="button" class="btn_alert_close"><img src="/front/img/common/btn_close_popup02.png" alt="팝업창닫기"></button>
            <div class="alert_content">
                <div class="alert_text" style="padding:32px 0 16px">
                    상품이 장바구니에 담겼습니다.
                </div>
                <div class="alert_btn_area">
                    <button type="button" class="btn_alert_cancel" id="btn_close_pop">계속 쇼핑</button>
                    <button type="button" class="btn_alert_ok" id="btn_move_basket">장바구니로</button>
                </div>
            </div>
        </div>
        <%-- main Bottom --%>


        <%--

        <c:if test="${!empty displayGoods1}">
            <div class="main_layout_middle">
                <data:goodsList value="${displayGoods1}" mainYn="Y" headYn="Y" iconYn="Y" />
            </div>
            <div class="divice_line"></div>
        </c:if>

        <c:if test="${!empty displayGoods2}">
        <div class="main_layout_middle">
            <data:goodsList value="${displayGoods2}" mainYn="Y" headYn="Y" iconYn="Y" />
        </div>
        <div class="divice_line"></div>
        </c:if>

        <c:if test="${!empty displayGoods3}">
        <div class="main_layout_middle">
            <data:goodsList value="${displayGoods3}" mainYn="Y" headYn="Y" iconYn="Y" />
        </div>
        <div class="divice_line"></div>
        </c:if>

        <c:if test="${!empty displayGoods4}">
            <div class="main_layout_middle">
                <data:goodsList value="${displayGoods4}" mainYn="Y" headYn="Y" iconYn="Y" />
            </div>
            <div class="divice_line"></div>
        </c:if>

        <c:if test="${!empty displayGoods5}">
            <div class="main_layout_middle">
                <div id="main_best_product">
                <data:goodsList value="${displayGoods5}" headYn="Y" iconYn="Y" />
                </div>
            </div>
        </c:if>

        --%>
        
    </t:putAttribute>
</t:insertDefinition>