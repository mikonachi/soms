<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="ucMyScheduler.ascx.cs" Inherits="SOMS.usMySchedulre" %>

<link href="Content/UserControl.css" rel="stylesheet" />

<!-- Clickable Event Container -->
<div class="event-container" style="cursor: pointer; background-color: white" onclick="openEventModal('<%= ReferenceNo %>', '<%= Organization %>', '<%= Venue %>', '<%= TimeStart %>', '<%= TimeEnd %>')">
    <!-- Left side: Time and Date -->
    <div class="left-side">
        <div class="time-range">
            <asp:Label ID="lblTimeRange" runat="server" Text=""></asp:Label>
        </div>
        <div class="month-day">
            <asp:Label ID="lblMonthDay" runat="server" Text=""></asp:Label>
        </div>
    </div>

    <!-- Right side: Organization, Venue, and Reference No. -->
    <div class="right-side">
        <div class="organization" style="display: flex; align-items: center;">
            <asp:Label ID="lblOrganization" runat="server" Text="" Style="margin-right: 5px;"></asp:Label>
            <!-- Edit Button -->
            <%--<asp:LinkButton ID="btnEditOrg" runat="server" OnClientClick="openEditModal(); event.stopPropagation(); return false;">
                <i class="fa fa-edit" style="color: black; font-size:25px"></i>
            </asp:LinkButton>--%>
        </div>
        <div class="venue">
            <asp:Label ID="lblVenue" runat="server" Text=""></asp:Label>
        </div>
        <div class="reference-no">
            <asp:Label ID="lblReferenceNo" runat="server" Text=""></asp:Label>
        </div>
    </div>
</div>
