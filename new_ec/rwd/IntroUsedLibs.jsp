<%
//商品資料
StringBuffer prodDataSb = new StringBuffer();
prodDataSb.append("<div style='margin:2px 0;'>");
if(sing_o.orgFlg.equals("A") && sing_o.prodCatId.equals("31")) {
if(author_text.length() > 0) {
prodDataSb.append("<span class='prodInfo_boldSpan' style='padding:0;'>"+ prodAuthorText +"：<span style='color: #666666; font-weight: normal;'>"+ author_text +"</span></span>");
}
if(producers.length() > 0) {
prodDataSb.append("<span class='prodInfo_boldSpan' >製作人：<span style='color: #666666; font-weight: normal;'><a href='" + searchProdAllUrlPattern + URLEncoder.encode(producers,"utf8") +"'>"+ producers +"</a></span></span>");
}
} else if(sing_o.orgFlg.equals("A") && sing_o.prodCatId.equals("32")) {
if(author_text.length() > 0) {
prodDataSb.append("<span class='prodInfo_boldSpan' style='padding:0;'>演員：<span style='color: #666666; font-weight: normal;'>"+ author_text +"</span></span>");
}
if(avInfo!=null&&avInfo.get("directorMain")!=null&&avInfo.getString("directorMain").length()>0) {
prodDataSb.append("<span class='prodInfo_boldSpan' >導演：<span style='color: #666666; font-weight: normal;'><a href='"+ searchProdAllUrlPattern + URLEncoder.encode(avInfo.getString("directorMain"),"utf8")+"'>"+ avInfo.getString("directorMain") +"</a></span></span>");
}
} else {
if(sing_o.author!=null && sing_o.author.length()>0){
prodDataSb.append("<span class='prodInfo_boldSpan' style='padding:0;'>" + prodAuthorText +"：<span style='color: #666666; font-weight: normal;'><a href='" + searchProdAuthorUrlPattern + URLEncoder.encode(sing_o.author,"utf8") +"'>" +sing_o.author +"</a></span></span>");
}
}
if(sing_o.painter!=null && sing_o.painter.length() > 0) {
prodDataSb.append("<span class='prodInfo_boldSpan' >繪者：<span style='color: #666666; font-weight: normal;'><a href='"+ searchProdAllUrlPattern + URLEncoder.encode(sing_o.painter,"utf8")+"'>"+ sing_o.painter +"</a></span></span>");
}
if(sing_o.translator!=null && sing_o.translator.length()>0){
prodDataSb.append("<span class='prodInfo_boldSpan'>譯者：<span style='color: #666666; font-weight: normal;'><a href='"+ searchProdAllUrlPattern + URLEncoder.encode(sing_o.translator,"utf8")+"'>"+ sing_o.translator +"</a></span></span>");
}
prodDataSb.append("</div>");
prodDataSb.append("<div style='margin:2px 0;'>");
if(sing_o.prodCatId.equals("31")) {
if(sing_o.brandId!=null && sing_o.brandId.length() > 0 && sing_o.pubNmMain!=null && sing_o.pubNmMain.length()>0) {
prodDataSb.append("<span class='prodInfo_boldSpan' style='padding:0;'>"+ prodPublishText +"：<span style='color: #666666; font-weight: normal;'><a href='" + searchProdPubUrlPattern + URLEncoder.encode(sing_o.pubNmMain,"utf8") +"'>"+ sing_o.brandNm +"</a></span></span>");
}
} else if(sing_o.prodCatId.equals("32")) {
if(sing_o.pubNmMain!=null && sing_o.pubNmMain.length()>0){
prodDataSb.append("<span class='prodInfo_boldSpan' style='padding:0;'>發行：<span style='color: #666666; font-weight: normal;'><a href='"+ searchProdPubUrlPattern + URLEncoder.encode(sing_o.pubNmMain,"utf8")+"'>" + sing_o.brandNm +"</a></span></span>");
}
} else {
if(sing_o.pubNmMain!=null && sing_o.pubNmMain.length()>0){
prodDataSb.append("<span class='prodInfo_boldSpan' style='padding:0;'>" + prodPublishText +"：<span style='color: #666666; font-weight: normal;'><a href='"+ searchProdPubUrlPattern + URLEncoder.encode(sing_o.pubNmMain,"utf8") +"'>"+ sing_o.pubNmMain +"</a></span></span>");
}
}
if(sing_o.publishDate!=null && sing_o.publishDate.length()>0){
prodDataSb.append("<span class='prodInfo_boldSpan'>"+ prodPublishDateText +"：<span style='color: #666666; font-weight: normal;'>"+ sing_o.getDateFormat(sing_o.publishDate) +"</span></span>");
}
if(sing_o.isbn!=null && sing_o.isbn.length()>0){
prodDataSb.append("<span class='prodInfo_boldSpan'>ISBN/ISSN：<span style='color: #666666; font-weight: normal;'>"+ sing_o.isbn +"</span></span>");
}
if(sing_o.prodCatId.equals("21") || sing_o.prodCatId.equals("22")|| sing_o.prodCatId.equals("23")|| sing_o.prodCatId.equals("24")|| sing_o.prodCatId.equals("25")|| sing_o.prodCatId.equals("26")|| sing_o.prodCatId.equals("27")) {
if(sing_o.eanCode!=null && sing_o.eanCode.length()>0){
prodDataSb.append("<span class='prodInfo_boldSpan'>條碼：<span style='color: #666666; font-weight: normal;'>"+ sing_o.eanCode +"</span></span>");
}
}
prodDataSb.append("</div>");
if(sing_o.prodCatId.equals("32")) {
prodDataSb.append("<div style='margin:2px 0;'>");
if(sing_o.rank!=null && sing_o.rank.length() > 0) { //商品內容分級.預設：‘A’A：普遍級,B：保護級C：輔導級,D：限制級
prodDataSb.append("<span class='prodInfo_boldSpan' style='padding:0;'>分級：<span style='color: #666666; font-weight: normal;'>"+ sing_o.getRankText(sing_o.rank) +"</span></span>");
}
if(avInfo!=null&&avInfo.get("avLen")!=null&&avInfo.getString("avLen").length()>0){
prodDataSb.append("<span class='prodInfo_boldSpan'>片長：<span style='color: #666666; font-weight: normal;'>"+ avInfo.getString("avLen") +"分鐘</span></span>");
}
if(avInfo!=null&&avInfo.get("cdFormat")!=null&&avInfo.getString("cdFormat").length()>0){
prodDataSb.append("<span class='prodInfo_boldSpan'>商品規格（光碟格式）/（張數）：<span style='color: #666666; font-weight: normal;'>" +avInfo.getString("cdFormat") +"/"+ avInfo.getString("discs") +"</span></span>");
}
prodDataSb.append("</div>");
prodDataSb.append("<div style='margin:2px 0;'>");
if(avInfo!=null&&avInfo.get("avRegion")!=null&&avInfo.getString("avRegion").length()>0){
prodDataSb.append("<span class='prodInfo_boldSpan' style='padding:0;'>播放區域：<span style='color: #666666; font-weight: normal;'>"+ sing_o.getAvRegionText(avInfo.getString("avRegion")) +"</span></span>");
}
prodDataSb.append("</div>");
prodDataSb.append("<div style='margin:2px 0;'>");
if(avInfo!=null&&avInfo.get("screenRatio")!=null&&avInfo.getString("screenRatio").length()>0){
prodDataSb.append("<span class='prodInfo_boldSpan' style='padding:0;'>螢幕比例：<span style='color: #666666; font-weight: normal;'>"+ sing_o.getScreenRatioText(avInfo.getString("screenRatio")) +"</span></span>");
}
if(avInfo!=null&&avInfo.get("sound")!=null&&avInfo.getString("sound").length()>0){
prodDataSb.append("<span class='prodInfo_boldSpan'>音效格式：<span style='color: #666666; font-weight: normal;'>" +avInfo.getString("sound") +"</span></span>");
}
prodDataSb.append("</div>");
prodDataSb.append("<div style='margin:2px 0;'>");
if(avInfo!=null&&avInfo.get("language")!=null&&avInfo.getString("language").length()>0){
prodDataSb.append("<span class='prodInfo_boldSpan' style='padding:0;'>發音：<span style='color: #666666; font-weight: normal;'>"+ avInfo.getString("language") +"</span></span>");
}
if(avInfo!=null&&avInfo.get("subtitles")!=null&&avInfo.getString("subtitles").length()>0){
prodDataSb.append("<span class='prodInfo_boldSpan'>字幕：<span style='color: #666666; font-weight: normal;'>"+ avInfo.getString("subtitles") +"</span></span>");
}
prodDataSb.append("</div>");
}
if(sing_o.countryNm != null) {
prodDataSb.append("<div style='margin:2px 0;'>");
prodDataSb.append("<span class='prodInfo_boldSpan' style='padding:0;'>製造/出產地：<span style='color: #666666; font-weight: normal;'>"+ sing_o.countryNm +"</span></span>");
if(eancode.length() > 0) {
prodDataSb.append("<span class='prodInfo_boldSpan'>商品條碼：<span style='color: #666666; font-weight: normal;'>"+ eancode +"</span></span>");
}
prodDataSb.append("</div>");
}
if(sing_o.orgFlg.equals("A") && sing_o.prodCatId.equals("31")) {
prodDataSb.append("<div style='margin:2px 0;'>");
prodDataSb.append("<span class='prodInfo_boldSpan' style='padding:0;'>音樂類型：<span style='color: #666666; font-weight: normal;'>"+ sing_o.catName +"</span></span><span style=\"padding: 0 0 0 20px; background: url('/new_ec/single/include/images/line01.jpg') no-repeat 0px 3px;\">商品規格：<span style='color: #666666; font-weight: normal;'>"+ prodFormatAndSpec +"</span></span>");
if(musical_instruments.length() > 0) {
prodDataSb.append("<span class='prodInfo_boldSpan'>演奏樂器：<span style='color: #666666; font-weight: normal;'>"+ musical_instruments +"</span></span>");
}
prodDataSb.append("</div>");
}
prodDataSb.append("<div style='margin:2px 0;'>");
if(sing_o.getLanguageTex().length()>0){
prodDataSb.append("<span class='prodInfo_boldSpan' style='padding:0;'>語言：<span style='color: #666666; font-weight: normal;'>"+ sing_o.getLanguageTex() +"</span></span>");
}
if(sing_o.phonetics!=null && sing_o.phonetics.equals("Y")) {
prodDataSb.append("<span class='prodInfo_boldSpan'>注音：<span style='color: #666666; font-weight: normal;'>內文含注音</span></span>");
}
prodDataSb.append(sing_o.getAgeText());
if(sing_o.getBindingType().length()>0){
prodDataSb.append("<span class='prodInfo_boldSpan'>裝訂方式：<span style='color: #666666; font-weight: normal;'>"+ sing_o.getBindingType() +"</span></span>");
}
if(sing_o.pages!=null && sing_o.pages.length()>0 && !sing_o.pages.equals("0")){
prodDataSb.append("<span class='prodInfo_boldSpan'>頁數：<span style='color: #666666; font-weight: normal;'>"+sing_o.pages +"頁</span></span>");
}
if(sing_o.bookSize!=null && sing_o.bookSize.length()>0){
prodDataSb.append("<span class='prodInfo_boldSpan'>開數：<span style='color: #666666; font-weight: normal;'>"+sing_o.bookSize +"</span></span>");
}
if (sing_o.orgFlg.equals("A") && (sing_o.prodCatId.equals("14") || sing_o.prodCatId.equals("25") || sing_o.prodCatId.equals("26") || sing_o.prodCatId.equals("17"))) { //電子書欄位
if ("Q".equals(sing_o.bindingType)) {
prodDataSb.append("<span class='prodInfo_boldSpan'").append(prodDataSb.indexOf("語言") < 0 ? " style='padding:0;'" : "").append(">檔案格式：<span style='color: #666666; font-weight: normal;'>流動版型</span></span>");
} else {
prodDataSb.append("<span class='prodInfo_boldSpan'").append(prodDataSb.indexOf("語言") < 0 ? " style='padding:0;'" : "").append(">檔案格式：<span style='color: #666666; font-weight: normal;'>固定版型</span></span>");
}
if (sing_o.fileSize != null && sing_o.fileSize.length() > 0) {
Double fileSizeMb = (Double.parseDouble(sing_o.fileSize) / 1024);
DecimalFormat df2 = new DecimalFormat("#.##");
prodDataSb.append("<span class='prodInfo_boldSpan'>檔案大小：<span style='color: #666666; font-weight: normal;'>" + df2.format(fileSizeMb) + "MB</span></span>");
}
}
prodDataSb.append("</div>");
String sizeBuild = "";
String sizeTemp = "";
sizeTemp = (sing_o.sizeL!=null&&!sing_o.sizeL.equals("0"))?"<span style=\"color:#666666; font-weight:normal;\">長：" + sing_o.sizeL + "mm</span>":"";
if(sizeTemp.length()>0){
sizeBuild += sizeBuild.length()>0 ? " \\ " + sizeTemp:sizeTemp;
}
sizeTemp = (sing_o.sizeW!=null&&!sing_o.sizeW.equals("0"))?"<span style=\"color:#666666; font-weight:normal;\">寬：" + sing_o.sizeW + "mm</span>":"";
if(sizeTemp.length()>0){
sizeBuild += sizeBuild.length()>0 ? " \\ " + sizeTemp:sizeTemp;
}
sizeTemp = (sing_o.sizeH!=null&&!sing_o.sizeH.equals("0"))?"<span style=\"color:#666666; font-weight:normal;\">高：" + sing_o.sizeH + "mm</span>":"";
if(sizeTemp.length()>0){
sizeBuild += sizeBuild.length()>0 ? " \\ " + sizeTemp:sizeTemp;
}
if(sizeBuild.length()>0){
sizeBuild = "<span class='prodInfo_boldSpan' style='padding:0;'>商品尺寸：</span>" + sizeBuild;
}
String weigthBuild = (sing_o.weight!=null&&!sing_o.weight.equals("0"))?"<span style=\"color:#666666; font-weight:normal;\">" + sing_o.sizeL + "公克</span>":"";
if(weigthBuild.length()>0){
if(sizeBuild.length()>0){
weigthBuild = "<span class='prodInfo_boldSpan'>商品重量：</span>" + weigthBuild;
}else{
weigthBuild = "<span class='prodInfo_boldSpan' style='padding:0;'>商品重量：</span>" + weigthBuild;
}
}
String prodSizeBuild = (sing_o.prodSize!=null&&sing_o.prodSize.length()>0)?"<span style=\"color:#666666; font-weight:normal;\">" + sing_o.prodSize + "</span>":"";
if(prodSizeBuild.length()>0){
prodSizeBuild = "<span class='prodInfo_boldSpan'>衣服尺寸：</span>" + prodSizeBuild;
}
String prodColorBuild = (sing_o.prodColor!=null&&sing_o.prodColor.length()>0)?"<span style=\"color:#666666; font-weight:normal;\">" + sing_o.prodColor + "</span>":"";
if(prodColorBuild.length()>0){
if(prodSizeBuild.length()>0){
prodColorBuild = "<span class='prodInfo_boldSpan' style='padding:0;'>商品顏色：</span>" + prodColorBuild;
}else{
prodColorBuild = "<span class='prodInfo_boldSpan'>商品顏色：</span>" + prodColorBuild;
}
}
%>