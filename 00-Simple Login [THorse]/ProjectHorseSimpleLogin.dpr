program Project1;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  System.IOUtils,
  Horse,
  Horse.Jhonson,
  Web.Stencils;

var
  StencilEngine: TWebStencilsEngine;
  ResourcesPath: string;

procedure InitStencilEngine;
begin
  StencilEngine := TWebStencilsEngine.Create(nil);
  StencilEngine.RootDirectory := ResourcesPath;
  StencilEngine.PathTemplates.Add('/->/login.html');
  StencilEngine.PathTemplates.Add('/{filename}');
end;

procedure RegisterRoutes;
begin
  // Login POST
  THorse.Post('/login',
    procedure(Req: THorseRequest; Res: THorseResponse)
    var
      Username, Password: string;
      Processor: TWebStencilsProcessor;
    begin
      writeln(Req.Body);
      Username := Req.ContentFields.Field('username').AsString;// Body<string>('username');
      Password := Req.ContentFields.Field('password').AsString;

      if SameText(Username, 'admin') and SameText(Password, '1234') then
      begin
        Res.AddHeader('HX-Redirect', '/dashboard.html').Send('Login exitoso. Redirigiendo...');
      end
      else
      begin
        Processor := TWebStencilsProcessor.Create(nil);
        try
          Processor.Engine := StencilEngine;
          Processor.InputFileName := 'html/partials/login_error.html';
          Res.Send(Processor.Content);
        finally
          Processor.Free;
        end;
      end;
    end
  );

  // Logout
  THorse.Post('/logout',
    procedure(Req: THorseRequest; Res: THorseResponse)
    begin
      Res.AddHeader('HX-Redirect', '/login.html')
         .Send('');
    end
  );


  THorse.Get('/dashboard.html',
    procedure(Req: THorseRequest; Res: THorseResponse)
    var
      Processor: TWebStencilsProcessor;
    begin
      Processor := TWebStencilsProcessor.Create(nil);
      try
        Processor.Engine := StencilEngine;
        Processor.InputFileName := 'html/dashboard.html';
       // Processor.Variables.Values['username'] := 'Peter';
        Res.Send(Processor.Content);
      finally
        Processor.Free;
      end;
    end
  );

  // Servir archivos estáticos como *.html
THorse.Get('/:file',
  procedure(Req: THorseRequest; Res: THorseResponse)
  var
    FileName, FullPath: string;
    Processor: TWebStencilsProcessor;
  begin
    FileName := Req.Params['file'];
    FullPath := TPath.Combine(ResourcesPath, FileName);

    if not TFile.Exists(FullPath) then
    begin
      Res.Status(404).Send('<h1>404 - Ruta no encontrada</h1>');
      Exit;
    end;

    if TPath.GetExtension(FullPath).ToLower = '.html' then
    begin
      Processor := TWebStencilsProcessor.Create(nil);
      try
        Processor.Engine := StencilEngine;
        Processor.InputFileName := FullPath;
        Res.Send(Processor.Content);
      finally
        Processor.Free;
      end;
    end
    else
    begin
      // Archivos no HTML como .js, .css, .png, etc.
      Res.SendFile(FullPath);
    end;
  end
);
end;


begin
  try
    ReportMemoryLeaksOnShutdown := True;

    // Iniciar THorse y middlewares
    THorse.Use(Jhonson);

    // Ruta a la carpeta de vistas HTML
    ResourcesPath := TPath.Combine(TPath.GetDirectoryName(ParamStr(0)), 'html');

    // Inicializar Stencil
    InitStencilEngine;

    // Registrar rutas
    RegisterRoutes;

    // Levantar servidor
    Writeln('Servidor  en http://localhost:8080');
    THorse.Listen(8080);

  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.

