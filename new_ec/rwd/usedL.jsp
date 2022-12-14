<%@page import="com.enjar.system.LoginUtil" %>
<%@page import="com.taaze.system.util.CookieSecure" %>
<%@page import="com.xsx.customer.service.CustQingdanService" %>
<%@page import="com.xsx.ec.service.EcPathSetting" %>
<%@page import="com.xsx.ec.service.impl.EcPathSettingImp" %>
<%@page import="java.net.URLEncoder" %>
<%@page import="java.text.DecimalFormat" %>
<%@page import="net.sf.json.JSONArray"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="com.enjar.system.SystemUtil"%>
<%@page import="java.text.SimpleDateFormat" %>
<%@page import="java.util.Calendar" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="javax.sql.DataSource" %>
<%@ page import="com.enjar.system.util.SpringUtil" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ taglib uri="/WEB-INF/tlds/c.tld" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8" %>
<%
String pid="11100969668";
JSONArray items = new JSONArray();
try {
	String s = SystemUtil.getEcJsonStrFromCacheByActionUrl("api/getWebEcSingleSameCatSaleDatas.html?p=" + pid);
	items = JSONArray.fromObject(s);
	out.print(s);
} catch (Exception e) {
	out.print("pid:"+pid+",error:"+e.getMessage());
	items = null;
}
out.print("ss");
Connection cn = null;
ResultSet rs = null;
PreparedStatement pstmt = null;
try {
	DataSource ds = (DataSource) SpringUtil.getSpringBeanById(this.getServletConfig(), "datasource");
	cn = ds.getConnection();
	String query = "SELECT P.ORG_PROD_ID orgProdId, P.TITLE_MAIN titleMain, P.TITLE_NEXT titleNext, " +
	"P.PROD_CAT_ID prodCatId, PM.CAT_ID catId, P.LIST_PRICE listPrice, P.SPECIAL_PRICE specialPrice, P.SALE_PRICE salePrice, P.SALE_DISC saleDisc,P.ORG_FLG orgFlg, PM.PUB_ID pubId, PM.AUTHOR_MAIN author, PM.ISBN isbn, PM.PUBLISH_DATE publishDate, PM.IST_PROD_ID istProdId, PM.SNDHAND_FLG sndHandFlg, PM.OUT_OF_PRINT outOfPrint, PB.TRANSLATOR translator, PB.PAINTER painter, PUB.PUB_NM_MAIN pubNmMain, PP.PROD_PF prodPf, PM.RANK rank, " +
	"(SELECT CAT_NM FROM CAT4XSX WHERE CAT_ID = PM.CAT_ID AND PROD_CAT_ID = PM.PROD_CAT_ID) catName, CASE WHEN SUBSTR(PM.CAT_ID,3,2) = '00' THEN '' ELSE (SELECT CAT_NM FROM CAT4XSX WHERE SUBSTR(CAT_ID,0,2) = SUBSTR(PM.CAT_ID,0,2) AND PROD_CAT_ID = PM.PROD_CAT_ID AND CAT_LEVEL = 1) END AS CatName1 " +
	"FROM PRODUCT P, PRODINFO_MAIN PM, PRODINFO_BOOK PB, PROD_PROFILE PP , PUBLISHER PUB " +                        "WHERE P.ORG_PROD_ID = PM.ORG_PROD_ID AND PM.ORG_PROD_ID = PB.ORG_PROD_ID(+) AND PM.PUB_ID = PUB.PUB_ID(+) AND PM.ORG_PROD_ID = PP.ORG_PROD_ID(+) AND P.PROD_CAT_ID IN ('11','12','13','24','27') " +                                   "AND P.STATUS_FLG = 'Y' AND P.ORG_FLG = 'A' " + "AND P.PROD_ID = ?";
	pstmt = cn.prepareStatement(query);
	pstmt.setString(1, "11100977212");
	rs = pstmt.executeQuery();                                                                                      if (rs.next()) {
		out.print(rs.getString("titleMain"));                                                                                                                                                                                             }
		rs.close();
		pstmt.close();
		cn.close();
	} catch (Exception e) {
		
		out.println(e.getMessage());
	} finally {
		try {
		
			if (pstmt != null && !pstmt.isClosed()) {
				pstmt.close();
			}
			if (cn != null && !cn.isClosed()) {
				
				cn.close();
				
			}
			
		} catch (Exception ex) {
			
			out.print(ex.getMessage());
			
		}
		
	}
	
	String fbTitle = "?????????????????????????????????|?????????????????????- TAAZE ????????????";
	String fbDes = "???????????????????????????|";
	String fbImage = "https://media.taaze.tw/showProdImage.html?sc=11100969668&width=200&height=283";
	%>
	
	<!DOCTYPE html>
	<html>
	<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge"/>
	<meta name="robots" content="index, follow"/>
	<meta name="keywords" content="<%=fbTitle %>"/>
	<meta name="title" content="<%=fbTitle %>"/>
	<meta name="description" content="<%=fbDes%>"/>
	<meta property="fb:app_id" content="362610148222713"/>
	<meta name="og:site_name" content="TAAZE ????????????">
	<meta property="og:title" content="<%=fbTitle %>"/>
	<meta property="og:description" content="<%=fbDes%>"/>
	<meta property="og:image" content="<%=fbImage %>"/>
	<c:choose>
	<c:when test="${cookie['mobile'].value eq 'on'}">
	<meta name="viewport" content="width=1200, initial-scale=1, user-scalable=yes">
	</c:when>
	<c:otherwise>
	<meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=no">
	</c:otherwise>
	</c:choose>
	<title><%=fbTitle %></title>
	<%@ include file="/new_ec/rwd/include/jsp/include_goods.jsp" %>
	<%@ include file="/new_ec/gift/include/css_include.jsp" %>
	<%@ include file="/new_ec/rwd/include/js.jsp" %>
	<%@ include file="/new_ec/rwd/include/css.jsp" %>
	<link href="<%=EcPathSetting.WEB_JS_PATH%>/tipsy.css" rel="stylesheet" type="text/css"/>
	<link href="/new_ec/single/include/js/rateit.css" media="screen, projection" rel="stylesheet" type="text/css">
	<link rel="stylesheet" type="text/css" href="/include2/css/alertify.core.css"/>
	<link rel="stylesheet" type="text/css" href="/include2/css/alertify.default.css"/>
	<link rel="stylesheet" type="text/css" href="/include2/css/jquery.jgrowl.min.css"/>
	<link rel="stylesheet" type="text/css" href="/include2/tooltipster/css/tooltipster.bundle.min.css"/>
	<link rel="stylesheet" type="text/css"
	href="/include2/tooltipster/css/plugins/tooltipster/sideTip/themes/tooltipster-sideTip-light.min.css"/>
	<link rel="stylesheet" type="text/css" href="/include2/css/swiper.min.css"/>
	<link rel="stylesheet" type="text/css" href="/include2/colorbox/colorbox.css"/>
	<link rel="canonical" href="https://www.taaze.tw/usedList.html?oid=11100977212"/>
	</head>

	<body>
	</body>
	</html>