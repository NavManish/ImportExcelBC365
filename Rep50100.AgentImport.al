report 50100 AgentImport
{
    UsageCategory = Administration;
    ApplicationArea = All;
    Caption = 'Agent Import';
    ProcessingOnly = true;

    dataset
    {
        dataitem(Integer; Integer)
        {
            DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));
            trigger OnPreDataItem()
            begin
                //Reading Excel File
                ReadExcelBook();
            end;

            trigger OnAfterGetRecord()
            begin
                ExcelBuf.SetFilter("Row No.", '>%1', ExcelRowstoSkip);
                if ExcelBuf.FindSet() then
                    repeat
                        if RowNo <> ExcelBuf."Row No." then
                            if ExcelBuf."Row No." > (ExcelRowstoSkip + 1) then
                                ProcessData();
                        RowNo := ExcelBuf."Row No.";

                        case ExcelBuf."Column No." of
                            1:
                                AgentNoVar := copystr(ExcelBuf."Cell Value as Text", 1, 20);
                            2:
                                AgentNameVar := copystr(ExcelBuf."Cell Value as Text", 1, 50);
                            3:
                                AgentVenueVar := copystr(ExcelBuf."Cell Value as Text", 1, 50);
                        end;
                    until ExcelBuf.Next() = 0;
                ProcessData();
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                    field(FileName; ExcelFileName)
                    {
                        ApplicationArea = All;
                        Caption = 'Select File Name';
                        trigger OnAssistEdit()
                        begin
                            Clear(ExcelFileName);
                            if UploadIntoStream('Upload Excel File', 'C:\TEMP', 'All Files (*.*)|*.*', ExcelFileName, exInstream) THEN
                                ExcelBuf.Reset();
                        end;
                    }
                    field(SheetName; ExcelSheetName)
                    {
                        ApplicationArea = All;
                        Caption = 'Select Sheet Name';
                        trigger OnAssistEdit()
                        begin
                            if ExcelFileName = '' then
                                Error('First select Excel file');

                            Clear(ExcelSheetName);
                            ExcelSheetName := ExcelBuf.SelectSheetsNameStream(exInstream);

                        end;
                    }
                    field(RowstoSkip; ExcelRowstoSkip)
                    {
                        ApplicationArea = All;
                        Caption = 'Row to Skip';
                        MinValue = 1;
                    }
                }
            }
        }

        // actions
        // {
        //     area(processing)
        //     {
        //         action(ActionName)
        //         {
        //             ApplicationArea = All;

        //         }
        //     }
        // }

    }

    var
        ExcelBuf: Record "Excel Buffer" temporary;
        AgentRec: Record Agents;
        ExcelRowstoSkip: Integer;
        RowNo: Integer;
        AgentNoVar: code[20];
        AgentNameVar: Text[50];
        AgentVenueVar: Text[50];
        ExcelFileName: Text;
        ExcelSheetName: Text;
        exInstream: InStream;

    trigger OnInitReport();
    begin
        ExcelRowstoSkip := 1;
    end;

    trigger OnPreReport();
    begin
        ExcelBuf.DeleteAll();
        if (ExcelFileName = '') or (ExcelSheetName = '') then
            Error('Either the Filename or the sheetname not selected');
        ExcelBuf.Reset();
    end;

    trigger OnPostReport();
    begin
        Message('Imported');
    end;

    local procedure ReadExcelBook()
    begin
        ExcelBuf.OpenBookStream(exInstream, ExcelSheetName);
        ExcelBuf.ReadSheet();
    end;

    local procedure ClearVar()
    begin
        Clear(AgentNoVar);
        Clear(AgentNameVar);
        Clear(AgentVenueVar);
    end;

    local procedure ProcessData()
    begin
        if AgentRec.get(AgentNoVar) then begin
            AgentRec."Agent Name" := AgentNameVar;
            AgentRec."Agent Venue" := AgentVenueVar;
            AgentRec.Modify();
        end else begin
            AgentRec.Init();
            AgentRec."Agent No." := AgentNoVar;
            AgentRec."Agent Name" := AgentNameVar;
            AgentRec."Agent Venue" := AgentVenueVar;
            AgentRec.Insert();
        end;
        ClearVar();

    end;
}