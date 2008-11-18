using System;
using System.Data;
using System.Text;
using System.Threading;
using System.Collections;

using Holo.Virtual.Users;

namespace Holo.Managers
{
    /// <summary>
    /// Provides management for logged in users, aswell for retrieving details such as ID/name and vice versa from the database.
    /// </summary>
    public static class userManager
    {
        public static Hashtable _Users = new Hashtable();
        private static Thread pingChecker;
        private static int _peakUserCount;

        /// <summary>
        /// Starts the pingchecker thread.
        /// </summary>
        public static void Init()
        {
            try { pingChecker.Abort(); }
            catch { }
            pingChecker = new Thread(new ThreadStart(checkPings));
            pingChecker.Priority = ThreadPriority.BelowNormal;
            pingChecker.Start();
        }
        /// <summary>
        /// Adds a virtualUser class together with the userID to the userManager. Login ticket will be nulled and previous logged in instances of this user will be dropped.
        /// </summary>
        /// <param name="userID">The ID of the user to add.</param>
        /// <param name="User">The virtualUser class of this user.</param>
        public static void addUser(int userID, virtualUser User)
        {
            if (_Users.ContainsKey(userID))
            {
                virtualUser oldUser = ((virtualUser)_Users[userID]);
                oldUser.Disconnect();
                if (_Users.ContainsKey(userID))
                    _Users.Remove(userID);
            }
            Database dbClient = new Database(false, false, 50);
            dbClient.addParameterWithValue("name", User._Username);
            dbClient.Open();
            if (User.connectionRemoteIP == dbClient.getString("SELECT ipaddress_last FROM users WHERE name = @name"))
            {
                _Users.Add(userID, User);
                dbClient.runQuery("UPDATE users SET ticket_sso = NULL WHERE id = '" + userID + "' LIMIT 1");
                Out.WriteLine("User " + userID + " logged in. [" + User._Username + "]", Out.logFlags.BelowStandardAction);
            }
            else
            {
                User.Disconnect(1000);
                User.sendData("BK" + "Invalid Session Ticket, please login again!");
            }
            dbClient.Close();

            if (_Users.Count > _peakUserCount)
                _peakUserCount = _Users.Count;
        }
        /// <summary>
        /// Removes a user from the userManager. [if it exists]
        /// </summary>
        /// <param name="userID">The ID of the user to remove.</param>
        public static void removeUser(int userID)
        {
            if (_Users.ContainsKey(userID))
            {
                _Users.Remove(userID);
                Out.WriteLine("User [" + userID + "] disconnected.", Out.logFlags.BelowStandardAction);
            }
        }
        /// <summary>
        /// Returns a bool that indicates if the userManager contains a certain user.
        /// </summary>
        /// <param name="userID">The ID of the user.</param>
        public static bool containsUser(int userID)
        {
            return _Users.ContainsKey(userID);
        }
        /// <summary>
        /// Returns a bool that indicates if the userManager contains a certain user.
        /// </summary>
        /// <param name="userName">The username of the user.</param>
        public static bool containsUser(string userName)
        {
            int userID = getUserID(userName);
            return _Users.ContainsKey(userID);
        }

        /// <summary>
        /// Returns the current amount of users in the userManager.
        /// </summary>
        public static int userCount
        {
            get
            {
                return _Users.Count;
            }
        }
        /// <summary>
        /// Returns the peak amount of users in the userManager since boot.
        /// </summary>
        public static int peakUserCount
        {
            get
            {
                return _peakUserCount;
            }
        }

        /// <summary>
        /// Retrieves the ID of a user from the database.
        /// </summary>
        /// <param name="userName">The username of the user.</param>
        public static int getUserID(string userName)
        {
            Database dbClient = new Database(false, true, 39);
            dbClient.addParameterWithValue("name", userName);
            dbClient.Open();
            return dbClient.getInteger("SELECT id FROM users WHERE name = @name");
        }
        /// <summary>
        /// Retrieves the username of a user from the database.
        /// </summary>
        /// <param name="userID">The ID of the user.</param>
        public static string getUserName(int userID)
        {
            Database dbClient = new Database(true, true, 40);
            return dbClient.getString("SELECT name FROM users WHERE id = '" + userID + "'");
        }
        /// <summary>
        /// Returns a bool that indicates if a user with a certain user ID exists in the database.
        /// </summary>
        /// <param name="userID">The ID of the user to check.</param>
        public static bool userExists(int userID)
        {
            Database dbClient = new Database(true, true, 41);
            return dbClient.findsResult("SELECT id FROM users WHERE id = '" + userID + "'");
        }

        /// <summary>
        /// Returns an int array with the ID's of the messenger friends of a certain user.
        /// </summary>
        /// <param name="userID">The ID of the user to get the friend ID's from.</param>
        public static int[] getUserFriendIDs(int userID)
        {
            Database dbClient = new Database(true, false, 42);
            try
            {
                ArrayList idBuilder = new ArrayList();
                DataColumn dCol = dbClient.getColumn("SELECT friendid FROM messenger_friendships WHERE userid = '" + userID + "'");
                int[] friendIDs = dataHandling.dColToArray(dCol, null);
                foreach (int i in friendIDs)
                    idBuilder.Add(i);
                dCol = dbClient.getColumn("SELECT userid FROM messenger_friendships WHERE friendid = '" + userID + "'");
                dbClient.Close();
                friendIDs = dataHandling.dColToArray(dCol, null);
                foreach (int i in friendIDs)
                    idBuilder.Add(i);

                return (int[])idBuilder.ToArray(typeof(int));
            }
            catch
            {
                return new int[0];
            }
            finally
            {
                dbClient.Close();
            }
        }
        /// <summary>
        /// Returns a virtualUser class for a certain user
        /// </summary>
        /// <param name="userID">The ID of the user.</param>
        public static virtualUser getUser(int userID)
        {
            try { return (virtualUser)_Users[userID]; }
            catch { return null; }
        }
        /// <summary>
        /// Returns a virtualUser class for a certain user.
        /// </summary>
        /// <param name="userName">The username of the user.</param>
        public static virtualUser getUser(string userName)
        {
            int userID = getUserID(userName);
            return getUser(userID);
        }
        /// <summary>
        /// Sends a single packet to all connected clients.
        /// </summary>
        /// <param name="Data">The packet to send.</param>
        public static void sendData(string Data)
        {
            try
            {
                foreach (virtualUser User in ((Hashtable)_Users.Clone()).Values)
                    User.sendData(Data);
            }
            catch { }
        }
        /// <summary>
        /// Sends a single packet to all active virtual users with the specified rank. Optionally you can include users who have a higher rank than the specified rank.
        /// </summary>
        /// <param name="Rank">The minimum rank that the virtual user required to receive the data.</param>
        /// <param name="includeHigher">Indicates if virtual users with a rank that's higher than the specified rank should also receive the packet.</param>
        /// <param name="Data">The packet to send.</param>
        public static void sendToRank(byte Rank, bool includeHigher, string Data)
        {
            foreach (virtualUser User in ((Hashtable)_Users.Clone()).Values)
            {
                if (User._Rank < Rank || (includeHigher == false && User._Rank > Rank))
                    continue;
                else
                    User.sendData(Data);
            }
        }
        /// <summary>
        /// Inserts a single 'chat saying' to the system_chatlog table, together with username of sayer, room ID of sayer and the current timestamp.
        /// </summary>
        /// <param name="userName">The username of the sayer.</param>
        /// <param name="roomID">The ID of the room where the sayer is in.</param>
        /// <param name="Message">The message the sayer said.</param>
        public static void addChatMessage(string userName, int roomID, string Message)
        {
            Database dbClient = new Database(false, true, 43);
            dbClient.addParameterWithValue("username", userName);
            dbClient.addParameterWithValue("roomid", roomID);
            dbClient.addParameterWithValue("message", Message);
            dbClient.Open();
            dbClient.runQuery("INSERT INTO system_chatlog (username,roomid,mtime,message) VALUES (@username,@roomid,CURRENT_TIMESTAMP,@message)");
        }
        /// <summary>
        /// Generates an info list about a certain user. If the user isn't found or has a higher rank than the info requesting user, then an access error message is returned. Otherwise, a report with user ID, username, rank, mission, credits amount, tickets amount, virtual birthday (signup date), real birthday, email address and last IP address. If the user is online, then information about the room the user currently is in (including ID and owner name) is supplied, otherwise, the last server access date is supplied.
        /// </summary>
        /// <param name="userID">The database ID of the user to generate the info of.</param>
        /// <param name="Rank">The rank of the user that requests this info. If this rank is lower than the rank of the target user, then there is no info returned.</param>
        public static string generateUserInfo(int userID, byte Rank)
        {
            Database dbClient = new Database(true, false, 44);
            DataRow dRow = dbClient.getRow("SELECT name,rank,mission,credits,tickets,email,birth,hbirth,ipaddress_last,lastvisit FROM users WHERE id = '" + userID + "' AND rank <= " + Rank);
            if (dRow.Table.Rows.Count == 0)
            {
                dbClient.Close();
                return stringManager.getString("userinfo_accesserror");
            }
            else
            {
                StringBuilder Info = new StringBuilder(stringManager.getString("userinfo_header") + "\r"); // Append header
                Info.Append(stringManager.getString("common_userid") + ": " + userID + "\r"); // Append user ID
                Info.Append(stringManager.getString("common_username") + ": " + Convert.ToString(dRow[0]) + "\r"); // Append username
                Info.Append(stringManager.getString("common_userrank") + ": " + Convert.ToString(dRow[1]) + "\r"); // Append rank
                Info.Append(stringManager.getString("common_usermission") + ": " + Convert.ToString(dRow[2]) + "\r"); // Append user's mission
                Info.Append(stringManager.getString("common_credits") + ": " + Convert.ToString(dRow[3]) + "\r"); // Append user's amount of credits
                Info.Append(stringManager.getString("common_tickets") + ": " + Convert.ToString(dRow[4]) + "\r"); // Append user's amount of tickets
                Info.Append(stringManager.getString("common_hbirth") + ": " + Convert.ToString(dRow[7]) + "\r\r"); // Append 'registered at' date + blank line
                Info.Append(stringManager.getString("common_birth") + ": " + Convert.ToString(dRow[6]) + "\r"); // Append real birthday
                Info.Append(stringManager.getString("common_email") + ": " + Convert.ToString(dRow[5]) + "\r"); // Append email address
                Info.Append(stringManager.getString("common_ip") + ": " + Convert.ToString(dRow[8]) + "\r\r"); // Append user's last used IP address

                if (_Users.ContainsKey(userID)) // User online
                {
                    virtualUser User = (virtualUser)_Users[userID];
                    string Location = "";
                    if (User._roomID == 0)
                        Location = stringManager.getString("common_hotelview");
                    else
                        Location = stringManager.getString("common_room") + " '" + dbClient.getString("SELECT name FROM rooms WHERE id = '" + User._roomID + "'") + "' [id: " + User._roomID + ", " + stringManager.getString("common_owner") + ": " + dbClient.getString("SELECT owner FROM rooms WHERE id = '" + User._roomID + "'") + "]"; // Roomname, room ID and name of the user that owns the room
                    Info.Append(stringManager.getString("common_location") + ": " + Location);
                }
                else // User is offline
                    Info.Append(stringManager.getString("common_lastaccess") + ": " + Convert.ToString(dRow[9])); // Append last server access date
                dbClient.Close();
                return Info.ToString();
            }
        }
        /// <summary>
        /// Generates a string containing the packet to send the the user.
        /// </summary>
        /// <param name="Rank">The rank of the user.</param>
        public static string generateCommands(byte Rank)
        {
            //Hashtable Commands = new Hashtable();
            string[] Commands = null;
            StringBuilder Packet = new StringBuilder("BKYour Commands:");

            // % = next
            string Cmds = "";


            Cmds += "%";
            Cmds += ":im NAME [MESSAGE] - Send an instant message to a friend%";
            Cmds += ":events - Shows the events window%";
            Cmds += ":about - Display some server infomation%";
            Cmds += ":whosonline - Display all the users online and there ranks%";
            Cmds += ":cleanhand - Deletes all items in your hand%";
            Cmds += ":brb - Displays a message telling the room you are brb (Max 15 minutes)%";
            Cmds += ":back - Stops displays a message telling the room you are brb%";
            Cmds += ":hotel/:info/:version - Displays the current version of the server%";
            Cmds += ":staff - Tells you how to contact staff%";
            Cmds += ":commands/:cmds - Displays this alert%";

            if (Rank > 1)
            {
                Cmds += "%";
                Cmds += ":chooser - Display everyone in the room%";
                Cmds += ":furni - Display all furni in the room%";

                if (rankManager.containsRight(Rank, "fuse_alert"))
                {
                    Cmds += "%";
                    Cmds += ":alert NAME MESSAGE - Sends a moderator alert%";
                }

                if (rankManager.containsRight(Rank, "fuse_room_alert"))
                {
                    Cmds += "%";
                    Cmds += ":roomalert MESSAGE - Sends a moderator alert to a whole room%";
                }

                if (rankManager.containsRight(Rank, "fuse_kick"))
                {
                    Cmds += "%";
                    Cmds += ":kick [MESSAGE] - Kicks a user from the room they are in%";
                }

                if (rankManager.containsRight(Rank, "fuse_room_kick"))
                {
                    Cmds += "%";
                    Cmds += ":roomkick [MESSAGE] - Kicks all users but you from the room";
                }

                if (rankManager.containsRight(Rank, "fuse_mute"))
                {
                    Cmds += "%";
                    Cmds += ":shutup NAME [MESSAGE] - Stops a user from using say/shout%";
                    Cmds += ":unmute NAME - Allows a user to say/shout again%";
                }

                if (rankManager.containsRight(Rank, "fuse_room_mute"))
                {
                    Cmds += "%";
                    Cmds += ":roomshutup [MESSAGE] - Stops all users in the room from using say/shout%";
                    Cmds += ":roomunmute Allows all users in the room to say/shout again%";
                }

                if (rankManager.containsRight(Rank, "fuse_ban"))
                {
                    Cmds += "%";
                    Cmds += ":ban NAME HOURS REASON - Bans a user for the how many hours%";
                }

                if (rankManager.containsRight(Rank, "fuse_superban"))
                {
                    Cmds += "%";
                    Cmds += ":superban NAME HOURS REASON - Bans a user and there IP for how many hours%";
                }

                if (rankManager.containsRight(Rank, "fuse_administrator_access"))
                {
                    Cmds += "%";
                    Cmds += ":ha MESSAGE - Sends an alert to all online users%";
                    Cmds += ":offline MINUTES - Informs all online users that the hotel is going offline in how long you said%";
                    Cmds += ":refresh - Updates certain parts of the server%";
                    Cmds += ":cords - Display your current room position%";
                    Cmds += ":teleport - Turns on teleport mode (WARNING: It causes the room to screw up)%";
                    Cmds += ":warp X Y -  Teleports you the the the location input%";
                    Cmds += ":sendme PACKET - Sends a packet to your self (For debuging)%";
                }

                if (rankManager.containsRight(Rank, "fuse_alert"))
                {
                    Cmds += "%";
                    Cmds += ":ra MESSAGE - Sends an alert to all online users with the same rank as you%";
                }

                if (rankManager.containsRight(Rank, "fuse_teleport"))
                {
                    Cmds += "%";
                    Cmds += ":teleport - Toggles your movent to teleport mode on/off%";
                    Cmds += ":warp X Y - Teleports you to the co-ordinates entered%";
                }

                if (rankManager.containsRight(Rank, "fuse_moderator_access"))
                {
                    Cmds += "%";
                    Cmds += ":userinfo NAME/:ui NAME - Displays infomation about a user%";
                }
            }
            Commands = Cmds/*.Replace("%", "|")*/.Split("%".ToCharArray());


            int r = 30;
            foreach (string Command in Commands)
            {
                if (r == 0)
                {
                    Packet.Append(Convert.ToChar(1) + "BKYour Commands:");
                    r = 30;
                }
                Packet.Append("\r" + Command);
                r--;
            }
            return Packet.ToString();
        }
        /// <summary>
        /// Generates a string containing the packet to send the the user.
        /// </summary>
        /// 
        public static string generateWhosOnline(bool Admin)
        {
            int i = userCount;
            int alerts = 0;
            while (i > 30)
            {
                alerts++;
                i -= 30;
            }
            alerts++;
            StringBuilder packet = new StringBuilder("BKOnline Users");
            if (alerts > 1)
                packet.Append(" page 1/" + alerts);
            packet.Append(" Total online: " + userCount);
            int r = 30;
            int p = 1;
            if (Admin)
                foreach (DictionaryEntry user in _Users)
                {
                    if (r == 0)
                    {
                        p++;
                        packet.Append(Convert.ToChar(1) + "BKOnline Users" + " page " + p + "/" + alerts + " Total online: " + userCount);
                        r = 30;
                    }
                    packet.Append("\r" + getUserName((int)user.Key) + " [" + user.Key.ToString() + "] {" + getUser((int)user.Key)._Rank + "}   " + getUser((int)user.Key).connectionRemoteIP);
                    r--;
                }
            else
            {
                foreach (DictionaryEntry user in _Users)
                {
                    if (r == 0)
                    {
                        p++;
                        packet.Append(Convert.ToChar(1) + "BKOnline Users" + " page " + p + " Total online: " + userCount);
                        r = 30;
                    }
                    packet.Append("\r" + getUserName((int)user.Key) + " {" + getUser((int)user.Key)._Rank + "}");
                    r--;
                }
            }
            return packet.ToString();
        }
        /// <summary>
        /// (Re)bans a single user for a specified amount of hours and reason. If the user is online, then it receives the ban message and get's disconnected.
        /// </summary>
        /// <param name="userID">The database ID of the user to ban.</param>
        /// <param name="Hours">The amount of hours (starts now) till the ban is lifted.</param>
        /// <param name="Reason">The reason for the ban, that describes the user why it's account is blocked from the system.</param>
        public static void setBan(int userID, int Hours, string Reason)
        {
            string Expires = DateTime.Now.AddHours(Hours).ToString().Replace("/", "-").Replace(".", "-");
            Database dbClient = new Database(false, true, 45);
            dbClient.addParameterWithValue("userid", userID);
            dbClient.addParameterWithValue("expires", Expires);
            dbClient.addParameterWithValue("reason", Reason);
            dbClient.Open();
            dbClient.runQuery("INSERT INTO users_bans (userid,date_expire,descr) VALUES (@userid,@expires,@reason)");

            if (_Users.ContainsKey(userID))
            {
                virtualUser User = ((virtualUser)_Users[userID]);
                User.sendData("@c" + Reason);
                User.Disconnect(1000);
            }
        }
        /// <summary>
        /// Checks if there are system bans for a certain IP address.
        /// If a ban is detected, it checks if it's already expired.
        /// If that is the case, then it lifts the ban.
        /// If there is a pending ban, it returns the reason that was supplied with the banning, otherwise, it returns "".
        /// </summary>
        /// <param name="IP">The IP address to check bans for.</param>
        public static string getBanReason(string IP)
        {
            Database dbClient = new Database(true, false, 46);
            if (dbClient.findsResult("SELECT ipaddress FROM users_bans WHERE ipaddress = '" + IP + "'"))
            {
                string banExpires = dbClient.getString("SELECT date_expire FROM users_bans WHERE ipaddress = '" + IP + "'");
                if (DateTime.Compare(DateTime.Parse(banExpires), DateTime.Now) > 0)
                    return dbClient.getString("SELECT descr FROM users_bans WHERE ipaddress = '" + IP + "'"); // Still banned, return reason
                else
                    dbClient.runQuery("DELETE FROM user_bans WHERE ipaddress = '" + IP + "' LIMIT 1");
            }
            dbClient.Close();

            return ""; // No pending ban/ban expired
        }
        /// <summary>
        /// (Re)bans all the users on a certain IP address, making them unable to login, and making them unable to connect to the system. The ban is applied with a specified amount and reason. All affected users receive the ban message (which contains the reason) and they are disconnected.
        /// </summary>
        /// <param name="IP">The IP address to ban.</param>
        /// <param name="Hours">The amount of hours (starts now) till the ban is lifted.</param>
        /// <param name="Reason">The reason for the ban, that describes thes user why their IP address/accounts are blocked from the system.</param>
        public static void setBan(string IP, int Hours, string Reason)
        {
            string Expires = DateTime.Now.AddHours(Hours).ToString().Replace("/", "-").Replace(".", "-");
            Database dbClient = new Database(false, false, 47);
            dbClient.addParameterWithValue("ip", IP);
            dbClient.addParameterWithValue("expires", Expires);
            dbClient.addParameterWithValue("reason", Reason);
            dbClient.Open();
            dbClient.runQuery("INSERT INTO users_bans (ipaddress,date_expire,descr) VALUES (@ip,@expires,@reason)");
            
            DataColumn dCol = dbClient.getColumn("SELECT id FROM users WHERE ipaddress_last = '" + IP + "'");
            dbClient.Close();
            virtualUser User;
            
            foreach (DataRow dRow in dCol.Table.Rows)
            {
                if (_Users.ContainsKey(Convert.ToInt32(dRow["id"])))
                {
                    User = ((virtualUser)_Users[Convert.ToInt32(dRow["ID"])]);
                    User.sendData("@c" + Reason);
                    User.Disconnect(1000);
                }
            }
        }
        /// <summary>
        /// Checks if there is a system ban for a certain user.
        /// If a ban is detected, it checks if it's already expired.
        /// If that is the case, then it lifts the ban.
        /// If there is a pending ban, it returns the reason that was supplied with the banning, otherwise, it returns "".
        /// </summary>
        /// <param name="userID">The database ID of the user to check for bans.</param>
        public static string getBanReason(int userID)
        {
            Database dbClient = new Database(true, false, 48);
            if (dbClient.findsResult("SELECT userid FROM users_bans WHERE userid = '" + userID + "'"))
            {
                string banExpires = dbClient.getString("SELECT date_expire FROM users_bans WHERE userid = '" + userID + "'");
                if (DateTime.Compare(DateTime.Parse(banExpires), DateTime.Now) > 0) // Still banned, return reason
                    return dbClient.getString("SELECT descr FROM users_bans WHERE userid = '" + userID + "'");
                else
                    dbClient.runQuery("DELETE FROM users_bans WHERE userid = '" + userID + "' LIMIT 1");
            }
            dbClient.Close();
            return ""; // No pending ban/ban expired
        }
        /// <summary>
        /// Generates a ban report for a certain ban on a user, including all details that could be of use. If there was no ban found, or the user that was banned doesn't exist, then a holo.cast.banreport.null is returned.
        /// </summary>
        /// <param name="userID">The database ID of the user to generate the ban report for.</param>
        public static string generateBanReport(int userID)
        {
            Database dbClient = new Database(true, false, 49);
            try
            {
                DataRow dRow = dbClient.getRow("SELECT date_expire,descr,ipaddress FROM users_bans WHERE userid = '" + userID + "'");
                DataRow dbRow = dbClient.getRow("SELECT name,rank,ipaddress_last FROM users WHERE id = '" + userID + "'");

                if (dRow.Table.Rows.Count == 0 || dbRow.Table.Rows.Count == 0)
                {
                    dbClient.Close();
                    return "holo.cast.banreport.null";
                }
                else
                {
                    string Note = "-";
                    string banPoster = "not available";
                    string banPosted = "not available";
                    DataRow DRow = dbClient.getRow("SELECT userid,note,timestamp FROM system_stafflog WHERE action = 'ban' AND targetid = '" + userID + "' ORDER BY id ASC"); // Get latest stafflog entry for this action (if exists)
                    if (DRow.Table.Rows.Count > 0) // system_stafflog table could be cleaned up
                    {
                        if (Convert.ToString(DRow[1]) != "")
                            Note = Convert.ToString(DRow[1]);
                        banPoster = dbClient.getString("SELECT name FROM users WHERE id = '" + Convert.ToString(DRow[0]) + "'");
                        banPosted = Convert.ToString(DRow[2]);
                    }
                    dbClient.Close();

                    StringBuilder Report = new StringBuilder(stringManager.getString("banreport_header") + " ");
                    Report.Append(Convert.ToString(dbRow[0]) + " [" + userID + "]" + "\r"); // Append username and user ID
                    Report.Append(stringManager.getString("common_userrank") + ": " + Convert.ToString(dbRow[1]) + "\r"); // Append user's rank
                    Report.Append(stringManager.getString("common_ip") + ": " + Convert.ToString(dbRow[2]) + "\r"); // Append the IP address of user
                    Report.Append(stringManager.getString("banreport_banner") + ": " + banPoster + "\r"); // Append username of banner
                    Report.Append(stringManager.getString("banreport_posted") + ": " + banPosted + "\r"); // Append datetime when ban was posted
                    Report.Append(stringManager.getString("banreport_expires") + ": " + Convert.ToString(dRow[0]) + "\r"); // Append datetime when ban expires
                    Report.Append(stringManager.getString("banreport_reason") + ": " + Convert.ToString(dRow[1]) + "\r"); // Append the reason that went with the ban
                    Report.Append(stringManager.getString("banreport_ipbanflag") + ": " + (Convert.ToString(dRow[2]) != "").ToString().ToLower() + "\r"); // Append true/false for the IP ban status
                    Report.Append(stringManager.getString("banreport_staffnote") + ": " + Note); // Append the staffnote that went with the ban
                    return Report.ToString();
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                dbClient.Close();
            }
        }
        /// <summary>
        /// Generates a ban report for a certain IP address, including all details that could be of use. If there was no ban found, or the user that was banned doesn't exist, then a holo.cast.banreport.null is returned.
        /// </summary>
        /// <param name="IP">The IP address to generate the ban report for.</param>
        public static string generateBanReport(string IP)
        {
            Database dbClient = new Database(true, false, 51);
            try
            {
                DataRow dRow = dbClient.getRow("SELECT userid,date_expire,descr FROM users_bans WHERE ipaddress = '" + IP + "'");
                //-// string[] banDetails = (string[])dbClient.getRow("SELECT userid,date_expire,descr FROM users_bans WHERE ipaddress = '" + IP + "'").ItemArray;

                if (dRow.Table.Rows.Count == 0)
                {
                    dbClient.Close();
                    return "holo.cast.banreport.null";
                }
                else
                {
                    string Note = "-";
                    string banPoster = "not available";
                    string banPosted = "not available";
                    DataRow DRow = dbClient.getRow("SELECT userid,note,timestamp FROM system_stafflog WHERE action = 'ban' AND targetid = '" + Convert.ToString(dRow[0]) + "' ORDER BY id ASC"); // Get latest stafflog entry for this action (if exists)
                    //-// string[] logEntries = (string[])dbClient.getRow("SELECT userid,note,timestamp FROM system_stafflog WHERE action = 'ban' AND targetid = '" + banDetails[0] + "' ORDER BY id DESC").ItemArray; // Get latest stafflog entry for this action (if exists)
                    if (DRow.Table.Rows.Count > 0) // system_stafflog table could be cleaned up
                    {
                        if (Convert.ToString(DRow[1]) != "")
                            Note = Convert.ToString(DRow[1]);
                        banPoster = dbClient.getString("SELECT name FROM users WHERE id = '" + Convert.ToString(DRow[0]) + "'");
                        banPosted = Convert.ToString(DRow[2]);
                    }

                    StringBuilder Report = new StringBuilder(stringManager.getString("banreport_header") + " ");
                    Report.Append(IP + "\r"); // Append IP address
                    Report.Append(stringManager.getString("banreport_banner") + ": " + banPoster + "\r"); // Append username of banner
                    Report.Append(stringManager.getString("banreport_posted") + ": " + banPosted + "\r"); // Append datetime when ban was posted
                    Report.Append(stringManager.getString("banreport_expires") + ": " + Convert.ToString(dRow[0]) + "\r"); // Append datetime when ban expires
                    Report.Append(stringManager.getString("banreport_reason") + ": " + Convert.ToString(dRow[1]) + "\r"); // Append the reason that went with the ban
                    Report.Append(stringManager.getString("banreport_ipbanflag") + ": " + (Convert.ToString(dRow[2]) != "").ToString().ToLower() + "\r"); // Append true/false for the IP ban status
                    Report.Append(stringManager.getString("banreport_staffnote") + ": " + Note + "\r\r"); // Append the staffnote that went with the ban

                    DataColumn dCol = dbClient.getColumn("SELECT name FROM users WHERE ipaddress_last = '" + IP + "'");
                    //string[] affectedUsernames = dataHandling.dColToArray(dCol);
                    Report.Append(stringManager.getString("banreport_affectedusernames") + ":");
                    foreach (DataRow dbRow in dCol.Table.Rows)
                        Report.Append("\r - " + Convert.ToString(dRow["name"]));
                    dbClient.Close();
                    return Report.ToString();
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                dbClient.Close();
            }
        }
        /// <summary>
        /// Ran on a thread at interval 60000ms, checks ping status of users and disconnects timed out users.
        /// </summary>
        private static void checkPings()
        {
            while (true)
            {
                foreach (virtualUser User in ((Hashtable)_Users.Clone()).Values)
                {
                    if (User.pingOK)
                    {
                        User.pingOK = false;
                        User.sendData("@r");
                    }
                    else
                    {
                        Holo.Out.WriteLine(User._Username + " timed out.");
                        User.Disconnect();
                    }
                }
                Thread.Sleep(60000);
                Out.WriteTrace("Checking virtual user pings");
            }
        }
    }
}
