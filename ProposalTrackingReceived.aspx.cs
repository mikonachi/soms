using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Web.Script.Serialization;
using System.Web.UI.WebControls;

namespace SOMS
{
    public partial class ProposalTrackingReceived : System.Web.UI.Page
    {
        private readonly string connectionString = ConfigurationManager.ConnectionStrings["OMSDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Session["UserAuthenticated"] != null && (bool)Session["UserAuthenticated"])
                {
                    BindEventsToRepeater(rptReceived, 1);

                    string auth = GetOrganizationAuthByEmail(Session["email"].ToString());

                    if (auth == "FAC")
                    {
                        btnGroups.Visible = false;
                    }
                    else
                    {
                        btnGroups.Visible = true;
                    }
                }
                else
                {
                    Response.Redirect("LandingPage.aspx");
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


        private List<EventData> GetEventDataFromDatabase(int status)
        {
            List<EventData> eventList = new List<EventData>();
            string query = "SELECT Title, EventDate, StartTime, EndTime, Organization, Venue, EventID FROM Events WHERE Status = @Status ORDER BY EventID ASC";

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


        private List<EventData> GetEventDataFromDatabaseByRefNo(int status)
        {
            List<EventData> eventList = new List<EventData>();
            string query = "SELECT TOP (1) Title, EventDate, StartTime, EndTime, Organization, Venue, EventID FROM Events WHERE Status = @Status AND EventID LIKE '%' + @RefNo + '%' ORDER BY EventID";

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@Status", status);
                    cmd.Parameters.AddWithValue("@RefNo", txtSearch.Text); // Ensure text is passed to the query

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

        private void BindEventsToRepeaterByRefNo(Repeater repeater, int status)
        {
            var eventList = GetEventDataFromDatabaseByRefNo(status);
            repeater.DataSource = eventList;
            repeater.DataBind();
        }
        protected void txtSearch_TextChanged(object sender, EventArgs e)
        {
            var eventList = GetEventDataFromDatabaseByRefNo(1);
            if (eventList != null && eventList.Count > 0)
            {
                // Bind data to the repeater
                rptReceived.DataSource = eventList;
                rptReceived.DataBind();
            }
            else
            {
                // Handle empty list case (optional)
                Response.Write("No events found");
            }
        }


        protected void btnEventCalendar_Click(object sender, EventArgs e)
        {

            string auth = GetOrganizationAuthByEmail(Session["email"].ToString());

            if (auth == "FAC")
            {
                Response.Redirect("SOCalendar.aspx");
            }
            else
            {
                Response.Redirect("Calendar.aspx");
            }
        }

        protected void btnProposalTracking_Click(object sender, EventArgs e)
        {
            string auth = GetOrganizationAuthByEmail(Session["email"].ToString());

            if (auth == "FAC")
            {
                Response.Redirect("FacultyProposalTracking.aspx");
            }
            else
            {
                Response.Redirect("ProposalTracking.aspx");
            }

        }
        protected string GetProposalTrackingUrl()
        {
            string auth = GetOrganizationAuthByEmail(Session["email"].ToString());

            if (auth == "FAC")
            {
                return "FacultyProposalTracking.aspx";
            }
            else
            {
                return "ProposalTracking.aspx";
            }
        }


        private string GetOrganizationAuthByEmail(string email)
        {
            string organization = string.Empty;

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = @"
                                SELECT O.Authority
                                FROM TB_Authority A
                                JOIN TB_Organization O ON A.organization = O.Organization
                                WHERE A.email = @Email;
                            ";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@Email", email);
                    conn.Open();
                    object result = cmd.ExecuteScalar();
                    if (result != null)
                    {
                        organization = result.ToString();
                    }
                }
            }

            return organization;
        }

        protected void btnGroups_Click(object sender, EventArgs e)
        {
            Response.Redirect("ManageGroups.aspx");
        }

        protected void btnSettings_Click(object sender, EventArgs e)
        {
            string auth = GetOrganizationAuthByEmail(Session["email"].ToString());

            if (auth == "FAC")
            {
                Response.Redirect("SOSettings.aspx");
            }
            else
            {
                Response.Redirect("AdminSettings.aspx");
            }

        }

    }
}