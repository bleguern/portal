<%@ Page Language="C#" %>
<%@ Import namespace="System.Drawing" %>
<!-- #Include File="../../../config/util.cs" -->
<%
	if(!IsAllowed(Request.ServerVariables["URL"], true))
	{
		Response.Redirect("../../../not_allowed.aspx");
	}
	
	if(Request["user_id"].ToString().Equals(""))
	{
		Response.Redirect("select_show_report.aspx");
	}
%>
<html>
<head>
<title>TIME REPORT FOR USER : <%= Request["name"].ToString() %></title>
<link href="../../../css/main.css" rel="stylesheet" type="text/css">
<script type="text/javascript" src="../../../scripts/main.js"></script>
</head>
<script language="C#" runat="server">
	void Page_Load(Object sender, EventArgs e) 
	{
		if(Session["sql_connection_string"] != null)
		{
			PortalSqlClient sqlClient = new PortalSqlClient(Session["sql_connection_string"].ToString());
			
			if(!IsPostBack)
			{
				string beginDate = "";
				string status = "SAVABLE";
				
				if(Request["date"] == null)
				{
					beginDate = sqlClient.ExecuteStoredProcedure("donezat_get_monday_date",
						"@date", null);
						
					SetHmltSelectSelectedIndexByString(ref MonthSelect, DateTime.Now.Month.ToString());
					SetHmltSelectSelectedIndexByString(ref YearSelect, DateTime.Now.Year.ToString());
				}
				else
				{
					beginDate = sqlClient.ExecuteStoredProcedure("donezat_get_monday_date",
						"@date", Request["date"].ToString());
						
					try
					{
						DateTime date = Convert.ToDateTime(beginDate);
						
						SetHmltSelectSelectedIndexByString(ref MonthSelect, date.Month.ToString());
						SetHmltSelectSelectedIndexByString(ref YearSelect, date.Year.ToString());
					}
					catch(FormatException) {}
					catch(OverflowException) {}
				}
				
				DateHiddenField.Value = beginDate;
				DateTextField.Value = GetWeekString(beginDate);
			}
		}
	}
	
	void NextWeekButton_Click(Object sender, EventArgs e) 
	{
		DateTime next = GetDateFromString(DateHiddenField.Value);
		next = next.AddDays(7);
		
		Response.Redirect("show_show_report.aspx?date=" + next.ToShortDateString() + "&user_id=" + Request["user_id"].ToString() + "&name=" + Request["name"].ToString());
	}
	
	void PreviousWeekButton_Click(Object sender, EventArgs e) 
	{
		DateTime previous = GetDateFromString(DateHiddenField.Value);
		previous = previous.Subtract(new TimeSpan(7, 0, 0, 0));
		
		Response.Redirect("show_show_report.aspx?date=" + previous.ToShortDateString() + "&user_id=" + Request["user_id"].ToString() + "&name=" + Request["name"].ToString());
	}
	
	void GoToButton_Click(Object sender, EventArgs e) 
	{
		try
		{
			int month = Convert.ToInt32(MonthSelect.Value);
			int year = Convert.ToInt32(YearSelect.Value);
			
			DateTime goTo = new DateTime(year, month, 1);
			
			Response.Redirect("show_show_report.aspx?date=" + goTo.ToShortDateString() + "&user_id=" + Request["user_id"].ToString() + "&name=" + Request["name"].ToString());
		}
		catch(FormatException) {}
		catch(OverflowException) {}
	}
</script>
<body>
<form id="MainForm" method="post" runat="server">
<table width="850" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td class="header">TIME REPORT FOR USER : <%= Request["name"].ToString() %></td>
	</tr>
	<tr>
		<td height="10"></td>
	</tr>
	<tr>
		<td>
			<table width="850" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td width="100"><input name="PreviousWeekButton" class="text" type="submit" id="PreviousWeekButton" value="Previous week" runat="server" onServerClick="PreviousWeekButton_Click" alt="Go to previous week" style="width:100px" /></td>
					<td width="5"></td>
					<td width="100"><input name="NextWeekButton" class="text" type="submit" id="NextWeekButton" value="Next week" runat="server" onServerClick="NextWeekButton_Click" alt="Go to next week" style="width:100px" /></td>
					<td width="45"><input type="hidden" name="DateHiddenField" id="DateHiddenField" runat="server"></td>
					<td width="300"><input id="DateTextField" name="DateTextField" type="text" class="text_bold" runat="server" style="width:300px;border-width:0px;text-align:center" readonly="true"></td>
				  	<td align="right" width="65" class="text">Go to :</td>
					<td width="5"></td>
					<td width="200"><select id="MonthSelect" name="MonthSelect" size="1" class="text" style="width:120px"
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
			    </select><select id="YearSelect" name="YearSelect" size="1" class="text" style="width:80px"
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
				<td width="5"></td>
				<td width="25"><input name="GoToButton" class="text" type="submit" id="GoToButton" value="Go" runat="server" onServerClick="GoToButton_Click" alt="Go to date" style="width:25px" /></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
    	<td height="10"></td>
  	</tr>
	<tr>
		<td class="red_big_bold">WARNING : Time report not saved for this week !</td>
	</tr>
</table>
</form>
</body>
</html>
