using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Web.UI.WebControls;

namespace SOMS
{
    public partial class ManageGroups : System.Web.UI.Page
    {
        private string connectionString = ConfigurationManager.ConnectionStrings["OMSDB"].ConnectionString;

        dataAccess crud = new dataAccess();
        protected void Page_Load(object sender, EventArgs e)
        {
            string userEmail = Session["email"] as string;
            string adminAccessKey = Session["AdminAccessKey"] as string;
            bool isAuthenticated = Session["UserAuthenticated"] as bool? ?? false;

            if (string.IsNullOrEmpty(userEmail) || string.IsNullOrEmpty(adminAccessKey) || !isAuthenticated)
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

            lblAdminAccessKey.Text = $"Admin Access Key: <b>{adminAccessKey}</b>";


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
        protected void gvOrganization_RowCommand(object sender, GridViewCommandEventArgs e)
        {

            if (e.CommandName == "EditName")
            {
                int rowIndex = Convert.ToInt32(e.CommandArgument);
                GridViewRow row = gvOrganization.Rows[rowIndex];
                string id = gvOrganization.DataKeys[rowIndex].Value.ToString();
                string organization = (row.FindControl("organizationLabel") as Label).Text;
                hfID.Value = id;

                ClientScript.RegisterStartupScript(this.GetType(), "ShowModal", "showModalEdit()", true);

                txtOldName.Text = organization;
            }
            else
            {
                int rowIndex = Convert.ToInt32(e.CommandArgument);
                GridViewRow row = gvOrganization.Rows[rowIndex];
                string id = gvOrganization.DataKeys[rowIndex].Value.ToString();
                hfID.Value = id;

                ClientScript.RegisterStartupScript(this.GetType(), "ShowModal", "showModalConfDel()", true);
            }
        }

        protected void btnConfirmEdit_Click(object sender, EventArgs e)
        {
            if (txtNewName.Text == "")
            {
                lblMessage.Visible = true;
                ClientScript.RegisterStartupScript(this.GetType(), "ShowModal", "showModalEdit()", true);

            }
            else
            {
                lblMessage.Visible = false; // Hide the error message

                string procedureName = "SP_EditGroupName";

                SqlParameter[] parameters =
                {
                new SqlParameter("@id", Convert.ToInt32(hfID.Value.ToString())),
                new SqlParameter("@newOrgName", txtNewName.Text),
                };

                try
                {
                    int rowsAffected = crud.ExecuteStoredProc(procedureName, parameters);

                    if (rowsAffected > 0)
                    {
                        gvOrganization.DataBind();
                        ClientScript.RegisterStartupScript(this.GetType(), "ShowModal", "showModalSuccess()", true);
                        txtNewName.Text = "";

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

        protected void btnConfirmAskDelete_Click(object sender, EventArgs e)
        {

            string procedureName = "SP_SetOrganizationInactive";

            SqlParameter[] parameters =
            {
                new SqlParameter("@id", Convert.ToInt32(hfID.Value.ToString()))
            };

            try
            {
                int rowsAffected = crud.ExecuteStoredProc(procedureName, parameters);

                if (rowsAffected > 0)
                {
                    gvOrganization.DataBind();
                    gvFacultyMembers.DataBind();
                    ClientScript.RegisterStartupScript(this.GetType(), "ShowModal", "showModalSuccess()", true);
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

        protected void btnEventCalendar_Click(object sender, EventArgs e)
        {
            Response.Redirect("Calendar.aspx");
        }

        protected void btnSettings_Click(object sender, EventArgs e)
        {
            Response.Redirect("AdminSettings.aspx");
        }

        protected void btnProposalTracking_Click(object sender, EventArgs e)
        {
            Response.Redirect("ProposalTracking.aspx");
        }

        protected void btnAddNewOrganization_Click(object sender, EventArgs e)
        {
            ClientScript.RegisterStartupScript(this.GetType(), "ShowModal", "showModalNewOrganization()", true);

        }

        protected void btnCancelNewOrgCreation_Click(object sender, EventArgs e)
        {
            txtNewOrgName.Text = "";
            txtNewOrgAccessKey.Text = "";
            lblMessageSave.Visible = false;
        }

        protected void btnConfirmNewOrgCreation_Click(object sender, EventArgs e)
        {
            string procedureName = "SP_AddNewOrg";

            SqlParameter[] parameters =
            {
                new SqlParameter("@organization", txtNewOrgName.Text),
                new SqlParameter("@accessKey", txtNewOrgAccessKey.Text)

            };

            try
            {
                int rowsAffected = crud.ExecuteStoredProc(procedureName, parameters);

                if (rowsAffected > 0)
                {
                    gvOrganization.DataBind();
                    ClientScript.RegisterStartupScript(this.GetType(), "ShowModal", "showModalSuccess()", true);
                    txtNewOrgName.Text = "";
                    txtNewOrgAccessKey.Text = "";
                    lblMessageSave.Visible = false;
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

        protected void btnGenerateEncryptedKey_Click(object sender, EventArgs e)
        {
            string encryptedKey = EncryptionHelper.GenerateEncryptedKey();
            txtNewOrgAccessKey.Text = encryptedKey;
            ClientScript.RegisterStartupScript(this.GetType(), "ShowModal", "showModalNewOrganization()", true);
            lblMessageSave.Visible = true;
        }

        protected void gvFacultyMembers_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "EditRole")
            {
                int rowIndex = Convert.ToInt32(e.CommandArgument);
                GridViewRow row = gvFacultyMembers.Rows[rowIndex];
                string id = gvFacultyMembers.DataKeys[rowIndex].Value.ToString();
                string organization = (row.FindControl("lblRole") as Label).Text;
                hfID.Value = id;

                ClientScript.RegisterStartupScript(this.GetType(), "ShowModal", "showModalEditRole()", true);

                txtOldRoleName.Text = organization;
            }
            else
            {
                int rowIndex = Convert.ToInt32(e.CommandArgument);
                GridViewRow row = gvFacultyMembers.Rows[rowIndex];
                string id = gvFacultyMembers.DataKeys[rowIndex].Value.ToString();
                hfID.Value = id;

                ClientScript.RegisterStartupScript(this.GetType(), "ShowModal", "showModalConfDel()", true);
            }

        }

        protected void btnConfirmEditRole_Click(object sender, EventArgs e)
        {
            if (txtNewRoleName.Text == "")
            {
                lblMessageRole.Visible = true;
                ClientScript.RegisterStartupScript(this.GetType(), "ShowModal", "showModalEditRole()", true);

            }
            else
            {
                lblMessageRole.Visible = false; // Hide the error message

                string procedureName = "SP_EditRoleName";

                SqlParameter[] parameters =
                {
                new SqlParameter("@id", Convert.ToInt32(hfID.Value.ToString())),
                new SqlParameter("@newRoleName", txtNewRoleName.Text),
                };

                try
                {
                    int rowsAffected = crud.ExecuteStoredProc(procedureName, parameters);

                    if (rowsAffected > 0)
                    {
                        gvFacultyMembers.DataBind();
                        ClientScript.RegisterStartupScript(this.GetType(), "ShowModal", "showModalSuccess()", true);
                        txtNewRoleName.Text = "";

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

        protected void btnAddNewFaculty_Click(object sender, EventArgs e)
        {
            ClientScript.RegisterStartupScript(this.GetType(), "ShowModal", "showModalNewRole()", true);

        }

        protected void btnGenerateEncryptedKeyRole_Click(object sender, EventArgs e)
        {
            string encryptedKey = EncryptionHelper.GenerateEncryptedKey();
            txtNewAccessKeyRole.Text = encryptedKey;
            ClientScript.RegisterStartupScript(this.GetType(), "ShowModal", "showModalNewRole()", true);
            lblMessageRoleCreate.Visible = true;

        }

        protected void btnCancelNewRole_Click(object sender, EventArgs e)
        {
            txtCreateNewRole.Text = "";
            txtNewAccessKeyRole.Text = "";
            lblMessageRoleCreate.Visible = false;

        }

        protected void btnConfirmNewRole_Click(object sender, EventArgs e)
        {
            string procedureName = "SP_AddNewFaculty";

            SqlParameter[] parameters =
            {
                new SqlParameter("@organization", txtCreateNewRole.Text),
                new SqlParameter("@accessKey", txtNewAccessKeyRole.Text)

            };

            try
            {
                int rowsAffected = crud.ExecuteStoredProc(procedureName, parameters);

                if (rowsAffected > 0)
                {
                    gvFacultyMembers.DataBind();
                    ClientScript.RegisterStartupScript(this.GetType(), "ShowModal", "showModalSuccess()", true);
                    txtCreateNewRole.Text = "";
                    txtNewAccessKeyRole.Text = "";
                    lblMessageRoleCreate.Visible = false;
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