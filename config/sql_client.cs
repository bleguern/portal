<!-- #Include File="exception.cs" -->
<%@ Import namespace="System.Data" %>
<%@ Import namespace="System.Data.SqlClient" %>

<script language="c#" runat="server">
	public class PortalSqlClient
	{
		/// <summary>
		/// SQL connection object
		/// </summary>
		private SqlConnection    sqlConnection             = null;
		
		/// <summary>
		/// SQL command object
		/// </summary>
		private SqlCommand       sqlCommand                = null;
		
		/// <summary>
		/// SQL dataset object
		/// </summary>
		private DataSet          dataSet                   = null;

		/// <summary>
		/// SQL data reader object
		/// </summary>
		private SqlDataReader    sqlDataReader             = null;
		
		/// <summary>
		/// SQL data adapter object
		/// </summary>
		private SqlDataAdapter   sqlDataAdapter            = null;


		/// <summary>
		/// Default constructor, intialised with a connection string
		/// V1.0.2005.01.26
		/// </summary>
		/// <param name="sqlConnectionString">Connection string</param>
		public PortalSqlClient(string sqlConnectionString)
		{
			if(sqlConnectionString != null)
			{
				sqlConnection = new SqlConnection(sqlConnectionString);
			}
		}
                
		/// <summary>
		/// Execute a SQL stored procedure, return not null if success
		/// V1.0.2005.01.26
		/// </summary>
		/// <param name="StoredProcedureName">Stored procedure name</param>
		/// <param name="Parameters">Stored procedure parameters</param>
		/// <returns>Value of primary key added, deleted of modified</returns>
		public string ExecuteStoredProcedure(string storedProcedureName, params object [] parameters)
		{
			string Value = null;

			sqlCommand = new  SqlCommand(storedProcedureName, sqlConnection);
			sqlCommand.CommandType = CommandType.StoredProcedure;
		
			for(int i = 0; i < parameters.Length; i = i+2)
			{
				sqlCommand.Parameters.Add(parameters[i].ToString(), parameters[i+1]);
			}

			try
			{
				sqlConnection.Open();
				sqlDataReader = sqlCommand.ExecuteReader();

				if(sqlDataReader.Read())
				{
					if(!sqlDataReader.IsDBNull(0))
					{
						Value = sqlDataReader.GetValue(0).ToString();
					}
				}

				sqlDataReader.Close();
			}
			catch(SqlException ex)
			{
				if(ex.Number == 2627)
				{
					throw new PortalSqlConstraintsException(ex.Message);
				}
				else
				{
					throw new PortalSqlErrorException(ex.Message);
				}
			}
			finally
			{
				if(sqlConnection.State == ConnectionState.Open)
				{
					sqlConnection.Close();
				}
			}

			return Value;
		}

		/// <summary>
		/// Update a DataGrid with a SQL stored procedure
		/// V1.0.2005.01.26
		/// </summary>
		/// <param name="MyDataGrid">DataGrid to update</param>
		/// <param name="StoredProcedureName">Stored procedure name</param>
		/// <param name="Parameters">Stored procedure parameters</param>
		/// <returns>Number of rows added in DataGrid</returns>
		public int UpdateDataGridWithStoredProcedure(ref DataGrid dataGrid, string storedProcedureName, params object [] parameters)
		{
			sqlCommand = new  SqlCommand(storedProcedureName, sqlConnection);
			sqlCommand.CommandType = CommandType.StoredProcedure;
		
			for(int i = 0; i < parameters.Length; i = i+2)
			{
				sqlCommand.Parameters.Add(parameters[i].ToString(), parameters[i+1]);
			}

			try
			{
				sqlConnection.Open();
				sqlDataAdapter = new SqlDataAdapter(sqlCommand);

				dataSet = new DataSet();
				sqlDataAdapter.Fill(dataSet);

				dataGrid.DataSource = dataSet;
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
			catch(SqlException ex)
			{
				//Clear the DataGrid
				dataGrid.Visible = false;
				
				throw ex;
			}
			finally
			{
				if(sqlConnection.State == ConnectionState.Open)
				{
					sqlConnection.Close();
				}
			}

			return dataGrid.Items.Count;
		}
		
		/// <summary>
		/// Update a DataSet object with a SQL stored procedure
		/// V1.0.2005.01.26
		/// </summary>
		/// <param name="dataSet">DataSet object to update</param>
		/// <param name="storedProcedureName">Stored procedure name</param>
		/// <param name="parameters">Stored procedure parameters</param>
		/// <returns>Number of rows added in DataSet</returns>
		public int UpdateDataSetWithStoredProcedure(ref DataSet dataSet, string storedProcedureName, params object [] parameters)
		{
			sqlCommand = new  SqlCommand(storedProcedureName, sqlConnection);
			sqlCommand.CommandType = CommandType.StoredProcedure;
		
			for(int i = 0; i < parameters.Length; i = i+2)
			{
				sqlCommand.Parameters.Add(parameters[i].ToString(), parameters[i+1]);
			}

			try
			{
				sqlConnection.Open();
				sqlDataAdapter = new SqlDataAdapter(sqlCommand);

				if(dataSet == null)
				{
                    dataSet = new DataSet();
				}
				
				sqlDataAdapter.Fill(dataSet);
			}
			catch(SqlException ex)
			{
				//Clear the DataSet
				dataSet = null;
				
				throw ex;
			}
			finally
			{
				if(sqlConnection.State == ConnectionState.Open)
				{
					sqlConnection.Close();
				}
			}
			
			return dataSet.Tables[0].Rows.Count;
		}

		/// <summary>
		/// Update a HtmlSelect with a SQL stored procedure
		/// V1.0.2005.01.26
		/// </summary>
		/// <param name="htmlSelect">HtmlSelect object to update</param>
		/// <param name="storedProcedureName">Stored procedure name</param>
		public void UpdateHtmlSelectWithStoredProcedure(ref HtmlSelect htmlSelect, string storedProcedureName, params object [] parameters)
		{
			ListItem listItem = null;
			htmlSelect.Items.Clear();

            sqlCommand = new SqlCommand(storedProcedureName, sqlConnection);
			sqlCommand.CommandType = CommandType.StoredProcedure;
            
			for(int i = 0; i < parameters.Length; i = i+2)
			{
				sqlCommand.Parameters.Add(parameters[i].ToString(), parameters[i+1]);
			}
			    
			try
			{
				sqlConnection.Open();
				sqlDataReader = sqlCommand.ExecuteReader();
			
				listItem = new ListItem("", "");
				htmlSelect.Items.Add(listItem);

				while(sqlDataReader.Read())
				{
					if(!sqlDataReader.IsDBNull(0))
					{
						listItem = new ListItem(sqlDataReader.GetValue(1).ToString(), sqlDataReader.GetValue(0).ToString());
						htmlSelect.Items.Add(listItem);
					}
				}

				sqlDataReader.Close();
			}
			catch(SqlException ex)
			{
				//Clear the HTML SELECT
				htmlSelect.Items.Clear();
				listItem = new ListItem("", "");
				htmlSelect.Items.Add(listItem);
				
				throw ex;
			}
			finally
			{
				if(sqlConnection.State == ConnectionState.Open)
				{
					sqlConnection.Close();
				}
			}
		}
        
		/// <summary>
		/// Get string values from a SQL stored procedure
		/// V1.0.2005.01.26
		/// </summary>
		/// <param name="storedProcedureName">Stored procedure name</param>
		/// <returns>Table of string</returns>
        public string [] GetValuesWithStoredProcedure(string storedProcedureName, params object [] parameters)
		{
			string [] values = null;

			sqlCommand = new  SqlCommand(storedProcedureName, sqlConnection);
			sqlCommand.CommandType = CommandType.StoredProcedure;

			for(int i = 0; i < parameters.Length; i = i+2)
			{
				sqlCommand.Parameters.Add(parameters[i].ToString(), parameters[i+1]);
			}

			try
			{
				sqlConnection.Open();
				sqlDataReader = sqlCommand.ExecuteReader();

				if(sqlDataReader.Read())
				{
					if(!sqlDataReader.IsDBNull(0))
					{
						values = new string[sqlDataReader.FieldCount];

                        for(int i = 0; i < values.Length; i++)
                        {
                                values[i] = sqlDataReader.GetValue(i).ToString();
                        }
					}
				}
                                
                sqlDataReader.Close();
			}
			catch(SqlException ex)
			{
				values = null;
				
				throw ex;
			}
			finally
			{
				if(sqlConnection.State == ConnectionState.Open)
				{
					sqlConnection.Close();
				}
			}

			return values;
		}
	}
</script>