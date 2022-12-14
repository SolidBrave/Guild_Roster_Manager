


-- LOCALIZATION ENUMS AND LOGIC

-- Table used for lookup, to determine the extent of the translation work compelted or not. This will be used as a quick lookup reference rather than parsing and counting the entire dictionaries
GRML.TranslationStatusEnum = {
    English = true,                 -- English is completed
    German = true,
    French = false,
    Italian = false,
    Russian = false,
    SpanishMX = false,
    SpanishEU = false,
    Portuguese = false,
    Korean = false,
    MandarinCN = false,
    MandarinTW = false  
}

GRML.Languages = {
    "English",
    "German",
    "French",
    "Italian",
    "Russian",
    "SpanishMX",
    "SpanishEU",
    "Portuguese" ,
    "Korean",
    "MandarinCN",
    "MandarinTW"
}

-- Array that holds all the initialization functions to load the dictionary of each language.
GRML.LoadLanguage = {
    GRML.English,
    GRML.German,
    GRML.French,
    GRML.Italian,
    GRML.Russian,
    GRML.SpanishMX,
    GRML.SpanishEU,
    GRML.Portuguese,
    GRML.Korean,
    GRML.MandarinCN,
    GRML.MandarinTW
}

-- Method:          GRML.GetFontNameFromLocation ( string )
-- What it does:    Parses out the name of the font from the file
-- Purpose:         To be able to identify any font...
GRML.GetFontNameFromLocation = function ( fontFileLocation )
    local result = "";
    for i = #fontFileLocation , 1 , -1 do
        if string.sub ( fontFileLocation , i , i ) == "\\" then
            result = string.sub ( fontFileLocation , i + 1 , string.find ( fontFileLocation , "%." ) - 1 );
            break;
        end
    end
    result = string.gsub ( result , "_" , "" );
    return result;
end

GRML.FontNames = {
    "Default(" .. GRML.GetFontNameFromLocation ( STANDARD_TEXT_FONT ) .. ")",
    "Blizz FrizQT",
    "Blizz FrizQT(Cyr)",
    "Blizz Korean",
    "Blizz MandarinCN",
    "Blizz MandarinTW",
    "Action Man",
    "Ancient",
    "Bitter",
    "Cardinal",
    "Continuum",
    "Expressway",
    "Merriweather",
    "PT Sans",
    "Roboto",
}

GRML.listOfFonts = {
    -------------------
    -- DEFAULT FONTS
    -------------------
    STANDARD_TEXT_FONT,
    -- Non-Cyrillic Friendly
    "FONTS\\FRIZQT__.TTF",
    -- Cyrillic Friendly
    "FONTS\\FRIZQT___CYR.TTF",
    -- Asian Character Friendly (and Cyrillic)
    -- Korean
    "FONTS\\2002.TTF",
    -- Simplified Chinese
    "FONTS\\ARKai_T.TTF",
    -- Traditional Chines
    "FONTS\\blei00d.TTF",

    ---------------
    -- CUSTOM FONTS (so far none are Asian character friendly)
    ---------------
    "Interface\\AddOns\\Guild_Roster_Manager\\media\\fonts\\Action_Man.TTF",
    "Interface\\AddOns\\Guild_Roster_Manager\\media\\fonts\\Ancient.TTF",
    "Interface\\AddOns\\Guild_Roster_Manager\\media\\fonts\\Bitter-Regular.OTF",
    "Interface\\AddOns\\Guild_Roster_Manager\\media\\fonts\\Cardinal.TTF",      
    "Interface\\AddOns\\Guild_Roster_Manager\\media\\fonts\\Continuum_Medium.TTF",    
    "Interface\\AddOns\\Guild_Roster_Manager\\media\\fonts\\Expressway.TTF",
    "Interface\\AddOns\\Guild_Roster_Manager\\media\\fonts\\Merriweather-Regular.TTF",
    "Interface\\AddOns\\Guild_Roster_Manager\\media\\fonts\\PT_Sans_Narrow.TTF",
    "Interface\\AddOns\\Guild_Roster_Manager\\media\\fonts\\Roboto-Regular.TTF"    
}

-- Method:          GRML.SetNewLanguage ( int , boolean )
-- What it Does:    It establishes both the appropriate region font, and a modifier for the Mandarin text
-- Purpose:         To be able to have an in-game UI option to change the player language.
GRML.SetNewLanguage = function ( index , firstLoad )
    GRML.LoadLanguage[index]();
    GRM_G.FontChoice = GRML.listOfFonts[GRM_AddonSettings_Save[GRM_G.FID][GRM_G.setPID][2][44]];
    GRML.SetFontModifier();
    if firstLoad then
        GRM_UI.ReloadAllFrames( false );
    else
        GRM_UI.ReloadAllFrames ( true );
    end
end

-- Method:          GRML.SetFontModifier()
-- What it Does:    Since different custom fonts represent font height differently, this normalizes the fonts, relatively close
-- Purpose:         Consistency, as some fonts would be super tiny otherwise.
GRML.SetFontModifier = function()
    -- Reset it...
    GRM_G.FontModifier = 0;
    if GRM_G.FontChoice == "Fonts\\ARKai_T.TTF" then                             -- China
        GRM_G.FontModifier = 0.5;
    elseif GRM_G.FontChoice == "FONTS\\blei00d.TTF" then                         -- Taiwan
        GRM_G.FontModifier = 2;
    elseif GRM_G.FontChoice == "Interface\\AddOns\\Guild_Roster_Manager\\media\\fonts\\Action_Man.TTF" then
        GRM_G.FontModifier = 1;
    elseif GRM_G.FontChoice == "Interface\\AddOns\\Guild_Roster_Manager\\media\\fonts\\Ancient.TTF" then
        GRM_G.FontModifier = 2;
    elseif GRM_G.FontChoice == "Interface\\AddOns\\Guild_Roster_Manager\\media\\fonts\\Cardinal.TTF" then
        GRM_G.FontModifier = 2;
    elseif GRM_G.FontChoice == "Interface\\AddOns\\Guild_Roster_Manager\\media\\fonts\\Continuum_Medium.TTF" then
        GRM_G.FontModifier = 1;
    elseif GRM_G.FontChoice == "Interface\\AddOns\\Guild_Roster_Manager\\media\\fonts\\Expressway.TTF" then
        GRM_G.FontModifier = 1;
    elseif GRM_G.FontChoice == "Interface\\AddOns\\Guild_Roster_Manager\\media\\fonts\\PT_Sans_Narrow.TTF" then
        GRM_G.FontModifier = 2;
    elseif GRM_G.FontChoice == "Interface\\AddOns\\Guild_Roster_Manager\\media\\fonts\\Roboto-Regular.TTF" then
        GRM_G.FontModifier = 1;
    end
    GRM_G.FontModifier = GRM_G.FontModifier + GRM_AddonSettings_Save[GRM_G.FID][GRM_G.setPID][2][45];
end

-- Method:          GRML.SetNewFont( int )
-- What it Does:    Establishes a new font
-- Purpose:         More player customization controls!!!
GRML.SetNewFont = function( index )
    GRM_G.FontChoice = GRML.listOfFonts[index];
    GRML.SetFontModifier();
    GRM_UI.ReloadAllFrames( true );
end

-- Method:          GRML.GetFontChoice() -- Not necessary for the most part as I can use "STANDARD_TEXT_FONT" - but, just in case...
-- What it Does:    Selects the proper font for the given locale of the addon user.
-- Purpose:         To ensure no ???? are in place and all characters are accounted for.
GRML.GetFontChoiceIndex = function( localizationIndex )
    local result = 1;
    if GRM_AddonSettings_Save[GRM_G.FID][GRM_G.setPID][2][44] ~= 1 then
        if ( localizationIndex < 5 or ( localizationIndex > 5 and localizationIndex < 9 ) ) then
            result = 2
        else
            result = GRM_AddonSettings_Save[GRM_G.FID][GRM_G.setPID][2][44];
        end
        -- For Russian, need Cyrilic compatible font.
        if localizationIndex == 5 and GRM_G.Region ~= "ruRU" then
            -- Russian Cyrilic
            result = 3;
        elseif localizationIndex == 9 and GRM_G.Region ~= "koKR" then
            -- Korean
            result = 4;
        elseif localizationIndex == 10 and GRM_G.Region ~= "zhCN" then
            -- Mandarin Chines
            result = 5;
        elseif localizationIndex == 11 and GRM_G.Region ~= "zhTW" then
            -- Taiwanese
            result = 6;
        end
    else
        result = 1;
    end
    return result;
end

-- Method:          GRML.GetNumberUntranslatedLines ( int )
-- What it Does:    It returns the number of language lines that need to be translated
-- Purpose:         To help reach out to the community to build an effort for crowdsupport for translation efforts.
GRML.GetNumberUntranslatedLines = function ( languageIndex )
    local result = 0;
    -- index 1 will always result as 0 since it is written native in English
    if languageIndex > 1 then
        for x , y in pairs ( GRM_L ) do
            if y == true then
                result = result + 1;
            end
        end
    end
    return result;
end

----------------------------------------------
-------- LOCALIZATION SYSTEM MESSAGES --------
-------- DO NOT CHANGE THESE! THEY ARE--------
-------- DIRECT FROM THE SERVER!!!!!! --------
----------------------------------------------

-- All of these values are static and cannot be changed by the addon as they are system messages based on the player's language settings. Whilst they can manually change the language they are 
-- using for the addon, they cannot adjust the language of the WOW client without exiting WOW and adjusting the settings in the Battle.net launcher settings. This is not possible from within game so these values will
-- be static and are used for identifying and parsing system message events.

-- German Defaults
if GRM_G.Region == "deDE" then
    GRM_G.Localized = true
    GRM_G.LocalizedIndex = 2;
    -- SYSTEM MESSAGES (DO NOT CHANGE THESE!!!! They are used for the back-end code to recognize for parsing info out, not for player UI
    GRM_L["has been kicked"] = "aus der Gilde geworfen."
    GRM_L["joined the guild."] = "Gilde angeschlossen."
    GRM_L["has promoted"] = "bef??rdert."
    GRM_L["has demoted"] = "degradiert."
    GRM_L["Professions"] = "Berufe"
    GRM_L["Guild: "] = "Gilde: "
    GRM_L["Guild created "] = "Gilde am "
    GRM_L["added to friends"] = "zur Kontaktliste hinzugef??gt."
    GRM_L["is already your friend"] = "ist bereits einer Eurer Kontakte."
    GRM_L["Player not found."] = "Spieler nicht gefunden."

    GRML.LoadLanguage[2]();

-- French Defaults
elseif GRM_G.Region == "frFR" then
    GRM_G.Localized = true
    GRM_G.LocalizedIndex = 3;
    -- SYSTEM MESSAGES (DO NOT CHANGE THESE!!!! They are used for the back-end code to recognize for parsing info out, not for player UI
    GRM_L["has been kicked"] = "a ??t?? renvoy??"
    GRM_L["joined the guild."] = "rejoint la guilde."
    GRM_L["has promoted"] = "a promu"
    GRM_L["has demoted"] = "a r??trograd??"
    GRM_L["Professions"] = "M??tiers"
    GRM_L["Guild: "] = "Guilde??: "
    GRM_L["Guild created "] = "Guilde cr????e le "
    GRM_L["added to friends"] = "fait maintenant partie de vos contacts."
    GRM_L["is already your friend"] = "est d??j?? dans votre liste de contacts."
    GRM_L["Player not found."] = "Joueur introuvable."

    GRML.LoadLanguage[3]();

-- Italian Defaults
elseif GRM_G.Region == "itIT" then
    GRM_G.Localized = true
    GRM_G.LocalizedIndex = 4;
    -- SYSTEM MESSAGES (DO NOT CHANGE THESE!!!! They are used for the back-end code to recognize for parsing info out, not for player UI
    GRM_L["has been kicked"] = "stato cacciato dalla"
    GRM_L["joined the guild."] = "si unisce alla gilda."
    GRM_L["has promoted"] = "al grado"
    GRM_L["has demoted"] = " degrada "
    GRM_L["Professions"] = "Professioni"
    GRM_L["Guild: "] = "Gilda: "
    GRM_L["Guild created "] = "Gilda creata il "
    GRM_L["added to friends"] = "all'elenco amici."   
    GRM_L["is already your friend"] = "?? gi?? nell'elenco amici."
    GRM_L["Player not found."] = "Personaggio non trovato."

    GRML.LoadLanguage[4]();

-- Russian Defaults
elseif GRM_G.Region == "ruRU" then
    GRM_G.Localized = true
    GRM_G.LocalizedIndex = 5;
    -- SYSTEM MESSAGES (DO NOT CHANGE THESE!!!! They are used for the back-end code to recognize for parsing info out, not for player UI
    GRM_L["has been kicked"] = "?????????????????? ???? ?????????????? "
    GRM_L["joined the guild."] = "?? ??????????????."
    GRM_L["has promoted"] = " ???????????????????? "
    GRM_L["has demoted"] = " ?????????????????? "
    GRM_L["Professions"] = "??????????????????"
    GRM_L["Guild: "] = "??????????????: "
    GRM_L["Guild created "] = "?????????????? ??????????????: "
    GRM_L["added to friends"] = " ?? ???????????? ????????????."
    GRM_L["is already your friend"] = "?????? ???????? ?? ?????????? ???????????? ????????????."
    GRM_L["Player not found."] = "?????????? ???? ????????????."

    GRML.LoadLanguage[5]();

    -- Spanish (MX) Defaults
elseif GRM_G.Region == "esMX" then
    GRM_G.Localized = true
    GRM_G.LocalizedIndex = 6;
    -- SYSTEM MESSAGES (DO NOT CHANGE THESE!!!! They are used for the back-end code to recognize for parsing info out, not for player UI
    GRM_L["has been kicked"] = "ha sido expulsado"
    GRM_L["joined the guild."] = "a la hermandad."
    GRM_L["has promoted"] = "ha ascendido"
    GRM_L["has demoted"] = "ha degradado"
    GRM_L["Professions"] = "Profesiones"
    GRM_L["Guild: "] = "Hermandad: "
    GRM_L["Guild created "] = "Hermandad creada "
    GRM_L["added to friends"] = "a??adido como amigo."
    GRM_L["is already your friend"] = "ya est?? en tu lista de amigos."
    GRM_L["Player not found."] = "No se ha encontrado al jugador."

    GRML.LoadLanguage[6]();

    -- Spanish (EU) Defaults
elseif GRM_G.Region == "esES" then
    GRM_G.Localized = true
    GRM_G.LocalizedIndex = 7;
    GRM_L["has been kicked"] = "ha sido expulsado"
    GRM_L["joined the guild."] = "a la hermandad."
    GRM_L["has promoted"] = "ha ascendido"
    GRM_L["has demoted"] = "ha degradado"
    GRM_L["Professions"] = "Profesiones"
    GRM_L["Guild: "] = "Hermandad: "
    GRM_L["Guild created "] = "Hermandad creada "
    GRM_L["added to friends"] = "a??adido como amigo."
    GRM_L["is already your friend"] = "en tu lista de amigos."
    GRM_L["Player not found."] = "No se ha encontrado al jugador."

    GRML.LoadLanguage[7]();

-- Portuguese Defaults
elseif GRM_G.Region == "ptBR" then
    GRM_G.Localized = true
    GRM_G.LocalizedIndex = 8;
    -- SYSTEM MESSAGES (DO NOT CHANGE THESE!!!! They are used for the back-end code to recognize for parsing info out, not for player UI
    GRM_L["has been kicked"] = "foi expulso da"
    GRM_L["joined the guild."] = "entrou na guilda."
    GRM_L["has promoted"] = " promoveu "
    GRM_L["has demoted"] = " rebaixou "
    GRM_L["Professions"] = "Profiss??es"
    GRM_L["Guild: "] = "Guilda: "
    GRM_L["Guild created "] = "Guilda criada "
    GRM_L["added to friends"] = "j?? est?? na lista de amigos."
    GRM_L["is already your friend"] = "?? gi?? nell'elenco amici."
    GRM_L["Player not found."] = "Jogador n??o encontrado."

    GRML.LoadLanguage[8]();

    -- Korean Defaults
elseif GRM_G.Region == "koKR" then
    GRM_G.Localized = true
    GRM_G.LocalizedIndex = 9;
    -- SYSTEM MESSAGES (DO NOT CHANGE THESE!!!! They are used for the back-end code to recognize for parsing info out, not for player UI
    GRM_L["has been kicked"] = "???????????? ??????????????????."
    GRM_L["joined the guild."] = "?????? ????????? ??????????????????"
    GRM_L["has promoted"] = "??? ???????????????."
    GRM_L["has demoted"] = "??? ???????????????."
    GRM_L["Professions"] = "?????? ??????"
    GRM_L["Guild: "] = "??????: "
    GRM_L["Guild created "] = "?????? ?????????: "
    GRM_L["added to friends"] = "?????? ?????? ????????? ?????????????????????."
    GRM_L["is already your friend"] = "?????? ?????? ?????? ????????? ????????????."
    GRM_L["Player not found."] = "??????????????? ?????? ??? ????????????."

    GRML.LoadLanguage[9]();

    -- Mandarin Chinese (CN) Defaults
elseif GRM_G.Region == "zhCN" then
    GRM_G.Localized = true
    GRM_G.LocalizedIndex = 10;
    -- SYSTEM MESSAGES (DO NOT CHANGE THESE!!!! They are used for the back-end code to recognize for parsing info out, not for player UI
    GRM_L["has been kicked"] = "??????????????????"
    GRM_L["joined the guild."] = "??????????????????"
    GRM_L["has promoted"] = "?????????"
    GRM_L["has demoted"] = "?????????"
    GRM_L["Professions"] = "??????"
    GRM_L["Guild: "] = "?????????"
    GRM_L["Guild created "] = "???????????????"
    GRM_L["added to friends"] = "????????????????????????"
    GRM_L["is already your friend"] = "?????????????????????????????????"
    GRM_L["Player not found."] = "?????????????????????"

    GRML.LoadLanguage[10]();

-- Mandarin Chinese (TW) Defaults
elseif GRM_G.Region == "zhTW" then
    GRM_G.Localized = true
    GRM_G.LocalizedIndex = 11;
    -- SYSTEM MESSAGES (DO NOT CHANGE THESE!!!! They are used for the back-end code to recognize for parsing info out, not for player UI
    GRM_L["has been kicked"] = "???????????????"
    GRM_L["joined the guild."] = "??????????????????"
    GRM_L["has promoted"] = "?????????"
    GRM_L["has demoted"] = "?????????"
    GRM_L["Professions"] = "????????????"
    GRM_L["Guild: "] = "?????????"
    GRM_L["Guild created "] = "???????????????"
    GRM_L["added to friends"] = "???????????????????????????"
    GRM_L["is already your friend"] = "?????????????????????????????????"
    GRM_L["Player not found."] = "?????????????????????"

    GRML.LoadLanguage[11]();

-- English Defaults
elseif GRM_G.Region == "enUS" or GRM_G.Region == "enGB" or not GRM_G.Localized then         -- In case the Region is not found at this point, just default it to English.
    GRM_G.Localized = true
    GRM_G.LocalizedIndex = 1;
    -- SYSTEM MESSAGES (DO NOT CHANGE THESE!!!! They are used for the back-end code to recognize for parsing info out, not for player UI
    GRM_L["has been kicked"] = true
    GRM_L["joined the guild."] = true
    GRM_L["has promoted"] = true
    GRM_L["has demoted"] = true
    GRM_L["Professions"] = true
    GRM_L["Guild: "] = true
    GRM_L["Guild created "] = true
    GRM_L["added to friends"] = true
    GRM_L["is already your friend"] = true
    GRM_L["Player not found."] = true

    GRML.LoadLanguage[1]();
end







-- UI Helper to make my localization process much easier!!!
-- Disable when not using by commenting out.,..
-- GRM_LocalizationHelper = CreateFrame ( "Frame" , "GRM_LocalizationHelper" , UIParent , "TranslucentFrameTemplate" );
-- GRM_LocalizationHelper:SetPoint ( "CENTER" , UIParent );
-- GRM_LocalizationHelper:SetSize ( 400 , 200 );
-- GRM_LocalizationHelper:EnableMouse ( true );
-- GRM_LocalizationHelper:SetMovable ( true );
-- GRM_LocalizationHelper:RegisterForDrag ( "LeftButton" );
-- GRM_LocalizationHelper:SetScript ( "OnDragStart" , GRM_LocalizationHelper.StartMoving );
-- GRM_LocalizationHelper:SetScript ( "OnDragStop" , GRM_LocalizationHelper.StopMovingOrSizing );

-- GRM_LocalizationHelper.GRM_LocalizationHelperText = GRM_LocalizationHelper:CreateFontString ( "GRM_LocalizationHelper.GRM_LocalizationHelperText" , "OVERLAY" , "GameFontWhiteTiny" );
-- GRM_LocalizationHelper.GRM_LocalizationHelperText:SetPoint ( "CENTER" , GRM_LocalizationHelper , 0 , 25 );
-- GRM_LocalizationHelper.GRM_LocalizationHelperText:SetFont ( GRM_G.FontChoice , 12 );
-- GRM_LocalizationHelper.GRM_LocalizationHelperText:SetWordWrap ( true );
-- GRM_LocalizationHelper.GRM_LocalizationHelperText:SetWidth ( 375)
-- GRM_LocalizationHelper.GRM_LocalizationHelperText:SetText ( "Waiting for Chat Response" );

-- GRM_LocalizationHelper.GRM_LocalizationButton = CreateFrame ( "Button" , "GRM_LocalizationButton" , GRM_LocalizationHelper , "UIPanelButtonTemplate" );
-- GRM_LocalizationHelper.GRM_LocalizationButton:SetPoint ( "BOTTOM" , GRM_LocalizationHelper , 0 , 5 );
-- GRM_LocalizationHelper.GRM_LocalizationButton:SetSize ( 60 , 50 );
-- GRM_LocalizationHelper.GRM_LocalizationButton:SetText ( "Link" );
-- GRM_LocalizationHelper.GRM_LocalizationButton:SetScript ( "OnClick" , function( self , button )
--     if button == "LeftButton" then
--         ChatFrame1EditBox:SetFocus();
--         ChatFrame1EditBox:SetText ( GRM_LocalizationHelper.GRM_LocalizationHelperText:GetText() );
--     end
-- end);

-- local count = 0;
-- GRM_LocalizationHelper:RegisterEvent ( "CHAT_MSG_SYSTEM")
-- GRM_LocalizationHelper:SetScript ( "OnEvent" , function( self , event , msg )
--     if event == "CHAT_MSG_SYSTEM" then
--         count = count + 1;
--         -- if count == 2 then
--             GRM_LocalizationHelper.GRM_LocalizationHelperText:SetText ( msg );
--         -- end
--     end
-- end);

