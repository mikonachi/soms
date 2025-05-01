using System;
using System.Data;
using System.Data.SqlClient;

namespace SOMS
{
    public class dataAccess
    {
        clsConnectionString connectionString = new clsConnectionString();

        //OPEN CONNECTION IN DATABASE
        public SqlConnection GetConnection()
        {
            SqlConnection connection = new SqlConnection(connectionString.con);
            connection.Open();
            return connection;

        }

        // USE FOR CRUD
        public int ExecuteStoredProc(string procedureName, SqlParameter[] parameters = null)
        {
            using (SqlConnection connection = GetConnection())
            using (SqlCommand command = new SqlCommand(procedureName, connection))
            {
                command.CommandType = CommandType.StoredProcedure;

                if (parameters != null)
                    command.Parameters.AddRange(parameters);
                return command.ExecuteNonQuery();
            }
        }


        // USE FOR FETCHING DATA FROM DATABASE
        public DataTable FetchDataFromProcedure(string procedureName, SqlParameter[] parameters = null)
        {
            DataTable resultTable = new DataTable();

            using (SqlConnection connection = GetConnection())
            {
                try
                {
                    SqlCommand cmd = new SqlCommand(procedureName, connection)
                    {
                        CommandType = CommandType.StoredProcedure
                    };

                    if (parameters != null && parameters.Length > 0)
                    {
                        cmd.Parameters.AddRange(parameters);
                    }

                    SqlDataAdapter dataAdapter = new SqlDataAdapter(cmd);
                    dataAdapter.Fill(resultTable);
                }
                catch (Exception ex)
                {
                    Console.WriteLine("Error fetching data: " + ex.Message);
                }
            }

            return resultTable;
        }


    }
}