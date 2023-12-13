<%@ page language="java" contentType="text/html; charset=UTF-8"
 pageEncoding="UTF-8"%>
<div id="nointerestLayer" class="layer_popup">
    <div class="pop_wrap size1">
        <!-- pop_tlt -->
        <div class="pop_tlt">
            <h2 class="tlth2">KCP 무이자 기간 생성</h2>
            <button class="close ico_comm">닫기</button>
        </div>
        <!-- //pop_tlt -->
        <!-- pop_con -->
        <div class="pop_con">
            <div>
                <p class="desc_txt">* 무이자할부 안내</p>
                <ul class="desc_txt top ">
                    <li>- 무이자할부는 반드시 KCP와 별도로 협의 또는 계약하셔야 합니다.</li>
                    <li>- 무이자할부기간은 2~12개월까지 가능합니다.</li>
                </ul>
                <p class="desc_txt">* 무이자 기간코드 생성방법</p>
                <ol class="desc_txt top ">
                    <li>1) 삼성카드 6개월무이자라면 먼저 카드사에서 삼성카드를 선택하세요.</li>
                    <li>2) 아래 기간선택에서 6을 선택하세요.</li>
                    <li>3) 무이자기간코드생성 버튼을 누르면 아래에 코드가 생성됩니다.</li>
                    <li>4) 다른 카드사를 추가하려면 체크버튼을 해제하고 위와같은 방식으로 다시 생성합니다.</li>
                </ol>
                <!-- tblw -->
                <div class="tblw mt0">
                    <table summary="이표는 KCP 무이자 기간 생성 표 입니다. 구성은  입니다.">
                        <caption>KCP 무이자 기간 생성</caption>
                        <colgroup>
                            <col width="20%">
                            <col width="80%">
                        </colgroup>
                        <tbody>
                            <tr>
                                <th>카드사 선택</th>
                                <td>
                                    <input type="checkbox" id="" class="blind">
                                    <label for="" class="chack mr20">
                                        <span class="ico_comm">&nbsp;</span>
                                        비씨카드 
                                    </label>
                                    <input type="checkbox" id="" class="blind">
                                    <label for="" class="chack mr20">
                                        <span class="ico_comm">&nbsp;</span>
                                        현대카드 
                                    </label>
                                    <input type="checkbox" id="" class="blind">
                                    <label for="" class="chack mr20">
                                        <span class="ico_comm">&nbsp;</span>
                                        외환카드 
                                    </label>
                                    <input type="checkbox" id="" class="blind">
                                    <label for="" class="chack mr20">
                                        <span class="ico_comm">&nbsp;</span>
                                        국민카드 
                                    </label>
                                    <input type="checkbox" id="" class="blind">
                                    <label for="" class="chack mr20">
                                        <span class="ico_comm">&nbsp;</span>
                                        신한카드  
                                    </label>
                                    <input type="checkbox" id="" class="blind">
                                    <label for="" class="chack mr20">
                                        <span class="ico_comm">&nbsp;</span>
                                        롯데카드 
                                    </label>
                                    <input type="checkbox" id="" class="blind">
                                    <label for="" class="chack mr20">
                                        <span class="ico_comm">&nbsp;</span>
                                        삼성카드 
                                    </label>
                                    <input type="checkbox" id="" class="blind">
                                    <label for="" class="chack mr20">
                                        <span class="ico_comm">&nbsp;</span>
                                        NH카드
                                    </label>
                                </td>
                            </tr>
                            <tr>
                                <th>기간선택<br>(할부개월)</th>
                                <td>
                                    <input type="checkbox" id="" class="blind">
                                    <label for="" class="chack mr20">
                                        <span class="ico_comm">&nbsp;</span>
                                        2
                                    </label>
                                    <input type="checkbox" id="" class="blind">
                                    <label for="" class="chack mr20">
                                        <span class="ico_comm">&nbsp;</span>
                                        3
                                    </label>
                                    <input type="checkbox" id="" class="blind">
                                    <label for="" class="chack mr20">
                                        <span class="ico_comm">&nbsp;</span>
                                        4
                                    </label>
                                    <input type="checkbox" id="" class="blind">
                                    <label for="" class="chack mr20">
                                        <span class="ico_comm">&nbsp;</span>
                                        5
                                    </label>
                                    <input type="checkbox" id="" class="blind">
                                    <label for="" class="chack mr20">
                                        <span class="ico_comm">&nbsp;</span>
                                        6
                                    </label>
                                    <input type="checkbox" id="" class="blind">
                                    <label for="" class="chack mr20">
                                        <span class="ico_comm">&nbsp;</span>
                                        7
                                    </label>
                                    <input type="checkbox" id="" class="blind">
                                    <label for="" class="chack mr20">
                                        <span class="ico_comm">&nbsp;</span>
                                        8
                                    </label>
                                    <input type="checkbox" id="" class="blind">
                                    <label for="" class="chack mr20">
                                        <span class="ico_comm">&nbsp;</span>
                                        9
                                    </label>
                                    <input type="checkbox" id="" class="blind">
                                    <label for="" class="chack mr20">
                                        <span class="ico_comm">&nbsp;</span>
                                        10
                                    </label>
                                    <input type="checkbox" id="" class="blind">
                                    <label for="" class="chack mr20">
                                        <span class="ico_comm">&nbsp;</span>
                                        11
                                    </label>
                                    <input type="checkbox" id="" class="blind">
                                    <label for="" class="chack mr20">
                                        <span class="ico_comm">&nbsp;</span>
                                        12
                                    </label>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
                <!-- //tblw -->
                <ul class="desc_list">
                    <li>위에서 카드사와 기간을 선택하면 아래에 코드가 생성됩니다. 복사한 후 창을 닫고 사용하세요.</li>
                    <li>KB카드 3개월, 삼성카드 6개월, 현대카드 12개월일 경우, 11-3, 51-6, 61-12 이렇게 됩니다.</li>
                    <li>즉, ‘카드사고유번호-개월수’가 코드명이 됩니다.</li>
                </ul>               
                <div class="btn_box txtc">
                    <button class="btn green">카드사별 기간코드 생성 적용</button>
                </div>
            </div>
        </div>
        <!-- //pop_con -->
    </div>
</div>