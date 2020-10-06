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
<title>TIME REPORT - Use report</title>
<LINK href="../../../css/main.css" rel="stylesheet" type="text/css">
<script type="text/javascript" src="../../../scripts/report.js"></script>
</head>
<script language="C#" runat="server">
	void Page_Load(Object sender, EventArgs e) 
	{
		string sectorId = Request["sector_id"];
		string year = Request["year"];
		string beginMonth = Request["begin_month"];
		string endMonth = Request["end_month"];
					
		if(sectorId.Equals("") || year.Equals("") || beginMonth.Equals("") || endMonth.Equals(""))
		{
			Response.Redirect("select_use_report.aspx");
		}
		else
		{
			if(Session["sql_connection_string"] != null)
			{
				DataSet pageData = null;
				
				PortalSqlClient sqlClient = new PortalSqlClient(Session["sql_connection_string"].ToString());
				
				sqlClient.UpdateDataSetWithStoredProcedure(ref pageData, "donezat_get_use_report",
					"@id_sector", sectorId,
					"@year", year,
					"@begin_month", beginMonth,
					"@end_month", endMonth);
			
				Session["currentUseReportPageData"] = pageData;
				
				SectorTextField.Value = pageData.Tables[0].Rows[0][0].ToString();
				BeginDateTextField.Value = pageData.Tables[1].Rows[0][0].ToString();
				EndDateTextField.Value = pageData.Tables[2].Rows[0][0].ToString();
				
				TotalUTTextField.Value = GetTotalUT();
				TotalUTextField.Value = GetTotalU();
				TotalBTextField.Value = GetTotalB();
			}
		}
	}
	
	void ShowCurrentUseReport()
	{
		string script = "";
		
		if(Session["currentUseReportPageData"] != null)
		{
			DataSet pageData = (DataSet) Session["currentUseReportPageData"];
			
			for(int i = 0; i < pageData.Tables[3].Rows.Count; i++)
			{
				DataRow currentUser = pageData.Tables[3].Rows[i];
								
				script += @"
<li><input name=""UserTextField_" + i.ToString() + @""" type=""text"" class=""text_bold"" style=""width:326px;border-width:0px"" value=""" + currentUser[1].ToString() + @""" readonly=""true"">
<input name=""UserUTTextField_" + i.ToString() + @""" type=""text"" class=""text"" style=""width:100px;text-align=center;border-width:0px"" value=""" + GetUserUT(currentUser[0].ToString()) + @""" readonly=""true"">
<input name=""UserUTextField_" + i.ToString() + @""" type=""text"" class=""text"" style=""width:100px;text-align=center;border-width:0px"" value=""" + GetUserU(currentUser[0].ToString()) + @""" readonly=""true"">
<input name=""UserBTextField_" + i.ToString() + @""" type=""text"" class=""text"" style=""width:100px;text-align=center;border-width:0px"" value=""" + GetUserB(currentUser[0].ToString()) + @""" readonly=""true"">";
	
				string innerScript = "";
				
				for(int j = 0; j < pageData.Tables[4].Rows.Count; j++)
				{
					DataRow currentAccountUse = pageData.Tables[4].Rows[j];
					
					innerScript += @"
<li><input name=""AccountUseTextField_" + i.ToString() + "_" + j.ToString() + @""" type=""text"" class=""text_bold"" style=""width:316px;border-width:0px"" value=""" + currentAccountUse[1].ToString() + @""" readonly=""true"">
<input name=""AccountUseUTTextField_" + i.ToString() + "_" + j.ToString() + @""" type=""text"" class=""text"" style=""width:100px;text-align=center;border-width:0px"" value=""" + GetAccountUseUT(currentUser[0].ToString(), currentAccountUse[0].ToString()) + @""" readonly=""true"">";

					string innerInnerScript = "";
					
					for(int k = 0; k < pageData.Tables[5].Rows.Count; k++)
					{
						DataRow currentAccount = pageData.Tables[5].Rows[k];
						
						if(currentAccount[1].ToString().Equals(currentAccountUse[0].ToString()))
						{
							string accountUT = GetAccountUT(currentUser[0].ToString(), currentAccount[0].ToString());
							
							if(!accountUT.Equals("0"))
							{
								innerInnerScript += @"
<li><input name=""AccountTextField_" + i.ToString() + "_" + j.ToString() + @""" type=""text"" class=""text"" style=""width:306px;border-width:0px"" value=""" + currentAccount[2].ToString() + @""" readonly=""true"">
<input name=""AccountUTTextField_" + i.ToString() + "_" + j.ToString() + @""" type=""text"" class=""text"" style=""width:100px;text-align=center;border-width:0px"" value=""" + accountUT + @""" readonly=""true"">
<input name=""AccountUTextField_" + i.ToString() + @""" type=""text"" class=""text"" style=""width:100px;text-align=center;border-width:0px"" value=""" + GetAccountU(currentAccount[0].ToString()) + @""" readonly=""true"">
<input name=""AccountBTextField_" + i.ToString() + @""" type=""text"" class=""text"" style=""width:100px;text-align=center;border-width:0px"" value=""" + GetAccountB(currentAccount[0].ToString()) + @""" readonly=""true""></li>";
							}
						}
					}
					
					if(!innerInnerScript.Equals(""))
					{
						innerInnerScript = "<ul>" + innerInnerScript + "</ul>";
					}

					innerScript += innerInnerScript + "</li>";
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
	
	
	string GetUserUT(string trigram)
	{
		int result = 0;
		
		if(Session["currentUseReportPageData"] != null)
		{
			DataSet pageData = (DataSet) Session["currentUseReportPageData"];
			
			for(int i = 0; i < pageData.Tables[6].Rows.Count; i++)
			{
				DataRow currentRow = pageData.Tables[6].Rows[i];
				
				if(currentRow[2].ToString().Equals(trigram))
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
	
	
	string GetUserU(string trigram)
	{
		decimal result = 0;
		int total = 0;
		int uTotal = 0;
		
		if(Session["currentUseReportPageData"] != null)
		{
			DataSet pageData = (DataSet) Session["currentUseReportPageData"];
			
			for(int i = 0; i < pageData.Tables[6].Rows.Count; i++)
			{
				DataRow currentRow = pageData.Tables[6].Rows[i];
				
				if(currentRow[2].ToString().Equals(trigram))
				{
					int current = 0;
					
					try
					{
						current = Convert.ToInt32(currentRow[1].ToString());
						current = (current/60);
						
						total += current;
						
						if(currentRow[3].ToString().Equals("1"))
						{
							uTotal += current;
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
		
		if((total != 0) && (uTotal != 0))
		{
			result = ((decimal)total)/100;
			result = ((decimal)uTotal)/result;
		}
	
		return System.Math.Round(result, 2).ToString();
	}
	
	string GetUserB(string trigram)
	{
		decimal result = 0;
		int total = 0;
		int bTotal = 0;
		
		if(Session["currentUseReportPageData"] != null)
		{
			DataSet pageData = (DataSet) Session["currentUseReportPageData"];
			
			for(int i = 0; i < pageData.Tables[6].Rows.Count; i++)
			{
				DataRow currentRow = pageData.Tables[6].Rows[i];
				
				if(currentRow[2].ToString().Equals(trigram))
				{
					int current = 0;
					
					try
					{
						current = Convert.ToInt32(currentRow[1].ToString());
						current = (current/60);
						
						total += current;
						
						if(currentRow[4].ToString().Equals("1"))
						{
							bTotal += current;
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
		
		if((total != 0) && (bTotal != 0))
		{
			result = ((decimal)total)/100;
			result = ((decimal)bTotal)/result;
		}
	
		return System.Math.Round(result, 2).ToString();
	}
	
	string GetAccountUseUT(string trigram, string idAccountUse)
	{
		int result = 0;
		
		if(Session["currentUseReportPageData"] != null)
		{
			DataSet pageData = (DataSet) Session["currentUseReportPageData"];
			
			for(int i = 0; i < pageData.Tables[6].Rows.Count; i++)
			{
				DataRow currentRow = pageData.Tables[6].Rows[i];
				
				if(currentRow[2].ToString().Equals(trigram))
				{
					if(currentRow[5].ToString().Equals(idAccountUse))
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
		}
	
		return result.ToString();
	}
	
	string GetAccountUT(string trigram, string idAccount)
	{
		int result = 0;
		
		if(Session["currentUseReportPageData"] != null)
		{
			DataSet pageData = (DataSet) Session["currentUseReportPageData"];
			
			for(int i = 0; i < pageData.Tables[6].Rows.Count; i++)
			{
				DataRow currentRow = pageData.Tables[6].Rows[i];
				
				if(currentRow[2].ToString().Equals(trigram))
				{
					if(currentRow[0].ToString().Equals(idAccount))
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
		}
	
		return result.ToString();
	}
	
	string GetAccountU(string idAccount)
	{
		string result = "0";
		
		if(Session["currentUseReportPageData"] != null)
		{
			DataSet pageData = (DataSet) Session["currentUseReportPageData"];
			
			for(int i = 0; i < pageData.Tables[5].Rows.Count; i++)
			{
				DataRow currentRow = pageData.Tables[5].Rows[i];
				
				if(currentRow[0].ToString().Equals(idAccount))
				{
					result = currentRow[3].ToString();
					break;
				}
			}
		}
	
		return result;
	}
	
	string GetAccountB(string idAccount)
	{
		string result = "0";
		
		if(Session["currentUseReportPageData"] != null)
		{
			DataSet pageData = (DataSet) Session["currentUseReportPageData"];
			
			for(int i = 0; i < pageData.Tables[5].Rows.Count; i++)
			{
				DataRow currentRow = pageData.Tables[5].Rows[i];
				
				if(currentRow[0].ToString().Equals(idAccount))
				{
					result = currentRow[4].ToString();
					break;
				}
			}
		}
	
		return result;
	}
	
	
	string GetTotalUT()
	{
		int result = 0;
		
		if(Session["currentUseReportPageData"] != null)
		{
			DataSet pageData = (DataSet) Session["currentUseReportPageData"];
			
			for(int i = 0; i < pageData.Tables[6].Rows.Count; i++)
			{
				DataRow currentRow = pageData.Tables[6].Rows[i];
				
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
	
		return result.ToString();
	}
	
	string GetTotalU()
	{
		int result = 0;
		
		if(Session["currentUseReportPageData"] != null)
		{
			DataSet pageData = (DataSet) Session["currentUseReportPageData"];
			
			for(int i = 0; i < pageData.Tables[6].Rows.Count; i++)
			{
				DataRow currentRow = pageData.Tables[6].Rows[i];
				
				if(currentRow[3].ToString().Equals("1"))
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
	
	string GetTotalB()
	{
		int result = 0;
		
		if(Session["currentUseReportPageData"] != null)
		{
			DataSet pageData = (DataSet) Session["currentUseReportPageData"];
			
			for(int i = 0; i < pageData.Tables[6].Rows.Count; i++)
			{
				DataRow currentRow = pageData.Tables[6].Rows[i];
				
				if(currentRow[4].ToString().Equals("1"))
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
<table width="676" border="0" cellspacing="0" cellpadding="0">
	<tr>
  		<td>
			<table width="676" border="0" cellspacing="0" cellpadding="0">
				<tr>
    				<td class="header">USE REPORT</td>
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
				<td width="80" class="text" align="left">Division : </td>
			    <td width=""><input name="SectorTextField" type="text" class="text_bold" id="SectorTextField" style="width:100px;border-width:0px" runat="server" readonly="true"></td>
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
		<table width="676" border="0" cellspacing="0" cellpadding="0">
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
	<tr>
		<td>
			<table width="676" cellspacing="0" cellpadding="0" class="datagrid_no_bottom">
				<tr>
					<td width="26" class="header"></td>
					<td width="335" class="header" align="center">USER - TYPE - ACCOUNT</td>
					<td width="105" class="header" align="center">TU</td>
					<td width="105" class="header" align="center">% U</td>
					<td width="105" class="header" align="center">% B</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td>
<ul class="report" id="reportTree">
<%
ShowCurrentUseReport();
%>
</ul>
		</td>
	</tr>
  <tr>
    <td height="5"></td>
  </tr>
  	<tr>
		<td>
			<table width="676" border="0" cellspacing="0" cellpadding="0">
				<tr>
    				<td width="200" class="text" align="center"><A HREF="show_use_report.aspx" onClick="expandTree('reportTree'); return false;">Expand all</A></td>
					<td width="276"></td>
					<td width="200" class="text" align="center"><A HREF="show_use_report.aspx" onClick="collapseTree('reportTree'); return false;">Collapse all</A></td>
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
					<td width="335" class="header" align="center">TOTAL</td>
					<td width="105" class="header" align="center">TU</td>
					<td width="105" class="header" align="center">U</td>
					<td width="105" class="header" align="center">B</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td>
			<table width="676" cellspacing="0" cellpadding="0" class="datagrid_no_bottom">
				<tr>
					<td width="26"></td>
					<td width="335"></td>
					<td width="105" align="center"><input name="TotalUTTextField" type="text" class="text_bold" id="TotalUTTextField" style="width:105px;text-align=center;border-width:0px" runat="server" readonly="true"></td>
					<td width="105" align="center"><input name="TotalUTextField" type="text" class="text_bold" id="TotalUTextField" style="width:105px;text-align=center;border-width:0px" runat="server" readonly="true"></td>
					<td width="105" align="center"><input name="TotalBTextField" type="text" class="text_bold" id="TotalBTextField" style="width:105px;text-align=center;border-width:0px" runat="server" readonly="true"></td>
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
