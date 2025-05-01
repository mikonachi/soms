using System;
using System.Data.SqlClient;
using System.Data;
using System.Text;
using System.Net.Mail;
using System.Net;
using System.Web.Security;
using System.Xml.Linq;

namespace SOMS
{
    public partial class WebForm3 : System.Web.UI.Page
    {
        dataAccess crud = new dataAccess();

        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void btnSendCode_Click(object sender, EventArgs e)
        {
            string userEmail = txtContact.Text;

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

                if (counter == "0")
                {
                    ClientScript.RegisterStartupScript(this.GetType(), "alertScript", "alert('The email does not existing, please use another.');", true);
                    return;
                }

                else
                {
                    //ENABLE THIS BEFORE DEPLOYMENT

                    //if (!userEmail.EndsWith("@cvsu.edu.ph"))
                    //{
                    //    // Show error if the domain is not @cvsu.edu.ph
                    //    ClientScript.RegisterStartupScript(this.GetType(), "alertScript", "alert('Please use a valid cvsu email address.');", true);
                    //    return; // Exit the method, don't send OTP
                    //}


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
            string enteredOtp = txtVerificationCode.Text;

            // Get the OTP stored in session
            string storedOtp = Session["OTP"] as string;

            // Check if entered OTP matches the stored OTP
            if (enteredOtp != null && enteredOtp == storedOtp)
            {
                // OTP is correct, proceed with the next action
                ClientScript.RegisterStartupScript(this.GetType(), "alertScript", "alert('OTP verified successfully!');", true);
                txtNewPassword.Enabled = true;
                txtConfirmPassword.Enabled = true;
                txtNewPassword.BackColor = System.Drawing.Color.White;
                txtConfirmPassword.BackColor = System.Drawing.Color.White;
            }
            else
            {
                // OTP is incorrect
                ClientScript.RegisterStartupScript(this.GetType(), "alertScript", "alert('Invalid OTP. Please try again.');", true);
                txtNewPassword.Enabled = false;
                txtConfirmPassword.Enabled = false;
                txtNewPassword.BackColor = System.Drawing.Color.LightGray;
                txtConfirmPassword.BackColor = System.Drawing.Color.LightGray;
            }
        }

        protected void btnResetPassword_Click(object sender, EventArgs e)
        {
            if (txtNewPassword.Text != txtConfirmPassword.Text)
            {
                errorMessage.Visible = true;
                return; // Stop further execution if passwords don't match
            }
            else
            {
                errorMessage.Visible = false; // Hide the error message

                string procedureName = "SP_UpdatePassword";

                SqlParameter[] parameters =
                {
                new SqlParameter("@email", txtContact.Text),
                new SqlParameter("@password", txtNewPassword.Text)
            };

                try
                {
                    int rowsAffected = crud.ExecuteStoredProc(procedureName, parameters);

                    if (rowsAffected > 0)
                    {
                        ClientScript.RegisterStartupScript(this.GetType(), "alertScript", "alert('SUCCESSFULLY UPDATED ACCOUNT PASSWORD!'); window.location.href='LogIn.aspx';", true);

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
}