<script language="c#" runat="server">
	public class PortalException : System.Exception
	{
		public PortalException() : base()
		{
		
		}
		
		public PortalException(string Message) : base(Message)
		{
		
		}
	}
	
	public class PortalSqlErrorException : PortalException
	{
		public PortalSqlErrorException() : base()
		{
		
		}
		
		public PortalSqlErrorException(string Message) : base(Message)
		{
		
		}
	}
	
	public class PortalSqlConstraintsException : PortalException
	{
		public PortalSqlConstraintsException() : base()
		{
		
		}
		
		public PortalSqlConstraintsException(string Message) : base(Message)
		{
		
		}
	}
</script>