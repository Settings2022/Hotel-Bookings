<%@ Page Language="C#" %>
<%@ Import Namespace="System.Data.OleDb" %>
<script runat="server">

     void UpdateClient_Click(Object s, EventArgs e)
    {
        Response.Redirect("UpDateClient.aspx");
    }

    void UpdateBooking_Click(Object s, EventArgs e)
    {
        Response.Redirect("UpDateBooking.aspx");
    }

    void Cancel_Click(Object s, EventArgs e)
    {
        Response.Redirect("CancelBooking.aspx");
    }

     void Return_Click(Object s, EventArgs e)
    {
        Response.Redirect("BookRoomV2.aspx");
    }

    void SignOut_Click(Object s, EventArgs e)
    {        
        Response.Redirect("Login.aspx");
    }

    //int = ID;
    void Display_Click(Object s, EventArgs e)
    {
        // Establishes database connection
        String cs = "Provider=Microsoft.ACE.OLEDB.12.0;" +
                    "Data Source=" + Server.MapPath("HotelBooking.accdb") + ";";
        OleDbConnection cn = new OleDbConnection(cs);
        OleDbCommand cmd;
        OleDbDataReader r;        
        cmd = new OleDbCommand("SELECT * FROM Guest WHERE ID = " + txtID.Value + ";", cn);
        cn.Open();
        r = cmd.ExecuteReader();       
        while (r.Read())
        {
            txtFirstName.Value = r["FirstName"].ToString();
            txtSurname.Value = r["Surname"].ToString();
            txtEmail.Value = r["Email"].ToString();
            txtTelephone.Value = r["Telephone"].ToString();
            txtAddressLine1.Value = r["AddressLine1"].ToString();
            txtAddressLine2.Value = r["AddressLine2"].ToString();
            txtAddressLine3.Value = r["AddressLine3"].ToString();
            txtPostcode.Value = r["Postcode"].ToString();
            //Marketing.??????? = r["Marketing"].??????????();
            Display.Disabled = true;
        }
        //Close connection to database
        cn.Close();

        if (txtFirstName.Value == "")
        {
          invalidGuestRef.InnerHtml = "Invalid Guest Reference.";
        } else
        {
          invalidGuestRef.InnerHtml = "";
        }

    }

    void UpDateClient_Click(Object s, EventArgs e)
    {
        String cs = "Provider=Microsoft.ACE.OLEDB.12.0;" +
                  "Data Source=" + Server.MapPath("HotelBooking.accdb") + ";";
        OleDbConnection cn = new OleDbConnection(cs);
        OleDbCommand cmd;
        String sql;

        sql = "UPDATE [Guest] " +
              " SET [FirstName] = '" + txtFirstName.Value + "'," +
              " [Surname] = '" + txtSurname.Value + "'," +
              " [Email] = '" + txtEmail.Value + "'," +
              " [Telephone] = '" + txtTelephone.Value + "'," +
              " [AddressLine1] = '" + txtAddressLine1.Value + "'," +
              " [AddressLine2] = '" + txtAddressLine2.Value + "'," +
              " [AddressLine3] = '" + txtAddressLine3.Value + "'" +
              " WHERE id = " + txtID.Value + ";";

        parConfirmUpdate.InnerHtml = ("Customer Details Updated.");
        UpDateClient.Disabled = true;

        cmd = new OleDbCommand(sql, cn);
        cn.Open();
        cmd.ExecuteNonQuery();
        cn.Close();
    }

</script>      
<html style="background-color: lightblue;">
  <head>
    <title>
    </title>
  </head>
  <body>
    <form runat="server">
      <center>  
        <p>Update Client Details
        </p>
        <table>
        <tr>
        <td>
        <input id="Submit1" type="submit" value="Update another client's details" runat="server"
               onserverclick="UpdateClient_Click" />
         </td>
         <td> 
        <input id="UpdateBooking" type="submit" value="Amend a Booking" runat="server"
               onserverclick="UpdateBooking_Click" />
         </td>
        <td>    
        <input id="Cancel" type="submit" value="Cancel a Booking" runat="server"
               onserverclick="Cancel_Click" />
        </td>
        <td>   
        <input id="Return" type="submit" value="Make a new booking" runat="server"
               onserverclick="Return_Click" />
        </td>
        <td>  
        <input id="SignOut" type="submit" value="Log Out" runat="server" 
               onserverclick="SignOut_Click"/>
        </td>  
        </tr>
        </table>
        <p>Enter Guest ID Number:
        </p>
        <p>
          <input id="txtID" type="text" style="background-color: khaki;" autocomplete="off" runat="server">
        </p>
        <br />
        <p> Click here to display a client's details:
          <br />      
          <input id="Display" type="submit" value="Display Client Details" runat="server"
                 onserverclick="Display_Click" />
        </p>
        <p id="invalidGuestRef" runat="server" style="color:red;">
        </p>
        <table>               
          <tr>
            <td>First Name:
            </td>
            <td>
              <input id="txtFirstName" type="text" style="background-color: khaki;" autocomplete="off" runat="server">
            </td>
          </tr>
          <tr>
            <td>Surname
            </td>
            <td>
              <input id="txtSurname" type="text" style="background-color: khaki;" runat="server">
            </td>
          </tr>
          <tr>
            <td>Email Address
            </td>
            <td>
              <input id="txtEmail" type="text" style="background-color: khaki;" runat="server">
            </td>
          </tr>
          <tr>
            <td>Telephone Number
            </td>
            <td>
              <input id="txtTelephone" type="text" style="background-color: khaki;" runat="server" maxlength="11">
            </td>
          </tr>
          <tr>
            <td>Address 1
            </td>
            <td>
              <input id="txtAddressLine1" type="text" style="background-color: khaki;" runat="server">
            </td>
          </tr>
          <tr>
            <td>Address 2
            </td>
            <td>
              <input id="txtAddressLine2" type="text" style="background-color: khaki;" runat="server">
            </td>
          </tr>
          <tr>
            <td>Address 3
            </td>
            <td>
              <input id="txtAddressLine3" type="text" style="background-color: khaki;" runat="server">
            </td>
          </tr>
          <tr>
            <td>Postcode
            </td>
            <td>
              <input id="txtPostcode" type="text" style="background-color: khaki;" runat="server">
            </td>
          </tr>
          <tr>
            <td>Marketing
            </td>
            <td>
              <input id="txtMarketing" type="checkbox" style="background-color: khaki;" runat="server">
            </td>
          </tr>
          <tr>
            <td>
              <br />      
              <input id="UpDateClient" type="submit" value="Update Client Details" runat="server"
                     onserverclick="UpDateClient_Click" />
              <p id="parConfirmUpdate" type="text" runat="server"></p>
              <br />
            </td>
          </tr>                
        </table>   
      </center>
    </form>
  </body>
</html>
