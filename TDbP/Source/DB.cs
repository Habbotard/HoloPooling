using System;
using System.Data;
using System.Data.Odbc;
using System.Collections;
using System.IO;
using System.Threading;

using MySql.Data.MySqlClient;

namespace Holo
{
    public static class dataHandling
    {
        /// <summary>
        /// Converts a DataColumn to an array .
        /// </summary>
        /// <param name="dCol">The DataColumn input.</param>
        public static string[] dColToArray(DataColumn dCol)
        {
            string[] dString = new string[dCol.Table.Rows.Count];
            for (int l = 0; l < dString.Length; l++)
                dString[l] = Convert.ToString(dCol.Table.Rows[l][0]);
            return dString;            
        }

        /// <summary>
        /// Converts a DataColumn to an array .
        /// </summary>
        /// <param name="dCol">The DataColumn input.</param>
        /// <param name="Tick">The output type of the array will become int.</param>
        public static int[] dColToArray(DataColumn dCol, object Tick)
        {
            int[] dInt = new int[dCol.Table.Rows.Count];
            for (int l = 0; l < dInt.Length; l++)
                dInt[l] = Convert.ToInt32(dCol.Table.Rows[l][0]);
            return dInt;
        }

    }
    /// <summary>
    /// A reuseable instance of a database connection, for accessing/writing data into the database.
    /// </summary>
    public class Database
    {
        #region Declares
        /// <summary>
        /// The MySqlConnection object of this connection. This object is private.
        /// </summary>
        private MySqlConnection Connection;
        /// <summary>
        /// The MySqlDataAdapter object of this connection, required for inserting data etc. This object is private.
        /// </summary>
        private MySqlDataAdapter dataAdapter = new MySqlDataAdapter();
        /// <summary>
        /// The MySqlCommand object of this connection, used for executing commands at the database. This object is private.
        /// </summary>
        private MySqlCommand Command = new MySqlCommand();
        /// <summary>
        /// A boolean indicating if the Database object should be closed after the next query.
        /// </summary>
        public bool closeAfterNextQuery;
        /// <summary>
        /// The connection string for connections. This string is static.
        /// </summary>
        public static string connectionString = "Server=" + Eucalypt.dbHost + ";Uid=" + Eucalypt.dbUsername +" ;Pwd=" + Eucalypt.dbPassword + ";Database=" + Eucalypt.dbName + ";Port=" + Eucalypt.dbPort + ";Pooling=false";//Max Pool Size=" + Eucalypt.dbPool;

        private bool _Ready = false;
        /// <summary>
        /// Gets the current readystate. (connected yes/no)
        /// </summary>
        public bool Ready
        {
            get { return this._Ready; }
        }
        #endregion

        #region Constructors
        /// <summary>
        /// Initializes the Database object, with the options to open the database upon constructing, and/or to make the Database object tidy up (close connection and dispose resources) after the first query.
        /// </summary>
        /// <param name="openNow">Indicates if the database connection should be opened already.</param>
        /// <param name="closeAfterNextQuery">Indicates if the Database object should close the connection and dispose resources after the first query.</param>
        public Database(bool openNow, bool closeAfterFirstQuery, int ID)
        {
            if (openNow)
                this.Open();
            this.closeAfterNextQuery = closeAfterFirstQuery;
        }
        #endregion

        #region Methods
        #region Opening and closing database
        /// <summary>
        /// Attempts to open a connection to the database and prepares for use.
        /// </summary>
        public void Open()
        {
            // Attempt to connect to the database and handle exceptions
            try
            {
                this.Connection = new MySqlConnection(connectionString);
                this.Connection.Open();
                this.Command.Connection = this.Connection;
                this.dataAdapter.SelectCommand = this.Command;
                this._Ready = true;
            }
            catch (MySqlException ex) // Error while connecting
            {
                WriteError(ex.Message);
            }
        }
        /// <summary>
        /// Closes the connection to the database, if connected. All resources are disposed.
        /// </summary>
        public void Close()
        {
            if (this._Ready)
            {
                this.Connection.Close();
                this.Connection = null;
                this.dataAdapter = null;
                this.Command = null;
                this.closeAfterNextQuery = false;
                this._Ready = false;
            }
        }
        #endregion

        #region Data access
        /// <summary>
        /// Returns a DataSet object containing requested data of various tables.
        /// </summary>
        /// <param name="Query">The query to run at the database.</param>
        public DataSet getDataSet(string Query)
        {
            
            DataSet dReturn = new DataSet();
            
            if (_Ready)
            {                
                try
                {
                    this.Command.CommandText = Query;
                    this.dataAdapter.Fill(dReturn);
                }
                catch (Exception ex) { WriteError(ex.Message + "\n(^^" + Query + "^^)"); }
                if (this.closeAfterNextQuery)
                    this.Close();

                return dReturn;
            }
            Out.WriteError("Database connection not active");
            return dReturn;
        }
        /// <summary>
        /// Returns a DataTable object containing requested data of a single table.
        /// </summary>
        /// <param name="Query">The query to run at the database.</param>
        public DataTable getTable(string Query)
        {
            //WriteError("Retrieving datatable; " + Query);
            
            DataTable dReturn = new DataTable();
            
            if (_Ready)
            {
                try
                {
                    this.Command.CommandText = Query;
                    this.dataAdapter.Fill(dReturn);
                }
                catch (Exception ex) { WriteError(ex.Message + "\n(^^" + Query + "^^)"); }
                if (this.closeAfterNextQuery)
                    this.Close();

                return dReturn;
            }
            Out.WriteError("Database connection not active");
            return dReturn;
        }
        /// <summary>
        /// Returns a DataTable object containing requested data of a single table.
        /// </summary>
        /// <param name="Query">The query to run at the database.</param>
        /// <param name="Quiet">Prevents an error from being printed to the server.</param>
        public DataTable getTable(string Query, object Quiet)
        {
            //WriteError("Retrieving datatable; " + Query);
            
            DataTable dReturn = new DataTable();
            
            if (_Ready)
            {
                try
                {
                    this.Command.CommandText = Query;
                    this.dataAdapter.Fill(dReturn);
                }
                catch { }
                if (this.closeAfterNextQuery)
                    this.Close();

                return dReturn;
            }
            Out.WriteError("Database connection not active");
            return dReturn;
        }
        /// <summary>
        /// Returns a DataRow object containing requested data of a single row of a single table.
        /// </summary>
        /// <param name="Query">The query to run at the database.</param>
        public DataRow getRow(string Query)
        {           
            DataRow dReturn = new DataTable().NewRow();
            
            if (_Ready)
            {
                try
                {
                    DataSet tmpSet = new DataSet();
                    this.Command.CommandText = Query;
                    this.dataAdapter.Fill(tmpSet);
                    dReturn = tmpSet.Tables[0].Rows[0];
                }
                catch { }

                if (this.closeAfterNextQuery)
                    this.Close();

                return dReturn;
            }
            Out.WriteError("Database connection not active");
            return dReturn;
        }
        /// <summary>
        /// Returns a DataColumn object containing requested data of a single column of a single table.
        /// </summary>
        /// <param name="Query">The query to run at the database.</param>
        public DataColumn getColumn(string Query)
        {
            
            DataColumn dReturn = new DataTable().Columns.Add();
            
            if (_Ready)
            {
            try
            {
                DataSet tmpSet = new DataSet();
                this.Command.CommandText = Query;
                this.dataAdapter.Fill(tmpSet);
                dReturn = tmpSet.Tables[0].Columns[0];
            }
            catch { }

            if (this.closeAfterNextQuery)
                this.Close();

            return dReturn;
            }
            Out.WriteError("Database connection not active");
            return dReturn;
        }
        /// <summary>
        /// Retrieves a single field value from the database and returns it as a string.
        /// </summary>
        /// <param name="Query">The query to run at the database.</param>
        public string getString(string Query)
        {
            
            string s = "";
            
            if (_Ready)
            {
            try
            {
                this.Command.CommandText = Query;
                s = this.Command.ExecuteScalar().ToString();
            }
            catch { }
            if (this.closeAfterNextQuery)
                this.Close();

            return s;
            }
            Out.WriteError("Database connection not active");
            return s;
        }
        /// <summary>
        /// Retrieves a single field value from the database and returns it as an integer.
        /// </summary>
        /// <param name="Query">The query to run at the database.</param>
        public int getInteger(string Query)
        {
            
            int i = 0;
            
            if (_Ready)
            {
            try
            {
                this.Command.CommandText = Query;
                i = int.Parse(this.Command.ExecuteScalar().ToString());
            }
            catch { }
            if (this.closeAfterNextQuery)
                this.Close();

            return i;
            }
            return i;
        }
        /// <summary>
        /// Returns a boolean indicating if there were results for a certain query.
        /// </summary>
        /// <param name="Query">The query to run at the database.</param>
        public bool findsResult(string Query)
        {
            
            bool Found = false;
            
            if (_Ready)
            {
            try
            {
                this.Command.CommandText = Query;
                MySqlDataReader dReader = this.Command.ExecuteReader();
                Found = dReader.HasRows;
                dReader.Close();
            }
            catch (Exception ex) { WriteError(ex.Message + "\n(^^" + Query + "^^)"); }
            if (this.closeAfterNextQuery)
                this.Close();

            return Found;
            }
            Out.WriteError("Database connection not active");
            return Found;
        }
        #endregion

        #region Other
        /// <summary>
        /// Adds a parameter with a value to the current parameter collection, for use in queries. A '@' symbol is placed infront of the parameter key automatically.
        /// </summary>
        /// <param name="Parameter">The parameter key to add. '@' symbol is added infront.</param>
        /// <param name="Value">The value of the parameter, can be any type.</param>
        public void addParameterWithValue(string Parameter, object Value)
        {
            
            this.Command.Parameters.AddWithValue("@" + Parameter, Value);
        }

        public void addRawParameter(MySqlParameter Parameter)
        {
            
            this.Command.Parameters.Add(Parameter);
        }
        /// <summary>
        /// Clears all parameters from the parameter collection.
        /// </summary>
        public void clearParameters()
        {
            
            this.Command.Parameters.Clear();
        }
        /// <summary>
        /// Attempts to open a connection to the database to execute a query.
        /// </summary>
        /// <param name="Query">The query string to execute.</param>
        public void runQuery(string Query)
        {
            
            if (_Ready)
            {
                try
                {
                    this.Command.CommandText = Query;
                    this.Command.ExecuteNonQuery();
                }
                catch (Exception ex) { WriteError(ex.Message + "\n(^^" + Query + "^^)"); }
                if (this.closeAfterNextQuery)
                    this.Close();
            }
            else
                Out.WriteError("Database connection not active");
        }
        /// <summary>
        /// Writes Message to the server and DB.err.
        /// </summary>
        /// <param name="Message">The message to write.</param>
        public static void WriteError(string Message)
        {
            try
            {
                FileStream Writer = new FileStream("DB.err", FileMode.Append, FileAccess.Write);
                byte[] Msg = System.Text.ASCIIEncoding.ASCII.GetBytes(Message + "\r\n");
                Writer.Write(Msg, 0, Msg.Length);
            }
            catch
            {
                Message = "FAILED TO SAVE ERROR TO FILE: " + Message;
            }
            Console.ForegroundColor = ConsoleColor.DarkMagenta;
            Console.Write("[DATABASE ERROR] => ");
            Console.ForegroundColor = ConsoleColor.Magenta;
            Console.WriteLine(Message);
            Console.ForegroundColor = ConsoleColor.Gray;
        }
        #endregion
        #endregion
    }

    //#region Old DB
    ///// <summary>
    ///// A reuseable instance of a database connection, for accessing/writing data into the database.
    ///// </summary>
    //sealed class Connection
    //{
    //        #region Declares
    //        public OdbcConnection dbConnection = new OdbcConnection("Driver={MySQL ODBC 5.1 Driver};Server=" + Eucalypt.dbHost + ";Port=" + Eucalypt.dbPort + ";Database=" + Eucalypt.dbName + ";User=" + Eucalypt.dbUsername + ";Password=" + Eucalypt.dbPassword + ";Option=3;");
    //        public OdbcCommand dbCommand = new OdbcCommand();

    //        public bool Locked = false;
    //        private bool _Ready = false;
    //        internal bool Ready
    //        {
    //            get { return this._Ready; }
    //        }
    //        #endregion

    //        public Connection()
    //        {

    //        }

    //        #region Opening and closing database
    //        internal void Open()
    //        {
    //            try
    //            {
    //                Locked = true;
    //                dbConnection.Open();
    //                dbCommand.Connection = dbConnection;
    //                _Ready = true;
    //            }
    //            catch (OdbcException ex) // Error while connecting
    //            {
    //                DB.WriteError(ex.Message);
    //                Locked = false;
    //            }
    //        }

    //        internal void Close()
    //        {
    //            if (_Ready)
    //            {
    //                dbConnection.Close();
    //                _Ready = false;
    //                Locked = false;
    //            }
    //        }
    //        #endregion
    //}
    
    ///// <summary> 
    ///// Provides high speed data access to the MySQL database of Holograph Emulator. It owns eh? 
    ///// </summary> 
    ///// <remarks></remarks> 
    //public static class DB
    //    {
    //        public static int Connections = 0;
    //        static Hashtable _Connections = new Hashtable();

    //        public static void Init()
    //        {
    //            for (int i = 0; i < Connections; i++)
    //            {
    //                _Connections.Add(i, new Connection());
    //            }
    //        }

    //        static Connection Fetch()
    //        {
    //            foreach (Connection dbConnection in _Connections.Values)
    //            {
    //                if (dbConnection.Locked == false)
    //                    return dbConnection;
    //            }
    //            _Connections.Add(Connections, new Connection());
    //            Connections++;
    //            return (Connection)_Connections[Connections - 1];
    //        }

    //        static Connection Connect()
    //        {
    //            Connection dbConnection = Fetch();
    //            dbConnection.Open();
    //            return dbConnection;
    //        }

    //        #region Database data manipulation
    //        /// <summary> 
    //        /// Executes a SQL statement on the database. 
    //        /// </summary> 
    //        /// <param name="Query">The SQL statement to be executed. Default SQL syntax.</param> 
    //        public static void runQuery(string Query)
    //        {
    //            Connection dbConnection = Connect();
    //            try
    //            {
    //                dbConnection.dbCommand.CommandText = Query;
    //                dbConnection.dbCommand.ExecuteScalar();
    //            }
    //            catch (Exception ex) { WriteError("Error '" + ex.Message + "' at '" + Query + "'"); }
    //            dbConnection.Close();
    //        }
    //        #endregion

    //        #region Database data retrieval
    //        #region runRead
    //        /// <summary> 
    //        /// Performs a SQL query and returns the first selected field as string. Other fields are ignored. 
    //        /// </summary> 
    //        /// <param name="Query">The SQL query that selects a field.</param> 
    //        public static string runRead(string Query)
    //        {
    //            Connection dbConnection = Connect();
    //            try
    //            {
    //                dbConnection.dbCommand.CommandText = Query + " LIMIT 1";
    //                string Return = dbConnection.dbCommand.ExecuteScalar().ToString();
    //                dbConnection.Close();
    //                return Return;
    //            }
    //            catch (Exception ex)
    //            {
    //                WriteError("Error '" + ex.Message + "' at '" + Query + "'");
    //                dbConnection.Close();
    //                return "";
    //            }
    //        }
    //        /// <summary> 
    //        /// Performs a SQL query and returns the first selected field as integer. Other fields are ignored. 
    //        /// </summary> 
    //        /// <param name="Query">The SQL query that selects a field.</param> 
    //        /// <param name="Tick">Just to differ the runRead functions; supply a null if you want to use this overload.</param> 
    //        public static int runRead(string Query, object Tick)
    //        {
    //            Connection dbConnection = Connect();
    //            try
    //            {
    //                dbConnection.dbCommand.CommandText = Query + " LIMIT 1";
    //                int Return = Convert.ToInt32(dbConnection.dbCommand.ExecuteScalar());
    //                dbConnection.Close();
    //                return Return;
    //            }
    //            catch (Exception ex)
    //            {
    //                WriteError("Error '" + ex.Message + "' at '" + Query + "'");
    //                dbConnection.Close();
    //                return 0;
    //            }
    //        }
    //        #endregion
    //        #region runReadColumn
    //        /// <summary> 
    //        /// Performs a SQL query and returns all vertical matching fields as a String array. Only the first supplied columname is looked for. 
    //        /// </summary> 
    //        /// <param name="Query">The SQL query that selects a column.</param> 
    //        /// <param name="maxResults">Adds as LIMIT to the query. Using this, the array will never return more than xx fields in of the column. When maxResults is supplied as 0, then there is no max limit.</param> 
    //        public static string[] runReadColumn(string Query, int maxResults)
    //        {
    //            if (maxResults > 0)
    //                Query += " LIMIT " + maxResults;
    //            Connection dbConnection = Connect();
    //            try
    //            {
    //                ArrayList columnBuilder = new ArrayList();
    //                dbConnection.dbCommand.CommandText = Query;
    //                OdbcDataReader columnReader = dbConnection.dbCommand.ExecuteReader();

    //                while (columnReader.Read())
    //                {
    //                    try { columnBuilder.Add(columnReader[0].ToString()); }
    //                    catch { columnBuilder.Add(""); }
    //                }
    //                columnReader.Close();
    //                dbConnection.Close();

    //                return (string[])columnBuilder.ToArray(typeof(string));
    //            }

    //            catch (Exception ex)
    //            {
    //                WriteError("Error '" + ex.Message + "' at '" + Query + "'");
    //                dbConnection.Close();
    //                return new string[0];
    //            }
    //        }
    //        /// <summary> 
    //        /// Performs a SQL query and returns all vertical matching fields as an Integer array. Only the first supplied columname is looked for. 
    //        /// </summary> 
    //        /// <param name="Query">The SQL query that selects a column.</param> 
    //        /// <param name="maxResults">Adds as LIMIT to the query. Using this, the array will never return more than xx fields in of the column. When maxResults is supplied as 0, then there is no max limit.</param> 
    //        /// <param name="Tick">Just to differ the runReadColumn functions; supply a null if you want to use this overload.</param> 
    //        public static int[] runReadColumn(string Query, int maxResults, object Tick)
    //        {
    //            if (maxResults > 0)
    //                Query += " LIMIT " + maxResults;
    //            Connection dbConnection = Connect();
    //            try
    //            {
    //                ArrayList columnBuilder = new ArrayList();
    //                dbConnection.dbCommand.CommandText = Query;
    //                OdbcDataReader columnReader = dbConnection.dbCommand.ExecuteReader();

    //                while (columnReader.Read())
    //                {
    //                    try { columnBuilder.Add(columnReader.GetInt32(0)); }
    //                    catch { columnBuilder.Add(0); }
    //                }
    //                columnReader.Close();
    //                dbConnection.Close();
    //                return (int[])columnBuilder.ToArray(typeof(int));
    //            }

    //            catch (Exception ex)
    //            {
    //                WriteError("Error '" + ex.Message + "' at '" + Query + "'");
    //                dbConnection.Close();
    //                return new int[0];

    //            }
    //        }
    //        #endregion
    //        #region runReadRow
    //        /// <summary> 
    //        /// Performs a SQL query and returns the selected in the first found row as a String array. Useable for only one row. 
    //        /// </summary> 
    //        /// <param name="Query">The SQL query that selects a row and the fields to get. LIMIT 1 is added.</param> 
    //        public static string[] runReadRow(string Query)
    //        {
    //            Connection dbConnection = Connect();
    //            try
    //            {
    //                ArrayList rowBuilder = new ArrayList();
    //                dbConnection.dbCommand.CommandText = Query + " LIMIT 1";
    //                OdbcDataReader rowReader = dbConnection.dbCommand.ExecuteReader();

    //                while (rowReader.Read())
    //                {
    //                    for (int i = 0; i < rowReader.FieldCount; i++)
    //                    {
    //                        try { rowBuilder.Add(rowReader[i].ToString()); }
    //                        catch { rowBuilder.Add(""); }
    //                    }
    //                }
    //                rowReader.Close();
    //                dbConnection.Close();
    //                return (string[])rowBuilder.ToArray(typeof(string));
    //            }

    //            catch (Exception ex)
    //            {
    //                WriteError("Error '" + ex.Message + "' at '" + Query + "'");
    //                dbConnection.Close();
    //                return new string[0];
    //            }
    //        }
    //        /// <summary> 
    //        /// Performs a SQL query and returns the selected in the first found row as an Integer array. Useable for only one row. 
    //        /// </summary> 
    //        /// <param name="Query">The SQL query that selects a row and the fields to get. LIMIT 1 is added.</param> 
    //        /// <param name="Tick">Just to differ the runReadRow functions; supply a null if you want to use this overload.</param> 
    //        public static int[] runReadRow(string Query, object Tick)
    //        {
    //            Connection dbConnection = Connect();
    //            try
    //            {
    //                ArrayList rowBuilder = new ArrayList();
    //                dbConnection.dbCommand.CommandText = Query + " LIMIT 1";
    //                OdbcDataReader rowReader = dbConnection.dbCommand.ExecuteReader();

    //                while (rowReader.Read())
    //                {
    //                    for (int i = 0; i < rowReader.FieldCount; i++)
    //                    {
    //                        try { rowBuilder.Add(rowReader.GetInt32(i)); }
    //                        catch { rowBuilder.Add(0); }
    //                    }
    //                }
    //                rowReader.Close();
    //                dbConnection.Close();
    //                return (int[])rowBuilder.ToArray(typeof(int));
    //            }

    //            catch (Exception ex)
    //            {
    //                WriteError("Error '" + ex.Message + "' at '" + Query + "'");
    //                dbConnection.Close();
    //                return new int[0];
    //            }
    //        }
    //        /// <summary>
    //        /// Performs a SQL query and returns the result as a string. On error, no error is reported and "" is returned.
    //        /// </summary>
    //        /// <param name="Query">The SQL query to run. LIMIT 1 is added.</param>
    //        public static string runReadUnsafe(string Query)
    //        {
    //            Connection dbConnection = Connect();
    //            try
    //            {
    //                dbConnection.dbCommand.CommandText = Query + " LIMIT 1";
    //                string Return = dbConnection.dbCommand.ExecuteScalar().ToString();
    //                dbConnection.Close();
    //                return Return;
    //            }
    //            catch
    //            {
    //                dbConnection.Close();
    //                return "";
    //            }
    //        }
    //        /// <summary>
    //        /// Performs a SQL query and returns the result as an integer. On error, no error is reported and 0 is returned.
    //        /// </summary>
    //        /// <param name="Query">The SQL query to run. LIMIT 1 is added.</param>
    //        /// <param name="Tick">Just to differ the runReadUnsafe functions; supply a null if you want to use this overload.</param> 
    //        public static int runReadUnsafe(string Query, object Tick)
    //        {
    //            Connection dbConnection = Connect();
    //            try
    //            {
    //                dbConnection.dbCommand.CommandText = Query + " LIMIT 1";
    //                int Return = Convert.ToInt32(dbConnection.dbCommand.ExecuteScalar());
    //                dbConnection.Close();
    //                return Return;
    //            }
    //            catch
    //            {
    //                dbConnection.Close();
    //                return 0;
    //            }
    //        }
    //        #endregion
    //        #endregion

    //        #region Data availability checks
    //        /// <summary> 
    //        /// Tries to find fields matching the query. When there is at least one result, it returns True and stops. 
    //        /// </summary> 
    //        /// <param name="Query">The SQL query that contains the seeked fields and conditions. LIMIT 1 is added.</param> 
    //        public static bool checkExists(string Query)
    //        {
    //            Connection dbConnection = Connect();
    //            dbConnection.dbCommand.CommandText = Query + " LIMIT 1";
    //            try
    //            {
    //                bool Check = dbConnection.dbCommand.ExecuteReader().HasRows;
    //                dbConnection.Close();
    //                return Check;
    //            }
    //            catch (Exception ex)
    //            {
    //                WriteError("Error '" + ex.Message + "' at '" + Query + "'");
    //                return false;
    //            }
    //        }
    //        #endregion

    //        #region Misc
    //        /// <summary> 
    //        /// Returns a stripslashed copy of the input string.
    //        /// </summary> 
    //        /// <param name="Query">The string to add stripslashes to.</param>
    //        public static string Stripslash(string Query)
    //        {
    //            try { return Query.Replace(@"\", "\\").Replace("'", @"\'"); }
    //            catch { return ""; }
    //        }

    //        /// <summary>
    //        /// Writes Message to the server and DB.err.
    //        /// </summary>
    //        /// <param name="Message">The message to write.</param>
    //        public static void WriteError(string Message)
    //        {
    //            try
    //            {
    //                FileStream Writer = new FileStream("DB.err", FileMode.Append, FileAccess.Write);
    //                byte[] Msg = System.Text.ASCIIEncoding.ASCII.GetBytes(Message + "\r\n");
    //                Writer.Write(Msg, 0, Msg.Length);
    //            }
    //            catch
    //            {
    //                Message = "FAILED TO SAVE ERROR TO FILE: " + Message;
    //            }

    //            Out.WriteError(Message);
    //        }
    //        #endregion
    //    }
    //#endregion
}