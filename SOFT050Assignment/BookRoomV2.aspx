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

    void btnAddGuest_Click(Object s, EventArgs e)
    {
        // Establishes database connection
        String cs = "Provider=Microsoft.ACE.OLEDB.12.0;" +
                    "Data Source=" + Server.MapPath("HotelBooking.accdb") + ";";
        OleDbConnection cn = new OleDbConnection(cs);
        OleDbCommand cmd;
        OleDbDataReader r;

        // Inserts into guest table, guest details
        String sql = "INSERT INTO Guest (FirstName, Surname, Email, Telephone, " +
            "AddressLine1, AddressLine2, AddressLine3, Postcode, Marketing) VALUES " +
            "('" + txtFirstName.Value + "', " +
            "'" + txtSurname.Value + "'," +
            "'" + txtEmail.Value + "'," +
            "'" + txtTelephone.Value + "'," +
            "'" + txtAddressLine1.Value + "'," +
            "'" + txtAddressLine2.Value + "'," +
            "'" + txtAddressLine3.Value + "'," +
            "'" + txtPostcode.Value + "'," +
            "" + Marketing.Checked + ")";

        parConfirmClientSaved.Value = ("Customer Details Saved.");
        AddGuest.Disabled = true;

        cmd = new OleDbCommand(sql, cn);
        cn.Open();
        r = cmd.ExecuteReader();
        //Close connection to database
        cn.Close();
    }
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
            AddGuest.Disabled = true;
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

    void btn_BookRoom(Object s, EventArgs e)
    {
        // Establishes database connection
        String cs = "Provider=Microsoft.ACE.OLEDB.12.0;" +
                  "Data Source=" + Server.MapPath("HotelBooking.accdb") + ";";
        OleDbConnection cn = new OleDbConnection(cs);
        OleDbCommand cmd;
        OleDbDataReader r;
        String Book = "INSERT INTO Booking (GuestID, CheckIn, CheckOut, " +
         "Dinner, Breakfast, Adults, Children, RoomNumber, TotCost, Payment) " +
         // Inserts the ID selected from the Guest table
         // https://www.w3schools.com/SQL/sql_insert_into_select.asp
         "SELECT ID, '" + ChkIn.Text + "'," +
          "'" + ChkOut.Text + "'," +
          "'" + txtD.Value + "'," +
          "'" + txtB.Value + "'," +
          "'" + txtAdults.Value + "'," +
          "'" + txtChildren.Value + "'," +
          "'" + txtNum.InnerHtml + "'," +
          "'" + parTotCost.InnerHtml + "'," +
          // uses email address from guest table to match against the correct guest
          "" + Payment.Checked + " from Guest where Email = '" + txtEmail.Value + "';";

        parConfirmRoomBooked.Value = ("Booking Saved.");
        BookRoom.Disabled = true;

        cmd = new OleDbCommand(Book, cn);
        cn.Open();
        r = cmd.ExecuteReader();
        // While reading each row in the database.
        //Close connection to database
        cn.Close();
    }

    void btnCalc_Click(Object s, EventArgs e)
    {
        // Prints out value of radiobutton AKA room number
        // this is for the purposes of inserting BACK into the database for the booking entry, where the room number is required
        txtNum.InnerText = radioCheck.Value;

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
            parCost.InnerHtml= ("Unable to Calculate.");
            parVat.InnerHtml = ("Unable to Calculate.");
            parTotCost.InnerHtml = ("Unable to Calculate.");
        }
        else if (P < 0 || P > 4 || PA > 2)
        {
            parG.InnerHtml = (P.ToString() + " Guest Limit Exceeded.");
            parCost.InnerHtml = ("Unable to Calculate.");
            parVat.InnerHtml = ("Unable to Calculate.");
            parTotCost.InnerHtml = ("Unable to Calculate.");
        }else
        {
            Double Cost = Nt * 50.00 + (D * 35 * Nt) + (B * 15 * Nt) + (SV * 20 * Nt);
            Double Vat = Cost * 0.20;
            Double TotCost = Cost + Vat;

            parG.InnerHtml = (P.ToString());
            parNt.InnerHtml = (Nt.ToString());

            // Removed pound signs because it was breaking the insert of the booking into the database
            parCost.InnerHtml = ("" + Cost);
            parVat.InnerHtml = ("" + Vat);
            parTotCost.InnerHtml = ("£" + TotCost);
        }

    }

    void SelectRoom(Object s, EventArgs e)
    {
        // Establishes database connection
        String cs = "Provider=Microsoft.ACE.OLEDB.12.0;" +
                  "Data Source=" + Server.MapPath("HotelBooking.accdb") + ";";
        OleDbConnection cn = new OleDbConnection(cs);
        OleDbCommand cmd;
        String h;
        OleDbDataReader r;
        h = "";

        // Gets room numbers from rooms, next step is to only show available rooms by date
        String room = "SELECT Room.RoomNumber FROM Room " +
                // SELECTs rooms FROM Room that have not yet been booked, as they don't appear in the Booking table
                "WHERE Room.RoomNumber NOT IN (SELECT Booking.RoomNumber FROM Booking)" +
                // UNION to combine results from both booking and room tables
                "UNION " +
                "SELECT Booking.RoomNumber FROM Booking " +
                "WHERE " +
                // Looks for rooms booked outside of the range of the user inputted dates 
                // where user inputted ChkIn and ChkOut is greater than (after) the booked checkIn date
                "(Booking.CheckIn < CDate('" + ChkIn.Text + "') AND Booking.CheckIn <= CDate('" + ChkOut.Text + "')) " +
                "AND " + //must meet both of these conditions
                         // where user inputted ChkIn and ChkOut is greater than (after) the booked checkOut date
                "(Booking.CheckOut <= CDate('" + ChkIn.Text + "') AND Booking.CheckOut < CDate('" + ChkOut.Text + "'))" +

                "OR " +
                // where user inputted ChkIn and ChkOut is less than (before) the booked checkIn date
                "(Booking.CheckIn > CDate('" + ChkIn.Text + "') AND Booking.CheckIn >= CDate('" + ChkOut.Text + "')) " +
                "AND " +
                // where user inputted ChkIn and ChkOut is less than (before) the booked checkOut date
                "(Booking.CheckOut >= CDate('" + ChkIn.Text + "') AND Booking.CheckOut > CDate('" + ChkOut.Text + "'))";

        cmd = new OleDbCommand(room, cn);
        cn.Open();
        r = cmd.ExecuteReader();

        // While reading each row in the database..
        while(r.Read()) {
            // Prints the radio buttons and labels to the page for each room number in the database - more rooms could be added
            // Each radio button runs the Javascript save(), from the <html> <head> function below when it changes state - line 176. because before, the radio buttons would clear each time the calculate button was pressed
            h = h + "<input id=\"rm" + r["RoomNumber"] + "\" type=\"radio\" name=\"roomNumber\" value=\"" + r["RoomNumber"] + "\" onchange=\"save()\" />";
            // Labels for the radio buttons
            h = h + "<label for=\"rm" + r["RoomNumber"] + "\">" + r["RoomNumber"] +"</label><br>";
        }
        parData.InnerHtml = h;
        cn.Close();
    }
   
</script>
<html>
  <head>
    <title>HotelCharge
    </title>
    <%-- JQuery link to source it otherwise JQUERY cannot be used here --%>
      <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js">
      </script>
      <script>
          // JQuery function to store value of checked radiobutton
          $(function () {
              $("input[type='radio']").click(function () {
                  // select room # by checking radio button
                  var radioValue = $("input[name='roomNumber']:checked").val();
                  // room # that has been checked
                  // radioValue is the RoomNumber
                  if (radioValue) {
                      $("#radioCheck").val(radioValue);
                      // stores checked room # in the box on the right
                  }
              }
              );
          }
          );

      </script>
      </head>
    <body style="background-color: lightblue;" onload="load()">
      <form runat="server">
        <center>
          <p>Hotel Room Charge Calculator
          </p>
          <br />
          <table>
          <tr>
          <td>
          <input id="UpdateClient" type="submit" value="Change Client Details" runat="server"
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
            <input id="txtID" type="text" autocomplete="off" style="background-color: khaki;" runat="server">
          </p>
          <br />       
        <p>     
          <input id="Display" type="submit" value="Display Client Details" runat="server"
                 onserverclick="Display_Click" />
        </p>
        <p id="invalidGuestRef" runat="server" style="color:red;">
        </p>
        <table>
            <tr>
              <td>Enter New client details:
              </td>
            </tr>
            <tr>
              <td>First Name:
              </td>
              <td>
                <input id="txtFirstName" type="text" style="background-color: khaki;" runat="server">
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
              <td>Address Line 1
              </td>
              <td>
                <input id="txtAddressLine1" type="text" style="background-color: khaki;" runat="server">
              </td>
            </tr>
            <tr>
              <td>Address Line 2
              </td>
              <td>
                <input id="txtAddressLine2" type="text" style="background-color: khaki;" runat="server">
              </td>
            </tr>
            <tr>
              <td>Address Line 3
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
                <input id="Marketing" type="checkbox" style="background-color: khaki;" runat="server">
              </td>
            </tr>               
            <tr>
              <td>Check-in Date:
              </td>
              <td>
                <asp:TextBox ID="ChkIn" runat="server" type="date" />
              </td>
            </tr>
            <tr>
              <td>Check-Out Date:
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
            <tr>
              <td>
                <input id="Submit2" type="submit" value="Available Rooms" runat="server"
                       onserverclick="SelectRoom" />
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
              <td>Number of Guests:
              </td>
              <td id="parG" type="text" style="background-color: lightgrey;" runat="server">
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
              <td>
                <label for="Choose">Choose a Room:
                </label>
                <p id="parData" runat="server">
                </p>
              </td>
            </tr>
            <tr>
              <td>Selected room number:
              </td>
              <td style="background-color: lightgrey;">
              <p id="txtNum" name="txtNum" runat="server">
              </p>
              </td>
            </tr>
            <tr>
              <td>Cost:
              </td>
              <td id="parCost" style="background-color: lightgrey;" runat="server">
              </td>
            </tr>
            <tr>
              <td>VAT:
              </td>
              <td id="parVat" style="background-color: lightgrey;" runat="server">
              </td>
            </tr>
            <tr>
              <td>Total Cost £
              </td>
              <td id="parTotCost" style="background-color: lightgrey;" runat="server">
              </td>
            </tr>
            <tr>
              <td>
                <input id="AddGuest" type="submit" value="Save Customer Details" runat="server"
                       onserverclick="btnAddGuest_Click" />
              </td>
              <td>
                <input id="parConfirmClientSaved" type="text" style="background-color: lightgray;" runat="server" />
              </td>
            </tr>
            <tr>
              <td> 
                <input id="BookRoom" type="submit" value="Book Room" runat="server"
                       onserverclick="btn_BookRoom" />
              </td>   
              <td>
                <input id="parConfirmRoomBooked" type="text" style="background-color: lightgray;" runat="server" />                       
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
        </center>
      </form>
    </body>
    </html>
