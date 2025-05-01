<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="ucAdminReceived.ascx.cs" Inherits="SOMS.usAdmin" %>

<link href="Content/UserControl.css" rel="stylesheet" />
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" />

<!-- Clickable Event Container -->
<div class="event-container" style="cursor: pointer; background-color: white" 
onclick='<%# "openEventModal(\"" + Eval("ReferenceNo") + "\", \"" + Eval("Organization") + "\", \"" + Eval("Venue") + "\", \"" + Convert.ToDateTime(Eval("TimeStart")).ToString("yyyy-MM-dd") + "\", \"" + Eval("TimeEnd") + "\")" %>'>

    <!-- Left side: Time and Date -->
    <div class="left-side">
        <div class="time-range">
            <asp:Label ID="lblTimeRange" runat="server" Text=""></asp:Label>
        </div>
        <div class="month-day">
            <asp:Label ID="lblMonthDay" runat="server" Text=""></asp:Label>
        </div>
        <!-- Comment Dots Button -->
        <div class="month-button">
            <asp:LinkButton ID="btnComment" runat="server"
                OnClientClick='<%# "event.stopPropagation(); openCommentModal(\"" + Eval("ReferenceNo") + "\"); return false;" %>'>
        <i class="fa-regular fa-comment-dots" style="color: black; font-size:25px"></i>
            </asp:LinkButton>
        </div>

    </div>

    <!-- Right side: Organization, Venue, and Reference No. -->
    <div class="right-side">
        <div class="organization">
            <asp:Label ID="lblOrganization" runat="server" Text="" Style="margin-right: 5px;"></asp:Label>
            <asp:LinkButton ID="btnEditOrg" runat="server"
                OnClientClick='<%# "event.stopPropagation(); openEditModal(\"" + Eval("ReferenceNo") + "\"); return false;" %>'>
                <i class="fa fa-edit" style="color: black; font-size:25px"></i>
            </asp:LinkButton>

        </div>
        <div class="venue">
            <asp:Label ID="lblVenue" runat="server" Text=""></asp:Label>
        </div>
        <div class="reference-no">
            <asp:Label ID="lblReferenceNo" runat="server" Text=""></asp:Label>
        </div>
    </div>
</div>
