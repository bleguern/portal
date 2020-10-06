<%@ Page Language="C#" %>
<!-- #Include File="../../../config/util.cs" -->
<html>
<head>
<title>TIME REPORT - Chargeable report</title>
<LINK href="../../../css/main.css" rel="stylesheet" type="text/css">
</head>
<script language="C#" runat="server">
	void Page_Load(Object sender, EventArgs e) 
	{
		if(!IsPostBack)
		{
			SetHmltSelectSelectedIndexByString(ref YearSelect, DateTime.Now.Year.ToString());
		}
	}
	
	void ShowButton_Click(Object sender, EventArgs e) {
		InformationTextField.Value = null;
		
		int begin = Convert.ToInt32(BeginMonthSelect.Value);
		int end = Convert.ToInt32(EndMonthSelect.Value);
		
		if(end < begin)
		{
			InformationTextField.Value = "WARNING : Begin month is smaller than end month!";
		}
		else
		{
			Response.Redirect("show_chargeable_report.aspx?year=" + YearSelect.Value +
				"&begin_month=" + BeginMonthSelect.Value +
				"&end_month=" + EndMonthSelect.Value);
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
    			<td class="header">SELECTION FOR CHARGEABLE REPORT</td>
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
			    <td width="100"><select id="YearSelect" name="YearSelect" size="1" class="text" style="width:100px"
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
				<td width="295"></td>
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
				<td width="100" class="text" align="left">Begin month : </td>
			    <td width="5"></td>
			    <td width="150"><select id="BeginMonthSelect" name="BeginMonthSelect" size="1" class="text" style="width:150px"
										runat="server">
			      <option value="1">January</option>
			      <option value="2">February</option>
			      <option value="3">March</option>
			      <option value="4">April</option>
			      <option value="5">May</option>
			      <option value="6">June</option>
			      <option value="7">July</option>
			      <option value="8">August</option>
			      <option value="9">September</option>
			      <option value="10">October</option>
			      <option value="11">November</option>
			      <option value="12">December</option>
			    </select></td>
				<td width="245"></td>
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
				<td width="100" class="text" align="left">End month : </td>
			    <td width="5"></td>
			    <td width="150"><select id="EndMonthSelect" name="EndMonthSelect" size="1" class="text" style="width:150px"
										runat="server">
			       <option value="1">January</option>
			      <option value="2">February</option>
			      <option value="3">March</option>
			      <option value="4">April</option>
			      <option value="5">May</option>
			      <option value="6">June</option>
			      <option value="7">July</option>
			      <option value="8">August</option>
			      <option value="9">September</option>
			      <option value="10">October</option>
			      <option value="11">November</option>
			      <option value="12">December</option>
			    </select></td>
				<td width="245"></td>
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
</table>
</form>
</body>
</html>
