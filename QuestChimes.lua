-- Track quest changes
    local function QuestChimes_OnEvent( self, event, ... )
        -- Load data from previous session
        local arg1 = ...;
        if ( event == "ADDON_LOADED" and arg1 == "QuestChimes" ) then
            if ( QC_SETTINGS == nil ) then
                QC_SETTINGS = {};
                QC_SETTINGS["COMPLETION_SOUND"] = "QUESTCOMPLETED"; -- RaidWarning
                QC_SETTINGS["PROGRESSION_SOUND"] = "AuctionWindowOpen";
            end;
        end;

        -- Get the quest that was updated
        if ( event == "QUEST_WATCH_UPDATE" ) then
            QuestIndex = ...;
        end;

        -- Get the state of the quest (Objective updated or quest completed)
        if ( event == "UNIT_QUEST_LOG_CHANGED" or event == "QUEST_LOG_UPDATE" ) then
            if ( QuestIndex ) then
                local text, type, finished, completed = nil, nil, nil, 0;
                for objective = 1, GetNumQuestLeaderBoards( QuestIndex ) do
                    text, type, finished = GetQuestLogLeaderBoard( objective, QuestIndex );
                    completed = completed + ( finished and 1 or 0 );
                end;
                if ( completed == GetNumQuestLeaderBoards( QuestIndex ) ) then
                    PlaySound( QC_SETTINGS["COMPLETION_SOUND"] );
                else
                    PlaySound( QC_SETTINGS["PROGRESSION_SOUND"] );
                end;
            end;
            QuestIndex = nil;
        end;
    end;

-- Initial setup
    local QuestIndex;
    local QuestChimes = CreateFrame( "Frame", "QuestChimes", UIParent );
    QuestChimes:RegisterEvent( "ADDON_LOADED" );
    QuestChimes:RegisterEvent( "QUEST_WATCH_UPDATE" );
    QuestChimes:RegisterEvent( "UNIT_QUEST_LOG_CHANGED" );
    QuestChimes:RegisterEvent( "QUEST_LOG_UPDATE" );
    QuestChimes:SetScript( "OnEvent", QuestChimes_OnEvent );
