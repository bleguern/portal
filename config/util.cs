<!-- #Include File="sql_client.cs" -->
<%@ Import namespace="System.Xml" %>
<%@ Import namespace="System.Security.Cryptography" %>
<%@ Import namespace="System.Web.Security" %>
<%@ Import namespace="System.Globalization" %>

<script language="c#" runat="server">
	
	////////////////////////////////////////////////////////////////////
	//////////// OTHERS  ///////////////////////////////////////////////
	////////////////////////////////////////////////////////////////////
	
	void WriteJavaScript(string script)
	{
		Response.Write("<script type='text/javascript'>" + script + "<"+"/script>");
	}
	
	////////////////////////////////////////////////////////////////////
	//////////// XML  ///////////////////////////////////////////////
	////////////////////////////////////////////////////////////////////
	
	string GetApplicationVersionLogin()
	{
		XmlNode node = GetXmlNode("config/config.xml", "/config/application");
		
		if(node != null)
		{
			return "V" + GetXmlAttribute(node, "version");
		}
		
		return null;
	}
	
	string GetApplicationVersion()
	{
		XmlNode node = GetXmlNode("../../config/config.xml", "/config/application");
		
		if(node != null)
		{
			return "V" + GetXmlAttribute(node, "version");
		}
		
		return null;
	}
	
	string GetAdministratorEmail()
	{
		XmlNode node = GetXmlNode("../../config/config.xml", "/config/administrator");
		
		if(node != null)
		{
			return GetXmlAttribute(node, "email");
		}
		
		return null;
	}
	
	XmlNode GetXmlNode(string xmlFilePath, string xPath) 
	{
		XmlNode node = null;
		
		try
		{
			XmlDocument xmlFile = new XmlDocument();
			xmlFile.Load(Server.MapPath(xmlFilePath));
			
			node = xmlFile.DocumentElement.SelectSingleNode(xPath);
		}
		catch(Exception)
		{
			return null;
		}
		
		return node;
	}
	
	string GetXmlAttribute(XmlNode node, string attribute)
	{
		string value = null;
		
		try
		{
			value = node.Attributes[attribute].Value;
		}
		catch(Exception)
		{
			return null;
		}
		
		return value;
	}
	
	////////////////////////////////////////////////////////////////////
	///////////////////////////////////////////////////////////////////////
	/////// STRING OPS /////////////////////////////////////////////////////
	////////////////////////////////////////////////////////////////////////
	
	string GetValueFromTextBox(TextBox textBox, bool isInsertOrUpdateProcedure)
	{
		string value = textBox.Text;
		
		if((value != null) && (value.Length != 0))
		{
			if(isInsertOrUpdateProcedure)
			{
				return value;
			}
			else
			{
				return value.Replace("'", "''");
			}
		}
			
		return null;
	}
	
	string GetValueFromCheckBox(CheckBox checkBox)
	{
		if(checkBox.Checked)
		{
			return "1";
		}
		else
		{
			return "0";
		}
	}

	string GetValueFromHtmlInputText(HtmlInputText htmlInputText, bool isInsertOrUpdateProcedure)
	{
		string value = htmlInputText.Value;
		
		if((value != null) && (value.Length != 0))
		{
			if(isInsertOrUpdateProcedure)
			{
				return value;
			}
			else
			{
				return value.Replace("'", "''");
			}
		}
			
		return null;
	}
	
	string GetValueFromHtmlInputHidden(HtmlInputHidden htmlInputHidden)
	{
		string value = htmlInputHidden.Value;
		
		if((value != null) && (value.Length != 0))
		{
			return value;
		}
			
		return null;
	}
	
	bool GetValueFromHtmlInputCheckBox(HtmlInputCheckBox htmlInputCheckBox)
	{
		return htmlInputCheckBox.Checked;
	}
	
	string GetValueFromHtmlSelect(HtmlSelect htmlSelect)
	{
		if(htmlSelect.SelectedIndex == 0)
		{
			return null;
		}
		else
		{
			return htmlSelect.Value;
		}
	}
	
	string GetTextFromHtmlSelect(HtmlSelect htmlSelect, bool isInsertOrUpdateProcedure)
	{
		if(htmlSelect.SelectedIndex == 0)
		{
			return null;
		}
		else
		{
			if(isInsertOrUpdateProcedure)
			{
				return htmlSelect.Items[htmlSelect.SelectedIndex].Text;
			}
			else
			{
				return htmlSelect.Items[htmlSelect.SelectedIndex].Text.Replace("'", "''");
			}
		}
	}
	
	string GetValueFromHtmlTextArea(HtmlTextArea htmlTextArea, bool isInsertOrUpdateProcedure)
	{
		string value = htmlTextArea.Value;
		
		if((value != null) && (value.Length != 0))
		{
			if(isInsertOrUpdateProcedure)
			{
				return value;
			}
			else
			{
				return value.Replace("'", "''");
			}
		}
			
		return null;
	}
	
	
	string GetSpecificValueFromHtmlInputHidden(HtmlInputHidden htmlInputHidden, int index)
	{
		string value = htmlInputHidden.Value;
		
		if((value != null) && (value.Length != 0))
		{
			int nb = value.Split("-".ToCharArray()).Length;
			
			if(index >= nb)
			{
				return null;
			}
			else
			{
				return value.Split("-".ToCharArray())[index];
			}
		}
			
		return null;
	}
	
	string GetDateFromHtmlInputText(HtmlInputText htmlInputText)
	{
		string value = htmlInputText.Value;
		
		if((value != null) && (value.Length != 0))
		{
			try
			{
				value = Convert.ToDateTime(value).ToShortDateString();
				return value;
			}
			catch(FormatException)
			{
				
			}
			catch(OverflowException)
			{
				
			}
		}

		return null;
	}
	
	string GetDateFromHtmlInputText(HtmlInputText htmlInputText, string format)
	{
		string value = htmlInputText.Value;
		
		if((value != null) && (value.Length != 0))
		{
			try
			{
				value = Convert.ToDateTime(value).ToString(format);
				return value;
			}
			catch(FormatException)
			{
				
			}
			catch(OverflowException)
			{
				
			}
		}

		return null;
	}
	
	object GetDoubleFromHtmlInputText(HtmlInputText htmlInputText)
	{
		string value = htmlInputText.Value;
		
		if((value != null) && (value.Length != 0))
		{
			try
			{
				value = value.Replace(".", ",");
				return Convert.ToDouble(value);
			}
			catch(FormatException)
			{
			
			}
			catch(OverflowException)
			{
			
			}
		}

		return DBNull.Value;
	}
	
	string GetValueFromPageRequest(object value)
	{
		if(value != null)
		{
			return value.ToString();
		}

		return "";
	}
	
	
	
	
	////////////////////////////////////////////////////////////////////////////
	////////////////////////////////////////////////////////////////////////////
	
	///////////////////////////////////////////////////////////////////////
	/////// HTML SELECT ///////////////////////////////////////////////////
	///////////////////////////////////////////////////////////////////////
	
	void SetHmltSelectSelectedIndexByUserName(ref HtmlSelect htmlSelect)
	{
		string currentLogin = User.Identity.Name.ToUpper();

		for(int i = 0; i < htmlSelect.Items.Count; i++)
		{
			if(htmlSelect.Items[i].Value.ToUpper().Equals(currentLogin))
			{
				htmlSelect.SelectedIndex = i;
				return;
			}
		}
	}
	
	void SetHmltSelectSelectedIndexByString(ref HtmlSelect htmlSelect, string value)
	{
		if((value == null) || (value.Length == 0))
		{
			htmlSelect.SelectedIndex = 0;
		}
		else
		{
			for(int i = 0; i < htmlSelect.Items.Count; i++)
			{
				if(htmlSelect.Items[i].Value.Equals(value))
				{
					htmlSelect.SelectedIndex = i;
					return;
				}
			}
		}
	}
	
	void SetHmltSelectSelectedIndexByText(ref HtmlSelect htmlSelect, string value)
	{
		if((value == null) || (value.Length == 0))
		{
			htmlSelect.SelectedIndex = 0;
		}
		else
		{
			for(int i = 0; i < htmlSelect.Items.Count; i++)
			{
				if(htmlSelect.Items[i].Text.Equals(value))
				{
					htmlSelect.SelectedIndex = i;
					return;
				}
			}
		}
	}
	
	void UpdateHmltSelectWithDataTable(ref HtmlSelect htmlSelect, DataTable table)
	{
		ClearHmltSelect(ref htmlSelect);
		
		if(table != null)
		{
			for(int i = 0; i < table.Rows.Count; i++)
			{
				ListItem tmp = new ListItem(table.Rows[i][1].ToString(), table.Rows[i][0].ToString());
				htmlSelect.Items.Add(tmp);
			}
		}
	}
	
	void UpdateDropDownListWithDataTable(ref DropDownList dropDownList, DataTable table)
	{
		ClearDropDownList(ref dropDownList);
		
		if(table != null)
		{
			for(int i = 0; i < table.Rows.Count; i++)
			{
				ListItem tmp = new ListItem(table.Rows[i][1].ToString(), table.Rows[i][0].ToString());
				dropDownList.Items.Add(tmp);
			}
		}
	}
	
	void UpdateDataGridWithDataTable(ref DataGrid dataGrid, DataTable table)
	{
		dataGrid.DataSource = table;
		dataGrid.DataBind();

		if(dataGrid.Items.Count == 0)
		{
			dataGrid.Visible = false;
		}
		else
		{
			dataGrid.Visible = true;
		}
	}
	
	void ClearHmltSelect(ref HtmlSelect htmlSelect)
	{
		htmlSelect.Items.Clear();
		htmlSelect.Items.Add("");
	}
	
	void ClearDropDownList(ref DropDownList dropDownList)
	{
		dropDownList.Items.Clear();
		dropDownList.Items.Add("");
	}
	
	bool SetSingleSelected(ref HtmlSelect htmlSelect)
	{
		if(htmlSelect.Items.Count == 2)
		{
			htmlSelect.SelectedIndex = 1;
			return true;
		}
		
		return false;
	}
	
	////////////////////////////////////////////////////////////////////////////////
	////////////////////////////////////////////////////////////////////////////////
	
	string GetHeaderScriptWithDataSet(DataSet dataSet)
	{
		string headerScript = "";
		
		if(dataSet != null)
		{
			for(int i = 0; i < dataSet.Tables.Count; i++)
			{
				DataTable table = dataSet.Tables[i];
				
				headerScript += "var " + table.TableName + " = new Array(";
				
				int nbRows = table.Rows.Count;
				int nbColumns = table.Columns.Count;
				
				for(int j = 0; j < nbRows; j++)
				{
					DataRow row = table.Rows[j];
					
					if(j > 0)
					{
						headerScript += ",";
					}

					headerScript += @"
new Array(";
					for(int k = 0; k < nbColumns; k++)
					{
						if(k > 0)
						{
							headerScript += ",";
						}
						
						headerScript += "\"" + GetStringFromValue(row[k]) + "\"";
					}
				
					headerScript += ")";
				}
				
				headerScript += @");
";
			}
		
		}
		
		return headerScript;
	}
	
	string GetStringFromValue(object Value)
	{
		if(Value != null)
		{
			string value = Value.ToString();
			
			if(value.Length != 0)
			{
				return value.Replace("\"", "\\\"");
			}
		}
		
		return "";
	}
	
	string GetValueFromRequest(object Value)
	{
		if(Value != null)
		{
			string value = Value.ToString();
			
			if(value.Length != 0)
			{
				return value;
			}
		}
		
		return null;
	}
	
	object GetDoubleFromRequest(object Value)
	{
		if(Value != null)
		{
			try
			{
				return Convert.ToDouble(Value.ToString());
			}
			catch(FormatException)
			{
			
			}
			catch(OverflowException)
			{
			
			}
		}
		
		return DBNull.Value;
	}
	
	object GetIntDbTypeFromString(string Value)
	{
		if(Value != null)
		{
			try
			{
				return Convert.ToInt32(Value.ToString());
			}
			catch(FormatException)
			{
			
			}
			catch(OverflowException)
			{
			
			}
		}
		
		return DBNull.Value;
	}
	
	string GetDateFromRequest(object Value)
	{
		if(Value != null)
		{
			string value = Value.ToString();
		
			if(value.Length != 0)
			{
				try
				{
					value = Convert.ToDateTime(value).ToShortDateString();
					return value;
				}
				catch(FormatException)
				{
					
				}
				catch(OverflowException)
				{
					
				}
			}
		}

		return null;
	}
	
	DateTime GetDateFromString(string dateValue)
	{
		if(dateValue != null)
		{
			if(dateValue.Length != 0)
			{
				try
				{
					return Convert.ToDateTime(dateValue);
				}
				catch(FormatException)
				{
					
				}
				catch(OverflowException)
				{
					
				}
			}
		}

		return DateTime.Now;
	}
	
	string GetSpecificValueFromRequest(object Value, int index)
	{
		if(Value != null)
		{
			string value = Value.ToString();
			
			if(value.Length != 0)
			{
				int nb = value.Split("-".ToCharArray()).Length;
				
				if(index >= nb)
				{
					return null;
				}
				else
				{
					return value.Split("-".ToCharArray())[index];
				}
			}
		}
			
		return null;
	}
	
	
	
	////////////////////////////PASSWORD AND CONNECTION/////////////////////////
	
	public string CreateSalt(int size)
	{
		// Generate a cryptographic random number using the cryptographic
		// service provider
	  	RNGCryptoServiceProvider rng = new RNGCryptoServiceProvider();
	  
	  	byte[] buff = new byte[size];
	  
	  	rng.GetBytes(buff);
		// Return a Base64 string representation of the random number
		return Convert.ToBase64String(buff);
	}

	public string CreatePasswordHash(string pwd, string salt)
	{
		string saltAndPwd = String.Concat(pwd, salt);
		string hashedPwd = FormsAuthentication.HashPasswordForStoringInConfigFile(saltAndPwd, "SHA1");
		return hashedPwd;
	}
	
	bool IsAllowed(string url, bool isServerUrl)
	{
		if(isServerUrl)
		{
			url = url.Substring(0, url.LastIndexOf("/"));
			url = url.Substring(url.IndexOf("/", 1)+1);
		}
		
		bool isAllowed = false;
		
		SqlConnection conn = new SqlConnection(Session["sql_connection_string"].ToString());
		
		SqlCommand cmd = new SqlCommand("portal_is_allowed", conn);
		cmd.CommandType = CommandType.StoredProcedure;
	
		SqlParameter sqlParam1 = cmd.Parameters.Add("@login", SqlDbType.VarChar, 20);
		sqlParam1.Value = User.Identity.Name;
		
		SqlParameter sqlParam2 = cmd.Parameters.Add("@url", SqlDbType.VarChar, 200);
		sqlParam2.Value = url;

		try
	  	{
			conn.Open();
			SqlDataReader reader = cmd.ExecuteReader();
			reader.Read();
			
			string result = reader.GetString(0);
			reader.Close();
			
			isAllowed = result.Equals("1");
	  	}
	  	catch (Exception ex)
	  	{
			throw ex;
	  	}
	  	finally
	  	{
			conn.Close();
	  	}
	  
	  	return isAllowed;
	}
	
	string GetDefaultConnectionString()
	{
		XmlNode node = null;
		
		string sqlLogin = null;
		string sqlPassword = null;
		
		node = GetXmlNode("config/config.xml", "/config/sql_user");
		
		if(node != null)
		{
			sqlLogin = GetXmlAttribute(node, "login");
			sqlPassword = GetXmlAttribute(node, "password");
			
			node = GetXmlNode("config/config.xml", "/config/sql_servers");
			
			if(node != null)
			{
				for(int i = 0; i < node.ChildNodes.Count; i++)
				{
					string name = GetXmlAttribute(node.ChildNodes[i], "name");
					string database = GetXmlAttribute(node.ChildNodes[i], "database");
					
					string connectionString = "Initial Catalog=" + database + ";Data Source=" + name + ";User ID=" + sqlLogin + ";Password=" + sqlPassword + @";Connect Timeout=2;Network Library=dbmssocn;";
					
					SqlConnection sqlConnection = new SqlConnection(connectionString);
			
					try
					{
						sqlConnection.Open();
			
						if(sqlConnection.State == ConnectionState.Open)
						{
							return connectionString;
						}
					}
					catch(Exception)
					{
						
					}
					
					sqlConnection = null;
				}
			}
		}
		
		return null;
	}
	
	string GetConnectionString(string sqlLogin, string sqlPassword)
	{
		XmlNode node = null;
		
		node = GetXmlNode("config/config.xml", "/config/sql_servers");
			
		if(node != null)
		{
			for(int i = 0; i < node.ChildNodes.Count; i++)
			{
				string name = GetXmlAttribute(node.ChildNodes[i], "name");
				string database = GetXmlAttribute(node.ChildNodes[i], "database");
				
				string connectionString = "Initial Catalog=" + database + ";Data Source=" + name + ";User ID=" + sqlLogin + ";Password=" + sqlPassword + @";Connect Timeout=2;Network Library=dbmssocn;";
				
				SqlConnection sqlConnection = new SqlConnection(connectionString);
		
				try
				{
					sqlConnection.Open();
		
					if(sqlConnection.State == ConnectionState.Open)
					{
						Session.Add("server", name);
						return connectionString;
					}
				}
				catch(Exception)
				{
					
				}
				
				sqlConnection = null;
			}
		}
		
		return null;
	}
	
	string GetWeekString(string beginDateString)
	{
		CultureInfo ci = new CultureInfo("en-GB");
		DateTime beginDate;
		DateTime endDate;
		
		try
		{
			beginDate = Convert.ToDateTime(beginDateString);
			endDate = beginDate.AddDays(6);
			
			return beginDate.ToString("D", ci) + " - " + endDate.ToString("D", ci);
		}
		catch(FormatException)
		{
		
		}
		catch(OverflowException)
		{
		
		}

		return "N/A";
	}
</script>