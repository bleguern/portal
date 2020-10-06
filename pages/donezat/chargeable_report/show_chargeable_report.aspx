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
<title>TIME REPORT - Chargeable report</title>
<LINK href="../../../css/main.css" rel="stylesheet" type="text/css">
<script type="text/javascript" src="../../../scripts/report.js"></script>
</head>
<script language="C#" runat="server">
	void Page_Load(Object sender, EventArgs e) 
	{
		string year = Request["year"];
		string beginMonth = Request["begin_month"];
		string endMonth = Request["end_month"];
					
		if(year.Equals("") || beginMonth.Equals("") || endMonth.Equals(""))
		{
			Response.Redirect("select_chargeable_report.aspx");
		}
		else
		{
			if(Session["sql_connection_string"] != null)
			{
				DataSet pageData = null;
				
				PortalSqlClient sqlClient = new PortalSqlClient(Session["sql_connection_string"].ToString());
				
				sqlClient.UpdateDataSetWithStoredProcedure(ref pageData, "donezat_get_chargeable_report",
					"@year", year,
					"@begin_month", beginMonth,
					"@end_month", endMonth);
			
				Session["currentChargeableReportPageData"] = pageData;
				
				BeginDateTextField.Value = pageData.Tables[0].Rows[0][0].ToString();
				EndDateTextField.Value = pageData.Tables[1].Rows[0][0].ToString();
			}
		}
	}
	
	void ShowCurrentChargeableReport()
	{
		string script = "";
		
		if(Session["currentChargeableReportPageData"] != null)
		{
			DataSet pageData = (DataSet) Session["currentChargeableReportPageData"];
			
			int divisionNumber = pageData.Tables[2].Rows.Count;
			
			script += @"
<tr>
	<td>
		<table width=""850"" cellspacing=""0"" cellpadding=""0"" class=""datagrid_no_bottom"">
			<tr>
				<td width=""26"" class=""header""></td>
				<td width=""324"" class=""header"" align=""center"">DIVISION - USER - ACCOUNT</td>";
					
			for(int i = 0; i < divisionNumber; i++)
			{
				DataRow currentDivision = pageData.Tables[2].Rows[i];
				
				script += @"<td width=""" + (500/divisionNumber).ToString() + @""" class=""header"" align=""center"">" + currentDivision[1].ToString() + "</td>";
			}
			
			script += @"
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td>
<ul class=""report"" id=""reportTree"">
";

			for(int i = 0; i < divisionNumber; i++)
			{
				DataRow currentDivision = pageData.Tables[2].Rows[i];
								
				script += @"
<li><input name=""DivisionTextField_" + i.ToString() + @""" type=""text"" class=""text_bold"" style=""width:324px;border-width:0px"" value=""" + currentDivision[1].ToString() + @""" readonly=""true"">";

				for(int j = 0; j < divisionNumber; j++)
				{
					script += @"
<input name=""DivisionUTTextField_" + i.ToString() + @"_" + j.ToString() + @""" type=""text"" class=""text"" style=""width:" + ((500/divisionNumber)-6).ToString() + @"px;text-align=center;border-width:0px"" value=""" + GetDivisionUT(currentDivision[1].ToString(), pageData.Tables[2].Rows[j][0].ToString()) + @""" readonly=""true"">";
				}
				
				string innerScript = "";
				
				for(int j = 0; j < pageData.Tables[3].Rows.Count; j++)
				{
					DataRow currentUser = pageData.Tables[3].Rows[j];
					
					if(currentUser[2].ToString().Equals(currentDivision[0].ToString()))
					{
						innerScript += @"
<li><input name=""UserTextField_" + i.ToString() + "_" + j.ToString() + @""" type=""text"" class=""text_bold"" style=""width:313px;border-width:0px"" value=""" + currentUser[1].ToString() + @""" readonly=""true"">";
	
						for(int k = 0; k < divisionNumber; k++)
						{
							innerScript += @"
<input name=""UserUTTextField_" + i.ToString() + @"_" + j.ToString() + @"_" + k.ToString() + @""" type=""text"" class=""text"" style=""width:" + ((500/divisionNumber)-6).ToString() + @"px;text-align=center;border-width:0px"" value=""" + GetUserUT(currentUser[0].ToString(), pageData.Tables[2].Rows[k][0].ToString()) + @""" readonly=""true"">";
						}
	
						string innerInnerScript = "";
					
						for(int k = 0; k < pageData.Tables[4].Rows.Count; k++)
						{
							DataRow currentAccount = pageData.Tables[4].Rows[k];
							
							if(HasAccountUT(currentAccount[0].ToString(), currentUser[0].ToString()))
							{
								innerInnerScript += @"
	<li><input name=""AccountTextField_" + i.ToString() + "_" + j.ToString() + "_" + k.ToString() + @""" type=""text"" class=""text"" style=""width:303px;border-width:0px"" value=""" + currentAccount[1].ToString() + @""" readonly=""true"">";
		
								for(int l = 0; l < divisionNumber; l++)
								{
									innerInnerScript += @"
	<input name=""AccountUTTextField_" + i.ToString() + "_" + j.ToString() + "_" + k.ToString() + "_" + l.ToString() + @""" type=""text"" class=""text"" style=""width:" + ((500/divisionNumber)-6).ToString() + @"px;text-align=center;border-width:0px"" value=""" + GetAccountUT(currentAccount[0].ToString(), currentUser[0].ToString(), pageData.Tables[2].Rows[l][0].ToString()) + @""" readonly=""true"">";
								}
								
								innerInnerScript += "</li>";
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

			script += @"
</ul>
		</td>
	</tr>
	<tr>
		<td>
			<table width=""850"" cellspacing=""0"" cellpadding=""0"" class=""datagrid"">
				<tr>
					<td width=""26"" class=""header""></td>
					<td width=""324"" class=""header"" align=""center"">TOTAL</td>";
	
			for(int i = 0; i < divisionNumber; i++)
			{
				DataRow currentDivision = pageData.Tables[2].Rows[i];
				
				script += @"<td width=""" + (500/divisionNumber).ToString() + @""" class=""header"" align=""center"">" + GetTotalUT(currentDivision[0].ToString()) + "</td>";
			}
			
			script += @"
				</tr>
			</table>
		</td>
	</tr>";
	
		}
		
		Response.Write(script);
		
		WriteJavaScript("convertTrees()");
	}
	
	
	string GetDivisionUT(string fromDivisionString, string toDivisionId)
	{
		int result = 0;
		
		if(Session["currentChargeableReportPageData"] != null)
		{
			DataSet pageData = (DataSet) Session["currentChargeableReportPageData"];
			
			for(int i = 0; i < pageData.Tables[5].Rows.Count; i++)
			{
				DataRow currentRow = pageData.Tables[5].Rows[i];
				
				if(currentRow[3].ToString().Equals(fromDivisionString) && currentRow[4].ToString().Equals(toDivisionId))
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
	
		return result.ToString();
	}
	
	string GetUserUT(string trigram, string toDivisionId)
	{
		int result = 0;
		
		if(Session["currentChargeableReportPageData"] != null)
		{
			DataSet pageData = (DataSet) Session["currentChargeableReportPageData"];
			
			for(int i = 0; i < pageData.Tables[5].Rows.Count; i++)
			{
				DataRow currentRow = pageData.Tables[5].Rows[i];
				
				if(currentRow[2].ToString().Equals(trigram) && currentRow[4].ToString().Equals(toDivisionId))
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
	
		return result.ToString();
	}
	
	string GetAccountUT(string accountId, string trigram, string toDivisionId)
	{
		int result = 0;
		
		if(Session["currentChargeableReportPageData"] != null)
		{
			DataSet pageData = (DataSet) Session["currentChargeableReportPageData"];
			
			for(int i = 0; i < pageData.Tables[5].Rows.Count; i++)
			{
				DataRow currentRow = pageData.Tables[5].Rows[i];
				
				if(currentRow[0].ToString().Equals(accountId) && currentRow[2].ToString().Equals(trigram) && currentRow[4].ToString().Equals(toDivisionId))
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
	
		return result.ToString();
	}
	
	bool HasAccountUT(string accountId, string trigram)
	{
		if(Session["currentChargeableReportPageData"] != null)
		{
			DataSet pageData = (DataSet) Session["currentChargeableReportPageData"];
			
			for(int i = 0; i < pageData.Tables[5].Rows.Count; i++)
			{
				DataRow currentRow = pageData.Tables[5].Rows[i];
				
				if(currentRow[0].ToString().Equals(accountId) && currentRow[2].ToString().Equals(trigram))
				{
					int current = 0;
					
					try
					{
						current = Convert.ToInt32(currentRow[1].ToString());
						
						if(current > 0)
						{
							return true;
						}
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
	
		return false;
	}
	
	string GetTotalUT(string toDivisionId)
	{
		int result = 0;
		
		if(Session["currentChargeableReportPageData"] != null)
		{
			DataSet pageData = (DataSet) Session["currentChargeableReportPageData"];
			
			for(int i = 0; i < pageData.Tables[5].Rows.Count; i++)
			{
				DataRow currentRow = pageData.Tables[5].Rows[i];
				
				if(currentRow[4].ToString().Equals(toDivisionId))
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
	
		return result.ToString();
	}
</script>
<body>
<form id="MainForm" method="post" runat="server">
<table width="850" border="0" cellspacing="0" cellpadding="0">
	<tr>
  		<td>
			<table width="850" border="0" cellspacing="0" cellpadding="0">
				<tr>
    				<td class="header">CHARGEABLE REPORT</td>
  				</tr>
			</table>
		</td>
   	</tr>
  <tr>
    <td height="5"></td>
  </tr>
  <tr>
	  <td>
		<table width="850" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td width="80" class="text" align="left">Begin date  : </td>
			    <td width=""><input name="BeginDateTextField" type="text" class="text_bold" id="BeginDateTextField" style="width:150px;border-width:0px" runat="server" readonly="true"></td>
			</tr>
		</table>
	 </td>
    </tr>
  <tr>
    <td height="5"></td>
  </tr>
  <tr>
	  <td>
		<table width="850" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td width="80" class="text" align="left">End date  : </td>
			    <td width=""><input name="EndDateTextField" type="text" class="text_bold" id="EndDateTextField" style="width:150px;border-width:0px" runat="server" readonly="true"></td>
			</tr>
		</table>
	 </td>
    </tr>
  	<tr>
    	<td height="10"></td>
  	</tr>
<%
ShowCurrentChargeableReport();
%>
  <tr>
    <td height="10"></td>
  </tr>
  	<tr>
		<td>
			<table width="850" border="0" cellspacing="0" cellpadding="0">
				<tr>
    				<td width="300" class="text" align="center"><A HREF="show_chargeable_report.aspx" onClick="expandTree('reportTree'); return false;">Expand all</A></td>
					<td width="250"></td>
					<td width="300" class="text" align="center"><A HREF="show_chargeable_report.aspx" onClick="collapseTree('reportTree'); return false;">Collapse all</A></td>
  				</tr>
			</table>
		</td>
  	</tr>
	<tr>
	 <td height="10"></td>
	</tr>
	<tr>
	 <td><input name="InformationTextField" type="text" class="red" id="InformationTextField" style="width:850px;border-width:0px"
										runat="server" readonly="true"></td>
	</tr>
</table>
</form>
</body>
</html>
