--[[ =================================================================
    Revision:
    ================================================================= --]]

-- Track quest changes
    local function QuestChimes_OnEvent( self, event, ... )
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
                    completed = completed + ( finished or 0 );
                end;
                if ( completed == GetNumQuestLeaderBoards( QuestIndex ) ) then
                    PlaySound( "QUESTCOMPLETED" );
                else
                    PlaySound( "AuctionWindowOpen" );
                end;
            end;
            QuestIndex = nil;
        end;
    end;

-- Initial setup
    local QuestIndex;
    local QuestChimes = CreateFrame( "Frame", "QuestChimes", UIParent );
    QuestChimes:RegisterEvent( "QUEST_WATCH_UPDATE" );
    QuestChimes:RegisterEvent( "UNIT_QUEST_LOG_CHANGED" );
    QuestChimes:RegisterEvent( "QUEST_LOG_UPDATE" );
    QuestChimes:SetScript( "OnEvent", QuestChimes_OnEvent );