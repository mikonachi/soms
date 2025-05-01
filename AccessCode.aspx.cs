using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace SOMS
{
    public partial class AccessCode : System.Web.UI.Page
    {
        private string connectionString = ConfigurationManager.ConnectionStrings["OMSDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            string userEmail = Session["email"] as string;

            // Check for valid session and email
            if (string.IsNullOrEmpty(userEmail) || Session["UserAuthenticated"] == null || !(bool)Session["UserAuthenticated"])
            {
                Session.RemoveAll();
                Response.Redirect("LandingPage.aspx");
                return;
            }

            string auth;
            try
            {
                auth = GetOrganizationAuthByEmail(userEmail);
            }
            catch
            {
                Session.RemoveAll();
                Response.Redirect("LandingPage.aspx");
                return;
            }

            // Check authorization level
            if (auth == "ADM")
            {
                // Authorized admin logic here
            }
            else
            {
                Session.RemoveAll();
                Response.Redirect("LandingPage.aspx");
                return;
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
        protected void btnConfirm_Click(object sender, EventArgs e)
        {
            // Create SQL parameters for the procedure
            SqlParameter[] parameters = new SqlParameter[]
            {
                new SqlParameter("@email", Session["email"].ToString()),
                new SqlParameter("@accessKey", txtAccessKey.Text)
            };


            // Initialize DbHelper object
            dataAccess dbHelper = new dataAccess();

            // Fetch data using the stored procedure
            DataTable userData = dbHelper.FetchDataFromProcedure("SP_CheckAccessCode", parameters);

            if (userData.Rows.Count > 0)
            {
                string counter = userData.Rows[0]["Counter"].ToString();

                if (counter == "0")
                {
                    Response.Redirect("AccessCode.aspx");
                    ClientScript.RegisterStartupScript(this.GetType(), "alertScript", "alert('Please Confirm Access Key!');", true);

                }
                else
                {
                    Session["AdminAccessKey"] = txtAccessKey.Text;
                    HideModal();
                }

            }
            else
            {
                Console.WriteLine("No accessKey data found.");
            }
        }

        private void HideModal()
        {
            string script = "hideModal();"; // Call client-side function to hide the modal
            ClientScript.RegisterStartupScript(this.GetType(), "HideModal", script, true);
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session.RemoveAll();
            Response.Redirect("LandingPage.aspx");
        }

        protected void btnLeft_Click(object sender, EventArgs e)
        {
            Response.Redirect("Calendar.aspx");
        }

        protected void btnRight_Click(object sender, EventArgs e)
        {
            Response.Redirect("ProposalTracking.aspx");
        }

        protected void btnEventCalendar_Click(object sender, EventArgs e)
        {
            Response.Redirect("Calendar.aspx");
        }

        protected void btnProposalTracking_Click(object sender, EventArgs e)
        {
            Response.Redirect("ProposalTracking.aspx");
        }
        protected void btnSettings_Click(object sender, EventArgs e)
        {
            Response.Redirect("AdminSettings.aspx");
        }

        protected void btnGroups_Click(object sender, EventArgs e)
        {
            Response.Redirect("ManageGroups.aspx");
        }
    }
}