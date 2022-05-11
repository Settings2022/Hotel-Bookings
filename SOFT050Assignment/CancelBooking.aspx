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
        cmd = new OleDbCommand("SELECT * FROM Booking WHERE REF = " + txtREF.Value + ";", cn);
        cn.Open();
        r = cmd.ExecuteReader();
        while (r.Read())
        {
            txtChkIn.Text = r["CheckIn"].ToString();
            txtChkOut.Text = r["CheckOut"].ToString();
            txtD.Value = r["Dinner"].ToString();
            txtB.Value = r["Breakfast"].ToString();
            txtAdults.Value = r["Adults"].ToString();
            txtChildren.Value = r["Children"].ToString();
            parTotCost.InnerText = r["TotCost"].ToString();
        }
        Display.Disabled = true;
        //Close connection to database
        cn.Close();
         if (txtAdults.Value == "")
        {
          invalidBookingRef.InnerHtml = ("Invalid Booking Reference.");
        } else
        {
          invalidBookingRef.InnerHtml = "";
        }
    }

    void CancelBooking_Click(Object s, EventArgs e)
    {
        String cs = "Provider=Microsoft.ACE.OLEDB.12.0;" +
                  "Data Source=" + Server.MapPath("HotelBooking.accdb") + ";";
        OleDbConnection cn = new OleDbConnection(cs);
        OleDbCommand cmd;
        String sql;
        sql = "DELETE * FROM Booking WHERE REF = " + txtREF.Value + ";";
        parConfirmCancel.InnerHtml = ("Booking Cancelled.");
        CancelBooking.Disabled = true;
        cmd = new OleDbCommand(sql, cn);
        cn.Open();
        cmd.ExecuteNonQuery();
        cn.Close();
        
    }

</script>           
<html>
  <head>
    <title>HotelCharge
    </title>
  </head>
  <body style="background-color: lightblue;" onload="load()">
    <form runat="server">
      <center>
        <p>Cancel a Booking
        </p>
        <table>
          <td>
            <input id="UpdateClient" type="submit" value="Change Client Details" runat="server"
                   onserverclick="UpdateClient_Click" />     
          </td>
          <td>
            <input id="UpdateBooking" type="submit" value="Amend a Booking" runat="server"
                   onserverclick="UpdateBooking_Click" />   
          </td>
          <td>
            <input id="Cancel" type="submit" value="Click here to cancel another Booking" runat="server"
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
        </table>
        <p>Enter Booking REF Number:
        </p>
        <p>
          <input id="txtREF" type="text" style="background-color: khaki;" autocomplete="off" runat="server">
        </p>
        <p id="invalidBookingRef" runat="server" style="color:red;">
        </p>
        <br />
        <p> Click here to display booking details:
          <br />      
          <input id="Display" type="submit" value="Display Booking Details" runat="server"
                 onserverclick="Display_Click" />
        </p>
        <br />
        <table>
          <tr>
            <td>Check-in date:
            </td>
            <td>
              <asp:TextBox id="txtChkIn" type="text" style="background-color: khaki;" runat="server"/>
            </td>
          </tr>     
          <tr>
            <td>Check-Out Date:
            </td>
            <td>
              <asp:TextBox id="txtChkOut" type="text" style="background-color: khaki;" runat="server"/>
            </td>
          </tr>             
          <tr>
            <td>Number of Adults:
            </td>
            <td>
              <input id="txtAdults" type="text" style="background-color: khaki;" runat="server">
            </td>
          </tr>
          <tr>
            <td>Number of Children:
            </td>
            <td>
              <input id="txtChildren" type="text" style="background-color: khaki;" runat="server">
            </td>
          </tr>             
          <tr>
            <td>Include Dinner:
            </td>
            <td>
              <input id="txtD" type="text" style="background-color: khaki;" runat="server"> 
            </td>
               <td><p>£35 per person. Please enter number of people.</p></td>
          </tr>
          <tr>
            <td>Include Breakfast:
            </td>
            <td>
              <input id="txtB" type="text" style="background-color: khaki;" runat="server">
            </td>
             <td><p>£15 per person. Please enter number of people.</p></td>
          </tr>                            
          <tr>
            <td>Total Cost:
            </td>
            <td id="parTotCost" style="background-color: lightgray;" runat="server">
            </td>
          </tr>
          <tr>
            <td>Payment
            </td>
            <td>
              <input id="Payment" type="checkbox" style="background-color: khaki;" runat="server">
            </td>
          </tr>
        </table>
        <div class="hidden_input">
          <input type="hidden" name="radioCheck" id="radioCheck" value="" runat="server" />
        </div>
        <br />      
        <input id="CancelBooking" type="submit" value="Cancel booking" runat="server"
               onserverclick="CancelBooking_Click" />        
        <p id="parConfirmCancel" type="text" runat="server" />
      </center>
    </form>
  </body>
</html>