using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Drawing;
using System.Text;
using System.Web.UI.WebControls;

namespace SOMS
{
    public partial class SOProposalTracker : System.Web.UI.Page
    {
        private static readonly Color ActiveReceived = ColorTranslator.FromHtml("#ffe699");
        private static readonly Color ActivePending = ColorTranslator.FromHtml("#9dc3e6");
        private static readonly Color ActiveFinalizing = ColorTranslator.FromHtml("#ed7d31");
        private static readonly Color ActiveApproved = ColorTranslator.FromHtml("#a9d18e");
        private static readonly Color InactiveColor = ColorTranslator.FromHtml("#e7e6e6");
        private static readonly Color DisapprovedColor = ColorTranslator.FromHtml("#f0f0f0");

        string connStr = ConfigurationManager.ConnectionStrings["OMSDB"].ConnectionString;


        private readonly List<string> statusOrder = new List<string> { "Received", "Pending", "Finalizing", "Approved" };

        protected void Page_Load(object sender, EventArgs e)
        {
            // Ensure user is authenticated before proceeding
            if (Session["UserAuthenticated"] != null && (bool)Session["UserAuthenticated"])
            {
                if (!IsPostBack)
                {
                    LoadDropdownItems();
                    ProcessOngoing("Approved");
                }
            }
            else
            {
                Response.Redirect("LandingPage.aspx");
            }

        }


        public void loadComments()
        {
            string connStr = ConfigurationManager.ConnectionStrings["OMSDB"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();
                using (SqlCommand cmd = new SqlCommand(@"SELECT ec.Comment, ta.FullName, ec.CommentFrom
                                            FROM EventComments ec
                                            INNER JOIN TB_Authority ta ON ec.CommentBy = ta.Email
                                            WHERE ec.eventReferenceNo = @refNo", conn))
                {
                    cmd.Parameters.AddWithValue("@refNo", ddlOptions.SelectedValue);

                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        StringBuilder output = new StringBuilder();

                        while (reader.Read())
                        {
                            string Comment = reader["Comment"].ToString();
                            string FullName = reader["FullName"].ToString();
                            string CommentFrom = reader["CommentFrom"].ToString();

                            string formattedText = $"{CommentFrom} by {FullName}\nComment: {Comment}\n\n";

                            output.Append(formattedText);
                        }


                        txtChat.Text = output.ToString();
                    }
                }
            }


        }
        private void LoadDropdownItems()
        {

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = "SELECT EventID, Title FROM Events WHERE Email = @email";
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@email", Session["email"].ToString()); //use session email

                try
                {
                    conn.Open();
                    SqlDataReader reader = cmd.ExecuteReader();

                    ddlOptions.DataSource = reader;
                    ddlOptions.DataTextField = "Title";
                    ddlOptions.DataValueField = "EventID";
                    ddlOptions.DataBind();


                    ddlOptions.Items.Insert(0, new ListItem("Viewing: The Sent Proposal", ""));
                    ddlOptions.Items[0].Attributes["disabled"] = "disabled";
                }
                catch (Exception ex)
                {
                    Response.Write("Error: " + ex.Message);
                }
            }
        }

        private void ProcessOngoing(string statusOngoing)
        {
            int currentIndex = statusOrder.IndexOf(statusOngoing);
            if (currentIndex == -1) return;

            lblReceived.BackColor = (currentIndex >= 0) ? ActiveReceived : InactiveColor;
            lblPending.BackColor = (currentIndex >= 1) ? ActivePending : InactiveColor;
            lblFinalizing.BackColor = (currentIndex >= 2) ? ActiveFinalizing : InactiveColor;
            lblApproved.BackColor = (currentIndex >= 3) ? ActiveApproved : InactiveColor;
        }

        private void ProcessDisapproval(string status)
        {
            ResetDisapprovalStatus();
            int startIndex = statusOrder.IndexOf(status);
            if (startIndex == -1) return;

            for (int i = startIndex; i < statusOrder.Count; i++)
            {
                DisapproveStatus(statusOrder[i]);
            }
        }

        private void DisapproveStatus(string status)
        {
            var statusLabels = new Dictionary<string, Tuple<Label, Label>>
            {
                { "Received", new Tuple<Label, Label>(lblReceived, lblReceivedDisap) },
                { "Pending", new Tuple<Label, Label>(lblPending, lblPendingDisap) },
                { "Finalizing", new Tuple<Label, Label>(lblFinalizing, lblFinalizingDisap) },
                { "Approved", new Tuple<Label, Label>(lblApproved, lblApprovedDisap) }
            };

            if (statusLabels.ContainsKey(status))
            {
                SetDisapprovedState(statusLabels[status].Item1, statusLabels[status].Item2);
            }
        }

        private void SetDisapprovedState(Label targetLabel, Label targetDisap)
        {
            targetLabel.BackColor = DisapprovedColor;
            targetDisap.Visible = true;
        }

        private void ResetActiveStatuses(string status)
        {
            int startIndex = statusOrder.IndexOf(status);
            if (startIndex == -1) return;

            for (int i = 0; i < startIndex; i++)
            {
                Label statusLabel = GetLabelByStatus(statusOrder[i]);
                if (statusLabel != null)
                {
                    statusLabel.BackColor = GetStatusColor(statusOrder[i]);
                }
            }
        }

        public void ApplyDisapproval(string status)
        {
            ResetActiveStatuses(status);
            ProcessDisapproval(status);
        }

        private Label GetLabelByStatus(string status)
        {
            if (status == "Received") return lblReceived;
            if (status == "Pending") return lblPending;
            if (status == "Finalizing") return lblFinalizing;
            if (status == "Approved") return lblApproved;
            return null;
        }

        private Color GetStatusColor(string status)
        {
            if (status == "Received") return ActiveReceived;
            if (status == "Pending") return ActivePending;
            if (status == "Finalizing") return ActiveFinalizing;
            if (status == "Approved") return ActiveApproved;
            return InactiveColor;
        }

        protected void btnEventCalendar_Click(object sender, EventArgs e)
        {
            Response.Redirect("SOCalendar.aspx");
        }

        protected void btnProposalTracking_Click(object sender, EventArgs e)
        {
            Response.Redirect("SOProposalTracker.aspx");
        }

        protected void btnSettings_Click(object sender, EventArgs e)
        {
            Response.Redirect("SOSettings.aspx");
        }

        protected void ddlOptions_SelectedIndexChanged(object sender, EventArgs e)
        {
            ddlOptions.Items[0].Attributes["disabled"] = "disabled";
            loadComments();

            using (SqlConnection conn = new SqlConnection(connStr))
            {

                string query = @"
                                SELECT 
                                    E.Status, 
                                    E.ReceivedDate, 
                                    RA.FullName AS ReceivedByName,
                                    E.PendingDate, 
                                    PA.FullName AS PendingByName,
                                    E.FinalizingDate, 
                                    FA.FullName AS FinalizedByName,
                                    E.ApprovedDate, 
                                    AA.FullName AS ApprovedByName,
                                    E.ProposalSentDate
                                FROM
                                    Events E
                                LEFT JOIN
                                    TB_Authority RA ON E.ReceivedBy = RA.Email
                                LEFT JOIN
                                    TB_Authority PA ON E.PendingBy = PA.Email
                                LEFT JOIN
                                    TB_Authority FA ON E.FinalizedBy = FA.Email
                                LEFT JOIN
                                    TB_Authority AA ON E.ApprovedBy = AA.Email
                                WHERE
                                    E.EventID = @EventID
                                ORDER BY
                                    E.EventID;";

                SqlCommand cmd = new SqlCommand(query, conn);

                cmd.Parameters.AddWithValue("@EventID", Convert.ToInt32(ddlOptions.SelectedValue));

                try
                {
                    conn.Open();
                    SqlDataReader reader = cmd.ExecuteReader();

                    // Reset existing labels
                    ResetTimelineLabels();
                    ResetDisapprovalStatus();

                    while (reader.Read())
                    {
                        int status = Convert.ToInt32(reader["Status"]);
                        string statusText = convertStatusToText(status);

                        if (status > 4)
                        {
                            // Process disapproval status
                            ProcessDisapproval(statusText);

                            if (status == 5)
                            {
                                lblTimestamp1.Text = reader["ReceivedDate"].ToString();
                                lblDetails1.Text = "Received by " + reader["ReceivedByName"].ToString();
                                lblTimestamp2.Text = reader["PendingDate"].ToString();
                                lblDetails2.Text = "Pending by " + reader["PendingByName"].ToString();
                                lblTimestamp3.Text = reader["ApprovedDate"].ToString();
                                lblDetails3.Text = "Revision by " + reader["ApprovedByName"].ToString();
                                //lblTimestamp4.Text = reader["ApprovedDate"].ToString();
                                lblDetails4.Text = "Proposal for Revision";
                            }
                            else if (status == 6)
                            {
                                lblTimestamp1.Text = reader["ReceivedDate"].ToString();
                                lblDetails1.Text = "Received by " + reader["ReceivedByName"].ToString();
                                lblTimestamp2.Text = reader["PendingDate"].ToString();
                                lblDetails2.Text = "Pending by " + reader["PendingByName"].ToString();
                                lblTimestamp3.Text = reader["ApprovedDate"].ToString();
                                lblDetails3.Text = "Disapproved by " + reader["ApprovedByName"].ToString();
                                //lblTimestamp4.Text = reader["ApprovedDate"].ToString();
                                lblDetails4.Text = "Proposal was Disapproved";
                            }
                        }
                        else
                        {
                            // Process ongoing status
                            ProcessOngoing(statusText);

                            // Set the timeline labels based on the status
                            if (status == 1)
                            {
                                lblTimestamp1.Text = reader["ProposalSentDate"].ToString();
                                lblDetails1.Text = "Proposal Sent";
                            }
                            else if (status == 2)
                            {
                                lblTimestamp1.Text = reader["ReceivedDate"].ToString();
                                lblDetails1.Text = "Received by " + reader["ReceivedByName"].ToString();
                                lblTimestamp2.Text = "---";
                                lblDetails2.Text = "Proposal is now pending.";
                            }
                            else if (status == 3)
                            {
                                lblTimestamp1.Text = reader["ReceivedDate"].ToString();
                                lblDetails1.Text = "Received by " + reader["ReceivedByName"].ToString();
                                lblTimestamp2.Text = reader["PendingDate"].ToString();
                                lblDetails2.Text = "Pending by " + reader["PendingByName"].ToString();
                                lblTimestamp3.Text = "---";
                                lblDetails3.Text = "Proposal is now finalizing.";
                            }
                            else if (status == 4)
                            {
                                lblTimestamp1.Text = reader["ReceivedDate"].ToString();
                                lblDetails1.Text = "Received by " + reader["ReceivedByName"].ToString();
                                lblTimestamp2.Text = reader["PendingDate"].ToString();
                                lblDetails2.Text = "Pending by " + reader["PendingByName"].ToString();
                                lblTimestamp3.Text = reader["ApprovedDate"].ToString();
                                lblDetails3.Text = "Finalized by " + reader["ApprovedByName"].ToString();
                                lblTimestamp4.Text = reader["ApprovedDate"].ToString();
                                lblDetails4.Text = "Approved by " + reader["ApprovedByName"].ToString();
                            }


                        }
                    }

                }
                catch (Exception ex) { }


            }
        }
        private string convertStatusToText(int status)
        {
            switch (status)
            {
                case 1:
                    return "Received";
                case 2:
                    return "Pending";
                case 3:
                    return "Finalizing";
                case 4:
                    return "Approved";
                default:
                    return "Approved";
            }
        }

        private void ResetTimelineLabels()
        {
            // Reset all the labels to default text (optional)
            lblTimestamp1.Text = string.Empty;
            lblDetails1.Text = string.Empty;
            lblTimestamp2.Text = string.Empty;
            lblDetails2.Text = string.Empty;
            lblTimestamp3.Text = string.Empty;
            lblDetails3.Text = string.Empty;
            lblTimestamp4.Text = string.Empty;
            lblDetails4.Text = string.Empty;
        }


        private void ResetDisapprovalStatus()
        {
            // Reset disapproval labels to hide the "X" mark and restore the colors
            lblReceivedDisap.Visible = false;
            lblPendingDisap.Visible = false;
            lblFinalizingDisap.Visible = false;
            lblApprovedDisap.Visible = false;

            // Restore original colors
            lblReceived.BackColor = ActiveReceived;
            lblPending.BackColor = ActivePending;
            lblFinalizing.BackColor = ActiveFinalizing;
            lblApproved.BackColor = ActiveApproved;
        }
    }
}
