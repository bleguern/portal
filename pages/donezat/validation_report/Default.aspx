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
<title>TIME REPORT - Validation report</title>
<LINK href="../../../css/main.css" rel="stylesheet" type="text/css">
<script type="text/javascript" src="../../../scripts/report.js"></script>
</head>
<script language="C#" runat="server">
	void Page_Load(Object sender, EventArgs e) 
	{
		if(Session["sql_connection_string"] != null)
		{
			DataSet pageData = null;
			
			PortalSqlClient sqlClient = new PortalSqlClient(Session["sql_connection_string"].ToString());
			sqlClient.UpdateDataSetWithStoredProcedure(ref pageData, "donezat_get_validation_report");
		
			Session["currentValidationReportPageData"] = pageData;
		}
	}
	
	
	void ShowCurrentValidationReport()
	{
		string script = "";
		
		if(Session["currentValidationReportPageData"] != null)
		{
			DataSet pageData = (DataSet) Session["currentValidationReportPageData"];
			
			for(int i = 0; i < pageData.Tables[0].Rows.Count; i++)
			{
				DataRow currentSector = pageData.Tables[0].Rows[i];
				string minSectorDate = GetMinSectorDate(currentSector[0].ToString());
				
				
				script += @"
<li><input name=""SectorTextField_" + i.ToString() + @""" type=""text"" class=""text_bold"" style=""width:150px;border-width:0px"" value=""" + currentSector[1].ToString() + @""" readonly=""true"">
<input name=""SectorDateTextField_" + i.ToString() + @""" type=""text"" class=""text"" style=""width:200px;text-align=center;border-width:0px"" value=""" + GetWeekString(minSectorDate) + @""" readonly=""true"">
<input name=""SectorDeltaTextField_" + i.ToString() + @""" type=""text"" class=""text_bold"" style=""width:90px;text-align=center;border-width:0px"" value=""" + GetLateWeeks(minSectorDate) + @""" readonly=""true"">";
	
				string innerScript = "";
				
				for(int j = 0; j < pageData.Tables[1].Rows.Count; j++)
				{
					DataRow currentUser = pageData.Tables[1].Rows[j];
					
					if(currentUser[1].ToString().Equals(currentSector[0].ToString()))
					{
						string minUserDate = GetMinUserDate(currentUser[0].ToString());
					
						innerScript += @"
<li><input name=""UserTextField_" + i.ToString() + "_" + j.ToString() + @""" type=""text"" class=""text"" style=""width:139px;border-width:0px"" value=""" + currentUser[2].ToString() + @""" readonly=""true"">
<input name=""UserDateTextField_" + i.ToString() + "_" + j.ToString() + @""" type=""text"" class=""text"" style=""width:200px;text-align=center;border-width:0px"" value=""" + GetWeekString(minUserDate) + @""" readonly=""true"">
<input name=""UserDeltaTextField_" + i.ToString() + "_" + j.ToString() + @""" type=""text"" class=""text_bold"" style=""width:90px;text-align=center;border-width:0px"" value=""" + GetLateWeeks(minUserDate) + @""" readonly=""true""></li>";
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
	
	
	string GetMinSectorDate(string sectorId)
	{
		DateTime minDate = new DateTime(9999, 12, 31);
		
		if(Session["currentValidationReportPageData"] != null)
		{
			DataSet pageData = (DataSet) Session["currentValidationReportPageData"];
			
			for(int i = 0; i < pageData.Tables[1].Rows.Count; i++)
			{
				DataRow currentUser = pageData.Tables[1].Rows[i];
				
				if(currentUser[1].ToString().Equals(sectorId))
				{
					for(int j = 0; j < pageData.Tables[2].Rows.Count; j++)
					{
						DataRow currentDate = pageData.Tables[2].Rows[j];
				
						if(currentDate[0].ToString().Equals(currentUser[0].ToString()))
						{
							try
							{
								DateTime current = Convert.ToDateTime(currentDate[1].ToString());
								
								if(current.CompareTo(minDate) < 0)
								{
									minDate = current;
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
			}
		}
		
		if(minDate.Equals(new DateTime(9999, 12, 31)))
		{
			return "";
		}
		else
		{
			return minDate.ToShortDateString();
		}
	}
	
	string GetMinUserDate(string userId)
	{
		if(Session["currentValidationReportPageData"] != null)
		{
			DataSet pageData = (DataSet) Session["currentValidationReportPageData"];
			
			for(int i = 0; i < pageData.Tables[2].Rows.Count; i++)
			{
				DataRow currentUser = pageData.Tables[2].Rows[i];
				
				if(currentUser[0].ToString().Equals(userId))
				{
					if(currentUser[1].ToString().Equals(""))
					{
						return "";
					}
					else
					{
						return currentUser[1].ToString();
					}
				}
			}
		}
		
		return "";
	}

	
	string GetLateWeeks(string dateString)
	{
		if((dateString == null) || (dateString.Equals("")))
		{
			return "N/A";
		}
		else
		{
			try
			{
				DateTime date = Convert.ToDateTime(dateString);
				DateTime now = DateTime.Now;
			
				int currentDow = Convert.ToInt32(now.DayOfWeek);
				
				if(currentDow == 0)
				{
					currentDow = 6;
				}
				else
				{
					currentDow -= 1;
				}
				
				now = now.Subtract(new TimeSpan(currentDow, 0, 0, 0));
				
				TimeSpan diff = now.Subtract(date);
				
				int lateWeeks = (diff.Days/7) - 1;
				
				if(lateWeeks < 0)
				{
					return "- " + (-lateWeeks).ToString();
				}
				else if(lateWeeks == 0)
				{
					return "0";
				}
				else
				{
					return lateWeeks.ToString();
				}
			}
			catch(FormatException)
			{
			
			}
			catch(OverflowException)
			{
			
			}
		}
		
		return "ERROR";
	}
</script>
<body>
<form id="MainForm" method="post" runat="server">
<table width="500" border="0" cellspacing="0" cellpadding="0">
	<tr>
  		<td>
			<table width="500" border="0" cellspacing="0" cellpadding="0">
				<tr>
    				<td class="header">VALIDATION REPORT</td>
  				</tr>
			</table>
		</td>
   	</tr>
	<tr>
	 <td height="5"></td>
	</tr>
	<tr>
		<td>
			<table width="500" cellspacing="0" cellpadding="0" class="datagrid_no_bottom">
				<tr>
					<td width="26" class="header"></td>
					<td width="150" class="header">DIVISION - USER</td>
					<td width="200" class="header" align="center">LAST VALIDATED WEEK </td>
					<td width="90" class="header">LATE WEEKS</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td>
<ul class="report" id="reportTree">
<%
ShowCurrentValidationReport();
%>
</ul>
		</td>
	</tr>
	<tr>
	 <td height="5"></td>
	</tr>
  	<tr>
		<td>
			<table width="500" border="0" cellspacing="0" cellpadding="0">
				<tr>
    				<td width="200" class="text" align="center"><A HREF="Default.aspx" onClick="expandTree('reportTree'); return false;">Expand all</A></td>
					<td width="100"></td>
					<td width="200" class="text" align="center"><A HREF="Default.aspx" onClick="collapseTree('reportTree'); return false;">Collapse all</A></td>
  				</tr>
			</table>
		</td>
  	</tr>
</table>
</form>
</body>
</html>
