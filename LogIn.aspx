<%@ Page Title="Log In" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="LogIn.aspx.cs" Inherits="SOMS.LogIn" %>

<asp:Content ID="Content1" ContentPlaceHolderID="NavContentAdmin" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" />

<link href="Content/login.css" rel="stylesheet" />

<style>
    body {
        position: relative;
        margin: 0;
        padding: 0;
        height: 100vh;
        background-image: url('Images/login.png');
        background-size: cover;
        background-position: center center;
        background-attachment: fixed;
        display: flex;
        justify-content: center;
        align-items: center;
        font-family: 'Century Gothic', sans-serif;
    }

    body::before {
        content: '';
        position: absolute;
        top: 0;
        left: 0;
        right: 0;
        bottom: 0;
        background-image: url('Images/login.png');
        background-size: cover;
        background-position: center center;
        background-attachment: fixed;
        filter: blur(10px);
        background-color: rgba(0, 0, 0, 0.5);
        z-index: -1;
    }
</style>

<div class="container">
    <div class="login-wrapper">
        <div class="logo">
            <img src="Images/cvsulogo.png" />
        </div>
        
        <div class="login-form">
            <br>
            <h2>LOG IN</h2>
            <br>
            <div>
                <asp:Label ID="lblUsername" runat="server" Text="Email Address" CssClass="label"></asp:Label>
                <asp:TextBox ID="txtUsername" runat="server" CssClass="form-control" Placeholder="Enter your email" AutoPostBack="False"></asp:TextBox>
            </div>
            <div>
                <asp:Label ID="lblPassword" runat="server" Text="Password" CssClass="label"></asp:Label>
                <asp:TextBox ID="txtPassword" runat="server" CssClass="form-control" TextMode="Password" Placeholder="Enter your password" AutoPostBack="False"></asp:TextBox>
            </div>
            <div class="button-container">
                <asp:Button ID="btnForgetPass" runat="server" Text="Forgot Password?" CssClass="form-control btn-forgot" OnClick="btnForgetPass_Click"/>
                <asp:Button ID="btnSignIn" runat="server" Text="Log In" CssClass="form-control btn-signin" OnClick="btnSignIn_Click"/>
            </div>

            <div class="button-container">
                <span style="font-size: 13px">Don't Have an account yet?</span><asp:Button ID="btnSignUp" runat="server" Text="Sign Up" CssClass="form-control btn-signup" OnClick="btnSignUp_Click"/>
            </div>
        </div>
    </div>
</div>

</asp:Content>

