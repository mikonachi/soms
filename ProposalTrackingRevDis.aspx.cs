using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Web.UI.WebControls;

namespace SOMS
{
    public partial class ProposalTrackingRevDis : System.Web.UI.Page
    {
        private readonly string connectionString = ConfigurationManager.ConnectionStrings["OMSDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Session["UserAuthenticated"] != null && (bool)Session["UserAuthenticated"])
                {
                    BindEventsToRepeater(rptReceived, 3);

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
            }

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
        protected void btnRevision_Click(object sender, EventArgs e)
        {
            ClientScript.RegisterStartupScript(this.GetType(), "ShowModal", "showModalConf1()", true);
            hfConfirmationButtonClicked.Value = "Revision";

        }

        protected void btnDisap_Click(object sender, EventArgs e)
        {
            ClientScript.RegisterStartupScript(this.GetType(), "ShowModal", "showModalConf1()", true);
            hfConfirmationButtonClicked.Value = "Disapproved";
            // Update into database

        }

        protected void btnApprove_Click(object sender, EventArgs e)
        {
            ClientScript.RegisterStartupScript(this.GetType(), "ShowModal", "showModalConf1()", true);
            hfConfirmationButtonClicked.Value = "Approved";
            // Update into database

        }
        protected void btnContinue_Click(object sender, EventArgs e)
        {
            // Refresh the page after saving
            Response.Redirect(Request.RawUrl);
        }
        private List<EventData> GetEventDataFromDatabase(int status)
        {
            List<EventData> eventList = new List<EventData>();
            string query = "SELECT Title, EventDate, StartTime, EndTime, Organization, Venue, EventID FROM Events WHERE Status IN (5, 6) ORDER BY EventID ASC";

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
            var eventList = GetEventDataFromDatabaseByRefNo(3);

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

    }
}