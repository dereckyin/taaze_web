<%@page import="com.xsx.ec.model.Cat4xsxModel"%>
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
<%@page import="com.enjar.ec.util.ApUtil"%>
<%@page import="java.util.Calendar" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="javax.sql.DataSource" %>
<%@ page import="com.enjar.system.util.SpringUtil" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ taglib uri="/WEB-INF/tlds/c.tld" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8" %>
<%@ taglib prefix="s" uri="/struts-tags" %>
<%@ include file="../single/include/jsp/SingleUsedLibs.jsp" %>
<%
Log log = LogFactory.getLog(this.getClass());
SystemDAO systemDao = (SystemDAO) SpringUtil.getSpringBeanById(this.getServletConfig(), "SystemDAO");
boolean openNewCollectFriendsFlg = SystemUtil.openWecollectfunFlg || SystemUtil.isHomeIP(request);
CustQingdanService custQingdanService = (CustQingdanService) SpringUtil.getSpringBeanById(this.getServletConfig(), "CustQingdanService");
String pid = "11100764589";
SingleUsedLibs sing = null;
SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
//log.info(request.getRemoteAddr());
if (pid.length() == 11) {
	sing = new SingleUsedLibs(this.getServletConfig(), pid);
} else {
	sing = new SingleUsedLibs();
}
if (!sing.initState) {
	//response.sendRedirect(sing.getWebUrl(request));
	out.print(sing.msgText);
	return;
}


SingleLibs sing_o = null;
if(pid.length()==11) {
	sing_o = new SingleLibs(this.getServletConfig(), pid);
} else {
	sing_o = new SingleLibs();
}

if (!sing_o.initState) {
	//response.sendRedirect(sing.getWebUrl(request));
	out.print(sing_o.msgText);
	return;
}

boolean logined = LoginUtil.isLoginCustomer(request);
Customer cc = null;
if (logined) {
	cc = LoginUtil.getLoginCustomer(request);
	if (cc == null) {
		LoginUtil.getCustomerLoginStatus(request, response);
	}
}
//圖檔
sing.setImgUrl(request);
boolean homeIp = true;
boolean sndSale = false;
String title = sing.titleMain + "";
String fbTitle = "讀冊【二手徵求好處多】|" + (sing.titleMain != null ? sing.titleMain + "|二手書交易資訊- TAAZE 讀冊生活" : "");
String fbDes = "【二手徵求好處多】|";
String fbImage = sing.imgUrl + "/showProdImage.html?sc=" + sing.orgProdId + "&width=200&height=283";
String divWidth1 = "301";
String divWidth2 = "454";
String prodImageWidth = "289";
String prodImageHeight = "386";
String prodImageWidth2 = "289";
String prodImageHeight2 = "386";
String prodImageBg = "300";
String showLargeImage = "showLargeImage";
String showProdImageByPK = "showProdImageByPK";
String prodAuthorText = "作者";
String searchProdAllUrlPattern = "/rwd_searchResult.html?keyType%5B%5D=0&keyword%5B%5D=";
String searchProdAuthorUrlPattern = "/rwd_searchResult.html?keyType%5B%5D=2&keyword%5B%5D=";
String searchProdPubUrlPattern = "/rwd_searchResult.html?keyType%5B%5D=3&keyword%5B%5D=";
String prodUrl = "/products/%s.html";//修改
String saleStatus = "C";
boolean IsWanted = false;
StringBuilder sb = null;
int version_size = 0;
String sale_text = "";
String sale_text2 = "";
String wnd_text = "";
String feature_sale = "";
String feature_want = "";
int total_want = 0;
String want_content_table = "";
//線上試讀
//String previewCount = sing.displayDL(sing.orgProdId, systemDao);
//出版日期距今
int diffDay = 0;
//評論筆數
// int startLevelSize = sing.getSizeStartLevelByOrgProdId(sing.orgProdId, systemDao);
int collectSize = sing.getProdCollect(sing.orgProdId, cc, systemDao);
if (sing.publishDate != null && sing.publishDate.trim().length() == 8) {
	diffDay = (int) sing.getDiffDay(new Date(), formatter.parse(sing.getDateFormat(sing.publishDate)));
}
if (cc != null) {
	List<Object> paraList = new ArrayList<Object>();
	paraList.add(cc.getCustId());
	paraList.add(sing.orgProdId);
	int IsWantedCheck = custQingdanService.getCustProdSeeklistSizeByWhcond(" where model.custId=? and model.orgProdId=?", paraList);
	if (IsWantedCheck > 0) {
		IsWanted = true;
	}
}
//相同版本
//JSONArray versionList = sing.getVersionList(sing.istProdId, sing.orgProdId);

Map<String, Integer> want_range = sing.getPriceRangeByWant(systemDao);
Map<String, JSONObject> sale_range = sing.getPriceRangeBySprod(systemDao);
Map<String, Integer> sprod_range = sing.getPriceRangeBySaleSprod(systemDao, sing.istProdId);
saleStatus = sing.getSaleStatus(systemDao);
if (sing.sndHandFlg.equals("Y")) {
	if (!sing.sndHandFlg2.equals("Y")) {
		if (sing.checkSprodLimit(sing.orgProdId, systemDao)) {
			sndSale = true;
		}
	}
	if (sing.sndHandFlg2.equals("Y")) {
		sndSale = true;
	}
}
fbDes += sing.titleMain != null ? sing.titleMain + ". " : "";
if (sing.titleNext != null && !sing.titleNext.equals(sing.titleMain)) {
	fbDes += sing.titleNext.replaceAll("\"", "'") + ". ";
}
if (sing.total_saler == 0) {
	sale_text = "上架公布";
}
if (sing.total_saler > 0) {
	int lowerest_disc = Math.round((sing.lowest_price / sing.listPrice) * 100);
	sale_text += "<span class='highlightu' style=' font-size: 13pt;'>" + sing.discString(String.valueOf(lowerest_disc)) + "</span>折";
	sale_text += sing.total_saler > 1 ? "<span class='highlightu' style=' font-size: 13pt;'>" + String.valueOf(sing.lowest_price) + "</span>元起，" : "<span class='highlightu' style=' font-size: 13pt;'>" + String.valueOf(sing.lowest_price) + "</span>元，";
	sale_text += "共<span>" + sing.total_saler + "</span>位賣家";
	sale_text2 += "二手價<span class='highlightu'>" + sing.discString(String.valueOf(lowerest_disc)) + "</span>折";
	sale_text2 += sing.total_saler > 1 ? "<span class='highlightu' >" + String.valueOf(sing.lowest_price) + "</span>元起，" : "<span class='highlightu' >" + String.valueOf(sing.lowest_price) + "</span>元，";
	sale_text2 += "共<span>" + sing.total_saler + "</span>位賣家";
	feature_sale = "二手價" + sing.discString(String.valueOf(lowerest_disc)) + "折" + String.valueOf(sing.lowest_price) + "元起，共" + sing.total_saler + "位賣家";
}
if (want_range.size() > 0) {
	int highest_disc = Math.round((sing.highest_wnt_price / sing.listPrice) * 100);
	if (highest_disc < 100) {
		feature_want += "徵求價" + sing.discString(String.valueOf(highest_disc)) + "折以下";
		wnd_text += "徵求價<span class='highlightu'>" + sing.discString(String.valueOf(highest_disc)) + "</span>折以下";
	} else {
		feature_want += "徵求價" + sing.highest_wnt_price + "元以下";
		wnd_text += "徵求價<span class='highlightu'>" + sing.highest_wnt_price + "</span>元以下";
	}
	//wnd_text += "<span class='highlightu' >"+String.valueOf(sing.lowest_price)+"</span>元，";
	wnd_text += "，目前有<span class='wantNum' ></span>位徵求";
	int index = 0;
	sb = new StringBuilder();
	sb.append("<table class='want_range' width='100%' class='table' border='0' cellspacing='0' cellpadding='0'>");
	sb.append("<tr class='column_title'><td class='column_left' width='50%'>徵求價</td><td width='50%'>數量</td></tr>");
	for (int i : sing.priceArray) {
		//log.info(want_range.get(String.valueOf(i)));
		String bg_color = "#ffffff";
		if (want_range.containsKey(String.valueOf(i))) {
			if (String.valueOf(i).equals(sing.most_sale)) {
				sb.append("<tr bgcolor='#efefef'><td class='column column_left' rel='" + i + "' style='font-weight:bold'>" + sing.getRangeText(i) + "</td><td class='column' align='right'>" + want_range.get(String.valueOf(i)) + "</td></tr>");
			} else {
				sb.append("<tr  bgcolor='" + bg_color + "'><td class='column column_left' rel='" + i + "'>" + sing.getRangeText(i) + "</td><td class='column' align='right'>" + want_range.get(String.valueOf(i)) + "</td></tr>");
			}
			total_want += Integer.valueOf(want_range.get(String.valueOf(i)));
		} else {
			if (String.valueOf(i).equals(sing.most_sale)) {
				sb.append("<tr  bgcolor='#efefef'><td class='column column_left' rel='" + i + "' style='font-weight:bold'>" + sing.getRangeText(i) + "</td><td class='column' align='right'>0</td></tr>");
			}
		}
		index++;
	}
	sb.append("</table>");
	want_content_table = sb.toString();
	sb.setLength(0);
	feature_want += "，目前有" + total_want + "位徵求";
	fbDes += total_want + "二手徵求. ";
}
fbDes += sing.author != null ? sing.author.replaceAll("\\<.*?\\>", "").replaceAll("\"", "") + ". " : "";
fbDes += sing.painter != null ? sing.painter.replaceAll("\\<.*?\\>", "").replaceAll("\"", "") + ". " : "";
fbDes += sing.translator != null ? sing.translator.replaceAll("\\<.*?\\>", "").replaceAll("\"", "") + ". " : "";
fbDes += sing.pubNmMain != null ? sing.pubNmMain.replaceAll("\\<.*?\\>", "").replaceAll("\"", "") + ". " : "";
fbDes += sing.isbn != null ? sing.isbn + ". " : "";
fbDes += sing.prodPf != null ? EcPathSettingImp.LimitString(sing.prodPf.replaceAll("\\<.*?\\>", "").replaceAll("\"", ""), 100, "...").replaceAll("(\r\n|\n)", "").replaceAll("\\\\", "") + ". " : "";
//二手書交易資訊頁sitemap相關 20190328新增
String listItemName = "";
if (sing.prodCatId.equals("11")) {
	listItemName = "中文書";
} else if (sing.prodCatId.equals("12")) {
	listItemName = "簡體書";
} else if (sing.prodCatId.equals("13")) {
	listItemName = "原文書";
} else if (sing.prodCatId.equals("14")) {
	listItemName = "中文電子書";
} else if (sing.prodCatId.equals("15")) {
	listItemName = "簡體電子書";
} else if (sing.prodCatId.equals("16")) {
	listItemName = "原文電子書";
} else if (sing.prodCatId.equals("17")) {
	listItemName = "日文電子書";
} else if (sing.prodCatId.equals("21")) {
	listItemName = "中文雜誌";
} else if (sing.prodCatId.equals("22")) {
	listItemName = "韓文雜誌";
} else if (sing.prodCatId.equals("23")) {
	listItemName = "歐美雜誌";
} else if (sing.prodCatId.equals("24")) {
	listItemName = "日文MOOK";
} else if (sing.prodCatId.equals("25")) {
	listItemName = "電子雜誌";
} else if (sing.prodCatId.equals("26")) {
	listItemName = "線上雜誌";
} else if (sing.prodCatId.equals("27")) {
	listItemName = "日文MOOK";
} else if (sing.prodCatId.equals("31")) {
	listItemName = "唱片CD";
} else if (sing.prodCatId.equals("32")) {
	listItemName = "影音(DVD)";
} else if (sing.prodCatId.equals("61")) {
	listItemName = "創意文具";
} else if (sing.prodCatId.equals("62")) {
	listItemName = "生活雜貨";
}
//評論
float rate1 = 0;
rate1 = (float) (Math.random() * 10) / 10 + 4;
DecimalFormat df = new DecimalFormat(".#");
String rate = df.format(rate1);
int review = 0;
review = (int) (Math.random() * 300) + 400;
//加入判斷會員是否18歲20191005
String lock18 = "0";

String showThumbnail = "https://media.taaze.tw/showThumbnail.html?sc="+sing.orgProdId +"&height=400&width=310";

String birthDate = LoginUtil.isLoginCustomer(request) && LoginUtil.getLoginCustomer(request) != null ? LoginUtil.getLoginCustomer(request).getBirthDate() : "";
if (LoginUtil.getLoginCustomer(request) != null && birthDate != null) {
	int birthYear = Integer.parseInt(birthDate.substring(0, 4));
	int birthMonth = Integer.parseInt(birthDate.substring(4, 6));
	int birthDateReal = Integer.parseInt(birthDate.substring(6, 8));
	Calendar cal = Calendar.getInstance();
	cal.setTime(new Date());
	int year = cal.get(Calendar.YEAR);
	int month = cal.get(Calendar.MONTH) + 1;
	int date = cal.get(Calendar.DATE);
	int checkYear = year - birthYear;
	int checkMonth = month - birthMonth;
	int checkDate = date - birthDateReal;
	if (sing.rank != null && sing.rank.equals("D") && !(checkYear > 18 || (checkYear > 17 && ((checkMonth > 0) || (checkMonth > -1 && checkDate > -1))))) {
		String lock = (String) session.getAttribute("lock");
		if (lock == null || !lock.equals("unlocked")) {
			lock18 = "1";
			showThumbnail = "/new_ec/rwd/include/images/B_image/pic_book_1@2x.png";
		}
	}
} else {
	if (sing.rank != null && sing.rank.equals("D")) {
		String lock = (String) session.getAttribute("lock");
		if (lock == null || !lock.equals("unlocked")) {
			lock18 = "1";
			showThumbnail = "/new_ec/rwd/include/images/B_image/pic_book_1@2x.png";
		}
	}
}


Calendar nowCal = Calendar.getInstance();

/* @@sitemap資料 	*/	
JSONArray pathList = new JSONArray(); 

JSONObject path = new JSONObject();
path.put("title","首頁");
path.put("url","/rwd_index.html");
pathList.add(path);

String prodCatIdWord = "";

if(sing.orgFlg.equals("C")){
	switch(Integer.parseInt(sing.prodCatId)){
		case 11: prodCatIdWord = "二手中文書";
		case 12: prodCatIdWord = "二手簡體書";
		case 13: prodCatIdWord = "二手原文書";
		case 14: prodCatIdWord = "中文電子書";
		case 15: prodCatIdWord = "簡體電子書";
		case 16: prodCatIdWord = "原文電子書";
		case 17: prodCatIdWord = "日文電子書";
		case 21: prodCatIdWord = "中文雜誌";
		case 22: prodCatIdWord = "韓文雜誌";
		case 23: prodCatIdWord = "歐美雜誌";
		case 24: prodCatIdWord = "二手日文MOOK";
		case 25: prodCatIdWord = "電子雜誌";
		case 26: prodCatIdWord = "日文電子雜誌";
		case 27: prodCatIdWord = "二手日文MOOK";
		case 31: prodCatIdWord = "CD";
		case 32: prodCatIdWord = "DVD";
		case 61: prodCatIdWord = "創意文具";
		case 62: prodCatIdWord = "生活百貨";
		default : prodCatIdWord = sing.prodCatId;
	}
}else{
	switch(Integer.parseInt(sing.prodCatId)){
		case 11: prodCatIdWord = "中文書";
		case 12: prodCatIdWord = "簡體書";
		case 13: prodCatIdWord = "原文書";
		case 14: prodCatIdWord = "中文電子書";
		case 15: prodCatIdWord = "簡體電子書";
		case 16: prodCatIdWord = "原文電子書";
		case 17: prodCatIdWord = "日文電子書";
		case 21: prodCatIdWord = "中文雜誌";
		case 22: prodCatIdWord = "韓文雜誌";
		case 23: prodCatIdWord = "歐美雜誌";
		case 24: prodCatIdWord = "日文MOOK";
		case 25: prodCatIdWord = "電子雜誌";
		case 26: prodCatIdWord = "日文電子雜誌";
		case 27: prodCatIdWord = "日文MOOK";
		case 31: prodCatIdWord = "CD";
		case 32: prodCatIdWord = "DVD";
		case 61: prodCatIdWord = "創意文具";
		case 62: prodCatIdWord = "生活百貨";
		default : prodCatIdWord = sing.prodCatId;
	}
}

/*
if(sing.orgFlg!=null&&sing.orgFlg.equals("C")){
	path = new JSONObject();
	path.put("title","二手書");
	path.put("url","/container_snd.html?t=11&k=03&d=00");
	pathList.add(path);
}
*/
String siteUrl = "";
if(sing.orgFlg!=null&&sing.orgFlg.equals("C")){
	siteUrl = "t=11&k=03&d="+sing.prodCatId;
}else{
	if( sing.prodCatId.equals("27") ){//20190718 修正27業種，點選館別後到日文MOOK(24)館別頁
		siteUrl = "t=24&k=01&d=00";
	}else{
		siteUrl = "t=" + sing.prodCatId + "&k=01&d=00";
	}
}

if(sing.prodCatId!=null&&sing.prodCatId.length()==2){
	path = new JSONObject();
	path.put("title", prodCatIdWord);
	path.put("url","/rwd_list.html?"+siteUrl);
	pathList.add(path);
}

if(sing.catId!=null&&sing.catId.length()==12){
	if(sing.orgFlg!=null&&sing.orgFlg.equals("C")){
		if(sing.catName1!=null && sing.catName1.length()>0){
			path = new JSONObject();
			path.put("title",sing.catName1);
			
			path.put("url","/rwd_listView.html?t=11&k=03&d="+sing.prodCatId+"&a=00&c=" + sing.catId.substring(0,2)+ "0000000000&l=1");
			
			pathList.add(path);
		}
		if(sing.catName!=null && sing.catName.length()>0){
			path = new JSONObject();
			path.put("title",sing.catName);
			path.put("url","/rwd_listView.html?t=11&k=03&d="+sing.prodCatId+"&a=00&c=" + sing.catId.substring(0,4)+ "00000000&l=2");
			pathList.add(path);
		}
	}else{
		if(sing.catName1!=null && sing.catName1.length()>0){
			path = new JSONObject();
			path.put("title",sing.catName1);
			if(sing.prodCatId.equals("11")||sing.prodCatId.equals("12")){
				path.put("url","/rwd_list.html?t=" + sing.prodCatId + "&k=01&d=00&a=00&c=" + sing.catId.substring(0,2)+ "0000000000&l=1");
			}else{
				path.put("url","/rwd_listView.html?t=" + sing.prodCatId + "&k=01&d=00&a=00&c=" + sing.catId.substring(0,2)+ "0000000000&l=1");
			}
			pathList.add(path);
		}
		if(sing.catName!=null && sing.catName.length()>0){
			path = new JSONObject();
			path.put("title",sing.catName);
			path.put("url","/rwd_listView.html?t=" + sing.prodCatId + "&k=01&d=00&a=00&c=" + sing.catId.substring(0,4)+ "00000000&l=2");
			pathList.add(path);
		}
	}
}
/* @@sitemap資料 	*/	


//圖檔
sing_o.setImgUrl(request);
//評價數(星評數)
int startLevelSize = sing_o.getSizeStartLevelByOrgProdId(sing_o.orgProdId, systemDao);
int startLevel = sing_o.getStartLevelByOrgProdId(sing_o.orgProdId, systemDao);
int myStartLevel = 0;

//無星評數的要生成
int orgProdIdsum = 0;//2
int orgProdIdrating = 0;//4 

char[] ch_orgProdIdsum = sing_o.orgProdId.substring(9).toCharArray();//將字串轉成字元陣列 
orgProdIdrating = Integer.parseInt(sing_o.orgProdId.substring(7));

for(int i=0;i<ch_orgProdIdsum.length;i++){
	int c = ch_orgProdIdsum[i]-'0';
orgProdIdsum += c ;//加總 
} 

float rate2 =0;
rate2 = (float) (orgProdIdrating)/30000+4;
DecimalFormat df1 = new DecimalFormat(".00");
String rate3 = df1.format(rate2);

//System.out.println("星評:"+startLevel);
//System.out.println("第二個加總:"+orgProdIdsum);
//System.out.println("第一個加總:" + rate3);

JSONArray commentList = null;
JSONObject cust_cmt = null;
String comment_pk = "";
String comment_text = "";
String comment_html = "";
String comment_title = "";
String comment_status = "A";
String comment_date = "";
try {
	if(cc!=null) {
		//commentList = sing_o.queryHotCommentMasByOrgProdId(cc.getCustId(), sing_o.orgProdId, systemDao);
		cust_cmt = sing_o.queryCustComment(cc.getCustId(), sing_o.orgProdId, systemDao);
		if(cust_cmt != null) {
			myStartLevel = Integer.valueOf(cust_cmt.getString("stars"));
			comment_pk = cust_cmt.getString("pk_no");
			comment_text = cust_cmt.getString("content");
			comment_html = comment_text.replaceAll("\n", "<br/>");
			comment_title = cust_cmt.getString("title");
			comment_status = cust_cmt.getString("status_flg");
			String[] dates = cust_cmt.getString("crt_time").split("-");
			comment_date = dates[0]+"年"+dates[1]+"月"+dates[2]+"日";
		}
	} 
} catch(Exception e) {
	sing_o.logger.error("query comment occur error : "+e.getMessage());
}

//收藏
int collectArray[];
if(cc!=null) {
	collectArray = sing_o.getCollectionItemSizeByOrgProdIdAndCustId(cc.getCustId(), sing_o.orgProdId, systemDao);
} else {
	collectArray = sing_o.getCollectionItemSize(sing_o.orgProdId, systemDao);
}
if(collectArray==null){
	collectArray = new int[3];
	collectArray[0] = 0;
	collectArray[1] = 0;
	collectArray[2] = 0;
}

//業種 11：繁體書,12：簡體書,13：外文書才能加入二手徵求
//2016-10-05加入24,27
boolean wantedSndFlg = false;
int wantedSndSize = 0;
// boolean IsWanted = false;
if ((sing_o.prodCatId.equals("11") || sing_o.prodCatId.equals("27") || sing_o.prodCatId.equals("24") || sing_o.prodCatId.equals("12") || sing_o.prodCatId.equals("13"))) {
	/** 取得二手徵求量 * */
	wantedSndFlg = true;//業種 11：繁體書,12：簡體書,13：外文書顯示標記
	//CustQingdanService custQingdanService = (CustQingdanService)SpringUtil.getSpringBeanById(this, "CustQingdanService");
	List<Object> paraList = new ArrayList<Object>();
	paraList.add(sing_o.orgProdId);
	String whCond = " where model.orgProdId = ?";
	wantedSndSize = custQingdanService.getCustProdSeeklistSizeByWhcond(whCond, paraList);
	if (cc != null && cc.getCustId().length() > 0) {
		paraList.clear();
		paraList.add(cc.getCustId());
		paraList.add(sing_o.orgProdId);
		int IsWantedCheck = custQingdanService.getCustProdSeeklistSizeByWhcond(" where model.custId=? and model.orgProdId=?", paraList);
		if (IsWantedCheck>0) {
			IsWanted = true;
		}
	}
}
//試讀
String previewCount = sing_o.displayDL(sing_o.orgProdId, systemDao);

//回饋金
SingeBookService singeBookService = (SingeBookService)SpringUtil.getSpringBeanById(this, "SingeBookService");
int bonusPctValue = singeBookService.getBonusPctValue(new BigDecimal(sing_o.salePrice),pid,null,null,sing_o.mcPk);

//回饋金 new 
JSONObject pct_result = sing_o.findMaxBonusPct(sing_o.orgProdId, (int)sing_o.salePrice, sing_o.pubId, sing_o.supId, sing_o.prodCatId, sing_o.catId, sing_o.orgFlg, systemDao);
String bonus_text = "";
boolean showBonusFlag = true;
//Date hideBonusDate = formatter.parse("2017-09-01");
//活動網址
String act_url = "";
if(pct_result.getString("bonus_text")!=null) {
	bonus_text = pct_result.getString("bonus_text");
}
if(pct_result.getString("act_url")!=null) {
	act_url = pct_result.getString("act_url");
}
if("".equals(bonus_text)){
	showBonusFlag= false;
}


//銷售地區與運送方式
JSONObject saleAreaJson = null;
if(sing_o.openFlg != 0) {
	saleAreaJson = sing_o.getSaleAreaAndCdtByJson(sing_o.saleArea,sing_o.soCnCdt);
}

//出版日期距今
//int diffDay = 0;
if(sing_o.publishDate!= null) {
	diffDay = (int)sing_o.getDiffDay(new Date(), formatter.parse(sing_o.getDateFormat(sing_o.publishDate)));
}
//相同版本
//List<SingProdScrollModel> versionList = singeBookService.getSingProdSameVersionList(sing_o.istProdId, sing_o.prodId);
JSONArray versionList = sing_o.getVersionList(sing_o.istProdId, sing_o.prodId);

//其他版本
//int version_size = 0;
if(versionList!=null && versionList.size()>0){
	version_size = versionList.size();
}
if(diffDay > 180 && (sing_o.prodCatId.equals("11") || sing_o.prodCatId.equals("14"))){
	version_size += 1;
}
if(sing_o.orgFlg.equals("A") && sing_o.prodCatId.equals("11") && !sing_o.haseUSed) {
	version_size += 1;
}
if(sing_o.orgFlg.equals("A") && sing_o.prodCatId.equals("27") && !sing_o.haseUSed) {
	version_size += 1;
}



String bindingType = "A"; 

//take look resort
String[] imageTakeLook = null;
String[] imageTakeLookTitle = null;
String[] imageTakeLookDesc = null;
String[] imageDesc = null;
if(sing_o.prodImages!=null && sing_o.prodImages.length>0 && !Arrays.toString(sing_o.prodImages).equals("[]")){ //多個書封圖時顯示 ,重新排序及過濾Image Index大於1000
	//重新排序
	String[] imageMap;
	String[] imagePkNo = new String[sing_o.prodImages.length];
	String[] imageInnerTitle = new String[sing_o.prodImages.length];
	String[] imageInnerDes = new String[sing_o.prodImages.length];
	int[] imageIndex =  new int[sing_o.prodImages.length];

	for(int i=1; i<(sing_o.prodImages.length+1); i++){
		imageMap = sing_o.prodImages[(i-1)].split("_");
		imageIndex[i-1] = Integer.parseInt(imageMap[0]);
		imagePkNo[i-1] = imageMap[1];
		if(imageMap[2]!=null) {
			imageInnerTitle[i-1] = imageMap[2];
		} else {
			imageInnerTitle[i-1] = "";	
		}
		if(imageMap[3]!=null) {
			imageInnerDes[i-1] = imageMap[3];
		} else {
			imageInnerDes[i-1] = "";	
		}
	}
	//泡沫排序法
	for (int i=0;i<imageIndex.length-1;i++)  //從a[0]比到a[8]，比較a[9]沒有意義
	{
		for (int j=0;j<imageIndex.length-i-1;j++)
		{
			if (imageIndex[j+1]<imageIndex[j])
			{
				int temp = imageIndex[j+1];  //交換陣列元素
				imageIndex[j+1]=imageIndex[j];
				imageIndex[j]= temp;
				String temp2 = imagePkNo[j+1];  //交換陣列元素
				String temp3 = imageInnerTitle[j+1];  //交換陣列元素
				String temp4 = imageInnerDes[j+1];  //交換陣列元素
				
				imagePkNo[j+1]=imagePkNo[j];
				imageInnerTitle[j+1]=imageInnerTitle[j];
				imageInnerDes[j+1]=imageInnerDes[j];
				
				imagePkNo[j]= temp2;
				imageInnerTitle[j]= temp3;
				imageInnerDes[j]= temp4;
			}
		}
	}
	List<String> tempTakeLook = new ArrayList<String>();
	List<String> tempImageDesc = new ArrayList<String>();
	List<String> tempImageInnerTitle = new ArrayList<String>();
	List<String> tempImageInnerDesc = new ArrayList<String>();

	for (int i=0;i<imagePkNo.length;i++){
		if(imageIndex[i]>1000){
			tempImageDesc.add(imagePkNo[i]);
		}else{
			tempTakeLook.add(imagePkNo[i]);
			tempImageInnerTitle.add(imageInnerTitle[i]);
			tempImageInnerDesc.add(imageInnerDes[i]);
		}
	}
	if(tempImageDesc.size()>0){
		imageDesc = new String[tempImageDesc.size()];
		for (int i=0;i<tempImageDesc.size();i++){
			imageDesc[i] = tempImageDesc.get(i);
		}
	}
	if(tempTakeLook.size()>0){
		//log.info(tempTakeLook.size());
		imageTakeLook = new String[tempTakeLook.size()];
		imageTakeLookTitle = new String[tempImageInnerTitle.size()];
		imageTakeLookDesc = new String[tempImageInnerDesc.size()];
		
		for (int i=0;i<tempTakeLook.size();i++){
			imageTakeLook[i] = tempTakeLook.get(i);
			imageTakeLookTitle[i] = tempImageInnerTitle.get(i);
			imageTakeLookDesc[i] = tempImageInnerDesc.get(i);
		}
		//log.info(imageTakeLook.length);
	}
}


//video check
//二手書資訊, 二手影片
SprodModel sprodAskModel = null;
List<CustSprodSchoolinfo> custSprodSchoolinfo = null;
List<CustSprodSchoolinfo> custSprodSchoolinfoByDiscipline = null;
List<CustSprodSchoolinfo> queryCustSprodSchoolinfo = null;
if(sing_o.orgFlg.equals("C")){
	sprodAskModel = sing_o.querySprodAskDetailByProdId(sing_o.prodId, systemDao);
	if(sprodAskModel == null) {
		response.sendRedirect(sing_o.getWebUrl(request));
		return;
	}
	custSprodSchoolinfo = sing_o.SchoolBookBySchool();
	custSprodSchoolinfoByDiscipline = sing_o.SchoolBookByDiscipline();
	queryCustSprodSchoolinfo = sing_o.textbookInfoBySaler(sprodAskModel.getCustId());
}
boolean video_exists = false;
int video_count = 0;
if(sing_o.orgFlg.equals("A") && sing_o.vdoShtFlg!=null && sing_o.vdoShtFlg.equals("Y")) {
	video_exists = true;
	video_count = 1;
}
if(sing_o.orgFlg.equals("C") && sprodAskModel.getUsedStatus()!=null && sprodAskModel.getVideoId()!=null) {
	if(sprodAskModel.getUsedStatus().equals("Y") || sprodAskModel.getUsedStatus().equals("R")) {
		video_exists = true;
		video_count = 1;
	}
}


//優惠組合
JSONObject buy_together = sing_o.getBougthTogethe(sing_o.prodId);

//也買了
JSONObject also_buy = sing_o.getAlsoBuy(sing_o.prodId,sing_o.orgProdId,sing_o.catId);


String prodPublishText = "出版社";
String prodPublishDateText = "出版日期";
String prodContentText = "內容簡介";
String fbDes2 = "";
String fbArthor = sing_o.author!=null?sing_o.author:"";

//唱片
String singer_main = "";
String singer_next = "";
String author_text = "";
String producers = "";
String musical_instruments = "";
String prodFormatAndSpec = "";
String eancode = "";
JSONArray musicList = null;
JSONArray videoList = null;

if(sing_o.prodCatId.equals("61") || sing_o.prodCatId.equals("62")){
	prodAuthorText = "作者／設計師";
	prodPublishText = "出版／製造／代理商";
	prodPublishDateText = "上架日期";
	//廠牌
	sing_o.setBrandData(sing_o.brandId, systemDao);
}else if(sing_o.prodCatId.equals("31") || sing_o.prodCatId.equals("32")){
	prodPublishDateText = "上架日期";
}

//CD、DVD
JSONObject avInfo = null;
if(sing_o.orgFlg.equals("A") && ( sing_o.prodCatId.equals("31") || sing_o.prodCatId.equals("32")) ){
	if(sing_o.brandId!=null) {
		sing_o.setBrandData(sing_o.brandId, systemDao);
	}
	JSONObject o = null;
	try {
		o = sing_o.queryProdInfoAv(sing_o.orgProdId, sing_o.prodCatId, systemDao);
	} catch(Exception e) {
		sing_o.logger.error("get "+sing_o.prodId+" vod info error: "+e);
	}
	if(o!=null && o.getString("error_code").equals("100")) {
		avInfo = o;
		singer_main = o.getString("author_main");
		singer_next = o.getString("author_next");
		producers = o.getString("producers")!=null? o.getString("producers"):"";
		eancode = o.getString("eancode")!=null? o.getString("eancode"):"";
		musical_instruments = o.getString("musical_instruments")!=null? o.getString("musical_instruments"):"";
		if(singer_main!=null && singer_main.length() > 0) {
			author_text += "<a href='"+ searchProdAuthorUrlPattern + URLEncoder.encode(singer_main,"utf8")+"'>"+ singer_main+"</a>";
		}
		if(singer_next!=null && singer_next.length() > 0) {
			if(author_text.length() > 0) {
				author_text += ", ";
			}
			author_text += "<a href='" +searchProdAuthorUrlPattern + URLEncoder.encode(singer_next,"utf8") +"'>"+ singer_next+"</a>";
		}
		if(sing_o.prodCatId.equals("31")) {
			musicList = (JSONArray)o.get("music_list");
		}
	}
	//log.info(o.toString());
	if(o.get("video_list") != null) {
		videoList = (JSONArray)o.get("video_list");
	}
	if(author_text.length() == 0 && sing_o.author!=null && sing_o.author.length() > 0) {
		author_text += "<a href='" + searchProdAuthorUrlPattern + URLEncoder.encode(sing_o.author,"utf8") +"'>"+ sing_o.author+"</a>";
	}
	prodPublishDateText = "上架日期";
	prodAuthorText = "演出者";
	prodPublishText = "廠牌";
	if(sing_o.prodCatId.equals("31")) {
		prodContentText = "專輯簡介";
	}
	if(sing_o.prodFormat!=null) {
		if(sing_o.prodFormat.equals("A")) {
			prodFormatAndSpec += "台壓專輯";
		} else if(sing_o.prodFormat.equals("B")) {
			prodFormatAndSpec += "進口專輯";
		} else {
			prodFormatAndSpec += "數位音樂";
		}
		if(sing_o.prodSpec!=null) {
			if(prodFormatAndSpec.length() > 0) {
				prodFormatAndSpec += " "+sing_o.prodSpec;
			} else {
				prodFormatAndSpec += sing_o.prodSpec;
			}
		}
	}
}

String searchProdTagUrlPattern = "/rwd_searchResult.html?keyType%5B%5D=4&keyword%5B%5D=";

//訂購日期
String orderDate = null;

//標籤雲,我的分類建議
List<ProdKwModel> keyList = sing_o.queryProdKwAmountGroupByOrgProdId(sing_o.orgProdId, 30, systemDao);
List<ProdKwModel> myKeyList = null;//我的標籤
List<Cat4xsxModel> listCat4xsx = null;//我的分類建議
List<String> listNCat4xsx = null; //延伸類別
listNCat4xsx = sing_o.getNCat4xsx(sing_o.orgProdId, systemDao);
if(cc!=null && cc.getCustId().length()>0){
	myKeyList = sing_o.queryProdKwAmountGroupByOrgProdIdAndCustId(sing_o.orgProdId,  cc.getCustId(), systemDao);
	listCat4xsx = sing_o.productService.queryCustCat4xsx(sing_o.orgProdId, cc.getCustId());
	orderDate = sing_o.getOrderDate(cc.getCustId(), sing_o.orgProdId, systemDao);
}
StringBuffer tagSb = new StringBuffer();
tagSb.append("<div style='margin:2px 0;'>");
tagSb.append("<div style='display:block'>");
tagSb.append("<div class='prodInfo_boldSpan' style='float:left;padding:0;'>標籤：</div>");
tagSb.append("<div style='float:left; font-weight: normal; font-size: 10pt; max-width:280px; color: #666666;'>");
tagSb.append("<div class='prodTag'>");
if (keyList!=null && keyList.size()>0) {
	if(keyList.size() > 10) {
		tagSb.append("<div class='all_tag' style='display:none;'>");
		for(int i = 0; i < keyList.size(); i++){
			String href= searchProdTagUrlPattern + (keyList.get(i)!=null?URLEncoder.encode(keyList.get(i).getKwId(),"utf8"):"null");
			tagSb.append("<a class='tag' href='");
			tagSb.append(href+"' >");
			tagSb.append(keyList.get(i)!=null?keyList.get(i).getKwId():"null");
			tagSb.append("</a>");
	 	}
		tagSb.append("<span class='closeTag single_tags' style='margin-left:10px;width: 70px; padding: 0px 0px; font-size: 10pt; cursor: pointer; text-decoration: underline; padding-left:16px;'>收合</span>");
		tagSb.append("</div>");
		tagSb.append("<div class='part_tag'>");
		for(int i = 0; i < 10; i++){
			String href= searchProdTagUrlPattern + (keyList.get(i)!=null?URLEncoder.encode(keyList.get(i).getKwId(),"utf8"):"null");
			tagSb.append("<a class='tag' href='");
			tagSb.append(href+"' >");
			tagSb.append(keyList.get(i)!=null?keyList.get(i).getKwId():"null");
			tagSb.append("</a>");
		}
		tagSb.append("<span class='moreTag single_tags' style='margin-left:10px;width: 70px; padding: 0px 0px; font-size: 10pt; cursor: pointer; text-decoration: underline; padding-left:16px;'>看更多</span>");
		tagSb.append("</div>");
	} else {
		tagSb.append("<div class='all_tag'>");
		for(int i = 0; i < keyList.size(); i++){
			String href= searchProdTagUrlPattern + (keyList.get(i)!=null?URLEncoder.encode(keyList.get(i).getKwId(),"utf8"):"null");
			tagSb.append("<a class='tag' href='");
			tagSb.append(href+"' >");
			tagSb.append(keyList.get(i)!=null?keyList.get(i).getKwId():"null");
			tagSb.append("</a>");
		}
		tagSb.append("</div>"); 
	}
} else {
	tagSb.append("<span style='font-size: 10pt; color: #666666;word-break: break-all;'>目前無標籤</span>");
}
tagSb.append("</div>");
tagSb.append("</div>");	
tagSb.append("<div style='clear:both'></div>");
tagSb.append("</div>");
tagSb.append("</div>");
tagSb.append("<div class='myTagFrame' style='line-height: 19pt;'>");
tagSb.append("<span>");
tagSb.append("<div class='prodInfo_boldSpan' style='float:left;padding:0;'>您的標籤：</div>");
tagSb.append("<div style='float:left;font-weight: normal; font-size: 10pt; max-width:340px; color: #666666; word-break: break-all;' id='myProdTags'>");
tagSb.append("<div class='my_all_tag'>");
if(myKeyList!=null && myKeyList.size()>0){
	for(int i = 0; i < myKeyList.size(); i++){
		tagSb.append("<a class='tag tip03' href='javascript:return false;' onClick=\"prodKwDelete('");
		tagSb.append(myKeyList.get(i)!=null?myKeyList.get(i).getKwId():"null"); 
		tagSb.append("','"+sing_o.orgProdId+"',this)\" title='點擊刪除'>");
		tagSb.append(myKeyList.get(i)!=null?myKeyList.get(i).getKwId():"null");
		tagSb.append("</a>");
	}
}
tagSb.append("</div>");
if(cc!=null && cc.getCuid().toString().length()>0){
	tagSb.append("<div class='tagAdd' style='cursor:pointer;font-weight:normal;'>");
	tagSb.append("<img class='single_tags' />");
	tagSb.append("<a class='tagAdd' href='javascript:void(0)'>新增您自己的標籤</a>");
	tagSb.append("</div>");
} else {
	tagSb.append("<div style='font-weight:normal;'>");
	tagSb.append("<img class='single_tags' />");
	tagSb.append("<a onClick='loginFirst()' href='javascript:void(0)'>新增您自己的標籤</a>");
	tagSb.append("</div>");
}
tagSb.append("</div>");
tagSb.append("<br style='clear:both' />");
tagSb.append("</span>");
tagSb.append("</div>");


//將video與takelook組合再一起
JSONArray takelookList = new JSONArray();
JSONObject takelookItem = null;
JSONObject cover = new JSONObject();
cover.put("src", "cover");
cover.put("pkNo", sing_o.orgProdId);
takelookList.add(cover);
if(video_exists){
	takelookItem = new JSONObject();
	takelookItem.put("src", "video");
	takelookItem.put("pkNo", (sing_o.orgFlg.equals("C")?"snd":"new"));
	takelookList.add(takelookItem);
}else{
	if(sing_o.orgFlg.equals("C")&&sprodAskModel.getProdRank()!=null){
		if(sprodAskModel.getProdRank().equals("A") || sprodAskModel.getProdRank().equals("B")){
			//全新 近全新無影片時，以圖片表示
			takelookItem = new JSONObject();
			takelookItem.put("src", "sndPic");
			String prodRankImg = sprodAskModel.getProdRank().equals("A")?"/new_ec/rwd/include/images/C_image/pic/pic_1@3x.png":"/new_ec/rwd/include/images/C_image/pic/pic_2@3x.png";
			takelookItem.put("pkNo", prodRankImg);
			takelookList.add(takelookItem);
		}
	}
}
if(imageTakeLook!=null&&imageTakeLook.length>0){
	for(int i=0; i<imageTakeLook.length; i++){
		takelookItem = new JSONObject();
		takelookItem.put("src", "image");
		takelookItem.put("pkNo", imageTakeLook[i]);
		takelookList.add(takelookItem);
	}
}

// begin of 內容簡介 -->
//內容簡介.....
JSONArray menuItems = new JSONArray();
//手機顯示以下內容簡介
String spam[] = {"prodPf","mediaRm","personGuide","howBuy","catalogue","viewData","prodSpec","authorPf","preface","brand"};
List<String> menuItemsForM = Arrays.asList(spam);
int showItem=0;
if(sing_o.prodPf!=null || imageDesc!=null || sing_o.authorPf!=null || sing_o.translatorPf!=null){
	menuItems.add(sing_o.setMenuItem("prodPf",prodContentText));
	
	fbDes2 = sing_o.prodPf!=null?sing_o.prodPf.replaceAll("<[^>]+>", "").replaceAll("\r\n","").replaceAll("\n","").trim():"";
	if(fbDes.length()>40){
		fbDes = fbDes.substring(0,40) + "...";
	}
	if(fbDes2.length()>150){
		fbDes2 = fbDes2.substring(0,150) + "...";
		fbDes2 = fbDes2.replaceAll("\"","\'");
	}
}
if(sing_o.prodCatId.equals("61") || sing_o.prodCatId.equals("62")) {
	if(sing_o.prodSpec!=null && sing_o.prodSpec.length() > 0) {
		menuItems.add(sing_o.setMenuItem("prodSpec","產品規格"));
	}
	if(sing_o.authorPf!=null && sing_o.authorPf.length() > 0) {
		menuItems.add(sing_o.setMenuItem("authorPf","設計師簡介"));
	}
}
if(sing_o.prodCatId.equals("31") || sing_o.prodCatId.equals("32")) {
	if(sing_o.awardRec!=null && sing_o.awardRec.length() > 0) {
		menuItems.add(sing_o.setMenuItem("mediaRm","得獎紀錄"));
	}
} else {
	if(sing_o.mediaRcm!=null || sing_o.awardRec!=null || sing_o.personRcm!=null || sing_o.spRec!=null){
		menuItems.add(sing_o.setMenuItem("mediaRm","各界推薦"));
	}
}
if(sing_o.viewData != null && sing_o.viewData.length() > 0){
	menuItems.add(sing_o.setMenuItem("viewData","章節試閱"));
}
if(sing_o.personGuide != null && sing_o.personGuide.length() > 0){
	menuItems.add(sing_o.setMenuItem("personGuide","推薦序"));
}
if(sing_o.preface != null && sing_o.preface.length() > 0){
	menuItems.add(sing_o.setMenuItem("preface","作者序"));
}
if(sing_o.catalogue != null && sing_o.catalogue.length() > 0){
	menuItems.add(sing_o.setMenuItem("catalogue","目錄"));
}
if(sing_o.brandNm != null || sing_o.brandPf != null){
	if(!sing_o.prodCatId.equals("32")){
		menuItems.add(sing_o.setMenuItem("brand","品牌簡介"));
	}
	
}
//品牌簡介新增排除業種32
menuItems.add(sing_o.setMenuItem("howBuy","購物須知"));


String htmlBuild1 = "";
int indexFlag = 0;
String appendStr = "";
String tempStr = "";
String topBtn = "";
//String topBtn = "<div><div class='topBtn'>TOP</div><br style='clear: right;' /></div>";
String moreBtn = "<div class='moreBtn' style='margin-top: 10px;'><div viewall='0' style='width: 88px; padding: 2px 0;font-weight:bold; font-size: 10pt; text-align: center; cursor: pointer;'>顯示全部內容</div></div>";
htmlBuild1 = "<div style='height:25px; border-bottom:solid 1px #cccccc; margin:0 auto;'></div>";
htmlBuild1 += "<div style='height:1px; border-bottom:dotted 1px #cccccc; margin:0 auto;'></div>";
htmlBuild1 += "<div style='padding:25px 0 10px 0; font-size:12pt; font-weight:bold; color:#333333;'>%s</div>";
JSONArray textAreaDOM = new JSONArray();
StringBuilder sb2 = new StringBuilder();
//商品簡介
if(imageDesc!=null || sing_o.prodPf != null || sing_o.authorPf!=null || sing_o.translatorPf!=null){
	sb2 = new StringBuilder();
	//影音商品嵌入影片
	if(sing_o.prodCatId.equals("31") || sing_o.prodCatId.equals("32")) { 
		if(videoList!=null) {
			for(int i = 0; i < videoList.size(); i++) {
				JSONObject obj = (JSONObject)videoList.get(i);
				sb2.append(obj.getString("video")!=""?"<center>"+obj.getString("video")+"</center><br/>":"");
			}
		}
	}
	//商品說明
	sb2.append(sing_o.prodPf != null ? "<p>" + sing_o.prodPf.replaceAll("(\r\n|\n|\r)", "<br />") + "</p>":"");
	//作者、譯者簡介
	if(!sing_o.prodCatId.equals("61") && !sing_o.prodCatId.equals("62")){
		sb2.append(sing_o.authorPf != null ? "<p style='margin:0; padding:0px; font-weight:bold;'>"+prodAuthorText+"簡介：</p><p>" + sing_o.authorPf.replaceAll("\r\n\r\n", "\r\n").replaceAll("\n\n", "\r\n").replaceAll("(\r\n|\n)", "<br /><br />") + "</p>" : "");
		sb2.append(sing_o.translatorPf != null ? "<p style='margin:0; padding:0px; font-weight:bold;'>譯者簡介：</p><p>" + sing_o.translatorPf.replaceAll("\r\n\r\n", "\r\n").replaceAll("\n\n", "\r\n").replaceAll("(\r\n|\n)", "<br /><br />") + "</p>" : "");
	}
	//導演 / 演出者簡介
	if(sing_o.prodCatId.equals("32")){
		sb2.append(sing_o.authorPf != null ? "<p style='margin:0; padding:0px; font-weight:bold;'>導演 / 演出者簡介：</p><p>" + sing_o.authorPf.replaceAll("\r\n\r\n", "\r\n").replaceAll("\n\n", "\r\n").replaceAll("(\r\n|\n)", "<br /><br />") + "</p>" : "");
	}
	//創意生活圖檔簡介
	if(imageDesc!=null && imageDesc.length>0){
		for(int i=0; i<imageDesc.length; i++){
			sb2.append("<p style='text-align:center;'><img style='max-width:700px' src='" + sing_o.getImgUrl() + "/showProdImageByPK/" + imageDesc[i] + "/800/1280/img.jpg' alt='' /></p>");
		}
	}
	sb2.append(topBtn);
	textAreaDOM.add(sing_o.setMenuItemContent("prodPf", prodContentText, sb2.toString()));
}
if(sing_o.prodCatId.equals("61") || sing_o.prodCatId.equals("62")) {
	//產品規格
	if(sing_o.prodSpec!=null && sing_o.prodSpec.length() > 0) { 
		sb2 = new StringBuilder();
		tempStr = sing_o.prodSpec.replaceAll("\n\n", "\r\n");
		//sb2.append("<div class='contentFull'>"+sing_o.setPordContentDOM(sing_o.prodSpec)+"</div>");
		sb2.append("<div class='contentFull'>"+tempStr.replaceAll("(\r\n|\n|\r)", "<br />")+"</div>");
		sb2.append(topBtn);
		textAreaDOM.add(sing_o.setMenuItemContent("prodSpec", "產品規格", sb2.toString()));
	}
	//設計師簡介
	if(sing_o.authorPf!=null && sing_o.authorPf.length() > 0) { 
		sb2 = new StringBuilder();
		//tempStr = sing_o.authorPf.replaceAll("\n\n", "\r\n");
		tempStr = sing_o.authorPf;
		//sb2.append("<div class='contentFull'>"+sing_o.setPordContentDOM(sing_o.authorPf) +"</div>");
		sb2.append("<div class='contentFull'>"+tempStr.replaceAll("(\r\n|\n|\r)", "<br />") +"</div>");
		sb2.append(topBtn);
		textAreaDOM.add(sing_o.setMenuItemContent("authorPf", "設計師簡介", sb2.toString()));
	}
}
//得獎紀錄
if(sing_o.prodCatId.equals("31") || sing_o.prodCatId.equals("32")) { 
	if(sing_o.awardRec!=null && sing_o.awardRec.length() > 0) {
		sb2 = new StringBuilder();
		sb2.append("<div class='content'>"+"<p>" + sing_o.setPordContentDOM(sing_o.awardRec) + "</p>"+"</div>");
		sb2.append(topBtn);
		textAreaDOM.add(sing_o.setMenuItemContent("mediaRm", "得獎紀錄", sb2.toString()));
	}
} else {
	if(sing_o.mediaRcm!=null || sing_o.awardRec!=null || sing_o.personRcm!=null || sing_o.spRec!=null){ 
		sb2 = new StringBuilder();
		tempStr = "";
		tempStr += sing_o.awardRec != null ? "<p style='margin:0; padding:0px; font-weight:bold;'>得獎紀錄：</p><p>" + sing_o.awardRec.replaceAll("\r\n\r\n", "\r\n").replaceAll("\n\n", "\r\n") + "</p>" : "";
		tempStr += sing_o.personRcm != null ? "<p style='margin:0; padding:0px; font-weight:bold;'>名人推薦：</p><p>" + sing_o.personRcm.replaceAll("\r\n\r\n", "\r\n").replaceAll("\n\n", "\r\n") + "</p>" : "";
		tempStr += sing_o.mediaRcm != null ? "<p style='margin:0; padding:0px; font-weight:bold;'>媒體推薦：</p><p>" + sing_o.mediaRcm.replaceAll("\r\n\r\n", "\r\n").replaceAll("\n\n", "\r\n") + "</p>" : "";
		tempStr += sing_o.spRec != null ? "<p style='margin:0; padding:0px; font-weight:bold;'>特別收錄 / 編輯的話：</p><p>" + sing_o.spRec.replaceAll("\r\n\r\n", "\r\n").replaceAll("\n\n", "\r\n") + "</p>" : "";
		sb2.append("<div class='content' style='display: none;'>"+tempStr.replaceAll("(\r\n|\n)", "<br /><br />")+"</div>");
		sb2.append("<div class='content'>"+EcPathSettingImp.LimitString(tempStr.replaceAll("\\<.*?\\>", ""),500,"...").replaceAll("(\r\n|\n)", "<br /><br />")+"</div>");
		if(tempStr.length()> 250){
			sb2.append(moreBtn);
		}
		sb2.append(topBtn);
		textAreaDOM.add(sing_o.setMenuItemContent("mediaRm", "各界推薦", sb2.toString()));
	}
}
//章節試閱
if(sing_o.viewData != null && sing_o.viewData.length() > 0){ 
	sb2 = new StringBuilder();
	if(sing_o.orgProdId.equals("11100763903")) {
		tempStr = sing_o.viewData;
		sb2.append("<div class='content' style='display: none;'>"+tempStr.replaceAll("\\<.*?\\>", "").replaceAll("(\r\n|\n)", "<br />")+"</div>");
		sb2.append("<div class='content'>"+EcPathSettingImp.LimitString(tempStr.replaceAll("\\<.*?\\>", ""),500,"...").replaceAll("(\r\n|\n)", "<br />")+"</div>");
		if(tempStr.length()> 250){
			sb2.append(moreBtn);
		}
		sb2.append(topBtn);
	}
	if(!sing_o.orgProdId.equals("11100763903")) {
		tempStr = sing_o.viewData.replaceAll("\r\n\r\n", "\r\n").replaceAll("\n\n", "\r\n");
		sb2.append("<div class='content' style='display: none;'>"+tempStr.replaceAll("(\r\n|\n)", "<br /><br />")+"</div>");
		sb2.append("<div class='content'>"+EcPathSettingImp.LimitString(tempStr.replaceAll("\\<.*?\\>", ""),500,"...").replaceAll("(\r\n|\n)", "<br /><br />")+"</div>");
		if(tempStr.length()> 250){
			sb2.append(moreBtn);
		}
		sb2.append(topBtn);
	}
	
	textAreaDOM.add(sing_o.setMenuItemContent("viewData", "章節試閱", sb2.toString()));
}
//推薦序
if(sing_o.personGuide != null && sing_o.personGuide.length() > 0){
	sb2 = new StringBuilder();
	tempStr = sing_o.personGuide.replaceAll("\r\n\r\n", "\r\n").replaceAll("\n\n", "\r\n");
	sb2.append("<div class='content' style='display: none;'>"+tempStr.replaceAll("(\r\n|\n)", "<br /><br />")+"</div>");
	sb2.append("<div class='content'>"+EcPathSettingImp.LimitString(tempStr.replaceAll("\\<.*?\\>", ""),500,"...").replaceAll("(\r\n|\n)", "<br /><br />")+"</div>");
	if(tempStr.length()> 250){
		sb2.append(moreBtn);
	}
	sb2.append(topBtn);
	textAreaDOM.add(sing_o.setMenuItemContent("personGuide", "推薦序", sb2.toString()));
}
//作者序
if(sing_o.preface != null && sing_o.preface.length() > 0){
	sb2 = new StringBuilder();
	tempStr = sing_o.preface.replaceAll("\r\n\r\n", "\r\n").replaceAll("\n\n", "\r\n");
	sb2.append("<div class='content' style='display: none;'>"+tempStr.replaceAll("(\r\n|\n)", "<br /><br />")+"</div>");
	sb2.append("<div class='content'>"+EcPathSettingImp.LimitString(tempStr.replaceAll("\\<.*?\\>", ""),500,"...").replaceAll("(\r\n|\n)", "<br /><br />")+"</div>");
	if(tempStr.length()> 250){
		sb2.append(moreBtn);
	}
	sb2.append(topBtn);
	textAreaDOM.add(sing_o.setMenuItemContent("preface", "作者序", sb2.toString()));
}
//目錄
if(sing_o.catalogue != null && sing_o.catalogue.length() > 0){
	sb2 = new StringBuilder();
	tempStr = sing_o.catalogue.replaceAll("\n\n", "\r\n");
	sb2.append("<div class='content' style='display: none;'>"+tempStr.replaceAll("(\r\n|\n|\r)", "<br />")+"</div>");
	sb2.append("<div class='content'>"+EcPathSettingImp.LimitString(tempStr.replaceAll("\\<.*?\\>",""),500,"...").replaceAll("(\r\n|\n|\r)", "<br />")+"</div>");
	if(tempStr.length()> 250){
		sb2.append(moreBtn);
	}
	sb2.append(topBtn);
	textAreaDOM.add(sing_o.setMenuItemContent("catalogue", "目錄", sb2.toString()));
}
//品牌簡介
if(sing_o.brandNm != null || sing_o.brandPf != null){
	sb2 = new StringBuilder();
	tempStr = "";
	tempStr += "<div><img style='max-height:230px' src='" + sing_o.getImgUrl() + "/showBrandImage.html?pk=" + sing_o.brandId + "&width=600' alt='' /></div>";
	tempStr += sing_o.brandNm != null ? "<p style='font-size:12pt; font-weight:bold;'>" + sing_o.setPordContentDOM(sing_o.brandNm) + "</p>" : "";
	tempStr += sing_o.brandPf != null ? "<p>" + sing_o.brandPf.replaceAll("\n\n", "\r\n").replaceAll("(\r\n|\n|\r)", "<br />") + "</p>" : "";
	sb2.append("<div>"+tempStr+"</div>");
	sb2.append(topBtn);
	textAreaDOM.add(sing_o.setMenuItemContent("brand", "品牌簡介", sb2.toString()));
}
//購物須知
sb2 = new StringBuilder();


if(sing_o.orgFlg.equals("C")){ //二手書
	sb2.append("<p style='font-weight: bold;'>關於二手書說明：</p>");
	sb2.append("<p>購買二手書時，請檢視商品書況、備註說明或書況影片。</p>");
	sb2.append("<p style='font-weight: bold;'>商品版權法律說明：</p>");
	sb2.append("<p>TAAZE 單純<strong>提供網路二手書託售平台予消費者</strong>，並不涉入書本作者與原出版商間之任何糾紛；敬請各界鑒察。</p>");
	sb2.append("<p style='font-weight: bold;'>退換貨說明：</p>");
	sb2.append("<p>二手書籍商品享有10天的商品猶豫期（含例假日）。若您欲辦理退貨，請於取得該商品10日內寄回。</p>");
	sb2.append("<p>二手影音商品（例如CD、DVD等），恕不提供10天猶豫期退貨。</p>");
	sb2.append("<p>二手商品無法提供換貨服務，僅能辦理退貨。如須退貨，請保持該商品及其附件的完整性(包含書籍封底之TAAZE物流條碼)。<strong>若退回商品無法回復原狀者</strong>，可能影響退換貨權利之行使或須負擔部分費用。</p>");
	sb2.append("訂購本商品前請務必詳閱<a class='linkStyleTextArea' href='https://taaze.tw/member_serviceCenter.html?qa_type=g#a1' target='_blank'>退換貨原則</a>、<a class='linkStyleTextArea' href='https://www.taaze.tw/member_serviceCenter.html?qa_type=m#a3' target='_blank'>二手CD、DVD退換貨說明</a>。");
	//免責聲明文字
	if(sing_o.crtSource!=null&&sing_o.crtSource.equals("B")){
		sb2.append("<p>本商品資料由TAAZE會員提供，TAAZE並已依據現貨及一般人之認知對其進行審核；TAAZE對其正確性不負連帶責任。若對商品資料有疑義請聯絡TAAZE客服。</p>");
	}
}else if(sing_o.prodCatId.equals("21") || sing_o.prodCatId.equals("23") || sing_o.prodCatId.equals("24") || sing_o.prodCatId.equals("27") || sing_o.prodCatId.equals("22")){
// 	雜誌/中文雜誌/業種別代碼21
// 	雜誌/日文MOOK/業種別代碼24
// 	雜誌/日文雜誌/業種別代碼27
// 	雜誌/歐美雜誌/業種別代碼23
// 	雜誌/韓文雜誌/業種別代碼22
	
	sb2.append("<p style='font-weight: bold;'>退換貨說明：</p>");
	sb2.append("<p>雜誌商品，恕不提供10天猶豫期退貨。</p>");
	sb2.append("<strong>訂購本商品前請務必詳閱</strong><a class='linkStyleTextArea' href='https://www.taaze.tw/member_serviceCenter.html?qa_type=g#a1' target='_blank'>退換貨原則</a>。");
}else if(sing_o.prodCatId.equals("14") || sing_o.prodCatId.equals("25") || sing_o.prodCatId.equals("17") || sing_o.prodCatId.equals("26")){  //電子書
// 	電子書/中文電子書/業種別代碼14
// 	電子書/中文電子雜誌/業種別代碼25
	
	sb2.append("<p style='font-weight: bold;'>電子書閱讀方式</p>");
	sb2.append("<p>您所購買的電子書，系統將自動儲存於您的雲端書櫃，您可透過PC（Windows / Mac）、行動裝置（手機、平板），輕鬆閱讀。</p>");
	sb2.append("<ul>");
	sb2.append("<li style='text-decoration:underline;'>");
	sb2.append("Ｗindows / Ｍac 電腦");
	sb2.append("</li>");
	sb2.append("<li style='list-style: none;'>");
	sb2.append("請先安裝<img src='/new_ec/rwd/include/images/C_image/pic/chrome.png'/>瀏覽器，並以Chrome開啟雲端書櫃後，點選『線上閱讀』，即可閱讀您已購買的電子書。");
	sb2.append("</li>");
	sb2.append("<li style='text-decoration:underline;'>");
	sb2.append("手機／平板");
	sb2.append("</li>");
	sb2.append("<li style='list-style: none;'>");
	sb2.append("請先安裝TAAZE eBook App<a target='_blank' href='https://itunes.apple.com/tw/app/taaze/id661669580?mt=8'><img src='/new_include/images/ebook-iosDownload.png' width='60' height='18' border='0' alt='' style='vertical-align:middle;'></a><a target='_blank' href='https://play.google.com/store/apps/details?id=tw.taaze.yaimmreader'><img src='/new_include/images/ebook-googlePlay.png' width='60' height='18' border='0' alt='' style='vertical-align:middle;'></a>後，依照提示登入您的TAAZE會員帳號，並下載您所購買的電子書。完成下載後，點選任一書籍即可開始離線閱讀。");
	sb2.append("</li>");
	sb2.append("</ul>");
	sb2.append("<p style='line-height:30px;'><strong>注意事項：</strong><br />");
	sb2.append("使用讀冊生活電子書服務即為同意<a target='_blank' style='color:blue;' href='/static_act/ebookpolicy/index.htm'>讀冊生活電子書服務條款</a>。<br />");
	sb2.append("下單後電子書可開啟閱讀的時間請參考：<a target='_blank' style='color:blue;' href='/member_serviceCenter.html?qa_type=h#c2'>不同的付款方式，何時可開啟及閱讀電子書?</a><br/>因版權保護，您在TAAZE所購買的電子書/雜誌僅能以TAAZE專屬的閱讀軟體開啟閱讀，無法以其他閱讀器或直接下載檔案。");
	sb2.append("<br />");
	sb2.append("<strong>退換貨說明：</strong>電子書、電子雜誌商品，恕不提供10天猶豫期退貨，若您對電子書閱讀有疑慮，建議您可於購買前先行試讀。並於訂購本商品前請務必詳閱<a target='_blank' style='color:blue;' href='/member_serviceCenter.html?qa_type=h#c9'>電子書商品退換貨原則</a>。");
	sb2.append("</p>");

}else if(sing_o.prodCatId.equals("61") || sing_o.prodCatId.equals("62") ){  
// 	創意生活/生活雜貨/業種別代碼62 創意生活/創意文具/業種別代碼61
	sb2.append("請留意以下狀況，若未符合標準，恕無法退換貨：");
	sb2.append("<br>");
	sb2.append("1.猶豫期非試用期，若您收到商品有任何不合意之處，請勿拆開使用。");
	sb2.append("<br>");
	sb2.append("2.辦理退換貨時，請保持商品原來狀態與完整包裝（包含商品本身、附件、內外包裝、附件文件、保證書、贈品等）一併寄回。若退回商品無法回復原狀者，可能影響退換貨權利之行使或須負擔部分費用。");
	sb2.append("<br>");
	sb2.append("3.3C電子商品若因本身有故障瑕疵，須退回已拆封商品時，外包裝不得有刮傷、破損、碰壞、受潮等狀況，並連同完整包裝(商品、附件、原廠外盒、保護袋、配件收納紙箱、 隨貨文件、贈品等)一併退回。");
	sb2.append("<br>");
	sb2.append("4.個人或消耗性商品請勿拆封試用（服飾、襪子、貼身衣物、個人衛生用品、寢具用品、清潔用具、食品…等），試用後將無法受理退貨。");
	sb2.append("<br>");
	sb2.append("5.活動票券類商品，恕不提供10天猶豫期退貨。");
	sb2.append("</p>");
	sb2.append("<p>注意1：拆封係指除了運送過程中所必須包裝(如紙箱、破壞袋、氣泡袋…等)之外的其他包裝。</p>");
	sb2.append("<p>注意2：讀冊提供10天商品猶豫期（含例假日），若要辦理退換貨，請保持商品原來狀態及完整包裝，於收到商品10天內寄回。</p>");
	sb2.append("<strong>訂購本商品前請務必詳閱</strong><a class='linkStyleTextArea' href='https://www.taaze.tw/member_serviceCenter.html?qa_type=g#b1' target='_blank'>創意生活館退換貨原則</a>。");
}else if(sing_o.prodCatId.equals("31") || sing_o.prodCatId.equals("32")){  
// 	創意生活/唱片CD/業種別代碼31
	
	sb2.append("<p style='font-weight: bold;'>退換貨說明：</p>");
	sb2.append("<p>商品若遭拆封或已非全新狀態(外觀有刮傷、破損、受潮…等情形)或包裝不完整(含商品、外盒、封膜及封膜上之貼紙、側標、贈品等損毀或遺失)，恕無法接受退貨退款。</p>");
	sb2.append("<p>注意：拆封係指除了運送過程中所必需包裝(如紙箱、破壞袋、氣泡袋…等)之外的其他包裝。</p>");
	sb2.append("<p>若有無法順利讀取的狀況時，請先改用其他播放器試播看看，如確認是商品本身之瑕疵( EX：光碟有刮痕、光碟盒破損、專輯說明掉頁…等 )，請洽詢<a class='linkStyleTextArea' href='https://www.taaze.tw/member_serviceCenter.html?act=mail' target='_blank'>客服信箱</a>協助您辦理換貨。</p>");
	sb2.append("<strong>訂購本商品前請務必詳閱</strong><a class='linkStyleTextArea' href='https://www.taaze.tw/member_serviceCenter.html?qa_type=m#a1' target='_blank'>影音商品退換貨原則</a>。");
}else{
// 	書籍/中文書/業種別代碼11
// 	書籍/簡體書/業種別代碼12
// 	書籍/原文書/業種別代碼13
	
	sb2.append("<p style='font-weight: bold;'>退換貨說明：</p>");
	sb2.append("<p>會員均享有10天的商品猶豫期（含例假日）。若您欲辦理退換貨，請於取得該商品10日內寄回。</p>");
	sb2.append("<p>辦理退換貨時，請保持商品全新狀態與完整包裝（商品本身、贈品、贈票、附件、內外包裝、保證書、隨貨文件等）一併寄回。若退回商品無法回復原狀者，可能影響退換貨權利之行使或須負擔部分費用。</p>");
	sb2.append("<strong>訂購本商品前請務必詳閱</strong><a class='linkStyleTextArea' href='https://www.taaze.tw/member_serviceCenter.html?qa_type=g#a1' target='_blank'>退換貨原則</a>。");
}
textAreaDOM.add(sing_o.setMenuItemContent("howBuy", "購物須知", sb2.toString()));

// end of 內容簡介 -->


String schoolBookUrlPattern = "/container_snd_actview.html?t=11&k=03&d=00&a=08#";
String schoolBookUrlParameter = "AA1,2,30,2,%s,%s,%s,%s,%s";

//二手書訊息
StringBuffer sndInfo =  new StringBuffer();
if(sing_o.orgFlg.equals("C")){
	sndInfo.append("<div class='sndInfo'>");
	if(custSprodSchoolinfo!=null && custSprodSchoolinfo.size()>0){//校系
		sndInfo.append("<div>");
		sndInfo.append("<span style=''>教科書校系檢索：</span><span style='font-weight: normal;'><a href='" +sing_o.schoolBookUrlPattern + URLEncoder.encode(String.format(sing_o.schoolBookUrlParameter,custSprodSchoolinfo.get(0).getCityId(), "", "", "", ""),"utf8") + "'>"+custSprodSchoolinfo.get(0).getCityNm() +"</a></span>"); 
		sndInfo.append("<span style='font-weight: normal;'>&gt;</span>");
		sndInfo.append("<span style='font-weight: normal;'><a href='"+sing_o.schoolBookUrlPattern + URLEncoder.encode(String.format(sing_o.schoolBookUrlParameter,custSprodSchoolinfo.get(0).getCityId(), custSprodSchoolinfo.get(0).getSchoolNo(),"", "", ""),"utf8") +"'>"+custSprodSchoolinfo.get(0).getSchoolName() +"</a></span>"); 
		if(custSprodSchoolinfo.get(0).getDepartmentNo()!=null && !custSprodSchoolinfo.get(0).getDepartmentNo().equals("0")) { 
			sndInfo.append("<span class='span01' style='font-weight: normal;'>&gt;</span>"); 
			sndInfo.append("<span style='font-weight: normal;'><a href='" + sing_o.schoolBookUrlPattern + URLEncoder.encode(String.format(sing_o.schoolBookUrlParameter,custSprodSchoolinfo.get(0).getCityId(), custSprodSchoolinfo.get(0).getSchoolNo(), custSprodSchoolinfo.get(0).getDepartmentNo(), "", ""),"utf8") +"'>"+custSprodSchoolinfo.get(0).getDepartmentName() +"</a></span>"); 
		}
		sndInfo.append("<span style='font-weight: normal; margin-left: 10px;'><a href='javascript:void(0);' id='showSprodSchool'>&nabla;</a> </span>"); 
		sndInfo.append("</div>");
		sndInfo.append("<li style='display: none;' id='spordSchool'>");
		for(int i=0; i<custSprodSchoolinfo.size(); i++){ 
		sndInfo.append("<div>");
		sndInfo.append("<span style='color: #666666; font-weight: normal;'><a class='linkStyle02' href='"+ schoolBookUrlPattern + URLEncoder.encode(String.format(schoolBookUrlParameter,custSprodSchoolinfo.get(i).getCityId(), "", "", "", ""),"utf8") +"'>"+ custSprodSchoolinfo.get(i).getCityNm()+"</a></span>");
		sndInfo.append("<span class='span01' style='font-weight: normal;'>&gt;</span>");
		sndInfo.append("<span style='color: #666666; font-weight: normal;'><a class='linkStyle02' href='"+ schoolBookUrlPattern + URLEncoder.encode(String.format(schoolBookUrlParameter,custSprodSchoolinfo.get(i).getCityId(), custSprodSchoolinfo.get(i).getSchoolNo(), "", "", ""),"utf8") +"'>"+custSprodSchoolinfo.get(i).getSchoolName() +"</a></span>");
		if(custSprodSchoolinfo.get(i).getDepartmentNo()!=null && !custSprodSchoolinfo.get(i).getDepartmentNo().equals("0")) { 
			sndInfo.append("<span class='span01' style='font-weight: normal;'>&gt;</span>");
			sndInfo.append("<span style='color: #666666; font-weight: normal;'><a class='linkStyle02' href='"+schoolBookUrlPattern + URLEncoder.encode(String.format(schoolBookUrlParameter,custSprodSchoolinfo.get(i).getCityId(), custSprodSchoolinfo.get(i).getSchoolNo(), custSprodSchoolinfo.get(i).getDepartmentNo(), "", ""),"utf8")+"'>"+custSprodSchoolinfo.get(i).getDepartmentName()+"</a></span>");
			}
		sndInfo.append("</div>");
			} 
		sndInfo.append("</li>");
	}
	if(custSprodSchoolinfoByDiscipline!=null && custSprodSchoolinfoByDiscipline.size()>0){ //學門學類
		sndInfo.append("<div>");
		sndInfo.append("<span style=''>教科書學科檢索：</span><span style='font-weight: normal;''><a href='" + sing_o.schoolBookUrlPattern + URLEncoder.encode(String.format(sing_o.schoolBookUrlParameter, "", "", "", custSprodSchoolinfoByDiscipline.get(0).getDisciplineNo(), ""),"utf8") +"'>" + custSprodSchoolinfoByDiscipline.get(0).getDisciplineName() +"</a></span>"); 
		sndInfo.append("<span style='font-weight: normal;'>&gt;</span>");
		sndInfo.append("<span style='font-weight: normal;'><a href='"+ sing_o.schoolBookUrlPattern + URLEncoder.encode(String.format(sing_o.schoolBookUrlParameter, "", "", "", custSprodSchoolinfoByDiscipline.get(0).getDisciplineNo(), custSprodSchoolinfoByDiscipline.get(0).getClassNo()),"utf8") +"'>"+custSprodSchoolinfoByDiscipline.get(0).getClassName() +"</a></span>"); 
		sndInfo.append("<span style='font-weight: normal; margin-left: 10px;'><a href='javascript:void(0);'id='showSprodDiscipline' class='linkStyle02' >&nabla;</a></span>");
		sndInfo.append("</div>");
		sndInfo.append("<li style='display: none;' id='spordDiscipline' class='linkStyle02'>");
		for(int i=0; i<custSprodSchoolinfoByDiscipline.size(); i++){ 
		sndInfo.append("<div>");
		sndInfo.append("<span style='color: #666666; font-weight: normal;'><a class='linkStyle02' href='"+ schoolBookUrlPattern + URLEncoder.encode(String.format(schoolBookUrlParameter, "", "", "", custSprodSchoolinfoByDiscipline.get(i).getDisciplineNo(), ""),"utf8") +"'>"+ custSprodSchoolinfoByDiscipline.get(i).getDisciplineName()+"</a></span> ");
		sndInfo.append("<span class='span01' style='font-weight: normal;'>&gt;</span>");
		sndInfo.append("<span style='color: #666666; font-weight: normal;'><a class='linkStyle02' href='"+ schoolBookUrlPattern + URLEncoder.encode(String.format(schoolBookUrlParameter, "", "", "", custSprodSchoolinfoByDiscipline.get(i).getDisciplineNo(), custSprodSchoolinfoByDiscipline.get(i).getClassNo()),"utf8") +"'>"+ custSprodSchoolinfoByDiscipline.get(i).getClassName() +"</a></span>");
		sndInfo.append("</div>");
			} 
		sndInfo.append("</li>");  		 
	}
	if(queryCustSprodSchoolinfo!=null && queryCustSprodSchoolinfo.size()>0){
		if(queryCustSprodSchoolinfo.get(0).getEdition()!=null){//賣家註記教科書版本
			sndInfo.append("<div>");
			sndInfo.append("<span>賣家註記教科書版本：</span><span style='font-weight: normal;'>第" + queryCustSprodSchoolinfo.get(0).getEdition() +"版</span>"); 
			sndInfo.append("</div>");
		}
		if(queryCustSprodSchoolinfo.get(0).getPubYear()!=null){//賣家註記教科書出版年
			sndInfo.append("<div>");
			sndInfo.append("<span>賣家註記教科書出版年：</span><span style='font-weight: normal;'>第" + queryCustSprodSchoolinfo.get(0).getPubYear() +"版</span>"); 
			sndInfo.append("</div>");
		}
	}
	//賣家
	sndInfo.append("<div>");
	sndInfo.append("<span>賣家：</span><span style='font-weight: normal;'><a href='/container_seller_view.html?t=11&k=03&d=00&ci="+sprodAskModel.getCuid() +"'>"+sprodAskModel.getNikeName() +"</a></span>");				
	sndInfo.append("</div>");
				
	//書況
	sndInfo.append("<div>");
	sndInfo.append("<span>書況(讀冊判定)：</span><span rel='"+sprodAskModel.getProdRank() +"' class='sndProdRank'>"+sing_o.getProdRankText(sprodAskModel.getProdRank())+"</span>");
	sndInfo.append("<div id='sndProdRank_info' style='display:none;'>");
	sndInfo.append("<ul style='list-style:none;padding:0'>");
	sndInfo.append("<li style='font-weight:bold; padding-bottom:3px;'>書況說明：</li>");
	sndInfo.append("<li style='font-weight:normal;padding-bottom:6px;'><span class='rank_A'>A. 全新：膠膜未拆，無瑕疵。</span></li>");
	sndInfo.append("<li style='font-weight:normal;padding-bottom:6px;'><span class='rank_B'>B. 近全新：未包膜，翻閱痕跡不明顯，如實體賣場陳列販售之書籍。</span></li>");
	sndInfo.append("<li style='font-weight:normal;padding-bottom:6px;'><span class='rank_C'>C. 良好：有使用痕跡，不如新書潔白、小範圍瑕疵，如摺角、碰撞、汙點或泛黃等。</span></li>");
	sndInfo.append("<li style='font-weight:normal;padding-bottom:6px;'><span class='rank_D'>D. 普通：有使用痕跡，並因時間因素，有大範圍黃、黑斑及瑕疵。</span></li>");
	sndInfo.append("<li style='font-weight:normal;padding-bottom:6px;'><span class='rank_E'>E. 差強人意：差強人意：印刷褪色、模糊或其它更糟之書況。</span></li>");
	sndInfo.append("</ul>");
	sndInfo.append("</div>");
	sndInfo.append("</div>");
				
	//備註
	sndInfo.append("<div>");
	sndInfo.append("<span>備註(賣家自填)：<span style='font-weight: normal;'>" +sing_o.getAddMarkText(sprodAskModel.getAddMarkFlg(), sprodAskModel.getNote()) +"</span></span>");
	sndInfo.append("</div>");
	sndInfo.append("<div>");
	sndInfo.append("<span class='whatAddMarkText'>");
	sndInfo.append("商品備註與退貨說明");
	sndInfo.append("<img style='width:15px;height:15px;vertical-align: text-top;' src='/new_ec/rwd/include/images/C_image/ic/ic_14@2x.png'/>");
	sndInfo.append("</span>");
	sndInfo.append("<div id='whatAddMarkText_info' style='display:none;'>");
	sndInfo.append("<ul style='margin:0; padding:0; list-style:none; text-align: left;line-height: 15px;'>");
	sndInfo.append("<li style='font-weight:bold; padding-bottom:3px;'>備註說明：</li>");
	sndInfo.append("<li style='font-weight:normal;padding-bottom:6px;'>備註內容與書況影片有出入時，以書況影片為準。商品之附件或贈品，亦以書況影片為準。</li>");
	sndInfo.append("<li style='font-weight:bold; padding-bottom:3px;'>商品退貨說明：</li>");
	sndInfo.append("<li style='font-weight:normal;'>會員購買二手商品皆擁有10天的鑑賞期。若收到的商品狀況與網站描述不符合時，在鑑賞期內，皆可退貨。退貨辦法請詳見，<a target='_blank' href='http://www.taaze.tw/member_serviceCenter.html?qa_type=g' style='color:#e3007f;text-decoration:underline;'>客服退換貨說明</a></li>");
	sndInfo.append("</ul>");
	sndInfo.append("</div>");
	sndInfo.append("</div>");
				
	sndInfo.append("</div>");

}


//app下載
String app_download = sing_o.getAvailableApp(sing_o.pubId);


//@購物車/暫存清單BUTTON 當「商品源別」為回頭書（B）或二手書（C）時，而且庫存為0（即無庫存關車）時隱藏
boolean orgAndQtyFlg = true;
if(sing_o.orgFlg.equals("B") || sing_o.orgFlg.equals("C")){
	if(sing_o.qty <= 0){
		orgAndQtyFlg = false;
	}
}

//直接購買顯示html字串
String buyNowHtml = "";


//電子雜誌訂閱
JSONObject mag_scribe = null;
JSONArray mag_scribe_list = new JSONArray();
boolean subscribe = false;
String mag_full_name = "";
String mag_pub = "";
String mag_new_issue = "";
String mag_publish_date = "";
String mag_timing = "";
String mag_print_type = "";
String mag_src = "";
String mag_sList_btn = "";
try {
	if(sing_o.prodCatId.equals("25")) {
		if(cc!= null) {
			mag_scribe = sing_o.queryProdMagzneInfo(sing_o.orgProdId,String.valueOf(cc.getCuid()),systemDao);
		} else {
			mag_scribe = sing_o.queryProdMagzneInfo(sing_o.orgProdId,null,systemDao);
		}
	}
	if(mag_scribe!= null) {
		if(mag_scribe.getInt("error_code") == 100) {
			mag_scribe_list = (JSONArray)mag_scribe.get("items");
			if(mag_scribe.getString("scribe_count").equals("1")) {
				subscribe = true;
			}
			if(mag_scribe.containsKey("mag_publisher")) {
				mag_pub = mag_scribe.getString("mag_publisher");
			}
			if(mag_scribe.containsKey("full_name")) {
				mag_full_name = mag_scribe.getString("full_name");
			}
			if(mag_scribe.containsKey("mag_new_issue")) {
				mag_new_issue = mag_scribe.getString("mag_new_issue");
			}
			if(mag_scribe.containsKey("mag_publish_date")) {
				mag_publish_date = mag_scribe.getString("mag_publish_date");
			}
			if(mag_scribe.containsKey("mag_timing")) {
				mag_timing = mag_scribe.getString("mag_timing");
			}
			if(mag_scribe.containsKey("mag_print_type")) {
				mag_print_type = mag_scribe.getString("mag_print_type");
			}
			if(mag_scribe.containsKey("img_src")) {
				mag_src = mag_scribe.getString("img_src");
			}
			
			if( mag_scribe_list!=null) { 
				StringBuilder sb_mag = new StringBuilder();
				for(int i =0 ; i < mag_scribe_list.size(); i++) {
					JSONObject item = (JSONObject)mag_scribe_list.get(i);
					String mag_id = "";
					String name = "";
					String disc = "";
					String price = "";
					
					if(item.containsKey("org_prod_id")) {
						mag_id = item.getString("org_prod_id");
					}
					if(item.containsKey("name")) {
						name = item.getString("name");
					}
					if(item.containsKey("sale_disc")) {
						disc = item.getString("sale_disc");
					}
					if(item.containsKey("sale_price")) {
						price = item.getString("sale_price");
					}
					
					if(Integer.parseInt(price) == 0) {
						sb_mag.append("<div style='float:left;cursor: pointer;margin-right:5px;' class='highlight' rel='"+ mag_id +"' onclick=\"scribeFreeMagazine('"+pid+"','"+mag_id+"')\" >");
					} else {
						sb_mag.append("<div style='float:left;cursor: pointer;margin-right:5px;' class='highlight' rel='"+ mag_id +"' onclick=\"add2ShoppingCart('"+mag_id+"','"+mag_id+"')\" >");
					}
					
					sb_mag.append("<div style='padding:0px;text-align: center;'>"+ name +"</div>");
					if(disc.length() > 0) {
						sb_mag.append("<div class='discPrice' style='padding:0px;margin:0;text-align: center;'><span>"+ disc +"</span>折<span>"+ price +"</span>元</div>");
					} else {
						sb_mag.append("<div class='discPrice' style='padding:0px;margin:0;text-align: center;'><span>"+ price +"</span>元</div>");
					}
					
					sb_mag.append("<div style='clear:both'></div>");
					sb_mag.append("</div>");
				}
				sb_mag.append("<div style='clear:both'></div>");
				mag_sList_btn = sb_mag.toString();
			}
		}
	}
} catch(Exception e) {
	sing_o.logger.error("mag subscribe:"+e.getMessage());
}


//贈品
//List<SingleGiftSettingModel> giftList = sing_o.querySingleGiftSettingByProdId(sing_o.prodId, sing_o.prodCatId, sing_o.pubId, sing_o.supId, systemDao);
//List<SingleGiftSettingModel> giftList = null;
//隨書贈品
JSONObject gift_add_info = sing_o.queryProdGiftAdd(sing_o.prodId, systemDao);
JSONArray gifts_add = null;
if(gift_add_info != null) {
	//log.info("error_code:"+gift_info.getInt("error_code"));
	if(gift_add_info.getInt("error_code") == 100) {
		gifts_add = JSONArray.fromObject(gift_add_info.get("data"));
		if(gifts_add != null) {
			//log.info("gift add size:"+gifts_add.size());
		}
	}
}
//贈品
JSONObject gift_info = sing_o.queryProdGift(sing_o.orgProdId,sing_o.prodId, sing_o.prodCatId, sing_o.pubId, sing_o.supId, sing_o.catId, systemDao);
//JSONObject gift_info = null;
JSONArray gifts = null;
//JSONArray gift_item = new JSONArray();
if(gift_info != null) {
	//log.info("error_code:"+gift_info.getInt("error_code"));
	if(gift_info.getInt("error_code") == 100) {
		gifts = JSONArray.fromObject(gift_info.get("data"));
	}
}

//new 格主推薦
JSONObject recommendZekea = null;
recommendZekea = sing_o.getRecommend(sing_o.orgProdId, systemDao);

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
<link rel="stylesheet" type="text/css" href="/new_ec/rwd/include/css/goods.css?v=201908061" />
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
<!-- js include  -->
<script type="text/javascript" src="/new_ec/single/include/js/modernizr.js"></script>
<script type="text/javascript" src="<%=EcPathSetting.WEB_JS_PATH%>/jquery.tipsy.js"></script>
<script type="text/javascript" src="/new_ec/single/include/js/Chart.min.js"></script>
<script src="/new_ec/single/include/js/jquery.rateit.min.js"></script>
<script type="text/javascript" src="/include2/js/alertify.js"></script>
<script type="text/javascript" src="/include2/js/jquery.jgrowl.min.js"></script>
<script type="text/javascript" src="/include2/tooltipster/js/tooltipster.bundle.min.js"></script>
<script type="text/javascript" src="/include2/js/swiper.min.js"></script>
<script type="text/javascript" src="/include2/colorbox/jquery.colorbox-min.js"></script>
<script>
if (!Modernizr.canvas) {
	var c = confirm("您的瀏覽器不支援此功能，請將IE瀏覽器更新至最新版本或使用Google Chrome瀏覽器。");
	if (c == true) {
		window.open('http://windows.microsoft.com/zh-tw/internet-explorer/download-ie', '_blank');
	} else {
		location.href = "https://www.taaze.tw";
	}
}
function loadHash(hash) {
	location.hash = "#" + encodeURIComponent(hash);
	$(window).hashchange();
}
jQuery.browser = {};
(function () {
	jQuery.browser.msie = false;
	jQuery.browser.version = 0;
	if (navigator.userAgent.match(/MSIE ([0-9]+)\./)) {
		jQuery.browser.msie = true;
		jQuery.browser.version = RegExp.$1;
	}
})();
</script>
<jsp:include page="/new_ec/rwd/include/marketingScript.jsp" flush="true"/>
<script type="application/ld+json">
{
	"@context": "https://schema.org/",
	"@type": "Book",
	"name": "sing.titleMain ",
	"image": [
	"https://media.taaze.tw/showThumbnail.html?sc=sing.orgProdId&height=400&width=310"
	],
	"description": "fbDes",
	"isbn": "sing.isbn",
	"publisher": {
		"@type": "Book",
		"name": "sing.pubNmMain"
	},
	"brand": {
		"@type": "Brand",
		"name": "sing.pubNmMain"
	},
	"review": {
		"@type": "Review",
		"reviewRating": {
			"@type": "Rating",
			"ratingValue": "5",
			"bestRating": "5"
		},
		"author": {
			"@type": "Person",
			"name": "((sing.author!=null && sing.author.trim().length()>0)?(sing.author.length()>30?sing.author.substring(0,30):sing.author):無)"
		}
	},
	"aggregateRating": {
		"@type": "AggregateRating",
		"ratingValue": "rate",
		"ratingCount": "review"
	},
	"offers": {
		"@type": "AggregateOffer",
		"lowPrice": "String.valueOf(sing.lowest_price)",
		"highPrice": "sing.listPrice",
		"priceCurrency": "TWD",
		"offerCount": "if(sing.total_saler<=0){out.print("1");}else{out.print(sing.total_saler);}"
	}
}
</script>
<script type="application/ld+json">
{
	"@context": "https://schema.org/",
	"@type": "Product",
	"name": "sing.titleMain ",
	"image": [
	"https://media.taaze.tw/showThumbnail.html?sc=sing.orgProdId&height=400&width=310"
	],
	"description": "fbDes",
	"sku": "sing.orgProdId",
	"mpn": "((sing.isbn==null || sing.isbn.trim().length()<=0)?sing.orgProdId:sing.isbn)",
	"publisher": {
		"@type": "Book",
		"name": "sing.pubNmMain"
	},
	"brand": {
		"@type": "Brand",
		"name": "sing.pubNmMain"
	},
	"review": {
		"@type": "Review",
		"reviewRating": {
			"@type": "Rating",
			"ratingValue": "5",
			"bestRating": "5"
		},
		"author": {
			"@type": "Person",
			"name": "((sing.author!=null && sing.author.trim().length()>0)?(sing.author.length()>30?sing.author.substring(0,30):sing.author):無)"
		}
	},
	"aggregateRating": {
		"@type": "AggregateRating",
		"ratingValue": "rate",
		"ratingCount": "review"
	},
	"offers": {
		"@type": "AggregateOffer",
		"lowPrice": "String.valueOf(sing.lowest_price)",
		"highPrice": "sing.listPrice",
		"priceCurrency": "TWD",
		"offerCount": "if(sing.total_saler<=0){out.print("1");}else{out.print(sing.total_saler);}"
	}
}
</script>
<%if (1==1) {%>
	<script type="application/ld+json">
	{
		"@context": "https://schema.org",
		"@type": "BreadcrumbList",
		"itemListElement": [
		{
			"@type": "ListItem",
			"position": 1,
			"name": "二手書",
			"item": "https://www.taaze.tw/container_snd.html?t=11&k=03&d=00"
		},
		{
			"@type": "ListItem",
			"position": 2,
			"name": "listItemName",
			"item": "https://www.taaze.tw/container_snd.html?t=11&k=03&d=sing.prodCatId"
		},
		{
			"@type": "ListItem",
			"position": 3,
			"name": "sing.catName1 ",
			"item": "https://www.taaze.tw/container_snd_view.html?t=11&k=03&d=sing.prodCatId&a=00&c=sing.catId.substring(0,2)0000000000&l=1"
		},
		{
			"@type": "ListItem",
			"position": 4,
			"name": "sing.catName ",
			"item": "https://www.taaze.tw/container_snd_view.html?t=11&k=03&d=sing.prodCatId&a=00&c=sing.catId.substring(0,4)00000000&l=2"
		},
		{
			"@type": "ListItem",
			"position": 5,
			"name": "sing.titleMain ",
			"item": "https://www.taaze.tw/usedList.html?oid=sing.orgProdId"
		}
		]
	}
	</script>
	<%} else {%>
		<script type="application/ld+json">
		{
			"@context": "https://schema.org",
			"@type": "BreadcrumbList",
			"itemListElement": [
			{
				"@type": "ListItem",
				"position": 1,
				"name": "二手書",
				"item": "https://www.taaze.tw/container_snd.html?t=11&k=03&d=00"
			},
			{
				"@type": "ListItem",
				"position": 2,
				"name": "listItemName",
				"item": "https://www.taaze.tw/container_snd.html?t=11&k=03&d=sing.prodCatId"
			},
			{
				"@type": "ListItem",
				"position": 3,
				"name": "sing.titleMain ",
				"item": "https://www.taaze.tw/usedList.html?oid=sing.orgProdId"
			}
			]
		}
		</script>
		<%}%>
		</head>
		
		<body>
		<div id="body-div" class="plexi"></div>
		<input id="USED_SIZE" type="hidden" value="0"/>
		<input id="MAX_SHOW_SIZE" type="hidden" value="5"/>
		<input id="USEDLIST_RANK" type="hidden" value="2"/>
		<jsp:include page="/new_ec/rwd/include/jsp/include_header.jsp" flush="true"/>
		<div style="position:absolute;left:-999999px">
			<ul>
				<li><h1><%=title %> (二手書交易資訊)</h1></li>
				<li><h2>最多人成交</h2></li>
				<% if (feature_sale.length() > 0) { %>
					<li><h2><%=feature_sale %>
					</h2></li>
				<% } %>
				<% if (feature_want.length() > 0) { %>
					<li><h2><%=feature_want %>
					</h2></li>
				<% } %>
				<li><h2>最近成交價(折扣)</h2></li>
				<li><h2>銷售中的二手書</h2></li>
			</ul>
		</div>
		<c:choose>
			<c:when test="${cookie['mobile'].value eq 'on'}">
				<div class="container container_PC_new wrap">
			</c:when>
			<c:otherwise>
				<div class="container wrap">
			</c:otherwise>
		</c:choose>
		<!-- sitemap -->
		<div class="row" style="margin-top:10px; padding:0 3px;">
			<div class="col-sm-12 col-xs-12 site_map" style="margin-bottom: 15px;">
				<span>
					<a class="linkStyle01" href="<%=sing.getWebUrl(request) %>">首頁</a>
				</span>
				<%=sing.getHyperLineBySnd() %>
				<%=(sing.prodCatId != null && sing.prodCatId.length() == 2) ? sing.getHyperLineByProdCatId() : "" %>
				<%=(sing.catId != null && sing.catId.length() == 12) ? sing.getHyperLineByCatId() : "" %>
				<span class='span01'>&gt;</span> <li class="active" style="color:#e3007f;display:inline-block"><%=title %></li>
			
			</div>
		</div>
		
		<c:choose>
			<c:when test="${cookie['mobile'].value eq 'on'}">
		<div class="row hidden-xs hidden-sm hidden-md hidden-lg">
			</c:when>
			<c:otherwise>
		<div class="row visible-xs-block">
			</c:otherwise>
		</c:choose>
			<div class="col-sm-10 col-xs-12">
				<h4 style="font-weight:bold; margin-top:0px;line-height:30px;">
					<div>讀冊【二手徵求好處多】|<%=sing.titleMain %><span style="color:#755e5f; font-weight: normal;font-size:20px;">（二手書交易資訊）</span></div>
					<%if (sing.titleNext != null && sing.titleNext.length() > 0) {%>
					<div class="title-next"><%=sing.titleNext %></div>
					<%}%>
				</h4>
			</div>

			<div class="col-sm-2 col-xs-12">
				<div class="market-status">
					<ul style="padding:0px;margin:0px;list-style:none;">
						<% if (saleStatus.equals("C")) { %>
						<li style="float:left;height:25px;"><span class="span03">書市熱度</span></li>
						<li style="float:left;height:25px;"><img class='status_text' src="new_ec/single/include/images/status_c.png"/></li>
						<% } %>
						<% if (saleStatus.equals("B")) { %>
						<li style="float:left;height:25px;"><span class="span03">書市熱度</span></li>
						<li style="float:left;height:25px;"><img class='status_text' src="new_ec/single/include/images/status_b.png"/></li>
						<% } %>
						<% if (saleStatus.equals("A")) { %>
						<li style="float:left;height:25px;padding-top:5px;"><span class="span03">書市熱度</span></li>
						<li style="float:left;height:25px;"><img class='status_text' src="new_ec/single/include/images/status_a.png"/></li>
						<% } %>
						<li style="clear:both"></li>
					</ul>
				</div>
			</div>
		</div>

		<div class="row visible-xs-block" style="border-bottom: 1px dotted #C2C2C2;height:15px;margin-bottom: 10px;"></div>
		<div class="row visible-xs-block">
			<div class="col-sm-12 col-xs-12">
			<%if (!sing.starLevel.equals("0")) { %>
				<div style='float:left; padding: 2px 5px 0px 0px;' class="rateit" data-rateit-value="<%=sing.starLevel %>" data-rateit-ispreset="true" data-rateit-readonly="true"></div>
			<%} %>

				<div class="commentLink" style='float:left' onClick="gotoComment('<%=sing.orgProdId%>')">
					<span class='commentCount'><%=startLevelSize > 0 ? startLevelSize : "" %></span>評價
				</div>

			<% if (collectSize > 0) { %>
				<div id="collectLink" class="collectLink" style='float:left;display:none' onClick="addToCollection('<%=sing.orgProdId%>')"><span class='collectNum'><%=sing.collect_count > 0 ? sing.collect_count : "" %></span>收藏</div>
				<div id="collectLink2" class="collectLink2" style='float:left;' onClick="cancelCollection('<%=sing.orgProdId%>')"><span class='collectNum'><%=sing.collect_count > 0 ? sing.collect_count : "" %></span>收藏</div>
			<% } else { %>
				<div id="collectLink" class="collectLink" style='float:left;' onClick="addToCollection('<%=sing.orgProdId%>')"><span class='collectNum'><%=sing.collect_count > 0 ? sing.collect_count : "" %></span>收藏</div>
				<div id="collectLink2" class="collectLink2" style='float:left;display:none'	onClick="cancelCollection('<%=sing.orgProdId%>')"><span	class='collectNum'><%=sing.collect_count > 0 ? sing.collect_count : "" %></span>收藏</div>
			<% } %>

			<% if (IsWanted) { %>
				<div id="wantSndLink" opid="<%=sing.orgProdId %>" onclick="wantBook()" class="wantSndLink" style='float:left;display:none;'><span class='wantNum'></span>二手徵求</div>
				<div id="wantSndLink2" class="wantSndLink2"	onclick="cancelWantedSize2('<%=sing.orgProdId%>')" style='float:left;'><span class='wantNum'></span>二手徵求</div>
			<% } else { %>
				<div id="wantSndLink" opid="<%=sing.orgProdId %>" onclick="wantBook()" class="wantSndLink" style='float:left;'><span class='wantNum'></span>二手徵求</div>
				<div id="wantSndLink2" class="wantSndLink2"	onclick="cancelWantedSize2('<%=sing.orgProdId%>')" style='float:left;display:none;'><span class='wantNum'></span>二手徵求</div>
			<% } %>

			<% if (previewCount != null && previewCount.length() > 0) {//線上試讀  %>
				<%if (sing.prodCatId.equals("14") || sing.prodCatId.equals("25") || sing.prodCatId.equals("17")) { %>
					<%if (cc != null && cc.getCuid().toString().length() > 0) { %>
				<div class="previewLink" style='float:left' rel="Y"	onclick="location.href='http://ebook.taaze.tw/do/mobile/ebook_preview.ashx?oid=<%=sing.orgProdId %>&cuid=<%=cc.getCuid() %>'"
					title='<div style="text-align:left; font-size:10pt;">你可以點進去，試讀電子書內容。</div><div style="text-align:left; margin-top:3px;"><a href="javascript:return false;" onClick="IKnow()" class="tool012">好，我知道了。</a></div>'>
					<span><%=previewCount %></span>人次試讀
				</div>
					<%} else { %>
				<div class="previewLink" rel="Y" style='float:left'
					onclick="location.href='http://ebook.taaze.tw/do/mobile/ebook_preview.ashx?oid=<%=sing.orgProdId %>'"
					title='<div style="text-align:left; font-size:10pt;">你可以點進去，試讀電子書內容。</div><div style="text-align:left; margin-top:3px;"><a href="javascript:return false;" onClick="IKnow()" class="tool012">好，我知道了。</a></div>'>
					<span><%=previewCount %></span>人次試讀
				</div>
					<%} %>
				<%} else { %>
					<div class="previewLink" rel="N" style='float:left'
					onclick="location.href='http://ebook.taaze.tw/do/preview/viewer2.aspx?oid=<%=sing.orgProdId %>'">
					<span><%=previewCount %></span>人次試讀
					</div>
				<%} %>
			<%} %>
				<div class="shareLink" style="float:left">分享</div>
			<div style="clear:both"></div>
		</div>
	</div>

	<%-- 商品頁內容 --%>
	<div class="row" style="margin-top:10px;">
		<%-- 左邊區塊 --%>
		<c:choose>  
		<c:when test="${cookie['mobile'].value eq 'on'}">    		
				<div class="col-xs-9" style="padding-left:0;padding-right:0;">
			</c:when>  
			<c:otherwise> 				
				<div class="col-sm-8 col-md-9" style="padding-left:0;padding-right:0;">
			</c:otherwise>  
		</c:choose> 
		<div class="" style="width:750px;">
			<div class="" style="position: relative;width:310px;float:left;margin-right:20px;">
				<a href="#">
					<img class="" style="width:100%;margin-bottom:0px" src=<%=showThumbnail %> alt="...">
					<%if(bindingType!=null && bindingType.equals("P")){ //pdf %>
					<img class="pdf_ebook_type" src='/new_ec/rwd/include/images/C_image/pic/pic_8@2x.png' />
					<%}else if(bindingType!=null && bindingType.equals("Q")){ //epub %>
					<img class="ePub_ebook_type" src='/new_ec/rwd/include/images/C_image/pic/pic_9@2x.png' />
					<%} %>
					<%if(sing.orgFlg.equals("C")){ 
						if(sprodAskModel != null && sprodAskModel.chrtFlg.equals("Y")){
					%>
					<img class="snd_type" src='/new_ec/rwd/include/images/C_image/pic/pic_12@2x.png' />
						<%}else{%>
					<img class="snd_type" src='/new_ec/rwd/include/images/C_image/pic/pic_7@2x.png' />
						<%}%>
					<%} %>
				</a>
				
<%--take look carousel--%>
<%--take look carousel改成用ajax抓取的方式 --%>
<!--takelookajax_start-->
				<div id ="takelookajax" >
					<%	
					out.print(sing_o.get_takelookajax_DOM(takelookList,request,video_exists,lock18));
					%>
				</div>
<!--takelookajax_end--> 

<%--take look carousel --%>	
				
			</div> <!-- left -->
			<div class="" style="padding-top:5px;width:420px;float:left;">

			<%-- titleMain titleNext --%>
			<div class="row">
				<div class="col-xs-12">
					<h1 style="line-height: 24px;letter-spacing: 0.5px;font-size:20px;font-weight:bold; letter-spacing:1px;margin: 0;">
						<%=sing_o.titleMain %>
					<% if(sing_o.orgFlg.equals("A")&&sing_o.prodFgInfo!=null&&sing_o.prodFgInfo.length()>0){%>
						<span style="padding-left: 10px; font-size: 10pt; color: #333333;"><%=sing_o.prodFgInfo %></span>
					<%} %>
					<%if(sing_o.orgFlg.equals("C")){ %>
						<span style="padding-left: 10px; font-size: 10pt; color: #333333;">（二手書）</span>
					<%}else if(sing_o.orgFlg.equals("B")){ %>
						<span style="padding-left: 10px; font-size: 10pt; color: #333333;">（回頭書）</span>
					<%}else if(sing_o.orgFlg.equals("A") && (sing_o.prodCatId.equals("14")||sing_o.prodCatId.equals("25")||sing_o.prodCatId.equals("17"))){ %>
	<%-- 								<%if(sing_o.bindingType!=null && sing_o.bindingType.equals("P")){ %> --%>
	<%-- 								<span style="padding-left: 10px; font-size: 10pt; color: #333333;">（PDF版）</span> --%>
	<%-- 								<%}else if(sing_o.bindingType!=null && sing_o.bindingType.equals("Q")){ %> --%>
	<%-- 								<span style="padding-left: 10px; font-size: 10pt; color: #333333;">（ePub版）</span> --%>
						<%if(sing_o.bindingType!=null && sing_o.bindingType.equals("K")){ %>
						<span style="padding-left: 10px; font-size: 10pt; color: #333333;">（電子有聲書）</span>
						<%}else if(sing_o.bindingType!=null && sing_o.bindingType.equals("S")){ %>
						<span style="padding-left: 10px; font-size: 10pt; color: #333333;">（電子雜誌訂閱）</span>
						<%}else if(sing_o.prodCatId.equals("25")){ %>
						<span style="padding-left: 10px; font-size: 10pt; color: #333333;">（電子雜誌）</span>
						<%}else{ %>
						<span style="padding-left: 10px; font-size: 10pt; color: #333333;">（電子書）</span>
						<%} %>
					<%} %>
					</h1>
				</div>
			<%if(sing_o.titleNext!=null&&sing_o.titleNext.length()>0){ %>
				<div class="col-xs-12" style="margin-top:10px;">
					<h2 style="font-size:16px; letter-spacing:1px; color:#8c8c8c; margin: 0;">
					<%=sing_o.titleNext %>
					</h2>
				</div>
			<%} %>		
		</div>
		<%-- titleMain titleNext --%>

		<%--品牌 作者 --%>
		<div class="authorBrand">
		<%if(sing_o.prodCatId.equals("61") || sing_o.prodCatId.equals("62")){
			if(sing_o.brandId!=null && sing_o.brandId.length() > 0) {
				StringBuffer sf = new StringBuffer();
				sf.append("<div style='margin-top:10px;'><span>品牌:");
				sf.append("<a href='"+ searchProdPubUrlPattern + URLEncoder.encode(sing_o.pubNmMain,"utf8") +"'>");
				sf.append(sing_o.brandNm);
				sf.append("</a>");
				sf.append("</span></div>");
				sf.append("<div style='margin-top:10px;'><span>");
				sf.append("<a href=" + searchProdPubUrlPattern + URLEncoder.encode(sing_o.pubNmMain,"utf8") +"><img style='max-width:120px' src='https://media.taaze.tw/showBrandImage.html?width=480&pk=" + sing_o.brandId +"' border='0' alt='' /></a>");
				sf.append("</span></div>");
				out.print(sf.toString());
			}
		}
		if(sing_o.orgFlg.equals("A") && sing_o.prodCatId.equals("31")){
			StringBuffer sf = new StringBuffer();
			if(sing_o.brandId!=null && sing_o.brandId.length() > 0 && sing_o.pubNmMain!=null && sing_o.pubNmMain.length()>0) {
				sf.append("<div style='margin-top:10px;'><span>廠牌:");
				sf.append("<a href='"+ searchProdPubUrlPattern + URLEncoder.encode(sing_o.pubNmMain,"utf8") +"'>");
				sf.append(sing_o.brandNm);
				sf.append("</a>");
				sf.append("</span></div>");
				sf.append("<div style='margin-top:10px;'><span>");
				sf.append("<a href=" + searchProdPubUrlPattern + URLEncoder.encode(sing_o.pubNmMain,"utf8") +"><img style='max-width:120px' src='https://media.taaze.tw/showBrandImage.html?width=480&pk=" + sing_o.brandId +"' border='0' alt='' /></a>");
				sf.append("</span></div>");
			}
			if(author_text.length() > 0) {
				sf.append("<div><span>"+prodAuthorText+"："+author_text+"</span></div>");
			}
			sf.append("<div><span>音樂類型：<span><a href='/rwd_list.html?t="+sing_o.prodCatId +"&k=01&d=00&a=00&c=" +sing_o.catId.substring(0,2) +"0000000000&l=1' >" +sing_o.catName1 +"</a></span></span></div>");
			if(prodFormatAndSpec.length() > 0) {
				sf.append("<div><span>商品規格：" +prodFormatAndSpec +"</span></div>");
			}
			out.print(sf.toString());
		}else if(sing_o.orgFlg.equals("A") && sing_o.prodCatId.equals("32")) {
			StringBuffer sf = new StringBuffer();
			if(author_text.length() > 0) {
				sf.append("<div><span>演員：" +author_text +"</span></div>");
			}
			if(avInfo!=null&&avInfo.get("directorMain")!=null&&avInfo.getString("directorMain").length()>0) {
				sf.append("<div><span>導演：<span>" + avInfo.getString("directorMain") +"</span></span></div>");
			}
			if(sing_o.publishDate!=null && sing_o.publishDate.length()>0){
				sf.append("<div><span>發行日期：<span>" +sing_o.getDateFormat(sing_o.publishDate) +"</span></span></div>");
			}
			if(sing_o.rank!=null && sing_o.rank.length() > 0){
				sf.append("<div><span>分級：<span>" +sing_o.getRankText(sing_o.rank) +"</span></span></div>");
			}
			out.print(sf.toString());
		}else if(sing_o.cover_people!=null && sing_o.cover_people.length()>0){
			StringBuffer sf = new StringBuffer();
			sf.append("<p style='margin:10px 0 0 0;'>");
			sf.append("<span>封面人物:"+sing_o.cover_people);
			sf.append("</span></p>");
			out.print(sf.toString());
		}else{
			if(sing_o.author!=null && sing_o.author.length()>0){
		%>
			<p style="margin:10px 0 0 0;"><span>作者：<a href='<%= searchProdAuthorUrlPattern  +  URLEncoder.encode(sing_o.author,"utf8") %>'><%=sing_o.author %></a></span></p>
		<%
				if(sing_o.painter!=null && sing_o.painter.length()>0){
		%>
			<p style="margin:10px 0 0 0;"><span>繪者：<span><%=sing_o.painter %></span></span></p>
		<% 	
				}

			}
		}
		%>
		</div>
		<%--品牌 作者--%>	

		<%--評價/收藏/二手徵求/試讀 --%>	
		<div style="padding-top:10px;width:420px">
			<div id='toComment' class='iconBtn'
				onclick="toComment(0)">				
				<!--<img src='/new_ec/rwd/include/images/C_image/ic/ic_1@1x.png' />--><span style='color:#e2007f'><%=startLevelSize>0?startLevelSize:"" %></span>評價 
			</div>
			<%if(collectArray[0]==0){ %>
			<div id="myCollect" class='iconBtn collectCount'
				onclick="add2Collection('<%=sing_o.prodId %>','<%=sing_o.orgProdId%>');">				
				<!--<img src='/new_ec/rwd/include/images/C_image/ic/ic_2@1x.png' />--><span style='color:#e2007f'><%=collectArray[2]>0?collectArray[2]:"" %></span>收藏
			</div>
			<div id="myCollectp" class="iconBtn collectCount" 
				onclick="add2Collection('<%=sing_o.prodId %>','<%=sing_o.orgProdId%>');" style="display:none;">				
				&nbsp;<img src='/new_ec/rwd/include/images/C_image/ic/ic_2_p@1x.png' /><span id='myCollectSize' style='color:#e2007f'><%=collectArray[2]>0?collectArray[2]:"" %></span>收藏&nbsp;&nbsp;
			</div>
			<%}else{ %>
			<div id="myCollectp" class="iconBtn collectCount" 
				onclick="add2Collection('<%=sing_o.prodId %>','<%=sing_o.orgProdId%>');">				
				&nbsp;<img src='/new_ec/rwd/include/images/C_image/ic/ic_2_p@1x.png' /><span id='myCollectSize' style='color:#e2007f'><%=collectArray[2]>0?collectArray[2]:"" %></span>收藏&nbsp;&nbsp;
			</div>
			<div id="myCollect" class="iconBtn collectCount" 
				onclick="add2Collection('<%=sing_o.prodId %>','<%=sing_o.orgProdId%>');" style="display:none;">				
				<!--<img src='/new_ec/rwd/include/images/C_image/ic/ic_2@1x.png' />--><span style='color:#e2007f'><%=collectArray[2]>0?collectArray[2]:"" %></span>收藏&nbsp;&nbsp;
			</div>
			<%} %> 
			
			<% if(wantedSndFlg){
				//二手書徵求
				if(IsWanted){
			%>
			<div id="mySndWantp" name="mySndWant" class='iconBtn'
				onclick="wantSnd(event);">				
				&nbsp;<img src='/new_ec/rwd/include/images/C_image/ic/ic_3_p@1x.png' /><span style='color:#e3007f;'><%=wantedSndSize>0?wantedSndSize:"" %></span>二手徵求&nbsp;&nbsp; 
				
			</div>
			<div id="mySndWant" name="mySndWant" class='iconBtn'
				onclick="wantSnd(event);" style="display:none;">				
				<!--<img src='/new_ec/rwd/include/images/C_image/ic/ic_3@1x.png' />--><span style='color:#e2007f;'><%=wantedSndSize>0?wantedSndSize:"" %></span>二手徵求
			</div>
			<%}else{ %>
			<div id="mySndWant" name="mySndWant" class='iconBtn'
				onclick="wantSnd(event);">				
				<!--<img src='/new_ec/rwd/include/images/C_image/ic/ic_3@1x.png' />--><span style='color:#e2007f'><%=wantedSndSize>0?wantedSndSize:"" %></span>二手徵求
			</div>
			<div id="mySndWantp" name="mySndWant" class='iconBtn'
				onclick="wantSnd(event);" style="display:none;">				
				&nbsp;<img src='/new_ec/rwd/include/images/C_image/ic/ic_3_p@1x.png' /><span style='color:#e3007f;'><%=wantedSndSize>0?wantedSndSize:"" %></span>二手徵求&nbsp;&nbsp; 
			</div>
			<%}
				//二手書徵求 	
			}%>
	
			<% if(previewCount!=null && previewCount.length()>0){//線上試讀  %>
				<% if(sing_o.prodCatId.equals("14") || sing_o.prodCatId.equals("25") || sing_o.prodCatId.equals("17")){ %>
					<%if(cc!=null && cc.getCuid().toString().length()>0){ %>
			<div id="myPreview" class='iconBtn'
				onclick="location.href='http://ebook.taaze.tw/do/mobile/ebook_preview.ashx?oid=<%=sing_o.orgProdId %>&cuid=<%=cc.getCuid() %>'" data-status="Y">				
				<!--<img src='/new_ec/rwd/include/images/C_image/ic/ic_4@1x.png' />--><span style='color:#e2007f'><%=previewCount %></span>人次試讀
			</div>
			
					<%}else{ %>
			<div id="myPreview" class='iconBtn'
				onclick="location.href='http://ebook.taaze.tw/do/mobile/ebook_preview.ashx?oid=<%=sing_o.orgProdId %>'" data-status="Y">				
				<!--<img src='/new_ec/rwd/include/images/C_image/ic/ic_4@1x.png' />--><span style='color:#e2007f'><%=previewCount %></span>人次試讀 
			</div>
			
					<%} %>
			<%}else{ %>
		<div id="myPreview" class='iconBtn'
			onclick="location.href='http://ebook.taaze.tw/do/preview/viewer2.aspx?oid=<%=sing_o.orgProdId %>'" data-status="N">				
			<!--<img src='/new_ec/rwd/include/images/C_image/ic/ic_4@1x.png' />--><span style='color:#e2007f'><%=previewCount %></span>人次試讀 
		</div>
		
			<%} %>
		<%} %>
	
		<div style="clear:left;"></div>		

	</div>
	<%--評價/收藏/二手徵求/試讀 --%>
	<%-- 分享 --%>
	<div id='pcShare' style='margin-left: -80px;'>
		<iframe id='shareBox' frameborder="0" border="0" cellspacing="0" style="margin-top:-10px;height:33px;border: 0px;" src="/share_index.html" ></iframe>
	</div>
	<%-- 分享 --%>	

	<%--定價/特價/優惠價 顯示邏輯 --%>	
	<div class='price'>
	<%
	if(sing_o.listPrice==sing_o.salePrice){//定價=售價 顯示定價
		%>
		<p style="margin:0 0;">
			<span>定價：NT$ <span style="color:#e2007e;"><strong><%=(int)sing_o.listPrice %></strong></span></span>
		</p>
		<%
	}else if(sing_o.specialPrice==sing_o.salePrice){//特價=售價 顯示定價/特價
		%>
		<p style="margin:0 0;">
			<%if(sing_o.listPrice>0){ %>
			<span>定價：NT$ <span style='text-decoration:line-through;'><%=(int)sing_o.listPrice %></span></span>
			<%} %>
			<span>特價：NT$ <span style="color:#e2007e;"><strong><%=(int)sing_o.specialPrice %></strong></span></span>
		</p>
		<%
	}else{//顯示定價/特價/優惠價/折扣
		if(sing_o.orgFlg.equals("C")){//二手
			if(sing_o.discString(String.valueOf((int)sing_o.saleDisc)) != null){
				%>
				<p style="margin:0 0;">
					<%if(sing_o.listPrice>0){ %>
					<span>定價：<small>NT$</small> <span style='text-decoration:line-through;'><%=(int)sing_o.listPrice %></span></span>
					<%} %>
					<%if(sing_o.specialPrice>0){ %>
					<span>特價：<small>NT$</small> <span><%=(int)sing_o.specialPrice %></span></span>
					<%} %>
				</p>
				<p style="margin:0 0;">
					<span>二手價：<span style="color:#e2007e;"><strong><%=sing_o.discString(String.valueOf((int)sing_o.saleDisc)) %></strong></span> <small>折</small>，<small>NT$</small> <span style="color:#e2007e;"><strong><%=(int)sing_o.salePrice %></strong></span></span>
				</p>
				
				<% 							
			}else{
				%>
				<p style="margin:0 0;">
					<%if(sing_o.listPrice>0){ %>
					<span>定價：<small>NT$</small> <span style='text-decoration:line-through;'><%=(int)sing_o.listPrice %></span></span>
					<%} %>
					<%if(sing_o.specialPrice>0){ %>
					<span>特價：<small>NT$</small> <span><%=(int)sing_o.specialPrice %></span></span>
					<%} %>
				</p>
				<p style="margin:0 0;">
					<span>優惠價：<span style="color:#e2007e;"><strong><%=sing_o.discString(String.valueOf((int)sing_o.saleDisc)) %></strong></span> <small>折</small>，<small>NT$</small> <span style="color:#e2007e;"><strong><%=(int)sing_o.salePrice %></strong></span></span>
				</p>
				<%
			}
		}else{
			if((int)sing_o.saleDisc==0){
				%>
				<p style="margin:0 0;">
				<%if(sing_o.listPrice>0){ %>
					<span>定價：<small>NT$</small> <span style='text-decoration:line-through;'><%=(int)sing_o.listPrice %></span></span>
					<%} %>
				<%if(sing_o.specialPrice>0){ %>
					<span>特價：<small>NT$</small> <span><%=(int)sing_o.specialPrice %></span></span>
					<%} %>
				</p>
				<p style="margin:0 0;">
					<span>優惠價：<small>NT$</small> <span><%=(int)sing_o.salePrice %></span></span>
				</p>
				<% 							
			}else{
				%>
				<p style="margin:0 0;">
					<%if(sing_o.listPrice>0){ %>
						<span>定價：<small>NT$</small> <span style='text-decoration:line-through;'><%=(int)sing_o.listPrice %></span></span>
					<%} %>
					<%if(sing_o.specialPrice>0){ %>
						<span>特價：<small>NT$</small> <span><%=(int)sing_o.specialPrice %></span></span>
					<%} %>
				</p>
				<p style="margin:0 0;">
					<span>優惠價：<span style="color:#e2007e;"><strong><%=sing_o.discString(String.valueOf((int)sing_o.saleDisc)) %></strong></span> <small>折</small>，<small>NT$</small> <span style="color:#e2007e;"><strong><%=(int)sing_o.salePrice %></strong></span></span>
				</p>
				<%
			}
		}  												
	}
	%>
	<%--現金回饋 --%>
	<%if(showBonusFlag){ %>
	<p style="margin:0 0;">
		<span>現金回饋：<span style="color:#e2007e;"><strong><%=bonusPctValue %></strong><small>%</small></span> </span>
		<% if(act_url.length() > 0) { %>
		<span><a href="<%=act_url %>" target="_blank">(活動詳情)</a></span>
		<% } %>
		<span><a href="/qa/view/d.html#c3" target="_blank">回饋金可全額折抵商品 <span class="glyphicon glyphicon-question-sign" aria-hidden="true"></span></a></span>
	</p>
	<%} %>
	
	<%--getfinWhDate???? --%>
	<% 
	if(sing_o.prodCatId.equals("24") || sing_o.prodCatId.equals("27") || sing_o.prodCatId.equals("21") || sing_o.prodCatId.equals("22") || sing_o.prodCatId.equals("23")) { 
		if(sing_o.getfinWhDate().length()>0){
		%>
		<p style="margin:0 0;">
			<span><%=sing_o.getfinWhDate() %></span>
		</p>
		<% 
		}
	} 
	%>
	
	<%--優惠截止 --%>
	<% 
	if(sing_o.mcEDate!=null && sing_o.mcEDate.length()>=8) { 
		if(sing_o.mcPk>0){
		%>
		<p style="margin:0 0;">
			<span style='color:#e3007f'>優惠截止日：<span style="letter-spacing:1px;">至<%=sing_o.mcEDate.substring(0,4) %>年<%=sing_o.mcEDate.substring(4,6) %>月<%=sing_o.mcEDate.substring(6,8) %>日</span></span>
		</p>
		<% 
		}
	} 
	%>
	</div>

	<%---二手書訊息 --%>
	<%if(sing_o.orgFlg.equals("C")&&sndInfo!=null){
		out.print(sndInfo.toString());
	}
	%>
	<%---二手書訊息 --%>

	<%--運送方式/銷售地/庫存 --%>
	<%
	if(!sing_o.prodCatId.equals("14")&&!sing_o.prodCatId.equals("25")&&!sing_o.prodCatId.equals("17")){
		if(sing_o.vstkDes.length()>0){
	%>
			<div style='padding-left:10px;'>
	<%--運送方式 --%>
	<% 
			if(saleAreaJson!=null && saleAreaJson.getString("Cdt").length()>0) { 
	%>
				<p style="margin:0 0;">
					<span>運送方式：<span><%=saleAreaJson.getString("Cdt") %></span></span>
				</p>
		<%
			} 
		%>
					
	<%--銷售地區 --%>
	<% 
	if(saleAreaJson!=null && saleAreaJson.getString("SaleArea").length()>0) { 
	%>
				<p style="margin:0 0;">
				<span>銷售地區：<span><%=saleAreaJson.getString("SaleArea") %></span></span>
				</p>
	<%
		} 
	%>
					
	<%--庫存 --%>
				<p style="margin:0 0;">
					<span><span><%=sing_o.getVstkShow(sing_o.vstkDes) %></span></span>
				</p>
			</div>
			<%--圖示 --%>	
			<p class='DeliverAndKpst'>
				<%=sing_o.getDeliverAndKpstTextShow(sing_o.deliverImgType,sing_o.qty, sing_o.kpstk_flg, sing_o.prodCatId) %>
			</p>
	<%
		}else{
	%>
			<div style='padding-left:10px;'>	
				<p style="margin:0 0;">
					<span><span><%=sing_o.getVstkShow(sing_o.qty, sing_o.openFlg, sing_o.whId) %></span></span>
				</p>
			<%--圖示 --%>	
			</div>
			<p class='DeliverAndKpst'>
				<%=sing_o.getDeliverAndKpstTextShow(sing_o.deliverImgType,sing_o.qty, sing_o.kpstk_flg, sing_o.prodCatId) %>
			</p>
	<% 
		}
	}else if(sing_o.orgFlg.equals("A") && (sing_o.prodCatId.equals("14")||sing_o.prodCatId.equals("25")||sing_o.prodCatId.equals("17"))){ //電子書欄位 
	%>
			<div style='padding-left:10px;'>
				<div>
					<span>閱讀裝置：</span>
					<span>手機</span>
					<span>、平板</span>
				<% if(sing_o.bindingType!=null && !sing_o.bindingType.equals("K")){ %>
					<span>、PC</span>
				<% } %>
					<a href="http://www.taaze.tw/static_act/201403/ebookapp/index.htm" target="_blank"><img style='width:15px;height:15px;vertical-align: text-top;' src='/new_ec/rwd/include/images/C_image/ic/ic_14@2x.png'/></a>
				</div>
				<div>
					<span>瀏覽軟體：</span>
					
					<%=app_download %>
					
				</div>
			</div>
	<%
	}
	%>

	<%if(sing_o.rank!=null && sing_o.rank.equals("D")){//限制級商品 %>
		<div style='margin-left:10px;border:<%=lock18.equals("1") ?"dotted #e3007f;":"none"%>'>
			<img src="/new_ec/rwd/include/images/C_image/pic/pic_w_10@2x.png" alt="" width="100" height="45" style="" />
			<div style='display:<%=lock18.equals("1") ?"inline-block":"none"%>'>
				<%
				StringBuffer sf = new StringBuffer();
				sf.append("<select class='search_select' style='width:70px;' name='unlockYear'>");
				sf.append("<option value='0'>年份</option>");
				for(int i = nowCal.get(Calendar.YEAR); i>=1950; i-- ){
					sf.append("<option value='"+String.format("%04d",i)+"'>"+String.format("%04d",i)+"</option>");
				}
				sf.append("</select>");
				
				sf.append("<select class='search_select' style='width:70px;' name='unlockMonth'>");
				sf.append("<option value='0'>月份</option>");
				for(int i = 1; i<=12; i++ ){
					sf.append("<option value='"+String.format("%02d",i)+"'>"+String.format("%02d",i)+"</option>");
				}
				sf.append("</select>");
				
				sf.append("<select class='search_select' style='width:70px;' name='unlockDay'>");
				sf.append("<option value='0'>日期</option>");
				for(int i = 1; i<=31; i++ ){
					sf.append("<option value='"+String.format("%02d",i)+"'>"+String.format("%02d",i)+"</option>");
				}
				sf.append("</select>");
				out.print(sf.toString());
				%>
				<button class='check' style='vertical-align: middle;' name ='unLock18' id='unLock18'></button>
			</div>
			<span style='clear:both'></span>
		</div>
	<%}%>

	<%--其他版本/圖書館借閱 --%>
	<% 
	if(version_size > 0){//其他版本 1003 
					
		%>
		<div class="otherVersion">
			<div>
				<span style="color: #4A4A4A;">其他版本：</span>
			</div>
			<%
			for(int i=0; i<versionList.size(); i++) { 
				JSONObject version = (JSONObject)versionList.get(i);
				String otherSndBook = "其他二手價";
				if(version.getString("versionProdtext").equals(otherSndBook)){
					%>
					<div class="highlight" style="float:left;">
						<a href="<%=sing_o.getWebUrl(request)%>/usedList.html?oid=<%=version.getString("orgProdId")%>">
							<%=version.getString("versionProdtext")%><br />
							<%
							if(sing_o.discString(String.valueOf(version.getInt("disc")))!=null){
							%>
							<span style="color:#e2007e;"><%=sing_o.discString(String.valueOf(version.getInt("disc")))%></span><span>折</span>
							<%	
							}
							%>
							<span style="color:#e2007e;"><%=version.getInt("listPrice")%></span><span>元起</span>
						</a>
					</div>
					<%
					
				}
				else{
				if(version.getString("MoreSecondHandFlag").equals("true")) {
					%>
					<div class="highlight" style="float:left;">
						<a href="<%=sing_o.getWebUrl(request)%>/usedList.html?oid=<%=version.getString("orgProdId")%>">
							<%=version.getString("versionProdtext")%><br />
							<%
							if(sing_o.discString(String.valueOf(version.getInt("disc")))!=null){
							%>
							<span style="color:#e2007e;"><%=sing_o.discString(String.valueOf(version.getInt("disc")))%></span><span>折</span>
							<%	
							}
							%>
							<span style="color:#e2007e;"><%=version.getInt("listPrice")%></span><span>元起</span>
						</a>
					</div>
					<%
				}
				if(version.getString("MoreSecondHandFlag").equals("false")) {
					if(version.getInt("listPrice") > 0) {
						%>
						<div class="highlight" style="float:left;">
							<a href="<%=sing_o.getWebUrl(request)%>/goods/<%=version.getString("prodId")%>.html">
								<%=version.getString("versionProdtext")%><br />
								<%
								if(sing_o.discString(String.valueOf(version.getInt("disc")))!=null){
								%>
								<span style="color:#e2007e;"><%=sing_o.discString(String.valueOf(version.getInt("disc")))%></span><span>折</span>
								<%	
								}
								%>
								<span style="color:#e2007e;"><%=version.getInt("listPrice")%></span><span>元</span>
							</a>
						</div>
						<%			
					}
					if(version.getInt("listPrice") == 0) {
						%>
						<div class="highlight" style="float:left;">
							<a href="<%=sing_o.getWebUrl(request)%>/goods/<%=version.getString("prodId")%>.html">
								<%=version.getString("versionProdtext")%><br />
								<%
								if(!version.get("prodCatId").equals("14") || !version.get("prodCatId").equals("25")) {
								%>
								<span style="color:#e2007e;"><%=version.getInt("listPrice")%></span><span>元</span>
								<%	
								}
								%>
								
							</a>
						</div>
						<%
					}
				}
			}}
			%>
			<%--圖書館借閱 --%>
			<%
			if(diffDay > 180 && (sing_o.prodCatId.equals("11") || sing_o.prodCatId.equals("14"))||sing_o.orgFlg.equals("C")&& (sing_o.prodCatId.equals("11") || sing_o.prodCatId.equals("14"))){
				%>
				<div id="lib-interact" class="highlight dropdown"  style="float:left;cursor:pointer;">
					<span data-toggle="dropdown">圖書館借閱</span>
					<ul class='dropdown-menu' style="margin:0; padding:0;">
						<li><a href="http://ebook.taaze.tw/middle/Library/Library.php?ISBN=<%=sing_o.isbn %>" target="_blank">臺北市立圖書館</a></li>
						<li><a href="http://ebook.taaze.tw/middle/Library/NTCLibrary.php?ISBN=<%=sing_o.isbn %>" target="_blank"><s:text name="single.lend_books_library_xinli" /></a></li>
						<li><a href="http://ebook.taaze.tw/middle/Library/TCCultureLibrary.php?ISBN=<%=sing_o.isbn %>" target="_blank">臺中市立圖書館</a></li>
						<li><a href="http://ebook.taaze.tw/middle/Library/TCLibrary.php?ISBN=<%=sing_o.isbn %>" target="_blank">國立公共資訊圖書館</a></li>
						<li><a href="http://ebook.taaze.tw/middle/Library/TNMLibrary.php?ISBN=<%=sing_o.isbn %>" target="_blank">臺南市立圖書館</a></li>
						<li><a href="http://ebook.taaze.tw/middle/Library/KSLibrary.php?ISBN=<%=sing_o.isbn %>" target="_blank"><s:text name="single.lend_books_library_gaoxiong"></s:text></a></li>
						<li><a href="http://ebook.taaze.tw/middle/Library/NTULibrary.php?ISBN=<%=sing_o.isbn %>" target="_blank">臺灣大學圖書館</a></li>
						<li class="libTooltip"><a id="tooltip" title="" onmouseover="">什麼是借閱查詢 <img style='width:15px;height:15px;vertical-align: text-top;' src='/new_ec/rwd/include/images/C_image/ic/ic_14@2x.png'/></a></li>
					</ul>
					<div id='lend_books_infos' style='display:none;'><s:text name="single.lend_books_infos"/></div>
				</div>
				<%
			}
			%>
			<%if(!sing_o.haseUSed&&!sing_o.prodCatId.equals("21")&&!sing_o.prodCatId.equals("22")&&!sing_o.prodCatId.equals("25")&&!sing_o.prodCatId.equals("14")){%>
			<div style="float:left;" class="highlight">
				<div>
					<a class="" href="/usedList.html?oid=<%=sing_o.istProdId %>" style="text-decoration:none; ">二手書<br/>交易資訊</a>
				</div>
			</div>	
			<%}%>
		</div>
	<% if(sing_o.orgFlg.equals("A") && (sing_o.prodCatId.equals("11") || sing_o.prodCatId.equals("14") || sing_o.prodCatId.equals("24") || sing_o.prodCatId.equals("27")) && !sing_o.haseUSed) {
		String lineStyle = "0";
		if(versionList.size()==0) {
			lineStyle = "1";
		}
	%>
	<% } %>
<%}%>
	<div style="clear:left;"></div>
</div>
<div style="clear:both;"></div>
</div><!-- <div class="media"> -->

</div>
<%-- 左邊區塊 --%>
		
<%-- 右邊區塊 --%>
<c:choose>  
<c:when test="${cookie['mobile'].value eq 'on'}">   		
<div class="col-xs-3">
</c:when>  
<c:otherwise> 		
<div class="col-sm-4 col-md-3">
</c:otherwise>  
</c:choose> 		
	<div id="cartArea" style='text-align: center;'>
	<%--行銷活動_feynamn_換成sing.setMcData()決定的  --%>
	<%if(orgAndQtyFlg){ %>
		<%if(sing_o.mcName2!=null && sing_o.mcName2.length()>0 && sing_o.mcUrl2!=null){//行銷活動 %>
		<div style="min-width:198px;">
			<div>
				 <!--<div class="arrow"></div>-->
				  <!--<h3 class="popover-title">Popover top</h3>-->
				  <div style="text-align:center;background-color:#FFF0F5;width: 215px;margin: 0 auto;">
					  <%if(sing_o.mcUrl2!=null){ %>
						<p style='padding:5px 5px;'><span style="font-weight:bold"><a id="mcUrl2" data-mccode2="<%=sing_o.mcCode2%>" target='_blank' href="<%=sing_o.mcUrl2%>" style="color:#e3007f;"><%=sing_o.mcName2%></a></span></p>
					<%}else{ %>
						<p><%=sing_o.mcName2%></p>
					<%} %>
				  </div>
			</div>
		  </div>				
		<%}%>
	<%}%>
	<%--行銷活動  --%>
	
	<%--購物車按鈕組  --%>
	<div class="panel-default" style="min-width:198px;border:none;margin-bottom: 20px;">
		<div class="panel-body" style='padding:0px;'>
		<%if(orgAndQtyFlg){ %>
			<%if(sing_o.openFlg==-1 || sing_o.openFlg==1){ %>
				<%if(sing_o.salePrice==0 && sing_o.orgFlg.equals("A") && (sing_o.prodCatId.equals("14")||sing_o.prodCatId.equals("25")||sing_o.prodCatId.equals("17"))){ //電子書欄位%>
					<%-- 電子書欄位 --%>
					<button id="readButton" onClick="readEbook('<%=sing_o.prodId%>','<%=sing_o.orgProdId%>')" type="button" class="btn btn-taaze-a btn-lg btn-block" style="padding-top:15px; padding-bottom:15px; margin-bottom: 15px;">免費閱讀</button>							
				<%}else{ %>	
					<%buyNowHtml = "<button type='button' name='shoppingBuy' class='shoppingBuy'>直接購買</button>"; %>
					<button type="button" name="saveToCart" class="saveToCart">放入購物車</button>
				<%} %>
				
	<%-- 二手書義賣所得 --%>
	<% if(sprodAskModel != null && sprodAskModel.chrtFlg.equals("Y") && sprodAskModel.welfareId!=null) { %>
	<span style="text-align:left;">
	<div class="bubbleInfo3" style="line-height: 16px;width: 160px; margin: 0px auto 7px; color:#666666; font-size:10pt;position:relative;">
	此本二手書販售所得，賣家將捐贈予：<%=sprodAskModel.welfareName %><a onmouseover="overShow()" onmouseout="outHide()" href="javascript:void(0);"><img style="vertical-align: bottom;" src="/include/default/imgs/question.gif"/></a>
	<div  id="showDiv" style="display:none; width:230px; border: 1px solid #C2C2C2; border-radius: 3px; padding:5px; position: absolute; color:#808080; background-color:#ffffff;"></div>
	</div>
	</span>
	<% } %>
				<%--直接購買  --%>
				<%=buyNowHtml %>
				<%--已購買提示  --%>
				<%if(orderDate!=null&&orderDate.length()>0){ %>
					<p style="padding:10px 5px 0 5px;">
						<s:text name="shop.main"></s:text>：您已於<%=orderDate %><s:text name="shop.aready"></s:text>。
					</p>							
				<%} %>
			<%}else if(sing_o.openFlg==0){ %>
				<%if(sing_o.outOfPrint.equals("Y")){ %>
					<%
					//二手書徵求
					if(wantedSndFlg){ 
					%>
						<%if(IsWanted){//已徵求 %>
							<button type="button" class="btn btn-taaze-a btn-lg btn-block" style="padding-top:15px; padding-bottom:15px;margin-bottom: 10px;" onclick='wantSnd(event)'>二手徵求</button>
						<%}else{//未徵求 %>
							<button type="button" class="btn btn-taaze-a btn-lg btn-block" style="padding-top:15px; padding-bottom:15px;margin-bottom: 10px;" onclick='wantSnd(event)'>二手徵求</button>
						<%} %>
					<%}%>
				<%}else{ %>
				
					<button type="button" name='shoppingNotic' class="saveTolistWatch">可購買時通知我</button>
					
				<%} %>
			<%} %>
			
			<!-- 訂閱 -->
			<% if(sing_o.prodCatId.equals("25")) { %>
				<% if(mag_scribe.getInt("error_code")==100 && !subscribe) { %>
				<!-- 訂閱按鈕 -->
				<button type="button" name="magScribe" class="magScribe" data-toggle='modal' data-target ='#msg_sub_Modal'>訂閱</button>
				<%} %>
			<%} %>
			
			<!-- 放入暫存清單 -->
			<button type="button" name="wishButton" rel="false" class="saveTolistWatch">放入暫存清單</button>
			
		<%}else{%>
			<div type="button" name='saleout' class="saleout">限量商品已售完</div>
		<%} %>
		</div>
	</div>			
	<%--購物車按鈕組  --%>
	</div><!-- cartArea -->	
	
	<%--贈品  --%>
	<% 

	StringBuilder giftsCarousel = new StringBuilder();
	
	if(gifts != null && gifts.size()>0){
		giftsCarousel.append("<div class='panel-default giftPanel'>");
		giftsCarousel.append("<div style='width:100%;height:26px;background:#F0F0F0;vertical-align: middle;padding:4px 10px;'>");
		giftsCarousel.append("<span>限量贈品</span>");
		giftsCarousel.append("</div>");
		giftsCarousel.append("<div class='panel-body giftPanelBody' >");
		giftsCarousel.append("<div id='giftCarousel' class='carousel slide' data-ride='carousel' data-interval='false' style='padding:0px;font-size: 12px;'>");
		//補充ol的部分，讓輪播下面有點顯示切換
		
		giftsCarousel.append("<ol class='carousel-indicators'>");
		for(int j=0; j<gifts.size();j++){
		giftsCarousel.append("<li data-target='#giftCarousel' data-slide-to='"+ j +"'"+( (j==0)?"class='active'":"" ) +"></li>");
		}
		giftsCarousel.append("</ol>");   
		//補充完畢
		giftsCarousel.append("<div class='carousel-inner' role='listbox'>");
		
	%>
						<%
						StringBuilder giftsSb = new StringBuilder();
						giftsSb.append("<div style='display:none'>");
						boolean aflg = false;
					int n_aflg=0;
					for(int j=0; j<gifts.size();j++){
						JSONObject gift_mas = JSONObject.fromObject(gifts.get(j));
						JSONArray gift_item = JSONArray.fromObject(gift_mas.get("items"));
					//feynman
					n_aflg+=gift_item.size();
						if(n_aflg>1){
							aflg = true;
						}
					
						for(int i=0; i<gift_item.size(); i++){
						//System.out.println(gift_item.get(i));
						JSONArray it = JSONArray.fromObject(gift_item.get(i));
							JSONObject gift_data = JSONObject.fromObject(it.get(0));
							int qty = gift_data.getInt("qty");
							
							giftsSb.append("<div style='display:none'><a class='gift_content' rel='"+gift_data.getString("prod_id")+"' href='#"+gift_data.getString("prod_id")+"'></a></div>");
							giftsSb.append("<div id='"+gift_data.getString("prod_id")+"' style='width:100%;padding-bottom:10px;' remark='"+gift_mas.getString("remark")+"' repeat_flg='"+gift_mas.getString("repeat_flg")+"' type='"+gift_mas.getString("gift_type")+"'>");
							//giftsSb.append("<div>");
							giftsSb.append("<div style='float:left;margin-left:10px;max-width: 180px;'><img style='max-width:180px;' src='https://media.taaze.tw/showLargeImage.html?sc="+gift_data.getString("prod_id")+"&width=300' /></div>");
							giftsSb.append("<div style='max-width:570px;float:left;padding: 5px 10px 12px 10px;line-height: 25px;font-size: 10pt;color: #666666;'>");
							giftsSb.append("<div><span style='font-weight:bold;'>限量贈品</span></div>");
							giftsSb.append("<div>"+gift_data.getString("prod_name")+"</div>");
							//sb2.append(" <div>剩餘數量："+qty+"</div>");
							if(!gift_data.getString("prod_id").substring(0,2).equals("14") && !gift_data.getString("prod_id").substring(0,2).equals("25")) {
								if(qty == 0) {
									giftsSb.append(" <div style='color:#e2008e'>已全數贈送完畢</div>");
								} else {
									if(qty > 5) {
										giftsSb.append(" <div><span style=''>剩餘數量</span><span style='margin:0 3px; font-weight:normal;'>&gt;</span>5</div>");
									} else {
										giftsSb.append(" <div><span style=''>剩餘數量 =</span>"+qty+"</div>");
									}
								}
							}
							if(gift_mas.getString("remark").length() > 0) {
								giftsSb.append("<div style='padding-top:10px;'><span style='font-weight:bold;'>活動辦法：</span></div>");
								giftsSb.append("<div>"+gift_mas.getString("remark").replaceAll("\n","<br/>")+"</div>");
							}
							giftsSb.append("<div class='item_info' >");
							if(gift_data.getString("material_desc").length() > 0) {
								giftsSb.append("<div style='padding-top: 10px;'><span style='font-weight:bold;'>贈品說明：</span></div>");
								giftsSb.append("<div><span>"+gift_data.getString("material_desc")+"</span></div>");
							}
							if(gift_mas.getString("repeat_flg").equals("A")) {
								giftsSb.append("<div style='padding-top:10px;'><span style='font-weight:bold;'>注意事項：</span></div><div>單筆訂單不可累送。</div>");
							} else {
								giftsSb.append("<div style='padding-top:10px;'><span style='font-weight:bold;'>注意事項：</span></div><div>單筆訂單可累送。</div>");
							}
							if(gift_data.getString("sale_area").equals("A")) {
								giftsSb.append("<div style='padding-top:10px;'><span  style='font-weight:bold;'>寄送地區限制：</span></div><div>沒有限制</div>");
							} else if(gift_data.getString("sale_area").equals("B")) {
								giftsSb.append("<div style='padding-top:10px;'><span  style='font-weight:bold;'>寄送地區限制：</span></div><div>限台灣本島加離島</div>");
							} else {
								giftsSb.append("<div style='padding-top:10px;'><span  style='font-weight:bold;'>寄送地區限制：</span></div><div>限台灣本島</div>");
							}
							giftsSb.append("</div>");
							
							giftsSb.append("</div>");
							//giftsSb.append("</div>");
							giftsSb.append("<div style='clear:both' ></div>");
							giftsSb.append("</div>");
							
							giftsCarousel.append("<div class='item " +( (j==0&&i==0)?"active":"" )+"' style='width:215px'>");
							giftsCarousel.append("<div onclick='showGiftDetailByPk("+gift_data.getString("prod_id")+")' class='giftImg' style='background-image:url(\"https://media.taaze.tw/showLargeImage.html?sc=" + gift_data.getString("prod_id") + "&height=170&width=120\");' data-pid='" +gift_data.getString("prod_id") +"'></div>");
							giftsCarousel.append("<div style='word-wrap:break-word; word-break:break-all;'>");
							giftsCarousel.append("<ul style='list-style:none; margin:0; padding:10%;'>");
							giftsCarousel.append("<li>"+EcPathSettingImp.LimitString(gift_data.getString("prod_name"),42,"...") +"</li>");
							
						%>
									<%
									if(!gift_data.getString("prod_id").substring(0,2).equals("14") && !gift_data.getString("prod_id").substring(0,2).equals("25")) {
										if(qty == 0) {
											giftsCarousel.append("<li style='color:#e2008e;'>已全數贈送完畢</li>");
//     													out.print("<li style='color:#e2008e;'>已全數贈送完畢</li>");
										} else {
											if(qty > 5) {
												giftsCarousel.append("<li style='color:#e2008e;'>贈品庫存&gt;5</li>");
//     														out.print("<li style='color:#e2008e;'>贈品庫存&gt;5</li>");
											} else {
												giftsCarousel.append("<li style='color:#e2008e;'>贈品庫存="+qty+"</li>");
//     														out.print("<li style='color:#e2008e;'>贈品庫存="+qty+"</li>");
											}
										}
									}
									%>

					<%	
						giftsCarousel.append("<li style='cursor:pointer;' onclick='showGiftDetailByPk("+gift_data.getString("prod_id")+")'><a>見活動詳情</a></li>");
					giftsCarousel.append("</ul>");
					giftsCarousel.append("</div>");
					giftsCarousel.append("</div>");
						} 
					}
						
					giftsSb.append("</div>");		
					out.print(giftsSb.toString());
					
					giftsCarousel.append("</div>");
					if(aflg){
						giftsCarousel.append("<div style='position:absolute;z-index:5;top:40%;left:-10px;'>");
						giftsCarousel.append("<a href='#giftCarousel' role='button' data-slide='prev'>");
						giftsCarousel.append("<img class='arrowForLeftImg_s' />");
						giftsCarousel.append("<span class='sr-only'>Previous</span>");
						giftsCarousel.append("</a>");
						giftsCarousel.append("</div>");
						giftsCarousel.append("<div style='position:absolute;z-index:5;top:40%;right:-10px;'>");
						giftsCarousel.append("<a href='#giftCarousel' role='button' data-slide='next'>");
						giftsCarousel.append("<img class='arrowForRightImg_s' />");
						giftsCarousel.append("<span class='sr-only'>Next</span>");
						giftsCarousel.append("</a>");
						giftsCarousel.append("</div>");
					}
					
					giftsCarousel.append("</div>");
					giftsCarousel.append("</div>");
					giftsCarousel.append("</div>");
					%>

	<%
		out.print(giftsCarousel.toString());
	} 
	%>
	<%--贈品  --%>
	
	<%-- 我想讀 --%>
	<%if(sing_o.prodCatId.equals("11") || sing_o.prodCatId.equals("14")) { %>
	<div id='iWantRead' style='width:215px;margin:0 auto 3px auto;'>
		<div class='dropdown'>
			<ul class='dropdown-menu hidden_menu' style='width:100%;margin-top:-1px;'>
				<li class='want_read_action' rel='W'><a>我想讀</a></li>
				<li class='reading_action' rel='A'><a>正在讀</a></li>
				<li class='readed_action' rel='D'><a>已讀完</a></li>
				<li style='border-bottom:1px solid #C2C2C2;'></li>
				<li onclick='changeCheckDiv(this)' class='collect_action' style='<%=collectArray[0]==0?"":"display:none"%>'>
					<div title="勾選這個欄位將書本收藏到書櫃中" class='checkDiv'>
						<div class='checkY <%=collectArray[0]==0?"active":"" %>' rel='Y'>
							<span class='glyphicon glyphicon-ok'></span>
						</div>
					</div>
					<span style='clear:both;letter-spacing:0.5px; line-height:19px;'>同步收藏</span>
				</li>
				<li onclick='changeCheckDiv(this)' class='fb_check'>
					<div title="勾選這個欄位將你發表的評論同步到facebook上"  rel="uncheck" class="fb_shared checkDiv">
						<div class='checkY' rel='N'>
							<span class='glyphicon glyphicon-ok'></span>
						</div>
					</div>
					<span style='clear:both;letter-spacing:0.5px; line-height:19px;'>分享至臉書</span>
				</li>
			</ul>
			<div style='float:left;text-align:center;display:inline-block;width:165px;height:45px;border-color: #E3007F;border-width: 1px 0px 1px 1px;border-style: solid;border-radius: 100px 0 0 100px;'>
				<div style='vertical-align:middle;height:100%;display:inline-block;'></div>
				<div class='read_state action_frame' rel='0' style='color:#E3007F;letter-spacing:2px; line-height:24px;font-size:17px;font-weight:700;display:inline-block;vertical-align:middle;'>我想讀</div>
			</div>
			<div data-toggle="dropdown" class="dropdown-toggle" style='padding-top:10px;text-align:center;float:left;width:50px;height:45px;border: 1px solid #E3007F;border-radius: 0 100px 100px 0;'>
				<img style='width:20px;height:10px;' src='/new_ec/rwd/include/images/C_image/ic/ic_5@2x.png' />
			</div>
			<div style='clear:both;'></div>
		</div>
		<%-- 收藏這本書的人 --%>
		<%
		
		if(recommendZekea!=null && recommendZekea.getString("error_code").equals("100") && recommendZekea.getInt("total_size") > 0){
			StringBuffer sb_zek = new StringBuffer();
			sb_zek.append("<div class='panel-default' style='width:215px;border:none;margin-bottom:0px;'>");
			sb_zek.append("<div class='panel-body' style='width:100%'>");
			sb_zek.append("<div class='collectCount'><span style='color:#e3007f;font-weight:bold;'>"+collectArray[2]+"</span><font style='color:#e3007f;font-weight:bold;'>人</font>收藏這本書</div>");
			
			sb_zek.append("<div id='recommendZekeaCarousel' class='carousel slide' data-ride='carousel' data-interval='false' style='padding:0px;'>");
			sb_zek.append("<div class='carousel-inner' style='padding-left:5px;' role='listbox'>");
			int pageSize = 5;
			JSONArray recommendList = recommendZekea.getJSONArray("custs"); 
			for(int i = 0; i <recommendList.size(); i++){
				JSONObject cust = recommendList.getJSONObject(i);
				if(i == 0 ){	
					sb_zek.append("<div class='item active'>");
				}else if((i%pageSize) == 0){
					sb_zek.append("<div class='item'>");
				}
				
				sb_zek.append("<div style='margin-left:5px;display:inline-block;width:25px;height:25px;'><a title='"+cust.getString("nick_name")+"' href='/container_zekeaclt_view.html?ci=" + cust.getString("cuid") + "' target='_blank' >");
				sb_zek.append("<img style='border-radius:50%;' src='https://media.taaze.tw/showMemImage.html?no=" + cust.getString("cuid") + "&width=50&height=50' width='25' height='25' border='0' />");
				sb_zek.append("</a></div>");

				if(i==(recommendList.size()-1) || (i%pageSize) == (pageSize-1)){
					sb_zek.append("<div style='clear:both;'></div>");
					sb_zek.append("</div>");
				}
			}
			sb_zek.append("</div>");
			if(recommendList.size()>pageSize){	
			sb_zek.append("<div style='position:absolute;z-index:5;top:25%;left:-10px;'>");
			sb_zek.append("<a href='#recommendZekeaCarousel' role='button' data-slide='prev'>");
			sb_zek.append("<img class='arrowForLeftImg_s' />");
			sb_zek.append("<span class='sr-only'>Previous</span>");
			sb_zek.append("</a>");
			sb_zek.append("</div>");
			
			sb_zek.append("<div style='position:absolute;z-index:5;top:25%;right:-10px;'>");
			sb_zek.append("<a href='#recommendZekeaCarousel' role='button' data-slide='next'>");
			sb_zek.append("<img class='arrowForRightImg_s' />");
			sb_zek.append("<span class='sr-only'>Next</span>");
			sb_zek.append("</a>");
			sb_zek.append("</div>");
			}
			
			sb_zek.append("</div>");
			sb_zek.append("</div>");
			sb_zek.append("</div>");
			
			out.print(sb_zek.toString());
		}
		
		%>
		<%-- 收藏這本書的人 End--%>
		<%-- 收藏這本書的朋友--%>
		<div class='friend_bookAction' style='display:none;'>
			
			<div class='panel panel-default' style='width:195px;border:none;margin-bottom:0px;'>
				<div class='panel-body' style='width:100%'>
					<div class='friendCount2'></div>
					<div id='friendShow2' class='friendShow2 carousel slide' data-ride='carousel' data-interval='false' style='padding:0px;'></div>
				</div>
			</div>
		</div>
		<%-- 收藏這本書的朋友 End--%>
	</div>
	<%} %>
	<%-- 我想讀 --%>
	
	<%-- 其他功能 --%>
	<div class='other'>
	<%
	String nextPositionTop = "";
	if(sndSale && (sing_o.prodCatId.equals("11")|| sing_o.prodCatId.equals("24") || sing_o.prodCatId.equals("27") || sing_o.prodCatId.equals("12") || sing_o.prodCatId.equals("13"))){ //sele form
		nextPositionTop="45px";
	%>
		<div id='sndSale' class='dropdown' style='display:inline-block;'>
			<img class='bay' />
	<%
		if(cc!=null && cc.getMobileVerifyFlg().equals("Y")){
	%>
			<a style='cursor:pointer;' type="button" data-toggle='modal' data-target ='#sendToSellModal'>我要賣</a>
	<%		
		}else if(cc!=null && cc.getCustId().equals("tch1050818@gmail.com")){
			out.print("<a style='cursor:pointer;' type='button' data-toggle='modal' data-target ='#sendToSellModal'>我要賣</a>");
		}else{
	%>
			<a data-toggle="dropdown" class="dropdown-toggle" style='cursor:pointer;' <%=cc==null?"onclick='loginFirst()'":"" %>>我要賣</a>
			<ul class="dropdown-menu" style='width:130px;margin-top:-1px;'>
				<li><a href='/sell_used_books.html'><s:text name="single.understand_more" /></a></li>
			</ul>
			<div style='display:none;' id='whatISale_info'>
				<s:text name="single.i_sell_icon_info.msg"/>
			</div>
	<%		
		}
	%>
		</div>
	<%
	}
	%>
		<div id='salebonus' class='dropdown' style='display:inline-block;'>
			<img class='money' />
			<a data-toggle="dropdown" class="dropdown-toggle" href="#">行銷分紅</a>
	<%
	if(cc!=null && cc.getMobileVerifyFlg().equals("Y") &&  cc.getPrFlg()!=null && cc.getPrFlg().equals("Y")){ //通過行銷分紅驗證
	%>	
			<ul class="dropdown-menu dropdown-menu-right" style='width:330px;margin-top:-1px;'>
				<li><a href='/member_serviceCenter.html?qa_type=l'><s:text name="single.understand_more" /></a></li>
				<li><a href='/mobileValidate.html?typeFlg=IA'><s:text name="single.immediately_open_access" /></a></li>
				<li class='whatAp'><a href='#'><s:text name="single.what's_ap" /><img style="margin-left:3px;width:15px;height:15px;vertical-align: text-top;" src="/new_ec/rwd/include/images/C_image/ic/ic_14@2x.png" /></a></li>				
				<li>
				<div style="padding-top: 6px;"> 
				<a class="linkStyle02" style="margin-left: 12px;" href="javascript:void(0);" onClick="selectApUrl()">點此全選下列網址</a><span style="padding-left: 5px;">再按右鍵複製</span>
					<input type="text" id="apUrl" name="apUrl" size="37" value="<%=sing_o.getWebUrl(request) %>/apredir.html?<%=ApUtil.encryptForCuid(new Long(cc.getCuid())) %>/<%=sing_o.getWebUrl(request) %>/goods/<%=sing_o.prodId %>.html?a=b"  readonly="readonly" style="margin-left: 12px;">
				</div>
				</li>
				<li>
				<div style="padding-top: 6px;">
				<a class="linkStyle02" style="margin-left: 12px;" href="javascript:void(0);" onClick="selectApCode()">點此全選下列Html碼</a><span style="padding-left: 5px;">再按右鍵複製</span>
					<textarea id="apCode" name="apCode" rows="5" cols="40" style="margin-left: 12px;"><a href="<%=sing_o.getWebUrl(request) %>/apredir.html?<%=ApUtil.encryptForCuid(new Long(cc.getCuid())) %>/<%=sing_o.getWebUrl(request) %>/goods/<%=sing_o.prodId %>.html?a=b" target="_blank"><%=sing_o.titleMain %></a></textarea>
				</div>
				</li>	
			</ul>
			<div style='display:none;' id='whatAp_info'>
				<s:text name="single.show_ap_info.msg"/>
			</div>
	<%}else{%>
			<ul class="dropdown-menu dropdown-menu-right" style='width:130px;margin-top:-1px;'>
				<li><a href='/member_serviceCenter.html?qa_type=l'><s:text name="single.understand_more" /></a></li>
				<li><a href='/mobileValidate.html?typeFlg=IA'><s:text name="single.immediately_open_access" /></a></li>
				<li class='whatAp'><a href='#'><s:text name="single.what's_ap" /><img style="margin-left:3px;width:15px;height:15px;vertical-align: text-top;" src="/new_ec/rwd/include/images/C_image/ic/ic_14@2x.png" /></a></li>
			</ul>
			<div style='display:none;' id='whatAp_info'>
				<s:text name="single.show_ap_info.msg"/>
			</div>
	<%} %>
		</div>
	</div>
	<%-- 其他功能 --%>		</div>
<%-- 右邊區塊 --%>

</div>

<div class="row visible-xs-block" style="border-bottom: 1px dotted #C2C2C2;height:15px;margin-bottom: 10px;"></div>


<%-- tags --%>
<div>tags tags tags tags tags tags tags </div>
<%-- tags --%>

<div class="row visible-xs-block" style="border-bottom: 1px dotted #C2C2C2;height:15px;margin-bottom: 10px;"></div>


<%-- 二手與徵求 --%>
<!-- 	我要徵求及我要賣 -->
<div class="row" style="margin-bottom: 10px;">
	<div class="col-sm-6 col-xs-12" style=" margin: 10px 0px;">
			<div class="col-sm-12 col-xs-12" style='padding:0px; margin-bottom: 10px;'>
				<div class="col-sm-12 col-xs-12" style='padding:0px;text-align:center;'>
					<%
/*
//似乎多餘
if(sing.total_saler > 0) {
int lowerest_disc = Math.round((sing.lowest_price/sing.listPrice)*100);
sale_text2 += "二手價<span class='highlightu'>"+sing.discString(String.valueOf(lowerest_disc))+"</span>折";
sale_text2 += sing.total_saler>1? "<span class='highlightu' >"+String.valueOf(sing.lowest_price)+"</span>元起，":"<span class='highlightu' >"+String.valueOf(sing.lowest_price)+"</span>元，";
sale_text2 += "共<span>"+sing.total_saler+"</span>位賣家";
}*/
%>
<label class="sprod_sale_text">
	<%=sing.total_saler > 0 ? sale_text2 : "目前沒有二手書" %>
</label>
</div>
<div id="wantLink2" class="col-sm-12 col-xs-12" style='padding:0px;'>
	<% if (IsWanted) { %>
	<div class="btn_buy" style="display:none;">我要徵求</div>
	<div class="btn_cancel_wnt"
	onclick="cancelWantedSize2('<%=sing.orgProdId %>')">取消徵求
</div>
<% } else { %>
<div class="btn_buy">我要徵求</div>
<div class="btn_cancel_wnt" style="display:none;"
onclick="cancelWantedSize2('<%=sing.orgProdId %>')">取消徵求
</div>
<% } %>
</div>
</div>


</div>

<!-- 	我要徵求及我要賣 -->

			<div class="col-sm-6 col-xs-12" style=" margin: 10px 0px;">
		
		<div class="col-sm-12 col-xs-12"
		style='padding:0px; margin-bottom: 10px;'>
		<div class="col-sm-12 col-xs-12"
		style='padding:0px;text-align: center;'>
		<label class="sprod_want_text"><%=want_range.size() > 0 ? wnd_text : "目前沒有人徵求" %>
		</label>
	</div>
	<div class="col-sm-12 col-xs-12" style='padding:0px;'>
		<% if (sndSale) { %>
		<% if (cc != null && cc.getMobileVerifyFlg().equals("Y")) { %>
		<div class="btn_sale">我要賣</div>
		<% } else { %>
		<% if (cc != null) { %>
		<div class="btn_sale_verify">我要賣</div>
		<% } else { %>
		<div class="btn_sale">我要賣</div>
		<% } %>
		<% } %>
		<% } else { %>
		<div class="btn_no_sale">暫不開放上架</div>
		<% } %>
	</div>
</div>


</div>
</div>

<%-- 二手與徵求 --%>


<%-- 商品簡介 --%>

		
	<%--內容簡介/各界推薦/章節試閱/作者序/目錄/購物須知....--%>
	<ul class="nav nav-tabs textArea" style='margin-bottom:20px;'>
	<%
	if(menuItems.size()>0) {
		for(int i = 0; i < menuItems.size(); i++) {
	%>
		<li data-toggle="tab" class="<%=i==0?"active":"" %>"><a style="cursor:pointer;" rel="pr<%=i%>"><%=menuItems.getJSONObject(i).get("title") %></a></li>
	<%	
		}
	}
	%>
	</ul>
	<div class="panel panel-default" style="margin-top:0px;border:none">				
		<div class="">
			<div style="text-align: right;">
				<span>文字字級</span>
				<img id="word1" style="cursor:pointer;width:30px;height:30px;" src='/new_ec/rwd/include/images/C_image/ic/ic_9@2x.png'></img>
				<img id="word2" style="cursor:pointer;width:30px;height:30px;" src='/new_ec/rwd/include/images/C_image/ic/ic_10@2x.png'></img>
				<img id="word3" style="cursor:pointer;width:30px;height:30px;" src='/new_ec/rwd/include/images/C_image/ic/ic_12@2x.png'></img>
			</div>
			<div id="textArea" style="font-size: 14px;line-height:22px">
		<%
		for(int i = 0; i < textAreaDOM.size(); i++) {
			String DOM = "";
			DOM += "<a name='pr"+i+"' ></a>";
			if(!textAreaDOM.getJSONObject(i).getString("id").equals("prodPf") && !textAreaDOM.getJSONObject(i).getString("id").equals("howBuy")) {
				DOM += "<div id='"+textAreaDOM.getJSONObject(i).getString("id") +"Div' class='prodContent'>";
			} else {
				DOM += "<div id='"+textAreaDOM.getJSONObject(i).getString("id") +"Div'>";
			}
			if(i > 0) {
				DOM += String.format(htmlBuild1, textAreaDOM.getJSONObject(i).getString("title"));
			} 
			DOM += textAreaDOM.getJSONObject(i).getString("content");
			DOM += "</div>";
			out.print(DOM);
		}
		
		%>
			</div>
		</div>
	</div>
	<%--內容簡介/各界推薦/章節試閱/作者序/目錄購物須知....--%>

<%-- 商品簡介 --%>

<div class="row" style="margin-bottom: 10px;">
	<div class="col-sm-6 col-xs-12" style=" margin: 10px 0px;">
			<div class="col-sm-12 col-xs-12" style='padding:0px; margin-bottom: 10px;'>
				<div class="col-sm-12 col-xs-12" style='padding:0px;text-align:center;'>
<%
sb = new StringBuilder();
int total_sale = 0;
if (sprod_range.size() > 0) {
	int index = 0;
	sb.append("<table class='sale_range' width='100%' class='table' border='0' cellspacing='0' cellpadding='0'>");
	sb.append("<tr class='column_title'><td class='column_left' width='50%'>二手價</td><td width='50%'>數量</td></tr>");
	for (int i : sing.priceArray) {
		String bg_color = "#ffffff";
		if (sprod_range.containsKey(String.valueOf(i))) {
			if (String.valueOf(i).equals(sing.most_sale)) {
				sb.append("<tr bgcolor='#efefef'><td class='column column_left' rel='" + i + "' style='font-weight:bold'>" + sing.getRangeText(i) + "</td><td class='column' align='right'>" + sprod_range.get(String.valueOf(i)) + "</td></tr>");
			} else {
				sb.append("<tr bgcolor='" + bg_color + "'><td class='column column_left' rel='" + i + "'>" + sing.getRangeText(i) + "</td><td class='column' align='right'>" + sprod_range.get(String.valueOf(i)) + "</td></tr>");
			}
			total_sale += Integer.valueOf(sprod_range.get(String.valueOf(i)));
		} else {
			if (String.valueOf(i).equals(sing.most_sale)) {
				sb.append("<tr  bgcolor='#efefef'><td class='column column_left' rel='" + i + "' style='font-weight:bold'>" + sing.getRangeText(i) + "</td><td class='column' align='right' >0</td></tr>");
			}
		}
		index++;
	}
	sb.append("</table>");
	out.print(sb.toString());
}
%>
<input type="hidden" id="TOTAL_SALE" value="<%=total_sale %>"/>
</div>
</div>
</div>

<div class="row" style="margin-bottom: 10px;">
	<div class="col-sm-6 col-xs-12" style=" margin: 10px 0px;">
			<div class="col-sm-12 col-xs-12" style='padding:0px; margin-bottom: 10px;'>
				<div class="col-sm-12 col-xs-12" style='padding:0px;text-align:center;'>
<%
if (want_range.size() > 0) {
	out.print(want_content_table);
}
%>
<input type="hidden" id="TOTAL_WANT" value="<%=total_want %>"/>
</div>
</div>
</div>
	</body>
</html>