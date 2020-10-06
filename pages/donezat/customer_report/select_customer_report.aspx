<%@ Page Language="C#" %>
<!-- #Include File="../../../config/util.cs" -->
<html>
<head>
<title>TIME REPORT - Chargeable report</title>
<LINK href="../../../css/main.css" rel="stylesheet" type="text/css">
<script type="text/javascript" src="../../../scripts/main.js"></script>
</head>
<script language="C#" runat="server">
	void Page_Load(Object sender, EventArgs e) 
	{
		if(Session["sql_connection_string"] != null)
		{
			string headerScript = "";
			DataSet pageData = null;
		
			PortalSqlClient sqlClient = new PortalSqlClient(Session["sql_connection_string"].ToString());
			sqlClient.UpdateDataSetWithStoredProcedure(ref pageData, "donezat_customer_report_page_data");
			
			headerScript = GetHeaderScriptWithDataSet(pageData);
			WriteJavaScript(headerScript);
			
			if(!IsPostBack)
			{
				UpdateHmltSelectWithDataTable(ref CustomerSelect, pageData.Tables[0]);
			
				SetHmltSelectSelectedIndexByString(ref YearSelect, DateTime.Now.Year.ToString());
			}
		}
	}
	
	void ShowButton_Click(Object sender, EventArgs e) {
		InformationTextField.Value = null;
		
		if(CustomerSelect.Value == "")
		{
			InformationTextField.Value = "WARNING : Some fields are missing!";
		}
		else
		{
			Response.Redirect("show_customer_report.aspx?year=" + YearSelect.Value +
				"&customer_id=" + CustomerSelect.Value);
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
    			<td class="header">SELECTION FOR CUSTOMER REPORT</td>
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
				<td width="100" class="text" align="left">Customer : </td>
			    <td width="5"></td>
				<td width="30"><input name="CustomerTrigTextField" type="text" class="text" id="CustomerTrigTextField" style="width:30px" onChange="onCustomerReportCustomerTrigChange(this.value, CustomerSelect)" maxlength="3" runat="server"></td>
			    <td width="5"></td>
				<td width="150"><select id="CustomerSelect" name="CustomerSelect" size="1" class="text" style="width:150px" runat="server"></select></td>
				<td width="2"></td>
				<td width="10" class="red">*</td>
				<td width="198"></td>
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
				<td width="100" class="text" align="left">Year : </td>
			    <td width="5"></td>
			    <td width="60"><select id="YearSelect" name="YearSelect" size="1" class="text" style="width:60px"
										runat="server">
			      <option value="2000">2000</option>
			      <option value="2001">2001</option>
			      <option value="2002">2002</option>
			      <option value="2003">2003</option>
			      <option value="2004">2004</option>
			      <option value="2005">2005</option>
			      <option value="2006">2006</option>
			      <option value="2007">2007</option>
			      <option value="2008">2008</option>
			      <option value="2009">2009</option>
			      <option value="2010">2010</option>
			    </select></td>
				<td width="335"></td>
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
      	 <td><input type="submit" class="text" runat="server" style="width:100px" id="ShowButton" name="ShowButton" alt="Show report" value="Show" onServerClick="ShowButton_Click"></td>
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
