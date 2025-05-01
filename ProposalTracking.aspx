<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ProposalTracking.aspx.cs" Inherits="SOMS.ProposalTracking" %>
<%@ Register Src="ucAdminReceived.ascx" TagPrefix="uc" TagName="MyEventControlAdminReceived" %>
<%@ Register Src="ucAdminPending.ascx" TagPrefix="uc" TagName="MyEventControlAdminPending" %>
<%@ Register Src="ucAdminApproved.ascx" TagPrefix="uc" TagName="MyEventControlAdminApproved" %>
<%@ Register Src="ucAdminRevDis.ascx" TagPrefix="uc" TagName="MyEventControlAdminRevDis" %>


<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">

     <title>Proposal Tracking</title>

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

    <link href="Content/ProposalTracking.css" rel="stylesheet" />

    <style>
        .card {
            border-radius: 20px;
            min-height: 662px;
        }
        .btn {
            border-radius: 20px;
            font-size: 14px;
            /*padding-left: 20px;*/
            /*padding-right: 35px;*/
        }
        .btnAdd {
            border-radius: 50%;
            padding-left: 10px;
            padding-right: 10px;
            font-size: 14px;
        }
        .modal{
            backdrop-filter: blur(5px); /* Apply blur to the background */
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
                            <asp:LinkButton ID="btnEventCalendar" runat="server" CssClass="nav-button" Text="Event Calendar" OnClick="btnEventCalendar_Click"/>
                        </li>
                        <li class="nav-item me-5">
                            <asp:LinkButton ID="btnProposalTracking" runat="server" CssClass="nav-button" Text="Proposal Tracking"/>
                        </li>
                        <li class="nav-item me-5">
                            <asp:LinkButton ID="btnGroups" runat="server" CssClass="nav-button" Text="Groups" OnClick="btnGroups_Click"/>
                        </li>
                        <li class="nav-item me-5">
                            <asp:LinkButton ID="btnSettings" runat="server" CssClass="nav-button" OnClick="btnSettings_Click">
                        <i class="fas fa-cog" style="font-weight: bold; color: white; font-size: 25px;"></i>
                            </asp:LinkButton>
                        </li>

                        <%--<li class="nav-item me-5">
                    <asp:LinkButton ID="btnLogIn" runat="server" CssClass="nav-button-login" Text="Log-In" OnClick="btnLogIn_Click"/>
                </li>--%>
                    </ul>
                </div>
            </div>
        </nav>

        <div class="container">
            <div class="row">
                <div class="col-md-3">
                    <div class="d-flex mb-2">
                        <asp:LinkButton ID="lbReceived" runat="server" CssClass="btn text-dark me-2 d-inline-block" Style="background-color: #fff2cc;" OnClick="lbReceived_Click">
                        <i class="fas fa-circle" style="color: #c4a000"></i> Received
                        </asp:LinkButton>
                        <asp:LinkButton ID="LinkButton5" runat="server" CssClass="btn text-dark d-inline-block btnAdd" Style="background-color: #70ad47;" OnClientClick="openAddEvent(); return false;">
                        <i class="fas fa-plus" style="color: white"></i>
                        </asp:LinkButton>
                    </div>
                    <div class="card" style="background-color: #fff2cc">
                        <div class="card-body">
                            <asp:Repeater ID="rptReceived" runat="server">
                                <ItemTemplate>
                                    <div class="event-control">
                                        <uc:MyEventControlAdminReceived runat="server"
                                            TimeStart='<%# Eval("TimeStart") %>'
                                            TimeEnd='<%# Eval("TimeEnd") %>'
                                            Organization='<%# Eval("Organization") %>'
                                            Venue='<%# Eval("Venue") %>'
                                            ReferenceNo='<%# Eval("ReferenceNo") %>' />
                                    </div>
                                    <br>
                                </ItemTemplate>
                            </asp:Repeater>
                        </div>
                    </div>
                </div>

                <div class="col-md-3">
                    <asp:LinkButton ID="lbPending" runat="server" CssClass="btn btn-block text-dark mb-2" Style="background-color: #deebf7;" OnClick="lbPending_Click"><i class="fas fa-circle" style="color: #3b6d8b"></i> Pending</asp:LinkButton>
                    <div class="card" style="background-color: #deebf7">
                        <div class="card-body">
                            <asp:Repeater ID="rptPending" runat="server">
                                <ItemTemplate>
                                    <div class="event-control">
                                        <uc:MyEventControlAdminReceived runat="server"
                                            TimeStart='<%# Eval("TimeStart") %>'
                                            TimeEnd='<%# Eval("TimeEnd") %>'
                                            Organization='<%# Eval("Organization") %>'
                                            Venue='<%# Eval("Venue") %>'
                                            ReferenceNo='<%# Eval("ReferenceNo") %>' />
                                    </div>
                                    <br>
                                </ItemTemplate>
                            </asp:Repeater>
                        </div>
                    </div>
                </div>
                <div class="col-md-3">
                    <asp:LinkButton ID="lbRevDis" runat="server" CssClass="btn btn-block text-dark mb-2" Style="background-color: #f8cbad;" OnClick="lbRevDis_Click"><i class="fas fa-circle" style="color: #b45f06"></i> Revision/Disapproved</asp:LinkButton>
                    <div class="card" style="background-color: #f8cbad">
                        <div class="card-body">
                            <asp:Repeater ID="rptRevDisApp" runat="server">
                                <ItemTemplate>
                                    <div class="event-control">
                                        <uc:MyEventControlAdminRevDis runat="server"
                                            TimeStart='<%# Eval("TimeStart") %>'
                                            TimeEnd='<%# Eval("TimeEnd") %>'
                                            Organization='<%# Eval("Organization") %>'
                                            Venue='<%# Eval("Venue") %>'
                                            ReferenceNo='<%# Eval("ReferenceNo") %>' />
                                    </div>
                                    <br>
                                </ItemTemplate>
                            </asp:Repeater>
                        </div>
                    </div>
                </div>
                <div class="col-md-3">
                    <asp:LinkButton ID="lbApproved" runat="server" CssClass="btn btn-block text-dark mb-2" Style="background-color: #c5e0b4;" OnClick="lbApproved_Click"><i class="fas fa-circle" style="color: #4f6228"></i> Approved</asp:LinkButton>
                    <div class="card" style="background-color: #c5e0b4">
                        <div class="card-body">
                            <asp:Repeater ID="rptApproved" runat="server">
                                <ItemTemplate>
                                    <div class="event-control">
                                        <uc:MyEventControlAdminApproved runat="server"
                                            TimeStart='<%# Eval("TimeStart") %>'
                                            TimeEnd='<%# Eval("TimeEnd") %>'
                                            Organization='<%# Eval("Organization") %>'
                                            Venue='<%# Eval("Venue") %>'
                                            ReferenceNo='<%# Eval("ReferenceNo") %>' />
                                    </div>
                                    <br>
                                </ItemTemplate>
                            </asp:Repeater>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Received Comment Modal -->
        <div id="commentModal" class="modal fade" tabindex="-1">
            <div class="modal-dialog modal-sm modal-dialog-centered">
                <div class="modal-content d-flex justify-content-center" style="border-radius: 20px; overflow: hidden; border: 1px solid black">
                    <h5 class="modal-title text-center w-100" style="margin-top: 20px;">Add a note</h5>
                    <div class="modal-body text-center">
                        <asp:TextBox runat="server" ID="txtComment" CssClass="form-control" TextMode="MultiLine" Rows="4" placeholder="Enter your comments here..." style="border-radius: 20px;"></asp:TextBox>
                    </div>
                    <div class="d-flex justify-content-center" style="border-top: none; margin-bottom: 20px">
                        <asp:Button ID="btnClose" runat="server" Text="Cancel" CssClass="btn btn-secondary px-4" Style="margin-right: 50px;" />
                        <asp:Button ID="btnCommentSend" runat="server" Text="Confirm" CssClass="btn btn-primary px-4" Style="background-color: #5b9bd5; border: none" OnClick="btnCommentSend_Click" />
                    </div>

                </div>
            </div>
            <asp:HiddenField ID="hfCommentRefNo" runat="server" />
        </div>



        <!-- Received Edit Modal -->
        <div id="editModal" class="modal fade" tabindex="-1">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">Edit Details for <span id="editModalRefNo"></span></h5>
                    </div>
                    <div class="message-content">
                        <asp:Label ID="Label1" runat="server" Text="Old Admin Access Key" Font-Size="medium" CssClass="lblAlign"></asp:Label>
                        <asp:TextBox ID="txtOldAccessKey" runat="server" CssClass="form-control txtCustomAccess" ReadOnly="true"></asp:TextBox><br>
                        <asp:Label ID="Label2" runat="server" Text="New Admin Access Key" Font-Size="medium" CssClass="lblAlign"></asp:Label>

                        <asp:Label ID="lblMessageSave" runat="server" Text="Please save the Generated Access Key!" Font-Size="medium" ForeColor="Crimson" Visible="false"></asp:Label>
                    </div>
                    <br>
                    <div class="message-footer">
                        <asp:Button ID="btnCancelEdit" runat="server" Text="Cancel" CssClass="form-control btnCustomCancel" />
                        <asp:Button ID="btnEditReceived" runat="server" Text="Confirm" CssClass=" form-control btnAccConf" />
                    </div>
                </div>
            </div>
        </div>


        

        <!-- Pending Comment Modal -->
        <div id="commentModalPending" class="modal fade" tabindex="-1">
            <div class="modal-dialog modal-sm modal-dialog-centered">
                <div class="modal-content d-flex justify-content-center" style="border-radius: 20px; overflow: hidden; border: 1px solid black"">
                    <h5 class="modal-title text-center w-100" style="margin-top: 20px;">Add a note</h5>
                    <div class="modal-body text-center">
                        <textarea class="form-control" rows="4" placeholder="Enter your comments here..." style="border-radius: 20px;"></textarea>
                    </div>
                    <div class="d-flex justify-content-center" style="border-top: none; margin-bottom: 20px">
                        <asp:Button ID="Button4" runat="server" Text="Cancel" CssClass="btn btn-secondary px-4" Style="margin-right: 50px;" />
                        <asp:Button ID="Button5" runat="server" Text="Confirm" CssClass="btn btn-primary px-4" Style="background-color: #5b9bd5; border: none" OnClick="btnCommentSend_Click" />
                    </div>

                </div>
            </div>
            <asp:HiddenField ID="HiddenField1" runat="server" />
        </div>



        <!-- Pending Edit Modal -->
        <div id="editModalPending" class="modal fade" tabindex="-1">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">Edit Details for<span id="editModalRefNoPending"></span></h5>
                    </div>
                    <div class="message-content">
                        <asp:Label ID="Label3" runat="server" Text="Old Admin Access Key" Font-Size="medium" CssClass="lblAlign"></asp:Label>
                        <asp:TextBox ID="TextBox1" runat="server" CssClass="form-control txtCustomAccess" ReadOnly="true"></asp:TextBox><br>
                        <asp:Label ID="Label4" runat="server" Text="New Admin Access Key" Font-Size="medium" CssClass="lblAlign"></asp:Label>

                        <asp:Label ID="Label5" runat="server" Text="Please save the Generated Access Key!" Font-Size="medium" ForeColor="Crimson" Visible="false"></asp:Label>
                    </div>
                    <br>
                    <div class="message-footer">
                        <asp:Button ID="Button6" runat="server" Text="Cancel" CssClass="form-control btnCustomCancel" />
                        <asp:Button ID="Button7" runat="server" Text="Confirm" CssClass=" form-control btnAccConf" />
                    </div>
                </div>
            </div>
        </div>



        <!-- Modal for Registering New Event -->
        <div class="modal fade" id="eventModal" tabindex="-1" aria-labelledby="eventModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content" style="border-radius: 20px; border: none; padding: 20px;">
                    <!-- Modal Header -->
                  <div class="modal-header text-center" style="border-bottom: none; display: flex; justify-content: space-between; align-items: center;">
                       <h5 class="modal-title w-100" id="eventModalLabel1"><strong>Add New Proposal</strong></h5>
                       <asp:TextBox ID="txtProposalDate" runat="server" TextMode="Date" CssClass="form-control" placeholder="Proposed Date" style="width: auto; margin-left: 10px;"></asp:textBox>
                    </div>
                    <!-- Modal Body -->
                    <div class="modal-body">
                        <!-- Event Details Section -->
                        <h6>Event Details</h6>
                        <div class="mb-3">
                            <asp:TextBox ID="txtTitle" runat="server" CssClass="form-control" placeholder="Title of Activity" Font-Size="small" ></asp:TextBox>
                        </div>

                        <div class="row">
                            <div class="col-6">
                                <asp:DropDownList ID="ddlVenue" runat="server" CssClass="form-select" Font-Size="small">
                                    <asp:ListItem Value="-">Select Venue</asp:ListItem>
                                    <asp:ListItem>Multi-purpose Hall</asp:ListItem>
                                    <asp:ListItem>Star Building Rooms</asp:ListItem>
                                    <asp:ListItem>Main Building Rooms</asp:ListItem>
                                    <asp:ListItem>Ground Floor</asp:ListItem>
                                    <asp:ListItem>HRM Building</asp:ListItem>
                                </asp:DropDownList>
                            </div>
                            <div class="col-6">
                                <asp:DropDownList ID="ddlOrgname" runat="server" CssClass="form-select" Font-Size="small" DataSourceID="SqlDataSource1" DataTextField="organization" DataValueField="organization" AppendDataBoundItems="true">
                                    <asp:ListItem Value="-">Select Organization</asp:ListItem>
                                </asp:DropDownList>
                                <asp:SqlDataSource runat="server" ID="SqlDataSource1" ConnectionString='<%$ ConnectionStrings:OMSDBConnectionString3 %>' ProviderName='<%$ ConnectionStrings:OMSDBConnectionString3.ProviderName %>' SelectCommand="SELECT [organization] FROM [TB_Authority] WHERE organization NOT IN ('org1', 'FACULTY')"></asp:SqlDataSource>
                            </div>

                        </div>

                        <div class="row">
                            <div class="col-4">
                                <label for="txtEventTime" class="form-label"><small>Start Time:</small></label>
                                <asp:TextBox ID="txtEventTime" runat="server" TextMode="Time" CssClass="form-control" placeholder="Start Time" Font-Size="small"></asp:TextBox>
                            </div>
                            <div class="col-4">
                                <label for="txtEndTime" class="form-label"><small>End Time:</small></label>
                                <asp:TextBox ID="txtEndTime" runat="server" TextMode="Time" CssClass="form-control" placeholder="End Time" Font-Size="small"></asp:TextBox>
                            </div>
                            <div class="col-4">
                                <label for="txtEventDate" class="form-label"><small>Event Date:</small></label>
                                <asp:TextBox ID="txtEventDate" runat="server" TextMode="Date" CssClass="form-control" placeholder="Event Date" Font-Size="small" ></asp:TextBox>
                            </div>
                        </div>

                        <!-- Formal Request Section -->
                        <h6 class="mt-3">Formal Request</h6>

                        <div class="mb-3">
                            <asp:DropDownList ID="ddlFacultyMember" runat="server" CssClass="form-select" Font-Size="small">
                                <asp:ListItem Value="-">Faculty Member Appearance</asp:ListItem>
                                <asp:ListItem>Dean</asp:ListItem>
                                <asp:ListItem>Program Coordinator</asp:ListItem>
                                <asp:ListItem>OSAS</asp:ListItem>
                                <asp:ListItem>Org Adviser</asp:ListItem>
                            </asp:DropDownList>
                        </div>

                        <div class="row">
                            <div class="col-4">
                                <input type="checkbox" class="btn-check" id="cbPodium" name="cbPodium" autocomplete="off"/>
                                <label class="btn btn-outline-primary btnWidth " for="cbPodium">Podium</label>
                            </div>
                            <div class="col-4">
                                <input type="checkbox" class="btn-check" id="cbChairs" name="cbChairs" autocomplete="off"/>
                                <label class="btn btn-outline-primary btnWidth " for="cbChairs">Chairs</label>
                            </div>
                            <div class="col-4">
                                <input type="checkbox" class="btn-check" id="cbCurtains" name="cbCurtains" autocomplete="off"/>
                                <label class="btn btn-outline-primary btnWidth" for="cbCurtains">Curtains</label>
                            </div>
                        </div>

                        <div class="row mt-3">
                            <div class="col-6">
                                <input type="checkbox" class="btn-check" id="cbSoundSystem" name="cbSoundSystem" autocomplete="off"/>
                                <label class="btn btn-outline-primary btnWidth" for="cbSoundSystem">Sound System</label>
                            </div>
                            <div class="col-6">
                                <input type="checkbox" class="btn-check" id="cbScreenAndProjector" name="cbScreenAndProjector" autocomplete="off"/>
                                <label class="btn btn-outline-primary btnWidth" for="cbScreenAndProjector">Screen and Projector</label>
                            </div>
                        </div>

                        <div class="modal-footer d-flex justify-content-between mt-3" style="border-top: none;">
                            <asp:Button ID="Button8" runat="server" Text="Cancel" CssClass="btn btn-secondary cancelBtn" UseSubmitBehavior="false" />
                            <asp:Button ID="Button9" runat="server" Text="Confirm" CssClass="btn btn-primary confirmBtn" OnClick="btnSaveEvent_Click" />
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Modal for VIEW DETAILS Event -->
        <div class="modal fade" id="eventModalViewDetails" tabindex="-1" aria-labelledby="eventModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content" style="border-radius: 20px; border: none; padding: 20px;">
                    <!-- Modal Header -->
                    <div class="modal-header text-center" style="border-bottom: none;">
                        <h5 class="modal-title w-100" id="eventModalLabel"><strong>Event Details</strong></h5>
                        <!-- <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button> -->
                    </div>

                    <div class="modal-body">
                        <!-- Event Details Section -->
                        <h6>Event Details</h6>
                        <div class="mb-3">
                            <asp:TextBox ID="txtTitleView" runat="server" CssClass="form-control" placeholder="Title of Activity" Font-Size="small" ReadOnly="true"></asp:TextBox>
                        </div>

                        <div class="row">
                            <div class="col-6">
                                <label for="txtVenue" class="form-label"><small>Venue:</small></label>
                                <asp:TextBox ID="txtVenue" runat="server" CssClass="form-control" placeholder="Venue" Font-Size="small" ReadOnly="true"></asp:TextBox>
                            </div>
                            <div class="col-6">
                                <label for="txtOrgName" class="form-label"><small>Organization:</small></label>
                                <asp:TextBox ID="txtOrg" runat="server" CssClass="form-control" placeholder="Organization" Font-Size="small"></asp:TextBox>
                            </div>

                        </div>

                        <div class="row">
                            <div class="col-4">
                                <label for="txtEventTime1" class="form-label"><small>Start Time:</small></label>
                                <asp:TextBox ID="txtEventTime1" runat="server" CssClass="form-control" placeholder="Start Time" Font-Size="small" ReadOnly="true"></asp:TextBox>
                            </div>
                            <div class="col-4">
                                <label for="txtEndTime1" class="form-label"><small>End Time:</small></label>
                                <asp:TextBox ID="txtEndTime1" runat="server" CssClass="form-control" placeholder="End Time" Font-Size="small" ReadOnly="true"></asp:TextBox>
                            </div>
                            <div class="col-4">
                                <label for="txtEventDate1" class="form-label"><small>Event Date:</small></label>
                                <asp:TextBox ID="txtEventDate1" runat="server" CssClass="form-control" placeholder="Event Date" Font-Size="small" ReadOnly="true"></asp:TextBox>
                            </div>
                        </div>

                        <hr>
                        <!-- Formal Request Section -->
                        <h6 class="mt-3">Formal Request</h6>

                        <div class="mb-3">
                            <label for="txtFaculty" class="form-label"><small>Faculty Request:</small></label>
                            <asp:TextBox ID="txtFaculty" runat="server" CssClass="form-control" placeholder="Faculty Request" Font-Size="small" ReadOnly="true"></asp:TextBox>
                        </div>

                        <div class="row">
                            <div class="col-4">
                                <input type="checkbox" class="btn-check" id="cbPodiumView" name="cbPodiumView" autocomplete="off" disabled />
                                <label class="btn btn-outline-primary btnWidth " for="cbPodiumView">Podium</label>
                            </div>
                            <div class="col-4">
                                <input type="checkbox" class="btn-check" id="cbChairsView" name="cbChairsView" autocomplete="off" disabled />
                                <label class="btn btn-outline-primary btnWidth " for="cbChairsView">Chairs</label>
                            </div>
                            <div class="col-4">
                                <input type="checkbox" class="btn-check" id="cbCurtainsView" name="cbCurtainsView" autocomplete="off" disabled />
                                <label class="btn btn-outline-primary btnWidth" for="cbCurtainsView">Curtains</label>
                            </div>
                        </div>

                        <div class="row mt-3">
                            <div class="col-6">
                                <input type="checkbox" class="btn-check" id="cbSoundSystemView" name="cbSoundSystemView" autocomplete="off" disabled />
                                <label class="btn btn-outline-primary btnWidth" for="cbSoundSystemView">Sound System</label>
                            </div>
                            <div class="col-6">
                                <input type="checkbox" class="btn-check" id="cbScreenAndProjectorView" name="cbScreenAndProjectorView" autocomplete="off" disabled />
                                <label class="btn btn-outline-primary btnWidth" for="cbScreenAndProjectorView">Screen and Projector</label>
                            </div>
                        </div>


                        <div class="modal-footer d-flex justify-content-between mt-3" style="border-top: none;">
                            <asp:Button ID="Button2" runat="server" Text="Close" CssClass="btn btn-secondary cancelBtn" UseSubmitBehavior="false" />
                            <asp:Button ID="btnProceedToPending" runat="server" Text="Proceed" CssClass="btn btn-primary confirmBtn" Width="150px" OnClick="btnProceedToPending_Click" />
                        </div>
                    </div>
                </div>
            </div>
        </div>

<!-- Modal for Editing Event -->
<div class="modal fade" id="eventModalEdit" tabindex="-1" aria-labelledby="eventModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content" style="border-radius: 20px; border: none; padding: 20px;">
            <!-- Modal Header -->
            <div class="modal-header text-center" style="border-bottom: none;">
                <h5 class="modal-title w-100" id="eventModalLabelEdit"><strong>Edit Event</strong></h5>
                <!-- <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button> -->
            </div>

            <!-- Modal Body -->
            <div class="modal-body">
                <!-- Event Details Section -->
                <h6>Event Details</h6>
                <div class="mb-3">
                    <asp:TextBox ID="txtTitleEdit" runat="server" CssClass="form-control" placeholder="Title of Activity" Font-Size="small" ></asp:TextBox>
                </div>

                <div class="row">
                    <div class="col-6">
                        <asp:DropDownList ID="ddlVenueEdit" runat="server" CssClass="form-select" Font-Size="small" >
                            <asp:ListItem Value="-">Select Venue</asp:ListItem>
                            <asp:ListItem>Multi-purpose Hall</asp:ListItem>
                            <asp:ListItem>Star Building Rooms</asp:ListItem>
                            <asp:ListItem>Main Building Rooms</asp:ListItem>
                            <asp:ListItem>Ground Floor</asp:ListItem>
                            <asp:ListItem>HRM Building</asp:ListItem>
                        </asp:DropDownList>
                    </div>
                    <div class="col-6">
                        <asp:TextBox ID="txtOrgNameEdit" runat="server" CssClass="form-control" placeholder="Organization" Font-Size="small"></asp:TextBox>
                    </div>
                </div>

                <div class="row">
                    <div class="col-4">
                        <label for="txtEventTimeEdit" class="form-label"><small>Start Time:</small></label>
                        <asp:TextBox ID="txtEventTimeEdit" runat="server" TextMode="Time" CssClass="form-control" placeholder="Start Time" Font-Size="small" ></asp:TextBox>
                    </div>
                    <div class="col-4">
                        <label for="txtEndTimeEdit" class="form-label"><small>End Time:</small></label>
                        <asp:TextBox ID="txtEndTimeEdit" runat="server" TextMode="Time" CssClass="form-control" placeholder="End Time" Font-Size="small" ></asp:TextBox>
                    </div>
                    <div class="col-4">
                        <label for="txtEventDateEdit" class="form-label"><small>Event Date:</small></label>
                        <asp:TextBox ID="txtEventDateEdit" runat="server" TextMode="Date" CssClass="form-control" placeholder="Event Date" Font-Size="small" ></asp:TextBox>
                    </div>
                </div>

                <!-- Formal Request Section -->
                <h6 class="mt-3">Formal Request</h6>

                <div class="mb-3">
                    <asp:DropDownList ID="ddlFacultyEdit" runat="server" CssClass="form-select" Font-Size="small">
                        <asp:ListItem Value="-">Faculty Member Appearance</asp:ListItem>
                        <asp:ListItem>Dean</asp:ListItem>
                        <asp:ListItem>Program Coordinator</asp:ListItem>
                        <asp:ListItem>OSAS</asp:ListItem>
                        <asp:ListItem>Org Adviser</asp:ListItem>
                    </asp:DropDownList>
                </div>

                <div class="row">
                    <div class="col-4">
                        <input type="checkbox" class="btn-check" id="cbPodiumEdit" name="cbPodiumEdit" autocomplete="off">
                        <label class="btn btn-outline-primary btnWidth" for="cbPodiumEdit">Podium</label>
                    </div>
                    <div class="col-4">
                        <input type="checkbox" class="btn-check" id="cbChairsEdit" name="cbChairsEdit" autocomplete="off">
                        <label class="btn btn-outline-primary btnWidth" for="cbChairsEdit">Chairs</label>
                    </div>
                    <div class="col-4">
                        <input type="checkbox" class="btn-check" id="cbCurtainsEdit" name="cbCurtainsEdit" autocomplete="off">
                        <label class="btn btn-outline-primary btnWidth" for="cbCurtainsEdit">Curtains</label>
                    </div>
                </div>

                <div class="row mt-3">
                    <div class="col-6">
                        <input type="checkbox" class="btn-check" id="cbSoundSystemEdit" name="cbSoundSystemEdit" autocomplete="off">
                        <label class="btn btn-outline-primary btnWidth" for="cbSoundSystemEdit">Sound System</label>
                    </div>
                    <div class="col-6">
                        <input type="checkbox" class="btn-check" id="cbScreenAndProjectorEdit" name="cbScreenAndProjectorEdit" autocomplete="off">
                        <label class="btn btn-outline-primary " for="cbScreenAndProjectorEdit">Screen and Projector</label>
                    </div>
                </div>

                <div class="modal-footer d-flex justify-content-between mt-3" style="border-top: none;">
                    <asp:Button ID="Button1" runat="server" Text="Cancel" CssClass="btn btn-secondary cancelBtn" UseSubmitBehavior="false" />
                    <asp:Button ID="btnUpdateEventDetails" runat="server" Text="Update" CssClass="btn btn-primary confirmBtn" OnClick="btnUpdateEventDetails_Click"/>
                </div>
            </div>
        </div>
    </div>
</div>



 <!-- Modal for APPROVED VIEW DETAILS Event -->
<div class="modal fade" id="eventModalViewDetailsApproved" tabindex="-1" aria-labelledby="eventModalLabelApproved" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content" style="border-radius: 20px; border: none; padding: 20px;">
            <!-- Modal Header -->
            <div class="modal-header text-center" style="border-bottom: none;">
                <h5 class="modal-title w-100" id="eventModalLabelApproved"><strong>Event Details</strong></h5>
                <!-- <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button> -->
            </div>

            <div class="modal-body">
                <!-- Event Details Section -->
                <h6>Event Details</h6>
                <div class="mb-3">
                    <asp:TextBox ID="txtTitleApproved" runat="server" CssClass="form-control" placeholder="Title of Activity" Font-Size="small" ReadOnly="true"></asp:TextBox>
                </div>

                <div class="row">
                    <div class="col-6">
                        <label for="txtVenueApproved" class="form-label"><small>Venue:</small></label>
                        <asp:TextBox ID="txtVenueApproved" runat="server" CssClass="form-control" placeholder="Venue" Font-Size="small" ReadOnly="true"></asp:TextBox>
                    </div>
                    <div class="col-6">
                        <label for="txtOrgNameApproved" class="form-label"><small>Organization:</small></label>
                        <asp:TextBox ID="txtOrgNameApproved" runat="server" CssClass="form-control" placeholder="Organization" Font-Size="small"></asp:TextBox>
                    </div>

                </div>

                <div class="row">
                    <div class="col-4">
                        <label for="txtEventTimeApproved" class="form-label"><small>Start Time:</small></label>
                        <asp:TextBox ID="txtEventTimeApproved" runat="server" CssClass="form-control" placeholder="Start Time" Font-Size="small" ReadOnly="true"></asp:TextBox>
                    </div>
                    <div class="col-4">
                        <label for="txtEndTimeApproved" class="form-label"><small>End Time:</small></label>
                        <asp:TextBox ID="txtEndTimeApproved" runat="server" CssClass="form-control" placeholder="End Time" Font-Size="small" ReadOnly="true"></asp:TextBox>
                    </div>
                    <div class="col-4">
                        <label for="txtEventDateApproved" class="form-label"><small>Event Date:</small></label>
                        <asp:TextBox ID="txtEventDateApproved" runat="server" CssClass="form-control" placeholder="Event Date" Font-Size="small" ReadOnly="true"></asp:TextBox>
                    </div>
                </div>

                <hr>
                <!-- Formal Request Section -->
                <h6 class="mt-3">Formal Request</h6>

                <div class="mb-3">
                    <label for="txtFacultyApproved" class="form-label"><small>Faculty Request:</small></label>
                    <asp:TextBox ID="txtFacultyApproved" runat="server" CssClass="form-control" placeholder="Faculty Request" Font-Size="small" ReadOnly="true"></asp:TextBox>
                </div>

                <div class="row">
                    <div class="col-4">
                        <input type="checkbox" class="btn-check" id="cbPodiumViewApproved" name="cbPodiumViewApproved" autocomplete="off" disabled />
                        <label class="btn btn-outline-primary btnWidth " for="cbPodiumViewApproved">Podium</label>
                    </div>
                    <div class="col-4">
                        <input type="checkbox" class="btn-check" id="cbChairsViewApproved" name="cbChairsViewApproved" autocomplete="off" disabled />
                        <label class="btn btn-outline-primary btnWidth " for="cbChairsViewApproved">Chairs</label>
                    </div>
                    <div class="col-4">
                        <input type="checkbox" class="btn-check" id="cbCurtainsViewApproved" name="cbCurtainsViewApproved" autocomplete="off" disabled />
                        <label class="btn btn-outline-primary btnWidth" for="cbCurtainsViewApproved">Curtains</label>
                    </div>
                </div>

                <div class="row mt-3">
                    <div class="col-6">
                        <input type="checkbox" class="btn-check" id="cbSoundSystemViewApproved" name="cbSoundSystemViewApproved" autocomplete="off" disabled />
                        <label class="btn btn-outline-primary btnWidth" for="cbSoundSystemViewApproved">Sound System</label>
                    </div>
                    <div class="col-6">
                        <input type="checkbox" class="btn-check" id="cbScreenAndProjectorViewApproved" name="cbScreenAndProjectorViewApproved" autocomplete="off" disabled />
                        <label class="btn btn-outline-primary btnWidth" for="cbScreenAndProjectorViewApproved">Screen and Projector</label>
                    </div>
                </div>


                <div class="modal-footer mt-3 text-center justify-content-center" style="border-top: none;">
                    <asp:Button ID="btnCloseMySchedButtonViewApproved" runat="server" Text="Close" CssClass="btn btn-secondary cancelBtn" UseSubmitBehavior="false" OnClientClick="closeModalViewApproved(); return false;" />
                </div>


            </div>
        </div>
    </div>
</div>



  <!-- Modal for VIEW DETAILS REVDISAP Event -->
 <div class="modal fade" id="eventModalViewDetailsRevDis" tabindex="-1" aria-labelledby="eventModalLabel" aria-hidden="true">
     <div class="modal-dialog modal-dialog-centered">
         <div class="modal-content" style="border-radius: 20px; border: none; padding: 20px;">
             <!-- Modal Header -->
             <div class="modal-header text-center" style="border-bottom: none;">
                 <h5 class="modal-title w-100" id="eventModalLabelRevDis"><strong>Event Details</strong></h5>
                 <!-- <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button> -->
             </div>

             <div class="modal-body">
                 <!-- Event Details Section -->
                 <h6>Event Details</h6>
                 <div class="mb-3">
                     <asp:TextBox ID="txtTitleRevDis" runat="server" CssClass="form-control" placeholder="Title of Activity" Font-Size="small" ReadOnly="true"></asp:TextBox>
                 </div>

                 <div class="row">
                     <div class="col-6">
                         <label for="txtVenueRevDis" class="form-label"><small>Venue:</small></label>
                         <asp:TextBox ID="txtVenueRevDis" runat="server" CssClass="form-control" placeholder="Venue" Font-Size="small" ReadOnly="true"></asp:TextBox>
                     </div>
                     <div class="col-6">
                         <label for="txtOrgNameRevDis" class="form-label"><small>Organization:</small></label>
                         <asp:TextBox ID="txtOrgNameRevDis" runat="server" CssClass="form-control" placeholder="Organization" Font-Size="small"></asp:TextBox>
                     </div>

                 </div>

                 <div class="row">
                     <div class="col-4">
                         <label for="txtEventTimeRevDis" class="form-label"><small>Start Time:</small></label>
                         <asp:TextBox ID="txtEventTimeRevDis" runat="server" CssClass="form-control" placeholder="Start Time" Font-Size="small" ReadOnly="true"></asp:TextBox>
                     </div>
                     <div class="col-4">
                         <label for="txtEndTimeRevDis" class="form-label"><small>End Time:</small></label>
                         <asp:TextBox ID="txtEndTimeRevDis" runat="server" CssClass="form-control" placeholder="End Time" Font-Size="small" ReadOnly="true"></asp:TextBox>
                     </div>
                     <div class="col-4">
                         <label for="txtEventDateRevDis" class="form-label"><small>Event Date:</small></label>
                         <asp:TextBox ID="txtEventDateRevDis" runat="server" CssClass="form-control" placeholder="Event Date" Font-Size="small" ReadOnly="true"></asp:TextBox>
                     </div>
                 </div>

                 <hr>
                 <!-- Formal Request Section -->
                 <h6 class="mt-3">Formal Request</h6>

                 <div class="mb-3">
                     <label for="txtFacultyRevDis" class="form-label"><small>Faculty Request:</small></label>
                     <asp:TextBox ID="txtFacultyRevDis" runat="server" CssClass="form-control" placeholder="Faculty Request" Font-Size="small" ReadOnly="true"></asp:TextBox>
                 </div>

                 <div class="row">
                     <div class="col-4">
                         <input type="checkbox" class="btn-check" id="cbPodiumViewRevDis" name="cbPodiumViewRevDis" autocomplete="off" disabled />
                         <label class="btn btn-outline-primary btnWidth " for="cbPodiumViewRevDis">Podium</label>
                     </div>
                     <div class="col-4">
                         <input type="checkbox" class="btn-check" id="cbChairsViewRevDis" name="cbChairsViewRevDis" autocomplete="off" disabled />
                         <label class="btn btn-outline-primary btnWidth " for="cbChairsViewRevDis">Chairs</label>
                     </div>
                     <div class="col-4">
                         <input type="checkbox" class="btn-check" id="cbCurtainsViewRevDis" name="cbCurtainsViewRevDis" autocomplete="off" disabled />
                         <label class="btn btn-outline-primary btnWidth" for="cbCurtainsViewRevDis">Curtains</label>
                     </div>
                 </div>

                 <div class="row mt-3">
                     <div class="col-6">
                         <input type="checkbox" class="btn-check" id="cbSoundSystemViewRevDis" name="cbSoundSystemViewRevDis" autocomplete="off" disabled />
                         <label class="btn btn-outline-primary btnWidth" for="cbSoundSystemViewRevDis">Sound System</label>
                     </div>
                     <div class="col-6">
                         <input type="checkbox" class="btn-check" id="cbScreenAndProjectorViewRevDis" name="cbScreenAndProjectorViewRevDis" autocomplete="off" disabled />
                         <label class="btn btn-outline-primary btnWidth" for="cbScreenAndProjectorViewRevDis">Screen and Projector</label>
                     </div>
                 </div>


                 <div class="modal-footer d-flex justify-content-center gap-2 mt-3" style="border-top: none;">
                     <asp:Button ID="btnRevision" runat="server" Text="Revision" CssClass="btn btn-primary" Width="115px" OnClick="btnRevision_Click" />
                     <asp:Button ID="btnDisap" runat="server" Text="Disapproved" CssClass="btn btn-danger" Width="115px" OnClick="btnDisap_Click" />
                     <asp:Button ID="btnApprove" runat="server" Text="Approved" CssClass="btn btn-primary confirmBtn" Width="115px" OnClick="btnApprove_Click" />
                 </div>
                 <div class="d-flex justify-content-center">
                     <asp:Button ID="btnCancelRevDis" runat="server" Text="Close" CssClass="btn btn-secondary" Width="120px" UseSubmitBehavior="false" />
                 </div>

             </div>
         </div>
     </div>
 </div>

         <%--MODAL CONFIRM--%>
        <div class="modal-overlay" id="modalConf" style="display: none;">
            <div class="custom-message">
                <div class="message-header">
                    <h6>Confirm</h6>
                </div>
                <hr class="divider" />
                <div class="message-content">
                    <h6><asp:Label ID="lblConfirmMessage" runat="server" Text="Are you sure you want to proceed?"></asp:Label></h6>
                </div>
                <br>
                <div class="message-footer">
                    <asp:Button ID="Button3" runat="server" Text="Cancel" CssClass="form-control btnCustomCancelMsg"/>
                    <asp:Button ID="btnConfirmAskDelete" runat="server" Text="Confirm" CssClass=" form-control btnAccConf" OnClick="btnConfirmAskDelete_Click"/>
                </div>
            </div>
        </div>
        <asp:HiddenField ID="hfConfirmationButtonClicked" runat="server" />

         <!-- Success Modal -->
        <div class="modal-overlay" id="modalSuccess" style="display: none;">
            <div class="custom-message">
                <i class="fa fa-info-circle info-icon"></i>
                <div class="message-content" style="margin-top: 40px;">
                    <h6>Action Registered<br>
                        Successfully!</h6>
                </div>

                <br>
                <div class="message-footer">
                    <asp:Button ID="btnContinue" runat="server" Text="Confirm" CssClass=" form-control btnAccConf" OnClick="btnContinue_Click" />
                </div>
            </div>
        </div>

        <asp:HiddenField ID="hfRefNo" runat="server" />
<script>

    function openCommentModal(referenceNo) {
        document.getElementById("hfCommentRefNo").value = referenceNo;
        $("#commentModal").modal("show");
    }

    function closeModalViewApproved() {
        $("#eventModalViewDetailsApproved").modal("hide");
    }

    function openEventModalApproved(referenceNo, organization, venue, timeStart, timeEnd) {

        // Extract numeric part from Reference No.
        let numericRefNo = referenceNo.replace(/\D/g, "").replace(/^0+/, "");

        document.getElementById('<%= hfRefNo.ClientID %>').value = numericRefNo;


        // Show modal
        $("#eventModalViewDetailsApproved").modal("show");

        fetchData(numericRefNo);

        function fetchData(numericRefNo) {
            // Pass the parameter in the query string
            fetch(`ProposalTracking.aspx?numericRefNo=${numericRefNo}`)
                .then(response => response.json())  // Parse response as JSON
                .then(data => {
                    if (data.Error) {
                        console.error(data.Error);
                        return;
                    }

                // Update the corresponding fields with data from the server
                document.getElementById('<%= txtTitleApproved.ClientID %>').value = data.Title;
                document.getElementById('<%= txtVenueApproved.ClientID %>').value = data.Venue;
                document.getElementById('<%= txtOrgNameApproved.ClientID %>').value = data.Organization;
                document.getElementById('<%= txtEventDateApproved.ClientID %>').value = data.EventDate;
                document.getElementById('<%= txtEventTimeApproved.ClientID %>').value = data.TimeStart;
                document.getElementById('<%= txtEndTimeApproved.ClientID %>').value = data.TimeEnd;
                document.getElementById('<%= txtFacultyApproved.ClientID %>').value = data.FacultyAppearance;

                // Set checkboxes based on values from the database (1 = checked, 0 = unchecked)
                    document.getElementById('cbPodiumViewApproved').checked = data.Podium === "1";
                    document.getElementById('cbChairsViewApproved').checked = data.Chairs === "1";
                    document.getElementById('cbCurtainsViewApproved').checked = data.Curtains === "1";
                    document.getElementById('cbSoundSystemViewApproved').checked = data.SoundSystem === "1";
                    document.getElementById('cbScreenAndProjectorViewApproved').checked = data.ScreenAndProjector === "1";
            })
            .catch(error => {
                console.error('Error fetching data:', error);
            });
    }
}

    function openEventModalRevDis(referenceNo, organization, venue, timeStart, timeEnd) {

        // Extract numeric part from Reference No.
        let numericRefNo = referenceNo.replace(/\D/g, "").replace(/^0+/, "");

        document.getElementById('<%= hfRefNo.ClientID %>').value = numericRefNo;


        // Show modal
        $("#eventModalViewDetailsRevDis").modal("show");

        fetchData(numericRefNo);

        function fetchData(numericRefNo) {
            // Pass the parameter in the query string
            fetch(`ProposalTracking.aspx?numericRefNo=${numericRefNo}`)
                .then(response => response.json())  // Parse response as JSON
                .then(data => {
                    if (data.Error) {
                        console.error(data.Error);
                        return;
                    }

                    // Update the corresponding fields with data from the server
                    document.getElementById('<%= txtTitleRevDis.ClientID %>').value = data.Title;
                    document.getElementById('<%= txtVenueRevDis.ClientID %>').value = data.Venue;
                    document.getElementById('<%= txtOrgNameRevDis.ClientID %>').value = data.Organization;
                    document.getElementById('<%= txtEventDateRevDis.ClientID %>').value = data.EventDate;
                    document.getElementById('<%= txtEventTimeRevDis.ClientID %>').value = data.TimeStart;
                    document.getElementById('<%= txtEndTimeRevDis.ClientID %>').value = data.TimeEnd;
                    document.getElementById('<%= txtFacultyRevDis.ClientID %>').value = data.FacultyAppearance;

                    // Set checkboxes based on values from the database (1 = checked, 0 = unchecked)
                    document.getElementById('cbPodiumViewRevDis').checked = data.Podium === "1";
                    document.getElementById('cbChairsViewRevDis').checked = data.Chairs === "1";
                    document.getElementById('cbCurtainsViewRevDis').checked = data.Curtains === "1";
                    document.getElementById('cbSoundSystemViewRevDis').checked = data.SoundSystem === "1";
                    document.getElementById('cbScreenAndProjectorRevDis').checked = data.ScreenAndProjector === "1";
                })
                .catch(error => {
                    console.error('Error fetching data:', error);
                });
        }
    }


    function openEditModal(referenceNo) {

        // Extract numeric part from Reference No.
        let numericRefNo = referenceNo.replace(/\D/g, "").replace(/^0+/, "");

        document.getElementById('<%= hfRefNo.ClientID %>').value = numericRefNo; 

        $("#eventModalEdit").modal("show");

        fetchData(numericRefNo);

        function fetchData(numericRefNo) {
            // Pass the parameter in the query string
            fetch(`ProposalTracking.aspx?numericRefNo=${numericRefNo}`)
                .then(response => response.json())  // Parse response as JSON
                .then(data => {
                    if (data.Error) {
                        console.error(data.Error);
                        return;
                    }


            // Update the corresponding fields with data from the server

            document.getElementById('<%= txtTitleEdit.ClientID %>').value = data.Title;
            var ddlVenue = document.getElementById('<%= ddlVenueEdit.ClientID %>');

            if (ddlVenue) {
                var found = false;

                for (var i = 0; i < ddlVenue.options.length; i++) {
                    if (ddlVenue.options[i].value.trim() === data.Venue.trim()) {
                        ddlVenue.selectedIndex = i;
                        found = true;
                        break;
                    }
                }
            }

            document.getElementById('<%= txtOrgNameEdit.ClientID %>').value = data.Organization;
            document.getElementById('<%= txtEventDateEdit.ClientID %>').value = data.EventDate;
            document.getElementById('<%= txtEventTimeEdit.ClientID %>').value = data.TimeStart;
            document.getElementById('<%= txtEndTimeEdit.ClientID %>').value = data.TimeEnd;

            var ddlFaculty = document.getElementById('<%= ddlFacultyEdit.ClientID %>');

            if (ddlFaculty) {
                var found = false;

                for (var i = 0; i < ddlFaculty.options.length; i++) {
                    if (ddlFaculty.options[i].value.trim() === data.FacultyAppearance.trim()) {
                        ddlFaculty.selectedIndex = i;
                        found = true;
                        break;
                    }
                }
            }

            // Set checkboxes based on values from the database (1 = checked, 0 = unchecked)
            document.getElementById('cbPodiumEdit').checked = data.Podium === "1";
            document.getElementById('cbChairsEdit').checked = data.Chairs === "1";
            document.getElementById('cbCurtainsEdit').checked = data.Curtains === "1";
            document.getElementById('cbSoundSystemEdit').checked = data.SoundSystem === "1";
            document.getElementById('cbScreenAndProjectorEdit').checked = data.ScreenAndProjector === "1";
        })
        .catch(error => {
            console.error('Error fetching data:', error);
        });
    }


    }

        function openEventModal(referenceNo, organization, venue, timeStart, timeEnd) {
            // Extract numeric part from Reference No.
            let numericRefNo = referenceNo.replace(/\D/g, "").replace(/^0+/, "");

            document.getElementById('<%= hfRefNo.ClientID %>').value = numericRefNo; 

            // Show modal
            $("#eventModalViewDetails").modal("show");

            fetchData(numericRefNo);

            function fetchData(numericRefNo) {
                // Pass the parameter in the query string
                fetch(`ProposalTracking.aspx?numericRefNo=${numericRefNo}`)
                    .then(response => response.json())  // Parse response as JSON
                    .then(data => {
                        if (data.Error) {
                            console.error(data.Error);
                            return;
                        }

                // Update the corresponding fields with data from the server
                document.getElementById('<%= txtTitleView.ClientID %>').value = data.Title;
                document.getElementById('<%= txtVenue.ClientID %>').value = data.Venue;
                document.getElementById('<%= txtOrg.ClientID %>').value = data.Organization;
                document.getElementById('<%= txtEventDate1.ClientID %>').value = data.EventDate;
                document.getElementById('<%= txtEventTime1.ClientID %>').value = data.TimeStart;
                document.getElementById('<%= txtEndTime1.ClientID %>').value = data.TimeEnd;
                document.getElementById('<%= txtFaculty.ClientID %>').value = data.FacultyAppearance;

                // Set checkboxes based on values from the database (1 = checked, 0 = unchecked)
                document.getElementById('cbPodiumView').checked = data.Podium === "1";
                document.getElementById('cbChairsView').checked = data.Chairs === "1";
                document.getElementById('cbCurtainsView').checked = data.Curtains === "1";
                document.getElementById('cbSoundSystemView').checked = data.SoundSystem === "1";
                document.getElementById('cbScreenAndProjectorView').checked = data.ScreenAndProjector === "1";
            })
                    .catch(error => {
                        console.error('Error fetching data:', error);
                    });
            }
        }



    function openCommentModalPending(referenceNo) {
        document.getElementById("hfCommentRefNoPending").value = referenceNo;
        $("#commentModalPending").modal("show");
    }

    function openEditModalPending(referenceNo) {
        document.getElementById("editModalRefNoPending").textContent = referenceNo;
        $("#editModalPending").modal("show");
    }


    function openAddEvent() {
        $("#eventModal").modal("show");
    }

    function showModalSuccess() {
        const modal = document.getElementById('modalSuccess');
        modal.style.display = 'flex';
    }
    function showModalConf() {
        const modal = document.getElementById('modalConf');
        modal.style.display = 'flex';
    }

</script>


    </form>
</body>
</html>
