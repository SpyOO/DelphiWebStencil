object DM: TDM
  Height = 319
  Width = 400
  PixelsPerInch = 120
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
    Left = 200
    Top = 56
  end
  object WebStencilsEngine: TWebStencilsEngine
    Dispatcher = WebFileDispatcher
    PathTemplates = <>
    Left = 200
    Top = 144
  end
end
