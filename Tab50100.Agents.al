table 50100 Agents
{
    DataClassification = CustomerContent;
    Caption = 'Agents';

    fields
    {
        field(1; "Agent No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Agent No.';
        }
        field(2; "Agent Name"; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Agent Name';
        }
        field(3; "Agent Venue"; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Agent Venue';
        }
    }

    keys
    {
        key(PK; "Agent No.")
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}