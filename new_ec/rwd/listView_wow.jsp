<%@page import="org.dom4j.Element"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/tlds/c.tld" prefix="c"%>
<%@ include file="/new_ec/rwd/include/jsp/include_listView.jsp" %>

<%@page import="java.util.*"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="net.sf.json.JSONArray"%>

<%
String pageInfoLog = request.getAttribute("javax.servlet.forward.request_uri") != null ? request.getAttribute("javax.servlet.forward.request_uri").toString() : request.getRequestURL().toString();
pageInfoLog += request.getQueryString() == null ? "" : "?" + request.getQueryString();
String redUrl="https://"+request.getServerName() + pageInfoLog;


/* @@大版Banner資料	*/

JSONArray bigBannerList = null;


if(urlParamters.getT().equals("11") && urlParamters.getK().equals("03")){//中文書(org_flg=C)
	// if(urlParamters.getL()==null 
	// 		|| !EcPathSettingImp.isNumeric_Pattern(urlParamters.getL()) 
	// 		|| Integer.parseInt(urlParamters.getL())==0){
		//在業種別層級
		if(urlParamters.getD().equals("12")){
			//二手簡體書
			bigBannerList = SystemUtil.parseActJson2Array("0212","00","A", urlParamters.getR()!=null?urlParamters.getR():"0");

		}else if(urlParamters.getD().equals("13")){
			//二手原文書
			bigBannerList = SystemUtil.parseActJson2Array("0213","00","A", urlParamters.getR()!=null?urlParamters.getR():"0");

		}else if(urlParamters.getD().equals("24")){
			//二手日文MOOK
			bigBannerList = SystemUtil.parseActJson2Array("0224","00","A", urlParamters.getR()!=null?urlParamters.getR():"0");

		}else{
			//二手中文書
			String c = "00";
			if(urlParamters.getC()!=null&&urlParamters.getC().length()>=2){
				c =urlParamters.getC().substring(0, 2);
			}
			bigBannerList = SystemUtil.parseActJson2Array("0211", c, "A", urlParamters.getR()!=null?urlParamters.getR():"0");
		

		}
	// }

	jsonDataSet.bigBannerData = new JSONObject();
	jsonDataSet.bigBannerData.put("titleMain", "大版Banner");
	jsonDataSet.bigBannerData.put("description", "大版Banner");
	jsonDataSet.bigBannerData.put("dataList", bigBannerList);
}else{
	
	String c = "00";
	if(urlParamters.getC()!=null&&urlParamters.getC().length()>=4){
		c =urlParamters.getC().substring(0,Integer.parseInt(urlParamters.getL()) * 2);
	}
	//參數L等於空值或參數L不是數值或參數L是數值小於類別層級2
	if(urlParamters.getL()==null || !EcPathSettingImp.isNumeric_Pattern(urlParamters.getL()) || Integer.parseInt(urlParamters.getL())<2){
		bigBannerList = SystemUtil.parseActJson2Array("02" + urlParamters.getT(), c, "A", urlParamters.getR()!=null?urlParamters.getR():"0");
	}

	jsonDataSet.bigBannerData = new JSONObject();
	jsonDataSet.bigBannerData.put("titleMain", "大版Banner");
	jsonDataSet.bigBannerData.put("description", "大版Banner");
	jsonDataSet.bigBannerData.put("dataList", bigBannerList);
}
/* 大版Banner@@	*/

/*	@@注目專區 	*/
JSONArray activityJsonArray = null;
try {
if(urlParamters.getK().equals("03")){
if(urlParamters.getD().equals("12")){
activityJsonArray = SystemUtil.parseActJson2Array("0212","00","P","0");
}else if(urlParamters.getD().equals("13")){
activityJsonArray = SystemUtil.parseActJson2Array("0213","00","P","0");
}else if(urlParamters.getD().equals("24")){
activityJsonArray = SystemUtil.parseActJson2Array("0224","00","P","0");
}else{
activityJsonArray = SystemUtil.parseActJson2Array("02","00","P","0");
}
}else{
	//activityJsonArray = SystemUtil.parseActJson2Array("0211",urlParamters.getC()!=null?urlParamters.getC().substring(0,2):"00","P","0");
	
}
} catch(Exception e) {
log.error(e.getMessage());
}
/* 注目專區 @@	*/

activityJsonArray = SystemUtil.parseActJson2Array("0211","01","P","0");
	out.print("hello" + activityJsonArray);

%>
<!DOCTYPE html>
<html lang="zh-hant">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<c:choose>
<c:when test="${cookie['mobile'].value eq 'on'}">
<meta name="viewport" content="width=1200, initial-scale=1, maximum-scale=1, user-scalable=yes">
</c:when>
<c:otherwise>
<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
</c:otherwise>
</c:choose>
<title>TAAZE 讀冊生活網路書店</title>
<% if (redUrl != null && redUrl.indexOf("container_view.html") > 0) {%>
<link rel="canonical" href="<%=redUrl.replaceAll("container_view.html","rwd_listView.html") %>"/>
<%}%>
<%@ include file="/new_ec/rwd/include/css.jsp" %>
<style type="text/css">
#sortm-group>.btn:first-child {
color: #9c9c9c;
text-align:left;
border-color: #979797;
}
#sortm>li>a {
color: #9c9c9c;
padding: 3px 20px 3px 2px;
min-width: 105px;
}
#sortm{
min-width: 105px;
border-radius: 0;
border-color: #979797;
}
#selectSort_m {
min-width: 105px;
border-radius: 0;
padding: 6px 12px 6px 2px
}
</style>
<%-- 先編譯再include --%>
<jsp:include page="/new_ec/rwd/include/marketingScript.jsp" flush="true"/>
</head>
<body>
<jsp:include page="/new_ec/rwd/include/jsp/include_header.jsp" flush="true"/>
<%-- body start --%>
<div style="display:none;">
<input id="HIDE_T" type="hidden" value="<%=urlParamters.getT()!=null?urlParamters.getT():"" %>" />
<input id="HIDE_K" type="hidden" value="<%=urlParamters.getK()!=null?urlParamters.getK():"" %>" />
<input id="HIDE_D" type="hidden" value="<%=urlParamters.getD()!=null?urlParamters.getD():"" %>" />
<input id="HIDE_A" type="hidden" value="<%=urlParamters.getA()!=null?urlParamters.getA():"" %>" />
<input id="HIDE_C" type="hidden" value="<%=urlParamters.getC()!=null?urlParamters.getC():"" %>" />
<input id="HIDE_L" type="hidden" value="<%=urlParamters.getL()!=null?urlParamters.getL():"" %>" />
<input id="HIDE_SORT" type="hidden" value="2" />
<input id="HIDE_TOTALSIZE" type="hidden" value="0" />
<input id="HIDE_NOWPAGE" type="hidden" value="1" />
<input id="HIDE_PAGESIZE" type="hidden" value="24" />
<input id="HIDE_SHOWMODEL" type="hidden" value="1" />
</div>
<code id="listViewData" style="display:none;">
</code>
<%-- pc model start +++++++++++++++++++++++++++++++++++++++++++++++++++++ --%>
<c:choose>
<c:when test="${cookie['mobile'].value eq 'on'}">
<div class="container container_PC visible-lg-block visible-sm-block visible-md-block visible-xs-block" style="margin-top:15px;width:1100px;">
</c:when>
<c:otherwise>
<div class="container container_PC visible-lg-block" style="margin-top:15px;">
</c:otherwise>
</c:choose>
<div class="row">
<%@ include file="/new_ec/rwd/include/jsp/listSiteMap.jsp"%>

<%--大版Banner --%>
<%--大版Banner --%>
<c:choose>  
   <c:when test="${cookie['mobile'].value eq 'on'}">    
<div class="container container_PC_new visible-lg-block  visible-sm-block visible-md-block visible-xs-block" style="margin-top:15px;">
   </c:when>  
   <c:otherwise> 
<div class="container container_PC visible-lg-block" style="margin-top:15px;">
   </c:otherwise>  
</c:choose> 

	<div class="row">
<%
if(jsonDataSet.bigBannerData!=null && jsonDataSet.bigBannerData.get("dataList")!=null&&jsonDataSet.bigBannerData.getJSONArray("dataList").size()>0){
%>
<c:choose>  
   <c:when test="${cookie['mobile'].value eq 'on'}">    

   </c:when>  
   <c:otherwise> 
<div id='betaSlider' class='hidden-xs hidden-sm hidden-md' style='display:none'>
   </c:otherwise>  
</c:choose> 
<%
String isSndBook=urlParamters.getK();
if(isSndBook.equals("03")){
	String prodcatid = urlParamters.getD();
	if(prodcatid.equals("00")){
		String bigBannerhomepagecode = SystemUtil.homepageTypeMap.get("02".concat("00").concat("A"));	
	  	for(int i=0; i<jsonDataSet.bigBannerData.getJSONArray("dataList").size(); i++){
	  	%>
	  	<a homepagecode="<%=bigBannerhomepagecode%>" bannerPk="<%=jsonDataSet.bigBannerData.getJSONArray("dataList").getJSONObject(i).getString("bannerPkNo")%>" actPk="<%=jsonDataSet.bigBannerData.getJSONArray("dataList").getJSONObject(i).getString("activityPkNo") %>" onMouseDown="miningTrigger(this);return false;"href="<%=jsonDataSet.bigBannerData.getJSONArray("dataList").getJSONObject(i).getString("activityUrl") %>">
	    	<img src="https://media.taaze.tw/showBanaerImage.html?pk=<%=jsonDataSet.bigBannerData.getJSONArray("dataList").getJSONObject(i).getString("bannerPkNo")%>&width=1000&height=326&fill=f" alt="">
	    	<span><%=jsonDataSet.bigBannerData.getJSONArray("dataList").getJSONObject(i).getString("titleMain") %></span>
	  	</a>
	  	<%
	  	}
	}else{	
		String bigBannerhomepagecode = SystemUtil.homepageTypeMap.get("02"+urlParamters.getD().concat("00").concat("A"));	
	  	for(int i=0; i<jsonDataSet.bigBannerData.getJSONArray("dataList").size(); i++){
	  	%>
	  	<a homepagecode="<%=bigBannerhomepagecode%>" bannerPk="<%=jsonDataSet.bigBannerData.getJSONArray("dataList").getJSONObject(i).getString("bannerPkNo")%>" actPk="<%=jsonDataSet.bigBannerData.getJSONArray("dataList").getJSONObject(i).getString("activityPkNo") %>" onMouseDown="miningTrigger(this);return false;"href="<%=jsonDataSet.bigBannerData.getJSONArray("dataList").getJSONObject(i).getString("activityUrl") %>">
	    	<img src="https://media.taaze.tw/showBanaerImage.html?pk=<%=jsonDataSet.bigBannerData.getJSONArray("dataList").getJSONObject(i).getString("bannerPkNo")%>&width=1000&height=326&fill=f" alt="">
	    	<span><%=jsonDataSet.bigBannerData.getJSONArray("dataList").getJSONObject(i).getString("titleMain") %></span>
	  	</a>
	  	<%
	  	}
	}	  	
}else{
	String bigBannerhomepagecode = SystemUtil.homepageTypeMap.get(urlParamters.getT().concat(urlParamters.getC().substring(0,2)).concat("A"));  	for(int i=0; i<jsonDataSet.bigBannerData.getJSONArray("dataList").size(); i++){
  	%>
  	<a homepagecode="<%=bigBannerhomepagecode%>" bannerPk="<%=jsonDataSet.bigBannerData.getJSONArray("dataList").getJSONObject(i).getString("bannerPkNo")%>" actPk="<%=jsonDataSet.bigBannerData.getJSONArray("dataList").getJSONObject(i).getString("activityPkNo") %>" onMouseDown="miningTrigger(this);return false;"href="<%=jsonDataSet.bigBannerData.getJSONArray("dataList").getJSONObject(i).getString("activityUrl") %>">
    	<img src="https://media.taaze.tw/showBanaerImage.html?pk=<%=jsonDataSet.bigBannerData.getJSONArray("dataList").getJSONObject(i).getString("bannerPkNo")%>&width=1000&height=326&fill=f" alt="">
    	<span><%=jsonDataSet.bigBannerData.getJSONArray("dataList").getJSONObject(i).getString("titleMain") %></span>
  	</a>
  	<%
  	}
}

  	if(jsonDataSet.bigBannerData.getJSONArray("dataList").size()<3){
  		if(urlParamters.getK().equals("03")){  			
  			out.print("<a href='sell_used_books.html'><img src='/new_include/images/second_019.jpg' alt='什麼是二手書' width='848' height='341' rel='什麼是二手書'/><span>什麼是二手書</span></a>");
  		}
  	}
  	%>		
</div>	
<%
}		
%>

</div>
</div>


<c:choose>
<c:when test="${cookie['mobile'].value eq 'on'}">
<div class="col-xs-3" style='padding-top: 8px;padding-left: 0;'><%-- left block --%>
</c:when>
<c:otherwise>
<div class="col-sm-4 col-md-3" style='padding-top: 8px;padding-left: 0;'><%-- left block --%>
</c:otherwise>
</c:choose>

<%-- 注目專區 --%>
<%
if(activityJsonArray!= null && activityJsonArray.size() > 0) {
StringBuilder activityContent = new StringBuilder();;
activityContent.append("<div class='panel panel-default' style='margin-bottom: 30px;'>");
activityContent.append("<div class='panel-heading' style='background-color:#D9D9D9;'>");
//activityContent.append("<ol class='breadcrumb' style='margin:0; padding:0;'>");
activityContent.append("<span style='font-size:16px;font-weight:bold;'>");
activityContent.append("注目專區");
activityContent.append("</span>");
//activityContent.append("</ol>");
activityContent.append("</div>");
activityContent.append("<div class='list-group'>");
/*修改
if(urlParamters.getK().equals("03")){
//二手書全新/近全新
if(urlParamters.getD().equals("00")){
activityContent.append("<a class='list-group-item' style='font-weight:bold;letter-spacing: 0.5px;line-height: 20px;' href='/rwd_listViewB.html?t=11&k=03&d=00&a=21' >全新/近全新</a>");
}else if(urlParamters.getD().equals("12")){
activityContent.append("<a class='list-group-item' style='font-weight:bold;letter-spacing: 0.5px;line-height: 20px;' href='/rwd_listViewB.html?t=12&k=03&d=12&a=21' >全新/近全新</a>");
}else if(urlParamters.getD().equals("13")){
activityContent.append("<a class='list-group-item' style='font-weight:bold;letter-spacing: 0.5px;line-height: 20px;' href='/rwd_listViewB.html?t=13&k=03&d=13&a=21' >全新/近全新</a>");
}else if(urlParamters.getD().equals("24")){
activityContent.append("<a class='list-group-item' style='font-weight:bold;letter-spacing: 0.5px;line-height: 20px;' href='/rwd_listViewB.html?t=24&k=03&d=24&a=21' >全新/近全新</a>");
}
}*/
for(int i = 0; i < activityJsonArray.size(); i++) {
JSONObject act = (JSONObject)activityJsonArray.get(i);
//取代字串，變更網址
if(act.getString("url").contains("container_snd_actview")){
String newUrl = act.getString("url").replace("container_snd_actview","rwd_listViewB");
activityContent.append("<a class='list-group-item' style='font-weight:bold;letter-spacing: 0.5px;line-height: 20px;' href='" + newUrl + "'>"+act.getString("areaNm")+"</a>");
}else{
String newUrl = act.getString("url").replace("container_snd","rwd_list");
activityContent.append("<a class='list-group-item' style='font-weight:bold;letter-spacing: 0.5px;line-height: 20px;' href='" + newUrl + "'>"+act.getString("areaNm")+"</a>");
}
}
if(urlParamters.getT().equals("14") || urlParamters.getT().equals("25") || urlParamters.getT().equals("17")){
activityContent.append("<a class='list-group-item' style='font-weight:bold;letter-spacing: 0.5px;line-height: 20px;' href='https://www.taaze.tw/static_act/taazecloudreader/index.htm' >Windows / Mac電腦</a>");
activityContent.append("<a class='list-group-item' style='font-weight:bold;letter-spacing: 0.5px;line-height: 20px;' href='https://www.taaze.tw/taazereader/index.jsp' >手機 / 平板</a>");
if(urlParamters.getT().equals("14")){
activityContent.append("<a class='list-group-item' style='font-weight:bold;letter-spacing: 0.5px;line-height: 20px;' href='/rwd_ebookActListView.html?t=14&k=01&d=00&a=01' >0元電子書</a>");
}else if(urlParamters.getT().equals("25")){
activityContent.append("<a class='list-group-item' style='font-weight:bold;letter-spacing: 0.5px;line-height: 20px;' href='/rwd_ebookActListView.html?t=25&k=01&d=00&a=01' >0元電子雜誌</a>");
}
if(!urlParamters.getT().equals("14")){
activityContent.append("<a class='list-group-item' style='font-weight:bold;letter-spacing: 0.5px;line-height: 20px;' href='http://activity.taaze.tw/home.html?m=1000642460' >訂閱電子雜誌</a>");
}
}
activityContent.append("</div>");
activityContent.append("</div>");
out.print(activityContent.toString());
}
%>
<%-- 注目專區 --%>

<%-- 顯示類別選單 --%>
<div class="panel panel-default">
<!--<div class="panel-heading" style='background-color:#D9D9D9;'>-->
<%
if(pathList!=null && pathList.size()>1){
out.print("<a href='/rwd_list.html?t="+urlParamters.getT()+"&k="+urlParamters.getK()+"&d="+urlParamters.getD()+"' class=\"panel-heading-1\"><span style='font-weight:bold;'>" + pathList.getJSONObject(1).getString("title") + "</span></a>");
}
%>
<!--</div>-->
<%
if(catalogList!=null&&catalogList.size()>0){
int target = Integer.parseInt(urlParamters.getL());
%>
<div class="list-group">
<%-- 					<a href='/rwd_list.html?t=<%=urlParamters.getT() %>&k=<%=urlParamters.getK() %>&d=<%=urlParamters.getD() %>' class='list-group-item'><span style='font-weight:bold;'>所有類別</span></a> --%>
<%
/*
if(pathList.size()>3){
out.print("<a class='list-group-item' href='" + pathList.getJSONObject(2).getString("url") + "'><span style='font-size:18px;font-weight:bold;'>" + pathList.getJSONObject(2).getString("title") + "</span></a>");
}else if(pathList.size()==3){
out.print("<a class='list-group-item' href='" + pathList.getJSONObject(2).getString("url") + "'><span style='font-size:18px;font-weight:bold;color:#e3007f'>" + pathList.getJSONObject(2).getString("title") + "</span></a>");
}
*/
for(int i = 2;i<pathList.size();i++){
if(pathList.size()>3){
if(i==pathList.size()-1){
break;
}
}
if(i==(target+1)){
out.print("<a class='list-group-item' href='" + pathList.getJSONObject(i).getString("url") + "'><span style='font-weight:bold;color:#e3007f'>" + pathList.getJSONObject(i).getString("title") + "</span></a>");
}else{
out.print("<a class='list-group-item' href='" + pathList.getJSONObject(i).getString("url") + "'><span style=''>" + pathList.getJSONObject(i).getString("title") + "</span></a>");
}
}
for(int i =0 ; i < catalogList.size(); i++){
Object obj = catalogList.get(i);
JSONObject item = (JSONObject)obj;
if(i==0){
out.print("<ul class='list-group panel-body'>");
}
if(item.getString("active").equals("1")){
out.print("<!--<li class='list-group-item'>--><a href='" + item.getString("url") + "'class=\"list-group-item\"><span style='color:#e3007f;'>" + item.getString("title") + "</span></a></li>");
}else{
out.print("<!--<li class='list-group-item'>--><a href='" + item.getString("url") + "'class=\"list-group-item\"><span style=''>" + item.getString("title") + "</span></a></li>");
}
if(i==catalogList.size()-1){
out.print("</ul>");
}
}
if(target==1 && levelOneList!=null){
for(Object o : levelOneList){
JSONObject item = (JSONObject)o;
if(item.getString("active").equals("0")){
out.println("<a href='" + item.getString("url")+"' class='list-group-item'><span >"+item.getString("title")+"</span></a>");
}
}
}
%>
</div>
<%
}
%>
</div>
<%-- 顯示類別選單 --%>
</div><%-- left block --%>
<c:choose>
<c:when test="${cookie['mobile'].value eq 'on'}">
<div class="col-xs-9"><%-- rigth block --%>
</c:when>
<c:otherwise>
<div class="col-sm-8 col-md-9"><%-- rigth block --%>
</c:otherwise>
</c:choose>
<div class="row listView_sort">
<div class="col-xs-12">
<div style="float:right;">
<!-- Single button -->
<span>排序方式</span>
<div class="btn-group">
<button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown" id="selectSort">
暢銷度排序 <span class="caret"></span>
</button>
<ul class="dropdown-menu" role="menu">
<li><a href="#" onclick="sortBy(this, event)" rel="2">暢銷度排序</a></li>
<li><a href="#" onclick="sortBy(this, event)" rel="1">出版日期排序</a></li>
<li><a href="#" onclick="sortBy(this, event)" rel="3">價格排序</a></li>
</ul>
</div>
<img id="layoutList" onclick="layoutByList(this)" />
<img id="layoutGrid" class="disabled" onclick="layoutByGrid(this)" />
<!--
<button type="button" id="layoutGrid" class="" style="background-repeat: no-repeat;background-position:center center;background-image: url('/new_ec/rwd/include/images/icon/ic_A_15.png')" onclick="layoutByGrid(this)">
<span class=""></span>
</button>
<button type="button" id="layoutList" class="btn btn-default" onclick="layoutByList(this)">
<span class="glyphicon glyphicon-th-list"></span>
</button>
-->
</div>
<div style="clear:both;"></div>
</div>
</div>
<div class="row">
<div class="col-xs-12" id="listView" style='padding:0'>
</div>
</div>
<div class="row">
<div class="col-xs-12 text-center">
<nav>
<ul class="pagination" id="pageButtons">
</ul>
</nav>
</div>
</div>
</div><%-- right block --%>
</div>
</div>
<%-- pc model end ------------------------------------------------------- --%>
<%-- mobile model start +++++++++++++++++++++++++++++++++++++++++++++++++++++ --%><c:choose>
<c:when test="${cookie['mobile'].value eq 'on'}">
<div class="container-fluid hidden-xs  hidden-sm hidden-md hidden-lg" style="margin-top:50px;">
</c:when>
<c:otherwise>
<div class="container-fluid visible-xs-block visible-sm-block visible-md-block" style="margin-top:50px;">
</c:otherwise>
</c:choose>
<%--site map --%>
<%-- 顯示類別選單 --%>
<%
//顯示第一層子分類
if(Integer.parseInt(urlParamters.getL())>=1){
%>
<div class="panel-default" style="margin-top:20px;margin-bottom: -20px;">
<div class="panel-heading" style='background-color:#D9D9D9;'>
<ol class="breadcrumb" style="background-color:#D9D9D9;margin:0; padding:0;">
<%
if(pathList!=null && pathList.size()>0){
if(pathList.size() > 1){
out.print("<li class='active'><a data-toggle='collapse' href='#mlisLevOne'><span style='font-size:14px;font-weight:bold;'>" + pathList.getJSONObject(1).getString("title") + "</span><img class='notice_btn noticeShow_btn' /></a></li>");
}
}
%>
</ol>
</div>
<%
if(levelOneList!=null&&levelOneList.size()>0){
%>
<div class='panel-collapse collapse' id='mlisLevOne'>
<div class="list-group">
<%
for(Object obj:levelOneList){
JSONObject item = (JSONObject)obj;
%>
<a href="<%=item.getString("url") %>" class="list-group-item"><span style='font-size:14px;font-weight:bold;'><%=item.getString("title") %></span></a>
<%
}
%>
</div>
</div>
<%
}
%>
</div>
<%}%>
<div class="panel-default" style="margin-top:20px;">
<div class="panel-heading">
<ol class="breadcrumb" style="margin:0; padding:0;">
<%
if(pathList!=null && pathList.size()>0){
if(pathList.size() > 1){
String lev1Title=pathList.getJSONObject(pathList.size()-1).getString("title");
if(Integer.parseInt(urlParamters.getL())>1 ){
lev1Title=pathList.size()>2?pathList.getJSONObject(2).getString("title"):"";
}
out.print("<li class='active'><a data-toggle='collapse' href='#mlistProdCat'><strong>" + lev1Title + "</strong><img class='notice_btn noticeShow_btn' /></a></li>");
}
}
%>
</ol>
</div>
<%
if(catalogList!=null&&catalogList.size()>0){
%>
<div class='panel-collapse collapse' id='mlistProdCat'>
<div class="list-group">
<%-- 				<a href='/rwd_list.html?t=<%=urlParamters.getT() %>&k=<%=urlParamters.getK() %>&d=<%=urlParamters.getD() %>' class='list-group-item'><span style='font-size:14px;font-weight:bold;'>所有類別</span></a> --%>
<%
if(pathList.size() > 3){
%>
<%-- 				<a href='<%=pathList.getJSONObject(2).getString("url") %>' class="list-group-item"><span style='font-size:14px;font-weight:bold;'><%=pathList.getJSONObject(2).getString("title") %></span></a> --%>
<%}else if(pathList.size() == 3){ %>
<%-- 				<a href='<%=pathList.getJSONObject(2).getString("url") %>' class="list-group-item"><span style='font-size:14px;font-weight:bold;color:#e3007f;'><%=pathList.getJSONObject(2).getString("title") %></span></a> --%>
<%} %>
<!-- 					<ul class="list-group panel-body"> -->
<%
for(Object obj:catalogList){
JSONObject item = (JSONObject)obj;
if(item.getString("active").equals("1")){
%>
<li class="list-group-item"><a href="<%=item.getString("url") %>"><span style='font-size:14px;font-weight:bold;color:#e3007f;'><%=item.getString("title") %></span></a></li>
<%
}else{
%>
<li class="list-group-item"><a href="<%=item.getString("url") %>"><span style='font-size:14px;font-weight:bold;'><%=item.getString("title") %></span></a></li>
<%
}
}
%>
<!-- 					</ul> -->
</div>
</div>
<%
}
%>
</div>
<%if(Integer.parseInt(urlParamters.getL())>1){%>
<div class="panel-default">
<div class="panel-heading">
<ol class="breadcrumb" style="margin:0; padding:0;">
<%
if(pathList!=null && pathList.size()>0){
if(pathList.size() > 1){
out.print("<li class='active'><a><strong style='color:#e3007f'>" + pathList.getJSONObject(pathList.size()-1).getString("title") + "</strong></a></li>");
}
}
%>
</ol>
</div>
</div>
<%}%>
<%-- 顯示類別選單 --%>

<%-- 注目專區 --%>
<%
if(activityJsonArray!= null && activityJsonArray.size() > 0) {
StringBuilder activityContent = new StringBuilder();;
activityContent.append("<div class='panel-default'>");
activityContent.append("<div class='panel-heading' style='background-color:#D9D9D9;'>");
activityContent.append("<ol class='breadcrumb' style='background-color:#D9D9D9;margin:0; padding:0;'>");
activityContent.append("<li class='active'>");
activityContent.append("<a data-toggle='collapse' href='#mlistActive'>");
activityContent.append("<strong>注目專區</strong>");
activityContent.append("<img class='notice_btn noticeShow_btn'/>");
activityContent.append("</a>");
activityContent.append("</li>");
activityContent.append("</ol>");
activityContent.append("</div>");
activityContent.append("<div class='panel-collapse collapse' id='mlistActive'>");
activityContent.append("<div class='panel-body list-group'>");
for(int i = 0; i < activityJsonArray.size(); i++) {
JSONObject act = (JSONObject)activityJsonArray.get(i);
activityContent.append("<a class='list-group-item' href='" + act.getString("url") + "'>"+act.getString("areaNm")+"</a>");
}
if(urlParamters.getT().equals("14") || urlParamters.getT().equals("25") || urlParamters.getT().equals("17")){
activityContent.append("<a class='list-group-item' href='https://www.taaze.tw/static_act/taazecloudreader/index.htm' >Windows / Mac電腦</a>");
activityContent.append("<a class='list-group-item' href='https://www.taaze.tw/taazereader/index.jsp' >手機 / 平板</a>");
if(urlParamters.getT().equals("14")){
activityContent.append("<a class='list-group-item' href='/rwd_ebookActListView.html?t=14&k=01&d=00&a=01' >0元電子書</a>");
}else if(urlParamters.getT().equals("25")){
activityContent.append("<a class='list-group-item' href='/rwd_ebookActListView.html?t=25&k=01&d=00&a=01' >0元電子雜誌</a>");
}
if(!urlParamters.getT().equals("14")){
activityContent.append("<a class='list-group-item' href='http://activity.taaze.tw/home.html?m=1000642460' >訂閱電子雜誌</a>");
}
}
activityContent.append("</div>");
activityContent.append("</div>");
activityContent.append("</div>");
out.print(activityContent.toString());
}
if(urlParamters.getT().equals("22")){
StringBuilder activityContent1 = new StringBuilder();;
activityContent1.append("<div class='panel-default'>");
activityContent1.append("<div class='panel-heading' style='background-color:#D9D9D9;'>");
activityContent1.append("<ol class='breadcrumb' style='background-color:#D9D9D9;margin:0; padding:0;'>");
activityContent1.append("<li class='active'>");
activityContent1.append("<a data-toggle='collapse' href='#mlistActive1'>");
activityContent1.append("<strong>韓文雜誌索引</strong>");
activityContent1.append("<img class='notice_btn noticeShow_btn'/>");
activityContent1.append("</a>");
activityContent1.append("</li>");
activityContent1.append("</ol>");
activityContent1.append("</div>");
activityContent1.append("<div class='panel-collapse collapse' id='mlistActive1'>");
activityContent1.append("<div class='panel-body list-group'>");
activityContent1.append("<a class='list-group-item' href='/rwd_listView.html?t=22&k=01&d=01&a=22'>A-C</a>");
activityContent1.append("<a class='list-group-item' href='/rwd_listView.html?t=22&k=01&d=02&a=22'>D-F</a>");
activityContent1.append("<a class='list-group-item' href='/rwd_listView.html?t=22&k=01&d=03&a=22'>G-I</a>");
activityContent1.append("<a class='list-group-item' href='/rwd_listView.html?t=22&k=01&d=04&a=22'>J-N</a>");
activityContent1.append("<a class='list-group-item' href='/rwd_listView.html?t=22&k=01&d=05&a=22'>O-T</a>");
activityContent1.append("<a class='list-group-item' href='/rwd_listView.html?t=22&k=01&d=06&a=22'>U-Z</a>");
activityContent1.append("<a class='list-group-item' href='/rwd_listView.html?t=22&k=01&d=07&a=22'>其他</a>");
activityContent1.append("</div>");
activityContent1.append("</div>");
activityContent1.append("</div>");
out.print(activityContent1.toString());
}
%>
<%-- 注目專區 --%>
<%--大版Banner --%>
<%
if(jsonDataSet.bigBannerData!=null && jsonDataSet.bigBannerData.get("dataList")!=null&&jsonDataSet.bigBannerData.getJSONArray("dataList").size()>0){
%>
<div id="mBibBanner" style='display:none'>
<%
String isSndBook=urlParamters.getK();
if(isSndBook.equals("03")){
String prodcatid=urlParamters.getD();
if(prodcatid.equals("00")){
String bigBannerhomepagecode = SystemUtil.homepageTypeMap.get("02".concat("00").concat("A"));
for(int i=0; i<jsonDataSet.bigBannerData.getJSONArray("dataList").size(); i++){
%>
<a homepagecode="<%=bigBannerhomepagecode%>" bannerPk="<%=jsonDataSet.bigBannerData.getJSONArray("dataList").getJSONObject(i).getString("bannerPkNo")%>" actPk="<%=jsonDataSet.bigBannerData.getJSONArray("dataList").getJSONObject(i).getString("activityPkNo") %>" onMouseDown="miningTrigger(this);return false;" href="<%=jsonDataSet.bigBannerData.getJSONArray("dataList").getJSONObject(i).getString("activityUrl") %>">
<%
String mbBanner = jsonDataSet.bigBannerData.getJSONArray("dataList").getJSONObject(i).getString("mbBannerPkNo");
if ("0".equals(mbBanner) || "".equals(mbBanner)){%>
<img src="https://media.taaze.tw/showBanaerImage.html?pk=<%=jsonDataSet.bigBannerData.getJSONArray("dataList").getJSONObject(i).getString("bannerPkNo")%>&width=300&height=250&fill=f" alt="" >
<%}else{%>
<img src="https://media.taaze.tw/showBanaerImage.html?pk=<%=jsonDataSet.bigBannerData.getJSONArray("dataList").getJSONObject(i).getString("mbBannerPkNo")%>&width=300&height=250&fill=f" alt="">
<%}	%>
</a>
<%
}
}else{
String bigBannerhomepagecode = SystemUtil.homepageTypeMap.get("02"+urlParamters.getD().concat("00").concat("A"));
for(int i=0; i<jsonDataSet.bigBannerData.getJSONArray("dataList").size(); i++){
%>
<a homepagecode="<%=bigBannerhomepagecode%>" bannerPk="<%=jsonDataSet.bigBannerData.getJSONArray("dataList").getJSONObject(i).getString("bannerPkNo")%>" actPk="<%=jsonDataSet.bigBannerData.getJSONArray("dataList").getJSONObject(i).getString("activityPkNo") %>" onMouseDown="miningTrigger(this);return false;" href="<%=jsonDataSet.bigBannerData.getJSONArray("dataList").getJSONObject(i).getString("activityUrl") %>">
<%
String mbBanner = jsonDataSet.bigBannerData.getJSONArray("dataList").getJSONObject(i).getString("mbBannerPkNo");
if ("0".equals(mbBanner) || "".equals(mbBanner)){%>
<img src="https://media.taaze.tw/showBanaerImage.html?pk=<%=jsonDataSet.bigBannerData.getJSONArray("dataList").getJSONObject(i).getString("bannerPkNo")%>&width=300&height=250&fill=f" alt="" >
<%}else{%>
<img src="https://media.taaze.tw/showBanaerImage.html?pk=<%=jsonDataSet.bigBannerData.getJSONArray("dataList").getJSONObject(i).getString("mbBannerPkNo")%>&width=300&height=250&fill=f" alt="">
<%}	%>
</a>
<%
}
}
}else{
String bigBannerhomepagecode = SystemUtil.homepageTypeMap.get(urlParamters.getT().concat(urlParamters.getC().substring(0,2)).concat("A"));
for(int i=0; i<jsonDataSet.bigBannerData.getJSONArray("dataList").size(); i++){
%>
<a homepagecode="<%=bigBannerhomepagecode%>" bannerPk="<%=jsonDataSet.bigBannerData.getJSONArray("dataList").getJSONObject(i).getString("bannerPkNo")%>" actPk="<%=jsonDataSet.bigBannerData.getJSONArray("dataList").getJSONObject(i).getString("activityPkNo") %>" onMouseDown="miningTrigger(this);return false;" href="<%=jsonDataSet.bigBannerData.getJSONArray("dataList").getJSONObject(i).getString("activityUrl") %>">
<%
String mbBanner = jsonDataSet.bigBannerData.getJSONArray("dataList").getJSONObject(i).getString("mbBannerPkNo");
if ("0".equals(mbBanner) || "".equals(mbBanner)){%>
<img src="https://media.taaze.tw/showBanaerImage.html?pk=<%=jsonDataSet.bigBannerData.getJSONArray("dataList").getJSONObject(i).getString("bannerPkNo")%>&width=300&height=250&fill=f" alt="" >
<%}else{%>
<img src="https://media.taaze.tw/showBanaerImage.html?pk=<%=jsonDataSet.bigBannerData.getJSONArray("dataList").getJSONObject(i).getString("mbBannerPkNo")%>&width=300&height=250&fill=f" alt="">
<%}	%>
</a>
<%
}
}
%>
</div>
<%
}
%>
<%--大版Banner --%>


<%--site map --%>
<div style="padding-top:10px;">
<span style="font-weight:bold;">排序方式&nbsp;&nbsp;</span>
<div class="btn-group" id="sortm-group">
<button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown" id="selectSort_m">
暢銷度 <img class="notice_btn noticeShow_btn" style ="margin-top:-6px;"/>
</button>
<ul id="sortm" class="dropdown-menu" role="menu">
<li><a href="#" onclick="sortBy(this, event)" rel="2">暢銷度</a></li>
<li><a href="#" onclick="sortBy(this, event)" rel="1">出版日期</a></li>
<li><a href="#" onclick="sortBy(this, event)" rel="3">價格</a></li>
</ul>
</div>
</div>
<div style="clear:both;"></div>
<div class="row" id="listViewForMobile">
<!--  -->
<div style="width:100%; height:5px; background:#e8e8e8; border-top:1px #CCCCCC solid;"></div>
</div>
<div class="row">
<div class="col-xs-12 text-center">
<nav>
<ul class="pagination pagination-sm" id="pageButtonsForMobile">
</ul>
</nav>
</div>
</div>
</div>
<%-- mobile model end ------------------------------------------------------- --%>
<%-- body end --%>
<jsp:include page="/new_ec/rwd/include/jsp/include_footer.jsp" flush="true"/>
<%@ include file="/new_ec/rwd/include/js.jsp" %>
<script type="text/javascript" src="/new_ec/rwd/include/js/include_list.js"></script>
<script type="text/javascript">
var isInit = true;
$(document).ready(function(){
if(typeof(State_initial)!="undefined"){
if(State_initial.data.state!=null){
$('#HIDE_NOWPAGE').val(State_initial.data.state);
}
if(State_initial.data.sort!=null){
$('#HIDE_SORT').val(State_initial.data.sort);
}
if(State_initial.data.showModel!=null){
$('#HIDE_SHOWMODEL').val(State_initial.data.showModel);
}
loadViewData();
}else{
loadViewData();
}
});
function loadViewData(){
//return;
console.log("PC Model => loadViewData Start....");
$.blockUI({
overlayCSS: { backgroundColor: '#ffffff' },
message: '<img src="../images/common/loading.gif" width="42" height="51" alt="" />',
css: {
top:  ($(window).height() - 42) /2 + 'px',
left: ($(window).width() - 51) /2 + 'px',
width: '42px',
width: '51px',
border: '0px'
}
});
//alert($('#HIDE_NOWPAGE').val());
//alert($('#HIDE_SORT').val());
//alert($('#HIDE_SHOWMODEL').val());
$("html, body").animate({ scrollTop: 0 }, 600);
var sp = (parseInt($('#HIDE_NOWPAGE').val())-1) * parseInt($('#HIDE_PAGESIZE').val());
//var ep = ep = sp+29;
var ep = (parseInt($('#HIDE_NOWPAGE').val()) * parseInt($('#HIDE_PAGESIZE').val()))-1;
var showModel = $("#HIDE_SHOWMODEL").val();
if(showModel=='2'){
ep = (parseInt($('#HIDE_NOWPAGE').val()) * parseInt($('#HIDE_PAGESIZE').val()))-1;
}
var sort = $("#HIDE_SORT").val();
if(sort=="1"){
$("#selectSort").html("出版日期排序 <span class=\"caret\"></span>");
$("#selectSort_m").html("出版日期 <img class=\"notice_btn noticeShow_btn\" style =\"margin-top:-6px;\"/>");
}
else if(sort=="2"){
$("#selectSort").html("暢銷度排序 <span class=\"caret\"></span>");
$("#selectSort_m").html("暢銷度 <img class=\"notice_btn noticeShow_btn\" style =\"margin-top:-6px;\"/>");
}
else if(sort=="3"){
$("#selectSort").html("價格排序 <span class=\"caret\"></span>");
$("#selectSort_m").html("價格 <img class=\"notice_btn noticeShow_btn\" style =\"margin-top:-6px;\"/>");
}
var t = $("#HIDE_T").val();
if($("#HIDE_K").val()=='03'){
t = $("#HIDE_D").val();
}
$.ajax({
type: "get",
url: "../beta/viewDataAgent.jsp",
timeout:1000,
data: { 'a':$("#HIDE_A").val(), 'd':$("#HIDE_D").val(), 'l':$("#HIDE_L").val(), 't':t, 'c':$("#HIDE_C").val(), 'k':$("#HIDE_K").val(), 'startNum':sp, 'endNum':ep, 'sortType':sort },
async: false,
dataType: "text",
error: function(err){ alert("請再試一次"); loadViewData(); },
success: function(data){
$("code#listViewData").html(data=="null"?"":data.replaceAll("<","《").replaceAll(">","》"));
var JData;
try {
JData = jQuery.parseJSON($("code#listViewData").html());
} catch (e) {
alert("很抱歉！資料發生錯誤，請稍後再試。");
console.log(e);
$("div#listView").empty();
return;
}
$('#HIDE_TOTALSIZE').val(JData.totalsize);
$("div#listView").empty();
var len = parseInt($('#HIDE_PAGESIZE').val())>JData.result1.length?JData.result1.length:parseInt($('#HIDE_PAGESIZE').val());
if(showModel=="1"){
<%-- 冊格顯示 --%>
$("#layoutGrid").addClass("disabled");
$("#layoutList").removeClass("disabled");
if(JData.result1!=null && JData.result1.length>0){
for(var i=0; i<len; i++){
var html = "";
html += "<div class=\"bookGridByListView\">";
html += "<div class=\"\">";
//html += "<a href=\"/sing.html?pid=" + JData.result1[i].prodId + "\" onclick=\"historyStatByListView(this, event, 10000)\">";
html += "<div class='bookImage' style='position: relative;'>";
if($("#HIDE_K").val()=="03"){
html += "<a href=\"/usedList.html?oid=" + JData.result1[i].orgProdId + "\" onclick=\"historyStatByListView(this, event, 10000)\">";
}
else{
html += "<a href=\"/products/" + JData.result1[i].prodId + ".html\" onclick=\"historyStatByListView(this, event, 10000)\">";
}
//html += "<img data-src=\"holder.js/100%x195\" alt=\"\" src=\"http://media.taaze.tw/showThumbnail.html?sc=" + JData.result1[i].orgProdId + "&height=220&width=180\" data-holder-rendered=\"true\" class=\"bookImage\">";
if(JData.result1[i].rank=="D"){
html += "<img data-src=\"holder.js/100%x195\" alt=\"\" src=\"/new_ec/rwd/include/images/B_image/pic_book_1@2x.png\" height=\"220\" width=\"180\" data-holder-rendered=\"true\" class=\"bookImage\">";
}
else{
html += "<img id=\"bookImgPCGrid"+i+"\" data-src=\"holder.js/100%x195\" alt=\"\" src=\"/new_ec/rwd/include/images/B_image/rwd_220x268.jpg\" data-holder-rendered=\"true\" class=\"bookImage\">";
}
html += "</a>";;
// switch(JData.result1[i].bindingType){
// case "P":
// 	html += "<div class='ebook_type' style='position: absolute; right: 2px; bottom:0px;width:26px;height:36px; background:url(\"/new_ec/single/include/images/pdf_26x36.png\") no-repeat;box-shadow: rgba(19, 20, 40, 0.498) 0px 1px 3px;'></div>";
// 	break;
// case "Q":
// 	html += "<div class='ebook_type' style='position: absolute; right: 2px; bottom:0px;width:26px;height:36px; background:url(\"/new_ec/single/include/images/epub_26x36.png\") no-repeat;box-shadow: rgba(19, 20, 40, 0.498) 0px 1px 3px;'></div>";
// 	break;
// }
if("Y"==JData.result1[i].adoFlg){
html += "<div  style='position: absolute; right: 2px; bottom:0px;width:38px;height:38px; background:url(\"/new_ec/rwd/include/images/ic_ebook_sound_38.png\") no-repeat;'></div>";
}else if("P"==JData.result1[i].bindingType || "O"==JData.result1[i].bindingType){
html += "<div  style='position: absolute; right: 2px; bottom:0px;width:38px;height:38px; background:url(\"/new_ec/rwd/include/images/ic_ebook_fix_38.png\") no-repeat;'></div>";
}else if("Q"==JData.result1[i].bindingType){
html += "<div  style='position: absolute; right: 2px; bottom:0px;width:38px;height:38px; background:url(\"/new_ec/rwd/include/images/ic_ebook_rwd_38.png\") no-repeat;'></div>";
}
html += "</div>";
html += "<div class=\"caption bookCaption\">";
html += "<ul style=\"list-style:none; margin:0; padding:0;\">";
html += "<li class='prod_TitleMain'>";
//html += "<a href=\"/sing.html?pid=" + JData.result1[i].prodId + "\" onclick=\"historyStatByListView(this, event, 10000)\">";
if($("#HIDE_K").val()=="03"){
html += "<a href=\"/usedList.html?oid=" + JData.result1[i].orgProdId + "\" onclick=\"historyStatByListView(this, event, 10000)\">";
}
else{
html += "<a href=\"/products/" + JData.result1[i].prodId + ".html\" onclick=\"historyStatByListView(this, event, 10000)\">";
}
html += JData.result1[i].titleMain;
html += "</a>";
html += "</li>";
if(JData.result1[i].author.length>0){
var auth=JData.result1[i].author;
html += "<li class='prod_author'>作者：<a href='/rwd_searchResult.html?keyword%5B%5D="+auth+"&keyType%5B%5D=2'>" + auth+ "</a></li>";
}
html += "<li class='discPrice'>";
html += $("#HIDE_K").val()=="03"?"二手價：":"優惠價：";
if(JData.result1[i].saleDisc<100 && JData.result1[i].saleDisc>0){
var disc = JData.result1[i].saleDisc;
if(disc <10){
disc = "0."+disc;
}
if(disc.endsWith('0')){
disc = disc.substring(0,1);
}
html += "<span>"+ disc + "</span>折";
//html += "<span style='color:#e3007f'> " + JData.result1[i].salePrice + "</span>元";
}
html += "<span style='color:#e3007f'>" + Math.round(JData.result1[i].salePrice) + "</span>元</li>";
html += "</ul>";
html += "</div>";
html += "</div>";
html += "</div>";
$("div#listView").append(html);
}
}
//圖片載入後換圖
for(var i=0; i<len; i++){
var item ="bookImgPCGrid"+i;
var el = document.getElementById(item);
function changeimagePCGrid(image){
const img = new Image();
img.src = 'https://media.taaze.tw/showThumbnail.html?sc=' + JData.result1[i].orgProdId + '&height=220&width=180';
img.onload = function(){ image.src = img.src; }
}
changeimagePCGrid(el);
}
}else{
<%-- 條列顯示 --%>
$("#layoutList").addClass("disabled");
$("#layoutGrid").removeClass("disabled");
if(JData.result1!=null && JData.result1.length>0){
for(var i=0; i<JData.result1.length; i++){
var html = "";
html += "<div class=\"media\">";
//html += "<a class=\"media-left\" href=\"/sing.html?pid=" + JData.result1[i].prodId + "\" onclick=\"historyStatByListView(this, event, 10000)\">";
//html += "<a class=\"media-left\" href=\"/products/" + JData.result1[i].prodId + ".html\" onclick=\"historyStatByListView(this, event, 10000)\" style = 'position:relative;' >";
if($("#HIDE_K").val()=="03"){
html += "<a class=\"media-left\" href=\"/usedList.html?oid=" + JData.result1[i].orgProdId + "\" onclick=\"historyStatByListView(this, event, 10000)\" style = 'position:relative;'>";
}
else{
html += "<a class=\"media-left\" href=\"/products/" + JData.result1[i].prodId + ".html\" onclick=\"historyStatByListView(this, event, 10000)\" style = 'position:relative;' >";
}
//html += "<img alt=\"\" src=\"http://media.taaze.tw/showThumbnail.html?sc=" + JData.result1[i].orgProdId + "&height=220&width=180\">";
if(JData.result1[i].rank=="D"){
html += "<img data-src=\"holder.js/100%x195\" alt=\"\" src=\"/new_ec/rwd/include/images/B_image/pic_book_1@2x.png\" height=\"220\" width=\"180\" data-holder-rendered=\"true\" class=\"bookImage\">";
}
else{
html += "<img id=\"bookImgPCList"+i+"\" data-src=\"holder.js/100%x195\" alt=\"\" src=\"/new_ec/rwd/include/images/B_image/rwd_220x268.jpg\" data-holder-rendered=\"true\" class=\"bookImage\">";
}
// switch(JData.result1[i].bindingType){
// case "P":
// 	html += "<img class='ebook_type' style='position: absolute; right: 10px; bottom:0px;width:26px;height:36px; background:url(\"/new_ec/single/include/images/pdf_26x36.png\") no-repeat;box-shadow: rgba(19, 20, 40, 0.498) 0px 1px 3px;' />";
// 	break;
// case "Q":
// 	html += "<img class='ebook_type' style='position: absolute; right: 10px; bottom:0px;width:26px;height:36px; background:url(\"/new_ec/single/include/images/epub_26x36.png\") no-repeat;box-shadow: rgba(19, 20, 40, 0.498) 0px 1px 3px;' />"
// }
if("Y"==JData.result1[i].adoFlg){
html += "<div  style='position: absolute; right: 10px; bottom:0px;width:38px;height:38px; background:url(\"/new_ec/rwd/include/images/ic_ebook_sound_38.png\") no-repeat;'></div>";
}else if("P"==JData.result1[i].bindingType || "O"==JData.result1[i].bindingType){
html += "<div  style='position: absolute; right: 10px; bottom:0px;width:38px;height:38px; background:url(\"/new_ec/rwd/include/images/ic_ebook_fix_38.png\") no-repeat;'></div>";
}else if("Q"==JData.result1[i].bindingType){
html += "<div  style='position: absolute; right: 10px; bottom:0px;width:38px;height:38px; background:url(\"/new_ec/rwd/include/images/ic_ebook_rwd_38.png\") no-repeat;'></div>";
}
html += "</a>";
html += "<div class=\"media-body\">";
if($("#HIDE_K").val()=="03"){
html += "<a style='position:relative;' href=\"/usedList.html?oid=" + JData.result1[i].orgProdId + "\">";
}
else{
html += "<a style='position:relative;' href=\"/products/" + JData.result1[i].prodId + ".html\">";
}
html += "<h4 class=\"media-heading\">" + JData.result1[i].titleMain + "</h4>";
html += "</a>";
if(JData.result1[i].author.length>0){
var auth=JData.result1[i].author;
html += "<div>作者：<a href='/rwd_searchResult.html?keyword%5B%5D="+auth+"&keyType%5B%5D=2'>" + auth + "</a></div>";
}
if(JData.result1[i].publishDate.length>0){
html += "<div>出版日期：" + JData.result1[i].publishDate + "</div>";
}
if(JData.result1[i].pubNmMain.length>0){
html += "<div>出版社：<a href='/rwd_searchResult.html?keyword%5B%5D=" + JData.result1[i].pubNmMain + "&keyType%5B%5D=3'>"+JData.result1[i].pubNmMain+"</a></div>";
}
html += "<div>定價：" + JData.result1[i].listPrice + "元，";
html += $("#HIDE_K").val()=="03"?"二手價：":"優惠價：";
if(JData.result1[i].saleDisc<100 && JData.result1[i].saleDisc>0){
var disc = JData.result1[i].saleDisc;
if(disc <10){
disc = "0."+disc;
}
if(disc.endsWith('0')){
disc = disc.substring(0,1);
}
html += "<span style='color:#e3007f'>"+ disc + "</span>折";
}
html += "<span style='color:#e3007f'> " + Math.round(JData.result1[i].salePrice) + "</span>元</div>";
if(JData.result1[i].prodPf.length>0){
html += "<div style=\"margin-top:10px;\">" + subWord(JData.result1[i].prodPf,200) + "</div>";
}else{
if($("#HIDE_K").val()=='03'){
var pfUrl = "/beta/searchbookAgent.jsp";
$.ajax({
type: "get",
url: pfUrl,
timeout:1000,
data: {'prodId':JData.result1[i].prodId,'pfLength':'160'},
async: false,
dataType: "json",
error: function(err){ console.log("請再試一次"); //loadViewData();
console.log(err)
},
success: function(data){
html += "<div style=\"margin-top:10px;\">" + data[0].bookprofile + "</div>";
},
complete: function(){
}
});
}
}
html += "</div>";//media-body
html += "<hr />";
html += "</div>";
$("div#listView").append(html);
}
//圖片載入後換圖
for(var i=0; i<len; i++){
var item ="bookImgPCList"+i;
var el = document.getElementById(item);
function changebookImgPCList(image){
const img = new Image();
img.src = 'https://media.taaze.tw/showThumbnail.html?sc=' + JData.result1[i].orgProdId + '&height=220&width=180';
img.onload = function(){ image.src = img.src; }
}
changebookImgPCList(el);
}
}
}
<%-- Mobile list view --%>
$("div#listViewForMobile").empty();
if(JData.result1!=null && JData.result1.length>0){
for(var i=0; i<len; i++){
var html = "";
html += "<div class=\"mlistView\" style=\"\">";
//html += "<a class=\"media-left\" href=\"/sing.html?pid=" + JData.result1[i].prodId + "\">";
html += "<div style='margin:0 auto'>";
html += "<div style='position: relative;'>"
//html += "<a href=\"/products/" + JData.result1[i].prodId + ".html\">";
if($("#HIDE_K").val()=="03"){
html += "<a href=\"/usedList.html?oid=" + JData.result1[i].orgProdId + "\">";
}
else{
html += "<a href=\"/products/" + JData.result1[i].prodId + ".html\">";
}
//html += "<img alt=\"\" width=\"100%\" height=\"auto\" src=\"http://media.taaze.tw/showThumbnail.html?sc=" + JData.result1[i].orgProdId + "&height=300&width=230\">";
if(JData.result1[i].rank=="D"){
html += "<img alt=\"\" width=\"100%\" height=\"auto\" src=\"/new_ec/rwd/include/images/B_image/pic_book_1@2x.png\" height=\"300\" width=\"230\">";
}
else{
html += "<img id=\"bookImgMobile"+i+"\" alt=\"\" width=\"100%\" height=\"auto\" src=\"/new_ec/rwd/include/images/B_image/rwd_300x250.jpg\">";
}
// switch(JData.result1[i].bindingType){
// case "P":
// 	html += "<img class='ebook_type' style='position: absolute; right: 0px; bottom:0px;width:26px;height:36px; background:url(\"/new_ec/single/include/images/pdf_26x36.png\") no-repeat;box-shadow: rgba(19, 20, 40, 0.498) 0px 1px 3px;' />";
// 	break;
// case "Q":
// 	html += "<img class='ebook_type' style='position: absolute; right: 0px; bottom:0px;width:26px;height:36px; background:url(\"/new_ec/single/include/images/epub_26x36.png\") no-repeat;box-shadow: rgba(19, 20, 40, 0.498) 0px 1px 3px;' />"
// 	break;
// }
if("Y"==JData.result1[i].adoFlg){
html += "<div  style='position: absolute; right: 0px; bottom:0px;width:38px;height:38px; background:url(\"/new_ec/rwd/include/images/ic_ebook_sound_38.png\") no-repeat;'></div>";
}else if("P"==JData.result1[i].bindingType || "O"==JData.result1[i].bindingType){
html += "<div  style='position: absolute; right: 0px; bottom:0px;width:38px;height:38px; background:url(\"/new_ec/rwd/include/images/ic_ebook_fix_38.png\") no-repeat;'></div>";
}else if("Q"==JData.result1[i].bindingType){
html += "<div  style='position: absolute; right: 0px; bottom:0px;width:38px;height:38px; background:url(\"/new_ec/rwd/include/images/ic_ebook_rwd_38.png\") no-repeat;'></div>";
}
html += "</a>";
html += "</div>";
html += "<div class=\"bookCaption\">";
//html += "<a href=\"/sing.html?pid=" + JData.result1[i].prodId + "\">";
//html += "<a href=\"/products/" + JData.result1[i].prodId + ".html\">";
if($("#HIDE_K").val()=="03"){
html += "<a href=\"/usedList.html?oid=" + JData.result1[i].orgProdId + "\">";
}
else{
html += "<a href=\"/products/" + JData.result1[i].prodId + ".html\">";
}
html += "<h5 class='prod_TitleMain'>" + JData.result1[i].titleMain + "</h5>";
html += "</a>";
//html += "<div>作者：" + JData.result1[i].author + "</div>";
//html += "<div>出版日期：2017-01-05</div>";
//html += "<div>出版社：" + JData.result1[i].publishDate + "</div>";
html += "<div class=\"discPrice\">";
html += $("#HIDE_K").val()=="03"?"二手價：":"優惠價：";
html += "<span>" ;
if(JData.result1[i].saleDisc<100 && JData.result1[i].saleDisc>0){
var disc = JData.result1[i].saleDisc;
if(disc <10){
disc = "0."+disc;
}
if(disc.endsWith('0')){
disc = disc.substring(0,1);
}
html += disc + "</span>折<span> " ;
}
html += Math.round(JData.result1[i].salePrice) + "</span>元</div>";
html += "</div>";
$("div#listViewForMobile").append(html);
}
}
//圖片載入後換圖
for(var i=0; i<len; i++){
var item ="bookImgMobile"+i;
var el = document.getElementById(item);
function changeimageMobile(image){
const img = new Image();
img.src = 'https://media.taaze.tw/showThumbnail.html?sc=' + JData.result1[i].orgProdId + '&height=300&width=230';
img.onload = function(){ image.src = img.src; }
}
changeimageMobile(el);
}
},
complete: function(){
setTimeout($.unblockUI, 1000);
PageCountButton();
PageCountButtonForMobile();
}
});//ajax
}
var subWord=function(str,n){
var r=/[^\x00-\xff]/g;
if(str.replace(r,"mm").length<=n){return str;}
var m=Math.floor(n/2);
for(var i=m;i<str.length;i++){
if(str.substr(0,i).replace(r,"mm").length>=n){
return str.substr(0,i)+"..";
}
}
return str;
}
function PageCountButton(){
var nowpage = 0;
var countrecord = 0;
var countpage = 0;
var PAGESIZE = parseInt($('#HIDE_PAGESIZE').val());
var startpage;
var endpage;
var SHOWPAGE = 10;
nowpage = parseInt($('#HIDE_NOWPAGE').val());
countrecord = parseInt($('#HIDE_TOTALSIZE').val());
countpage = countrecord % PAGESIZE == 0 ? (countrecord  / PAGESIZE)  : Math.floor(countrecord / PAGESIZE) + 1;
if (countpage < (SHOWPAGE / 2 + 1)) {
startpage = 1;
endpage = countpage;
}else{
if (nowpage <= (SHOWPAGE / 2 + 1)) {
startpage = 1;
endpage = SHOWPAGE;
if (endpage >= countpage) {
endpage = countpage;
}
} else {
//startpage = nowpage - (SHOWPAGE/2);
startpage = nowpage - Math.floor(SHOWPAGE/2);
//endpage = nowpage + (SHOWPAGE-1);
endpage = startpage + (SHOWPAGE-1);
if (endpage >= countpage) {
endpage = countpage;
if (countpage <= SHOWPAGE) {
startpage = 1;
} else {
startpage = endpage - SHOWPAGE;
}
}
}
}
$("ul#pageButtons").empty();
if(nowpage>1){
//$("<li><a href=\"#\" onclick=\"gotoPage(this, event, 1)\">&lt;&lt;</a></li>").appendTo($("ul#pageButtons"));
$("<li><a class='arrowForLeftImg_s' style='border:none;display:block' href=\"#\" onclick=\"gotoPage(this, event, " + (nowpage-1) + ")\"></a></li>").appendTo($("ul#pageButtons"));
if(startpage>1){
//$("<li><a href=\"#\" onclick=\"gotoPage(this, event, 1)\">1... </a></li>").appendTo($("ul#pageButtons"));
}
}
for(var s1 = startpage; s1<=endpage; s1++){
if(s1==nowpage){
$("<li class=\"active\"><a href=\"#\" onclick=\"gotoPage(this, event, " + s1 + ")\">" + s1 + "</a></li>").appendTo($("ul#pageButtons"));
}else{
$("<li><a href=\"#\" onclick=\"gotoPage(this, event, " + s1 + ")\">" + s1 + "</a></li>").appendTo($("ul#pageButtons"));
}
}
if(countpage>nowpage){
if(countpage > endpage){
//$("<li><a href=\"#\" onclick=\"gotoPage(this, event, " + countpage + ")\"> ... "+countpage+"</a></li>").appendTo($("ul#pageButtons"));
}
$("<li><a class='arrowForRightImg_s' style='border:none;display:block' href=\"#\" onclick=\"gotoPage(this, event, " + (nowpage+1) + ")\"></a></li>").appendTo($("ul#pageButtons"));
}
}
function PageCountButtonForMobile(){
var nowpage = 0;
var countrecord = 0;
var countpage = 0;
var PAGESIZE = parseInt($('#HIDE_PAGESIZE').val());
var startpage;
var endpage;
var SHOWPAGE = 5;
nowpage = parseInt($('#HIDE_NOWPAGE').val());
countrecord = parseInt($('#HIDE_TOTALSIZE').val());
countpage = countrecord % PAGESIZE == 0 ? countrecord  / PAGESIZE  : Math.floor(countrecord / PAGESIZE) + 1;
if (countpage < (SHOWPAGE / 2 + 1)) {
startpage = 1;
endpage = countpage;
}else{
if (nowpage <= (SHOWPAGE / 2 + 1)) {
startpage = 1;
endpage = SHOWPAGE;
if (endpage >= countpage) {
endpage = countpage;
}
} else {
startpage = nowpage - Math.floor(SHOWPAGE/2);
endpage = startpage + (SHOWPAGE-1);
if (endpage >= countpage) {
endpage = countpage;
if (countpage <= SHOWPAGE) {
startpage = 1;
} else {
startpage = endpage - SHOWPAGE;
}
}
}
}
$("ul#pageButtonsForMobile").empty();
if(nowpage>1){
//$("<li><a href=\"#\" onclick=\"gotoPage(this, event, 1)\">&lt;&lt;</a></li>").appendTo($("ul#pageButtonsForMobile"));
//$("<li><a href=\"#\" onclick=\"gotoPage(this, event, " + (nowpage-1) + ")\">&lt;</a></li>").appendTo($("ul#pageButtonsForMobile"));
$("<li><a class='arrowForLeftImg_s' style='display:block;border:none' href=\"#\" onclick=\"gotoPage(this, event, " + (nowpage-1) + ")\"></a></li>").appendTo($("ul#pageButtonsForMobile"));
if(startpage>1){
//$("<li><a href=\"#\" onclick=\"gotoPage(this, event, 1)\">1... </a></li>").appendTo($("ul#pageButtonsForMobile"));
}
}
for(var s1 = startpage; s1<=endpage; s1++){
if(s1==nowpage){
$("<li class=\"active\"><a href=\"#\" onclick=\"gotoPage(this, event, " + s1 + ")\">" + s1 + "</a></li>").appendTo($("ul#pageButtonsForMobile"));
}else{
$("<li><a href=\"#\" onclick=\"gotoPage(this, event, " + s1 + ")\">" + s1 + "</a></li>").appendTo($("ul#pageButtonsForMobile"));
}
}
if(countpage>nowpage){
//$("<li><a href=\"#\" onclick=\"gotoPage(this, event, " + (nowpage+1) + ")\">&gt;</a></li>").appendTo($("ul#pageButtonsForMobile"));
//$("<li><a href=\"#\" onclick=\"gotoPage(this, event, " + countpage + ")\">&gt;&gt;</a></li>").appendTo($("ul#pageButtonsForMobile"));
if(countpage > endpage){
//$("<li><a href=\"#\" onclick=\"gotoPage(this, event, " + countpage + ")\"> ... "+countpage+"</a></li>").appendTo($("ul#pageButtonsForMobile"));
}
$("<li><a class='arrowForRightImg_s' style='display:block;border:none' href=\"#\" onclick=\"gotoPage(this, event, " + (nowpage+1) + ")\"></a></li>").appendTo($("ul#pageButtonsForMobile"));
}
}
function gotoPage(e, event, page){
event.preventDefault();
$('#HIDE_NOWPAGE').val(page);
//History.pushState({'state':page, 'sort':$('#HIDE_SORT').val(), 'showModel':$('#HIDE_SHOWMODEL').val() ,'rand':Math.random()}, "", "#" + $('#HIDE_NOWPAGE').val());
//loadViewData();
location.href = "#" + $('#HIDE_NOWPAGE').val()+"$"+$('#HIDE_SHOWMODEL').val()+"$"+$('#HIDE_SORT').val();
}
function historyStatByListView(e, event, index_position){
event.preventDefault();
//History.pushState({state:parseInt($('#HIDE_NOWPAGE').val()), sort:$('#HIDE_SORT').val(), showModel:$('#HIDE_SHOWMODEL').val() ,rand:Math.random()}, "", "#" + $('#HIDE_NOWPAGE').val());
location.href = $(e).attr("href");
}
function sortBy(e, event){
event.preventDefault();
var elm = $(e);
$('#HIDE_SORT').val(elm.attr("rel"));
$('#HIDE_NOWPAGE').val(1);
//History.pushState({state:parseInt($('#HIDE_NOWPAGE').val()), sort:$('#HIDE_SORT').val(), showModel:$('#HIDE_SHOWMODEL').val() ,rand:Math.random()}, "", "#" + $('#HIDE_NOWPAGE').val());
//$("#selectSort").html( elm.html() + " <span class=\"caret\"></span>");
//$("html, body").animate({ scrollTop: 0 }, 600);
//loadViewData();
location.href = "#" + $('#HIDE_NOWPAGE').val()+"$"+$('#HIDE_SHOWMODEL').val()+"$"+$('#HIDE_SORT').val();
}
function layoutByGrid(e){
var elm = $(e);
if(!elm.hasClass("disabled")){
$("#HIDE_SHOWMODEL").val(1);
$('#HIDE_PAGESIZE').val(24);
$('#HIDE_NOWPAGE').val(1);
//$("#layoutGrid").addClass("disabled");
//$("#layoutList").removeClass("disabled");
//History.pushState({state:parseInt($('#HIDE_NOWPAGE').val()), sort:$('#HIDE_SORT').val(), showModel:$('#HIDE_SHOWMODEL').val() ,rand:Math.random()}, "", "#" + $('#HIDE_NOWPAGE').val());
//loadViewData();
location.href = "#" + $('#HIDE_NOWPAGE').val()+"$"+$('#HIDE_SHOWMODEL').val()+"$"+$('#HIDE_SORT').val();
}
}
function layoutByList(e){
var elm = $(e);
if(!elm.hasClass("disabled")){
$("#HIDE_SHOWMODEL").val(2);
$('#HIDE_PAGESIZE').val(5);
$('#HIDE_NOWPAGE').val(1);
//$("#layoutGrid").removeClass("disabled");
//$("#layoutList").addClass("disabled");
//History.pushState({state:parseInt($('#HIDE_NOWPAGE').val()), sort:$('#HIDE_SORT').val(), showModel:$('#HIDE_SHOWMODEL').val() ,rand:Math.random()}, "", "#" + $('#HIDE_NOWPAGE').val());
//loadViewData();
location.href = "#" + $('#HIDE_NOWPAGE').val()+"$"+$('#HIDE_SHOWMODEL').val()+"$"+$('#HIDE_SORT').val();
}
}
History.Adapter.bind(window,'hashchange',function(){
var hash =location.hash!=""?location.hash.replace("#",""):"1";
var page;
var model = '1';
var sort = '2';
var words = hash.split('$');
page = words[0];
model = typeof(words[1])!='undefined'? words[1]:'1';
if(words.length>2){
sort = typeof(words[2])!='undefined'? words[2]:'2';
}
$('#HIDE_NOWPAGE').val(page);
$('#HIDE_SHOWMODEL').val(model);
$('#HIDE_SORT').val(sort);
if(model=='1'){
$('#HIDE_PAGESIZE').val(24);
}else if(model=='2'){
$('#HIDE_PAGESIZE').val(5);
}
loadViewData();
});
</script>
</body>
</html>
