class CoinPackageModel {
  final String id;
  final String nome;
  final int moedas;
  final int bonusMoedas;
  final double precoReais;
  final bool popular;
  final double custoPorMoeda;

  CoinPackageModel({
    required this.id,
    required this.nome,
    required this.moedas,
    required this.bonusMoedas,
    required this.precoReais,
    this.popular = false,
    required this.custoPorMoeda,
  });

  int get totalMoedas => moedas + bonusMoedas;
}

class CoinTransactionModel {
  final String id;
  final String data;
  final String tipo; // recarga, desbloqueio_lead, reembolso_garantia, bonus_cadastro
  final int quantidadeMoedas;
  final String? solicitacaoId;
  final String descricao;
  final int saldoApos;

  CoinTransactionModel({
    required this.id,
    required this.data,
    required this.tipo,
    required this.quantidadeMoedas,
    this.solicitacaoId,
    required this.descricao,
    required this.saldoApos,
  });
}

class UnlockedLeadModel {
  final String solicitacaoId;
  final String dataDesbloqueio;
  final int moedasGastas;
  final String clienteNome;
  final String clienteTelefone;
  final String clienteWhatsapp;
  final String clienteEmail;
  final String enderecoCompleto;
  final String statusContato;
  final bool podeSolicitarReembolso;

  UnlockedLeadModel({
    required this.solicitacaoId,
    required this.dataDesbloqueio,
    required this.moedasGastas,
    required this.clienteNome,
    required this.clienteTelefone,
    required this.clienteWhatsapp,
    required this.clienteEmail,
    required this.enderecoCompleto,
    this.statusContato = 'contatado',
    this.podeSolicitarReembolso = true,
  });
}

class JobPostingModel {
  final String vagaId;
  final String titulo;
  final String empresaNome;
  final String categoria;
  final String tipoContrato; // pj, freelancer_fixo, clt_especialista, associado
  final String remuneracaoEstimada;
  final String cidade;
  final String estado;
  final String modalidade;
  final String descricaoAtividades;
  final List<String> requisitos;
  final List<String> beneficios;
  final String dataPublicacao;
  int totalCandidatos;

  JobPostingModel({
    required this.vagaId,
    required this.titulo,
    required this.empresaNome,
    required this.categoria,
    required this.tipoContrato,
    required this.remuneracaoEstimada,
    required this.cidade,
    required this.estado,
    required this.modalidade,
    required this.descricaoAtividades,
    required this.requisitos,
    required this.beneficios,
    required this.dataPublicacao,
    required this.totalCandidatos,
  });

  String get contractLabel {
    switch (tipoContrato) {
      case 'pj':
        return 'Contrato PJ';
      case 'freelancer_fixo':
        return 'Freelancer Fixo';
      case 'associado':
        return 'Sócio / Associado';
      case 'clt_especialista':
        return 'CLT Especialista';
      default:
        return tipoContrato;
    }
  }
}

class ProposalStepModel {
  final String titulo;
  final int prazoDias;
  final double valorProporcional;

  ProposalStepModel({
    required this.titulo,
    required this.prazoDias,
    required this.valorProporcional,
  });
}

class ProposalModel {
  final String propostaId;
  final String solicitacaoId;
  final String profissionalId;
  final String profissionalNome;
  final double valorHonorarios;
  final double despesasAdicionais;
  final double custosTerceiros;
  final double valorTotal;
  final String descricaoTrabalho;
  final List<ProposalStepModel> etapas;
  final int prazoDias;
  final String condicoesPagamento;
  final List<String> documentosNecessarios;
  final String dataEnvio;
  String status; // enviada, em_negociacao, aceita, recusada

  ProposalModel({
    required this.propostaId,
    required this.solicitacaoId,
    required this.profissionalId,
    required this.profissionalNome,
    required this.valorHonorarios,
    required this.despesasAdicionais,
    required this.custosTerceiros,
    required this.valorTotal,
    required this.descricaoTrabalho,
    required this.etapas,
    required this.prazoDias,
    required this.condicoesPagamento,
    required this.documentosNecessarios,
    required this.dataEnvio,
    required this.status,
  });
}

class VaultDocumentModel {
  final String documentoId;
  final String titulo;
  final String tipo;
  final String nomeArquivo;
  final int tamanhoKb;
  final String dataUpload;
  String statusVerificacao; // aprovado, em_analise, rejeitado
  final String hashIntegridade;

  VaultDocumentModel({
    required this.documentoId,
    required this.titulo,
    required this.tipo,
    required this.nomeArquivo,
    required this.tamanhoKb,
    required this.dataUpload,
    required this.statusVerificacao,
    required this.hashIntegridade,
  });
}

class ChatMessageModel {
  final String mensagemId;
  final String ordemServicoId;
  final String remetenteNome;
  final String remetentePapel; // profissional | cliente
  final String conteudo;
  final String dataEnvio;
  final String? anexoNome;

  ChatMessageModel({
    required this.mensagemId,
    required this.ordemServicoId,
    required this.remetenteNome,
    required this.remetentePapel,
    required this.conteudo,
    required this.dataEnvio,
    this.anexoNome,
  });
}

class FinancialTransactionModel {
  final String pagamentoId;
  final String ordemServicoId;
  final String metodo;
  final double valorBruto;
  final double taxaIntermediacao;
  final double valorLiquido;
  final String statusMercadoPago;
  final String dataCriacao;
  final String idempotencyKey;

  FinancialTransactionModel({
    required this.pagamentoId,
    required this.ordemServicoId,
    required this.metodo,
    required this.valorBruto,
    required this.taxaIntermediacao,
    required this.valorLiquido,
    required this.statusMercadoPago,
    required this.dataCriacao,
    required this.idempotencyKey,
  });
}

class SubscriptionPlanModel {
  final String id;
  final String nome;
  final String publicoAlvo;
  final double precoMensal;
  final double taxaComissaoPercentual;
  final List<String> recursos;
  final bool destaque;

  SubscriptionPlanModel({
    required this.id,
    required this.nome,
    required this.publicoAlvo,
    required this.precoMensal,
    required this.taxaComissaoPercentual,
    required this.recursos,
    this.destaque = false,
  });
}

class RecoveryCaseModel {
  final String casoEmpresarialId;
  final String empresaRazaoSocial;
  final String empresaCnpj;
  final String cidade;
  final String estado;
  final double faturamentoAnualEstimado;
  final double passivoTotal;
  final String dataDiagnostico;
  final String statusRecuperacao;
  final List<String> areasAfetadas;
  final List<String> solicitacoesGeradas;

  RecoveryCaseModel({
    required this.casoEmpresarialId,
    required this.empresaRazaoSocial,
    required this.empresaCnpj,
    required this.cidade,
    required this.estado,
    required this.faturamentoAnualEstimado,
    required this.passivoTotal,
    required this.dataDiagnostico,
    required this.statusRecuperacao,
    required this.areasAfetadas,
    required this.solicitacoesGeradas,
  });
}
