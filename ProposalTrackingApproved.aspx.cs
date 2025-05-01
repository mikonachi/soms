using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Web.Script.Serialization;
using System.Web.UI.WebControls;

namespace SOMS
{
    public partial class ProposalTrackingApproved : System.Web.UI.Page
    {
        private readonly string connectionString = ConfigurationManager.ConnectionStrings["OMSDB"].ConnectionString;
        dataAccess crud = new dataAccess();
        protected TextBox txtProposalDate;
        protected TextBox txtComment;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Session["UserAuthenticated"] != null && (bool)Session["UserAuthenticated"])
                {
                    BindEventsToRepeater(rptReceived, 4);

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


        private List<EventData> GetEventDataFromDatabase(int status)
        {
            List<EventData> eventList = new List<EventData>();
            string query = "SELECT Title, EventDate, StartTime, EndTime, Organization, Venue, EventID FROM Events WHERE Status = @Status AND ApprovedBy IS NOT NULL ORDER BY EventID ASC";

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

        protected void txtSearch_TextChanged(object sender, EventArgs e)
        {
            var eventList = GetEventDataFromDatabaseByRefNo(4);

            rptReceived.DataSource = eventList;
            rptReceived.DataBind();
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
        protected void btnContinue_Click(object sender, EventArgs e)
        {
            // Refresh the page after saving
            Response.Redirect(Request.RawUrl);
        }
    }
}