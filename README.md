HDebug
======

HDebug library:

Functions:

//Return a clean table of hooks, name it's optional

hook.GetDebug(string:name or nil)

//Write a file and set a kind of crc

hook.Bake(string:name or nil,number:id or nil)

//Disable a hook <time> seconds

hook.ByPass(string:tabl,string:name,number:time)

//Write a file with all addons installed

file.BakeAddons()

Chat functions:

// % will run a string after the %

%MsgN("Hello")

// $ will run a command after the $

$sv_gravity 200

