#include <open.mp>
#include <a_mysql>
//include database config
#include "includes/config_database.pwn"

main()
{
    print("============================");
    print("in gamemode ejra shod");
    print("==== TG : xxNeXus ====");
    print("============================");
}
// list of dialog
#define DIALOG_LOGIN 1
#define DIALOG_REGISTER 2
#define BTN_NEXT "Next"
#define BTN_EXIT "Exit"


enum Player_data
{
    pName[24],
    pPassword[32],
    bool:loginned
}
new PlayerInfo[MAX_PLAYERS][Player_data];
public OnGameModeInit()
{
    connection = mysql_connect(MYSQL_HOST, MYSQL_UZR, MYSQL_PASS, MYSQL_DB);
    if (mysql_errno(connection) != 0)
    {
        print("[MYSQL] - database vasel nashod!");
        return 1;
    }
    print("[MYSQL] - database vasel shod!");
    SetGameModeText("Login And Register System");
    return 1;
}

public OnGameModeExit()
{
    mysql_close(connection);
    return 1;
}

public OnPlayerConnect(playerid)
{
    new Name[MAX_PLAYER_NAME], query[128];
    GetPlayerName(playerid, Name, sizeof(Name));
    PlayerInfo[playerid][pName] = Name;
    mysql_format(connection, query, sizeof(query), "SELECT * FROM `players` WHERE `pName` = '%e'", PlayerInfo[playerid][pName]);
    printf("================ %s", query);
    mysql_tquery(connection, query, "OnPlayerConnectCheckAcoount", "i", playerid);
    return 1;
}
forward OnPlayerConnectCheckAcoount(playerid);
public OnPlayerConnectCheckAcoount(playerid)
{
    new nums = cache_num_rows();
    if (nums > 0)
    {
        new Name[MAX_PLAYER_NAME], mess[128];
        cache_get_value_name(0, "pPassword", PlayerInfo[playerid][pPassword]);
        printf("ram: '%s'", PlayerInfo[playerid][pPassword]);
        format(mess, sizeof(mess), "%s Aziz Be Server Khosh omadi! Lotfan Ramz Khod Ra Vared Konid : ", Name);
        ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_INPUT, "Login", mess, BTN_NEXT, BTN_EXIT);
        return 1;
    }
    else
    {
        new Name[MAX_PLAYER_NAME], mess[128];
        GetPlayerName(playerid, Name, sizeof(Name));
        format(mess, sizeof(mess), "%s Aziz! Hesab shoma dar database ma vojud nedard - Lorfan Yek Hesab Besazid\n - Lotfan Yek ramz ghavi entekhab konid \n lotfan ramz shoma bishtar az 6 horuf bashed", Name);
        ShowPlayerDialog(playerid, DIALOG_REGISTER, DIALOG_STYLE_INPUT, "Register", mess, BTN_NEXT, BTN_EXIT);
        return 1;
    }
}
public OnPlayerDisconnect(playerid, reason)
{
    return 1;
}

public OnPlayerRequestClass(playerid, classid)
{
    SetPlayerPos(playerid, 217.8511, -98.4865, 1005.2578);
    SetPlayerFacingAngle(playerid, 113.8861);
    SetPlayerInterior(playerid, 15);
    SetPlayerCameraPos(playerid, 215.2182, -99.5546, 1006.4);
    SetPlayerCameraLookAt(playerid, 217.8511, -98.4865, 1005.2578);
    ApplyAnimation(playerid, "benchpress", "gym_bp_celebrate", 4.1, true, false, false, false, 0, SYNC_NONE);
    return 1;
}

public OnPlayerSpawn(playerid)
{
    if (!PlayerInfo[playerid][loginned])
    {
        SendClientMessage(playerid, -1, "Shoma Login Nakrdin");
        Kick(playerid);
    }
    SetPlayerInterior(playerid, 0);
    SendClientMessage(playerid, -1, "Shoma Spawn Shodid!");
    return 1;
}

public OnPlayerDeath(playerid, killerid, WEAPON:reason)
{
    return 1;
}

public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
    return 1;
}

public OnPlayerExitVehicle(playerid, vehicleid)
{
    return 1;
}

public OnVehicleSpawn(vehicleid)
{
    return 1;
}

public OnVehicleDeath(vehicleid, killerid)
{
    return 1;
}

/*
     ___              _      _ _    _
    / __|_ __  ___ __(_)__ _| (_)__| |_
    \__ \ '_ \/ -_) _| / _` | | (_-<  _|
    |___/ .__/\___\__|_\__,_|_|_/__/\__|
        |_|
*/

public OnFilterScriptInit()
{
    printf(" ");
    printf("  -----------------------------------------");
    printf("  |  Error: Script was loaded incorrectly |");
    printf("  -----------------------------------------");
    printf(" ");
    return 1;
}

public OnFilterScriptExit()
{
    return 1;
}

public OnPlayerRequestSpawn(playerid)
{
    return 1;
}

public OnPlayerCommandText(playerid, cmdtext[])
{
    return 0;
}

public OnPlayerText(playerid, text[])
{
    return 1;
}

public OnPlayerUpdate(playerid)
{
    return 1;
}

public OnPlayerKeyStateChange(playerid, KEY:newkeys, KEY:oldkeys)
{
    return 1;
}

public OnPlayerStateChange(playerid, PLAYER_STATE:newstate, PLAYER_STATE:oldstate)
{
    return 1;
}

public OnPlayerEnterCheckpoint(playerid)
{
    return 1;
}

public OnPlayerLeaveCheckpoint(playerid)
{
    return 1;
}

public OnPlayerEnterRaceCheckpoint(playerid)
{
    return 1;
}

public OnPlayerLeaveRaceCheckpoint(playerid)
{
    return 1;
}

public OnPlayerGiveDamageActor(playerid, damaged_actorid, Float:amount, WEAPON:weaponid, bodypart)
{
    return 1;
}

public OnActorStreamIn(actorid, forplayerid)
{
    return 1;
}

public OnActorStreamOut(actorid, forplayerid)
{
    return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    if (dialogid == DIALOG_LOGIN)
    {
        if (!response)
        {
            Kick(playerid);
            return 1;
        }
        if (strlen(inputtext) < 6)
        {
            ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_INPUT, "Login", "Ramz shoma nebaid kamtar az 6 horof bashd", BTN_NEXT, BTN_EXIT);
            return 1;
        }
        if (!strcmp(inputtext, PlayerInfo[playerid][pPassword]))
        {
            // Login Player is oky
            PlayerInfo[playerid][loginned] = true;
            SpawnPlayer(playerid);
            return 1;
        }
        else
        {
            // system tedad kheta badn ezafe misheved
            ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_INPUT, "Login", "Ramz shoma Nadorost ast, lotfan az aval telaash konid", BTN_NEXT, BTN_EXIT);
            return 1;
        }
    }
    if (dialogid == DIALOG_REGISTER)
    {
        if (!response)
        {
            ShowPlayerDialog(playerid, DIALOG_REGISTER, DIALOG_STYLE_INPUT, "Register", "Beraye sabt-name Dokme Next Ra Beznid", BTN_NEXT, BTN_EXIT);
            return 1;
        }
        if (strlen(inputtext) < 6)
        {
            ShowPlayerDialog(playerid, DIALOG_REGISTER, DIALOG_STYLE_INPUT, "Register", "Ramz Shoma Nebaid Kamtar az 6 horuf bashed", BTN_NEXT, BTN_EXIT);
            return 1;
        }
        return 1;


    }
    return 1;
}
forward OnPlayerLoginCheck(playerid, inputtext[]);
public OnPlayerLoginCheck(playerid, inputtext[])
{

}
public OnPlayerEnterGangZone(playerid, zoneid)
{
    return 1;
}

public OnPlayerLeaveGangZone(playerid, zoneid)
{
    return 1;
}

public OnPlayerEnterPlayerGangZone(playerid, zoneid)
{
    return 1;
}

public OnPlayerLeavePlayerGangZone(playerid, zoneid)
{
    return 1;
}

public OnPlayerClickGangZone(playerid, zoneid)
{
    return 1;
}

public OnPlayerClickPlayerGangZone(playerid, zoneid)
{
    return 1;
}

public OnPlayerSelectedMenuRow(playerid, row)
{
    return 1;
}

public OnPlayerExitedMenu(playerid)
{
    return 1;
}

public OnClientCheckResponse(playerid, actionid, memaddr, retndata)
{
    return 1;
}

public OnRconLoginAttempt(ip[], password[], success)
{
    return 1;
}

public OnPlayerFinishedDownloading(playerid, virtualworld)
{
    return 1;
}

public OnPlayerRequestDownload(playerid, DOWNLOAD_REQUEST:type, crc)
{
    return 1;
}

public OnRconCommand(cmd[])
{
    return 0;
}

public OnPlayerSelectObject(playerid, SELECT_OBJECT:type, objectid, modelid, Float:fX, Float:fY, Float:fZ)
{
    return 1;
}

public OnPlayerEditObject(playerid, playerobject, objectid, EDIT_RESPONSE:response, Float:fX, Float:fY, Float:fZ, Float:fRotX, Float:fRotY, Float:fRotZ)
{
    return 1;
}

public OnPlayerEditAttachedObject(playerid, EDIT_RESPONSE:response, index, modelid, boneid, Float:fOffsetX, Float:fOffsetY, Float:fOffsetZ, Float:fRotX, Float:fRotY, Float:fRotZ, Float:fScaleX, Float:fScaleY, Float:fScaleZ)
{
    return 1;
}

public OnObjectMoved(objectid)
{
    return 1;
}

public OnPlayerObjectMoved(playerid, objectid)
{
    return 1;
}

public OnPlayerPickUpPickup(playerid, pickupid)
{
    return 1;
}

public OnPlayerPickUpPlayerPickup(playerid, pickupid)
{
    return 1;
}

public OnPickupStreamIn(pickupid, playerid)
{
    return 1;
}

public OnPickupStreamOut(pickupid, playerid)
{
    return 1;
}

public OnPlayerPickupStreamIn(pickupid, playerid)
{
    return 1;
}

public OnPlayerPickupStreamOut(pickupid, playerid)
{
    return 1;
}

public OnPlayerStreamIn(playerid, forplayerid)
{
    return 1;
}

public OnPlayerStreamOut(playerid, forplayerid)
{
    return 1;
}

public OnPlayerTakeDamage(playerid, issuerid, Float:amount, WEAPON:weaponid, bodypart)
{
    return 1;
}

public OnPlayerGiveDamage(playerid, damagedid, Float:amount, WEAPON:weaponid, bodypart)
{
    return 1;
}

public OnPlayerClickPlayer(playerid, clickedplayerid, CLICK_SOURCE:source)
{
    return 1;
}

public OnPlayerWeaponShot(playerid, WEAPON:weaponid, BULLET_HIT_TYPE:hittype, hitid, Float:fX, Float:fY, Float:fZ)
{
    return 1;
}

public OnPlayerClickMap(playerid, Float:fX, Float:fY, Float:fZ)
{
    return 1;
}

public OnIncomingConnection(playerid, ip_address[], port)
{
    return 1;
}

public OnPlayerInteriorChange(playerid, newinteriorid, oldinteriorid)
{
    return 1;
}

public OnPlayerClickTextDraw(playerid, Text:clickedid)
{
    return 1;
}

public OnPlayerClickPlayerTextDraw(playerid, PlayerText:playertextid)
{
    return 1;
}

public OnTrailerUpdate(playerid, vehicleid)
{
    return 1;
}

public OnVehicleSirenStateChange(playerid, vehicleid, newstate)
{
    return 1;
}

public OnVehicleStreamIn(vehicleid, forplayerid)
{
    return 1;
}

public OnVehicleStreamOut(vehicleid, forplayerid)
{
    return 1;
}

public OnVehicleMod(playerid, vehicleid, componentid)
{
    return 1;
}

public OnEnterExitModShop(playerid, enterexit, interiorid)
{
    return 1;
}

public OnVehiclePaintjob(playerid, vehicleid, paintjobid)
{
    return 1;
}

public OnVehicleRespray(playerid, vehicleid, color1, color2)
{
    return 1;
}

public OnVehicleDamageStatusUpdate(vehicleid, playerid)
{
    return 1;
}

public OnUnoccupiedVehicleUpdate(vehicleid, playerid, passenger_seat, Float:new_x, Float:new_y, Float:new_z, Float:vel_x, Float:vel_y, Float:vel_z)
{
    return 1;
}
