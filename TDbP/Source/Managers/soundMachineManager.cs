using System;
using System.Data;
using System.Text;

namespace Holo.Managers
{
    /// <summary>
    /// Provides management for virtual sound machines and virtual songs.
    /// </summary>
    public static class soundMachineManager
    {
        /// <summary>
        /// Returns the string with all the soundsets in the Hand of a certain user.
        /// </summary>
        /// <param name="userID">The database ID of the user to get the soundsets of.</param>
        public static string getHandSoundsets(int userID)
        {
            Database dbClient = new Database(true, true, 32);
            DataColumn dCol = dbClient.getColumn("SELECT soundmachine_soundset FROM furniture WHERE ownerid = '" + userID + "' AND roomid = '0' AND soundmachine_soundset > 0");
            StringBuilder Soundsets = new StringBuilder(Encoding.encodeVL64(dCol.Table.Rows.Count));
            foreach(DataRow dRow in dCol.Table.Rows)
                Soundsets.Append(Encoding.encodeVL64(Convert.ToInt32(dRow["soundmachine_soundset"])));
            return Soundsets.ToString();
        }
        /// <summary>
        /// Returns the length of a song in seconds as an integer. The length is calculated by counting the notes on the four tracks, if an error occurs here, then -1 is returned as length.
        /// </summary>
        /// <param name="Data">The songdata. (all 4 tracks)</param>
        public static int calculateSongLength(string Data)
        {
            int songLength = 0;
            try
            {
                string[] Track = Data.Split(':');
                for (int i = 1; i < 8; i += 3)
                {
                    int trackLength = 0;
                    string[] Samples = Track[i].Split(';');
                    for (int j = 0; j < Samples.Length; j++)
                        trackLength += int.Parse(Samples[j].Substring(Samples[j].IndexOf(",") + 1));

                    if (trackLength > songLength)
                        songLength = trackLength;
                }
                return songLength;
            }
            catch { return -1; }
        }

        public static string getMachineSongList(int machineID)
        {
            Database dbClient = new Database(true, true, 33);
            DataTable dTable = dbClient.getTable("SELECT id,length,title,burnt FROM soundmachine_songs WHERE machineid = '" + machineID + "' ORDER BY id ASC");
            StringBuilder Songs = new StringBuilder(Encoding.encodeVL64(dTable.Rows.Count));
            foreach (DataRow dRow in dTable.Rows)
            {
                Songs.Append(Encoding.encodeVL64(Convert.ToInt32(dRow["id"])) + Encoding.encodeVL64(Convert.ToInt32(dRow["length"])) + Convert.ToString(dRow["title"]) + Convert.ToChar(2));
                if (Convert.ToString(dRow["burnt"]) == "1")
                    Songs.Append("I");
                else
                    Songs.Append("H");
            }
            return Songs.ToString();
        }
        public static string getMachinePlaylist(int machineID)
        {
            Database dbClient = new Database(true, false, 34);
            DataColumn dCol = dbClient.getColumn("SELECT songid FROM soundmachine_playlists WHERE machineid = '" + machineID + "' ORDER BY pos ASC");
            StringBuilder Playlist = new StringBuilder("H" + Encoding.encodeVL64(dCol.Table.Rows.Count));
            string Title;
            string Creator;
            foreach (DataRow dRow in dCol.Table.Rows)
            {
                Title = dbClient.getString("SELECT title FROM soundmachine_songs WHERE id = '" + dRow[0].ToString() + "'");
                Creator = dbClient.getString("SELECT name FROM users WHERE id = '" + dbClient.getString("SELECT userid FROM soundmachine_songs WHERE id = '" + dRow[0].ToString() + "'") + "'");
                Playlist.Append(Encoding.encodeVL64(Convert.ToInt32(dRow[0])) + Encoding.encodeVL64(Convert.ToInt32(dRow[0]) + 1) + Title + Convert.ToChar(2) + Creator + Convert.ToChar(2));
            }
            dbClient.Close();
            return Playlist.ToString();
        }
        public static string getSong(int songID)
        {
            Database dbClient = new Database(true, true, 35);
            DataRow dRow = dbClient.getRow("SELECT title,data FROM soundmachine_songs WHERE id = '" + songID + "'");
            object[] songObject = dRow.ItemArray;
            string[] songData = new string[songObject.Length];
            for (int i = 0; i < songObject.Length; i++)
                songData[i] = songObject[i].ToString();
            if (songData.Length > 0)
                return Encoding.encodeVL64(songID) + songData[0] + Convert.ToChar(2) + songData[1] + Convert.ToChar(2);
            else
                return "holo.cast.soundmachine.song.unknown";
        }
    }
}
