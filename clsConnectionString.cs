using System.Configuration;

namespace SOMS
{
    internal class clsConnectionString
    {
        public string con = ConfigurationManager.ConnectionStrings["OMSDB"].ConnectionString;
    }
}