unit Model.messages;

interface

uses
  System.SysUtils,
  System.Classes; // Necesario para TPersistent si quieres que sea persistente, aunque no es estrictamente necesario aquí si solo lo pasas a la vista.

type
  // Hereda de TObject o TPersistent si quieres capacidades de streaming
  TMessageModel = class(TObject)
  private
    FError: string;
    FSuccess: string;
  public
    // Constructor para facilitar la inicialización
    constructor Create(const AError: string = ''; const ASuccess: string = '');
    destructor Destroy; override;

    // Propiedades para acceder desde la plantilla
    property Error: string read FError write FError;
    property Success: string read FSuccess write FSuccess;
  end;

implementation

{ TMessageModel }

constructor TMessageModel.Create(const AError: string; const ASuccess: string);
begin
  inherited Create;
  FError := AError;
  FSuccess := ASuccess;
end;

destructor TMessageModel.Destroy;
begin
  // No hay objetos internos que liberar aquí, pero es buena práctica mantenerlo
  inherited Destroy;
end;

end.
