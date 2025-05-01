using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace SOMS
{
    public partial class SOAccessCode : System.Web.UI.Page
    {
        private string connectionString = ConfigurationManager.ConnectionStrings["OMSDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserAuthenticated"] != null && (bool)Session["UserAuthenticated"])
            {
            }
            else
            {
                Response.Redirect("LandingPage.aspx");
            }
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
                    Response.Redirect("SOAccessCode.aspx");
                    ClientScript.RegisterStartupScript(this.GetType(), "alertScript", "alert('Please Confirm Access Key!');", true);

                }
                else
                {
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
            string auth = GetOrganizationAuthByEmail(Session["email"].ToString());

            if (auth == "FAC")
            {
                Response.Redirect("FacultyCalendar.aspx");
            }
            else
            {
                Response.Redirect("SOCalendar.aspx");
            }
        }

        protected void btnRight_Click(object sender, EventArgs e)
        {
            string auth = GetOrganizationAuthByEmail(Session["email"].ToString());

            if (auth == "FAC")
            {
                Response.Redirect("FacultyProposalTracking.aspx");
            }
            else
            {
                Response.Redirect("SOProposalTracker.aspx");
            }
        }

        protected void btnEventCalendar_Click(object sender, EventArgs e)
        {
            string auth = GetOrganizationAuthByEmail(Session["email"].ToString());

            if (auth == "FAC")
            {
                Response.Redirect("FacultyCalendar.aspx");
            }
            else
            {
                Response.Redirect("SOCalendar.aspx");
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
                Response.Redirect("SOProposalTracker.aspx");
            }
        }
        protected void btnSettings_Click(object sender, EventArgs e)
        {
            Response.Redirect("SOSettings.aspx");
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

    }
}