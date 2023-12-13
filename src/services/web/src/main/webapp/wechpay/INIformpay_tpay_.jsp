<!------------------------------------------------------------------------------
FILE NAME : INIformpay_tpay.html
AUTHOR : mi@inicis.com
DATE : 2016/05
USE WITH : INIformpay_tpay.jsp, config.jsp, INIpayJAVA.jar

Copyright 2016 Inicis, Co. All rights reserved.
------------------------------------------------------------------------------->
<%@ page language = "java" contentType = "text/html; charset=euc-kr" %>

<html>
    <head>
        <title>INIpay for Wechat</title>
        <meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
        <script language=javascript>

            var openwin;


            function pay(frm)
            {
                return true;
            }


        </script>	

        <style type="text/css">
            BODY{font-size:9pt; line-height:160%}
            TD{font-size:9pt; line-height:160%}
            A {color:blue;line-height:160%; background-color:#E0EFFE}
            INPUT{font-size:9pt;}
            SELECT{font-size:9pt;}
            .emp{background-color:#FDEAFE;}
        </style>
    </head>

    <body>

        <!-- pay()가 "true"를 반환하면 post된다 -->
        <form name="ini" method=post action=INIformpay_tpay.jsp onSubmit="return pay(this)">
            <br>
            <table border=0 width=500>
                <tr>
                    <td align=center>
                        <table width=300 cellspacing=0 cellpadding=0 border=0 bgcolor=#6699CC>
                            <tr>
                                <td>
                                    <table width=100% cellspacing=1 cellpadding=2 border=0>
                                        <tr bgcolor=#BBCCDD height=25>
                                            <td align=center>
                                                정보를 기입하신 후 지불버튼을 눌러주십시오
                                            </td>
                                        </tr>
                                        <tr bgcolor=#FFFFFF>
                                            <td valign=top>
                                                <table width=100% cellspacing=0 cellpadding=2 border=0>
                                                    <tr>
                                                        <td align=center>
                                                            <br>
                                                            <table>
                                                                <tr>
                                                                    <td>상품명 : </td>
                                                                    <td><input type=text name=goodname size=20 value="배구공"></td>
                                                                </tr>

                                                                <tr> 
                                                                    <td>가격 : </td>
                                                                    <td><input type=text name=price size=20 value="1000"></td>
                                                                </tr>

                                                                <tr>
                                                                    <td>성명 : </td> 
                                                                    <td><input type=text name=buyername size=20 value="홍길동"></td>
                                                                </tr>

                                                                <tr>
                                                                    <td>전자우편 : </td>
                                                                    <td>
                                                                        <input type=text name=buyeremail size=20 value="test@inicis.com">
                                                                    </td>
                                                                </tr>

                                                                <tr>
                                                                    <td>이동전화 : </td>
                                                                    <td>
                                                                        <input type=text name=buyertel size=20 value="011-123-1234">
                                                                    </td>
                                                                </tr>

                                                                <tr>
                                                                    <td>인증코드 : </td>
                                                                    <td><input type=text name=wech_authcode size=20 value=""></td>
                                                                </tr>

                                                                <tr>
                                                                    <td>서브가맹점사업자번호 : </td>
                                                                    <td><input type=text name=wech_companynumber  size=20 value=""></td>
                                                                </tr>
                                                                <tr>
                                                                    <td colspan=2 align=center>
                                                                        <br>
                                                                        <input type="submit" value=" 지 불 " >
                                                                        <br><br>
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
            <br>

            <table border=0 width=500>
                <tr>
                    <td><hr noshade size=1></td>
                </tr>

                <tr>
                    <td align=right>Copyright Inicis, Co.<br>www.inicis.com</td>
                </tr>
            </table>


            <!-- 
            상점아이디.
            테스트를 마친 후, 발급받은 아이디로 바꾸어 주십시오.
            -->
            <input type=hidden name=mid value="INIpayTes2">

            <!--
            화폐단위
            WON 또는 USD
            주의 : 미화승인은 별도 계약이 필요합니다.
            -->
            <input type=hidden name=currency value="WON">

        </form>
    </body>
</html>

