<%@ tag import="java.util.StringTokenizer" %>
<%@ tag language="java" body-content="scriptless" pageEncoding="utf-8" description="그리드 페이징" trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="grid" tagdir="/WEB-INF/tags/grid" %>
<%@ attribute name="id" required="false" description="그리드 ID" type="java.lang.String" %>
<%@ attribute name="so" required="true" description="검색조건 SO 객체" type="dmall.framework.common.model.BaseSearchVO" %>
<%@ attribute name="resultListModel" required="true" description="검색결과인 ResultListModel 객체" type="dmall.framework.common.model.ResultListModel" %>
<%@ attribute name="hasExcel" required="false"  description="엑셀 다운로드 여부" type="java.lang.Boolean" %>
<%@ attribute name="sortOptionStr" required="false" description="그리드 정렬 기준 옵션 es) REG_DTTM:최근등록일;REG_DTTM DESC:등록일 역순" type="java.lang.String" %>
<%@ attribute name="rowsOptionStr" required="false" description="그리드 출력 기준 옵션 ex) 10, 50, 100" type="java.lang.String" %>
<%
    String idStr = id != null ? "id=\"" + id + "\"" : "";
    String rowsOption = "10, 20, 50, 100";
    String sortOption = "REG_DTTM DESC:최근 등록일;UPD_DTTM DESC:최근 수정일";
    String sidxOptions = "";
    String rowsOptions = "";

    if(rowsOptionStr != null) {
        rowsOption = rowsOptionStr;
    }

    if(sortOptionStr != null) {
        sortOption = sortOptionStr;
    }

    StringTokenizer sortOptionToken = new StringTokenizer(sortOption, ";");
    StringTokenizer sortToken;
    String value;
    for(String token; sortOptionToken.hasMoreTokens();) {
        token = sortOptionToken.nextToken().trim();
        sortToken = new StringTokenizer(token, ":");
        value = sortToken.nextToken();
        sidxOptions += "<option value=\"" + value + "\"";

        if(value.equals(String.valueOf(so.getSort()))) {
            sidxOptions += " selected=\"selected\"";
        }
        sidxOptions += ">" + sortToken.nextToken() + "</option>";
    }

    StringTokenizer rowsOptionToken = new StringTokenizer(rowsOption, ",");
    for(String token; rowsOptionToken.hasMoreTokens();) {
        token = rowsOptionToken.nextToken().trim();
        rowsOptions += "<option value=\"" + token + "\"";
        if(token.equals(String.valueOf(so.getRows()))) {
            rowsOptions += " selected=\"selected\"";
        }
        rowsOptions += ">" + token + "개 출력</option>";
    }

%>
<div class="line_box"<%= idStr %>>
    <div class="top_lay">
        <div class="search_txt">
            검색 <strong class="be">${resultListModel.filterdRows}</strong>개 /
            총 <strong class="all">${resultListModel.totalRows}</strong>개
        </div>
        <div class="select_btn">
<%
    if(!sidxOptions.equals("")) {
%>
            <span class="select">
                <label></label>
                <select name="sidx">
                    <%= sidxOptions %>
                </select>
            </span>
<%
    }
    if(!rowsOptions.equals("")) {
%>

            <span class="select">
                <label></label>
                <select name="rows">
                    <%= rowsOptions %>
                </select>
            </span>
<%
    }
    if(hasExcel != null && hasExcel) {
%>
            <a href="#none" class="btn_exl"><span class="txt">Excel download</span> <span class="ico_comm">&nbsp;</span></a>
<%
    }
%>
        </div>
    </div>
    <jsp:doBody />
</div>