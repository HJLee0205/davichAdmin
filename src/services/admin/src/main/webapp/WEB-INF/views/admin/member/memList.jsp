<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<t:insertDefinition name="defaultLayout">
    <t:putAttribute name="title">회원리스트</t:putAttribute>
    <t:putAttribute name="script">
        <script type="text/javascript">

            jQuery(document).ready(function() {
                $('#frmTest').on('submit', function() {
                    var url = '/admin/example/test-validate-json',
                            param = $('frmTest').serialize();

                    $.post(url, param, function(result) {
                    });
                    return false;
                });
            })
        </script>
    </t:putAttribute>
    <t:putAttribute name="content">
        <div class="sec01_box">
            <div class="tlt_box">
                <h2 class="tlth2">회원리스트</h2>
                <div class="btn_box left">
                    <a href="#none" class="btn green">검색</a>
                </div>
            </div>
            <!-- line_box -->
            <div class="line_box fri">
                <!-- tblw -->
                <div class="tblw">
                    <table summary="이표는 회원리스트 검색 표 입니다. 구성은 가입일, 최종방문일, 생일, SMS수신, 이메이수신, 회원등급, 구매금액, 마켓포인트, 주문횟수, 댓글횟수, 방문횟수, 성별, 포인트, 가입방법, 검색어 입니다.">
                        <caption>회원리스트 검색</caption>
                        <colgroup>
                            <col width="15%">
                            <col width="35%">
                            <col width="15%">
                            <col width="35%">
                        </colgroup>
                        <tbody>
                        <tr>
                            <th>가입일</th>
                            <td colspan="3">
                                <span class="intxt"><input type="text" value="" id="bell_date_sc01" class="bell_date_sc"></span>
                                <a href="javascript:void(0)" class="date_sc ico_comm" id="bell_date01">달력이미지</a>
                                ~
                                <span class="intxt"><input type="text" value="" id="bell_date_sc02" class="bell_date_sc"></span>
                                <a href="javascript:void(0)" class="date_sc ico_comm" id="bell_date02">달력이미지</a>
                                <div class="tbl_btn">
                                    <button class="btn_day on">오늘</button>
                                    <button class="btn_day">3일간</button>
                                    <button class="btn_day">일주일</button>
                                    <button class="btn_day">1개월</button>
                                    <button class="btn_day">3개월</button>
                                    <button class="btn_day">전체</button>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <th>최종방문일</th>
                            <td colspan="3">
                                <span class="intxt"><input type="text" value="" id="bell_date_sc03" class="bell_date_sc"></span>
                                <a href="javascript:void(0)" class="date_sc ico_comm" id="bell_date03">달력이미지</a>
                                ~
                                <span class="intxt"><input type="text" value="" id="bell_date_sc04" class="bell_date_sc"></span>
                                <a href="javascript:void(0)" class="date_sc ico_comm" id="bell_date04">달력이미지</a>
                                <div class="tbl_btn">
                                    <button class="btn_day on">오늘</button>
                                    <button class="btn_day">3일간</button>
                                    <button class="btn_day">일주일</button>
                                    <button class="btn_day">1개월</button>
                                    <button class="btn_day">3개월</button>
                                    <button class="btn_day">전체</button>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <th>생일</th>
                            <td colspan="3">
                                <span class="intxt"><input type="text" value="" id="bell_date_sc05" class="bell_date_sc"></span>
                                <a href="javascript:void(0)" class="date_sc ico_comm" id="bell_date05">달력이미지</a>
                                ~
                                <span class="intxt"><input type="text" value="" id="bell_date_sc06" class="bell_date_sc"></span>
                                <a href="javascript:void(0)" class="date_sc ico_comm" id="bell_date06">달력이미지</a>
                                <div class="tbl_btn">
                                    <button class="btn_day on">오늘</button>
                                    <button class="btn_day">3일간</button>
                                    <button class="btn_day">일주일</button>
                                    <button class="btn_day">1개월</button>
                                    <button class="btn_day">3개월</button>
                                    <button class="btn_day">전체</button>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <th>SMS수신</th>
                            <td>
                                <label for="radio01" class="radio mr20 on"><span class="ico_comm"><input type="radio" name="SMS" id="radio01" checked="checked" /></span> 전체</label>
                                <label for="radio02" class="radio mr20"><span class="ico_comm"><input type="radio" name="SMS" id="radio02" /></span> 동의</label>
                                <label for="radio03" class="radio mr20"><span class="ico_comm"><input type="radio" name="SMS" id="radio03" /></span> 거부</label>
                            </td>
                            <th class="line">이메일수신</th>
                            <td>
                                <label for="radio04" class="radio mr20 on"><span class="ico_comm"><input type="radio" name="mail" id="radio04" checked="checked" /></span> 전체</label>
                                <label for="radio05" class="radio mr20"><span class="ico_comm"><input type="radio" name="mail" id="radio05" /></span> 동의</label>
                                <label for="radio06" class="radio mr20"><span class="ico_comm"><input type="radio" name="mail" id="radio06" /></span> 거부</label>
                            </td>
                        </tr>
                        <tr>
                            <th>회원등급</th>
                            <td>
								<span class="select">
									<select name="" id="select1">
										<option value="">전체</option>
									</select>
								</span>
                            </td>
                            <th class="line">구매금액</th>
                            <td>
                                <span class="intxt"><input type="text" value="" id="" class="txtr" /></span>
                                ~
                                <span class="intxt"><input type="text" value="" id="" class="txtr" /></span>
                            </td>
                        </tr>
                        <tr>
                            <th>마켓포인트</th>
                            <td>
                                <span class="intxt"><input type="text" value="" id="" class="txtr" /></span>
                                ~
                                <span class="intxt"><input type="text" value="" id="" class="txtr" /></span>
                            </td>
                            <th class="line">주문횟수</th>
                            <td>
                                <span class="intxt"><input type="text" value="" id="" class="txtr" /></span>
                                ~
                                <span class="intxt"><input type="text" value="" id="" class="txtr" /></span>
                            </td>
                        </tr>
                        <tr>
                            <th>댓글횟수</th>
                            <td>
                                <span class="intxt"><input type="text" value="" id="" class="txtr" /></span>
                                ~
                                <span class="intxt"><input type="text" value="" id="" class="txtr" /></span>
                            </td>
                            <th class="line">방문횟수</th>
                            <td>
                                <span class="intxt"><input type="text" value="" id="" class="txtr" /></span>
                                ~
                                <span class="intxt"><input type="text" value="" id="" class="txtr" /></span>
                            </td>
                        </tr>
                        <tr>
                            <th>성별</th>
                            <td>
                                <label for="radio07" class="radio mr20 on"><span class="ico_comm"><input type="radio" name="sex" id="radio07" checked="checked" /></span> 전체</label>
                                <label for="radio08" class="radio mr20"><span class="ico_comm"><input type="radio" name="sex" id="radio08" /></span> 남</label>
                                <label for="radio09" class="radio mr20"><span class="ico_comm"><input type="radio" name="sex" id="radio09" /></span> 여</label>
                            </td>
                            <th class="line">포인트</th>
                            <td>
                                <span class="intxt"><input type="text" value="" id="" class="txtr" /></span>
                                ~
                                <span class="intxt"><input type="text" value="" id="" class="txtr" /></span>
                            </td>
                        </tr>
                        <tr>
                            <th>가입정보</th>
                            <td colspan="3">
                                <input type="checkbox" name="table" id="chack01" class="" value="mall" />
                                <label for="chack01" class="chack mr20" onclick="chack_btn(this);">
                                    <span class="ico_comm">&nbsp;</span>
                                    쇼핑몰 ID
                                </label>
                                <input type="checkbox" name="table" id="chack02" class="" value="facebook" />
                                <label for="chack02" class="chack mr20" onclick="chack_btn(this);">
                                    <span class="ico_comm">&nbsp;</span>
                                    페이스북
                                </label>
                                <input type="checkbox" name="table" id="chack03" class="" value="kakao" />
                                <label for="chack03" class="chack mr20" onclick="chack_btn(this);">
                                    <span class="ico_comm">&nbsp;</span>
                                    카카오
                                </label>
                                <input type="checkbox" name="table" id="chack04" class="" value="naver" />
                                <label for="chack04" class="chack mr20" onclick="chack_btn(this);">
                                    <span class="ico_comm">&nbsp;</span>
                                    네이버
                                </label>
                            </td>
                        </tr>
                        <tr>
                            <th>검색어</th>
                            <td colspan="3">
                                <div class="select_inp">
									<span>
										<select name="" id="">
											<option value="">전체</option>
										</select>
									</span>
                                    <input type="text" value="" id="" />
                                </div>
                            </td>
                        </tr>
                        </tbody>
                    </table>
                </div>
                <!-- //tblw -->

            </div>
            <!-- //line_box -->
            <!-- line_box -->
            <div class="line_box">
                <div class="top_lay">
                    <div class="search_txt">
                        검색 <strong class="be">7</strong>개 /
                        총 <strong class="all">2400</strong>개
                    </div>
                    <div class="select_btn">
					<span class="select">
						<select name="" id="">
							<option value="">최근 등록일 순</option>
						</select>
					</span>
					<span class="select">
						<select name="" id="">
							<option value="">10개 출력</option>
						</select>
					</span>
                        <a href="#none" class="btn_exl"><span class="txt">Excel download</span> <span class="ico_comm">&nbsp;</span></a>
                    </div>
                </div>
                <!-- tblh -->
                <div class="tblh">
                    <table summary="이표는 회원리스트 표 입니다. 구성은 체크박스, 번호, 등급, 가입경로, 이름, 아이디, 이메일, 휴대폰번호 전화번호, 가입일 최종방문, 마켓포인트, 방문횟수, 관리 입니다.">
                        <caption>회원리스트</caption>
                        <colgroup>
                            <col width="5%">
                            <col width="6%">
                            <col width="8%">
                            <col width="8%">
                            <col width="8%">
                            <col width="8%">
                            <col width="14%">
                            <col width="10.5%">
                            <col width="8.5%">
                            <col width="8%">
                            <col width="8%">
                            <col width="8%">
                        </colgroup>
                        <thead>
                        <tr>
                            <th>
                                <input type="checkbox" name="table" id="chack05" class="blind" />
                                <label for="chack05" class="chack" onclick="chack_btn(this);">
                                    <span class="ico_comm">&nbsp;</span>
                                </label>
                            </th>
                            <th>번호</th>
                            <th>등급</th>
                            <th>가입경로</th>
                            <th>이름</th>
                            <th>아이디</th>
                            <th>이메일</th>
                            <th>휴대폰번호<br>전호번호</th>
                            <th>가입일<br>최종방문</th>
                            <th>마켓포인트</th>
                            <th>방문횟수</th>
                            <th>관리</th>
                        </tr>
                        </thead>
                        <tbody>
                        <tr>
                            <td>
                                <input type="checkbox" name="table" id="chack05_1" class="blind" />
                                <label for="chack05_1" class="chack" onclick="chack_btn(this);">
                                    <span class="ico_comm">&nbsp;</span>
                                </label>
                            </td>
                            <td>10</td>
                            <td>플래티넘</td>
                            <td>네이버</td>
                            <td>김수정</td>
                            <td><a href="#none">sublime</a></td>
                            <td><a href="#layout1" class="popup_open">sublime@danvistory.com</a></td>
                            <td><a href="#layout2" class="popup_open">010-0000-0000</a><br><a href="#none">010-0000-0000</a></td>
                            <td>2016-04-04<br>2016-04-04</td>
                            <td><a href="#layout3" class="popup_open">10,000</a></td>
                            <td>100</td>
                            <td>
                                <div class="pop_btn">
                                    <a href="#none" class="btn_normal">상세</a>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <input type="checkbox" name="table" id="chack05_2" class="blind" />
                                <label for="chack05_2" class="chack" onclick="chack_btn(this);">
                                    <span class="ico_comm">&nbsp;</span>
                                </label>
                            </td>
                            <td>10</td>
                            <td>플래티넘</td>
                            <td>네이버</td>
                            <td>김수정</td>
                            <td><a href="#none">sublime</a></td>
                            <td><a href="#layout1" class="popup_open">sublime@danvistory.com</a></td>
                            <td><a href="#layout2" class="popup_open">010-0000-0000</a><br><a href="#none">010-0000-0000</a></td>
                            <td>2016-04-04<br>2016-04-04</td>
                            <td><a href="#layout3" class="popup_open">10,000</a></td>
                            <td>100</td>
                            <td>
                                <div class="pop_btn">
                                    <a href="#none" class="btn_normal">상세</a>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <input type="checkbox" name="table" id="chack05_3" class="blind" />
                                <label for="chack05_3" class="chack" onclick="chack_btn(this);">
                                    <span class="ico_comm">&nbsp;</span>
                                </label>
                            </td>
                            <td>10</td>
                            <td>플래티넘</td>
                            <td>네이버</td>
                            <td>김수정</td>
                            <td><a href="#none">sublime</a></td>
                            <td><a href="#layout1" class="popup_open">sublime@danvistory.com</a></td>
                            <td><a href="#layout2" class="popup_open">010-0000-0000</a><br><a href="#none">010-0000-0000</a></td>
                            <td>2016-04-04<br>2016-04-04</td>
                            <td><a href="#layout3" class="popup_open">10,000</a></td>
                            <td>100</td>
                            <td>
                                <div class="pop_btn">
                                    <a href="#none" class="btn_normal">상세</a>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <input type="checkbox" name="table" id="chack05_4" class="blind" />
                                <label for="chack05_4" class="chack" onclick="chack_btn(this);">
                                    <span class="ico_comm">&nbsp;</span>
                                </label>
                            </td>
                            <td>10</td>
                            <td>플래티넘</td>
                            <td>네이버</td>
                            <td>김수정</td>
                            <td><a href="#none">sublime</a></td>
                            <td><a href="#layout1" class="popup_open">sublime@danvistory.com</a></td>
                            <td><a href="#layout2" class="popup_open">010-0000-0000</a><br><a href="#none">010-0000-0000</a></td>
                            <td>2016-04-04<br>2016-04-04</td>
                            <td><a href="#layout3" class="popup_open">10,000</a></td>
                            <td>100</td>
                            <td>
                                <div class="pop_btn">
                                    <a href="#none" class="btn_normal">상세</a>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <input type="checkbox" name="table" id="chack05_5" class="blind" />
                                <label for="chack05_5" class="chack" onclick="chack_btn(this);">
                                    <span class="ico_comm">&nbsp;</span>
                                </label>
                            </td>
                            <td>10</td>
                            <td>플래티넘</td>
                            <td>네이버</td>
                            <td>김수정</td>
                            <td><a href="#none">sublime</a></td>
                            <td><a href="#layout1" class="popup_open">sublime@danvistory.com</a></td>
                            <td><a href="#layout2" class="popup_open">010-0000-0000</a><br><a href="#none">010-0000-0000</a></td>
                            <td>2016-04-04<br>2016-04-04</td>
                            <td><a href="#layout3" class="popup_open">10,000</a></td>
                            <td>100</td>
                            <td>
                                <div class="pop_btn">
                                    <a href="#none" class="btn_normal">상세</a>
                                </div>
                            </td>
                        </tr>
                        </tbody>
                    </table>
                </div>
                <!-- //tblh -->
                <!-- bottom_lay -->
                <div class="bottom_lay">
                    <!-- pageing -->
                    <grid:paging currentPage="1" totalPage="113" totalCount="1133" ></grid:paging>
                    <!-- //pageing -->
                </div>
                <!-- //bottom_lay -->
            </div>
            <!-- //line_box -->
        </div>

    </t:putAttribute>
</t:insertDefinition>
