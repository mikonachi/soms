<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="FacultyCalendar.aspx.cs" Inherits="SOMS.FacultyCalendar" %>
<%@ Register Src="ucMyScheduler.ascx" TagPrefix="uc" TagName="MyEventControl" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Event Calendar</title>

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

   

    <script>

        $(document).ready(function () {

           var eventsData = JSON.parse('<%= EventsJson %>');

           var currentYear = new Date().getFullYear();

           var eventDates = {};

           var holidayData = [
               { title: 'New Year’s Day', month: 1, day: 1, isHoliday: true },
               { title: 'Chinese New Year', month: 1, day: 25, isHoliday: true },
               { title: 'EDSA Revolution', month: 2, day: 25, isHoliday: true },
               { title: 'Day of Valor', month: 4, day: 9, isHoliday: true },
               { title: 'Maundy Thursday', month: 4, day: 17, isHoliday: true },
               { title: 'Good Friday', month: 4, day: 18, isHoliday: true },
               { title: 'Black Saturday', month: 4, day: 19, isHoliday: true },
               { title: 'Labor Day', month: 5, day: 1, isHoliday: true },
               { title: 'Eid al-Fitr', month: 5, day: 25, isHoliday: true },
               { title: 'Independence Day', month: 6, day: 12, isHoliday: true },
               { title: 'Eid al-Adha', month: 7, day: 18, isHoliday: true },
               { title: 'Ninoy Aquino Day', month: 8, day: 21, isHoliday: true },
               { title: 'National Heroes Day', month: 8, day: 31, isHoliday: true },
               { title: 'All Saints’ Day', month: 11, day: 1, isHoliday: true },
               { title: 'All Souls’ Day', month: 11, day: 2, isHoliday: true },
               { title: 'Bonifacio Day', month: 11, day: 30, isHoliday: true },
               { title: 'Immaculate Conception', month: 12, day: 8, isHoliday: true },
               { title: 'Christmas Eve', month: 12, day: 24, isHoliday: true },
               { title: 'Christmas Day', month: 12, day: 25, isHoliday: true },
               { title: 'Rizal Day', month: 12, day: 30, isHoliday: true },
               { title: 'New Year’s Eve', month: 12, day: 31, isHoliday: true }
           ];


           holidayData.forEach(function (holiday) {
               var holidayDate = moment(`${currentYear}-${holiday.month}-${holiday.day}`).format("YYYY-MM-DD");
               eventsData.push({
                   title: holiday.title,
                   start: holidayDate,
                   isHoliday: true
               });
           });

           eventsData.forEach(function (event) {
               var eventDate = moment(event.start).format("YYYY-MM-DD");
               if (!eventDates[eventDate]) {
                   eventDates[eventDate] = [];
               }
               eventDates[eventDate].push(event);
           });

           $('#calendar').fullCalendar({
               editable: true,
               selectable: true,
               defaultView: 'month',
               header: {
                   right: 'prev,next today',
                   left: 'title'
               },
               showNonCurrentDates: false,
               events: eventsData,
               eventRender: function (event, element) {
                   var descriptionHtml = event.description ? event.description.replace(/\n/g, "<br>") : "";

                   if (event.isHoliday) {
                       element.find('.fc-title').html(event.title + '<br>' + descriptionHtml);
                       element.addClass('fc-holiday');
                       element.attr('title', event.title);
                   } else {
                       element.find('.fc-title').html(event.title + '<br>' + descriptionHtml);
                   }
               },
               select: function (start) {
                   var selectedDate = moment(start).format("YYYY-MM-DD");

                   if (eventDates[selectedDate] && eventDates[selectedDate].some(event => event.isHoliday)) {
                       var holidayTitle = eventDates[selectedDate].find(event => event.isHoliday).title;
                       showCustomHolidayAlert(holidayTitle);
                       return;
                   }

                   if (moment(start).day() === 0) {
                       showCustomSundayAlert();
                       return;
                   }


                   if (eventDates[selectedDate] && eventDates[selectedDate].length > 0) {
                       showCustomEventExistsAlert();
                       return;
                   }

                   $("#txtEventDate").val(moment(start).format("YYYY-MM-DD"));
                   $("#eventModal").modal("show");
               }
           });

           function showCustomHolidayAlert(holidayTitle) {
               var customAlertHtml = `
                    <div class="custom-alert">
                        <p><strong>Holiday:</strong> ${holidayTitle}</p>
                        <p>You cannot book an event on holiday.</p>
                        <button class="close-alert">Close</button>
                    </div>
                `;

               $('body').append(customAlertHtml);

               $('.custom-alert').css({
                   'position': 'fixed',
                   'top': '50%',
                   'left': '50%',
                   'transform': 'translate(-50%, -50%)',
                   'background-color': '#fff',
                   'border': '1px solid #ccc',
                   'border-radius': '15px',
                   'padding': '20px',
                   'box-shadow': '0 4px 8px rgba(0, 0, 0, 0.1)',
                   'z-index': '9999',
                   'text-align': 'center'
               });

               $('.custom-alert button').css({
                   'margin-top': '10px',
                   'padding': '5px 10px',
                   'background-color': '#70ad47',
                   'color': '#fff',
                   'border': 'none',
                   'cursor': 'pointer',
                   'border-radius': '15px',
                   'width': '100px'

               });

               $('.close-alert').click(function () {
                   $('.custom-alert').remove();
               });
           }

           function showCustomSundayAlert() {
               var customAlertHtml = `
                    <div class="custom-alert">
                        <p><strong>Sunday:</strong> You can't book an event on Sunday.</p>
                        <button class="close-alert">Close</button>
                    </div>
                `;

               $('body').append(customAlertHtml);

               $('.custom-alert').css({
                   'position': 'fixed',
                   'top': '50%',
                   'left': '50%',
                   'transform': 'translate(-50%, -50%)',
                   'background-color': '#fff',
                   'border': '1px solid #ccc',
                   'padding': '20px',
                   'box-shadow': '0 4px 8px rgba(0, 0, 0, 0.1)',
                   'z-index': '9999',
                   'border-radius': '15px',
                   'text-align': 'center'

               });

               $('.custom-alert button').css({
                   'margin-top': '10px',
                   'padding': '5px 10px',
                   'background-color': '#70ad47',
                   'color': '#fff',
                   'border': 'none',
                   'border-radius': '15px',
                   'cursor': 'pointer'
               });

               // Close the custom alert when the button is clicked
               $('.close-alert').click(function () {
                   $('.custom-alert').remove();
               });
           }

           // Function to show a custom alert for existing events
           function showCustomEventExistsAlert() {
               var customAlertHtml = `
                <div class="custom-alert">
                    <p><strong>This date is not Available.</strong> <br> <br>  An event were already booked on this date.</p>
                    <button class="close-alert">Close</button>
                </div>
            `;

               // Append the alert to the body
               $('body').append(customAlertHtml);

               // Style the custom alert
               $('.custom-alert').css({
                   'position': 'fixed',
                   'top': '50%',
                   'left': '50%',
                   'transform': 'translate(-50%, -50%)',
                   'background-color': '#fff',
                   'border': '1px solid #ccc',
                   'padding': '20px',
                   'box-shadow': '0 4px 8px rgba(0, 0, 0, 0.1)',
                   'z-index': '9999',
                   'border-radius': '15px',
                   'text-align': 'center'
               });

               $('.custom-alert button').css({
                   'margin-top': '10px',
                   'padding': '5px 10px',
                   'background-color': '#70ad47',
                   'color': '#fff',
                   'border': 'none',
                   'border-radius': '15px',
                   'cursor': 'pointer'
               });

               // Close the custom alert when the button is clicked
               $('.close-alert').click(function () {
                   $('.custom-alert').remove();
               });
           }
       });


       
    </script>

    <link href="Content/Calendar.css" rel="stylesheet" />

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
                            <asp:LinkButton ID="btnSettings" runat="server" CssClass="nav-button" OnClick="btnSettings_Click">
                        <i class="fas fa-cog" style="font-weight: bold; color: white; font-size: 25px;"></i>
                            </asp:LinkButton>
                        </li>
                    </ul>
                </div>
            </div>
        </nav>


        <!-- CALENDAR -->
        <div class="row" style="margin-left: 70px; margin-right: 0">
            <div class="col-12 col-md-3">
                <div class="container" style="margin-top: 30px;">
                    <div class="card">
                        <div class="card-header" style="background-color: #f16565; color: white; font-size: 20px; font-weight: bold; text-align: center;">
                            MY SCHEDULE
                        </div>
                        <div class="card-body">
                            <asp:Repeater ID="rptEventControls" runat="server">
                                <ItemTemplate>
                                    <div class="event-control">
                                        <uc:MyEventControl runat="server"
                                            TimeStart='<%# Eval("TimeStart") %>'
                                            TimeEnd='<%# Eval("TimeEnd") %>'
                                            Organization='<%# Eval("Organization") %>'
                                            Venue='<%# Eval("Venue") %>'
                                            ReferenceNo='<%# Eval("ReferenceNo") %>' />
                                    </div>
                                </ItemTemplate>
                            </asp:Repeater>

                            <div class="text-center">
                                <asp:LinkButton ID="btnSeeMoreSched" runat="server" CssClass="btn btn-primary confirmBtn" OnClick="btnSeeMoreSched_Click"><i class="fas fa-eye"></i> SEE MORE
                                </asp:LinkButton>
                            </div>
                        </div>
                    </div>

                    <div>
                        <br>
                        <h1>Pending Requests:</h1>
                        <asp:Label Text="#0000" runat="server" id="txtLblCountPendingRequests" Font-Size="34px"/>

                    </div>
                </div>
            </div>

            <div class="col-12 col-md-9">
                <div class="container" style="margin-top: 30px;">
                    <div id="calendar"></div>
                </div>
            </div>
        </div>

        
        <!-- Modal for Registering New Event -->
        <div class="modal fade" id="eventModal" tabindex="-1" aria-labelledby="eventModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content" style="border-radius: 20px; border: none; padding: 20px;">
                    <!-- Modal Header -->
                    <div class="modal-header text-center" style="border-bottom: none;">
                        <h5 class="modal-title w-100" id="eventModalLabelRegister"><strong>Register Event</strong></h5>
                        <!-- <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button> -->
                    </div>

                    <!-- Modal Body -->
                    <div class="modal-body">
                        <!-- Event Details Section -->
                        <h6>Event Details</h6>
                        <div class="mb-3">
                            <asp:TextBox ID="txtTitle" runat="server" CssClass="form-control" placeholder="Title of Activity" Font-Size="small" required></asp:TextBox>
                        </div>

                        <div class="row">
                            <div class="col-6">
                                <asp:DropDownList ID="ddlVenue" runat="server" CssClass="form-select" Font-Size="small" required>
                                    <asp:ListItem Value="---">Select Venue</asp:ListItem>
                                    <asp:ListItem>Multi-purpose Hall</asp:ListItem>
                                    <asp:ListItem>Star Building Rooms</asp:ListItem>
                                    <asp:ListItem>Main Building Rooms</asp:ListItem>
                                    <asp:ListItem>Ground Floor</asp:ListItem>
                                    <asp:ListItem>HRM Building</asp:ListItem>
                                </asp:DropDownList>
                            </div>
                            <div class="col-6">
                                <asp:TextBox ID="txtOrgName" runat="server" CssClass="form-control" placeholder="Organization" ReadOnly="true" Font-Size="small"></asp:TextBox>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-4">
                                <label for="txtEventTime" class="form-label"><small>Start Time:</small></label>
                                <asp:TextBox ID="txtEventTime" runat="server" TextMode="Time" CssClass="form-control" placeholder="Start Time" Font-Size="small" required></asp:TextBox>
                            </div>
                            <div class="col-4">
                                <label for="txtEndTime" class="form-label"><small>End Time:</small></label>
                                <asp:TextBox ID="txtEndTime" runat="server" TextMode="Time" CssClass="form-control" placeholder="End Time" Font-Size="small" required></asp:TextBox>
                            </div>
                            <div class="col-4">
                                <label for="txtEventDate" class="form-label"><small>Event Date:</small></label>
                                <asp:TextBox ID="txtEventDate" runat="server" TextMode="Date" CssClass="form-control" placeholder="Event Date" Font-Size="small" required></asp:TextBox>
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
                                <input type="checkbox" class="btn-check" id="cbPodium" name="cbPodium" autocomplete="off">
                                <label class="btn btn-outline-primary" for="cbPodium">Podium</label>
                            </div>
                            <div class="col-4">
                                <input type="checkbox" class="btn-check" id="cbChairs" name="cbChairs" autocomplete="off">
                                <label class="btn btn-outline-primary" for="cbChairs">Chairs</label>
                            </div>
                            <div class="col-4">
                                <input type="checkbox" class="btn-check" id="cbCurtains" name="cbCurtains" autocomplete="off">
                                <label class="btn btn-outline-primary" for="cbCurtains">Curtains</label>
                            </div>
                        </div>

                        <div class="row mt-3">
                            <div class="col-6">
                                <input type="checkbox" class="btn-check" id="cbSoundSystem" name="cbSoundSystem" autocomplete="off">
                                <label class="btn btn-outline-primary" for="cbSoundSystem">Sound System</label>
                            </div>
                            <div class="col-6">
                                <input type="checkbox" class="btn-check" id="cbScreenAndProjector" name="cbScreenAndProjector" autocomplete="off">
                                <label class="btn btn-outline-primary" for="cbScreenAndProjector">Screen and Projector</label>
                            </div>
                        </div>

                        <div class="modal-footer d-flex justify-content-between mt-3" style="border-top: none;">
                            <asp:Button ID="btnCancelEdit" runat="server" Text="Cancel" CssClass="btn btn-secondary cancelBtn" UseSubmitBehavior="false" OnClick="btnCancelEdit_Click" />
                            <asp:Button ID="btnCheck" runat="server" Text="Save Event" CssClass="btn btn-primary confirmBtn" OnClick="btnSaveEvent_Click" />
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <asp:HiddenField ID="hfVenue" runat="server" />
        <asp:HiddenField ID="hfDatetime" runat="server" />
        <asp:HiddenField ID="hfFaculty" runat="server" />
        <asp:HiddenField ID="hfSoundSystem" runat="server" />
        <asp:HiddenField ID="hfChair" runat="server" />
        <asp:HiddenField ID="hfCurtains" runat="server" />
        <asp:HiddenField ID="hfProjector" runat="server" />
        <asp:HiddenField ID="hfPodium" runat="server" />

        
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


                 <div class="modal-footer mt-3 text-center justify-content-center" style="border-top: none;">
                     <asp:Button ID="btnCloseMySchedButtonView" runat="server" Text="Close" CssClass="btn btn-secondary cancelBtn" UseSubmitBehavior="false" OnClientClick="closeModalView(); return false;" />
                 </div>


             </div>
         </div>
     </div>
 </div>

<!-- JavaScript to Handle Modal Opening -->
<script>
   
    function closeModalView() {
        $("#eventModalViewDetails").modal("hide");
    }

    function openEventModal(referenceNo, organization, venue, timeStart, timeEnd) {

        // Extract numeric part from Reference No.
        let numericRefNo = referenceNo.replace(/\D/g, "").replace(/^0+/, "");

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
</script>

    </form>
</body>
</html>

