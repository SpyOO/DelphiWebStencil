object WM: TWM
  OnCreate = WebModuleCreate
  Actions = <
    item
      Default = True
      Name = 'DefaultHandler'
      PathInfo = '/'
    end
    item
      MethodType = mtPost
      Name = 'PostLogin'
      PathInfo = '/login'
      OnAction = WMPostLoginAction
    end
    item
      MethodType = mtPost
      Name = 'PostLogout'
      PathInfo = '/logout'
      OnAction = WMPostLogoutAction
    end>
  BeforeDispatch = WebModuleBeforeDispatch
  Height = 288
  Width = 519
  PixelsPerInch = 120
  object WebStencilsEngine: TWebStencilsEngine
    Dispatcher = WebFileDispatcher
    PathTemplates = <>
    Left = 112
    Top = 160
  end
  object WebFileDispatcher: TWebFileDispatcher
    WebFileExtensions = <
      item
        MimeType = 'text/css'
        Extensions = 'css'
      end
      item
        MimeType = 'text/html'
        Extensions = 'html;htm'
      end
      item
        MimeType = 'application/javascript'
        Extensions = 'js'
      end
      item
        MimeType = 'image/jpeg'
        Extensions = 'jpeg;jpg'
      end
      item
        MimeType = 'image/png'
        Extensions = 'png'
      end>
    WebDirectories = <
      item
        DirectoryAction = dirInclude
        DirectoryMask = '*'
      end
      item
        DirectoryAction = dirExclude
        DirectoryMask = '\templates\*'
      end>
    RootDirectory = './bin/html/'
    VirtualPath = '/'
    Left = 112
    Top = 72
  end
end
