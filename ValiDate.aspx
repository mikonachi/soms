<%@ Page Title="" Language="C#" AutoEventWireup="true" CodeBehind="ValiDate.aspx.cs" Inherits="SOMS.WebForm2" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Event Calendar</title>

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    
    <!-- jQuery -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

    <!-- Bootstrap -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

    <link href="Content/ManageGroups.css" rel="stylesheet" />
    <style>
        table {
            width: 100%;
            border-collapse: collapse;
            font-family: 'Century Gothic', sans-serif;
        }

        th, td {
            border: 1px solid #ddd;
            padding: 10px;
            text-align: left;
        }

        th {
            background-color: #70ad47;
            color: white;
            text-align: center;
        }

        tr:nth-child(even) {
            background-color: #f2f2f2;
        }

        td:first-child {
            font-weight: bold;
        }

        td:last-child {
            text-align: center;
            font-weight: bold;
        }

        .available {
            color: green;
            font-weight: bold;
            text-align: center;
        }

        .not-available {
            color: crimson;
            font-weight: bold;
            text-align: center;
        }
        .btn{
             min-width: 150px;
             background-color: #70ad47;
             border: none;
             border-radius: 25px;
             color: white;
        }

        .btn:hover {
            background-color: #5a8c39;
            color: white;
        }
    </style>

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
                            <asp:LinkButton ID="btnProposalTracking" runat="server" CssClass="nav-button" Text="Proposal Tracking" OnClick="btnProposalTracking_Click"/>
                        </li>
                        <li class="nav-item me-5">
                            <asp:LinkButton ID="btnGroups" runat="server" CssClass="nav-button" Text="Groups" OnClick="btnGroups_Click" />
                        </li>
                        <li class="nav-item me-5">
                            <asp:LinkButton ID="btnSettings" runat="server" CssClass="nav-button" OnClick="btnSettings_Click">
                        <i class="fas fa-cog" style="font-weight: bold; color: white; font-size: 25px;"></i>
                            </asp:LinkButton>
                        </li>
                    </ul>
                </div>
            </div>
        </nav>

        <div class="container">
            <div class="header">
                <a href="Calendar.aspx"><span>< Calendar</span></a>
            </div>
            <br />

            <table>
                <tr>
                    <th>Category</th>
                    <th>Details</th>
                    <th>Availability</th>
                </tr>
                <tr>
                    <td>Venue</td>
                    <td>
                        <asp:Label ID="lblVenue" runat="server" Text="Loading..."></asp:Label></td>
                    <td>
                        <asp:Label ID="lblVenueAvailability" runat="server" Text="Checking..."></asp:Label></td>
                </tr>
                <tr>
                    <td>Time and Date</td>
                    <td>
                        <asp:Label ID="lblTimeDate" runat="server" Text="Loading..."></asp:Label></td>
                    <td>
                        <asp:Label ID="lblTimeDateAvailability" runat="server" Text="Checking..."></asp:Label></td>
                </tr>
                <tr>
                    <td>Faculty Member</td>
                    <td>
                        <asp:Label ID="lblFacultyMember" runat="server" Text="Loading..."></asp:Label></td>
                    <td>
                        <asp:Label ID="lblFacultyMemberAvailability" runat="server" Text="Checking..."></asp:Label></td>
                </tr>
                <tr>
                    <td>Sound System</td>
                    <td>
                        <asp:Label ID="lblSoundSystem" runat="server" Text="Loading..."></asp:Label></td>
                    <td>
                        <asp:Label ID="lblSoundSystemAvailability" runat="server" Text="Checking..."></asp:Label></td>
                </tr>
                <tr>
                    <td>Chairs</td>
                    <td>
                        <asp:Label ID="lblChairs" runat="server" Text="Loading..."></asp:Label></td>
                    <td>
                        <asp:Label ID="lblChairsAvailability" runat="server" Text="Checking..."></asp:Label></td>
                </tr>
                <tr>
                    <td>Curtains</td>
                    <td>
                        <asp:Label ID="lblCurtains" runat="server" Text="Loading..."></asp:Label></td>
                    <td>
                        <asp:Label ID="lblCurtainsAvailability" runat="server" Text="Checking..."></asp:Label></td>
                </tr>
                <tr>
                    <td>Screen & Projector</td>
                    <td>
                        <asp:Label ID="lblScreenProjector" runat="server" Text="Loading..."></asp:Label></td>
                    <td>
                        <asp:Label ID="lblScreenProjectorAvailability" runat="server" Text="Checking..."></asp:Label></td>
                </tr>
                <tr>
                    <td>Podium</td>
                    <td>
                        <asp:Label ID="lblPodium" runat="server" Text="Loading..."></asp:Label></td>
                    <td>
                        <asp:Label ID="lblPodiumAvailability" runat="server" Text="Checking..."></asp:Label></td>
                </tr>
            </table>
            <br>
            <div style="display: flex; flex-direction: column; align-items: center; text-align: center;">
                <h6>Check availability for your preferred schedule. Select to see open slots for:</h6>
                <div style="display: flex; gap: 10px; margin-top: 10px; justify-content: center;">
                    <asp:Button ID="btnTomorrow" runat="server" Text="Tomorrow" CssClass="btn" OnClick="btnTomorrow_Click" />
                    <asp:Button ID="btnThreeDays" runat="server" Text="3 days from now" CssClass="btn" OnClick="btnThreeDays_Click" />
                    <asp:Button ID="btnAWeek" runat="server" Text="A week from now" CssClass="btn" OnClick="btnAWeek_Click" />
                </div>
            </div>

            <br><br>

            <div style="display: flex; flex-direction: column; align-items: center; text-align: center;">
                <h6>Reminder: Schedule your event at least 3 days in advance or up to a week before to increase the
                    
                    chances of approval and ensure all preparations are in place.</h6>
                <div style="display: flex; justify-content: center; margin-top: 10px;">
                    <asp:Button ID="btnSubmitProposal" runat="server" Text="SUBMIT" CssClass="btn" OnClick="btnSubmitProposal_Click" />
                </div>
            </div>

        </div>
        <asp:HiddenField ID="hfSuggestedDate" runat="server" />
        <%--MODAL AVAILABILITY CHECKING--%>
        <div class="modal-overlay" id="modalCheckAvailability" style="display: none;">
            <div class="custom-message">
                <i class="fa fa-info-circle info-icon"></i>
                <div class="message-header">
                    <asp:Label ID="lblHeaderModal" runat="server" Text="Recommend"></asp:Label>
                </div>
                <hr class="divider" />
                <div class="message-content">
                    <asp:Label ID="lblModalContent" runat="server" Text="Please select another date option."></asp:Label>
                </div>
                <br>
                <div class="message-footer">
                    <asp:Button ID="Button1" runat="server" Text="Cancel" CssClass="form-control btnCustomCancelMsg"/>
                    <asp:Button ID="btnConfirm" runat="server" Text="Confirm" CssClass=" form-control btnAccConf" OnClick="btnConfirm_Click"/>
                </div>
            </div>
        </div>
        <asp:HiddenField ID="isClicked" runat="server" />

        <script>

            function showModalAvailability() {
                const modal = document.getElementById('modalCheckAvailability');
                modal.style.display = 'flex';
            }

        </script>

        </form>
</body>

</html>