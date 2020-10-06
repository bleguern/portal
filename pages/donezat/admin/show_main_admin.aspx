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
		Response.Redirect("select_admin.aspx");
	}
%>
<html>
<head>
<title>TIME REPORT ADMINISTRATION FOR USER : <%= Request["name"].ToString() %> - Main</title>
<link href="../../../css/main.css" rel="stylesheet" type="text/css">
<script type="text/javascript" src="../../../scripts/main.js"></script>
</head>
<script language="C#" runat="server">
	void Page_Load(Object sender, EventArgs e) 
	{
		RegisterHiddenField("__EVENTTARGET", "SaveButton");
	   
		if(Session["sql_connection_string"] != null)
		{
			string headerScript = "";
			DataSet pageData = null;
			
			PortalSqlClient sqlClient = new PortalSqlClient(Session["sql_connection_string"].ToString());
			
			if(Request["date"] == null)
			{
				sqlClient.UpdateDataSetWithStoredProcedure(ref pageData, "donezat_time_report_page_data_with_user_id",
					"@user_id", Request["user_id"].ToString(),
					"@begin_date", null);
			}
			else
			{
				sqlClient.UpdateDataSetWithStoredProcedure(ref pageData, "donezat_time_report_page_data_with_user_id",
					"@user_id", Request["user_id"].ToString(),
					"@begin_date", Request["date"].ToString());
			}
			
			headerScript = GetHeaderScriptWithDataSet(pageData);
			
			Session["currentTimeReportPageData"] = pageData;
		
			WriteJavaScript(headerScript);
			
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
				
				status = sqlClient.ExecuteStoredProcedure("donezat_get_time_report_status_with_user_id",
							"@user_id", Request["user_id"].ToString(),
							"@begin_date", beginDate);
				
				StatusTextField.Value = status;
				DateTextField.Value = GetWeekString(beginDate);
				
				if(status.Equals("SAVABLE"))
				{
					LoadDefaultTimeReportDataGrid();
				}
				else if((status.Equals("SAVED")) || (status.Equals("VALIDABLE")) || (status.Equals("VALIDATED")))
				{
					LoadTimeReportDataGrid();
				}
				
				UpdateAccountListDataGrid();
			}
			else
			{
				UpdateCurrentDataTable();
				UpdateTimeReportDataGrid();
			}
			
			Init();
		}
	}
	
	void Init()
	{
		string status = StatusTextField.Value;
		
		if(status.Equals("SAVABLE"))
		{
			SaveButton.Disabled = false;
			ValidateButton.Disabled = true;
		}
		else if(status.Equals("SAVED") || status.Equals("VALIDABLE"))
		{
			SaveButton.Disabled = false;
			ValidateButton.Disabled = false;
		}
		else if(status.Equals("VALIDATED"))
		{
			SaveButton.Disabled = true;
			ValidateButton.Disabled = false;
		}
		
		UpdateTotalFields();
		ShowNonWorkingDays();
	}
	
	void UpdateTotalFields()
	{
		int [] total = new int[7];
		
		for(int i = 0; i < TimeReportDataGrid.Items.Count; i++)
		{
			DataGridItem dataGridItem = TimeReportDataGrid.Items[i];

			HtmlInputText [] timeTextField = new HtmlInputText[7];
			
			for(int j = 0; j < 7; j++)
			{
				timeTextField[j] = (HtmlInputText) dataGridItem.FindControl("TimeTextField_" + j.ToString());
				
				if(!(timeTextField[j].Value.Equals("")))
				{
					total[j] += Int32.Parse(timeTextField[j].Value);
				}
			}
		}
		
		for(int i = 0; i < 7; i++)
		{
			HtmlInputText overTimeTextField = (HtmlInputText) FindControl("OverTimeTextField_" + i.ToString());
			
			if(i < 5)
			{
				HtmlInputText totalTextField = (HtmlInputText) FindControl("TotalTextField_" + i.ToString());
			
				if((total[i] >= 0) && (total[i] <= 8))
				{
					totalTextField.Value = total[i].ToString();
					overTimeTextField.Value = "0";
				}
				else if((total[i] >= 9) && (total[i] <= 24))
				{
					totalTextField.Value = "8";
					overTimeTextField.Value = (total[i] - 8).ToString();
				}
				else
				{
					totalTextField.Value = "#";
					overTimeTextField.Value = "#";
					InformationTextField.Value = "Time incorrect!";
				}
			}
			else
			{
				if((total[i] >= 0) && (total[i] <= 24))
				{
					overTimeTextField.Value = total[i].ToString();
				}
				else
				{
					overTimeTextField.Value = "#";
					InformationTextField.Value = "Time incorrect!";
				}
			}
		}
	}
	
	void ShowNonWorkingDays()
	{
		if(Session["currentTimeReportPageData"] != null)
		{
			DataSet pageData = (DataSet) Session["currentTimeReportPageData"];
			DateTime date = DateTime.Now;
			
			try
			{
				date = Convert.ToDateTime(DateHiddenField.Value);
			}
			catch(Exception)
			{
				return;
			}
		
			for(int i = 0; i < 7; i++)
			{
				for(int j = 0; j < pageData.Tables[3].Rows.Count; j++)
				{
					DataRow row = pageData.Tables[3].Rows[j];
					
					if(row[0].ToString().Equals(date.AddDays(i).ToShortDateString()))
					{
						TimeReportDataGrid.Columns[2+i].ItemStyle.CssClass = "non_working_day";
						TimeReportDataGrid.Columns[2+i].HeaderStyle.ForeColor = Color.LightGray;
						
						for(int k = 0; k < TimeReportDataGrid.Items.Count; k++)
						{
							HtmlInputText timeTextField = (HtmlInputText) TimeReportDataGrid.Items[k].FindControl("TimeTextField_" + i.ToString());
							timeTextField.Attributes["class"] = "non_working_day";

							DropDownList typeDropDownList = (DropDownList) TimeReportDataGrid.Items[k].FindControl("TypeSelect_" + i.ToString());
							typeDropDownList.CssClass = "non_working_day_select";
						}
								
						break;
					}
				}
			}
		}
	}
	
	void NextWeekButton_Click(Object sender, EventArgs e) 
	{
		DateTime next = GetDateFromString(DateHiddenField.Value);
		next = next.AddDays(7);
		
		Response.Redirect("show_main_admin.aspx?date=" + next.ToShortDateString() + "&user_id=" + Request["user_id"].ToString() + "&name=" + Request["name"].ToString());
	}
	
	void PreviousWeekButton_Click(Object sender, EventArgs e) 
	{
		DateTime previous = GetDateFromString(DateHiddenField.Value);
		previous = previous.Subtract(new TimeSpan(7, 0, 0, 0));
		
		Response.Redirect("show_main_admin.aspx?date=" + previous.ToShortDateString() + "&user_id=" + Request["user_id"].ToString() + "&name=" + Request["name"].ToString());
	}
	
	void GoToButton_Click(Object sender, EventArgs e) 
	{
		try
		{
			int month = Convert.ToInt32(MonthSelect.Value);
			int year = Convert.ToInt32(YearSelect.Value);
			
			DateTime goTo = new DateTime(year, month, 1);
			
			Response.Redirect("show_main_admin.aspx?date=" + goTo.ToShortDateString() + "&user_id=" + Request["user_id"].ToString() + "&name=" + Request["name"].ToString());
		}
		catch(FormatException) {}
		catch(OverflowException) {}
	}
	
	void SaveButton_Click(Object sender, EventArgs e) 
	{
		if(Session["sql_connection_string"] != null)
		{	
			UpdateCurrentDataTable();
			
			PortalSqlClient sqlClient = new PortalSqlClient(Session["sql_connection_string"].ToString());
			
			DataTable currentTimeReport = (DataTable) Session["currentTimeReport"];
			string beginDate = GetValueFromHtmlInputHidden(DateHiddenField);
			string status = GetValueFromHtmlInputText(StatusTextField, true);
			
			if(status.Equals("SAVED") || status.Equals("VALIDABLE") || status.Equals("VALIDATED"))
			{
				string result = sqlClient.ExecuteStoredProcedure("donezat_delete_week_activity_with_user_id",
					"@user_id", Request["user_id"].ToString(),
					"@begin_date", beginDate);
									
				if(result == null)
				{
					InformationTextField.Value = "Internal error while updating time report!";
					return;
				}
			}
			
			bool success = false;
					
			foreach(DataRow row in currentTimeReport.Rows)
			{
				if(!(row[1].ToString().Equals("")))
				{
					string newId = sqlClient.ExecuteStoredProcedure("donezat_add_week_activity_with_user_id",
						"@user_id",Request["user_id"].ToString(),
						"@id_account", GetValueFromRequest(row[1]),
						"@begin_date", beginDate,
						"@monday_time", GetValueFromRequest(row[2]),
						"@monday_type", GetValueFromRequest(row[3]),
						"@tuesday_time", GetValueFromRequest(row[4]),
						"@tuesday_type", GetValueFromRequest(row[5]),
						"@wednesday_time", GetValueFromRequest(row[6]),
						"@wednesday_type", GetValueFromRequest(row[7]),
						"@thursday_time", GetValueFromRequest(row[8]),
						"@thursday_type", GetValueFromRequest(row[9]),
						"@friday_time", GetValueFromRequest(row[10]),
						"@friday_type", GetValueFromRequest(row[11]),
						"@saturday_time", GetValueFromRequest(row[12]),
						"@saturday_type", GetValueFromRequest(row[13]),
						"@sunday_time", GetValueFromRequest(row[14]),
						"@sunday_type", GetValueFromRequest(row[15]));
			
					if(newId == null)
					{
						success = false;
						break;
					}
					else
					{
						success = true;
					}
				}
			}
			
			if(success)
			{
				InformationTextField.Value = "Time report saved!";
			}
			
			status = sqlClient.ExecuteStoredProcedure("donezat_get_time_report_status_with_user_id",
				"@user_id", Request["user_id"].ToString(),
				"@begin_date", beginDate);
			
			if(status != null)
			{
				StatusTextField.Value = status;
				Init();
			}
		}
	}
	
	void ValidateButton_Click(Object sender, EventArgs e) 
	{
		if(Session["sql_connection_string"] != null)
		{
			UpdateCurrentDataTable();
			
			PortalSqlClient sqlClient = new PortalSqlClient(Session["sql_connection_string"].ToString());
			
			DataTable currentTimeReport = (DataTable) Session["currentTimeReport"];
			string status = GetValueFromHtmlInputText(StatusTextField, true);
			string beginDate = GetValueFromHtmlInputHidden(DateHiddenField);
			string result = "";
			
			if(status.Equals("SAVED") || status.Equals("VALIDABLE") || status.Equals("VALIDATED"))
			{
				result = sqlClient.ExecuteStoredProcedure("donezat_delete_week_activity_with_user_id",
					"@user_id", Request["user_id"].ToString(),
					"@begin_date", beginDate);
									
				if(result == null)
				{
					InformationTextField.Value = "Internal error while updating time report!";
					return;
				}
			}
			
			foreach(DataRow row in currentTimeReport.Rows)
			{
				if(!(row[1].ToString().Equals("")))
				{
					string newId = sqlClient.ExecuteStoredProcedure("donezat_add_week_activity_with_user_id",
						"@user_id",Request["user_id"].ToString(),
						"@id_account", GetValueFromRequest(row[1]),
						"@begin_date", beginDate,
						"@monday_time", GetValueFromRequest(row[2]),
						"@monday_type", GetValueFromRequest(row[3]),
						"@tuesday_time", GetValueFromRequest(row[4]),
						"@tuesday_type", GetValueFromRequest(row[5]),
						"@wednesday_time", GetValueFromRequest(row[6]),
						"@wednesday_type", GetValueFromRequest(row[7]),
						"@thursday_time", GetValueFromRequest(row[8]),
						"@thursday_type", GetValueFromRequest(row[9]),
						"@friday_time", GetValueFromRequest(row[10]),
						"@friday_type", GetValueFromRequest(row[11]),
						"@saturday_time", GetValueFromRequest(row[12]),
						"@saturday_type", GetValueFromRequest(row[13]),
						"@sunday_time", GetValueFromRequest(row[14]),
						"@sunday_type", GetValueFromRequest(row[15]));
			
					if(newId == null)
					{
						break;
					}
				}
			}
			
			result = sqlClient.ExecuteStoredProcedure("donezat_validate_time_report_with_user_id",
				"@user_id", Request["user_id"].ToString(),
				"@begin_date", beginDate);
			
			if(result == null)
			{
				InformationTextField.Value = "Internal error while validating time report!";
			}
			else
			{
				InformationTextField.Value = "Time report validated!";
				
				status = sqlClient.ExecuteStoredProcedure("donezat_get_time_report_status_with_user_id",
					"@user_id", Request["user_id"].ToString(),
					"@begin_date", beginDate);
			
				if(status != null)
				{
					StatusTextField.Value = status;
					Init();
				}
			}
		}
	}
	
	void AddLineButton_Click(Object sender, EventArgs e) 
	{
		if(Session["sql_connection_string"] != null)
		{
			PortalSqlClient sqlClient = new PortalSqlClient(Session["sql_connection_string"].ToString());
			
			string newId = sqlClient.ExecuteStoredProcedure("donezat_get_next_time_report_id");
			
			if(newId == null)
			{
				InformationTextField.Value = "Internal error while adding a new line!";
			}
			else
			{
				UpdateCurrentDataTable();

				DataTable currentTimeReport = (DataTable) Session["currentTimeReport"];
				
				DataRow row = currentTimeReport.NewRow();
				
				row[0] = GetIntDbTypeFromString(newId);
				currentTimeReport.Rows.Add(row);
			
				Session["currentTimeReport"] = currentTimeReport;
				
				LineNumberHiddenField.Value = currentTimeReport.Rows.Count.ToString();
			
				UpdateTimeReportDataGrid();
			
				InformationTextField.Value = "Line added!";
				
				ShowNonWorkingDays();
			}
		}
	}
	
	int GetTypeIndex(string dataValue)
	{
		DataSet pageData = (DataSet) Session["currentTimeReportPageData"];
		
		for(int i = 0; i < pageData.Tables[1].Rows.Count; i++)
		{
			DataRow row = pageData.Tables[1].Rows[i];
			
			if(row[0].ToString().Equals(dataValue))
			{
				return i+1;
			}
		}
		
		return 0;
	}

	int GetAccountIndex(string dataValue)
	{
		DataSet pageData = (DataSet) Session["currentTimeReportPageData"];
		
		for(int i = 0; i < pageData.Tables[2].Rows.Count; i++)
		{
			DataRow row = pageData.Tables[2].Rows[i];
			
			if(row[0].ToString().Equals(dataValue))
			{
				return i+1;
			}
		}
		
		return 0;
	}
	
	void UpdateCurrentDataTable()
	{
		DataTable currentTimeReport = (DataTable) Session["currentTimeReport"];

		currentTimeReport.Rows.Clear();

		for(int i = 0; i < TimeReportDataGrid.Items.Count; i++)
		{
			DataGridItem dataGridItem = TimeReportDataGrid.Items[i];

			DropDownList accountDropDownList = (DropDownList)dataGridItem.FindControl("AccountSelect");

			HtmlInputText [] timeTextField = new HtmlInputText[7];
			DropDownList [] typeDropDownList = new DropDownList[7];

			for(int j = 0; j < 7; j++)
			{
				timeTextField[j] = (HtmlInputText)dataGridItem.FindControl("TimeTextField_" + j.ToString());
				typeDropDownList[j] = (DropDownList)dataGridItem.FindControl("TypeSelect_" + j.ToString());
			}

			DataRow newRow = currentTimeReport.NewRow();
			newRow[0] = TimeReportDataGrid.DataKeys[i];
			newRow[1] = GetIntDbTypeFromString(accountDropDownList.SelectedValue);

			for(int k = 2; k < 16; k += 2)
			{
				newRow[k] = GetIntDbTypeFromString(timeTextField[(k-2)/2].Value);
				newRow[k+1] = GetIntDbTypeFromString(typeDropDownList[(k-2)/2].SelectedValue);
			}

			currentTimeReport.Rows.Add(newRow);
		}
		
		Session["currentTimeReport"] = currentTimeReport;
	}

	void UpdateTimeReportDataGrid()
	{
		DataTable currentTimeReport = (DataTable) Session["currentTimeReport"];

		TimeReportDataGrid.DataSource = currentTimeReport;
		TimeReportDataGrid.DataBind();
	}
	
	void UpdateAccountListDataGrid()
    {
       	if(Session["sql_connection_string"] != null)
		{
			string beginDate = DateHiddenField.Value;
			
			PortalSqlClient sqlClient = new PortalSqlClient(Session["sql_connection_string"].ToString());
			
			sqlClient.UpdateDataGridWithStoredProcedure(ref AccountListDataGrid, "donezat_get_current_account_list_with_user_id",
				"@user_id", Request["user_id"].ToString(),
				"@begin_date", beginDate);
		}
    }
	
	void LoadTimeReportDataGrid()
	{
		if(Session["sql_connection_string"] != null)
		{
			string beginDate = DateHiddenField.Value;
			DataSet currentTimeReportDataSet = null;
			
			PortalSqlClient sqlClient = new PortalSqlClient(Session["sql_connection_string"].ToString());
			
			sqlClient.UpdateDataSetWithStoredProcedure(ref currentTimeReportDataSet, "donezat_get_saved_time_report_with_user_id",
				"@user_id", Request["user_id"].ToString(),
				"@begin_date", beginDate);
				
			if(currentTimeReportDataSet != null)
			{
				Session["currentTimeReport"] = currentTimeReportDataSet.Tables[0];
				LineNumberHiddenField.Value = currentTimeReportDataSet.Tables[0].Rows.Count.ToString();
			}

			UpdateTimeReportDataGrid();
		}
	}

	void LoadDefaultTimeReportDataGrid()
	{
		int lineNumber = 0;

		try
		{
			lineNumber = Convert.ToInt32(LineNumberHiddenField.Value);
		}
		catch(FormatException)
		{

		}
		catch(OverflowException)
		{

		}

		DataTable dataTable = new DataTable();
		DataColumn dataColumn = new DataColumn("ID");
		dataTable.Columns.Add(dataColumn);
		dataColumn = new DataColumn("ACCOUNT");
		dataTable.Columns.Add(dataColumn);
		dataColumn = new DataColumn("MONDAY_TIME");
		dataTable.Columns.Add(dataColumn);
		dataColumn = new DataColumn("MONDAY_TYPE");
		dataTable.Columns.Add(dataColumn);
		dataColumn = new DataColumn("TUESDAY_TIME");
		dataTable.Columns.Add(dataColumn);
		dataColumn = new DataColumn("TUESDAY_TYPE");
		dataTable.Columns.Add(dataColumn);
		dataColumn = new DataColumn("WEDNESDAY_TIME");
		dataTable.Columns.Add(dataColumn);
		dataColumn = new DataColumn("WEDNESDAY_TYPE");
		dataTable.Columns.Add(dataColumn);
		dataColumn = new DataColumn("THURSDAY_TIME");
		dataTable.Columns.Add(dataColumn);
		dataColumn = new DataColumn("THURSDAY_TYPE");
		dataTable.Columns.Add(dataColumn);
		dataColumn = new DataColumn("FRIDAY_TIME");
		dataTable.Columns.Add(dataColumn);
		dataColumn = new DataColumn("FRIDAY_TYPE");
		dataTable.Columns.Add(dataColumn);
		dataColumn = new DataColumn("SATURDAY_TIME");
		dataTable.Columns.Add(dataColumn);
		dataColumn = new DataColumn("SATURDAY_TYPE");
		dataTable.Columns.Add(dataColumn);
		dataColumn = new DataColumn("SUNDAY_TIME");
		dataTable.Columns.Add(dataColumn);
		dataColumn = new DataColumn("SUNDAY_TYPE");
		dataTable.Columns.Add(dataColumn);

		for(int i = 0; i < lineNumber; i++)
		{
			DataRow row = dataTable.NewRow();
			row[0] = i;
			dataTable.Rows.Add(row);
		}

		Session["currentTimeReport"] = dataTable;

		UpdateTimeReportDataGrid();
	}
	
	void TimeReportDataGrid_ItemCreated(object sender, System.Web.UI.WebControls.DataGridItemEventArgs e)
	{
		if((e.Item.ItemType != ListItemType.Header) && (e.Item.ItemType != ListItemType.Footer))
		{
			if(Session["currentTimeReportPageData"] != null)
			{
				DataSet pageData = (DataSet) Session["currentTimeReportPageData"];
				
				DropDownList accountDropDownList = (DropDownList)e.Item.FindControl("AccountSelect");
				DropDownList [] typeDropDownList = new DropDownList[7];
	
				UpdateDropDownListWithDataTable(ref accountDropDownList, pageData.Tables[2]);
	
				for(int i = 0; i < 7; i++)
				{
					typeDropDownList[i] = (DropDownList)e.Item.FindControl("TypeSelect_" + i.ToString());
					
					UpdateDropDownListWithDataTable(ref typeDropDownList[i], pageData.Tables[1]);
				}
			}
		}
	}
</script>
<body>
<form id="MainForm" method="post" runat="server" onClick="onTimeReportFormClick(LineNumberHiddenField.value, InformationTextField)">
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
					<td width="45"></td>
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
  	<td>
	<ASP:DataGrid id="TimeReportDataGrid" runat="server"
      Width="850"
      BackColor="#FFFFFF"
      BorderColor="black"
      ShowFooter="false"
      CellPadding="1"
      CellSpacing="0"
      Font-Name="Verdana"
      Font-Size="8pt"
      HeaderStyle-BackColor="#DE0029"
	  HeaderStyle-ForeColor="#FFFFFF"
	  HeaderStyle-Font-Bold="true"
      DataKeyField="ID"
      AutoGenerateColumns="false"
	  OnItemCreated="TimeReportDataGrid_ItemCreated"
    >
      <Columns>
	  	 <asp:BoundColumn HeaderText="ID" SortExpression="ID" Visible="false" DataField="ID"/>
	  	 <asp:TemplateColumn HeaderText="ACCOUNT" HeaderStyle-Width="134" HeaderStyle-HorizontalAlign="center" ItemStyle-HorizontalAlign="center">
          <ItemTemplate>
		  	<asp:DropDownList runat="server" Width="132" SelectedIndex='<%# GetAccountIndex(DataBinder.Eval(Container.DataItem, "ACCOUNT").ToString()) %>' id="AccountSelect"></asp:DropDownList>
          </ItemTemplate>
        </asp:TemplateColumn>
		<asp:TemplateColumn HeaderText="Monday" HeaderStyle-Width="98" HeaderStyle-HorizontalAlign="center" ItemStyle-HorizontalAlign="center">
          <ItemTemplate>
            <input id="TimeTextField_0" name="TimeTextField_0" type="text" class="text"  style="width:23px" maxlength="2" runat="server" value='<%# DataBinder.Eval(Container.DataItem, "MONDAY_TIME") %>'>
			<asp:DropDownList runat="server" CssClass="day" SelectedIndex='<%# GetTypeIndex(DataBinder.Eval(Container.DataItem, "MONDAY_TYPE").ToString()) %>' id="TypeSelect_0"></asp:DropDownList>
		  </ItemTemplate>
        </asp:TemplateColumn>
        <asp:TemplateColumn HeaderText="Tuesday" HeaderStyle-Width="98" HeaderStyle-HorizontalAlign="center" ItemStyle-HorizontalAlign="center">
          <ItemTemplate>
            <input id="TimeTextField_1" name="TimeTextField_1" type="text" class="text"  style="width:23px" maxlength="2" runat="server" value='<%# DataBinder.Eval(Container.DataItem, "TUESDAY_TIME") %>'>
			<asp:DropDownList runat="server" CssClass="day" SelectedIndex='<%# GetTypeIndex(DataBinder.Eval(Container.DataItem, "TUESDAY_TYPE").ToString()) %>' id="TypeSelect_1"></asp:DropDownList>
          </ItemTemplate>
        </asp:TemplateColumn>
		<asp:TemplateColumn HeaderText="Wednesday" HeaderStyle-Width="98" HeaderStyle-HorizontalAlign="center" ItemStyle-HorizontalAlign="center">
          <ItemTemplate>
            <input id="TimeTextField_2" name="TimeTextField_2" type="text" class="text"  style="width:23px" maxlength="2" runat="server" value='<%# DataBinder.Eval(Container.DataItem, "WEDNESDAY_TIME") %>'>
			<asp:DropDownList runat="server" CssClass="day" SelectedIndex='<%# GetTypeIndex(DataBinder.Eval(Container.DataItem, "WEDNESDAY_TYPE").ToString()) %>' id="TypeSelect_2"></asp:DropDownList>
          </ItemTemplate>
        </asp:TemplateColumn>
		<asp:TemplateColumn HeaderText="Thursday" HeaderStyle-Width="98" HeaderStyle-HorizontalAlign="center" ItemStyle-HorizontalAlign="center">
          <ItemTemplate>
            <input id="TimeTextField_3" name="TimeTextField_3" type="text" class="text"  style="width:23px" maxlength="2" runat="server" value='<%# DataBinder.Eval(Container.DataItem, "THURSDAY_TIME") %>'>
			<asp:DropDownList runat="server" CssClass="day" SelectedIndex='<%# GetTypeIndex(DataBinder.Eval(Container.DataItem, "THURSDAY_TYPE").ToString()) %>' id="TypeSelect_3"></asp:DropDownList>
          </ItemTemplate>
        </asp:TemplateColumn>
		<asp:TemplateColumn HeaderText="Friday" HeaderStyle-Width="98" HeaderStyle-HorizontalAlign="center" ItemStyle-HorizontalAlign="center">
          <ItemTemplate>
            <input id="TimeTextField_4" name="TimeTextField_4" type="text" class="text"  style="width:23px" maxlength="2" runat="server" value='<%# DataBinder.Eval(Container.DataItem, "FRIDAY_TIME") %>'>
			<asp:DropDownList runat="server" CssClass="day" SelectedIndex='<%# GetTypeIndex(DataBinder.Eval(Container.DataItem, "FRIDAY_TYPE").ToString()) %>' id="TypeSelect_4"></asp:DropDownList>
          </ItemTemplate>
        </asp:TemplateColumn>
		<asp:TemplateColumn HeaderText="Saturday" HeaderStyle-Width="98" HeaderStyle-HorizontalAlign="center" HeaderStyle-ForeColor="#CCCCCC" ItemStyle-HorizontalAlign="center" ItemStyle-BackColor="#CCCCCC">
          <ItemTemplate>
		  	<input id="TimeTextField_5" name="TimeTextField_5" type="text" class="weekend"  style="width:23px" maxlength="2" runat="server" value='<%# DataBinder.Eval(Container.DataItem, "SATURDAY_TIME") %>'>
			<asp:DropDownList runat="server" CssClass="weekend_select" SelectedIndex='<%# GetTypeIndex(DataBinder.Eval(Container.DataItem, "SATURDAY_TYPE").ToString()) %>' id="TypeSelect_5"></asp:DropDownList>
          </ItemTemplate>
        </asp:TemplateColumn>
		<asp:TemplateColumn HeaderText="Sunday" HeaderStyle-Width="98" HeaderStyle-HorizontalAlign="center" HeaderStyle-ForeColor="#CCCCCC" ItemStyle-HorizontalAlign="center" ItemStyle-BackColor="#CCCCCC">
          <ItemTemplate>
            <input id="TimeTextField_6" name="TimeTextField_6" type="text" class="weekend"  style="width:23px" maxlength="2" runat="server" value='<%# DataBinder.Eval(Container.DataItem, "SUNDAY_TIME") %>'>
			<asp:DropDownList runat="server" CssClass="weekend_select" SelectedIndex='<%# GetTypeIndex(DataBinder.Eval(Container.DataItem, "SUNDAY_TYPE").ToString()) %>' id="TypeSelect_6"></asp:DropDownList>
          </ItemTemplate>
        </asp:TemplateColumn>
		<asp:TemplateColumn HeaderText="" HeaderStyle-Width="30" HeaderStyle-HorizontalAlign="center" ItemStyle-HorizontalAlign="center">
          <ItemTemplate>
            <input name="ClearButton" type="button" class="text" id="ClearButton" style="width:30px" onClick="onTimeReportClearButtonClick(this)" value="Del" runat="server">
          </ItemTemplate>
        </asp:TemplateColumn>
      </Columns>
    </ASP:DataGrid>
	</td>
    </tr>
	<tr>
	 <td height="10"></td>
	</tr>
	<tr>
	 <td align="left"><input name="AddLineButton" class="text" type="submit" id="AddLineButton" value="Add a line" runat="server" onServerClick="AddLineButton_Click" alt="Add a line to time report" style="width:100px" />
      <input type="hidden" name="LineNumberHiddenField" id="LineNumberHiddenField" value="5" runat="server">
      <input type="hidden" name="DateHiddenField" id="DateHiddenField" runat="server">
      </td>
	</tr>
	<tr>
	 <td height="10"></td>
	</tr>
	<tr>
		<td>
			<table width="850" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td align="left" width="134" class="text_bold">Total : </td>
					<td align="center" width="98"><input name="TotalTextField_0" type="text" class="text_bold" id="TotalTextField_0" style="width:95px;text-align:right" runat="server" readonly="true" value="0"></td>
					<td align="center" width="98"><input name="TotalTextField_1" type="text" class="text_bold" id="TotalTextField_1" style="width:95px;text-align:right" runat="server" readonly="true" value="0"></td>
					<td align="center" width="98"><input name="TotalTextField_2" type="text" class="text_bold" id="TotalTextField_2" style="width:95px;text-align:right" runat="server" readonly="true" value="0"></td>
					<td align="center" width="98"><input name="TotalTextField_3" type="text" class="text_bold" id="TotalTextField_3" style="width:95px;text-align:right" runat="server" readonly="true" value="0"></td>
					<td align="center" width="98"><input name="TotalTextField_4" type="text" class="text_bold" id="TotalTextField_4" style="width:95px;text-align:right" runat="server" readonly="true" value="0"></td>
					<td align="center" width="98"></td>
					<td align="center" width="98"></td>
					<td width="30"></td>
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
					<td align="left" width="134" class="red_bold">Overtime :</td>
					<td align="center" width="98"><input name="OverTimeTextField_0" type="text" class="red_bold" id="OverTimeTextField_0" style="width:95px;text-align:right" runat="server" readonly="true" value="0"></td>
					<td align="center" width="98"><input name="OverTimeTextField_1" type="text" class="red_bold" id="OverTimeTextField_1" style="width:95px;text-align:right" runat="server" readonly="true" value="0"></td>
					<td align="center" width="98"><input name="OverTimeTextField_2" type="text" class="red_bold" id="OverTimeTextField_2" style="width:95px;text-align:right" runat="server" readonly="true" value="0"></td>
					<td align="center" width="98"><input name="OverTimeTextField_3" type="text" class="red_bold" id="OverTimeTextField_3" style="width:95px;text-align:right" runat="server" readonly="true" value="0"></td>
					<td align="center" width="98"><input name="OverTimeTextField_4" type="text" class="red_bold" id="OverTimeTextField_4" style="width:95px;text-align:right" runat="server" readonly="true" value="0"></td>
					<td align="center" width="98"><input name="OverTimeTextField_5" type="text" class="red_weekend_bold" id="OverTimeTextField_5" style="width:95px;text-align:right" runat="server" readonly="true" value="0"></td>
					<td align="center" width="98"><input name="OverTimeTextField_6" type="text" class="red_weekend_bold" id="OverTimeTextField_6" style="width:95px;text-align:right" runat="server" readonly="true" value="0"></td>
					<td width="30"></td>
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
					<td width="45" class="text_bold">Status :</td>
					<td width="5"></td>
					<td width="100"><input type="text" class="text_bold" id="StatusTextField" name="StatusTextField" style="width:100px;border-width:0px" runat="server" readonly="true"></td>
					<td width="495"></td>
					<td width="100"><input name="SaveButton" class="text" type="submit" id="SaveButton" value="Save" runat="server" onServerClick="SaveButton_Click" alt="Save current time report" style="width:100px" /></td>
					<td width="5"></td>
					<td width="100"><input name="ValidateButton" class="text" type="submit" id="ValidateButton" onClick="return validateReport();" value="Validate" runat="server" onServerClick="ValidateButton_Click" alt="Validate current time report" style="width:100px" /></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
	 <td height="5"></td>
	</tr>
	<tr>
	 <td><input name="InformationTextField" type="text" class="red" id="InformationTextField" style="width:850px;border-width:0px"
										runat="server" readonly="true"></td>
	</tr>
	  <tr>
    <td height="5"></td>
  </tr>
  <tr>
  	<td>
		<table width="850" border="0" cellspacing="0" cellpadding="0">
			<tr>
    			<td class="header">ACCOUNT LIST INFORMATION</td>
  			</tr>
		</table>
	</td>
   </tr>
  <tr>
    <td height="5"></td>
  </tr>
  <tr>
  	<td>
	<ASP:DataGrid id="AccountListDataGrid" runat="server"
      Width="850"
      BackColor="#FFFFFF"
      BorderColor="black"
      ShowFooter="false"
      CellPadding=3
      CellSpacing="0"
      Font-Name="Verdana"
      Font-Size="8pt"
      HeaderStyle-BackColor="#DE0029"
	  HeaderStyle-ForeColor="#FFFFFF"
	  HeaderStyle-Font-Bold="true"
      DataKeyField="ID"
      AutoGenerateColumns="false"
    >


      <Columns>
        <asp:BoundColumn HeaderText="ID" Visible="false" ReadOnly="True" DataField="ID" ItemStyle-Wrap="false"/>
        <asp:TemplateColumn HeaderText="ACCOUNT" HeaderStyle-Width="150">
          <ItemTemplate>
            <asp:Label runat="server" Text='<%# DataBinder.Eval(Container.DataItem, "LABEL") %>'/>
          </ItemTemplate>
        </asp:TemplateColumn>
		<asp:TemplateColumn HeaderText="NAME" HeaderStyle-Width="300">
          <ItemTemplate>
            <asp:Label runat="server" Text='<%# DataBinder.Eval(Container.DataItem, "NAME") %>'/>
          </ItemTemplate>
        </asp:TemplateColumn>
		<asp:TemplateColumn HeaderText="CUSTOMER" HeaderStyle-Width="150">
          <ItemTemplate>
            <asp:Label runat="server" Text='<%# DataBinder.Eval(Container.DataItem, "CUSTOMER") %>'/>
          </ItemTemplate>
        </asp:TemplateColumn>
		<asp:TemplateColumn HeaderText="USE" HeaderStyle-Width="150">
          <ItemTemplate>
            <asp:Label runat="server" Text='<%# DataBinder.Eval(Container.DataItem, "[USE]") %>'/>
          </ItemTemplate>
        </asp:TemplateColumn>
        <asp:TemplateColumn HeaderText="CHARGEABLE" HeaderStyle-Width="100">
          <ItemTemplate>
            <asp:Label runat="server" Text='<%# DataBinder.Eval(Container.DataItem, "SECTOR") %>'/>
          </ItemTemplate>
        </asp:TemplateColumn>
      </Columns>
    </ASP:DataGrid>
	</td>
    </tr>
</table>
</form>
</body>
</html>
