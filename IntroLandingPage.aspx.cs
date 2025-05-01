using System;

namespace SOMS
{
    public partial class IntroLandingPage : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {


        }
        protected void btnEventCalendar_Click(object sender, EventArgs e)
        {
            // Handle Event Calendar button click
            Response.Redirect("LandingPage.aspx");
        }

        protected void btnProposalTracking_Click(object sender, EventArgs e)
        {
            // Handle Proposal Tracking button click
            Response.Redirect("LandingPage.aspx");
        }

        protected void btnSettings_Click(object sender, EventArgs e)
        {
            // Handle Settings button click
            Response.Redirect("LandingPage.aspx");
        }

        protected void btnLogIn_Click(object sender, EventArgs e)
        {
            Response.Redirect("LogIn.aspx");
        }

        protected void btnLeft_Click(object sender, EventArgs e)
        {
            Response.Redirect("LandingPage.aspx");
        }

        protected void btnRight_Click(object sender, EventArgs e)
        {
            Response.Redirect("LandingPage.aspx");
        }
    }
}