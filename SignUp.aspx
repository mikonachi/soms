<%@ Page Title="SignUp" Language="C#" AutoEventWireup="true" CodeBehind="SignUp.aspx.cs" Inherits="SOMS.SignUp" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Create an Account</title>
    <link href="Content/sign-up.css" rel="stylesheet" />

    <style>
        body {
            position: relative;
            margin: 0;
            padding: 0;
            height: 100vh;
            background-image: url('Images/login.png');
            background-size: cover;
            background-position: center center;
            background-attachment: fixed;
            display: flex;
            justify-content: center;
            align-items: center;
            font-family: 'Century Gothic', sans-serif;
        }

            body::before {
                content: '';
                position: absolute;
                top: 0;
                left: 0;
                right: 0;
                bottom: 0;
                background-image: url('Images/login.png');
                background-size: cover;
                background-position: center center;
                background-attachment: fixed;
                filter: blur(10px);
                background-color: rgba(0, 0, 0, 0.5);
                z-index: -1;
            }
    </style>
         <link href="Content/AdminSettings.css" rel="stylesheet" />

</head>

<body>
    <div class="container">
        <h1 class="page-title">Create an Account as S.O. President</h1>
        <form id="signupForm" runat="server" class="forgot-password-form">
            <!-- Personal Information Section -->
            <div class="section personal-info">
                <div class="left-column">
                    <h2 class="section-title">Personal Info</h2>
                    <div class="form-group">
                        <label for="name">Name</label>
                        <asp:TextBox ID="name" runat="server" CssClass="form-control" placeholder="Enter your name" required="required"></asp:TextBox>
                    </div>
                    <div class="form-group">
                        <label for="role">Role</label>
                        <asp:DropDownList ID="role" runat="server" CssClass="form-control" required="required">
                            <asp:ListItem Value="SO">S.O. PRESIDENT</asp:ListItem>
                        </asp:DropDownList>
                    </div>
                    <div class="form-group">
                        <label for="student-number">Student Number</label>
                        <asp:TextBox ID="studentNumber" runat="server" CssClass="form-control" placeholder="Enter your student number" MaxLength="12" required="required"></asp:TextBox>
                    </div>
                    <div class="form-group">
                        <label for="organization">Organization</label>
                        <asp:DropDownList ID="organization" runat="server" CssClass="form-control" required="required">

                        </asp:DropDownList>
                    </div>
                </div>

                <!-- Verification Section -->
                <div class="right-column">
                    <h2 class="section-title">Verification</h2>
                    <div class="form-group">
                        <label for="email">Email</label>
                        <div class="input-with-button">
                            <asp:TextBox ID="email" runat="server" CssClass="form-control" placeholder="Enter your email" required="required" type="email"></asp:TextBox>
                            <asp:Button ID="btnSendCode" runat="server" CssClass="action-btn" Text="Send Code" OnClick="btnSendCode_Click"  />
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="code">Code</label>
                        <div class="input-with-button">
                            <asp:TextBox ID="code" runat="server" CssClass="form-control" placeholder="Enter verification code"></asp:TextBox>
                            <asp:Button ID="btnVerifyCode" runat="server" CssClass="action-btn" Text="Verify" OnClick="btnVerifyCode_Click"  />
                        </div>
                    </div>

                    <!-- Password and Confirm Password Section -->
                    <div class="form-group">
                        <label for="password">Password</label>
                        <asp:TextBox ID="password" runat="server" CssClass="form-control" placeholder="Enter your password" TextMode="Password" Enabled="False" BackColor="lightGray"></asp:TextBox>
                    </div>

                    <div class="form-group">
                        <label for="passwordConf">Confirm Password</label>
                        <asp:TextBox ID="passwordConf" runat="server" CssClass="form-control" placeholder="Confirm your password" TextMode="Password" Enabled="False" BackColor="lightGray"></asp:TextBox>
                    </div>

                    <asp:Label runat="server" ID="errorMessage" Style="color: red;" Visible="false">Passwords do not match.</asp:Label>
                </div>
                 

            <!-- Submit Button -->
            <div class="section submit-section">
                <asp:Button ID="btnSubmit" runat="server" CssClass="submit-btn" Text="Sign Up" OnClick="btnSubmit_Click" Enabled="false" />
            </div>
         </div>
         <div class="text-center">
          <asp:HyperLink ID="HyperLink1" runat="server" NavigateUrl="LogIn.aspx" Text="Already have an account? Log in"></asp:HyperLink>
         </div>


            <asp:HiddenField ID="hfPassword" runat="server" />

             <div class="modal-overlay" id="modalSecurityCode" style="display: none">
                 <div class="custom-message1">
                     <div class="message-header" style="margin-bottom: 30px;">
                         <h3>Enter Access Code to Join A Group</h3>
                     </div>
                     <div class="message-content">
                         <asp:Label ID="Label2" runat="server" Text="Input Access Code" Font-Size="medium" CssClass="lblAlign"></asp:Label>
                         <div class="input-group mb-3">
                             <asp:TextBox ID="txtKey" runat="server" CssClass="form-control txtCustomAccess input-group-text" Style="background-color: white; font-size: medium;"></asp:TextBox><br>
                             <asp:Button runat="server" ID="btnDecryptKey" OnClick="btnDecryptKey_Click" CssClass="form-control btnAccConf" Text="Decrypt Access Code" Style="font-size: medium; border-bottom-right-radius: 20px; border-top-right-radius: 20px;" />
                         </div>
                     </div>
                     <br>
                     <div class="message-footer">
                         <asp:Button ID="btnCancelNewAccessKey" runat="server" Text="Cancel" CssClass="form-control btnCustomCancel" OnClick="btnCancelNewAccessKey_Click" />
                         <asp:Button ID="btnConfirmNewAccessKey" runat="server" Text="Join Group" CssClass=" form-control btnAccConf" OnClick="btnConfirmNewAccessKey_Click" />
                     </div>
                 </div>
             </div>

             <script>
                 function showModalSecCode() {
                     const modal = document.getElementById('modalSecurityCode');
                     modal.style.display = 'flex';
                 }
             </script>


        </form>
    </div>




</body>
</html>
