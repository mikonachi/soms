using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace SOMS
{
    public partial class AdminSettings : System.Web.UI.Page
    {
        private string connectionString = ConfigurationManager.ConnectionStrings["OMSDB"].ConnectionString;

        dataAccess crud = new dataAccess();

        protected void Page_Load(object sender, EventArgs e)
        {
            string userEmail = Session["email"] as string;
            bool isAuthenticated = Session["UserAuthenticated"] as bool? ?? false;

            if (string.IsNullOrEmpty(userEmail) || !isAuthenticated)
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

            if (auth != "ADM")
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
        protected void btnChangeAccessKey_Click(object sender, EventArgs e)
        {
            hf1.Value = "Change Access Key";
            ClientScript.RegisterStartupScript(this.GetType(), "ShowModal", "showModal()", true);
        }

        protected void btnGenerateEncryptedKey_Click(object sender, EventArgs e)
        {
            string encryptedKey = EncryptionHelper.GenerateEncryptedKey();
            txtGeneratedKey.Text = encryptedKey;
            ClientScript.RegisterStartupScript(this.GetType(), "ShowModal", "showModalNewSecCode()", true);
            lblMessageSave.Visible = true;
        }


        protected void btnCancelNewAccessKey_Click(object sender, EventArgs e)
        {
            txtOldAccessKey.Text = "";
            txtGeneratedKey.Text = "";
            lblMessageSave.Visible = false;

            //ClientScript.RegisterStartupScript(this.GetType(), "HideModal", "hideModal()", true);
        }

        protected void btnConfirm_Click(object sender, EventArgs e)
        {
            if (hf1.Value == "Change Access Key")
            {
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
                        ClientScript.RegisterStartupScript(this.GetType(), "alertScript", "alert('Please Confirm Access Key!');", true);

                    }
                    else
                    {
                        ClientScript.RegisterStartupScript(this.GetType(), "ShowModal", "showModalNewSecCode()", true);
                        txtOldAccessKey.Text = txtAccessKey.Text;
                    }

                }
                else
                {
                    Console.WriteLine("No accessKey data found.");
                }

            }
            else if (hf1.Value == "Delete Admin Account")
            {

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
                        ClientScript.RegisterStartupScript(this.GetType(), "alertScript", "alert('Please Confirm Access Key!');", true);

                    }
                    else
                    {
                        ClientScript.RegisterStartupScript(this.GetType(), "ShowModal", "showModalConfDel()", true);
                    }

                }
                else
                {
                    Console.WriteLine("No accessKey data found.");
                }

            }

        }

        protected void btnConfirmNewAccessKey_Click(object sender, EventArgs e)
        {
            string procedureName = "SP_UpdateAccessKey";

            SqlParameter[] parameters =
                {
                    new SqlParameter("@email", Session["email"].ToString()),
                    new SqlParameter("@newAccessKey", txtGeneratedKey.Text)
                };

            try
            {
                int rowsAffected = crud.ExecuteStoredProc(procedureName, parameters);

                if (rowsAffected > 0)
                {

                    ClientScript.RegisterStartupScript(this.GetType(), "ShowModal", "showModalSuccess()", true);
                    Session["AdminAccessKey"] = txtGeneratedKey.Text;
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

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session.RemoveAll();
            Response.Redirect("LandingPage.aspx");
        }

        protected void btnEventCalendar_Click(object sender, EventArgs e)
        {
            Response.Redirect("Calendar.aspx");
        }

        protected void btnGroups_Click(object sender, EventArgs e)
        {
            Response.Redirect("ManageGroups.aspx");
        }
        protected void btnManageGroups_Click(object sender, EventArgs e)
        {
            Response.Redirect("ManageGroups.aspx");
        }

        protected void btnDeleteAdminAcc_Click(object sender, EventArgs e)
        {
            hf1.Value = "Delete Admin Account";
            ClientScript.RegisterStartupScript(this.GetType(), "ShowModal", "showModal()", true);

        }

        protected void btnClose_Click(object sender, EventArgs e)
        {

        }

        protected void btnProposalTracking_Click(object sender, EventArgs e)
        {
            Response.Redirect("ProposalTracking.aspx");
        }

        protected void Button1_Click(object sender, EventArgs e)
        {
            txtAccessKey.Text = "";
        }

        protected void Unnamed1_Click(object sender, EventArgs e)
        {
            Response.Redirect("ForgotPassword.aspx");
        }


        protected void btnConfirmAskDelete_Click(object sender, EventArgs e)
        {
            string procedureName = "SP_SetAdminAccInactive";

            SqlParameter[] parameters =
            {
                new SqlParameter("@email", Session["email"].ToString()),
                };

            try
            {
                int rowsAffected = crud.ExecuteStoredProc(procedureName, parameters);

                if (rowsAffected > 0)
                {

                    Response.Redirect("LandingPage.aspx");
                    Session.RemoveAll();
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
    }
}