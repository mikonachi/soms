using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace SOMS
{
    public partial class WebForm2 : System.Web.UI.Page
    {
        private string connectionString = ConfigurationManager.ConnectionStrings["OMSDB"].ConnectionString;
        private int addedDays = 0;

        protected void Page_Load(object sender, EventArgs e)
        {

            if (!IsPostBack)
            {
                if (Session["UserAuthenticated"] != null && (bool)Session["UserAuthenticated"])
                {
                    if (Request.QueryString["Venue"] != null)
                    {
                        lblVenue.Text = Request.QueryString["Venue"];


                        string eventDateSelected = Request.QueryString["EventDate"];
                        string startTime = Request.QueryString["StartTime"];
                        string endTime = Request.QueryString["EndTime"];

                        // Convert startTime and endTime to AM/PM format
                        DateTime parsedStartTime = DateTime.Parse(startTime);
                        DateTime parsedEndTime = DateTime.Parse(endTime);

                        string formattedStartTime = parsedStartTime.ToString("h tt"); // e.g., "10 AM"
                        string formattedEndTime = parsedEndTime.ToString("h tt"); // e.g., "10 PM"

                        // Format and display in label
                        lblTimeDate.Text = $"{eventDateSelected} {formattedStartTime} - {formattedEndTime}";

                        string faculty = Request.QueryString["Faculty"];

                        lblFacultyMember.Text = faculty == "Faculty Member Appearance" ? "N/A" : faculty;
                        lblSoundSystem.Text = Convert.ToInt32(Request.QueryString["SoundSystem"]) == 1 ? "Requested" : "N/A";
                        lblChairs.Text = Convert.ToInt32(Request.QueryString["Chairs"]) == 1 ? "Requested" : "N/A";
                        lblCurtains.Text = Convert.ToInt32(Request.QueryString["Curtains"]) == 1 ? "Requested" : "N/A";
                        lblScreenProjector.Text = Convert.ToInt32(Request.QueryString["ScreenProjector"]) == 1 ? "Requested" : "N/A";
                        lblPodium.Text = Convert.ToInt32(Request.QueryString["Podium"]) == 1 ? "Requested" : "N/A";

                    }
                    string eventDate = Request.QueryString["EventDate"];
                    // Example: Binding data with a specific date
                    DateTime date = Convert.ToDateTime(eventDate);
                    BindTableData(date);

                }
                else
                {
                    Response.Redirect("LandingPage.aspx");
                }
            }

        }

        private void BindTableData(DateTime selectedDate)
        {
            // **Fixed Categories**
            string[] categories = { "Venue", "Time and Date", "Faculty Member", "Sound System", "Chairs", "Curtains", "Screen & Projector", "Podium" };

            // **Third Column Labels (Availability)**
            Label[] availabilityLabels = { lblVenueAvailability, lblTimeDateAvailability, lblFacultyMemberAvailability,
                                   lblSoundSystemAvailability, lblChairsAvailability, lblCurtainsAvailability,
                                   lblScreenProjectorAvailability, lblPodiumAvailability };

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();

                // **Query to Fetch the Latest Event Data for the Given Date**
                string query = @"
                SELECT TOP 1 Venue, EventDate, Organization, StartTime, EndTime, 
                             SoundSystem, Chairs, Curtains, ScreenAndProjector, Podium
                FROM Events
                WHERE CAST(EventDate AS DATE) = @EventDate
                ORDER BY EventID DESC";  // Fetch the latest event for the selected date

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@EventDate", selectedDate.Date); // Ensure DATE-only match

                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            // **Venue**
                            string venue = reader["Venue"].ToString();
                            availabilityLabels[0].Text = !string.IsNullOrEmpty(venue) ? "Not Available" : "Available";
                            availabilityLabels[0].CssClass = availabilityLabels[0].Text == "Available" ? "available" : "not-available";

                            // **Time and Date**
                            if (reader["EventDate"] != DBNull.Value && reader["StartTime"] != DBNull.Value && reader["EndTime"] != DBNull.Value)
                            {
                                availabilityLabels[1].Text = "Not Available"; // Since a scheduled event means it's taken
                            }
                            else
                            {
                                availabilityLabels[1].Text = "Available";
                            }
                            availabilityLabels[1].CssClass = availabilityLabels[1].Text == "Available" ? "available" : "not-available";

                            // **Faculty Member (Organization)**
                            string facultyMember = reader["Organization"].ToString();
                            availabilityLabels[2].Text = !string.IsNullOrEmpty(facultyMember) ? "Not Available" : "Available";
                            availabilityLabels[2].CssClass = availabilityLabels[2].Text == "Available" ? "available" : "not-available";

                            // **Loop Through Equipment (4th to 7th index)**
                            string[] equipmentFields = { "SoundSystem", "Chairs", "Curtains", "ScreenAndProjector", "Podium" };

                            for (int i = 0; i < equipmentFields.Length; i++)
                            {
                                int value = reader[equipmentFields[i]] != DBNull.Value ? Convert.ToInt32(reader[equipmentFields[i]]) : 0;

                                // **Corrected Logic: 1 = "Not Available", 0 = "Available"**
                                availabilityLabels[i + 3].Text = value == 1 ? "Not Available" : "Available";
                                availabilityLabels[i + 3].CssClass = value == 1 ? "not-available" : "available";
                            }
                        }
                        else
                        {
                            for (int i = 0; i < availabilityLabels.Length; i++)
                            {
                                availabilityLabels[i].Text = "Available";
                                availabilityLabels[i].CssClass = "available";
                            }
                        }
                    }
                }
            }
        }


        private void CheckEventAvailability(DateTime eventDate)
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();
                string query = "SELECT COUNT(*) FROM Events WHERE CAST(EventDate AS DATE) = @EventDate";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@EventDate", eventDate.Date);
                    int count = Convert.ToInt32(cmd.ExecuteScalar());

                    if (count > 0)
                    {
                        // If the selected date is booked
                        lblHeaderModal.Text = "Information";
                        lblModalContent.Text = $"<span style='color:crimson;'>This date <b>{eventDate:yyyy-MM-dd}</b> is already booked.</span>";
                    }
                    else
                    {
                        lblHeaderModal.Text = "Recommendation";
                        lblModalContent.Text = $"You can schedule the event on <span style='color:#70ad47;'>{eventDate:yyyy-MM-dd}</span>.";
                        hfSuggestedDate.Value = eventDate.ToString("yyyy-MM-dd");
                    }
                    ScriptManager.RegisterStartupScript(this, GetType(), "ShowModal", "showModalAvailability();", true);
                }
            }
        }



        private bool IsAllAvailable()
        {
            string[] availabilityLabels = {
                lblVenueAvailability.Text,
                lblTimeDateAvailability.Text,
                lblFacultyMemberAvailability.Text,
                lblSoundSystemAvailability.Text,
                lblChairsAvailability.Text,
                lblCurtainsAvailability.Text,
                lblScreenProjectorAvailability.Text,
                lblPodiumAvailability.Text
                };

            foreach (string status in availabilityLabels)
            {
                if (status.Trim() != "Available")
                {
                    return false;
                }
            }
            return true;
        }

        protected void btnEventCalendar_Click(object sender, EventArgs e)
        {
            if (Session["whatCalendar"].ToString() == "SOCalendar")
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
            // Handle Proposal Tracking button click
            Response.Redirect("ProposalTracking.aspx");
        }

        protected void btnGroups_Click(object sender, EventArgs e)
        {
            // Handle Groups button click
            Response.Redirect("ManageGroups.aspx");
        }

        protected void btnSettings_Click(object sender, EventArgs e)
        {
            // Handle Settings button click
            Response.Redirect("AdminSettings.aspx");
        }

        protected void btnTomorrow_Click(object sender, EventArgs e)
        {
            isClicked.Value = "Tomorrow";
            addedDays = 1;
            DateTime baseDate = GetBaseDateFromQuery();
            CheckEventAvailability(baseDate.AddDays(1));
        }

        protected void btnThreeDays_Click(object sender, EventArgs e)
        {
            isClicked.Value = "ThreeDays";
            addedDays = 3;
            DateTime baseDate = GetBaseDateFromQuery();
            CheckEventAvailability(baseDate.AddDays(3));
        }

        protected void btnAWeek_Click(object sender, EventArgs e)
        {
            isClicked.Value = "AWeekFromNow";
            addedDays = 7;
            DateTime baseDate = GetBaseDateFromQuery();
            CheckEventAvailability(baseDate.AddDays(7));
        }


        protected void btnSubmitProposal_Click(object sender, EventArgs e)
        {
            isClicked.Value = "Submit";

            if (IsAllAvailable())
            {
                lblHeaderModal.Text = "Confirmation";
                lblModalContent.Text = "Please confirm all details before proceeding.";
                ClientScript.RegisterStartupScript(this.GetType(), "ShowModal", "showModalAvailability()", true);

            }
            else
            {
                lblHeaderModal.Text = "Information";
                lblModalContent.Text = "Please select other date option.";
                ClientScript.RegisterStartupScript(this.GetType(), "ShowModal", "showModalAvailability()", true);
                isClicked.Value = "Submit Cancel";

            }
        }

        protected void btnConfirm_Click(object sender, EventArgs e)
        {
            if (isClicked.Value.Equals("Submit"))
            {

                string fullDateText = lblTimeDate.Text.Trim(); // Get the label text
                string dateOnly = fullDateText.Split(' ')[0]; // Extract only the date part

                // Insert into database
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    string query = "INSERT INTO Events (Title, Venue, EventDate, Organization, Email, FacultyAppearance, StartTime, EndTime, " +
                                   "SoundSystem, Chairs, Curtains, ScreenAndProjector, Podium, Status, ProposalSentDate) " +
                                   "VALUES (@Title, @Venue, @EventDate, @Organization, @email, @Faculty, @StartTime, @EndTime, " +
                                   "@SoundSystem, @Chairs, @Curtains, @ScreenAndProjector, @Podium, 1, GETDATE())";



                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@Title", Request.QueryString["Title"].ToUpper());
                        cmd.Parameters.AddWithValue("@Venue", Request.QueryString["Venue"]);

                        cmd.Parameters.AddWithValue("@EventDate", DateTime.Parse(dateOnly));

                        cmd.Parameters.AddWithValue("@Organization", Request.QueryString["Organization"]);
                        cmd.Parameters.AddWithValue("@email", Session["email"].ToString());


                        cmd.Parameters.AddWithValue("@Faculty", Request.QueryString["Faculty"]);
                        cmd.Parameters.AddWithValue("@StartTime", TimeSpan.Parse(Request.QueryString["StartTime"]));
                        cmd.Parameters.AddWithValue("@EndTime", TimeSpan.Parse(Request.QueryString["EndTime"]));

                        cmd.Parameters.AddWithValue("@SoundSystem", Request.QueryString["SoundSystem"]);
                        cmd.Parameters.AddWithValue("@Chairs", Request.QueryString["Chairs"]);
                        cmd.Parameters.AddWithValue("@Curtains", Request.QueryString["Curtains"]);
                        cmd.Parameters.AddWithValue("@ScreenAndProjector", Request.QueryString["ScreenProjector"]);
                        cmd.Parameters.AddWithValue("@Podium", Request.QueryString["Podium"]);

                        conn.Open();
                        cmd.ExecuteNonQuery();
                    }
                }

                lblHeaderModal.Text = "SUCCESS";
                lblModalContent.Text = "Your event is now pending for confirmation.";
                ClientScript.RegisterStartupScript(this.GetType(), "ShowModal", "showModalAvailability()", true);
                isClicked.Value = "Success";
            }
            else if (isClicked.Value.Equals("Success"))
            {
                if (Session["whatCalendar"].ToString() == "SOCalendar")
                {
                    Response.Redirect("SOCalendar.aspx");
                }
                else
                {
                    Response.Redirect("Calendar.aspx");
                }
            }
            else
            {
                try
                {
                    string suggestedDate = hfSuggestedDate.Value.Trim();
                    DateTime parsedDate;

                    if (DateTime.TryParse(suggestedDate, out parsedDate))
                    {
                        suggestedDate = parsedDate.ToString("yyyy-MM-dd");
                    }

                    string currentText = lblTimeDate.Text.Trim();
                    int spaceIndex = currentText.IndexOf(' ');

                    if (spaceIndex != -1)
                    {
                        string timePart = currentText.Substring(spaceIndex).Trim();
                        lblTimeDate.Text = $"{suggestedDate} {timePart}";
                    }
                    else
                    {
                        lblTimeDate.Text = suggestedDate;
                    }

                    BindTableData(DateTime.Parse(suggestedDate));
                }
                catch
                {
                    return;
                }

            }
        }


        private DateTime GetBaseDateFromQuery()
        {
            DateTime baseDate;

            string eventDateSelected = Request.QueryString["EventDate"];

            if (DateTime.TryParse(eventDateSelected, out baseDate))
            {
                return baseDate;
            }
            else
            {
                return DateTime.Now;
            }
        }


    }
}