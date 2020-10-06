<%@ Page Language="C#" %>
<!-- #Include File="../../../config/util.cs" -->
<%
	if(!IsAllowed(Request.ServerVariables["URL"], true))
	{
		Response.Redirect("../../../not_allowed.aspx");
	}
%>
<html>
<head>
<title>TIME REPORT - Usability report</title>
<LINK href="../../../css/main.css" rel="stylesheet" type="text/css">
<script type="text/javascript" src="../../../scripts/report.js"></script>
</head>
<script language="C#" runat="server">
	void Page_Load(Object sender, EventArgs e) 
	{
		string month = Request["month"];
		string year = Request["year"];
		string timeComparison = Request["time_comparison"];
					
		if(month.Equals("") || year.Equals("") || timeComparison.Equals(""))
		{
			Response.Redirect("select_usability_report.aspx");
		}
		else
		{
			if(Session["sql_connection_string"] != null)
			{
				DataSet pageData = null;
				
				PortalSqlClient sqlClient = new PortalSqlClient(Session["sql_connection_string"].ToString());
				
				sqlClient.UpdateDataSetWithStoredProcedure(ref pageData, "donezat_get_usability_report",
					"@month", month,
					"@year", year,
					"@time_comparison", timeComparison);
			
				Session["currentUsabilityReportPageData"] = pageData;
				
				ActualTextField.Value = pageData.Tables[0].Rows[0][0].ToString();
				PriorTextField.Value = pageData.Tables[1].Rows[0][0].ToString();
				TimeComparisonTextField.Value = timeComparison;
				
				int actualTotal = GetTotalUT(true);
				int priorTotal = GetTotalUT(false);
				
				TotalActualUTTextField.Value = actualTotal.ToString();
				TotalPriorUTTextField.Value = priorTotal.ToString();
				
				TotalVarUTTextField.Value = GetVar(actualTotal, priorTotal);
			}
		}
	}
	
	void ShowCurrentUsabilityReport()
	{
		string script = "";
		
		if(Session["currentUsabilityReportPageData"] != null)
		{
			DataSet pageData = (DataSet) Session["currentUsabilityReportPageData"];
			
			for(int i = 0; i < pageData.Tables[2].Rows.Count; i++)
			{
				DataRow currentAccountUse = pageData.Tables[2].Rows[i];
				
				int accountUseActual = GetAccountUseUT(currentAccountUse[0].ToString(), true);
				int accountUsePrior = GetAccountUseUT(currentAccountUse[0].ToString(), false);
				
				script += @"
<li><input name=""AccountUseTextField_" + i.ToString() + @""" type=""text"" class=""text_bold"" style=""width:326px;border-width:0px"" value=""" + currentAccountUse[1].ToString() + @""" readonly=""true"">
<input name=""AccountUseActualUTTextField_" + i.ToString() + @""" type=""text"" class=""text"" style=""width:100px;text-align=center;border-width:0px"" value=""" + accountUseActual.ToString() + @""" readonly=""true"">
<input name=""AccountUsePriorUTTextField_" + i.ToString() + @""" type=""text"" class=""text"" style=""width:100px;text-align=center;border-width:0px"" value=""" + accountUsePrior.ToString() + @""" readonly=""true"">
<input name=""AccountUseVarUTTextField_" + i.ToString() + @""" type=""text"" class=""text_bold"" style=""width:100px;text-align=center;border-width:0px"" value=""" + GetVar(accountUseActual, accountUsePrior) + @""" readonly=""true"">";
	
				string innerScript = "";
				
				for(int j = 0; j < pageData.Tables[3].Rows.Count; j++)
				{
					DataRow currentUser = pageData.Tables[3].Rows[j];
					
					int userActual = GetUserUT(currentAccountUse[0].ToString(), currentUser[0].ToString(), true);
					int userPrior = GetUserUT(currentAccountUse[0].ToString(), currentUser[0].ToString(), false);
				
					if((userActual != 0) || (userPrior != 0))
					{
						innerScript += @"
<li><input name=""UserTextField_" + i.ToString() + "_" + j.ToString() + @""" type=""text"" class=""text_bold"" style=""width:315px;border-width:0px"" value=""" + currentUser[1].ToString() + @""" readonly=""true"">
<input name=""UserActualUTTextField_" + i.ToString() + "_" + j.ToString() + @""" type=""text"" class=""text"" style=""width:100px;text-align=center;border-width:0px"" value=""" + userActual.ToString() + @""" readonly=""true"">
<input name=""UserPriorUTTextField_" + i.ToString() + "_" + j.ToString() + @""" type=""text"" class=""text"" style=""width:100px;text-align=center;border-width:0px"" value=""" + userPrior.ToString() + @""" readonly=""true"">
<input name=""UserVarUTTextField_" + i.ToString() + "_" + j.ToString() + @""" type=""text"" class=""text_bold"" style=""width:100px;text-align=center;border-width:0px"" value=""" + GetVar(userActual, userPrior) + @""" readonly=""true"">";
	
						string innerInnerScript = "";
						
						for(int k = 0; k < pageData.Tables[4].Rows.Count; k++)
						{
							DataRow currentAccount = pageData.Tables[4].Rows[k];
							
							int accountActual = GetAccountUT(currentAccountUse[0].ToString(), currentUser[0].ToString(), currentAccount[0].ToString(), true);
							int accountPrior = GetAccountUT(currentAccountUse[0].ToString(), currentUser[0].ToString(), currentAccount[0].ToString(), false);
						
							if((accountActual != 0) || (accountPrior != 0))
							{
								innerInnerScript += @"
<li><input name=""AccountTextField_" + i.ToString() + "_" + j.ToString() + @""" type=""text"" class=""text"" style=""width:305px;border-width:0px"" value=""" + currentAccount[1].ToString() + @""" readonly=""true"">
<input name=""AccountActualUTTextField_" + i.ToString() + "_" + j.ToString() + @""" type=""text"" class=""text"" style=""width:100px;text-align=center;border-width:0px"" value=""" + accountActual.ToString() + @""" readonly=""true"">
<input name=""AccountPriorUTTextField_" + i.ToString() + @""" type=""text"" class=""text"" style=""width:100px;text-align=center;border-width:0px"" value=""" + accountPrior.ToString() + @""" readonly=""true"">
<input name=""AccountVarUTTextField_" + i.ToString() + @""" type=""text"" class=""text_bold"" style=""width:100px;text-align=center;border-width:0px"" value=""" + GetVar(accountActual, accountPrior) + @""" readonly=""true""></li>";
							}
						}
						
						if(!innerInnerScript.Equals(""))
						{
							innerInnerScript = "<ul>" + innerInnerScript + "</ul>";
						}
	
						innerScript += innerInnerScript + "</li>";
					}
				}
				
				if(!innerScript.Equals(""))
				{
					innerScript = "<ul>" + innerScript + "</ul>";
				}
				
				script += innerScript + "</li>";
			}
		}
		
		Response.Write(script);
		
		WriteJavaScript("convertTrees()");
	}
	
	int GetAccountUseUT(string accountUseId, bool isActual)
	{
		int result = 0;
		
		if(Session["currentUsabilityReportPageData"] != null)
		{
			DataSet pageData = (DataSet) Session["currentUsabilityReportPageData"];
			DataTable currentTable;
			
			if(isActual)
			{
				currentTable = pageData.Tables[5];
			}
			else
			{
				currentTable = pageData.Tables[6];
			}
			
			for(int i = 0; i < currentTable.Rows.Count; i++)
			{
				DataRow currentRow = currentTable.Rows[i];
				
				if(currentRow[3].ToString().Equals(accountUseId))
				{
					int current = 0;
					
					try
					{
						current = Convert.ToInt32(currentRow[1].ToString());
						
						current = (current/60);
						
						result += current;
					}
					catch(FormatException)
					{
					
					}
					catch(OverflowException)
					{
					
					}
				}
			}
		}
	
		return result;
	}
	
	int GetUserUT(string accountUseId, string trigram, bool isActual)
	{
		int result = 0;
		
		if(Session["currentUsabilityReportPageData"] != null)
		{
			DataSet pageData = (DataSet) Session["currentUsabilityReportPageData"];
			DataTable currentTable;
			
			if(isActual)
			{
				currentTable = pageData.Tables[5];
			}
			else
			{
				currentTable = pageData.Tables[6];
			}
			
			for(int i = 0; i < currentTable.Rows.Count; i++)
			{
				DataRow currentRow = currentTable.Rows[i];
				
				if(currentRow[3].ToString().Equals(accountUseId) && currentRow[2].ToString().Equals(trigram))
				{
					int current = 0;
					
					try
					{
						current = Convert.ToInt32(currentRow[1].ToString());
						
						current = (current/60);
						
						result += current;
					}
					catch(FormatException)
					{
					
					}
					catch(OverflowException)
					{
					
					}
				}
			}
		}
	
		return result;
	}
	
	int GetAccountUT(string accountUseId, string trigram, string accountId, bool isActual)
	{
		int result = 0;
		
		if(Session["currentUsabilityReportPageData"] != null)
		{
			DataSet pageData = (DataSet) Session["currentUsabilityReportPageData"];
			DataTable currentTable;
			
			if(isActual)
			{
				currentTable = pageData.Tables[5];
			}
			else
			{
				currentTable = pageData.Tables[6];
			}
			
			for(int i = 0; i < currentTable.Rows.Count; i++)
			{
				DataRow currentRow = currentTable.Rows[i];
				
				if(currentRow[3].ToString().Equals(accountUseId) && currentRow[2].ToString().Equals(trigram) && currentRow[0].ToString().Equals(accountId))
				{
					int current = 0;
					
					try
					{
						current = Convert.ToInt32(currentRow[1].ToString());
						
						current = (current/60);
						
						result += current;
					}
					catch(FormatException)
					{
					
					}
					catch(OverflowException)
					{
					
					}
				}
			}
		}
	
		return result;
	}
	
	int GetTotalUT(bool isActual)
	{
		int result = 0;
		
		if(Session["currentUsabilityReportPageData"] != null)
		{
			DataSet pageData = (DataSet) Session["currentUsabilityReportPageData"];
			DataTable currentTable;
			
			if(isActual)
			{
				currentTable = pageData.Tables[5];
			}
			else
			{
				currentTable = pageData.Tables[6];
			}
			
			for(int i = 0; i < currentTable.Rows.Count; i++)
			{
				DataRow currentRow = currentTable.Rows[i];
				
				int current = 0;
					
				try
				{
					current = Convert.ToInt32(currentRow[1].ToString());
					
					current = (current/60);
					
					result += current;
				}
				catch(FormatException)
				{
				
				}
				catch(OverflowException)
				{
				
				}
			}
		}
	
		return result;
	}
	
	
	string GetVar(int actual, int prior)
	{
		if(actual < prior)
		{
			return "- " + (-(actual - prior)).ToString();
		}
		else if(actual > prior)
		{
			return "+ " + (actual - prior).ToString();
		}
		else if(actual == prior)
		{
			return "0";
		}
		else
		{
			return "N/A";
		}
	}
</script>
<body>
<form id="MainForm" method="post" runat="server">
<table width="676" border="0" cellspacing="0" cellpadding="0">
	<tr>
  		<td>
			<table width="676" border="0" cellspacing="0" cellpadding="0">
				<tr>
    				<td class="header">USABILITY REPORT</td>
  				</tr>
			</table>
		</td>
   	</tr>
	<tr>
    	<td height="5"></td>
  	</tr>
  <tr>
	  <td>
		<table width="676" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td width="100" class="text" align="left">Actual : </td>
			    <td width=""><input name="ActualTextField" type="text" class="text_bold" id="ActualTextField" style="width:300px;border-width:0px" runat="server" readonly="true"></td>
			</tr>
		</table>
	 </td>
    </tr>
  <tr>
    <td height="5"></td>
  </tr>
  <tr>
	  <td>
		<table width="676" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td width="100" class="text" align="left">Prior  : </td>
			    <td width=""><input name="PriorTextField" type="text" class="text_bold" id="PriorTextField" style="width:300px;border-width:0px" runat="server" readonly="true"></td>
			</tr>
		</table>
	 </td>
    </tr>
  <tr>
    <td height="5"></td>
  </tr>
  <tr>
	  <td>
		<table width="676" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td width="100" class="text" align="left">Time comparison   : </td>
			    <td width=""><input name="TimeComparisonTextField" type="text" class="text_bold" id="TimeComparisonTextField" style="width:150px;border-width:0px" runat="server" readonly="true"></td>
			</tr>
		</table>
	 </td>
    </tr>
  	<tr>
    	<td height="10"></td>
  	</tr>
	<tr>
		<td>
			<table width="676" cellspacing="0" cellpadding="0" class="datagrid_no_bottom">
				<tr>
					<td width="26" class="header"></td>
					<td width="335" class="header" align="center">TYPE - USER - ACCOUNT</td>
					<td width="105" class="header" align="center">Actual</td>
					<td width="105" class="header" align="center">Prior</td>
					<td width="105" class="header" align="center">VAR</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td>
<ul class="report" id="reportTree">
<%
ShowCurrentUsabilityReport();
%>
</ul>
		</td>
	</tr>
	<tr>
		<td>
			<table width="676" cellspacing="0" cellpadding="0" class="datagrid">
				<tr>
					<td width="26" class="header"></td>
					<td width="335" class="header" align="center">TOTAL</td>
					<td width="105"><input name="TotalActualUTTextField" type="text" class="text_bold" id="TotalActualUTTextField" style="width:105px;text-align=center;border-width:0px" runat="server" readonly="true"></td>
					<td width="105"><input name="TotalPriorUTTextField" type="text" class="text_bold" id="TotalPriorUTTextField" style="width:105px;text-align=center;border-width:0px" runat="server" readonly="true"></td>
					<td width="105"><input name="TotalVarUTTextField" type="text" class="text_bold" id="TotalVarUTTextField" style="width:105px;text-align=center;border-width:0px" runat="server" readonly="true"></td>
				</tr>
			</table>
		</td>
	</tr>
  <tr>
    <td height="10"></td>
  </tr>
  	<tr>
		<td>
			<table width="676" border="0" cellspacing="0" cellpadding="0">
				<tr>
    				<td width="200" class="text" align="center"><A HREF="show_usability_report.aspx" onClick="expandTree('reportTree'); return false;">Expand all</A></td>
					<td width="276"></td>
					<td width="200" class="text" align="center"><A HREF="show_usability_report.aspx" onClick="collapseTree('reportTree'); return false;">Collapse all</A></td>
  				</tr>
			</table>
		</td>
  	</tr>
	<tr>
	 <td height="10"></td>
	</tr>
	<tr>
	 <td><input name="InformationTextField" type="text" class="red" id="InformationTextField" style="width:676px;border-width:0px"
										runat="server" readonly="true"></td>
	</tr>
</table>
</form>
</body>
</html>
