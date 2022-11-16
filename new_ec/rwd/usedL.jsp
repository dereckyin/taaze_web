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
	// out.print(s);
} catch (Exception e) {
	//out.print("pid:"+pid+",error:"+e.getMessage());
	items = null;
}
out.print("ss");
Connection cn = null;
ResultSet rs = null;
PreparedStatement pstmt = null;

	DataSource ds = (DataSource) SpringUtil.getSpringBeanById(this.getServletConfig(), "datasource");
	cn = ds.getConnection();
	String query = "SELECT P.ORG_PROD_ID orgProdId, P.TITLE_MAIN titleMain, P.TITLE_NEXT titleNext, " +
	"P.PROD_CAT_ID prodCatId, PM.CAT_ID catId, P.LIST_PRICE listPrice, P.SPECIAL_PRICE specialPrice, P.SALE_PRICE salePrice, P.SALE_DISC saleDisc,P.ORG_FLG orgFlg, PM.PUB_ID pubId, PM.AUTHOR_MAIN author, PM.ISBN isbn, PM.PUBLISH_DATE publishDate, PM.IST_PROD_ID istProdId, PM.SNDHAND_FLG sndHandFlg, PM.OUT_OF_PRINT outOfPrint, PB.TRANSLATOR translator, PB.PAINTER painter, PUB.PUB_NM_MAIN pubNmMain, PP.PROD_PF prodPf, PM.RANK rank, " +
	"(SELECT CAT_NM FROM CAT4XSX WHERE CAT_ID = PM.CAT_ID AND PROD_CAT_ID = PM.PROD_CAT_ID) catName, CASE WHEN SUBSTR(PM.CAT_ID,3,2) = '00' THEN '' ELSE (SELECT CAT_NM FROM CAT4XSX WHERE SUBSTR(CAT_ID,0,2) = SUBSTR(PM.CAT_ID,0,2) AND PROD_CAT_ID = PM.PROD_CAT_ID AND CAT_LEVEL = 1) END AS CatName1 " +
	"FROM PRODUCT P, PRODINFO_MAIN PM, PRODINFO_BOOK PB, PROD_PROFILE PP , PUBLISHER PUB " +                        "WHERE P.ORG_PROD_ID = PM.ORG_PROD_ID AND PM.ORG_PROD_ID = PB.ORG_PROD_ID(+) AND PM.PUB_ID = PUB.PUB_ID(+) AND PM.ORG_PROD_ID = PP.ORG_PROD_ID(+) AND P.PROD_CAT_ID IN ('11','12','13','24','27') " +                                   "AND P.STATUS_FLG = 'Y' AND P.ORG_FLG = 'A' " + "AND P.PROD_ID = ?";
	pstmt = cn.prepareStatement(query);
	pstmt.setString(1, "11100977212");
	rs = pstmt.executeQuery();
	if (rs.next()) {
		//out.print(rs.getString("titleMain"));                                                                                                                                                                                             }
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
			
			//out.print(ex.getMessage());
			
		}
		
	}
	
	String fbTitle = "讀冊【二手徵求好處多】|二手書交易資訊- TAAZE 讀冊生活";
	String fbDes = "【二手徵求好處多】|";
	String fbImage = "https://media.taaze.tw/showProdImage.html?sc=11100977212&width=200&height=283";
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
	<meta name="og:site_name" content="TAAZE 讀冊生活">
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
	<!-- critical css -->
<style>
body {
color: #472a2b;
}
.modal-backdrop {
background-color: #fff;
}
.xs-hide {
display: none;
}
.xs-show {
display: inline-block;
}
h4 {
font-size: 22px;
}
a, a:hover {
color: #472a2b;
}
.status_text {
float: left;
padding-left: 5px;
}
.span01, .span02 {
color: #472a2b;
padding: 0 0 0 5px;
}
.span03, .span03 a {
color: #472a2b;
font-size: 12pt;
font-weight: bold;
}
.span04, .span04 a {
color: #472a2b;
font-size: 11pt;
font-weight: normal;
}
.highlightu {
color: #e3007f;
font-weight: bold;
background-color: none;
}
.market-status {
width: 100px;
float: right;
}
.market-status .span03 {
font-size: 11pt;
}
.btn_sale, .btn_cancel_wnt, .btn_sale_verify {
background: url('/new_ec/single/include/images/btn_act.png') no-repeat;
width: 71px;
height: 39px;
cursor: pointer;
font-size: 12pt;
padding: 8px 11px;
margin-right: 10px;
margin: 0px auto;
}
.btn_buy {
background: url('/new_ec/single/include/images/btn_more.png') no-repeat;
width: 102px;
height: 40px;
font-size: 11pt;
padding: 10px 0px;
text-align: center;
margin: 0px auto;
cursor: pointer;
}
.btn_buy:hover {
background: url('/new_ec/single/include/images/btn_more_hover.png') no-repeat;
color: #ffffff;
}
.btn_no_sale {
background: url('/new_ec/single/include/images/btn_more.png') no-repeat;
width: 102px;
height: 40px;
font-size: 10pt;
padding: 10px 0px;
text-align: center;
margin: 0px auto;
}
.btn_cancel_wnt {
width: 71px;
padding: 8px;
font-size: 10pt;
}
.btn_sale:hover, .btn_cancel_wnt:hover, .btn_sale_verify:hover {
background: url('/new_ec/single/include/images/btn_act_hover.png') no-repeat;
color: #ffffff;
}
.sprod_sale_text, .sprod_want_text {
padding: 7px 0px;
font-size: 12pt;
}
.version_left, .version_right {
float: left;
width: 4px;
height: 54px;
}
.version_left {
background: url('/new_ec/single/include/images/version_bk_left.png') no-repeat;
}
.version_right {
background: url('/new_ec/single/include/images/version_bk_right.png') no-repeat;
}
.version_middle {
float: left;
height: 54px;
background: url('/new_ec/single/include/images/version_bk_middle.png') 0px -1px repeat-x;
padding: 5px 10px 0 10px;
font-size: 10pt;
}
ul#prodInfo3 li {
font-size: 10pt;
color: #454545;
margin: 0 0 10px 0;
}
.commentLink, .collectLink, .collectLink2, .wantSndLink, .previewLink, .shareLink {
padding: 1px 15px 0 22px;
cursor: pointer;
color: #472a2b;
font-size: 11pt;
text-decoration: none;
font-weight: bold;
}
.commentLink {
background: url('<s:property value="#attr.INIT_SERVER_MAP.web_url"/>/new_ec/single/include/images/cmt_bg1.png') 5px 2px no-repeat;
}
.commentLink:hover {
color: #e3007f;
background: url('<s:property value="#attr.INIT_SERVER_MAP.web_url"/>/new_ec/single/include/images/cmt_bg2.png') 5px 2px no-repeat;
}
.collectLink {
background: url('<s:property value="#attr.INIT_SERVER_MAP.web_url"/>/new_ec/single/include/images/clt_bg1.png') 2px 4px no-repeat;
}
.collectLink:hover {
color: #e3007f;
background: url('<s:property value="#attr.INIT_SERVER_MAP.web_url"/>/new_ec/single/include/images/clt_bg2.png') 2px 4px no-repeat;
}
.collectLink2, .collectLink2:hover {
color: #e3007f;
background: url('<s:property value="#attr.INIT_SERVER_MAP.web_url"/>/new_ec/single/include/images/clt_bg2.png') 2px 4px no-repeat;
}
.wantSndLink {
background: url('<s:property value="#attr.INIT_SERVER_MAP.web_url"/>/new_ec/single/include/images/wnd_bg1.png') 0px 3px no-repeat;
}
.wantSndLink:hover {
color: #e3007f;
text-decoration: none;
background: url('/new_ec/single/include/images/wnd_bg2.png') 0px 3px no-repeat;
}
.previewLink {
background: url('<s:property value="#attr.INIT_SERVER_MAP.web_url"/>/new_ec/single/include/images/pv_bg1.png') 2px no-repeat;
}
.previewLink:hover {
color: #e3007f;
background: url('<s:property value="#attr.INIT_SERVER_MAP.web_url"/>/new_ec/single/include/images/pv_bg2.png') 2px no-repeat;
}
.shareLink {
background: url('/new_ec/single/include/images/share_bg1.png') 2px no-repeat;
}
.shareLink:hover {
color: #e3007f;
background: url('/new_ec/single/include/images/share_bg2.png') 2px no-repeat;
}
.table td {
border: 1px solid #d9d9d9;
}
#prodImage300 {
padding: 5px;
display: table-cell;
text-align: center;
vertical-align: middle;
border: 1px solid #efefef;
}
.sprod_want_text, .sprod_sale_text {
text-align: center;
color: #333333;
}
#wantSndLink2, #wantSndLink2:hover {
padding: 1px 15px 0 22px;
cursor: pointer;
color: #e3007f;
background: url('/new_ec/single/include/images/wnd_bg2.png') 0px 3px no-repeat;
font-size: 11pt;
text-decoration: none;
font-weight: bold;
}
#saleBtn {
text-decoration: none;
color: #ffffff;
}
table.sale_range, table.want_range {
margin: 10px 0px;
font-size: 11pt;
}
table.sale_range tr.column_title, table.want_range tr.column_title {
border: 1px solid #B8B8B8;
border-left: 0px;
border-right: 0px;
text-align: center;
}
table.sale_range td, table.want_range td {
padding: 5px 10px;
text-align: center;
}
table.sale_range td.column, table.want_range td.column {
border-bottom: 1px dotted #B8B8B8;
text-align: left;
}
table.sale_range td.column_left, table.want_range td.column_left {
border-right: 1px solid #B8B8B8;
}
.sprod_list {
margin: 10px 0px;
padding: 0px;
word-break: break-all;
}
.sprod_list table {
font-size: 11pt;
}
.sprod_list table tr.column_title {
border: 1px solid #B8B8B8;
border-left: 0px;
border-right: 0px;
text-align: center;
}
.sprod_list table tr.column_title td {
border: 1px solid #B8B8B8;
border-left: 0px;
border-right: 0px;
text-align: center;
}
.sprod_list table tr.column_title td.column_left {
border-right: 1px solid #B8B8B8;
}
.sprod_list table tr.column_title td.column_last {
border-right: 1px solid #B8B8B8;
}
.sprod_list table td {
padding: 5px 10px;
border: 0px;
}
.sprod_list table td.column {
text-align: left;
}
.sprod_list table td.column_left {
border-right: 1px solid #B8B8B8;
}
.sprod_list table td.column_last {
border-right: 1px solid #B8B8B8;
}
.view_prod, .mark_text {
font-size: 10pt;
}
.btn_add_cart {
margin: 0px auto;
cursor: pointer;
width: 122px;
height: 40px;
padding: 10px 0px 0px 32px;
font-size: 10pt;
background: url('/new_ec/single/include/images/btn_add_cart.png') no-repeat;
}
.btn_add_cart:hover {
color: #ffffff;
background: url('/new_ec/single/include/images/btn_add_cart_hover.png') no-repeat;
}
.btn_add_cart_m {
margin: 0px auto;
cursor: pointer;
width: 30px;
height: 30px;
padding: 0px;
background: url('/new_ec/single/include/images/ic_index_3@2x.png') no-repeat;
background-size: contain;
}
.btn_add_cart_m:hover {
color: #ffffff;
background: url('/new_ec/single/include/images/ic_index_7@2x.png') no-repeat;
background-size: contain;
}
.more_btn {
margin: 0px auto;
cursor: pointer;
padding: 8px 15px;
width: 102px;
height: 40px;
background: url('/new_ec/single/include/images/btn_more.png') no-repeat;
}
.more_btn:hover {
color: #ffffff;
background: url('/new_ec/single/include/images/btn_more_hover.png') no-repeat;
}
.modal-header, .modal-footer {
border: 0px;
}
.modal-title {
color: #472a2b;
font-size: 11pt;
background: #F0F0F0;
padding: 6px;
font-weight: bold;
}
.modal-body {
font-size: 11pt;
display: inline-block;
padding-top: 0px;
padding-bottom: 5px;
}
.want_quest, .library_quest {
height: 20px;
width: 105px;
background: url('/include/default/imgs/question.gif') no-repeat right center;
color: #472a2b;
}
button.check {
width: 52px;
height: 31px;
border: none;
background-color: #ffffff;
background-image: url('/new_ec/rwd/include/images/C_image/btn/btn_12@2x.png');
background-size: cover;
display: inline-block;
cursor: pointer;
}
.form-control {
display: inline-block;
}
.form-inline .form-group {
display: block;
}
.button {
background: #797979;
color: #ffffff;
font-size: 10pt;
border: 1px solid transparent;
}
.button-hover, .button-hover:hover {
background: #ED008C;
color: #ffffff
}
.button:hover {
background: #ED008C;
color: #ffffff
}
.col-text {
padding-right: 5px;
}
.form-group {
margin-bottom: 5px;
}
.form-control {
height: 30px;
padding: 3px 12px;
}
#noSchoolFind {
cursor: pointer;
text-decoration: underline;
}
#noSchoolFind:hover {
color: #e3007f;
}
.sale_info_hide {
display: none;
}
.wnd_error, .sale_error {
margin-right: 10px;
font-size: 10pt;
width: 135px;
text-align: left;
}
.alertMsg, .confirmMsg {
font-size: 12pt;
}
.alert-confirm {
color: # #333333;
background: #ffffff;
}
.view_prod:hover, .prod_saler:hover {
color: #e3007f;
}
.vod_btn {
background: url('/new_ec/single/include/images/vod_btn.png ') no-repeat;
padding-left: 25px;
padding-right: 25px;
cursor: pointer;
}
#fb_shared, #gmail_shared, #plurk_shared, #twitter_shared {
cursor: pointer;
float: left;
margin: 2px 5px 2px 0px;
}
#fb_shared {
background: url('new_ec/share/images/f.png') no-repeat;
width: 46px;
height: 20px;
}
#gmail_shared {
background: url('new_ec/share/images/e.png') no-repeat;
width: 21px;
height: 20px;
}
#plurk_shared {
background: url('new_ec/share/images/p.png') no-repeat;
width: 21px;
height: 20px;
}
#twitter_shared {
background: url('new_ec/share/images/t.png') no-repeat;
width: 21px;
height: 20px;
}
#prodImage {
padding: 5px;
display: table-cell;
text-align: center;
vertical-align: middle;
border: 1px solid #efefef;
}
#18Image {
padding: 5px;
display: table-cell;
text-align: center;
vertical-align: middle;
border: 1px solid #efefef;
}
.prodInfo {
padding: 0px;
}
.prodInfo p {
margin-bottom: 6px;
}
.add2cat {
right: 0px;
}
.cat-list {
max-height: 400px;
overflow-x: hidden;
}
.cat-list label {
width: 100%;
padding: 0px;
}
.cat-list .list-group-item:hover {
background-color: #f5f5f5;
}
.cat-list .checkbox {
margin: 0px;
}
.add-cat {
margin-left: 10px;
float: right;
}
.clt-msg {
text-align: center;
font-size: 12pt
}
.cat-input {
display: none;
}
.cancel-add, .confirm-add {
float: right;
margin-right: 5px;
}
.title-next {
font-size: 75%;
padding-top: 10px;
line-height: 25px;
font-weight: 700;
font-family: 'Helvetica', 'Arial';
}
@media (min-width: 768px) {
.sm-hide {
display: inline-block;
}
.sm-show {
display: none;
}
#prodImage {
width: 276px;
}
.prodInfo {
padding: 0px;
}
}
@media (max-width: 767px) {
.prodInfo {
margin-top: 10px;
padding: 0px 15px;
}
}
@media only screen and (max-width: 568px) {
.market-status {
float: left;
margin: 5px 0px;
}
.prodInfo {
margin-top: 10px;
padding: 0px 15px;
}
.sprod_list table td.column_last {
border-right: 0px;
}
.sprod_list table tr.column_title td.column_last {
border-right: 0px;
}
.sprod_sale_text, .sprod_want_text {
font-size: 11pt;
}
.cat-list {
max-height: 250px;
}
.note {
font-size: 9pt;
}
}
</style>
	</head>

	<body>
	</body>
	</html>