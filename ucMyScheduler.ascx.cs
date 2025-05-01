using System;

namespace SOMS
{
    public partial class usMySchedulre : System.Web.UI.UserControl
    {
        public string TimeStart { get; set; }
        public string TimeEnd { get; set; }
        public string Organization { get; set; }
        public string Venue { get; set; }
        public string ReferenceNo { get; set; }

        protected void Page_Load(object sender, EventArgs e)
        {
            // Setting the values dynamically
            if (!IsPostBack)
            {
                lblTimeRange.Text = TimeEnd;

                DateTime eventDate = DateTime.Parse(TimeStart); // Assuming TimeStart is a valid date string
                lblMonthDay.Text = eventDate.ToString("MMM dd").ToUpper(); // Format like "FEB 01"
                lblOrganization.Text = Organization;
                lblVenue.Text = Venue;
                lblReferenceNo.Text = ReferenceNo;
            }
        }

        protected void lnkEvent_Click(object sender, EventArgs e)
        {

        }
    }
}