class OpportunityModel {
  final String solicitacaoId;
  final String? casoEmpresarialId;
  final String origemSolicitacao;
  final String categoria;
  final String subcategoria;
  final String especialidade;
  final String titulo;
  final String descricaoResumida;
  final String cidade;
  final String estado;
  final String modalidade;
  final String urgencia;
  final int prazoEstimadoDias;
  final double orcamentoMin;
  final double orcamentoMax;
  final int compatibilidadeScore;
  final String dataPublicacao;
  final String prazoManifestacao;
  final String status;
  final List<String> documentosExigidos;
  final String clienteNomeAnonimizado;
  final String clienteId;
  final bool liberacaoFinanceira;

  // Campos estilo GetNinjas (Moedas & Desbloqueio de Lead)
  final int custoMoedas;
  final int maxProfissionaisPermitidos;
  int profissionaisJaDesbloquearam;
  final String? clienteTelefoneReal;
  final String? clienteWhatsappReal;
  final String? clienteEmailReal;
  final String? clienteEnderecoReal;
  final String? quandoPrecisa;

  OpportunityModel({
    required this.solicitacaoId,
    this.casoEmpresarialId,
    required this.origemSolicitacao,
    required this.categoria,
    required this.subcategoria,
    required this.especialidade,
    required this.titulo,
    required this.descricaoResumida,
    required this.cidade,
    required this.estado,
    required this.modalidade,
    required this.urgencia,
    required this.prazoEstimadoDias,
    required this.orcamentoMin,
    required this.orcamentoMax,
    required this.compatibilidadeScore,
    required this.dataPublicacao,
    this.prazoManifestacao = '2026-11-20',
    this.status = 'aberta',
    required this.documentosExigidos,
    this.clienteNomeAnonimizado = 'Empresa Solicitante',
    this.clienteId = 'CLI-000',
    required this.liberacaoFinanceira,
    this.custoMoedas = 35,
    this.maxProfissionaisPermitidos = 4,
    this.profissionaisJaDesbloquearam = 0,
    this.clienteTelefoneReal,
    this.clienteWhatsappReal,
    this.clienteEmailReal,
    this.clienteEnderecoReal,
    this.quandoPrecisa,
  });

  bool get isOmniRecovery =>
      origemSolicitacao == 'omni_recuperacao_empresarial';

  int get vagasRestantes =>
      (maxProfissionaisPermitidos - profissionaisJaDesbloquearam)
          .clamp(0, maxProfissionaisPermitidos);

  factory OpportunityModel.fromJson(Map<String, dynamic> json) {
    return OpportunityModel(
      solicitacaoId: json['solicitacao_id'] ?? '',
      casoEmpresarialId: json['caso_empresarial_id'],
      origemSolicitacao: json['origem_solicitacao'] ?? 'marketplace_publico',
      categoria: json['categoria'] ?? '',
      subcategoria: json['subcategoria'] ?? '',
      especialidade: json['especialidade'] ?? '',
      titulo: json['titulo'] ?? '',
      descricaoResumida: json['descricao_resumida'] ?? '',
      cidade: json['cidade'] ?? '',
      estado: json['estado'] ?? '',
      modalidade: json['modalidade'] ?? 'remoto',
      urgencia: json['urgencia'] ?? 'media',
      prazoEstimadoDias:
          int.tryParse(json['prazo_estimado_dias']?.toString() ?? '30') ?? 30,
      orcamentoMin:
          double.tryParse(json['orcamento_minimo']?.toString() ?? '0') ?? 0,
      orcamentoMax:
          double.tryParse(json['orcamento_maximo']?.toString() ?? '0') ?? 0,
      compatibilidadeScore:
          int.tryParse(json['compatibilidade_score']?.toString() ?? '90') ?? 90,
      dataPublicacao: json['data_publicacao'] ?? '',
      prazoManifestacao: json['prazo_manifestacao'] ?? '2026-11-20',
      status: json['status'] ?? 'aberta',
      documentosExigidos: (json['documentos_exigidos'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      clienteNomeAnonimizado:
          json['cliente_nome_anonimizado'] ?? 'Empresa Solicitante',
      clienteId: json['cliente_id'] ?? 'CLI-000',
      liberacaoFinanceira: json['liberacao_financeira'] == 1 ||
          json['liberacao_financeira'] == true,
      custoMoedas:
          int.tryParse(json['custo_moedas']?.toString() ?? '35') ?? 35,
      maxProfissionaisPermitidos: int.tryParse(
              json['max_profissionais_permitidos']?.toString() ?? '4') ??
          4,
      profissionaisJaDesbloquearam: int.tryParse(
              json['profissionais_ja_desbloquearam']?.toString() ?? '0') ??
          0,
      clienteTelefoneReal: json['cliente_telefone_real'],
      clienteWhatsappReal: json['cliente_whatsapp_real'],
      clienteEmailReal: json['cliente_email_real'],
      clienteEnderecoReal: json['cliente_endereco_real'],
      quandoPrecisa: json['quando_precisa'],
    );
  }
}
