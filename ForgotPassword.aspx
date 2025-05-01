<%@ Page Title="" Language="C#"  AutoEventWireup="true" CodeBehind="ForgotPassword.aspx.cs" Inherits="SOMS.WebForm3" %>
<!DOCTYPE html>
<html lang="en">
<head runat="server">
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Forgot | Change Password</title>
  <style>
    /* General Styles */
    body {
      margin: 0;
      padding: 0;
      background: linear-gradient(135deg, #f0fdf4, #0f5132);
      font-family: 'Inter', sans-serif;
      display: flex;
      justify-content: center;
      align-items: center;
      height: 100vh;
      overflow: hidden;
    }

    .container {
      background: linear-gradient(135deg, #f8fafc, #b4ffb0);
      border: 1px solid #d1e7dd;
      border-radius: 10px;
      box-shadow: 0 4px 15px rgba(0, 0, 0, 0.2);
      padding: 30px;
      width: 400px;
      text-align: center;
      position: relative;
      animation: slideIn 0.6s ease-out;
    }

    /* Animation */
    @keyframes slideIn {
      0% {
        transform: translateY(-50px);
        opacity: 0;
      }
      100% {
        transform: translateY(0);
        opacity: 1;
      }
    }

    .page-title {
      font-size: 28px;
      font-weight: 600;
      color: #1d7736;
      margin-bottom: 20px;
      text-shadow: 0 2px 4px rgba(29, 119, 54, 0.6);
    }

    .forgot-password-form {
      display: flex;
      flex-direction: column;
    }

    .form-group {
      margin-bottom: 20px;
      text-align: left;
    }

    .form-group label {
      font-size: 14px;
      font-weight: 500;
      color: #0f5132;
      margin-bottom: 5px;
      display: block;
    }

    .input-with-button {
      display: flex;
      align-items: center;
      position: relative;
    }

    .input-with-button input {
      width: calc(100% - 140px);
      padding: 12px;
      font-size: 14px;
      border: 1px solid #d1e7dd;
      background: #f8fafc;
      color: #1d7736;
      border-radius: 5px 0 0 5px;
      box-sizing: border-box;
      transition: box-shadow 0.3s;
    }

    .input-with-button input:focus {
      outline: none;
      box-shadow: 0 0 8px #80ed99;
    }

    .action-btn {
      width: 140px;
      font-size: 14px;
      font-weight: 500;
      color: white;
      background: linear-gradient(135deg, #1d7736, #28a745);
      border: none;
      padding: 12px;
      cursor: pointer;
      transition: background 0.3s, transform 0.2s, box-shadow 0.3s;
      border-radius: 0 5px 5px 0;
    }

    .action-btn:hover {
      background: linear-gradient(135deg, #28a745, #5fbd7c);
      transform: translateY(-2px);
      box-shadow: 0 0 10px #80ed99;
    }

    input[type="password"],
    input[type="text"] {
      width: 100%;
      padding: 12px;
      font-size: 14px;
      border: 1px solid #d1e7dd;
      background: #f8fafc;
      color: #1d7736;
      border-radius: 5px;
      box-sizing: border-box;
      transition: box-shadow 0.3s;
    }

    input[type="password"]:focus,
    input[type="text"]:focus {
      outline: none;
      box-shadow: 0 0 8px #80ed99;
    }

    .submit-btn {
      font-size: 16px;
      font-weight: 500;
      color: white;
      background: linear-gradient(135deg, #1d7736, #28a745);
      border: none;
      padding: 15px 20px;
      border-radius: 5px;
      cursor: pointer;
      transition: background 0.3s, transform 0.2s, box-shadow 0.3s;
    }

    .submit-btn:hover {
      background: linear-gradient(135deg, #28a745, #5fbd7c);
      transform: translateY(-2px);
      box-shadow: 0 0 10px #80ed99;
    }

    .submit-btn:hover, 
    .action-btn:hover {
      box-shadow: 0 0 15px #80ed99;
    }
  </style>
</head>
<body>
  <form id="form1" runat="server">
    <div class="container">
      <h1 class="page-title">Forgot | Change Password</h1>

      <div class="forgot-password-form">
        <!-- Contact -->
        <div class="form-group">
          <label for="txtContact">Email Address</label>
          <div class="input-with-button">
            <asp:TextBox ID="txtContact" runat="server" CssClass="form-control" placeholder="Enter your email address" required="true" />
            <asp:Button ID="btnSendCode" runat="server" CssClass="action-btn" Text="Send Code" OnClick="btnSendCode_Click"/>
          </div>
        </div>

        <!-- Verification Code -->
        <div class="form-group">
          <label for="txtVerificationCode">Verification Code</label>
          <div class="input-with-button">
            <asp:TextBox ID="txtVerificationCode" runat="server" CssClass="form-control" placeholder="Enter verification code"/>
            <asp:Button ID="btnVerifyCode" runat="server" CssClass="action-btn" Text="Verify Code" OnClick="btnVerifyCode_Click" />
          </div>
        </div>

        <!-- New Password -->
        <div class="form-group">
          <label for="txtNewPassword">New Password</label>
          <asp:TextBox ID="txtNewPassword" runat="server" TextMode="Password" CssClass="form-control" placeholder="At least 8 characters (Aa,#@!)" required="true" Enabled="false" BackColor="lightGray"/>
        </div>

        <!-- Confirm Password -->
        <div class="form-group">
          <label for="txtConfirmPassword">Re-enter Password</label>
          <asp:TextBox ID="txtConfirmPassword" runat="server" TextMode="Password" CssClass="form-control" placeholder="Confirm your password" required="true" Enabled="false" BackColor="lightGray"/>
            <asp:Label runat="server" ID="errorMessage" Style="color: red;" Visible="false">Passwords do not match.</asp:Label>
        </div>

        <!-- Reset Password Button -->
        <asp:Button ID="btnResetPassword" runat="server" CssClass="submit-btn" Text="Reset | Change Password" OnClick="btnResetPassword_Click" />
      </div>
    </div>
  </form>
</body>
</html>
