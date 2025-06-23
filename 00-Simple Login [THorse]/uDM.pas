unit uDM;

interface

uses
  System.SysUtils, System.Classes, Web.Stencils, Web.HTTPApp;

type
  TDM = class(TDataModule)
    WebFileDispatcher: TWebFileDispatcher;
    WebStencilsEngine: TWebStencilsEngine;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DM: TDM;

implementation

{%CLASSGROUP 'System.Classes.TPersistent'}

{$R *.dfm}

end.
