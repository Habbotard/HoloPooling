using System;
using System.Data;
using System.Text;
using System.Net;
using System.Net.Sockets;
using System.Threading;

using Holo.Managers;
using Holo.Virtual.Rooms;
using Holo.Virtual.Users.Items;
using Holo.Virtual.Users.Messenger;
using Holo.Virtual.Rooms.Games;

namespace Holo.Virtual.Users
{
    /// <summary>
    /// Represents a virtual user, with connection and packet handling, access management etc etc. The details about the user are kept separate in a different class.
    /// </summary>
    public class virtualUser
    {
        /// <summary>
        /// The ID of the connection for this virtual user. Assigned by the game socket server.
        /// </summary>
        private int connectionID;
        /// <summary>
        /// The socket that connects the client with the emulator. Operates asynchronous.
        /// </summary>
        private Socket connectionSocket;
        /// <summary>
        /// The byte array where the data is saved in while receiving the data asynchronously.
        /// </summary>
        private byte[] dataBuffer = new byte[1024];
        /// <summary>
        /// Specifies if the client has sent the 'CD' packet on time. Being checked by the user manager every minute.
        /// </summary>
        internal bool pingOK;
        /// <summary>
        /// Specifies if the client is disconnected already.
        /// </summary>
        private bool _isDisconnected;
        /// <summary>
        /// Specifies if the client has logged in and the user details are loaded. If false, then the user is just a connected client and shouldn't be able to send 'logged in' packets.
        /// </summary>
        private bool _isLoggedIn;
        /// <summary>        
        /// The room user ID (rUID) of the virtual user where this virtual user is currently trading items with. If not trading, then this value is -1.
        /// </summary>
        internal int _tradePartnerRoomUID = -1;
        /// Specifies if the user has received the sprite index packet (Dg) already. This packet only requires being sent once, and since it's a BIG packet, we limit it to send it once.
        /// </summary>
        private bool _receivedSpriteIndex;
        /// <summary>
        /// The number of the page of the Hand (item inventory) the user is currently on.
        /// </summary>
        private int _handPage;
        private delegate void timedDisconnector(int ms);

        /// <summary>
        /// The virtual room the user is in.
        /// </summary>
        internal virtualRoom Room;
        /// <summary>
        /// The virtualRoomUser that represents this virtual user in room. Contains in-room only objects such as position, rotation and walk related objects.
        /// </summary>
        internal virtualRoomUser roomUser;
        /// <summary>
        /// The status manager that keeps status strings for the user in room.
        /// </summary>
        internal virtualRoomUserStatusManager statusManager;
        /// <summary>
        /// The messenger that provides instant messaging, friendlist etc for this virtual user.
        /// </summary>
        internal Messenger.virtualMessenger Messenger;
        /// <summary>
        /// Variant of virtualRoomUser object. Represents this virtual user in a game arena, aswell as in a game team in the navigator.
        /// </summary>
        internal gamePlayer gamePlayer;

        #region Personal
        internal int userID;
        internal string _Username;
        internal string _Figure;
        internal char _Sex;
        internal string _Mission;
        internal string _consoleMission;
        internal byte _Rank;
        internal int _Credits;
        internal int _Tickets;

        internal string _nowBadge;
        internal bool _clubMember;

        internal int _roomID;
        internal bool _inPublicroom;
        internal bool _ROOMACCESS_PRIMARY_OK;
        internal bool _ROOMACCESS_SECONDARY_OK;
        internal bool _isOwner;
        internal bool _hasRights;
        internal bool _isMuted;

        internal int _groupID;
        internal int _groupMemberRank;

        internal int _tradePartnerUID = -1;
        internal bool _tradeAccept;
        internal int[] _tradeItems = new int[65];
        internal int _tradeItemCount;

        internal int _teleporterID;
        internal bool _hostsEvent;

        private virtualSongEditor songEditor;
        private Thread brbLooper;
        #endregion

        #region Constructors/destructors
        /// <summary>
        /// Initializes a new virtual user, and starts packet transfer between client and asynchronous socket server.
        /// </summary>
        /// <param name="connectionID">The ID of the new connection.</param>
        /// <param name="connectionSocket">The socket of the new connection.</param>
        public virtualUser(int connectionID, Socket connectionSocket)
        {
            this.connectionID = connectionID;
            this.connectionSocket = connectionSocket;

            try
            {
                string banReason = userManager.getBanReason(this.connectionRemoteIP);
                if (banReason != "")
                {
                    sendData("@c" + banReason);
                    Disconnect();
                }
                else
                {
                    pingOK = true;
                    sendData("@@");
                    connectionSocket.BeginReceive(dataBuffer, 0, dataBuffer.Length, SocketFlags.None, new AsyncCallback(dataArrival), null);
                }
            }
            catch { }
        }
        #endregion

        #region Connection management
        /// <summary>
        /// Immediately completes the current data transfer [if any], disconnects the client and flags the connection slot as free.
        /// </summary>
        internal void Disconnect()
        {
            if (_isDisconnected)
                return;

            try { connectionSocket.Close(); }
            catch { }
            connectionSocket = null;

            if (Room != null && roomUser != null)
                Room.removeUser(roomUser.roomUID, false, "");

            if (Messenger != null)
                Messenger.Clear();

            userManager.removeUser(userID);
            Socketservers.gameSocketServer.freeConnection(connectionID);
            _isDisconnected = true;
        }
        /// <summary>
        /// Disables receiving on the socket, sleeps for a specified amount of time [ms] and disconnects via normal Disconnect() void. Asynchronous.
        /// </summary>
        /// <param name="ms"></param>
        internal void Disconnect(int ms)
        {
            new timedDisconnector(delDisconnectTimed).BeginInvoke(ms, null, null);
        }
        private void delDisconnectTimed(int ms)
        {
            connectionSocket.Shutdown(SocketShutdown.Receive);
            Thread.Sleep(ms);
            Disconnect();
        }

        /// <summary>
        /// Returns the IP address of this connection as a string.
        /// </summary>
        internal string connectionRemoteIP
        {
            get
            {
                return connectionSocket.RemoteEndPoint.ToString().Split(':')[0];
            }
        }
        #endregion

        #region Data receiving
        /// <summary>
        /// This void is triggered when a new datapacket arrives at the socket of this user. The packet is separated and processed. On errors, the client is disconnected.
        /// </summary>
        /// <param name="iAr">The IAsyncResult of this BeginReceive asynchronous action.</param>
        private void dataArrival(IAsyncResult iAr)
        {
            string lPacket = "";
            int vPacket = 0;
            try
            {
                int bytesReceived = connectionSocket.EndReceive(iAr);
                string connectionData = System.Text.Encoding.Default.GetString(dataBuffer, 0, bytesReceived);

                if (connectionData.Contains("\x01") || connectionData.Contains("\x02") || connectionData.Contains("\x05") || connectionData.Contains("\x09"))
                {
                    Disconnect();
                    return;
                }

                while (connectionData != "")
                {
                    int v = Encoding.decodeB64(connectionData.Substring(1, 2));
                    lPacket = connectionData;
                    vPacket = v;
                    processPacket(connectionData.Substring(3, v));
                    connectionData = connectionData.Substring(v + 3);
                }

                connectionSocket.BeginReceive(dataBuffer, 0, dataBuffer.Length, SocketFlags.None, new AsyncCallback(dataArrival), null);
            }
            catch { Disconnect(); }
        }
        #endregion  

        #region Data sending
        /// <summary>
        /// Sends a single packet to the client via an asynchronous BeginSend action.
        /// </summary>
        /// <param name="Data">The string of data to send. char[01] is added.</param>
        internal void sendData(string Data)
        {
            try
            {
                byte[] dataBytes = System.Text.Encoding.Default.GetBytes(Data + Convert.ToChar(1));
                connectionSocket.BeginSend(dataBytes, 0, dataBytes.Length, 0, new AsyncCallback(sentData), null);
                //Out.WriteSpecialLine(Data.Replace("\r", "{13}"), Out.logFlags.MehAction, ConsoleColor.White, ConsoleColor.DarkCyan, "> [" + Thread.GetDomainID() + "]", 2, ConsoleColor.Cyan);
            }
            catch
            {
                Disconnect();
            }
        }
        /// <summary>
        /// Triggered when an asynchronous BeginSend action is completed. Virtual user completes the transfer action and leaves asynchronous action.
        /// </summary>
        /// <param name="iAr">The IAsyncResult of this BeginSend asynchronous action.</param>
        private void sentData(IAsyncResult iAr)
        {
            try { connectionSocket.EndSend(iAr); }
            catch { Disconnect(); }
        }
        #endregion

        #region Packet processing
        /// <summary>
        /// Processes a single packet from the client.
        /// </summary>
        /// <param name="currentPacket">The packet to process.</param>
        private void processPacket(string currentPacket)
        {
            //Out.WriteSpecialLine(currentPacket.Replace("\r", "{13}"), Out.logFlags.MehAction, ConsoleColor.White, ConsoleColor.DarkCyan, "> [" + Thread.GetDomainID() + "]", 2, ConsoleColor.Cyan);
            if (_isLoggedIn == false)
            {
                #region Non-logged in packet processing
                
                    switch (currentPacket.Substring(0, 2))
                    {
                        case "CD":
                            pingOK = true;
                            break;

                        case "CN":
                            sendData("DUIH");
                            break;

                        case "CJ":
                            sendData("DAQBHHIIKHJIPAHQAdd-MM-yyyy" + Convert.ToChar(2) + "SAHPBhttp://www.vista4life.com" + Convert.ToChar(2) + "QBH");
                            break;

                        ///case "_R":
                            ///{
                                //v24
                                //Habbo_V24_Crypto v24Enc = new Habbo_V24_Crypto();
                                //string ssoTicket = DB.Stripslash(currentPacket.Substring(4));
                                //int myID = DB.runRead("SELECT id FROM users WHERE ticket_sso = '" + ssoTicket + "'", null);
                                //if (myID == 0) // No user found for this sso ticket and/or IP address
                                //Out.WriteError(v24Enc.deciphper(ssoTicket));
                                //Out.WriteError(v24Enc.deciphper("@A"));
                                //sendData("@A" + myID + ssoTicket);
                                //break;
                            //}

                        case "CL":
                            {
                                Database dbClient = new Database(false, false, 125);
                                dbClient.addParameterWithValue("sso", currentPacket.Substring(4));
                                    dbClient.Open();
                                int myID = dbClient.getInteger("SELECT id FROM users WHERE ticket_sso = @sso");
                                if (myID == 0) // No user found for this sso ticket and/or IP address
                                {
                                    Disconnect();
                                    dbClient.Close();
                                    return;
                                }

                                string banReason = userManager.getBanReason(myID);
                                if (banReason != "")
                                {
                                    sendData("@c" + banReason);
                                    Disconnect(1000);
                                    dbClient.Close();
                                    return;
                                }

                                this.userID = myID;
                                DataRow dRow = dbClient.getRow("SELECT name,figure,sex,mission,rank,consolemission FROM users WHERE id = '" + myID + "'");
                                dbClient.Close();
                                _Username = Convert.ToString(dRow[0]);
                                _Figure = Convert.ToString(dRow[1]);
                                _Sex = Convert.ToChar(dRow[2]);
                                _Mission = Convert.ToString(dRow[3]);
                                _Rank = Convert.ToByte(dRow[4]);
                                _consoleMission = Convert.ToString(dRow[5]);
                                userManager.addUser(myID, this);
                                _isLoggedIn = true;

                                sendData("DA" + "QBHIIIKHJIPAIQAdd-MM-yyyy" + Convert.ToChar(2) + "SAHPB/client" + Convert.ToChar(2) + "QBH");
                                sendData("@B" + rankManager.fuseRights(_Rank));
                                sendData("DbIH");
                                sendData("@C");

                                if (Config.enableWelcomeMessage)
                                    sendData("BK" + stringManager.getString("welcomemessage_text"));
                                break;
                            }

                        default:
                            Disconnect();
                            break;
                    }

                #endregion                    
            }
            else
            {
                #region Logged-in packet processing
                switch (currentPacket.Substring(0, 2))
                {                
                        #region Misc
                        case "CD": // Client - response to @r ping
                            pingOK = true;
                            break;

                        case "@q": // Client - request current date
                            sendData("Bc" + DateTime.Today.ToShortDateString());
                            break;

                        case "BA": // Purse - redeem credit voucher
                            {
                                Database dbClient = new Database(false, false, 137);
                                dbClient.addParameterWithValue("code", currentPacket.Substring(4));
                                dbClient.Open();
                                if (dbClient.findsResult("SELECT credits FROM vouchers WHERE voucher = @code"))
                                {
                                    int voucherAmount = dbClient.getInteger("SELECT credits FROM vouchers WHERE voucher = @code");
                                    dbClient.runQuery("DELETE FROM vouchers WHERE voucher = @code LIMIT 1");

                                    _Credits += voucherAmount;
                                    sendData("@F" + _Credits);
                                    sendData("CT");
                                    dbClient.runQuery("UPDATE users SET credits = '" + voucherAmount + "' WHERE id = '" + userID + "' LIMIT 1");
                                }
                                else
                                    sendData("CU1");
                                dbClient.Close();
                                break;
                            }
                        #endregion
                        
                        #region Login
                        case "@L": // Login - initialize messenger
                            Messenger = new Messenger.virtualMessenger(userID);
                            sendData("@L" + Messenger.friendList());
                            sendData("Dz" + Messenger.friendRequests());
                            break;

                        case "@Z": // Login - initialize Club subscription status
                            refreshClub();
                            break;

                        case "@G": // Login - initialize/refresh appearance
                            refreshAppearance(false, true, false);
                            break;

                        case "@H": // Login - initialize/refresh valueables [credits, tickets, etc]
                            refreshValueables(true, true);
                            break;

                        case "B]": // Login - initialize/refresh badges
                            refreshBadges();
                            break;

                        case "Cd": // Login - initialize/refresh group status
                            refreshGroupStatus();
                            break;

                        case "C^": // Recycler - receive recycler setup
                            sendData("Do" + recyclerManager.setupString);
                            break;

                        case "C_": // Recycler - receive recycler session status
                            sendData("Dp" + recyclerManager.sessionString(userID));
                            break;
                        #endregion
                         
                        #region Messenger
                        case "@g": // Messenger - request user as friend
                            {
                                if (Messenger != null)
                                {
                                    Database dbClient = new Database(false, false, 142);
                                    dbClient.addParameterWithValue("username", currentPacket.Substring(4));
                                    dbClient.Open();
                                    int toID = dbClient.getInteger("SELECT id FROM users WHERE name = @username");
                                    if (toID > 0 && Messenger.hasFriendRequests(toID) == false && Messenger.hasFriendship(toID) == false)
                                    {
                                        int requestID = dbClient.getInteger("SELECT MAX(requestid) FROM messenger_friendrequests WHERE userid_to = '" + toID + "'") + 1;
                                        dbClient.runQuery("INSERT INTO messenger_friendrequests(userid_to,userid_from,requestid) VALUES ('" + toID + "','" + userID + "','" + requestID + "')");
                                        userManager.getUser(toID).sendData("BD" + "I" + _Username + Convert.ToChar(2) + userID + Convert.ToChar(2));
                                    }
                                    dbClient.Close();
                                }
                                break;
                            }
                            
                        case "@e": // Messenger - accept friendrequest(s)
                            {
                                if (Messenger != null)
                                {
                                    int Amount = Encoding.decodeVL64(currentPacket.Substring(2));
                                    currentPacket = currentPacket.Substring(Encoding.encodeVL64(Amount).Length + 2);

                                    int updateAmount = 0;
                                    StringBuilder Updates = new StringBuilder();
                                    virtualBuddy Me = new virtualBuddy(userID);

                                    Database dbClient = new Database(true, false, 143);
                                    for (int i = 0; i < Amount; i++)
                                    {
                                        if (currentPacket == "")
                                        {
                                            dbClient.Close();
                                            return;
                                        }
                                        int requestID = Encoding.decodeVL64(currentPacket);
                                        int fromUserID = dbClient.getInteger("SELECT userid_from FROM messenger_friendrequests WHERE userid_to = '" + this.userID + "' AND requestid = '" + requestID + "'");
                                        if (fromUserID == 0) // Corrupt data
                                        {
                                            dbClient.Close();
                                            return;
                                        }

                                        virtualBuddy Buddy = new virtualBuddy(fromUserID);
                                        Updates.Append(Buddy.ToString(true));
                                        updateAmount++;

                                        Messenger.addBuddy(Buddy, false);
                                        if (userManager.containsUser(fromUserID))
                                            userManager.getUser(fromUserID).Messenger.addBuddy(Me, true);

                                        dbClient.runQuery("INSERT INTO messenger_friendships(userid,friendid) VALUES ('" + fromUserID + "','" + this.userID + "')");
                                        dbClient.runQuery("DELETE FROM messenger_friendrequests WHERE userid_to = '" + this.userID + "' AND requestid = '" + requestID + "' LIMIT 1");
                                        currentPacket = currentPacket.Substring(Encoding.encodeVL64(requestID).Length);
                                    }
                                    dbClient.Close();

                                    if (updateAmount > 0)
                                        sendData("@M" + "HI" + Encoding.encodeVL64(updateAmount) + Updates.ToString());
                                }
                                break;
                            }

                        case "@f": // Messenger - decline friendrequests
                            {
                                if (Messenger != null)
                                {
                                    int Amount = Encoding.decodeVL64(currentPacket.Substring(3));
                                    currentPacket = currentPacket.Substring(Encoding.encodeVL64(Amount).Length + 3);

                                    Database dbClient = new Database(true, false, 144);
                                    for (int i = 0; i < Amount; i++)
                                    {
                                        if (currentPacket == "")
                                        {
                                            dbClient.Close();
                                            return;
                                        }
                                        int requestID = Encoding.decodeVL64(currentPacket);
                                        dbClient.runQuery("DELETE FROM messenger_friendrequests WHERE userid_to = '" + this.userID + "' AND requestid = '" + requestID + "' LIMIT 1");
                                        currentPacket = currentPacket.Substring(Encoding.encodeVL64(requestID).Length);
                                    }
                                    dbClient.Close();
                                }
                                break;
                            }  

                        case "@h": // Messenger - remove buddy from friendlist
                            {
                                if (Messenger != null)
                                {
                                    int buddyID = Encoding.decodeVL64(currentPacket.Substring(3));
                                    Messenger.removeBuddy(buddyID);
                                    if (userManager.containsUser(buddyID))
                                        userManager.getUser(buddyID).Messenger.removeBuddy(userID);
                                    Database dbClient = new Database(true, true, 145);
                                    dbClient.runQuery("DELETE FROM messenger_friendships WHERE (userid = '" + userID + "' AND friendid = '" + buddyID + "') OR (userid = '" + buddyID + "' AND friendid = '" + userID + "') LIMIT 1");
                                }
                                break;
                            }

                        case "@a": // Messenger - send instant message to buddy
                            {
                                if (Messenger != null)
                                {
                                    int buddyID = Encoding.decodeVL64(currentPacket.Substring(2));
                                    string Message = currentPacket.Substring(Encoding.encodeVL64(buddyID).Length + 4);
                                    Message = stringManager.filterSwearwords(Message); // Filter swearwords

                                    if (Messenger.containsOnlineBuddy(buddyID)) // Buddy online
                                        userManager.getUser(buddyID).sendData("BF" + Encoding.encodeVL64(userID) + Message + Convert.ToChar(2));
                                    else // Buddy offline (or user doesn't has user in buddylist)
                                        sendData("DE" + Encoding.encodeVL64(5) + Encoding.encodeVL64(userID));
                                }
                                break;
                            }

                        case "@O": // Messenger - refresh friendlist
                            {
                                if (Messenger != null)
                                    sendData("@M" + Messenger.getUpdates());
                                break;
                            }

                        case "DF": // Messenger - follow buddy to a room
                            {
                                if (Messenger != null)
                                {
                                    int ID = Encoding.decodeVL64(currentPacket.Substring(2));
                                    int errorID = -1;
                                    if (Messenger.hasFriendship(ID)) // Has friendship with user
                                    {
                                        if (userManager.containsUser(ID)) // User is online
                                        {
                                            virtualUser _User = userManager.getUser(ID);
                                            if (_User._roomID > 0) // User is in room
                                            {
                                                if (_User._inPublicroom)
                                                    sendData("D^" + "I" + Encoding.encodeVL64(_User._roomID));
                                                else
                                                    sendData("D^" + "H" + Encoding.encodeVL64(_User._roomID));
                                            }
                                            else // User is not in a room
                                                errorID = 2;
                                        }
                                        else // User is offline
                                            errorID = 1;
                                    }
                                    else // User is not this virtual user's friend
                                        errorID = 0;

                                    if (errorID != -1) // Error occured
                                        sendData("E]" + Encoding.encodeVL64(errorID));
                                }
                                break;
                            }

                        case "@b": // Messenger - invite buddies to your room
                            {
                                if (Messenger != null && roomUser != null)
                                {
                                    int Amount = Encoding.decodeVL64(currentPacket.Substring(2));
                                    int[] IDs = new int[Amount];
                                    currentPacket = currentPacket.Substring(Encoding.encodeVL64(Amount).Length + 2);

                                    for (int i = 0; i < Amount; i++)
                                    {
                                        if (currentPacket == "")
                                            return;

                                        int ID = Encoding.decodeVL64(currentPacket);
                                        if (Messenger.hasFriendship(ID) && userManager.containsUser(ID))
                                            IDs[i] = ID;

                                        currentPacket = currentPacket.Substring(Encoding.encodeVL64(ID).Length);
                                    }

                                    string Message = currentPacket.Substring(2);
                                    string Data = "BG" + Encoding.encodeVL64(userID) + Message + Convert.ToChar(2);
                                    for (int i = 0; i < Amount; i++)
                                        userManager.getUser(IDs[i]).sendData(Data);
                                }
                                break;
                            }

                        #endregion

                        #region Navigator actions
                        case "BV": // Navigator - navigate through rooms and categories
                            {
                                int hideFull = Encoding.decodeVL64(currentPacket.Substring(2, 1));
                                int cataID = Encoding.decodeVL64(currentPacket.Substring(3));

                                Database dbClient = new Database(true, false, 146);
                                string Name = dbClient.getString("SELECT name FROM room_categories WHERE id = '" + cataID + "' AND (access_rank_min <= " + _Rank + " OR access_rank_hideforlower = '0')");
                                if (Name == "") // User has no access to this category/it does not exist
                                {
                                    dbClient.Close();
                                    return;
                                }
                                int Type = dbClient.getInteger("SELECT type FROM room_categories WHERE id = '" + cataID + "'");
                                int parentID = dbClient.getInteger("SELECT parent FROM room_categories WHERE id = '" + cataID + "'");

                                StringBuilder Navigator = new StringBuilder(@"C\" + Encoding.encodeVL64(hideFull) + Encoding.encodeVL64(cataID) + Encoding.encodeVL64(Type) + Name + Convert.ToChar(2) + Encoding.encodeVL64(0) + Encoding.encodeVL64(10000) + Encoding.encodeVL64(parentID));
                                string _SQL_ORDER_HELPER = "";
                                if (Type == 0) // Publicrooms
                                {
                                    if (hideFull == 1)
                                        _SQL_ORDER_HELPER = "AND visitors_now < visitors_max ORDER BY id ASC";
                                    else
                                        _SQL_ORDER_HELPER = "ORDER BY id ASC";
                                }
                                else // Guestrooms
                                {
                                    if (hideFull == 1)
                                        _SQL_ORDER_HELPER = "AND visitors_now < visitors_max ORDER BY visitors_now DESC LIMIT 30";
                                    else
                                        _SQL_ORDER_HELPER = "ORDER BY visitors_now DESC LIMIT " + Config.Navigator_openCategory_maxResults;
                                }

                                DataTable dTable = dbClient.getTable("SELECT id,state,showname,visitors_now,visitors_max,name,description,owner,ccts FROM rooms WHERE category = '" + cataID + "' " + _SQL_ORDER_HELPER);
                                if (Type == 2) // Guestrooms
                                    Navigator.Append(Encoding.encodeVL64(dTable.Rows.Count));

                                bool canSeeHiddenNames = false;

                                if (Type != 0) // Publicroom
                                    canSeeHiddenNames = rankManager.containsRight(_Rank, "fuse_enter_locked_rooms");

                                foreach (DataRow dRow in dTable.Rows)
                                {
                                    if (Type == 0)
                                        Navigator.Append(Encoding.encodeVL64(Convert.ToInt32(dRow["id"])) + "I" + Convert.ToString(dRow["name"]) + Convert.ToChar(2) + Encoding.encodeVL64(Convert.ToInt32(dRow["visitors_now"])) + Encoding.encodeVL64(Convert.ToInt32(dRow["visitors_max"])) + Encoding.encodeVL64(cataID) + Convert.ToString(dRow["description"]) + Convert.ToChar(2) + Encoding.encodeVL64(Convert.ToInt32(dRow["id"])) + "H" + Convert.ToString(dRow["ccts"]) + Convert.ToChar(2) + "HI");
                                    else
                                    {
                                        if (Convert.ToInt32(dRow["showname"]) == 0 && canSeeHiddenNames == false)
                                            continue;
                                        else
                                            Navigator.Append(Encoding.encodeVL64(Convert.ToInt32(dRow["id"])) + Convert.ToString(dRow["name"]) + Convert.ToChar(2) + Convert.ToString(dRow["owner"]) + Convert.ToChar(2) + roomManager.getRoomState(Convert.ToInt32(dRow["state"])) + Convert.ToChar(2) + Encoding.encodeVL64(Convert.ToInt32(dRow["visitors_now"])) + Encoding.encodeVL64(Convert.ToInt32(dRow["visitors_max"])) + Convert.ToString(dRow["description"]) + Convert.ToChar(2));
                                    }
                                }

                                DataColumn dCol = dbClient.getColumn("SELECT id FROM room_categories WHERE parent = '" + cataID + "' AND (access_rank_min <= " + _Rank + " OR access_rank_hideforlower = '0') ORDER BY id ASC");
                                if (dCol.Table.Rows.Count > 0) // Sub categories
                                {
                                    StringBuilder sb = new StringBuilder();
                                    System.Collections.Generic.List<int> emptyIDs = new System.Collections.Generic.List<int>();

                                    foreach (DataRow dRow in dCol.Table.Rows)
                                    {
                                        sb.Append(" OR category = '" + Convert.ToString(dRow[0]) + "'");
                                        emptyIDs.Add(Convert.ToInt32(dRow[0]));
                                    }
                                    dTable = dbClient.getTable("SELECT SUM(visitors_now),SUM(visitors_max),category FROM rooms WHERE" + sb.ToString().Substring(3) + " GROUP BY category");

                                    foreach (DataRow dRow in dTable.Rows)
                                    {
                                        if (Convert.ToInt32(dRow[1]) > 0 && hideFull == 1 && Convert.ToInt32(dRow[0]) >= Convert.ToInt32(dRow[1]))
                                            continue;

                                        Navigator.Append(Encoding.encodeVL64(Convert.ToInt32(dRow[2])) + "H" + dbClient.getString("SELECT name FROM room_categories WHERE id = '" + Convert.ToString(dRow[2]) + "'") + Convert.ToChar(2) + Encoding.encodeVL64(Convert.ToInt32(dRow[0])) + Encoding.encodeVL64(Convert.ToInt32(dRow[1])) + Encoding.encodeVL64(cataID));
                                        emptyIDs.Remove(Convert.ToInt32(dRow[2]));
                                    }

                                    foreach (int emptyID in emptyIDs)
                                        Navigator.Append(Encoding.encodeVL64(emptyID) + "H" + dbClient.getString("SELECT name FROM room_categories WHERE id = '" + emptyID + "'") + Convert.ToChar(2) + "HH" + Encoding.encodeVL64(cataID));
                                }
                                dbClient.Close();

                                sendData(Navigator.ToString());
                                break;
                            }

                        case "BW": // Navigator - request index of categories to place guestroom on
                            {
                                StringBuilder Categories = new StringBuilder();
                                Database dbClient = new Database(true, true, 147);
                                DataTable dTable = dbClient.getTable("SELECT id,name FROM room_categories WHERE type = '2' AND parent > 0 AND access_rank_min <= " + _Rank);
                                
                                foreach(DataRow dRow in dTable.Rows)
                                    Categories.Append(Encoding.encodeVL64(Convert.ToInt32(dRow["id"])) + dRow["name"] + Convert.ToChar(2));

                                sendData("C]" + Encoding.encodeVL64(dTable.Rows.Count) + Categories.ToString());
                                break;
                            }

                        case "DH": // Navigator - refresh recommended rooms (random guestrooms)
                            {
                                string Rooms = "";
                                Database dbClient = new Database(true, true, 148);
                                DataTable dTable = dbClient.getTable("SELECT id,name,owner,description,state,visitors_now,visitors_max FROM rooms WHERE NOT(owner IS NULL) ORDER BY RAND() LIMIT 3");
                                foreach(DataRow dRow in dTable.Rows)
                                    Rooms += Encoding.encodeVL64(Convert.ToInt32(dRow["id"])) + Convert.ToString(dRow["name"]) + Convert.ToChar(2) + Convert.ToString(dRow["owner"]) + Convert.ToChar(2) + roomManager.getRoomState(Convert.ToInt32(dRow["state"])) + Convert.ToChar(2) + Encoding.encodeVL64(Convert.ToInt32(dRow["visitors_now"])) + Encoding.encodeVL64(Convert.ToInt32(dRow["visitors_max"])) + Convert.ToString(dRow["description"]) + Convert.ToChar(2);
                                
                                sendData("E_" + Encoding.encodeVL64(3) + Rooms);
                                break;
                            }

                        case "@P": // Navigator - view user's own guestrooms
                            {
                                Database dbClient = new Database(true, true, 149);
                                DataTable dTable = dbClient.getTable("SELECT id,name,description,state,showname,visitors_now,visitors_max FROM rooms WHERE owner = '" + _Username + "' ORDER BY id ASC");
                                if (dTable.Rows.Count > 0)
                                {
                                    StringBuilder Rooms = new StringBuilder();
                                    foreach (DataRow dRow in dTable.Rows)
                                        Rooms.Append(Convert.ToString(dRow["id"]) + "\t" + Convert.ToString(dRow["name"]) + Convert.ToChar(9) + _Username + Convert.ToChar(9) + roomManager.getRoomState(Convert.ToInt32(dRow["state"])) + Convert.ToChar(9) + "x" + Convert.ToChar(9) + Convert.ToString(dRow["visitors_now"]) + Convert.ToChar(9) + Convert.ToString(dRow["visitors_max"]) + Convert.ToChar(9) + "null" + Convert.ToChar(9) + Convert.ToString(dRow["description"]) + Convert.ToChar(9) + Convert.ToString(dRow["description"]) + Convert.ToChar(9) + Convert.ToChar(13));
                                    sendData("@P" + Rooms.ToString());
                                }
                                else
                                {
                                    sendData("@y" + _Username);
                                }                               
                                break;
                            }

                        case "@Q": // Navigator - perform guestroom search on name/owner with a given criticeria
                            {
                                bool seeAllRoomOwners = rankManager.containsRight(_Rank, "fuse_see_all_roomowners");
                                Database dbClient = new Database(false, true, 150);
                                dbClient.addParameterWithValue("search", currentPacket.Substring(2));
                                dbClient.addParameterWithValue("max", Config.Navigator_roomSearch_maxResults);
                                dbClient.Open();
                                DataTable dTable = dbClient.getTable("SELECT id,name,owner,description,state,showname,visitors_now,visitors_max FROM rooms WHERE NOT(owner IS NULL) AND (owner = @search OR name LIKE '%@search%') ORDER BY id ASC LIMIT @max");
                                if (dTable.Rows.Count > 0)
                                {
                                    StringBuilder Rooms = new StringBuilder();
                                    string nameString;
                                    foreach (DataRow dRow in dTable.Rows)
                                    {
                                        nameString = Convert.ToString(dRow["owner"]);
                                        if (Convert.ToString(dRow["showname"]) == "0" && Convert.ToString(dRow["owner"]) != _Username && seeAllRoomOwners == false)// The room owner has hidden his name at the guestroom and this user hasn't got the fuseright to see all room owners
                                            nameString = "-";
                                        Rooms.Append(Convert.ToString(dRow["id"]) + Convert.ToChar(9) + Convert.ToString(dRow["name"]) + Convert.ToChar(9) + Convert.ToString(dRow["owner"]) + Convert.ToChar(9) + roomManager.getRoomState(Convert.ToInt32(dRow["state"])) + Convert.ToChar(9) + "x" + Convert.ToChar(9) + Convert.ToString(dRow["visitors_now"]) + Convert.ToChar(9) + Convert.ToString(dRow["visitors_max"]) + Convert.ToChar(9) + "null" + Convert.ToChar(9) + Convert.ToString(dRow["description"]) + Convert.ToChar(9) + Convert.ToChar(13));
                                    }
                                    sendData("@w" + Rooms.ToString());
                                }
                                else
                                    sendData("@z");
                                dbClient.Close();
                                break;
                            }

                        case "@U": // Navigator - get guestroom details
                            {
                                Database dbClient = new Database(true, false, 151);
                                int roomID = int.Parse(currentPacket.Substring(2));
                                DataRow dRow = dbClient.getRow("SELECT name,owner,description,model,state,superusers,showname,category,visitors_now,visitors_max FROM rooms WHERE id = '" + roomID + "' AND NOT(owner IS NULL)");

                                if (dRow.Table.Rows.Count > 0) // Guestroom does exist
                                {
                                    StringBuilder Details = new StringBuilder(Encoding.encodeVL64(Convert.ToInt32(dRow[5])) + Encoding.encodeVL64(Convert.ToInt32(dRow[4])) + Encoding.encodeVL64(roomID));
                                    if (Convert.ToString(dRow[6]) == "0" && rankManager.containsRight(_Rank, "fuse_see_all_roomowners")) // The room owner has decided to hide his name at this room, and this user hasn't got the fuseright to see all room owners, hide the name
                                        Details.Append("-");
                                    else
                                        Details.Append(Convert.ToString(dRow[1]));

                                    Details.Append(Convert.ToChar(2) + "model_" + Convert.ToString(dRow[3]) + Convert.ToChar(2) + Convert.ToString(dRow[0]) + Convert.ToChar(2) + Convert.ToString(dRow[2]) + Convert.ToChar(2) + Encoding.encodeVL64(Convert.ToInt32(dRow[6])));
                                    if (dbClient.findsResult("SELECT id FROM room_categories WHERE id = '" + Convert.ToString(dRow[7]) + "' AND trading = '1'"))
                                        Details.Append("I"); // Allow trading
                                    else
                                        Details.Append("H"); // Disallow trading

                                    Details.Append(Encoding.encodeVL64(Convert.ToInt32(dRow[8])) + Encoding.encodeVL64(Convert.ToInt32(dRow[9])));
                                    sendData("@v" + Details.ToString());
                                }
                                dbClient.Close();
                                break;
                            }

                        case "@R": // Navigator - initialize user's favorite rooms
                            {
                                Database dbClient = new Database(true, false, 152);
                                DataColumn dCol = dbClient.getColumn("SELECT roomid FROM users_favourites WHERE userid = '" + userID + "' ORDER BY roomid DESC LIMIT " + Config.Navigator_Favourites_maxRooms);
                                System.Collections.Hashtable deletedIDs = new System.Collections.Hashtable(dCol.Table.Rows.Count);

                                string roomIDs = "    ";
                                foreach (DataRow dRow in dCol.Table.Rows)
                                {
                                    deletedIDs.Add(Convert.ToInt32(dRow["roomid"]), Convert.ToInt32(dRow["roomid"]));
                                    roomIDs += "id = '" + Convert.ToString(dRow["roomid"]) + "' OR ";
                                }
                                roomIDs = roomIDs.Substring(0, roomIDs.Length - 4);
                                if (roomIDs.Length > 0)
                                {
                                    int guestRoomAmount = 0;
                                    string nameString; 
                                    bool seeHiddenRoomOwners = rankManager.containsRight(_Rank, "fuse_enter_locked_rooms");
                                    StringBuilder Rooms = new StringBuilder();
                                    DataTable dTable = dbClient.getTable("SELECT name,owner,state,showname,visitors_now,visitors_max,description,category,ccts,id FROM rooms WHERE " + roomIDs);
                                    foreach (DataRow dRow in dTable.Rows)
                                    {
                                        deletedIDs.Remove(Convert.ToInt32(dRow["id"]));

                                        if (Convert.ToString(dRow[1]) == "")
                                            Rooms.Append(Encoding.encodeVL64(Convert.ToInt32(dRow["id"])) + "I" + Convert.ToString(dRow[0]) + Convert.ToChar(2) + Encoding.encodeVL64(Convert.ToInt32(dRow[4])) + Encoding.encodeVL64(Convert.ToInt32(dRow[5])) + Encoding.encodeVL64(Convert.ToInt32(dRow[7])) + Convert.ToString(dRow[6]) + Convert.ToChar(2) + Encoding.encodeVL64(Convert.ToInt32(dRow["id"])) + "H" + Convert.ToString(dRow[8]) + Convert.ToChar(2) + "HI");
 
                                        else // Guestroom
                                        {
                                            nameString = Convert.ToString(dRow[0]);
                                            if (Convert.ToString(dRow[3]) == "0" && _Username != Convert.ToString(dRow[1]) && seeHiddenRoomOwners == false) // Room owner doesn't wish to show his name, and this user isn't the room owner and this user doesn't has the right to see hidden room owners, change room owner to '-'
                                                nameString = "-";
                                            Rooms.Append(Encoding.encodeVL64(Convert.ToInt32(dRow["id"])) + nameString + Convert.ToChar(2) + Convert.ToString(dRow[1]) + Convert.ToChar(2) + roomManager.getRoomState(Convert.ToInt32(dRow[2])) + Convert.ToChar(2) + Encoding.encodeVL64(Convert.ToInt32(dRow[4])) + Encoding.encodeVL64(Convert.ToInt32(dRow[5])) + Convert.ToString(dRow[6]) + Convert.ToChar(2));
                                            guestRoomAmount++;
                                        }
                                    }
                                    foreach (int rID in deletedIDs.Values)
                                        dbClient.runQuery("DELETE FROM users_favourites WHERE roomid = '" + rID + "' LIMIT 1");
                                    dbClient.Close();
                                    sendData("@}" + "HHJ" + Convert.ToChar(2) + "HHH" + Encoding.encodeVL64(guestRoomAmount - deletedIDs.Count) + Rooms.ToString());
                                }
                                break;
                            }

                        case "@S": // Navigator - add room to favourite rooms list
                            {
                                int roomID = Encoding.decodeVL64(currentPacket.Substring(3));
                                Database dbClient = new Database(true, false, 153);
                                if (dbClient.findsResult("SELECT id FROM rooms WHERE id = '" + roomID + "'") == true && dbClient.findsResult("SELECT userid FROM users_favourites WHERE userid = '" + userID + "' AND roomid = '" + roomID + "'") == false) // The virtual room does exist, and the virtual user hasn't got it in the list already
                                {
                                    if (dbClient.getInteger("SELECT COUNT(userid) FROM users_favourites WHERE userid = '" + userID + "'") < Config.Navigator_Favourites_maxRooms)
                                        dbClient.runQuery("INSERT INTO users_favourites (userid,roomid) VALUES ('" + userID + "','" + roomID + "')");
                                    else
                                        sendData("@a" + "nav_error_toomanyfavrooms");
                                }
                                dbClient.Close();
                                break;
                            }
                        case "@T": // Navigator - remove room from favourite rooms list
                            {
                                int roomID = Encoding.decodeVL64(currentPacket.Substring(3));
                                Database dbClient = new Database(true, true, 154);
                                dbClient.runQuery("DELETE FROM users_favourites WHERE userid = '" + userID + "' AND roomid = '" + roomID + "' LIMIT 1");
                                break;
                            }

                        #endregion

                        #region Room event actions
                        case "EA": // Events - get setup
                            sendData("Ep" + Encoding.encodeVL64(eventManager.categoryAmount));
                            break;

                        case "EY": // Events - show/hide 'Host event' button
                            if (_inPublicroom || roomUser == null || _hostsEvent) // In publicroom, not in room at all or already hosting event
                                sendData("Eo" + "H"); // Hide
                            else
                                sendData("Eo" + "I"); // Show
                            break;

                        case "D{": // Events - check if event category is OK
                            {
                                int categoryID = Encoding.decodeVL64(currentPacket.Substring(2));
                                if (eventManager.categoryOK(categoryID))
                                    sendData("Eb" + Encoding.encodeVL64(categoryID));
                                break;
                            }

                        case "E^": // Events - open category
                            {
                                int categoryID = Encoding.decodeVL64(currentPacket.Substring(2));
                                if (categoryID >= 1 && categoryID <= 11)
                                    sendData("Eq" + Encoding.encodeVL64(categoryID) + eventManager.getEvents(categoryID));
                                break;
                            }

                        case "EZ": // Events - create event
                            {
                                if (_isOwner && _hostsEvent == false && _inPublicroom == false && roomUser != null)
                                {
                                    int categoryID = Encoding.decodeVL64(currentPacket.Substring(2));
                                    if (eventManager.categoryOK(categoryID))
                                    {
                                        int categoryLength = Encoding.encodeVL64(categoryID).Length;
                                        int nameLength = Encoding.decodeB64(currentPacket.Substring(categoryLength + 2, 2));
                                        string Name = currentPacket.Substring(categoryLength + 4, nameLength);
                                        string Description = currentPacket.Substring(categoryLength + nameLength + 6);

                                        _hostsEvent = true;
                                        eventManager.createEvent(categoryID, userID, _roomID, Name, Description);
                                        Room.sendData("Er" + eventManager.getEvent(_roomID));
                                    }
                                }
                                break;
                            }

                        case @"E\": // Events - edit event
                            {
                                if (_hostsEvent && _isOwner && _inPublicroom == false && roomUser != null)
                                {
                                    int categoryID = Encoding.decodeVL64(currentPacket.Substring(2));
                                    if (eventManager.categoryOK(categoryID))
                                    {
                                        int categoryLength = Encoding.encodeVL64(categoryID).Length;
                                        int nameLength = Encoding.decodeB64(currentPacket.Substring(categoryLength + 2, 2));
                                        string Name = currentPacket.Substring(categoryLength + 4, nameLength);
                                        string Description = currentPacket.Substring(categoryLength + nameLength + 6);

                                        eventManager.editEvent(categoryID, _roomID, Name, Description);
                                        Room.sendData("Er" + eventManager.getEvent(_roomID));
                                    }
                                }
                                break;
                            }

                        case "E[": // Events - end event
                            {
                                if (_hostsEvent && _isOwner && _inPublicroom == false && roomUser != null)
                                {
                                    _hostsEvent = false;
                                    eventManager.removeEvent(_roomID);
                                    Room.sendData("Er" + "-1");
                                }
                                break;
                            }

                        #endregion

                        #region Guestroom create and modify
                        case "@]": // Create guestroom - phase 1
                            {
                                Database dbClient = new Database(true, true, 155);
                                if (dbClient.getInteger("SELECT COUNT(id) FROM rooms WHERE owner = '" + _Username + "'") < Config.Navigator_createRoom_maxRooms)
                                {                                    
                                    string[] roomSettings = currentPacket.Split('/');
                                    roomSettings[2] = stringManager.filterSwearwords(roomSettings[2]);
                                    roomSettings[3] = roomSettings[3].Substring(6, 1);
                                    roomSettings[4] = roomManager.getRoomState(roomSettings[4]).ToString();
                                    if (roomSettings[5] != "0" && roomSettings[5] != "1")
                                        return;
                                    dbClient = new Database(false, false, 156);
                                    dbClient.addParameterWithValue("rs2", roomSettings[2]);
                                    dbClient.addParameterWithValue("user", _Username);
                                    dbClient.addParameterWithValue("rs3", roomSettings[3]);
                                    dbClient.addParameterWithValue("rs4", roomSettings[4]);
                                    dbClient.addParameterWithValue("rs5", roomSettings[5]);
                                    dbClient.Open();
                                    dbClient.runQuery("INSERT INTO rooms (name, owner, model, state, showname) VALUES (@rs2,@user,@rs3,@rs4,@rs5)");
                                    string roomID = dbClient.getString("SELECT MAX(id) FROM rooms WHERE owner = @user");
                                    dbClient.Close();
                                    sendData("@{" + roomID + Convert.ToChar(13) + roomSettings[2]);
                                }
                                else
                                    sendData("@a" + "Error creating a private room");
                                break;
                            }

                        case "@Y": // Create guestroom - phase 2 / modify guestroom
                            {
                                int roomID = 0;
                                if (currentPacket.Substring(2, 1) == "/")
                                    roomID = int.Parse(currentPacket.Split('/')[1]);
                                else
                                    roomID = int.Parse(currentPacket.Substring(2).Split('/')[0]);

                                string superUsers = "0";
                                int maxVisitors = 25;
                                string[] packetContent = currentPacket.Split(Convert.ToChar(13));
                                string roomDescription = "";
                                string roomPassword = "";

                                for (int i = 1; i < packetContent.Length; i++) // More proper way, thanks Jeax
                                {
                                    string updHeader = packetContent[i].Split('=')[0];
                                    string updValue = packetContent[i].Substring(updHeader.Length + 1);
                                    switch (updHeader)
                                    {
                                        case "description":
                                            roomDescription = stringManager.filterSwearwords(updValue);
                                            break;

                                        case "allsuperuser":
                                            superUsers = updValue;
                                            if (superUsers != "0" && superUsers != "1")
                                                superUsers = "0";
                                            
                                            break;

                                        case "maxvisitors":
                                            maxVisitors = int.Parse(updValue);
                                            if (maxVisitors < 10 || maxVisitors > 25)
                                                maxVisitors = 25;
                                            break;

                                        case "password":
                                            roomPassword = updValue;
                                            break;

                                        default:
                                            return;
                                    }
                                }
                                Database dbClient = new Database(false, true,78);
                                dbClient.addParameterWithValue("desc", roomDescription);
                                dbClient.addParameterWithValue("super", superUsers);
                                dbClient.addParameterWithValue("max", maxVisitors);
                                dbClient.addParameterWithValue("pass", roomPassword);
                                dbClient.addParameterWithValue("id", roomID);
                                dbClient.addParameterWithValue("owner", _Username);
                                dbClient.Open();
                                dbClient.runQuery("UPDATE rooms SET description = @desc,superusers = @super,visitors_max = @max, password = @pass WHERE id = @id AND owner = @owner LIMIT 1");
                                break;
                            }

                        case "@X": // Modify guestroom, save name, state and show/hide ownername
                            {
                                string[] packetContent = currentPacket.Substring(2).Split('/');
                                if (packetContent[3] != "1" && packetContent[2] != "0")
                                    packetContent[2] = "1";
                                Database dbClient = new Database(false, true, 79);
                                dbClient.addParameterWithValue("name", stringManager.filterSwearwords(packetContent[1]));
                                dbClient.addParameterWithValue("state", roomManager.getRoomState(packetContent[2]));
                                dbClient.addParameterWithValue("show", packetContent[3]);
                                dbClient.addParameterWithValue("id", packetContent[0]);
                                dbClient.addParameterWithValue("owner", _Username);
                                dbClient.Open();
                                dbClient.runQuery("UPDATE rooms SET name = @name,state = @state,showname = @show WHERE id = @id AND owner = @owner LIMIT 1");
                                break;
                            }

                        case "BX": // Navigator - trigger guestroom modify
                            {
                                int roomID = Encoding.decodeVL64(currentPacket.Substring(2));
                                Database dbClient = new Database(true, true, 80);
                                string roomCategory = dbClient.getString("SELECT category FROM rooms WHERE id = '" + roomID + "' AND owner = '" + _Username + "'");
                                if (roomCategory != "")
                                    sendData("C^" + Encoding.encodeVL64(roomID) + Encoding.encodeVL64(int.Parse(roomCategory)));
                                break;
                            }

                        case "BY": // Navigator - edit category of a guestroom
                            {
                                int roomID = Encoding.decodeVL64(currentPacket.Substring(2));
                                int cataID = Encoding.decodeVL64(currentPacket.Substring(Encoding.encodeVL64(roomID).Length + 2));
                                Database dbClient = new Database(true, false, 81);
                                if (dbClient.findsResult("SELECT id FROM room_categories WHERE id = '" + cataID + "' AND type = '2' AND parent > 0 AND access_rank_min <= " + _Rank)) // Category is valid for this user
                                    dbClient.runQuery("UPDATE rooms SET category = '" + cataID + "' WHERE id = '" + roomID + "' AND owner = '" + _Username + "' LIMIT 1");
                                dbClient.Close();
                                break;
                            }

                        case "@W": // Guestroom - Delete
                            {
                                int roomID = int.Parse(currentPacket.Substring(2));
                                Database dbClient = new Database(true, false, 82);
                                if (dbClient.findsResult("SELECT id FROM rooms WHERE id = '" + roomID + "' AND owner = '" + _Username + "'") == true)
                                {
                                    dbClient.runQuery("DELETE FROM room_rights WHERE roomid = '" + roomID + "'");
                                    dbClient.runQuery("DELETE FROM rooms WHERE id = '" + roomID + "' LIMIT 1");
                                    dbClient.runQuery("DELETE FROM room_votes WHERE roomid = '" + roomID + "'");
                                    dbClient.runQuery("DELETE FROM room_bans WHERE roomid = '" + roomID + "' LIMIT 1");
                                    dbClient.runQuery("DELETE FROM furniture WHERE roomid = '" + roomID + "'");
                                    dbClient.runQuery("DELETE FROM furniture_moodlight WHERE roomid = '" + roomID + "'");
                                }
                                dbClient.Close();
                                if (roomManager.containsRoom(roomID) == true)
                                {
                                    roomManager.getRoom(roomID).kickUsers(byte.Parse("9"), "This room has been deleted");
                                }
                                break;
                            }

                        case "BZ": // Navigator - 'Who's in here' feature for public rooms
                            {
                                int roomID = Encoding.decodeVL64(currentPacket.Substring(2));
                                if (roomManager.containsRoom(roomID))
                                    sendData("C_" + roomManager.getRoom(roomID).Userlist);
                                else
                                    sendData("C_");
                                break;
                            }
                        #endregion

                        #region Enter/leave room
                        case "@u": // Rooms - eave room
                            {
                                if (Room != null && roomUser != null)
                                    Room.removeUser(roomUser.roomUID, false, "");
                                else
                                {
                                    if (gamePlayer != null)
                                        leaveGame();
                                }
                                break;
                            }

                        case "Bv": // Enter room - loading screen advertisement
                            {
                                Config.Rooms_LoadAvertisement_img = "";
                                if (Config.Rooms_LoadAvertisement_img == "")
                                    sendData("DB0");
                                else
                                    sendData("DB" + Config.Rooms_LoadAvertisement_img + Convert.ToChar(9) + Config.Rooms_LoadAvertisement_uri);
                            }
                            break;

                        case "@B": // Enter room - determine room and check state + max visitors override
                            {
                                int roomID = Encoding.decodeVL64(currentPacket.Substring(3));
                                bool isPublicroom = (currentPacket.Substring(2, 1) == "A");

                                sendData("@S");
                                sendData("Bf" + "http://wwww.holographemulator.com/bf.php?p=emu");

                                if (gamePlayer != null && gamePlayer.Game != null)
                                {
                                    if (gamePlayer.enteringGame)
                                    {
                                        Room.removeUser(roomUser.roomUID, false, "");
                                        sendData("AE" + gamePlayer.Game.Lobby.Type + "_arena_" + gamePlayer.Game.mapID + " " + roomID);
                                        sendData("Cs" + gamePlayer.Game.getMap());
                                        string s = gamePlayer.Game.getMap();
                                    }
                                    else
                                        leaveGame();
                                }
                                else
                                {
                                    if (Room != null && roomUser != null)
                                        Room.removeUser(roomUser.roomUID, false, "");

                                    Database dbClient = new Database(true, false, 83);
                                    if (_teleporterID == 0)
                                    {
                                        bool allowEnterLockedRooms = rankManager.containsRight(_Rank, "fuse_enter_locked_rooms");
                                        int accessLevel = dbClient.getInteger("SELECT state FROM rooms WHERE id = '" + roomID + "'");
                                        if (accessLevel == 3 && _clubMember == false && allowEnterLockedRooms == false) // Room is only for club subscribers and the user isn't club and hasn't got the fuseright for entering all rooms nomatter the state
                                        {
                                            sendData("C`" + "Kc");
                                            dbClient.Close();
                                            return;
                                        }
                                        else if (accessLevel == 4 && allowEnterLockedRooms == false) // The room is only for staff and the user hasn't got the fuseright for entering all rooms nomatter the state
                                        {
                                            sendData("BK" + stringManager.getString("room_stafflocked"));
                                            dbClient.Close();
                                            return;
                                        }

                                        int nowVisitors = dbClient.getInteger("SELECT SUM(visitors_now) FROM rooms WHERE id = '" + roomID + "'");
                                        if (nowVisitors > 0)
                                        {
                                            int maxVisitors = dbClient.getInteger("SELECT SUM(visitors_max) FROM rooms WHERE id = '" + roomID + "'");
                                            if (nowVisitors >= maxVisitors && rankManager.containsRight(_Rank, "fuse_enter_full_rooms") == false)
                                            {
                                                if (isPublicroom == false)
                                                    sendData("C`" + "I");
                                                else
                                                    sendData("BK" + stringManager.getString("room_full"));
                                                dbClient.Close();
                                                return;
                                            }
                                        }
                                    }

                                    _roomID = roomID;
                                    _inPublicroom = isPublicroom;
                                    _ROOMACCESS_PRIMARY_OK = true;

                                    if (isPublicroom)
                                    {
                                        string roomModel = dbClient.getString("SELECT model FROM rooms WHERE id = '" + roomID + "'");
                                        sendData("AE" + roomModel + " " + roomID);
                                        _ROOMACCESS_SECONDARY_OK = true;
                                    }
                                    dbClient.Close();
                                }
                                break;
                            }

                        case "@v": // Enter room - guestroom - enter room by using a teleporter
                            {
                                sendData("@S");
                                break;
                            }

                        case "@y": // Enter room - guestroom - check roomban/password/doorbell
                            {
                                if (_inPublicroom == false)
                                {
                                    Database dbClient = new Database(true, false, 84);
                                    _isOwner = dbClient.findsResult("SELECT id FROM rooms WHERE id = '" + _roomID + "' AND owner = '" + _Username + "'");
                                    if (_isOwner == false)
                                        _hasRights = dbClient.findsResult("SELECT userid FROM room_rights WHERE roomid = '" + _roomID + "' AND userid = '" + userID + "'");
                                    if (_hasRights == false)
                                        _hasRights = dbClient.findsResult("SELECT id FROM rooms WHERE id = '" + _roomID + "' AND superusers = '1'");

                                    if (_teleporterID == 0 && _isOwner == false && rankManager.containsRight(_Rank, "fuse_enter_locked_rooms") == false)
                                    {
                                        int accessFlag = dbClient.getInteger("SELECT state FROM rooms WHERE id = '" + _roomID + "'");
                                        if (_ROOMACCESS_PRIMARY_OK == false && accessFlag != 2)
                                        {
                                            dbClient.Close();
                                            return;
                                        }
                                        // Check for roombans
                                        if (dbClient.findsResult("SELECT roomid FROM room_bans WHERE roomid = '" + _roomID + "' AND userid = '" + userID + "'"))
                                        {
                                            DateTime banExpireMoment = DateTime.Parse(dbClient.getString("SELECT ban_expire FROM room_bans WHERE roomid = '" + _roomID + "' AND userid = '" + userID + "'"));
                                            if (DateTime.Compare(banExpireMoment, DateTime.Now) > 0)
                                            {
                                                sendData("C`" + "PA");
                                                sendData("@R");
                                                dbClient.Close();
                                                return;
                                            }
                                            else
                                                dbClient.runQuery("DELETE FROM room_bans WHERE roomid = '" + _roomID + "' AND userid = '" + userID + "' LIMIT 1");
                                        }

                                        if (accessFlag == 1) // Doorbell
                                        {
                                            if (roomManager.containsRoom(_roomID) == false)
                                            {
                                                sendData("BC");
                                                dbClient.Close();
                                                return;
                                            }
                                            else
                                            {
                                                roomManager.getRoom(_roomID).sendDataToRights("A[" + _Username);
                                                sendData("A[");
                                                dbClient.Close();
                                                return;
                                            }
                                        }
                                        else if (accessFlag == 2) // Password
                                        {
                                            string givenPassword = "";
                                            try { givenPassword = currentPacket.Split('/')[1]; }
                                            catch { }
                                            string roomPassword = dbClient.getString("SELECT password FROM rooms WHERE id = '" + _roomID + "'");
                                            if (givenPassword != roomPassword) { sendData("@a" + "Incorrect flat password"); dbClient.Close(); return; }
                                        }
                                    }
                                    dbClient.Close();
                                    _ROOMACCESS_SECONDARY_OK = true;
                                    sendData("@i");
                                }
                                break;
                            }

                        case "Ab": // Answer guestroom doorbell
                            {
                                if (_hasRights == false && rankManager.containsRight(roomUser.User._Rank, "fuse_enter_locked_rooms"))
                                    return;

                                string ringer = currentPacket.Substring(4, Encoding.decodeB64(currentPacket.Substring(2, 2)));
                                bool letIn = currentPacket.Substring(currentPacket.Length - 1) == "A";

                                virtualUser ringerData = userManager.getUser(ringer);
                                if (ringerData == null)
                                    return;
                                if (ringerData._roomID != _roomID)
                                    return;

                                if (letIn)
                                {
                                    ringerData._ROOMACCESS_SECONDARY_OK = true;
                                    Room.sendDataToRights("@i" + ringer + Convert.ToChar(2));
                                    ringerData.sendData("@i");
                                }
                                else
                                {
                                    ringerData.sendData("BC");
                                    ringerData._roomID = 0;
                                    ringerData._inPublicroom = false;
                                    ringerData._ROOMACCESS_PRIMARY_OK = false;
                                    ringerData._ROOMACCESS_SECONDARY_OK = false;
                                    ringerData._isOwner = false;
                                    ringerData._hasRights = false;
                                    ringerData.Room = null;
                                    ringerData.roomUser = null;
                                }
                                break;
                            }

                        case "@{": // Enter room - guestroom - guestroom only data: model, wallpaper, rights, room votes
                            {
                                if (_ROOMACCESS_SECONDARY_OK && _inPublicroom == false)
                                {
                                    Database dbClient = new Database(true, false, 85);
                                    DataRow dRow = dbClient.getRow("SELECT model, wallpaper, floor FROM rooms WHERE id = '" + _roomID + "'");
                                    string Model = "model_" + Convert.ToString(dRow["model"]);
                                    sendData("AE" + Model + " " + _roomID);

                                    int Wallpaper = Convert.ToInt32(dRow["wallpaper"]);
                                    int Floor = Convert.ToInt32(dRow["floor"]);
                                    if (Wallpaper > 0)
                                        sendData("@n" + "wallpaper/" + Wallpaper);
                                    if (Floor > 0)
                                        sendData("@n" + "floor/" + Floor);


                                    if (_isOwner == false)
                                    {
                                        _isOwner = rankManager.containsRight(_Rank, "fuse_any_room_controller");
                                    }
                                    if (_isOwner)
                                    {
                                        _hasRights = true;
                                        sendData("@o");
                                    }
                                    if (_hasRights)
                                        sendData("@j");

                                    int voteAmount = -1;
                                    if (dbClient.findsResult("SELECT userid FROM room_votes WHERE userid = '" + userID + "' AND roomid = '" + _roomID + "'"))
                                    {
                                        voteAmount = dbClient.getInteger("SELECT SUM(vote) FROM room_votes WHERE roomid = '" + _roomID + "'");
                                        if (voteAmount < 0) { voteAmount = 0; }
                                    }
                                    dbClient.Close();
                                    sendData("EY" + Encoding.encodeVL64(voteAmount));
                                    sendData("Er" + eventManager.getEvent(_roomID));
                                }
                                break;
                            }

                        case "A~": // Enter room - get room advertisement
                            {
                                Database dbClient = new Database(true, false, 86);
                                if (_inPublicroom && dbClient.findsResult("SELECT roomid FROM room_ads WHERE roomid = '" + _roomID + "'"))
                                {
                                    DataRow dRow = dbClient.getRow("SELECT img, uri FROM room_ads WHERE roomid = '" + _roomID + "'");
                                    string advImg = Convert.ToString(dRow["img"]);
                                    string advUri = Convert.ToString(dRow["uri"]);
                                    sendData("CP" + advImg + Convert.ToChar(9) + advUri);
                                }
                                else
                                    sendData("CP" + "0");
                                dbClient.Close();
                                break;
                            }

                        case "@|": // Enter room - get roomclass + get heightmap
                            {
                                if (_ROOMACCESS_SECONDARY_OK)
                                {
                                    if (roomManager.containsRoom(_roomID))
                                        Room = roomManager.getRoom(_roomID);
                                    else
                                    {
                                        Room = new virtualRoom(_roomID, _inPublicroom);
                                        roomManager.addRoom(_roomID, Room);
                                    }

                                    sendData("@_" + Room.Heightmap);
                                    sendData(@"@\" + Room.dynamicUnits);
                                }
                                else
                                {
                                    if (gamePlayer != null && gamePlayer.enteringGame && gamePlayer.teamID != -1 && gamePlayer.Game != null)
                                    {
                                        sendData("@_" + gamePlayer.Game.Heightmap);
                                        sendData("Cs" + gamePlayer.Game.getPlayers());
                                        string s = gamePlayer.Game.getPlayers();
                                    }
                                    gamePlayer.enteringGame = false;
                                }
                                break;
                            }

                        case "@}": // Enter room - get items
                            {
                                if (_ROOMACCESS_SECONDARY_OK && Room != null)
                                {
                                    sendData("@^" + Room.PublicroomItems);
                                    sendData("@`" + Room.Flooritems);
                                }
                                break;
                            }

                        case "@~": // Enter room - get group badges, optional skill levels in game lobbies and sprite index
                            {
                                    if (_ROOMACCESS_SECONDARY_OK && Room != null)
                                    {
                                        sendData("Du" + Room.Groups);
                                        if (Room.Lobby != null)
                                        {
                                            sendData("Cg" + "H" + Room.Lobby.Rank.Title + Convert.ToChar(2) + Encoding.encodeVL64(Room.Lobby.Rank.minPoints) + Encoding.encodeVL64(Room.Lobby.Rank.maxPoints));
                                            sendData("Cz" + Room.Lobby.playerRanks);
                                        }

                                        sendData("DiH");
                                        if (_receivedSpriteIndex == false)
                                        {
                                            /*
                                             * 
                                             * New sprite index
                                             * Added by Nillus
                                             * 
                                             */

                                            sendData("Dg" + @"YKEshelves_norjaX~Dshelves_polyfonYmAshelves_siloXQHtable_polyfon_smallYmAchair_polyfonZbBtable_norja_medY_Itable_silo_medX~Dtable_plasto_4legY_Itable_plasto_roundY_Itable_plasto_bigsquareY_Istand_polyfon_zZbBchair_siloX~Dsofa_siloX~Dcouch_norjaX~Dchair_norjaX~Dtable_polyfon_medYmAdoormat_loveZbBdoormat_plainZ[Msofachair_polyfonX~Dsofa_polyfonZ[Msofachair_siloX~Dchair_plastyX~Dchair_plastoYmAtable_plasto_squareY_Ibed_polyfonX~Dbed_polyfon_one[dObed_trad_oneYmAbed_tradYmAbed_silo_oneYmAbed_silo_twoYmAtable_silo_smallX~Dbed_armas_twoYmAbed_budget_oneXQHbed_budgetXQHshelves_armasYmAbench_armasYmAtable_armasYmAsmall_table_armasZbBsmall_chair_armasYmAfireplace_armasYmAlamp_armasYmAbed_armas_oneYmAcarpet_standardY_Icarpet_armasYmAcarpet_polarY_Ifireplace_polyfonY_Itable_plasto_4leg*1Y_Itable_plasto_bigsquare*1Y_Itable_plasto_round*1Y_Itable_plasto_square*1Y_Ichair_plasto*1YmAcarpet_standard*1Y_Idoormat_plain*1Z[Mtable_plasto_4leg*2Y_Itable_plasto_bigsquare*2Y_Itable_plasto_round*2Y_Itable_plasto_square*2Y_Ichair_plasto*2YmAdoormat_plain*2Z[Mcarpet_standard*2Y_Itable_plasto_4leg*3Y_Itable_plasto_bigsquare*3Y_Itable_plasto_round*3Y_Itable_plasto_square*3Y_Ichair_plasto*3YmAcarpet_standard*3Y_Idoormat_plain*3Z[Mtable_plasto_4leg*4Y_Itable_plasto_bigsquare*4Y_Itable_plasto_round*4Y_Itable_plasto_square*4Y_Ichair_plasto*4YmAcarpet_standard*4Y_Idoormat_plain*4Z[Mdoormat_plain*6Z[Mdoormat_plain*5Z[Mcarpet_standard*5Y_Itable_plasto_4leg*5Y_Itable_plasto_bigsquare*5Y_Itable_plasto_round*5Y_Itable_plasto_square*5Y_Ichair_plasto*5YmAtable_plasto_4leg*6Y_Itable_plasto_bigsquare*6Y_Itable_plasto_round*6Y_Itable_plasto_square*6Y_Ichair_plasto*6YmAtable_plasto_4leg*7Y_Itable_plasto_bigsquare*7Y_Itable_plasto_round*7Y_Itable_plasto_square*7Y_Ichair_plasto*7YmAtable_plasto_4leg*8Y_Itable_plasto_bigsquare*8Y_Itable_plasto_round*8Y_Itable_plasto_square*8Y_Ichair_plasto*8YmAtable_plasto_4leg*9Y_Itable_plasto_bigsquare*9Y_Itable_plasto_round*9Y_Itable_plasto_square*9Y_Ichair_plasto*9YmAcarpet_standard*6Y_Ichair_plasty*1X~DpizzaYmAdrinksYmAchair_plasty*2X~Dchair_plasty*3X~Dchair_plasty*4X~Dbar_polyfonY_Iplant_cruddyYmAbottleYmAbardesk_polyfonX~Dbardeskcorner_polyfonX~DfloortileHbar_armasY_Ibartable_armasYmAbar_chair_armasYmAcarpet_softZ@Kcarpet_soft*1Z@Kcarpet_soft*2Z@Kcarpet_soft*3Z@Kcarpet_soft*4Z@Kcarpet_soft*5Z@Kcarpet_soft*6Z@Kred_tvY_Iwood_tvYmAcarpet_polar*1Y_Ichair_plasty*5X~Dcarpet_polar*2Y_Icarpet_polar*3Y_Icarpet_polar*4Y_Ichair_plasty*6X~Dtable_polyfonYmAsmooth_table_polyfonYmAsofachair_polyfon_girlX~Dbed_polyfon_girl_one[dObed_polyfon_girlX~Dsofa_polyfon_girlZ[Mbed_budgetb_oneXQHbed_budgetbXQHplant_pineappleYmAplant_fruittreeY_Iplant_small_cactusY_Iplant_bonsaiY_Iplant_big_cactusY_Iplant_yukkaY_Icarpet_standard*7Y_Icarpet_standard*8Y_Icarpet_standard*9Y_Icarpet_standard*aY_Icarpet_standard*bY_Iplant_sunflowerY_Iplant_roseY_Itv_luxusY_IbathZ\BsinkY_ItoiletYmAduckYmAtileYmAtoilet_redYmAtoilet_yellYmAtile_redYmAtile_yellYmApresent_gen[~Npresent_gen1[~Npresent_gen2[~Npresent_gen3[~Npresent_gen4[~Npresent_gen5[~Npresent_gen6[~Nbar_basicY_Ishelves_basicXQHsoft_sofachair_norjaX~Dsoft_sofa_norjaX~Dlamp_basicXQHlamp2_armasYmAfridgeY_IdoorYc[doorBYc[doorCYc[pumpkinYmAskullcandleYmAdeadduckYmAdeadduck2YmAdeadduck3YmAmenorahYmApuddingYmAhamYmAturkeyYmAxmasduckY_IhouseYmAtriplecandleYmAtree3YmAtree4YmAtree5X~Dham2YmAwcandlesetYmArcandlesetYmAstatueYmAheartY_IvaleduckYmAheartsofaX~DthroneYmAsamovarY_IgiftflowersY_IhabbocakeYmAhologramYmAeasterduckY_IbunnyYmAbasketY_IbirdieYmAediceX~Dclub_sofaZ[Mprize1YmAprize2YmAprize3YmAdivider_poly3X~Ddivider_arm1YmAdivider_arm2YmAdivider_arm3YmAdivider_nor1X~Ddivider_silo1X~Ddivider_nor2X~Ddivider_silo2Z[Mdivider_nor3X~Ddivider_silo3X~DtypingmachineYmAspyroYmAredhologramYmAcameraHjoulutahtiYmAhyacinth1YmAhyacinth2YmAchair_plasto*10YmAchair_plasto*11YmAbardeskcorner_polyfon*12X~Dbardeskcorner_polyfon*13X~Dchair_plasto*12YmAchair_plasto*13YmAchair_plasto*14YmAtable_plasto_4leg*14Y_ImocchamasterY_Icarpet_legocourtYmAbench_legoYmAlegotrophyYmAvalentinescreenYmAedicehcYmArare_daffodil_rugYmArare_beehive_bulbY_IhcsohvaYmAhcammeYmArare_elephant_statueYmArare_fountainY_Irare_standYmArare_globeYmArare_hammockYmArare_elephant_statue*1YmArare_elephant_statue*2YmArare_fountain*1Y_Irare_fountain*2Y_Irare_fountain*3Y_Irare_beehive_bulb*1Y_Irare_beehive_bulb*2Y_Irare_xmas_screenY_Irare_parasol*1XMVrare_parasol*2XMVrare_parasol*3XMVtree1X~Dtree2ZmBwcandleYxBrcandleYxBsoft_jaggara_norjaYmAhouse2YmAdjesko_turntableYmAmd_sofaZ[Mmd_limukaappiY_Itable_plasto_4leg*10Y_Itable_plasto_4leg*15Y_Itable_plasto_bigsquare*14Y_Itable_plasto_bigsquare*15Y_Itable_plasto_round*14Y_Itable_plasto_round*15Y_Itable_plasto_square*14Y_Itable_plasto_square*15Y_Ichair_plasto*15YmAchair_plasty*7X~Dchair_plasty*8X~Dchair_plasty*9X~Dchair_plasty*10X~Dchair_plasty*11X~Dchair_plasto*16YmAtable_plasto_4leg*16Y_Ihockey_scoreY_Ihockey_lightYmAdoorDYc[prizetrophy2*3Yd[prizetrophy3*3Yd[prizetrophy4*3Yd[prizetrophy5*3Yd[prizetrophy6*3Yd[prizetrophy*1Yd[prizetrophy2*1Yd[prizetrophy3*1Yd[prizetrophy4*1Yd[prizetrophy5*1Yd[prizetrophy6*1Yd[prizetrophy*2Yd[prizetrophy2*2Yd[prizetrophy3*2Yd[prizetrophy4*2Yd[prizetrophy5*2Yd[prizetrophy6*2Yd[prizetrophy*3Yd[rare_parasol*0XMVhc_lmp[fBhc_tblYmAhc_chrYmAhc_dskXQHnestHpetfood1ZvCpetfood2ZvCpetfood3ZvCwaterbowl*4XICwaterbowl*5XICwaterbowl*2XICwaterbowl*1XICwaterbowl*3XICtoy1XICtoy1*1XICtoy1*2XICtoy1*3XICtoy1*4XICgoodie1Yc[goodie1*1Yc[goodie1*2Yc[goodie2Yc[prizetrophy7*3Yd[prizetrophy7*1Yd[prizetrophy7*2Yd[scifiport*0Y_Iscifiport*9Y_Iscifiport*8Y_Iscifiport*7Y_Iscifiport*6Y_Iscifiport*5Y_Iscifiport*4Y_Iscifiport*3Y_Iscifiport*2Y_Iscifiport*1Y_Iscifirocket*9Y_Iscifirocket*8Y_Iscifirocket*7Y_Iscifirocket*6Y_Iscifirocket*5Y_Iscifirocket*4Y_Iscifirocket*3Y_Iscifirocket*2Y_Iscifirocket*1Y_Iscifirocket*0Y_Iscifidoor*10Y_Iscifidoor*9Y_Iscifidoor*8Y_Iscifidoor*7Y_Iscifidoor*6Y_Iscifidoor*5Y_Iscifidoor*4Y_Iscifidoor*3Y_Iscifidoor*2Y_Iscifidoor*1Y_Ipillow*5YmApillow*8YmApillow*0YmApillow*1YmApillow*2YmApillow*7YmApillow*9YmApillow*4YmApillow*6YmApillow*3YmAmarquee*1Y_Imarquee*2Y_Imarquee*7Y_Imarquee*aY_Imarquee*8Y_Imarquee*9Y_Imarquee*5Y_Imarquee*4Y_Imarquee*6Y_Imarquee*3Y_Iwooden_screen*1Y_Iwooden_screen*2Y_Iwooden_screen*7Y_Iwooden_screen*0Y_Iwooden_screen*8Y_Iwooden_screen*5Y_Iwooden_screen*9Y_Iwooden_screen*4Y_Iwooden_screen*6Y_Iwooden_screen*3Y_Ipillar*6Y_Ipillar*1Y_Ipillar*9Y_Ipillar*0Y_Ipillar*8Y_Ipillar*2Y_Ipillar*5Y_Ipillar*4Y_Ipillar*7Y_Ipillar*3Y_Irare_dragonlamp*4Y_Irare_dragonlamp*0Y_Irare_dragonlamp*5Y_Irare_dragonlamp*2Y_Irare_dragonlamp*8Y_Irare_dragonlamp*9Y_Irare_dragonlamp*7Y_Irare_dragonlamp*6Y_Irare_dragonlamp*1Y_Irare_dragonlamp*3Y_Irare_icecream*1Y_Irare_icecream*7Y_Irare_icecream*8Y_Irare_icecream*2Y_Irare_icecream*6Y_Irare_icecream*9Y_Irare_icecream*3Y_Irare_icecream*0Y_Irare_icecream*4Y_Irare_icecream*5Y_Irare_fan*7YxBrare_fan*6YxBrare_fan*9YxBrare_fan*3YxBrare_fan*0YxBrare_fan*4YxBrare_fan*5YxBrare_fan*1YxBrare_fan*8YxBrare_fan*2YxBqueue_tile1*3X~Dqueue_tile1*6X~Dqueue_tile1*4X~Dqueue_tile1*9X~Dqueue_tile1*8X~Dqueue_tile1*5X~Dqueue_tile1*7X~Dqueue_tile1*2X~Dqueue_tile1*1X~Dqueue_tile1*0X~DticketHrare_snowrugX~Dcn_lampZxIcn_sofaYmAsporttrack1*1YmAsporttrack1*3YmAsporttrack1*2YmAsporttrack2*1[~Nsporttrack2*2[~Nsporttrack2*3[~Nsporttrack3*1YmAsporttrack3*2YmAsporttrack3*3YmAfootylampX~Dbarchair_siloX~Ddivider_nor4*4X~Dtraffic_light*1ZxItraffic_light*2ZxItraffic_light*3ZxItraffic_light*4ZxItraffic_light*6ZxIrubberchair*1X~Drubberchair*2X~Drubberchair*3X~Drubberchair*4X~Drubberchair*5X~Drubberchair*6X~Dbarrier*1X~Dbarrier*2X~Dbarrier*3X~Drubberchair*7X~Drubberchair*8X~Dtable_norja_med*2Y_Itable_norja_med*3Y_Itable_norja_med*4Y_Itable_norja_med*5Y_Itable_norja_med*6Y_Itable_norja_med*7Y_Itable_norja_med*8Y_Itable_norja_med*9Y_Icouch_norja*2X~Dcouch_norja*3X~Dcouch_norja*4X~Dcouch_norja*5X~Dcouch_norja*6X~Dcouch_norja*7X~Dcouch_norja*8X~Dcouch_norja*9X~Dshelves_norja*2X~Dshelves_norja*3X~Dshelves_norja*4X~Dshelves_norja*5X~Dshelves_norja*6X~Dshelves_norja*7X~Dshelves_norja*8X~Dshelves_norja*9X~Dchair_norja*2X~Dchair_norja*3X~Dchair_norja*4X~Dchair_norja*5X~Dchair_norja*6X~Dchair_norja*7X~Dchair_norja*8X~Dchair_norja*9X~Ddivider_nor1*2X~Ddivider_nor1*3X~Ddivider_nor1*4X~Ddivider_nor1*5X~Ddivider_nor1*6X~Ddivider_nor1*7X~Ddivider_nor1*8X~Ddivider_nor1*9X~Dsoft_sofa_norja*2X~Dsoft_sofa_norja*3X~Dsoft_sofa_norja*4X~Dsoft_sofa_norja*5X~Dsoft_sofa_norja*6X~Dsoft_sofa_norja*7X~Dsoft_sofa_norja*8X~Dsoft_sofa_norja*9X~Dsoft_sofachair_norja*2X~Dsoft_sofachair_norja*3X~Dsoft_sofachair_norja*4X~Dsoft_sofachair_norja*5X~Dsoft_sofachair_norja*6X~Dsoft_sofachair_norja*7X~Dsoft_sofachair_norja*8X~Dsoft_sofachair_norja*9X~Dsofachair_silo*2X~Dsofachair_silo*3X~Dsofachair_silo*4X~Dsofachair_silo*5X~Dsofachair_silo*6X~Dsofachair_silo*7X~Dsofachair_silo*8X~Dsofachair_silo*9X~Dtable_silo_small*2X~Dtable_silo_small*3X~Dtable_silo_small*4X~Dtable_silo_small*5X~Dtable_silo_small*6X~Dtable_silo_small*7X~Dtable_silo_small*8X~Dtable_silo_small*9X~Ddivider_silo1*2X~Ddivider_silo1*3X~Ddivider_silo1*4X~Ddivider_silo1*5X~Ddivider_silo1*6X~Ddivider_silo1*7X~Ddivider_silo1*8X~Ddivider_silo1*9X~Ddivider_silo3*2X~Ddivider_silo3*3X~Ddivider_silo3*4X~Ddivider_silo3*5X~Ddivider_silo3*6X~Ddivider_silo3*7X~Ddivider_silo3*8X~Ddivider_silo3*9X~Dtable_silo_med*2X~Dtable_silo_med*3X~Dtable_silo_med*4X~Dtable_silo_med*5X~Dtable_silo_med*6X~Dtable_silo_med*7X~Dtable_silo_med*8X~Dtable_silo_med*9X~Dsofa_silo*2X~Dsofa_silo*3X~Dsofa_silo*4X~Dsofa_silo*5X~Dsofa_silo*6X~Dsofa_silo*7X~Dsofa_silo*8X~Dsofa_silo*9X~Dsofachair_polyfon*2X~Dsofachair_polyfon*3X~Dsofachair_polyfon*4X~Dsofachair_polyfon*6X~Dsofachair_polyfon*7X~Dsofachair_polyfon*8X~Dsofachair_polyfon*9X~Dsofa_polyfon*2Z[Msofa_polyfon*3Z[Msofa_polyfon*4Z[Msofa_polyfon*6Z[Msofa_polyfon*7Z[Msofa_polyfon*8Z[Msofa_polyfon*9Z[Mbed_polyfon*2X~Dbed_polyfon*3X~Dbed_polyfon*4X~Dbed_polyfon*6X~Dbed_polyfon*7X~Dbed_polyfon*8X~Dbed_polyfon*9X~Dbed_polyfon_one*2[dObed_polyfon_one*3[dObed_polyfon_one*4[dObed_polyfon_one*6[dObed_polyfon_one*7[dObed_polyfon_one*8[dObed_polyfon_one*9[dObardesk_polyfon*2X~Dbardesk_polyfon*3X~Dbardesk_polyfon*4X~Dbardesk_polyfon*5X~Dbardesk_polyfon*6X~Dbardesk_polyfon*7X~Dbardesk_polyfon*8X~Dbardesk_polyfon*9X~Dbardeskcorner_polyfon*2X~Dbardeskcorner_polyfon*3X~Dbardeskcorner_polyfon*4X~Dbardeskcorner_polyfon*5X~Dbardeskcorner_polyfon*6X~Dbardeskcorner_polyfon*7X~Dbardeskcorner_polyfon*8X~Dbardeskcorner_polyfon*9X~Ddivider_poly3*2X~Ddivider_poly3*3X~Ddivider_poly3*4X~Ddivider_poly3*5X~Ddivider_poly3*6X~Ddivider_poly3*7X~Ddivider_poly3*8X~Ddivider_poly3*9X~Dchair_silo*2X~Dchair_silo*3X~Dchair_silo*4X~Dchair_silo*5X~Dchair_silo*6X~Dchair_silo*7X~Dchair_silo*8X~Dchair_silo*9X~Ddivider_nor3*2X~Ddivider_nor3*3X~Ddivider_nor3*4X~Ddivider_nor3*5X~Ddivider_nor3*6X~Ddivider_nor3*7X~Ddivider_nor3*8X~Ddivider_nor3*9X~Ddivider_nor2*2X~Ddivider_nor2*3X~Ddivider_nor2*4X~Ddivider_nor2*5X~Ddivider_nor2*6X~Ddivider_nor2*7X~Ddivider_nor2*8X~Ddivider_nor2*9X~Dsilo_studydeskX~Dsolarium_norjaY_Isolarium_norja*1Y_Isolarium_norja*2Y_Isolarium_norja*3Y_Isolarium_norja*5Y_Isolarium_norja*6Y_Isolarium_norja*7Y_Isolarium_norja*8Y_Isolarium_norja*9Y_IsandrugX~Drare_moonrugYmAchair_chinaYmAchina_tableYmAsleepingbag*1YmAsleepingbag*2YmAsleepingbag*3YmAsleepingbag*4YmAsafe_siloY_Isleepingbag*7YmAsleepingbag*9YmAsleepingbag*5YmAsleepingbag*10YmAsleepingbag*6YmAsleepingbag*8YmAchina_shelveX~Dtraffic_light*5ZxIdivider_nor4*2X~Ddivider_nor4*3X~Ddivider_nor4*5X~Ddivider_nor4*6X~Ddivider_nor4*7X~Ddivider_nor4*8X~Ddivider_nor4*9X~Ddivider_nor5*2X~Ddivider_nor5*3X~Ddivider_nor5*4X~Ddivider_nor5*5X~Ddivider_nor5*6X~Ddivider_nor5*7X~Ddivider_nor5*8X~Ddivider_nor5*9X~Ddivider_nor5X~Ddivider_nor4X~Dwall_chinaYmAcorner_chinaYmAbarchair_silo*2X~Dbarchair_silo*3X~Dbarchair_silo*4X~Dbarchair_silo*5X~Dbarchair_silo*6X~Dbarchair_silo*7X~Dbarchair_silo*8X~Dbarchair_silo*9X~Dsafe_silo*2Y_Isafe_silo*3Y_Isafe_silo*4Y_Isafe_silo*5Y_Isafe_silo*6Y_Isafe_silo*7Y_Isafe_silo*8Y_Isafe_silo*9Y_Iglass_shelfY_Iglass_chairY_Iglass_stoolY_Iglass_sofaY_Iglass_tableY_Iglass_table*2Y_Iglass_table*3Y_Iglass_table*4Y_Iglass_table*5Y_Iglass_table*6Y_Iglass_table*7Y_Iglass_table*8Y_Iglass_table*9Y_Iglass_chair*2Y_Iglass_chair*3Y_Iglass_chair*4Y_Iglass_chair*5Y_Iglass_chair*6Y_Iglass_chair*7Y_Iglass_chair*8Y_Iglass_chair*9Y_Iglass_sofa*2Y_Iglass_sofa*3Y_Iglass_sofa*4Y_Iglass_sofa*5Y_Iglass_sofa*6Y_Iglass_sofa*7Y_Iglass_sofa*8Y_Iglass_sofa*9Y_Iglass_stool*2Y_Iglass_stool*4Y_Iglass_stool*5Y_Iglass_stool*6Y_Iglass_stool*7Y_Iglass_stool*8Y_Iglass_stool*3Y_Iglass_stool*9Y_ICF_10_coin_goldZvCCF_1_coin_bronzeZvCCF_20_moneybagZvCCF_50_goldbarZvCCF_5_coin_silverZvChc_crptYmAhc_tvZ\BgothgateX~DgothiccandelabraYxBgothrailingX~Dgoth_tableYmAhc_bkshlfYmAhc_btlrY_Ihc_crtnYmAhc_djsetYmAhc_frplcZbBhc_lmpstYmAhc_machineYmAhc_rllrXQHhc_rntgnX~Dhc_trllYmAgothic_chair*1X~Dgothic_sofa*1X~Dgothic_stool*1X~Dgothic_chair*2X~Dgothic_sofa*2X~Dgothic_stool*2X~Dgothic_chair*3X~Dgothic_sofa*3X~Dgothic_stool*3X~Dgothic_chair*4X~Dgothic_sofa*4X~Dgothic_stool*4X~Dgothic_chair*5X~Dgothic_sofa*5X~Dgothic_stool*5X~Dgothic_chair*6X~Dgothic_sofa*6X~Dgothic_stool*6X~Dval_cauldronX~Dsound_machineX~Dromantique_pianochair*3Y_Iromantique_pianochair*5Y_Iromantique_pianochair*2Y_Iromantique_pianochair*4Y_Iromantique_pianochair*1Y_Iromantique_divan*3Y_Iromantique_divan*5Y_Iromantique_divan*2Y_Iromantique_divan*4Y_Iromantique_divan*1Y_Iromantique_chair*3Y_Iromantique_chair*5Y_Iromantique_chair*2Y_Iromantique_chair*4Y_Iromantique_chair*1Y_Irare_parasolY_Iplant_valentinerose*3XICplant_valentinerose*5XICplant_valentinerose*2XICplant_valentinerose*4XICplant_valentinerose*1XICplant_mazegateYeCplant_mazeZcCplant_bulrushXICpetfood4Y_Icarpet_valentineZ|Egothic_carpetXICgothic_carpet2Z|Egothic_chairX~Dgothic_sofaX~Dgothic_stoolX~Dgrand_piano*3Z|Egrand_piano*5Z|Egrand_piano*2Z|Egrand_piano*4Z|Egrand_piano*1Z|Etheatre_seatZ@Kromantique_tray2Y_Iromantique_tray1Y_Iromantique_smalltabl*3Y_Iromantique_smalltabl*5Y_Iromantique_smalltabl*2Y_Iromantique_smalltabl*4Y_Iromantique_smalltabl*1Y_Iromantique_mirrortablY_Iromantique_divider*3Z[Mromantique_divider*2Z[Mromantique_divider*4Z[Mromantique_divider*1Z[Mjp_tatami2[dWjp_tatamiYGGhabbowood_chairYGGjp_bambooYGGjp_iroriXQHjp_pillowYGGsound_set_1[dWsound_set_2[dWsound_set_3[dWsound_set_4[dWsound_set_5[dWsound_set_6[dWsound_set_7[dWsound_set_8[dWsound_set_9[dWsound_machine*1Yc[spotlightY_Isound_machine*2Yc[sound_machine*3Yc[sound_machine*4Yc[sound_machine*5Yc[sound_machine*6Yc[sound_machine*7Yc[rom_lampZ|Erclr_sofaXQHrclr_gardenXQHrclr_chairZ|Esound_set_28[dWsound_set_27[dWsound_set_26[dWsound_set_25[dWsound_set_24[dWsound_set_23[dWsound_set_22[dWsound_set_21[dWsound_set_20[dWsound_set_19[dWsound_set_18[dWsound_set_17[dWsound_set_16[dWsound_set_15[dWsound_set_14[dWsound_set_13[dWsound_set_12[dWsound_set_11[dWsound_set_10[dWrope_dividerXQHromantique_clockY_Irare_icecream_campaignY_Ipura_mdl5*1Yc[pura_mdl5*2Yc[pura_mdl5*3Yc[pura_mdl5*4Yc[pura_mdl5*5Yc[pura_mdl5*6Yc[pura_mdl5*7Yc[pura_mdl5*8Yc[pura_mdl5*9Yc[pura_mdl4*1XQHpura_mdl4*2XQHpura_mdl4*3XQHpura_mdl4*4XQHpura_mdl4*5XQHpura_mdl4*6XQHpura_mdl4*7XQHpura_mdl4*8XQHpura_mdl4*9XQHpura_mdl3*1XQHpura_mdl3*2XQHpura_mdl3*3XQHpura_mdl3*4XQHpura_mdl3*5XQHpura_mdl3*6XQHpura_mdl3*7XQHpura_mdl3*8XQHpura_mdl3*9XQHpura_mdl2*1XQHpura_mdl2*2XQHpura_mdl2*3XQHpura_mdl2*4XQHpura_mdl2*5XQHpura_mdl2*6XQHpura_mdl2*7XQHpura_mdl2*8XQHpura_mdl2*9XQHpura_mdl1*1XQHpura_mdl1*2XQHpura_mdl1*3XQHpura_mdl1*4XQHpura_mdl1*5XQHpura_mdl1*6XQHpura_mdl1*7XQHpura_mdl1*8XQHpura_mdl1*9XQHjp_lanternXQHchair_basic*1XQHchair_basic*2XQHchair_basic*3XQHchair_basic*4XQHchair_basic*5XQHchair_basic*6XQHchair_basic*7XQHchair_basic*8XQHchair_basic*9XQHbed_budget*1XQHbed_budget*2XQHbed_budget*3XQHbed_budget*4XQHbed_budget*5XQHbed_budget*6XQHbed_budget*7XQHbed_budget*8XQHbed_budget*9XQHbed_budget_one*1XQHbed_budget_one*2XQHbed_budget_one*3XQHbed_budget_one*4XQHbed_budget_one*5XQHbed_budget_one*6XQHbed_budget_one*7XQHbed_budget_one*8XQHbed_budget_one*9XQHjp_drawerXQHtile_stellaZ[Mtile_marbleZ[Mtile_brownZ[Msummer_grill*1Y_Isummer_grill*2Y_Isummer_grill*3Y_Isummer_grill*4Y_Isummer_chair*1Y_Isummer_chair*2Y_Isummer_chair*3Y_Isummer_chair*4Y_Isummer_chair*5Y_Isummer_chair*6Y_Isummer_chair*7Y_Isummer_chair*8Y_Isummer_chair*9Y_Isound_set_36[dWsound_set_35[dWsound_set_34[dWsound_set_33[dWsound_set_32[dWsound_set_31[dWsound_set_30[dWsound_set_29[dWsound_machine_proYc[rare_mnstrY_Ione_way_door*1XQHone_way_door*2XQHone_way_door*3XQHone_way_door*4XQHone_way_door*5XQHone_way_door*6XQHone_way_door*7XQHone_way_door*8XQHone_way_door*9XQHexe_rugZ[Mexe_s_tableZGRsound_set_37[dWsummer_pool*1ZlIsummer_pool*2ZlIsummer_pool*3ZlIsummer_pool*4ZlIsong_diskYc[jukebox*1Yc[carpet_soft_tut[~Nsound_set_44[dWsound_set_43[dWsound_set_42[dWsound_set_41[dWsound_set_40[dWsound_set_39[dWsound_set_38[dWgrunge_chairZ@Kgrunge_mattressZ@Kgrunge_radiatorZ@Kgrunge_shelfZ@Kgrunge_signZ@Kgrunge_tableZ@Khabboween_crypt[uKhabboween_grassZ@Khal_cauldronZ@Khal_graveZ@Ksound_set_52[dWsound_set_51[dWsound_set_50[dWsound_set_49[dWsound_set_48[dWsound_set_47[dWsound_set_46[dWsound_set_45[dWxmas_icelampZ[Mxmas_cstl_wallZ[Mxmas_cstl_twrZ[Mxmas_cstl_gate[~Ntree7Z[Mtree6Z[Msound_set_54[dWsound_set_53[dWsafe_silo_pb[dOplant_mazegate_snowZ[Mplant_maze_snowZ[Mchristmas_sleighZ[Mchristmas_reindeer[~Nchristmas_poopZ[Mexe_bardeskZ[Mexe_chairZ[Mexe_chair2Z[Mexe_cornerZ[Mexe_drinksZ[Mexe_sofaZ[Mexe_tableZ[Msound_set_59[dWsound_set_58[dWsound_set_57[dWsound_set_56[dWsound_set_55[dWnoob_table*1[~Nnoob_table*2[~Nnoob_table*3[~Nnoob_table*4[~Nnoob_table*5[~Nnoob_table*6[~Nnoob_stool*1[~Nnoob_stool*2[~Nnoob_stool*3[~Nnoob_stool*4[~Nnoob_stool*5[~Nnoob_stool*6[~Nnoob_rug*1[~Nnoob_rug*2[~Nnoob_rug*3[~Nnoob_rug*4[~Nnoob_rug*5[~Nnoob_rug*6[~Nnoob_lamp*1[dOnoob_lamp*2[dOnoob_lamp*3[dOnoob_lamp*4[dOnoob_lamp*5[dOnoob_lamp*6[dOnoob_chair*1[~Nnoob_chair*2[~Nnoob_chair*3[~Nnoob_chair*4[~Nnoob_chair*5[~Nnoob_chair*6[~Nexe_globe[~Nexe_plantZ[Mval_teddy*1[dOval_teddy*2[dOval_teddy*3[dOval_teddy*4[dOval_teddy*5[dOval_teddy*6[dOval_randomizer[dOval_choco[dOteleport_doorYc[sound_set_61[dWsound_set_60[dWfortune[dOsw_tableZIPsw_raven[cQsw_chestZIPsand_cstl_wallZIPsand_cstl_twrZIPsand_cstl_gateZIPgrunge_candleZIPgrunge_benchZIPgrunge_barrelZIPrclr_lampZGRprizetrophy9*1Yd[prizetrophy8*1Yd[nouvelle_traxYc[md_rugZGRjp_tray6ZGRjp_tray5ZGRjp_tray4ZGRjp_tray3ZGRjp_tray2ZGRjp_tray1ZGRarabian_teamkZGRarabian_snakeZGRarabian_rugZGRarabian_pllwZGRarabian_divdrZGRarabian_chairZGRarabian_bigtbZGRarabian_tetblZGRarabian_tray1ZGRarabian_tray2ZGRarabian_tray3ZGRarabian_tray4ZGRsound_set_64[dWsound_set_63[dWsound_set_62[dWjukebox_ptv*1Yc[calippoZAStraxsilverYc[traxgoldYc[traxbronzeYc[bench_puffetYATCFC_500_goldbarZvCCFC_200_moneybagZvCCFC_10_coin_bronzeZvCCFC_100_coin_goldZvCCFC_50_coin_silverZvCjp_tableXMVjp_rareXMVjp_katana3XMVjp_katana2XMVjp_katana1XMVfootylamp_campaignXMVtiki_waterfall[dWtiki_tray4[dWtiki_tray3[dWtiki_tray2[dWtiki_tray1[dWtiki_tray0[dWtiki_toucan[dWtiki_torch[dWtiki_statue[dWtiki_sand[dWtiki_parasol[dWtiki_junglerug[dWtiki_corner[dWtiki_bflies[dWtiki_bench[dWtiki_bardesk[dWtampax_rug[dWsound_set_70[dWsound_set_69[dWsound_set_68[dWsound_set_67[dWsound_set_66[dWsound_set_65[dWnoob_rug_tradeable*1[dWnoob_rug_tradeable*2[dWnoob_rug_tradeable*3[dWnoob_rug_tradeable*4[dWnoob_rug_tradeable*5[dWnoob_rug_tradeable*6[dWnoob_plant[dWnoob_lamp_tradeable*1[dWnoob_lamp_tradeable*2[dWnoob_lamp_tradeable*3[dWnoob_lamp_tradeable*4[dWnoob_lamp_tradeable*5[dWnoob_lamp_tradeable*6[dWnoob_chair_tradeable*1[dWnoob_chair_tradeable*2[dWnoob_chair_tradeable*3[dWnoob_chair_tradeable*4[dWnoob_chair_tradeable*5[dWnoob_chair_tradeable*6[dWjp_teamaker[dWsvnr_ukXhXsvnr_nlXhXsvnr_itXhXsvnr_de[gXsvnr_aus[gXdiner_tray_7[gXdiner_tray_6[gXdiner_tray_5[gXdiner_tray_4[gXdiner_tray_3[gXdiner_tray_2[gXdiner_tray_1[gXdiner_tray_0[gXdiner_sofa_2*1[gXdiner_sofa_2*2[gXdiner_sofa_2*3[gXdiner_sofa_2*4[gXdiner_sofa_2*5[gXdiner_sofa_2*6[gXdiner_sofa_2*7[gXdiner_sofa_2*8[gXdiner_sofa_2*9[gXdiner_shaker[gXdiner_rug[gXdiner_gumvendor*1[gXdiner_gumvendor*2[gXdiner_gumvendor*3[gXdiner_gumvendor*4[gXdiner_gumvendor*5[gXdiner_gumvendor*6[gXdiner_gumvendor*7[gXdiner_gumvendor*8[gXdiner_gumvendor*9[gXdiner_cashreg*1[gXdiner_cashreg*2[gXdiner_cashreg*3[gXdiner_cashreg*4[gXdiner_cashreg*5[gXdiner_cashreg*6[gXdiner_cashreg*7[gXdiner_cashreg*8[gXdiner_cashreg*9[gXdiner_table_2*1XiZdiner_table_2*2XiZdiner_table_2*3XiZdiner_table_2*4XiZdiner_table_2*5XiZdiner_table_2*6XiZdiner_table_2*7XiZdiner_table_2*8XiZdiner_table_2*9XiZdiner_table_1*1XiZdiner_table_1*2XiZdiner_table_1*3XiZdiner_table_1*4XiZdiner_table_1*5XiZdiner_table_1*6XiZdiner_table_1*7XiZdiner_table_1*8XiZdiner_table_1*9XiZdiner_sofa_1*1XiZdiner_sofa_1*2XiZdiner_sofa_1*3XiZdiner_sofa_1*4XiZdiner_sofa_1*5XiZdiner_sofa_1*6XiZdiner_sofa_1*7XiZdiner_sofa_1*8XiZdiner_sofa_1*9XiZdiner_chair*1XiZdiner_chair*2XiZdiner_chair*3XiZdiner_chair*4XiZdiner_chair*5XiZdiner_chair*6XiZdiner_chair*7XiZdiner_chair*8XiZdiner_chair*9XiZdiner_bardesk_gate*1XiZdiner_bardesk_gate*2XiZdiner_bardesk_gate*3XiZdiner_bardesk_gate*4XiZdiner_bardesk_gate*5XiZdiner_bardesk_gate*6XiZdiner_bardesk_gate*7XiZdiner_bardesk_gate*8XiZdiner_bardesk_gate*9XiZdiner_bardesk_corner*1XiZdiner_bardesk_corner*2XiZdiner_bardesk_corner*3XiZdiner_bardesk_corner*4XiZdiner_bardesk_corner*5XiZdiner_bardesk_corner*6XiZdiner_bardesk_corner*7XiZdiner_bardesk_corner*8XiZdiner_bardesk_corner*9XiZdiner_bardesk*1XiZdiner_bardesk*2XiZdiner_bardesk*3XiZdiner_bardesk*4XiZdiner_bardesk*5XiZdiner_bardesk*6XiZdiner_bardesk*7XiZdiner_bardesk*8XiZdiner_bardesk*9XiZads_dave_cnsXiZeasy_carpetYc[easy_bowl2Yc[greek_cornerYc[greek_gateYc[greek_pillarsYc[greek_seatYc[greektrophy*1[P\greektrophy*2[P\greektrophy*3[P\greek_blockXt[PPpost.itHpost.it.vdHphotoHChessHTicTacToeHBattleShipHPokerHwallpaperHfloorHposterZ@KgothicfountainYxBhc_wall_lampZbBindustrialfanZ`BtorchZ\Bval_heartXBCwallmirrorZ|Ejp_ninjastarsXQHhabw_mirrorXQHhabbowheelZ[Mguitar_skullZ@Kguitar_vZ@Kxmas_light[~Nhrella_poster_3[Nhrella_poster_2ZIPhrella_poster_1[Nsw_swordsZIPsw_stoneZIPsw_holeZIProomdimmerYc[md_logo_wallZGRmd_canZGRjp_sheet3ZGRjp_sheet2ZGRjp_sheet1ZGRarabian_swordsZGRarabian_wndwZGRtiki_wallplnt[dWtiki_surfboard[dWtampax_wall[dWwindow_single_default[gXwindow_double_default[gXnoob_window_double[dWwindow_triple[gXwindow_square[gXwindow_romantic_wide[gXwindow_romantic_narrow[gXwindow_grunge[gXwindow_golden[gXwindow_chinese_wide[gXwindow_chinese_narrowYA\window_basic[gXwindow_70s_wide[gXwindow_70s_narrow[gXads_sunnydYlXwindow_diner2XiZwindow_dinerXiZdiner_walltableXiZads_dave_wallXiZwindow_holeYc[easy_posterYc[ads_nokia_logoYc[ads_nokia_phoneYc[landscapeYA\window_skyscraper[j\");
                                            _receivedSpriteIndex = true;
                                        }
                                    }
                                    break;
                            }

                        case "@": // Enter room - guestroom - get wallitems
                            {
                                if (_ROOMACCESS_SECONDARY_OK && Room != null)
                                    sendData("@m" + Room.Wallitems);
                                break;
                            }

                        case "A@": // Enter room - add this user to room
                            {
                                if (_ROOMACCESS_SECONDARY_OK && Room != null && roomUser == null)
                                {
                                    sendData("@b" + Room.dynamicStatuses);
                                    Room.addUser(this);
                                }
                                break;
                            }

                        #endregion

                        #region Moderation
                        #region MOD-Tool
                        case "CH": // MOD-Tool
                            {
                                int messageLength = 0;
                                string Message = "";
                                int staffNoteLength = 0;
                                string staffNote = "";
                                string targetUser = "";

                                switch (currentPacket.Substring(2, 2)) // Select the action
                                {
                                    #region Alert single user
                                    case "HH": // Alert single user
                                        {
                                            if (rankManager.containsRight(_Rank, "fuse_alert") == false) { sendData("BK" + stringManager.getString("modtool_accesserror")); return; }

                                            messageLength = Encoding.decodeB64(currentPacket.Substring(4, 2));
                                            Message = currentPacket.Substring(6, messageLength).Replace(Convert.ToChar(1).ToString(), " ");
                                            staffNoteLength = Encoding.decodeB64(currentPacket.Substring(messageLength + 6, 2));
                                            staffNote = currentPacket.Substring(messageLength + 8, staffNoteLength);
                                            targetUser = currentPacket.Substring(messageLength + staffNoteLength + 10);

                                            if (Message == "" || targetUser == "")
                                                return;

                                            virtualUser _targetUser = userManager.getUser(targetUser);
                                            if (_targetUser == null)
                                                sendData("BK" + stringManager.getString("modtool_actionfail") + "\r" + stringManager.getString("modtool_usernotfound"));
                                            else
                                            {
                                                _targetUser.sendData("B!" + Message + Convert.ToChar(2));
                                                staffManager.addStaffMessage("alert", userID, _targetUser.userID, Message, staffNote);
                                            }
                                            break;
                                        }
                                    #endregion

                                    #region Kick single user from room
                                    case "HI": // Kick single user from room
                                        {
                                            if (rankManager.containsRight(_Rank, "fuse_kick") == false) { sendData("BK" + stringManager.getString("modtool_accesserror")); return; }

                                            messageLength = Encoding.decodeB64(currentPacket.Substring(4, 2));
                                            Message = currentPacket.Substring(6, messageLength).Replace(Convert.ToChar(1).ToString(), " ");
                                            staffNoteLength = Encoding.decodeB64(currentPacket.Substring(messageLength + 6, 2));
                                            staffNote = currentPacket.Substring(messageLength + 8, staffNoteLength);
                                            targetUser = currentPacket.Substring(messageLength + staffNoteLength + 10);

                                            if (Message == "" || targetUser == "")
                                                return;

                                            virtualUser _targetUser = userManager.getUser(targetUser);
                                            if (_targetUser == null)
                                                sendData("BK" + stringManager.getString("modtool_actionfail") + "\r" + stringManager.getString("modtool_usernotfound"));
                                            else
                                            {
                                                if (_targetUser.Room != null && _targetUser.roomUser != null)
                                                {
                                                    if (_targetUser._Rank < _Rank)
                                                    {
                                                        _targetUser.Room.removeUser(_targetUser.roomUser.roomUID, true, Message);
                                                        staffManager.addStaffMessage("kick", userID, _targetUser.userID, Message, staffNote);
                                                    }
                                                    else
                                                        sendData("BK" + stringManager.getString("modtool_actionfail") + "\r" + stringManager.getString("modtool_rankerror"));
                                                }
                                            }
                                            break;
                                        }
                                    #endregion

                                    #region Ban single user
                                    case "HJ": // Ban single user / IP
                                        {
                                            if (rankManager.containsRight(_Rank, "fuse_ban") == false) { sendData("BK" + stringManager.getString("modtool_accesserror")); return; }

                                            int targetUserLength = 0;
                                            int banHours = 0;
                                            bool banIP = (currentPacket.Substring(currentPacket.Length - 1, 1) == "I");

                                            messageLength = Encoding.decodeB64(currentPacket.Substring(4, 2));
                                            Message = currentPacket.Substring(6, messageLength).Replace(Convert.ToChar(1).ToString(), " ");
                                            staffNoteLength = Encoding.decodeB64(currentPacket.Substring(messageLength + 6, 2));
                                            staffNote = currentPacket.Substring(messageLength + 8, staffNoteLength);
                                            targetUserLength = Encoding.decodeB64(currentPacket.Substring(messageLength + staffNoteLength + 8, 2));
                                            targetUser = currentPacket.Substring(messageLength + staffNoteLength + 10, targetUserLength);
                                            banHours = Encoding.decodeVL64(currentPacket.Substring(messageLength + staffNoteLength + targetUserLength + 10));

                                            if (Message == "" || targetUser == "" || banHours == 0)
                                                return;
                                            else
                                            {
                                                Database dbClient = new Database(false, true, 87);
                                                dbClient.addParameterWithValue("name", targetUser);
                                                dbClient.Open();
                                                DataRow dRow = dbClient.getRow("SELECT id,rank,ipaddress_last FROM users WHERE name = @name");
                                                if (dRow.Table.Rows.Count == 0)
                                                {
                                                    sendData("BK" + stringManager.getString("modtool_actionfail") + "\r" + stringManager.getString("modtool_usernotfound"));
                                                    return;
                                                }
                                                else if (Convert.ToByte(dRow["rank"]) >= _Rank)
                                                {
                                                    sendData("BK" + stringManager.getString("modtool_actionfail") + "\r" + stringManager.getString("modtool_rankerror"));
                                                    return;
                                                }

                                                int targetID = Convert.ToInt32(dRow["id"]);
                                                string Report = "";
                                                staffManager.addStaffMessage("ban", userID, targetID, Message, staffNote);
                                                if (banIP && rankManager.containsRight(_Rank, "fuse_superban")) // IP ban is chosen and allowed for this staff member
                                                {
                                                    userManager.setBan(Convert.ToString(dRow["ipaddress_last"]), banHours, Message);
                                                    Report = userManager.generateBanReport(Convert.ToString(dRow["ipaddress_last"]));
                                                }
                                                else
                                                {
                                                    userManager.setBan(targetID, banHours, Message);
                                                    Report = userManager.generateBanReport(targetID);
                                                }

                                                sendData("BK" + Report);
                                            }
                                            break;
                                        }
                                    #endregion

                                    #region Room alert
                                    case "IH": // Alert all users in current room
                                        {
                                            if (rankManager.containsRight(_Rank, "fuse_room_alert") == false) { sendData("BK" + stringManager.getString("modtool_accesserror")); return; }
                                            if (Room == null || roomUser == null) { return; }

                                            messageLength = Encoding.decodeB64(currentPacket.Substring(4, 2));
                                            Message = currentPacket.Substring(6, messageLength).Replace(Convert.ToChar(1).ToString(), " ");
                                            staffNoteLength = Encoding.decodeB64(currentPacket.Substring(messageLength + 6, 2));
                                            staffNote = currentPacket.Substring(messageLength + 8, staffNoteLength);

                                            if (Message != "")
                                            {
                                                Room.sendData("B!" + Message + Convert.ToChar(2));
                                                staffManager.addStaffMessage("ralert", userID, _roomID, Message, staffNote);
                                            }
                                            break;
                                        }
                                    #endregion

                                    #region Room kick
                                    case "II": // Kick all users below users rank from room
                                        {
                                            if (rankManager.containsRight(_Rank, "fuse_room_kick") == false) { sendData("BK" + stringManager.getString("modtool_accesserror")); return; }
                                            if (Room == null || roomUser == null) { return; }

                                            messageLength = Encoding.decodeB64(currentPacket.Substring(4, 2));
                                            Message = currentPacket.Substring(6, messageLength).Replace(Convert.ToChar(1).ToString(), " ");
                                            staffNoteLength = Encoding.decodeB64(currentPacket.Substring(messageLength + 6, 2));
                                            staffNote = currentPacket.Substring(messageLength + 8, staffNoteLength);

                                            if (Message != "")
                                            {
                                                Room.kickUsers(_Rank, Message);
                                                staffManager.addStaffMessage("rkick", userID, _roomID, Message, staffNote);
                                            }
                                            break;
                                        }
                                    #endregion
                                }
                                break;
                            }
                        #endregion

                        #region Call For Help

                        #region User Side
                        case "Cm": // User wants to send a CFH message 
                            {
                                Database dbClient = new Database(true, true, 88);
                                DataRow dRow = dbClient.getRow("SELECT id, date, message FROM cms_help WHERE username = '" + _Username + "' AND picked_up = '0'");
                                if (dRow.Table.Rows.Count == 0)
                                    sendData("D" + "H");
                                else
                                    sendData("D" + "I" + Convert.ToString(dRow[0]) + Convert.ToChar(2) + Convert.ToString(dRow[1]) + Convert.ToChar(2) + Convert.ToString(dRow[2]) + Convert.ToChar(2));
                                break;
                            }

                        case "Cn": // User deletes his pending CFH message
                            {
                                Database dbClient = new Database(true, false, 89);
                                int cfhID = dbClient.getInteger("SELECT id FROM cms_help WHERE username = '" + _Username + "' AND picked_up = '0'");
                                dbClient.runQuery("DELETE FROM cms_help WHERE picked_up = '0' AND username = '" + _Username + "' LIMIT 1");
                                dbClient.Close();
                                sendData("DH");
                                userManager.sendToRank(Config.Minimum_CFH_Rank, true, "BT" + Encoding.encodeVL64(cfhID) + Convert.ToChar(2) + "I" + "User Deleted!" + Convert.ToChar(2) + "User Deleted!" + Convert.ToChar(2) + "User Deleted!" + Convert.ToChar(2) + Encoding.encodeVL64(0) + Convert.ToChar(2) + "" + Convert.ToChar(2) + "H" + Convert.ToChar(2) + Encoding.encodeVL64(0));
                                break;
                            }

                        case "AV": // User sends CFH message
                            {
                                Database dbClient = new Database(true, true, 90);
                                if (dbClient.findsResult("SELECT id FROM cms_help WHERE username = '" + _Username + "' AND picked_up = '0'") == true)
                                    return;
                                int messageLength = Encoding.decodeB64(currentPacket.Substring(2, 2));
                                if (messageLength == 0)
                                    return;
                                string cfhMessage = currentPacket.Substring(4, messageLength);
                                dbClient = new Database(false, false, 91);
                                dbClient.addParameterWithValue("username", _Username);
                                dbClient.addParameterWithValue("ip", connectionSocket.RemoteEndPoint.ToString().Split(Char.Parse(":"))[0]);
                                dbClient.addParameterWithValue("message", cfhMessage);
                                dbClient.addParameterWithValue("date", DateTime.Now);
                                dbClient.addParameterWithValue("roomid", _roomID.ToString());
                                dbClient.Open();
                                dbClient.runQuery("INSERT INTO cms_help (username,ip,message,date,picked_up,subject,roomid) VALUES (@username,@ip,@message,@date,'0','CFH message [hotel]',@roomid)");
                                int cfhID = dbClient.getInteger("SELECT id FROM cms_help WHERE username = @username AND picked_up = '0'");
                                string roomName = dbClient.getString("SELECT name FROM rooms WHERE id = @roomid");//                                                                                                                       H = Hide Room ID / I = Show Room ID
                                dbClient.Close();                                                                       //       H = Automated / I = Manual    
                                sendData("EAH"); //                                                                                           \_/                                                                                                                                                                                                    \_/
                                userManager.sendToRank(Config.Minimum_CFH_Rank, true, "BT" + Encoding.encodeVL64(cfhID) + Convert.ToChar(2) + "I" + "Sent: " + DateTime.Now + Convert.ToChar(2) + _Username + Convert.ToChar(2) + cfhMessage + Convert.ToChar(2) + Encoding.encodeVL64(_roomID) + Convert.ToChar(2) + roomName + Convert.ToChar(2) + "I" + Convert.ToChar(2) + Encoding.encodeVL64(_roomID));
                                break;
                            }
                        #endregion

                        #region Staff Side
                        case "CG": // CFH center - reply call
                            {
                                if (rankManager.containsRight(_Rank, "fuse_receive_calls_for_help") == false)
                                    return;
                                int cfhID = Encoding.decodeVL64(currentPacket.Substring(4, Encoding.decodeB64(currentPacket.Substring(2, 2))));
                                string cfhReply = currentPacket.Substring(Encoding.decodeB64(currentPacket.Substring(2, 2)) + 6);

                                Database dbClient = new Database(true, false, 92);
                                string toUserName = dbClient.getString("SELECT username FROM cms_help WHERE id = '" + cfhID + "'");
                                if (toUserName == null)
                                    sendData("BK" + stringManager.getString("cfh_fail"));
                                else
                                {
                                    int toUserID = userManager.getUserID(toUserName);
                                    virtualUser toVirtualUser = userManager.getUser(toUserID);
                                    if (toVirtualUser._isLoggedIn)
                                    {
                                        toVirtualUser.sendData("DR" + cfhReply + Convert.ToChar(2));
                                        dbClient.runQuery("UPDATE cms_help SET picked_up = '" + _Username + "' WHERE id = '" + cfhID + "' LIMIT 1");
                                    }
                                }
                                dbClient.Close();
                                break;
                            }

                        case "CF": // CFH center - Delete (Downgrade)
                            {
                                if (rankManager.containsRight(_Rank, "fuse_receive_calls_for_help") == false)
                                    return;
                                int cfhID = Encoding.decodeVL64(currentPacket.Substring(4, Encoding.decodeB64(currentPacket.Substring(2, 2))));
                                Database dbClient = new Database(true, false, 93);
                                DataRow dRow = dbClient.getRow("SELECT picked_up FROM cms_help WHERE id = '" + cfhID + "'");
                                if (dRow.Table.Columns.Count == 0)
                                {
                                    dbClient.Close();
                                    return;
                                }
                                else
                                {
                                    dbClient.runQuery("DELETE FROM cms_help WHERE id = '" + cfhID + "' LIMIT 1");
                                    userManager.sendToRank(Config.Minimum_CFH_Rank, true, "BT" + Encoding.encodeVL64(cfhID) + Convert.ToChar(2) + "H" + "Staff Deleted!" + Convert.ToChar(2) + "Staff Deleted!" + Convert.ToChar(2) + "Staff Deleted!" + Convert.ToChar(2) + "H" + Convert.ToChar(2) + Convert.ToChar(2) + "H" + Convert.ToChar(2) + "H");
                                }
                                dbClient.Close();
                                break;
                            }

                        case "@p": // CFH center - Pickup
                            {
                                int cfhID = Encoding.decodeVL64(currentPacket.Substring(4));
                                Database dbClient = new Database(true, false, 94);
                                if (dbClient.findsResult("SELECT id FROM cms_help WHERE id = '" + cfhID + "'") == false)
                                {
                                    sendData("BK" + stringManager.getString("cfh_deleted"));
                                    dbClient.Close();
                                    return;
                                }
                                DataRow dRow = dbClient.getRow("SELECT picked_up,username,message,roomid FROM cms_help WHERE id = '" + cfhID + "'");
                                string roomName = dbClient.getString("SELECT name FROM rooms WHERE id = '" + Convert.ToString(dRow[3]) + "'");
                                if (Convert.ToString(dRow[0]) == "1")
                                    sendData("BK" + stringManager.getString("cfh_picked_up"));
                                else
                                    userManager.sendToRank(Config.Minimum_CFH_Rank, true, "BT" + Encoding.encodeVL64(cfhID) + Convert.ToChar(2) + "I" + "Picked up: " + DateTime.Now + Convert.ToChar(2) + Convert.ToString(dRow[1]) + Convert.ToChar(2) + Convert.ToString(dRow[2]) + Convert.ToChar(2) + Encoding.encodeVL64(Convert.ToInt32(dRow[3])) + Convert.ToChar(2) + roomName + Convert.ToChar(2) + "I" + Convert.ToChar(2) + Encoding.encodeVL64(Convert.ToInt32(dRow[3])));
                                dbClient.runQuery("UPDATE cms_help SET picked_up = '1' WHERE id = '" + cfhID + "' LIMIT 1");
                                dbClient.Close();
                                break;
                            }

                        case "EC": // Go to the room that the call for help was sent from
                            {
                                if (rankManager.containsRight(_Rank, "fuse_receive_calls_for_help") == false)
                                    return;
                                int idLength = Encoding.decodeB64(currentPacket.Substring(2, 2));
                                int cfhID = Encoding.decodeVL64(currentPacket.Substring(4, idLength));
                                Database dbClient = new Database(true, true, 95);
                                int roomID = dbClient.getInteger("SELECT roomid FROM cms_help WHERE id = '" + cfhID + "'");
                                if (roomID == 0)
                                    return;
                                virtualRoom room = roomManager.getRoom(roomID);
                                if (room.isPublicroom)
                                    sendData("D^" + "I" + Encoding.encodeVL64(roomID));
                                else
                                    sendData("D^" + "H" + Encoding.encodeVL64(roomID));

                                break;
                            }
                        #endregion
                        #endregion
                        #endregion

                        #region In-room actions
                        #region Misc
                        case "AO": // Room - rotate user
                            {
                                if (Room != null && roomUser != null && statusManager.containsStatus("sit") == false && statusManager.containsStatus("lay") == false)
                                {
                                    int X = int.Parse(currentPacket.Substring(2).Split(' ')[0]);
                                    int Y = int.Parse(currentPacket.Split(' ')[1]);
                                    roomUser.Z1 = Rooms.Pathfinding.Rotation.Calculate(roomUser.X, roomUser.Y, X, Y);
                                    roomUser.Z2 = roomUser.Z1;
                                    roomUser.Refresh();
                                }
                                break;
                            }

                        case "AK": // Room - walk to a new square
                            {
                                if (Room != null && roomUser != null && roomUser.walkLock == false)
                                {
                                    int goalX = Encoding.decodeB64(currentPacket.Substring(2, 2));
                                    int goalY = Encoding.decodeB64(currentPacket.Substring(4, 2));

                                    if (roomUser.SPECIAL_TELEPORTABLE)
                                    {
                                        roomUser.X = goalX;
                                        roomUser.Y = goalY;
                                        roomUser.goalX = -1;
                                        Room.Refresh(roomUser);
                                        refreshAppearance(false, false, true);
                                    }
                                    else
                                    {
                                        roomUser.goalX = goalX;
                                        roomUser.goalY = goalY;
                                    }
                                }
                                break;
                            }

                        case "As": // Room - click door to exit room
                            {
                                if (Room != null && roomUser != null && roomUser.walkDoor == false)
                                {
                                    roomUser.walkDoor = true;
                                    roomUser.goalX = Room.doorX;
                                    roomUser.goalY = Room.doorY;
                                }
                                break;
                            }

                        case "At": // Room - select swimming outfit
                            {
                                if (Room != null || roomUser != null && Room.hasSwimmingPool)
                                {
                                    virtualRoom.squareTrigger Trigger = Room.getTrigger(roomUser.X, roomUser.Y);
                                    if (Trigger.Object == "curtains1" || Trigger.Object == "curtains2")
                                    {
                                        roomUser.SwimOutfit = currentPacket.Substring(2);
                                        Room.sendData(@"@\" + roomUser.detailsString);
                                        Room.sendSpecialCast(Trigger.Object, "open");
                                        roomUser.walkLock = false;
                                        roomUser.goalX = Trigger.goalX;
                                        roomUser.goalY = Trigger.goalY;

                                        Database dbClient = new Database(false, true, 96);
                                        dbClient.addParameterWithValue("figure_swim", currentPacket.Substring(2));
                                        dbClient.addParameterWithValue("id", userID);
                                        dbClient.Open();
                                        dbClient.runQuery("UPDATE users SET figure_swim = @figure_swim WHERE id = @id LIMIT 1");
                                    }
                                }
                                break;
                            }

                        case "B^": // Badges - switch or toggle on/off badge
                            {
                                if (Room != null && roomUser != null)
                                {
                                    int badgeLength = Encoding.decodeB64(currentPacket.Substring(2, 2));
                                    int badgeEnabled = Encoding.decodeVL64(currentPacket.Substring(badgeLength + 4, 1));
                                    if (badgeEnabled != 0 && badgeEnabled != 1)
                                        return;

                                    Database dbClient = new Database(false, false, 97);
                                    dbClient.addParameterWithValue("userid", userID);
                                    dbClient.addParameterWithValue("badgeida", currentPacket.Substring(4, badgeLength));
                                    dbClient.addParameterWithValue("badgeidb", _nowBadge);
                                    dbClient.addParameterWithValue("badge_status", badgeEnabled.ToString());
                                    dbClient.Open();
                                    if (dbClient.findsResult("SELECT userid FROM users_badges WHERE userid = @userid AND badgeid = @badgeida") == false)
                                    {
                                        dbClient.Close(); 
                                        return;
                                    }

                                    dbClient.runQuery("UPDATE users SET badge_status = @badge_status WHERE id = @userid LIMIT 1");
                                    dbClient.runQuery("UPDATE users_badges SET iscurrent = '0' WHERE userid = @userid AND badgeid = @badgeidb LIMIT 1");
                                    dbClient.runQuery("UPDATE users_badges SET iscurrent = '1' WHERE userid = @userid AND badgeid = @badgeida LIMIT 1");
                                    dbClient.Close();
                                    string newStatus = "Cd" + Encoding.encodeVL64(roomUser.roomUID);
                                    if (badgeEnabled == 1)
                                    {
                                        _nowBadge = currentPacket.Substring(4, badgeLength);
                                        newStatus += currentPacket.Substring(4, badgeLength) + Convert.ToChar(2);
                                    }
                                    else
                                        _nowBadge = "";

                                    Room.sendData(newStatus);
                                }
                                break;
                            }

                        case "DG": // Tags - get tags of virtual user
                            {
                                int ownerID = Encoding.decodeVL64(currentPacket.Substring(2));
                                Database dbClient = new Database(true, true, 98);
                                DataColumn dCol = dbClient.getColumn("SELECT tag FROM cms_tags WHERE ownerid = '" + ownerID + "' LIMIT 20");
                                StringBuilder List = new StringBuilder(Encoding.encodeVL64(ownerID) + Encoding.encodeVL64(dCol.Table.Rows.Count));
                                foreach(DataRow dRow in dCol.Table.Rows)
                                    List.Append(Convert.ToInt32(dRow["tag"]) + Convert.ToChar(2));
                                sendData("E^" + List.ToString());
                                break;
                            }

                        case "Cg": // Group badges - get details about a group [click badge]
                            {
                                if (Room != null && roomUser != null)
                                {
                                    int groupID = Encoding.decodeVL64(currentPacket.Substring(2));
                                    Database dbClient = new Database(true, false, 99);
                                    DataRow dRow = dbClient.getRow("SELECT name,description,roomid FROM groups_details WHERE id = '" + groupID + "'");
                                    if (dRow.Table.Rows.Count == 1)
                                    {
                                        string roomName = "";
                                        int roomID = Convert.ToInt32(dRow["roomid"]);
                                        if (roomID > 0)
                                            roomName = dbClient.getString("SELECT name FROM rooms WHERE id = '" + roomID + "'");
                                        else
                                            roomID = -1;

                                        sendData("Dw" + Encoding.encodeVL64(groupID) + Convert.ToString(dRow["name"]) + Convert.ToChar(2) + Convert.ToString(dRow["description"]) + Convert.ToChar(2) + Encoding.encodeVL64(Convert.ToInt32(dRow["roomid"])) + roomName + Convert.ToChar(2));
                                    }
                                    dbClient.Close();
                                }                                
                                break;
                            }

                        case "AX": // Statuses - stop status
                            {
                                if (statusManager != null)
                                {
                                    string Status = currentPacket.Substring(2);
                                    if (Status == "CarryItem")
                                        statusManager.dropCarrydItem();
                                    else if (Status == "Dance")
                                    {
                                        statusManager.removeStatus("dance");
                                        statusManager.Refresh();
                                    }
                                }
                                break;
                            }

                        case "A^": // Statuses - wave
                            {
                                if (Room != null && roomUser != null && statusManager.containsStatus("wave") == false)
                                {
                                    statusManager.removeStatus("dance");
                                    statusManager.handleStatus("wave", "", Config.Statuses_Wave_waveDuration);
                                }
                                break;
                            }

                        case "A]": // Statuses - dance
                            {
                                if (Room != null && roomUser != null && statusManager.containsStatus("sit") == false && statusManager.containsStatus("lay") == false)
                                {
                                    statusManager.dropCarrydItem();
                                    if (currentPacket.Length == 2)
                                        statusManager.addStatus("dance", "");
                                    else
                                    {
                                        if (rankManager.containsRight(_Rank, "fuse_use_club_dance") == false) { return; }
                                        int danceID = Encoding.decodeVL64(currentPacket.Substring(2));
                                        if (danceID < 0 || danceID > 4) { return; }
                                        statusManager.addStatus("dance", danceID.ToString());
                                    }

                                    statusManager.Refresh();
                                }
                                break;
                            }

                        case "AP": // Statuses - carry item
                            {
                                if (Room != null && roomUser != null)
                                {
                                    string Item = currentPacket.Substring(2);
                                    if (statusManager.containsStatus("lay") || Item.Contains("/"))
                                        return; // THE HAX! \o/

                                    try
                                    {
                                        int nItem = int.Parse(Item);
                                        if (nItem < 1 || nItem > 26)
                                            return;
                                    }
                                    catch
                                    {
                                        if (_inPublicroom == false && Item != "Water" && Item != "Milk" && Item != "Juice") // Not a drink that can be retrieved from the infobus minibar
                                            return;
                                    }
                                    statusManager.carryItem(Item);
                                }
                                break;
                            }

                        case "Ah": // Statuses - Lido Voting
                            {
                                if (Room != null && roomUser != null && statusManager.containsStatus("sit") == false && statusManager.containsStatus("lay") == false)
                                {
                                    if (currentPacket.Length == 2)
                                        statusManager.addStatus("sign", "");
                                    else
                                    {
                                        string signID = currentPacket.Substring(2);
                                        statusManager.handleStatus("sign", signID, Config.Statuses_Wave_waveDuration);
                                    }

                                    statusManager.Refresh();
                                }
                                break;
                            }

                        //\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//
                        // I never released the full poll code and I do not have it anymore (I lost it). I can not be bothered to code it again. This code has been disabled and skiped \\
                        //\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//
                        //case "Cl": // Room Poll - answer
                        //    {
                        //        if (Room == null || roomUser == null)
                        //            return;
                        //        int subStringSkip = 2;
                        //        int pollID = Encoding.decodeVL64(currentPacket.Substring(subStringSkip));
                        //        if (DB.checkExists("SELECT aid FROM poll_results WHERE uid = '" + userID + "' AND pid = '" + pollID + "'"))
                        //            return;
                        //        subStringSkip += Encoding.encodeVL64(pollID).Length;
                        //        int questionID = Encoding.decodeVL64(currentPacket.Substring(subStringSkip));
                        //        subStringSkip += Encoding.encodeVL64(questionID).Length;
                        //        bool typeThree = DB.checkExists("SELECT type FROM poll_questions WHERE qid = '" + questionID + "' AND type = '3'");
                        //        if (typeThree)
                        //        {
                        //            int countAnswers = Encoding.decodeB64(currentPacket.Substring(subStringSkip, 2));
                        //            subStringSkip += 2;
                        //            string Answer = DB.Stripslash(currentPacket.Substring(subStringSkip, countAnswers));
                        //            DB.runQuery("INSERT INTO poll_results (pid,qid,aid,answers,uid) VALUES ('" + pollID + "','" + questionID + "','0','" + Answer + "','" + userID + "')");
                        //        }
                        //        else
                        //        {
                        //            int countAnswers = Encoding.decodeVL64(currentPacket.Substring(subStringSkip));
                        //            subStringSkip += Encoding.encodeVL64(countAnswers).Length;
                        //            int[] Answer = new int[countAnswers];
                        //            for (int i = 0; i < countAnswers; i++)
                        //            {
                        //                Answer[i] = Encoding.decodeVL64(currentPacket.Substring(subStringSkip));
                        //                subStringSkip += Encoding.encodeVL64(Answer[i]).Length;
                        //            }
                        //            foreach (int a in Answer)
                        //            {
                        //                DB.runQuery("INSERT INTO poll_results (pid,qid,aid,answers,uid) VALUES ('" + pollID + "','" + questionID + "','" + a + "',' ','" + userID + "')");
                        //            }
                        //        }
                        //        break;
                        //    }
                        #endregion

                        #region Chat
                        case "@t": // Chat - say
                        case "@w": // Chat - shout
                            {
                                try
                                {
                                    if (_isMuted == false && (Room != null && roomUser != null))
                                    {
                                        string Message = currentPacket.Substring(4);
                                        userManager.addChatMessage(_Username, _roomID, Message);
                                        Message = stringManager.filterSwearwords(Message);
                                        if (Message.Substring(0, 1) == ":" && isSpeechCommand(Message.Substring(1))) // Speechcommand invoked!
                                        {
                                            if (roomUser.isTyping)
                                            {
                                                Room.sendData("Ei" + Encoding.encodeVL64(roomUser.roomUID) + "H");
                                                roomUser.isTyping = false;
                                            }
                                        }
                                        else
                                        {
                                            if (currentPacket.Substring(1, 1) == "w") // Shout
                                            {
                                                Room.sendShout(roomUser, Message);
                                            }
                                            else
                                            {
                                                Room.sendSaying(roomUser, Message);
                                                //Out.WriteChat("Say", _Username, Message); 
                                            }
                                        }
                                    }
                                }
                                catch (Exception e)
                                {
                                    Out.WriteError(e.ToString());
                                }
                                break;
                            }

                        case "@x": // Chat - whisper
                            {
                                if (_isMuted == false && Room != null && roomUser != null)
                                {
                                    string Receiver = currentPacket.Substring(4).Split(' ')[0];
                                    string Message = currentPacket.Substring(Receiver.Length + 5);
                                    userManager.addChatMessage(_Username, _roomID, Message);

                                    Message = stringManager.filterSwearwords(Message);
                                    Room.sendWhisper(roomUser, Receiver, Message);
                                    //Out.WriteChat("Whisper", _Username + "-" + Receiver, Message); 
                                }
                                break;
                            }

                        case "D}": // Chat - show speech bubble
                            {
                                if (_isMuted == false && Room != null && roomUser != null)
                                {
                                    Room.sendData("Ei" + Encoding.encodeVL64(roomUser.roomUID) + "I");
                                    roomUser.isTyping = true;
                                }
                                break;
                            }

                        case "D~": // Chat - hide speech bubble
                            {
                                if (Room != null && roomUser != null)
                                {
                                    Room.sendData("Ei" + Encoding.encodeVL64(roomUser.roomUID) + "H");
                                    roomUser.isTyping = false;
                                }
                                break;
                            }
                        #endregion

                        #region Guestroom - rights, kicking, roombans and room voting
                        case "A`": // Give rights
                            {
                                if (Room == null || roomUser == null || _inPublicroom || _isOwner == false)
                                    return;

                                string Target = currentPacket.Substring(2);
                                if (userManager.containsUser(Target) == false)
                                    return;

                                virtualUser _Target = userManager.getUser(Target);
                                if (_Target._roomID != _roomID || _Target._hasRights || _Target._isOwner)
                                    return;

                                Database dbClient = new Database(true, true, 100);
                                dbClient.runQuery("INSERT INTO room_rights(roomid,userid) VALUES ('" + _roomID + "','" + _Target.userID + "')");
                                _Target._hasRights = true;
                                _Target.statusManager.addStatus("flatctrl", "onlyfurniture");
                                _Target.roomUser.Refresh();
                                _Target.sendData("@j");
                                break;
                            }

                        case "Aa": // Take rights
                            {
                                if (Room == null || roomUser == null || _inPublicroom || _isOwner == false)
                                    return;

                                string Target = currentPacket.Substring(2);
                                if (userManager.containsUser(Target) == false)
                                    return;

                                virtualUser _Target = userManager.getUser(Target);
                                if (_Target._roomID != _roomID || _Target._hasRights == false || _Target._isOwner)
                                    return;

                                Database dbClient = new Database(true,true, 101);
                                dbClient.runQuery("DELETE FROM room_rights WHERE roomid = '" + _roomID + "' AND userid = '" + _Target.userID + "' LIMIT 1");
                                _Target._hasRights = false;
                                _Target.statusManager.removeStatus("flatctrl");
                                _Target.roomUser.Refresh();
                                _Target.sendData("@k");
                                break;
                            }

                        case "A_": // Kick user
                            {
                                if (Room == null || roomUser == null || _inPublicroom || _hasRights == false)
                                    return;

                                string Target = currentPacket.Substring(2);
                                if (userManager.containsUser(Target) == false)
                                    return;

                                virtualUser _Target = userManager.getUser(Target);
                                if (_Target._roomID != _roomID)
                                    return;

                                if (_Target._isOwner && (_Target._Rank > _Rank || rankManager.containsRight(_Target._Rank, "fuse_any_room_controller")))
                                    return;

                                _Target.roomUser.walkLock = true;
                                _Target.roomUser.walkDoor = true;
                                _Target.roomUser.goalX = Room.doorX;
                                _Target.roomUser.goalY = Room.doorY;
                                break;
                            }

                        case "E@": // Kick and apply roomban
                            {
                                if (_hasRights == false || _inPublicroom || Room == null || roomUser == null)
                                    return;

                                string Target = currentPacket.Substring(2);
                                if (userManager.containsUser(Target) == false)
                                    return;

                                virtualUser _Target = userManager.getUser(Target);
                                if (_Target._roomID != _roomID)
                                    return;

                                if (_Target._isOwner && (_Target._Rank > _Rank || rankManager.containsRight(_Target._Rank, "fuse_any_room_controller")))
                                    return;

                                string banExpireMoment = DateTime.Now.AddMinutes(Config.Rooms_roomBan_banDuration).ToString();
                                Database dbClient = new Database(true, true, 102);
                                dbClient.runQuery("INSERT INTO room_bans (roomid,userid,ban_expire) VALUES ('" + _roomID + "','" + _Target.userID + "','" + banExpireMoment + "')");

                                _Target.roomUser.walkLock = true;
                                _Target.roomUser.walkDoor = true;
                                _Target.roomUser.goalX = Room.doorX;
                                _Target.roomUser.goalY = Room.doorY;
                                break;
                            }

                        case "DE": // Vote -1 or +1 on room
                            {
                                if (_inPublicroom || Room == null || roomUser == null)
                                    return;

                                int Vote = Encoding.decodeVL64(currentPacket.Substring(2));
                                Database dbClient = new Database(true, false, 103);
                                if ((Vote == 1 || Vote == -1) && dbClient.findsResult("SELECT userid FROM room_votes WHERE userid = '" + userID + "' AND roomid = '" + _roomID + "'") == false)
                                {
                                    dbClient.runQuery("INSERT INTO room_votes (userid,roomid,vote) VALUES ('" + userID + "','" + _roomID + "','" + Vote + "')");
                                    int voteAmount = dbClient.getInteger("SELECT SUM(vote) FROM room_votes WHERE roomid = '" + _roomID + "'");
                                    if (voteAmount < 0)
                                        voteAmount = 0;
                                    roomUser.hasVoted = true;
                                    if (_isOwner == true)
                                        Room.sendNewVoteAmount(voteAmount);
                                }
                                dbClient.Close();
                                break;
                            }

                        #endregion

                        #region Catalogue and Recycler
                        case "Ae": // Catalogue - open, retrieve index of pages
                            {
                                if (Room != null && roomUser != null)
                                    sendData("A~" + catalogueManager.getPageIndex(_Rank));

                                break;
                            }

                        case "Af": // Catalogue, open page, get page content
                            {
                                if (Room != null && roomUser != null)
                                {
                                    string pageIndexName = currentPacket.Split('/')[1];
                                    sendData("A" + catalogueManager.getPage(pageIndexName, _Rank));
                                }
                                break;
                            }

                        case "Ad": // Catalogue - purchase
                            {
                                string[] packetContent = currentPacket.Split(Convert.ToChar(13));
                                string Page = packetContent[1];
                                string Item = packetContent[3];

                                Database dbClient = new Database(false, false, 104);
                                dbClient.addParameterWithValue("indexname", Page);
                                dbClient.addParameterWithValue("name_cct", Item);
                                dbClient.Open();
                                int pageID = dbClient.getInteger("SELECT indexid FROM catalogue_pages WHERE indexname = @indexname AND minrank <= " + _Rank);
                                int templateID = dbClient.getInteger("SELECT tid FROM catalogue_items WHERE name_cct = @name_cct");
                                int Cost = dbClient.getInteger("SELECT catalogue_cost FROM catalogue_items WHERE catalogue_id_page = '" + pageID + "' AND tid = '" + templateID + "'");
                                if (Cost == 0 || Cost > _Credits) { sendData("AD"); dbClient.Close(); return; }

                                int receiverID = userID;
                                int presentBoxID = 0;
                                int roomID = 0; // -1 = present box, 0 = inhand

                                if (packetContent[5] == "1") // Purchased as present
                                {
                                    string receiverName = packetContent[6];
                                    dbClient.Close();
                                    dbClient = new Database(false, false, 105);
                                    dbClient.addParameterWithValue("name", receiverName);
                                    dbClient.Open();
                                    if (receiverName != _Username)
                                    {
                                        int i = dbClient.getInteger("SELECT id FROM users WHERE name = @name");
                                        if (i > 0)
                                            receiverID = i;
                                        else
                                        {
                                            sendData("AL" + receiverName);
                                            dbClient.Close();
                                            return;
                                        }
                                    }

                                    string boxSprite = "present_gen" + new Random().Next(1, 7);
                                    string boxTemplateID = dbClient.getString("SELECT tid FROM catalogue_items WHERE name_cct = '" + boxSprite + "'");
                                    dbClient.Close();
                                    dbClient = new Database(false, false, 106);
                                    dbClient.addParameterWithValue("tid", boxTemplateID);
                                    dbClient.addParameterWithValue("ownerid", receiverID);
                                    dbClient.addParameterWithValue("var", "!" + stringManager.filterSwearwords(packetContent[7]));
                                    dbClient.Open();
                                    dbClient.runQuery("INSERT INTO furniture(tid,ownerid,var) VALUES (@tid,@ownerid,@var)");
                                    presentBoxID = catalogueManager.lastItemID;
                                    roomID = -1;
                                }

                                _Credits -= Cost;
                                sendData("@F" + _Credits);
                                dbClient.runQuery("UPDATE users SET credits = '" + _Credits + "' WHERE id = '" + userID + "' LIMIT 1");

                                if (stringManager.getStringPart(Item, 0, 4) == "deal")
                                {
                                    int dealID = int.Parse(Item.Substring(4));
                                    DataTable dTable = dbClient.getTable("SELECT tid,amount FROM catalogue_deals WHERE id = '" + dealID + "'");
                                    StringBuilder sb = new StringBuilder();
                                    foreach(DataRow dRow in dTable.Rows)
                                    {
                                        for(int i = 0; i <= Convert.ToInt32(dRow["amount"]); i++)
                                            sb.Append(",('" + Convert.ToString(dRow["tid"]) + "','" + receiverID + "','" + roomID + "')");
                                        dbClient.runQuery("INSERT INTO furniture(tid,ownerid,roomid) VALUES " + sb.ToString().Substring(1));
                                        for(int i = 0; i <= Convert.ToInt32(dRow["amount"]); i++)
                                            catalogueManager.handlePurchase(Convert.ToInt32(dRow["tid"]), receiverID, roomID, 0, presentBoxID);
                                    }
                                }
                                else
                                {
                                    dbClient.runQuery("INSERT INTO furniture(tid,ownerid,roomid) VALUES ('" + templateID + "','" + receiverID + "','" + roomID + "')");
                                    
                                    if (catalogueManager.getTemplate(templateID).Sprite == "wallpaper" || catalogueManager.getTemplate(templateID).Sprite == "floor")
                                    {
                                        int decorID = int.Parse(packetContent[4]);
                                        catalogueManager.handlePurchase(templateID, receiverID, 0, decorID, presentBoxID);
                                    }
                                    else if (stringManager.getStringPart(Item, 0, 11) == "prizetrophy")
                                    {
                                    }
                                    else if (stringManager.getStringPart(Item, 0, 11) == "greektrophy")
                                    {
                                        dbClient.Close();
                                        dbClient = new Database(false, false, 107);
                                        dbClient.addParameterWithValue("var", _Username + "\t" + DateTime.Today.ToShortDateString() + "\t" + stringManager.filterSwearwords(packetContent[4]));
                                        dbClient.addParameterWithValue("id ", catalogueManager.lastItemID);
                                        dbClient.Open();
                                        dbClient.runQuery("UPDATE furniture SET var = @var WHERE id = @id LIMIT 1");
                                        //"H" + GIVERNAME + [09] + GIVEDATE + [09] + MSG
                                    }
                                    else
                                        catalogueManager.handlePurchase(templateID, receiverID, roomID, 0, presentBoxID);
                                }

                                dbClient.Close();
                                if (receiverID == userID)
                                    refreshHand("last");
                                else
                                    if (userManager.containsUser(receiverID)) { userManager.getUser(receiverID).refreshHand("last"); }
                                //if (presentBoxID > 0)
                                //Out.WriteLine(_Username + " Buy a present.");
                                break;
                            }

                        case "Ai": // Buy game-tickets
                            {
                                string args = currentPacket.Substring(2);
                                int Amount = Encoding.decodeVL64(args.Substring(0, 3));
                                string Receiver = args.Substring(3);
                                int Ticketamount = 0;
                                int Price = 0;

                                if (Amount == 1) // Look how much tickets you want
                                {
                                    Ticketamount = 2;
                                    Price = 1;
                                }
                                else if (Amount == 2) // And again
                                {
                                    Ticketamount = 20;
                                    Price = 6;
                                }
                                else // Wrong parameter
                                    return;

                                if (Price > _Credits) // Enough credits?
                                {
                                    sendData("AD");
                                    return;
                                }

                                Database dbClient = new Database(false, false, 108);
                                dbClient.addParameterWithValue("name", Receiver);
                                dbClient.Open();
                                int ReceiverID = dbClient.getInteger("SELECT id FROM users WHERE name = @name");
                                if (!(ReceiverID > 0)) // Does the user exist?
                                {
                                    sendData("AL" + Receiver);
                                    dbClient.Close();
                                    return;
                                }

                                _Credits -= Price; // New credit amount
                                sendData("@F" + _Credits); // Send the new credits
                                dbClient.runQuery("UPDATE users SET credits = '" + _Credits + "' WHERE id = '" + userID + "' LIMIT 1");
                                // Update receivers ticketamount
                                dbClient.runQuery("UPDATE users SET tickets = tickets+" + Ticketamount + " WHERE id = '" + ReceiverID + "' LIMIT 1");
                                dbClient.Close();

                                if (userManager.containsUser(ReceiverID)) // Check or the user is online
                                {
                                    virtualUser _Receiver = userManager.getUser(ReceiverID); // Get him/her
                                    _Receiver._Tickets = _Receiver._Tickets + Ticketamount; // Update ticketamount

                                    if (ReceiverID == userID) // Stop double kaching
                                        _Receiver.refreshValueables(false, true); // Kaching!
                                    else
                                        _Receiver.refreshValueables(true, true); // Kaching!
                                }


                                break;
                            }  

                        case "Ca": // Recycler - proceed input items
                            {
                                if (Config.enableRecycler == false || Room == null || recyclerManager.sessionExists(userID))
                                    return;

                                int itemCount = Encoding.decodeVL64(currentPacket.Substring(2));
                                if (recyclerManager.rewardExists(itemCount))
                                {
                                    recyclerManager.createSession(userID, itemCount);
                                    currentPacket = currentPacket.Substring(Encoding.encodeVL64(itemCount).ToString().Length + 2);
                                    for (int i = 0; i < itemCount; i++)
                                    {
                                        int itemID = Encoding.decodeVL64(currentPacket);
                                        Database dbClient = new Database(true, false, 109);
                                        if(dbClient.findsResult("SELECT id FROM furniture WHERE ownerid = '" + userID + "' AND roomid = '0'"))
                                        {
                                            dbClient.runQuery("UPDATE furniture SET roomid = '-2' WHERE id = '" + itemID + "' LIMIT 1");
                                            currentPacket = currentPacket.Substring(Encoding.encodeVL64(itemID).ToString().Length);
                                        }
                                        else
                                        {
                                            recyclerManager.dropSession(userID, true);
                                            sendData("DpH");
                                            dbClient.Close();
                                            return;
                                        }
                                        dbClient.Close();
                                    }

                                    sendData("Dp" + recyclerManager.sessionString(userID));
                                    refreshHand("update");
                                }

                                break;
                            }

                        case "Cb": // Recycler - redeem/cancel session
                            {
                                if (Config.enableRecycler == false || Room != null && recyclerManager.sessionExists(userID))
                                {
                                    bool Redeem = (currentPacket.Substring(2) == "I");
                                    if (Redeem && recyclerManager.sessionReady(userID))
                                        recyclerManager.rewardSession(userID);
                                    recyclerManager.dropSession(userID, Redeem);

                                    sendData("Dp" + recyclerManager.sessionString(userID));
                                    if (Redeem)
                                        refreshHand("last");
                                    else
                                        refreshHand("new");
                                }
                                break;
                            }
                        #endregion

                        #region Hand and item handling
                        case "AA": // Hand
                            {
                                if (Room == null || roomUser == null)
                                    return;

                                string Mode = currentPacket.Substring(2);
                                refreshHand(Mode);
                                break;
                            }

                        case "LB": // Hand
                            {
                                if (Room == null || roomUser == null)
                                    return;

                                string Mode = currentPacket.Substring(2);
                                refreshHand(Mode);
                                break;
                            }

                        case "AB": // Item handling - apply wallpaper/floor/landscape to room
                            {
                                if (_hasRights == false || _inPublicroom || Room == null || roomUser == null)
                                    return;

                                int itemID = int.Parse(currentPacket.Split('/')[1]);
                                string decorType = currentPacket.Substring(2).Split('/')[0];
                                if (decorType != "wallpaper" && decorType != "floor" && decorType != "landscape") // Non-valid decoration type
                                    return;

                                Database dbClient = new Database(true, false, 110);
                                int templateID = dbClient.getInteger("SELECT tid FROM furniture WHERE id = '" + itemID + "' AND ownerid = '" + userID + "' AND roomid = '0'");
                                if (catalogueManager.getTemplate(templateID).Sprite != decorType) // This item isn't the decoration item the client thinks it is. (obv scripter) If the item wasn't found (so the user didn't owned the item etc), then an empty item template isn't required, which also doesn't match this condition
                                {
                                    dbClient.Close();
                                    return;
                                }
                                string decorVal = dbClient.getString("SELECT var FROM furniture WHERE id = '" + itemID + "'");
                                Room.sendData("@n" + decorType + "/" + decorVal); // "@n" (46) is a generic message for setting a room's decoration. Since the introduction of landscapes, it can be 'wallpaper', 'floor' and 'landscape'

                                dbClient.runQuery("UPDATE rooms SET " + decorType + " = '" + decorVal + "' WHERE id = '" + _roomID + "' LIMIT 1"); // Generates query like 'UPDATE rooms SET floor/wallpaper/landscape blabla' (the string decorType is containing either 'floor', 'wallpaper' or 'landscape')
                                dbClient.runQuery("DELETE FROM furniture WHERE id = '" + itemID + "' LIMIT 1");
                                dbClient.Close();
                            }
                            break;  


                        case "AZ": // Item handling - place item down
                            {
                                if (_hasRights == false || _inPublicroom || Room == null || roomUser == null)
                                    return;

                                int itemID = int.Parse(currentPacket.Split(' ')[0].Substring(2));
                                Database dbClient = new Database(true, false, 111);
                                int templateID = dbClient.getInteger("SELECT tid FROM furniture WHERE id = '" + itemID + "' AND ownerid = '" + userID + "' AND roomid = '0'");
                                if (templateID == 0)
                                {
                                    dbClient.Close();
                                    return;
                                }
                                if (catalogueManager.getTemplate(templateID).typeID == 0)
                                {
                                    string _INPUTPOS = currentPacket.Substring(itemID.ToString().Length + 3);
                                    string _CHECKEDPOS = catalogueManager.wallPositionOK(_INPUTPOS);
                                    if (_CHECKEDPOS != _INPUTPOS)
                                    {
                                        dbClient.Close();
                                        return;
                                    }

                                    string Var = dbClient.getString("SELECT var FROM furniture WHERE id = '" + itemID + "'");
                                    if (stringManager.getStringPart(catalogueManager.getTemplate(templateID).Sprite, 0, 7) == "post.it")
                                    {
                                        if (int.Parse(Var) > 1)
                                            dbClient.runQuery("UPDATE furniture SET var = var - 1 WHERE id = '" + itemID + "' LIMIT 1");
                                        else
                                            dbClient.runQuery("DELETE FROM furniture WHERE id = '" + itemID + "' LIMIT 1");
                                        dbClient.runQuery("INSERT INTO furniture(tid,ownerid) VALUES ('" + templateID + "','" + userID + "')");
                                        itemID = catalogueManager.lastItemID;
                                        dbClient.runQuery("INSERT INTO furniture_stickies(id) VALUES ('" + itemID + "')");
                                        Var = "FFFF33";
                                        dbClient.runQuery("UPDATE furniture SET var = '" + Var + "' WHERE id = '" + itemID + "' LIMIT 1");
                                    }
                                    else if (stringManager.getStringPart(catalogueManager.getTemplate(templateID).Sprite, 0, 10) == "roomdimmer")
                                        dbClient.runQuery("UPDATE furniture_moodlight SET roomid = '" + _roomID + "' WHERE id = '" + itemID + "' LIMIT 1");
                                    Room.wallItemManager.addItem(itemID, templateID, _CHECKEDPOS, Var, true);
                                }
                                else
                                {
                                    string[] locDetails = currentPacket.Split(' ');
                                    int X = int.Parse(locDetails[1]);
                                    int Y = int.Parse(locDetails[2]);
                                    byte Z = byte.Parse(locDetails[3]);
                                    byte typeID = catalogueManager.getTemplate(templateID).typeID;
                                    Room.floorItemManager.placeItem(itemID, templateID, X, Y, typeID, Z);
                                }
                                dbClient.Close();
                                break;
                            }

                        case "AC": // Item handling - pickup item
                            {
                                if (_isOwner == false || _inPublicroom || Room == null || roomUser == null)
                                    return;

                                int itemID = int.Parse(currentPacket.Split(' ')[2]);
                                if (Room.floorItemManager.containsItem(itemID))
                                    Room.floorItemManager.removeItem(itemID, userID);
                                else if (Room.wallItemManager.containsItem(itemID) && stringManager.getStringPart(Room.wallItemManager.getItem(itemID).Sprite, 0, 7) != "post.it") // Can't pickup stickies from room
                                    Room.wallItemManager.removeItem(itemID, userID);
                                else
                                    return;

                                refreshHand("update");
                                break;
                            }

                        case "AI": // Item handling - move/rotate item
                            {
                                if (_hasRights == false || _inPublicroom || Room == null || roomUser == null)
                                    return;

                                int itemID = int.Parse(currentPacket.Split(' ')[0].Substring(2));
                                if (Room.floorItemManager.containsItem(itemID))
                                {
                                    string[] locDetails = currentPacket.Split(' ');
                                    int X = int.Parse(locDetails[1]);
                                    int Y = int.Parse(locDetails[2]);
                                    byte Z = byte.Parse(locDetails[3]);

                                    Room.floorItemManager.relocateItem(itemID, X, Y, Z);
                                }
                                break;
                            }

                        case "CV": // Item handling - toggle wallitem status
                            {
                                if (_inPublicroom || Room == null || roomUser == null)
                                    return;

                                int itemID = int.Parse(currentPacket.Substring(4, Encoding.decodeB64(currentPacket.Substring(2, 2))));
                                int toStatus = Encoding.decodeVL64(currentPacket.Substring(itemID.ToString().Length + 4));
                                Room.wallItemManager.toggleItemStatus(itemID, toStatus);
                                break;
                            }

                        case "AJ": // Item handling - toggle flooritem status
                            {
                                try
                                {
                                    int itemID = int.Parse(currentPacket.Substring(4, Encoding.decodeB64(currentPacket.Substring(2, 2))));
                                    string toStatus = currentPacket.Substring(itemID.ToString().Length + 6);
                                    Room.floorItemManager.toggleItemStatus(itemID, toStatus, _hasRights);
                                }
                                catch { }
                                break;
                            }

                        case "AN": // Item handling - open presentbox
                            {
                                if (_isOwner == false || _inPublicroom || Room == null || roomUser == null)
                                    return;

                                int itemID = int.Parse(currentPacket.Substring(2));
                                if (Room.floorItemManager.containsItem(itemID) == false)
                                    return;

                                Database dbClient = new Database(true, false, 112);
                                DataColumn dCol = dbClient.getColumn("SELECT itemid FROM furniture_presents WHERE id = '" + itemID + "'");
                                if(dCol.Table.Rows.Count > 0)
                                {
                                    StringBuilder sb = new StringBuilder();
                                    int lastItemID = 0;
                                    foreach(DataRow dRow in dCol.Table.Rows)
                                    {
                                        sb.Append(" OR id = '" + Convert.ToString(dRow["itemid"]) + "'");
                                        lastItemID = Convert.ToInt32(dRow["itemid"]);
                                    }
                                    dbClient.runQuery("UPDATE furniture SET roomid = '-' WHERE " + sb.ToString().Substring(4));
                                    Room.floorItemManager.removeItem(itemID, 0);

                                    int lastItemTID = dbClient.getInteger("SELECT tid FROM furniture WHERE id = '" + lastItemID + "'");
                                    catalogueManager.itemTemplate Template = catalogueManager.getTemplate(lastItemTID);

                                    if(Template.typeID > 0)
                                        sendData("BA" + Template.Sprite + "\r" + Template.Sprite + "\r" + Template.Length + Convert.ToChar(30) + Template.Width + Convert.ToChar(30) + Template.Colour);
                                    else
                                        sendData("BA" + Template.Sprite + "\r" + Template.Sprite + " " + Template.Colour + "\r");
                                }
                                dbClient.runQuery("DELETE FROM furniture_presents WHERE id = '" + itemID + "' LIMIT " + dCol.Table.Rows.Count);
                                dbClient.runQuery("DELETE FROM furniture WHERE id = '" + itemID + "' LIMIT 1");
                                dbClient.Close();
                                refreshHand("last");
                                break;

                            }

                        case "Bw": // Item handling - redeem credit item
                            {
                                if (_isOwner == false || _inPublicroom || Room == null || roomUser == null)
                                    return;

                                int itemID = Encoding.decodeVL64(currentPacket.Substring(2));
                                if (Room.floorItemManager.containsItem(itemID))
                                {
                                    string Sprite = Room.floorItemManager.getItem(itemID).Sprite;
                                    if (Sprite.Substring(0, 3).ToLower() != "cf_" && Sprite.Substring(0, 3).ToLower() != "cfc_")
                                        return;
                                    int redeemValue = 0;
                                    try { redeemValue = int.Parse(Sprite.Split('_')[1]); }
                                    catch { return; }

                                    Room.floorItemManager.removeItem(itemID, 0);

                                    _Credits += redeemValue;
                                    sendData("@F" + _Credits);
                                    Database dbClient = new Database(true, true, 113);
                                    dbClient.runQuery("UPDATE users SET credits = '" + _Credits + "' WHERE id = '" + userID + "' LIMIT 1");
                                }
                                break;
                            }

                        case "AQ": // Item handling - teleporters - enter teleporter
                            {
                                if (_inPublicroom || Room == null || roomUser == null)
                                    return;

                                int itemID = int.Parse(currentPacket.Substring(2));
                                if (Room.floorItemManager.containsItem(itemID))
                                {
                                    Rooms.Items.floorItem Teleporter = Room.floorItemManager.getItem(itemID);
                                    // Prevent clientside 'jumps' to teleporter, check if user is removed one coord from teleporter entrance
                                    if (Teleporter.Z == 2 && roomUser.X != Teleporter.X + 1 && roomUser.Y != Teleporter.Y)
                                        return;
                                    else if (Teleporter.Z == 4 && roomUser.X != Teleporter.X && roomUser.Y != Teleporter.Y + 1)
                                        return;
                                    roomUser.goalX = -1;
                                    Room.moveUser(this.roomUser, Teleporter.X, Teleporter.Y, true);
                                }
                                break;
                            }

                        case @"@\": // Item handling - teleporters - flash teleporter
                            {
                                if (_inPublicroom || Room == null || roomUser == null)
                                    return;

                                int itemID = int.Parse(currentPacket.Substring(2));
                                if (Room.floorItemManager.containsItem(itemID))
                                {
                                    Rooms.Items.floorItem Teleporter1 = Room.floorItemManager.getItem(itemID);
                                    if (roomUser.X != Teleporter1.X && roomUser.Y != Teleporter1.Y)
                                        return;
                                    Database dbClient = new Database (true, false, 114);
                                    int idTeleporter2 = dbClient.getInteger("SELECT teleportid FROM furniture WHERE id = '" + itemID + "'");
                                    int roomIDTeleporter2 = dbClient.getInteger("SELECT roomid FROM furniture WHERE id = '" + idTeleporter2 + "'");
                                    dbClient.Close();
                                    if (roomIDTeleporter2 > 0)
                                        new TeleporterUsageSleep(useTeleporter).BeginInvoke(Teleporter1, idTeleporter2, roomIDTeleporter2, null, null);
                                }
                                break;
                            }

                        case "AM": // Item handling - dices - close dice
                            {
                                if (Room == null || roomUser == null || _inPublicroom)
                                    return;

                                int itemID = int.Parse(currentPacket.Substring(2));
                                if (Room.floorItemManager.containsItem(itemID))
                                {
                                    Rooms.Items.floorItem Item = Room.floorItemManager.getItem(itemID);
                                    string Sprite = Item.Sprite;
                                    if (Sprite != "edice" && Sprite != "edicehc") // Not a dice item
                                        return;

                                    if (!(Math.Abs(roomUser.X - Item.X) > 1 || Math.Abs(roomUser.Y - Item.Y) > 1)) // User is not more than one square removed from dice
                                    {
                                        Item.Var = "0";
                                        Room.sendData("AZ" + itemID + " " + (itemID * 38));
                                        Database dbClient = new Database(true, true, 115);
                                        dbClient.runQuery("UPDATE furniture SET var = '0' WHERE id = '" + itemID + "' LIMIT 1");
                                    }
                                }
                                break;
                            }

                        case "AL": // Item handling - dices - spin dice
                            {
                                if (Room == null || roomUser == null || _inPublicroom)
                                    return;

                                int itemID = int.Parse(currentPacket.Substring(2));
                                if (Room.floorItemManager.containsItem(itemID))
                                {
                                    Rooms.Items.floorItem Item = Room.floorItemManager.getItem(itemID);
                                    string Sprite = Item.Sprite;
                                    if (Sprite != "edice" && Sprite != "edicehc") // Not a dice item
                                        return;

                                    if (!(Math.Abs(roomUser.X - Item.X) > 1 || Math.Abs(roomUser.Y - Item.Y) > 1)) // User is not more than one square removed from dice
                                    {
                                        Room.sendData("AZ" + itemID);

                                        int rndNum = new Random(DateTime.Now.Millisecond).Next(1, 7);
                                        Room.sendData("AZ" + itemID + " " + ((itemID * 38) + rndNum), 2000);
                                        Item.Var = rndNum.ToString();
                                        Database dbClient = new Database(true, true, 116);
                                        dbClient.runQuery("UPDATE furniture SET var = '" + rndNum + "' WHERE id = '" + itemID + "' LIMIT 1");
                                    }
                                }
                                break;
                            }

                        case "Cw": // Item handling - spin Wheel of fortune
                            {
                                if (_hasRights == false || Room == null || roomUser == null || _inPublicroom)
                                    return;

                                int itemID = Encoding.decodeVL64(currentPacket.Substring(2));
                                if (Room.wallItemManager.containsItem(itemID))
                                {
                                    Rooms.Items.wallItem Item = Room.wallItemManager.getItem(itemID);
                                    if (Item.Sprite == "habbowheel")
                                    {
                                        int rndNum = new Random(DateTime.Now.Millisecond).Next(0, 10);
                                        Room.sendData("AU" + itemID + Convert.ToChar(9) + "habbowheel" + Convert.ToChar(9) + " " + Item.wallPosition + Convert.ToChar(9) + "-1");
                                        Room.sendData("AU" + itemID + Convert.ToChar(9) + "habbowheel" + Convert.ToChar(9) + " " + Item.wallPosition + Convert.ToChar(9) + rndNum, 4250);
                                        Database dbClient = new Database(true, true, 117);
                                        dbClient.runQuery("UPDATE furniture SET var = '" + rndNum + "' WHERE id = '" + itemID + "' LIMIT 1");
                                    }
                                }
                                break;
                            }

                        case "Dz": // Item handling - activate Love shuffler sofa
                            {
                                if (Room == null || roomUser == null || _inPublicroom)
                                    return;

                                int itemID = Encoding.decodeVL64(currentPacket.Substring(2));
                                if (Room.floorItemManager.containsItem(itemID) && Room.floorItemManager.getItem(itemID).Sprite == "val_randomizer")
                                {
                                    int rndNum = new Random(DateTime.Now.Millisecond).Next(1, 5);
                                    Room.sendData("AX" + itemID + Convert.ToChar(2) + "123456789" + Convert.ToChar(2));
                                    Room.sendData("AX" + itemID + Convert.ToChar(2) + rndNum + Convert.ToChar(2), 5000);
                                    Database dbClient = new Database(true, true, 118);
                                    dbClient.runQuery("UPDATE furniture SET var = '" + rndNum + "' WHERE id = '" + itemID + "' LIMIT 1");
                                }
                                break;
                            }

                        case "AS": // Item handling - stickies/photo's - open stickie/photo
                            {
                                if (Room == null || roomUser == null || _inPublicroom)
                                    return;

                                int itemID = int.Parse(currentPacket.Substring(2));
                                if (Room.wallItemManager.containsItem(itemID))
                                {
                                    Database dbClient = new Database(true, true, 119);
                                    string Message = dbClient.getString("SELECT text FROM furniture_stickies WHERE id = '" + itemID + "'");
                                    sendData("@p" + itemID + Convert.ToChar(9) + Room.wallItemManager.getItem(itemID).Var + " " + Message);
                                }
                                break;
                            }

                        case "AT": // Item handling - stickies - edit stickie colour/message
                            {
                                if (_hasRights == false || Room == null || roomUser == null || _inPublicroom)
                                    return;

                                int itemID = int.Parse(currentPacket.Substring(2, currentPacket.IndexOf("/") - 2));
                                if (Room.wallItemManager.containsItem(itemID))
                                {
                                    Rooms.Items.wallItem Item = Room.wallItemManager.getItem(itemID);
                                    string Sprite = Item.Sprite;
                                    if (Sprite != "post.it" && Sprite != "post.it.vd")
                                        return;
                                    string Colour = "FFFFFF"; // Valentine stickie default colour
                                    if (Sprite == "post.it") // Normal stickie
                                    {
                                        Colour = currentPacket.Substring(2 + itemID.ToString().Length + 1, 6);
                                        if (Colour != "FFFF33" && Colour != "FF9CFF" && Colour != "9CFF9C" && Colour != "9CCEFF")
                                            return;
                                    }

                                    string Message = currentPacket.Substring(2 + itemID.ToString().Length + 7);
                                    if (Message.Length > 684)
                                        return;
                                    Database dbClient = new Database(false, false, 120);
                                    dbClient.addParameterWithValue("text", stringManager.filterSwearwords(Message).Replace("/r", Convert.ToChar(13).ToString()));
                                    dbClient.Open();
                                    if (Colour != Item.Var)
                                        dbClient.runQuery("UPDATE furniture SET var = '" + Colour + "' WHERE id = '" + itemID + "' LIMIT 1");
                                    Item.Var = Colour;
                                    Room.sendData("AU" + itemID + Convert.ToChar(9) + Sprite + Convert.ToChar(9) + " " + Item.wallPosition + Convert.ToChar(9) + Colour);
                                    dbClient.runQuery("UPDATE furniture_stickies SET text = @text WHERE id = '" + itemID + "' LIMIT 1");
                                    dbClient.Close();
                                }
                                break;
                            }

                        case "AU": // Item handling - stickies/photo - delete stickie/photo
                            {
                                if (_isOwner == false || Room == null || roomUser == null || _inPublicroom)
                                    return;

                                int itemID = int.Parse(currentPacket.Substring(2));
                                if (Room.wallItemManager.containsItem(itemID) && stringManager.getStringPart(Room.wallItemManager.getItem(itemID).Sprite, 0, 7) == "post.it")
                                {
                                    Room.wallItemManager.removeItem(itemID, 0);
                                    Database dbClient = new Database(true, true, 121);
                                    dbClient.runQuery("DELETE FROM furniture_stickies WHERE id = '" + itemID + "' LIMIT 1");
                                }
                                break;
                            }
                        #endregion

                        #region Soundmachines
                        case "Ct": // Soundmachine - initialize songs in soundmachine
                            {
                                if (_isOwner && Room != null && Room.floorItemManager.soundMachineID > 0)
                                    sendData("EB" + soundMachineManager.getMachineSongList(Room.floorItemManager.soundMachineID));
                                break;
                            }

                        case "Cu": // Soundmachine - enter room initialize playlist
                            {
                                if (Room != null && Room.floorItemManager.soundMachineID > 0)
                                    sendData("EC" + soundMachineManager.getMachinePlaylist(Room.floorItemManager.soundMachineID));
                                break;
                            }

                        case "C]": // Soundmachine - get song title and data of certain song
                            {
                                if (Room != null && Room.floorItemManager.soundMachineID > 0)
                                {
                                    int songID = Encoding.decodeVL64(currentPacket.Substring(2));
                                    sendData("Dl" + soundMachineManager.getSong(songID));
                                }
                                break;
                            }

                        case "Cs": // Soundmachine - save playlist
                            {
                                if (_isOwner && Room != null && Room.floorItemManager.soundMachineID > 0)
                                {
                                    int Amount = Encoding.decodeVL64(currentPacket.Substring(2));
                                    if (Amount < 6) // Max playlist size
                                    {
                                        currentPacket = currentPacket.Substring(Encoding.encodeVL64(Amount).Length + 2);
                                        Database dbClient = new Database(true, false, 122);
                                        dbClient.runQuery("DELETE FROM soundmachine_playlists WHERE machineid = '" + Room.floorItemManager.soundMachineID + "'");
                                        StringBuilder sb = new StringBuilder();
                                        for (int i = 0; i < Amount; i++)
                                        {
                                            int songID = Encoding.decodeVL64(currentPacket);
                                            sb.Append(" ,('" + Room.floorItemManager.soundMachineID + "','" + songID + "','" + i + "')");
                                            currentPacket = currentPacket.Substring(Encoding.encodeVL64(songID).Length);
                                        }
                                        if(sb.Length != 0)
                                            dbClient.runQuery("INSERT INTO soundmachine_playlists(machineid,songid,pos) VALUES " + sb.ToString().Substring(2));
                                        dbClient.Close();
                                        Room.sendData("EC" + soundMachineManager.getMachinePlaylist(Room.floorItemManager.soundMachineID)); // Refresh playlist
                                    }
                                }
                                break;
                            }

                        case "C~": // Sound machine - burn song to disk
                            {
                                if (_isOwner && Room != null && Room.floorItemManager.soundMachineID > 0)
                                {
                                    int songID = Encoding.decodeVL64(currentPacket.Substring(2));
                                    Database dbClient = new Database(true, false, 123);
                                    if (_Credits > 0 && dbClient.findsResult("SELECT id FROM soundmachine_songs WHERE id = '" + songID + "' AND userid = '" + userID + "' AND machineid = '" + Room.floorItemManager.soundMachineID + "'"))
                                    {
                                        DataRow dRow = dbClient.getRow("SELECT title, length FROM soundmachine_songs WHERE id = '" + songID + "'");
                                        string Status = Encoding.encodeVL64(songID) + _Username + "\n" + DateTime.Today.Day + "\n" + DateTime.Today.Month + "\n" + DateTime.Today.Year + "\n" + Convert.ToString(dRow["length"]) + "\n" + Convert.ToString(dRow["title"]);
                                        dbClient.Close();
                                        dbClient = new Database(false, false, 123);
                                        dbClient.addParameterWithValue("tid", Config.Soundmachine_burnToDisk_diskTemplateID);
                                        dbClient.addParameterWithValue("ownerid", userID);
                                        dbClient.addParameterWithValue("var", Status);
                                        dbClient.Open();

                                        dbClient.runQuery("INSERT INTO furniture(tid,ownerid,var) VALUES (@tid,@owner,@var)");
                                        dbClient.runQuery("UPDATE soundmachine_songs SET burnt = '1' WHERE id = '" + songID + "' LIMIT 1");
                                        dbClient.runQuery("UPDATE users SET credits = credits - 1 WHERE id = '" + userID + "' LIMIT 1");

                                        _Credits--;
                                        sendData("@F" + _Credits);
                                        sendData("EB" + soundMachineManager.getMachineSongList(Room.floorItemManager.soundMachineID));
                                        refreshHand("last");
                                    }
                                    else // Virtual user doesn't has enough credits to burn this song to disk, or this song doesn't exist in his/her soundmachine
                                        sendData("AD");
                                    dbClient.Close();
                                }
                                break;
                            }

                        case "Cx": // Sound machine - delete song
                            {
                                if (_isOwner && Room != null && Room.floorItemManager.soundMachineID > 0)
                                {
                                    int songID = Encoding.decodeVL64(currentPacket.Substring(2));
                                    Database dbClient = new Database(true, false, 124);
                                    if (dbClient.findsResult("SELECT id FROM soundmachine_songs WHERE id = '" + songID + "' AND machineid = '" + Room.floorItemManager.soundMachineID + "'"))
                                    {
                                        dbClient.runQuery("UPDATE soundmachine_songs SET machineid = '0' WHERE id = '" + songID + "' AND burnt = '1'"); // If the song is burnt atleast once, then the song is removed from this machine
                                        dbClient.runQuery("DELETE FROM soundmachine_songs WHERE id = '" + songID + "' AND burnt = '0' LIMIT 1"); // If the song isn't burnt; delete song from database
                                        dbClient.runQuery("DELETE FROM soundmachine_playlists WHERE machineid = '" + Room.floorItemManager.soundMachineID + "' AND songid = '" + songID + "'"); // Remove song from playlist
                                        Room.sendData("EC" + soundMachineManager.getMachinePlaylist(Room.floorItemManager.soundMachineID));
                                    }
                                    dbClient.Close();
                                }
                                break;
                            }

                        #region Song editor
                        case "Co": // Soundmachine - song editor - initialize soundsets and samples
                            {
                                if (_isOwner && Room != null && Room.floorItemManager.soundMachineID > 0)
                                {
                                    songEditor = new virtualSongEditor(Room.floorItemManager.soundMachineID, userID);
                                    songEditor.loadSoundsets();
                                    sendData("Dm" + songEditor.getSoundsets());
                                    sendData("Dn" + soundMachineManager.getHandSoundsets(userID));
                                }
                                break;
                            }

                        case "C[": // Soundmachine - song editor - add soundset
                            {
                                if (songEditor != null && _isOwner && Room != null && Room.floorItemManager.soundMachineID > 0)
                                {
                                    int soundSetID = Encoding.decodeVL64(currentPacket.Substring(2));
                                    int slotID = Encoding.decodeVL64(currentPacket.Substring(Encoding.encodeVL64(soundSetID).Length + 2));
                                    if (slotID > 0 && slotID < 5 && songEditor.slotFree(slotID))
                                    {
                                        songEditor.addSoundset(soundSetID, slotID);
                                        sendData("Dn" + soundMachineManager.getHandSoundsets(userID));
                                        sendData("Dm" + songEditor.getSoundsets());
                                    }
                                }
                                break;
                            }

                        case @"C\": // Soundmachine - song editor - remove soundset
                            {
                                if (songEditor != null && _isOwner && Room != null && Room.floorItemManager.soundMachineID > 0)
                                {
                                    int slotID = Encoding.decodeVL64(currentPacket.Substring(2));
                                    if (songEditor.slotFree(slotID) == false)
                                    {
                                        songEditor.removeSoundset(slotID);
                                        sendData("Dm" + songEditor.getSoundsets());
                                        sendData("Dn" + soundMachineManager.getHandSoundsets(userID));
                                    }
                                }
                                break;
                            }

                        case "Cp": // Soundmachine - song editor - save new song                        
                            {
                                if (songEditor != null && _isOwner && Room != null && Room.floorItemManager.soundMachineID > 0)
                                {
                                    int nameLength = Encoding.decodeB64(currentPacket.Substring(2, 2));
                                    string Title = currentPacket.Substring(4, nameLength);
                                    string Data = currentPacket.Substring(nameLength + 6);
                                    int Length = soundMachineManager.calculateSongLength(Data);

                                    if (Length != -1)
                                    {
                                        Database dbClient = new Database(false, true, 126);
                                        dbClient.addParameterWithValue("userid", userID);
                                        dbClient.addParameterWithValue("machineid", Room.floorItemManager.soundMachineID);
                                        dbClient.addParameterWithValue("title", stringManager.filterSwearwords(Title));
                                        dbClient.addParameterWithValue("length", Length);
                                        dbClient.addParameterWithValue("data", Data);
                                        dbClient.Open();
                                        dbClient.runQuery("INSERT INTO soundmachine_songs (userid,machineid,title,length,data) VALUES (@userid,@machineid,@title,@length,@data)");

                                        sendData("EB" + soundMachineManager.getMachineSongList(Room.floorItemManager.soundMachineID));
                                        sendData("EK" + Encoding.encodeVL64(Room.floorItemManager.soundMachineID) + Title + Convert.ToChar(2));
                                    }
                                }
                                break;
                            }

                        case "Cq": // Soundmachine - song editor - request edit of existing song
                            {
                                if (_isOwner && Room != null && Room.floorItemManager.soundMachineID > 0)
                                {
                                    int songID = Encoding.decodeVL64(currentPacket.Substring(2));
                                    sendData("Dl" + soundMachineManager.getSong(songID));

                                    songEditor = new virtualSongEditor(Room.floorItemManager.soundMachineID, userID);
                                    //songEditor.loadSoundsets();

                                    sendData("Dm" + songEditor.getSoundsets());
                                    sendData("Dn" + soundMachineManager.getHandSoundsets(userID));
                                }
                                break;
                            }

                        case "Cr": // Soundmachine - song editor - save edited existing song
                            {
                                if (songEditor != null && _isOwner && Room != null && Room.floorItemManager.soundMachineID > 0)
                                {
                                    int songID = Encoding.decodeVL64(currentPacket.Substring(2));
                                    Database dbClient = new Database(true, true, 127);
                                    if (dbClient.findsResult("SELECT id FROM soundmachine_songs WHERE id = '" + songID + "' AND userid = '" + userID + "' AND machineid = '" + Room.floorItemManager.soundMachineID + "'"))
                                    {   
                                        int idLength = Encoding.encodeVL64(songID).Length;
                                        int nameLength = Encoding.decodeB64(currentPacket.Substring(idLength + 2, 2));
                                        string Title = currentPacket.Substring(idLength + 4, nameLength);
                                        string Data = currentPacket.Substring(idLength + nameLength + 6);
                                        int Length = soundMachineManager.calculateSongLength(Data);
                                        if (Length != -1)
                                        {
                                            dbClient = new Database(false, true, 128);
                                            dbClient.addParameterWithValue("id", songID);
                                            dbClient.addParameterWithValue("title", stringManager.filterSwearwords(Title));
                                            dbClient.addParameterWithValue("length", Length);
                                            dbClient.addParameterWithValue("data", Data);
                                            dbClient.Open();
                                            dbClient.runQuery("UPDATE soundmachine_songs SET title = @title,data = @data,length = @length WHERE id = @id LIMIT 1");
                                            sendData("ES");
                                            sendData("EB" + soundMachineManager.getMachineSongList(Room.floorItemManager.soundMachineID));
                                            Room.sendData("EC" + soundMachineManager.getMachinePlaylist(Room.floorItemManager.soundMachineID));
                                        }
                                    }
                                }
                                break;
                            }
                        #endregion Song editor
                        #endregion

                        #region Trading
                        case "AG": // Trading - start
                            {
                                if (Room != null || roomUser != null || _tradePartnerRoomUID == -1)
                                {
                                    if (Config.enableTrading == false) { sendData("BK" + stringManager.getString("trading_disabled")); return; }

                                    int partnerUID = int.Parse(currentPacket.Substring(2));
                                    if (Room.containsUser(partnerUID))
                                    {
                                        virtualUser Partner = Room.getUser(partnerUID);
                                        if (Partner.statusManager.containsStatus("trd"))
                                            return;

                                        this._tradePartnerRoomUID = partnerUID;
                                        this.statusManager.addStatus("trd", "");
                                        this.roomUser.Refresh();

                                        Partner._tradePartnerRoomUID = this.roomUser.roomUID;
                                        Partner.statusManager.addStatus("trd", "");
                                        Partner.roomUser.Refresh();

                                        this.refreshTradeBoxes();
                                        Partner.refreshTradeBoxes();
                                    }
                                }
                                break;
                            }

                        case "AH": // Trading - offer item
                            {
                                if (Room != null && roomUser != null && _tradePartnerRoomUID != -1 && Room.containsUser(_tradePartnerRoomUID))
                                {
                                    int itemID = int.Parse(currentPacket.Substring(2));
                                    Database dbClient = new Database(true, true, 129);
                                    int templateID = dbClient.getInteger("SELECT tid FROM furniture WHERE id = '" + itemID + "' AND ownerid = '" + userID + "' AND roomid = '0'");
                                    if (templateID == 0)
                                        return;

                                    _tradeItems[_tradeItemCount] = itemID;
                                    _tradeItemCount++;
                                    virtualUser Partner = Room.getUser(_tradePartnerRoomUID);

                                    this._tradeAccept = false;
                                    Partner._tradeAccept = false;

                                    this.refreshTradeBoxes();
                                    Partner.refreshTradeBoxes();
                                }
                                break;
                            }

                        case "AD": // Trading - decline trade
                            {
                                if (Room != null && roomUser != null && _tradePartnerRoomUID != -1 && Room.containsUser(_tradePartnerRoomUID))
                                {
                                    virtualUser Partner = Room.getUser(_tradePartnerRoomUID);
                                    this._tradeAccept = false;
                                    Partner._tradeAccept = false;
                                    this.refreshTradeBoxes();
                                    Partner.refreshTradeBoxes();
                                }
                                break;
                            }

                        case "AE": // Trading - accept trade (and, if both partners accept, swap items]
                            {
                                if (Room != null && roomUser != null && _tradePartnerRoomUID != -1 && Room.containsUser(_tradePartnerRoomUID))
                                {
                                    virtualUser Partner = Room.getUser(_tradePartnerRoomUID);
                                    this._tradeAccept = true;
                                    this.refreshTradeBoxes();
                                    Partner.refreshTradeBoxes();

                                    if (Partner._tradeAccept)
                                    {
                                        StringBuilder sb = new StringBuilder("'a'='b'");
                                        for (int i = 0; i < _tradeItemCount; i++)
                                            if (_tradeItems[i] > 0)
                                                sb.Append(" OR id = '" + this._tradeItems[i] + "'");
                                        
                                        Database dbClient = new Database(true, false, 130);
                                        dbClient.runQuery("UPDATE furniture SET ownerid = '" + Partner.userID + "',roomid = '0' WHERE" + sb.ToString());
                                        sb.Remove(7, sb.Length-7);

                                        for (int i = 0; i < Partner._tradeItemCount; i++)
                                            if (Partner._tradeItems[i] > 0)
                                                sb.Append(" OR id = '" + Partner._tradeItems[i] + "'");

                                        dbClient.runQuery("UPDATE furniture SET ownerid = '" + this.userID + "',roomid = '0' WHERE" + sb.ToString());

                                        dbClient.Close();
                                        abortTrade();
                                    }
                                }
                                break;
                            }

                        case "AF": // Trading - abort trade
                            {
                                if (Room != null && roomUser != null && _tradePartnerRoomUID != -1 && Room.containsUser(_tradePartnerRoomUID))
                                {
                                    abortTrade();
                                    refreshHand("update");
                                }
                                break;
                            }


                        #endregion

                        #region Games
                        case "B_": // Gamelobby - refresh gamelist
                            {
                                if (Room != null && Room.Lobby != null)
                                    sendData("Ch" + Room.Lobby.gameList());
                                break;
                            }

                        case "B`": // Gamelobby - checkout single game sub
                            {
                                if (Room != null && roomUser != null && Room.Lobby != null && gamePlayer == null)
                                {
                                    int gameID = Encoding.decodeVL64(currentPacket.Substring(2));
                                    if (Room.Lobby.Games.ContainsKey(gameID))
                                    {
                                        this.gamePlayer = new gamePlayer(this, roomUser.roomUID, (Game)Room.Lobby.Games[gameID]);
                                        gamePlayer.Game.Subviewers.Add(gamePlayer);
                                        sendData("Ci" + gamePlayer.Game.Sub);
                                    }
                                }
                                break;
                            }

                        case "Bb": // Gamelobby - request new game create
                            {
                                if (Room != null && roomUser != null && Room.Lobby != null && gamePlayer == null)
                                {
                                    if (_Tickets > 1) // Atleast two tickets in inventory
                                    {
                                        if (Room.Lobby.validGamerank(roomUser.gamePoints))
                                        {
                                            if (Room.Lobby.isBattleBall)
                                                sendData("Ck" + Room.Lobby.getCreateGameSettings());
                                            else
                                                sendData("Ck" + "RA" + "secondsUntilRestart" + Convert.ToChar(2) + "HIRGIHHfieldType" + Convert.ToChar(2) + "HKIIIISAnumTeams" + Convert.ToChar(2) + "HJJIII" + "PA" + "gameLengthChoice" + Convert.ToChar(2) + "HJIIIIK" + "name" + Convert.ToChar(2) + "IJ" + Convert.ToChar(2) + "H" + "secondsUntilStart" + Convert.ToChar(2) + "HIRBIHH");
                                        }
                                        else
                                            sendData("Cl" + "K"); // Error [3] = Skillevel not valid in this lobby
                                    }
                                    else
                                        sendData("Cl" + "J"); // Error [2] = Not enough tickets
                                }
                                break;
                            }

                        case "Bc": // Gamelobby - process new created game
                            {
                                if (Room != null && roomUser != null && Room.Lobby != null && gamePlayer == null)
                                {
                                    if (_Tickets > 1) // Atleast two tickets in inventory
                                    {
                                        if (Room.Lobby.validGamerank(roomUser.gamePoints))
                                        {
                                            try
                                            {
                                                int mapID = -1;
                                                int teamAmount = -1;
                                                int[] Powerups = null;
                                                string Name = "";

                                                #region Game settings decoding
                                                int keyAmount = Encoding.decodeVL64(currentPacket.Substring(2));
                                                currentPacket = currentPacket.Substring(Encoding.encodeVL64(keyAmount).Length + 2);
                                                for (int i = 0; i < keyAmount; i++)
                                                {
                                                    int j = Encoding.decodeB64(currentPacket.Substring(0, 2));
                                                    string Key = currentPacket.Substring(2, j);
                                                    if (currentPacket.Substring(j + 2, 1) == "H") // VL64 value
                                                    {
                                                        int Value = Encoding.decodeVL64(currentPacket.Substring(j + 3));
                                                        switch (Key)
                                                        {
                                                            case "fieldType":
                                                                //if (Value != 5)
                                                                //{
                                                                //    sendData("BK" + "Soz but only the maps for Oldskool are added to db yet kthx.");
                                                                //    return;
                                                                //}
                                                                mapID = Value;
                                                                break;

                                                            case "numTeams":
                                                                teamAmount = Value;
                                                                break;
                                                        }
                                                        int k = Encoding.encodeVL64(Value).Length;
                                                        currentPacket = currentPacket.Substring(j + k + 3);
                                                    }
                                                    else // B64 value
                                                    {

                                                        int valLen = Encoding.decodeB64(currentPacket.Substring(j + 3, 2));
                                                        string Value = currentPacket.Substring(j + 5, valLen);

                                                        switch (Key)
                                                        {
                                                            case "allowedPowerups":
                                                                string[] ps = Value.Split(',');
                                                                Powerups = new int[ps.Length];
                                                                for (int p = 0; p < ps.Length; p++)
                                                                {
                                                                    int P = int.Parse(ps[p]);
                                                                    if (Room.Lobby.allowsPowerup(P))
                                                                        Powerups[p] = P;
                                                                    else // Powerup not allowed in this lobby
                                                                        return;
                                                                }
                                                                break;

                                                            case "name":
                                                                Name = stringManager.filterSwearwords(Value);
                                                                break;
                                                        }
                                                        currentPacket = currentPacket.Substring(j + valLen + 5);
                                                    }
                                                }
                                                #endregion

                                                if (mapID == -1 || teamAmount == -1 || Name == "") // Incorrect keys supplied by client
                                                    return;
                                                this.gamePlayer = new gamePlayer(this, roomUser.roomUID, null);
                                                Room.Lobby.createGame(this.gamePlayer, Name, mapID, teamAmount, Powerups);
                                            }
                                            catch { }
                                        }
                                        else
                                            sendData("Cl" + "K"); // Error [3] = Skillevel not valid in this lobby
                                    }
                                    else
                                        sendData("Cl" + "J"); // Error [2] = Not enough tickets
                                }
                                break;
                            }

                        case "Be": // Gamelobby - switch team in game
                            {
                                if (Room != null && Room.Lobby != null && gamePlayer != null && gamePlayer.Game.State == Game.gameState.Waiting)
                                {
                                    if (_Tickets > 1) // Atleast two tickets in inventory
                                    {
                                        if (Room.Lobby.validGamerank(roomUser.gamePoints))
                                        {
                                            int j = Encoding.decodeVL64(currentPacket.Substring(2));
                                            int teamID = Encoding.decodeVL64(currentPacket.Substring(Encoding.encodeVL64(j).Length + 2));

                                            if (teamID != gamePlayer.teamID && gamePlayer.Game.teamHasSpace(teamID))
                                            {
                                                if (gamePlayer.teamID == -1) // User was a subviewer
                                                    gamePlayer.Game.Subviewers.Remove(gamePlayer);
                                                gamePlayer.Game.movePlayer(gamePlayer, gamePlayer.teamID, teamID);
                                            }
                                            else
                                                sendData("Cl" + "H"); // Error [0] = Team full
                                        }
                                        else
                                            sendData("Cl" + "K"); // Error [3] = Skillevel not valid in this lobby
                                    }
                                    else
                                        sendData("Cl" + "J"); // Error [2] = Not enough tickets
                                }
                                break;
                            }

                        case "Bg": // Gamelobby - leave single game sub
                            {
                                leaveGame();
                                break;
                            }

                        case "Bh": // Gamelobby - kick player from game
                            {
                                if (Room != null && Room.Lobby != null && gamePlayer != null && gamePlayer.Game != null && gamePlayer == gamePlayer.Game.Owner)
                                {
                                    int roomUID = Encoding.decodeVL64(currentPacket.Substring(2));
                                    for (int i = 0; i < gamePlayer.Game.Teams.Length; i++)
                                    {
                                        foreach (gamePlayer Member in gamePlayer.Game.Teams[i])
                                        {
                                            if (Member.roomUID == roomUID)
                                            {
                                                Member.sendData("Cl" + "RA"); // Error [6] = kicked from game
                                                gamePlayer.Game.movePlayer(Member, i, -1);
                                                return;
                                            }
                                        }
                                    }
                                }
                                break;
                            }

                        case "Bj": // Gamelobby - start game
                            {
                                if (Room != null && Room.Lobby != null && gamePlayer != null && gamePlayer == gamePlayer.Game.Owner)
                                {
                                    //if(Game.Launchable)
                                    //{
                                    gamePlayer.Game.startGame();
                                    //}
                                    //else
                                    //    sendData("Cl" + "I");
                                }
                                break;
                            }

                        case "Bk": // Game - ingame - move unit
                            {
                                if (gamePlayer != null && gamePlayer.Game.State == Game.gameState.Started && gamePlayer.teamID != -1)
                                {
                                    gamePlayer.goalX = Encoding.decodeVL64(currentPacket.Substring(3));
                                    gamePlayer.goalY = Encoding.decodeVL64(currentPacket.Substring(Encoding.encodeVL64(gamePlayer.goalX).Length + 3));
                                    Out.WriteLine(_Username + ": " + gamePlayer.goalX + "," + gamePlayer.goalY);
                                }
                                break;
                            }

                        case "Bl": // Game - ingame - proceed with restart of game
                            {
                                if (gamePlayer != null && gamePlayer.Game.State == Game.gameState.Ended && gamePlayer.teamID != -1)
                                {
                                    gamePlayer.Game.sendData("BK" + "" + _Username + " wants to replay!");
                                }
                                break;
                            }
                        #endregion

                        #region Guide system

                        case "Ej":
                            {
                                //DB.runQuery("UPDATE users SET guideavailable = '1' WHERE id = '" + userID + "' LIMIT 1");
                                break;
                            }

                        case "Ek":
                            {
                                //DB.runQuery("UPDATE users SET guideavailable = '0' WHERE id = '" + userID + "' LIMIT 1");
                                break;
                            }

                        #endregion

                        #region Games Joystick

                        case "FC":
                            {
                                //Not coded yet (NOT A BUG)!
                                break;
                            }

                        #endregion

                        #region Moodlight
                        case "EW": // Turn moodlight on/off
                            {
                                if (_isOwner == false && _hasRights == false)
                                    return;
                                roomManager.moodlight.setSettings(_roomID, false, 0, 0, null, 0);
                                break;
                            }

                        case "EU": // Load moodlight settings
                            {
                                if (_isOwner == false && _hasRights == false)
                                    return;
                                string settingData = roomManager.moodlight.getSettings(_roomID);
                                if (settingData != null)
                                    sendData("Em" + settingData);
                                break;
                            }

                        case "EV": // Apply modified moodlight settings
                            {
                                if (_isOwner == false && _hasRights == false)
                                    return;
                                int presetID = Encoding.decodeVL64(currentPacket.Substring(2, 1));
                                int bgState = Encoding.decodeVL64(currentPacket.Substring(3, 1));
                                string presetColour = currentPacket.Substring(6, Encoding.decodeB64(currentPacket.Substring(4, 2)));
                                int presetDarkF = Encoding.decodeVL64(currentPacket.Substring(presetColour.Length + 6));
                                roomManager.moodlight.setSettings(_roomID, true, presetID, bgState, presetColour, presetDarkF);
                                break;
                            }
                    #endregion
                    #endregion
                }
                #endregion
            }
        }
        #endregion
                
        #region Update voids
        /// <summary>
        /// Refreshes
        /// </summary>
        /// <param name="Reload">Specifies if the details have to be reloaded from database, or to use current _</param>
        /// <param name="refreshSettings">Specifies if the @E packet (which contains username etc) has to be resent.</param>
        ///<param name="refreshRoom">Specifies if the user has to be refreshed in room by using the 'poof' animation.</param>
        internal void refreshAppearance(bool Reload, bool refreshSettings, bool refreshRoom)
        {
            if (Reload)
            {
                Database dbClient = new Database(true, true, 131);
                DataRow dRow = dbClient.getRow("SELECT figure,sex,mission FROM users WHERE id = '" + userID + "'");
                _Figure = Convert.ToString(dRow["figure"]);
                _Sex = Convert.ToChar(dRow["sex"]);
                _Mission = Convert.ToString(dRow["mission"]);
            }
            
            if (refreshSettings)
                sendData("@E" + connectionID + Convert.ToChar(2) + _Username + Convert.ToChar(2) + _Figure + Convert.ToChar(2) + _Sex + Convert.ToChar(2) + _Mission + Convert.ToChar(2) + Convert.ToChar(2) + "PCch=s02/53,51,44" + Convert.ToChar(2) + "HI");

            if (refreshRoom && Room != null && roomUser != null)
                Room.sendData("DJ" + Encoding.encodeVL64(roomUser.roomUID) + _Figure + Convert.ToChar(2) + _Sex + Convert.ToChar(2) + _Mission + Convert.ToChar(2));
        }
        /// <summary>
        /// Reloads the valueables (tickets and credits) from database and updates them for client.
        /// </summary>
        /// <param name="Credits">Specifies if to reload and update the Credit count.</param>
        /// <param name="Tickets">Specifies if to reload and update the Ticket count.</param>
        internal void refreshValueables(bool Credits, bool Tickets)
        {
            Database dbClient = new Database(true, true, 132);
            if (Credits)
            {
                _Credits = dbClient.getInteger("SELECT credits FROM users WHERE id = '" + userID + "'");
                sendData("@F" + _Credits);
            }

            if (Tickets)
            {
                _Tickets = dbClient.getInteger("SELECT tickets FROM users WHERE id = '" + userID + "'");
                sendData("A|" + _Tickets);
            }
        }
        /// <summary>
        /// Refreshes the users Club subscription status.
        /// </summary>
        internal void refreshClub()
        {
            int restingDays = 0;
            int passedMonths = 0;
            int restingMonths = 0;
            Database dbClient = new Database(true, true, 133);
            DataRow dRow = dbClient.getRow("SELECT months_expired,months_left,date_monthstarted FROM users_club WHERE userid = '" + userID + "'");
            if (dRow.Table.Columns.Count >0)
            {
                passedMonths = Convert.ToInt32(dRow["months_expired"]);
                restingMonths = Convert.ToInt32(dRow["months_left"]) - 1;
                restingDays = (int)(DateTime.Parse(Convert.ToString(dRow["date_monthstarted"]), new System.Globalization.CultureInfo("en-GB"))).Subtract(DateTime.Now).TotalDays + 32;
                _clubMember = true;
            }
            sendData("@Gclub_habbo" + Convert.ToChar(2) + Encoding.encodeVL64(restingDays) + Encoding.encodeVL64(passedMonths) + Encoding.encodeVL64(restingMonths) + "I");
        }
        /// <summary>
        /// Refreshes the user's badges.
        /// </summary>
        internal void refreshBadges()
        {
            _nowBadge = "";

            int badgeActiveSlot = 0;
            int badgeStatus = 0;
            Database dbClient = new Database(true, false, 134);
            DataColumn dCol = dbClient.getColumn("SELECT badgeid FROM users_badges WHERE userid = '" + userID + "'");

            StringBuilder badgeList = new StringBuilder();
            if (dCol.Table.Rows.Count > 0)
            {
                badgeStatus = dbClient.getInteger("SELECT badge_status FROM users WHERE id = '" + userID + "'");
                string badgeCurrent = dbClient.getString("SELECT badgeid FROM users_badges WHERE userid = '" + userID + "' AND iscurrent = '1'");

                int i = 0;
                foreach (DataRow dRow in dCol.Table.Rows)
                {
                    badgeList.Append(Convert.ToString(dRow["badgeid"]) + Convert.ToChar(2));
                    if (Convert.ToString(dRow["badgeid"]) == badgeCurrent)
                        badgeActiveSlot = i;
                    i++;
                }
                if (badgeStatus == 1)
                    _nowBadge = badgeCurrent;
            }
            dbClient.Close();

            sendData("Ce" + Encoding.encodeVL64(dCol.Table.Rows.Count) + badgeList.ToString() + Encoding.encodeVL64(badgeActiveSlot) + Encoding.encodeVL64(badgeStatus));
        }
        /// <summary>
        /// Refreshes the user's group status.
        /// </summary>
        internal void refreshGroupStatus()
        {
            Database dbClient = new Database(true, false, 135);
            _groupID = dbClient.getInteger("SELECT groupid FROM groups_memberships WHERE userid = '" + userID + "' AND is_current = '1'");
            if (_groupID > 0) // User is member of a group
                _groupMemberRank = dbClient.getInteger("SELECT member_rank FROM groups_memberships WHERE userid = '" + userID + "' AND groupID = '" + _groupID + "'");
            dbClient.Close();
        }
        /// <summary>
        /// Refreshes the Hand, which contains virtual items, with a specified mode.
        /// </summary>
        /// <param name="Mode">The refresh mode, available: 'next', 'prev', 'update', 'last' and 'new'.</param>
        internal void refreshHand(string Mode)
        {
            Database dbClient = new Database(true, true, 136);
            DataTable dTable = dbClient.getTable("SELECT id,tid,var FROM furniture WHERE ownerid = '" + userID + "' AND roomid = '0' ORDER BY id ASC");
            StringBuilder Hand = new StringBuilder("BL");
            int startID = 0;
            int stopID = dTable.Rows.Count;

            switch (Mode)
            {
                case "next":
                    _handPage++;
                    break;
                case "prev":
                    _handPage--;
                    break;
                case "last":
                    _handPage = (stopID - 1) / 9;
                    break;
                case "update": // Nothing, keep handpage the same
                    break;
                default: // Probably, "new"
                    _handPage = 0;
                    break;
            }

            try
            {
                if (stopID > 0)
                {
                reCount:
                    startID = _handPage * 9;
                    if (stopID > (startID + 9)) { stopID = startID + 9; }
                    if (startID > stopID || startID == stopID) { _handPage--; goto reCount; }
                    string Colour = "";
                    DataRow dRow;
                    for(int f = startID; f < stopID; f++)
                    {
                        dRow = dTable.Rows[f];
                        catalogueManager.itemTemplate Template = catalogueManager.getTemplate(Convert.ToInt32(dRow["tid"]));
                        char Recycleable = '1';
                        if (Template.isRecycleable == false)
                            Recycleable = '0';

                        if (Template.typeID == 0) // Wallitem
                        {
                            Colour = Template.Colour;
                            if (Template.Sprite == "post.it" || Template.Sprite == "post.it.vd") // Stickies - pad size
                                Colour = Convert.ToString(dRow["var"]);
                            Hand.Append("SI" + Convert.ToChar(30).ToString() + Convert.ToString(dRow["id"]) + Convert.ToChar(30).ToString() + f + Convert.ToChar(30).ToString() + "I" + Convert.ToChar(30).ToString() + Convert.ToString(dRow["id"]) + Convert.ToChar(30).ToString() + Template.Sprite + Convert.ToChar(30).ToString() + Colour + Convert.ToChar(30).ToString() + Recycleable + "/");
                        }
                        else // Flooritem
                            Hand.Append("SI" + Convert.ToChar(30).ToString() + Convert.ToString(dRow["id"]) + Convert.ToChar(30).ToString() + f + Convert.ToChar(30).ToString() + "S" + Convert.ToChar(30).ToString() + Convert.ToString(dRow["id"]) + Convert.ToChar(30).ToString() + Template.Sprite + Convert.ToChar(30).ToString() + Template.Length + Convert.ToChar(30).ToString() + Template.Width + Convert.ToChar(30).ToString() + Convert.ToString(dRow["var"]) + Convert.ToChar(30).ToString() + Template.Colour + Convert.ToChar(30).ToString() + Recycleable + Convert.ToChar(30).ToString() + Template.Sprite + Convert.ToChar(30).ToString() + "/");
                    }

                }
                Hand.Append("\r" + dTable.Rows.Count);
                sendData(Hand.ToString());
            }
            catch
            {
                sendData("BL" + "\r0");
            }
        }
        /// <summary>
        /// Refreshes the trade window for the user.
        /// </summary>
        internal void refreshTradeBoxes()
        {
            if (Room != null && Room.containsUser(_tradePartnerRoomUID) && roomUser != null)
            {
                virtualUser Partner = Room.getUser(_tradePartnerRoomUID);
                StringBuilder tradeBoxes = new StringBuilder("Al" + _Username + Convert.ToChar(9) + _tradeAccept.ToString().ToLower() + Convert.ToChar(9));
                if (_tradeItemCount > 0) { tradeBoxes.Append(catalogueManager.tradeItemList(_tradeItems)); }
                tradeBoxes.Append(Convert.ToChar(13) + Partner._Username + Convert.ToChar(9) + Partner._tradeAccept.ToString().ToLower() + Convert.ToChar(9));
                if (Partner._tradeItemCount > 0) { tradeBoxes.Append(catalogueManager.tradeItemList(Partner._tradeItems)); }
                sendData(tradeBoxes.ToString());
            }
        }
        /// <summary>
        /// Aborts the trade between this user and his/her partner.
        /// </summary>
        internal void abortTrade()
        {
            if (Room != null && Room.containsUser(_tradePartnerRoomUID) && roomUser != null)
            {
                virtualUser Partner = Room.getUser(_tradePartnerRoomUID);
                this.sendData("An");
                this.refreshHand("update");
                Partner.sendData("An");
                Partner.refreshHand("update");

                this._tradePartnerRoomUID = -1;
                this._tradeAccept = false;
                this._tradeItems = new int[65];
                this._tradeItemCount = 0;
                this.statusManager.removeStatus("trd");
                this.roomUser.Refresh();

                Partner._tradePartnerRoomUID = -1;
                Partner._tradeAccept = false;
                Partner._tradeItems = new int[65];
                Partner._tradeItemCount = 0;
                Partner.statusManager.removeStatus("trd");
                Partner.roomUser.Refresh();
            }
        }
        #endregion

        #region Misc voids
        /// <summary>
        /// Checks if a certain chat message was a 'speech command', if so, then the action for this command is processed and a 'true' boolean is returned. Otherwise, 'false' is returned.
        /// </summary>
        /// <param name="Text">The chat message that was used.</param>
        private bool isSpeechCommand(string Text)
        {
            string[] args = Text.Split(' ');
            try // Try/catch, on error (eg, target user offline, parameters incorrect etc) then failure message will be sent
            {
                switch (args[0].ToLower()) // arg[0] = command itself
                {
                    #region Public commands
                    #region :about
                    case "about": // Display information about the emulator
                        {
                            sendData("BK" + "Hello " + _Username + ", it appears that you are currently connected to a copy of Holograph Emulator,\r" +
                                "the free and open source C# Habbo emulator(FIXED BY WERPO AND DATABASE REDONE BY CECER1).\r\r" +
                                "This server is fixed by Werpo on RZ and has had the whole database system recoded by Cecer1 (Also on RageZone)\r" +
                                "The asynchronous socket server for game connections has accepted " + Socketservers.gameSocketServer.acceptedConnections + " connections since last boot.\r" +
                                "There are " + userManager.userCount + " virtual users connected at the moment, the peak since last boot is " + userManager.peakUserCount + ".\r" +
                                "There are " + roomManager.roomCount + " virtual rooms in use at the moment, the peak since last boot is " + roomManager.roomCount + ".\r\r" +
                                "We hope you experience a nice time here and we hope to see you again!\r\r" +
                                "Thanks\r" +
                                "The team");

                            break;
                        }
                    #endregion

                    #region :cleanhand
                    case "cleanhand": // Deletes everything from the senders hand
                        {
                            Database dbClient = new Database(true, true, 138);
                            dbClient.runQuery("DELETE FROM furniture WHERE ownerid = '" + userID + "' AND roomid = '0'");
                            refreshHand("update");
                            break;
                        }
                    #endregion

                    #region :brb/:back
                    case "brb": // Shows the user has brb in the room
                        {
                            if (brbLooper == null)
                            {
                                ThreadStart brbStarter = new ThreadStart(showBrb);
                                brbLooper = new Thread(brbStarter);
                                brbLooper.Priority = ThreadPriority.Lowest;
                                brbLooper.Start();
                            }                            
                            break;
                        }

                    case "back": // Stops the user from being shown as brb
                        {
                            if (brbLooper != null)
                            {
                                brbLooper.Abort();
                                brbLooper = null;
                                Room.sendShout(roomUser, "\n\n\n                 I am back now.\n\n\n                                                ");
                            }
                            break;
                        }
                    #endregion

                    #region :commands
                    case "commands": // Displays a list of commands
                    case "cmds": // Displays a list of commands
                            sendData(userManager.generateCommands(_Rank));
                            break;
                    #endregion

                    #region :whosonline
                    case "whosonline": // Generates a list of users connected
                        sendData(userManager.generateWhosOnline(rankManager.containsRight(_Rank, "fuse_administrator_access")));
                        break;
                    #endregion

                    #region :version
                    case "hotel":
                    case "info": 
                    case "version": // Displays the Server Version
                        {
                            sendData("BK" + "You are currently connected to " + Eucalypt.serverVersion);
                            break;
                        }
                    #endregion

                    #region :staff
                    case "staff": // / How to Contact Hotel Staff
                        {
                            sendData("BK" + "If you need to contact the Hotel Staff Please use the Call for help");
                            break;
                        }
                    #endregion
                    #endregion

                    #region Moderacy commands
                    #region :alert
                    case "alert": // Alert a virtual user
                        {
                            if (rankManager.containsRight(_Rank, "fuse_alert") == false)
                                return false;
                            else
                            {
                                virtualUser Target = userManager.getUser(args[1]);
                                string Message = stringManager.wrapParameters(args, 2);

                                Target.sendData("B!" + Message + Convert.ToChar(2));
                                sendData("BK" + stringManager.getString("scommand_success"));
                                staffManager.addStaffMessage("alert", userID, Target.userID, args[2], "");
                            }
                            break;
                        }
                    #endregion

                    #region :roomalert
                    case "roomalert": // Alert all virtual users in current virtual room
                        {
                            if (rankManager.containsRight(_Rank, "fuse_room_alert") == false)
                                return false;
                            else
                            {
                                string Message = Text.Substring(10);
                                Room.sendData("B!" + Message + Convert.ToChar(2));
                                staffManager.addStaffMessage("ralert", userID, Room.roomID, Message, "");
                            }
                            break;
                        }
                    #endregion

                    #region :kick
                    case "kick": // Kicks a virtual user from room
                        {
                            if (rankManager.containsRight(_Rank, "fuse_kick") == false)
                                return false;
                            else
                            {
                                virtualUser Target = userManager.getUser(args[1]);
                                if (Target._Rank < this._Rank)
                                {
                                    string Message = "";
                                    if (args.Length > 2) // Reason supplied
                                        Message = stringManager.wrapParameters(args, 2);

                                    Target.Room.removeUser(Target.roomUser.roomUID, true, Message);
                                    sendData("BK" + stringManager.getString("scommand_success"));
                                    staffManager.addStaffMessage("kick", userID, Target.userID, Message, "");
                                }
                                else
                                    sendData("BK" + stringManager.getString("scommand_failed"));
                            }
                            break;
                        }
                    #endregion

                    #region :roomkick
                    case "roomkick": // Kicks all virtual users below rank from virtual room
                        {
                            if (rankManager.containsRight(_Rank, "fuse_room_kick") == false)
                                return false;
                            else
                            {
                                string Message = stringManager.wrapParameters(args, 1);
                                Room.kickUsers(_Rank, Message);
                                sendData("BK" + stringManager.getString("scommand_success"));
                                staffManager.addStaffMessage("rkick", userID, Room.roomID, Message, "");
                            }
                            break;
                        }
                    #endregion

                    #region :shutup/:unmute
                    case "shutup": // Mutes a virtual user (disabling it from chat)
                        {
                            if (rankManager.containsRight(_Rank, "fuse_mute") == false)
                                return false;
                            else
                            {
                                virtualUser Target = userManager.getUser(args[1]);
                                if (Target._Rank < _Rank && Target._isMuted == false)
                                {
                                    string Message = stringManager.wrapParameters(args, 2);
                                    Target._isMuted = true;
                                    Target.sendData("BK" + stringManager.getString("scommand_muted") + "\r" + Message);
                                    sendData("BK" + stringManager.getString("scommand_success"));
                                    staffManager.addStaffMessage("mute", userID, Target.userID, Message, "");
                                }
                                else
                                    sendData("BK" + stringManager.getString("scommand_failed"));
                            }
                            break;
                        }

                    case "unmute": // Unmutes a virtual user (enabling it to chat again)
                        {
                            if (rankManager.containsRight(_Rank, "fuse_mute") == false)
                                return false;
                            else
                            {
                                virtualUser Target = userManager.getUser(args[1]);
                                if (Target._Rank < _Rank && Target._isMuted)
                                {
                                    Target._isMuted = false;
                                    Target.sendData("BK" + stringManager.getString("scommand_unmuted"));
                                    sendData("BK" + stringManager.getString("scommand_success"));
                                    staffManager.addStaffMessage("unmute", userID, Target.userID, "", "");
                                }
                                else
                                    sendData("BK" + stringManager.getString("scommand_failed"));
                            }
                            break;
                        }
                    #endregion

                    #region :roomshutup/:roomunmute
                    case "roomshutup": // Mutes all virtual users in the current room from chat. Only user's that have a lower rank than this user are affected.
                        {
                            if (rankManager.containsRight(_Rank, "fuse_room_mute") == false)
                                return false;
                            else
                            {
                                string Message = stringManager.wrapParameters(args, 1);
                                Room.muteUsers(_Rank, Message);
                                sendData("BK" + stringManager.getString("scommand_success"));
                                staffManager.addStaffMessage("rmute", userID, Room.roomID, Message, "");
                            }
                            break;
                        }

                    case "roomunmute": // Unmutes all the muted virtual users in this room (who's rank is lower than this user's rank), making them able to chat again
                        {
                            if (rankManager.containsRight(_Rank, "fuse_room_mute") == false)
                                return false;
                            else
                            {
                                Room.unmuteUsers(_Rank);
                                sendData("BK" + stringManager.getString("scommand_success"));
                                staffManager.addStaffMessage("runmute", userID, Room.roomID, "", "");
                            }
                            break;
                        }
                    #endregion

                    #region :ban/:superban
                    case "ban": // Bans a virtual user from server (no IP ban)
                        {
                            if (rankManager.containsRight(_Rank, "fuse_ban") == false)
                                return false;
                            else
                            {
                                Database dbClient = new Database(false, true, 139);
                                dbClient.addParameterWithValue("name", args[1]);
                                dbClient.Open();
                                DataRow dRow = dbClient.getRow("SELECT id,rank FROM users WHERE name = @name");
                                if (dRow.Table.Rows.Count == 0)
                                    sendData("BK" + stringManager.getString("modtool_actionfailed") + "\r" + stringManager.getString("modtool_usernotfound"));
                                else if (Convert.ToByte(dRow["rank"]) > _Rank)
                                    sendData("BK" + stringManager.getString("modtool_actionfailed") + "\r" + stringManager.getString("modtool_rankerror"));
                                else
                                {
                                    int banHours = int.Parse(args[2]);
                                    string Reason = stringManager.wrapParameters(args, 3);
                                    if (banHours == 0 || Reason == "")
                                        sendData("BK" + stringManager.getString("scommand_failed"));
                                    else
                                    {
                                        staffManager.addStaffMessage("ban", userID, Convert.ToInt32(dRow["id"]), Reason, "");
                                        userManager.setBan(Convert.ToInt32(dRow["id"]), banHours, Reason);
                                        sendData("BK" + userManager.generateBanReport(Convert.ToInt32(dRow["id"])));
                                    }
                                }
                            }
                            break;
                        }

                    case "superban": // Bans an IP address and all virtual user's that used this IP address for their last access from the system
                        {
                            if (rankManager.containsRight(_Rank, "fuse_superban") == false)
                                return false;
                            else
                            {
                                Database dbClient = new Database(false, false, 140);
                                dbClient.addParameterWithValue("name", args[1]);
                                dbClient.Open();
                                DataRow dRow = dbClient.getRow("SELECT id,rank,ipaddress_last FROM users WHERE name = @name");
                                if (dRow.Table.Rows.Count == 0)
                                    sendData("BK" + stringManager.getString("modtool_actionfailed") + "\r" + stringManager.getString("modtool_usernotfound"));
                                else if (Convert.ToByte(dRow["rank"]) > _Rank)
                                    sendData("BK" + stringManager.getString("modtool_actionfailed") + "\r" + stringManager.getString("modtool_rankerror"));
                                else
                                {
                                    int banHours = int.Parse(args[2]);
                                    string Reason = stringManager.wrapParameters(args, 3);
                                    if (banHours == 0 || Reason == "")
                                        sendData("BK" + stringManager.getString("scommand_failed"));
                                    else
                                    {
                                        string IP = Convert.ToString(dRow["ipaddress_last"]);
                                        staffManager.addStaffMessage("superban", userID, Convert.ToInt32(dRow["id"]), Reason, "");
                                        userManager.setBan(IP, banHours, Reason);
                                        sendData("BK" + userManager.generateBanReport(IP));
                                    }
                                }
                                dbClient.Close();
                            }
                            break;
                        }
                    #endregion
                    #endregion

                    #region Message broadcoasting
                    #region :ha
                    case "ha": // Broadcoasts a message to all virtual users (hotel alert)
                    case "hotelalert": // Broadcoasts a message to all virtual users (hotel alert)
                        {
                            if (rankManager.containsRight(_Rank, "fuse_administrator_access") == false)
                                return false;
                            else
                            {
                                string Message = Text.Substring(3);
                                userManager.sendData("BK" + stringManager.getString("scommand_hotelalert") + "\r" + Message);
                                staffManager.addStaffMessage("halert", userID, 0, Message, "");
                            }
                        }
                        break;
                    #endregion

                    #region :offline
                    case "offline": // Broadcoasts a message that the server will shutdown in xx minutes
                        {
                            if (rankManager.containsRight(_Rank, "fuse_administrator_access") == false)
                                return false;
                            else
                            {
                                int Minutes = int.Parse(args[1]);
                                userManager.sendData("Dc" + Encoding.encodeVL64(Minutes));
                                staffManager.addStaffMessage("offline", userID, 0, "mm=" + Minutes, "");
                            }
                            break;
                        }
                    #endregion

                    #region :ra
                    case "ra": // Broadcoasts a message to all users with the same rank (rank alert)
                        {
                            if (rankManager.containsRight(_Rank, "fuse_alert") == false)
                                return false;
                            else
                            {
                                string Message = Text.Substring(3);
                                userManager.sendToRank(_Rank, false, "BK" + stringManager.getString("scommand_rankalert") + "\r" + Message);
                                staffManager.addStaffMessage("rankalert", userID, _Rank, Message, "");
                            }
                            break;
                        }
                    #endregion
                    #endregion

                    #region Special staff commands
                    #region :teleport/:warp
                    case "teleport": // Toggles the user's teleport ability on/off
                        {
                            if (rankManager.containsRight(_Rank, "fuse_administrator_access") == false)
                                return false;
                            else
                            {
                                roomUser.SPECIAL_TELEPORTABLE = (roomUser.SPECIAL_TELEPORTABLE != true); // Reverse the bool
                                refreshAppearance(false, false, true); // Use the poof animation
                            }
                            break;
                        }

                    case "warp": // Warps the virtual user to a certain X,Y coordinate
                        {
                            if (rankManager.containsRight(_Rank, "fuse_administrator_access") == false)
                                return false;
                            else
                            {
                                int X = int.Parse(args[1]);
                                int Y = int.Parse(args[2]);
                                roomUser.X = X;
                                roomUser.Y = Y;
                                roomUser.goalX = -1;
                                Room.Refresh(roomUser);
                                refreshAppearance(false, false, true); // Use the poof animation
                            }
                            break;
                        }
                    #endregion

                    #region :userinfo
                    case "ui":
                    case "userinfo": // Generates a list of information about a certain virtual user
                        {
                            if (rankManager.containsRight(_Rank, "fuse_moderator_access") == false)
                                return false;
                            else
                                sendData("BK" + userManager.generateUserInfo(userManager.getUserID(args[1]), _Rank));
                            break;
                        }
                    #endregion

                    #region :cords
                    case "cords": // Returns the cords of the user
                        {
                            if (rankManager.containsRight(_Rank, "fuse_administrator_access") == false)
                                return false;
                            else
                                sendData("BK" + "X: " + roomUser.X + "\rY: " + roomUser.Y + "\rH: " + roomUser.H);
                            break;
                        }
                    #endregion

                    #region :sendme
                    case "sendme": // Sends the user the packet they enter (Debug Reasons);
                        {
                            if (rankManager.containsRight(_Rank, "fuse_administrator_access") == false)
                                return false;
                            else
                                sendData(stringManager.wrapParameters(args, 1));
                            break;
                        }
                    #endregion

                    #region :refresh
                    case "refresh": // Updates certain parts of the server.
                        {
                            if (rankManager.containsRight(_Rank, "fuse_administrator_access") == false)
                                return false;
                            else
                            {
                                try
                                {
                                    Thread Refresher;
                                    ThreadStart tStarter = null;
                                    switch (args[1])
                                    {
                                        case "catalogue": // Refresh the catalogue
                                            {
                                                tStarter = new ThreadStart(refresh_cat);
                                                break;
                                            }
                                        case "strings": // Refresh the catalogue
                                            {
                                                tStarter = new ThreadStart(refresh_strings);
                                                break;
                                            }
                                        case "config": // Refresh the catalogue
                                            {
                                                tStarter = new ThreadStart(refresh_config);
                                                break;
                                            }
                                        case "filter": // Refresh the catalogue
                                            {
                                                tStarter = new ThreadStart(refresh_filter);
                                                break;
                                            }
                                        case "fuse": // Refresh the catalogue
                                            {
                                                tStarter = new ThreadStart(refresh_fuse);
                                                break;
                                            }
                                        case "eco": // Refresh the catalogue
                                            {
                                                tStarter = new ThreadStart(refresh_eco);
                                                break;
                                            }
                                        default:
                                            sendData("BK" + stringManager.getString("scommand_failed"));
                                            return true;
                                    }
                                    Refresher = new Thread(tStarter);
                                    Refresher.Priority = ThreadPriority.BelowNormal;
                                    Refresher.Start();
                                    sendData("BK" + stringManager.getString("scommand_success"));
                                }
                                catch
                                {
                                    sendData("BK" + ":refresh catalogue\r" +
                                        ":refresh eco\r" +
                                        ":refresh strings\r" +
                                        ":refresh config\r" +
                                        ":refresh filter\r" +
                                        ":refresh fuse\r");
                                }
                                break;
                            }
                        }
                    #endregion
                    #endregion
                    default:
                        return false;
                }
            }
            catch { sendData("BK" + stringManager.getString("scommand_failed")); }
            return true;
        }

        /// <summary>
        /// Checks if the user is involved with a 'BattleBall' or 'SnowStorm' game. If so, then the removal procedure is invoked. If the user is the owner of the game, then the game will be aborted.
        /// </summary>
        internal void leaveGame()
        {
            if (gamePlayer != null && gamePlayer.Game != null)
            {
                if (gamePlayer.Game.Owner == gamePlayer) // Owner leaves game
                {
                    try { gamePlayer.Game.Lobby.Games.Remove(gamePlayer.Game.ID); }
                    catch { }
                    gamePlayer.Game.Abort();
                }
                else if (gamePlayer.teamID != -1) // Team member leaves game
                    gamePlayer.Game.movePlayer(gamePlayer, gamePlayer.teamID, -1);
                else
                {
                    gamePlayer.Game.Subviewers.Remove(gamePlayer);
                    sendData("Cm" + "H");
                }
            }
            this.gamePlayer = null;
        }

        #region :refresh voids
        private void refresh_cat()
        {
            catalogueManager.Init(true);
        }
        private void refresh_strings()
        {
            stringManager.Init("en", true);
        }
        private void refresh_config()
        {
            Config.Init(true);
        }
        private void refresh_filter()
        {
            stringManager.initFilter(true);
        }
        private void refresh_fuse()
        {
            rankManager.Init(true);
        }
        private void refresh_eco()
        {
            recyclerManager.Init(true);
        }
        #endregion
        #region Misc Thread Loops
        private void showBrb()
        {
            int iCount = 0;
            try
            {
                while (true)
                {
                    refreshAppearance(false, false, true);
                    Room.sendShout(roomUser, "\n\n\n      I am currently brb.\n      I have been so for more than: " + (iCount / 2).ToString() + " minutes.\n\n\n      I have been so for more than: 00 minutes.     ");
                    iCount++;
                    if (iCount > 30)
                    {
                        Room.sendShout(roomUser, "\n\n\n      I have been brb for to long and have stoped alerting you.\n\n\n      I have been brb for to long and have stoped alerting you.     ");
                        Thread.CurrentThread.Abort();
                        brbLooper = null;
                    }
                    Thread.Sleep(30000);
                }
            }
            catch
            {
                Thread.CurrentThread.Abort();
                brbLooper = null;
            }
        }
        #endregion

        private delegate void TeleporterUsageSleep(Rooms.Items.floorItem Teleporter1, int idTeleporter2, int roomIDTeleporter2);
        private void useTeleporter(Rooms.Items.floorItem Teleporter1, int idTeleporter2, int roomIDTeleporter2)
        {
            roomUser.walkLock = true;
            string Sprite = Teleporter1.Sprite;
            if (roomIDTeleporter2 == _roomID) // Partner teleporter is in same room, don't leave room
            {
                Rooms.Items.floorItem Teleporter2 = Room.floorItemManager.getItem(idTeleporter2);
                Thread.Sleep(500);
                Room.sendData("AY" + Teleporter1.ID + "/" + _Username + "/" + Sprite);
                //Thread.Sleep(1000);
                Room.sendData(@"A\" + Teleporter2.ID + "/" + _Username + "/" + Sprite);
                roomUser.X = Teleporter2.X;
                roomUser.Y = Teleporter2.Y;
                roomUser.H = Teleporter2.H;
                roomUser.Z1 = Teleporter2.Z;
                roomUser.Z2 = Teleporter2.Z;
                roomUser.Refresh();
                roomUser.walkLock = false;
            }
            else // Partner teleporter is in different room
            {
                _teleporterID = idTeleporter2;
                sendData("@~" + Encoding.encodeVL64(idTeleporter2) + Encoding.encodeVL64(roomIDTeleporter2));
                Room.sendData("AY" + Teleporter1.ID + "/" + _Username + "/" + Sprite);
            }
        }
        #endregion
    }
}