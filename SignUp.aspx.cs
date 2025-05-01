using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Net;
using System.Net.Mail;
using System.Text;
using System.Web.UI.WebControls;

namespace SOMS
{
    public partial class SignUp : System.Web.UI.Page
    {
        dataAccess crud = new dataAccess();
        string connStr = ConfigurationManager.ConnectionStrings["OMSDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadDropdownItems();
            }
        }

        protected void btnSubmit_Click(object sender, EventArgs e)
        {
            if (password.Text == passwordConf.Text)
            {
                hfPassword.Value = passwordConf.Text;
                ClientScript.RegisterStartupScript(this.GetType(), "ShowModal", "showModalSecCode()", true);
            }
            else
            {
                errorMessage.Visible = true;
                return;
            }

        }

        protected void btnSendCode_Click(object sender, EventArgs e)
        {

            string userEmail = email.Text;

            // Create SQL parameters for the procedure
            SqlParameter[] parameters = new SqlParameter[]
            {
                new SqlParameter("@email", userEmail),
            };

            // Initialize DbHelper object
            dataAccess dbHelper = new dataAccess();

            // Fetch data using the stored procedure
            DataTable userData = dbHelper.FetchDataFromProcedure("SP_CheckEmailExist", parameters);

            if (userData.Rows.Count > 0)
            {
                string counter = userData.Rows[0]["EmailExists"].ToString();

                if (counter != "0")
                {
                    ClientScript.RegisterStartupScript(this.GetType(), "alertScript", "alert('There is an existing email, please use another.');", true);
                    return;
                }

                else
                {
                    //ENABLE THIS BEFORE DEPLOYMENT

                    if (!userEmail.EndsWith("@cvsu.edu.ph"))
                    {
                        // Show error if the domain is not @cvsu.edu.ph
                        ClientScript.RegisterStartupScript(this.GetType(), "alertScript", "alert('Please use a valid cvsu email address.');", true);
                        return; // Exit the method, don't send OTP
                    }


                    string otpCode = GenerateOTP(6);  // 6-digit OTP


                    // Store OTP in session to verify later
                    Session["OTP"] = otpCode;

                    bool emailSent = SendOTPEmail(userEmail, otpCode);


                    if (emailSent)
                    {
                        ClientScript.RegisterStartupScript(this.GetType(), "alertScript", "alert('OTP sent successfully to your email address');", true);
                    }
                    else
                    {
                        ClientScript.RegisterStartupScript(this.GetType(), "alertScript", "alert('Failed to send OTP. Please try again.');", true);

                    }
                }
            }
        }


        public string GenerateOTP(int length = 6)
        {
            Random random = new Random();
            StringBuilder otp = new StringBuilder();
            for (int i = 0; i < length; i++)
            {
                otp.Append(random.Next(0, 10).ToString()); // Generate a random number from 0 to 9
            }
            return otp.ToString();
        }

        // Method to send OTP to the email address
        public bool SendOTPEmail(string toEmailAddress, string otpCode)
        {
            try
            {
                // Setup SMTP client for sending email using Mailjet's SMTP server
                SmtpClient smtpClient = new SmtpClient("in-v3.mailjet.com")
                {
                    Port = 587, // Use 587 for TLS or 465 for SSL
                    Credentials = new NetworkCredential("7453209f28ced4d5a229f62030f161ee", "081d42dda58484e83e8dc92b283bc17f"), //Mailjet APIkey and SecretKey
                    EnableSsl = true // Enable SSL for secure connection
                };

                // THIS IS FOR THE DESIGN OF THE EMAIL THAT WILL BE SENT
                string emailBody = $@"
            <html>
                <head>
                    <style>
                        body {{
                            font-family: Century Gothic, sans-serif;
                            background-color: #f4f4f4;
                            margin: 0;
                            padding: 0;
                        }}
                        .container {{
                            background-color: #ffffff;
                            padding: 20px;
                            border-radius: 8px;
                            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
                            width: 100%;
                            max-width: 600px;
                            margin: 0 auto;
                        }}
                        h2 {{
                            color: #333333;
                            font-size: 22px;
                        }}
                        p {{
                            color: #555555;
                            font-size: 16px;
                        }}
                        .otp-code {{
                            font-size: 28px;
                            font-weight: bold;
                            color: #4CAF50;
                            background-color: #f0f0f0;
                            padding: 15px;
                            border-radius: 5px;
                            display: inline-block;
                        }}
                       
                    </style>
                </head>
                <body>
                    <div class='container'>
                        <h2>Your OTP Code</h2>
                        <p>Dear Cavsueño,</p>
                        <p>Thank you for your request. Please use the following One-Time Password (OTP) to verify your email:</p>
                        <p class='otp-code'>{otpCode}</p>
                        <p>If you did not request this code, please disregard this email.</p>
                        <p>NOTE: This is an auto generated email, please do not reply.</p><br>
                        <p>Thank You!</p>
                    </div>
                </body>
            </html>
        ";

                // Compose the email
                MailMessage mailMessage = new MailMessage
                {
                    From = new MailAddress("omscvsu@gmail.com"), // Use your email address
                    Subject = "OMS OTP",
                    Body = emailBody,
                    IsBodyHtml = true
                };

                mailMessage.To.Add(toEmailAddress);

                // Send the email
                smtpClient.Send(mailMessage);

                return true; // Email sent successfully
            }
            catch (Exception ex)
            {
                // Log error or handle failure
                Console.WriteLine($"Error sending email: {ex.Message}");
                return false; // Email failed to send
            }
        }

        protected void btnVerifyCode_Click(object sender, EventArgs e)
        {
            // Get the entered OTP
            string enteredOtp = code.Text;

            // Get the OTP stored in session
            string storedOtp = Session["OTP"] as string;

            // Check if entered OTP matches the stored OTP
            if (enteredOtp != null && enteredOtp == storedOtp)
            {
                // OTP is correct, proceed with the next action
                ClientScript.RegisterStartupScript(this.GetType(), "alertScript", "alert('OTP verified successfully!');", true);
                password.Enabled = true;
                passwordConf.Enabled = true;
                btnSubmit.Enabled = true;
                password.BackColor = System.Drawing.Color.White;
                passwordConf.BackColor = System.Drawing.Color.White;
            }
            else
            {
                // OTP is incorrect
                ClientScript.RegisterStartupScript(this.GetType(), "alertScript", "alert('Invalid OTP. Please try again.');", true);
                password.Enabled = false;
                passwordConf.Enabled = false;
                btnSubmit.Enabled = false;
                password.BackColor = System.Drawing.Color.LightGray;
                passwordConf.BackColor = System.Drawing.Color.LightGray;
            }
        }


        private void LoadDropdownItems()
        {

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = "SELECT Organization FROM TB_Organization WHERE Authority = 'SO' AND Status = 1";
                SqlCommand cmd = new SqlCommand(query, conn);

                try
                {
                    conn.Open();
                    SqlDataReader reader = cmd.ExecuteReader();

                    organization.DataSource = reader;
                    organization.DataTextField = "Organization";
                    organization.DataValueField = "Organization";
                    organization.DataBind();

                    organization.Items.Insert(0, new ListItem("SELECT ORGANIZATION", ""));
                    organization.Items[0].Attributes["disabled"] = "disabled";

                }
                catch (Exception ex)
                {
                    Response.Write("Error: " + ex.Message);
                }
            }
        }

        protected void btnDecryptKey_Click(object sender, EventArgs e)
        {
             try
            {
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    string query = "SELECT TOP 1 Organization FROM TB_Organization WHERE AccessKey = @AccessKey AND Status = 1";
                    SqlCommand cmd = new SqlCommand(query, conn);

                    cmd.Parameters.Add("@AccessKey", SqlDbType.NVarChar).Value = txtKey.Text;

                    conn.Open();

                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.HasRows)
                        {
                            while (reader.Read())
                            {
                                string organization = reader["Organization"].ToString();
                    
                                txtKey.Text = organization;

                                ClientScript.RegisterStartupScript(this.GetType(), "ShowModal", "showModalSecCode()", true);
                            }
                        }
                        else
                        {
                            txtKey.Text = "";

                            ClientScript.RegisterStartupScript(this.GetType(), "alertScript", "alert('No organization found for the given AccessKey.');", true);

                        }
                    }
                }
            }
            catch (Exception ex)
            {
                // Log the error and show the message to the user
                Response.Write("Error: " + ex.Message);
            }

        }

        protected void btnConfirmNewAccessKey_Click(object sender, EventArgs e)
        {
            // Password and Confirmation Password Validation
            if (txtKey.Text != organization.SelectedValue)
            {
                ClientScript.RegisterStartupScript(this.GetType(), "alertScript", "alert('ERROR! Please confirm Organization');", true);
                return; 
            }
            else
            {
                errorMessage.Visible = false; 

                string procedureName = "SP_Registration";

                SqlParameter[] parameters =
                {
                    new SqlParameter("@email", email.Text),
                    new SqlParameter("@password", hfPassword.Value),
                    new SqlParameter("@fullName", name.Text),
                    new SqlParameter("@role", role.SelectedValue.ToString()),
                    new SqlParameter("@studentNumber", Convert.ToInt64(studentNumber.Text)),
                    new SqlParameter("@organization", organization.SelectedValue.ToString())
                };

                try
                {
                    // Execute stored procedure
                    int rowsAffected = crud.ExecuteStoredProc(procedureName, parameters);

                    // Check if the stored procedure executed successfully
                    if (rowsAffected > 0)
                    {
                        // Success: Redirect to login page with a success message
                        ClientScript.RegisterStartupScript(this.GetType(), "alertScript", "alert('SUCCESSFULLY CREATED NEW ACCOUNT!'); window.location.href='LogIn.aspx';", true);
                    }
                    else
                    {
                        // Failure: Show error message
                        ClientScript.RegisterStartupScript(this.GetType(), "alertScript", "alert('ERROR! Could not create the account.');", true);
                    }
                }
                catch (Exception ex)
                {
                    // Log or display the exception message
                    ClientScript.RegisterStartupScript(this.GetType(), "alertScript", $"alert('An error occurred: {ex.Message}');", true);
                }
            }


        }
        protected void btnCancelNewAccessKey_Click(object sender, EventArgs e)
        {
            txtKey.Text = "";
            //ClientScript.RegisterStartupScript(this.GetType(), "HideModal", "hideModal()", true);
        }


    }
}