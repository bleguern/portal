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
<title>ADMINISTRATION - Add a contract</title>
<LINK href="../../../css/main.css" rel="stylesheet" type="text/css">
<LINK href="../../../css/calendar.css" rel="stylesheet" type="text/css">
<script type="text/javascript" src="../../../scripts/main.js"></script>
<script type="text/javascript" src="../../../scripts/calendar/CalendarPopup.js"></script>
</head>
<script language="C#" runat="server">
	void Page_Load(Object sender, EventArgs e) 
	{
		if(!IsPostBack)
		{
			if(Session["sql_connection_string"] != null)
			{
				PortalSqlClient sqlClient = new PortalSqlClient(Session["sql_connection_string"].ToString());
				
				sqlClient.UpdateHtmlSelectWithStoredProcedure(ref ProjectSelect, "admin_get_project_list_to_html_select");
				sqlClient.UpdateHtmlSelectWithStoredProcedure(ref StatusSelect, "admin_get_contract_status_list_to_html_select");
				sqlClient.UpdateHtmlSelectWithStoredProcedure(ref CommercialSelect, "admin_get_user_list_to_html_select");
			}
			
			UpdateLevelDataGrid();
		}
		
		if(IdContractHiddenField.Value != "")
		{
			SaveContractButton.Disabled = true;
			AddLevelButton.Disabled = false;
			SetDefaultLevelButton.Disabled = false;
		}
		else
		{
			SaveContractButton.Disabled = false;
			AddLevelButton.Disabled = true;
			SetDefaultLevelButton.Disabled = true;
		}
	}

	void AddLevelButton_Click(Object sender, EventArgs e) {
		LevelInformationTextField.Value = null;
		
		if((NameTextField.Value == "")
		|| (AnswerTimeTextField.Value == ""))
		{
			LevelInformationTextField.Value = "WARNING : Some fields are missing!";
		}
		else
		{
			string contractId = IdContractHiddenField.Value;
						
			if(!contractId.Equals(""))
			{
				if(Session["sql_connection_string"] != null)
				{
					try
					{
						PortalSqlClient sqlClient = new PortalSqlClient(Session["sql_connection_string"].ToString());
					
						string result = sqlClient.ExecuteStoredProcedure("admin_add_contract_level",
							"@id_support", contractId,
							"@nom_gravite", GetValueFromHtmlInputText(NameTextField, true),
							"@delai_reponse_gravite", GetValueFromHtmlInputText(AnswerTimeTextField, true));
							
						LevelInformationTextField.Value = result;
						UpdateLevelDataGrid();
						NameTextField.Value = null;
						AnswerTimeTextField.Value = null;
					}
					catch(PortalException ex)
					{
						Response.Redirect("../../error/Default.aspx?error=Internal error while adding a level!&message=" + ex.Message);
					}
				}
			}
			else
			{
				InformationTextField.Value = "Error : Invalid data!";
			}
		}
	}
	
	void LevelDataGrid_Edit(Object sender, DataGridCommandEventArgs e)
    {
        LevelDataGrid.EditItemIndex = (int)e.Item.ItemIndex;
        UpdateLevelDataGrid();
    }

    void LevelDataGrid_Cancel(Object sender, DataGridCommandEventArgs e)
    {
        LevelDataGrid.EditItemIndex = -1;
        UpdateLevelDataGrid();
    }

    void LevelDataGrid_Update(Object sender, DataGridCommandEventArgs e)
    {
		LevelInformationTextField.Value = null;

		if((((System.Web.UI.HtmlControls.HtmlInputText)e.Item.FindControl("EditNameTextField")).Value == "")
		|| (((System.Web.UI.HtmlControls.HtmlInputText)e.Item.FindControl("EditAnswerTimeTextField")).Value == ""))
		{
			LevelInformationTextField.Value = "WARNING : Some fields are missing!";
		}
		else
		{
			string contractId = IdContractHiddenField.Value;
						
			if(!contractId.Equals(""))
			{
				if(Session["sql_connection_string"] != null)
				{
					try
					{
						PortalSqlClient sqlClient = new PortalSqlClient(Session["sql_connection_string"].ToString());
					
						string result = sqlClient.ExecuteStoredProcedure("admin_update_contract_level",
							"@id_support", contractId,
							"@num_gravite", LevelDataGrid.DataKeys[(int)e.Item.ItemIndex],
							"@nom_gravite", GetValueFromHtmlInputText(((System.Web.UI.HtmlControls.HtmlInputText)e.Item.FindControl("EditNameTextField")), true),
							"@delai_reponse_gravite", GetValueFromHtmlInputText(((System.Web.UI.HtmlControls.HtmlInputText)e.Item.FindControl("EditAnswerTimeTextField")), true));
					
						LevelDataGrid.EditItemIndex = -1;
						UpdateLevelDataGrid();
						LevelInformationTextField.Value = result;
					}
					catch(PortalException ex)
					{
						Response.Redirect("../../error/Default.aspx?error=Internal error while updating a level!&message=" + ex.Message);
					}
				}
			}
		}
    }
	
	void LevelDataGrid_Delete(Object sender, DataGridCommandEventArgs e)
    {
		LevelInformationTextField.Value = null;
		
		string contractId = IdContractHiddenField.Value;
						
		if(!contractId.Equals(""))
		{
			if(Session["sql_connection_string"] != null)
			{
				try
				{
					PortalSqlClient sqlClient = new PortalSqlClient(Session["sql_connection_string"].ToString());
				
					string result = sqlClient.ExecuteStoredProcedure("admin_delete_contract_level",
						"@id_support", contractId,
						"@num_gravite", LevelDataGrid.DataKeys[(int)e.Item.ItemIndex]);
					
					UpdateLevelDataGrid();
					LevelInformationTextField.Value = result;
				}
				catch(PortalException ex)
				{
					Response.Redirect("../../error/Default.aspx?error=Internal error while deleting a level!&message=" + ex.Message);
				}
			}
		}
    }

	
	void UpdateLevelDataGrid()
    {
       	string contractId = IdContractHiddenField.Value;
					
		if(contractId != "")
		{
			if(Session["sql_connection_string"] != null)
			{
				PortalSqlClient sqlClient = new PortalSqlClient(Session["sql_connection_string"].ToString());
				
				sqlClient.UpdateDataGridWithStoredProcedure(ref LevelDataGrid, "admin_get_contract_level_list_with_contract",
					"@id_support", contractId);
			}
		}
    }
	
	void SaveContractButton_Click(Object sender, EventArgs e) {
		InformationTextField.Value = null;
		
		if((ProjectSelect.Value == "")
		|| (StatusSelect.Value == "")
		|| (CommercialSelect.Value == "")
		|| (SupportReferenceTextField.Value == "")
		|| (TypeSelect.Value == ""))
		{
			InformationTextField.Value = "WARNING : Some fields are missing!";
		}
		else
		{
			if(Session["sql_connection_string"] != null)
			{
				try
				{
					PortalSqlClient sqlClient = new PortalSqlClient(Session["sql_connection_string"].ToString());
				
					string result = sqlClient.ExecuteStoredProcedure("admin_add_contract",
						"@id_projet_client", GetValueFromHtmlSelect(ProjectSelect),
						"@id_etat_contrat", GetValueFromHtmlSelect(StatusSelect),
						"@commercial_support", GetValueFromHtmlSelect(CommercialSelect),
						"@ref_support", GetValueFromHtmlInputText(SupportReferenceTextField, true),
						"@date_debut_support", GetDateFromHtmlInputText(OpeningDateTextField),
						"@date_fin_support", GetDateFromHtmlInputText(ClosingDateTextField),
						"@type_support", GetValueFromHtmlSelect(TypeSelect));
						
					IdContractHiddenField.Value = result;
					InformationTextField.Value = "Contract n°" + result + " saved!";
					
					SaveContractButton.Disabled = true;
					AddLevelButton.Disabled = false;
					SetDefaultLevelButton.Disabled = false;
					
					UpdateLevelDataGrid();
				}
				catch(PortalException ex)
				{
					Response.Redirect("../../error/Default.aspx?error=Internal error while adding a contract!&message=" + ex.Message);
				}
			}
		}
	}
	
	void SetDefaultLevelButton_Click(Object sender, EventArgs e) {
		InformationTextField.Value = null;
		
		string contractId = IdContractHiddenField.Value;
					
		if(!contractId.Equals(""))
		{
			if(Session["sql_connection_string"] != null)
			{
				try
				{
					PortalSqlClient sqlClient = new PortalSqlClient(Session["sql_connection_string"].ToString());
				
					string result = sqlClient.ExecuteStoredProcedure("admin_set_default_contract_level",
						"@id_support", contractId);
					
					InformationTextField.Value = result;
					UpdateLevelDataGrid();
				}
				catch(PortalException ex)
				{
					Response.Redirect("../../error/Default.aspx?error=Internal error while setting default level list!&message=" + ex.Message);
				}
			}
		}
	}
</script>
<body>
<form id="MainForm" method="post" runat="server">
<table width="850" border="0" cellspacing="0" cellpadding="0">
  <tr>
  	<td>
		<table width="850" border="0" cellspacing="0" cellpadding="0">
			<tr>
    			<td class="header">ADD A CONTRACT</td>
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
				<td width="80" class="text">Project :</td>
			    <td width="5"></td>
			    <td width="200"><select id="ProjectSelect" name="ProjectSelect" size="1" class="text" style="width:200px"
										runat="server"></select></td>
				<td width="2"></td>
				<td width="10" class="red">*</td>
				<td width="553"><input id="IdContractHiddenField" class="hidden" name="IdContractHiddenField" type="hidden" value="" runat="server"></td>
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
				<td width="80" class="text">Status :</td>
			    <td width="5"></td>
			    <td width="200"><select id="StatusSelect" name="StatusSelect" size="1" class="text" style="width:200px"
										runat="server"></select></td>
				<td width="2"></td>
				<td width="10" class="red">*</td>
				<td width="553"></td>
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
				<td width="80" class="text">Commercial :</td>
			    <td width="5"></td>
			    <td width="250"><select id="CommercialSelect" name="CommercialSelect" size="1" class="text" style="width:250px"
										runat="server"></select></td>
				<td width="2"></td>
				<td width="10" class="red">*</td>
				<td width="503"></td>
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
				<td width="80" class="text">Support ref. :</td>
			    <td width="5"></td>
			    <td width="250"><input name="SupportReferenceTextField" type="text" class="text" id="SupportReferenceTextField" style="width:250px" maxlength="25" runat="server"></td>
				<td width="2"></td>
				<td width="10" class="red">*</td>
				<td width="60" align="right" class="text">Type : </td>
				<td width="5"></td>
				<td width="100"><select id="TypeSelect" name="TypeSelect" size="1" class="text" style="width:100px"
										runat="server">
				  <option value="" selected></option>
				  <option value="Std">Standard</option>
				  <option value="Client">Client</option>
				</select></td>
				<td width="2"></td>
				<td width="10" class="red">*</td>
				<td width="326"></td>
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
			<td width="80" class="text">Opening date : </td>
			<td width="5"></td>
			<td width="80"><input name="OpeningDateTextField" type="text" class="text" id="OpeningDateTextField" style="width:80px" maxlength="10" runat="server"></td>
			<td width="18"><img id="OpeningDateImageLink" name="OpeningDateImageLink" src="../../../images/cal.gif" alt="Opening date" width="18" height="18" onClick="showCalendar(OpeningDateTextField, 'OpeningDateImageLink')"></td>
			<td width="80" class="text" align="center">Closing date :</td>
			<td width="5"></td>
			<td width="80"><input name="ClosingDateTextField" type="text" class="text" id="ClosingDateTextField" style="width:80px" maxlength="10" runat="server"></td>
			<td width="18"><img id="ClosingDateImageLink" name="ClosingDateImageLink" src="../../../images/cal.gif" alt="Closing date" width="18" height="18" onClick="showCalendar(ClosingDateTextField, 'ClosingDateImageLink')"></td>
			<td width="484"></td>
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
      	 <td width="150"></td>
		 <td width="100"><input type="submit" class="text" runat="server" style="width:100px" id="SaveContractButton" name="SaveContractButton" alt="Save contract" value="Save" onServerClick="SaveContractButton_Click"></td>
      	 <td width="600"><input type="submit" class="text" runat="server" style="width:100px" id="SetDefaultLevelButton" name="SetDefaultLevelButton" alt="Set default level list" value="Set default" onServerClick="SetDefaultLevelButton_Click"></td>
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
	 <td height="10"></td>
	</tr>
  <tr>
  	<td>
		<table width="850" border="0" cellspacing="0" cellpadding="0">
			<tr>
    			<td class="header">LEVEL LIST</td>
  			</tr>
		</table>
	</td>
   </tr>
  <tr>
    <td height="5"></td>
  </tr>
  <tr>
  	<td>
	<ASP:DataGrid id="LevelDataGrid" runat="server"
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
      OnEditCommand="LevelDataGrid_Edit"
      OnCancelCommand="LevelDataGrid_Cancel"
      OnUpdateCommand="LevelDataGrid_Update"
	  OnDeleteCommand="LevelDataGrid_Delete"
      DataKeyField="LEVEL"
      AutoGenerateColumns="false"
    >

      <Columns>
        <asp:BoundColumn HeaderText="LEVEL" SortExpression="LEVEL" ReadOnly="True" DataField="LEVEL" ItemStyle-Wrap="false"/>
        <asp:TemplateColumn HeaderText="NAME" HeaderStyle-Width="300" SortExpression="NAME">
          <ItemTemplate>
            <asp:Label runat="server" Text='<%# DataBinder.Eval(Container.DataItem, "NAME") %>'/>
          </ItemTemplate>
          <EditItemTemplate>
		  	<input id="EditNameTextField" name="EditNameTextField" type="text" class="text"  style="width:300px" maxlength="25" runat="server" value='<%# DataBinder.Eval(Container.DataItem, "NAME") %>'>
          </EditItemTemplate>
        </asp:TemplateColumn>
        <asp:TemplateColumn HeaderText="ANSWER TIME (H)" HeaderStyle-Width="150" SortExpression="ANSWER_TIME">
          <ItemTemplate>
            <asp:Label runat="server" Text='<%# DataBinder.Eval(Container.DataItem, "ANSWER_TIME") %>'/>
          </ItemTemplate>
          <EditItemTemplate>
		  	<input id="EditAnswerTimeTextField" name="EditAnswerTimeTextField" type="text" class="text"  style="width:150px" maxlength="4" runat="server" value='<%# DataBinder.Eval(Container.DataItem, "ANSWER_TIME") %>'>
          </EditItemTemplate>
        </asp:TemplateColumn>
		<asp:EditCommandColumn ButtonType="PushButton" EditText="Update" CancelText="Cancel" UpdateText="Update" ItemStyle-Wrap="false"/>
		<asp:ButtonColumn ButtonType="PushButton" Text="Delete" CommandName="Delete"/>
      </Columns>
    </ASP:DataGrid>
	</td>
    </tr>
	<tr>
	 <td height="10"></td>
	</tr>
   <tr>
  	<td>
		<table width="850" border="0" cellspacing="0" cellpadding="0">
			<tr>
    			<td class="header">ADD A LEVEL</td>
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
				<td width="50" class="text" align="left">Name : </td>
				<td width="5"></td>
				<td width="400"><input name="NameTextField" type="text" class="text" id="NameTextField" style="width:400px" runat="server"></td>
				<td width="2"></td>
				<td width="10" class="red">*</td>
				<td width="100" class="text" align="center">Answer time (H) : </td>
				<td width="5"></td>
				<td width="100"><input name="AnswerTimeTextField" type="text" class="text" id="AnswerTimeTextField" style="width:100px" runat="server"></td>
				<td width="2"></td>
				<td width="10" class="red">*</td>
				<td align="center"><input type="submit" class="text" runat="server" style="width:100px" id="AddLevelButton" name="AddLevelButton" alt="Add a level" value="Add" onServerClick="AddLevelButton_Click"></td>
			</tr>
		</table>
	 </td>
	</tr>
	<tr>
	 <td height="5"></td>
	</tr>
	<tr>
	 <td><input name="LevelInformationTextField" type="text" class="red" id="LevelInformationTextField" style="width:850px;border-width:0px"
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