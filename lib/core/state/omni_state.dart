import 'package:flutter/material.dart';
import '../../models/opportunity_model.dart';
import '../../models/service_order_model.dart';
import '../../models/omni_models.dart';

class AdminCategoryItem {
  final String nome;
  final String slug;
  final int especialidades;
  final String status;

  AdminCategoryItem({
    required this.nome,
    required this.slug,
    required this.especialidades,
    this.status = 'Ativo',
  });
}

class OmniAppState extends ChangeNotifier {
  String currentTab = 'dashboard';
  String currentRole = 'profissional';
  double commissionRate = 10.0;
  String activeChatOrderId = 'OS-OMNI-2026-0041';
  String selectedPlanId = 'plano-profissional';
  String verificationStatus = 'aprovado';

  int saldoMoedas = 280;
  int moedasEmGarantia = 45;

  final List<String> appliedJobIds = [];
  final List<String> notifications = [
    'Novo caso OMNI-CASO-2026-0891 despachado com 3 demandas abertas.',
    'Proposta PROP-2026-109 em negociação aguardando retorno.',
    'Laudo da OS-OMNI-2026-0038 anexado para homologação.',
  ];

  final List<AdminCategoryItem> catalogCategories = [
    AdminCategoryItem(nome: 'Serviços Jurídicos', slug: 'juridico', especialidades: 16),
    AdminCategoryItem(nome: 'Serviços Contábeis e Tributários', slug: 'contabil_tributario', especialidades: 12),
    AdminCategoryItem(nome: 'Administração e Gestão Empresarial', slug: 'administracao_gestao', especialidades: 11),
    AdminCategoryItem(nome: 'Serviços Financeiros', slug: 'financeiro', especialidades: 8),
    AdminCategoryItem(nome: 'Documentação e Regularização', slug: 'documentacao_regularizacao', especialidades: 10),
    AdminCategoryItem(nome: 'Serviços Cartorários e Notariais', slug: 'cartorario_notarial', especialidades: 9),
    AdminCategoryItem(nome: 'Engenharia, Arquitetura e Avaliação', slug: 'engenharia_arquitetura', especialidades: 10),
    AdminCategoryItem(nome: 'Tecnologia e Sistemas', slug: 'tecnologia_sistemas', especialidades: 9),
    AdminCategoryItem(nome: 'Serviços Empresariais Diversos', slug: 'servicos_empresariais', especialidades: 14),
  ];

  final Map<String, UnlockedLeadModel> unlockedLeads = {
    'SOL-MKT-4410': UnlockedLeadModel(
      solicitacaoId: 'SOL-MKT-4410',
      dataDesbloqueio: '2026-11-08 16:15',
      moedasGastas: 35,
      clienteNome: 'Eng. Marcelo Queiroz (LogPrime Empreendimentos)',
      clienteTelefone: '(11) 4588-3310',
      clienteWhatsapp: '5511985883310',
      clienteEmail: 'engenharia@logprime.com.br',
      enderecoCompleto:
          'Rodovia Anhanguera, Km 62 - Distrito Industrial, Jundiaí/SP',
      statusContato: 'contatado',
      podeSolicitarReembolso: true,
    ),
  };

  final List<CoinPackageModel> coinPackages = [
    CoinPackageModel(
      id: 'pack-iniciante',
      nome: 'Pacote Básico Start',
      moedas: 120,
      bonusMoedas: 0,
      precoReais: 99.0,
      custoPorMoeda: 0.825,
    ),
    CoinPackageModel(
      id: 'pack-profissional',
      nome: 'Pacote Profissional Ninja',
      moedas: 350,
      bonusMoedas: 50,
      precoReais: 249.0,
      popular: true,
      custoPorMoeda: 0.6225,
    ),
    CoinPackageModel(
      id: 'pack-especialista',
      nome: 'Pacote Especialista Prime',
      moedas: 750,
      bonusMoedas: 150,
      precoReais: 489.0,
      custoPorMoeda: 0.543,
    ),
    CoinPackageModel(
      id: 'pack-corporativo',
      nome: 'Pacote Escritório & Equipe',
      moedas: 1800,
      bonusMoedas: 400,
      precoReais: 990.0,
      custoPorMoeda: 0.45,
    ),
  ];

  final List<CoinTransactionModel> coinHistory = [
    CoinTransactionModel(
      id: 'tx-coin-004',
      data: '2026-11-09 11:30',
      tipo: 'desbloqueio_lead',
      quantidadeMoedas: -35,
      solicitacaoId: 'SOL-MKT-4411',
      descricao: 'Desbloqueio de contato SOL-MKT-4411 (AgroComércio)',
      saldoApos: 280,
    ),
    CoinTransactionModel(
      id: 'tx-coin-003',
      data: '2026-11-08 16:15',
      tipo: 'desbloqueio_lead',
      quantidadeMoedas: -35,
      solicitacaoId: 'SOL-MKT-4410',
      descricao: 'Desbloqueio de contato SOL-MKT-4410 (LogPrime)',
      saldoApos: 315,
    ),
    CoinTransactionModel(
      id: 'tx-coin-002',
      data: '2026-11-04 14:20',
      tipo: 'recarga',
      quantidadeMoedas: 250,
      descricao: 'Recarga via Pix Mercado Pago (Pacote Start + Bônus)',
      saldoApos: 350,
    ),
    CoinTransactionModel(
      id: 'tx-coin-001',
      data: '2026-11-01 10:00',
      tipo: 'bonus_cadastro',
      quantidadeMoedas: 100,
      descricao: 'Bônus de boas-vindas pelo credenciamento homologado',
      saldoApos: 100,
    ),
  ];

  final List<OpportunityModel> opportunities = [
    OpportunityModel(
      solicitacaoId: 'SOL-OMNI-901',
      casoEmpresarialId: 'OMNI-CASO-2026-0891',
      origemSolicitacao: 'omni_recuperacao_empresarial',
      categoria: 'contabil_tributario',
      subcategoria: 'Planejamento e Regularização Fiscal',
      especialidade: 'Transação Tributária Individual PGFN',
      titulo: 'Reestruturação de Passivo Fiscal e Adesão a Transação PGFN',
      descricaoResumida:
          'Empresa em recuperação com R\$ 2,4M em dívida ativa da União. Necessidade de elaboração de plano de amortização e protocolo de transação tributária.',
      cidade: 'Campinas',
      estado: 'SP',
      modalidade: 'remoto',
      urgencia: 'alta',
      prazoEstimadoDias: 45,
      orcamentoMin: 28000,
      orcamentoMax: 45000,
      compatibilidadeScore: 98,
      dataPublicacao: '2026-11-08',
      documentosExigidos: ['CRC Ativo', 'Experiência em Transação'],
      clienteNomeAnonimizado:
          'Indústria Metalúrgica (Região Metropolitana de Campinas)',
      clienteId: 'CLI-891',
      liberacaoFinanceira: true,
      custoMoedas: 45,
      maxProfissionaisPermitidos: 4,
      profissionaisJaDesbloquearam: 2,
      clienteTelefoneReal: '(19) 3812-4091',
      clienteWhatsappReal: '5519998124091',
      clienteEmailReal: 'diretoria.fiscal@metalurgicapaulista.com.br',
      clienteEnderecoReal:
          'Av. das Indústrias, 1420 - Distrito Industrial, Campinas/SP',
      quandoPrecisa: 'Urgente para esta semana (PGFN notificou)',
    ),
    OpportunityModel(
      solicitacaoId: 'SOL-OMNI-902',
      casoEmpresarialId: 'OMNI-CASO-2026-0891',
      origemSolicitacao: 'omni_recuperacao_empresarial',
      categoria: 'cartorario_notarial',
      subcategoria: 'Atos de Registro Imobiliário e Notarial',
      especialidade: 'Levantamento de Ônus e Averbação',
      titulo:
          'Auditoria de Matrícula Imobiliária em Cartório de Registro de Imóveis',
      descricaoResumida:
          'Regularização de certidões vintenárias e averbação de renegociação patrimonial para garantia de plano de recuperação perante o 1º Oficial.',
      cidade: 'Campinas',
      estado: 'SP',
      modalidade: 'hibrido',
      urgencia: 'media',
      prazoEstimadoDias: 20,
      orcamentoMin: 8500,
      orcamentoMax: 14000,
      compatibilidadeScore: 92,
      dataPublicacao: '2026-11-09',
      documentosExigidos: ['Habilitação Notarial', 'Certidão de Idoneidade'],
      clienteNomeAnonimizado:
          'Indústria Metalúrgica (Região Metropolitana de Campinas)',
      clienteId: 'CLI-891',
      liberacaoFinanceira: true,
      custoMoedas: 25,
      maxProfissionaisPermitidos: 3,
      profissionaisJaDesbloquearam: 1,
      clienteTelefoneReal: '(19) 3812-4092',
      clienteWhatsappReal: '5519998124092',
      clienteEmailReal: 'patrimonio@metalurgicapaulista.com.br',
      clienteEnderecoReal: 'Rua Barão de Jaguara, 700 - Centro, Campinas/SP',
      quandoPrecisa: 'Nos próximos 15 dias',
    ),
    OpportunityModel(
      solicitacaoId: 'SOL-OMNI-903',
      casoEmpresarialId: 'OMNI-CASO-2026-0891',
      origemSolicitacao: 'omni_recuperacao_empresarial',
      categoria: 'juridico',
      subcategoria: 'Direito Societário e Contratual',
      especialidade: 'Reestruturação Societária e Entrada de Investidor',
      titulo: 'Elaboração de Acordo de Acionistas e Mútuo Conversível',
      descricaoResumida:
          'Confecção de instrumentos jurídicos para aportes de capital por investidores estratégicos em suporte ao plano de soerguimento empresarial.',
      cidade: 'São Paulo',
      estado: 'SP',
      modalidade: 'remoto',
      urgencia: 'alta',
      prazoEstimadoDias: 30,
      orcamentoMin: 35000,
      orcamentoMax: 60000,
      compatibilidadeScore: 95,
      dataPublicacao: '2026-11-10',
      documentosExigidos: ['OAB Ativa', 'Atuação em M&A'],
      clienteNomeAnonimizado: 'Holding Industrial Paulista',
      clienteId: 'CLI-891',
      liberacaoFinanceira: true,
      custoMoedas: 55,
      maxProfissionaisPermitidos: 4,
      profissionaisJaDesbloquearam: 0,
      clienteTelefoneReal: '(11) 3209-8810',
      clienteWhatsappReal: '5511992098810',
      clienteEmailReal: 'juridico.societario@holding-invest.com.br',
      clienteEnderecoReal:
          'Av. Brigadeiro Faria Lima, 3477 - Itaim Bibi, São Paulo/SP',
      quandoPrecisa: 'O quanto antes (investidor aguarda minuta)',
    ),
    OpportunityModel(
      solicitacaoId: 'SOL-MKT-4410',
      origemSolicitacao: 'marketplace_publico',
      categoria: 'engenharia_arquitetura',
      subcategoria: 'Avaliação Patrimonial e Laudos',
      especialidade: 'Laudo de Avaliação de Parque Fabril',
      titulo:
          'Laudo Técnico de Avaliação Patrimonial Conforme ABNT NBR 14.653',
      descricaoResumida:
          'Necessidade de laudo pericial para reavaliação de ativos imobilizados de galpão logístico de 8.500 m² para composição de balanço.',
      cidade: 'Jundiaí',
      estado: 'SP',
      modalidade: 'presencial',
      urgencia: 'media',
      prazoEstimadoDias: 25,
      orcamentoMin: 18000,
      orcamentoMax: 28000,
      compatibilidadeScore: 87,
      dataPublicacao: '2026-11-07',
      documentosExigidos: ['CREA Ativo', 'ART'],
      clienteNomeAnonimizado: 'LogPrime Empreendimentos Logísticos',
      clienteId: 'CLI-552',
      liberacaoFinanceira: true,
      custoMoedas: 35,
      maxProfissionaisPermitidos: 3,
      profissionaisJaDesbloquearam: 1,
      clienteTelefoneReal: '(11) 4588-3310',
      clienteWhatsappReal: '5511985883310',
      clienteEmailReal: 'engenharia@logprime.com.br',
      clienteEnderecoReal:
          'Rodovia Anhanguera, Km 62 - Distrito Industrial, Jundiaí/SP',
      quandoPrecisa: 'Dentro de 2 semanas',
    ),
    OpportunityModel(
      solicitacaoId: 'SOL-MKT-4411',
      origemSolicitacao: 'solicitacao_direta',
      categoria: 'administracao_gestao',
      subcategoria: 'Gestão Financeira e Fluxo de Caixa',
      especialidade: 'Diagnóstico Operacional e Capital de Giro',
      titulo: 'Implantação de Comitê de Tesouraria e Orçamento Base Zero',
      descricaoResumida:
          'Estruturação de fluxo de caixa projetado diário de 13 semanas (13-Week Cash Flow) e política de compras para estancar sangria financeira.',
      cidade: 'Ribeirão Preto',
      estado: 'SP',
      modalidade: 'hibrido',
      urgencia: 'baixa',
      prazoEstimadoDias: 60,
      orcamentoMin: 22000,
      orcamentoMax: 38000,
      compatibilidadeScore: 91,
      dataPublicacao: '2026-11-06',
      documentosExigidos: ['CRA Ativo', 'Portfólio de Reestruturação'],
      clienteNomeAnonimizado: 'AgroComércio Centro-Oeste',
      clienteId: 'CLI-709',
      liberacaoFinanceira: true,
      custoMoedas: 30,
      maxProfissionaisPermitidos: 4,
      profissionaisJaDesbloquearam: 2,
      clienteTelefoneReal: '(16) 3600-4490',
      clienteWhatsappReal: '5516996004490',
      clienteEmailReal: 'gestao@agrocomercio-co.com.br',
      clienteEnderecoReal:
          'Av. Maurílio Biagi, 1800 - Ribeirânia, Ribeirão Preto/SP',
      quandoPrecisa: 'Para início imediato neste mês',
    ),
  ];

  final List<JobPostingModel> jobPostings = [
    JobPostingModel(
      vagaId: 'VAGA-OMNI-2026-01',
      titulo: 'Consultor Tributário & Auditor Fiscal Sênior',
      empresaNome: 'Grupo Alvarez & Associados Consultoria',
      categoria: 'contabil_tributario',
      tipoContrato: 'pj',
      remuneracaoEstimada: 'R\$ 14.000 a R\$ 18.000 / mês',
      cidade: 'São Paulo',
      estado: 'SP',
      modalidade: 'hibrido',
      descricaoAtividades:
          'Liderar projetos de transação tributária individual na PGFN, levantamento de teses tributárias e cruzamento de arquivos SPED para empresas em reestruturação.',
      requisitos: [
        'CRC ativo ou OAB',
        'Experiência em transações PGFN',
        'Domínio de SPED e EFD ICMS/IPI'
      ],
      beneficios: [
        'Bônus por êxito de até 15%',
        'Notebook corporativo',
        'Acesso a bases de jurimetria'
      ],
      dataPublicacao: '2026-11-09',
      totalCandidatos: 7,
    ),
    JobPostingModel(
      vagaId: 'VAGA-OMNI-2026-02',
      titulo: 'Perito Contábil e Financeiro Judicial',
      empresaNome: 'Câmara de Perícias e Mediação Paulista',
      categoria: 'financeiro',
      tipoContrato: 'freelancer_fixo',
      remuneracaoEstimada: 'R\$ 4.500 a R\$ 7.000 por laudo',
      cidade: 'Campinas',
      estado: 'SP',
      modalidade: 'remoto',
      descricaoAtividades:
          'Confecção de laudos periciais contábeis em ações revisionais de contratos bancários, apuração de haveres e liquidação de sentenças.',
      requisitos: [
        'Cadastro CNPC/CFC ativo',
        'Experiência em perícias cíveis e empresariais'
      ],
      beneficios: [
        'Volume recorrente de 4 a 8 laudos/mês',
        'Adiantamento de honorários'
      ],
      dataPublicacao: '2026-11-10',
      totalCandidatos: 4,
    ),
    JobPostingModel(
      vagaId: 'VAGA-OMNI-2026-03',
      titulo: 'Despachante Documentalista & Especialista em Cartórios',
      empresaNome: 'Rede Imob & Regularização Patrimonial',
      categoria: 'cartorario_notarial',
      tipoContrato: 'pj',
      remuneracaoEstimada: 'R\$ 6.500 / mês fixo + ajuda de custo',
      cidade: 'Belo Horizonte',
      estado: 'MG',
      modalidade: 'presencial',
      descricaoAtividades:
          'Atuação direta perante cartórios de registro de imóveis, tabelionatos de notas e órgãos municipais para levantamento de certidões e averbações.',
      requisitos: [
        'Registro CRDD ativo',
        'Experiência em rotinas cartorárias',
        'Veículo próprio para diligências'
      ],
      beneficios: [
        'Reembolso de KM rodado',
        'Seguro de vida',
        'Apoio jurídico especializado'
      ],
      dataPublicacao: '2026-11-08',
      totalCandidatos: 9,
    ),
    JobPostingModel(
      vagaId: 'VAGA-OMNI-2026-04',
      titulo: 'Advogado Especialista em Recuperação Judicial e M&A',
      empresaNome: 'Vasconcelos & Prado Advogados Associados',
      categoria: 'juridico',
      tipoContrato: 'associado',
      remuneracaoEstimada: 'R\$ 9.000 fixo + participação no êxito',
      cidade: 'São Paulo',
      estado: 'SP',
      modalidade: 'hibrido',
      descricaoAtividades:
          'Atuação em processos de recuperação judicial, planos de credores, assembleias e redação de contratos societários (M&A).',
      requisitos: [
        'OAB/SP ativa',
        'Pós-graduação em Direito Empresarial',
        'Mínimo de 4 anos de atuação'
      ],
      beneficios: [
        'Participação nos lucros (PLR)',
        'Estacionamento no local',
        'Plano de carreira para sócio'
      ],
      dataPublicacao: '2026-11-11',
      totalCandidatos: 12,
    ),
  ];

  final List<ProposalModel> proposals = [
    ProposalModel(
      propostaId: 'PROP-2026-102',
      solicitacaoId: 'SOL-OMNI-880',
      profissionalId: 'PRO-1001',
      profissionalNome: 'Dra. Helena Vasconcelos',
      valorHonorarios: 38000,
      despesasAdicionais: 2500,
      custosTerceiros: 1500,
      valorTotal: 42000,
      descricaoTrabalho:
          'Atuação especializada em Execução Fiscal Estadual (ICMS) perante a Procuradoria Geral do Estado com garantia de seguro-fiança e suspensão de leilão.',
      etapas: [
        ProposalStepModel(
            titulo: 'Auditoria dos autos executivos e certidões CDA',
            prazoDias: 7,
            valorProporcional: 10000),
        ProposalStepModel(
            titulo: 'Petição de Exceção de Pré-Executividade',
            prazoDias: 15,
            valorProporcional: 20000),
        ProposalStepModel(
            titulo: 'Termo de parcelamento especial e baixa de penhora',
            prazoDias: 10,
            valorProporcional: 12000),
      ],
      prazoDias: 32,
      condicoesPagamento: 'Liberação por etapas homologadas no cofre OMNI',
      documentosNecessarios: ['OAB Ativa', 'Procuração Ad Judicia'],
      dataEnvio: '2026-10-20',
      status: 'aceita',
    ),
    ProposalModel(
      propostaId: 'PROP-2026-109',
      solicitacaoId: 'SOL-OMNI-901',
      profissionalId: 'PRO-1001',
      profissionalNome: 'Dra. Helena Vasconcelos',
      valorHonorarios: 34000,
      despesasAdicionais: 2000,
      custosTerceiros: 0,
      valorTotal: 36000,
      descricaoTrabalho:
          'Elaboração de proposta para transação tributária individual PGFN da Indústria Metalúrgica Paulista.',
      etapas: [
        ProposalStepModel(
            titulo: 'Diagnóstico de Dívida Ativa da União',
            prazoDias: 10,
            valorProporcional: 12000),
        ProposalStepModel(
            titulo: 'Protocolo de Transação Individual',
            prazoDias: 20,
            valorProporcional: 24000),
      ],
      prazoDias: 30,
      condicoesPagamento: 'Custódia Mercado Pago OMNI',
      documentosNecessarios: ['CRC/OAB'],
      dataEnvio: '2026-11-09',
      status: 'em_negociacao',
    ),
  ];

  final List<ServiceOrderModel> orders = [
    ServiceOrderModel(
      ordemServicoId: 'OS-OMNI-2026-0041',
      solicitacaoId: 'SOL-OMNI-880',
      casoEmpresarialId: 'OMNI-CASO-2026-0810',
      propostaId: 'PROP-2026-102',
      clienteNome: 'Varejo Nacional de Calçados Ltda',
      profissionalNome: 'Dra. Helena Vasconcelos (Advocacia Empresarial)',
      categoria: 'juridico',
      tituloServico:
          'Defesa e Renegociação de Execuções Fiscais Estaduais (ICMS)',
      valorContratado: 42000,
      taxaPlataforma: 4200,
      valorLiquido: 37800,
      status: 'em_execucao',
      dataContratacao: '2026-10-22',
      prazoFinal: '2026-12-10',
      etapas: [
        ServiceOrderMilestone(
          id: 'etapa-1',
          titulo: 'Auditoria dos autos executivos e certidões CDA',
          concluida: true,
          dataConclusao: '2026-10-28',
        ),
        ServiceOrderMilestone(
          id: 'etapa-2',
          titulo:
              'Petição de Exceção de Pré-Executividade com garantia de seguro-fiança',
          concluida: true,
          dataConclusao: '2026-11-05',
        ),
        ServiceOrderMilestone(
          id: 'etapa-3',
          titulo: 'Reunião de conciliação com a Procuradoria Geral do Estado',
          concluida: false,
        ),
        ServiceOrderMilestone(
          id: 'etapa-4',
          titulo:
              'Formalização de termo de parcelamento especial e baixa de gravames',
          concluida: false,
        ),
      ],
      entregaveis: [
        ServiceOrderDeliverable(
          id: 'del-1',
          titulo: 'Relatório Preliminar de Diagnóstico das CDAs.pdf',
          arquivoNome: 'diagnostico_cda_varejo_paulista.pdf',
          tamanhoKb: 1420,
          dataUpload: '2026-10-28',
          status: 'aprovado',
        ),
        ServiceOrderDeliverable(
          id: 'del-2',
          titulo: 'Protocolo da Petição de Defesa Judicial.pdf',
          arquivoNome: 'protocolo_epe_processo_1029384.pdf',
          tamanhoKb: 890,
          dataUpload: '2026-11-05',
          status: 'aprovado',
        ),
      ],
      linhaTempo: [
        ServiceOrderTimelineEvent(
          data: '2026-10-22 14:30',
          evento:
              'Ordem de Serviço contratada com garantia de custódia Mercado Pago',
          usuario: 'Sistema OMNI',
        ),
        ServiceOrderTimelineEvent(
          data: '2026-10-28 17:15',
          evento: 'Etapa 1 concluída e entregável validado pelo cliente',
          usuario: 'Dra. Helena Vasconcelos',
        ),
        ServiceOrderTimelineEvent(
          data: '2026-11-05 11:20',
          evento: 'Etapa 2 protocolada e anexada ao cofre seguro',
          usuario: 'Dra. Helena Vasconcelos',
        ),
      ],
    ),
    ServiceOrderModel(
      ordemServicoId: 'OS-OMNI-2026-0038',
      solicitacaoId: 'SOL-OMNI-865',
      casoEmpresarialId: 'OMNI-CASO-2026-0792',
      propostaId: 'PROP-2026-098',
      clienteNome: 'Hospital Samaritano & Clínica Especializada',
      profissionalNome: 'Silva & Associados Perícias Contábeis',
      categoria: 'contabil_tributario',
      tituloServico: 'Laudo Pericial de Compensação de Créditos de PIS/COFINS',
      valorContratado: 28500,
      taxaPlataforma: 2850,
      valorLiquido: 25650,
      status: 'aguardando_aprovacao',
      dataContratacao: '2026-10-15',
      prazoFinal: '2026-11-12',
      etapas: [
        ServiceOrderMilestone(
          id: 'et-1',
          titulo: 'Cruzamento de arquivos SPED Fiscal e EFD Contribuições',
          concluida: true,
          dataConclusao: '2026-10-25',
        ),
        ServiceOrderMilestone(
          id: 'et-2',
          titulo: 'Memória de cálculo dos créditos não prescritos (5 anos)',
          concluida: true,
          dataConclusao: '2026-11-02',
        ),
        ServiceOrderMilestone(
          id: 'et-3',
          titulo: 'Emissão e assinatura de Laudo Pericial Contábil',
          concluida: true,
          dataConclusao: '2026-11-10',
        ),
      ],
      entregaveis: [
        ServiceOrderDeliverable(
          id: 'del-3',
          titulo: 'Laudo Pericial Contábil Tributário Homologado.pdf',
          arquivoNome: 'laudo_tributario_pis_cofins_assinado.pdf',
          tamanhoKb: 4890,
          dataUpload: '2026-11-10',
          status: 'em_analise',
        ),
      ],
      linhaTempo: [
        ServiceOrderTimelineEvent(
          data: '2026-10-15 09:00',
          evento: 'Ordem de serviço formalizada via marketplace',
          usuario: 'Sistema OMNI',
        ),
        ServiceOrderTimelineEvent(
          data: '2026-11-10 16:40',
          evento:
              'Laudo final anexado pelo perito. Aguardando validação do cliente.',
          usuario: 'Silva & Associados',
        ),
      ],
    ),
  ];

  final List<VaultDocumentModel> documents = [
    VaultDocumentModel(
      documentoId: 'DOC-OMNI-001',
      titulo: 'Carteira Profissional OAB/SP 384.992',
      tipo: 'registro_classe',
      nomeArquivo: 'oab_helena_vasconcelos_autenticada.pdf',
      tamanhoKb: 750,
      dataUpload: '2026-09-12',
      statusVerificacao: 'aprovado',
      hashIntegridade: 'e3b0c44298fc1c149afbf4c8996fb92427ae41e4',
    ),
    VaultDocumentModel(
      documentoId: 'DOC-OMNI-002',
      titulo: 'Certidão de Regularidade Profissional CRC/SP',
      tipo: 'registro_classe',
      nomeArquivo: 'certidao_crc_silva_associados.pdf',
      tamanhoKb: 420,
      dataUpload: '2026-09-15',
      statusVerificacao: 'aprovado',
      hashIntegridade: 'a58b688b1f5160897d28711e58e3ea9549f05634',
    ),
    VaultDocumentModel(
      documentoId: 'DOC-OMNI-003',
      titulo: 'Certidão Negativa de Débitos Federais (PGFN)',
      tipo: 'certidao',
      nomeArquivo: 'cnd_receita_federal_atualizada.pdf',
      tamanhoKb: 310,
      dataUpload: '2026-11-01',
      statusVerificacao: 'em_analise',
      hashIntegridade: 'c679930f78df3d2e99f0f9b6b9075e5332f17042',
    ),
  ];

  final List<ChatMessageModel> messages = [
    ChatMessageModel(
      mensagemId: 'MSG-01',
      ordemServicoId: 'OS-OMNI-2026-0041',
      remetenteNome: 'Carlos Eduardo (Diretor Financeiro)',
      remetentePapel: 'cliente',
      conteudo:
          'Dra. Helena, boa tarde! Acabamos de aprovar a Etapa 1. O levantamento das CDAs ficou excepcional e já identificamos 2 execuções com vício de citação.',
      dataEnvio: '2026-10-29 10:14',
    ),
    ChatMessageModel(
      mensagemId: 'MSG-02',
      ordemServicoId: 'OS-OMNI-2026-0041',
      remetenteNome: 'Dra. Helena Vasconcelos',
      remetentePapel: 'profissional',
      conteudo:
          'Excelente notícia, Carlos! Já estou estruturando a Exceção de Pré-Executividade para suspender a penhora de faturamento de imediato.',
      dataEnvio: '2026-10-29 10:28',
    ),
    ChatMessageModel(
      mensagemId: 'MSG-03',
      ordemServicoId: 'OS-OMNI-2026-0041',
      remetenteNome: 'Dra. Helena Vasconcelos',
      remetentePapel: 'profissional',
      conteudo:
          'Acabei de anexar o protocolo da distribuição no cofre da OS. Assim que o juiz apreciar a liminar, farei nova atualização.',
      dataEnvio: '2026-11-05 11:30',
      anexoNome: 'protocolo_epe_processo_1029384.pdf',
    ),
  ];

  final List<FinancialTransactionModel> transactions = [
    FinancialTransactionModel(
      pagamentoId: 'MP-PAY-98102941',
      ordemServicoId: 'OS-OMNI-2026-0041',
      metodo: 'pix',
      valorBruto: 42000,
      taxaIntermediacao: 4200,
      valorLiquido: 37800,
      statusMercadoPago: 'approved',
      dataCriacao: '2026-10-22 14:25',
      idempotencyKey: 'idem-mp-90182-41-os',
    ),
    FinancialTransactionModel(
      pagamentoId: 'MP-PAY-98103300',
      ordemServicoId: 'OS-OMNI-2026-0038',
      metodo: 'cartao_credito',
      valorBruto: 28500,
      taxaIntermediacao: 2850,
      valorLiquido: 25650,
      statusMercadoPago: 'approved',
      dataCriacao: '2026-10-15 08:58',
      idempotencyKey: 'idem-mp-90182-38-os',
    ),
  ];

  final List<SubscriptionPlanModel> plans = [
    SubscriptionPlanModel(
      id: 'plano-gratuito',
      nome: 'Plano Inicial',
      publicoAlvo: 'Profissionais autônomos em início de atividade',
      precoMensal: 0,
      taxaComissaoPercentual: 14.5,
      recursos: [
        'Até 5 propostas/mês no marketplace',
        'Acesso a demandas públicas',
        'Recebimento via Pix e Cartão',
        'Cofre básico de documentos (100MB)',
      ],
    ),
    SubscriptionPlanModel(
      id: 'plano-profissional',
      nome: 'Plano Profissional Prime',
      publicoAlvo: 'Advogados, contadores e peritos atuantes',
      precoMensal: 189,
      taxaComissaoPercentual: 9.8,
      destaque: true,
      recursos: [
        'Até 35 propostas/mês com prioridade',
        'Fila do OMNI Recuperação Empresarial',
        'Assistente de IA para propostas',
        'Selo Profissional Verificado OMNI',
      ],
    ),
    SubscriptionPlanModel(
      id: 'plano-empresarial',
      nome: 'Plano Escritórios & Consultorias',
      publicoAlvo: 'Firmas e consultorias multidisciplinares',
      precoMensal: 499,
      taxaComissaoPercentual: 6.5,
      destaque: true,
      recursos: [
        'Propostas ilimitadas para toda equipe',
        'Encaminhamento de casos complexos',
        'Subcontas para peritos e advogados',
        'Conciliação automática Mercado Pago',
      ],
    ),
    SubscriptionPlanModel(
      id: 'plano-institucional',
      nome: 'Canal Notarial & Institucional',
      publicoAlvo: 'Cartórios e tabelionatos oficiais',
      precoMensal: 0,
      taxaComissaoPercentual: 0,
      recursos: [
        'Triagem documental dedicada',
        '0% retenção sobre emolumentos tabelados',
        'Validação de certidões com fé pública',
      ],
    ),
  ];

  final List<RecoveryCaseModel> recoveryCases = [
    RecoveryCaseModel(
      casoEmpresarialId: 'OMNI-CASO-2026-0891',
      empresaRazaoSocial: 'Indústria Metalúrgica Paulista Ltda',
      empresaCnpj: '48.912.304/0001-92',
      cidade: 'Campinas',
      estado: 'SP',
      faturamentoAnualEstimado: 18500000,
      passivoTotal: 4200000,
      dataDiagnostico: '2026-10-18',
      statusRecuperacao: 'execucao_servicos',
      areasAfetadas: [
        'Tributária / PGFN',
        'Societária / Regularização',
        'Cartório de Imóveis'
      ],
      solicitacoesGeradas: ['SOL-OMNI-901', 'SOL-OMNI-902', 'SOL-OMNI-903'],
    ),
    RecoveryCaseModel(
      casoEmpresarialId: 'OMNI-CASO-2026-1044',
      empresaRazaoSocial: 'Rede Farma Express Distribuidora S/A',
      empresaCnpj: '12.455.789/0001-33',
      cidade: 'Belo Horizonte',
      estado: 'MG',
      faturamentoAnualEstimado: 32000000,
      passivoTotal: 7800000,
      dataDiagnostico: '2026-11-02',
      statusRecuperacao: 'em_estruturacao',
      areasAfetadas: [
        'Auditoria Contábil',
        'Renegociação Bancária',
        'Mediação Trabalhista'
      ],
      solicitacoesGeradas: ['SOL-OMNI-904', 'SOL-OMNI-905'],
    ),
  ];

  // Ações de Navegação & Papel
  void setTab(String tab) {
    currentTab = tab;
    notifyListeners();
  }

  void setRole(String role) {
    currentRole = role;
    if (role == 'admin') {
      currentTab = 'admin_panel';
    } else if (role == 'cliente') {
      currentTab = 'ordens_servico';
    } else if (role == 'instituicao') {
      currentTab = 'oportunidades';
    } else {
      currentTab = 'dashboard';
    }
    notifyListeners();
  }

  // Moedas & Desbloqueio de Lead estilo GetNinjas
  bool unlockLead(String solicitacaoId, int custo) {
    if (saldoMoedas < custo) return false;
    final idx = opportunities.indexWhere((o) => o.solicitacaoId == solicitacaoId);
    if (idx == -1) return false;
    final opp = opportunities[idx];

    saldoMoedas -= custo;
    opp.profissionaisJaDesbloquearam += 1;

    coinHistory.insert(
      0,
      CoinTransactionModel(
        id: 'tx-coin-${DateTime.now().millisecondsSinceEpoch % 100000}',
        data: _nowStr(),
        tipo: 'desbloqueio_lead',
        quantidadeMoedas: -custo,
        solicitacaoId: solicitacaoId,
        descricao: 'Desbloqueio de contato $solicitacaoId (${opp.titulo})',
        saldoApos: saldoMoedas,
      ),
    );

    unlockedLeads[solicitacaoId] = UnlockedLeadModel(
      solicitacaoId: solicitacaoId,
      dataDesbloqueio: _nowStr(),
      moedasGastas: custo,
      clienteNome: opp.clienteNomeAnonimizado,
      clienteTelefone: opp.clienteTelefoneReal ?? '(11) 98844-3322',
      clienteWhatsapp: opp.clienteWhatsappReal ?? '5511988443322',
      clienteEmail:
          opp.clienteEmailReal ?? 'contato@empresa-solicitante.com.br',
      enderecoCompleto:
          opp.clienteEnderecoReal ?? '${opp.cidade}/${opp.estado}',
    );

    notifications.insert(
        0, 'Contato de $solicitacaoId desbloqueado (-$custo moedas).');
    notifyListeners();
    return true;
  }

  int requestLeadRefund(String solicitacaoId) {
    final lead = unlockedLeads[solicitacaoId];
    if (lead == null) return 0;
    final estorno = lead.moedasGastas;
    saldoMoedas += estorno;

    coinHistory.insert(
      0,
      CoinTransactionModel(
        id: 'tx-coin-${DateTime.now().millisecondsSinceEpoch % 100000}',
        data: _nowStr(),
        tipo: 'reembolso_garantia',
        quantidadeMoedas: estorno,
        solicitacaoId: solicitacaoId,
        descricao: 'Garantia Ninja OMNI: Estorno integral ($solicitacaoId)',
        saldoApos: saldoMoedas,
      ),
    );
    unlockedLeads.remove(solicitacaoId);
    notifications.insert(0, 'Garantia Ninja: +$estorno moedas estornadas.');
    notifyListeners();
    return estorno;
  }

  int buyCoinPackage(CoinPackageModel pacote, String metodo) {
    final total = pacote.totalMoedas;
    saldoMoedas += total;
    coinHistory.insert(
      0,
      CoinTransactionModel(
        id: 'tx-coin-${DateTime.now().millisecondsSinceEpoch % 100000}',
        data: _nowStr(),
        tipo: 'recarga',
        quantidadeMoedas: total,
        descricao:
            'Recarga ${pacote.nome} via ${metodo == 'pix' ? 'Pix' : 'Cartão'}',
        saldoApos: saldoMoedas,
      ),
    );
    notifications.insert(0, 'Recarga confirmada: +$total moedas na carteira.');
    notifyListeners();
    return total;
  }

  void addClientOpportunity(OpportunityModel opp) {
    opportunities.insert(0, opp);
    notifications.insert(0, 'Novo pedido publicado: ${opp.titulo}');
    currentTab = 'oportunidades';
    notifyListeners();
  }

  void applyToJob(String vagaId) {
    if (!appliedJobIds.contains(vagaId)) {
      appliedJobIds.add(vagaId);
      final idx = jobPostings.indexWhere((j) => j.vagaId == vagaId);
      if (idx != -1) jobPostings[idx].totalCandidatos += 1;
      notifications.insert(0, 'Candidatura enviada para a vaga $vagaId.');
      notifyListeners();
    }
  }

  void submitProposal(ProposalModel proposal) {
    proposals.insert(0, proposal);
    notifications.insert(0, 'Proposta ${proposal.propostaId} enviada.');
    currentTab = 'propostas';
    notifyListeners();
  }

  void sendCounterProposal(String propostaId, double novoValor, String msg) {
    final idx = proposals.indexWhere((p) => p.propostaId == propostaId);
    if (idx != -1) {
      final old = proposals[idx];
      proposals[idx] = ProposalModel(
        propostaId: old.propostaId,
        solicitacaoId: old.solicitacaoId,
        profissionalId: old.profissionalId,
        profissionalNome: old.profissionalNome,
        valorHonorarios: novoValor,
        despesasAdicionais: 0,
        custosTerceiros: 0,
        valorTotal: novoValor,
        descricaoTrabalho: '${old.descricaoTrabalho}\n\n[Contraproposta]: $msg',
        etapas: old.etapas,
        prazoDias: old.prazoDias,
        condicoesPagamento: old.condicoesPagamento,
        documentosNecessarios: old.documentosNecessarios,
        dataEnvio: old.dataEnvio,
        status: 'em_negociacao',
      );
      notifications.insert(
          0, 'Contraproposta enviada para ${old.propostaId}.');
      notifyListeners();
    }
  }

  String acceptProposal(String propostaId) {
    final idx = proposals.indexWhere((p) => p.propostaId == propostaId);
    if (idx == -1) return '';
    final prop = proposals[idx];
    prop.status = 'aceita';

    final taxa = (prop.valorTotal * commissionRate) / 100.0;
    final liquido = prop.valorTotal - taxa;
    final osId =
        'OS-OMNI-${(DateTime.now().millisecondsSinceEpoch % 9000) + 1000}';

    orders.insert(
      0,
      ServiceOrderModel(
        ordemServicoId: osId,
        solicitacaoId: prop.solicitacaoId,
        propostaId: prop.propostaId,
        clienteNome: 'Empresa Contratante Homologada',
        profissionalNome: prop.profissionalNome,
        tituloServico: 'Execução Contratual · ${prop.solicitacaoId}',
        valorContratado: prop.valorTotal,
        taxaPlataforma: taxa,
        valorLiquido: liquido,
        status: 'contratada',
        dataContratacao: _todayStr(),
        prazoFinal: '2026-12-20',
        etapas: prop.etapas
            .asMap()
            .entries
            .map((e) => ServiceOrderMilestone(
                  id: 'etapa-${e.key + 1}',
                  titulo: e.value.titulo,
                ))
            .toList(),
        entregaveis: [],
        linhaTempo: [
          ServiceOrderTimelineEvent(
            data: _nowStr(),
            evento:
                'Proposta ${prop.propostaId} aceita. OS formalizada com custódia de R\$ ${prop.valorTotal.toStringAsFixed(0)}.',
            usuario: 'Sistema OMNI',
          ),
        ],
      ),
    );
    notifications.insert(0, 'Ordem de Serviço $osId gerada com sucesso.');
    currentTab = 'ordens_servico';
    notifyListeners();
    return osId;
  }

  void rejectProposal(String propostaId) {
    final idx = proposals.indexWhere((p) => p.propostaId == propostaId);
    if (idx != -1) {
      proposals[idx].status = 'recusada';
      notifyListeners();
    }
  }

  void updateOrderStatus(String orderId, String newStatus) {
    final idx = orders.indexWhere((o) => o.ordemServicoId == orderId);
    if (idx != -1) {
      orders[idx].status = newStatus;
      orders[idx].linhaTempo.add(ServiceOrderTimelineEvent(
            data: _nowStr(),
            evento:
                "Status alterado para '${ServiceOrderModel.allStatusesLabels[newStatus] ?? newStatus}'",
            usuario: 'Operador OMNI',
          ));
      notifyListeners();
    }
  }

  void toggleMilestone(String orderId, String milestoneId) {
    final idx = orders.indexWhere((o) => o.ordemServicoId == orderId);
    if (idx == -1) return;
    final msIdx = orders[idx].etapas.indexWhere((m) => m.id == milestoneId);
    if (msIdx != -1) {
      final m = orders[idx].etapas[msIdx];
      m.concluida = !m.concluida;
      m.dataConclusao = m.concluida ? _todayStr() : null;
      orders[idx].linhaTempo.add(ServiceOrderTimelineEvent(
            data: _nowStr(),
            evento:
                "Marco '${m.titulo}' ${m.concluida ? 'concluído' : 'reaberto'}.",
            usuario: 'Dra. Helena Vasconcelos',
          ));
      notifyListeners();
    }
  }

  void uploadDeliverable(String orderId, String titulo) {
    final idx = orders.indexWhere((o) => o.ordemServicoId == orderId);
    if (idx == -1) return;
    final file = '${titulo.toLowerCase().replaceAll(' ', '_')}.pdf';
    orders[idx].entregaveis.add(ServiceOrderDeliverable(
          id: 'del-${DateTime.now().millisecondsSinceEpoch % 10000}',
          titulo: titulo,
          arquivoNome: file,
          tamanhoKb: 1850,
          dataUpload: _todayStr(),
          status: 'em_analise',
        ));
    orders[idx].status = 'aguardando_aprovacao';
    orders[idx].linhaTempo.add(ServiceOrderTimelineEvent(
          data: _nowStr(),
          evento: "Entregável '$titulo' anexado ao cofre seguro da OS.",
          usuario: 'Profissional Responsável',
        ));
    notifyListeners();
  }

  void sendChatMessage(String orderId, String conteudo, {String? anexoNome}) {
    messages.add(ChatMessageModel(
      mensagemId: 'MSG-${DateTime.now().millisecondsSinceEpoch % 100000}',
      ordemServicoId: orderId,
      remetenteNome: 'Dra. Helena Vasconcelos',
      remetentePapel: 'profissional',
      conteudo: conteudo,
      dataEnvio: _nowStr(),
      anexoNome: anexoNome,
    ));
    notifyListeners();
  }

  void openOrderChat(String orderId) {
    activeChatOrderId = orderId;
    currentTab = 'chat';
    notifyListeners();
  }

  void simulatePixPayment(String orderId, double valor) {
    final taxa = (valor * commissionRate) / 100.0;
    transactions.insert(
      0,
      FinancialTransactionModel(
        pagamentoId: 'MP-PIX-${DateTime.now().millisecondsSinceEpoch % 999999}',
        ordemServicoId: orderId,
        metodo: 'pix',
        valorBruto: valor,
        taxaIntermediacao: taxa,
        valorLiquido: valor - taxa,
        statusMercadoPago: 'approved',
        dataCriacao: _nowStr(),
        idempotencyKey: 'idem-pix-${DateTime.now().millisecondsSinceEpoch}',
      ),
    );
    notifyListeners();
  }

  void selectPlan(String planId) {
    selectedPlanId = planId;
    notifyListeners();
  }

  void uploadVaultDocument(String titulo, String tipo) {
    documents.insert(
      0,
      VaultDocumentModel(
        documentoId:
            'DOC-OMNI-${(DateTime.now().millisecondsSinceEpoch % 900) + 100}',
        titulo: titulo,
        tipo: tipo,
        nomeArquivo: '${titulo.toLowerCase().replaceAll(' ', '_')}.pdf',
        tamanhoKb: 920,
        dataUpload: _todayStr(),
        statusVerificacao: 'em_analise',
        hashIntegridade: '9f86d081884c7d659a2feaa0c55ad015a3bf4f1b',
      ),
    );
    notifyListeners();
  }

  void moderateDocument(String docId, String status) {
    final idx = documents.indexWhere((d) => d.documentoId == docId);
    if (idx != -1) {
      documents[idx].statusVerificacao = status;
      notifyListeners();
    }
  }

  void updateCommissionRate(double newRate) {
    commissionRate = newRate;
    notifyListeners();
  }

  void addCatalogCategory(String nome, String slug, int especialidades) {
    catalogCategories.add(AdminCategoryItem(
      nome: nome,
      slug: slug,
      especialidades: especialidades,
    ));
    notifyListeners();
  }

  String dispatchNewRecoveryCase() {
    final suffix = (DateTime.now().millisecondsSinceEpoch % 900) + 100;
    final casoId = 'OMNI-CASO-2026-$suffix';
    final sol1 = 'SOL-OMNI-${suffix}1';
    final sol2 = 'SOL-OMNI-${suffix}2';

    recoveryCases.insert(
      0,
      RecoveryCaseModel(
        casoEmpresarialId: casoId,
        empresaRazaoSocial: 'Comércio e Logística Sudeste S/A',
        empresaCnpj: '31.882.109/0001-44',
        cidade: 'Santos',
        estado: 'SP',
        faturamentoAnualEstimado: 24000000,
        passivoTotal: 5100000,
        dataDiagnostico: _todayStr(),
        statusRecuperacao: 'execucao_servicos',
        areasAfetadas: [
          'Passivo Fiscal ICMS/PGFN',
          'Certidão de Registro de Imóveis'
        ],
        solicitacoesGeradas: [sol1, sol2],
      ),
    );

    opportunities.insertAll(0, [
      OpportunityModel(
        solicitacaoId: sol1,
        casoEmpresarialId: casoId,
        origemSolicitacao: 'omni_recuperacao_empresarial',
        categoria: 'contabil_tributario',
        subcategoria: 'Recuperação Fiscal & Parcelamentos',
        especialidade: 'Defesa Tributária de ICMS e Transação Federal',
        titulo: 'Defesa e Reestruturação de Passivo de ICMS (Porto de Santos)',
        descricaoResumida:
            'Regularização fiscal de débitos estaduais e suspensão de exigibilidade para liberação de certidões portuárias.',
        cidade: 'Santos',
        estado: 'SP',
        modalidade: 'remoto',
        urgencia: 'imediata',
        prazoEstimadoDias: 30,
        orcamentoMin: 32000,
        orcamentoMax: 48000,
        compatibilidadeScore: 97,
        dataPublicacao: _todayStr(),
        documentosExigidos: ['CRC Ativo', 'OAB Tributária'],
        clienteNomeAnonimizado: 'Operador Logístico Portuário',
        clienteId: 'CLI-$suffix',
        liberacaoFinanceira: true,
        custoMoedas: 60,
        maxProfissionaisPermitidos: 4,
        profissionaisJaDesbloquearam: 0,
        clienteTelefoneReal: '(13) 3219-9400',
        clienteWhatsappReal: '5513997814400',
        clienteEmailReal: 'diretoria.fiscal@portolog-santos.com.br',
        clienteEnderecoReal:
            'Av. Cândido Gaffrée, s/n - Docas do Porto, Santos/SP',
        quandoPrecisa: 'Imediatamente (urgente)',
      ),
      OpportunityModel(
        solicitacaoId: sol2,
        casoEmpresarialId: casoId,
        origemSolicitacao: 'omni_recuperacao_empresarial',
        categoria: 'cartorario_notarial',
        subcategoria: 'Atos Notariais e Imobiliários',
        especialidade: 'Averbação e Desoneração de Hipoteca Imobiliária',
        titulo: 'Baixa de Gravames em Cartório de Registro de Imóveis',
        descricaoResumida:
            'Instrução documental perante o Oficial de Registro de Imóveis para levantamento de penhoras superadas.',
        cidade: 'Santos',
        estado: 'SP',
        modalidade: 'hibrido',
        urgencia: 'alta',
        prazoEstimadoDias: 15,
        orcamentoMin: 9500,
        orcamentoMax: 15000,
        compatibilidadeScore: 94,
        dataPublicacao: _todayStr(),
        documentosExigidos: ['Habilitação Cartorial / Notarial'],
        clienteNomeAnonimizado: 'Operador Logístico Portuário',
        clienteId: 'CLI-$suffix',
        liberacaoFinanceira: true,
        custoMoedas: 40,
        maxProfissionaisPermitidos: 4,
        profissionaisJaDesbloquearam: 1,
        clienteTelefoneReal: '(13) 3219-9400',
        clienteWhatsappReal: '5513997814400',
        clienteEmailReal: 'juridico@portolog-santos.com.br',
        clienteEnderecoReal:
            'Av. Cândido Gaffrée, s/n - Docas do Porto, Santos/SP',
        quandoPrecisa: 'Nos próximos 15 dias',
      ),
    ]);

    notifications.insert(
        0, 'Caso $casoId integrado com 2 novas demandas no marketplace.');
    notifyListeners();
    return casoId;
  }

  String _todayStr() {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }

  String _nowStr() {
    final now = DateTime.now();
    return '${_todayStr()} ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
  }
}
