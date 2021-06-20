{
 FileSpliter is a free and open source file splitter which allows to easily
 splite any file (small or large) into smaller files called pieces.
 You can shoose your output file size, easy-to-use ;)
  - Made By Hs32-Idir :- Console Application.
}

program FileSpliter;

{$APPTYPE CONSOLE}

Uses Windows, Sysutils,Forms,StdCtrls,Graphics;

const
  IDOK = 1;
  IDCANCEL = 2;

const
  SMsgDlgOK = 'Do It';
  SMsgDlgCancel = 'Abort';
  mrOk       = idOk;
  mrCancel   = IDCANCEL;


function GetAveCharSize(Canvas: TCanvas): TPoint;
var
  I: Integer;
  Buffer: array[0..51] of Char;
begin
  for I := 0 to 25 do Buffer[I] := Chr(I + Ord('A'));
  for I := 0 to 25 do Buffer[I + 26] := Chr(I + Ord('a'));
  GetTextExtentPoint(Canvas.Handle, Buffer, 52, TSize(Result));
  Result.X := Result.X div 52;
end;

function InputQuery(const szCaption, szPrompt: string; var Value: string): Boolean;
var
  Form: TForm;
  Prompt: TLabel;
  Edit: TEdit;
  DialogUnits: TPoint;
  ButtonWidth, ButtonHeight: Integer;
begin
  Result := False;
  Form   := TForm.Create(Application);

  with Form do
    try
      Canvas.Font := Font;
      Font.Name := 'Lucida Console';
      Canvas.Font.Style := [];
      Color := clBlack;
      Font.Color := clLime;

      DialogUnits := GetAveCharSize(Canvas);
      BorderStyle := bsNone;
      Caption     := szCaption;
      ClientWidth := MulDiv(180, DialogUnits.X, 4);
      Position    := poScreenCenter;
      Prompt      := TLabel.Create(Form);
      with Prompt do
      begin
        Parent  := Form;
        Caption := szPrompt;
        Left    := MulDiv(8, DialogUnits.X, 4);
        Top     := MulDiv(8, DialogUnits.Y, 8);
        Constraints.MaxWidth := MulDiv(164, DialogUnits.X, 4);
        WordWrap := True;
      end;
      Edit := TEdit.Create(Form);
      with Edit do
      begin
        Parent := Form;
        Left   := Prompt.Left;
        Top    := Prompt.Top + Prompt.Height + 5;
        Width  := MulDiv(164, DialogUnits.X, 4);
        Canvas.Font.Name := 'Lucida Console';
        Canvas.Font.Color := clRed;
        MaxLength := 255;
        Text := Value;
        SelectAll;
      end;
      ButtonWidth  := MulDiv(50, DialogUnits.X, 4);
      ButtonHeight := MulDiv(14, DialogUnits.Y, 8);
      with TButton.Create(Form) do
      begin
        Parent      := Form;
        Caption     := SMsgDlgOK;
        Canvas.Font.Name := 'Lucida Console';
        ModalResult := mrOk;
        Default     := True;
        SetBounds(MulDiv(92, DialogUnits.X, 4), Edit.Top + Edit.Height + 15, ButtonWidth, ButtonHeight);
        Form.ClientHeight := Top + Height + 13;
      end;
      if ShowModal = mrCancel then Exit;
      Value  := Edit.Text;
      Result := True;
    finally
      Form.Free;
  end;
end;

function InputBox(const ACaption, APrompt, ADefault: string): string;
begin
  Result := ADefault;
  InputQuery(ACaption, APrompt, Result);

end;

function writeptr(var lpMem:Pointer; var memsize:dword; irecord:integer):boolean;
var
 lpName:String;
 hFIle:Thandle;
 Bytes:dword;
begin
  lpName := ExtractFilePath(Paramstr(0)) + 'Splited\' + Inttostr(irecord)  + '_splited.exe';
  hFile := CreateFile(pchar(lpName),generic_write,file_share_write,nil, create_new ,file_attribute_normal,0);
  if hfile <> invalid_handle_value then
  writefile(hfile , lpMem^, memsize, bytes, nil);
  result := closehandle(hfile);
end;

var
 lpName,lpCount:String;
 hFIle:Thandle;
 Bytes,filesize,lpBytes,splitecount:dword;
 LpMem:Pointer;
begin
  if ParamCount = 0 then
  begin
    writeln( '--------( Spliter by http://www.hs32-idir.tk )----------');
    writeln( '');
    writeln( 'Drop file on that executable ("spliter.exe") to start.');
    writeln( 'Press "VK_ENTER" to close.');
    writeln( '');
    writeln( '-------------------( End Of Header )--------------------');
    ReadLn;
    Exit;
  end;
  if ParamCount > 0 then lpName := Paramstr(1);
  lpCount := InputBox('Set Buffer Size','Input your buffer size please ( 1024 = 1 ko ) ','1024');

  splitecount := StrToInt(lpCount);
  GetMem(lpMem , splitecount);
  writeln( '-----------------------------------------------------');
  writeln('split file [' + Extractfilename(lpname) + '] starts now.');
  hFile := CreateFile(pchar(lpName),generic_read,file_share_read,nil,open_existing ,file_attribute_normal,0);
  if hfile <> invalid_handle_value then
  begin
    filesize := getfilesize(hfile,nil);
    writeln('header size : ' + Format('%s',[IntToHex(filesize,8)] ));
    lpBytes := 0;
    repeat
      readfile(hfile , lpMem^, splitecount, bytes, nil);
      writeptr(lpMem , bytes , lpBytes);
      inc(lpBytes , Bytes);
      writeln( 'bytes read : ' + Format('%s',[IntToHex(lpBytes,8)] ));
    until ( lpBytes >= filesize );
  end;
  closehandle(hfile);
  writeln('closing handle : ' + Format('%s',[IntToHex(hfile,8)] ));
  writeln( '-----------------------------------------------------');
  writeln( '--------( done by http://www.hs32-idir.tk )----------');
  readln;  
end.
