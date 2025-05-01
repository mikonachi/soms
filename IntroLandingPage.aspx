<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="IntroLandingPage.aspx.cs" Inherits="SOMS.IntroLandingPage" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Intro Landing Page</title>

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    
    <!-- jQuery -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

    <!-- FullCalendar CSS & JS -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/fullcalendar/3.10.2/fullcalendar.min.css" rel="stylesheet">
    <script src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.29.1/moment.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/fullcalendar/3.10.2/fullcalendar.min.js"></script>

    <!-- Bootstrap -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <link href="Content/IntroLandingPage.css" rel="stylesheet" />
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
                    <asp:LinkButton ID="btnSettings" runat="server" CssClass="nav-button" OnClick="btnSettings_Click">
                        <i class="fas fa-cog" style="font-weight: bold; color: white; font-size: 25px;"></i>
                    </asp:LinkButton>
                </li>
                <li class="nav-item me-5">
                    <asp:LinkButton ID="btnLogIn" runat="server" CssClass="nav-button-login" Text="Log-In" OnClick="btnLogIn_Click" />
                </li>
            </ul>
        </div>
    </div>
</nav>
        <br>
 <!-- Main container to wrap content -->
    <div class="container mt-5">
        <!-- First row: Title text with gap below -->
        <div class="row">
            <div class="col-12">
                <h1 class="text-center mb-4">
                    An Online Document Proposal Tracking And Activity Monitoring System With Symmetric Key Encryption Algorithm For Cavite State University - Carmona Campus
                </h1>
            </div>
        </div>
        <br><br><br><br>

        <div class="row">

            <div class="col-md-3">
                <div class="text-center">
                    <h4>Activity Calendar</h4>
                    <p>A calendar to see and manage all your scheduled activities in one place</p>
                    <asp:Button ID="btnLeft" runat="server" Text="View Calendar" CssClass="btn leftButton" OnClick="btnLeft_Click"/>
                </div>
            </div>

            <div class="col-md-3">
                <div class="text-center">
                    <img src="Images/gif2.gif" alt="Image 1" class="img-fluid">
                </div>
            </div>

            <div class="col-md-3">
                <div class="text-center">
                    <h4>Proposal Tracking</h4>
                    <p>A tool to check the status of your proposals. Showing if they are approved, rejected, or need changes.</p>
                    <asp:Button ID="btnRight" runat="server" Text="Track Proposal" CssClass="btn rightButton" OnClick="btnRight_Click"/>
                </div>
            </div>

            <div class="col-md-3">
                <div class="text-center">
                    <img src="Images/gif1.gif" alt="Image 2" class="img-fluid">
                </div>
            </div>
        </div>
    </div>



        <div class="login-link">
            <p class="dont-have-account">Don't have an account?</p>
            <a href="SignUp.aspx" class="signup-link">Sign-up</a>
        </div>


</form>
     

</body>
</html>

