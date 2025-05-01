<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ManageGroups.aspx.cs" Inherits="SOMS.ManageGroups" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Manage Groups</title>

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
<link href="Content/ManageGroups.css" rel="stylesheet" />

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
                                <asp:LinkButton ID="btnGroups" runat="server" CssClass="nav-button" Text="Groups" />
                            </li>
                            <li class="nav-item me-5">
                                <asp:LinkButton ID="btnSettings" runat="server" CssClass="nav-button" OnClick="btnSettings_Click">
                        <i class="fas fa-cog" style="font-weight: bold; color: white; font-size: 25px;"></i>
                                </asp:LinkButton>
                            </li>

                            <%--                <li class="nav-item me-5">
                    <asp:LinkButton ID="btnLogIn" runat="server" CssClass="nav-button-login" Text="Log-In" OnClick="btnLogIn_Click"/>
                </li>--%>
                        </ul>
                    </div>
                </div>
            </nav>


            <div class="container">
                <div class="header">
                    <a href="AdminSettings.aspx"><span>< Settings</span></a>
                </div>
                <asp:Label ID="lblAdminAccessKey" runat="server" Text="Admin Access Key: " Font-Size="14"></asp:Label>
                <hr />

                <%--<div class="container">--%>
                <div class="row">
                    <!-- Organization Table -->
                    <div class="col-md-6">
                        <div class="d-flex justify-content-between align-items-center">
                            <h3 class="mb-0">Organization</h3>
                            <asp:Button ID="btnAddNewOrganization" Text="Add Organization" runat="server" CssClass="btn btn-success btn-sm" OnClick="btnAddNewOrganization_Click"/>
                        </div>

                        <asp:GridView ID="gvOrganization" runat="server" class="table table-bordered" AutoGenerateColumns="False" DataKeyNames="id" DataSourceID="OMS" OnRowCommand="gvOrganization_RowCommand">
                            <Columns>
                                <asp:BoundField DataField="id" HeaderText="ID" SortExpression="id" InsertVisible="False" ReadOnly="True" />
                                <asp:BoundField DataField="Organization" HeaderText="ORGANIZATION" SortExpression="Organization" />
                                <asp:BoundField DataField="AccessKey" HeaderText="ACCESS KEY" SortExpression="AccessKey" />

                                <asp:TemplateField HeaderText="Actions">
                                    <ItemTemplate>
                                        <asp:Label ID="organizationLabel" runat="server" Text='<%# Eval("Organization") %>' Visible="false" />
                                        <!-- Edit Button -->
                                        <asp:LinkButton ID="btnEdit" runat="server" CommandName="EditName" CommandArgument='<%# Container.DataItemIndex %>' CssClass="btn btn-primary btn-sm">
                                            <i class="fas fa-edit" style="color: white;"></i>
                                        </asp:LinkButton>

                                        <!-- Delete Button -->
                                        <asp:LinkButton ID="btnDelete" runat="server" CommandName="DeleteName" CommandArgument='<%# Container.DataItemIndex %>' CssClass="btn btn-danger btn-sm">
                                            <i class="fas fa-trash" style="color: white;"></i>
                                        </asp:LinkButton>
                                    </ItemTemplate>
                                </asp:TemplateField>

                            </Columns>
                        </asp:GridView>
                        <asp:SqlDataSource ID="OMS" runat="server" ConnectionString="<%$ ConnectionStrings:OMSDBConnectionString %>" SelectCommand="SELECT [id], [Organization], [AccessKey] FROM [TB_Organization] WHERE Authority = 'SO' AND Status = 1"></asp:SqlDataSource>
                    </div>


                    <!-- Faculty Members Table -->
                    <div class="col-md-6">
                        <div class="d-flex justify-content-between align-items-center">
                            <h3 class="mb-0">Faculty Members</h3>
                            <asp:Button ID="btnAddNewFaculty" Text="Add Faculty" runat="server" CssClass="btn btn-success btn-sm" OnClick="btnAddNewFaculty_Click"/>
                        </div>
                        <asp:GridView ID="gvFacultyMembers" runat="server" class="table table-bordered" AutoGenerateColumns="False" DataKeyNames="id" DataSourceID="OMSFaculty" OnRowCommand="gvFacultyMembers_RowCommand">
                            <Columns>
                                <asp:BoundField DataField="id" HeaderText="ID" SortExpression="id" InsertVisible="False" ReadOnly="True" />
                                <asp:BoundField DataField="Organization" HeaderText="ROLE" SortExpression="Organization" />
                                <asp:BoundField DataField="AccessKey" HeaderText="ACCES KEY" SortExpression="AccessKey" />

                                <asp:TemplateField HeaderText="Actions">
                                    <ItemTemplate>
                                        <asp:Label ID="lblRole" runat="server" Text='<%# Eval("Organization") %>' Visible="false" />
                                        <!-- Edit Button -->
                                        <asp:LinkButton ID="btnEditRole" runat="server" CommandName="EditRole" CommandArgument='<%# Container.DataItemIndex %>' CssClass="btn btn-primary btn-sm">
                                                <i class="fas fa-edit" style="color: white;"></i>
                                        </asp:LinkButton>

                                        <!-- Delete Button -->
                                        <asp:LinkButton ID="btnDeleteRole" runat="server" CommandName="DeleteRole" CommandArgument='<%# Container.DataItemIndex %>' CssClass="btn btn-danger btn-sm">
                                                <i class="fas fa-trash" style="color: white;"></i>
                                        </asp:LinkButton>
                                    </ItemTemplate>
                                </asp:TemplateField>

                            </Columns>
                        </asp:GridView>
                        <asp:SqlDataSource ID="OMSFaculty" runat="server" ConnectionString="<%$ ConnectionStrings:OMSDBConnectionString2 %>" ProviderName="<%$ ConnectionStrings:OMSDBConnectionString2.ProviderName %>" SelectCommand="SELECT [id], [Organization], [AccessKey] FROM [TB_Organization] WHERE [Authority] = 'FAC' AND Status = 1"></asp:SqlDataSource>
                    </div>
                </div>
                <%--</div>--%>
            </div>


        <%--MODAL EDIT ORGANIZATION--%>
        <div class="modal-overlay" id="modalEdit" style="display: none">
            <div class="custom-message1">
                <div class="message-header" style="margin-bottom: 30px;">
                    <h5>Edit Organization Name</h5>
                </div>
                <div class="message-content">
                    <asp:Label ID="lblOldGroupName" runat="server" Text="Group Name" Font-Size="medium" CssClass="lblAlign"></asp:Label>
                    <asp:TextBox ID="txtOldName" runat="server" CssClass="form-control txtCustomAccess" ReadOnly="true" BackColor="White"></asp:TextBox><br>
                    <asp:Label ID="Label2" runat="server" Text="New Group Name" Font-Size="medium" CssClass="lblAlign"></asp:Label>
                    <asp:TextBox ID="txtNewName" runat="server" CssClass="form-control txtCustomAccess"></asp:TextBox><br>
<%--                    <asp:Label ID="Label5" runat="server" Text="Admin Access Key" Font-Size="medium" CssClass="lblAlign"></asp:Label>
                    <asp:TextBox ID="txtAdminAccessKey" runat="server" CssClass="form-control txtCustomAccess"></asp:TextBox><br>--%>
                    <asp:Label ID="lblMessage" runat="server" Text="Please input new organization name!" Font-Size="medium" ForeColor="Crimson" Visible="false"></asp:Label>
                </div>
                <br>
                <div class="message-footer">
                    <asp:Button ID="btnCancel" runat="server" Text="Cancel" CssClass="form-control btnCustomCancel"/>
                    <asp:Button ID="btnConfirmEdit" runat="server" Text="Confirm" CssClass=" form-control btnAccConf" OnClick="btnConfirmEdit_Click" />
                </div>
            </div>
        </div>
        <asp:HiddenField ID="hfID" runat="server" />

        <%--MODAL CONFIRM DELETION--%>
        <div class="modal-overlay" id="modalDeleteConf" style="display: none;">
            <div class="custom-message">
                <div class="message-header">
                    <h6>Delete this group?</h6>
                </div>
                <hr class="divider" />
                <div class="message-content">
                    <h6>This action cannot be<br>
                        undone. Proceed?</h6>
                </div>
                <br>
                <div class="message-footer">
                    <asp:Button ID="Button1" runat="server" Text="Cancel" CssClass="form-control btnCustomCancelMsg"/>
                    <asp:Button ID="btnConfirmAskDelete" runat="server" Text="Confirm" CssClass=" form-control btnAccConf" OnClick="btnConfirmAskDelete_Click"/>
                </div>
            </div>
        </div>

        <%--MODAL NEW ORGANIZATION--%>
        <div class="modal-overlay" id="modalNewOrganization" style="display: none">
            <div class="custom-message1">
                <div class="message-header" style="margin-bottom: 30px;">
                    <h5>Create New Organization</h5>
                </div>
                <div class="message-content">
                    <asp:Label ID="Label1" runat="server" Text="New Organization Name" Font-Size="medium" CssClass="lblAlign"></asp:Label>
                    <asp:TextBox ID="txtNewOrgName" runat="server" CssClass="form-control txtCustomAccess"></asp:TextBox><br>
                    <asp:Label ID="Label3" runat="server" Text="Generate Organization Access Key" Font-Size="medium" CssClass="lblAlign"></asp:Label>
                    <div class="input-group mb-3">
                        <asp:TextBox ID="txtNewOrgAccessKey" runat="server" CssClass="form-control txtCustomAccess input-group-text" Style="background-color: white; font-size: small; min-width: 250px;"></asp:TextBox>
                        <asp:Button runat="server" ID="btnGenerateEncryptedKey" OnClick="btnGenerateEncryptedKey_Click" CssClass="form-control btnAccConf" Text="Generate Encrypted Key" Style="font-size: x-small; border-bottom-right-radius: 20px; border-top-right-radius: 20px;" />
                    </div>
                    <asp:Label ID="lblMessageSave" runat="server" Text="Please save the Generated Access Key!" Font-Size="medium" ForeColor="Crimson" Visible="false"></asp:Label>
                </div>
                <br>
                <div class="message-footer">
                    <asp:Button ID="btnCancelNewOrgCreation" runat="server" Text="Cancel" CssClass="form-control btnCustomCancel" OnClick="btnCancelNewOrgCreation_Click"/>
                    <asp:Button ID="btnConfirmNewOrgCreation" runat="server" Text="Confirm" CssClass=" form-control btnAccConf" OnClick="btnConfirmNewOrgCreation_Click"/>
                </div>
            </div>
        </div>

         <%--MODAL EDIT ROLE--%>
        <div class="modal-overlay" id="modalEditRole" style="display: none">
            <div class="custom-message1">
                <div class="message-header" style="margin-bottom: 30px;">
                    <h5>Edit Role Name</h5>
                </div>
                <div class="message-content">
                    <asp:Label ID="Label4" runat="server" Text="Role Name" Font-Size="medium" CssClass="lblAlign"></asp:Label>
                    <asp:TextBox ID="txtOldRoleName" runat="server" CssClass="form-control txtCustomAccess" ReadOnly="true" BackColor="White"></asp:TextBox><br>
                    <asp:Label ID="Label5" runat="server" Text="New Role Name" Font-Size="medium" CssClass="lblAlign"></asp:Label>
                    <asp:TextBox ID="txtNewRoleName" runat="server" CssClass="form-control txtCustomAccess"></asp:TextBox><br>
                    <asp:Label ID="lblMessageRole" runat="server" Text="Please input new role name!" Font-Size="medium" ForeColor="Crimson" Visible="false"></asp:Label>
                </div>
                <br>
                <div class="message-footer">
                    <asp:Button ID="btnCancelEditRole" runat="server" Text="Cancel" CssClass="form-control btnCustomCancel"/>
                    <asp:Button ID="btnConfirmEditRole" runat="server" Text="Confirm" CssClass=" form-control btnAccConf" OnClick="btnConfirmEditRole_Click" />
                </div>
            </div>
        </div>

         <%--MODAL NEW ROLE--%>
        <div class="modal-overlay" id="modalNewRole" style="display: none">
            <div class="custom-message1">
                <div class="message-header" style="margin-bottom: 30px;">
                    <h5>Create New Role</h5>
                </div>
                <div class="message-content">
                    <asp:Label ID="Label6" runat="server" Text="New Role Name" Font-Size="medium" CssClass="lblAlign"></asp:Label>
                    <asp:TextBox ID="txtCreateNewRole" runat="server" CssClass="form-control txtCustomAccess"></asp:TextBox><br>
                    <asp:Label ID="Label7" runat="server" Text="Generate Role Access Key" Font-Size="medium" CssClass="lblAlign"></asp:Label>
                    <div class="input-group mb-3">
                        <asp:TextBox ID="txtNewAccessKeyRole" runat="server" CssClass="form-control txtCustomAccess input-group-text" Style="background-color: white; font-size: small; min-width: 250px;"></asp:TextBox>
                        <asp:Button runat="server" ID="btnGenerateEncryptedKeyRole" OnClick="btnGenerateEncryptedKeyRole_Click" CssClass="form-control btnAccConf" Text="Generate Encrypted Key" Style="font-size: x-small; border-bottom-right-radius: 20px; border-top-right-radius: 20px;" />
                    </div>
                    <asp:Label ID="lblMessageRoleCreate" runat="server" Text="Please save the Generated Access Key!" Font-Size="medium" ForeColor="Crimson" Visible="false"></asp:Label>
                </div>
                <br>
                <div class="message-footer">
                    <asp:Button ID="btnCancelNewRole" runat="server" Text="Cancel" CssClass="form-control btnCustomCancel" OnClick="btnCancelNewRole_Click"/>
                    <asp:Button ID="btnConfirmNewRole" runat="server" Text="Confirm" CssClass=" form-control btnAccConf" OnClick="btnConfirmNewRole_Click" />
                </div>
            </div>
        </div>


        <%--MODAL SUCCESS--%>
        <div class="modal-overlay" id="modalSuccess" style="display: none;">
            <div class="custom-message">
                <i class="fa fa-info-circle info-icon"></i>
                <div class="message-content" style="margin-top: 40px;">
                    <h6>Action Registered<br>
                        Successfully!</h6>
                </div>

                <br>
                <div class="message-footer">
                    <asp:Button ID="btnClose" runat="server" Text="Confirm" CssClass=" form-control btnAccConf" />
                </div>
            </div>
        </div>


        <script>
            function showModalEdit() {
                const modal = document.getElementById('modalEdit');
                modal.style.display = 'flex';
            }
            function showModalEditRole() {
                const modal = document.getElementById('modalEditRole');
                modal.style.display = 'flex';
            }
            function showModalSuccess() {
                const modal = document.getElementById('modalSuccess');
                modal.style.display = 'flex';
            }

            function showModalNewOrganization() {
                const modal = document.getElementById('modalNewOrganization');
                modal.style.display = 'flex';
            }
            function showModalNewRole() {
                const modal = document.getElementById('modalNewRole');
                modal.style.display = 'flex';
            }

            function showModalConfDel() {
                const modal = document.getElementById('modalDeleteConf');
                modal.style.display = 'flex';
            }
        </script>

    </form>
</body>
</html>
