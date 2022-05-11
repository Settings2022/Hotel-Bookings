<%@ Page Language="C#" %>
<script runat="server">
  void btnLogon_Click(Object s, EventArgs e){
  String un;
  String pw;
    un = txtUserName.Value;
    pw = txtPassWord.Value;
    if(un == "Big" && pw == "Banana"){
      Response.Redirect("BookRoomV2.aspx");    
    }else{
      msg.InnerText = "Login details incorrect.";
    }
  }
</script>

<html style="background-color: lightblue;">
  <head><title>Log-in to Bookings</title></head>
  <body>
    <form runat="server">
    <center>
      Please login:<br />
        Username:
      <input id="txtUserName" type="text" autocomplete="off" runat="server" /><br />
        Password:
      <input id="txtPassWord" type="password" autocomplete="off" runat="server" /><br />
      <input id="btnLogon" type="submit" value="Logon" runat="server"
                                   onserverclick="btnLogon_Click" />
      <p id="msg" runat="server"></p>
    </center>
    </form>
  </body>
</html>