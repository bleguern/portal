<%@ Page Language="C#" %>
<!-- #Include File="config/util.cs" -->
<html>
<head>
<title>DELIA SYSTEMS PORTAL</title>
<link href="css/main.css" rel="stylesheet" type="text/css">
<script type="text/javascript">
function MM_findObj(n, d) { //v4.01
  var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
    d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
  if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
  for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
  if(!x && d.getElementById) x=d.getElementById(n); return x;
}
function MM_nbGroup(event, grpName) { //v6.0
var i,img,nbArr,args=MM_nbGroup.arguments;
  if (event == "init" && args.length > 2) {
    if ((img = MM_findObj(args[2])) != null && !img.MM_init) {
      img.MM_init = true; img.MM_up = args[3]; img.MM_dn = img.src;
      if ((nbArr = document[grpName]) == null) nbArr = document[grpName] = new Array();
      nbArr[nbArr.length] = img;
      for (i=4; i < args.length-1; i+=2) if ((img = MM_findObj(args[i])) != null) {
        if (!img.MM_up) img.MM_up = img.src;
        img.src = img.MM_dn = args[i+1];
        nbArr[nbArr.length] = img;
    } }
  } else if (event == "over") {
    document.MM_nbOver = nbArr = new Array();
    for (i=1; i < args.length-1; i+=3) if ((img = MM_findObj(args[i])) != null) {
      if (!img.MM_up) img.MM_up = img.src;
      img.src = (img.MM_dn && args[i+2]) ? args[i+2] : ((args[i+1])?args[i+1] : img.MM_up);
      nbArr[nbArr.length] = img;
    }
  } else if (event == "out" ) {
    for (i=0; i < document.MM_nbOver.length; i++) { img = document.MM_nbOver[i]; img.src = (img.MM_dn) ? img.MM_dn : img.MM_up; }
  } else if (event == "down") {
    nbArr = document[grpName];
    if (nbArr) for (i=0; i < nbArr.length; i++) { img=nbArr[i]; img.src = img.MM_up; img.MM_dn = 0; }
    document[grpName] = nbArr = new Array();
    for (i=2; i < args.length-1; i+=2) if ((img = MM_findObj(args[i])) != null) {
      if (!img.MM_up) img.MM_up = img.src;
      img.src = img.MM_dn = (args[i+1])? args[i+1] : img.MM_up;
      nbArr[nbArr.length] = img;
  } }
}

function MM_preloadImages() { //v3.0
 var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
   var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
   if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
}
</script>
</head>
<script language="C#" runat="server">
	void Page_Load(Object sender, EventArgs e) 
	{
		InformationTextField.Value = "Welcome to Delia Systems Portal, you are connected as " + User.Identity.Name.ToUpper() + " on " + Session["server"].ToString();
	}
</script>
<body onLoad="MM_preloadImages('images/main/main_r2_c2_f2.gif','images/main/main_r2_c2_f3.gif','images/main/main_r2_c5_f2.gif','images/main/main_r2_c5_f3.gif','images/main/main_r4_c3_f2.gif','images/main/main_r4_c3_f3.gif','images/main/main_r4_c7_f2.gif','images/main/main_r4_c7_f3.gif','images/main/main_r5_c7.gif','images/main/main_r5_c7_f2.gif','images/main/main_r5_c7_f3.gif')">
<center>
<br>
<br>
<br>
<br>
<table border="0" cellpadding="0" cellspacing="0" width="750">
  <tr>
   <td><img name="main_r1_c1" src="images/main/main_r1_c1.gif" width="759" height="181" border="0" alt=""></td>
  </tr>
  <tr>
   <td height="10"></td>
  </tr>
  <tr>
  	<td>
  	<table border="0" cellpadding="0" cellspacing="0" width="759">
	  <tr>
		
<%

if(IsAllowed("pages/donezat", false))
{

%>

		<td width="214" nowrap><a href="pages/donezat/Default.aspx" onMouseOut="MM_nbGroup('out');" onMouseOver="MM_nbGroup('over','main_r2_c2','images/main/main_r2_c2_f2.gif','images/main/main_r2_c2_f3.gif',1)" onClick="MM_nbGroup('down','navbar1','main_r2_c2','images/main/main_r2_c2_f3.gif',1)"><img name="main_r2_c2" src="images/main/main_r2_c2.gif" width="214" height="51" border="0" alt=""></a></td>
		<td width="50" nowrap></td>

<%

}

if(IsAllowed("pages/marie", false))
{

%>

		<td width="214" nowrap><a href="http://webcaen/marie2" target="_blank" onMouseOut="MM_nbGroup('out');" onMouseOver="MM_nbGroup('over','main_r2_c5','images/main/main_r2_c5_f2.gif','images/main/main_r2_c5_f3.gif',1)" onClick="MM_nbGroup('down','navbar1','main_r2_c5','images/main/main_r2_c5_f3.gif',1)"><img name="main_r2_c5" src="images/main/main_r2_c5.gif" width="214" height="51" border="0" alt=""></a></td>
		<td width="50" nowrap></td>

<%

}

if(IsAllowed("pages/expenses", false))
{

%>

		<td width="214" nowrap><a href="pages/expenses/Default.aspx" onMouseOut="MM_nbGroup('out');" onMouseOver="MM_nbGroup('over','main_r5_c7','images/main/main_r5_c7_f2.gif','images/main/main_r5_c7_f3.gif',1)" onClick="MM_nbGroup('down','navbar1','main_r5_c7','images/main/main_r5_c7_f3.gif',1)"><img name="main_r5_c7" src="images/main/main_r5_c7.gif" width="214" height="51" border="0" alt=""></a></td>

<%

}

%>
		
   		<td width="759"></td>
  	 </tr>
	</table>
	</td>
  </tr>
  <tr>
   <td height="30"></td>
  </tr>
  <tr>
  	<td>
  	<table border="0" cellpadding="0" cellspacing="0" width="759">
	  <tr>
	   
	   
<%

if(IsAllowed("pages/admin", false))
{

%>

		<td width="50" nowrap></td>
		<td width="214" nowrap><a href="pages/admin/Default.aspx" onMouseOut="MM_nbGroup('out');" onMouseOver="MM_nbGroup('over','main_r4_c3','images/main/main_r4_c3_f2.gif','images/main/main_r4_c3_f3.gif',1)" onClick="MM_nbGroup('down','navbar1','main_r4_c3','images/main/main_r4_c3_f3.gif',1)"><img name="main_r4_c3" src="images/main/main_r4_c3.gif" width="214" height="51" border="0" alt=""></a></td>

<%

}

%>
	   
		   <td width="50" nowrap></td>
		   <td width="214" nowrap><a href="logout.aspx" onMouseOut="MM_nbGroup('out');" onMouseOver="MM_nbGroup('over','main_r4_c7','images/main/main_r4_c7_f2.gif','images/main/main_r4_c7_f3.gif',1)" onClick="MM_nbGroup('down','navbar1','main_r4_c7','images/main/main_r4_c7_f3.gif',1)"><img name="main_r4_c7" src="images/main/main_r4_c7.gif" width="214" height="51" border="0" alt=""></a></td>
		   <td width="759"></td>
		   <td></td>
	  	</tr>
	</table>
	</td>
  </tr>
  <tr>
   <td height="30"></td>
  </tr>
  <tr>
   <td><input name="InformationTextField" type="text" class="welcome" id="InformationTextField" style="width:750px;border-width:0px" readonly="true" runat="server"></td>
  </tr>
  <tr>
   <td height="5"></td>
  </tr>
  <tr>
   <td class="text"><a href="pages/password/Default.aspx">Update my password</a></td>
  </tr>
  <tr>
   <td class="text" align="right"><a href="pages/help/Default.aspx" target="_blank">Documentation</a></td>
  </tr>
</table>
</center>
</body>
</html>