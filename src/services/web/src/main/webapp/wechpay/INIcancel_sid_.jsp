<!------------------------------------------------------------------------------
FILE NAME : INIcancel_sid.html
AUTHOR : mi@inicis.com
DATE : 2017/01
USE WITH : INIcancel_sid.jsp, config.jsp, INIpayJAVA.jar

SID�� ���� ��Ҹ� ��û�Ѵ�.

Copyright 2007 Inicis, Co. All rights reserved.
------------------------------------------------------------------------------->


<html>
    <head>
        <title>INIpay</title>
        <meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
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
        <form name=ini method=post action=INIcancel_sid.jsp>

            <table border=0 width=500>
                <tr>
                    <td>
                        <hr noshade size=1>
                        <b>SID ���� ��� ����</b>
                        <hr noshade size=1>
                    </td>
                </tr>

                <tr>
                    <td>
                        <font color=gray>
                        �� �������� ������ ����ϴ� JSP, HTML���� �����ϱ� ���� �����Դϴ�.
                        �ͻ��� �䱸�� �°� ������ �����Ͽ� ����Ͻʽÿ�.
                        </font>
                    </td>
                </tr>

                <tr>
                    <td>
                        <br>���ҽÿ� ��� �Ǵ� �ŷ���ȣ(SID)�� �Է��Ͽ� ������ ����մϴ�.
                    </td>
                </tr>
            </table>
            <br>

            <table border=0 width=500>
                <tr>
                    <td align=center>
                        <table width=450 cellspacing=0 cellpadding=0 border=0 bgcolor=#6699CC>
                            <tr>
                                <td>
                                    <table width=100% cellspacing=1 cellpadding=2 border=0>
                                        <tr bgcolor=#BBCCDD height=25>
                                            <td align=center>
                                                ������ �����Ͻ� �� Ȯ�ι�ư�� �����ֽʽÿ�
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
                                                                    <td>�������̵� : </td>
                                                                    <td><input type=text name=mid size=10 value="INIpayTes2"></td>
                                                                </tr>

                                                                <tr>
                                                                    <td>�ŷ���ȣ(SID) : </td>
                                                                    <td><input type=text name=sid size=40 value=""></td>
                                                                </tr>
                                                                <tr>
                                                                    <td>���Ҽ��� : </td>
                                                                    <td><input type=text name=paymethod size=10 value="TPAY"> (��ê���� : TPAY)</td>
                                                                </tr>
                                                                <tr>
                                                                    <td>�����ڵ�  </td>
                                                                    <td><input type=text name=svccode size=10 value="W"> (��ê���� : W)</td>
                                                                </tr>                                                                
                                                                <tr>
                                                                    <td>��һ��� : </td>
                                                                    <td><input type=text name=cancelMsg size=40 value=""></td>
                                                                </tr>

                                                                <tr>
                                                                    <td colspan=2 align=center>
                                                                        <br>
                                                                        <input type="submit" value=" Ȯ �� ">
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

        </form>
    </body>
</html>
