page 50100 Agents
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = Agents;
    Caption = 'Agents';

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Agent No."; "Agent No.")
                {
                    ApplicationArea = All;
                }
                field("Agent Name"; "Agent Name")
                {
                    ApplicationArea = All;
                }
                field("Agent Venue"; "Agent Venue")
                {
                    ApplicationArea = All;
                }
            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            // action(ActionName)
            // {
            //     ApplicationArea = All;

            //     trigger OnAction();
            //     begin

            //     end;
            // }
        }
    }
}