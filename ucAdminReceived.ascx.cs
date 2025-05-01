using System;

namespace SOMS
{
    public partial class usAdmin : System.Web.UI.UserControl
    {
        public string TimeStart { get; set; }
        public string TimeEnd { get; set; }
        public string Organization { get; set; }
        public string Venue { get; set; }
        public string ReferenceNo { get; set; }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                lblTimeRange.Text = TimeEnd;

                DateTime eventDate;
                if (DateTime.TryParse(TimeStart, out eventDate))
                {
                    lblMonthDay.Text = eventDate.ToString("MMM dd").ToUpper();
                }
                else
                {
                    lblMonthDay.Text = "N/A";
                }

                lblOrganization.Text = Organization;
                lblVenue.Text = Venue;
                lblReferenceNo.Text = ReferenceNo;
            }
        }


    }
}