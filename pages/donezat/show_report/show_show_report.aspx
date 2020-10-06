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
				
				if((status.Equals("SAVED")) || (status.Equals("VALIDABLE")) || (status.Equals("VALIDATED")))
				{
					LoadTimeReportDataGrid();
				}
				
				UpdateAccountListDataGrid();
			}
			
			Init();
		}
	}
	
	void Init()
	{
		string status = StatusTextField.Value;
		
		if(status.Equals("SAVABLE"))
		{
			Response.Redirect("show_show_report_not_saved.aspx?date=" + GetDateFromString(DateHiddenField.Value) + "&user_id=" + Request["user_id"].ToString() + "&name=" + Request["name"].ToString());
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

							HtmlInputText typeTextField = (HtmlInputText) TimeReportDataGrid.Items[k].FindControl("TypeTextField_" + i.ToString());
							typeTextField.Attributes["class"] = "non_working_day";
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
			
			sqlClient.UpdateDataGridWithStoredProcedure(ref AccountListDataGrid, "donezat_get_time_report_account_information_with_user_id",
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
			
			sqlClient.UpdateDataSetWithStoredProcedure(ref currentTimeReportDataSet, "donezat_get_time_report_with_user_id",
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
    >
      <Columns>
	  	 <asp:BoundColumn HeaderText="ID" SortExpression="ID" Visible="false" DataField="ID"/>
	  	 <asp:TemplateColumn HeaderText="ACCOUNT" HeaderStyle-Width="150" HeaderStyle-HorizontalAlign="center" ItemStyle-HorizontalAlign="center">
          <ItemTemplate>
		  	<input id="AccountTextField" name="AccountTextField" type="text" class="text"  style="width:150px" runat="server" readonly="true" value='<%# DataBinder.Eval(Container.DataItem, "ACCOUNT") %>'>
          </ItemTemplate>
        </asp:TemplateColumn>
		<asp:TemplateColumn HeaderText="Monday" HeaderStyle-Width="100" HeaderStyle-HorizontalAlign="center" ItemStyle-HorizontalAlign="center">
          <ItemTemplate>
            <input id="TimeTextField_0" name="TimeTextField_0" type="text" class="text"  style="width:25px" maxlength="2" runat="server" readonly="true" value='<%# DataBinder.Eval(Container.DataItem, "MONDAY_TIME") %>'>
			<input id="TypeTextField_0" name="TypeTextField_0" type="text" class="text"  style="width:65px" runat="server" readonly="true" value='<%# DataBinder.Eval(Container.DataItem, "MONDAY_TYPE") %>'>
		  </ItemTemplate>
        </asp:TemplateColumn>
        <asp:TemplateColumn HeaderText="Tuesday" HeaderStyle-Width="100" HeaderStyle-HorizontalAlign="center" ItemStyle-HorizontalAlign="center">
          <ItemTemplate>
            <input id="TimeTextField_1" name="TimeTextField_1" type="text" class="text"  style="width:25px" maxlength="2" runat="server" readonly="true" value='<%# DataBinder.Eval(Container.DataItem, "TUESDAY_TIME") %>'>
			<input id="TypeTextField_1" name="TypeTextField_1" type="text" class="text"  style="width:65px" runat="server" readonly="true" value='<%# DataBinder.Eval(Container.DataItem, "TUESDAY_TYPE") %>'>
          </ItemTemplate>
        </asp:TemplateColumn>
		<asp:TemplateColumn HeaderText="Wednesday" HeaderStyle-Width="100" HeaderStyle-HorizontalAlign="center" ItemStyle-HorizontalAlign="center">
          <ItemTemplate>
            <input id="TimeTextField_2" name="TimeTextField_2" type="text" class="text"  style="width:25px" maxlength="2" runat="server" readonly="true" value='<%# DataBinder.Eval(Container.DataItem, "WEDNESDAY_TIME") %>'>
			<input id="TypeTextField_2" name="TypeTextField_2" type="text" class="text"  style="width:65px" runat="server" readonly="true" value='<%# DataBinder.Eval(Container.DataItem, "WEDNESDAY_TYPE") %>'>
          </ItemTemplate>
        </asp:TemplateColumn>
		<asp:TemplateColumn HeaderText="Thursday" HeaderStyle-Width="100" HeaderStyle-HorizontalAlign="center" ItemStyle-HorizontalAlign="center">
          <ItemTemplate>
            <input id="TimeTextField_3" name="TimeTextField_3" type="text" class="text"  style="width:25px" maxlength="2" runat="server" readonly="true" value='<%# DataBinder.Eval(Container.DataItem, "THURSDAY_TIME") %>'>
			<input id="TypeTextField_3" name="TypeTextField_3" type="text" class="text"  style="width:65px" runat="server" readonly="true" value='<%# DataBinder.Eval(Container.DataItem, "THURSDAY_TYPE") %>'>
          </ItemTemplate>
        </asp:TemplateColumn>
		<asp:TemplateColumn HeaderText="Friday" HeaderStyle-Width="100" HeaderStyle-HorizontalAlign="center" ItemStyle-HorizontalAlign="center">
          <ItemTemplate>
            <input id="TimeTextField_4" name="TimeTextField_4" type="text" class="text"  style="width:25px" maxlength="2" runat="server" readonly="true" value='<%# DataBinder.Eval(Container.DataItem, "FRIDAY_TIME") %>'>
			<input id="TypeTextField_4" name="TypeTextField_4" type="text" class="text"  style="width:65px" runat="server" readonly="true" value='<%# DataBinder.Eval(Container.DataItem, "FRIDAY_TYPE") %>'>
          </ItemTemplate>
        </asp:TemplateColumn>
		<asp:TemplateColumn HeaderText="Saturday" HeaderStyle-Width="100" HeaderStyle-HorizontalAlign="center" HeaderStyle-ForeColor="#CCCCCC" ItemStyle-HorizontalAlign="center" ItemStyle-BackColor="#CCCCCC">
          <ItemTemplate>
		  	<input id="TimeTextField_5" name="TimeTextField_5" type="text" class="weekend"  style="width:25px" maxlength="2" runat="server" readonly="true" value='<%# DataBinder.Eval(Container.DataItem, "SATURDAY_TIME") %>'>
			<input id="TypeTextField_5" name="TypeTextField_5" type="text" class="weekend"  style="width:65px" runat="server" readonly="true" value='<%# DataBinder.Eval(Container.DataItem, "SATURDAY_TYPE") %>'>
          </ItemTemplate>
        </asp:TemplateColumn>
		<asp:TemplateColumn HeaderText="Sunday" HeaderStyle-Width="100" HeaderStyle-HorizontalAlign="center" HeaderStyle-ForeColor="#CCCCCC" ItemStyle-HorizontalAlign="center" ItemStyle-BackColor="#CCCCCC">
          <ItemTemplate>
            <input id="TimeTextField_6" name="TimeTextField_6" type="text" class="weekend"  style="width:25px" maxlength="2" runat="server" readonly="true" value='<%# DataBinder.Eval(Container.DataItem, "SUNDAY_TIME") %>'>
			<input id="TypeTextField_6" name="TypeTextField_6" type="text" class="weekend"  style="width:65px" runat="server" readonly="true" value='<%# DataBinder.Eval(Container.DataItem, "SUNDAY_TYPE") %>'>
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
	 <td align="left"><input type="hidden" name="LineNumberHiddenField" id="LineNumberHiddenField" value="5" runat="server">
	  <input type="hidden" name="DateHiddenField" id="DateHiddenField" runat="server"></td>
	</tr>
	<tr>
	 <td height="10"></td>
	</tr>
	<tr>
		<td>
			<table width="850" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td align="left" width="150" class="text_bold">Total : </td>
					<td align="center" width="100"><input name="TotalTextField_0" type="text" class="text_bold" id="TotalTextField_0" style="width:95px;text-align:right" runat="server" readonly="true" value="0"></td>
					<td align="center" width="100"><input name="TotalTextField_1" type="text" class="text_bold" id="TotalTextField_1" style="width:95px;text-align:right" runat="server" readonly="true" value="0"></td>
					<td align="center" width="100"><input name="TotalTextField_2" type="text" class="text_bold" id="TotalTextField_2" style="width:95px;text-align:right" runat="server" readonly="true" value="0"></td>
					<td align="center" width="100"><input name="TotalTextField_3" type="text" class="text_bold" id="TotalTextField_3" style="width:95px;text-align:right" runat="server" readonly="true" value="0"></td>
					<td align="center" width="100"><input name="TotalTextField_4" type="text" class="text_bold" id="TotalTextField_4" style="width:95px;text-align:right" runat="server" readonly="true" value="0"></td>
					<td align="center" width="100"></td>
					<td align="center" width="100"></td>
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
					<td align="left" width="150" class="red_bold">Overtime :</td>
					<td align="center" width="100"><input name="OverTimeTextField_0" type="text" class="red_bold" id="OverTimeTextField_0" style="width:95px;text-align:right" runat="server" readonly="true" value="0"></td>
					<td align="center" width="100"><input name="OverTimeTextField_1" type="text" class="red_bold" id="OverTimeTextField_1" style="width:95px;text-align:right" runat="server" readonly="true" value="0"></td>
					<td align="center" width="100"><input name="OverTimeTextField_2" type="text" class="red_bold" id="OverTimeTextField_2" style="width:95px;text-align:right" runat="server" readonly="true" value="0"></td>
					<td align="center" width="100"><input name="OverTimeTextField_3" type="text" class="red_bold" id="OverTimeTextField_3" style="width:95px;text-align:right" runat="server" readonly="true" value="0"></td>
					<td align="center" width="100"><input name="OverTimeTextField_4" type="text" class="red_bold" id="OverTimeTextField_4" style="width:95px;text-align:right" runat="server" readonly="true" value="0"></td>
					<td align="center" width="100"><input name="OverTimeTextField_5" type="text" class="red_weekend_bold" id="OverTimeTextField_5" style="width:95px;text-align:right" runat="server" readonly="true" value="0"></td>
					<td align="center" width="100"><input name="OverTimeTextField_6" type="text" class="red_weekend_bold" id="OverTimeTextField_6" style="width:95px;text-align:right" runat="server" readonly="true" value="0"></td>
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
					<td width="700"></td>
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
