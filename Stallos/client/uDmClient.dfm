object DMClient: TDMClient
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 195
  Width = 290
  object RESTClient: TRESTClient
    Params = <>
    Left = 24
    Top = 32
  end
  object RESTRequest: TRESTRequest
    Client = RESTClient
    Params = <>
    Response = RESTResponse
    SynchronizedEvents = False
    Left = 24
    Top = 96
  end
  object RESTResponse: TRESTResponse
    Left = 104
    Top = 32
  end
  object DSPessoas: TFDMemTable
    FieldDefs = <>
    IndexDefs = <>
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    StoreDefs = True
    Left = 200
    Top = 96
    object DSPessoasidpessoa: TIntegerField
      FieldName = 'idpessoa'
    end
    object DSPessoasdsdocumento: TStringField
      FieldName = 'dsdocumento'
    end
    object DSPessoasnmprimeiro: TStringField
      FieldName = 'nmprimeiro'
    end
    object DSPessoasnmsegundo: TStringField
      FieldName = 'nmsegundo'
    end
  end
  object DSEndereco: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 200
    Top = 40
    object DSEnderecodsuf: TStringField
      FieldName = 'dsuf'
    end
    object DSEnderecodscep: TStringField
      FieldName = 'dscep'
    end
    object DSEndereconmcidade: TStringField
      FieldName = 'nmcidade'
    end
    object DSEndereconmbairro: TStringField
      FieldName = 'nmbairro'
    end
    object DSEndereconmlogradouro: TStringField
      FieldName = 'nmlogradouro'
    end
    object DSEnderecodscomplemento: TStringField
      FieldName = 'dscomplemento'
    end
  end
end
