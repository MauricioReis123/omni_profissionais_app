class ServiceOrderMilestone {
  final String id;
  final String titulo;
  bool concluida;
  String? dataConclusao;

  ServiceOrderMilestone({
    required this.id,
    required this.titulo,
    this.concluida = false,
    this.dataConclusao,
  });
}

class ServiceOrderDeliverable {
  final String id;
  final String titulo;
  final String arquivoNome;
  final int tamanhoKb;
  final String dataUpload;
  final String status;

  ServiceOrderDeliverable({
    required this.id,
    required this.titulo,
    required this.arquivoNome,
    required this.tamanhoKb,
    required this.dataUpload,
    required this.status,
  });
}

class ServiceOrderTimelineEvent {
  final String data;
  final String evento;
  final String usuario;

  ServiceOrderTimelineEvent({
    required this.data,
    required this.evento,
    required this.usuario,
  });
}

class ServiceOrderModel {
  final String ordemServicoId;
  final String solicitacaoId;
  final String? casoEmpresarialId;
  final String? propostaId;
  final String clienteNome;
  final String profissionalNome;
  final String categoria;
  final String tituloServico;
  final double valorContratado;
  final double taxaPlataforma;
  final double valorLiquido;
  String status;
  final String dataContratacao;
  final String prazoFinal;
  final List<ServiceOrderMilestone> etapas;
  final List<ServiceOrderDeliverable> entregaveis;
  final List<ServiceOrderTimelineEvent> linhaTempo;

  ServiceOrderModel({
    required this.ordemServicoId,
    required this.solicitacaoId,
    this.casoEmpresarialId,
    this.propostaId,
    required this.clienteNome,
    required this.profissionalNome,
    this.categoria = 'juridico',
    required this.tituloServico,
    required this.valorContratado,
    required this.taxaPlataforma,
    required this.valorLiquido,
    required this.status,
    required this.dataContratacao,
    required this.prazoFinal,
    required this.etapas,
    required this.entregaveis,
    required this.linhaTempo,
  });

  static const Map<String, String> allStatusesLabels = {
    'solicitacao_recebida': 'Solicitação Recebida',
    'aguardando_distribuicao': 'Aguardando Distribuição',
    'profissionais_convidados': 'Profissionais Convidados',
    'aguardando_propostas': 'Aguardando Propostas',
    'propostas_recebidas': 'Propostas Recebidas',
    'em_negociacao': 'Em Negociação',
    'aguardando_aprovacao_cliente': 'Aguardando Aprovação',
    'aguardando_contratacao': 'Aguardando Contratação',
    'aguardando_pagamento': 'Aguardando Pagamento',
    'contratada': 'Contratada',
    'aguardando_inicio': 'Aguardando Início',
    'em_execucao': 'Em Execução',
    'aguardando_documentos': 'Aguardando Documentos',
    'aguardando_aprovacao': 'Aguardando Aprovação de Entrega',
    'em_revisao': 'Em Revisão',
    'concluida': 'Concluída & Homologada',
    'cancelada': 'Cancelada',
    'suspensa': 'Suspensa',
    'em_disputa': 'Em Disputa / Mediação',
    'arquivada': 'Arquivada',
  };

  String get statusLabel => allStatusesLabels[status] ?? status;

  factory ServiceOrderModel.fromJson(Map<String, dynamic> json) {
    return ServiceOrderModel(
      ordemServicoId: json['ordem_servico_id'] ?? '',
      solicitacaoId: json['solicitacao_id'] ?? '',
      casoEmpresarialId: json['caso_empresarial_id'],
      propostaId: json['proposta_id'],
      clienteNome: json['cliente_nome'] ?? 'Cliente',
      profissionalNome: json['profissional_nome'] ?? 'Profissional',
      categoria: json['categoria'] ?? 'juridico',
      tituloServico: json['titulo_servico'] ?? '',
      valorContratado:
          double.tryParse(json['valor_contratado']?.toString() ?? '0') ?? 0,
      taxaPlataforma:
          double.tryParse(json['valor_taxa_plataforma']?.toString() ?? '0') ??
              0,
      valorLiquido: double.tryParse(
              json['valor_liquido_profissional']?.toString() ?? '0') ??
          0,
      status: json['status'] ?? 'contratada',
      dataContratacao: json['data_contratacao'] ?? '',
      prazoFinal: json['prazo_final'] ?? '',
      etapas: [],
      entregaveis: [],
      linhaTempo: [],
    );
  }
}
