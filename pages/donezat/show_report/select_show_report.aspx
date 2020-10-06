<%@ Page Language="C#" %>
<!-- #Include File="../../../config/util.cs" -->
<html>
<head>
<title>TIME REPORT - Show report</title>
<LINK href="../../../css/main.css" rel="stylesheet" type="text/css">
</head>
<script language="C#" runat="server">
	void Page_Load(Object sender, EventArgs e) 
	{
		if(!IsPostBack)
		{
			DataSet pageData = null;
			
			PortalSqlClient sqlClient = new PortalSqlClient(Session["sql_connection_string"].ToString());
		
			sqlClient.UpdateDataSetWithStoredProcedure(ref pageData, "donezat_admin_page_data");
		
			UpdateHmltSelectWithDataTable(ref UserSelect, pageData.Tables[0]);
		}
	}
	
	void ShowButton_Click(Object sender, EventArgs e) {
		InformationTextField.Value = null;
		
		if(UserSelect.Value == "")
		{
			InformationTextField.Value = "WARNING : Some fields are missing!";
		}
		else
		{
			WriteJavaScript("window.open('show_show_report.aspx?user_id=" + UserSelect.Value + "&name=" + UserSelect.Items[UserSelect.SelectedIndex].Text + "')");
		}
	}
	
	
</script>
<body>
<form id="MainForm" method="post" runat="server">
<table width="500" border="0" cellspacing="0" cellpadding="0">
  <tr>
  	<td>
		<table width="500" border="0" cellspacing="0" cellpadding="0">
			<tr>
    			<td class="header">SELECT AN USER TO SHOW HIS TIME REPORT</td>
  			</tr>
		</table>
	</td>
 </tr>
  <tr>
    <td height="5"></td>
  </tr>
 <tr>
	  <td>
		<table width="500" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td width="50" class="text" align="left">User : </td>
			    <td width="5"></td>
			    <td width="250"><select id="UserSelect" name="UserSelect" size="1" class="text" style="width:250px"
										runat="server"></select></td>
				<td width="2"></td>
				<td width="10" class="red">*</td>
				<td width="183"></td>
			</tr>
		</table>
	 </td>
    </tr>
	<tr>
	 <td height="10"></td>
	</tr>
    <tr>
	  <td>
	  <table width="500" border="0" cellspacing="0" cellpadding="0">
		<tr align="center">
      	 <td><input type="submit" class="text" runat="server" style="width:100px" id="ShowButton" name="ShowButton" alt="Show time report for this user" value="Show" onServerClick="ShowButton_Click"></td>
      	</tr>
	  </table>
	  </td>
    </tr>
	<tr>
	 <td height="10"></td>
	</tr>
	<tr>
	 <td><input name="InformationTextField" type="text" class="red" id="InformationTextField" style="width:500px;border-width:0px"
										runat="server" readonly="true"></td>
	</tr>
	<tr>
	 <td height="5"></td>
	</tr>
	<tr>
		<td class="red">* : Mandatory fields</td>
	</tr>
</table>
</form>
</body>
</html>
