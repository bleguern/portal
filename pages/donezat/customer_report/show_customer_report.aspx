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
		string customerId = Request["customer_id"];
					
		if(year.Equals("") || customerId.Equals(""))
		{
			Response.Redirect("select_customer_report.aspx");
		}
		else
		{
			if(Session["sql_connection_string"] != null)
			{
				////////////////////////
				string headerScript = "";
				////////////////////////
				
				DataSet pageData = null;
				
				PortalSqlClient sqlClient = new PortalSqlClient(Session["sql_connection_string"].ToString());
				
				sqlClient.UpdateDataSetWithStoredProcedure(ref pageData, "donezat_get_customer_report",
					"@year", year,
					"@customer_id", customerId);
				
				////////////////////////
				headerScript = GetHeaderScriptWithDataSet(pageData);
				WriteJavaScript(headerScript);
				////////////////////////
			
				Session["currentCustomerReportPageData"] = pageData;
				
				CustomerTextField.Value = pageData.Tables[0].Rows[0][0].ToString();
				YearTextField.Value = year;
				CurrentMonthlyYearTextField.Value = year;
				CurrentCumulativeYearTextField.Value = year;
			}
		}
	}
	
	void ShowCurrentMonthlyCustomerReport()
	{
		string script = "";
		
		if(Session["currentCustomerReportPageData"] != null)
		{
			DataSet pageData = (DataSet) Session["currentCustomerReportPageData"];
			
			for(int i = 0; i < pageData.Tables[1].Rows.Count; i++)
			{
				DataRow currentAccount = pageData.Tables[1].Rows[i];
				
				script += @"
<li><input name=""AccountTextField_" + i.ToString() + @""" type=""text"" class=""text_bold"" style=""width:176px;border-width:0px"" value=""" + currentAccount[1].ToString() + @""" readonly=""true"">
<input name=""AccountPriorTextField_" + i.ToString() + @""" type=""text"" class=""text_bold"" style=""width:35px;text-align=center;border-width:0px"" value=""" + GetAccountPriorUT(currentAccount[0].ToString()) + @""" readonly=""true"">
<input name=""AccountJanuaryTextField_" + i.ToString() + @""" type=""text"" class=""text"" style=""width:35px;text-align=center;border-width:0px"" value=""" + GetAccountUT(currentAccount[0].ToString(), 4) + @""" readonly=""true"">
<input name=""AccountFebruaryTextField_" + i.ToString() + @""" type=""text"" class=""text"" style=""width:35px;text-align=center;border-width:0px"" value=""" + GetAccountUT(currentAccount[0].ToString(), 5) + @""" readonly=""true"">
<input name=""AccountMarchTextField_" + i.ToString() + @""" type=""text"" class=""text"" style=""width:35px;text-align=center;border-width:0px"" value=""" + GetAccountUT(currentAccount[0].ToString(), 6) + @""" readonly=""true"">
<input name=""AccountAprilTextField_" + i.ToString() + @""" type=""text"" class=""text"" style=""width:35px;text-align=center;border-width:0px"" value=""" + GetAccountUT(currentAccount[0].ToString(), 7) + @""" readonly=""true"">
<input name=""AccountMayTextField_" + i.ToString() + @""" type=""text"" class=""text"" style=""width:35px;text-align=center;border-width:0px"" value=""" + GetAccountUT(currentAccount[0].ToString(), 8) + @""" readonly=""true"">
<input name=""AccountJuneTextField_" + i.ToString() + @""" type=""text"" class=""text"" style=""width:35px;text-align=center;border-width:0px"" value=""" + GetAccountUT(currentAccount[0].ToString(), 9) + @""" readonly=""true"">
<input name=""AccountJulyTextField_" + i.ToString() + @""" type=""text"" class=""text"" style=""width:35px;text-align=center;border-width:0px"" value=""" + GetAccountUT(currentAccount[0].ToString(), 10) + @""" readonly=""true"">
<input name=""AccountAugustTextField_" + i.ToString() + @""" type=""text"" class=""text"" style=""width:35px;text-align=center;border-width:0px"" value=""" + GetAccountUT(currentAccount[0].ToString(), 11) + @""" readonly=""true"">
<input name=""AccountSeptemberTextField_" + i.ToString() + @""" type=""text"" class=""text"" style=""width:35px;text-align=center;border-width:0px"" value=""" + GetAccountUT(currentAccount[0].ToString(), 12) + @""" readonly=""true"">
<input name=""AccountOctoberTextField_" + i.ToString() + @""" type=""text"" class=""text"" style=""width:35px;text-align=center;border-width:0px"" value=""" + GetAccountUT(currentAccount[0].ToString(), 13) + @""" readonly=""true"">
<input name=""AccountNovemberTextField_" + i.ToString() + @""" type=""text"" class=""text"" style=""width:35px;text-align=center;border-width:0px"" value=""" + GetAccountUT(currentAccount[0].ToString(), 14) + @""" readonly=""true"">
<input name=""AccountDecemberTextField_" + i.ToString() + @""" type=""text"" class=""text"" style=""width:35px;text-align=center;border-width:0px"" value=""" + GetAccountUT(currentAccount[0].ToString(), 15) + @""" readonly=""true"">
<input name=""AccountNextTextField_" + i.ToString() + @""" type=""text"" class=""text_bold"" style=""width:35px;text-align=center;border-width:0px"" value=""" + GetAccountNextUT(currentAccount[0].ToString()) + @""" readonly=""true"">
<input name=""AccountCurrentTextField_" + i.ToString() + @""" type=""text"" class=""text_bold"" style=""width:35px;text-align=center;border-width:0px"" value=""" + GetAccountCurrentUT(currentAccount[0].ToString()) + @""" readonly=""true"">
<input name=""AccountTotalTextField_" + i.ToString() + @""" type=""text"" class=""text_bold"" style=""width:35px;text-align=center;border-width:0px"" value=""" + GetAccountTotalUT(currentAccount[0].ToString()) + @""" readonly=""true"">";
	
				string innerScript = "";
				
				for(int j = 0; j < pageData.Tables[2].Rows.Count; j++)
				{
					DataRow currentUser = pageData.Tables[2].Rows[j];
					
					if(HasUserUT(currentAccount[0].ToString(), currentUser[0].ToString()))
					{
						innerScript += @"
<li><input name=""UserTextField_" + i.ToString() + @""" type=""text"" class=""text_bold"" style=""width:165px;border-width:0px"" value=""" + currentUser[1].ToString() + @""" readonly=""true"">
<input name=""UserPriorTextField_" + i.ToString() + @""" type=""text"" class=""text_bold"" style=""width:35px;text-align=center;border-width:0px"" value=""" + GetUserPriorUT(currentAccount[0].ToString(), currentUser[0].ToString()) + @""" readonly=""true"">
<input name=""UserJanuaryTextField_" + i.ToString() + @""" type=""text"" class=""text"" style=""width:35px;text-align=center;border-width:0px"" value=""" + GetUserUT(currentAccount[0].ToString(), currentUser[0].ToString(), 4) + @""" readonly=""true"">
<input name=""UserFebruaryTextField_" + i.ToString() + @""" type=""text"" class=""text"" style=""width:35px;text-align=center;border-width:0px"" value=""" + GetUserUT(currentAccount[0].ToString(), currentUser[0].ToString(), 5) + @""" readonly=""true"">
<input name=""UserMarchTextField_" + i.ToString() + @""" type=""text"" class=""text"" style=""width:35px;text-align=center;border-width:0px"" value=""" + GetUserUT(currentAccount[0].ToString(), currentUser[0].ToString(), 6) + @""" readonly=""true"">
<input name=""UserAprilTextField_" + i.ToString() + @""" type=""text"" class=""text"" style=""width:35px;text-align=center;border-width:0px"" value=""" + GetUserUT(currentAccount[0].ToString(), currentUser[0].ToString(), 7) + @""" readonly=""true"">
<input name=""UserMayTextField_" + i.ToString() + @""" type=""text"" class=""text"" style=""width:35px;text-align=center;border-width:0px"" value=""" + GetUserUT(currentAccount[0].ToString(), currentUser[0].ToString(), 8) + @""" readonly=""true"">
<input name=""UserJuneTextField_" + i.ToString() + @""" type=""text"" class=""text"" style=""width:35px;text-align=center;border-width:0px"" value=""" + GetUserUT(currentAccount[0].ToString(), currentUser[0].ToString(), 9) + @""" readonly=""true"">
<input name=""UserJulyTextField_" + i.ToString() + @""" type=""text"" class=""text"" style=""width:35px;text-align=center;border-width:0px"" value=""" + GetUserUT(currentAccount[0].ToString(), currentUser[0].ToString(), 10) + @""" readonly=""true"">
<input name=""UserAugustTextField_" + i.ToString() + @""" type=""text"" class=""text"" style=""width:35px;text-align=center;border-width:0px"" value=""" + GetUserUT(currentAccount[0].ToString(), currentUser[0].ToString(), 11) + @""" readonly=""true"">
<input name=""UserSeptemberTextField_" + i.ToString() + @""" type=""text"" class=""text"" style=""width:35px;text-align=center;border-width:0px"" value=""" + GetUserUT(currentAccount[0].ToString(), currentUser[0].ToString(), 12) + @""" readonly=""true"">
<input name=""UserOctoberTextField_" + i.ToString() + @""" type=""text"" class=""text"" style=""width:35px;text-align=center;border-width:0px"" value=""" + GetUserUT(currentAccount[0].ToString(), currentUser[0].ToString(), 13) + @""" readonly=""true"">
<input name=""UserNovemberTextField_" + i.ToString() + @""" type=""text"" class=""text"" style=""width:35px;text-align=center;border-width:0px"" value=""" + GetUserUT(currentAccount[0].ToString(), currentUser[0].ToString(), 14) + @""" readonly=""true"">
<input name=""UserDecemberTextField_" + i.ToString() + @""" type=""text"" class=""text"" style=""width:35px;text-align=center;border-width:0px"" value=""" + GetUserUT(currentAccount[0].ToString(), currentUser[0].ToString(), 15) + @""" readonly=""true"">
<input name=""UserNextTextField_" + i.ToString() + @""" type=""text"" class=""text_bold"" style=""width:35px;text-align=center;border-width:0px"" value=""" + GetUserNextUT(currentAccount[0].ToString(), currentUser[0].ToString()) + @""" readonly=""true"">
<input name=""UserCurrentTextField_" + i.ToString() + @""" type=""text"" class=""text_bold"" style=""width:35px;text-align=center;border-width:0px"" value=""" + GetUserCurrentUT(currentAccount[0].ToString(), currentUser[0].ToString()) + @""" readonly=""true"">
<input name=""UserTotalTextField_" + i.ToString() + @""" type=""text"" class=""text_bold"" style=""width:35px;text-align=center;border-width:0px"" value=""" + GetUserTotalUT(currentAccount[0].ToString(), currentUser[0].ToString()) + @""" readonly=""true""></li>";
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
	}
	
	void ShowCurrentCumulativeCustomerReport()
	{
		string script = "";
		
		if(Session["currentCustomerReportPageData"] != null)
		{
			DataSet pageData = (DataSet) Session["currentCustomerReportPageData"];
			
			for(int i = 0; i < pageData.Tables[1].Rows.Count; i++)
			{
				DataRow currentAccount = pageData.Tables[1].Rows[i];
				
				int januaryAccountUT = GetAccountUT(currentAccount[0].ToString(), 4);
				int februaryAccountUT = januaryAccountUT + GetAccountUT(currentAccount[0].ToString(), 5);
				int marchAccountUT = februaryAccountUT + GetAccountUT(currentAccount[0].ToString(), 6);
				int aprilAccountUT = marchAccountUT + GetAccountUT(currentAccount[0].ToString(), 7);
				int mayAccountUT = aprilAccountUT + GetAccountUT(currentAccount[0].ToString(), 8);
				int juneAccountUT = mayAccountUT + GetAccountUT(currentAccount[0].ToString(), 9);
				int julyAccountUT = juneAccountUT + GetAccountUT(currentAccount[0].ToString(), 10);
				int augustAccountUT = julyAccountUT + GetAccountUT(currentAccount[0].ToString(), 11);
				int septemberAccountUT = augustAccountUT + GetAccountUT(currentAccount[0].ToString(), 12);
				int octoberAccountUT = septemberAccountUT + GetAccountUT(currentAccount[0].ToString(), 13);
				int novemberAccountUT = octoberAccountUT + GetAccountUT(currentAccount[0].ToString(), 14);
				int decemberAccountUT = novemberAccountUT + GetAccountUT(currentAccount[0].ToString(), 15);
				
				script += @"
<li><input name=""AccountTextField_" + i.ToString() + @""" type=""text"" class=""text_bold"" style=""width:176px;border-width:0px"" value=""" + currentAccount[1].ToString() + @""" readonly=""true"">
<input name=""AccountPriorTextField_" + i.ToString() + @""" type=""text"" class=""text_bold"" style=""width:35px;text-align=center;border-width:0px"" value=""" + GetAccountPriorUT(currentAccount[0].ToString()).ToString() + @""" readonly=""true"">
<input name=""AccountJanuaryTextField_" + i.ToString() + @""" type=""text"" class=""text"" style=""width:35px;text-align=center;border-width:0px"" value=""" + januaryAccountUT.ToString() + @""" readonly=""true"">
<input name=""AccountFebruaryTextField_" + i.ToString() + @""" type=""text"" class=""text"" style=""width:35px;text-align=center;border-width:0px"" value=""" + februaryAccountUT.ToString() + @""" readonly=""true"">
<input name=""AccountMarchTextField_" + i.ToString() + @""" type=""text"" class=""text"" style=""width:35px;text-align=center;border-width:0px"" value=""" + marchAccountUT.ToString() + @""" readonly=""true"">
<input name=""AccountAprilTextField_" + i.ToString() + @""" type=""text"" class=""text"" style=""width:35px;text-align=center;border-width:0px"" value=""" + aprilAccountUT.ToString() + @""" readonly=""true"">
<input name=""AccountMayTextField_" + i.ToString() + @""" type=""text"" class=""text"" style=""width:35px;text-align=center;border-width:0px"" value=""" + mayAccountUT.ToString() + @""" readonly=""true"">
<input name=""AccountJuneTextField_" + i.ToString() + @""" type=""text"" class=""text"" style=""width:35px;text-align=center;border-width:0px"" value=""" + juneAccountUT.ToString() + @""" readonly=""true"">
<input name=""AccountJulyTextField_" + i.ToString() + @""" type=""text"" class=""text"" style=""width:35px;text-align=center;border-width:0px"" value=""" + julyAccountUT.ToString() + @""" readonly=""true"">
<input name=""AccountAugustTextField_" + i.ToString() + @""" type=""text"" class=""text"" style=""width:35px;text-align=center;border-width:0px"" value=""" + augustAccountUT.ToString() + @""" readonly=""true"">
<input name=""AccountSeptemberTextField_" + i.ToString() + @""" type=""text"" class=""text"" style=""width:35px;text-align=center;border-width:0px"" value=""" + septemberAccountUT.ToString() + @""" readonly=""true"">
<input name=""AccountOctoberTextField_" + i.ToString() + @""" type=""text"" class=""text"" style=""width:35px;text-align=center;border-width:0px"" value=""" + octoberAccountUT.ToString() + @""" readonly=""true"">
<input name=""AccountNovemberTextField_" + i.ToString() + @""" type=""text"" class=""text"" style=""width:35px;text-align=center;border-width:0px"" value=""" + novemberAccountUT.ToString() + @""" readonly=""true"">
<input name=""AccountDecemberTextField_" + i.ToString() + @""" type=""text"" class=""text"" style=""width:35px;text-align=center;border-width:0px"" value=""" + decemberAccountUT.ToString() + @""" readonly=""true"">
<input name=""AccountNextTextField_" + i.ToString() + @""" type=""text"" class=""text_bold"" style=""width:35px;text-align=center;border-width:0px"" value=""" + GetAccountNextUT(currentAccount[0].ToString()).ToString() + @""" readonly=""true"">
<input name=""AccountCurrentTextField_" + i.ToString() + @""" type=""text"" class=""text_bold"" style=""width:35px;text-align=center;border-width:0px"" value=""" + GetAccountCurrentUT(currentAccount[0].ToString()).ToString() + @""" readonly=""true"">
<input name=""AccountTotalTextField_" + i.ToString() + @""" type=""text"" class=""text_bold"" style=""width:35px;text-align=center;border-width:0px"" value=""" + GetAccountTotalUT(currentAccount[0].ToString()).ToString() + @""" readonly=""true"">";
	
				string innerScript = "";
				
				for(int j = 0; j < pageData.Tables[2].Rows.Count; j++)
				{
					DataRow currentUser = pageData.Tables[2].Rows[j];
					
					if(HasUserUT(currentAccount[0].ToString(), currentUser[0].ToString()))
					{
						int januaryUserUT = GetUserUT(currentAccount[0].ToString(), currentUser[0].ToString(), 4);
						int februaryUserUT = januaryUserUT + GetUserUT(currentAccount[0].ToString(), currentUser[0].ToString(), 5);
						int marchUserUT = februaryUserUT + GetUserUT(currentAccount[0].ToString(), currentUser[0].ToString(), 6);
						int aprilUserUT = marchUserUT + GetUserUT(currentAccount[0].ToString(), currentUser[0].ToString(), 7);
						int mayUserUT = aprilUserUT + GetUserUT(currentAccount[0].ToString(), currentUser[0].ToString(), 8);
						int juneUserUT = mayUserUT + GetUserUT(currentAccount[0].ToString(), currentUser[0].ToString(), 9);
						int julyUserUT = juneUserUT + GetUserUT(currentAccount[0].ToString(), currentUser[0].ToString(), 10);
						int augustUserUT = julyUserUT + GetUserUT(currentAccount[0].ToString(), currentUser[0].ToString(), 11);
						int septemberUserUT = augustUserUT + GetUserUT(currentAccount[0].ToString(), currentUser[0].ToString(), 12);
						int octoberUserUT = septemberUserUT + GetUserUT(currentAccount[0].ToString(), currentUser[0].ToString(), 13);
						int novemberUserUT = octoberUserUT + GetUserUT(currentAccount[0].ToString(), currentUser[0].ToString(), 14);
						int decemberUserUT = novemberUserUT + GetUserUT(currentAccount[0].ToString(), currentUser[0].ToString(), 15);
				
						innerScript += @"
<li><input name=""UserTextField_" + i.ToString() + @""" type=""text"" class=""text_bold"" style=""width:165px;border-width:0px"" value=""" + currentUser[1].ToString() + @""" readonly=""true"">
<input name=""UserPriorTextField_" + i.ToString() + @""" type=""text"" class=""text_bold"" style=""width:35px;text-align=center;border-width:0px"" value=""" + GetUserPriorUT(currentAccount[0].ToString(), currentUser[0].ToString()).ToString() + @""" readonly=""true"">
<input name=""UserJanuaryTextField_" + i.ToString() + @""" type=""text"" class=""text"" style=""width:35px;text-align=center;border-width:0px"" value=""" + januaryUserUT.ToString() + @""" readonly=""true"">
<input name=""UserFebruaryTextField_" + i.ToString() + @""" type=""text"" class=""text"" style=""width:35px;text-align=center;border-width:0px"" value=""" + februaryUserUT.ToString() + @""" readonly=""true"">
<input name=""UserMarchTextField_" + i.ToString() + @""" type=""text"" class=""text"" style=""width:35px;text-align=center;border-width:0px"" value=""" + marchUserUT.ToString() + @""" readonly=""true"">
<input name=""UserAprilTextField_" + i.ToString() + @""" type=""text"" class=""text"" style=""width:35px;text-align=center;border-width:0px"" value=""" + aprilUserUT.ToString() + @""" readonly=""true"">
<input name=""UserMayTextField_" + i.ToString() + @""" type=""text"" class=""text"" style=""width:35px;text-align=center;border-width:0px"" value=""" + mayUserUT.ToString() + @""" readonly=""true"">
<input name=""UserJuneTextField_" + i.ToString() + @""" type=""text"" class=""text"" style=""width:35px;text-align=center;border-width:0px"" value=""" + juneUserUT.ToString() + @""" readonly=""true"">
<input name=""UserJulyTextField_" + i.ToString() + @""" type=""text"" class=""text"" style=""width:35px;text-align=center;border-width:0px"" value=""" + julyUserUT.ToString() + @""" readonly=""true"">
<input name=""UserAugustTextField_" + i.ToString() + @""" type=""text"" class=""text"" style=""width:35px;text-align=center;border-width:0px"" value=""" + augustUserUT.ToString() + @""" readonly=""true"">
<input name=""UserSeptemberTextField_" + i.ToString() + @""" type=""text"" class=""text"" style=""width:35px;text-align=center;border-width:0px"" value=""" + septemberUserUT.ToString() + @""" readonly=""true"">
<input name=""UserOctoberTextField_" + i.ToString() + @""" type=""text"" class=""text"" style=""width:35px;text-align=center;border-width:0px"" value=""" + octoberUserUT.ToString() + @""" readonly=""true"">
<input name=""UserNovemberTextField_" + i.ToString() + @""" type=""text"" class=""text"" style=""width:35px;text-align=center;border-width:0px"" value=""" + novemberUserUT.ToString() + @""" readonly=""true"">
<input name=""UserDecemberTextField_" + i.ToString() + @""" type=""text"" class=""text"" style=""width:35px;text-align=center;border-width:0px"" value=""" + decemberUserUT.ToString() + @""" readonly=""true"">
<input name=""UserNextTextField_" + i.ToString() + @""" type=""text"" class=""text_bold"" style=""width:35px;text-align=center;border-width:0px"" value=""" + GetUserNextUT(currentAccount[0].ToString(), currentUser[0].ToString()).ToString() + @""" readonly=""true"">
<input name=""UserCurrentTextField_" + i.ToString() + @""" type=""text"" class=""text_bold"" style=""width:35px;text-align=center;border-width:0px"" value=""" + GetUserCurrentUT(currentAccount[0].ToString(), currentUser[0].ToString()).ToString() + @""" readonly=""true"">
<input name=""UserTotalTextField_" + i.ToString() + @""" type=""text"" class=""text_bold"" style=""width:35px;text-align=center;border-width:0px"" value=""" + GetUserTotalUT(currentAccount[0].ToString(), currentUser[0].ToString()).ToString() + @""" readonly=""true""></li>";
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
	}
	
	int GetAccountUT(string accountId, int tableIndex)
	{
		int result = 0;
		
		if(Session["currentCustomerReportPageData"] != null)
		{
			DataSet pageData = (DataSet) Session["currentCustomerReportPageData"];
			
			for(int i = 0; i < pageData.Tables[tableIndex].Rows.Count; i++)
			{
				DataRow currentRow = pageData.Tables[tableIndex].Rows[i];
				
				if(currentRow[0].ToString().Equals(accountId))
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
	
	int GetAccountPriorUT(string accountId)
	{
		return GetAccountUT(accountId, 3);
	}
	
	int GetAccountNextUT(string accountId)
	{
		return GetAccountUT(accountId, 16);
	}
	
	int GetAccountCurrentUT(string accountId)
	{
		return GetAccountUT(accountId, 17);
	}
	
	int GetAccountTotalUT(string accountId)
	{
		return GetAccountUT(accountId, 18);
	}
	
	int GetUserUT(string accountId, string trigram, int tableIndex)
	{
		int result = 0;
		
		if(Session["currentCustomerReportPageData"] != null)
		{
			DataSet pageData = (DataSet) Session["currentCustomerReportPageData"];
			
			for(int i = 0; i < pageData.Tables[tableIndex].Rows.Count; i++)
			{
				DataRow currentRow = pageData.Tables[tableIndex].Rows[i];
				
				if(currentRow[0].ToString().Equals(accountId)  && currentRow[2].ToString().Equals(trigram))
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
	
	int GetUserPriorUT(string accountId, string trigram)
	{
		return GetUserUT(accountId, trigram, 3);
	}
	
	int GetUserNextUT(string accountId, string trigram)
	{
		return GetUserUT(accountId, trigram, 16);
	}
	
	int GetUserCurrentUT(string accountId, string trigram)
	{
		return GetUserUT(accountId, trigram, 17);
	}
	
	int GetUserTotalUT(string accountId, string trigram)
	{
		return GetUserUT(accountId, trigram, 18);
	}
	
	bool HasUserUT(string accountId, string trigram)
	{
		if(Session["currentCustomerReportPageData"] != null)
		{
			DataSet pageData = (DataSet) Session["currentCustomerReportPageData"];
			
			for(int i = 0; i < pageData.Tables[18].Rows.Count; i++)
			{
				DataRow currentRow = pageData.Tables[18].Rows[i];
				
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
</script>
<body>
<form id="MainForm" method="post" runat="server">
<table width="850" border="0" cellspacing="0" cellpadding="0">
	<tr>
  		<td>
			<table width="850" border="0" cellspacing="0" cellpadding="0">
				<tr>
    				<td class="header">CUSTOMER REPORT</td>
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
				<td width="80" class="text">Customer  : </td>
			    <td width=""><input name="CustomerTextField" type="text" class="text_bold" id="CustomerTextField" style="width:150px;border-width:0px" runat="server" readonly="true"></td>
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
				<td width="80" class="text">Year  :</td>
			    <td width="100"><input name="YearTextField" type="text" class="text_bold" id="YearTextField" style="width:100px;border-width:0px" runat="server" readonly="true"></td>
				<td width="670"></td>
			</tr>
		</table>
	 </td>
    </tr>
  	<tr>
    	<td height="10"></td>
  	</tr>
	<tr>
  		<td>
			<table width="850" border="0" cellspacing="0" cellpadding="0">
				<tr>
    				<td class="header">MONTHLY</td>
  				</tr>
			</table>
		</td>
   	</tr>
	<tr>
    <td height="5"></td>
  </tr>
	<tr>
		<td>
			<table width="850" cellspacing="0" cellpadding="0" class="datagrid_no_bottom">
				<tr>
					<td width="26" class="header"></td>
					<td width="184" class="header" align="center">ACCOUNT - USER</td>
					<td width="40" class="header" align="center">PRIOR</td>
					<td width="40" class="header" align="center">Jan</td>
					<td width="40" class="header" align="center">Feb</td>
					<td width="40" class="header" align="center">Mar</td>
					<td width="40" class="header" align="center">Apr</td>
					<td width="40" class="header" align="center">May</td>
					<td width="40" class="header" align="center">Jun</td>
					<td width="40" class="header" align="center">Jul</td>
					<td width="40" class="header" align="center">Aug</td>
					<td width="40" class="header" align="center">Sep</td>
					<td width="40" class="header" align="center">Oct</td>
					<td width="40" class="header" align="center">Nov</td>
					<td width="40" class="header" align="center">Dec</td>
					<td width="40" class="header" align="center">NEXT</td>
					<td width="40" class="header" align="center"><input name="CurrentMonthlyYearTextField" type="text" class="header" id="CurrentMonthlyYearTextField" style="width:40px;border-width:0px;text-align:center" runat="server" readonly="true"></td>
					<td width="40" class="header" align="center">TOTAL</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td>
<ul class="report" id="monthlyReportTree">
<%
	ShowCurrentMonthlyCustomerReport();
%>
</ul>
		</td>
	</tr>
  <tr>
    <td height="10"></td>
  </tr>
  	<tr>
		<td>
			<table width="850" border="0" cellspacing="0" cellpadding="0">
				<tr>
    				<td width="300" class="text" align="center"><A HREF="show_customer_report.aspx" onClick="expandTree('monthlyReportTree'); return false;">Expand all</A></td>
					<td width="250"></td>
					<td width="300" class="text" align="center"><A HREF="show_customer_report.aspx" onClick="collapseTree('monthlyReportTree'); return false;">Collapse all</A></td>
  				</tr>
			</table>
		</td>
  	</tr>
	<tr>
	 <td height="10"></td>
	</tr>
	<tr>
  		<td>
			<table width="850" border="0" cellspacing="0" cellpadding="0">
				<tr>
    				<td class="header">CUMULATIVE</td>
  				</tr>
			</table>
		</td>
   	</tr>
	<tr>
    <td height="5"></td>
  </tr>
	<tr>
		<td>
			<table width="850" cellspacing="0" cellpadding="0" class="datagrid_no_bottom">
				<tr>
					<td width="26" class="header"></td>
					<td width="184" class="header" align="center">ACCOUNT - USER</td>
					<td width="40" class="header" align="center">PRIOR</td>
					<td width="40" class="header" align="center">Jan</td>
					<td width="40" class="header" align="center">Feb</td>
					<td width="40" class="header" align="center">Mar</td>
					<td width="40" class="header" align="center">Apr</td>
					<td width="40" class="header" align="center">May</td>
					<td width="40" class="header" align="center">Jun</td>
					<td width="40" class="header" align="center">Jul</td>
					<td width="40" class="header" align="center">Aug</td>
					<td width="40" class="header" align="center">Sep</td>
					<td width="40" class="header" align="center">Oct</td>
					<td width="40" class="header" align="center">Nov</td>
					<td width="40" class="header" align="center">Dec</td>
					<td width="40" class="header" align="center">NEXT</td>
					<td width="40" class="header" align="center"><input name="CurrentCumulativeYearTextField" type="text" class="header" id="CurrentCumulativeYearTextField" style="width:40px;border-width:0px;text-align:center" runat="server" readonly="true"></td>
					<td width="40" class="header" align="center">TOTAL</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td>
<ul class="report" id="cumulativeReportTree">
<%
	ShowCurrentCumulativeCustomerReport();
	
	WriteJavaScript("convertTrees()");
%>
</ul>
		</td>
	</tr>
  <tr>
    <td height="10"></td>
  </tr>
  	<tr>
		<td>
			<table width="850" border="0" cellspacing="0" cellpadding="0">
				<tr>
    				<td width="300" class="text" align="center"><A HREF="show_customer_report.aspx" onClick="expandTree('cumulativeReportTree'); return false;">Expand all</A></td>
					<td width="250"></td>
					<td width="300" class="text" align="center"><A HREF="show_customer_report.aspx" onClick="collapseTree('cumulativeReportTree'); return false;">Collapse all</A></td>
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
