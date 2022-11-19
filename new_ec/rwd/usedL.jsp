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
String previewCount = sing.displayDL(sing.orgProdId, systemDao);
//出版日期距今
int diffDay = 0;
//評論筆數
int startLevelSize = sing.getSizeStartLevelByOrgProdId(sing.orgProdId, systemDao);
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
JSONArray versionList = sing.getVersionList(sing.istProdId, sing.orgProdId);

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





String bindingType = "A"; 
String author_text = "";
String prodFormatAndSpec = "";


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
		


	</body>
</html>