unit WebModuleUnit;

interface

uses
  System.SysUtils, System.Classes, Web.HTTPApp, Web.Stencils, System.IOUtils;

type
  TWM = class(TWebModule)
    WebStencilsEngine: TWebStencilsEngine;
    WebFileDispatcher: TWebFileDispatcher;
    procedure WebModuleDefaultHandlerAction(Sender: TObject;
      Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
    procedure WebModuleCreate(Sender: TObject);
    procedure WMPostLoginAction(Sender: TObject; Request: TWebRequest;
      Response: TWebResponse; var Handled: Boolean);
    procedure WebModuleBeforeDispatch(Sender: TObject; Request: TWebRequest;
      Response: TWebResponse; var Handled: Boolean);
    procedure WMLogoutAction(Sender: TObject; Request: TWebRequest;
      Response: TWebResponse; var Handled: Boolean);
    procedure WMPostLogoutAction(Sender: TObject; Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
  private
    FResourcesPath: string;
    procedure DefineRoutes;
    procedure InitResourcesPath;
  public
    { Public declarations }
  end;

var
  WebModuleClass: TComponentClass = TWM;

implementation

{%CLASSGROUP 'System.Classes.TPersistent'}

{$R *.dfm}

procedure TWM.DefineRoutes;
begin
  WebStencilsEngine.PathTemplates.Add('/->/login.html');
  WebStencilsEngine.PathTemplates.Add('/{filename}');
end;

procedure TWM.InitResourcesPath;
var
  BinaryPath: string;
begin
  BinaryPath := TPath.GetDirectoryName(ParamStr(0));
{$IFDEF MSWINDOWS}
  FResourcesPath := TPath.Combine(BinaryPath, '');
{$ELSE}
  FResourcesPath := BinaryPath;
{$ENDIF}
  WebStencilsEngine.RootDirectory := TPath.Combine(FResourcesPath, 'html');
  WebFileDispatcher.RootDirectory := WebStencilsEngine.RootDirectory;
end;

procedure TWM.WebModuleDefaultHandlerAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
begin
  Response.StatusCode := 404;
  Response.Content := '<html><body><h1>404 - Ruta no encontrada</h1></body></html>';
  Handled := True;
end;

procedure TWM.WebModuleBeforeDispatch(Sender: TObject; Request: TWebRequest;
  Response: TWebResponse; var Handled: Boolean);
begin
  Response.ContentType := 'text/html; charset=utf-8';
end;

procedure TWM.WebModuleCreate(Sender: TObject);
begin
  inherited;
  InitResourcesPath;
  DefineRoutes;
  WebStencilsEngine.Dispatcher := WebFileDispatcher;
end;

procedure TWM.WMLogoutAction(Sender: TObject; Request: TWebRequest;
  Response: TWebResponse; var Handled: Boolean);
begin
  Handled := True;
  Response.SetCustomHeader('HX-Redirect', '/login.html');
end;

procedure TWM.WMPostLoginAction(Sender: TObject; Request: TWebRequest;
  Response: TWebResponse; var Handled: Boolean);
var
  LUsername, LPassword: string;
  LProcessor: TWebStencilsProcessor;
begin
  Handled := True;

  LUsername := Request.ContentFields.Values['username'];
  LPassword := Request.ContentFields.Values['password'];

  if SameText(LUsername, 'admin') and SameText(LPassword, '1234') then
  begin
    Response.SetCustomHeader('HX-Redirect', '/dashboard.html');
    Response.Content := 'Login exitoso. Redirigiendo...';
  end
  else
  begin
    LProcessor := TWebStencilsProcessor.Create(nil);
    try
      LProcessor.Engine := WebStencilsEngine;
      LProcessor.InputFileName := 'html/partials/login_error.html';
      Response.Content := LProcessor.Content;
    finally
      LProcessor.Free;
    end;
  end;
end;

procedure TWM.WMPostLogoutAction(Sender: TObject; Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
begin
  Handled := True;
  Response.SetCustomHeader('HX-Redirect', '/login.html');
end;

end.

