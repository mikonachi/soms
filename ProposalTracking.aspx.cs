using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Web.Script.Serialization;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace SOMS
{
    public partial class ProposalTracking : Page
    {
        private readonly string connectionString = ConfigurationManager.ConnectionStrings["OMSDB"].ConnectionString;
        protected TextBox txtProposalDate;
        protected TextBox txtComment;

        dataAccess crud = new dataAccess();


        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserAuthenticated"] != null && (bool)Session["UserAuthenticated"])
            {
                if (!IsPostBack)
                {
                    BindEventsToRepeater(rptReceived, 1);
                    BindEventsToRepeater(rptPending, 2);
                    BindEventsToRepeater(rptRevDisApp, 3);
                    BindEventsToRepeater(rptApproved, 4);
                }

                string numericRefNo = Request.QueryString["numericRefNo"];

                if (!string.IsNullOrEmpty(numericRefNo))
                {
                    // Call method to fetch data based on the numericRefNo
                    string result = GetValueFromDatabase(numericRefNo);
                    Response.ContentType = "text/plain";
                    Response.Write(result); // Send the result as plain text to the client
                    Response.End();
                }

            }
            else
            {
                Response.Redirect("LandingPage.aspx");
            }

        }

        private string GetValueFromDatabase(string numericRefNo)
        {
            var result = new
            {
                Title = string.Empty,
                Venue = string.Empty,
                Organization = string.Empty,
                EventDate = string.Empty,
                TimeStart = string.Empty,
                TimeEnd = string.Empty,
                FacultyAppearance = string.Empty,
                SoundSystem = string.Empty,
                Chairs = string.Empty,
                Curtains = string.Empty,
                ScreenAndProjector = string.Empty,
                Podium = string.Empty
            };

            string connectionString = ConfigurationManager.ConnectionStrings["OMSDB"].ConnectionString;

            string query = "SELECT Title, Venue, Organization, EventDate, StartTime, EndTime, FacultyAppearance, SoundSystem, Chairs, Curtains, ScreenAndProjector, Podium FROM Events WHERE EventID = @NumericRefNo";

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@NumericRefNo", numericRefNo);

                try
                {
                    conn.Open();
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            // Retrieve values
                            string title = reader["Title"].ToString();
                            string venue = reader["Venue"].ToString();
                            string organization = reader["Organization"].ToString();
                            string eventDate = reader["EventDate"].ToString();
                            string timeStart = reader["StartTime"].ToString();
                            string timeEnd = reader["EndTime"].ToString();
                            string facultyAppearance = reader["FacultyAppearance"].ToString();
                            string soundSystem = reader["SoundSystem"].ToString();
                            string chairs = reader["Chairs"].ToString();
                            string curtains = reader["Curtains"].ToString();
                            string screenAndProjector = reader["ScreenAndProjector"].ToString();
                            string podium = reader["Podium"].ToString();

                            //// Format the date and time
                            string formattedEventDate = FormatEventDate(eventDate);
                            //string formattedTimeStart = FormatEventTime(timeStart);
                            //string formattedTimeEnd = FormatEventTime(timeEnd);

                            // Return formatted data as JSON
                            result = new
                            {
                                Title = title,
                                Venue = venue,
                                Organization = organization,
                                EventDate = formattedEventDate,
                                //TimeStart = formattedTimeStart,
                                //TimeEnd = formattedTimeEnd
                                TimeStart = timeStart,
                                TimeEnd = timeEnd,
                                FacultyAppearance = facultyAppearance,
                                SoundSystem = soundSystem,
                                Chairs = chairs,
                                Curtains = curtains,
                                ScreenAndProjector = screenAndProjector,
                                Podium = podium
                            };
                        }
                    }
                }
                catch (Exception ex)
                {

                }
            }

            return new JavaScriptSerializer().Serialize(result);
        }


        private string FormatEventDate(string dateStr)
        {
            DateTime date;
            if (DateTime.TryParse(dateStr, out date))
            {
                return date.ToString("yyyy-MM-dd");  // Format date as YYYY-MM-DD
            }
            return string.Empty;
        }

        private string FormatEventTime(string timeStr)
        {
            DateTime time;
            if (DateTime.TryParse(timeStr, out time))
            {
                return time.ToString("h tt");  // Format time as 12-hour AM/PM
            }
            return string.Empty;
        }


        private List<EventData> GetEventDataFromDatabase(int status)
        {
            List<EventData> eventList = new List<EventData>();
            string query = "SELECT TOP 4 Title, EventDate, StartTime, EndTime, Organization, Venue, EventID FROM Events WHERE Status = @Status AND ProposalSentDate IS NOT NULL ORDER BY EventID";

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@Status", status);

                    conn.Open();
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            TimeSpan startTime = (TimeSpan)reader["StartTime"];
                            TimeSpan endTime = (TimeSpan)reader["EndTime"];
                            string formattedTime = $"{DateTime.Today.Add(startTime):h tt} - {DateTime.Today.Add(endTime):h tt}";
                            string eventDate = reader["EventDate"].ToString();
                            string refNo = FormatReferenceNo(reader["EventID"].ToString());

                            eventList.Add(new EventData
                            {
                                TimeStart = eventDate,
                                TimeEnd = formattedTime,
                                Organization = reader["Organization"].ToString().ToUpper(),
                                Venue = reader["Venue"].ToString(),
                                ReferenceNo = "Ref No. " + refNo,
                            });

                        }
                    }
                }
            }
            return eventList;
        }


        private string FormatReferenceNo(string referenceNo)
        {
            return int.TryParse(referenceNo, out int number) ? number.ToString("D6") : referenceNo;
        }




        protected void btnSaveEvent_Click(object sender, EventArgs e)
        {
            int isPodiumChecked = Request.Form.GetValues("cbPodium") != null ? 1 : 0;
            int isChairsChecked = Request.Form.GetValues("cbChairs") != null ? 1 : 0;
            int isCurtainsChecked = Request.Form.GetValues("cbCurtains") != null ? 1 : 0;
            int isSoundSystemChecked = Request.Form.GetValues("cbSoundSystem") != null ? 1 : 0;
            int isScreenAndProjectorChecked = Request.Form.GetValues("cbScreenAndProjector") != null ? 1 : 0;

            // Insert into database
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = "INSERT INTO Events (Title, Venue, EventDate, Organization, Email,FacultyAppearance, StartTime, EndTime, " +
                               "SoundSystem, Chairs, Curtains, ScreenAndProjector, Podium, Status, ReceivedDate, ReceivedBy, PrososalSentDate) " +
                               "VALUES (@Title, @Venue, @EventDate, @Organization, @email, @faculty, @StartTime, @EndTime, " +
                               "@SoundSystem, @Chairs, @Curtains, @ScreenAndProjector, @Podium, 1, @ReceivedDate, @ReceivedBy, GETDATE())";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@Title", txtTitle.Text.ToUpper());
                    cmd.Parameters.AddWithValue("@Venue", ddlVenue.SelectedItem.Text);
                    cmd.Parameters.AddWithValue("@EventDate", Convert.ToDateTime(txtEventDate.Text));
                    cmd.Parameters.AddWithValue("@Organization", ddlOrgname.SelectedValue.ToString());
                    cmd.Parameters.AddWithValue("@faculty", ddlFacultyMember.SelectedValue.ToString());
                    cmd.Parameters.AddWithValue("@email", Session["email"].ToString());
                    cmd.Parameters.AddWithValue("@StartTime", TimeSpan.Parse(txtEventTime.Text));
                    cmd.Parameters.AddWithValue("@EndTime", TimeSpan.Parse(txtEndTime.Text));
                    cmd.Parameters.AddWithValue("@ReceivedDate", Convert.ToDateTime(txtProposalDate.Text));
                    cmd.Parameters.AddWithValue("@ReceivedBy", Session["email"].ToString());
                    cmd.Parameters.AddWithValue("@SoundSystem", isSoundSystemChecked);
                    cmd.Parameters.AddWithValue("@Chairs", isChairsChecked);
                    cmd.Parameters.AddWithValue("@Curtains", isCurtainsChecked);
                    cmd.Parameters.AddWithValue("@ScreenAndProjector", isScreenAndProjectorChecked);
                    cmd.Parameters.AddWithValue("@Podium", isPodiumChecked);

                    conn.Open();
                    cmd.ExecuteNonQuery();
                }
            }

            // Refresh the page after saving
            Response.Redirect(Request.RawUrl);
        }

        protected void btnCancelEdit_Click(object sender, EventArgs e)
        {
            BindEventsToRepeater(rptReceived, 1);
        }


        public class EventData
        {
            public string TimeStart { get; set; }
            public string TimeEnd { get; set; }
            public string Organization { get; set; }
            public string Venue { get; set; }
            public string ReferenceNo { get; set; }
        }


        private void BindEventsToRepeater(Repeater repeater, int status)
        {
            var eventList = GetEventDataFromDatabase(status);
            repeater.DataSource = eventList;
            repeater.DataBind();
        }


        protected void btnCommentSend_Click(object sender, EventArgs e)
        {
            string formattedReferenceNo = RevertReferenceNo(hfCommentRefNo.Value.ToString());

            string procedureName = "SP_AddEventComment";

            SqlParameter[] parameters =
            {
                new SqlParameter("@eventReferenceNo", formattedReferenceNo), // Use the reverted reference number here
                new SqlParameter("@comment", txtComment.Text),
                new SqlParameter("@commentBy", Session["email"].ToString()),
            };

            try
            {
                int rowsAffected = crud.ExecuteStoredProc(procedureName, parameters);

                if (rowsAffected > 0)
                {
                    ClientScript.RegisterStartupScript(this.GetType(), "ShowModal", "showModalSuccess()", true);
                    txtComment.Text = string.Empty;
                }
                else
                {
                    ClientScript.RegisterStartupScript(this.GetType(), "alertScript", "alert('ERROR!');", true);
                }
            }
            catch
            {

            }
        }

        private string RevertReferenceNo(string formattedReferenceNo)
        {
            if (formattedReferenceNo.StartsWith("Ref No. "))
            {
                string numberPart = formattedReferenceNo.Substring(8);

                if (int.TryParse(numberPart, out int number))
                {
                    return number.ToString();
                }
            }

            return formattedReferenceNo;
        }

        protected void btnEventCalendar_Click(object sender, EventArgs e)
        {
            Response.Redirect("Calendar.aspx");
        }

        protected void btnGroups_Click(object sender, EventArgs e)
        {
            Response.Redirect("ManageGroups.aspx");
        }

        protected void btnSettings_Click(object sender, EventArgs e)
        {
            Response.Redirect("AdminSettings.aspx");
        }

        protected void btnProceedToPending_Click(object sender, EventArgs e)
        {
            // Update into database
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = "UPDATE Events " +
                "SET Status = Status + 1, " +
                "ReceivedBy = CASE WHEN Status = 1 THEN @email ELSE ReceivedBy END, " +  // Set ReceivedBy when Status is 1
                "ReceivedDate = CASE WHEN Status = 1 THEN GETDATE() ELSE ReceivedDate END, " +  // Set ReceivedDate when Status is 1
                "PendingBy = CASE WHEN Status = 2 THEN @email ELSE PendingBy END, " +  // Set PendingBy when Status is 2
                "PendingDate = CASE WHEN Status = 2 THEN GETDATE() ELSE PendingDate END, " +  // Set PendingDate when Status is 2
                "FinalizedBy = CASE WHEN Status = 3 THEN @email ELSE FinalizedBy END, " +  // Set FinalizedBy when Status is 3
                "FinalizingDate = CASE WHEN Status = 3 THEN GETDATE() ELSE FinalizingDate END " +  // Set FinalizingDate when Status is 3
                "WHERE EventID = @EventID";



                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    // Set parameters properly
                    cmd.Parameters.AddWithValue("@EventID", hfRefNo.Value);
                    cmd.Parameters.AddWithValue("@email", Session["email"].ToString());/*Session["email"].ToString()*/


                    conn.Open();
                    cmd.ExecuteNonQuery();
                }

                ClientScript.RegisterStartupScript(this.GetType(), "ShowModal", "showModalSuccess()", true);

            }
        }

        protected void btnContinue_Click(object sender, EventArgs e)
        {
            // Refresh the page after saving
            Response.Redirect(Request.RawUrl);
        }

        protected void btnUpdateEventDetails_Click(object sender, EventArgs e)
        {
            int isPodiumChecked = Request.Form.GetValues("cbPodiumEdit") != null ? 1 : 0;
            int isChairsChecked = Request.Form.GetValues("cbChairsEdit") != null ? 1 : 0;
            int isCurtainsChecked = Request.Form.GetValues("cbCurtainsEdit") != null ? 1 : 0;
            int isSoundSystemChecked = Request.Form.GetValues("cbSoundSystemEdit") != null ? 1 : 0;
            int isScreenAndProjectorChecked = Request.Form.GetValues("cbScreenAndProjectorEdit") != null ? 1 : 0;

            string procedureName = "SP_EditEventDetails";

            SqlParameter[] parameters =
            {
                new SqlParameter("@id", Convert.ToInt32(hfRefNo.Value)), // Corrected parameter name and converted to int
                new SqlParameter("@title", txtTitleEdit.Text),  // Extracting Text property
                new SqlParameter("@venue", ddlVenueEdit.SelectedValue.ToString()),
                new SqlParameter("@eventDate", Convert.ToDateTime(txtEventDateEdit.Text)), // Ensuring correct format
                new SqlParameter("@organization", txtOrgNameEdit.Text),
                new SqlParameter("@startTime", TimeSpan.Parse(txtEventTimeEdit.Text)), // Ensuring time format
                new SqlParameter("@endTime", TimeSpan.Parse(txtEndTimeEdit.Text)),
                new SqlParameter("@faculty", ddlFacultyEdit.SelectedValue.ToString()),
                new SqlParameter("@soundSystem", isSoundSystemChecked),
                new SqlParameter("@chairs", isChairsChecked),
                new SqlParameter("@curtains", isCurtainsChecked),
                new SqlParameter("@screenProjector", isScreenAndProjectorChecked),
                new SqlParameter("@podium", isPodiumChecked),
                new SqlParameter("@editedBy", Session["email"].ToString()) // Change to actual email session
            };

            try
            {
                int rowsAffected = crud.ExecuteStoredProc(procedureName, parameters);

                if (rowsAffected > 0)
                {
                    ClientScript.RegisterStartupScript(this.GetType(), "ShowModal", "showModalSuccess()", true);
                    txtComment.Text = string.Empty;
                }
                else
                {
                    ClientScript.RegisterStartupScript(this.GetType(), "alertScript", "alert('ERROR!');", true);
                }
            }
            catch (Exception ex)
            {
                ClientScript.RegisterStartupScript(this.GetType(), "alertScript", $"alert('ERROR: {ex.Message}');", true);
            }
        }

        protected void btnRevision_Click(object sender, EventArgs e)
        {
            ClientScript.RegisterStartupScript(this.GetType(), "ShowModal", "showModalConf()", true);
            hfConfirmationButtonClicked.Value = "Revision";

        }

        protected void btnDisap_Click(object sender, EventArgs e)
        {
            ClientScript.RegisterStartupScript(this.GetType(), "ShowModal", "showModalConf()", true);
            hfConfirmationButtonClicked.Value = "Disapproved";
            // Update into database

        }

        protected void btnApprove_Click(object sender, EventArgs e)
        {
            ClientScript.RegisterStartupScript(this.GetType(), "ShowModal", "showModalConf()", true);
            hfConfirmationButtonClicked.Value = "Approved";
            // Update into database

        }

        protected void lbReceived_Click(object sender, EventArgs e)
        {
            Response.Redirect("ProposalTrackingReceived.aspx");
        }

        protected void lbPending_Click(object sender, EventArgs e)
        {
            Response.Redirect("ProposalTrackingPending.aspx");
        }

        protected void lbRevDis_Click(object sender, EventArgs e)
        {
            Response.Redirect("ProposalTrackingRevDis.aspx");
        }

        protected void lbApproved_Click(object sender, EventArgs e)
        {
            Response.Redirect("ProposalTrackingApproved.aspx");
        }

        protected void btnConfirmAskDelete_Click(object sender, EventArgs e)
        {

            if (hfConfirmationButtonClicked.Value == "Revision")
            {
                // Update into database
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    string query = "UPDATE Events " +
                    "SET Status = 5, " +
                    "ApprovedBy = @email, " +
                    "ApprovedDate = GETDATE() " +
                    "WHERE EventID = @EventID";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        // Set parameters properly
                        cmd.Parameters.AddWithValue("@EventID", hfRefNo.Value);
                        cmd.Parameters.AddWithValue("@email", Session["email"].ToString());


                        conn.Open();
                        cmd.ExecuteNonQuery();
                    }
                }
            }
            else if (hfConfirmationButtonClicked.Value == "Disapproved")
            {

                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    string query = "UPDATE Events " +
                    "SET Status = 6, " +
                    "ApprovedBy = @email, " +
                    "ApprovedDate = GETDATE() " +
                    "WHERE EventID = @EventID";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        // Set parameters properly
                        cmd.Parameters.AddWithValue("@EventID", hfRefNo.Value);
                        cmd.Parameters.AddWithValue("@email", Session["email"].ToString());/*Session["email"].ToString()*/


                        conn.Open();
                        cmd.ExecuteNonQuery();
                    }

                }
            }

            else
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    string query = "UPDATE Events " +
                    "SET Status = 4, " +
                    "ApprovedBy = @email, " +
                    "ApprovedDate = GETDATE() " +
                    "WHERE EventID = @EventID";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        // Set parameters properly
                        cmd.Parameters.AddWithValue("@EventID", hfRefNo.Value);
                        cmd.Parameters.AddWithValue("@email", Session["email"].ToString());/*Session["email"].ToString()*/


                        conn.Open();
                        cmd.ExecuteNonQuery();
                    }


                }
            }

            ClientScript.RegisterStartupScript(this.GetType(), "ShowModal", "showModalSuccess()", true);

        }
    }
}
