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
            txtNum.Text = r["RoomNumber"].ToString();
            parTotCost.InnerText = r["TotCost"].ToString();
            //Marketing.??????? = r["Marketing"].??????????();
            Display.Disabled = true;
        }
        //Close connection to database
        cn.Close();

        if (txtNum.Text == "")
        {
          invalidBookingRef.InnerHtml = ("Invalid Booking Reference.");
        } else
        {
          invalidBookingRef.InnerHtml = "";
        }
    }

    void AmendBooking_Click(Object s, EventArgs e)
    {
        String cs = "Provider=Microsoft.ACE.OLEDB.12.0;" +
                  "Data Source=" + Server.MapPath("HotelBooking.accdb") + ";";
        OleDbConnection cn = new OleDbConnection(cs);
        OleDbCommand cmd;
        String sql;
        sql = "UPDATE [Booking] " +
              " SET [CheckIn] = '" + ChkIn.Text + "'," +
              " [CheckOut] = '" + ChkOut.Text + "'," +
              " [Dinner] = '" + txtD.Value + "'," +
              " [Breakfast] = '" + txtB.Value + "'," +
              " [Adults] = '" + txtAdults.Value + "'," +
              " [Children] = '" + txtChildren.Value + "'," +
              " [RoomNumber] = '" + txtNum.Text + "'," +
              " [TotCost] = '" + parTotCost.InnerText + "'" +
              " WHERE REF = " + txtREF.Value + ";";

        parConfirmUpdate.InnerHtml = ("Booking Updated.");
        AmendBooking.Disabled = true;

        cmd = new OleDbCommand(sql, cn);
        cn.Open();
        cmd.ExecuteNonQuery();
        cn.Close();

    }
    void btnCalc_Click(Object s, EventArgs e)
    {
        // Prints out value of radiobutton AKA room number
        // this is for the purposes of inserting BACK into the database for the booking entry, where the room number is required
        // parNum.InnerText = radioCheck.Value;

        // Takes dates inputted by user
        String ChkInDate = ChkIn.Text;
        String ChkOutDate = ChkOut.Text;

        // Two empty DateTime variables for the above dates
        System.DateTime Date1;
        System.DateTime Date2;

        // TryParse to convert Strings to DateTime
        var isValidDateIn = DateTime.TryParse(ChkInDate, out Date1);
        var isValidDateOut = DateTime.TryParse(ChkOutDate, out Date2);

        // Uses TimeSpan to find the difference between the two dates
        System.TimeSpan variance = Date2.Subtract(Date1);

        // Converts the variance variable into number of nights the guest wants to stay for
        Double Nt = variance.TotalDays;
        Double D = 1;
        Double B = 1;
        Double SV = 1;
        Double numChildren = Double.Parse(txtChildren.Value);
        Double PA = Double.Parse(txtAdults.Value);
        Double P = PA + numChildren; // made this a Sum instead of just combining 2 stings

        D = Double.Parse(txtD.Value);
        B = Double.Parse(txtB.Value);
        SV = Double.Parse(txtSV.Value);

        if (D < 0 || B < 0)
        {
            parCost.InnerText = ("Unable to Calculate.");
            parVat.InnerText = ("Unable to Calculate.");
            parTotCost.InnerText = ("Unable to Calculate.");
        }
        else if (P < 0 || P > 4 || PA > 2)
        {
            parG.InnerText = (P.ToString() + " Guest Limit Exceeded.");
            parCost.InnerText = ("Unable to Calculate.");
            parVat.InnerText = ("Unable to Calculate.");
            parTotCost.InnerText = ("Unable to Calculate.");
        }
        else
        {
            Double Cost = Nt * 50.00 + (D * 35 * Nt) + (B * 15 * Nt) + (SV * 20 * Nt);
            Double Vat = Cost * 0.20;
            Double TotCost = Cost + Vat;

            parG.InnerText = (P.ToString());
            parNt.InnerText = (Nt.ToString());

            // Removed pound signs from cost and VAT because it was breaking the insert of the booking into the database
            parCost.InnerText = ("" + Cost);
            parVat.InnerText = ("" + Vat);
            parTotCost.InnerText = ("£" + TotCost);
        }
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
        <p>Update a Booking
        </p>          
          <table>
          <tr>
              <td>
    <input id="UpdateClient" type="submit" value="Change a Client's Details" runat="server"
           onserverclick="UpdateClient_Click" />
                  </td>
    <td>  
    <input id="UpdateBooking" type="submit" value="Amend another Booking" runat="server"
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
        <br />
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
            <td>Room Number:
            </td>
            <td>
              <asp:TextBox id="txtNum" type="text" style="background-color: khaki;" runat="server"/>
            </td>
          </tr>   
          <tr>
            <td>Original Check-in Date:
            </td>
            <td>
              <asp:TextBox id="txtChkIn" type="text" style="background-color: khaki;" runat="server"/>
            </td>
          </tr>     
          <tr>
            <td>Original Check-Out Date:
            </td>
            <td>
              <asp:TextBox id="txtChkOut" type="text" style="background-color: khaki;" runat="server"/>
            </td>
          </tr>
          <tr>
          <tr>
            <td>New Check-in Date:
            </td>
            <td>
              <asp:TextBox ID="ChkIn" runat="server" type="date" />
            </td>
          </tr>
          <tr>
            <td>New Check-Out Date:
            </td>
            <td>
              <asp:TextBox ID="ChkOut" runat="server" type="date" />
            </td>
          </tr>
          <tr>
            <td>Number of Nights:
            </td>
            <td id="parNt" type="text" style="background-color: lightgrey;" runat="server">
            </td>
          </tr>
          <%-- 
               <tr>
          <td>
            <input id="Submit2" type="submit" value="Available Rooms" runat="server"
                   onserverclick="SelectRoom" />
          </td>
          </tr>--%>
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
          <td>Number of Guests:
          </td>
          <td id="parG" type="text" style="background-color: lightgray;" runat="server">
          </td>
        </tr>
        <tr>
          <td>Room with Sea View (Room 101):
          </td>
          <td>
            <input id="txtSV" type="text" style="background-color: khaki;" runat="server"> 
          </td>
          <td><p>£20 extra, enter 1 for yes or 0 for no.</p></td>
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
          <td>
            <input id="btnCalc" type="submit" value="Calculate" runat="server"
                   onserverclick="btnCalc_Click" />
          </td>
        </tr>
        <tr>
          <td>Cost:
          </td>
          <td id="parCost" style="background-color: lightgray;" runat="server">
          </td>
        </tr>
        <tr>
          <td>VAT:
          </td>
          <td id="parVat" style="background-color: lightgray;" runat="server">
          </td>
        </tr>
        <tr>
          <td>Total Cost £
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
      <%--
           <div class="hidden_input">
      <input type="hidden" name="radioCheck" id="radioCheck" value="" runat="server" />
      </div>--%>
    <br />      
    <input id="AmendBooking" type="submit" value="Update Booking Details" runat="server"
           onserverclick="AmendBooking_Click" />
    <p id="parConfirmUpdate" runat="server" ></p>
    </center>
  </form>
</body>
</html>
