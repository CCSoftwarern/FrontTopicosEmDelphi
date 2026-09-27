unit UnitDmBase;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  REST.Types, REST.Response.Adapter, REST.Client, Data.Bind.Components,
  Data.Bind.ObjectScope;

type
  TdmBase = class(TDataModule)
    RESTClientCategorias: TRESTClient;
    RESTRequestCategorias: TRESTRequest;
    RESTResponseCategorias: TRESTResponse;
    RESTResponseDataSetAdapterCategorias: TRESTResponseDataSetAdapter;
    TabCategorias: TFDMemTable;
    DataSourceCategorias: TDataSource;
    RESTClientCategoriasDelete: TRESTClient;
    RESTRequestCategoriasDelete: TRESTRequest;
    RESTResponseCategoriasDelete: TRESTResponse;
    RESTClientCategoriasPost: TRESTClient;
    RESTRequestCategoriasPost: TRESTRequest;
    RESTResponseCategoriasPost: TRESTResponse;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dmBase: TdmBase;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

end.
