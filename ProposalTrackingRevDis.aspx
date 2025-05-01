<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ProposalTrackingRevDis.aspx.cs" Inherits="SOMS.ProposalTrackingRevDis" %>
<%@ Register Src="ucAdminRevDis.ascx" TagPrefix="uc" TagName="MyEventControlAdminRevDis" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>RevDis Proposals</title>

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
                            <asp:LinkButton ID="btnGroups" runat="server" CssClass="nav-button" Text="Groups" OnClick="btnGroups_Click"/>
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
                    <span>&lt; REVISION | DISAPPROVED PROPOSALS</span>
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

            <div class="card mt-3" style="background-color: #f8cbad; border: 1px solid #ccc; border-radius: 25px; min-height: 700px">

                <div class="card-body">

                    <div class="event-control-container">
                        <asp:Repeater ID="rptReceived" runat="server">
                            <ItemTemplate>
                                <div class="event-control">
                                    <uc:MyEventControlAdminRevDis runat="server"
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
        function showModalConf1() {
            const modal = document.getElementById('modalConf');
            modal.style.display = 'flex';
        }
        function showModalSuccess() {
            const modal = document.getElementById('modalSuccess');
            modal.style.display = 'flex';
        }
    </script>

        
    </form>
</body>
</html>


