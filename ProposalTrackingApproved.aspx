<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ProposalTrackingApproved.aspx.cs" Inherits="SOMS.ProposalTrackingApproved" %>
<%@ Register Src="ucAdminApproved.ascx" TagPrefix="uc" TagName="MyEventControlAdminApproved" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Approved Proposals</title>

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css"/>

    <!-- jQuery -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

        <!-- Bootstrap -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"/>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    
    <link href="Content/ProposalTracking.css" rel="stylesheet" />
    <link href="Content/ManageGroups.css" rel="stylesheet" />


    <style>
    .event-control {
        width: 100%;
    }

    .event-control-container {
        display: flex;
        flex-wrap: wrap;
        gap: 20px;
    }

    .event-control-container .event-control {
        flex: 0 0 23%;
        box-sizing: border-box;
    }

  
    @media (max-width: 768px) {
        .event-control-container .event-control {
            flex: 0 0 48%;
        }
    }

    @media (max-width: 480px) {
        .event-control-container .event-control {
            flex: 0 0 100%;
        }
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
                            <asp:LinkButton ID="btnEventCalendar" runat="server" CssClass="nav-button" Text="Event Calendar" Onclick="btnEventCalendar_Click" />
                        </li>
                        <li class="nav-item me-5">
                            <asp:LinkButton ID="btnProposalTracking" runat="server" CssClass="nav-button" Text="Proposal Tracking" OnClick="btnProposalTracking_Click" />
                        </li>
                        <li class="nav-item me-5">
                            <asp:LinkButton ID="btnGroups" runat="server" CssClass="nav-button" Text="Groups" OnClick="btnGroups_Click" />
                        </li>
                        <li class="nav-item me-5">
                            <asp:LinkButton ID="btnSettings" runat="server" CssClass="nav-button" Onclick="btnSettings_Click">
                                <i class="fas fa-cog" style="font-weight: bold; color: white; font-size: 25px;"></i>
                            </asp:LinkButton>
                        </li>

                    </ul>
                </div>
            </div>
        </nav>

        <div class="container">

            <div class="header d-flex flex-column flex-md-row justify-content-between align-items-center">
                <a href="<%= GetProposalTrackingUrl() %>" class="mb-2 mb-md-0">
                    <span>&lt; APPROVED PROPOSALS</span>
                </a>
                <div class="d-flex gap-2" style="width: 400px;">
                    <div class="input-group" style="width: 100%;">
                        <span class="input-group-text" style="border-right: none; background-color: transparent; border-top-left-radius: 25px; border-bottom-left-radius: 25px; padding-left: 20px;">
                            <i class="fa fa-search" style="font-weight: bold; color: black; font-size: 20px;"></i>
                        </span>
                        <asp:TextBox ID="txtSearch" runat="server" CssClass="form-control" placeholder="Reference Number..."
                            Style="border-left: none; height: 50px; border-top-right-radius: 25px; border-bottom-right-radius: 25px;" AutoPostBack="true" OnTextChanged="txtSearch_TextChanged">
                        </asp:TextBox>
                    </div>
                </div>
            </div>

            <div class="card mt-3" style="background-color: #c5e0b4; border: 1px solid #ccc; border-radius: 25px; min-height: 700px">

                <div class="card-body">

                    <div class="event-control-container">
                        <asp:Repeater ID="rptReceived" runat="server">
                            <ItemTemplate>
                                <div class="event-control">
                                    <uc:MyEventControlAdminApproved runat="server"
                                        TimeStart='<%# Eval("TimeStart") %>'
                                        TimeEnd='<%# Eval("TimeEnd") %>'
                                        Organization='<%# Eval("Organization") %>'
                                        Venue='<%# Eval("Venue") %>'
                                        ReferenceNo='<%# Eval("ReferenceNo") %>' />
                                </div>
                            </ItemTemplate>
                        </asp:Repeater>
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
    </form>

    <script>

        function openEventModal(referenceNo, organization, venue, timeStart, timeEnd) {

            let numericRefNo = referenceNo.replace(/\D/g, "").replace(/^0+/, "");

            document.getElementById('<%= hfRefNo.ClientID %>').value = numericRefNo;

            console.log(numericRefNo);

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


        function openEditModal(referenceNo) {

            // Extract numeric part from Reference No.
            let numericRefNo = referenceNo.replace(/\D/g, "").replace(/^0+/, "");

            document.getElementById('<%= hfRefNo.ClientID %>').value = numericRefNo;

         //$("#eventModalEdit").modal("show");

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

        function showModalSuccess() {
            const modal = document.getElementById('modalSuccess');
            modal.style.display = 'flex';
        }
    </script>


</body>
</html>


