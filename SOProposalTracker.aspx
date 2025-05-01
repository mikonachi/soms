<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SOProposalTracker.aspx.cs" Inherits="SOMS.SOProposalTracker" %>

<!DOCTYPE html>
<html>
<head>
    <title>SO Proposal Tracker</title>

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

    <link href="Content/SOProposalTracker.css" rel="stylesheet" />
</head>
<body>
    <form id="form1" runat="server">

        <!-- NAVBAR -->
        <nav class="navbar navbar-expand-lg navbar-dark" style="background: #70ad47;">
            <div class="container-fluid">
                <a class="navbar-brand d-flex align-items-center" href="#">
                    <img src="Images/cvsulogo.png" alt="Logo" style="width: 50px; height: 45px; margin-right: 30px; margin-left: 30px; padding: 0;">
                    <span style="font-weight: bold; font-size: 25px;">SOMS</span>
                </a>

                <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
                    <span class="navbar-toggler-icon"></span>
                </button>

                <div class="collapse navbar-collapse" id="navbarNav">
                    <ul class="navbar-nav ms-auto d-flex flex-row align-items-center">
                        <li class="nav-item me-5">
                            <asp:LinkButton ID="btnEventCalendar" runat="server" CssClass="nav-button" Text="Event Calendar" OnClick="btnEventCalendar_Click"/>
                        </li>
                        <li class="nav-item me-5">
                            <asp:LinkButton ID="btnProposalTracking" runat="server" CssClass="nav-button" Text="Proposal Tracking" OnClick="btnProposalTracking_Click"/>
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
            <div class="row">
                <!-- Dropdown List -->
                <div class="col-auto">
                    <asp:DropDownList ID="ddlOptions" runat="server" CssClass="form-select" OnSelectedIndexChanged="ddlOptions_SelectedIndexChanged" AutoPostBack="true" Width="400px">
                        <asp:ListItem Text="Viewing: The Sent Proposal" Value="0"></asp:ListItem>
                    </asp:DropDownList>
                </div>
            </div>

           <%-- <div class="mt-4">
                <asp:Label ID="lblProposalName" runat="server" Text="Proposal Name" Font-Size="24px"></asp:Label>
            </div>--%>

            <!-- Status Labels -->
            <div class="row mt-4 ms-5 custom-gap">

                <!-- Received -->
                <div class="col-auto text-center position-relative">
                    <asp:Label ID="lblReceived" runat="server" CssClass="receivedIcon" BackColor="#fad564">
                        <i class="fa-solid fa-person-circle-check"></i>
                    </asp:Label>
                    <asp:Label ID="lblReceivedDisap" runat="server" CssClass="receivedIconDisap" Visible="false">
                        <i class="fa-regular fa-circle-xmark"></i>
                    </asp:Label>
                    <asp:Label ID="Label1" runat="server" Text="Receiving" CssClass="d-block mt-1"></asp:Label>
                </div>

                <!-- Pending -->
                <div class="col-auto text-center position-relative">
                    <asp:Label ID="lblPending" runat="server" CssClass="receivedIcon">
                        <i class="fa-regular fa-clock"></i>
                    </asp:Label>
                    <asp:Label ID="lblPendingDisap" runat="server" CssClass="receivedIconDisap" Visible="false">
                        <i class="fa-regular fa-circle-xmark"></i>
                    </asp:Label>
                    <asp:Label ID="lbl2" runat="server" Text="Pending" CssClass="d-block mt-1"></asp:Label>
                </div>

                <!-- Finalizing -->
                <div class="col-auto text-center position-relative">
                    <asp:Label ID="lblFinalizing" runat="server" CssClass="receivedIcon">
                        <i class="fa-solid fa-book-open-reader"></i>
                    </asp:Label>
                    <asp:Label ID="lblFinalizingDisap" runat="server" CssClass="receivedIconDisap" Visible="false">
                        <i class="fa-regular fa-circle-xmark"></i>
                    </asp:Label>
                    <asp:Label ID="lbl3" runat="server" Text="Finalizing" CssClass="d-block mt-1"></asp:Label>
                </div>

                <!-- Approved -->
                <div class="col-auto text-center position-relative">
                    <asp:Label ID="lblApproved" runat="server" CssClass="receivedIcon">
                        <i class="fa-solid fa-file-circle-check"></i>
                    </asp:Label>
                    <asp:Label ID="lblApprovedDisap" runat="server" CssClass="receivedIconDisap" Visible="false">
                        <i class="fa-regular fa-circle-xmark"></i>
                    </asp:Label>
                    <asp:Label ID="lbl4" runat="server" Text="Approved" CssClass="d-block mt-1"></asp:Label>
                </div>

            </div>

           <!-- Timeline & Chat -->
            <div class="row mt-custom d-flex align-items-start">
                <!-- Timeline -->
                <div class="col-md-6">
                    <div class="timeline-container">
                        <div class="line"></div>
                        <div class="timeline">
                            <div class="timeline-item">
                                <asp:Label ID="lblTimestamp1" runat="server" CssClass="timestamp">2025-01-01 12:00:00</asp:Label>
                                <div class="circle"></div>
                                <asp:Label ID="lblDetails1" runat="server" CssClass="details">Received by [Name]</asp:Label>
                            </div>
                            <div class="timeline-item">
                                <asp:Label ID="lblTimestamp2" runat="server" CssClass="timestamp">2025-01-01 12:00:00</asp:Label>
                                <div class="circle"></div>
                                <asp:Label ID="lblDetails2" runat="server" CssClass="details">Pending by [Name]</asp:Label>
                            </div>
                            <div class="timeline-item">
                                <asp:Label ID="lblTimestamp3" runat="server" CssClass="timestamp">2025-01-01 12:00:00</asp:Label>
                                <div class="circle"></div>
                                <asp:Label ID="lblDetails3" runat="server" CssClass="details">Finalized by [Name]</asp:Label>
                            </div>
                            <div class="timeline-item">
                                <asp:Label ID="lblTimestamp4" runat="server" CssClass="timestamp">2025-01-01 12:00:00</asp:Label>
                                <div class="circle"></div>
                                <asp:Label ID="lblDetails4" runat="server" CssClass="details">Approved by [Name]</asp:Label>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Chatbox -->
                <div class="col-md-6">
                    <div class="chatbox-container position-relative">
                        <i class="fa-regular fa-comment-dots chat-icon"></i>
                        <asp:TextBox ID="txtChat" runat="server" CssClass="chatbox" TextMode="MultiLine" placeholder="Display Message Here..." ReadOnly="true"></asp:TextBox>
                    </div>
                </div> 
            </div>
        </div>
    </form>
</body>
</html>
