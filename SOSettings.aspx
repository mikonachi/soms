<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SOSettings.aspx.cs" Inherits="SOMS.Settings" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
  <title>AdminSettings</title>

 <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css"/>
 
 <!-- jQuery -->
 <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

 <!-- FullCalendar CSS & JS -->
 <link href="https://cdnjs.cloudflare.com/ajax/libs/fullcalendar/3.10.2/fullcalendar.min.css" rel="stylesheet"/>
 <script src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.29.1/moment.min.js"></script>
 <script src="https://cdnjs.cloudflare.com/ajax/libs/fullcalendar/3.10.2/fullcalendar.min.js"></script>

 <!-- Bootstrap -->
 <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"/>
 <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

  <link href="Content/AdminSettings.css" rel="stylesheet" />

</head>
<body>
    <form id="form1" runat="server">

         <!-- NAVBAR -->
        <nav class="navbar navbar-expand-lg navbar-dark" style="background: #70ad47;">
         <div class="container-fluid">
        <!-- Left side: Logo and App Name -->
        <a class="navbar-brand d-flex align-items-center" href="#">
            <img src="Images/cvsulogo.png" alt="Logo" style="width: 50px; height: 45px; margin-right: 30px; margin-left: 30px; padding: 0;">
            <span style="font-weight: bold; font-size: 25px;">SOMS</span>
        </a>

        <!-- Button to toggle the navbar on smaller screens -->
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>

        <!-- Right side: Navigation items and Login button -->
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav ms-auto d-flex flex-row align-items-center">
                <li class="nav-item me-5">
                    <asp:LinkButton ID="btnEventCalendar" runat="server" CssClass="nav-button" Text="Event Calendar" OnClick="btnEventCalendar_Click" />
                </li>
                <li class="nav-item me-5">
                    <asp:LinkButton ID="btnProposalTracking" runat="server" CssClass="nav-button" Text="Proposal Tracking" OnClick="btnProposalTracking_Click" />
                </li>
                <li class="nav-item me-5">
                    <asp:LinkButton ID="btnSettings" runat="server" CssClass="nav-button">
                        <i class="fas fa-cog" style="font-weight: bold; color: white; font-size: 25px;"></i>
                    </asp:LinkButton>
                </li>

<%--                <li class="nav-item me-5">
                    <asp:LinkButton ID="btnLogIn" runat="server" CssClass="nav-button-login" Text="Log-In" OnClick="btnLogIn_Click"/>
                </li>--%>
            </ul>
        </div>
    </div>
</nav>


        <div class="container">
            <div class="header">
                <span>Settings</span>
                <hr />
            </div>
            
            <div class="row mb-3">
                <div class="col">
                    <div class="input-group mb-3">
                        <span class="input-group-text spanCustom"><i class="fa fa-user-lock" style="color: #70ad47"></i>
                        </span>
                        <asp:Button runat="server" CssClass="form-control" Text="Change Password" OnClick="Unnamed1_Click" />
                    </div>
                </div>
                <div class="col">
                    <div class="input-group mb-3">
                        <span class="input-group-text spanCustom"><i class="fa fa-key" style="color: #ffd966"></i></span>
                        <asp:Button runat="server" ID="btnChangeAccessKey" CssClass="form-control" Text="Change Access Key" OnClick="btnChangeAccessKey_Click"/>
                    </div>
                </div>
                
            </div>
 
            <br><br>
 
            <div class="header">
                <hr />
            </div>
 
            <div class="info-container" style="display: flex;">
                <div style="flex: 1;">
                    <div class="input-group mb-3">
                        <span class="input-group-text spanCustom"><i class="fa fa-user-xmark" style="color: crimson"></i></span>
                        <asp:Button runat="server" ID="btnDeleteAdminAcc" CssClass="form-control" Text="Delete this Account" OnClick="btnDeleteAdminAcc_Click"/>
                    </div>
                </div>
                <i class="fa fa-info-circle" style="color: black; font-size: 30px; margin-left: 100px; margin-bottom: 20px;"></i>
                <div style="flex: 2; margin-left: 20px; text-align: justify;">
                    <p>
                        Deletion of this account terminates all of the data registered
                        <br>
                        including groups, proposal tracked and all activities made.
                        <br>
                        <strong style="color: crimson">REMEMBER</strong> this action cannot be undone but you may still make a
                        <br>
                        new account using this user information.
                    </p>
                </div>
            </div>
            
            <!-- Logout Button -->
            <asp:LinkButton ID="btnLogout" runat="server" CssClass="form-control btnLogout" OnClick="btnLogout_Click"><i class='fas fa-sign-out'></i> Log Out</asp:LinkButton>
        </div>
 
 
        <div class="modal-overlay" id="modalOverlay" style="display:none">
            <div class="custom-message">
                <i class="fa fa-info-circle info-icon"></i>
                <div class="message-header">
                    <h6>Access Key</h6>
                </div>
                <hr class="divider" />
                <div class="message-content">
                    <asp:TextBox ID="txtAccessKey" runat="server" CssClass="form-control txtCustomAccess" placeholder="Enter Access Key"></asp:TextBox>
                </div>
 
                <br>
                <div class="message-footer">
                    <asp:Button ID="btnCancel" runat="server" Text="Cancel" CssClass="form-control btnAccLogOut" OnClick="Button1_Click"/>
                    <asp:Button ID="btnConfirm" runat="server" Text="Confirm" CssClass=" form-control btnAccConf" OnClick="btnConfirm_Click"/>
                </div>
            </div>
        </div>
 
 
        <div class="modal-overlay" id="modalNewSecurityCode" style="display:none">
            <div class="custom-message1">
                <div class="message-header" style="margin-bottom: 30px;">
                    <h5>New Security Code</h5>
                </div>
                <div class="message-content">
                    <asp:Label ID="Label1" runat="server" Text="Old Admin Access Key" Font-Size="medium" CssClass="lblAlign"></asp:Label>
                    <asp:TextBox ID="txtOldAccessKey" runat="server" CssClass="form-control txtCustomAccess" ReadOnly="true"></asp:TextBox><br>
                    <asp:Label ID="Label2" runat="server" Text="New Admin Access Key" Font-Size="medium" CssClass="lblAlign"></asp:Label>
                    
                    <div class="input-group mb-3">
                        <asp:TextBox ID="txtGeneratedKey" runat="server" CssClass="form-control txtCustomAccess input-group-text" style="background-color: white; font-size: small; min-width: 250px;"></asp:TextBox>
                        <asp:Button runat="server" ID="btnGenerateEncryptedKey" OnClick="btnGenerateEncryptedKey_Click" CssClass="form-control btnAccConf" Text="Generate Encrypted Key" Style="font-size: x-small; border-bottom-right-radius: 20px; border-top-right-radius: 20px;" />
                    </div>
                    <asp:Label ID="lblMessageSave" runat="server" Text="Please save the Generated Access Key!" Font-Size="medium" ForeColor="Crimson" Visible="false"></asp:Label>
                </div>
                <br>
                <div class="message-footer">
                    <asp:Button ID="btnCancelNewAccessKey" runat="server" Text="Cancel" CssClass="form-control btnCustomCancel" OnClick="btnCancelNewAccessKey_Click"/>
                    <asp:Button ID="btnConfirmNewAccessKey" runat="server" Text="Confirm" CssClass=" form-control btnAccConf" OnClick="btnConfirmNewAccessKey_Click"/>
                </div>
            </div>
        </div>
 
 
        <div class="modal-overlay" id="modalSuccess" style="display:none;">
            <div class="custom-message">
                <i class="fa fa-info-circle info-icon"></i>
                <div class="message-content" style="margin-top: 40px;">
                    <h6>Action Registered<br>Successfully!</h6>
                </div>
 
                <br>
                <div class="message-footer">
                    <asp:Button ID="btnClose" runat="server" Text="Confirm" CssClass=" form-control btnAccConf" OnClick="btnClose_Click"/>
                </div>
            </div>
        </div>



            <%--MODAL CONFIRM DELETION--%>
        <div class="modal-overlay" id="modalDeleteConf" style="display: none;">
            <div class="custom-message">
                <div class="message-header">
                    <h6>Delete this admin account?</h6>
                </div>
                <hr class="divider" />
                <div class="message-content">
                    <h6>This action cannot be<br>
                        undone. Proceed?</h6>
                </div>
                <br>
                <div class="message-footer">
                    <asp:Button ID="Button1" runat="server" Text="Cancel" CssClass="form-control btnAccLogOut"/>
                    <asp:Button ID="btnConfirmAskDelete" runat="server" Text="Confirm" CssClass=" form-control btnAccConf" OnClick="btnConfirmAskDelete_Click"/>
                </div>
            </div>
        </div>

        <asp:HiddenField ID="hf1" runat="server" />

        <script>

            function showModal() {
                const modal = document.getElementById('modalOverlay');
                modal.style.display = 'flex';
            }

            function showModalNewSecCode() {
                const modal = document.getElementById('modalNewSecurityCode');
                modal.style.display = 'flex';
            }

            function showModalSuccess() {
                const modal = document.getElementById('modalSuccess');
                modal.style.display = 'flex';
            }

            function showModalConfDel() {
                const modal = document.getElementById('modalDeleteConf');
                modal.style.display = 'flex';
            }
        </script>
    </form>
</body>
</html>

