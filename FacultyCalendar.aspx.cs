using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace SOMS
{
    public partial class FacultyCalendar : System.Web.UI.Page
    {
        private string connectionString = ConfigurationManager.ConnectionStrings["OMSDB"].ConnectionString;
        public string EventsJson { get; set; }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Session["UserAuthenticated"] != null && (bool)Session["UserAuthenticated"])
                {
                    // Retrieve email from session
                    string userEmail = Session["email"] as string;

                    if (!string.IsNullOrEmpty(userEmail))
                    {
                        // Get the organization from the database
                        string userOrganization = GetOrganizationByEmail(userEmail);

                        if (!string.IsNullOrEmpty(userOrganization))
                        {
                            txtOrgName.Text = userOrganization; // Set organization name in the textbox
                        }
                    }

                    txtLblCountPendingRequests.Text = "#" + GetPendingRequestsCount().ToString();

                    LoadEvents();

                    // Fetch event data from the database
                    var eventList = GetEventDataFromDatabase();

                    // Bind the event list to the Repeater
                    rptEventControls.DataSource = eventList;
                    rptEventControls.DataBind();
                }
                else
                {
                    Response.Redirect("LandingPage.aspx");
                }
            }

        }

        private string GetOrganizationByEmail(string email)
        {
            string organization = string.Empty;

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = "SELECT Organization FROM TB_Authority WHERE Email = @Email";
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

        private int GetPendingRequestsCount()
        {
            int count = 0;

            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    string query = "SELECT COUNT(*) FROM Events WHERE Status IN (1,2, 3)";
                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        conn.Open();
                        count = (int)cmd.ExecuteScalar();
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error fetching pending requests: " + ex.Message);
            }

            return count;
        }



        private void LoadEvents()
        {
            List<object> events = new List<object>();

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = "SELECT Organization, EventDate, StartTime, EndTime, Venue FROM Events WHERE Status = 4 AND Organization <> 'System Administrator' ORDER BY EventDate ASC"; /*AND Organization<> 'OSAS'*/
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    conn.Open();
                    SqlDataReader reader = cmd.ExecuteReader();
                    while (reader.Read())
                    {
                        string eventDate = Convert.ToDateTime(reader["EventDate"]).ToString("yyyy-MM-dd");
                        TimeSpan startTime = (TimeSpan)reader["StartTime"];
                        TimeSpan endTime = (TimeSpan)reader["EndTime"];

                        DateTime eventStartDateTime = DateTime.Today.Add(startTime);
                        DateTime eventEndDateTime = DateTime.Today.Add(endTime);

                        string eventTime = eventStartDateTime.ToString("h tt") + " - " + eventEndDateTime.ToString("h tt");

                        string orgName = reader["Organization"].ToString();
                        string venue = reader["Venue"].ToString();

                        // Set the background color based on the organization
                        string colorClass = GetColorClassForOrganization(orgName);

                        events.Add(new
                        {
                            title = $"{eventTime}",
                            start = eventDate,
                            description = $"<span class='org-name'>{orgName}</span><br>{venue}",
                            className = colorClass  // Add the class to the event
                        });
                    }
                }
            }

            JavaScriptSerializer js = new JavaScriptSerializer();
            EventsJson = js.Serialize(events);
        }


        private List<EventData> GetEventDataFromDatabase()
        {
            List<EventData> eventList = new List<EventData>();

            string query = "SELECT TOP 3 EventDate, StartTime, EndTime, Organization, Venue, EventID FROM Events WHERE Status = 4 AND EventDate >= GETDATE() AND Organization = @organization ORDER BY EventDate ASC";

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@organization", txtOrgName.Text);
                    Session["organization"] = txtOrgName.Text;

                    conn.Open();
                    SqlDataReader reader = cmd.ExecuteReader();


                    while (reader.Read())
                    {


                        TimeSpan startTime1 = (TimeSpan)reader["StartTime"];
                        TimeSpan endTime1 = (TimeSpan)reader["EndTime"];
                        DateTime eventStartDateTime1 = DateTime.Today.Add(startTime1);
                        DateTime eventEndDateTime1 = DateTime.Today.Add(endTime1);
                        string eventTimeStart1 = eventStartDateTime1.ToString("h tt");
                        string eventTimeEnd1 = eventEndDateTime1.ToString("h tt");
                        string combiTime = eventTimeStart1 + " - " + eventTimeEnd1;

                        string eventDate = reader["EventDate"].ToString();

                        string refNo = FormatReferenceNo(reader["EventID"].ToString());


                        eventList.Add(new EventData
                        {
                            TimeStart = eventDate,
                            TimeEnd = combiTime,
                            Organization = reader["Organization"].ToString().ToUpper(),
                            Venue = reader["Venue"].ToString(),
                            ReferenceNo = "Ref No. " + refNo
                        });
                    }
                }
            }

            return eventList;
        }



        public class EventData
        {
            public string TimeStart { get; set; }
            public string TimeEnd { get; set; }
            public string Organization { get; set; }
            public string Venue { get; set; }
            public string ReferenceNo { get; set; }
        }

        private string FormatReferenceNo(string referenceNo)
        {
            return int.TryParse(referenceNo, out int number) ? number.ToString("D6") : referenceNo;
        }

        private string GetColorClassForOrganization(string orgName)
        {

            switch (orgName.ToLower())
            {
                case "thecognizant":
                    return "org-color-thecognizant";
                case "thecog...":
                    return "org-color-thecognizant";
                case "caremo...":
                    return "org-color-caremorenow";
                case "emc":
                    return "org-color-emc";
                case "itec":
                    return "org-color-itec";
                case "feso":
                    return "org-color-feso";
                case "shots":
                    return "org-color-shots";
                case "elite":
                    return "org-color-elite";
                case "ypads":
                    return "org-color-ypads";
                case "shield":
                    return "org-color-shield";
                case "jma":
                    return "org-color-jma";
                case "hrmsa":
                    return "org-color-hrmsa";
                case "quizsoc":
                    return "org-color-quizsoc";
                case "enc":
                    return "org-color-enc";
                case "caremorenow":
                    return "org-color-caremorenow";
                case "osas":
                    return "org-color-osas";
                default:
                    return "org-color-default";
            }

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
                string query = @"INSERT INTO Events 
                                (Title, Venue, EventDate, Organization, FacultyAppearance, StartTime, EndTime, Email, 
                                 SoundSystem, Chairs, Curtains, ScreenAndProjector, Podium, Status) 
                                VALUES 
                                (@Title, @Venue, @EventDate, @Organization, @Faculty, @StartTime, @EndTime, @Email, 
                                 @SoundSystem, @Chairs, @Curtains, @ScreenAndProjector, @Podium, 4)";


                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@Title", txtTitle.Text);
                    cmd.Parameters.AddWithValue("@Venue", ddlVenue.SelectedValue);
                    cmd.Parameters.AddWithValue("@EventDate", Convert.ToDateTime(txtEventDate.Text));
                    cmd.Parameters.AddWithValue("@Organization", txtOrgName.Text);
                    cmd.Parameters.AddWithValue("@Faculty", ddlFacultyMember.SelectedItem.Text);
                    cmd.Parameters.AddWithValue("@StartTime", TimeSpan.Parse(txtEventTime.Text));
                    cmd.Parameters.AddWithValue("@EndTime", TimeSpan.Parse(txtEndTime.Text));
                    cmd.Parameters.AddWithValue("@Email", Session["email"].ToString());
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




        protected void btnEventCalendar_Click(object sender, EventArgs e)
        {
            // Handle Event Calendar button click
            Response.Redirect("FacultyCalendar.aspx");
        }

        protected void btnProposalTracking_Click(object sender, EventArgs e)
        {
            // Handle Proposal Tracking button click
            Response.Redirect("FacultyProposalTracking.aspx");
        }

        protected void btnSettings_Click(object sender, EventArgs e)
        {
            // Handle Settings button click
            Response.Redirect("SOSettings.aspx");
        }

        protected void btnCancelEdit_Click(object sender, EventArgs e)
        {
            LoadEvents();

            var eventList = GetEventDataFromDatabase();
        }

        protected void btnCheck_Click(object sender, EventArgs e)
        {
            string venue = ddlVenue.SelectedItem.Text;
            string eventDate = txtEventDate.Text;
            string startTime = txtEventTime.Text;
            string endTime = txtEndTime.Text;
            string faculty = ddlFacultyMember.SelectedItem.Text;
            string org = txtOrgName.Text;
            string title = txtTitle.Text;


            // Check if the checkbox exists in the form submission
            int isSoundSystemChecked = Request.Form["cbSoundSystem"] != null ? 1 : 0;
            int isChairsChecked = Request.Form["cbChairs"] != null ? 1 : 0;
            int isCurtainsChecked = Request.Form["cbCurtains"] != null ? 1 : 0;
            int isScreenAndProjectorChecked = Request.Form["cbScreenAndProjector"] != null ? 1 : 0;
            int isPodiumChecked = Request.Form["cbPodium"] != null ? 1 : 0;

            // Create QueryString
            string url = "ValiDate.aspx?"
                + "Venue=" + Server.UrlEncode(venue)
                + "&EventDate=" + Server.UrlEncode(eventDate)
                + "&StartTime=" + Server.UrlEncode(startTime)
                + "&EndTime=" + Server.UrlEncode(endTime)
                + "&Faculty=" + Server.UrlEncode(faculty)
                + "&SoundSystem=" + isSoundSystemChecked
                + "&Chairs=" + isChairsChecked
                + "&Curtains=" + isCurtainsChecked
                + "&ScreenProjector=" + isScreenAndProjectorChecked
                + "&Podium=" + isPodiumChecked
                + "&Title=" + Server.UrlEncode(title)
                + "&Organization=" + Server.UrlEncode(org);

            // Redirect to the next page
            Response.Redirect(url);

        }

        protected void btnSeeMoreSched_Click(object sender, EventArgs e)
        {
            Response.Redirect("MySchedule.aspx");

        }
    }
}