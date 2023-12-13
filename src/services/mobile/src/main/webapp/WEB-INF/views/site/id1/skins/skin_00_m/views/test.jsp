<%--
  Created by IntelliJ IDEA.
  User: dong
  Date: 2016-05-17
  Time: 오후 4:56
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="t" uri="http://tiles.apache.org/tags-tiles"%>
<t:insertDefinition name="defaultLayout">
    <t:putAttribute name="title">테스트</t:putAttribute>
    
    
    
    <t:putAttribute name="script">
        <script></script>
    </t:putAttribute>
    <t:putAttribute name="content">
        <!--- 05.LAYOUT: MAIN VISUAL AREA --->
        <!--- main visual --->
        <div style="width:100%;height:100%;background:#ccc;text-align:center;padding:150px 0;font-size:18px">main/main_visual.html</div>
        <!---// main visual --->
        <!---// 05.LAYOUT: MAIN VISUAL AREA --->
        <div class="divice_line"></div>

        <!--- 06.LAYOUT: MAIN NEW ARRIVAL AREA --->
        <!--- new product --->
        <div class="main_layout_middle">
            <div style="width:100%;height:100%;background:#ddd;text-align:center;padding:150px 0;font-size:18px">main/main_new_arrival.html</div>
        </div>
        <!---// new product --->
        <!---// 06.LAYOUT: MAIN NEW ARRIVAL AREA --->
        <div class="divice_line"></div>

        <!--- 07.LAYOUT: MAIN BEST PRODUCT AREA --->
        <!--- main best product --->
        <div class="main_layout_middle">
            <div style="width:100%;height:100%;background:#ccc;text-align:center;padding:150px 0;font-size:18px">main/main_best_product.html</div>
        </div>
        <!---// main best product --->
        <!---// 07.LAYOUT: MAIN BEST PRODUCT AREA --->
        <div class="divice_line"></div>

        <!--- 08.LAYOUT: MAIN PRODUCT AREA --->
        <!--- main product --->
        <div class="main_layout_middle">
            <div style="width:100%;height:100%;background:#ddd;text-align:center;padding:150px 0;font-size:18px">main/main_product.html</div>
        </div>
        <!---// main product --->
        <!---// 08.LAYOUT: MAIN PRODUCT AREA --->
        <div class="divice_line"></div>
    </t:putAttribute>
</t:insertDefinition>