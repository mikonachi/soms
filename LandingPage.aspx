<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="LandingPage.aspx.cs" Inherits="SOMS.WebForm1" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SOMS Landing Page</title>

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

    <link href="Content/LandingPage.css" rel="stylesheet" />
    <style>
        body {
            margin: 0;
            padding: 0;
            height: 100vh;
            background-image: url('Images/landingpage.gif');
            background-size: cover;
            background-position: center center;
            background-attachment: fixed;
            font-family: 'Century Gothic', sans-serif;
        }

        body::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background-image: url('Images/landingpage.gif');
            background-size: cover;
            background-position: center center;
            background-attachment: fixed;
            filter: blur(10px);
            background-color: rgba(0, 0, 0, 0.5);
            z-index: -1;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">

        <!-- NAVBAR -->
        <nav class="navbar navbar-expand-lg navbar-dark" style="background: #70ad47;">
         <div class="container-fluid">
        <!-- Left side: Logo and App Name -->
        <a class="navbar-brand d-flex align-items-center" href="IntroLandingPage.aspx">
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
                    <asp:LinkButton ID="btnLogIn" runat="server" CssClass="nav-button-login" Text="Log-In" OnClick="btnLogIn_Click"/>
                </li>
            </ul>
        </div>
    </div>
</nav>


<div class="container">
    <asp:Label ID="lblMessage" CssClass="custom-label" runat="server" Text="Sign up as" />
    
    <div class="button-container">
        <asp:Button ID="btnLeft" runat="server" Text="S.O. President"
            CssClass="btn leftButton" OnClick="btnLeft_Click" />
        <asp:Button ID="btnRight" runat="server" Text="Faculty Member"
            CssClass="btn rightButton" OnClick="btnRight_Click" />
    </div>
</div>

        
        <div class="login-link">
            <p class="dont-have-account">Already have an account?</p>
            <a href="LogIn.aspx" class="signup-link">Log-in</a>
        </div>



</form>






</body>
</html>
