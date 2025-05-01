using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace SOMS
{
    public partial class LogIn : System.Web.UI.Page
    {
        private string connectionString = ConfigurationManager.ConnectionStrings["OMSDB"].ConnectionString;

        protected void btnSignIn_Click(object sender, EventArgs e)
        {
            // Create SQL parameters for the procedure
            SqlParameter[] parameters = new SqlParameter[]
            {
                new SqlParameter("@email", txtUsername.Text),
                new SqlParameter("@password", txtPassword.Text)
            };


            // Initialize DbHelper object
            dataAccess dbHelper = new dataAccess();

            // Fetch data using the stored procedure
            DataTable userData = dbHelper.FetchDataFromProcedure("SP_FetchDataInTableAuthority", parameters);

            if (userData.Rows.Count > 0)
            {
                string counter = userData.Rows[0]["Counter"].ToString();

                if (counter == "0")
                {
                    ClientScript.RegisterStartupScript(this.GetType(), "alertScript", "alert('Log In Failed, Please Confirm Email and Password!');", true);
                }
                else
                {
                    Session["UserAuthenticated"] = true;
                    Session["email"] = txtUsername.Text;

                    string userOrganization = GetOrganizationByEmail(txtUsername.Text);

                    if (userOrganization == "ADM")
                    {
                        Response.Redirect("AccessCode.aspx");

                    }
                    else if (userOrganization == "FAC")
                    {
                        Response.Redirect("SOAccessCode.aspx");

                    }
                    else
                    {
                        Response.Redirect("SOAccessCode.aspx");

                    }

                }

            }
            else
            {
                Console.WriteLine("No user data found.");
            }

        }


        private string GetOrganizationByEmail(string email)
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
        protected void btnSignUp_Click(object sender, EventArgs e)
        {
            Response.Redirect("LandingPage.aspx");
        }

        protected void btnForgetPass_Click(object sender, EventArgs e)
        {
            Response.Redirect("ForgotPassword.aspx");
        }
    }
}